Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0F232B7E
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgG3Fls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:48 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56018 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgG3Flr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DAE1F20590;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 45DRFPxYKU0Z; Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2E2DD205B2;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 260263180167; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 01/19] xfrm: introduce oseq-may-wrap flag
Date:   Thu, 30 Jul 2020 07:41:12 +0200
Message-ID: <20200730054130.16923-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Vaněk <pv@excello.cz>

RFC 4303 in section 3.3.3 suggests to disable anti-replay for manually
distributed ICVs in which case the sender does not need to monitor or
reset the counter. However, the sender still increments the counter and
when it reaches the maximum value, the counter rolls over back to zero.

This patch introduces new extra_flag XFRM_SA_XFLAG_OSEQ_MAY_WRAP which
allows sequence number to cycle in outbound packets if set. This flag is
used only in legacy and bmp code, because esn should not be negotiated
if anti-replay is disabled (see note in 3.3.3 section).

Signed-off-by: Petr Vaněk <pv@excello.cz>
Acked-by: Christophe Gouault <christophe.gouault@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/xfrm.h |  1 +
 net/xfrm/xfrm_replay.c    | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index ff7cfdc6cb44..ffc6a5391bb7 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -387,6 +387,7 @@ struct xfrm_usersa_info {
 };
 
 #define XFRM_SA_XFLAG_DONT_ENCAP_DSCP	1
+#define XFRM_SA_XFLAG_OSEQ_MAY_WRAP	2
 
 struct xfrm_usersa_id {
 	xfrm_address_t			daddr;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 98943f8d01aa..c6a4338a0d08 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -89,7 +89,8 @@ static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
 		XFRM_SKB_CB(skb)->seq.output.low = ++x->replay.oseq;
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
-		if (unlikely(x->replay.oseq == 0)) {
+		if (unlikely(x->replay.oseq == 0) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_OSEQ_MAY_WRAP)) {
 			x->replay.oseq--;
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
@@ -168,7 +169,8 @@ static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
 	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
 		XFRM_SKB_CB(skb)->seq.output.low = ++replay_esn->oseq;
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
-		if (unlikely(replay_esn->oseq == 0)) {
+		if (unlikely(replay_esn->oseq == 0) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_OSEQ_MAY_WRAP)) {
 			replay_esn->oseq--;
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
@@ -572,7 +574,8 @@ static int xfrm_replay_overflow_offload(struct xfrm_state *x, struct sk_buff *sk
 
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
 		xo->seq.hi = 0;
-		if (unlikely(oseq < x->replay.oseq)) {
+		if (unlikely(oseq < x->replay.oseq) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_OSEQ_MAY_WRAP)) {
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
 
@@ -611,7 +614,8 @@ static int xfrm_replay_overflow_offload_bmp(struct xfrm_state *x, struct sk_buff
 
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
 		xo->seq.hi = 0;
-		if (unlikely(oseq < replay_esn->oseq)) {
+		if (unlikely(oseq < replay_esn->oseq) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_OSEQ_MAY_WRAP)) {
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
 
-- 
2.17.1

