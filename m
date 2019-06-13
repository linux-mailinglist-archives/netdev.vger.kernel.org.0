Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D31F43878
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbfFMPGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:06:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:18387 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732427AbfFMOL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:11:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 07:11:28 -0700
X-ExtLoop1: 1
Received: from btopel-mobl.isw.intel.com (HELO btopel-mobl.ger.intel.com) ([10.103.211.150])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2019 07:11:24 -0700
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612134805.3bf4ea25@cakuba.netronome.com>
 <CAJ+HfNh3KcoZC5W6CLgnx2tzH41Kz11Zs__2QkOKF+CyEMzdMQ@mail.gmail.com>
 <65cf2b7b-79a5-c660-358c-a265fc03b495@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <54a8ed28-0690-565e-f470-2c81a990251e@intel.com>
Date:   Thu, 13 Jun 2019 16:11:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <65cf2b7b-79a5-c660-358c-a265fc03b495@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-06-13 16:01, Maxim Mikityanskiy wrote:
> On 2019-06-13 15:58, Björn Töpel wrote:
>> On Wed, 12 Jun 2019 at 22:49, Jakub Kicinski
>> <jakub.kicinski@netronome.com> wrote:
>>>
>>> On Wed, 12 Jun 2019 15:56:33 +0000, Maxim Mikityanskiy wrote:
>>>> UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
>>>> half of the available amount of RX queues are regular queues, and the
>>>> upper half are XSK RX queues.
>>>
>>> If I have 32 queues enabled on the NIC and I install AF_XDP socket on
>>> queue 10, does the NIC now have 64 RQs, but only first 32 are in the
>>> normal RSS map?
>>>
>>
>> Additional, related, question to Jakub's: Say that I'd like to hijack
>> all 32 Rx queues of the NIC. I create 32 AF_XDP socket and attach them
>> in zero-copy mode to the device. What's the result?
> 
> There are 32 regular RX queues (0..31) and 32 XSK RX queues (32..63). If
> you want 32 zero-copy AF_XDP sockets, you can attach them to queues
> 32..63, and the regular traffic won't be affected at all.
> 
Thanks for getting back! More questions!

Ok, so I cannot (with zero-copy) get the regular traffic into AF_XDP
sockets?

How does qids map? Can I only bind a zero-copy socket to qid 32..63 in
the example above?

Say that I have a a copy-mode AF_XDP socket bound to queue 2. In this
case I will receive the regular traffic from queue 2. Enabling zero-copy
for the same queue, will this give an error, or receive AF_XDP specific
traffic from queue 2+32? Or return an error, and require an explicit
bind to any of the queues 32..63?


Thanks,
Björn
