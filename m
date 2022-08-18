Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3CF598964
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345079AbiHRQvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345081AbiHRQvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:51:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B99C6FDC
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4hys+dHsvGKwimvP9q8wpRWR1CV0ec7am4TJ1PyleZM=;
        b=UZdcwIYSg9oxF0TD2DsgTciVuB4VtrDFJftdHV2I7K37/HQ6bQzS/f+fGxFfB1Sbpqn9oS
        MVnJG7PbFds+OscvUmfQqVWXZ/dGGNXGTQ6WdOMtP64idHvRANtQ2LgTKzvjk3kz04QEgk
        e7E+lqpSpM2mFV35JWHXyavB0jWBSZs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-iuYNNpz9O1O1vDpAWd8NUQ-1; Thu, 18 Aug 2022 12:51:29 -0400
X-MC-Unique: iuYNNpz9O1O1vDpAWd8NUQ-1
Received: by mail-wm1-f72.google.com with SMTP id j22-20020a05600c485600b003a5e4420552so2947433wmo.8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=4hys+dHsvGKwimvP9q8wpRWR1CV0ec7am4TJ1PyleZM=;
        b=GfJFLemoVGSbNywwZApSSAKIxkCh6JH/DEtP1Nf3XaPZlPRcvj3FG79xOdVJpSbVL5
         73REuvb72XQUhkaw6EWKFKUkpbKhJ0nfFW+ZHDC3/2TEF1SrTf+v+m5xiMNA74snV+Vr
         ANU2uJfTkw0ZQSFSZKJX20sD5BbcwfEWtS6PxGXbdMT2e/jhy2UlB19sU3NRhW4l42eT
         3w1wQMTd7XKn2Hip7bo2JPOLLZKX+IvlelzngFVa+dOYLadtKnXZBMm6a4Gw2GukyHeG
         zl+nTM7XqiWejo2BP0iQQqhcGN5ZX3GTecOu41kV8TaF7lQ7e80g0ttrbR0Kz4wTbFmc
         sH9g==
X-Gm-Message-State: ACgBeo2GTqqMi0JC0t21Knh7NiGnPYQOGWvfXOHxWtuVSdwKxEPE/Mmy
        maQ+/7t/4ukxQht94X0quqeW/obEQizs9cciKYE9uYzvMPjfbeyzx4QvgcvMk5TXUJNAvSjRCe8
        MqKtV6j51s92iNd06
X-Received: by 2002:a7b:cbd0:0:b0:3a6:9f6:a3e8 with SMTP id n16-20020a7bcbd0000000b003a609f6a3e8mr2416314wmi.13.1660841488562;
        Thu, 18 Aug 2022 09:51:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR42KLtH2wgObwY2XF2QCwFA4YZsXhbXH3Krxozkk5s4ActjOWw0Iol/UCx419LGdNcY8BX3xA==
X-Received: by 2002:a7b:cbd0:0:b0:3a6:9f6:a3e8 with SMTP id n16-20020a7bcbd0000000b003a609f6a3e8mr2416291wmi.13.1660841488411;
        Thu, 18 Aug 2022 09:51:28 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003a5fa79007fsm3034679wmq.7.2022.08.18.09.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:51:27 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v2 0/5] sched, net: NUMA-aware CPU spreading interface
In-Reply-To: <xhsmhzgg1a4dy.mognet@vschneid.remote.csb>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <9b062b28-e6dd-3af1-da02-1bc511ed6939@intel.com>
 <xhsmhzgg1a4dy.mognet@vschneid.remote.csb>
Date:   Thu, 18 Aug 2022 17:51:26 +0100
Message-ID: <xhsmhwnb5a41d.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/22 17:43, Valentin Schneider wrote:
> On 18/08/22 09:28, Jesse Brandeburg wrote:
>> On 8/17/2022 10:58 AM, Valentin Schneider wrote:
>>> Hi folks,
>>>
>>> Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
>>> from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
>>> it).
>>>
>>> The proposed interface involved an array of CPUs and a temporary cpumask, and
>>> being my difficult self what I'm proposing here is an interface that doesn't
>>> require any temporary storage other than some stack variables (at the cost of
>>> one wild macro).
>>>
>>> Patch 5/5 is just there to showcase how the thing would be used. If this doesn't
>>> get hated on, I'll let Tariq pick this up and push it with his networking driver
>>> changes (with actual changelogs).
>>
>> I am interested in this work, but it seems that at least on lore and in
>> my inbox, patch 3,4,5 didn't show up.
>
> I used exactly the same git send-email command for this than for v1 (which
> shows up in its entirety on lore), but I can't see these either. I'm going
> to assume they got lost and will resend them.

Welp, it's there now, but clearly should've used --no-thread when resending
them :/

