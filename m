Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0E2BA13F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKTDf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgKTDf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 22:35:29 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF0D2225E;
        Fri, 20 Nov 2020 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605843328;
        bh=vbS1m1gv7iPYLjNgjf2zIUzIKyTt+1+RUBxI8hDlklg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qY96n5G0JV0vStBiHwu//6ptAiT3YJO6Na3IQ5li3QBB+1ZVsRsv0SE8Ap9/lvXgW
         TXeXJRHusRpD0bB19MQZIODVnh0uypEaF61OyIiRShSJm5w0o5AE7N+aX7OmkKxrCo
         aZT2isAP/IJ5MHwGYtrwWkH/l/mCprcapD5Yq4DY=
Date:   Thu, 19 Nov 2020 19:35:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201119193526.014b968b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119140017.GN244516@ziepe.ca>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <28239ff66a27c0ddf8be4f1461e27b0ac0b02871.camel@kernel.org>
        <20201119140017.GN244516@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 10:00:17 -0400 Jason Gunthorpe wrote:
> Finally, in the mlx5 model VDPA is just an "application". It asks the
> device to create a 'RDMA' raw ethernet packet QP that is uses rings
> formed in the virtio-net specification. We can create it in the kernel
> using mlx5_vdpa, and we can create it in userspace through the RDMA
> subsystem. Like any "RDMA" application it is contained by the security
> boundary of the PF/VF/SF the mlx5_core is running on.

Thanks for the write up!

The SF part is pretty clear to me, it is what it is. DPDK camp has been
pretty excited about ADI/PASID for a while now.


The part that's blurry to me is VDPA.

I was under the impression that for VDPA the device is supposed to
support native virtio 2.0 (or whatever the "HW friendly" spec was).

I believe that's what the early patches from Intel did.

You're saying it's a client application like any other - do I understand
it right that the hypervisor driver will be translating descriptors
between virtio and device-native then?

The vdpa parent is in the hypervisor correct?

Can a VDPA device have multiple children of the same type?

Why do we have a representor for a SF, if the interface is actually VDPA?
Block and net traffic can't reasonably be treated the same by the switch.

Also I'm confused how block device can bind to mlx5_core - in that case
I'm assuming the QP is bound 1:1 with a QP on the SmartNIC side, and
that QP is plugged into an appropriate backend?
