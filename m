Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB152C305F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404104AbgKXTCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390881AbgKXTCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 14:02:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C00204FD;
        Tue, 24 Nov 2020 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606244525;
        bh=PW4WMI4gJ6Ccl9hIj/7wrZ3x0ZDqbNJOOj0gKSntkbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sN5ZukW2s3wpA8/aMX1/mW0W5ROOvDFe7mOIUTu3xUvhDw/tsBBp6s4lpPgfBBjko
         wrpcUsvv8QbDp0YR+Q6nRCV4RBgAT5Z6MhSYWqWvtd1UqssF0eVGeL5IyvE6dkNkFQ
         zbqmuYjzMJqWYQm21z1Zqo/ZLA2N4rMHd6i1jGSs=
Date:   Tue, 24 Nov 2020 11:02:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH net v5] aquantia: Remove the build_skb path
Message-ID: <20201124110202.38dc6d5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MWHPR1001MB23184F3EAFA413E0D1910EC9E8FC0@MWHPR1001MB2318.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119221510.GI15137@breakpoint.cc>
        <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119222800.GJ15137@breakpoint.cc>
        <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119225842.GK15137@breakpoint.cc>
        <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201121132324.72d79e94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CY4PR1001MB2311E9770EF466FB922CBB27E8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201123084243.423b23a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MWHPR1001MB23184F3EAFA413E0D1910EC9E8FC0@MWHPR1001MB2318.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 21:40:43 +0000 Ramsay, Lincoln wrote:
> From: Lincoln Ramsay <lincoln.ramsay@opengear.com>
> 
> When performing IPv6 forwarding, there is an expectation that SKBs
> will have some headroom. When forwarding a packet from the aquantia
> driver, this does not always happen, triggering a kernel warning.
> 
> aq_ring.c has this code (edited slightly for brevity):
> 
> if (buff->is_eop && buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
>     skb = build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);
> } else {
>     skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
> 
> There is a significant difference between the SKB produced by these
> 2 code paths. When napi_alloc_skb creates an SKB, there is a certain
> amount of headroom reserved. However, this is not done in the
> build_skb codepath.
> 
> As the hardware buffer that build_skb is built around does not
> handle the presence of the SKB header, this code path is being
> removed and the napi_alloc_skb path will always be used. This code
> path does have to copy the packet header into the SKB, but it adds
> the packet data as a frag.
> 
> Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
> Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>

Applied, queued of stable.

Thanks!
