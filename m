Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCF043B4E8
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhJZO6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235818AbhJZO6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29DC860E74;
        Tue, 26 Oct 2021 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635260146;
        bh=L00Ey8pUReMds1W4+nA5X/CSUlaE39wuDJ1S7E8qLQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h3HYj9w392XlBuNu1K0Br5ZMS8CJsQc9YFYCLaJSKGjIHeRFgxXTHiaeD6X7qtks8
         NH5IupIRuW0046KYfXqwuFULRXoZMhXApWoIppSt9oSF59rSu7RPT9xaUCao+SsqxZ
         2bX76/F8S6xYEUZoI04FST31pDotnO99KYG5v0Cz8wDhVhM9Bv5GQB3tq20awMVSu8
         P8S1im705r1IhCGScf9Uru5ABarVmBEfpGF4RSLgc60wfI0g0Gn4Q+SRDOmnHKwrHN
         d0VzdlvL+WtIwx4Ig5uP18P2GZs/BBy9oU6rXLqqVm0pZD9KZUtnrQhPqaJ9TD66xJ
         fx7DDqpvfqWAw==
Date:   Tue, 26 Oct 2021 07:55:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, <davem@davemloft.net>,
        <mkubecek@suse.cz>, <andrew@lunn.ch>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211026075544.65256820@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8ce654b8-4a31-2d43-df7e-607528ba44d5@huawei.com>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
        <20211014113943.16231-5-huangguangbin2@huawei.com>
        <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
        <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
        <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211025190114.zbqgzsfiv7zav7aq@pengutronix.de>
        <8ce654b8-4a31-2d43-df7e-607528ba44d5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 22:41:19 +0800 huangguangbin (A) wrote:
> On 2021/10/26 3:01, Marc Kleine-Budde wrote:
> > On 25.10.2021 10:45:05, Jakub Kicinski wrote:  
> >> Indeed, there are different ways to extend the API for drivers,
> >> I think it comes down to personal taste. I find the "inheritance"
> >> models in C (kstruct usually contains the old struct as some "base")
> >> awkward.
> >>
> >> I don't think we have agreed-on best practice in the area.  
> > 
> >  From my point of view, if there already is an extension mainline:
> > 
> > | https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f3ccfda19319
> > 
> > I'm more in the flavor for modeling other extensions the same way. Would
> > be more consistent to name the new struct "kernel_"ethtool_ringparam,
> > following the coalescing example:
> > 
> > | struct kernel_ethtool_ringparam {
> > |        __u32   rx_buf_len;

nit: no __, just u32. It's not uAPI.

> > | };
> > 
> > regards,
> > Marc
> >   
> We think ethtool_ringparam_ext is more easy to understand it is extension of
> struct ethtool_ringparam. However, we don't mind to keep the same way and modify
> to the name kernel_ethtool_ringparam if everyone agrees.
> 
> Does anyone have other opinions?

Either way is fine by me. Andrew's way is fine too, as long as we don't
embed the old structure into the new one but translate field-by-field.
