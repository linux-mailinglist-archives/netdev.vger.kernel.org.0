Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59279156A93
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 14:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgBINQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 08:16:48 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36065 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgBINQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 08:16:48 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so2401738pgu.3
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 05:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OLvbwlDpjjz4aDr8aF7WDTxQP+Bb8OFKd2oEqb6N6wI=;
        b=LLKp9DbxmpoG56Y3rfRlZSuDg+4JYrdoRSiaKtxTzeUymDsz2OORa3/KXJTvD73mN9
         BoupfzCjYqzxMtJLOVTCMRz4LZWZNUyWtm3Yd0Fl6Rn1tzytV7lOx24+qB5k3/zvjad4
         utbfWIzdvG2Mpml5WU2MVf96yxID47F5x3neXJ5EzH/TxpVKS/ky3spTV+NnoUL30nM8
         gvg8mosKNkm7wtSatfo++pFALBXE/2IAKizk0A7FR8EK/28zeafsoAf9VzvJyVAPDQYi
         HOFreGrrHlZDBZ0SxFVWMvHDBKA6BpTT7LD7D/rDaJhxAcaOrvIUdvBckfHtCTgo27w8
         7cZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OLvbwlDpjjz4aDr8aF7WDTxQP+Bb8OFKd2oEqb6N6wI=;
        b=I5kHn00cFGEkUgDLm3d3E9QiVEQYBKegm7/ceZiGGMcxeM4XjzRXpgF3sC8wXXPYcd
         RjVi+d8YZesFGetzC9XlvQM/ryPhNJH7yuxkamO0AwE1H/Ud11FW2gd7fwkjVE57xiBL
         MXiIJ1ZJiklP+k0YGsct5pwRcebpllHbv9B65ZbxlGnd7HZQm9rM7EKqt3sOWtBtcJIS
         Q//OqL8uH3OvvrfBglrWXzPl6aet0C5vM+z7b4FhAsv9rlSDoftDc2PsYk4ZZ3U6o5aQ
         PD3Ku64tJXIiI0Fh1FItRepwNR77FjSPcx8jg7nV6BCF5HzmF5ejxX4qk3xXSsD68Ic3
         htxg==
X-Gm-Message-State: APjAAAUOKltjJMW0HDG0Tj4dPlrMfVF1dbTODyGg67asXMZOTEMvTIag
        FScpZL3a2xGiOTdLJmGTE0Bhi0F5Jkg=
X-Google-Smtp-Source: APXvYqwFCIc0GqqOKXZO0cgWH8P4mRqiCgrjhkUO6u6ndgcauVd5V+XyOvLAy2JV/X0hY7b4gr1Wvw==
X-Received: by 2002:aa7:9d87:: with SMTP id f7mr8399651pfq.138.1581254206113;
        Sun, 09 Feb 2020 05:16:46 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t63sm9289172pfb.70.2020.02.09.05.16.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Feb 2020 05:16:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Trent Jaeger <tjaeger@cse.psu.edu>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH ipsec] xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire
Date:   Sun,  9 Feb 2020 21:16:38 +0800
Message-Id: <3745867d50c4527853579f09b243acf3d8b5b850.1581254198.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without doing verify_sec_ctx_len() check in xfrm_add_acquire(), it may be
out-of-bounds to access uctx->ctx_str with uctx->ctx_len, as noticed by
syz:

  BUG: KASAN: slab-out-of-bounds in selinux_xfrm_alloc_user+0x237/0x430
  Read of size 768 at addr ffff8880123be9b4 by task syz-executor.1/11650

  Call Trace:
   dump_stack+0xe8/0x16e
   print_address_description.cold.3+0x9/0x23b
   kasan_report.cold.4+0x64/0x95
   memcpy+0x1f/0x50
   selinux_xfrm_alloc_user+0x237/0x430
   security_xfrm_policy_alloc+0x5c/0xb0
   xfrm_policy_construct+0x2b1/0x650
   xfrm_add_acquire+0x21d/0xa10
   xfrm_user_rcv_msg+0x431/0x6f0
   netlink_rcv_skb+0x15a/0x410
   xfrm_netlink_rcv+0x6d/0x90
   netlink_unicast+0x50e/0x6a0
   netlink_sendmsg+0x8ae/0xd40
   sock_sendmsg+0x133/0x170
   ___sys_sendmsg+0x834/0x9a0
   __sys_sendmsg+0x100/0x1e0
   do_syscall_64+0xe5/0x660
   entry_SYSCALL_64_after_hwframe+0x6a/0xdf

So fix it by adding the missing verify_sec_ctx_len check there.

Fixes: 980ebd25794f ("[IPSEC]: Sync series - acquire insert")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 38ff02d..e6cfaa6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2276,6 +2276,9 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(&ua->policy);
 	if (err)
 		goto free_state;
+	err = verify_sec_ctx_len(attrs);
+	if (err)
+		goto free_state;
 
 	/*   build an XP */
 	xp = xfrm_policy_construct(net, &ua->policy, attrs, &err);
-- 
2.1.0

