Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AFC594ECE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiHPCny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241292AbiHPCnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:43:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4BD78BEF
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 16:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660604834; x=1692140834;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=gUGCB+cCXLWz50wxfcMZzhPYuyiu6DMtyAEI0z/0XPE=;
  b=C1lQzSy3OuQ0BUUu1/HWCo2EaQIykVaHCZaObrS9XVHHdsOc280oDkXn
   JNrh59u1KcombCNc/mC9WMEzmBiMH1bXIYjrdwF6UZCutpARxIpEsUgKG
   ua0Q5eZvMFyPf9nkdl2O7Mzszw1RyLr+nABHgg+Vmv93MGA4pZBQ3JkoX
   7XQDktZRXNz4Ra/9kDzNnMrWpS9JXJTycPP1Axd8YcNDpTTOzE2aM28dR
   rCjdYDmQEoqbki2ro+f6neLuz76eyJicy0YGjIyNdXlPuwn72cFBfi4jg
   Ms9ZQdVk7pLzE43Lw4NhapJA/KKqA8CruGhG+eTFCBhlp2Tqm8ugwSAIU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="318067348"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="318067348"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 16:07:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="674990854"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 16:07:14 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <20220815222639.346wachaaq5zjwue@skbuf>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
 <20220815222639.346wachaaq5zjwue@skbuf>
Date:   Mon, 15 Aug 2022 16:07:13 -0700
Message-ID: <87k079hzry.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Hi Vinicius,
>
> On Mon, Aug 15, 2022 at 02:39:33PM -0700, Vinicius Costa Gomes wrote:
>> Just some aditional information (note that I know very little about
>> interrupt internal workings), igc_intr_msi() is called when MSI-X is not
>> enabled (i.e. "MSI only" system), igc_msix_other() is called when MSI-X
>> is available. When MSI-X is available, i225/i226 sets up a separate
>> interrupt handler for "general" events, the TX timestamp being available
>> to be read from the registers is one those events.
>
> Thanks for the extra information.
>
> Why is the i225/i226 emitting an interrupt about the availability of a
> new TX timestamp, if the igc driver polls for its availability anyway?
> In other words, when IGC_TSICR_TXTS is found set, is a TX timestamp
> available or is it not? Why does the driver schedule a deferred work
> item to retrieve it?

The interrupt that is generated is a general/misc interrupt, we have to
check on the interrupt cause bit that it's something TimeSync related,
and only then, we have to check that it's indeed a TX Timestamp that is
ready. And then, there's another register with some bits saying which
one of the 4 registers for timestamps that is ready. There are a few
levels of indirection, but no polling.

I think your question is more "why there's that workqueue on igc?"/"why
don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
got that right, then, I don't have a good reason, apart from the feeling
that reading all those (5-6?) registers may take too long for a
interrupt handler. And it's something that's being done the same for
most (all?) Intel drivers.

I have a TODO to experiment with removing the workqueue, and retrieving
the TX timestamp in the same context as the interrupt handler, but other
things always come up.


Cheers,
-- 
Vinicius
