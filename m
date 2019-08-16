Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0EC8FAE3
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfHPGZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:25:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:34135 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfHPGZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 02:25:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 23:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,391,1559545200"; 
   d="scan'208";a="182095397"
Received: from samudral-mobl1.amr.corp.intel.com (HELO [10.251.21.3]) ([10.251.21.3])
  by orsmga006.jf.intel.com with ESMTP; 15 Aug 2019 23:25:55 -0700
Subject: Re: [PATCH bpf-next 0/5] Add support for SKIP_BPF flag for AF_XDP
 sockets
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        tom.herbert@intel.com
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
 <20190815122844.52eeda08@cakuba.netronome.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <f9df4d0e-c5f2-036d-994c-3162274820ea@intel.com>
Date:   Thu, 15 Aug 2019 23:25:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815122844.52eeda08@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 12:28 PM, Jakub Kicinski wrote:
> On Wed, 14 Aug 2019 20:46:18 -0700, Sridhar Samudrala wrote:
>> This patch series introduces XDP_SKIP_BPF flag that can be specified
>> during the bind() call of an AF_XDP socket to skip calling the BPF
>> program in the receive path and pass the buffer directly to the socket.
>>
>> When a single AF_XDP socket is associated with a queue and a HW
>> filter is used to redirect the packets and the app is interested in
>> receiving all the packets on that queue, we don't need an additional
>> BPF program to do further filtering or lookup/redirect to a socket.
>>
>> Here are some performance numbers collected on
>>    - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
>>    - Intel 40Gb Ethernet NIC (i40e)
>>
>> All tests use 2 cores and the results are in Mpps.
>>
>> turbo on (default)
>> ---------------------------------------------	
>>                        no-skip-bpf    skip-bpf
>> ---------------------------------------------	
>> rxdrop zerocopy           21.9         38.5
>> l2fwd  zerocopy           17.0         20.5
>> rxdrop copy               11.1         13.3
>> l2fwd  copy                1.9          2.0
>>
>> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
>> ---------------------------------------------	
>>                        no-skip-bpf    skip-bpf
>> ---------------------------------------------	
>> rxdrop zerocopy           15.4         29.0
>> l2fwd  zerocopy           11.8         18.2
>> rxdrop copy                8.2         10.5
>> l2fwd  copy                1.7          1.7
>> ---------------------------------------------	
> 
> Could you include a third column here - namely the in-XDP performance?
> AFAIU the way to achieve better performance with AF_XDP is to move the
> fast path into the kernel's XDP program..

The in-xdp drop that can be measured with xdp1 is lower than rxdrop
zerocopy with skip-bpf although in-xdp drop uses only 1 core. af-xdp 
1-core performance would improve with need-wakeup or busypoll patches 
and based on early experiments so far af-xdp with need-wakeup/busypoll + 
skip-bpf perf is higher than in-xdp drop.

Will include in-xdp drop data too in the next revision.

> 
> Maciej's work on batching XDP program's execution should lower the
> retpoline overhead, without leaning close to the bypass model.
> 
