Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3583298626
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 05:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421045AbgJZESk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 00:18:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33789 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420945AbgJZESh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 00:18:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id j18so5503933pfa.0
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 21:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vC3xozK2wZN6iUGIbKodyxCftG+54UZ6I8VNlV5QpNE=;
        b=OTt1gOkNUsoKyD0ZfZZHAvJ/p8nPrK5Nqg9yG9Mg/Bvp2tT7N9oxVrXfi2CAD3x0A4
         bpqCH5RdviQyO/PRZqmbeVENOOERtki2gfoeXFMF0wwuGTKLkpJljrFGZwAV817YH2Wy
         WmfttLYTwWwApFvjDR6hokwnJpvJ5km/EKleg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vC3xozK2wZN6iUGIbKodyxCftG+54UZ6I8VNlV5QpNE=;
        b=g6w0JRR/qfkUsqL66DePBsCYNnkRqd/cpx1Y16Jvk9uoI8LXoQEVonrktFtwkFJU3c
         htMhPSKn1bHey91ZpzFlbKOt0DBj4fLcNoVxnln49Kby2By4lVMW/Wjzlr5D/Euir/jc
         XfWlSdz7+yhZs1Pa/fVdx8cHBeaQwVUoPRhMU7J4jRB6zs4xzEZ2MbsKvd7xY55lLzug
         B29/e2Pewg2mrx87hjQiiB7yermpbTr0vdYJE5g+saa23SwUOF3FpxIphxqQwoJ6+WEa
         TkRrdmDGSxoBsp3s67FiSrG8doZIgKDuiZ2FJrKkYc4nnC+LvC0dzau8v2IHLnqqEU8M
         wJyA==
X-Gm-Message-State: AOAM532sMAFGfRbPNIdwiDRt3TlzN2K/9AOVP6+P7b1S9FDxUzLvVHvd
        cLk9C5i2gkl0mh/1Onc77mWftyFBndaDeg==
X-Google-Smtp-Source: ABdhPJyKVoI+AEgt8ExLABJ0ofythjszofAn1ICSxSQD2Iv7ggsSOQhpvGhWQyCWrCoqn/4o/+ZYVg==
X-Received: by 2002:a63:9508:: with SMTP id p8mr14376742pgd.189.1603685916043;
        Sun, 25 Oct 2020 21:18:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 10sm11505835pjt.50.2020.10.25.21.18.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Oct 2020 21:18:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, gospo@broadcom.com
Subject: [PATCH net 4/5] bnxt_en: Check abort error state in bnxt_open_nic().
Date:   Mon, 26 Oct 2020 00:18:20 -0400
Message-Id: <1603685901-17917-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603685901-17917-1-git-send-email-michael.chan@broadcom.com>
References: <1603685901-17917-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000643e6105b28b39d7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000643e6105b28b39d7

bnxt_open_nic() is called during configuration changes that require
the NIC to be closed and then opened.  This call is protected by
rtnl_lock.  Firmware reset can be happening at the same time.  Only
critical portions of the entire firmware reset sequence are protected
by the rtnl_lock.  It is possible that bnxt_open_nic() can be called
when the firmware reset sequence is aborting.  In that case,
bnxt_open_nic() needs to check if the ABORT_ERR flag is set and
abort if it is.  The configuration change that resulted in the
bnxt_open_nic() call will fail but the NIC will be brought to a
consistent IF_DOWN state.

Without this patch, if bnxt_open_nic() were to continue in this error
state, it may crash like this:

[ 1648.659736] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1648.659768] IP: [<ffffffffc01e9b3a>] bnxt_alloc_mem+0x50a/0x1140 [bnxt_en]
[ 1648.659796] PGD 101e1b3067 PUD 101e1b2067 PMD 0
[ 1648.659813] Oops: 0000 [#1] SMP
[ 1648.659825] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter sunrpc dell_smbios dell_wmi_descriptor dcdbas amd64_edac_mod edac_mce_amd kvm_amd kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper vfat cryptd fat pcspkr ipmi_ssif sg k10temp i2c_piix4 wmi ipmi_si ipmi_devintf ipmi_msghandler tpm_crb acpi_power_meter sch_fq_codel ip_tables xfs libcrc32c sd_mod crc_t10dif crct10dif_generic mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci drm libahci megaraid_sas crct10dif_pclmul crct10dif_common
[ 1648.660063]  tg3 libata crc32c_intel bnxt_en(OE) drm_panel_orientation_quirks devlink ptp pps_core dm_mirror dm_region_hash dm_log dm_mod fuse
[ 1648.660105] CPU: 13 PID: 3867 Comm: ethtool Kdump: loaded Tainted: G           OE  ------------   3.10.0-1152.el7.x86_64 #1
[ 1648.660911] Hardware name: Dell Inc. PowerEdge R7515/0R4CNN, BIOS 1.2.14 01/28/2020
[ 1648.661662] task: ffff94e64cbc9080 ti: ffff94f55df1c000 task.ti: ffff94f55df1c000
[ 1648.662409] RIP: 0010:[<ffffffffc01e9b3a>]  [<ffffffffc01e9b3a>] bnxt_alloc_mem+0x50a/0x1140 [bnxt_en]
[ 1648.663171] RSP: 0018:ffff94f55df1fba8  EFLAGS: 00010202
[ 1648.663927] RAX: 0000000000000000 RBX: ffff94e6827e0000 RCX: 0000000000000000
[ 1648.664684] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff94e6827e08c0
[ 1648.665433] RBP: ffff94f55df1fc20 R08: 00000000000001ff R09: 0000000000000008
[ 1648.666184] R10: 0000000000000d53 R11: ffff94f55df1f7ce R12: ffff94e6827e08c0
[ 1648.666940] R13: ffff94e6827e08c0 R14: ffff94e6827e08c0 R15: ffffffffb9115e40
[ 1648.667695] FS:  00007f8aadba5740(0000) GS:ffff94f57eb40000(0000) knlGS:0000000000000000
[ 1648.668447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1648.669202] CR2: 0000000000000000 CR3: 0000001022772000 CR4: 0000000000340fe0
[ 1648.669966] Call Trace:
[ 1648.670730]  [<ffffffffc01f1d5d>] ? bnxt_need_reserve_rings+0x9d/0x170 [bnxt_en]
[ 1648.671496]  [<ffffffffc01fa7ea>] __bnxt_open_nic+0x8a/0x9a0 [bnxt_en]
[ 1648.672263]  [<ffffffffc01f7479>] ? bnxt_close_nic+0x59/0x1b0 [bnxt_en]
[ 1648.673031]  [<ffffffffc01fb11b>] bnxt_open_nic+0x1b/0x50 [bnxt_en]
[ 1648.673793]  [<ffffffffc020037c>] bnxt_set_ringparam+0x6c/0xa0 [bnxt_en]
[ 1648.674550]  [<ffffffffb8a5f564>] dev_ethtool+0x1334/0x21a0
[ 1648.675306]  [<ffffffffb8a719ff>] dev_ioctl+0x1ef/0x5f0
[ 1648.676061]  [<ffffffffb8a324bd>] sock_do_ioctl+0x4d/0x60
[ 1648.676810]  [<ffffffffb8a326bb>] sock_ioctl+0x1eb/0x2d0
[ 1648.677548]  [<ffffffffb8663230>] do_vfs_ioctl+0x3a0/0x5b0
[ 1648.678282]  [<ffffffffb8b8e678>] ? __do_page_fault+0x238/0x500
[ 1648.679016]  [<ffffffffb86634e1>] SyS_ioctl+0xa1/0xc0
[ 1648.679745]  [<ffffffffb8b93f92>] system_call_fastpath+0x25/0x2a
[ 1648.680461] Code: 9e 60 01 00 00 0f 1f 40 00 45 8b 8e 48 01 00 00 31 c9 45 85 c9 0f 8e 73 01 00 00 66 0f 1f 44 00 00 49 8b 86 a8 00 00 00 48 63 d1 <48> 8b 14 d0 48 85 d2 0f 84 46 01 00 00 41 8b 86 44 01 00 00 c7
[ 1648.681986] RIP  [<ffffffffc01e9b3a>] bnxt_alloc_mem+0x50a/0x1140 [bnxt_en]
[ 1648.682724]  RSP <ffff94f55df1fba8>
[ 1648.683451] CR2: 0000000000000000

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8012386b4a0f..0165f70dba74 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9779,7 +9779,10 @@ int bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
 
-	rc = __bnxt_open_nic(bp, irq_re_init, link_re_init);
+	if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state))
+		rc = -EIO;
+	if (!rc)
+		rc = __bnxt_open_nic(bp, irq_re_init, link_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "nic open fail (rc: %x)\n", rc);
 		dev_close(bp->dev);
-- 
2.18.1


--000000000000643e6105b28b39d7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgQDAZ8k4ev+cY
We3pCBReiIFNQ/yWAP2boXqRUdwgpAMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDI2MDQxODM2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGW2zPUex8F7zf7jyv/qKSEcTFuac8Vc
2MBf4dm+zCZqM5FDAoJ8QYwnDR72Vf4YBtCUysUW7MPbrSLZmPv6/M/L0ndECRYZvmEn/gB/1d3l
Jzk+PlkbEL7+kzfxtp+jLLPu3jd+pmhG3xml+jJYr4KAyqxx9KgNejbSyTIl5G5MoGlZwUCvAmFD
bBGFkfsSBedCS6N5chrgwfGuVK90m/cVzLUi7cCsIXjH2W/99NVNr61yBXiX6BJYgaazV03HHnNy
Xlb+tgSICEZyTGwNNSSDe5caruTKwUCNoevXn/IAb8UubisokKO7eZ0MdABh+xlejUxFe0Jwk+Ge
KAk6C14=
--000000000000643e6105b28b39d7--
