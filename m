Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD093B3CB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbfFJLMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:12:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41454 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388848AbfFJLMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:12:24 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1haIDn-0007I6-C9; Mon, 10 Jun 2019 07:12:17 -0400
Date:   Mon, 10 Jun 2019 07:12:09 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     vyasevich@gmail.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Add rcu lock to protect dst entry in
 sctp_transport_route
Message-ID: <20190610111209.GA15599@hmswarspite.think-freely.org>
References: <1560136800-17961-1-git-send-email-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560136800-17961-1-git-send-email-suyj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:20:00AM +0800, Su Yanjun wrote:
> syzbot found a crash in rt_cache_valid. Problem is that when more
> threads release dst in sctp_transport_route, the route cache can
> be freed.
> 
> As follows,
> p1:
> sctp_transport_route
>   dst_release
>   get_dst
> 
> p2:
> sctp_transport_route
>   dst_release
>   get_dst
> ...
> 
> If enough threads calling dst_release will cause dst->refcnt==0
> then rcu softirq will reclaim the dst entry,get_dst then use
> the freed memory.
> 
> This patch adds rcu lock to protect the dst_entry here.
> 
> Fixes: 6e91b578bf3f("sctp: re-use sctp_transport_pmtu in sctp_transport_route")
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> Reported-by: syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com
> ---
>  net/sctp/transport.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index ad158d3..5ad7e20 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -308,8 +308,13 @@ void sctp_transport_route(struct sctp_transport *transport,
>  	struct sctp_association *asoc = transport->asoc;
>  	struct sctp_af *af = transport->af_specific;
>  
> +	/* When dst entry is being released, route cache may be referred
> +	 * again. Add rcu lock here to protect dst entry.
> +	 */
> +	rcu_read_lock();
>  	sctp_transport_dst_release(transport);
>  	af->get_dst(transport, saddr, &transport->fl, sctp_opt2sk(opt));
> +	rcu_read_unlock();
>  
What is the exact error that syzbot reported?  This doesn't seem like it fixes
anything.  Based on what you've said above, we have multiple processes looking
up and releasing routes in parallel (which IIRC should never happen, as only one
process should traverse the sctp state machine for a given association at any
one time).  Protecting the lookup/release operations with a read side rcu lock
won't fix that.  

Neil

>  	if (saddr)
>  		memcpy(&transport->saddr, saddr, sizeof(union sctp_addr));
> -- 
> 2.7.4
> 
> 
> 
> 
