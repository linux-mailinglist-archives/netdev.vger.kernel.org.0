Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA75E258116
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgHaS2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHaS2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 14:28:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2A2C061573;
        Mon, 31 Aug 2020 11:28:42 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kCoXY-00DhWg-Li; Mon, 31 Aug 2020 20:28:24 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        syzkaller-bugs@googlegroups.com,
        Johannes Berg <johannes.berg@intel.com>,
        syzbot+353df1490da781637624@syzkaller.appspotmail.com
Subject: [PATCH] netlink: policy: correct validation type check
Date:   Mon, 31 Aug 2020 20:28:05 +0200
Message-Id: <20200831202805.8ca5a2fe1ffb.I46f0d5bee0a774517aeec539620895a473dd2299@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <000000000000ee7d1a05ae2f2720@google.com>
References: <000000000000ee7d1a05ae2f2720@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In the policy export for binary attributes I erroneously used
a != NLA_VALIDATE_NONE comparison instead of checking for the
two possible values, which meant that if a validation function
pointer ended up aliasing the min/max as negatives, we'd hit
a warning in nla_get_range_unsigned().

Fix this to correctly check for only the two types that should
be handled here, i.e. range with or without warn-too-long.

Reported-by: syzbot+353df1490da781637624@syzkaller.appspotmail.com
Fixes: 8aa26c575fb3 ("netlink: make NLA_BINARY validation more flexible")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 7b1f50531cd3..5c9e7530865f 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -264,7 +264,8 @@ int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
 		else
 			type = NL_ATTR_TYPE_BINARY;
 
-		if (pt->validation_type != NLA_VALIDATE_NONE) {
+		if (pt->validation_type == NLA_VALIDATE_RANGE ||
+		    pt->validation_type == NLA_VALIDATE_RANGE_WARN_TOO_LONG) {
 			struct netlink_range_validation range;
 
 			nla_get_range_unsigned(pt, &range);
-- 
2.26.2

