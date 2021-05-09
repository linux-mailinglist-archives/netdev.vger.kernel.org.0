Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0593776C1
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 15:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhEINMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 09:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEINMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 09:12:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B11C061573;
        Sun,  9 May 2021 06:11:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lfjCt-0001y1-2w; Sun, 09 May 2021 15:10:51 +0200
Date:   Sun, 9 May 2021 15:10:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, yhs@fb.com, ast@kernel.org,
        johannes.berg@intel.com, rdunlap@infradead.org,
        0x7f454c46@gmail.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: netlink_sendmsg: memset unused tail bytes in skb
Message-ID: <20210509131051.GD4038@breakpoint.cc>
References: <20210509121858.1232583-1-phil@philpotter.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509121858.1232583-1-phil@philpotter.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phillip Potter <phil@philpotter.co.uk> wrote:
> When allocating the skb within netlink_sendmsg, with certain supplied
> len arguments, extra bytes are allocated at the end of the data buffer,
> due to SKB_DATA_ALIGN giving a larger size within __alloc_skb for
> alignment reasons. This means that after using skb_put with the same
> len value and then copying data into the skb, the skb tail area is
> non-zero in size and contains uninitialised bytes. Wiping this area
> (if it exists) fixes a KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=3e63bcec536b7136b54c72e06adeb87dc6519f69

This patch papers over the real bug.

Please fix TIPC instead.
Incomplete patch as a starting point:

diff --git a/net/tipc/node.c b/net/tipc/node.c
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2481,7 +2481,6 @@ int tipc_nl_node_get_link(struct sk_buff *skb, struct genl_info *info)
 	struct net *net = genl_info_net(info);
 	struct nlattr *attrs[TIPC_NLA_LINK_MAX + 1];
 	struct tipc_nl_msg msg;
-	char *name;
 	int err;
 
 	msg.portid = info->snd_portid;
@@ -2499,13 +2498,11 @@ int tipc_nl_node_get_link(struct sk_buff *skb, struct genl_info *info)
 	if (!attrs[TIPC_NLA_LINK_NAME])
 		return -EINVAL;
 
-	name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
-
 	msg.skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!msg.skb)
 		return -ENOMEM;
 
-	if (strcmp(name, tipc_bclink_name) == 0) {
+	if (nla_strcmp(attrs[TIPC_NLA_LINK_NAME], tipc_bclink_name) == 0) {
 		err = tipc_nl_add_bc_link(net, &msg, tipc_net(net)->bcl);
 		if (err)
 			goto err_free;


You will also need to change tipc_node_find_by_name() to pass the nla
attr.

Alternatively TIPC_NLA_LINK_NAME policy can be changed:

diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -88,7 +88,7 @@ const struct nla_policy tipc_nl_net_policy[TIPC_NLA_NET_MAX + 1] = {
 
 const struct nla_policy tipc_nl_link_policy[TIPC_NLA_LINK_MAX + 1] = {
        [TIPC_NLA_LINK_UNSPEC]          = { .type = NLA_UNSPEC },
-       [TIPC_NLA_LINK_NAME]            = { .type = NLA_STRING,
+       [TIPC_NLA_LINK_NAME]            = { .type = NLA_NUL_STRING,


... which makes it safe to treat the raw attribute payload as a c-string,
but this might break existing userspace applications.

Its probably a good idea to audit all NLA_STRING attributes in tipc for
similar problems.
