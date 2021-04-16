Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE77362BAB
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhDPXBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:01:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:59320 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhDPXBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:01:06 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lXXRz-0009P5-4b; Sat, 17 Apr 2021 01:00:35 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lXXRy-000GvA-PR; Sat, 17 Apr 2021 01:00:34 +0200
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <YHoBtldcPyKNFKPv@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <daeb8a26-44fa-d76e-dd8e-bd4ca62ef868@iogearbox.net>
Date:   Sat, 17 Apr 2021 01:00:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YHoBtldcPyKNFKPv@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26142/Fri Apr 16 13:14:04 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/21 11:29 PM, Lorenzo Bianconi wrote:
>>
>> Took your patches for a test run with the AF_XDP sample xdpsock on an
>> i40e card and the throughput degradation is between 2 to 6% depending
>> on the setup and microbenchmark within xdpsock that is executed. And
>> this is without sending any multi frame packets. Just single frame
>> ones. Tirtha made changes to the i40e driver to support this new
>> interface so that is being included in the measurements.
> 
> thx for working on it. Assuming the fragmented part is only initialized/accessed
> if mb is set (so for multi frame packets), I would not expect any throughput
> degradation in the single frame scenario. Can you please share the i40e
> support added by Tirtha?

Thanks Tirtha & Magnus for adding and testing mb support for i40e, and sharing those
data points; a degradation between 2-6% when mb is not used would definitely not be
acceptable. Would be great to root-cause and debug this further with Lorenzo, there
really should be close to /zero/ additional overhead to avoid regressing existing
performance sensitive workloads like load balancers, etc once they upgrade their
kernels/drivers.

>> What performance do you see with the mvneta card? How much are we
>> willing to pay for this feature when it is not being used or can we in
>> some way selectively turn it on only when needed?
> 
> IIRC I did not get sensible throughput degradation on mvneta but I will re-run
> the tests running an updated bpf-next tree.

But compared to i40e, mvneta is also only 1-2.5 Gbps so potentially less visible,
right [0]? Either way, it's definitely good to get more data points from benchmarking
given this was lacking before for higher speed NICs in particular.

Thanks everyone,
Daniel

   [0] https://doc.dpdk.org/guides/nics/mvneta.html
