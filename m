Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC59597668
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbiHQTYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiHQTYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:24:07 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDAC3C16C
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 12:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660764247; x=1692300247;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=MsD8ovn0mFA4MNmwfDYJ5bF7ia/WKHOPMUc4+s5w6P4=;
  b=oC9Gvv4emBD+elooBBaO8mStird4M3WYNPBmRuZu9usK1bnPMvLedajD
   sNW2MxQH2q+E+2v+LTiP/uBnwyRcbz1dCo+C3JjwSB4j8GNF02wwb9NpD
   rq6Wv4M5VaBLqrOeCd7pGAuLhmM9iWAkfJItlPJ7IjaW+uWhjoBWO+v/N
   YFt3BFtEie7ShGIP9qhM9h+TbeiqJ7PUPOV6xB9pn4Mqr4TH9KzxBgnwg
   ExSSeUy3UDpUvfLwggXqP7Tpg4mLY+Bwy+HINxZBGFI7mLQF6p+t5+tz5
   Jx5Ymtd6u10ZqT9nA4B53qiuDq+30nwhV5zx70yDN67wl5ilrpNqU+uTY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="290154754"
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="290154754"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 12:24:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="710678740"
Received: from gsrawal-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.252.143.209])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 12:24:05 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <87y1vno0xu.fsf@kurt>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
 <20220815222639.346wachaaq5zjwue@skbuf> <87k079hzry.fsf@intel.com>
 <87edxgr2q0.fsf@kurt> <87v8qrhq7w.fsf@intel.com> <87y1vno0xu.fsf@kurt>
Date:   Wed, 17 Aug 2022 12:24:05 -0700
Message-ID: <87lermwu5m.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kurt Kanzenbach <kurt@linutronix.de> writes:

> On Tue Aug 16 2022, Vinicius Costa Gomes wrote:
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>
>>> Hi Vinicius,
>>>
>>> On Mon Aug 15 2022, Vinicius Costa Gomes wrote:
>>>> I think your question is more "why there's that workqueue on igc?"/"why
>>>> don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
>>>> got that right, then, I don't have a good reason, apart from the feeling
>>>> that reading all those (5-6?) registers may take too long for a
>>>> interrupt handler. And it's something that's being done the same for
>>>> most (all?) Intel drivers.
>>>
>>> We do have one optimization for igb which attempts to read the Tx
>>> timestamp directly from the ISR. If that's not ready *only* then we
>>> schedule the worker. I do assume igb and igc have the same logic for
>>> retrieving the timestamps here.
>>>
>>
>> That seems a sensible approach. And yes, the timestamping logic is the
>> same.
>>
>>> The problem with workqueues is that under heavy system load, it might be
>>> deferred and timestamps will be lost. I guess that workqueue was added
>>> because of something like this: 1f6e8178d685 ("igb: Prevent dropped Tx
>>> timestamps via work items and interrupts.").
>>>
>>>>
>>>> I have a TODO to experiment with removing the workqueue, and retrieving
>>>> the TX timestamp in the same context as the interrupt handler, but other
>>>> things always come up.
>>>
>>> Let me know if you have interest in that igb patch.
>>
>> That would be great! Thanks.
>
> Sure. See igb patch below.

Thanks!

>
> I'm also wondering whether that delayed work should be replaced
> completely by the PTP AUX worker, because that one can be prioritized in
> accordance to the use case. And I see Vladimir already suggested this.

That was the idea.


Cheers,
-- 
Vinicius
