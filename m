Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4540439DD5
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhJYRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhJYRra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:47:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39B460F4F;
        Mon, 25 Oct 2021 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635183908;
        bh=bhjdTGOIGvU3IA/dEUMtefq7QpPdbxtZdNryKp8NUgY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SQz6JfrCueWoQ0oWcVHw6w8nKPyKw1iqJNIwb5WLWtPivB1hSfO1iD+HVNtbGSShm
         Fz1VGjLjvHRdE5+qjAMNPvj3XygelMqo8CAN3f5XBn4fNOVZa0eDVGDOHZgzogi2/A
         u/UKp3BK+mfmcg2781YUPkDPv2QdkwAD6tA1MuHTZlGoE02ixVg1K9zXRSOo9CM8p7
         PcBUM0GZbCjvB3m/YtJITaa+vG7sdM0/+xWWMGM4uzrZpsn95hNvf8opRtDDG63t9P
         tAOMHbFCrVDC37XaxCYSFcTQ9RgM3amrsU9flWt8qMG7rSiAmpcGWTxSIW0wpbS0zE
         FnG+N9P8eJbsA==
Date:   Mon, 25 Oct 2021 10:45:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        mkubecek@suse.cz, andrew@lunn.ch, amitc@mellanox.com,
        idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
        <20211014113943.16231-5-huangguangbin2@huawei.com>
        <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
        <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 15:27:18 +0200 Marc Kleine-Budde wrote:
> On 25.10.2021 15:11:49, Marc Kleine-Budde wrote:
> > On 14.10.2021 19:39:41, Guangbin Huang wrote:  
> > > From: Hao Chen <chenhao288@hisilicon.com>
> > > 
> > > Add two new parameters ringparam_ext and extack for
> > > .get_ringparam and .set_ringparam to extend more ring params
> > > through netlink.
> > > 
> > > Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> > > Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>  
> > 
> > While discussing a different ethtool ring param extension,  
> 
> Let me explain my requirements:
> 
> There is a not Ethernet based bus system, called CAN (mainly used in the
> automotive and industrial world). It comes in 2 different generations or
> modes (CAN-2.0 and CAN-FD) and the 3rd one CAN-XL has already been
> specified.
> 
> Due to different frame sizes used in these CAN modes and HW limitations,
> we need the possibility to set a RX/TX ring configuration for each of
> these modes.
> 
> The approach Andrew suggested is two-fold. First introduce a "struct
> ethtool_kringparam" that's only used inside the kernel, as "struct
> ethtool_ringparam" is ABI. Then extend "struct ethtool_kringparam" as
> needed.

Indeed, there are different ways to extend the API for drivers,
I think it comes down to personal taste. I find the "inheritance" 
models in C (kstruct usually contains the old struct as some "base")
awkward.

I don't think we have agreed-on best practice in the area.
