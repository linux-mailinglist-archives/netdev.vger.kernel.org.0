Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175F3D3B7E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfJKIpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:45:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:56238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726508AbfJKIpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 04:45:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D9F1ABE3;
        Fri, 11 Oct 2019 08:45:45 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 91E73E378C; Fri, 11 Oct 2019 10:45:44 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Date:   Fri, 11 Oct 2019 09:40:09 +0200
Subject: [PATCH net-next v3] genetlink: do not parse attributes for families
 with zero maxattr
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20191011084544.91E73E378C@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
to a separate function") moved attribute buffer allocation and attribute
parsing from genl_family_rcv_msg_doit() into a separate function
genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
__nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
parsing). The parser error is ignored and does not propagate out of
genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
type") is set in extack and if further processing generates no error or
warning, it stays there and is interpreted as a warning by userspace.

Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
the call of genl_family_rcv_msg_attrs_parse() if family->maxattr is zero.
Move this logic inside genl_family_rcv_msg_attrs_parse() so that we don't
have to handle it in each caller.

v3: put the check inside genl_family_rcv_msg_attrs_parse()
v2: adjust also argument of genl_family_rcv_msg_attrs_free()

Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/netlink/genetlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index ecc2bd3e73e4..0522b2b1fd95 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -483,6 +483,9 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	struct nlattr **attrbuf;
 	int err;
 
+	if (!family->maxattr)
+		return NULL;
+
 	if (parallel) {
 		attrbuf = kmalloc_array(family->maxattr + 1,
 					sizeof(struct nlattr *), GFP_KERNEL);
@@ -582,9 +585,6 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
 		return -EINVAL;
 
-	if (!family->maxattr)
-		goto no_attrs;
-
 	attrs = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						ops, hdrlen,
 						GENL_DONT_VALIDATE_DUMP_STRICT,
@@ -649,7 +649,6 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
 						  GENL_DONT_VALIDATE_STRICT,
-						  family->maxattr &&
 						  family->parallel_ops);
 	if (IS_ERR(attrbuf))
 		return PTR_ERR(attrbuf);
@@ -676,8 +675,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 		family->post_doit(ops, skb, &info);
 
 out:
-	genl_family_rcv_msg_attrs_free(family, attrbuf,
-				       family->maxattr && family->parallel_ops);
+	genl_family_rcv_msg_attrs_free(family, attrbuf, family->parallel_ops);
 
 	return err;
 }
-- 
2.23.0

