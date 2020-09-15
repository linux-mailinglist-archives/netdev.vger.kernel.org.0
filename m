Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38B426B8AB
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIPAsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:48:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49403 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgIOLmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:42:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D5C3D5C0059;
        Tue, 15 Sep 2020 07:41:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 07:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oVG4yOVfTTCzL5fPmz2dSKzJntWmjOGz7S7dF25peks=; b=HhSb0yDv
        vfLAUGVveQy7WKwo1q9I6IMwdozGDC19sRbBawcG5MajsIENU5Dkivt3x7LZleL5
        /T/465uRDu+n1yj6j3pbf2I8o0+alQDJ3Ase8KEE+Imu4WSNzPnHclsKJOGi2/Uq
        7FY0kgGEx+squ5XcH9gCbtR2AcdFYfeguB0eEmhEHEeq2hlYCnPfPe9+AX/D0EdZ
        cumVFfn7RUuKNN5jAknX7YkliUqwaW+FVKhu5aA1cu6F20crcJ+/tlA3j5wII/Vw
        hGq2sfIjGvX2g3GZk08C/kLnhdE/ypOfFYiumzKBm3NCEmbMXLswrWaVHDGBWIwe
        ++NOy81UtID/lg==
X-ME-Sender: <xms:hKhgXzWfeuS5izWUEZzfeAfWDr87VDaoKI4trnIbDzq3GJY_KlLm6g>
    <xme:hKhgX7mDEXZHRlXIqrjZWLy93wDam01VqcQ2mCyot5dnVANMVNMkQQFEzn5ric6Om
    p4j6FvFrgs6n64>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefiedrkedvnecu
    vehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hKhgX_ajudXZERPWf_Zyo_HK5lJvVsntuh3Kp8AQpm0fYTgmGBwIwQ>
    <xmx:hKhgX-U_BYknRP3wPVPhZfPj1jQSPVFoFIYVGteIytntgFGZEL0ipQ>
    <xmx:hKhgX9m2A8htsxUGSxSfM37E_UsT1YrnIz6TzWNpRDKtTGYF3P65yg>
    <xmx:hKhgXyxmMwhRMrhDxJ090eOpVWAHjezYVE76emzQwpiqBlj9BDLxHA>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 234AD3064674;
        Tue, 15 Sep 2020 07:41:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/5] nexthop: Only emit a notification when nexthop is actually deleted
Date:   Tue, 15 Sep 2020 14:41:02 +0300
Message-Id: <20200915114103.88883-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915114103.88883-1-idosch@idosch.org>
References: <20200915114103.88883-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the in-kernel delete notification is emitted from the error
path of nexthop_add() and replace_nexthop(), which can be confusing to
in-kernel listeners as they are not familiar with the nexthop.

Instead, only emit the notification when the nexthop is actually
deleted. The following sub-cases are covered:

1. User space deletes the nexthop
2. The nexthop is deleted by the kernel due to a netdev event (e.g.,
   nexthop device going down)
3. A group is deleted because its last nexthop is being deleted
4. The network namespace of the nexthop device is deleted

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 13d9219a9aa1..8c0f17c6863c 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -870,8 +870,6 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	bool do_flush = false;
 	struct fib_info *fi;
 
-	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
-
 	list_for_each_entry(fi, &nh->fi_list, nh_list) {
 		fi->fib_flags |= RTNH_F_DEAD;
 		do_flush = true;
@@ -909,6 +907,8 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   struct nl_info *nlinfo)
 {
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+
 	/* remove from the tree */
 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
 
-- 
2.26.2

