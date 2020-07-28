Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793C823114A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbgG1SIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:08:50 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:46604 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728452AbgG1SIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:08:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 1F1DB181D303C;
        Tue, 28 Jul 2020 18:08:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:4321:5007:10004:10400:10848:11026:11232:11473:11658:11914:12296:12297:12555:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21451:21627:21740:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: frog48_1a0a3d026f6b
X-Filterd-Recvd-Size: 2274
Received: from XPS-9350 (unknown [172.58.27.230])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jul 2020 18:08:48 +0000 (UTC)
Message-ID: <bd83cd37a477721c0336807ffd2044f19f85f1d3.camel@perches.com>
Subject: Re: [PATCH 17/29] l2tp: avoid precidence issues in L2TP_SKB_CB macro
From:   Joe Perches <joe@perches.com>
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
Date:   Tue, 28 Jul 2020 11:08:45 -0700
In-Reply-To: <169fe729db1ba8529d0c071b39d48091cc77fba2.camel@perches.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
         <20200721173221.4681-18-tparkin@katalix.com>
         <169fe729db1ba8529d0c071b39d48091cc77fba2.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-28 at 09:21 -0700, Joe Perches wrote:
> On Tue, 2020-07-21 at 18:32 +0100, Tom Parkin wrote:
> > checkpatch warned about the L2TP_SKB_CB macro's use of its argument: add
> > braces to avoid the problem.
> []
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> []
> > @@ -93,7 +93,7 @@ struct l2tp_skb_cb {
> >  	unsigned long		expires;
> >  };
> >  
> > -#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&skb->cb[sizeof(struct inet_skb_parm)])
> > +#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&(skb)->cb[sizeof(struct inet_skb_parm)])
> 
> Likely better to use a static inline.
> 
> Something like:
> 
> static inline struct l2tp_skb_cb *L2TP_SKB_SB(struct sk_buff *skb)
> {
> 	return &skb->cb[sizeof(struct inet+skb_parm)];
> }

More precisely:
---
 net/l2tp/l2tp_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index e723828e458b..78ad6d8405c4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -93,7 +93,10 @@ struct l2tp_skb_cb {
 	unsigned long		expires;
 };
 
-#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&(skb)->cb[sizeof(struct inet_skb_parm)])
+static inline struct l2tp_skb_cb *L2TP_SKB_CB(struct sk_buff *skb)
+{
+	return (struct l2tp_skb_cb *)&skb->cb[sizeof(struct inet_skb_parm)];
+}
 
 static struct workqueue_struct *l2tp_wq;
 


