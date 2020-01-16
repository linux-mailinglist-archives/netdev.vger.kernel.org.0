Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6613F3AB
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389569AbgAPSoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:44:07 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40673 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388390AbgAPSoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:44:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 44C6A21FBA;
        Thu, 16 Jan 2020 13:44:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 16 Jan 2020 13:44:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fZu+O3UNIantsONtc
        wme3597r9WQlS77ssX35OWzZVw=; b=IodJkT9qDrYpccJZC/REA946qzspiExO2
        K9pkAhsXWKEMyUQXq06TXxTGzy5WbOa57wrfvmLSaY7ywQmstQ33S70IsseLl5eb
        VhQK0Ep5q5bip9pNupUKRsrDLpnanxpPbyDB7iPMlzNz6j6HSf1/Gz4JEZfFC8Bx
        D9T9hYeOa+cDh447HhyFUAD6UZA4x06TR2Yb0GZVbjVdEgJLhJPNM6QCFgyDgz6P
        0juk4IzbthnAZG9FctZ5sWVzE64aqs7a1K4x9ZoQC3uo/BmgxAOLC2e1UiySfTHd
        A6lrkg4CH4l6poMt74X2kFqHOT9EkMsEqD+70nI6RC+uGSjpfAx0Q==
X-ME-Sender: <xms:9K4gXhZPGIKuWR4JjaIWXaALRlNaUb2NmEkBRAR3ov32jIZMIfCVbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdehgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:9K4gXsZgQnpvXGhwlCVVjqPaY8n_DQTt7BSf6PvRKEO5gdkMvA66VA>
    <xmx:9K4gXklNbW_JOIsIOqWi0ngHZlvNQoE_bkc5v7jnuVILMer3RTKjIA>
    <xmx:9K4gXvjLSMehGcjA7gRhrvAQ7EXrjN9DKWYOwlz0XDS87xEvSAOoMg>
    <xmx:9K4gXj-5JpKgr4x1S_WNp539VTA5nLWjMfIsjNWmUjB9bt_HTztrKw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AEB630607B0;
        Thu, 16 Jan 2020 13:44:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next] ip route: Print "rt_offload" and "rt_trap" indication
Date:   Thu, 16 Jan 2020 20:43:48 +0200
Message-Id: <20200116184348.1984324-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The kernel now signals the offload state of a route using the
'RTM_F_OFFLOAD' and 'RTM_F_TRAP' flags. Print these to help users
understand the offload state of each route. The "rt_" prefix is used in
order to distinguish it from the offload state of nexthops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 ip/iproute.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ip/iproute.c b/ip/iproute.c
index 32bb52df250c..93b805c9004d 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -368,6 +368,10 @@ void print_rt_flags(FILE *fp, unsigned int flags)
 		print_string(PRINT_ANY, NULL, "%s ", "linkdown");
 	if (flags & RTNH_F_UNRESOLVED)
 		print_string(PRINT_ANY, NULL, "%s ", "unresolved");
+	if (flags & RTM_F_OFFLOAD)
+		print_string(PRINT_ANY, NULL, "%s ", "rt_offload");
+	if (flags & RTM_F_TRAP)
+		print_string(PRINT_ANY, NULL, "%s ", "rt_trap");
 
 	close_json_array(PRINT_JSON, NULL);
 }
-- 
2.24.1

