Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15B6632C21
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKUS3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiKUS3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:29:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4AFD06EB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:29:16 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id o142-20020a257394000000b006eae582c285so4822882ybc.12
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EpRKKSjGU4jU5Fg7oLYgcrsizQF6B4l3aKjhPZhJTYQ=;
        b=WGyPIRvE7xm89yZZC0yh7Y/evxJvHEVZ6kEII7KWNOY7r3r2gWDfaerXYm1jwJ68jn
         lA4IESJ9ahupM3UT4DYXtfNk5qudY+GL+nWYTk68EcR675T9JZ1uqNfcOrmw+EOuPb+7
         r4IobcByfs5zDRlp1t5/AO++HaxGuq3MW1xpPj33EdveELYOrd3DvLFsg1K9PstXV4pf
         CHqFF+1O3Nw7K91kLY55gNMj2CmLG4KYG382goF5EqXc+SOyI6cKaIog2nEFdBQhX/yd
         M0mcUwv+DjOBBUjzqFwJ2rwg5rhXMJUkSWp11ozbNKVQkI+cijCOYqQISeeCrVr/1XPV
         8G4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EpRKKSjGU4jU5Fg7oLYgcrsizQF6B4l3aKjhPZhJTYQ=;
        b=5GgSawI+gdIxJ4/7QcRzvsdKty9y8fcGRdnekLmeJvBi2mdJIflucsSgxFmdPRSnRF
         Eswhl+pxAtNAeUUCCiYqT8ETM3di58JzdoZVADnEqApDN62WNTFZykOBMDMv6eQVk7fR
         O6rnogopMedXRhsTeBOAGU7ePlH+F9YO/08WayYTE99ykinuABkPWnt6G59j9MLtZ8cB
         Xl0TVi0Tx4qDrYVz+5szREzXTvTnqllMxV6GceP1u38LD6uCt1Z32Fm4jDzQaUYUhox3
         3QXBRTp0XK1Q8uo+b7QZ0v4VRyTnX5R1CA4gZQAAqsRyxXPgw2HwpmC7Eexalu+8tulH
         +aTQ==
X-Gm-Message-State: ANoB5pk8hrHvi1FDh4yLUOy570xnV5YNINxRWUkVKV0iePaWzda+KS8y
        bTEEiMYZ99KJ5t7BHcx8fzljGVqe7kYNiOZOOFShMejpeqv/dQTa402v/7G2u3rUA1LZq1U2phk
        tXmJe4UmSqjNfdvEaHNt1U8JnnMkAHu5PFNqcTFENKprpQ+WIGtZZ3Q==
X-Google-Smtp-Source: AA0mqf6ndnxDk4mb2nv00gdQZTM/qoTHu4mqJPKEzXtmHvNAnQr6dyOZC4fxSojVnefOxuNCqOXyUEQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:cf42:0:b0:6dd:cb46:84f1 with SMTP id
 f63-20020a25cf42000000b006ddcb4684f1mr2617387ybg.159.1669055354696; Mon, 21
 Nov 2022 10:29:14 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:29:13 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121182913.2166006-1-sdf@google.com>
Subject: [PATCH net-next] ppp: associate skb with a device at tx
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        syzbot+41cab52ab62ee99ed24a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller triggered flow dissector warning with the following:

r0 = openat$ppp(0xffffffffffffff9c, &(0x7f0000000000), 0xc0802, 0x0)
ioctl$PPPIOCNEWUNIT(r0, 0xc004743e, &(0x7f00000000c0))
ioctl$PPPIOCSACTIVE(r0, 0x40107446, &(0x7f0000000240)={0x2, &(0x7f0000000180)=[{0x20, 0x0, 0x0, 0xfffff034}, {0x6}]})
pwritev(r0, &(0x7f0000000040)=[{&(0x7f0000000140)='\x00!', 0x2}], 0x1, 0x0, 0x0)

[    9.485814] WARNING: CPU: 3 PID: 329 at net/core/flow_dissector.c:1016 __skb_flow_dissect+0x1ee0/0x1fa0
[    9.485929]  skb_get_poff+0x53/0xa0
[    9.485937]  bpf_skb_get_pay_offset+0xe/0x20
[    9.485944]  ? ppp_send_frame+0xc2/0x5b0
[    9.485949]  ? _raw_spin_unlock_irqrestore+0x40/0x60
[    9.485958]  ? __ppp_xmit_process+0x7a/0xe0
[    9.485968]  ? ppp_xmit_process+0x5b/0xb0
[    9.485974]  ? ppp_write+0x12a/0x190
[    9.485981]  ? do_iter_write+0x18e/0x2d0
[    9.485987]  ? __import_iovec+0x30/0x130
[    9.485997]  ? do_pwritev+0x1b6/0x240
[    9.486016]  ? trace_hardirqs_on+0x47/0x50
[    9.486023]  ? __x64_sys_pwritev+0x24/0x30
[    9.486026]  ? do_syscall_64+0x3d/0x80
[    9.486031]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd

Flow dissector tries to find skb net namespace either via device
or via socket. Neigher is set in ppp_send_frame, so let's manually
use ppp->dev.

Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
Reported-by: syzbot+41cab52ab62ee99ed24a@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ppp/ppp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 9206c660a72e..d4c821c8cf57 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1743,6 +1743,8 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	int len;
 	unsigned char *cp;
 
+	skb->dev = ppp->dev;
+
 	if (proto < 0x8000) {
 #ifdef CONFIG_PPP_FILTER
 		/* check if we should pass this packet */
-- 
2.38.1.584.g0f3c55d4c2-goog

