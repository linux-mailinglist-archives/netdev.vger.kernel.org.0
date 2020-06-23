Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CFA206522
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393633AbgFWVb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388685AbgFWVbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:31:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A53922078A;
        Tue, 23 Jun 2020 21:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592947879;
        bh=B7onChlE/boz2zJORl0fpzdFl/rHlDuBUXINddHNGDw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WIwYoec4Q1HVmrtTmgxtXPOFLgN+koBAXyeQyrY9QipX8iqEElWIH6cYnjtHLgMhJ
         BIOGyPKc5fEic+iDhmsNLANVE6wV15Km2v8GDcSciwUsLPH45+GXWzYyi3JMf3i7rt
         utCUgF2reVeF8CtaQcHCzlPUvjM4RFrUkxEUANnU=
Date:   Tue, 23 Jun 2020 14:31:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed
 ordering
Message-ID: <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623195229.26411-11-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
        <20200623195229.26411-11-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 12:52:29 -0700 Saeed Mahameed wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> The concept of Relaxed Ordering in the PCI Express environment allows
> switches in the path between the Requester and Completer to reorder some
> transactions just received before others that were previously enqueued.
> 
> In ETH driver, there is no question of write integrity since each memory
> segment is written only once per cycle. In addition, the driver doesn't
> access the memory shared with the hardware until the corresponding CQE
> arrives indicating all PCI transactions are done.

Assuming the device sets the RO bits appropriately, right? Otherwise
CQE write could theoretically surpass the data write, no?

> With relaxed ordering set, traffic on the remote-numa is at the same
> level as when on the local numa.

Same level of? Achievable bandwidth?

> Running TCP single stream over ConnectX-4 LX, ARM CPU on remote-numa
> has 300% improvement in the bandwidth.
> With relaxed ordering turned off: BW:10 [GB/s]
> With relaxed ordering turned on:  BW:40 [GB/s]
> 
> The driver turns relaxed ordering off by default. It exposes 2 boolean
> private-flags in ethtool: pci_ro_read and pci_ro_write for user
> control.
> 
> $ ethtool --show-priv-flags eth2
> Private flags for eth2:
> ...
> pci_ro_read        : off
> pci_ro_write       : off
> 
> $ ethtool --set-priv-flags eth2 pci_ro_write on
> $ ethtool --set-priv-flags eth2 pci_ro_read on

I think Michal will rightly complain that this does not belong in
private flags any more. As (/if?) ARM deployments take a foothold 
in DC this will become a common setting for most NICs.
