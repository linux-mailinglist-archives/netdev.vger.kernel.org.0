Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886B2755C6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfGYRbA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 13:31:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:29216 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbfGYRa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 13:30:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 10:30:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="369719789"
Received: from ellie.jf.intel.com (HELO ellie) ([10.24.14.188])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jul 2019 10:30:58 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     =?utf-8?Q?St=C3=A9phane?= Ancelot <sancelot@numalliance.com>,
        netdev@vger.kernel.org
Subject: Re: TSN - tc usage for a tbs setup
In-Reply-To: <43c8c7bd-f281-a4dc-badc-9672aaccbd6a@numalliance.com>
References: <43c8c7bd-f281-a4dc-badc-9672aaccbd6a@numalliance.com>
Date:   Thu, 25 Jul 2019 10:30:58 -0700
Message-ID: <87ef2ef2ct.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Stéphane Ancelot <sancelot@numalliance.com> writes:

> Hi,
>
> I am trying to setup my network queue for offline time based configuration.
>
> initial setup is :
>
> tc qdisc show dev eth1:
>
> qdisc mq 0: root
>
> qdisc pfifo_fast 0: parent :1 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 
> 1 1 1
>
>
> I won't need pfifo , I have to send one frame at a precise xmit time 
> (high prio), and then maybe some other frames (with low priority)
>
>
> I want to setup offload time based  xmit.
>
> /sbin/tc qdisc add dev eth1 root handle 100:1 etf delta 100000 clockid 
> CLOCK_REALTIME offload
>

Because the common (expected?) use case for ETF is using it on a system
that is running ptp4l (for example), and so, has the NIC PHC clock using
the TAI clock reference, we only accept the clockid to be CLOCK_TAI.
(Perhaps you are using an old version of iproute2, because a clearer
message should have been printed together with the error as well, anyway
there should be something in dmesg too)

That said, when I need to run some experiments with ETF, and do not care
about having the PHC clock is sync with anything else, I use phc2sys to
force the TAI offset to be zero. Something like this:

$ phc2sys -c $IFACE -s CLOCK_REALTIME -O 0 -m

And install ETF as "usual", something like this:

$ tc qdisc add dev $IFACE root handle 100:1 etf delta 100000 clockid CLOCK_TAI offload

Hope this helps.


Cheers,
--
Vinicius
