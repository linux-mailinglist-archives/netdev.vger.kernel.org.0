Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC0CCE01F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfJGLWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfJGLWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:22:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABC753086228;
        Mon,  7 Oct 2019 11:22:22 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7275360606;
        Mon,  7 Oct 2019 11:22:17 +0000 (UTC)
Date:   Mon, 7 Oct 2019 13:22:15 +0200
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
Subject: Re: [PATCH net v4 12/12] virt_wifi: fix refcnt leak in module exit
 routine
Message-ID: <20191007112215.GA1288400@bistromath.localdomain>
References: <20190928164843.31800-1-ap420073@gmail.com>
 <20190928164843.31800-13-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190928164843.31800-13-ap420073@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 07 Oct 2019 11:22:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-09-28, 16:48:43 +0000, Taehee Yoo wrote:
> virt_wifi_newlink() calls netdev_upper_dev_link() and it internally
> holds reference count of lower interface.
> 
> Current code does not release a reference count of the lower interface
> when the lower interface is being deleted.
> So, reference count leaks occur.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add vw1 link dummy0 type virt_wifi

There should also be "ip link del dummy0" in this reproducer, right?

[...]

> @@ -598,14 +634,24 @@ static int __init virt_wifi_init_module(void)
>  	/* Guaranteed to be locallly-administered and not multicast. */
>  	eth_random_addr(fake_router_bssid);
>  
> +	err = register_netdevice_notifier(&virt_wifi_notifier);
> +	if (err)
> +		return err;
> +

Here err is 0.

>  	common_wiphy = virt_wifi_make_wiphy();
>  	if (!common_wiphy)
> -		return -ENOMEM;
> +		goto notifier;

err is still 0 when we jump...

>  	err = rtnl_link_register(&virt_wifi_link_ops);
>  	if (err)
> -		virt_wifi_destroy_wiphy(common_wiphy);
> +		goto destroy_wiphy;
>  
> +	return 0;
> +
> +destroy_wiphy:
> +	virt_wifi_destroy_wiphy(common_wiphy);
> +notifier:
> +	unregister_netdevice_notifier(&virt_wifi_notifier);
>  	return err;
>  }

... so now we return 0 on failure. Can you add an "err = -ENOMEM"
before "common_wiphy = ..."?

Thanks.

-- 
Sabrina
