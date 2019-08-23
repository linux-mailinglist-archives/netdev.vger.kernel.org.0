Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF83F9AEBC
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 14:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732076AbfHWMID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 08:08:03 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54044 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729276AbfHWMIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 08:08:02 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 09BB49C005B;
        Fri, 23 Aug 2019 12:08:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 23 Aug
 2019 05:07:56 -0700
Subject: Re: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case of
 forwarding
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        <linux-sctp@vger.kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        <syzkaller-bugs@googlegroups.com>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5b2e79d5-57af-e340-c629-fc6b55a7a61a@solarflare.com>
Date:   Fri, 23 Aug 2019 13:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24864.005
X-TM-AS-Result: No-6.072200-4.000000-10
X-TMASE-MatchedRID: VfovoVrt/obmLzc6AOD8DfHkpkyUphL9V447DNvw38Yd0WOKRkwsh9KE
        CfhYwuaGqgI39lWBXGAUEDo1iEscxd4V9K8RueK0iVJZi91I9JiNY/pqxovzxSUYk4HuiHNeeOb
        QA+fBlTZvBSlbLE2hM+oLLihYlOnnhYPPuY/F3SnG693ff8j9ZH316REeU5CRYy6fApvL8BfHK3
        DBP8Kop+WneZ7hAIg8WQRuvgDOtkMfJqU6guixkT8Ckw9b/GFeTJDl9FKHbrlVZCccrGnfyHjYj
        uQ9Q8tr4vM1YF6AJbZFi+KwZZttL7ew1twePJJBrSFs54Y4wbX6C0ePs7A07cMFHFkKVmrB4yVB
        4DP4QUXOxYH2crb20n+rtbXKkNdbBogZJT1nwGLHY0vPhWZTahmrOt6CI3sftTMHDUFM4sWhQ3b
        waWPv/XPOKpmID8G1UdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD8VsfdwUmMsnAvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.072200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24864.005
X-MDID: 1566562081-YpG2qX1V0QLU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2019 12:33, Xin Long wrote:
> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
> listify ip_rcv_finish in case of forwarding") does for ipv4.
>
> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
> trace was:
>
>   kernel BUG at include/linux/skbuff.h:2225!
>   RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
>   RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
>   Call Trace:
>     sctp_inq_pop+0x2f1/0xd80 net/sctp/inqueue.c:202
>     sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
>     sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
>     sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
>     sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
>     ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
>     ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
>     NF_HOOK include/linux/netfilter.h:305 [inline]
>     NF_HOOK include/linux/netfilter.h:299 [inline]
>     ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
>     dst_input include/net/dst.h:442 [inline]
>     ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
>     ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
>     ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
>     ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
>     __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
>     __netif_receive_skb_list_core+0x5fc/0x9d0 net/core/dev.c:5097
>     __netif_receive_skb_list net/core/dev.c:5149 [inline]
>     netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
>     gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
>     gro_normal_list net/core/dev.c:5755 [inline]
>     gro_normal_one net/core/dev.c:5769 [inline]
>     napi_frags_finish net/core/dev.c:5782 [inline]
>     napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
>     tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
>     tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020
>
> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Thanks for catching this.
> ---
>  net/ipv6/ip6_input.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index fa014d5..d432d00 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -80,8 +80,10 @@ static void ip6_sublist_rcv_finish(struct list_head *head)
>  {
>  	struct sk_buff *skb, *next;
>  
> -	list_for_each_entry_safe(skb, next, head, list)
> +	list_for_each_entry_safe(skb, next, head, list) {
> +		skb_list_del_init(skb);
>  		dst_input(skb);
> +	}
>  }
>  
>  static void ip6_list_rcv_finish(struct net *net, struct sock *sk,

