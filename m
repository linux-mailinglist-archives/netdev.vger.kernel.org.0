Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2160663A5E1
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiK1KQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiK1KQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:16:28 -0500
Received: from fritzc.com (mail.fritzc.com [IPv6:2a00:17d8:100::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E4A13E35;
        Mon, 28 Nov 2022 02:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fritzc.com;
        s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JGFyuaNpearh4I2bkKpI3Yx2+bxxpkCL2JVRRmilW+M=; b=IEmONJxAPPyIdo+IxEmTA2iS8t
        FNntZqbM6YxPJtgwAFsuhkxNjZsfCEoDiwYyXLkng/f+jLhWFk2wEUhc90F2uXeGLOOnkoFQUSrzi
        qunS5i5HnqySi9KjBws1E3bIY8ahh/z7UlT51WccrgBb3jYlidt8rxs+SyrFDSjZFsyY=;
Received: from 127.0.0.1
        by fritzc.com with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim latest)
        (envelope-from <christoph.fritz@hexdev.de>)
        id 1ozbBH-000ZNN-IW; Mon, 28 Nov 2022 11:16:11 +0100
Date:   Mon, 28 Nov 2022 11:16:05 +0100
From:   Christoph Fritz <christoph.fritz@hexdev.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
Message-ID: <Y4SKZb9woV5XE1bU@mars>
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
 <58a773bd-0db4-bade-f8a2-46e850df9b0b@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <58a773bd-0db4-bade-f8a2-46e850df9b0b@hartkopp.net>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oliver

> are you already aware of this LIN project that uses the Linux SocketCAN
> infrastructure and implements the LIN protocol based on a serial tty
> adaption (which the serial LIN protocol mainly is)?
> 
> https://github.com/lin-bus

Sure, that's why I initially added Pavel Pisa to the recipients of this
RFC patch series. When there is an internal kernel API for LIN, his
sllin (tty-line-discipline driver for LIN) could be adjusted and finally
go mainline.

Adding LIN only as a tty-line-discipline does not fit all the currently
available hardware. Another argument against a tty-line-discipline only
approach as a LIN-API is, that there is no off the shelf standard
computer UART with LIN-break-detection (necessary to meet timing
constraints), so it always needs specially crafted hardware like USB
adapters or PCIe-cards.

For the handful of specialized embedded UARTs with LIN-break-detection I
guess it could make more sense to go the RS485-kind-of-path and
integrate LIN support into the tty-driver while not using a
tty-line-discipline there at all.

> IIRC the implementation of the master/slave timings was the biggest

Currently sllin only supports master mode, I guess because of the tight
timing constraints.

> challenge and your approach seems to offload this problem to your
> USB-attached hardware right?

The hexLIN USB adapter processes slave mode answer table on its own,
just to meet timing constraints.  For master mode, it is currently not
offloaded (but could be if really necessary).

The amount of offloading (if any at all) is totally up to the device and
its device-driver (the entity actually processing data). So sllin does
not do offloading but can only work in relaxed timing constrained
environments.
An UART with built in LIN-break-detection (there are a few) might be
able to fully meet timing constraints without offloading (as well as
e.g. a PCIe card).

> Can I assume there will be a similar CAN-controlled programming interface to
> create real time master/slave protocol frames like in a usual CAN/LIN
> adapter (e.g. https://www.peak-system.com/PCAN-LIN.213.0.html) ??

I already did some tests letting hexLIN and PCAN talk to each other in a
real time manner. Please see my preliminary PDF docu at
https://hexdev.de/hexlin/

Thanks
 -- Christoph
