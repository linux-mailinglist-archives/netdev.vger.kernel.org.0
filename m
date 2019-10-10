Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F153D349E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfJJXuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:50:32 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:48063 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725845AbfJJXub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:50:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 4DA0E181D3377;
        Thu, 10 Oct 2019 23:50:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:2898:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3868:3871:4321:4605:5007:6117:7576:7875:9391:10004:10400:11026:11232:11233:11473:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13439:14096:14097:14181:14659:14721:21080:21451:21505:21627:21740:21972:30054:30064:30070:30091,0,RBL:47.151.152.152:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: dock63_3e5b57d448e10
X-Filterd-Recvd-Size: 3509
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu, 10 Oct 2019 23:50:28 +0000 (UTC)
Message-ID: <2231d5f0a82f880e6706e2d0f070328a029c9b21.camel@perches.com>
Subject: Re: [PATCH v2 3/4] treewide: Use sizeof_member() macro
From:   Joe Perches <joe@perches.com>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date:   Thu, 10 Oct 2019 16:50:27 -0700
In-Reply-To: <20191010232345.26594-4-keescook@chromium.org>
References: <20191010232345.26594-1-keescook@chromium.org>
         <20191010232345.26594-4-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 16:23 -0700, Kees Cook wrote:
> From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
> 
> Replace all the occurrences of FIELD_SIZEOF() and sizeof_field() with
> sizeof_member() except at places where these are defined. Later patches
> will remove the unused definitions.
> 
> This patch is generated using following script:
> 
> EXCLUDE_FILES="include/linux/stddef.h|include/linux/kernel.h"
> 
> git grep -l -e "\bFIELD_SIZEOF\b" -e "\bsizeof_field\b" | while read file;
> do
> 
> 	if [[ "$file" =~ $EXCLUDE_FILES ]]; then
> 		continue
> 	fi
> 	sed -i  -e 's/\bFIELD_SIZEOF\b/sizeof_member/g' \
> 		-e 's/\bsizeof_field\b/sizeof_member/g' \
> 		$file;
> done

While the sed works, a cocci script would perhaps
be better as multi line argument realignment would
also occur.

$ cat sizeof_member.cocci
@@
@@

-	FIELD_SIZEOF
+	sizeof_member

@@
@@

-	sizeof_field
+	sizeof_member
$

For instance, this sed produces:

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
@@ -435,10 +435,10 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 
 	BUILD_BUG_ON(offsetofend(struct adiantum_request_ctx, u) !=
 		     sizeof(struct adiantum_request_ctx));
-	subreq_size = max(FIELD_SIZEOF(struct adiantum_request_ctx,
+	subreq_size = max(sizeof_member(struct adiantum_request_ctx,
 				       u.hash_desc) +
 			  crypto_shash_descsize(hash),
-			  FIELD_SIZEOF(struct adiantum_request_ctx,
+			  sizeof_member(struct adiantum_request_ctx,
 				       u.streamcipher_req) +
 			  crypto_skcipher_reqsize(streamcipher));
 

where the cocci script produces:

--- crypto/adiantum.c
+++ /tmp/cocci-output-22881-d8186c-adiantum.c
@@ -435,11 +435,11 @@ static int adiantum_init_tfm(struct cryp
 
 	BUILD_BUG_ON(offsetofend(struct adiantum_request_ctx, u) !=
 		     sizeof(struct adiantum_request_ctx));
-	subreq_size = max(FIELD_SIZEOF(struct adiantum_request_ctx,
-				       u.hash_desc) +
+	subreq_size = max(sizeof_member(struct adiantum_request_ctx,
+					u.hash_desc) +
 			  crypto_shash_descsize(hash),
-			  FIELD_SIZEOF(struct adiantum_request_ctx,
-				       u.streamcipher_req) +
+			  sizeof_member(struct adiantum_request_ctx,
+					u.streamcipher_req) +
 			  crypto_skcipher_reqsize(streamcipher));
 
 	crypto_skcipher_set_reqsize(tfm,


