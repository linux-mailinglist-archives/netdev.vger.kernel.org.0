Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B396C4F8C7E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiDHCvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 22:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiDHCvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 22:51:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95CB1945DF
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 19:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4031AB82816
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 02:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D7BC385A0;
        Fri,  8 Apr 2022 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649386140;
        bh=MoTQZqWDRmP60IMR3gk1tvBf4pwyjG0fN9vCUUQXZpg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WUSCjrtM2yniH6HNZyuC26xa7axjkpyVjG9HQ9H5faUYHwXUCVQ5G63l+9wnjxbjq
         H4bUqgChCeqqDrgDCMLJiAp7m0frf9MVrd9yy1VD0H6eKeOWWfAb8QRohwaoA8eEzm
         JxtYCa1sw+Mzo+H7nQhjI5Xs1rbDSso/F0t9lhYRQ1CtUDsDfAZnDcVI6D0G95QvFU
         w5Gc8NrhauOT4syIzMnjP6cMckI8qne8F/edsdKcuKxq9x5fGvHNPEN/z298P/q8lI
         x5wSCymS5TQJnVSVTUnoiok4bpdEeTI09L6dKKUUecooRiUuXWiyQBpu1bt9RTioLV
         lSYfslMZbIBiw==
Date:   Thu, 7 Apr 2022 19:48:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Dave Jones <davej@codemonkey.org.uk>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH] decouple llc/bridge
Message-ID: <20220407194859.1e897edf@kernel.org>
In-Reply-To: <20220407091640.1551b9d4@hermes.local>
References: <20220407151217.GA8736@codemonkey.org.uk>
        <20220407091640.1551b9d4@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 09:16:40 -0700 Stephen Hemminger wrote:
> > I was wondering why the llc code was getting compiled and it turned out
> > to be because I had bridging enabled. It turns out to only needs it for
> > a single function (llc_mac_hdr_init).

> > +static inline int llc_mac_hdr_init(struct sk_buff *skb,
> > +				   const unsigned char *sa, const unsigned char *da)
> > +{
> > +	int rc = -EINVAL;
> > +
> > +	switch (skb->dev->type) {
> > +	case ARPHRD_ETHER:
> > +	case ARPHRD_LOOPBACK:
> > +		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
> > +				     skb->len);
> > +		if (rc > 0)
> > +			rc = 0;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	return rc;
> > +}
> > +
> >  

nit: extra new line

> > -int llc_mac_hdr_init(struct sk_buff *skb,
> > -		     const unsigned char *sa, const unsigned char *da)
> > -{
> > -	int rc = -EINVAL;
> > -
> > -	switch (skb->dev->type) {
> > -	case ARPHRD_ETHER:
> > -	case ARPHRD_LOOPBACK:
> > -		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
> > -				     skb->len);
> > -		if (rc > 0)
> > -			rc = 0;
> > -		break;
> > -	default:
> > -		break;
> > -	}
> > -	return rc;
> > -}

There's also an EXPORT somewhere in this file that has to go.

> >  /**
> >   *	llc_build_and_send_ui_pkt - unitdata request interface for upper layers
> >   *	@sap: sap to use  
> 
> You may break other uses of LLC.
> 
> Why not open code as different function.  I used the llc stuff because there
> were multiple copies of same code (DRY).

I didn't quite get what you mean, Stephen, would you mind restating?
