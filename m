Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBFA4714AF
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 17:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhLKQV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 11:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhLKQVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 11:21:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC72C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 08:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 513ADB807E7
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 16:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F9C004DD;
        Sat, 11 Dec 2021 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639239712;
        bh=hSdXb71B7AsIeLEKioI4zkM+TB40dhFgbqMI/PNSlCc=;
        h=From:To:Cc:Subject:Date:From;
        b=uIhr9xYfbU3cyQ6xVnf1b/fFf0EFiECMRuG8SFsP7VaeHI0aDPiXaTO+7P+ic1tRC
         wf9f8J1WArWyRlcRg5ldns5bBMDkjN11QlAtF79S1M094hCPFheeLAzl8GrH6lfiP2
         790Vmtg5rNDBn02Kmp6NfV0fwUsAJmLpLRdW684b5Kg9eLfK3B8I1wfp/yC8qnXzB8
         aF+Y+RhkNg+7HeNbV/FDh/CKZEDmBFAl3J1PqIimfJJ8+yj9MDj1kdcz41MyjLEWOI
         9wPAz7VBCFao4sTzHWw5H85Xmb3N77oC3Cezc4ojLiCPD/hYyw4YG3m7ePja4QN8/M
         l0u+S7I4WS2Sg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        Thomas Graf <tgraf@suug.ch>
Subject: [PATCH net] ipv4: Check attribute length for RTA_GATEWAY
Date:   Sat, 11 Dec 2021 09:21:48 -0700
Message-Id: <20211211162148.74404-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported uninit-value:
============================================================
  BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80
  net/ipv4/fib_semantics.c:708
   fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
   fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
   fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
   inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886

Add length checking before using the attribute.

Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
---
I do not have KMSAN setup, so this is based on a code analysis. Before
4e902c57417c fib_get_attr32 was checking the attribute length; the
switch to nla_get_u32 does not.

 net/ipv4/fib_semantics.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3cad543dc747..930843ba3b17 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -704,6 +704,10 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 				return -EINVAL;
 			}
 			if (nla) {
+				if (nla_len(nla) < sizeof(__be32)) {
+					NL_SET_ERR_MSG(extack, "Invalid IPv4 address in RTA_GATEWAY");
+					return -EINVAL;
+				}
 				fib_cfg.fc_gw4 = nla_get_in_addr(nla);
 				if (fib_cfg.fc_gw4)
 					fib_cfg.fc_gw_family = AF_INET;
-- 
2.24.3 (Apple Git-128)

