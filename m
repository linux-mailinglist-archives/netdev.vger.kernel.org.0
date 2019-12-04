Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24881113CDB
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 09:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfLEIMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 03:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfLEIMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 03:12:32 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22C3F206DB;
        Thu,  5 Dec 2019 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575533551;
        bh=ky657dThfKjbVCpIILkr6VubSyzgvjEQ7qr2LeYt6TY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zWTADLrRypv69ffcx5KeP3fiz0Z9hUuW2eeE9r2qjy2Q2u06vOT0cjeLRos5fN18Q
         sppeEg3dnSGvTz70LpCz/WxVXkTth+7KVp6rQAJ5RJFfexkW8hV+GIYj6xxZYbBu/t
         BZXTk0kbrZ1SYTl64LBHBAQbPQUI9zGCkth/Fk+8=
Date:   Wed, 4 Dec 2019 16:17:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.con>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, kexec@lists.infradead.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH v4 7/8] linux/log2.h: Fix 64bit calculations in
 roundup/down_pow_two()
Message-ID: <20191204141725.GA4939@unreal>
References: <20191203114743.1294-1-nsaenzjulienne@suse.de>
 <20191203114743.1294-8-nsaenzjulienne@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203114743.1294-8-nsaenzjulienne@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 12:47:40PM +0100, Nicolas Saenz Julienne wrote:
> Some users need to make sure their rounding function accepts and returns
> 64bit long variables regardless of the architecture. Sadly
> roundup/rounddown_pow_two() takes and returns unsigned longs. It turns
> out ilog2() already handles 32/64bit calculations properly, and being
> the building block to the round functions we can rework them as a
> wrapper around it.
>
> Suggested-by: Robin Murphy <robin.murphy@arm.con>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
>  drivers/clk/clk-divider.c                    |  8 ++--
>  drivers/clk/sunxi/clk-sunxi.c                |  2 +-
>  drivers/infiniband/hw/hfi1/chip.c            |  4 +-
>  drivers/infiniband/hw/hfi1/init.c            |  4 +-
>  drivers/infiniband/hw/mlx4/srq.c             |  2 +-
>  drivers/infiniband/hw/mthca/mthca_srq.c      |  2 +-
>  drivers/infiniband/sw/rxe/rxe_qp.c           |  4 +-


Thanks, for infiniband.
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
