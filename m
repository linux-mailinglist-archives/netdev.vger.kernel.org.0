Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84EE63E26C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiK3VCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK3VC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:02:28 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E87383EA1;
        Wed, 30 Nov 2022 13:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669842144;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=rQjv0ilcgXlZxoUpB0HbLsfebMKlAgyw+Xw7AfTs1CU=;
    b=F+Xg1D4iYJLeyPuMtepW/NlzFi19PGjYOLvAuV5v5ibvfQFWiBvN5XFCApAbyJiP0f
    E2SMHt7yMtpalJrRvU9TeQCiBiDxpbC34zPl9vnnLs55IPg3PyCXhO0yw6zwGDPPUFiY
    PrSMMILsKv50mQsexLEt2jVnRSXebJdYkVGE+YQalEhi8eog5yEFlAG/fFmKMdJwphaI
    0ruPTifQ745nS2iT/ZMoE8KAAxAWKDtwBsfsEzphahNKuA7v2KBlyhh4kvAj+gZQIjLm
    bZz4+GHc5maLyci83b9C+oIaH+IwlGnc5Wd8kcbfRsEuGCVQ7+1H24XrKlb0K3vHlAci
    GsbA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yAUL2NYBv
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 30 Nov 2022 22:02:23 +0100 (CET)
Message-ID: <ed685ce0-16e2-3f7c-173a-ac14f32d9ca6@hartkopp.net>
Date:   Wed, 30 Nov 2022 22:02:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
Content-Language: en-US
To:     Christoph Fritz <christoph.fritz@hexdev.de>
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
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
 <58a773bd-0db4-bade-f8a2-46e850df9b0b@hartkopp.net> <Y4SKZb9woV5XE1bU@mars>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <Y4SKZb9woV5XE1bU@mars>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph, all,

On 28.11.22 11:16, Christoph Fritz wrote:

>> IIRC the implementation of the master/slave timings was the biggest
> 
> Currently sllin only supports master mode, I guess because of the tight
> timing constraints.

I think this has to be corrected.

In the master mode the SocketCAN Broadcast Manager (BCM) is configured 
to periodically send LIN headers
(according to LIN schedule table).

https://www.kernel.org/doc/html/latest/networking/can.html#broadcast-manager-protocol-sockets-sock-dgram

This is a very easy approach to precisely send the the LIN frames from 
kernel space and also atomically change the content of (all) the 
configured LIN frames while the schedule table is continuously processed.

Sending LIN frames directly from *userspace* (and handling timers there) 
was *never* intended for real LIN communication - although the examples 
(with cangen) in the document look like this.

Same applies to the slave mode:

If you check out 
https://raw.githubusercontent.com/wiki/lin-bus/linux-lin/sllin-doc.pdf 
on page 11 you are able to enable the slave mode with

	insmod ./sllin.ko master=0

The 'trick' about this mode is that the RTR-functionality of the BCM is 
able process the incoming CAN/LIN identifier and *instantly* send back 
some pre-defined data for that specific LIN-ID, so that the SLLIN driver 
sends/answers the 'data' section of the received LIN-ID within the 
required timing constrains for LIN slaves.

Not sure if the info about this concept got lost somehow, but the 
CAN_BCM is the key for handling the LIN protocol and offload the LIN 
scheduling (master/slave) to the kernel for the comparably dumb tty 
interfaces.

Best regards,
Oliver
