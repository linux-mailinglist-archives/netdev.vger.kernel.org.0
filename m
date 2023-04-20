Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327006E8845
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjDTCt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjDTCtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:49:25 -0400
X-Greylist: delayed 53466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 19:49:16 PDT
Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CED5240
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:49:16 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681958955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WA6UVK8dj8ldPfIV6BLeh8Vlm+ePhRuqvYfYMkiPMtU=;
        b=IJoj2c66qQk0/sYbblqDvvKQuDn9sR4DCai/lySCGbLZPoWyGmiFefLjWtkd4FWX0OI+Go
        byo2+QMSBf3x1U/JVWt4W2AvD6Cyf01dieW0MaAKseWf+6YxvZtI/uU4Pvd3tjJc4rYTm1
        VwCF8nSZwi/8K7M7IprGNu/YopYtdLg=
Date:   Thu, 20 Apr 2023 02:49:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Yajun Deng" <yajun.deng@linux.dev>
Message-ID: <38876115ff2bd4756eca5d8d8f93a48e@linux.dev>
Subject: Re: [PATCH] net: sched: print jiffies when transmit queue time
 out
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CANn89iJeiEk_Rcoh0odfjK2ocP23HQfOPDhJJ7p_=Q--A2jHJg@mail.gmail.com>
References: <CANn89iJeiEk_Rcoh0odfjK2ocP23HQfOPDhJJ7p_=Q--A2jHJg@mail.gmail.com>
 <20230419115632.738730-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

April 19, 2023 8:02 PM, "Eric Dumazet" <edumazet@google.com> wrote:=0A=0A=
> On Wed, Apr 19, 2023 at 1:56 PM Yajun Deng <yajun.deng@linux.dev> wrote=
:=0A> =0A>> Although there is watchdog_timeo to let users know when the t=
ransmit queue=0A>> begin stall, but dev_watchdog() is called with an inte=
rval. The jiffies=0A>> will always be greater than watchdog_timeo.=0A>> =
=0A>> To let users know the exact time the stall started, print jiffies w=
hen=0A>> the transmit queue time out.=0A>> =0A>> Signed-off-by: Yajun Den=
g <yajun.deng@linux.dev>=0A>> ---=0A>> =0A>> atomic_long_inc(&txq->trans_=
timeout);=0A>> break;=0A>> }=0A>> @@ -522,8 +522,9 @@ static void dev_wat=
chdog(struct timer_list *t)=0A>> =0A>> if (unlikely(some_queue_timedout))=
 {=0A>> trace_net_dev_xmit_timeout(dev, i);=0A>> - WARN_ONCE(1, KERN_INFO=
 "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",=0A>> - dev->n=
ame, netdev_drivername(dev), i);=0A>> + WARN_ONCE(1, KERN_INFO "NETDEV WA=
TCHDOG: %s (%s): \=0A>> + transmit queue %u timed out %lu jiffies\n",=0A>=
> + dev->name, netdev_drivername(dev), i, some_queue_timedout);=0A> =0A> =
If we really want this, I suggest we export a time in ms units, using=0A>=
 jiffies_to_msecs()=0A=0AOK.
