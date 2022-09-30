Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC65F0E74
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiI3PI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiI3PIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:08:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5F912385E
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664550503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ThgIMG5jXzsQN6twWFk4fVY0qmWrtHR2kq3lK3VY7c=;
        b=Xwv/4Fd4v92qXD9NDbbPLEEg/MWjDlahDnvSGoY9uNaEa8ADdvTxwFotIK5l/jvQaRKVoo
        VrGwpLe+ZiOB1VTziBLLTEbZ53A/NOjKJBXM8RLj9M3Uar8RVTKru1uDWO0dpeWZhytgim
        lkXf72RFkdaT23MoyD/Mmd1Al2WCLRU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-1mLrxDRLOE6_xpyYaI2RYQ-1; Fri, 30 Sep 2022 11:08:22 -0400
X-MC-Unique: 1mLrxDRLOE6_xpyYaI2RYQ-1
Received: by mail-wm1-f72.google.com with SMTP id 62-20020a1c0241000000b003b4922046e5so2202564wmc.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1ThgIMG5jXzsQN6twWFk4fVY0qmWrtHR2kq3lK3VY7c=;
        b=bqTjpp0P4OEGGhxHPMwgxtcGyQZS9JNHO4IvKhN3Odx4BjEcikPUwV96fM8QK2h4df
         XgFYZSpeVlEGg820VGUihvOO6j66RcxZpOTx6/cGGZuffwq7qDuyHK1dnstcCpcalzed
         lhMI8EiIa7xAVR2ArGkFMMeEbssBr7TDV93JyxtVoKTIGk3GBi7MgculZkrZsIHNh7U7
         lVmIUVk0gnfAGfbVzllXzly8Qu+fYy/O0lQNsL4mHC/htjWZfMBzscyFrR4iH6YMGmX+
         v727s8einHGZWLNmi2oI9MZS9SA3b3mlDH2YbuWDSafDK0eWCa1mbQXrgEThmRCLaFY7
         JDoA==
X-Gm-Message-State: ACrzQf1DqSjn5PzzfXDBhKajn9ZiQULi4nobU2DlyC5RnOhIwoHBazqI
        mreLmIePFXRknApFx0w1Qx72ejOVNCUKYys+5bO8YLHpVI+8pL4O4wb9phUBKCJFSJacrNq/fH+
        oogZtJ680tMHodK86
X-Received: by 2002:adf:eb83:0:b0:22c:f295:19a5 with SMTP id t3-20020adfeb83000000b0022cf29519a5mr2641081wrn.457.1664550501553;
        Fri, 30 Sep 2022 08:08:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5BtSGsnizcOAB9rv7VtThs8g0EBWhTN2l0qiqwUhqzDeB7hdtfsgspZw4zPNevNAoKLojONw==
X-Received: by 2002:adf:eb83:0:b0:22c:f295:19a5 with SMTP id t3-20020adfeb83000000b0022cf29519a5mr2641064wrn.457.1664550501363;
        Fri, 30 Sep 2022 08:08:21 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bv7-20020a0560001f0700b0022cdbc76b1bsm2123278wrb.82.2022.09.30.08.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 08:08:20 -0700 (PDT)
Date:   Fri, 30 Sep 2022 17:08:18 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220930150818.GC10057@localhost.localdomain>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
 <20220930141048.GA10057@localhost.localdomain>
 <20220930144752.GA8349@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930144752.GA8349@breakpoint.cc>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 04:47:52PM +0200, Florian Westphal wrote:
> Guillaume Nault <gnault@redhat.com> wrote:
> > On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> > > diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> > > index 8970d0b4faeb..1d7e520d9966 100644
> > > --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> > > +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> > > @@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
> > >  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
> > >  		lookup_flags |= RT6_LOOKUP_F_IFACE;
> > >  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> > > +	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
> > > +		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
> > > +		fl6->flowi6_oif = dev->ifindex;
> > >  	}
> > 
> > I'm not very familiar with nft code, but it seems dev can be NULL here,
> > so netif_is_l3_master() can dereference a NULL pointer.
> 
> No, this should never be NULL, NFTA_FIB_F_IIF is restricted to
> input/prerouting chains.

Thanks, I didn't realise that.

> > Shouldn't we test dev in the 'else if' condition?
> 
> We could do that in case it makes review easier.

Then if it's just to help reviewers, a small comment should be enough.

