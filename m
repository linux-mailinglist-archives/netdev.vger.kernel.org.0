Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0112D1C73CE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgEFPPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:15:14 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:60978 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728821AbgEFPPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:15:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id B51AB246E;
        Wed,  6 May 2020 15:15:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:5007:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12220:12296:12297:12438:12663:12740:12760:12895:13069:13161:13229:13255:13311:13357:13439:14096:14097:14181:14659:14721:21080:21627:30054:30055:30069:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: bears23_ff76a315943a
X-Filterd-Recvd-Size: 2948
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 May 2020 15:15:09 +0000 (UTC)
Message-ID: <2208e464cd8bd399cfb9b49abb5aed211f27b3a8.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: pcie: Use bitwise instead of arithmetic
 operator for flags
From:   Joe Perches <joe@perches.com>
To:     Luciano Coelho <luciano.coelho@intel.com>,
        Samuel Zou <zou_wei@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        Julia Lawall <julia.lawall@lip6.fr>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci <cocci@systeme.lip6.fr>
Date:   Wed, 06 May 2020 08:15:08 -0700
In-Reply-To: <bfd6b3a7db0c50cd3d084510bd43c9e540688edd.camel@intel.com>
References: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
         <f8b258e0c8bb073c445090e637195df2fc989543.camel@perches.com>
         <bfd6b3a7db0c50cd3d084510bd43c9e540688edd.camel@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-06 at 16:51 +0300, Luciano Coelho wrote:
> On Tue, 2020-05-05 at 20:19 -0700, Joe Perches wrote:
> > On Wed, 2020-05-06 at 11:07 +0800, Samuel Zou wrote:
> > > This silences the following coccinelle warning:
> > > 
> > > "WARNING: sum of probable bitmasks, consider |"
> > 
> > I suggest instead ignoring bad and irrelevant warnings.
> > 
> > PREFIX_LEN is 32 not 0x20 or BIT(5)
> > PCI_DUMP_SIZE is 352
> > 
> > > diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> > []
> > > @@ -109,9 +109,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
> > >  
> > >  	/* Alloc a max size buffer */
> > >  	alloc_size = PCI_ERR_ROOT_ERR_SRC +  4 + PREFIX_LEN;
> > > -	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE + PREFIX_LEN);
> > > -	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE + PREFIX_LEN);
> > > -	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE + PREFIX_LEN);
> > > +	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE | PREFIX_LEN);
> > > +	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE | PREFIX_LEN);
> > > +	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE | PREFIX_LEN);
> > >  
> > >  	buf = kmalloc(alloc_size, GFP_ATOMIC);
> > >  	if (!buf)
> 
> Yeah, those macros are clearly not bitmasks.  I'm dropping this patch.

Can the cocci script that generated this warning

scripts/coccinelle/misc/orplus.cocci

be dropped or improved to validate the likelihood that
the defines or constants used are more likely than
not are bit values?

Maybe these should be defined as hex or BIT or BIT_ULL
or GENMASK or the like?


Right now it seems it just tests for two constants.


