Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E72311F6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEaQI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:08:28 -0400
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:33067 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbfEaQI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:08:28 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id E252D837F24A;
        Fri, 31 May 2019 16:08:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:4321:5007:7514:7576:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21433:21451:21627:30054:30055:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: brush01_83b97375ede34
X-Filterd-Recvd-Size: 2238
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Fri, 31 May 2019 16:08:25 +0000 (UTC)
Message-ID: <f46c916f9ffeb0fba04eb53c56ef0c9b0a586b01.camel@perches.com>
Subject: Re: [net-next 01/13] iavf: Use printf instead of gnu_printf for
 iavf_debug_d
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Fri, 31 May 2019 09:08:23 -0700
In-Reply-To: <20190531081518.16430-2-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
         <20190531081518.16430-2-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 01:15 -0700, Jeff Kirsher wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> We can convert from gnu_printf to printf without any side effects
[]
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
[]
> @@ -46,7 +46,7 @@ struct iavf_virt_mem {
>  
>  #define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s, ##__VA_ARGS__)
>  extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
> -	__attribute__ ((format(gnu_printf, 3, 4)));
> +	__printf(3, 4);

This declaration and function likely have several defects:

void *hw should likely be struct iavf_hw *hw
char *fmt_str should likely be const char *

And the definition of the function should
probably have the output at KERN_DEBUG and not
KERN_INFO.  As well it should probably use %pV
instead of a local automatic buffer.

Perhaps a macro like:

#define iavf_debug_d(hw, mask, fmt, ...)	\
do {						\
	if ((mask) & (hw)->debug_mask)		\
		pr_debug(fmt, ##__VA_ARGS__);	\
} while (0)

would be better as it could allow dynamic debug
for every use.


