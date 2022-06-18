Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27255017C
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 02:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbiFRA4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 20:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiFRA4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 20:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AF76A425
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 17:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 521B2613F8
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 00:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE68C3411B;
        Sat, 18 Jun 2022 00:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655513759;
        bh=vMLksrSsMpCNh22fPgyLkvGBwszROQ+3h6L08cN1lKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sfupjHE+2qP6Czace3foAts/wjs/HFmVjML9SbOnFeY5htnzMaZa4OpmeE1iF7v8B
         z0ODhuEJ+d3xD9kPmV0MDzTF9ImVpKmJKtIIpTHQGj97IoHf3YdUuBKw5/c7Tu8pJm
         Hsw+/yG+Tceba150+MUroFrIg5bWz1o4P2WAytPJoYcS+u/0D01Cx1/hiSskYyd+D8
         ASilJAUXsAtwL12oUXjCCMk5hT1LxfHCkvTc0XpbgKOExk0BiEAjhQqnjayf45mIkl
         yNfmErkpFJkbebICnbCNho3yYo1rjrx62/J7xYpyUMrtL2XJeKngVx13vAPmPTJ0ur
         SRBxtr2ZwQDOA==
Date:   Fri, 17 Jun 2022 17:55:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
Message-ID: <20220617175550.6a3602ab@kernel.org>
In-Reply-To: <28607.1655512063@famine>
References: <9088.1655407590@famine>
        <20220617084535.6d687ed0@kernel.org>
        <5765.1655484175@famine>
        <20220617124413.6848c826@kernel.org>
        <28607.1655512063@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 17:27:43 -0700 Jay Vosburgh wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> >On Fri, 17 Jun 2022 09:42:55 -0700 Jay Vosburgh wrote:  
> >> 	In this case, it's to permit the bonding ARP / ND monitor to
> >> function if that software device (veth in this case) is added to a bond
> >> using the ARP / ND monitor (which relies on trans_start, and has done so
> >> since at least 2.6.0).  I'll agree it's a niche case; this was broken
> >> for veth for quite some time, but veth + netns is handy for software
> >> only test cases, so it seems worth doing.  
> >
> >I presume it needs it to check if the device has transmitted anything
> >in the last unit of time, can we look at the device stats for LLTX for
> >example?  
> 
> 	Yes, that's the use case.  
> 
> 	Hmm.  Polling the device stats would likely work for software
> devices, although the unit of time varies (some checks are fixed at one
> unit, but others can be N units depending on the missed_max option
> setting).
> 
> 	Polling hardware devices might not work; as I recall, some
> devices only update the statistics on timespans on the order of seconds,
> e.g., bnx2 and tg3 appear to update once per second.  But those do
> update trans_start.

Right, unfortunately.

> 	The question then becomes how to distinguish a software LLTX
> device from a hardware LLTX device.

If my way of thinking about trans_start is correct then we can test 
for presence of ndo_tx_timeout. Anything that has the tx_timeout NDO
must be maintaining trans_start.

> >> 	I didn't exhaustively check all LLTX drivers, but, e.g., tun
> >> does update trans_start:
> >> 
> >> drivers/net/tun.c:
> >> 
> >>        /* NETIF_F_LLTX requires to do our own update of trans_start */
> >>         queue = netdev_get_tx_queue(dev, txq);
> >>         txq_trans_cond_update(queue);  
> >
> >Well, it is _an_ example, but the only one I can find. And the
> >justification is the same as yours now -- make bonding work a31d27fb.
> >Because of that I don't think we can use tun as a proof that trans 
> >start should be updated on LLTX devices as a general, stack-wide rule.
> >There's a lot more LLTX devices than veth and tun.  
> 
> 	I'm not suggesting that all (software) LLTX software devices be
> updated.

The ones which are not updated would remain broken then, no?
Waiting for someone to try to bond them and discover it doesn't work.
