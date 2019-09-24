Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFFCBC98A
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391068AbfIXN4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:56:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51840 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfIXN4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 09:56:53 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B22AC1525459D;
        Tue, 24 Sep 2019 06:56:51 -0700 (PDT)
Date:   Tue, 24 Sep 2019 15:56:50 +0200 (CEST)
Message-Id: <20190924.155650.2089667667300458495.davem@davemloft.net>
To:     zhangsha.zhang@huawei.com
Cc:     jay.vosburgh@canonical.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuehaibing@huawei.com, hunongda@huawei.com, alex.chen@huawei.com
Subject: Re: [PATCH v3] bonding: force enable lacp port after link state
 recovery for 802.3ad
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190918130620.8556-1-zhangsha.zhang@huawei.com>
References: <20190918130620.8556-1-zhangsha.zhang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 06:56:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <zhangsha.zhang@huawei.com>
Date: Wed, 18 Sep 2019 21:06:20 +0800

> From: Sha Zhang <zhangsha.zhang@huawei.com>
> 
> After the commit 334031219a84 ("bonding/802.3ad: fix slave link
> initialization transition states") merged,
> the slave's link status will be changed to BOND_LINK_FAIL
> from BOND_LINK_DOWN in the following scenario:
> - Driver reports loss of carrier and
>   bonding driver receives NETDEV_DOWN notifier
> - slave's duplex and speed is zerod and
>   its port->is_enabled is cleard to 'false';
> - Driver reports link recovery and
>   bonding driver receives NETDEV_UP notifier;
> - If speed/duplex getting failed here, the link status
>   will be changed to BOND_LINK_FAIL;
> - The MII monotor later recover the slave's speed/duplex
>   and set link status to BOND_LINK_UP, but remains
>   the 'port->is_enabled' to 'false'.
> 
> In this scenario, the lacp port will not be enabled even its speed
> and duplex are valid. The bond will not send LACPDU's, and its
> state is 'AD_STATE_DEFAULTED' forever. The simplest fix I think
> is to call bond_3ad_handle_link_change() in bond_miimon_commit,
> this function can enable lacp after port slave speed check.
> As enabled, the lacp port can run its state machine normally
> after link recovery.
> 
> Signed-off-by: Sha Zhang <zhangsha.zhang@huawei.com>

Please work out with Jay and Aleksei how to properly fix this.
