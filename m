Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF6C2A87A5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgKET6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:58:08 -0500
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:43244 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgKET6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:58:08 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 4A045100E7B47;
        Thu,  5 Nov 2020 19:58:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3872:3874:4225:4321:4605:5007:6119:7514:7576:7903:7904:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12295:12296:12297:12555:12679:12740:12895:13439:13894:14181:14659:14721:21080:21451:21627:21660:21990:30054:30056:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cake94_5d0fadf272cc
X-Filterd-Recvd-Size: 3092
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu,  5 Nov 2020 19:58:05 +0000 (UTC)
Message-ID: <31e5ce025694049ab6b21fe8f688131ac07b8abf.camel@perches.com>
Subject: Re: [PATCH] cxgb4: Fix the -Wmisleading-indentation warning
From:   Joe Perches <joe@perches.com>
To:     xiakaixu1987@gmail.com, vishal@chelsio.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Date:   Thu, 05 Nov 2020 11:58:04 -0800
In-Reply-To: <1604467444-23043-1-git-send-email-kaixuxia@tencent.com>
References: <1604467444-23043-1-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 13:24 +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the gcc warning:
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c:2673:9: warning: this 'for' clause does not guard... [-Wmisleading-indentation]
>  2673 |         for (i = 0; i < n; ++i) \

true, the defined macros though aren't pretty and depend on
externally defined i and n.

It'd be good to show that and to update the slightly difficult to read
helpers below that and remove the unnecessary T3 and R3 macros too.

Perhaps:
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 28 ++++++++++------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 0273f40b85f7..a7fddcdf4eac 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2666,20 +2666,20 @@ static int sge_qinfo_show(struct seq_file *seq, void *v)
 	if (r)
 		seq_putc(seq, '\n');
 
-#define S3(fmt_spec, s, v) \
-do { \
-	seq_printf(seq, "%-12s", s); \
-	for (i = 0; i < n; ++i) \
-		seq_printf(seq, " %16" fmt_spec, v); \
-		seq_putc(seq, '\n'); \
+/* These macros are dependent on locally scoped i and n variables */
+#define S3(fmt_spec, s, v)						\
+do {									\
+	seq_printf(seq, "%-12s", s);					\
+	for (i = 0; i < n; ++i)						\
+		seq_printf(seq, " %16" fmt_spec, v);			\
+	seq_putc(seq, '\n');						\
 } while (0)
-#define S(s, v) S3("s", s, v)
-#define T3(fmt_spec, s, v) S3(fmt_spec, s, tx[i].v)
-#define T(s, v) S3("u", s, tx[i].v)
-#define TL(s, v) T3("lu", s, v)
-#define R3(fmt_spec, s, v) S3(fmt_spec, s, rx[i].v)
-#define R(s, v) S3("u", s, rx[i].v)
-#define RL(s, v) R3("lu", s, v)
+
+#define S(s, v)			S3("s", s, v)
+#define T(s, v)			S3("u", s, tx[i].v)
+#define TL(s, v)		S3("lu", s, tx[i].v)
+#define R(s, v)			S3("u", s, rx[i].v)
+#define RL(s, v)		S3("lu", s, rx[i].v)
 
 	if (r < eth_entries) {
 		int base_qset = r * 4;
@@ -3139,8 +3139,6 @@ do { \
 #undef T
 #undef TL
 #undef S
-#undef R3
-#undef T3
 #undef S3
 out:
 	return 0;


