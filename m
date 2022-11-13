Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A982626F79
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiKMM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 07:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiKMM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 07:29:52 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97995EE29;
        Sun, 13 Nov 2022 04:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668342591; x=1699878591;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3aDUPNbZhT7y8PFBk3x2fesIcWdCkiQc/eyvtcMv5A4=;
  b=D5MdBdM5z+pBFnsbceA26OF4AtlI2zWEnXEJgUuB48gb/hF7AUUDB6Jr
   q+nPEFlAPnitTafLZogjV7nJaAkTp8dqMb4Pe/cHnnzvVF03QLZl3jv8v
   PNvrk1uyDkEwtccuczZqHYRBc7WgIjBW4PaQkr9Zn8wkUa+b66loRfyix
   YUX2gP84loi4p/zc5Ux0yq1xNKUHotDdTOkWsQ/quvbtr68rYCdw3QM/J
   Dz37FJQ0gIdvN+JF7IFqQRKtnw3g6WPe1uPoPRNQZt7HZovqD8iTx+JKI
   gJXg1rtRGyoWavV42tawUUr8e1pUyC2z/zlmORar9A1lbGsyFA8RH/MF4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10529"; a="376072774"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="376072774"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 04:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10529"; a="638111594"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="638111594"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 13 Nov 2022 04:29:44 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ouC7I-00Bfs8-35;
        Sun, 13 Nov 2022 14:29:40 +0200
Date:   Sun, 13 Nov 2022 14:29:40 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 0/4] cpumask: improve on cpumask_local_spread() locality
Message-ID: <Y3DjNJNtiZGNLeGi@smile.fi.intel.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111082551.7e71fbf4@kernel.org>
 <CAAH8bW9jG5US0Ymn1wax9tNK3MgZpcWfQsYgu-Km_E+WZw3yiA@mail.gmail.com>
 <a8c52fa8-f976-92a0-2948-843476a81efb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8c52fa8-f976-92a0-2948-843476a81efb@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 09:37:59AM +0200, Tariq Toukan wrote:
> On 11/11/2022 6:47 PM, Yury Norov wrote:
> > On Fri, Nov 11, 2022, 10:25 AM Jakub Kicinski <kuba@kernel.org
> > <mailto:kuba@kernel.org>> wrote:
> >     On Thu, 10 Nov 2022 20:00:23 -0800 Yury Norov wrote:

..

> > Sure. Tariq and Valentine please send your tags as appropriate.
> 
> I wonder what fits best here?
> 
> As the contribution is based upon previous work that I developed, then
> probably:
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Then it probably means that one of you (Yury or you) should also have a
Co-developed-by.

-- 
With Best Regards,
Andy Shevchenko


