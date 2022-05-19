Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140C052D542
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbiESN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239471AbiESNz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:55:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77679EC331
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kp0f8QHVeH2LTclla3A6yuWzABAGd//1d08OAxYxpuE=; b=QUKMwFjRHrOPUpdYPELRCG0VmU
        YWpxwnYL9Ejv4Ut6aNKIRAZSbm3bRlXHnFjZtE7cAL8jMMrCQhgVJydPnjuOve8dWfJhTytPSGVJy
        OKI8W27mmk4/VcWqO0IIoQMZcLvKy8a5A6kts+qHdZp9OvzckbQ9YuyhUXn+hw4FQZMQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nrgby-003UWE-9i; Thu, 19 May 2022 15:54:42 +0200
Date:   Thu, 19 May 2022 15:54:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        'Pavan Chebbi' <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: Re: tg3 dropping packets at high packet rates
Message-ID: <YoZMInrha8Sux61Q@lunn.ch>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
 <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
 <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
 <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
 <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
 <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If the packet processing is 'bursty', you can have idle time and still
> hit now and the 'rx ring is [almost] full' condition. If pause frames
> are enabled, that will cause the peer to stop sending frames: drop can
> happen in the switch, and the local NIC will not notice (unless there
> are counters avaialble for pause frames sent).

You can control pause with ethtool

       ethtool -a|--show-pause devname

       ethtool -A|--pause devname [autoneg on|off] [rx on|off] [tx on|off]

But it depends on the driver implementing these options. So you might
want to try autoneg on, rx off, tx off, for testing.

ethtool should also show you want has been negotiated for pause, if
the driver has implemented that part of the ethtool API.

    Andrew
