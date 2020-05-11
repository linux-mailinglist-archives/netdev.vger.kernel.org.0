Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDBD1CE12D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbgEKRDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:03:36 -0400
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:39078 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730900AbgEKRDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:03:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id B68D5100E7B51;
        Mon, 11 May 2020 17:03:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:7903:10004:10400:10848:11026:11232:11658:11914:12297:12679:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21451:21627:30012:30034:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: dog25_5922f49cb6a19
X-Filterd-Recvd-Size: 2052
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Mon, 11 May 2020 17:03:32 +0000 (UTC)
Message-ID: <c4b600b5455fcb48975cfc9d8214cdbbc01f2e2f.camel@perches.com>
Subject: Re: [PATCH net-next v2] checkpatch: warn about uses of ENOTSUPP
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Date:   Mon, 11 May 2020 10:03:31 -0700
In-Reply-To: <20200511165319.2251678-1-kuba@kernel.org>
References: <20200511165319.2251678-1-kuba@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-11 at 09:53 -0700, Jakub Kicinski wrote:
> ENOTSUPP often feels like the right error code to use, but it's
> in fact not a standard Unix error. E.g.:
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4199,6 +4199,17 @@ sub process {
>  			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
>  		}
>  
> +# ENOTSUPP is not a standard error code and should be avoided in new patches.
> +# Folks usually mean EOPNOTSUPP (also called ENOTSUP), when they type ENOTSUPP.
> +# Similarly to ENOSYS warning a small number of false positives is expected.
> +		if (~$file && $line =~ /\bENOTSUPP\b/) {

It's probably my typo or my brain thinking "not" and hitting
the tilde and not the bang, but this should be

		if (!$file & ...)

Otherwise:

Acked-by: Joe Perches <joe@perches.com>

> +			if (WARN("ENOTSUPP",
> +				 "ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP\n" . $herecurr) &&
> +			    $fix) {
> +				$fixed[$fixlinenr] =~ s/\bENOTSUPP\b/EOPNOTSUPP/;
> +			}
> +		}
> +
>  # function brace can't be on same line, except for #defines of do while,
>  # or if closed on same line
>  		if ($perl_version_ok &&

