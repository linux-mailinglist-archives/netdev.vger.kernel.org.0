Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43899517F04
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 09:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiECHim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 03:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiECHim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 03:38:42 -0400
X-Greylist: delayed 455 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 May 2022 00:35:09 PDT
Received: from mx-8.mail.web4u.cz (smtp7.web4u.cz [81.91.87.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF737A1E;
        Tue,  3 May 2022 00:35:09 -0700 (PDT)
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id B6BA32014EF;
        Tue,  3 May 2022 09:27:29 +0200 (CEST)
Received: from baree.pikron.com (unknown [94.112.11.73])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id 59E03201258;
        Tue,  3 May 2022 09:27:29 +0200 (CEST)
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual rules and documentation linking
Date:   Tue, 3 May 2022 09:27:15 +0200
User-Agent: KMail/1.9.10
Cc:     Andrew Dennison <andrew.dennison@motec.com.au>,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz> <CAHQrW0_bxDyTf7pNHgXwcO=-0YRWtsxscOSWWU4fDmNYo8d-9Q@mail.gmail.com> <20220503064626.lcc7nl3rze5txive@pengutronix.de>
In-Reply-To: <20220503064626.lcc7nl3rze5txive@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202205030927.15558.pisa@cmp.felk.cvut.cz>
X-W4U-Auth: 3f689dcfd3550b7b0bcf9e525c23dbe5a6645c9e
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc and Andrew,

On Tuesday 03 of May 2022 08:46:26 Marc Kleine-Budde wrote:
> On 03.05.2022 16:32:32, Andrew Dennison wrote:
> > > > When value is configurable then for (uncommon) number
> > > > of buffers which is not power of two, there will be likely
> > > > a problem with way how buffers queue is implemented
> >
> > Only power of 2 makes sense to me: I didn't consider those corner
> > cases but the driver could just round down to the next power of 2 and
> > warn about a misconfiguration of the IP core.
>
> +1

Then (n-1) mask be used instead of modulo which is what I used for these
kind of queues.

https://sourceforge.net/p/ulan/ulut/ci/master/tree/ulut/ul_dqfifo.h

> > I added the dynamic detection because the IP core default had changed
> > to 2 TX buffers and this broke some hard coded assumptions in the
> > driver in a rather obscure way that had me debugging for a bit...
>
> The mainline driver uses a hard coded default of 4 still... Can you
> provide that patch soonish?

We discuss with Ondrej Ille final location of the bits with queue
length information etc... The version 3.0 of the core is in development
still. So I do not like to introduce something which would break
compatability with future revisions. Yes, we can check for version
reported by IP core but when it is possible I would not introduce
such logic... So if it gets to 5.19 it would be great but if we should
risk incompatible changes or too cluttered logic then it will be
5.20 material. Other option is to add Kconfig option to specify
maximal number of TX buffers used by the driver for now.

> > > You can make use of more TX buffers, if you implement (fully
> > > hardware based) TX IRQ coalescing (== handle more than one TX
> > > complete interrupt at a time) like in the mcp251xfd driver, or BQL
> > > support (== send more than one TX CAN frame at a time). I've played
> > > a bit with BQL support on the mcp251xfd driver (which is attached by
> > > SPI), but with mixed results. Probably an issue with proper
> > > configuration.
> >
> > Reducing CAN IRQ load would be good.
>
> IRQ coalescing comes at the price of increased latency, but if you have
> a timeout in hardware you can configure the latencies precisely.

HW coalescing not considered yet. Generally my intention for CAN use
is usually robotic and motion control and there is CAN and even CAN FD
on edge with its latencies already and SocketCAN layer adds yet
another level due common tasklets and threads with other often
dense and complex protocols on ETHERNET so to lover CPU load
by IRQ coalescing is not my priority. We have done latencies
evaluation of SocketCAN, LinCAN and RTEMS years ago on Oliver Hartkopp's
requests on standard and fully-preemptive kernels on more targets
(x86, PowerPC, ...) and I hope that we revive CAN Bench project
on Xilinx Zynq based MZ_APO again, see Martin Jerabek's theses FPGA
Based CAN Bus Channels Mutual Latency Tester and Evaluation, 2016

https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/wikis/uploads/56b4d27d8f81ae390fc98bdce803398f/F3-BP-2016-Jerabek-Martin-Jerabek-thesis-2016.pdf

It is actual work of Matej Vasilevski. So I hope to have again more
insight into latencies on CAN. By the way, I plan to speak with
Carsten Emde on Embedded World if these is interrest to add
continuous HW timestamping based CAN latencies testing into OSADL
QA Farm

https://www.osadl.org/OSADL-QA-Farm-Real-time.linux-real-time.0.html

Other option is to setup system and run it locally at CTU
as we run complete CI on CTU CAN FD.

> > > > We need 2 * priv->ntxbufs range to distinguish empty and full
> > > > queue... But modulo is not nice either so I probably come with
> > > > some other solution in a longer term. In the long term, I want to
> > > > implement virtual queues to allow multiqueue to use dynamic Tx
> > > > priority of up to 8 the buffers...
> > >
> > > ACK, multiqueue TX support would be nice for things like the
> > > Earliest TX Time First scheduler (ETF). 1 TX queue for ETF, the
> > > other for bulk messages.
> >
> > Would be nice, I have multi-queue in the CAN layer I wrote for a
> > little RTOS (predates socketcan) and have used for a while.
>
> Out of interest:
> What are the use cases? How did you decide which queue to use?

For example for CAN open there should be at least three queues
to prevent CAN Tx priority inversion. one for NMT (network
management), one for PDO (process data objects) and least priority
for SDO (service data objects). That such applications works
somehow with single queue is only matter of luck and low
level of the link bandwidth utilization.

We have done research how to use Linux networking infrastructure
to route application send CAN messages into multiple queues
according to the CAN ID priorities. There are some results in mainline
from that work

Rostislav Lisovy 2014: can: Propagate SO_PRIORITY of raw sockets to skbs
Rostislav Lisovy 2012: net: em_canid: Ematch rule to match CAN frames 
according to their identifiers

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/em_canid.c

So some enhancements and testing in this direction belongs
between my long horizon goals. But low priority now because
my company and even studnets at university are paid from
other projects (silicon-heaven, ESA, Bluetooth-monitoring,
NuttX etc.) so Linux CAN is hobby only at this moment.
But others have contracts for CTU CAN FD, Skoda Auto
testers etc. there...

Best wishes,

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home
