Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2D45AE12
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 22:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhKWVNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 16:13:21 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:18995 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhKWVNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 16:13:20 -0500
X-Greylist: delayed 1658 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 16:13:20 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637701809;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=3oNYpWlA+i2uiKkkfogiuDtNFkcFf0oANh+xeOwrb4Q=;
    b=qpPptg68PmQcJGTTHkFIHzJ68m5ujWrGdwfHP2Te4J9IseNiAcuLvGm2SPLfnKnWaz
    0pBoIaXS6aOE9yfa9litHXm5r+uWv7MJBL9oM/DGAnNI0lrT9w4NieY+bNyI4AQF8Qc2
    DuOVjed5SZz3tgnT8Eup9nIEEitfRFSOp9JLV9KxtSQ72Co0JwCPtEuQdOX7gFtRmZqu
    m9BpDDfzEhIXFZKtMDiRVeUbdas+zYbo0yVImQ9k5qSQs0Nqdhc/6U4c+DBt6EfvKPp5
    w01tyAA2MR3bU17UGYcKrn8G+lIAa459tlQE6/v18sPNS5/UhRjWXRqd07oa049At1/Q
    +E8w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id a04d59xANLA86ap
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Nov 2021 22:10:08 +0100 (CET)
Subject: Re: [PATCH v1 0/2] fix statistics for CAN RTR and Error frames
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
References: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <bc682dbe-c74e-cd8a-ab05-78a6b4079ebf@hartkopp.net>
Date:   Tue, 23 Nov 2021 22:10:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.11.21 12:53, Vincent Mailhol wrote:
> There are two common errors which are made when reporting the CAN RX
> statistics:
> 
>    1. Incrementing the "normal" RX stats when receiving an Error
>    frame. Error frames is an abstraction of Socket CAN and does not
>    exist on the wire.
> 
>    2. Counting the length of the Remote Transmission Frames (RTR). The
>    length of an RTR frame is the length of the requested frame not the
>    actual payload. In reality the payload of an RTR frame is always 0
>    bytes long.
> 
> This patch series fix those two issues for all CAN drivers.
> 
> Vincent Mailhol (2):
>    can: do not increase rx statistics when receiving CAN error frames
>    can: do not increase rx_bytes statistics for RTR frames

I would suggest to upstream this change without bringing it to older 
(stable) trees.

It doesn't fix any substantial flaw which needs to be backported IMHO.

Btw. can you please change 'error frames' to 'error message frames'?

We had a discussion some years ago that the 'error frames' are used as 
term inside the CAN protocol.

Thanks,
Oliver


> 
>   drivers/net/can/at91_can.c                      |  9 ++-------
>   drivers/net/can/c_can/c_can_main.c              |  8 ++------
>   drivers/net/can/cc770/cc770.c                   |  6 ++----
>   drivers/net/can/dev/dev.c                       |  4 ----
>   drivers/net/can/dev/rx-offload.c                |  7 +++++--
>   drivers/net/can/grcan.c                         |  3 ++-
>   drivers/net/can/ifi_canfd/ifi_canfd.c           |  8 ++------
>   drivers/net/can/janz-ican3.c                    |  3 ++-
>   drivers/net/can/kvaser_pciefd.c                 |  8 ++------
>   drivers/net/can/m_can/m_can.c                   | 10 ++--------
>   drivers/net/can/mscan/mscan.c                   | 10 ++++++----
>   drivers/net/can/pch_can.c                       |  6 ++----
>   drivers/net/can/peak_canfd/peak_canfd.c         |  7 ++-----
>   drivers/net/can/rcar/rcar_can.c                 |  9 +++------
>   drivers/net/can/rcar/rcar_canfd.c               |  7 ++-----
>   drivers/net/can/sja1000/sja1000.c               |  5 ++---
>   drivers/net/can/slcan.c                         |  3 ++-
>   drivers/net/can/spi/hi311x.c                    |  3 ++-
>   drivers/net/can/spi/mcp251x.c                   |  3 ++-
>   drivers/net/can/sun4i_can.c                     | 10 ++++------
>   drivers/net/can/usb/ems_usb.c                   |  5 ++---
>   drivers/net/can/usb/esd_usb2.c                  |  5 ++---
>   drivers/net/can/usb/etas_es58x/es58x_core.c     |  7 -------
>   .../net/can/usb/kvaser_usb/kvaser_usb_core.c    |  2 --
>   .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c   | 14 ++++----------
>   .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c    |  7 ++-----
>   drivers/net/can/usb/mcba_usb.c                  |  3 ++-
>   drivers/net/can/usb/peak_usb/pcan_usb.c         |  5 ++---
>   drivers/net/can/usb/peak_usb/pcan_usb_fd.c      | 11 ++++-------
>   drivers/net/can/usb/peak_usb/pcan_usb_pro.c     | 11 +++++------
>   drivers/net/can/usb/ucan.c                      |  7 +++++--
>   drivers/net/can/usb/usb_8dev.c                  | 10 ++++------
>   drivers/net/can/xilinx_can.c                    | 17 ++++++-----------
>   33 files changed, 86 insertions(+), 147 deletions(-)
> 
