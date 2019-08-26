Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19A9D44E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbfHZQp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:45:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbfHZQp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 12:45:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D924081127;
        Mon, 26 Aug 2019 16:45:56 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7D585D704;
        Mon, 26 Aug 2019 16:45:43 +0000 (UTC)
Date:   Mon, 26 Aug 2019 18:45:42 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Akshat Kakkar <akshat.1984@gmail.com>
Cc:     brouer@redhat.com, Cong Wang <xiyou.wangcong@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
Message-ID: <20190826184542.4d61b609@carbon>
In-Reply-To: <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
        <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
        <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
        <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
        <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 26 Aug 2019 16:45:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Aug 2019 00:34:33 +0530
Akshat Kakkar <akshat.1984@gmail.com> wrote:

> My goal is not just to make as many classes as possible, but also to
> use them to do rate limiting per ip per server. Say, I have a list of
> 10000 IPs and more than 100 servers. So simply if I want few IPs to
> get speed of says 1Mbps per server but others say speed of 2 Mbps per
> server. How can I achieve this without having 10000 x 100 classes.
> These numbers can be large than this and hence I am looking for a
> generic solution to this.

As Eric Dumazet also points out indirectly, you will be creating a huge
bottleneck for SMP/multi-core CPUs.  As your HTB root qdisc is a
serialization point for all egress traffic, that all CPUs will need to
take a lock on.

It sounds like your use-case is not global rate limiting, but instead
the goal is to rate limit customers or services (to something
significantly lower than NIC link speed).  To get scalability, in this
case, you can instead use the MQ qdisc (as Eric also points out).
I have an example script here[1], that shows how to setup MQ as root
qdisc and add HTB leafs based on how many TX-queue the interface have
via /sys/class/net/$DEV/queues/tx-*/

[1] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/bin/tc_mq_htb_setup_example.sh


You are not done, yet.  For solving the TX-queue locking congestion, the
traffic needs to be redirected to the appropriate/correct TX CPUs. This
can either be done with RSS (Receive Side Scaling) HW ethtool
adjustment (reduce hash to IPs L3 only), or RPS (Receive Packet
Steering), or with XDP cpumap redirect.

The XDP cpumap redirect feature is implemented with XDP+TC BPF code
here[2]. Notice, that XPS can screw with this so there is a XPS disable
script here[3].


[2] https://github.com/xdp-project/xdp-cpumap-tc
[3] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/bin/xps_setup.sh

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
