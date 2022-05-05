Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8AD51C259
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380580AbiEEOZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380562AbiEEOZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:25:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028225A59A;
        Thu,  5 May 2022 07:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nd7QNghQW8LARprbqtCzIE+R5+NJaXA4ski1ugmRTkM=; b=UhKdPC9O2krISj7KyPErZVIFze
        5Hdt9X/vLTlYnLknZvrGnD58ETP7dTx9tEwgEdk5WDeoLcd3CEpadGYa9djMVHVrCSCufHlvQc/tu
        w2bCfA1FKnpzjSNVFPgnUabDSDCRiuIsaHWt8xgivElTF1pdYmqdRQnwKtn2N+V0meR0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmcMc-001NCa-1K; Thu, 05 May 2022 16:21:54 +0200
Date:   Thu, 5 May 2022 16:21:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 07/11] leds: trigger: netdev: use mutex instead of
 spinlocks
Message-ID: <YnPdglC+QJ4Gw81C@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-8-ansuelsmth@gmail.com>
 <YnMj/SY8BhJuebFO@lunn.ch>
 <6273d126.1c69fb81.7d047.4a30@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6273d126.1c69fb81.7d047.4a30@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:29:09PM +0200, Ansuel Smith wrote:
> On Thu, May 05, 2022 at 03:10:21AM +0200, Andrew Lunn wrote:
> > > @@ -400,7 +400,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
> > >  
> > >  	cancel_delayed_work_sync(&trigger_data->work);
> > >  
> > > -	spin_lock_bh(&trigger_data->lock);
> > > +	mutex_lock(&trigger_data->lock);
> > 
> > I'm not sure you can convert a spin_lock_bh() in a mutex_lock().
> > 
> > Did you check this? What context is the notifier called in?
> > 
> >     Andrew
> 
> I had to do this because qca8k use completion to set the value and that
> can sleep... Mhhh any idea how to handle this?

First step is to define what the lock is protecting. Once you know
that, you should be able to see what you can do without actually
holding the lock.

Do you need the lock when actually setting the LED?

Or is the lock protecting state information inside trigger_data?

Can you make a copy of what you need from trigger_data while holding
the lock, release it and then set the LED?

Maybe a nested mutex and a spin lock? The spin lock protecting
trigger_data, and the mutex protecting setting the LED?

	      Andrew
