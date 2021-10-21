Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECAB435EBB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhJUKK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:10:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33864 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhJUKKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:10:49 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DFE5F63F44;
        Thu, 21 Oct 2021 12:06:48 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/8] netfilter: ebtables: allocate chainstack on CPU local nodes
Date:   Thu, 21 Oct 2021 12:08:21 +0200
Message-Id: <20211021100821.964677-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211021100821.964677-1-pablo@netfilter.org>
References: <20211021100821.964677-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

Keep the per-CPU memory allocated for chainstacks local.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 83d1798dfbb4..ba045f35114d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -926,7 +926,9 @@ static int translate_table(struct net *net, const char *name,
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
 			newinfo->chainstack[i] =
-			  vmalloc(array_size(udc_cnt, sizeof(*(newinfo->chainstack[0]))));
+			  vmalloc_node(array_size(udc_cnt,
+					  sizeof(*(newinfo->chainstack[0]))),
+				       cpu_to_node(i));
 			if (!newinfo->chainstack[i]) {
 				while (i)
 					vfree(newinfo->chainstack[--i]);
-- 
2.30.2

