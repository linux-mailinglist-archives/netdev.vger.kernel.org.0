Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F447624613
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiKJPiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKJPiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:38:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A27DDC;
        Thu, 10 Nov 2022 07:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/pAYNcF0zoVzPs0aZgiJJdzecZ78CCS2qwtQqBBQaio=; b=rLbuPSBvPQ5xAVhuXettb1PPqm
        EbLQ5HDwu7w/LGN0ZvUueuWUDeuTsO+OZR3PDEvCG+1BMdBk1FZ2B6JQmFvbz9RB66HbWuE91BKns
        PWxqvArWmge75FmWSbAF/7EanGHQfvAxMsxQjOBNxg3rf2izf3Oy9dYgbYBedupx6p3M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot9cb-0022sV-BT; Thu, 10 Nov 2022 16:37:41 +0100
Date:   Thu, 10 Nov 2022 16:37:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: Fix missing IPV6 #ifdef
Message-ID: <Y20axWysgRAwJsxc@lunn.ch>
References: <Y20A33ya17l/MqxU@lunn.ch>
 <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
 <3080953.1668089385@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3080953.1668089385@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 02:09:45PM +0000, David Howells wrote:
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > +#ifdef CONFIG_AF_RXRPC_IPV6
> > >  	return ipv6_icmp_error(sk, skb, err, port, info, payload);
> > > +#endif
> > 
> > Can this be if (IS_ENABLED(CONFIG_AF_RXRPC_IPV6) {} rather than
> > #ifdef? It gives better build testing.
> 
> Sure.  Does it actually make that much of a difference?  I guess the
> declaration is there even if IPV6 is disabled.

And that is the point. Even if this feature is disabled, the type
checking will be performed, the number of parameters etc. Somebody who
modifies ipv6_icmp_error() is going to find problems with a single
compilation, rather than having to use a big collection of random
configs.

So this is a review comment i often make. Avoid #ifdef if you can, use
IS_ENABLED() inside an if statement.

	Andrew
