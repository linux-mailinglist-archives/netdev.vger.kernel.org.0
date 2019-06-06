Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1FE369CF
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFFCI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:08:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44256 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFFCI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 22:08:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BABCA1456E95C;
        Wed,  5 Jun 2019 19:08:25 -0700 (PDT)
Date:   Wed, 05 Jun 2019 19:08:25 -0700 (PDT)
Message-Id: <20190605.190825.2245741686094611389.davem@davemloft.net>
To:     uli+renesas@fpond.eu
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com
Subject: Re: [PATCH v2] ravb: implement MTU change while device is up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559747660-17875-1-git-send-email-uli+renesas@fpond.eu>
References: <1559747660-17875-1-git-send-email-uli+renesas@fpond.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 19:08:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ulrich Hecht <uli+renesas@fpond.eu>
Date: Wed,  5 Jun 2019 17:14:20 +0200

> @@ -1811,11 +1811,14 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
>  static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
>  {
>  	if (netif_running(ndev))
> -		return -EBUSY;
> +		ravb_close(ndev);
>  
>  	ndev->mtu = new_mtu;
>  	netdev_update_features(ndev);
>  
> +	if (netif_running(ndev))
> +		return ravb_open(ndev);
> +

And if ravb_open() fails?  The user sees a failure, but to the user the failure
means the MTU change can't be done, yet the device has the new MTU set still.

This really is terrible behavior.

If you must do a prepare/commit kind of sequence for this to work properly if
you are going to go down the road of taking the device down to change the MTU
when the device is UP.
