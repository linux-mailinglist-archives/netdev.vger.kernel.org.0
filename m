Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A386D561327
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiF3HXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiF3HXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:23:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B0727CFF
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656573813; x=1688109813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MbfSuw9UA3LRc7GDrrVI9/ku4qISI1pv7/WgZ9sqQ64=;
  b=HjriQi8sWHXxY2QXc/V3PhcKywRw0OSF6mZva4RuT68p63oIuSF8fKYK
   8v0Ps44fO8euqrl2GDMR1QNReLUb9/0qUL97YZmVSR16hO0gTkiGheCRo
   CZuNuSK9CTLr96fg0wulunj5AvKakCCtLqiTy7Evxek468L08yHtKGPCX
   Nqg5FIkNqZwFd0VWokU65GhFYhwr8IQRvsnl825Pyz9HscqHId8EbifO+
   PslK7lfOMOa4o15gmVlJQCv6XqumpIFgRETlT8PKF7tHJky9Osro/GuCQ
   1tpRjt4R+4HOchvpO2jqwpV1p3JBqZ0ap/xM0zQmirGMPF59WWGmMfC0r
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="281034834"
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="281034834"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 00:23:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="658889107"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.28]) ([10.13.12.28])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 00:23:28 -0700
Message-ID: <887f578a-6302-a1c5-b96e-012fef31ae60@linux.intel.com>
Date:   Thu, 30 Jun 2022 10:23:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [Intel-wired-lan] [PATCH v1] igc: Reinstate IGC_REMOVED logic and
 implement it properly
Content-Language: en-US
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        intel-wired-lan@lists.osuosl.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <YpjeEyMxobCIRfTx@wantstofly.org>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <YpjeEyMxobCIRfTx@wantstofly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/2022 18:58, Lennert Buytenhek wrote:
> The initially merged version of the igc driver code (via commit
> 146740f9abc4, "igc: Add support for PF") contained the following
> IGC_REMOVED checks in the igc_rd32/wr32() MMIO accessors:
> 
> 	u32 igc_rd32(struct igc_hw *hw, u32 reg)
> 	{
> 		u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
> 		u32 value = 0;
> 
> 		if (IGC_REMOVED(hw_addr))
> 			return ~value;
> 
> 		value = readl(&hw_addr[reg]);
> 
> 		/* reads should not return all F's */
> 		if (!(~value) && (!reg || !(~readl(hw_addr))))
> 			hw->hw_addr = NULL;
> 
> 		return value;
> 	}
> 
> And:
> 
> 	#define wr32(reg, val) \
> 	do { \
> 		u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
> 		if (!IGC_REMOVED(hw_addr)) \
> 			writel((val), &hw_addr[(reg)]); \
> 	} while (0)
> 
> E.g. igb has similar checks in its MMIO accessors, and has a similar
> macro E1000_REMOVED, which is implemented as follows:
> 
> 	#define E1000_REMOVED(h) unlikely(!(h))
> 
> These checks serve to detect and take note of an 0xffffffff MMIO read
> return from the device, which can be caused by a PCIe link flap or some
> other kind of PCI bus error, and to avoid performing MMIO reads and
> writes from that point onwards.
> 
> However, the IGC_REMOVED macro was not originally implemented:
> 
> 	#ifndef IGC_REMOVED
> 	#define IGC_REMOVED(a) (0)
> 	#endif /* IGC_REMOVED */
> 
> This led to the IGC_REMOVED logic to be removed entirely in a
> subsequent commit (commit 3c215fb18e70, "igc: remove IGC_REMOVED
> function"), with the rationale that such checks matter only for
> virtualization and that igc does not support virtualization -- but a
> PCIe device can become detached even without virtualization being in
> use, and without proper checks, a PCIe bus error affecting an igc
> adapter will lead to various NULL pointer dereferences, as the first
> access after the error will set hw->hw_addr to NULL, and subsequent
> accesses will blindly dereference this now-NULL pointer.
> 
> This patch reinstates the IGC_REMOVED checks in igc_rd32/wr32(), and
> implements IGC_REMOVED the way it is done for igb, by checking for the
> unlikely() case of hw_addr being NULL.  This change prevents the oopses
> seen when a PCIe link flap occurs on an igc adapter.
> 
> Fixes: 146740f9abc4 ("igc: Add support for PF")
> Signed-off-by: Lennert Buytenhek <buytenh@arista.com>
> ---
> As initially reported on intel-wired-lan@ in February:
> 
> 	https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20220214/027787.html
> 
> We're seeing these NULL pointer dereferences hit fairly reproducibly
> when rebooting, presumably due to the particularities of reset
> sequencing on the boards we see this hit on.
> 
> A link flap can be caused by toggling the Secondary Bus Reset bit
> in the upstream PCIe bridge's Bridge Control register and can reliably
> reproduce this problem.
> 
>   drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
>   drivers/net/ethernet/intel/igc/igc_regs.h | 5 ++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
