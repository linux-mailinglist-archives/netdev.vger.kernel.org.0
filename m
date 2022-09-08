Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8A75B1972
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiIHJ6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIHJ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:58:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C72DAA4EB;
        Thu,  8 Sep 2022 02:58:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWEIl-0002vq-18; Thu, 08 Sep 2022 11:58:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>,
        Igor Ryzhov <iryzhov@nfware.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/4] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
Date:   Thu,  8 Sep 2022 11:57:54 +0200
Message-Id: <20220908095757.1755-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908095757.1755-1-fw@strlen.de>
References: <20220908095757.1755-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Ryzhov <iryzhov@nfware.com>

ct_sip_next_header and ct_sip_get_header return an absolute
value of matchoff, not a shift from current dataoff.
So dataoff should be assigned matchoff, not incremented by it.

This issue can be seen in the scenario when there are multiple
Contact headers and the first one is using a hostname and other headers
use IP addresses. In this case, ct_sip_walk_headers will work as follows:

The first ct_sip_get_header call to will find the first Contact header
but will return -1 as the header uses a hostname. But matchoff will
be changed to the offset of this header. After that, dataoff should be
set to matchoff, so that the next ct_sip_get_header call find the next
Contact header. But instead of assigning dataoff to matchoff, it is
incremented by it, which is not correct, as matchoff is an absolute
value of the offset. So on the next call to the ct_sip_get_header,
dataoff will be incorrect, and the next Contact header may not be
found at all.

Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
Signed-off-by: Igor Ryzhov <iryzhov@nfware.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index daf06f71d31c..77f5e82d8e3f 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -477,7 +477,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 				return ret;
 			if (ret == 0)
 				break;
-			dataoff += *matchoff;
+			dataoff = *matchoff;
 		}
 		*in_header = 0;
 	}
@@ -489,7 +489,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 			break;
 		if (ret == 0)
 			return ret;
-		dataoff += *matchoff;
+		dataoff = *matchoff;
 	}
 
 	if (in_header)
-- 
2.35.1

