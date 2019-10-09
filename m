Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D200D1462
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbfJIQof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:44:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:56018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729644AbfJIQof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 12:44:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57B1DAC7D;
        Wed,  9 Oct 2019 16:44:33 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AD5D1E3785; Wed,  9 Oct 2019 18:44:32 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next] genetlink: do not parse attributes for families with
 zero maxattr
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20191009164432.AD5D1E3785@unicorn.suse.cz>
Date:   Wed,  9 Oct 2019 18:44:32 +0200 (CEST)
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
the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
same also in genl_family_rcv_msg_doit().

Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/netlink/genetlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index ecc2bd3e73e4..c4bf8830eedf 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -639,21 +639,23 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 				    const struct genl_ops *ops,
 				    int hdrlen, struct net *net)
 {
-	struct nlattr **attrbuf;
+	struct nlattr **attrbuf = NULL;
 	struct genl_info info;
 	int err;
 
 	if (!ops->doit)
 		return -EOPNOTSUPP;
 
+	if (!family->maxattr)
+		goto no_attrs;
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
 						  GENL_DONT_VALIDATE_STRICT,
-						  family->maxattr &&
 						  family->parallel_ops);
 	if (IS_ERR(attrbuf))
 		return PTR_ERR(attrbuf);
 
+no_attrs:
 	info.snd_seq = nlh->nlmsg_seq;
 	info.snd_portid = NETLINK_CB(skb).portid;
 	info.nlhdr = nlh;
-- 
2.23.0

