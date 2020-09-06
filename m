Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24D25EF85
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 20:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgIFSl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 14:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbgIFSlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 14:41:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA74120759;
        Sun,  6 Sep 2020 18:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599417715;
        bh=F0mk1QO0HqDSARTtYtap/jH8rSgeDmoL5AM/fRQZRQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0LSOGShtMWu6ib6qChbBeINrYqL0BHuXV4S3A8cXFMvPC3r4cwXqodmNpjK/bfSga
         SwH969PRX7XlH6fKLz8CV8pWvYRiQ7fmhyHdgsZoOjioq8yEbq0vJF51W+oM8rskYV
         eo9QfjUdhfviKLybhwf3bI0qIETTb8e6qlVtOMko=
Date:   Sun, 6 Sep 2020 11:41:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next 0/2] net: two updates related to UDP GSO
Message-ID: <20200906114153.7dccce5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com>
References: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 14:11:11 +0800 Huazhong Tan wrote:
> There are two updates relates to UDP GSO.
> #1 adds a new GSO type for UDPv6
> #2 adds check for UDP GSO when csum is disable in netdev_fix_features().
> 
> Changes since RFC V2:
> - modifies the timing of setting UDP GSO type when doing UDP GRO in #1.
> 
> Changes since RFC V1:
> - updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
>   and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
>   - add #2 who needs #1.

Please CC people who gave you feedback (Willem). 

I don't feel good about this series. IPv6 is not optional any more.
AFAIU you have some issues with csum support in your device? Can you
use .ndo_features_check() to handle this?

The change in semantics of NETIF_F_GSO_UDP_L4 from "v4 and v6" to 
"just v4" can trip people over; this is not a new feature people 
may be depending on the current semantics.

Willem, what are your thoughts on this?
