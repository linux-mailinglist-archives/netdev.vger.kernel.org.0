Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172344FBC6A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346200AbiDKMvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiDKMvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:51:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78AA2DD59
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kKLGMLlVNuVgQVkSQC2KcKbtlnbyuo4zd1ug0YlFBvQ=; b=bgicx/iXI/KRfkqOExqWBIMRbT
        CTriPHB5VZZ5f8J9I6i3nthBR2Ws8K21SUJ5+H58pqO5llthDJSj+/fd7T4s5ARKO/PgEIlF9a3KJ
        Rnz1ifhN0OQHV8LG3JnPLlMIVfl5qX8VfywNhqQWuIRcml2Crd/l9Ch+pESWRv/jUPA0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ndtTz-00FG2q-6V; Mon, 11 Apr 2022 14:49:27 +0200
Date:   Mon, 11 Apr 2022 14:49:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlQj11JOHOYB+f62@lunn.ch>
References: <cover.1649528984.git.lorenzo@kernel.org>
 <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
 <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com>
 <YlQe8QysuyGRtxAx@lore-desk>
 <CAC_iWj+fk4hkpBQE6SnusVHFJMoq3u40Hn2VK7uCmUADXM2MPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_iWj+fk4hkpBQE6SnusVHFJMoq3u40Hn2VK7uCmUADXM2MPQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:34:21PM +0300, Ilias Apalodimas wrote:
> On Mon, 11 Apr 2022 at 15:28, Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > > Hi Lorenzo,
> >
> > Hi Ilias,
> >
> > >
> > > [...]
> > >
> > > >
> > > >         for_each_possible_cpu(cpu) {
> > > >                 const struct page_pool_recycle_stats *pcpu =
> > > > @@ -66,6 +87,47 @@ bool page_pool_get_stats(struct page_pool *pool,
> > > >         return true;
> > > >  }
> > > >  EXPORT_SYMBOL(page_pool_get_stats);
> > > > +
> > > > +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> > > > +{
> > > > +       int i;
> > > > +
> > > > +       for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> > > > +               memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
> > > > +               data += ETH_GSTRING_LEN;
> > > > +       }
> > > > +
> > > > +       return data;
> > >
> > > Is there a point returning data here or can we make this a void?
> >
> > it is to add the capability to add more strings in the driver code after
> > running page_pool_ethtool_stats_get_strings.
> 
> But the current driver isn't using it.

It could be you need it for the mlx5 driver, which puts the TLS
counters after the page pool counters. Or you could just move them to
the end. I don't think the order of statistics are ABI, just the
strings themselves..

> I don't have too much
> experience with how drivers consume ethtool stats, but would it make
> more sense to return a length instead of a pointer? Maybe Andrew has
> an idea.

Either is acceptable. Even if you do make it a void, the driver can
use the stats_get_count() and do the maths. But a length or a pointer
is simpler.

   Andrew
