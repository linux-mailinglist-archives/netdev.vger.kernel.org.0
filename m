Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0317E260E5F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgIHJMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:03 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43405 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729010AbgIHJLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 789F8F7F;
        Tue,  8 Sep 2020 05:11:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=L5VwYGWT4zQphxBDOFVxwn3OwXLoOWF9ISTpW6xVtbo=; b=T1sAvhQb
        O5FseC+ycSZUMCwgcDFPFGX77bd1QDtdlKgrEch4wCnlbsmvQmhd/AOCFOcVpNzP
        zB711M2AtwsTYIuhzL1eV71uPxNupiSHfv57QwncoLtmGl7bnrssZNjKz6QReE++
        WaxPjDmTEBGXbAfUPExqXDRnnffbb0gIVPAV1QT/FJGrOHjtPaCqeVO0cDzudpNd
        lDETe+DA11CRlGfDJqozLNgXgErnVKMUu9aKhyBCx6fKBgU4AauF+ldhmtf4GUWH
        h2ZUKGChHxFoFXxV94LPRXi/gXOWALIuduv5JR53ea8q5H9tVePTiWtOAq5JB1Vx
        oSI1SUtkCzNOwQ==
X-ME-Sender: <xms:wkpXX5rv9xQRykEwemCGtrsME0mHf8rqoc-_XbNvIgqtKE0O7j08dA>
    <xme:wkpXX7p8w2RnjI84n9ar7qOk_DAQbLVmAItnRt9V6AOs38bJZKpR7M-c9cQsMTEoG
    _HrL94gkDIZCM8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wkpXX2OPI8hiqKPckXqjfsHvZfBaXC4B1ipb9pAREzt8m742lqgADw>
    <xmx:wkpXX05rHnio84tgtLTCeE6RuiLQehKXcdKCRBfEBiMTvi6wIj_qbQ>
    <xmx:wkpXX46Ih0XmPyYV3QzvthJ9lgh4j43lPHxCasdDlj7dJnV38SFS0w>
    <xmx:wkpXX2mL1g3hIHw8hcOmzfIMocGrwDoyWSiZwIa3xnWvkSvBi-RHZw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6F713064682;
        Tue,  8 Sep 2020 05:11:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 03/22] nexthop: Only emit a notification when nexthop is actually deleted
Date:   Tue,  8 Sep 2020 12:10:18 +0300
Message-Id: <20200908091037.2709823-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the delete notification is emitted from the error path of
nexthop_add() and replace_nexthop(), which can be confusing to listeners
as they are not familiar with the nexthop.

Instead, only emit the notification when the nexthop is actually
deleted. The following sub-cases are covered:

1. User space deletes the nexthop
2. The nexthop is deleted by the kernel due to a netdev event (e.g.,
   nexthop device going down)
3. A group is deleted because its last nexthop is being deleted
4. The network namespace of the nexthop device is deleted

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
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

