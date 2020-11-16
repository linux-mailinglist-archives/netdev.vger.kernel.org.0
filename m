Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F02B4EF1
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbgKPSMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgKPSMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 13:12:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F112078E;
        Mon, 16 Nov 2020 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605550358;
        bh=LjQ/MMjl64/Jl8ZPC785yG7LunzvzinO5RMl3P0oUys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ijb8pVNTxyxIxJvRLjeK5Q6rVWlDY6hf9IYfVUTfZXEaE6WhgozgTe5f1ObpeRF8H
         u5PktOGlunVmfYoCSKJDZol62284DlKxpxaiE0UDHzOUYusRK2XBTo1eCUafIKf86E
         NqunYoyZBpoKfPdcRXG7fXVxOlGyFkhWN8UdaJGw=
Date:   Mon, 16 Nov 2020 10:12:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        Jiri Pirko <jiri@resnulli.us>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH V3 net-next 06/10] net: hns3: add ethtool priv-flag for
 DIM
Message-ID: <20201116101236.64fc9c49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <370fe668-d719-6380-f172-ad01edeb666e@huawei.com>
References: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
        <1605151998-12633-7-git-send-email-tanhuazhong@huawei.com>
        <20201114105423.07c2ce67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <370fe668-d719-6380-f172-ad01edeb666e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:41:45 +0800 tanhuazhong wrote:
> On 2020/11/15 2:54, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 11:33:14 +0800 Huazhong Tan wrote:  
> >> Add a control private flag in ethtool for enable/disable
> >> DIM feature.
> >>
> >> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>  
> > 
> > Please work on a common ethtool API for the configuration instead of
> > using private flags.
> > 
> > Private flags were overused because the old IOCTL-based ethtool was
> > hard to extend, but we have a netlink API now.
> > 
> > For example here you're making a choice between device and DIM
> > implementation of IRQ coalescing. You can add a new netlink attribute
> > to the ETHTOOL_MSG_COALESCE_GET/ETHTOOL_MSG_COALESCE_SET commands which
> > controls the type of adaptive coalescing (if enabled).
> 
> The device's implementation of IRQ coalescing will be removed, if DIM 
> works ok for a long time. So could this private flag for DIM be 
> uptreamed as a transition scheme? And adding a new netlink attrtibute to 
> controls the type of adaptive coalescing seems useless for other drivers.

The information whether the adaptive behavior is implemented by DIM,
device or custom driver implementation is useful regardless. Right now
users only see "adaptive" and don't know what implements it - device,
DIM or is it a custom implementation in the driver. So regardless if
you remove the priv flag, the "read"/"get" side of the information will
still be useful.

Besides you have another priv flag in this set that needs to be
converted to a generic attribute - the one for the timer reset
behavior.
