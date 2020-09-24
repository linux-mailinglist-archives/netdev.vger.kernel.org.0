Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC48277627
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgIXQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbgIXQDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 12:03:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8026D235FD;
        Thu, 24 Sep 2020 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600963394;
        bh=nx5fc2qT1dKDZhxupdYrhOZWNqt6L+jeM++9RJd8mCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qn3Qw8NuLhWrWdS/B5Pp0Xnhkr2KJ6x7oyHwbslo70YKDR/bb/jEFI3Z8X37Ov6KU
         IUOH8BCXVL9yXxDWV3pJOf+4Rt2ce2AjWtRWrEQn/XNGE9tojnLNJjGdZKv5u2B+YW
         dWg04EXwEQj9m0lmCisaJCevm9pamzB5nKcB/EqI=
Date:   Thu, 24 Sep 2020 09:03:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     David Miller <davem@davemloft.net>, hkallweit1@gmail.com,
        geert+renesas@glider.be, f.fainelli@gmail.com, andrew@lunn.ch,
        gaku.inami.xh@renesas.com, yoshihiro.shimoda.uh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
Message-ID: <20200924090311.745cac3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2cf4178e970d2737e7ba866ebc83a7ec30ca8ad1.camel@kernel.org>
References: <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
        <a7ff1afd2e1fc2232103ceb9aa763064daf90212.camel@kernel.org>
        <20200923.172125.1341776337290371000.davem@davemloft.net>
        <20200923.172349.872678515629678579.davem@davemloft.net>
        <2cf4178e970d2737e7ba866ebc83a7ec30ca8ad1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 22:49:37 -0700 Saeed Mahameed wrote:
> 2) Another problematic scenario which i see is repeated in many
> drivers:
> 
> shutdown/suspend()
>     rtnl_lock()
>     netif_device_detach()//Mark !present;
>     stop()->carrier_off()->linkwatch_event()
>     // at this point device is still IFF_UP and !present
>     // due to the early detach above..  
>     rtnl_unlock();

Maybe we can solve this by providing drivers with a better helper for
the suspend use case?

AFAIU netif_device_detach() is used by both IO errors and drivers
willingly detaching the device during normal operation (e.g. for
suspend).

Since the suspend path can sleep if we have a separate helper perhaps
we could fire off the appropriate events synchronously, and quiescence
the stack properly?
