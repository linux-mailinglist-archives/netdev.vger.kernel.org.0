Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2B11C721E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgEFNvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 09:51:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:49986 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgEFNvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 09:51:25 -0400
IronPort-SDR: 5WfPlfjMe6qWCKw8sNqcrOONmhepX64xDwuYBNAAFtdj7O2y5HNCqg83tqKxLXVQni3K2rhqOE
 WUbc6iAfwsMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 06:51:24 -0700
IronPort-SDR: m8nwacp2R8DmPdZZRMDkHjX40n5VlhkEVs907sIOf5X9efKF+Bsn5pWTaqEgIqP4NsARFjRvXh
 9YR9BtMvkarw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,359,1583222400"; 
   d="scan'208";a="369797404"
Received: from jcalzada-mobl1.amr.corp.intel.com ([10.249.254.200])
  by fmsmga001.fm.intel.com with ESMTP; 06 May 2020 06:51:21 -0700
Message-ID: <bfd6b3a7db0c50cd3d084510bd43c9e540688edd.camel@intel.com>
Subject: Re: [PATCH -next] iwlwifi: pcie: Use bitwise instead of arithmetic
 operator for flags
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Joe Perches <joe@perches.com>, Samuel Zou <zou_wei@huawei.com>,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 06 May 2020 16:51:20 +0300
In-Reply-To: <f8b258e0c8bb073c445090e637195df2fc989543.camel@perches.com>
References: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
         <f8b258e0c8bb073c445090e637195df2fc989543.camel@perches.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-05-05 at 20:19 -0700, Joe Perches wrote:
> On Wed, 2020-05-06 at 11:07 +0800, Samuel Zou wrote:
> > This silences the following coccinelle warning:
> > 
> > "WARNING: sum of probable bitmasks, consider |"
> 
> I suggest instead ignoring bad and irrelevant warnings.
> 
> PREFIX_LEN is 32 not 0x20 or BIT(5)
> PCI_DUMP_SIZE is 352
> 
> > diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> []
> > @@ -109,9 +109,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
> >  
> >  	/* Alloc a max size buffer */
> >  	alloc_size = PCI_ERR_ROOT_ERR_SRC +  4 + PREFIX_LEN;
> > -	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE + PREFIX_LEN);
> > -	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE + PREFIX_LEN);
> > -	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE + PREFIX_LEN);
> > +	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE | PREFIX_LEN);
> > +	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE | PREFIX_LEN);
> > +	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE | PREFIX_LEN);
> >  
> >  	buf = kmalloc(alloc_size, GFP_ATOMIC);
> >  	if (!buf)

Yeah, those macros are clearly not bitmasks.  I'm dropping this patch.

--
Cheers,
Luca.

