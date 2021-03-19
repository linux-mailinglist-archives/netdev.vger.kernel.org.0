Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626EF341B4C
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 12:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhCSLUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 07:20:38 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45689 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhCSLUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 07:20:19 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4A1BA221E6;
        Fri, 19 Mar 2021 12:20:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1616152817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0znsRcMt40TMej64H4IGJ1CDLfFMnqG3HzV6wk+Zhro=;
        b=Du6flcIYDxAOlLAQjfVoBr2OcI6lrm+DdOHdxRR/BzR+xu+hZ8XwktkqmdIEUWoJKPpZCE
        f5F8USqaMF8efOb3eceQYlRZVhglndIz6K7CncazrL3L8eI/bJGGWfwdTb86BsUrrBsVHE
        B5wzo0GJTddExOTZu9t3v8Rkqt1euOI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 19 Mar 2021 12:20:15 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: enetc: teardown CBDR during PF/VF unbind
In-Reply-To: <20210319100806.801581-1-olteanv@gmail.com>
References: <20210319100806.801581-1-olteanv@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f64aeb3ed16df43363bbbbe5f8003785@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-03-19 11:08, schrieb Vladimir Oltean:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Michael reports that after the blamed patch, unbinding a VF would cause
> these transactions to remain pending, and trigger some warnings with 
> the
> DMA API debug:
> 
> $ echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
> pci 0000:00:01.0: [1957:ef00] type 00 class 0x020001
> fsl_enetc_vf 0000:00:01.0: Adding to iommu group 19
> fsl_enetc_vf 0000:00:01.0: enabling device (0000 -> 0002)
> fsl_enetc_vf 0000:00:01.0 eno0vf0: renamed from eth0
> 
> $ echo 0 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
> DMA-API: pci 0000:00:01.0: device driver has pending DMA allocations
> while released from device [count=1]
> One of leaked entries details: [size=2048 bytes] [mapped with
> DMA_BIDIRECTIONAL] [mapped as coherent]
> WARNING: CPU: 0 PID: 2547 at kernel/dma/debug.c:853
> dma_debug_device_change+0x174/0x1c8
> (...)
> Call trace:
>  dma_debug_device_change+0x174/0x1c8
>  blocking_notifier_call_chain+0x74/0xa8
>  device_release_driver_internal+0x18c/0x1f0
>  device_release_driver+0x20/0x30
>  pci_stop_bus_device+0x8c/0xe8
>  pci_stop_and_remove_bus_device+0x20/0x38
>  pci_iov_remove_virtfn+0xb8/0x128
>  sriov_disable+0x3c/0x110
>  pci_disable_sriov+0x24/0x30
>  enetc_sriov_configure+0x4c/0x108
>  sriov_numvfs_store+0x11c/0x198
> (...)
> DMA-API: Mapped at:
>  dma_entry_alloc+0xa4/0x130
>  debug_dma_alloc_coherent+0xbc/0x138
>  dma_alloc_attrs+0xa4/0x108
>  enetc_setup_cbdr+0x4c/0x1d0
>  enetc_vf_probe+0x11c/0x250
> pci 0000:00:01.0: Removing from iommu group 19
> 
> This happens because stupid me moved enetc_teardown_cbdr outside of
> enetc_free_si_resources, but did not bother to keep calling
> enetc_teardown_cbdr from all the places where enetc_free_si_resources
> was called. In particular, now it is no longer called from the main
> unbind function, just from the probe error path.
> 
> Fixes: 4b47c0b81ffd ("net: enetc: don't initialize unused ports from a
> separate code path")
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Michael Walle <michael@walle.cc>

Thanks!

-michael
