Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BCA5298A1
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 06:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiEQESP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 00:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiEQESO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 00:18:14 -0400
X-Greylist: delayed 348 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 21:18:13 PDT
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 687EA30564
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 21:18:13 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 53714FF9C4;
        Tue, 17 May 2022 04:12:24 +0000 (UTC)
Date:   Tue, 17 May 2022 06:12:21 +0200
From:   Max Staudt <max@enpas.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517061221.012e36d1.max@enpas.org>
In-Reply-To: <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
        <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
        <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
        <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 10:50:16 +0900
Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:

> My concern is: what would be the merrit? If we do not split, the users
> of slcan and v(x)can would have to load the can-dev module which will
> be slightly bloated for their use, but is this really an issue? I do
> not see how this can become a performance bottleneck, so what is the
> problem?
> I could also argue that most of the devices do not depend on
> rx-offload.o. So should we also split this one out of can-dev on the
> same basis and add another module dependency?
> The benefit (not having to load a bloated module for three drivers)
> does not outweigh the added complexity: all hardware modules will have
> one additional modprobe dependency on the tiny can-skb module.
> 
> But as said above, I am not fully opposed to the split, I am just
> strongly divided. If we go for the split, creating a can-skb module is
> the natural and only option I see.
> If the above argument does not convince you, I will send a v3 with
> that split.

I originally replied to PATCHv2 in agreement with what Vincent said in
the first part - I agree that simply moving this code into can-dev and
making v(x)can/slcan depend on it is the straightforward thing to do.

Having yet another kernel module for a tiny bit of code adds more
unnecessary complexity IMHO. And from a user perspective, it seems
fairly natural to have can-dev loaded any time some can0, slcan0,
vcan0, etc. pops up.

Finally, embedded applications that are truly short on memory are
likely using a "real" CAN adapter, and hence already have can-dev
loaded anyway.

I think it's okay to just move it to can-dev and call it a day :)


Max
