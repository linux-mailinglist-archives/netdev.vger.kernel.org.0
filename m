Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00FC64C6EC
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiLNKPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiLNKPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:15:38 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571DAA8;
        Wed, 14 Dec 2022 02:15:37 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so6632862pjr.3;
        Wed, 14 Dec 2022 02:15:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6oKCe6FlnGVIrrL38oYuOUwNAzfDStCwEdUL/iWCuNk=;
        b=k8Z+r54fnjtP/41GuAvlsUhW+jjQVn9MIFpagWD4cGEm1wsQm5uEseSepqJwxYJeS1
         RhN3UGxK6+HNYy6qsBVgHl/SGNWIc3c5C0UFTJMm2mWhSGEJaWsdFgJFpqF5ECqqatJJ
         OXumTcuZz4F0/v8Lk/x7usQUo79oxlRS2rKY5mLbvQ17Km4ZRSxAzLSnSXQ/sPo+3GgD
         KMswVe93r66oVbKmXqp6BBZgfssHFXf0JJT3qeSWm1iIo4W5PgNjOPluBN541guX94sr
         5D642ltEOQT0cU6dWUF6VEcxFJC1N2EpTKDKiALukyveqDrDD1jiL/rycTNts/quGAw7
         ymzw==
X-Gm-Message-State: AFqh2kqVJiIuaDZbNOkPuS2/1t+k+LP3TsXLTGFW6SeDEtCtQz/W6/UH
        boR2cAckf/BiWGcYhnEmNaHzuDQiPr44Kwvf5xdOoxr+ubc=
X-Google-Smtp-Source: AMrXdXvu1Fo97EmRMuM5KpH6sOZBGrZd+eZOC1yoLQpGgZ5AGaGDz9ZKCZbxJcekt7qottIorgyj4clLtqCXu7tBMow=
X-Received: by 2002:a17:90b:2741:b0:21c:bc8b:b080 with SMTP id
 qi1-20020a17090b274100b0021cbc8bb080mr216728pjb.19.1671012936773; Wed, 14 Dec
 2022 02:15:36 -0800 (PST)
MIME-Version: 1.0
References: <20221116205308.2996556-1-msp@baylibre.com> <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de> <20221214091406.g6vim5hvlkm34naf@blmsp>
 <20221214091820.geugui5ws3f7a5ng@pengutronix.de> <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
In-Reply-To: <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 14 Dec 2022 19:15:25 +0900
Message-ID: <CAMZ6RqLAZNj9dm_frbKExHK8AYDj9D0rX_9=c8_wk9kFrO-srw@mail.gmail.com>
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Markus Schneider-Pargmann <msp@baylibre.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 14 Dec. 2022 at 18:28, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 14.12.2022 10:18:20, Marc Kleine-Budde wrote:
> > On 14.12.2022 10:14:06, Markus Schneider-Pargmann wrote:
> > > Hi Marc,
> > >
> > > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > > Currently the driver waits to wakeup the queue until the interrupt for
> > > > > the transmit event is received and acknowledged. If we want to use the
> > > > > hardware FIFO, this is too late.
> > > > >
> > > > > Instead release the queue as soon as the transmit was transferred into
> > > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > > transferred.
> > > >
> > > > If you want to really speed up the TX path, remove the worker and use
> > > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> > > >
> > > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > > per SPI transfer.
> > >
> > > Just a quick question here, I mplemented a xmit_more() call and I am
> > > testing it right now, but it always returns false even under high
> > > pressure. The device has a txqueuelen set to 1000. Do I need to turn
> > > some other knob for this to work?

I was the first to use BQL in a CAN driver. It also took me time to
first figure out the existence of xmit_more() and even more to
understand how to make it so that it would return true.

> > AFAIK you need BQL support: see 0084e298acfe ("can: mcp251xfd: add BQL support").
> >
> > The etas_es58x driver implements xmit_more(), I added the Author Vincent
> > on Cc.
>
> Have a look at netdev_queue_set_dql_min_limit() in the etas driver.

The functions you need are the netdev_send_queue() and the
netdev_complete_queue():

  https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L3424

For CAN, you probably want to have a look to can_skb_get_frame_len().

  https://elixir.bootlin.com/linux/latest/source/include/linux/can/length.h#L166

The netdev_queue_set_dql_min_limit() gives hints by setting a minimum
value for BQL. It is optional (and as of today I am the only user of
it).


Yours sincerely,
Vincent Mailhol
