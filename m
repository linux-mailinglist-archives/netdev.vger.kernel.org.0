Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792C7577FF6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiGRKmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiGRKmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:42:22 -0400
X-Greylist: delayed 119 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 03:42:20 PDT
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7611EAEC;
        Mon, 18 Jul 2022 03:42:20 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc11a.ko.seznam.cz (email-smtpc11a.ko.seznam.cz [10.53.11.75])
        id 15060301f1aad03f14dba26f;
        Mon, 18 Jul 2022 12:42:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1658140939; bh=v3TCeBdThVJ4g/0p6MORvWuzDihnfViRg2oFUU1uZgY=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-szn-frgn:X-szn-frgc;
        b=oIn6Nl3cHUPsMweXFdKhvf3JrXhzOpsgCFHy6DSJswr6LRpZOI9B8URTbMlYEWOlN
         jFOK5AeoHMZRbjWT8nFEocLlAkpIphlqybxLIHVEOMK4jfxvD7aE/ZTNKMIS+x8IWI
         0GPXVyM6f4QAUZyixkYeeENE+8Qp8scCTh0R5e2k=
Received: from hopium (2a02:8308:900d:2400:7457:3d0c:d80:5888 [2a02:8308:900d:2400:7457:3d0c:d80:5888])
        by email-relay1.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Mon, 18 Jul 2022 12:40:04 +0200 (CEST)  
Date:   Mon, 18 Jul 2022 12:40:03 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Martin Jerabek <martin.jerabek01@gmail.com>
Subject: Re: [PATCH] can: xilinx_can: add support for RX timestamps on Zynq
Message-ID: <20220718104003.GA35020@hopium>
References: <20220716120408.450405-1-matej.vasilevski@seznam.cz>
 <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
X-szn-frgn: <165438ee-cde6-4382-8844-9ee4e2117027>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:33:12AM +0200, Marc Kleine-Budde wrote:
> On 16.07.2022 14:04:09, Matej Vasilevski wrote:
> > This patch adds support for hardware RX timestamps from Xilinx Zynq CAN
> > controllers. The timestamp is calculated against a timepoint reference
> > stored when the first CAN message is received.
> > 
> > When CAN bus traffic does not contain long idle pauses (so that
> > the clocks would drift by a multiple of the counter rollover time),
> > then the hardware timestamps provide precise relative time between
> > received messages. This can be used e.g. for latency testing.
> 
> Please make use of the existing cyclecounter/timecounter framework. Is
> there a way to read the current time from a register? If so, please
> setup a worker that does that regularly.
> 
> Have a look at the mcp251xfd driver as an example:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c

Hi Marc,

as Pavel have said, the counter register isn't readable.

I'll try to fit the timecounter/cyclecounter framework and send a v2
patch if it works well. Thanks for the suggestion, it didn't occur to me
that I can use it in this case as well.

Regards,
Matej
