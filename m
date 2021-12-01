Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7C464702
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbhLAGJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:09:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:49752 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346801AbhLAGJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 01:09:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236335085"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="236335085"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:06:02 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="677139683"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.35.160]) ([10.209.35.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:06:01 -0800
Message-ID: <5755abe9-7b3c-0361-4eea-e0c125811eae@linux.intel.com>
Date:   Tue, 30 Nov 2021 22:06:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 09/14] net: wwan: t7xx: Add WWAN network interface
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-10-ricardo.martinez@linux.intel.com>
 <CAHNKnsTAj8OHzoyK3SHhA_yXJrqc38bYmY6pYZf9fwUemcK7iQ@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsTAj8OHzoyK3SHhA_yXJrqc38bYmY6pYZf9fwUemcK7iQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/6/2021 11:08 AM, Sergey Ryazanov wrote:
> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> Creates the Cross Core Modem Network Interface (CCMNI) which implements
>> the wwan_ops for registration with the WWAN framework, CCMNI also
>> implements the net_device_ops functions used by the network device.
>> Network device operations include open, close, start transmission, TX
>> timeout, change MTU, and select queue.
>>
[skipped]
>> +static enum txq_type get_txq_type(struct sk_buff *skb)
>> +{
>> +       u32 total_len, payload_len, l4_off;
>> +       bool tcp_syn_fin_rst, is_tcp;
>> +       struct ipv6hdr *ip6h;
>> +       struct tcphdr *tcph;
>> +       struct iphdr *ip4h;
>> +       u32 packet_type;
>> +       __be16 frag_off;
>> +
>> +       packet_type = skb->data[0] & SBD_PACKET_TYPE_MASK;
>> +       if (packet_type == IPV6_VERSION) {
>> +               ip6h = (struct ipv6hdr *)skb->data;
>> +               total_len = sizeof(struct ipv6hdr) + ntohs(ip6h->payload_len);
>> +               l4_off = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &ip6h->nexthdr, &frag_off);
>> +               tcph = (struct tcphdr *)(skb->data + l4_off);
>> +               is_tcp = ip6h->nexthdr == IPPROTO_TCP;
>> +               payload_len = total_len - l4_off - (tcph->doff << 2);
>> +       } else if (packet_type == IPV4_VERSION) {
>> +               ip4h = (struct iphdr *)skb->data;
>> +               tcph = (struct tcphdr *)(skb->data + (ip4h->ihl << 2));
>> +               is_tcp = ip4h->protocol == IPPROTO_TCP;
>> +               payload_len = ntohs(ip4h->tot_len) - (ip4h->ihl << 2) - (tcph->doff << 2);
>> +       } else {
>> +               return TXQ_NORMAL;
>> +       }
>> +
>> +       tcp_syn_fin_rst = tcph->syn || tcph->fin || tcph->rst;
>> +       if (is_tcp && !payload_len && !tcp_syn_fin_rst)
>> +               return TXQ_FAST;
>> +
>> +       return TXQ_NORMAL;
>> +}
> I am wondering how much modem performance has improved with this
> optimization compared to the performance loss on each packet due to
> the cache miss? Do you have any measurement results?

No performance gains observed in the latest tests, this is going to be 
removed for the

next iteration.

>> +static u16 ccmni_select_queue(struct net_device *dev, struct sk_buff *skb,
>> +                             struct net_device *sb_dev)
>> +{
>> +       struct ccmni_instance *ccmni;
>> +
>> +       ccmni = netdev_priv(dev);
>> +
>> +       if (ccmni->ctlb->capability & NIC_CAP_DATA_ACK_DVD)
>> +               return get_txq_type(skb);
>> +
>> +       return TXQ_NORMAL;
>> +}
>> +
>> +static int ccmni_open(struct net_device *dev)
>> +{
>> +       struct ccmni_instance *ccmni;
>> +
>> +       ccmni = wwan_netdev_drvpriv(dev);
>
[skipped]
>> +       skb_set_mac_header(skb, -ETH_HLEN);
>> +       skb_reset_network_header(skb);
>> +       skb->dev = dev;
>> +       if (pkt_type == IPV6_VERSION)
>> +               skb->protocol = htons(ETH_P_IPV6);
>> +       else
>> +               skb->protocol = htons(ETH_P_IP);
>> +
>> +       skb_len = skb->len;
>> +
>> +       netif_rx_any_context(skb);
> Did you consider using NAPI for the packet Rx path? This should
> improve Rx performance.
Yes, NAPI implementation is in the plan.
>> +       dev->stats.rx_packets++;
>> +       dev->stats.rx_bytes += skb_len;
>> +}
> [skipped]
>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.h b/drivers/net/wwan/t7xx/t7xx_netdev.h
>> ...
>> +#define CCMNI_TX_QUEUE         1000
> Is this a really carefully selected queue depth limit, or just an
> arbitrary value? If the last one, then feel free to use  the
> DEFAULT_TX_QUEUE_LEN macro.
Changing this to DEFAULT_TX_QUEUE_LEN for the next iteration
>> ..
>> +#define IPV4_VERSION           0x40
>> +#define IPV6_VERSION           0x60
> Just curious why the _VERSION suffix? Why not, for example, PKT_TYPE_ prefix?
Nothing special about _VERSION, but it does look a bit weird, will use 
PKT_TYPE_  as suggested
> --
> Sergey
Ricardo
