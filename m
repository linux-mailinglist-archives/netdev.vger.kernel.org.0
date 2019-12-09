Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505751175CC
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfLIT0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:26:54 -0500
Received: from correo.us.es ([193.147.175.20]:58472 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfLIT0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B350B120844
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3251DA70F
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 972D4DA70D; Mon,  9 Dec 2019 20:26:48 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54B2CDA70A;
        Mon,  9 Dec 2019 20:26:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DD62F4265A5A;
        Mon,  9 Dec 2019 20:26:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/17] netfilter: nf_flow_table_offload: Don't use offset uninitialized in flow_offload_port_{d,s}nat
Date:   Mon,  9 Dec 2019 20:26:25 +0100
Message-Id: <20191209192638.71184-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Clang warns (trimmed the second warning for brevity):

../net/netfilter/nf_flow_table_offload.c:342:2: warning: variable
'offset' is used uninitialized whenever switch default is taken
[-Wsometimes-uninitialized]
        default:
        ^~~~~~~
../net/netfilter/nf_flow_table_offload.c:346:57: note: uninitialized use
occurs here
        flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
                                                               ^~~~~~
../net/netfilter/nf_flow_table_offload.c:331:12: note: initialize the
variable 'offset' to silence this warning
        u32 offset;
                  ^
                   = 0

Match what was done in the flow_offload_ipv{4,6}_{d,s}nat functions and
just return in the default case, since port would also be uninitialized.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Link: https://github.com/ClangBuiltLinux/linux/issues/780
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: kernelci.org bot <bot@kernelci.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b3ad285e057d..dd78ae5441e9 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -340,7 +340,7 @@ static void flow_offload_port_snat(struct net *net,
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
-		break;
+		return;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
@@ -367,7 +367,7 @@ static void flow_offload_port_dnat(struct net *net,
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
-		break;
+		return;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
-- 
2.11.0

