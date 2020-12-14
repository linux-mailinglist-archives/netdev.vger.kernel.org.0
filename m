Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2331C2D98BD
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439464AbgLNN0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:26:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:52356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439357AbgLNNZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 08:25:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F87AAC10;
        Mon, 14 Dec 2020 13:25:01 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1346B6030D; Mon, 14 Dec 2020 14:25:01 +0100 (CET)
Message-Id: <b54ed5c5fd972a59afea3e1badfb36d86df68799.1607952208.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: fix string set id check
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 14:25:01 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a shift of a u32 by more than 31 in strset_parse_request()
which is undefined behavior. This is caused by range check of string set id
using variable ret (which is always 0 at this point) instead of id (string
set id from request).

Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Reported-by: syzbot+96523fb438937cd01220@syzkaller.appspotmail.com
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/strset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 0baad0ce1832..c3a5489964cd 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -182,7 +182,7 @@ static int strset_parse_request(struct ethnl_req_info *req_base,
 		ret = strset_get_id(attr, &id, extack);
 		if (ret < 0)
 			return ret;
-		if (ret >= ETH_SS_COUNT) {
+		if (id >= ETH_SS_COUNT) {
 			NL_SET_ERR_MSG_ATTR(extack, attr,
 					    "unknown string set id");
 			return -EOPNOTSUPP;
-- 
2.29.2

