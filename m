Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F5E2BC44A
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 07:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgKVGmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 01:42:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13667 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgKVGmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 01:42:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fba08480002>; Sat, 21 Nov 2020 22:42:16 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 22 Nov
 2020 06:42:01 +0000
Date:   Sun, 22 Nov 2020 08:41:58 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-12-saeedm@nvidia.com>
 <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606027336; bh=9KcXOM/tbaKX0cAiT2QacYeJKkRteNDQI28JoIRhA68=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=kgCgDkmkGCjfYTocCr6U6a3mzIdIbvmiJPwweDPS9hXndJk5OCL1dJr1dpsx8SP8P
         jRl0+Y6LNPzCsl65wQLG4waXO866NHOkQOBBGkPClQGIncA87W/vTXIkzPqW4/NDi0
         uVFNIFduEuMSK40wi+bKTEwVLGVNzvA4VhAzX98rP3vnzedJL0790meK/hgBJ9DUTF
         pQItNLjCkv33nU5p+LAKeL9T93cdZc9xliT4qFc2y6eVQMYKl+jlw1yWRZpoxP1JOx
         0kdkwRj/L+3XURzX73J684s9ynlhRMU3Jajjwr6jv7vYwrGkDiSkELqrOvgdbJuawX
         wWpR4esu43hhw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 04:01:55PM -0800, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 15:03:34 -0800 Saeed Mahameed wrote:
> > From: Eli Cohen <eli@mellanox.com>
> > 
> > Add a new namespace type to the NIC RX root namespace to allow for
> > inserting VDPA rules before regular NIC but after bypass, thus allowing
> > DPDK to have precedence in packet processing.
> 
> How does DPDK and VDPA relate in this context?

mlx5 steering is hierarchical and defines precedence amongst namespaces.
Up till now, the VDPA implementation would insert a rule into the
MLX5_FLOW_NAMESPACE_BYPASS hierarchy which is used by DPDK thus taking
all the incoming traffic.

The MLX5_FLOW_NAMESPACE_VDPA hirerachy comes after
MLX5_FLOW_NAMESPACE_BYPASS.
