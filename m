Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753B25F67BB
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiJFNUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJFNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:20:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793B49AFFE;
        Thu,  6 Oct 2022 06:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665062447; x=1696598447;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EU0abpI6YFdk3YA4KGgLZ9e2cnqNyTF/1r17KmA6WbU=;
  b=H/rXg2onBw8kdQTJR9j91bg7GaQ9NTLI4VQaO5RUMKhgyGVdTsqC0ihZ
   ZFrzupyxaktvnWl0/oAO1N0j+d7VdJ7vhM5jhQno6ZKD98/lmLTbJHLEk
   YdnjF2+yZPR82O204zlslKkxKat4YQqK1Imt18zDrXqo1ccS1JJsVSyxk
   MRKlQcD0RpszRcaGv0aLNg8NB07bkMRbNN5u6y9NvDUd9Pep7UTxlCSgc
   gMlNjOL77ikXzd/PJ+sKmxYh/x98yvYK62uMdNxBx1YoiL7Kpv6EnctwN
   rw/6E45iagBLiy4ub27Y6WReJAotEZtIYsSDo2cskapKSLTwKhAf1RYEB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="290697978"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="290697978"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 06:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="729143418"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="729143418"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 06 Oct 2022 06:20:34 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ogQng-0039rX-0O;
        Thu, 06 Oct 2022 16:20:32 +0300
Date:   Thu, 6 Oct 2022 16:20:31 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, cake@lists.bufferbloat.net,
        ceph-devel@vger.kernel.org, coreteam@netfilter.org,
        dccp@vger.kernel.org, dev@openvswitch.org,
        dmaengine@vger.kernel.org, drbd-dev@lists.linbit.com,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        linux-actions@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-raid@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xfs@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        SHA-cyfmac-dev-list@infineon.com, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v1 3/5] treewide: use get_random_u32() when possible
Message-ID: <Yz7WHyD+teLOh2ho@smile.fi.intel.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
 <20221005214844.2699-4-Jason@zx2c4.com>
 <Yz7OdfKZeGkpZSKb@ziepe.ca>
 <CAHmME9r_vNRFFjUvqx8QkBddg_kQU=FMgpk9TqOVZdvX6zXHNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9r_vNRFFjUvqx8QkBddg_kQU=FMgpk9TqOVZdvX6zXHNg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 07:05:48AM -0600, Jason A. Donenfeld wrote:
> On Thu, Oct 6, 2022 at 6:47 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > On Wed, Oct 05, 2022 at 11:48:42PM +0200, Jason A. Donenfeld wrote:

...

> > > -     u32 isn = (prandom_u32() & ~7UL) - 1;
> > > +     u32 isn = (get_random_u32() & ~7UL) - 1;
> >
> > Maybe this wants to be written as
> >
> > (prandom_max(U32_MAX >> 7) << 7) | 7

> > ?
> 
> Holy smokes. Yea I guess maybe? It doesn't exactly gain anything or
> make the code clearer though, and is a little bit more magical than
> I'd like on a first pass.

Shouldn't the two first 7s to be 3s?

...

> > > -     psn = prandom_u32() & 0xffffff;
> > > +     psn = get_random_u32() & 0xffffff;
> >
> >  prandom_max(0xffffff + 1)
> 
> That'd work, but again it's not more clear. Authors here are going for
> a 24-bit number, and masking seems like a clear way to express that.

We have some 24-bit APIs (and 48-bit) already in kernel, why not to have
get_random_u24() ?


-- 
With Best Regards,
Andy Shevchenko


