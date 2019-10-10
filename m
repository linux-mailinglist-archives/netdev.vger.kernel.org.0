Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C4DD2707
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfJJKTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfJJKTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 06:19:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68BBC30655F9;
        Thu, 10 Oct 2019 10:19:32 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.36.118.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4CF960BF4;
        Thu, 10 Oct 2019 10:19:26 +0000 (UTC)
Date:   Thu, 10 Oct 2019 12:19:25 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, roopa@cumulusnetworks.com,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        stephen@networkplumber.org, sashal@kernel.org, hare@suse.de,
        varun@chelsio.com, ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
Message-ID: <20191010101925.GA93190@bistromath.localdomain>
References: <20190928164843.31800-1-ap420073@gmail.com>
 <20190928164843.31800-2-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190928164843.31800-2-ap420073@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 10 Oct 2019 10:19:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-09-28, 16:48:32 +0000, Taehee Yoo wrote:
> @@ -6790,23 +6878,45 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
>  					void *data),
>  			      void *data)
>  {
> -	struct net_device *ldev;
> -	struct list_head *iter;
> -	int ret;
> +	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
> +	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
> +	int ret, cur = 0;
>  
> -	for (iter = &dev->adj_list.lower,
> -	     ldev = netdev_next_lower_dev(dev, &iter);
> -	     ldev;
> -	     ldev = netdev_next_lower_dev(dev, &iter)) {
> -		/* first is the lower device itself */
> -		ret = fn(ldev, data);
> -		if (ret)
> -			return ret;
> +	now = dev;
> +	iter = &dev->adj_list.lower;
>  
> -		/* then look at all of its lower devices */
> -		ret = netdev_walk_all_lower_dev(ldev, fn, data);
> -		if (ret)
> -			return ret;
> +	while (1) {
> +		if (now != dev) {
> +			ret = fn(now, data);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		next = NULL;
> +		while (1) {
> +			ldev = netdev_next_lower_dev(now, &iter);
> +			if (!ldev)
> +				break;
> +
> +			if (!next) {
> +				next = ldev;
> +				niter = &ldev->adj_list.lower;
> +			} else {
> +				dev_stack[cur] = ldev;
> +				iter_stack[cur++] = &ldev->adj_list.lower;
> +				break;
> +			}
> +		}
> +
> +		if (!next) {
> +			if (!cur)
> +				return 0;

Hmm, I don't think this condition is correct.

If we have this topology:


                bridge0
                /  |  \
               /   |   \
              /    |    \
        dummy0   vlan1   vlan2
                   |       \
                 dummy1    dummy2

We end up with the expected lower/upper levels for all devices:

    | device  | upper | lower |
    |---------+-------+-------|
    | dummy0  |     2 |     1 |
    | dummy1  |     3 |     1 |
    | dummy2  |     3 |     1 |
    | vlan1   |     2 |     2 |
    | vlan2   |     2 |     2 |
    | bridge0 |     1 |     3 |


If we then add macvlan0 on top of bridge0:


                macvlan0
                   |
                   |
                bridge0
                /  |  \
               /   |   \
              /    |    \
        dummy0   vlan1   vlan2
                   |       \
                 dummy1    dummy2


we can observe that __netdev_update_upper_level is only called for
some of the devices under bridge0. I added a perf probe:

 # perf probe -a '__netdev_update_upper_level dev->name:string'

which gets hit for bridge0 (called directly by
__netdev_upper_dev_link) and then dummy0, vlan1, dummy1. It is never
called for vlan2 and dummy2.

After this, we have the following levels (*):

    | device   | upper | lower |
    |----------+-------+-------|
    | dummy0   |     3 |     1 |
    | dummy1   |     4 |     1 |
    | dummy2   |     3 |     1 |
    | vlan1    |     3 |     2 |
    | vlan2    |     2 |     2 |
    | bridge0  |     2 |     3 |
    | macvlan0 |     1 |     4 |

For dummy0, dummy1, vlan1, the upper level has increased by 1, as
expected. For dummy2 and vlan2, it's still the same, which is wrong.


(*) observed easily by adding another probe:

 # perf probe -a 'dev_get_stats dev->name:string dev->upper_level dev->lower_level'

and running "ip link"

Or you can just add prints and recompile, of course :)

> +			next = dev_stack[--cur];
> +			niter = iter_stack[cur];
> +		}
> +
> +		now = next;
> +		iter = niter;
>  	}
>  
>  	return 0;

-- 
Sabrina
