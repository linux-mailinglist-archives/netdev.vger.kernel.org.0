Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF6269997
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgINXWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:22:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:41908 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgINXWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 19:22:47 -0400
IronPort-SDR: gPdsEs4bsqF8e+NWbTCDGDFqZTXVErCR/iozthnsKQehMkb0J50PNjJERRPU1TZm2TEs2n6fkD
 RqvXTVQX/orw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="146863859"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="146863859"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:22:45 -0700
IronPort-SDR: PPektVXm3G9N68vCM055B+5z6xPuR54+n1NSt/YxNe+VH90gIVk2Wu8WgRhSE7v+OgsTVwe6AA
 ZMvza8mfDAVw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482534587"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.55.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 16:22:45 -0700
Date:   Mon, 14 Sep 2020 16:22:44 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH][next] i40e: switch kvzalloc to allocate rx/tx_bi buffer
Message-ID: <20200914162244.00001783@intel.com>
In-Reply-To: <1598000514-5951-1-git-send-email-lirongqing@baidu.com>
References: <1598000514-5951-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li RongQing wrote:

> when changes the rx/tx ring to 4096, rx/tx_bi needs an order
> 5 pages, and allocation maybe fail due to memory fragmentation
> so switch to kvzalloc

Hi Li,
Thanks for your patches, but I think you're solving a problem that isn't
a problem (besides that the warning is being printed.) After all, the
driver either gets the memory that it needed via the kernel waiting
(since we didn't set GFP_NOWAIT), or ENOMEM gets returned to the user.
If your kernel is so close to OOM that it's having this problem aren't
you going to have other issues? Anyway....

This driver goes to great lengths to not make any changes to the
existing queues if an allocation fails via ethtool (in fact this is
code I authored).

Maybe a better option is to just set __GFP_NOWARN on the kcalloc call?
Then if there is a memory allocation error we'll just reflect it to
user space and let the user retry, with no noisy kernel message.

For performance reasons, having actually contiguous regions from
kcalloc should help performance vs kvcalloc virtually contiguous
regions.

I'd prefer that you don't solve the problem this way. How about just
marking the allocations as GFP_RETRY_MAYFAIL and GFP_NOWARN?

The same goes for the iavf patch.

Jesse
