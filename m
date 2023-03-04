Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C686AA7A8
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjCDCoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCDCoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:44:23 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E6125E30
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:44:22 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id y10so5106262qtj.2
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 18:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1677897861;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iSDKpx9BWeMnovTVMCEOAQylS8AdBoU6Sp5HqL6Dgsg=;
        b=I/ICm4IeNUmszZnujaOian5Z8lt/MYVpZhtheAMAyIZF7UFfiLOEAgkoDJVHWygfur
         7WVJfld9uF8M0P6bNNY2BUhPNCfgMkOeWw9azVbAdhraQJ9NYurwvzTBS9YdkZhJypPS
         M3imqEkZaAlzfVvUNqDMkuKDP/cNLzVRkfs2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677897861;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iSDKpx9BWeMnovTVMCEOAQylS8AdBoU6Sp5HqL6Dgsg=;
        b=ET5Y9/Je5NYdcTsz0Bh7l6nsSKNOLLNhGMdPaI6Qys+3eVXAccBISOpCzwLs0ICN2a
         BhzPtGoIZVDDzFDcuzIhZ8QTl/Pbsz7qQXuaYdvaT3D+fVBTqzvb7gz9itoxSV1fttJq
         4HrTkvG/iN1YFTnS16b5B+XOV+dVOpAB3sZZ1utS1vWWTpCuITyY/iaLDXh2P8oF9QXx
         tZZf7fyOYX5Q3cKi/OFr/uz9ELvirCpR6OwvBmRzWHwM/29MRG7pxMGOAoujqp1a6kVx
         bhGpEBJo0TtlavpK5g5gxkW+P+KxN+MBAr4kMarRbcEfzIxcXI6ogd/G6A8rCDGmlAAX
         mX+w==
X-Gm-Message-State: AO0yUKWRFiTXUKXrT+kK1GxxHpYN4bhHOYvssAmQc5+uIUs5pjc0WuwD
        mASGzDnFnUtaXjySCTGDB2QPWw==
X-Google-Smtp-Source: AK7set/Ja9ee60R/tnjhRqdLJz3qqaDTTMPdJU5qU81KjfE8wim0ol5JE+YFzmMzNL05nVfZFYjzqQ==
X-Received: by 2002:a05:622a:24f:b0:3b8:2c34:b9f2 with SMTP id c15-20020a05622a024f00b003b82c34b9f2mr6714031qtx.63.1677897861329;
        Fri, 03 Mar 2023 18:44:21 -0800 (PST)
Received: from localhost.attlocal.net (108-196-84-92.lightspeed.irvnca.sbcglobal.net. [108.196.84.92])
        by smtp.gmail.com with ESMTPSA id h20-20020ac846d4000000b003b64f1b1f40sm2963845qto.40.2023.03.03.18.44.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Mar 2023 18:44:20 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com,
        Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH net 2/2] bnxt_en: Fix the double free during device removal
Date:   Fri,  3 Mar 2023 18:43:58 -0800
Message-Id: <1677897838-23562-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1677897838-23562-1-git-send-email-michael.chan@broadcom.com>
References: <1677897838-23562-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000004034705f60a0a6e"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000004034705f60a0a6e

From: Selvin Xavier <selvin.xavier@broadcom.com>

Following warning reported by KASAN during driver unload

==================================================================
BUG: KASAN: double-free in bnxt_remove_one+0x103/0x200 [bnxt_en]
Free of addr ffff88814e8dd4c0 by task rmmod/17469
CPU: 47 PID: 17469 Comm: rmmod Kdump: loaded Tainted: G S                 6.2.0-rc7+ #2
Hardware name: Dell Inc. PowerEdge R740/01YM03, BIOS 2.3.10 08/15/2019
Call Trace:
 <TASK>
 dump_stack_lvl+0x33/0x46
 print_report+0x17b/0x4b3
 ? __call_rcu_common.constprop.79+0x27e/0x8c0
 ? __pfx_free_object_rcu+0x10/0x10
 ? __virt_addr_valid+0xe3/0x160
 ? bnxt_remove_one+0x103/0x200 [bnxt_en]
 kasan_report_invalid_free+0x64/0xd0
 ? bnxt_remove_one+0x103/0x200 [bnxt_en]
 ? bnxt_remove_one+0x103/0x200 [bnxt_en]
 __kasan_slab_free+0x179/0x1c0
 ? bnxt_remove_one+0x103/0x200 [bnxt_en]
 __kmem_cache_free+0x194/0x350
 bnxt_remove_one+0x103/0x200 [bnxt_en]
 pci_device_remove+0x62/0x110
 device_release_driver_internal+0xf6/0x1c0
 driver_detach+0x76/0xe0
 bus_remove_driver+0x89/0x160
 pci_unregister_driver+0x26/0x110
 ? strncpy_from_user+0x188/0x1c0
 bnxt_exit+0xc/0x24 [bnxt_en]
 __x64_sys_delete_module+0x21f/0x390
 ? __pfx___x64_sys_delete_module+0x10/0x10
 ? __pfx_mem_cgroup_handle_over_high+0x10/0x10
 ? _raw_spin_lock+0x87/0xe0
 ? __pfx__raw_spin_lock+0x10/0x10
 ? __audit_syscall_entry+0x185/0x210
 ? ktime_get_coarse_real_ts64+0x51/0x80
 ? syscall_trace_enter.isra.18+0x126/0x1a0
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7effcb6fd71b
Code: 73 01 c3 48 8b 0d 6d 17 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3d 17 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffeada270b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 00005623660e0750 RCX: 00007effcb6fd71b
RDX: 000000000000000a RSI: 0000000000000800 RDI: 00005623660e07b8
RBP: 0000000000000000 R08: 00007ffeada26031 R09: 0000000000000000
R10: 00007effcb771280 R11: 0000000000000206 R12: 00007ffeada272e0
R13: 00007ffeada28bc4 R14: 00005623660e02a0 R15: 00005623660e0750
 </TASK>

Auxiliary device structures are freed in bnxt_aux_dev_release. So avoid
calling kfree from bnxt_remove_one.

Also, set bp->edev to NULL before freeing the auxilary private structure.

Fixes: d80d88b0dfff ("bnxt_en: Add auxiliary driver support")
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 2 --
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f96d539b469c..808236dc898b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13205,8 +13205,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_free_hwrm_resources(bp);
 	bnxt_ethtool_free(bp);
 	bnxt_dcb_free(bp);
-	kfree(bp->edev);
-	bp->edev = NULL;
 	kfree(bp->ptp_cfg);
 	bp->ptp_cfg = NULL;
 	kfree(bp->fw_health);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index d4cc9c371e7b..e7b5e28ee29f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -317,9 +317,11 @@ static void bnxt_aux_dev_release(struct device *dev)
 {
 	struct bnxt_aux_priv *aux_priv =
 		container_of(dev, struct bnxt_aux_priv, aux_dev.dev);
+	struct bnxt *bp = netdev_priv(aux_priv->edev->net);
 
 	ida_free(&bnxt_aux_dev_ids, aux_priv->id);
 	kfree(aux_priv->edev->ulp_tbl);
+	bp->edev = NULL;
 	kfree(aux_priv->edev);
 	kfree(aux_priv);
 }
-- 
2.32.0


--00000000000004034705f60a0a6e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIRigcSzWSFdYe0rXVA3laYxTC776bXd
YCfLJ6GFcPxpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMw
NDAyNDQyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBYH8JUVQJ+3q5VhG6hyd0zSEV/4WFma1XcS1gFPEIvo3AVbv5S
r1JZ8PPqBbaQdoWFUSOe+0+hGiO4J8lPdIrvxvMtFg/pLNPJ6WCLC+n8fMeaDajE+nJj3EAEUHrZ
LKR2uQNC/kAsUzKNMvIN/O7WmDtvI3kAS4o2E1zAiy23D/ivafvqqgWUG2Prwt5uT1wltKEuRzL6
UPsfio1IA8nm3YXc9T3Idg7DOiCMr7VThfhFOSiesliA5LTYSltbWHWnt4+k6M9Fzt0GdwDwgOVg
Gc4hrTGbwxbo/xqNM76RUo6FXVrSqajJSLrN3jAqFnOpWyRJdPRrNn/ya/KOTAC8
--00000000000004034705f60a0a6e--
