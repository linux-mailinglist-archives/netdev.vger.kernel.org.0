Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE252AC3E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbiEQTuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352878AbiEQTtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:49:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0878C522F4;
        Tue, 17 May 2022 12:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BEAFCE1C2E;
        Tue, 17 May 2022 19:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1404CC385B8;
        Tue, 17 May 2022 19:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652816984;
        bh=8Vh3M3tm6VPH+uYWWUnPKertgAz3IANS4NLNGdL1+T8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rMfmaF2jqEP0GdDSmMJD2CPlj+To9i/T2Xu8ZBxkWHjrDNWqtZYWCoQBadeYN7YXT
         zgyBNmsvHdujCCuYROcukp7F6NFBaxSAIL9qKCD4cp5uw3lnBtAR/Oq8lLZ+jS9dGG
         xBZius/+AV4S4LaRFK373WxecrquyxpkExVMaf7WH/7ovnFhHtIIqSQWi+OO69Oqeb
         eFvA2X/unEYHoJ7uDs0ALCr5tI8q0e9RETyvxkdmHtqmp3uIo4oPpQaKLFMPjXPURr
         EaadW/+4jADSbKYLKZ5RHVhippxWeOZIwxRuJPQsSq1qGRRW+2q05hrGhl9FbtIrNO
         U/I2zsmiBCUNg==
Date:   Tue, 17 May 2022 12:49:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        edumazet@google.com, Paolo Abeni <pabeni@redhat.com>,
        johannes@sipsolutions.net, Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
Message-ID: <20220517124942.7e89216a@kernel.org>
In-Reply-To: <CAK-6q+jRDMDGbNS2JkTXmW2dp6D7mGzZ6ghrjf7m-wp7Xo9weQ@mail.gmail.com>
References: <20220516215638.1787257-1-kuba@kernel.org>
        <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
        <CAK-6q+jRDMDGbNS2JkTXmW2dp6D7mGzZ6ghrjf7m-wp7Xo9weQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 15:33:02 -0400 Alexander Aring wrote:
> > Could not we move to an union of pointers in the future since in many
> > cases a network device can only have one of those pointers at any given
> > time?  
> 
> note that ieee802154 has also functionality like __dev_get_by_index()
> and checks via "if (netdev->ieee802154_ptr)" if it's a wpan interface
> or not, guess the solution would be like it's done in wireless then.


Ack, but that code must live somewhere under

#if IS_ENABLED(CONFIG_IEEE802154) || IS_ENABLED(CONFIG_6LOWPAN)

otherwise I think I'd see a build failure. I guess a nice thing about
having the typed pointers is that we can depend on the compiler for
basic checking :)
