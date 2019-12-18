Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D012540B
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfLRVCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:02:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:6672 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfLRVCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 16:02:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:02:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="365859209"
Received: from unknown (HELO [10.241.98.36]) ([10.241.98.36])
  by orsmga004.jf.intel.com with ESMTP; 18 Dec 2019 13:02:51 -0800
Date:   Wed, 18 Dec 2019 13:02:51 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     David Miller <davem@davemloft.net>
cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next v3 07/11] tcp: Prevent coalesce/collapse when
 skb has MPTCP extensions
In-Reply-To: <20191218.124510.1971632024371398726.davem@davemloft.net>
Message-ID: <alpine.OSX.2.21.1912181251550.32925@mjmartin-mac01.local>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com> <20191217203807.12579-8-mathew.j.martineau@linux.intel.com> <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com> <20191218.124510.1971632024371398726.davem@davemloft.net>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 18 Dec 2019, David Miller wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 18 Dec 2019 11:50:24 -0800
>
>> On 12/17/19 12:38 PM, Mat Martineau wrote:
>>> The MPTCP extension data needs to be preserved as it passes through the
>>> TCP stack. Make sure that these skbs are not appended to others during
>>> coalesce or collapse, so the data remains associated with the payload of
>>> the given skb.
>>
>> This seems a very pessimistic change to me.
>>
>> Are you planing later to refine this limitation ?
>>
>> Surely if a sender sends TSO packet, we allow all the segments
>> being aggregated at receive side either by GRO or TCP coalescing.
>
> This turns off absolutely crucial functional elements of our TCP
> stack, and will avoid all of the machinery that avoids wastage in TCP
> packets sitting in the various queues.  skb->truesize management, etc.
>
> I will not apply these patches with such a non-trivial regression in
> place for MPTCP streams, sorry.
>

Ok, understood. Not every packet has this MPTCP extension data so 
coalescing was not always turned off, but given the importance of avoiding 
this memory waste I'll confirm GRO behavior and work on maintaining 
coalesce/collapse with identical MPTCP extension data.

--
Mat Martineau
Intel
