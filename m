Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECDC164B68
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgBSRES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:04:18 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47284 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSREQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:04:16 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01JH3kYa052674;
        Wed, 19 Feb 2020 11:03:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582131826;
        bh=s1rj2PhW3r5Lwc5e3k3MTDncWdeeeMlTNSken+W8KT8=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=QqY2ra/46zEOVXtUqO8hBqphKtk3SWyDxRHGfb/pJ8lJ+sioT0aNuIM2GQMM4AyL9
         5DN97oHgkEj/Rfe3nUu3VAxPSQdowYmpGFU//+ce77vEBw1UNCOMjx+5LVT0FVQ/of
         dr15SKJ4niS20YlQv41YxHYQocD0LxAFdUlsmZUo=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01JH3kH3066837;
        Wed, 19 Feb 2020 11:03:46 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 19
 Feb 2020 11:03:46 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 19 Feb 2020 11:03:46 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01JH3hoU081367;
        Wed, 19 Feb 2020 11:03:44 -0600
Subject: Re: CHECKSUM_COMPLETE question
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <da2b1a2f-b8f7-21de-05c2-9a30636ccf9f@ti.com>
Message-ID: <9cfc1bcb-6d67-e966-28d9-a6f290648cb0@ti.com>
Date:   Wed, 19 Feb 2020 19:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <da2b1a2f-b8f7-21de-05c2-9a30636ccf9f@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 12/02/2020 11:52, Grygorii Strashko wrote:
> Hi All,
> 
> I'd like to ask expert opinion and clarify few points about HW RX checksum offload.
> 
> 1) CHECKSUM_COMPLETE - from description in <linux/skbuff.h>
>   * CHECKSUM_COMPLETE:
>   *
>   *   This is the most generic way. The device supplied checksum of the _whole_
>   *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
>   *   hardware doesn't need to parse L3/L4 headers to implement this.
> 
> My understanding from above is that HW, to be fully compatible with Linux, should produce CSUM
> starting from first byte after EtherType field:
>   (6 DST_MAC) (6 SRC_MAC) (2 EtherType) (...                   ...)
>                                          ^                       ^
>                                          | start csum            | end csum
> and ending at the last byte of Ethernet frame data.
> - if packet is VLAN tagged then VLAN TCI and real EtherType included in CSUM,
>    but first VLAN TPID doesn't
> - pad bytes may/may not be included in csum
> 
> 
> 2) I've found some difference between IPv4 and IPv6 csum processing of fragmented packets
> 
> Fragmented IPv4 UDP packet:
>   - driver fills skb->csum and sets skb->ip_summed = CHECKSUM_COMPLETE for every fragment
>   - in ip_frag_queue() the ip_hdr is parsed, and polled, and packet queued, but
>     there is *no* csum correction in this function for polled ip_hdr (no csum_sub() or similar calls)
> ^^^^
>   - as result, in inet_frag_reasm_finish() the skb->csum field can be seen unmodified
>   - if the same packet is sent over VLAN the skb->csum in inet_frag_reasm_finish() will be seen as modified due to
>     skb_vlan_untag()->skb_pull_rcsum()
> 
> Fragmented IPv6 UDP packet:
>   - driver fills skb->csum and sets skb->ip_summed = CHECKSUM_COMPLETE for every fragment
>   - in ip6_frag_queue() the ipv6_hdr s parsed, and polled, and packet queued,
>     *and csum corrected*
> 
>   ip6_frag_queue()
>   ...
>          if (skb->ip_summed == CHECKSUM_COMPLETE) {
>          const unsigned char *nh = skb_network_header(skb);
>          skb->csum = csum_sub(skb->csum,
>                       csum_partial(nh, (u8 *)(fhdr + 1) - nh,
> 
> Are there any reasons for such difference between IPv4 and IPv6?

I'm very sorry for disturbing you, but could anybody help with above two questions?


> 
> 3) few words about new HW i'm working with.
> The HW can parse IP4/IP6 and UDP/TCP headers and generate csum including pseudo header checksum
> which is working pretty well for non fragmented packets.
> 
> For fragmented packets (UDP for example):
> - First fragments have the UDP header (including pseudo header) and data included in the count.
> - Middle and last fragments have only data included in the count
> 
> As result when SUM_ALL(frag->csum) == 0xFFFF means packet csum is correct.
> 
> Above seems will not be working out of the box, at least not without csum manipulations simialar
> to what is done in mellanox/mlx4/en_rx.c (check_csum(),get_fixed_ipv4_csum(), get_fixed_ipv6_csum())
> 
> 
> Thanks you.
> 

-- 
Best regards,
grygorii
