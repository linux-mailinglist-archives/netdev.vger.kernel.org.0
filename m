Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AA02A82E2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgKEQA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgKEQA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:00:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 867C72087D;
        Thu,  5 Nov 2020 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604592026;
        bh=o56ev0zmgq63tK5Zw4wGWNNTE6ic1u4IRv6L1oyPU6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rkNVMg73EcGu44kEcc5jmciEzVU5VGUBs9LjQZ9+m/Eq8+4aCcJwKPKJLSj9MZv60
         WJPt55hHRTF6q45lfbWJ/4jdBI7fLFFPKFcddiJS1x8s9JdAJLw/BkPPXtYxcA+MaC
         3GEN2fLslBb0Ak07o2Sm/onNoeLg1eqp6v+jqT68=
Date:   Thu, 5 Nov 2020 08:00:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
Message-ID: <20201105080019.24bd43fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2f95eb05-6a2e-de29-4fd8-1dcff0ab0cfa@gmail.com>
References: <20201104102141.3489-1-tariqt@nvidia.com>
        <20201104132521.2f7c3690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2f95eb05-6a2e-de29-4fd8-1dcff0ab0cfa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 15:22:53 +0200 Tariq Toukan wrote:
> On 11/4/2020 11:25 PM, Jakub Kicinski wrote:
> > On Wed,  4 Nov 2020 12:21:41 +0200 Tariq Toukan wrote:  
> >> With NETIF_F_HW_TLS_TX packets are encrypted in HW. This cannot be
> >> logically done when HW_CSUM offload is off.  
> > 
> > Right. Do you expect drivers to nack clearing NETIF_F_HW_TLS_TX when
> > there are active connections, then?  I don't think NFP does.  We either
> > gotta return -EBUSY when there are offloaded connections, or at least
> > clearly document the expected behavior.
> 
> As I see from code, today drivers and TLS stack allow clearing 
> NETIF_F_HW_TLS_TX without doing anything to change behavior in existing 
> sockets, so they continue to do HW offload. Only new sockets will be 
> affected.

Right, we want to let users turn off the offload when it misbehaves,
and we don't have a way of un-offloading connections.

> I think the same behavior should apply when NETIF_F_HW_TLS_TX is cleared 
> implicitly (due to clearing HW_CSUM).

Right, I don't mind either way. My thinking with the tls feature was
that offload is likely to be broken, at least initially. Checksum
offload should work, one would hope, so its less of a risk.

The question is perhaps - do we care more about consistency with the
behavior of the TLS feature, or current expectation that csum offload
off will actually turn it off.

> If the existing behavior is not expected, and we should force fallback 
> to SW kTLS for existing sockets, then I think this should be fixed 
> independently to this patch, as it introduces no new regression.
> 
> What do you think?

The current behavior of the TLS features is documented in
tls-offload.rst, you can do what you're doing in this patch, 
but you need to document it there.
