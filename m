Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9A61C1254
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgEAMlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 08:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728712AbgEAMlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 08:41:47 -0400
X-Greylist: delayed 4393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 May 2020 05:41:47 PDT
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C41CC061A0C;
        Fri,  1 May 2020 05:41:47 -0700 (PDT)
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1jUTq8-0005B2-96; Fri, 01 May 2020 07:28:26 -0400
Date:   Fri, 1 May 2020 07:28:14 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 07/15] drop_monitor: work around gcc-10 stringop-overflow
 warning
Message-ID: <20200501112814.GA2175875@hmswarspite.think-freely.org>
References: <20200430213101.135134-1-arnd@arndb.de>
 <20200430213101.135134-8-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430213101.135134-8-arnd@arndb.de>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:30:49PM +0200, Arnd Bergmann wrote:
> The current gcc-10 snapshot produces a false-positive warning:
> 
> net/core/drop_monitor.c: In function 'trace_drop_common.constprop':
> cc1: error: writing 8 bytes into a region of size 0 [-Werror=stringop-overflow=]
> In file included from net/core/drop_monitor.c:23:
> include/uapi/linux/net_dropmon.h:36:8: note: at offset 0 to object 'entries' with size 4 declared here
>    36 |  __u32 entries;
>       |        ^~~~~~~
> 
> I reported this in the gcc bugzilla, but in case it does not get
> fixed in the release, work around it by using a temporary variable.
> 
> Fixes: 9a8afc8d3962 ("Network Drop Monitor: Adding drop monitor implementation & Netlink protocol")
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94881
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/core/drop_monitor.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 8e33cec9fc4e..2ee7bc4c9e03 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -213,6 +213,7 @@ static void sched_send_work(struct timer_list *t)
>  static void trace_drop_common(struct sk_buff *skb, void *location)
>  {
>  	struct net_dm_alert_msg *msg;
> +	struct net_dm_drop_point *point;
>  	struct nlmsghdr *nlh;
>  	struct nlattr *nla;
>  	int i;
> @@ -231,11 +232,13 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	nlh = (struct nlmsghdr *)dskb->data;
>  	nla = genlmsg_data(nlmsg_data(nlh));
>  	msg = nla_data(nla);
> +	point = msg->points;
>  	for (i = 0; i < msg->entries; i++) {
> -		if (!memcmp(&location, msg->points[i].pc, sizeof(void *))) {
> -			msg->points[i].count++;
> +		if (!memcmp(&location, &point->pc, sizeof(void *))) {
> +			point->count++;
>  			goto out;
>  		}
> +		point++;
>  	}
>  	if (msg->entries == dm_hit_limit)
>  		goto out;
> @@ -244,8 +247,8 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	 */
>  	__nla_reserve_nohdr(dskb, sizeof(struct net_dm_drop_point));
>  	nla->nla_len += NLA_ALIGN(sizeof(struct net_dm_drop_point));
> -	memcpy(msg->points[msg->entries].pc, &location, sizeof(void *));
> -	msg->points[msg->entries].count = 1;
> +	memcpy(point->pc, &location, sizeof(void *));
> +	point->count = 1;
>  	msg->entries++;
>  
>  	if (!timer_pending(&data->send_timer)) {
Acked-by: Neil Horman <nhorman@tuxdriver.com>
