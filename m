Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8F3C3523
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 17:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhGJPc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 11:32:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49064 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhGJPcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 11:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TYiG2EqNKSzkSuCYPnt+Lx1AOJY2xXfDL9r7Cx7cDS8=; b=MseDGGphRUm/HogPIoPvVcqFvH
        8SxiAv6z0IA3wio5xG3xk9geeD3cMQ8ddE9uqZhVv+tMUPYvX/gG/AxS1Aw0qOkFnOF58UQ8JnZiQ
        Mr/1YRmRrQxfR9lqnWt4g+gsEq4QXdtbvPAZDoaRdhBTcJOrNwEcAVv6YAjsPWSegsUs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m2Ev4-00CtH5-8g; Sat, 10 Jul 2021 17:29:30 +0200
Date:   Sat, 10 Jul 2021 17:29:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFC net-next] net: extend netdev features
Message-ID: <YOm82gTf/efnR7Fj@lunn.ch>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 05:40:47PM +0800, Jian Shen wrote:
> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit.

The PHY subsystem had a similar problem a while back. supported and
advertised link modes where represented as bits in a u64. We changed
to a linux bitmap, with wrappers around it. Take a look at the
linkmode_ API usage in drivers/net/phy, and some Ethernet drivers.

It is going to be a big change, but i think you need to do something
similar here. Add a netdev_feature_ API for manipulating features,
convert all users to this API, and then change the implementation of
the API to allow more bits.

You will want to make use of code re-writing tools to do most of the
work.

	Andrew
