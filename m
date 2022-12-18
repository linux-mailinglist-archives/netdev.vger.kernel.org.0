Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17F6650224
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiLRQmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiLRQlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:41:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB889F018;
        Sun, 18 Dec 2022 08:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A2960DCC;
        Sun, 18 Dec 2022 16:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A1BC433D2;
        Sun, 18 Dec 2022 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380091;
        bh=xFDclNvplgYnbL3uJh3dyEBsxCIi4aefQA4vqwNoo4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTi9dNvhNJJEMdhaWVXcEOhu8fEj5DnuO/LQ7YsO/z4q7FZL5AUtQTwNagWiL4/IQ
         l6OY4olN1kClbdd0ckV3L1xWnRQoYkQAJ5Yvjg0biAaUubCToc89Z6Qsz5OFGN06/o
         lsNMy08Ry/+K+3/TRI9HPhgxwuXx3yGrYVJC2XqUuPUwcHbew1/C9Z2G+rdb8EmoUZ
         pl3PTMI6iNy0dgPxLnJHsYM7OZIQ0T7fV5NeL4jH+KoMdFUdrFIMhBZfYNK6pfHg28
         ujYVR091UDrXcb0K79SyFU3LEd5oRPVs2KocGEusniKFfpxzRDH37inNa5FKe56dA5
         FytxAh2CvM6Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        syzbot+41cab52ab62ee99ed24a@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 31/46] ppp: associate skb with a device at tx
Date:   Sun, 18 Dec 2022 11:12:29 -0500
Message-Id: <20221218161244.930785-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 9f225444467b98579cf28d94f4ad053460dfdb84 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 829d6ada1704..c1f11d1df4cd 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1742,6 +1742,8 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	int len;
 	unsigned char *cp;
 
+	skb->dev = ppp->dev;
+
 	if (proto < 0x8000) {
 #ifdef CONFIG_PPP_FILTER
 		/* check if we should pass this packet */
-- 
2.35.1

