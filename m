Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC50260104
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgIGQ5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730616AbgIGQeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0AD21D79;
        Mon,  7 Sep 2020 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496443;
        bh=uuUO6kHcVDNnH/wIg6TTJneR+OJeQf6S+KS0dfYWZg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l3AP9kkfMZPza+CT7MMGseWtaia9gWdxCjq8GzyUIQ2dUF+NRkeX3QVnNL4Zub7Pe
         aBHvkt52suoBfF2NK9BDhLA46veiltLcIBcZmVS0uXs6RsqqwUqXOTFOHmAuJ00dT/
         P9tAukcGBYn8QKVVLZG/54Bd/8NR1qXrZWD+VIcA=
Date:   Mon, 7 Sep 2020 09:34:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        yishaih@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200907093401.547ae9b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907071939.GK2997@nanopsycho.orion>
References: <20200904200621.2407839-1-kuba@kernel.org>
        <20200906072759.GC55261@unreal>
        <20200906093305.5c901cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200907062135.GJ2997@nanopsycho.orion>
        <20200907064830.GK55261@unreal>
        <20200907071939.GK2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 09:19:39 +0200 Jiri Pirko wrote:
> >The port type is being set to IB or ETH without relation to net_device,
> >fixing it will require very major code rewrite for the stable driver
> >that in maintenance mode.  
> 
> Because the eth driver is not loaded, I see. The purpose of the
> WARN in devlink_port_type_eth_set is to prevent drivers from registering
> particular port without netdev/ibdev. That is what was repeatedly
> happening in the past as the driver developers didn't know they need to
> do it or were just lazy to do so.
> 
> I wonder if there is any possibility to do both...

I think we have two options in this case:
 - set type to eth without the netdev
 - selectively mute the warning

I think the former is better, because we still want to see what the
port type is. Perhaps we should add a:

  dev_warn("devlink port type set without software interface
            reference, device type not supported by the kernel?");

That way people won't just pass NULL out of laziness, hopefully.

WDYT?
