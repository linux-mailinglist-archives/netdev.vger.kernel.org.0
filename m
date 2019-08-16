Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2D18FAA7
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfHPGMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:12:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:37768 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfHPGMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 02:12:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 23:12:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,391,1559545200"; 
   d="scan'208";a="182093084"
Received: from samudral-mobl1.amr.corp.intel.com (HELO [10.251.21.3]) ([10.251.21.3])
  by orsmga006.jf.intel.com with ESMTP; 15 Aug 2019 23:12:36 -0700
Subject: Re: [PATCH bpf-next 0/5] Add support for SKIP_BPF flag for AF_XDP
 sockets
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        tom.herbert@intel.com
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
 <87ftm2adi2.fsf@toke.dk> <b9423054-247e-8b57-ea59-42368f60ea1e@intel.com>
 <87ftm2wdzk.fsf@toke.dk>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <3b85138e-97a7-e59c-194d-54301b482689@intel.com>
Date:   Thu, 15 Aug 2019 23:12:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87ftm2wdzk.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 10:11 AM, Toke Høiland-Jørgensen wrote:
> "Samudrala, Sridhar" <sridhar.samudrala@intel.com> writes:
> 
>> On 8/15/2019 4:12 AM, Toke Høiland-Jørgensen wrote:
>>> Sridhar Samudrala <sridhar.samudrala@intel.com> writes:
>>>
>>>> This patch series introduces XDP_SKIP_BPF flag that can be specified
>>>> during the bind() call of an AF_XDP socket to skip calling the BPF
>>>> program in the receive path and pass the buffer directly to the socket.
>>>>
>>>> When a single AF_XDP socket is associated with a queue and a HW
>>>> filter is used to redirect the packets and the app is interested in
>>>> receiving all the packets on that queue, we don't need an additional
>>>> BPF program to do further filtering or lookup/redirect to a socket.
>>>>
>>>> Here are some performance numbers collected on
>>>>     - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
>>>>     - Intel 40Gb Ethernet NIC (i40e)
>>>>
>>>> All tests use 2 cores and the results are in Mpps.
>>>>
>>>> turbo on (default)
>>>> ---------------------------------------------	
>>>>                         no-skip-bpf    skip-bpf
>>>> ---------------------------------------------	
>>>> rxdrop zerocopy           21.9         38.5
>>>> l2fwd  zerocopy           17.0         20.5
>>>> rxdrop copy               11.1         13.3
>>>> l2fwd  copy                1.9          2.0
>>>>
>>>> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
>>>> ---------------------------------------------	
>>>>                         no-skip-bpf    skip-bpf
>>>> ---------------------------------------------	
>>>> rxdrop zerocopy           15.4         29.0
>>>> l2fwd  zerocopy           11.8         18.2
>>>> rxdrop copy                8.2         10.5
>>>> l2fwd  copy                1.7          1.7
>>>> ---------------------------------------------
>>>
>>> You're getting this performance boost by adding more code in the fast
>>> path for every XDP program; so what's the performance impact of that for
>>> cases where we do run an eBPF program?
>>
>> The no-skip-bpf results are pretty close to what i see before the
>> patches are applied. As umem is cached in rx_ring for zerocopy the
>> overhead is much smaller compared to the copy scenario where i am
>> currently calling xdp_get_umem_from_qid().
> 
> I meant more for other XDP programs; what is the performance impact of
> XDP_DROP, for instance?

Will run xdp1 with and without the patches and include that data with 
the next revision.

