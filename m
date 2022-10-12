Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526895FCD5B
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJLVhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJLVhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:37:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B96D77C4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tim9rEQovX6T6UzqF63T26njejkMcsPkCgv7fvDKtLI=; b=g79HXpaL2Kic9Br5UNM70YskfK
        8Vn9fXio1V8EctxQNggXdWuOP/M38l8WE2a7KbYHUJztSs/278jSy+sC8g4msMFXRsqAVLPkItISV
        GGn1lRs/zzjcTwAQUFru3i9dhxlXm+cNmAHqHZ4GD0kSp1sslK+TFoi87qfOoApVxvC4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oijQ6-001pvX-8E; Wed, 12 Oct 2022 23:37:42 +0200
Date:   Wed, 12 Oct 2022 23:37:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Message-ID: <Y0czpmTJlIVXd78u@lunn.ch>
References: <20221012153737.128424-1-saproj@gmail.com>
 <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +     const unsigned int length = ftmac100_rxdes_frame_length(rxdes);
> >
> > Do you need to read this value this early in the function?
> > Looks like it is only used when overlong packets are reported.
> 
> I decided to make a variable in order to use it twice:
> in the condition: "length > 1518"
> in logging: "netdev_info(netdev, "rx frame too long (%u)\n", length);"
> You are right saying it is not needed in most cases. Can we hope for
> the optimizer to postpone the initialization of 'length' till it is
> accessed?

Unlikely, since it is accessing a descriptor, and probably using
memory barriers. It is hard for the compiler to differ that until
needed.

But you could look at the .lst file, and it should be pretty obvious
if it has deferred it.

make driver/net/foo/bar.lst

should i think generate what you need.

   Andrew
