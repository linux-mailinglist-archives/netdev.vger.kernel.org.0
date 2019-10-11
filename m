Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC0D49D5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfJKV0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:26:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:42797 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfJKV0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 17:26:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 14:25:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,285,1566889200"; 
   d="scan'208";a="395873141"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 11 Oct 2019 14:25:59 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: taprio testing - Any help?
In-Reply-To: <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com> <87v9sv3uuf.fsf@linux.intel.com> <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
Date:   Fri, 11 Oct 2019 14:26:55 -0700
Message-ID: <87r23j3rds.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Murali Karicheri <m-karicheri2@ti.com> writes:

> Hi Vinicius,
>
> On 10/11/2019 04:12 PM, Vinicius Costa Gomes wrote:
>> Hi Murali,
>> 
>> Murali Karicheri <m-karicheri2@ti.com> writes:
>> 
>>> Hi,
>>>
>>> I am testing the taprio (802.1Q Time Aware Shaper) as part of my
>>> pre-work to implement taprio hw offload and test.
>>>
>>> I was able to configure tap prio on my board and looking to do
>>> some traffic test and wondering how to play with the tc command
>>> to direct traffic to a specfic queue. For example I have setup
>>> taprio to create 5 traffic classes as shows below;-
>>>
>>> Now I plan to create iperf streams to pass through different
>>> gates. Now how do I use tc filters to mark the packets to
>>> go through these gates/queues? I heard about skbedit action
>>> in tc filter to change the priority field of SKB to allow
>>> the above mapping to happen. Any example that some one can
>>> point me to?
>> 
>> What I have been using for testing these kinds of use cases (like iperf)
>> is to use an iptables rule to set the priority for some kinds of traffic.
>> 
>> Something like this:
>> 
>> sudo iptables -t mangle -A POSTROUTING -p udp --dport 7788 -j CLASSIFY --set-class 0:3
> Let me try this. Yes. This is what I was looking for. I was trying
> something like this and I was getting an error
>
> tc filter add  dev eth0 parent 100: protocol ip prio 10 u32 match ip 
> dport 10000 0xffff flowid 100:3
> RTNETLINK answers: Operation not supported
> We have an error talking to the kernel, -1

Hmm, taprio (or mqprio for that matter) doesn't support tc filter
blocks, so this won't work for those qdiscs.

I never thought about adding support for it, it looks very interesting.
Thanks for pointing this out. I will add this to my todo list, but
anyone should feel free to beat me to it :-)


Cheers,
--
Vinicius
