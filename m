Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7DE4FEB06
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiDLXiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiDLXcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:32:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F62397B80
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649801937; x=1681337937;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=pYSQFcXZJGcZzAcdQ77EdDgdUOQxNQ1Jn2IZPilXocI=;
  b=CiaRAEgcZ5LEVhLM2xseS2EZ7Eb4+JMUnvbi/+9qinaTsj6xEI0kDGL2
   GBwhI3vB4GYsIKM2qpPJ0ZrrDB0/8wxHQPrfAD5+3cJSZpuinWA/o9naT
   CoeGF4QsmYShRGQ2csEEPJy1+YyPxHCo/MuwhEsLHx23lVhsCGDqFr7OX
   0H4UQtMtQEWKk/T+01fNuHjWOr2MyO/f0GBQpH5EAuxHnjY/UYQLaYp7E
   l/JvQxfwMxJ7U0sdx5jmX4YuolIB+2Ugo7P3yDBempIqGI3gDK493nQdE
   VGCzU/I3bvjdf1OUjFeGiMjjLGc5LOXaSaZFKfW2M5i3/IJ8uA2PNhFyC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="348941246"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="348941246"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 14:05:03 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="655288321"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.61])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 14:05:03 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
In-Reply-To: <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com>
 <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org>
 <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
Date:   Tue, 12 Apr 2022 14:05:02 -0700
Message-ID: <87sfqiypvl.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gerhard Engleder <gerhard@engleder-embedded.com> writes:

>> > > > > @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>> > > > >       if (shhwtstamps &&
>> > > > >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>> > > > >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
>> > > > > +             rcu_read_lock();
>> > > > > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
>> > > >
>> > > > __sock_recv_timestamp() is hot path.
>> > > >
>> > > > No need to call dev_get_by_napi_id() for the vast majority of cases
>> > > > using plain old MAC time stamping.
>> > >
>> > > Isn't dev_get_by_napi_id() called most of the time anyway in put_ts_pktinfo()?
>> >
>> > No.  Only when SOF_TIMESTAMPING_OPT_PKTINFO is requested.
>>
>> You are right, my fault.
>>
>> > > That's the reason for the removal of a separate flag, which signals the need to
>> > > timestamp determination based on address/cookie. I thought there is no need
>> > > for that flag, as netdev is already available later in the existing code.
>> > >
>> > > > Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).
>> > >
>> > > This flag tells netdev_get_tstamp() which timestamp is required. If it
>> > > is not set, then
>> > > netdev_get_tstamp() has to deliver the normal timestamp as always. But
>> > > this normal
>> > > timestamp is only available via address/cookie. So netdev_get_tstamp() must be
>> > > called.
>> >
>> > It should be this:
>> >
>> > - normal, non-vclock:   use hwtstamps->hwtstamp directly
>> > - vclock:               use slower path with lookup
>> >
>> > I don't see why you can't implement that.
>>
>> I will try to implement it that way.
>
> I'm thinking about why there should be a slow path with lookup. If the
> address/cookie
> points to a defined data structure with two timestamps, then no lookup
> for the phc or
> netdev is necessary. It should be possible for every driver to
> allocate a skbuff with enough
> space for this structure in front of the received Ethernet frame. The
> structure could be:
>
> struct skb_inline_hwtstamps {
>         ktime_t hwtstamp;
>         ktime_t hwcstamp;
> };
>
> Actually my device and igc are storing the timestamps in front of the
> received Ethernet
> frame. In my opinion it is obvious to the store metadata of received
> Ethernet frames in
> front of it, because it eliminates the need for another DMA transfer.
> What is your opinion
> Vinicius?

If I am understanding this right, the idea is providing both "cycles"
(free running cycles measurement) and PHC timestamp for all packets, for
igc, it will work fine for RX (the HW already writes the timestamps for
two timer registers in the host memory), but for TX it's going be
awkward/slow (I would have to read two extra registers), but I think
it's still possible.

But it would be best to avoid the overhead, and only providing the
"extra" (the cycles one) measurement if necessary for TX, so
SKBTX_HW_TSTAMP_USE_CYCLES would still be needed.

So, in short, I am fine with it, as long as I can get away with only
providing the cycles measurement for TX if necessary.

>
> Gerhard

Cheers,
-- 
Vinicius
