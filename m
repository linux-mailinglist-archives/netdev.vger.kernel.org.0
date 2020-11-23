Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B53A2C0568
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgKWMVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 07:21:02 -0500
Received: from mga12.intel.com ([192.55.52.136]:39192 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgKWMVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 07:21:02 -0500
IronPort-SDR: Zz1w8plttsWbmKxb9QAE8+yiizj52Rn/ml6NWfxMjoix6bYTz7Ppjhq6kZXQ9MhGcTy9NrtXqG
 pXE3sKUyBMcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="151013964"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="151013964"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 04:20:58 -0800
IronPort-SDR: 22iTex5m9S/kk/mkkh0WkOsIP6fsqtcXP2dqrFoD/SVlO+duLAoxPnmdpsQcfNMAOcs773bhkG
 TNsUZiYG0Dnw==
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="546391854"
Received: from gcavallu-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.119])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 04:20:53 -0800
Subject: Re: [PATCH bpf-next v2 0/5] selftests/bpf: xsk selftests
To:     Yonghong Song <yhs@fb.com>,
        Weqaar Janjua <weqaar.janjua@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        magnus.karlsson@gmail.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <586d63b4-1828-f633-a4ff-88e4e23d164a@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8b7cccf1-9845-fd9a-6f6b-bc70b9b3f9b1@intel.com>
Date:   Mon, 23 Nov 2020 13:20:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <586d63b4-1828-f633-a4ff-88e4e23d164a@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-21 01:31, Yonghong Song wrote:
> 
> 
> On 11/20/20 5:00 AM, Weqaar Janjua wrote:
>> This patch set adds AF_XDP selftests based on veth to selftests/bpf.
>>
>> # Topology:
>> # ---------
>> #                 -----------
>> #               _ | Process | _
>> #              /  -----------  \
>> #             /        |        \
>> #            /         |         \
>> #      -----------     |     -----------
>> #      | Thread1 |     |     | Thread2 |
>> #      -----------     |     -----------
>> #           |          |          |
>> #      -----------     |     -----------
>> #      |  xskX   |     |     |  xskY   |
>> #      -----------     |     -----------
>> #           |          |          |
>> #      -----------     |     ----------
>> #      |  vethX  | --------- |  vethY |
>> #      -----------   peer    ----------
>> #           |          |          |
>> #      namespaceX      |     namespaceY
>>
>> These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
>> Ethernet interfaces.
>>
>> The test program contains two threads, each thread is single socket with
>> a unique UMEM. It validates in-order packet delivery and packet content
>> by sending packets to each other.
>>
>> Prerequisites setup by script test_xsk_prerequisites.sh:
>>
>>     Set up veth interfaces as per the topology shown ^^:
>>     * setup two veth interfaces and one namespace
>>     ** veth<xxxx> in root namespace
>>     ** veth<yyyy> in af_xdp<xxxx> namespace
>>     ** namespace af_xdp<xxxx>
>>     * create a spec file veth.spec that includes this run-time 
>> configuration
>>       that is read by test scripts - filenames prefixed with test_xsk_
>>     *** xxxx and yyyy are randomly generated 4 digit numbers used to 
>> avoid
>>         conflict with any existing interface
>>
>> The following tests are provided:
>>
>> 1. AF_XDP SKB mode
>>     Generic mode XDP is driver independent, used when the driver does
>>     not have support for XDP. Works on any netdevice using sockets and
>>     generic XDP path. XDP hook from netif_receive_skb().
>>     a. nopoll - soft-irq processing
>>     b. poll - using poll() syscall
>>     c. Socket Teardown
>>        Create a Tx and a Rx socket, Tx from one socket, Rx on another.
>>        Destroy both sockets, then repeat multiple times. Only nopoll mode
>>       is used
>>     d. Bi-directional Sockets
>>        Configure sockets as bi-directional tx/rx sockets, sets up fill
>>       and completion rings on each socket, tx/rx in both directions.
>>       Only nopoll mode is used
>>
>> 2. AF_XDP DRV/Native mode
>>     Works on any netdevice with XDP_REDIRECT support, driver dependent.
>>     Processes packets before SKB allocation. Provides better performance
>>     than SKB. Driver hook available just after DMA of buffer descriptor.
>>     a. nopoll
>>     b. poll
>>     c. Socket Teardown
>>     d. Bi-directional Sockets
>>     * Only copy mode is supported because veth does not currently support
>>       zero-copy mode
>>
>> Total tests: 8
>>
>> Flow:
>> * Single process spawns two threads: Tx and Rx
>> * Each of these two threads attach to a veth interface within their
>>    assigned namespaces
>> * Each thread creates one AF_XDP socket connected to a unique umem
>>    for each veth interface
>> * Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
>> * Rx thread verifies if all 10k packets were received and delivered
>>    in-order, and have the right content
>>
>> v2 changes:
>> * Move selftests/xsk to selftests/bpf
>> * Remove Makefiles under selftests/xsk, and utilize 
>> selftests/bpf/Makefile
>>
>> Structure of the patch set:
>>
>> Patch 1: This patch adds XSK Selftests framework under selftests/bpf
>> Patch 2: Adds tests: SKB poll and nopoll mode, and mac-ip-udp debug
>> Patch 3: Adds tests: DRV poll and nopoll mode
>> Patch 4: Adds tests: SKB and DRV Socket Teardown
>> Patch 5: Adds tests: SKB and DRV Bi-directional Sockets
> 
> I just want to report that after applying the above 5 patches
> on top of bpf-next commit 450d060e8f75 ("bpftool: Add {i,d}tlb_misses 
> support for bpftool profile"), I hit the following error with below 
> command sequences:
> 
>   $ ./test_xsk_prerequisites.sh
>   $ ./test_xsk_skb_poll.sh
> # Interface found: ve1480
> # Interface found: ve9258
> # NS switched: af_xdp9258
> 1..1
> # Interface [ve9258] vector [Rx]
> # Interface [ve1480] vector [Tx]
> # Sending 10000 packets on interface ve1480
> [  331.741244] ------------[ cut here ]------------
> [  331.741741] kernel BUG at net/core/skbuff.c:1621!
> [  331.742265] invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [  331.742837] CPU: 0 PID: 1883 Comm: xdpxceiver Not tainted 5.10.0-rc3+ 
> #1037
> [  331.743468] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 1.9.3
> -1.el7.centos 04/01/2014
> [  331.744300] RIP: 0010:pskb_expand_head+0x27b/0x310

Ugh, looks like the tests are working. :-P

This is a BUG_ON(skb_shared(skb)) trigger, related to the skbuff 
refcount changes done recently in AF_XDP.

I'll cook a patch! Thanks for the report!


Björn
