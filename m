Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D9E2496C2
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgHSHLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:11:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:59332 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgHSHIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 03:08:43 -0400
IronPort-SDR: Se8FeWK9kbDFM2wk1mnRyV6C2c916wuK0cvB1gQGmwePJbPQSseJB1MpOAvknDuWbzfssbXHNu
 T0jkmoBVj+bA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152677109"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="152677109"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:44:36 -0700
IronPort-SDR: UP/bWo7cvexJr+5xpiXGIF3K+sedaZKf06Sk9pZSmzsB1yW1Bjk6/gql68V9VKeg+yGI7Z06Xj
 mWiOzr0kjyfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="497126683"
Received: from skirillo-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.32.199])
  by fmsmga006.fm.intel.com with ESMTP; 18 Aug 2020 23:44:33 -0700
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIDAvMl0g?=
 =?UTF-8?Q?intel/xdp_fixes_for_fliping_rx_buffer?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
 <4268316b200049d58b9973ec4dc4725c@baidu.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <83e45ec2-1c66-59f6-e817-d4c523879007@intel.com>
Date:   Wed, 19 Aug 2020 08:44:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4268316b200049d58b9973ec4dc4725c@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-19 03:37, Li,Rongqing wrote:
[...]
 > Hi:
 >
 > Thanks for your explanation.
 >
 > But we can reproduce this bug
 >
 > We use ebpf to redirect only-Vxlan packets to non-zerocopy AF_XDP, 
First we see panic on tcp stack, in tcp_collapse: BUG_ON(offset < 0); it 
is very hard to reproduce.
 >
 > Then we use the scp to do test, and has lots of vxlan packet at the 
same time, scp will be broken frequently.
 >

Ok! Just so that I'm certain of your setup. You receive packets to an
i40e netdev where there's an XDP program. The program does XDP_PASS or
XDP_REDIRECT to e.g. devmap for non-vxlan packets. However, vxlan
packets are redirected to AF_XDP socket(s) in *copy-mode*. Am I
understanding that correct?

I'm assuming this is an x86-64 with 4k page size, right? :-) The page
flipping is a bit different if the PAGE_SIZE is not 4k.

 > With this fixes, scp has not been broken again, and kernel is not 
panic again
 >

Let's dig into your scenario.

Are you saying the following:

Page A:
+------------
| "first skb" ----> Rx HW ring entry X
+------------
| "second skb"----> Rx HW ring entry X+1 (or X+n)
+------------

This is a scenario that shouldn't be allowed, because there are now
two users of the page. If that's the case, the refcounting is
broken. Is that the case?

Check out i40e_can_reuse_rx_page(). The idea with page flipping/reuse
is that the page is only reused if there is only one user.

 > Seem your explanation is unable to solve my analysis:
 >
 >         1. first skb is not for xsk, and forwarded to another device
 >            or socket queue

The data for the "first skb" resides on a page:
A:
+------------
| "first skb"
+------------
| to be reused
+------------
refcount >>1

 >         2. seconds skb is for xsk, copy data to xsk memory, and page
 >            of skb->data is released

Note that page B != page A.

B:
+------------
| to be reused/or used by the stack
+------------
| "second skb for xsk"
+------------
refcount >>1

data is copied to socket, page_frag_free() is called, and the page
count is decreased. The driver will then check if the page can be
reused. If not, it's freed to the page allocator.

 >         3. rx_buff is reusable since only first skb is in it, but
 >            *_rx_buffer_flip will make that page_offset is set to
 >            first skb data

I'm having trouble grasping how this is possible. More than one user
implies that it wont be reused. If this is possible, the
recounting/reuse mechanism is broken, and that is what should be
fixed.

The AF_XDP redirect should not have semantics different from, say,
devmap redirect. It's just that the page_frag_free() is called earlier
for AF_XDP, instead of from i40e_clean_tx_irq() as the case for
devmap/XDP_TX.

 >         4. then reuse rx buffer, first skb which still is living
 >            will be corrupted.
 >
 >
 > The root cause is difference you said upper, so I only fixes for 
non-zerocopy AF_XDP
 >

I have only addressed non-zerocopy, so we're on the same page (pun
intended) here!


Björn

 > -Li
