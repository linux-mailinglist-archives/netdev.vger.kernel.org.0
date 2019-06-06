Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19DE36D1F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfFFHOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfFFHOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 03:14:31 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B6232083D;
        Thu,  6 Jun 2019 07:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559805270;
        bh=YpA9Vnz3jW+q2XbnluRqcGie7z/b4PTVlZKms4b3nu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LlUcbSIekc2v6jkGqikBU9WHAtVNJQoLWeioTLoUUfmaAI27z98zNMSH/jQXlMGv8
         zDKVnDZ/cRlnervpr3tLA8J865vee4/iKGSQ5HhD5f21NWm4+kAfl08QUs/ee/Qzey
         2d39Jlq1xJIUyCbXyhMNmciJITwlcmxx+9bZ6mls=
Date:   Thu, 6 Jun 2019 10:14:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Message-ID: <20190606071427.GU5261@mtr-leonro.mtl.com>
References: <20190605232348.6452-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605232348.6452-1-saeedm@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:24:31PM +0000, Saeed Mahameed wrote:
> Hi Dave, Doug & Jason
>
> This series improves DIM - Dynamically-tuned Interrupt
> Moderation- to be generic for netdev and RDMA use-cases.
>
> From Tal and Yamin:
> The first 7 patches provide the necessary refactoring to current net_dim
> library which affect some net drivers who are using the API.
>
> The last 2 patches provide the RDMA implementation for DIM.
>
> For more information please see tag log below.
>
> Once we are all happy with the series, please pull to net-next and
> rdma-next trees.
>
> Thanks,
> Saeed.
>
> ---
> The following changes since commit cd6c84d8f0cdc911df435bb075ba22ce3c605b07:
>
>   Linux 5.2-rc2 (2019-05-26 16:49:19 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/dim-updates-2019-06-05
>
> for you to fetch changes up to 1ec9974e75e7a58bff1ab17c4fcda17b180ed3bb:
>
>   RDMA/core: Provide RDMA DIM support for ULPs (2019-06-05 16:09:02 -0700)
>
> ----------------------------------------------------------------
> dim-updates-2019-06-05
>
> From: Tal Gilboa
>
> Implement net DIM over a generic DIM library
>
> net_dim.h lib exposes an implementation of the DIM algorithm for
> dynamically-tuned interrupt moderation for networking interfaces.
>
> We want a similar functionality for other protocols, which might need to
> optimize interrupts differently. Main motivation here is DIM for NVMf
> storage protocol.
>
> Current DIM implementation prioritizes reducing interrupt overhead over
> latency. Also, in order to reduce DIM's own overhead, the algorithm might
> take some time to identify it needs to change profiles. While this is
> acceptable for networking, it might not work well on other scenarios.
>
> Here I propose a new structure to DIM. The idea is to allow a slightly
> modified functionality without the risk of breaking Net DIM behavior for
> netdev. I verified there are no degradations in current DIM behavior with
> the modified solution.
>
> Solution:
> - Common logic is declared in include/linux/dim.h and implemented in
>   lib/dim/dim.c
> - Net DIM (existing) logic is declared in include/linux/net_dim.h and
>   implemented in lib/dim/net_dim.c, which uses the common logic from dim.h
> - Any new DIM logic will be declared in "/include/linux/new_dim.h" and
>    implemented in "lib/dim/new_dim.c".
> - This new implementation will expose modified versions of profiles,
>   dim_step() and dim_decision().
>
> Pros for this solution are:
> - Zero impact on existing net_dim implementation and usage
> - Relatively more code reuse (compared to two separate solutions)
> - Increased extensibility
>
> ----------------------------------------------------------------
> Tal Gilboa (6):
>       linux/dim: Move logic to dim.h
>       linux/dim: Remove "net" prefix from internal DIM members
>       linux/dim: Rename externally exposed macros
>       linux/dim: Rename net_dim_sample() to net_dim_update_sample()
>       linux/dim: Rename externally used net_dim members
>       linux/dim: Move implementation to .c files
>
> Yamin Friedman (3):
>       linux/dim: Add completions count to dim_sample
>       linux/dim: Implement rdma_dim
>       RDMA/core: Provide RDMA DIM support for ULPs

Saeed,

No, for the RDMA patches.
We need to see usage of those APIs before merging.

Thanks
