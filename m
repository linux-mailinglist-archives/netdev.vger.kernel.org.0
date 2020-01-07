Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C301C132A4F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgAGPpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:45:50 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44753 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728344AbgAGPpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:45:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C49F21FD7;
        Tue,  7 Jan 2020 10:45:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=01jy3gydLKItbVZbZbQXmiXWMfFweItw748lizAgGos=; b=O30SQGSj
        WelS/wEZkSOWSoybT+5l0gSvtLzDk8hHOwICnvfL3q2Ik+JgVYkoUVLCGzrpLM/O
        Miak3OoO9lm2vj0+1gZvKOzovLNKAsj0JeRQRymUIeONETOvxiYtruDSFyFAu8Xk
        UWiSzeuRubDQAHWoMgdtPkXWDYNmfjW4/m8vr622y5LI3BLJ5TN/091179hAvK39
        FZZqyA7uRPOWfCKM8AMePMe948DO34jNp03oTBwoFyoiye362vIV3CkEKjzTd9ZB
        50I7Q7tOjzvbxO3LNerYuvTND8VjRFDSFv5MZW8HcbSk2++NthRbDjsVX+bFJlZ8
        YYibmwo0FP75Cw==
X-ME-Sender: <xms:rKcUXjuACpJ1h60ZiZDSgQfK0aREtLzjSmdvsgTkZuhujHyKwc4tRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:rKcUXqcSFNei2-R3L2fVQ2youUZA8Q4eNObMDDDf1DWAZCLiwVjdHA>
    <xmx:rKcUXhlkAjSRXCXXTs0R688m7VUwXvjLXNtx5haOqDedNUEhh1_xUA>
    <xmx:rKcUXlAlcQKHZppkfQ6wbYIAZVAVouJlAuZta_PJLDn8htxVEu7-Yg>
    <xmx:racUXpC0NzVLUF8nifcVJMYVs2uZV-DnTEeXd2axwHKLn2zQElFW7A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E5D68005A;
        Tue,  7 Jan 2020 10:45:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/10] ipv4: Replace route in list before notifying
Date:   Tue,  7 Jan 2020 17:45:08 +0200
Message-Id: <20200107154517.239665-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
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

