Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160DF1C6638
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEFDTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:19:07 -0400
Received: from smtprelay0003.hostedemail.com ([216.40.44.3]:36174 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725908AbgEFDTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 23:19:06 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 925061801E69E;
        Wed,  6 May 2020 03:19:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3871:4321:5007:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12220:12296:12297:12438:12740:12760:12895:13069:13255:13311:13357:13439:14659:14721:21080:21627:30054:30055:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: plane35_14f105b6b975d
X-Filterd-Recvd-Size: 2073
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 May 2020 03:19:03 +0000 (UTC)
Message-ID: <f8b258e0c8bb073c445090e637195df2fc989543.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: pcie: Use bitwise instead of arithmetic
 operator for flags
From:   Joe Perches <joe@perches.com>
To:     Samuel Zou <zou_wei@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 05 May 2020 20:19:02 -0700
In-Reply-To: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
References: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-06 at 11:07 +0800, Samuel Zou wrote:
> This silences the following coccinelle warning:
> 
> "WARNING: sum of probable bitmasks, consider |"

I suggest instead ignoring bad and irrelevant warnings.

PREFIX_LEN is 32 not 0x20 or BIT(5)
PCI_DUMP_SIZE is 352

> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
[]
> @@ -109,9 +109,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
>  
>  	/* Alloc a max size buffer */
>  	alloc_size = PCI_ERR_ROOT_ERR_SRC +  4 + PREFIX_LEN;
> -	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE + PREFIX_LEN);
> -	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE + PREFIX_LEN);
> -	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE + PREFIX_LEN);
> +	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE | PREFIX_LEN);
> +	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE | PREFIX_LEN);
> +	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE | PREFIX_LEN);
>  
>  	buf = kmalloc(alloc_size, GFP_ATOMIC);
>  	if (!buf)

