Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A10618CD9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 00:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKCXd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 19:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiKCXdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 19:33:44 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173D013D1E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 16:33:44 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id o8so2207054qvw.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 16:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MsubwvLrRKKdjq6ok8GCqHP+4Iuv6fA4iG9Wred+0yM=;
        b=Fj96E5IQwHSnHbt/tSeMVN2iGQcySdG0qTLURq9n3jP+ZHl0Zgz2Bk2FKX6N9rxRbb
         uZhWfGrFUTlITbjC6z8ErTmiWNIYcIUGBDkURXq7VB3sNQm13x4TqgjJEFAQ6S8bXJcw
         /K5BzuhNotPMNxQpkcPrAoCanpJ8guFVXlMcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MsubwvLrRKKdjq6ok8GCqHP+4Iuv6fA4iG9Wred+0yM=;
        b=1sH0OlbDkk9y7FwIt6x++RnbCbQwr4JKoi5YwkRIA4CHOJNTrY7txjfpy8bPgCH8ju
         OkBMU0k+7jFtEvgDbo/hDJmUKH6PuQYr3fDDoYRfnUo/5lvSVw0HWOz1gs8lXfSMWV1e
         78DcHxU0gHQvuCBAdKEI5Y501olTkGynTUMBVsf/7JT7oDiwqxtKvhb4mq5PhukG5YhE
         g+ghCEjm/5CaOuA5tecIwM4Rw7eku2IE4cjVwTNBNxPPK9F6/Du4WSD32Gbedo0naT11
         OtbrJHyxS45w2PYk1dOpt1pZSUy6wHWsvtls4kZRhLR9Fbq9RLLEJyQAi+lZcRoRmJBG
         GWSA==
X-Gm-Message-State: ANoB5pnVo3Bf95oKd+D5CpBjABXr/0SRI12Dhw03wh9P8inJH5eG2grB
        c0WiHBjUCbFM2Uea9u8FEGxq1w==
X-Google-Smtp-Source: AA0mqf5P+fGOBrwyvHlIAPASgAx9Uf363XreH6VySKkpI34YrYQ0tBq2kuA4Vel/WdXl9XUWrAAdCg==
X-Received: by 2002:a05:6214:d61:b0:4c1:d4e5:bdd6 with SMTP id 1-20020a0562140d6100b004c1d4e5bdd6mr183461qvs.66.1667518422890;
        Thu, 03 Nov 2022 16:33:42 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u5-20020a37ab05000000b006f8665f483fsm1662020qke.85.2022.11.03.16.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Nov 2022 16:33:42 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Subject: [PATCH net 3/4] bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()
Date:   Thu,  3 Nov 2022 19:33:26 -0400
Message-Id: <1667518407-15761-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1667518407-15761-1-git-send-email-michael.chan@broadcom.com>
References: <1667518407-15761-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000049465305ec996392"
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000049465305ec996392

During the error recovery sequence, the rtnl_lock is not held for the
entire duration and some datastructures may be freed during the sequence.
Check for the BNXT_STATE_OPEN flag instead of netif_running() to ensure
that the device is fully operational before proceeding to reconfigure
the coalescing settings.

This will fix a possible crash like this:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 10 PID: 181276 Comm: ethtool Kdump: loaded Tainted: G          IOE    --------- -  - 4.18.0-348.el8.x86_64 #1
Hardware name: Dell Inc. PowerEdge R740/0F9N89, BIOS 2.3.10 08/15/2019
RIP: 0010:bnxt_hwrm_set_coal+0x1fb/0x2a0 [bnxt_en]
Code: c2 66 83 4e 22 08 66 89 46 1c e8 10 cb 00 00 41 83 c6 01 44 39 b3 68 01 00 00 0f 8e a3 00 00 00 48 8b 93 c8 00 00 00 49 63 c6 <48> 8b 2c c2 48 8b 85 b8 02 00 00 48 85 c0 74 2e 48 8b 74 24 08 f6
RSP: 0018:ffffb11c8dcaba50 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8d168a8b0ac0 RCX: 00000000000000c5
RDX: 0000000000000000 RSI: ffff8d162f72c000 RDI: ffff8d168a8b0b28
RBP: 0000000000000000 R08: b6e1f68a12e9a7eb R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000037 R12: ffff8d168a8b109c
R13: ffff8d168a8b10aa R14: 0000000000000000 R15: ffffffffc01ac4e0
FS:  00007f3852e4c740(0000) GS:ffff8d24c0080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000041b3ee003 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ethnl_set_coalesce+0x3ce/0x4c0
 genl_family_rcv_msg_doit.isra.15+0x10f/0x150
 genl_family_rcv_msg+0xb3/0x160
 ? coalesce_fill_reply+0x480/0x480
 genl_rcv_msg+0x47/0x90
 ? genl_family_rcv_msg+0x160/0x160
 netlink_rcv_skb+0x4c/0x120
 genl_rcv+0x24/0x40
 netlink_unicast+0x196/0x230
 netlink_sendmsg+0x204/0x3d0
 sock_sendmsg+0x4c/0x50
 __sys_sendto+0xee/0x160
 ? syscall_trace_enter+0x1d3/0x2c0
 ? __audit_syscall_exit+0x249/0x2a0
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x5b/0x1a0
 entry_SYSCALL_64_after_hwframe+0x65/0xca
RIP: 0033:0x7f38524163bb

Fixes: 2151fe0830fd ("bnxt_en: Handle RESET_NOTIFY async event from firmware.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index f57e524c7e30..8cad15c458b3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -162,7 +162,7 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	}
 
 reset_coalesce:
-	if (netif_running(dev)) {
+	if (test_bit(BNXT_STATE_OPEN, &bp->state)) {
 		if (update_stats) {
 			rc = bnxt_close_nic(bp, true, false);
 			if (!rc)
-- 
2.18.1


--00000000000049465305ec996392
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIO4cKO5r0UazMa0cojZ7sYlDW8+SDoX9
3D/8PzZCLH8iMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEw
MzIzMzM0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBB9Xhxiii20KTrPd6GafNDfjLnsXJ37ckbwzuHNNm3WfCrphox
x1DpKayrLhXpF/KX+/X0hl9id9WvPfTlhZSYNbQTuz0DhvThAPHGyXnpZwwnrXs2Dt2K3fV8yIiW
BvIEXmQu+YU5T/jfAJzIgLRfDdAlUNXDTFf4bJz8yLjI7HYqETN1/EoTZFHDnaVcBk7PYM2pBR+A
acufsIdfImPWcTysWQCoUkaN3jTFja3X4NR2BIC4dFOhlMIxosak9ulFAr5j6NbvGbPb4LmzVLa0
JzSD+KsxjsY23HbQd/5bBXxxz2MlQfQTQ1uEtmTsVxSflmI0CSttC7YbWrYizTAM
--00000000000049465305ec996392--
