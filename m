Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3838269815
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgINVpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgINVp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:45:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB2C208DB;
        Mon, 14 Sep 2020 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600119925;
        bh=MrKDcm4QhfS4JW43IvNQBg7V7LnF4erm6voWMCdgFxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2l8Ws3d83rQUjHn8OWu7OLJJ9jrIvf/33FT9bhBB937ks0x1wrhlqmPy8Y+fpCbHZ
         PTrSYaHfIZ+R89c4huMs3KO6KnGNWhjr+79O0DvdGWhwAq6I75hNRVD1b7IZAbrlLX
         Ikr/yBUEVfESQZPk/B4Lf+O2tsLmwfMyjx4jTmQc=
Date:   Mon, 14 Sep 2020 14:45:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH net-next 5/6] net: hns3: use writel() to optimize the
 barrier operation
Message-ID: <20200914144522.02d469a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600085217-26245-6-git-send-email-tanhuazhong@huawei.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
        <1600085217-26245-6-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 20:06:56 +0800 Huazhong Tan wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> writel() can be used to order I/O vs memory by default when
> writing portable drivers. Use writel() to replace wmb() +
> writel_relaxed(), and writel() is dma_wmb() + writel_relaxed()
> for ARM64, so there is an optimization here because dma_wmb()
> is a lighter barrier than wmb().

Cool, although lots of drivers will need a change like this now. 

And looks like memory-barriers.txt is slightly, eh, not coherent there,
between the documentation of writeX() and dma_wmb() :S

	3. A writeX() by a CPU thread to the peripheral will first wait for the
	   completion of all prior writes to memory either issued by, or
	   propagated to, the same thread. This ensures that writes by the CPU
	   to an outbound DMA buffer allocated by dma_alloc_coherent() will be
	   visible to a DMA engine when the CPU writes to its MMIO control
	   register to trigger the transfer.



 (*) dma_wmb();
 (*) dma_rmb();

     These are for use with consistent memory to guarantee the ordering
     of writes or reads of shared memory accessible to both the CPU and a
     DMA capable device.

     For example, consider a device driver that shares memory with a device
     and uses a descriptor status value to indicate if the descriptor belongs
     to the device or the CPU, and a doorbell to notify it when new
     descriptors are available:

	if (desc->status != DEVICE_OWN) {
		/* do not read data until we own descriptor */
		dma_rmb();

		/* read/modify data */
		read_data = desc->data;
		desc->data = write_data;

		/* flush modifications before status update */
		dma_wmb();

		/* assign ownership */
		desc->status = DEVICE_OWN;

		/* notify device of new descriptors */
		writel(DESC_NOTIFY, doorbell);
	}

     The dma_rmb() allows us guarantee the device has released ownership
     before we read the data from the descriptor, and the dma_wmb() allows
     us to guarantee the data is written to the descriptor before the device
     can see it now has ownership.  Note that, when using writel(), a prior
     wmb() is not needed to guarantee that the cache coherent memory writes
     have completed before writing to the MMIO region.  The cheaper
     writel_relaxed() does not provide this guarantee and must not be used
     here.
