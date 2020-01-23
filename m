Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF23146EC8
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgAWQ7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgAWQ7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 11:59:07 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D982071E;
        Thu, 23 Jan 2020 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579798747;
        bh=kSGcMTzAf4NiR0SgzGIPmzGXO+zaWusO8GxX42p0iIc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0N8Psd0uums0PGJRB9OdJVzkPo9Mfe++Q1LgNtwD1fi5N1TZBFx8eYEUAjT1pbh63
         Sv8OX4mDZmVVfeP9DrbffU9L9jFVm184UokrlZWMMcKzTT62mXb8shjU9Wo3QmjgOO
         l+TP4ZNPwFb7EcA9dzJv9I3HGCmPRvCCqWrsTZjk=
Date:   Thu, 23 Jan 2020 08:59:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Message-ID: <20200123085906.20608707@cakuba>
In-Reply-To: <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
        <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 09:23:33 -0800, Haiyang Zhang wrote:
> This patch adds support of XDP in native mode for hv_netvsc driver, and
> transparently sets the XDP program on the associated VF NIC as well.
> 
> Setting / unsetting XDP program on synthetic NIC (netvsc) propagates to
> VF NIC automatically. Setting / unsetting XDP program on VF NIC directly
> is not recommended, also not propagated to synthetic NIC, and may be
> overwritten by setting of synthetic NIC.
> 
> The Azure/Hyper-V synthetic NIC receive buffer doesn't provide headroom
> for XDP. We thought about re-use the RNDIS header space, but it's too
> small. So we decided to copy the packets to a page buffer for XDP. And,
> most of our VMs on Azure have Accelerated  Network (SRIOV) enabled, so
> most of the packets run on VF NIC. The synthetic NIC is considered as a
> fallback data-path. So the data copy on netvsc won't impact performance
> significantly.
> 
> XDP program cannot run with LRO (RSC) enabled, so you need to disable LRO
> before running XDP:
>         ethtool -K eth0 lro off
> 
> XDP actions not yet supported:
>         XDP_REDIRECT
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
> Changes:
> 	v3: Minor code and comment updates.
>         v2: Added XDP_TX support. Addressed review comments.

How does the locking of the TX path work? You seem to be just calling
the normal xmit method, but you don't hold the xmit queue lock, so the
stack can start xmit concurrently, no?
