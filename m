Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581132A9F7C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgKFVug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:50:36 -0500
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:38860 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728771AbgKFVuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 16:50:13 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 4980E1800F08D;
        Fri,  6 Nov 2020 21:50:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:4321:4605:5007:7514:7903:7904:10004:10400:10848:11026:11232:11473:11658:11783:11889:11914:12043:12295:12296:12297:12555:12740:12895:12986:13160:13229:13439:13894:14181:14659:14721:21080:21433:21451:21627:21939:21990:30029:30041:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rod14_3b0fb74272d5
X-Filterd-Recvd-Size: 3501
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Fri,  6 Nov 2020 21:50:09 +0000 (UTC)
Message-ID: <d1cefb17a0a915fdabe7a80d14895ff3d85970c1.camel@perches.com>
Subject: Re: [PATCH] libbpf: Remove unnecessary conversion to bool
From:   Joe Perches <joe@perches.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>, xiakaixu1987@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Date:   Fri, 06 Nov 2020 13:50:08 -0800
In-Reply-To: <CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com>
References: <1604646759-785-1-git-send-email-kaixuxia@tencent.com>
         <CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-06 at 13:32 -0800, Andrii Nakryiko wrote:
> On Thu, Nov 5, 2020 at 11:12 PM <xiakaixu1987@gmail.com> wrote:
> > Fix following warning from coccinelle:
> > ./tools/lib/bpf/libbpf.c:1478:43-48: WARNING: conversion to bool not needed here
[]
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
[]
> > @@ -1475,7 +1475,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> >                                 ext->name, value);
> >                         return -EINVAL;
> >                 }
> > -               *(bool *)ext_val = value == 'y' ? true : false;
> > +               *(bool *)ext_val = value == 'y';
> 
> I actually did this intentionally. x = y == z; pattern looked too
> obscure to my taste, tbh.

It's certainly a question of taste and obviously there is nothing
wrong with yours.

Maybe adding parentheses makes the below look less obscure to you?

	x = (y == z);

My taste would run to something like:
---
 tools/lib/bpf/libbpf.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 313034117070..5d9c9c8d50c9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1469,25 +1469,34 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
 			      char value)
 {
 	switch (ext->kcfg.type) {
-	case KCFG_BOOL:
+	case KCFG_BOOL: {
+		bool *p = ext_val;
+
 		if (value == 'm') {
 			pr_warn("extern (kcfg) %s=%c should be tristate or char\n",
 				ext->name, value);
 			return -EINVAL;
 		}
-		*(bool *)ext_val = value == 'y' ? true : false;
+		*p = (value == 'y');
 		break;
-	case KCFG_TRISTATE:
+	}
+	case KCFG_TRISTATE: {
+		enum libbpf_tristate *p = ext_val;
+
 		if (value == 'y')
-			*(enum libbpf_tristate *)ext_val = TRI_YES;
+			*p = TRI_YES;
 		else if (value == 'm')
-			*(enum libbpf_tristate *)ext_val = TRI_MODULE;
+			*p = TRI_MODULE;
 		else /* value == 'n' */
-			*(enum libbpf_tristate *)ext_val = TRI_NO;
+			*p = TRI_NO;
 		break;
-	case KCFG_CHAR:
-		*(char *)ext_val = value;
+	}
+	case KCFG_CHAR: {
+		char *p = ext_val;
+
+		*p = value;
 		break;
+	}
 	case KCFG_UNKNOWN:
 	case KCFG_INT:
 	case KCFG_CHAR_ARR:

