Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555A820D7E0
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbgF2Tdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbgF2TdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:33:19 -0400
Received: from localhost (mobile-166-170-222-206.mycingular.net [166.170.222.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA31A206E2;
        Mon, 29 Jun 2020 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593459199;
        bh=S0YdjtPRSSlnoNdihph14QS32xSkaKxF4OYCSio0GLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=opm5/3ZKjNT8OrAL+IyGlJIOqrB869sIflfMIebZ+o5mNYTqOegs/4sBzCzNYVZxI
         Jm+XxAYDkrNFpAmyh04dupvYYCtLyFxJUJqAWShS8dXKFcBeH9nBs+z+ruWIQA5Yo6
         EgXpkLslb1j2PttdG0sCiQRzqTqZ5B3NV2QBzujM=
Date:   Mon, 29 Jun 2020 14:33:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, linux-pci@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        Casey Leedom <leedom@chelsio.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200629193316.GA3283437@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca121a18-8c11-5830-9840-51f353c3ddd2@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Ashok, Ding, Casey]

On Mon, Jun 29, 2020 at 12:32:44PM +0300, Aya Levin wrote:
> I wanted to turn on RO on the ETH driver based on
> pcie_relaxed_ordering_enabled().
> From my experiments I see that pcie_relaxed_ordering_enabled() return true
> on Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. This CPU is from Haswell
> series which is known to have bug in RO implementation. In this case, I
> expected pcie_relaxed_ordering_enabled() to return false, shouldn't it?

Is there an erratum for this?  How do we know this device has a bug
in relaxed ordering?

> In addition, we are worried about future bugs in new CPUs which may result
> in performance degradation while using RO, as long as the function
> pcie_relaxed_ordering_enabled() will return true for these CPUs. 

I'm worried about this too.  I do not want to add a Device ID to the
quirk_relaxedordering_disable() list for every new Intel CPU.  That's
a huge hassle and creates a real problem for old kernels running on
those new CPUs, because things might work "most of the time" but not
always.

Maybe we need to prevent the use of relaxed ordering for *all* Intel
CPUs.

> That's why
> we thought of adding the feature on our card with default off and enable the
> user to set it.

Bjorn
