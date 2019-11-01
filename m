Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5452CEC101
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 11:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbfKAKHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 06:07:38 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:48886 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729037AbfKAKHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 06:07:37 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E6DE370006C;
        Fri,  1 Nov 2019 10:07:35 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 1 Nov 2019
 10:07:32 +0000
Subject: Re: [PATCH net-next v4 0/6] sfc: Add XDP support
To:     David Ahern <dsahern@gmail.com>,
        Charles McLachlan <cmclachlan@solarflare.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <brouer@redhat.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
 <b971b219-5aab-722d-72b7-545a7c2b609e@gmail.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <e3f1c071-3609-d6e7-81d6-9ee73f9f4f6a@solarflare.com>
Date:   Fri, 1 Nov 2019 10:07:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <b971b219-5aab-722d-72b7-545a7c2b609e@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25014.003
X-TM-AS-Result: No-10.134600-8.000000-10
X-TMASE-MatchedRID: eVEkOcJu0F7mLzc6AOD8DfHkpkyUphL9TkUH66TwzU50FoS1aixTNeey
        WMLRVf2LTPkqidFNTAX5YdzxGod4dQGhobW1O/ZCqjZ865FPtpoApu/OILCbuJGhAvBSa2i/7P0
        f4RQxQyUcF4JhFYmAij9HdKO/hTEuqftxS3LnjvV08zy97KsgJl8Rp2iseaxy5DJ1FS+XdBMh9u
        bLG9wIkJY+kEk03nhZqcwVjSNTEBuNgUMaLItOxf3HILfxLV/9Y9JlLwL1dg1TaPOXTIbBNvWIr
        nzPJMLjFHHvrZOHeTOL9bagsxDRhZ/7sfLzEF819VjtTc1fwmB+CWCcHScOE60Mkw1qz/bKngIg
        pj8eDcC063Wh9WVqgnlZfqMjiglX1GcRAJRT6PP3FLeZXNZS4KBkcgGnJ4WmNsk9WPw4IH9rK9e
        XwOV8NluFc1vTDX1CCpsKt3bthbt+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.134600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25014.003
X-MDID: 1572602856-1rEvLr4QoPav
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/10/2019 22:18, David Ahern wrote:
> On 10/31/19 4:21 AM, Charles McLachlan wrote:
>> Supply the XDP callbacks in netdevice ops that enable lower level processing
>> of XDP frames.
>>
>> Changes in v4:
>> - Handle the failure to send some frames in efx_xdp_tx_buffers() properly.
>>
>> Changes in v3:
>> - Fix a BUG_ON when trying to allocate piobufs to xdp queues.
>> - Add a missed trace_xdp_exception.
>>
>> Changes in v2:
>> - Use of xdp_return_frame_rx_napi() in tx.c
>> - Addition of xdp_rxq_info_valid and xdp_rxq_info_failed to track when
>>   xdp_rxq_info failures occur.
>> - Renaming of rc to err and more use of unlikely().
>> - Cut some duplicated code and fix an array overrun.
>> - Actually increment n_rx_xdp_tx when packets are transmitted.
>>
> 
> Something is up with this version versus v2. I am seeing a huge
> performance drop with my L2 forwarding program - something I was not
> seeing with v2 and I do not see with the experimental version of XDP in
> the out of tree sfc driver.
> 
> Without XDP:
> 
> $ netperf -H 10.39.16.7 -l 30 -t TCP_STREAM
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> 10.39.16.7 () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    30.00    9386.73
> 
> 
> With XDP
> 
> $ netperf -H 10.39.16.7 -l 30 -t TCP_STREAM
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> 10.39.16.7 () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    30.01     384.11
> 
> 
> Prior versions was showing throughput of at least 4000 (depends on the
> test and VM setup).

Thanks for testing this. And a good thing we have counters for this.
Are the rx_xdp_drops or rx_xdp_bad_drops non-zero/increasing?

Martin
