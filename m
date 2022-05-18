Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6205152C1A2
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiERR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241011AbiERR1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A45F01D525F
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 10:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652894830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmvvdwRrKyc/34953549lLBDijrDi4M/HCBNuDxS9Bk=;
        b=Oaq6JJEbMpIiuAcsICatNN71tSpfgxUfRyhY4WLp0IsIpT/0orozcQKVOPt4X4sh9MeB1u
        n9eY1wsnJHqB/ur7HAuxmZw5ufcHHee1XfbAZask1d6Uqy2r4px+K6enPOPJoz78yTEF1h
        bNOtwxsYI5dvPG2OuYoVbH+Vb3pOx7E=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-8OK-QCvxPQ-d_W1yMgtdSA-1; Wed, 18 May 2022 13:27:09 -0400
X-MC-Unique: 8OK-QCvxPQ-d_W1yMgtdSA-1
Received: by mail-qt1-f199.google.com with SMTP id d15-20020ac85d8f000000b002f3b3b7e0adso2134175qtx.20
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 10:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dmvvdwRrKyc/34953549lLBDijrDi4M/HCBNuDxS9Bk=;
        b=1JoXR3f1xHoPeG8j7QYg6QV2h2nRBY/ZU5ys/Rc06sQOGtT/cCBs/2T73cejekVfF1
         Cawd0QUlRrioN/dZqnDreAW6YBrptq0s+awMrsfjCI9xrqW1ZxLfKS3i3EH46pg4BmIm
         Ns4OUVXqWoRhVN8wS7KpBTi9NYVWbKRyq1ZBSMq02tZPHdxqabxJoO1HRWrWUjh3J8H3
         7QfofiGgdQDbjoWQH0vdfXGVxyEZKdTwgRFHnVwO1q/rv5IDkG0H+TskDrXUFAXtQdy1
         BpY1jwtbRbvFpPV4Atr+aqtnx4ubQ3k0T4ovkvy2IurGvUMoqR8O7aVIYvHS1qA1OPTc
         PVPQ==
X-Gm-Message-State: AOAM531rAjjJSD6P0cUDoyCL0c8IM/A3SsEb0xM4XPRefFX0t9lrRkfR
        AjfXqswKIpfV5iU1dHsv23NeqxhjvGGTJrhcoS/XsNANGRYG/rHMmdjnarxzn1M3nMG4/AkS60w
        S4sgQW6K0u4sH/4Kx
X-Received: by 2002:ac8:57d3:0:b0:2f3:acf2:7981 with SMTP id w19-20020ac857d3000000b002f3acf27981mr779485qta.81.1652894828710;
        Wed, 18 May 2022 10:27:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZqXgknugw1G2vcKg2b+168Csa0PRH3iAwqDWIPZSkmM3uHRDhxatx30DbYiuQqhOs85P03Q==
X-Received: by 2002:ac8:57d3:0:b0:2f3:acf2:7981 with SMTP id w19-20020ac857d3000000b002f3acf27981mr779464qta.81.1652894828327;
        Wed, 18 May 2022 10:27:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id fb6-20020a05622a480600b002f3d23cf87esm1754209qtb.27.2022.05.18.10.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:27:07 -0700 (PDT)
Message-ID: <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
Subject: Re: tg3 dropping packets at high packet rates
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "'mchan@broadcom.com'" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Date:   Wed, 18 May 2022 19:27:02 +0200
In-Reply-To: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-18 at 16:08 +0000, David Laight wrote:
> I'm trying to see why the tg3 driver is dropping a lot of
> receive packets.
> 
> (This driver is making my head hurt...)
> 
> I think that the rx_packets count (sum of rx_[umb]cast_packets)
> is all the packets, but a smaller number are actually processed
> by the tg3_rx()
> But none of the error counts get increased.
> 
> It is almost as if it has lost almost all the receive buffers.
> 
> If I read /sys/class/net/em2/statistics/rx_packets every second
> delaying with:
>   syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> about every 43 seconds I get a zero increment.
> This really doesn't help!

It looks like the tg3 driver fetches the H/W stats once per second. I
guess that if you fetch them with the same period and you are unlucky
you can read the same sample 2 consecutive time.

> I've put a count into tg3_rx() that seems to match what IP/UDP
> and the application see.
> 
> The traffic flow is pretty horrid (but could be worse).
> There are 8000 small UDP packets every 20ms.
> These are reasonably spread through the 20ms (not back to back).
> All the destination ports are different (8000 receiving sockets).
> (The receiving application handles this fine (now).)
> The packets come from two different systems.
> 
> Firstly RSS doesn't seem to work very well.
> With the current driver I think everything hits 2 rings.
> With the 3.10 RHEL driver it all ends up in one.
> 
> Anyway after a hint from Eric I enabled RPS.
> This offloads the IP and UDP processing enough to stop
> any of the cpu (only 40 of them) from reporting even 50% busy.
> 
> I've also increased the rx ring size to 2047.
> Changing the coalescing parameters seems to have no effect.
> 
> I think there should be 2047 receive buffers.
> So 4 interrupts every 20ms or 200/sec might be enough
> to receive all the frames.
> The actual interrupt rate (deltas on /proc/interrupts)
> is actual over 80000/sec.
> So it doesn't look as though the driver is ever processing
> many packets/interrupt.
> If the driver were getting behind I'd expect a smaller number
> of interrupts.

With RPS enabled packet processing for most packets (the ones stirred
to remote CPUs) is very cheap, as the skb are moved out of the NIC to a
per CPU queue and that's it.

In theory packets could be drepped before inserting them into the RPS
queue, if the latter grow to big, but that looks unlikely. You can try
raising netdev_max_backlog, just in case.


dropwatch (or perf record -ga -e skb:kfree_skb) should point you where
exactly the packets are dropped.

Cheers,

Paolo

