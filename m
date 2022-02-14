Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBCF4B4095
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 05:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbiBNEDt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Feb 2022 23:03:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiBNEDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 23:03:48 -0500
Received: from mail-m2458.qiye.163.com (mail-m2458.qiye.163.com [220.194.24.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15954EA3B;
        Sun, 13 Feb 2022 20:03:40 -0800 (PST)
Received: from smtpclient.apple (unknown [117.48.120.186])
        by mail-m2458.qiye.163.com (Hmail) with ESMTPA id C8EC17401B9;
        Mon, 14 Feb 2022 12:03:38 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] gso: do not skip outer ip header in case of ipip and
 net_failover
From:   Tao Liu <thomas.liu@ucloud.cn>
In-Reply-To: <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
Date:   Mon, 14 Feb 2022 12:03:38 +0800
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, sridhar.samudrala@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn>
References: <20220213150234.31602-1-thomas.liu@ucloud.cn>
 <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRoaThhWSh4ZQ08fHh0aGh
        lPVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phg6EQw4SjIzMwo6ODFIOAoI
        PB0aFC5VSlVKTU9PQ0pKT0pCSkNLVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SkpMVU9DVUpJS1VKQ01ZV1kIAVlBTUlLSTcG
X-HM-Tid: 0a7ef6667d798c17kuqtc8ec17401b9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for bothering, just repost it.

> 2022年2月14日 09:28，Willem de Bruijn <willemdebruijn.kernel@gmail.com> 写道：
> 
> On Sun, Feb 13, 2022 at 10:10 AM Tao Liu <thomas.liu@ucloud.cn> wrote:
>> 
>> We encouter a tcp drop issue in our cloud environment. Packet GROed in host
>> forwards to a VM virtio_net nic with net_failover enabled. VM acts as a
>> IPVS LB with ipip encapsulation. The full path like:
>> host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
>> -> ipip encap -> net_failover tx -> virtio_net tx
>> 
>> When net_failover transmits a ipip pkt (gso_type = 0x0103), there is no gso
>> performed because it supports TSO and GSO_IPXIP4. But network_header has
>> been pointing to inner ip header.
> 
> If the packet is configured correctly, and net_failover advertises
> that it can handle TSO packets with IPIP encap, then still virtio_net
> should not advertise it and software GSO be applied on its
> dev_queue_xmit call.
> 
> This is assuming that the packet not only has SKB_GSO_IPXIP4 correctly
> set, but also tunneling fields like skb->encapsulated and
> skb_inner_network_header.
Thanks very much for your comment!

Yes, the packet is correct. Another thing i have not pointed directly is
that the pkt has SKB_GSO_DODGY. net_failover do not advertises GSO_ROBUST
but virtio_net do.

>> ---
>> net/ipv4/af_inet.c | 10 +++++++++-
>> 1 file changed, 9 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
>> index 9c465ba..f8b3f8a 100644
>> --- a/net/ipv4/af_inet.c
>> +++ b/net/ipv4/af_inet.c
>> @@ -1425,10 +1425,18 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
>> static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
>>                                        netdev_features_t features)
>> {
>> +       struct sk_buff *segs;
>> +       int nhoff;
>> +
>>        if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
>>                return ERR_PTR(-EINVAL);
>> 
>> -       return inet_gso_segment(skb, features);
>> +       nhoff = skb_network_header(skb) - skb_mac_header(skb);
>> +       segs = inet_gso_segment(skb, features);
>> +       if (!segs)
>> +               skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
>> +
>> +       return segs;
>> }
> 
> If this would be needed for IPIP, then the same would be needed for SIT, etc.
> 
> Is the skb_network_header
> 
> 1. correctly pointing to the outer header of the TSO packet before the
> call to inet_gso_segment
> 2. incorrectly pointing to the inner header of the (still) TSO packet
> after the call to inet_gso_segment
> 
> inet_gso_segment already does the same operation: save nhoff, pull
> network header, call callbacks.gso_segment (which can be
> ipip_gso_segment->inet_gso_segment), then place the network header
> back at nhoff.
> 
values print in skb_mac_gso_segment() before callbacks.gso_segment:
ipip:               vlan_depth=0 mac_len=0 skb->network_header=206
net_failover:  vlan_depth=14 mac_len=14 skb->network_header=186
virtio_net:      vlan_depth=34 mac_len=34 skb->network_header=206

agree to add sit/ip4ip6/ip6ip6, and patch can be simplified as:

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 9c465ba..72fde28 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1376,8 +1376,11 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
        }

        ops = rcu_dereference(inet_offloads[proto]);
-       if (likely(ops && ops->callbacks.gso_segment))
+       if (likely(ops && ops->callbacks.gso_segment)) {
                segs = ops->callbacks.gso_segment(skb, features);
+               if (!segs)
+                       skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
+       }

        if (IS_ERR_OR_NULL(segs))
                goto out;
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index b29e9ba..5f577e2 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -114,6 +114,8 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
        if (likely(ops && ops->callbacks.gso_segment)) {
                skb_reset_transport_header(skb);
                segs = ops->callbacks.gso_segment(skb, features);
+               if (!segs)
+                       skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
        }

        if (IS_ERR_OR_NULL(segs))


