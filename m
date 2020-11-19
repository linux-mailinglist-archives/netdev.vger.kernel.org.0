Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA962B9DE6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKSW5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:57:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:7659 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbgKSW5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 17:57:53 -0500
IronPort-SDR: TpBCWfWms7hSHONDPXMr9gzTjIrmq7AvM8ycHBr7ifRDxqdWS8akutLmv7zTyEBfIHQFRKJpEr
 em3P8HJQo/gQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171477203"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171477203"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 14:57:53 -0800
IronPort-SDR: IXOIoUhTOVwuGQj3y0QTWrhPiJwa3WyhY3keGLmacHp5RAJUdCDzkzF2GhZl6RPM7nCrxaYTax
 LhN18NRsES+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="534956339"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 19 Nov 2020 14:57:51 -0800
Date:   Thu, 19 Nov 2020 23:49:16 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v3] aquantia: Remove the build_skb path
Message-ID: <20201119224916.GA24569@ranger.igk.intel.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 10:34:48PM +0000, Ramsay, Lincoln wrote:
> When performing IPv6 forwarding, there is an expectation that SKBs
> will have some headroom. When forwarding a packet from the aquantia
> driver, this does not always happen, triggering a kernel warning.
> 
> The build_skb path fails to allow for an SKB header, but the hardware
> buffer it is built around won't allow for this anyway. Just always use the
> slower codepath that copies memory into an allocated SKB.
> 
> Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>
> ---

(Next time please include in the subject the tree that you're targetting
the patch)

I feel like it's only a workaround, not a real solution. On previous
thread Igor says:

"The limitation here is we can't tell HW on granularity less than 1K."

Are you saying that the minimum headroom that we could provide is 1k?
Maybe put more pressure on memory side and pull in order-1 pages, provide
this big headroom and tailroom for skb_shared_info and use build_skb by
default? With standard 1500 byte MTU.

This issue would pop up again if this driver would like to support XDP
where 256 byte headroom will have to be provided.

[...]
