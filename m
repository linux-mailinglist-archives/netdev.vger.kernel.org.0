Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C611DBE11
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgETThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETThf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:37:35 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B077C061A0E;
        Wed, 20 May 2020 12:37:35 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbUWe-0001Mp-BQ; Wed, 20 May 2020 21:37:12 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A319A100C99; Wed, 20 May 2020 21:37:11 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     stephen@networkplumber.org, a.darwish@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        paulmck@kernel.org, bigeasy@linutronix.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a seqcount
In-Reply-To: <20200519.195722.1091264300612213554.davem@davemloft.net>
Date:   Wed, 20 May 2020 21:37:11 +0200
Message-ID: <87wo56v1nc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 20 May 2020 01:42:30 +0200
>>> Please try, it isn't that hard..
>>>
>>> # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
>>>
>>> real	0m17.002s
>>> user	0m1.064s
>>> sys	0m0.375s
>> 
>> And that solves the incorrectness of the current code in which way?
>
> You mentioned that there wasn't a test case, he gave you one to try.

If it makes you happy to compare incorrrect code with correct code, here
you go:

5 runs of 1000 device add, 1000 device rename and 1000 device del

CONFIG_PREEMPT_NONE=y

         Base      rwsem
 add     0:05.01   0:05.28
	 0:05.93   0:06.11
	 0:06.52   0:06.26
	 0:06.06   0:05.74
	 0:05.71   0:06.07

 rename  0:32.57   0:33.04
	 0:32.91   0:32.45
	 0:32.72   0:32.53
	 0:39.65   0:34.18
	 0:34.52   0:32.50

 delete  3:48.65   3:48.91
	 3:49.66   3:49.13
	 3:45.29   3:48.26
	 3:47.56   3:46.60
	 3:50.01   3:48.06

 -------------------------

CONFIG_PREEMPT_VOLUNTARY=y

         Base      rwsem
 add     0:06.80   0:06.42
	 0:04.77   0:05.03
	 0:05.74   0:04.62
	 0:05.87   0:04.34
	 0:04.20   0:04.12

 rename  0:33.33   0:42.02
	 0:42.36   0:32.55
	 0:39.58   0:31.60
	 0:33.69   0:35.08
	 0:34.24   0:33.97

 delete  3:47.82   3:44.00
	 3:47.42   3:51.00
	 3:48.52   3:48.88
	 3:48.50   3:48.09
	 3:50.03   3:46.56

 -------------------------

CONFIG_PREEMPT=y

         Base      rwsem

 add     0:07.89   0:07.72
	 0:07.25   0:06.72
	 0:07.42   0:06.51
	 0:06.92   0:06.38
	 0:06.20   0:06.72

 rename  0:41.77   0:32.39
	 0:44.29   0:33.29
	 0:36.19   0:34.86
	 0:33.19   0:35.06
	 0:37.00   0:34.78

 delete  2:36.96   2:39.97
	 2:37.80   2:42.19
	 2:44.66   2:48.40
	 2:39.75   2:41.02
	 2:40.77   2:38.36

The runtime variation is rather large and when running the same in a VM
I got complete random numbers for both base and rwsem. The most amazing
was delete where the time varies from 30s to 6m20s.

Btw, Sebastian noticed that rename spams dmesg:

  netdev_info(dev, "renamed from %s\n", oldname);

which eats about 50% of the Rename run time.

         Base      netdev_info() removed

Rename   0:34.84   0:17.48

That number at least makes tons of sense

Thanks,

        tglx
