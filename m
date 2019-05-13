Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4C1B36A
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfEMJ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:57:05 -0400
Received: from mail.us.es ([193.147.175.20]:34206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbfEMJ4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:56:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D19A04DE729
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3350DA7B6
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2906DA7B5; Mon, 13 May 2019 11:56:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B44DDA720;
        Mon, 13 May 2019 11:56:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 64E644265A31;
        Mon, 13 May 2019 11:56:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/13] netfilter: nf_flow_table: fix netdev refcnt leak
Date:   Mon, 13 May 2019 11:56:20 +0200
Message-Id: <20190513095630.32443-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

flow_offload_alloc() calls nf_route() to get a dst_entry. Internally,
nf_route() calls ip_route_output_key() that allocates a dst_entry and
holds it. So, a dst_entry should be released by dst_release() if
nf_route() is successful.

Otherwise, netns exit routine cannot be finished and the following
message is printed:

[  257.490952] unregister_netdevice: waiting for lo to become free. Usage count = 1

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 8968c7f5a72e..69d7a8439c7a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -112,6 +112,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
+	dst_release(route.tuple[!dir].dst);
 	return;
 
 err_flow_add:
-- 
2.11.0

