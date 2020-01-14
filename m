Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F341913A850
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgANLXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:23:47 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52347 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANLXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A73B21B10;
        Tue, 14 Jan 2020 06:23:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=+7x55T/BdyzRqhHf8reJZv0QytQu+y4M25lWVJfpdFU=; b=tbSO9Vuo
        /tQsCkjWlzmrTfNo6DWEI6ueWqqM4dOBQ+9zOxIXQyk52/us37BF1GsURQhRbzMr
        njDdqC918Lnw+rmMAni96rqxUpv1snkyi3hR2RFlu95abUuI8Rwtpe7umbcKJZng
        A+zMxJHgNrvjVg615Hy3PlqCVRixlucUFtT+OAtkowuhsC4H/Zxh+nhOOvS65x/W
        go7EQBD/J98QpuKg9IfZSwzttk4JOfjI6kFkJrpOvlZElht2CuJOFETqnrqIJOa+
        HR8Jxm5u0GV0/+Y6bARWbTkkkpsRdy/dMt7Rhk7RRrZYOIevsFQcwoHD2St0aBhE
        ScEvGLVa/bf5Mw==
X-ME-Sender: <xms:waQdXufxjGFb1sbZTaAe7CopSZVJtfeld9GGUhuK4ItHH1Kqi3fgpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:wqQdXjsUFMBiRUZdVlNthqs9Bb2C7GxYFms4TFBzMNVUm8dERW7Ypw>
    <xmx:wqQdXknuPwYsP0Ji6lunTGimQhpnFO6_CzEV6HqpalIUSIYfIzysOA>
    <xmx:wqQdXq7XK5QmGhl-w5Ww-qUmcn3GgQasf5IA0T9vu5MEDhA9BupIUw>
    <xmx:wqQdXmirLnJqBcoM190O7vZy85k3Lff6xjV8_JkCxOK_CX99rreudw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83FA580061;
        Tue, 14 Jan 2020 06:23:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/10] ipv4: Replace route in list before notifying
Date:   Tue, 14 Jan 2020 13:23:09 +0200
Message-Id: <20200114112318.876378-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Subsequent patches will add an offload / trap indication to routes which
will signal if the route is present in hardware or not.

After programming the route to the hardware, drivers will have to ask
the IPv4 code to set the flags by passing the route's key.

In the case of route replace, the new route is notified before it is
actually inserted into the FIB alias list. This can prevent simple
drivers (e.g., netdevsim) that program the route to the hardware in the
same context it is notified in from being able to set the flag.

Solve this by first inserting the new route to the list and rollback the
operation in case the route was vetoed.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index b92a42433a7d..39f56d68ec19 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1221,23 +1221,26 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
 
+			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
+
 			if (fib_find_alias(&l->leaf, fa->fa_slen, 0, 0,
-					   tb->tb_id, true) == fa) {
+					   tb->tb_id, true) == new_fa) {
 				enum fib_event_type fib_event;
 
 				fib_event = FIB_EVENT_ENTRY_REPLACE;
 				err = call_fib_entry_notifiers(net, fib_event,
 							       key, plen,
 							       new_fa, extack);
-				if (err)
+				if (err) {
+					hlist_replace_rcu(&new_fa->fa_list,
+							  &fa->fa_list);
 					goto out_free_new_fa;
+				}
 			}
 
 			rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen,
 				  tb->tb_id, &cfg->fc_nlinfo, nlflags);
 
-			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
-
 			alias_free_mem_rcu(fa);
 
 			fib_release_info(fi_drop);
-- 
2.24.1

