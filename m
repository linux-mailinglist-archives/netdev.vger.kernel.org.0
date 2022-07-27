Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFD7583209
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiG0Saw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239763AbiG0Sai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:30:38 -0400
X-Greylist: delayed 1154 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 10:28:47 PDT
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA0CC107291;
        Wed, 27 Jul 2022 10:28:47 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 6E70CFFCE8;
        Wed, 27 Jul 2022 17:28:46 +0000 (UTC)
Date:   Wed, 27 Jul 2022 19:28:39 +0200
From:   Max Staudt <max@enpas.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220727192839.707a3453.max@enpas.org>
In-Reply-To: <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
        <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
        <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 13:30:54 +0200
Marc Kleine-Budde <mkl@pengutronix.de> wrote:

> As far as I understand, setting the btr is an alternative way to set the
> bitrate, right? I don't like the idea of poking arbitrary values into a
> hardware from user space.

I agree with Marc here.

This is a modification across the whole stack, specific to a single
device, when there are ways around.


If I understand correctly, the CAN232 "S" command sets one of the fixed
bitrates, whereas "s" sets the two BTR registers. Now the question is,
what do BTR0/BTR1 mean, and what are they? If they are merely a divider
in a CAN controller's master clock, like in ELM327, then you could

  a) Calculate the BTR values from the bitrate userspace requests, or

  b) pre-calculate a huge table of possible bitrates and present them
     all to userspace. Sounds horrible, but that's what I did in can327,
     haha. Maybe I should have reigned them in a little, to the most
     useful values.

  c) just limit the bitrates to whatever seems most useful (like the
     "S" command's table), and let users complain if they really need
     something else. In the meantime, they are still free to slcand or
     minicom to their heart's content before attaching slcan, thanks to
     your backwards compatibility efforts.


In short, to me, this isn't a deal breaker for your patch series.


Max
