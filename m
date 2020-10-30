Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D4A2A1032
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgJ3V24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgJ3V2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 17:28:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8B7221FA;
        Fri, 30 Oct 2020 21:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604093334;
        bh=2WfncEEDDukpj4PzdMv1Nnhzkfd4P1u9ddu3zLF5R8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xcaL5ydamrsW7ntfLrUyvV6mJU6FBG6wW/Ax3ruUehwGQggtZ4bdqnrRRpYzXuIUZ
         EfFIXN74IqN6N7S77tFrtKYdz1lgWIlavDQAgWxAJfZ2plE2yt7QWNs1nQYMpZVGS/
         4TiGJs5Qg3CRIGbTSRnSQ428jsAD9AlPS1IMfhR0=
Date:   Fri, 30 Oct 2020 14:28:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: silence suspicious RCU usage
 warning
Message-ID: <20201030142852.7d41eecc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <160398318667.8898.856205445259063348.stgit@ebuild>
References: <160398318667.8898.856205445259063348.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:53:21 +0100 Eelco Chaudron wrote:
> Silence suspicious RCU usage warning in ovs_flow_tbl_masks_cache_resize()
> by replacing rcu_dereference() with rcu_dereference_ovsl().
> 
> In addition, when creating a new datapath, make sure it's configured under
> the ovs_lock.
> 
> Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
> Reported-by: syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  net/openvswitch/datapath.c   |    8 ++++----
>  net/openvswitch/flow_table.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 832f898edb6a..020f8539fede 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1695,6 +1695,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	if (err)
>  		goto err_destroy_ports;
>  
> +	/* So far only local changes have been made, now need the lock. */
> +	ovs_lock();

Should we move the lock below assignments to param?

Looks a little strange to protect stack variables with a global lock.

>  	/* Set up our datapath device. */
>  	parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
>  	parms.type = OVS_VPORT_TYPE_INTERNAL;
> @@ -1707,9 +1710,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	if (err)
>  		goto err_destroy_meters;
>  
> -	/* So far only local changes have been made, now need the lock. */
> -	ovs_lock();
> -
>  	vport = new_vport(&parms);
>  	if (IS_ERR(vport)) {
>  		err = PTR_ERR(vport);
> @@ -1725,7 +1725,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  				ovs_dp_reset_user_features(skb, info);
>  		}
>  
> -		ovs_unlock();
>  		goto err_destroy_meters;
>  	}
>  
> @@ -1742,6 +1741,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	return 0;
>  
>  err_destroy_meters:

Let's update the name of the label.

> +	ovs_unlock();
>  	ovs_meters_exit(dp);
>  err_destroy_ports:
>  	kfree(dp->ports);
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index f3486a37361a..c89c8da99f1a 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -390,7 +390,7 @@ static struct mask_cache *tbl_mask_cache_alloc(u32 size)
>  }
>  int ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size)
>  {
> -	struct mask_cache *mc = rcu_dereference(table->mask_cache);
> +	struct mask_cache *mc = rcu_dereference_ovsl(table->mask_cache);
>  	struct mask_cache *new;
>  
>  	if (size == mc->cache_size)
> 

