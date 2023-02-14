Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4174969594E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjBNGkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBNGkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:40:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289453C33
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B794861454
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B44C433D2;
        Tue, 14 Feb 2023 06:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676356805;
        bh=fOfVmluCYbqgst21Ks3hq58Q29AKag9ee+kh2+gH8tE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pn6V28+vZYfMhn/jvnqRfJE1LB50pHU4ruLr2lQdlp9HZCNnIQNYA57nV1t61sv3N
         rKxBk4S5SOS35mgDgbKudCtgtA92Yy2z4vDDlzFp8hJ3TLWbjeY751EaSwDerUoIcK
         WmZD+YM99ZRQhcPc/ejjoE9MmRvo3apDFMpshxsTwPm/N9MZkKyyz6GW6ACm1kH3ub
         wONZgY0uj4PieOir2LAe5MwUkxXaZq3w/h13VllMvUZ2kONCt7Dvmv06OGz9QlPbED
         6215udAvKjPTVquH7pzH6lVJAlrOtHdfyHfr05hjGbN/bXXtknS15ufHGBp5wVrbBi
         u+QacvPAcMOrg==
Date:   Mon, 13 Feb 2023 22:40:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "naamax.meir@linux.intel.com" <naamax.meir@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tee.min.tan@linux.intel.com" <tee.min.tan@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
Subject: Re: [PATCH net-next v3] igc: offload queue max SDU from tc-taprio
Message-ID: <20230213224003.1af75612@kernel.org>
In-Reply-To: <SJ1PR11MB61801B3439A4F19C32ADE11BB8A29@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230208003327.29538-1-muhammad.husaini.zulkifli@intel.com>
        <20230208213019.460d7163@kernel.org>
        <SJ1PR11MB61801B3439A4F19C32ADE11BB8A29@SJ1PR11MB6180.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 06:27:17 +0000 Zulkifli, Muhammad Husaini wrote:
> > > +	if (tx_ring->max_sdu > 0) {
> > > +		max_sdu = tx_ring->max_sdu +
> > > +			  (skb_vlan_tagged(skb) ? VLAN_HLEN : 0);
> > > +
> > > +		if (skb->len > max_sdu)  
> > 
> > You should increment some counter here. Otherwise it's a silent discard.  
> 
> I am thinking to use tx_dropped counters for this. Is it ok?

Yup!

> > > +			goto skb_drop;
> > > +	}
> > > +
> > >  	if (!tx_ring->launchtime_enable)
> > >  		goto done;
> > >
> > > @@ -1606,6 +1615,11 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,  
> > >  	dev_kfree_skb_any(first->skb);  
> > 
> > first->skb is skb, as far as I can tell, you can reshuffle this code to
> > avoid adding the new return flow.  
> 
> What we try to do is to check the current max_sdu size at the
> beginning stage of the func() and drop it quickly.

I understand, what I'm saying is that the code which is already here
can be reused, it currently operates on first->skb but it can as well
use skb. And then you'll be able to jump to the same statement, rather
than have to create a separate return.
