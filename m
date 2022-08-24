Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC05A04BD
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiHXXeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiHXXeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:34:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E788688D;
        Wed, 24 Aug 2022 16:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661384025; x=1692920025;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Ta6Boi4dB85Bw+MJV6ACqB2ldklriSUX+Ia0u+H/QEk=;
  b=F4YljnFCcjNUauBH1J0zR3Ji7yHSPqTX/rY7qY4xrVFsQ9YSVq2wvR7j
   OcpA3UkkehRDquopCDcKWJiQ2hMvSM5gpswXquYEfYYYcA453rYcwrs2/
   UdO/YgljiqylPxpo7eeGNq3xV/bCVn2bLX2uxEZswn1lvEO5qRpEeDoXP
   vr0X8jRTBbCDWqVDoTHkKFhaHslmJ/hSeUhzSHxuWJe0P5jQXAIa2VNZ5
   VohpGVRaqGtsHhmZBmFy5cPwAmytumKrdIad+IG6s2u3DMKYLNWXkGBKw
   YcXRAU1XbiOQcnL/zYVNa56DF+THfs+tiwYlHqqWaChH0S5xyhxsTDDUv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="295380723"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="295380723"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 16:33:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="639338084"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 16:33:44 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: taprio vs. wireless/mac80211
In-Reply-To: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
Date:   Wed, 24 Aug 2022 16:33:43 -0700
Message-ID: <87lerdmd2g.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,
>
> We're exploring the use of taprio with wireless/mac80211, and in
> mac80211 today (**) we don't have multiple queues (any more) since all
> the queuing actually happens in FQ/Codel inside mac80211. We also set
> IFF_NO_QUEUE, but that of course only really affects the default qdisc,
> not the fact that you could use it or not.
>
> In mac80211 thus we never back-pressure against the qdiscs, which is why
> we basically selected a single queue. Also, there's nothing else we do
> about the queue other than immediately pull a packet from it if
> available, so it'd basically pure overhead to have real queues there.
>
> In a sense, given that we cannot back-pressure against the queues, it
> feels a bit wrong to even have multiple queues. We also don't benefit in
> any way from splitting data structures onto multiple CPUs or something
> since we put it all into the same FQ/Codel anyway.
>
>
> Now, in order to use taprio, you're more or less assuming that you have
> multiple (equivalent) queues, as far as I can tell.
>
>
> Obviously we can trivially expose multiple equivalent queues from
> mac80211, but it feels somewhat wrong if that's just to make taprio be
> able to do something?
>
> Also how many should we have, there's more code to run so in many cases
> you probably don't want more than one, but if you want to use taprio you
> need at least two, but who says that's good enough, you might want more
> classes:
>
>         /* taprio imposes that traffic classes map 1:n to tx queues */
>         if (qopt->num_tc > dev->num_tx_queues) {
>                 NL_SET_ERR_MSG(extack, "Number of traffic classes is
> greater than number of HW queues");
>                 return -EINVAL;
>         }
>
>
> The way taprio is done almost feels like maybe it shouldn't even care
> about the number of queues since taprio_dequeue_soft() anyway only
> queries the sub-qdiscs? I mean, it's scheduling traffic, if you over-
> subscribe and send more than the link can handle, you've already lost
> anyway, no?
>
> (But then Avi pointed out that the sub qdiscs are initialized per HW
> queue, so this doesn't really hold either ...)
>
>
> Anyone have recommendations what we should do?

I will need to sleep on this, but at first glance, it seems you are
showing a limitation of taprio.

Removing that limitation seems possible, but it would add a bit of
complexity (but not much it seems) to the code, let me write down what I
am thinking:

 0. right now I can trust that there are more queues than traffic
 classes, and using the netdev prio->tc->queue map, I can do the
 scheduling almost entirely on queues. I have to remove this assumption.

 1. with that assumption removed, it means that I can have more traffic
 classes than queues, and so I have to be able to handle multiple
 traffic classes mapped to a single queue, i.e. one child qdisc per TC
 vs. one child per queue that we have today. Enqueueing each packet to
 the right child qdisc is easy. Dequeueing also is also very similar to
 what taprio does right now.

 2. it would be great if I knew the context in which each ->dequeue() is
 called, specifically which queue the ->dequeue() is for, it would
 reduce the number of children that I would have to check.

After writing this, I got the impression that it's feasible. Anyway,
will think a bit more about it.

(2) I don't think is possible right now, but I think we can go on
without it, and leave it as a future optimization.

Does it make sense? Did I understand the problem you are having right?


Cheers,
-- 
Vinicius
