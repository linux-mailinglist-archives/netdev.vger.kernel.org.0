Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A014A5963E8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbiHPUp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbiHPUp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:45:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895988DEC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660682756; x=1692218756;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=hCZyn0XASUQiYpVFt/664nMlYYX0sfN8DjTaw2BiDwc=;
  b=cr8SF2jElyhq1xQnXlp+W8dMbeHipDRCxZAUH63zQ9y7TAKF5T9tscx+
   FZu+Rn5VNlGyOzc506txQrdrY4Het56JQggtR7pYxTo6me2LNkS6DMdyx
   Zap89RksP4oKX3VmLkkR1HFPsK5aIb02ua8BZgPQeFPMnkLIjwymJcwr+
   vReAtgjD9OXiSvYrkL9SOmc5rSVUKFTyAj8zn9aMaiSQvLRPWJR6cV4xh
   EUd9Sp27tvQi7FW03ZQlH75Mb6zMmz8i10eNZ78ENqRR4wAMf3IJMtTKT
   z2D1vysHxD0lEDPk193O8k0w/vHXj5c3MsKjT7bUEKqCUqnKaOwKXKeHM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293120941"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="293120941"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 13:45:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="607182100"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 13:45:55 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <87edxgr2q0.fsf@kurt>
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
 <87edxgr2q0.fsf@kurt>
Date:   Tue, 16 Aug 2022 13:45:55 -0700
Message-ID: <87v8qrhq7w.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kurt Kanzenbach <kurt@linutronix.de> writes:

> Hi Vinicius,
>
> On Mon Aug 15 2022, Vinicius Costa Gomes wrote:
>> I think your question is more "why there's that workqueue on igc?"/"why
>> don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
>> got that right, then, I don't have a good reason, apart from the feeling
>> that reading all those (5-6?) registers may take too long for a
>> interrupt handler. And it's something that's being done the same for
>> most (all?) Intel drivers.
>
> We do have one optimization for igb which attempts to read the Tx
> timestamp directly from the ISR. If that's not ready *only* then we
> schedule the worker. I do assume igb and igc have the same logic for
> retrieving the timestamps here.
>

That seems a sensible approach. And yes, the timestamping logic is the
same.

> The problem with workqueues is that under heavy system load, it might be
> deferred and timestamps will be lost. I guess that workqueue was added
> because of something like this: 1f6e8178d685 ("igb: Prevent dropped Tx
> timestamps via work items and interrupts.").
>
>>
>> I have a TODO to experiment with removing the workqueue, and retrieving
>> the TX timestamp in the same context as the interrupt handler, but other
>> things always come up.
>
> Let me know if you have interest in that igb patch.

That would be great! Thanks.

>
> Thanks,
> Kurt


Cheers,
-- 
Vinicius
