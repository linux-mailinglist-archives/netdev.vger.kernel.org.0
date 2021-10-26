Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264A343B784
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhJZQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhJZQuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D737560E8B;
        Tue, 26 Oct 2021 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635266865;
        bh=4tRn582kmyrkqO2AEaLstI7ko1JH586VTMxozleB/+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fo52WyjBoac5Pz1EDlL+1YeY1IJu+sszfv2irzYF34KNuI4dovfHjo3eZwvv0nOn+
         Z7ohpg8LJJGWBY1yqrIgwIFBYrU7bsjLKVxjetJ95u5mZDBksyQYjZ+4CAj/Q+CGI6
         2E62HWfSiRmAJaj/4pP75m7Pnw701i7t3R1a2rgOysIp3Hd/wSMbkPS2g/N0mEdPhL
         +a2v7kjcsRwkKixvdaLHr1PB/Pq3DbMyHEbYgkyRZGPBY6cQwnQ08z7/3b+8hTxrIm
         2jYAlvy6NvRuKBze5ts5ytzoG4RoweFbXaMtkbvni4/qClOb2xE3MtgUYbzbJK1fpt
         NZVqTU4OjnbrA==
Date:   Tue, 26 Oct 2021 09:47:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: remove the recent devlink params
Message-ID: <20211026094743.390224ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR12MB5481970AFEFD9C969B42BE20DC849@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211026152939.3125950-1-kuba@kernel.org>
        <PH0PR12MB5481970AFEFD9C969B42BE20DC849@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 15:53:17 +0000 Parav Pandit wrote:
> Hi Jakub,
> 
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, October 26, 2021 9:00 PM
> > To: davem@davemloft.net
> > Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org; Leon
> > Romanovsky <leonro@nvidia.com>; Jakub Kicinski <kuba@kernel.org>
> > Subject: [PATCH net-next] net/mlx5: remove the recent devlink params
> > 
> > revert commit 46ae40b94d88 ("net/mlx5: Let user configure io_eq_size
> > param") revert commit a6cb08daa3b4 ("net/mlx5: Let user configure
> > event_eq_size param") revert commit 554604061979 ("net/mlx5: Let user
> > configure max_macs param")
> > 
> > The EQE parameters are applicable to more drivers, they should be configured
> > via standard API, probably ethtool. Example of another driver needing
> > something similar:  
> 
> ethool is not a good choice for following reasons.
> 
> 1. EQs of the mlx5 core devlink instance is used by multiple auxiliary devices, namely net, rdma, vdpa.
> 2. And sometime netdevice doesn't even exists to operate via ethtool (but devlink instance exist to serve other devices).
> 3. ethtool doesn't have notion set the config and apply (like devlink reload)
> Such reload operation is useful when user wants to configure more than one parameter and initialize the device only once.
> Otherwise dynamically changing parameter results in multiple device re-init sequence that increases device setup time.

Sure these are good points. OTOH devlink doesn't have any notion of
queues, IRQ vectors etc today so it doesn't really fit there, either.

> Should we define the devlink resources in the devlink layer, instead of driver?

I'm not sure how the EQE fits into the existing devlink objects.
params are not much of an API, it's a garbage bag.

> So that multiple drivers can make use of them without redefinition?

Yes, please.
