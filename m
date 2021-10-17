Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61978430CB0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344815AbhJQWSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:18:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53480 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344784AbhJQWR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:59 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2018F63F04;
        Mon, 18 Oct 2021 00:14:08 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 15/15] netfilter: core: Fix clang warnings about unused static inlines
Date:   Mon, 18 Oct 2021 00:15:22 +0200
Message-Id: <20211017221522.853838-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Unlike gcc, clang warns about unused static inlines that are not in an
include file:

  net/netfilter/core.c:344:20: error: unused function 'nf_ingress_hook' [-Werror,-Wunused-function]
  static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
                     ^
  net/netfilter/core.c:353:20: error: unused function 'nf_egress_hook' [-Werror,-Wunused-function]
  static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
                     ^

According to commit 6863f5643dd7 ("kbuild: allow Clang to find unused
static inline functions for W=1 build"), the proper resolution is to
mark the affected functions as __maybe_unused.  An alternative approach
would be to move them to include/linux/netfilter_netdev.h, but since
Pablo didn't do that in commit ddcfa710d40b ("netfilter: add
nf_ingress_hook() helper function"), I'm guessing __maybe_unused is
preferred.

This fixes both the warning introduced by Pablo in v5.10 as well as the
one recently introduced by myself with commit 42df6e1d221d ("netfilter:
Introduce egress hook").

Fixes: ddcfa710d40b ("netfilter: add nf_ingress_hook() helper function")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3a32a813fcde..6dec9cd395f1 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -341,7 +341,8 @@ static int nf_ingress_check(struct net *net, const struct nf_hook_ops *reg,
 	return 0;
 }
 
-static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
+static inline bool __maybe_unused nf_ingress_hook(const struct nf_hook_ops *reg,
+						  int pf)
 {
 	if ((pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS) ||
 	    (pf == NFPROTO_INET && reg->hooknum == NF_INET_INGRESS))
@@ -350,7 +351,8 @@ static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
 	return false;
 }
 
-static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
+static inline bool __maybe_unused nf_egress_hook(const struct nf_hook_ops *reg,
+						 int pf)
 {
 	return pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS;
 }
-- 
2.30.2

