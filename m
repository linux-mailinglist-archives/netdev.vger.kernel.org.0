Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33E146FB5
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAWRaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgAWRaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 12:30:15 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544DF21569;
        Thu, 23 Jan 2020 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579800614;
        bh=rmA6KyDbqwAsoSEXaVkYOuGxZZeh0dbF4LK/1h1tWSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezgS0Cf2xaRVBA5xIs0nTkBbjVPaqD3v9CXNTpxEPfBjUIcEBgqpToKeCABolLuER
         yRSd/GyTRk63WVb4XL3FRV/PbUEEHULCoFoxk0RwwxnglXgPwgJ+i7gxE2AAO2pamh
         lKZF5FpL/RiHuFx71XNMQ/DePMO79XFCZw+OZ4LM=
Date:   Thu, 23 Jan 2020 09:30:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Message-ID: <20200123093013.53d78485@cakuba>
In-Reply-To: <MN2PR21MB13757F7D19C11EC175FD9F98CA0F0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
        <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
        <20200123085906.20608707@cakuba>
        <MN2PR21MB13757F7D19C11EC175FD9F98CA0F0@MN2PR21MB1375.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 17:14:06 +0000, Haiyang Zhang wrote:
> > > Changes:
> > > 	v3: Minor code and comment updates.
> > >         v2: Added XDP_TX support. Addressed review comments.  
> > 
> > How does the locking of the TX path work? You seem to be just calling the
> > normal xmit method, but you don't hold the xmit queue lock, so the stack can
> > start xmit concurrently, no?  
> 
> The netvsc and vmbus can handle concurrent transmits, except the msd 
> (Multi-Send Data) field which can only be used by one queue. 
> 
> I already added a new flag to netvsc_send(), so packets from XDP_TX won't use 
> the msd.

I see, there's a few non-atomic counters there, but maybe that's not a
big deal.

What frees the skb if the ring is full, and netvsc_send_pkt() returns
-EAGAIN? Nothing checks the return value from netvsc_xdp_xmit().
