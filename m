Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBF596224
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiHPSMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236883AbiHPSLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:11:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06EA8306D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660673508; x=1692209508;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=M6/7yGujA7YV5kHQqbgm4hnBeSVQ9JPR/pCoiQaLr5k=;
  b=gwcjt3Y9W2lEGqJoh0u0Ju/OXdILUafAAGJhyWnNTBGge3D7kOcePmzb
   aP6ufv0jJACoN9PiHdtiNviaRxOcaVxlU0X7nrApqLoc0AaXIwlzgE9Is
   RJ8Gvh6FXnp5dqos3VwqfOJ9RdorA1bSarsCJfW00Z5lnOoIcBScxnVtn
   rWeFZPHgYpc7KMfWGOISFM4wTaLltELoAYrK3IBzPA9Tv+YvfucYK8gks
   cxx+wWnjX1gv5Mo9wLXYC9c3aJXGZFPFyVZ63fZTsNHjNM8NyQeWhZ0GV
   XkJCbAwokjA9Dc+sMDam1goqdATG51j9N3+ItUFIvZIVAJp4qfpJFfC0u
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293568398"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="293568398"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:11:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="852745258"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:11:47 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <20220816091033.n6zfyiastdugfvfr@skbuf>
References: <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
 <20220815222639.346wachaaq5zjwue@skbuf> <87k079hzry.fsf@intel.com>
 <20220816091033.n6zfyiastdugfvfr@skbuf>
Date:   Tue, 16 Aug 2022 11:11:47 -0700
Message-ID: <8735dwhxcs.fsf@intel.com>
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

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Hi Vinicius,
>
> On Mon, Aug 15, 2022 at 04:07:13PM -0700, Vinicius Costa Gomes wrote:
>> The interrupt that is generated is a general/misc interrupt, we have to
>> check on the interrupt cause bit that it's something TimeSync related,
>> and only then, we have to check that it's indeed a TX Timestamp that is
>> ready. And then, there's another register with some bits saying which
>> one of the 4 registers for timestamps that is ready. There are a few
>> levels of indirection, but no polling.
>
> I used the word "poll" after being inspired by the code comments:
>
> /**
>  * igc_ptp_tx_work
>  * @work: pointer to work struct
>  *
>  * This work function polls the TSYNCTXCTL valid bit to determine when a
>  * timestamp has been taken for the current stored skb.
>  */
>

Ah, I see. That comment is misleading/wrong, that was "inherited" from
igb, which has a model that didn't have the TimeSync interrupt cause,
IIRC. Going to fix that.

>> I think your question is more "why there's that workqueue on igc?"/"why
>> don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
>> got that right, then, I don't have a good reason, apart from the feeling
>> that reading all those (5-6?) registers may take too long for a
>> interrupt handler. And it's something that's being done the same for
>> most (all?) Intel drivers.
>
> Ok, so basically it is an attempt of making the interrupt handler threaded,
> which doesn't run in hardirq context?
>

Something like that, I guess. Mixed with "if it ain't broken, don't fix
it", but things are breaking with higher link speeds, different use
cases, more users/interest.

> Note that this decision makes the igc limitation of "single timestampable
> skb in flight" even much worse than it needs to be, because it prolongs
> the "in flight" period until the system_wq actually gets to run the work
> item we create.
>

Yes, no disagreement from my side.

>> I have a TODO to experiment with removing the workqueue, and retrieving
>> the TX timestamp in the same context as the interrupt handler, but other
>> things always come up.
>> 
>> 
>> Cheers,
>> -- 
>> Vinicius


Cheers,
-- 
Vinicius
