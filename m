Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9363A1B6E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhFIRFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:05:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46014 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFIRFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:05:43 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 159H3O43082589;
        Wed, 9 Jun 2021 12:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623258204;
        bh=8tV/mlNsqlqAQLJnwWc4yK/c+olAVVllPTnr/Jd7mlY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QaLOUCQ9R1lVewfjYLCB86Rb51jSGGxU2b28WHvJo2TArhj854lu8cN2NfutK5t7i
         Ky9WPMnYRTqBjn8RiTT591LUroeME9zRBTiKAtwM7nGuMcvicyY6uADZgiPv58fl9o
         DPGx1NylVfH0KADRuQqv6Lo172o6cYtRn/5Lxwjo=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 159H3OGU041744
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Jun 2021 12:03:24 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 12:03:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 9 Jun 2021 12:03:24 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 159H3MuJ071385;
        Wed, 9 Jun 2021 12:03:22 -0500
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
 <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <8f6624b3-b197-1cc7-ede3-03198c6f1936@ti.com>
Date:   Wed, 9 Jun 2021 20:03:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/06/2021 15:20, Matteo Croce wrote:
> On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>
>> As already done for mvneta and mvpp2, enable skb recycling for ti
>> ethernet drivers
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Looks good! If someone with the HW could provide a with and without
> the patch, that would be nice!
> 

Not sure to which mail to answer, so answering here - thanks all

1) I've simulated packet drop using iperf
Host:
- arp -s <some IP> <unknown MAC>
- iperf -c <some IP> -u -l60 -b700M -t60 -i1

DUP:
- place interface in promisc mode
- check rx_packets stats

I see big improvement ~47Kpps vs ~64Kpps

2) I've run iperf3 tests - see no regressions, but also not too much improvements

3) I've applied 2 patches
- this one
- and [1]

Results are below, Thank you

Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210609103326.278782-18-toke@redhat.com/

=========== Before:
[perf top]
  47.15%  [kernel]                   [k] _raw_spin_unlock_irqrestore
   11.77%  [kernel]                   [k] __cpdma_chan_free
    3.16%  [kernel]                   [k] ___bpf_prog_run
    2.52%  [kernel]                   [k] cpsw_rx_vlan_encap
    2.34%  [kernel]                   [k] __netif_receive_skb_core
    2.27%  [kernel]                   [k] free_unref_page
    2.26%  [kernel]                   [k] kmem_cache_free
    2.24%  [kernel]                   [k] kmem_cache_alloc
    1.69%  [kernel]                   [k] __softirqentry_text_start
    1.61%  [kernel]                   [k] cpsw_rx_handler
    1.19%  [kernel]                   [k] page_pool_release_page
    1.19%  [kernel]                   [k] clear_bits_ll
    1.15%  [kernel]                   [k] page_frag_free
    1.06%  [kernel]                   [k] __dma_page_dev_to_cpu
    0.99%  [kernel]                   [k] memset
    0.94%  [kernel]                   [k] __alloc_pages_bulk
    0.92%  [kernel]                   [k] kfree_skb
    0.85%  [kernel]                   [k] packet_rcv
    0.78%  [kernel]                   [k] page_address
    0.75%  [kernel]                   [k] v7_dma_inv_range
    0.71%  [kernel]                   [k] __lock_text_start

[rx packets - with packet drop]
rxdiff 48004
rxdiff 47630
rxdiff 47538

[iperf3 TCP]
iperf3 -c 192.168.1.1 -i1
[  5]   0.00-10.00  sec   873 MBytes   732 Mbits/sec    0             sender
[  5]   0.00-10.01  sec   866 MBytes   726 Mbits/sec                  receiver

=========== After:
[perf top - with packet drop]
  40.58%  [kernel]                   [k] _raw_spin_unlock_irqrestore
   16.18%  [kernel]                   [k] __softirqentry_text_start
   10.33%  [kernel]                   [k] __cpdma_chan_free
    2.62%  [kernel]                   [k] ___bpf_prog_run
    2.05%  [kernel]                   [k] cpsw_rx_vlan_encap
    2.00%  [kernel]                   [k] kmem_cache_alloc
    1.86%  [kernel]                   [k] __netif_receive_skb_core
    1.80%  [kernel]                   [k] kmem_cache_free
    1.63%  [kernel]                   [k] cpsw_rx_handler
    1.12%  [kernel]                   [k] cpsw_rx_mq_poll
    1.11%  [kernel]                   [k] page_pool_put_page
    1.04%  [kernel]                   [k] _raw_spin_unlock
    0.97%  [kernel]                   [k] clear_bits_ll
    0.90%  [kernel]                   [k] packet_rcv
    0.88%  [kernel]                   [k] __dma_page_dev_to_cpu
    0.85%  [kernel]                   [k] kfree_skb
    0.80%  [kernel]                   [k] memset
    0.71%  [kernel]                   [k] __lock_text_start
    0.66%  [kernel]                   [k] v7_dma_inv_range
    0.64%  [kernel]                   [k] gen_pool_free_owner
    0.58%  [kernel]                   [k] __rcu_read_unlock

[rx packets - with packet drop]
rxdiff 65843
rxdiff 66722
rxdiff 65264

[iperf3 TCP]
iperf3 -c 192.168.1.1 -i1
[  5]   0.00-10.00  sec   884 MBytes   742 Mbits/sec    0             sender
[  5]   0.00-10.01  sec   878 MBytes   735 Mbits/sec                  receiver


-- 
Best regards,
grygorii
