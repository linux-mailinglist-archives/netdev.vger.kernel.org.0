Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602DB221391
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 19:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGORg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 13:36:26 -0400
Received: from ja.ssi.bg ([178.16.129.10]:59332 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726722AbgGORgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 13:36:25 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 06FHZgoI007525;
        Wed, 15 Jul 2020 20:35:44 +0300
Date:   Wed, 15 Jul 2020 20:35:42 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     guodeqing <geffrey.guo@huawei.com>
cc:     wensong@linux-vs.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: fix the connection sync failed in some cases
In-Reply-To: <1594796027-66136-1-git-send-email-geffrey.guo@huawei.com>
Message-ID: <alpine.LFD.2.23.451.2007152016420.6034@ja.home.ssi.bg>
References: <1594796027-66136-1-git-send-email-geffrey.guo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 15 Jul 2020, guodeqing wrote:

> The sync_thread_backup only checks sk_receive_queue is empty or not,
> there is a situation which cannot sync the connection entries when
> sk_receive_queue is empty and sk_rmem_alloc is larger than sk_rcvbuf,
> the sync packets are dropped in __udp_enqueue_schedule_skb, this is
> because the packets in reader_queue is not read, so the rmem is
> not reclaimed.

	Good catch. We missed this change in UDP...

> Here I add the check of whether the reader_queue of the udp sock is
> empty or not to solve this problem.
> 
> Fixes: 7c13f97ffde6 ("udp: do fwd memory scheduling on dequeue")

	Why this commit and not 2276f58ac589 which adds
reader_queue to udp_poll() ? May be both?

> Reported-by: zhouxudong <zhouxudong8@huawei.com>
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
> ---
>  net/netfilter/ipvs/ip_vs_sync.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 605e0f6..abe8d63 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -1717,6 +1717,8 @@ static int sync_thread_backup(void *data)
>  {
>  	struct ip_vs_sync_thread_data *tinfo = data;
>  	struct netns_ipvs *ipvs = tinfo->ipvs;
> +	struct sock *sk = tinfo->sock->sk;
> +	struct udp_sock *up = udp_sk(sk);
>  	int len;
>  
>  	pr_info("sync thread started: state = BACKUP, mcast_ifn = %s, "
> @@ -1724,12 +1726,14 @@ static int sync_thread_backup(void *data)
>  		ipvs->bcfg.mcast_ifn, ipvs->bcfg.syncid, tinfo->id);
>  
>  	while (!kthread_should_stop()) {
> -		wait_event_interruptible(*sk_sleep(tinfo->sock->sk),
> -			 !skb_queue_empty(&tinfo->sock->sk->sk_receive_queue)
> -			 || kthread_should_stop());
> +		wait_event_interruptible(*sk_sleep(sk),
> +					 !skb_queue_empty(&sk->sk_receive_queue) ||
> +					 !skb_queue_empty(&up->reader_queue) ||

	May be we should use skb_queue_empty_lockless for 5.4+
and skb_queue_empty() for backports to 4.14 and 4.19...

> +					 kthread_should_stop());
>  
>  		/* do we have data now? */
> -		while (!skb_queue_empty(&(tinfo->sock->sk->sk_receive_queue))) {
> +		while (!skb_queue_empty(&sk->sk_receive_queue) ||
> +		       !skb_queue_empty(&up->reader_queue)) {

	Here too

>  			len = ip_vs_receive(tinfo->sock, tinfo->buf,
>  					ipvs->bcfg.sync_maxlen);
>  			if (len <= 0) {
> -- 
> 2.7.4

Regards

--
Julian Anastasov <ja@ssi.bg>
