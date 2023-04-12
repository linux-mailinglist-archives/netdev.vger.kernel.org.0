Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E36DE94C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 04:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDLCHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 22:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDLCHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 22:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A2644B9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 19:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B72862D24
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 02:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F02C433D2;
        Wed, 12 Apr 2023 02:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681265237;
        bh=ckwPkhXHkT7UNVsOpK7qXguqPhN7si4yvJYpBFy+sls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LNwxHCrl+yDQQuA97G1tE+cN0zJg0GFriLkZC+elKYRPuSkgmKE7IRgecx5s6QOUB
         lbn8eBbSPKsuily8q7VirzAz7NfKnf8lUnQCYOG3uSrmFql9Xo5uRIPN/VA2uiKBA8
         r4pQLjlTkxno3AbFCY2MtabFtkZ2/RgkeK2DqIHKdXxI9Ug6s5FjuW3SrpZPeIb5Ps
         7FmFStQ48HQ/6IFm5NH6/B7yaY0sMh1hzRgufCOcFs2pjj4VMNiBwBc8pijSEGd4Kd
         5OvlnxkudwKgSt5Udi4oN1dHHcZPqHskmStsfC41Jd8XQaW6v3dorxh/sUmEXSQD90
         ilADqqA2LrYqA==
Date:   Tue, 11 Apr 2023 19:07:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc:     robert.hancock@calian.com, Nicolas.Ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, tomas.melin@vaisala.com
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
Message-ID: <20230411190715.6eefb4fa@kernel.org>
In-Reply-To: <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
        <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Apr 2023 23:33:48 +0200 Ingo Rohloff wrote:
> Analysis:
> Commit 404cd086f29e867f ("net: macb: Allocate valid memory for TX and RX BD
> prefetch") mentions:
> 
>     GEM version in ZynqMP and most versions greater than r1p07 supports
>     TX and RX BD prefetch. The number of BDs that can be prefetched is a
>     HW configurable parameter. For ZynqMP, this parameter is 4.
> 
> I think what happens is this:
> Example Scenario (SW == linux kernel, HW == cadence ethernet IP).
> 1) SW has written TX descriptors 0..7
> 2) HW is currently transmitting TX descriptor 6.
>    HW has already prefetched TX descriptors 6,7,8,9.
> 3) SW writes TX descriptor 8 (clearing TX_USED)
> 4) SW writes the TSTART bit.
>    HW ignores this, because it is still transmitting.
> 5) HW transmits TX descriptor 7.
> 6) HW reaches descriptor 8; because this descriptor
>    has already been prefetched, HW sees a non-active
>    descriptor (TX_USED set) and stops transmitting.

This sounds broken, any idea if this is how the IP is supposed to work
or it may be an integration issue in Zynq?  The other side of this
question is how expensive the workaround is - a spin lock and two extra
register reads on completion seems like a lot.

Roman, Lars, have you seen Tx stalls on your macb setups?
