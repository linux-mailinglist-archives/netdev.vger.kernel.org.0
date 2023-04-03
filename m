Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C086D501F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjDCSSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjDCSSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:18:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEAF1721
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680545848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/rfmodWFBVfCapod+Yy8BSvN2F8ZpaZqSxQWO1LJnCc=;
        b=HZY7bIcH2BUFQozID7T4UU4J4uXNEdjJ1bRf3i6DysXXfi6JYdFIpJ8VDR24b5+s/7U/Ss
        mqQSvToP1TH+Ju9d7k8RCTBM9gQ485IUUegONHVwUJCqu4FVHYDE18rjP/wEAVZNX3gYxI
        tPxdM+RpE6WDTaQzaiALUTCmGB4Vtcc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-HPXt6YG9NTibw_RxOvyQKw-1; Mon, 03 Apr 2023 14:17:25 -0400
X-MC-Unique: HPXt6YG9NTibw_RxOvyQKw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 154713C0ED53;
        Mon,  3 Apr 2023 18:17:25 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C42B3492C13;
        Mon,  3 Apr 2023 18:17:24 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 72418A80CED; Mon,  3 Apr 2023 20:17:23 +0200 (CEST)
Date:   Mon, 3 Apr 2023 20:17:23 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: publish actual MTU restriction
Message-ID: <ZCsYM4Q8fUWYyS6n@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092344.268981-1-vinschen@redhat.com>
 <20230331215208.66d867ff@kernel.org>
 <ZCqYbMOEg9LvgcWZ@calimero.vinschen.de>
 <20230403093011.27545760@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230403093011.27545760@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr  3 09:30, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 11:12:12 +0200 Corinna Vinschen wrote:
> > > Are any users depending on the advertised values being exactly right?  
> > 
> > The max MTU is advertised per interface:
> > 
> > p -d link show dev enp0s29f1
> > 2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >     link/ether [...] promiscuity 0 minmtu 46 maxmtu 9000 [...]
> > 
> > So the idea is surely that the user can check it and then set the MTU
> > accordingly.  If the interface claims a max MTU of 9000, the expectation
> > is that setting the MTU to this value just works, right?
> > 
> > So isn't it better if the interface only claims what it actually supports,
> > i. .e, 
> > 
> >   # ip -d link show dev enp0s29f1
> >   2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >       link/ether [...] promiscuity 0 minmtu 46 maxmtu 4096 [...]
> > 
> > ?
> 
> No doubt that it's better to be more precise.
> 
> The question is what about drivers which can't support full MTU with
> certain features enabled. So far nobody has been updating the max MTU
> dynamically, to my knowledge, so the max MTU value is the static max
> under best conditions.

Yeah, I agree, but what this code does *is* to set the max MTU to the
best possible value.

In all(*) drivers using the stmmac core, the max MTU is restricted by
the size of a single TX queue per the code in stmmac_change_mtu().

You can change the number of queues within the limits of the HW
dynamically, but the size of the queues is not configurable.  The size
of the queues is determined at probe time, typically as tx_fifo_size,
a HW feature, divided by the max number of queues.  Or, in dwmac-intel.c,
simply set to the constant value 4096.

(*) Noticable exception is dwmac-mediatek, which doesn't support jumbo
    frames and sets max mtu to ETH_DATA_LEN.

> > > > +	/* stmmac_change_mtu restricts MTU to queue size.
> > > > +	 * Set maxmtu accordingly, if it hasn't been set from DT.
> > > > +	 */
> > > > +	if (priv->plat->maxmtu == 0) {
> > > > +		priv->plat->maxmtu = priv->plat->tx_fifo_size ?:
> > > > +				     priv->dma_cap.tx_fifo_size;
> > > > +		priv->plat->maxmtu /= priv->plat->tx_queues_to_use;  
> > > 
> > > tx_queues_to_use may change due to reconfiguration, no?
> > > What will happen then?  
> > 
> > Nothing.  tx_fifo_size is tx_queues_to_use multiplied by the size of the
> > queue.  All the above code does is to compute the size of the queues,
> > which is a fixed value limiting the size of the MTU.  It's the same
> > check the stmmac_change_mtu() function performs to allow or deny the MTU
> > change, basically:
> > 
> >   txfifosz = priv->plat->tx_fifo_size;
> >   if (txfifosz == 0)
> >     txfifosz = priv->dma_cap.tx_fifo_size;
> >   txfifosz /= priv->plat->tx_queues_to_use;
> >   if (txfifosz < new_mtu)
> >     return -EINVAL;
> 
> I haven't looked at the code in detail but if we start with
> tx_queues_to_use = 4 and lower it via ethtool -L, won't that
> make the core prevent setting higher MTU even tho the driver
> would have supported it previously?

No.  See the code snippet from stmmac_change_mtu() above.  Max MTU is
*not* restricted by the number of queues, but by the non-configurable
size of a single queue.

After probe, you can potentially change the number of queues, but not
the size of the queues.


Corinna

