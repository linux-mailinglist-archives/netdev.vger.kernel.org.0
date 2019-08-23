Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625E19B462
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436677AbfHWQSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:18:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40687 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389787AbfHWQSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:18:33 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:43ee::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1i1CGb-00083M-3R; Fri, 23 Aug 2019 12:18:27 -0400
Date:   Fri, 23 Aug 2019 12:17:53 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, arnd@arndb.de,
        andrew@lunn.ch, ayal@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next] drop_monitor: Make timestamps y2038 safe
Message-ID: <20190823161753.GA20193@hmswarspite.think-freely.org>
References: <20190823154721.9927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823154721.9927-1-idosch@idosch.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 06:47:21PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Timestamps are currently communicated to user space as 'struct
> timespec', which is not considered y2038 safe since it uses a 32-bit
> signed value for seconds.
> 
> Fix this while the API is still not part of any official kernel release
> by using 64-bit nanoseconds timestamps instead.
> 
> Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
> Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
> Arnd, I have followed your recommendation to use 64-bit nanoseconds
> timestamps. I would appreciate it if you could review this change.
> 
> Thanks!
> ---
>  include/uapi/linux/net_dropmon.h |  2 +-
>  net/core/drop_monitor.c          | 14 ++++++--------
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 75a35dccb675..8bf79a9eb234 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -75,7 +75,7 @@ enum net_dm_attr {
>  	NET_DM_ATTR_PC,				/* u64 */
>  	NET_DM_ATTR_SYMBOL,			/* string */
>  	NET_DM_ATTR_IN_PORT,			/* nested */
> -	NET_DM_ATTR_TIMESTAMP,			/* struct timespec */
> +	NET_DM_ATTR_TIMESTAMP,			/* u64 */
>  	NET_DM_ATTR_PROTO,			/* u16 */
>  	NET_DM_ATTR_PAYLOAD,			/* binary */
>  	NET_DM_ATTR_PAD,
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index bfc024024aa3..cc60cc22e2db 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -552,7 +552,7 @@ static size_t net_dm_packet_report_size(size_t payload_len)
>  	       /* NET_DM_ATTR_IN_PORT */
>  	       net_dm_in_port_size() +
>  	       /* NET_DM_ATTR_TIMESTAMP */
> -	       nla_total_size(sizeof(struct timespec)) +
> +	       nla_total_size(sizeof(u64)) +
>  	       /* NET_DM_ATTR_ORIG_LEN */
>  	       nla_total_size(sizeof(u32)) +
>  	       /* NET_DM_ATTR_PROTO */
> @@ -592,7 +592,6 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
>  	char buf[NET_DM_MAX_SYMBOL_LEN];
>  	struct nlattr *attr;
> -	struct timespec ts;
>  	void *hdr;
>  	int rc;
>  
> @@ -615,8 +614,8 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  	if (rc)
>  		goto nla_put_failure;
>  
> -	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
> -	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
> +	if (nla_put_u64_64bit(msg, NET_DM_ATTR_TIMESTAMP,
> +			      ktime_to_ns(skb->tstamp), NET_DM_ATTR_PAD))
>  		goto nla_put_failure;
>  
>  	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
> @@ -716,7 +715,7 @@ net_dm_hw_packet_report_size(size_t payload_len,
>  	       /* NET_DM_ATTR_IN_PORT */
>  	       net_dm_in_port_size() +
>  	       /* NET_DM_ATTR_TIMESTAMP */
> -	       nla_total_size(sizeof(struct timespec)) +
> +	       nla_total_size(sizeof(u64)) +
>  	       /* NET_DM_ATTR_ORIG_LEN */
>  	       nla_total_size(sizeof(u32)) +
>  	       /* NET_DM_ATTR_PROTO */
> @@ -730,7 +729,6 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
>  {
>  	struct net_dm_hw_metadata *hw_metadata;
>  	struct nlattr *attr;
> -	struct timespec ts;
>  	void *hdr;
>  
>  	hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
> @@ -761,8 +759,8 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
>  			goto nla_put_failure;
>  	}
>  
> -	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
> -	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
> +	if (nla_put_u64_64bit(msg, NET_DM_ATTR_TIMESTAMP,
> +			      ktime_to_ns(skb->tstamp), NET_DM_ATTR_PAD))
>  		goto nla_put_failure;
>  
>  	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
> -- 
> 2.21.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
