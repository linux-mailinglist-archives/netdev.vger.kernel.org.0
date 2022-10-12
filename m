Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B10B5FC54E
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJLM36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJLM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:29:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ACB114F;
        Wed, 12 Oct 2022 05:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/5AR52X0TNzu+9Tf1HoiiB5UfdgRASn9FQlf5bRurJs=; b=Zsv5btHgK3RCJcX0cSLZh1FMQ6
        ITDqrocYHVBhqUCY9AQ7y0CaL68dwWVfJLcjYc/aZnFy0/uM+7PDdgagUk12UxoBGZHHspWXQ2hGG
        4v6sKcq5v8CZYIxbTYgutpvyz0f+IB1JkBiRWG6ratl7080axkwjA4NlFBf4DudfMfP8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiarW-001ng0-H5; Wed, 12 Oct 2022 14:29:26 +0200
Date:   Wed, 12 Oct 2022 14:29:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
Message-ID: <Y0azJlxthYXr7gMX@lunn.ch>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <Y0RqDd/P3XkrSzc3@lunn.ch>
 <63446da5.050a0220.92e81.d3fb@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63446da5.050a0220.92e81.d3fb@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 02:44:46PM +0200, Christian Marangi wrote:
> On Mon, Oct 10, 2022 at 08:53:01PM +0200, Andrew Lunn wrote:
> > >  /* Special struct emulating a Ethernet header */
> > >  struct qca_mgmt_ethhdr {
> > > -	u32 command;		/* command bit 31:0 */
> > > -	u32 seq;		/* seq 63:32 */
> > > -	u32 mdio_data;		/* first 4byte mdio */
> > > +	__le32 command;		/* command bit 31:0 */
> > > +	__le32 seq;		/* seq 63:32 */
> > > +	__le32 mdio_data;		/* first 4byte mdio */
> > >  	__be16 hdr;		/* qca hdr */
> > >  } __packed;
> > 
> > It looks odd that hdr is BE while the rest are LE. Did you check this?
> > 
> >    Andrew
> 
> Yes we did many test to analyze this and I just checked with some
> tcpdump that the hdr is BE everytime.

That might actual make sense. The comment says:

> > >  /* Special struct emulating a Ethernet header */

And hdr is where the Ether type would be, which is network endian,
i.e. big endian.

     Andrew
