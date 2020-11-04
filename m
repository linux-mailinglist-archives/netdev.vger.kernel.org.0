Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F662A71D5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbgKDXdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731539AbgKDXdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 18:33:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AEA22074B;
        Wed,  4 Nov 2020 23:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604532802;
        bh=pLgzlZcEoMWv2J4Mk1Xd7jOAN5YoKXgl49GtlZW2QNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JmQgCSoSsXOhiz82qHrpYSpMT86LMGk98P+q/NWFve+aj9dPapUGXW2jZtVpjbCl/
         lBnZXOwQS4ULyHLXRG0cdVMt+bbLtxZ5Ttcj9SIMxFSEEBYU/jrGwVB/hTcaLzotjg
         +b2z5paNfpiUwSq5ORfkMRu/7q+Vm9ROOGUecoZE=
Date:   Wed, 4 Nov 2020 15:33:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 1/6] i40e: introduce lazy Tx completions for
 AF_XDP zero-copy
Message-ID: <20201104153320.66cecba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604498942-24274-2-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
        <1604498942-24274-2-git-send-email-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 15:08:57 +0100 Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Introduce lazy Tx completions when a queue is used for AF_XDP
> zero-copy. In the current design, each time we get into the NAPI poll
> loop we try to complete as many Tx packets as possible from the
> NIC. This is performed by reading the head pointer register in the NIC
> that tells us how many packets have been completed. Reading this
> register is expensive as it is across PCIe, so let us try to limit the
> number of times it is read by only completing Tx packets to user-space
> when the number of available descriptors in the Tx HW ring is below
> some threshold. This will decrease the number of reads issued to the
> NIC and improves performance with 1.5% - 2% for the l2fwd xdpsock
> microbenchmark.
> 
> The threshold is set to the minimum possible size that the HW ring can
> have. This so that we do not run into a scenario where the threshold
> is higher than the configured number of descriptors in the HW ring.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

I feel like this needs a big fat warning somewhere.

It's perfectly fine to never complete TCP packets, but AF_XDP could be
used to implement protocols in user space. What if someone wants to
implement something like TSQ?
