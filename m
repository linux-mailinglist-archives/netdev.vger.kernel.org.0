Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC24637539
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiKXJea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXJe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:34:29 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A875A8E2BE
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669282468; x=1700818468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZTRKsPsKKtQI3pfTR2vKvJJznIwZ0Di9hwer3Xw2dHc=;
  b=eBpplvuGnC+DUjAuuKdULUGDIscB4aJDhdmGuT/jH7pykGDTuxR8IVjv
   N3pqdPTqOCTOKKqA6kLSlAssgJN4UuCVO6n9wCUP/VkNG1TE6mCG92xf/
   1suAVximA/gumRVOVUy8YIZRO52dSo5fhdA6ax/mttW3aAN3fWoGBT7d2
   ArLKQBV7XtCm0y9TA+70IojDRaTbLqDMytEr8IhJdCzceKt8w81X07i2p
   y3ydrqW5Fkytlz5v7qgdP+bb4bfNI6juULPUbVq0P3yQhd9WnP4Xdd//9
   pxLcqzLQaIrVtzEqBjrftz+VflvjT15KAgc1nPr0B1v3CQ6+5i5t49gT3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="376406642"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="376406642"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 01:34:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592851537"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="592851537"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 24 Nov 2022 01:34:26 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 185B7128; Thu, 24 Nov 2022 11:34:51 +0200 (EET)
Date:   Thu, 24 Nov 2022 11:34:51 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     netdev@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH v2 net-next 6/6] net: thunderbolt: Use kmap_local_page()
 instead of kmap_atomic()
Message-ID: <Y386u4X14LYBlX18@black.fi.intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
 <20221123205219.31748-7-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221123205219.31748-7-anirudh.venkataramanan@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 12:52:19PM -0800, Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
> kmap_atomic() and kunmap_atomic() with kmap_local_page() and kunmap_local()
> respectively.
> 
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
> to check if the code being executed between the map/unmap implicitly
> depends on page-faults and/or preemption being disabled. If yes, then code
> to disable page-faults and/or preemption should also be added for
> functional correctness. That however doesn't appear to be the case here,
> so just kmap_local_page() is used.
> 
> Also note that the page being mapped is not allocated by the driver, and so
> the driver doesn't know if the page is in normal memory. This is the reason
> kmap_local_page() is used as opposed to page_address().
> 
> I don't have hardware, so this change has only been compile tested.
> 
> Cc: Michael Jamet <michael.jamet@intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
