Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD71A18DA06
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCTVNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:13:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:33226 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgCTVNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 17:13:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F12DABD7;
        Fri, 20 Mar 2020 21:13:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4BD38E0FD3; Fri, 20 Mar 2020 22:13:43 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] netlink: check for null extack in cookie helpers
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Message-Id: <20200320211343.4BD38E0FD3@unicorn.suse.cz>
Date:   Fri, 20 Mar 2020 22:13:43 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike NL_SET_ERR_* macros, nl_set_extack_cookie_u64() and
nl_set_extack_cookie_u32() helpers do not check extack argument for null
and neither do their callers, as syzbot recently discovered for
ethnl_parse_header().

Instead of fixing the callers and leaving the trap in place, add check of
null extack to both helpers to make them consistent with NL_SET_ERR_*
macros.

Fixes: 2363d73a2f3e ("ethtool: reject unrecognized request flags")
Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Reported-by: syzbot+258a9089477493cea67b@syzkaller.appspotmail.com
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/netlink.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 4090524c3462..60739d0cbf93 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -115,6 +115,8 @@ static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 {
 	u64 __cookie = cookie;
 
+	if (!extack)
+		return;
 	memcpy(extack->cookie, &__cookie, sizeof(__cookie));
 	extack->cookie_len = sizeof(__cookie);
 }
@@ -124,6 +126,8 @@ static inline void nl_set_extack_cookie_u32(struct netlink_ext_ack *extack,
 {
 	u32 __cookie = cookie;
 
+	if (!extack)
+		return;
 	memcpy(extack->cookie, &__cookie, sizeof(__cookie));
 	extack->cookie_len = sizeof(__cookie);
 }
-- 
2.25.1

