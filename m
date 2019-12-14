Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC99E11F2A3
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLNPzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:55:01 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49777 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726861AbfLNPzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:55:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 69052225A0;
        Sat, 14 Dec 2019 10:54:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=IsgHlKmT4wDAs+xUVEYIcvw8OO1GKrbqfoxg+j8Uc1Q=; b=IhhFoCBP
        fcLMPIWApemVKGlTlB5QzSqhORifd0GWR/FjK0pYiviWQ+7KjP/hsLrv+3BrwuBW
        qzIC/w63iJenqRDhnA3KVsNkTHgTdJnPQL0BR6Qv/qaSD7vPq5HYs2fLgFxh+Rpn
        MCVMEJe3cpQHDC5Ev6uMAVr5deiw1yCKsDY636CkbYlT8cFIhS1DWeGKGM3Hzyk2
        DB1kr6l/FwqWOrrBGJgAeZMxhTzuKo/86qFec1jobHCii5d1RWzgiVsj4sJVWs2k
        JkGjfr5kPwmA7p3zIimlDGCLiaOZ+Hqeg35Y8glSI8U+18dPQOkhOSFWAB4crDHa
        MRrb/cMb5kukKA==
X-ME-Sender: <xms:0wX1XVhg3eukHW71Elwm7W3tcef5qDvIinfYgYrDykbQDexwPJEUQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:0wX1XTO9BReIL_NNbQ86kBM1gG0dxH6ovv7HKZVyiHi08qwZvIzwZw>
    <xmx:0wX1XSBAR6R7pY_OWU9IDHyVrlDmJhhfPX_VHx-hLYmyFg5ssc6uEQ>
    <xmx:0wX1Xbx4OXFo-cKB7vhwkVvdpmQj3dtppJEwEdE4KXPZtlIBdDOqdg>
    <xmx:0wX1XfUnq5kJf6mHfFzWjCxzPvdAs7Mbik0awUCJFcisNUaS3WUmbg>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F2498005C;
        Sat, 14 Dec 2019 10:54:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/10] ipv4: Notify newly added route if should be offloaded
Date:   Sat, 14 Dec 2019 17:53:10 +0200
Message-Id: <20191214155315.613186-6-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191214155315.613186-1-idosch@idosch.org>
References: <20191214155315.613186-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When a route is added, it should only be notified in case it is the
first route in the FIB alias list with the given {prefix, prefix length,
table ID}. Otherwise, it is not used in the data path and should not be
considered by switch drivers.

v2:
* Convert to use fib_find_alias() instead of fib_find_first_alias()

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4c80ac0344f4..f56945d00d7a 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1295,6 +1295,16 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	if (WARN_ON_ONCE(!l))
 		goto out_free_new_fa;
 
+	if (fib_find_alias(&l->leaf, new_fa->fa_slen, 0, 0, tb->tb_id, true) ==
+	    new_fa) {
+		enum fib_event_type fib_event;
+
+		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		err = call_fib_entry_notifiers(net, fib_event, key, plen,
+					       new_fa, extack);
+		if (err)
+			goto out_remove_new_fa;
+	}
 	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
 	if (err)
 		goto out_remove_new_fa;
-- 
2.23.0

