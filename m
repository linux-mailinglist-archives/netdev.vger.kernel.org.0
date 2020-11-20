Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030FB2BA02E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKTCKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:10:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:32908 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKTCKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 21:10:19 -0500
IronPort-SDR: sJyxijFnti9lBTRsA/1TaNUswerW5IWUwdj83REz6A/7JlueCXXEOQN1cBeKvvS37KQJgnOCyj
 TakcH6BaAoBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="159170002"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="159170002"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 18:10:18 -0800
IronPort-SDR: eLS9s1WqUVI+ku1GyewQS+aKxGIi901ZGh0TjNtO592tk7fVkEd74A7c3oSNG2B2q7xR/az79H
 kPog+u4qBUXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="477054026"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 19 Nov 2020 18:10:16 -0800
Date:   Fri, 20 Nov 2020 03:01:40 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     David Awogbemila <awogbemila@google.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v7 1/4] gve: Add support for raw addressing
 device option
Message-ID: <20201120020140.GA26162@ranger.igk.intel.com>
References: <20201118232014.2910642-1-awogbemila@google.com>
 <20201118232014.2910642-2-awogbemila@google.com>
 <9b38c47593d2dedd5cad2c425b778a60cc7eeedf.camel@kernel.org>
 <CAL9ddJf1bPH2na9x6G7q22Jk-e_R7gP=yEVTe9y6vzrmnuRm6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL9ddJf1bPH2na9x6G7q22Jk-e_R7gP=yEVTe9y6vzrmnuRm6Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 04:22:24PM -0800, David Awogbemila wrote:
> On Thu, Nov 19, 2020 at 12:21 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >
> > On Wed, 2020-11-18 at 15:20 -0800, David Awogbemila wrote:
> > > From: Catherine Sullivan <csully@google.com>
> > >
> > > Add support to describe device for parsing device options. As
> > > the first device option, add raw addressing.
> > >
> > > "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> > > operational mode which allows the driver avoid bounce buffer copies
> > > which it currently performs using pre-allocated qpls
> > > (queue_page_lists)
> > > when sending and receiving packets.
> > > For egress packets, the provided skb data addresses will be
> > > dma_map'ed and
> > > passed to the device, allowing the NIC can perform DMA directly - the
> > > driver will not have to copy the buffer content into pre-allocated
> > > buffers/qpls (as in qpl mode).
> > > For ingress packets, copies are also eliminated as buffers are handed
> > > to
> > > the networking stack and then recycled or re-allocated as
> > > necessary, avoiding the use of skb_copy_to_linear_data().
> > >
> > > This patch only introduces the option to the driver.
> > > Subsequent patches will add the ingress and egress functionality.
> > >
> > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > ---
> > >
> > ...
> > > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c
> > > b/drivers/net/ethernet/google/gve/gve_adminq.c
> > > index 24ae6a28a806..1e2d407cb9d2 100644
> > > --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> > > +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> > > @@ -14,6 +14,57 @@
> > >  #define GVE_ADMINQ_SLEEP_LEN         20
> > >  #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK   100
> > >
> > > +#define GVE_DEVICE_OPTION_ERROR_FMT "%s option error:\n" \
> > > +"Expected: length=%d, feature_mask=%x.\n" \
> > > +"Actual: length=%d, feature_mask=%x.\n"
> > > +
> > > +static inline
> > > +struct gve_device_option *gve_get_next_option(struct
> > >
> >
> > Following Dave's policy, no static inline functions in C files.
> > This is control path so you don't really need the inline here.
> 
> Okay, I'll move it to a header file.

That's not what Saeed meant I suppose. Policy says that we let the
compiler to make the decision whether or not such static function should
be inlined. And since it's not a performance critical path as Saeed says
then drop the inline and keep the rest as-is.

> 
> >
> >
> >
