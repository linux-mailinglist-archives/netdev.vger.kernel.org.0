Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E755340D0
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 17:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242053AbiEYP4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 11:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiEYP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 11:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADDB56403
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73C58B81E01
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 15:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3231C385B8;
        Wed, 25 May 2022 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653494209;
        bh=0+HUi+IFDiQ26ybqE0FlUH5uZzCJ6EvlyaBxjqOe+io=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iYav1lqrDA+60Z66RtB4MmkLB0cBZFlnFmyI5YeIUOdS+jmg3qtK4I3o5LUyVBer8
         /nWByyuq6fSsVZ+KBcCWXEOQwfN5yIhGvJYzOKl5Go9a66DkLjfuVKFyrenVacHxIh
         HZvAOLaxQsE6YCrcEVzZqCWtc+lFSlhE5cVtI/dywL/6W277809Mhqw8I2N7yiBxpc
         PQz1v/nBAUqwZSmkSCEaqv+zRyMLvBOpxidYdI5+ur0UBPI9nkLicIGqPhjuL+YaEF
         0fPlt0qdCYWvHZnzz+jl2L7EfOWqs+JnN9cVLfG9UUjNiBDWEtaY8EP7Mu9VNvoFPH
         dc7qSeGfQLMiw==
Date:   Wed, 25 May 2022 08:56:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Pavan Chebbi' <pavan.chebbi@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: Re: tg3 dropping packets at high packet rates
Message-ID: <20220525085647.6dfb7ed0@kernel.org>
In-Reply-To: <3bbe3c3762c44ffa932101092117853c@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
        <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
        <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
        <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
        <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
        <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
        <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
        <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
        <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
        <CALs4sv2M+9N1joECMQrOGKHQ_YjMqzeF1gPD_OBQ2_r+SJwOwQ@mail.gmail.com>
        <1bc5053ef6f349989b42117eda7d2515@AcuMS.aculab.com>
        <ae631eefb45947ac84cfe0468d0b7508@AcuMS.aculab.com>
        <9119f62fadaa4342a34882cac835c8b0@AcuMS.aculab.com>
        <CALs4sv13Y7CoMvrYm2c58vP6FKyK+_qrSp2UBCv0MURTAkv8hg@mail.gmail.com>
        <71de7bfbb0854449bce509d67e9cf58c@AcuMS.aculab.com>
        <3bbe3c3762c44ffa932101092117853c@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 07:28:42 +0000 David Laight wrote:
> > As the trace below shows I think the underlying problem
> > is that the napi callbacks aren't being made in a timely manner.  
> 
> Further investigations have shown that this is actually
> a generic problem with the way napi callbacks are called
> from the softint handler.
> 
> The underlying problem is the effect of this code
> in __do_softirq().
> 
>         pending = local_softirq_pending();
>         if (pending) {
>                 if (time_before(jiffies, end) && !need_resched() &&
>                     --max_restart)
>                         goto restart;
> 
>                 wakeup_softirqd();
>         }
> 
> The napi processing can loop through here and needs to do
> the 'goto restart' - not doing so will drop packets.
> The need_resched() test is particularly troublesome.
> I've also had to increase the limit for 'max_restart' from
> its (hard coded) 10 to 1000 (100 isn't enough).
> I'm not sure whether I'm hitting the jiffies limit,
> but that is hard coded at 2.
> 
> I'm going to start another thread.

If you share the core between the application and NAPI try using prefer
busy polling (SO_PREFER_BUSY_POLL), and manage polling from user space.
If you have separate cores use threaded NAPI and isolate the core
running NAPI or give it high prio.

YMMV but I've spent more time than I'd like to admit looking at the
softirq yielding conditions, they are hard to beat :( If you control
the app much better use of your time to arrange busy poll or pin things.
