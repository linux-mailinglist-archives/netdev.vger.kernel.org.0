Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5171CCD5F
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgEJT45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:56:57 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:50394 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728468AbgEJT44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 15:56:56 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 96E952C14;
        Sun, 10 May 2020 19:56:55 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:4250:4321:5007:6119:7903:8660:8957:10004:10400:10848:11026:11232:11658:11914:12043:12297:12555:12740:12760:12895:13095:13148:13230:13439:14180:14181:14659:14721:21060:21080:21324:21433:21451:21627:21809:21819:21939:30012:30022:30034:30054:30062:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bag48_596f82e07ea1f
X-Filterd-Recvd-Size: 3524
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sun, 10 May 2020 19:56:54 +0000 (UTC)
Message-ID: <19cc4fe7238358988950970a6f8af68a31b2e4bd.camel@perches.com>
Subject: Re: [PATCH net-next] checkpatch: warn about uses of ENOTSUPP
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 10 May 2020 12:56:53 -0700
In-Reply-To: <20200510185148.2230767-1-kuba@kernel.org>
References: <20200510185148.2230767-1-kuba@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-05-10 at 11:51 -0700, Jakub Kicinski wrote:
> ENOTSUPP often feels like the right error code to use, but it's
> in fact not a standard Unix error. E.g.:

It is SUSv3 though.

> $ python
> > > > import errno
> > > > errno.errorcode[errno.ENOTSUPP]
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> AttributeError: module 'errno' has no attribute 'ENOTSUPP'
> 
> There were numerous commits converting the uses back to EOPNOTSUPP
> but in some cases we are stuck with the high error code for backward
> compatibility reasons.
> 
> Let's try prevent more ENOTSUPPs from getting into the kernel.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Hi Joe, I feel like I already talked to you about this, but I lost
> my email archive, so appologies if you already said no.

Not so far as I can tell.

This seems OK to me, but using checkpatch -f should probably
not show this error.

You might include a link to where Andrew Lunn suggested it
in the commit message.  I didn't find it with a trivial search.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4199,6 +4199,14 @@ sub process {
>  			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
>  		}
>  
> +# ENOTSUPP is not a standard error code and should be avoided.
> +# Folks usually mean EOPNOTSUPP (also called ENOTSUP), when they type ENOTSUPP.
> +# Similarly to ENOSYS warning a small number of false positives is expected.
> +		if ($line =~ /\bENOTSUPP\b/) {

So to avoid having newbies and others trying to convert
existing uses in files using checkpatch.pl -f, maybe:
---
 scripts/checkpatch.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e5b6b9aa21d6..f1bc81d4d97c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4244,6 +4244,17 @@ sub process {
 			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
 		}
 
+# ENOTSUPP is not a standard error code and should be avoided in new patches.
+# Folks usually mean EOPNOTSUPP (also called ENOTSUP), when they type ENOTSUPP.
+# Similarly to ENOSYS warning a small number of false positives is expected.
+		if (~$file && $line =~ /\bENOTSUPP\b/) {
+			if (WARN("ENOTSUPP",
+				 "ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\bENOTSUPP\b/EOPNOTSUPP/;
+			}
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if ($perl_version_ok &&


