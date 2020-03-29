Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4169196B8C
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 08:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbgC2Gox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 02:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgC2Gox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 02:44:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBE7A2073B;
        Sun, 29 Mar 2020 06:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585464292;
        bh=ZSnBqyHG5vDVbqdvVr9ONDnFEQ3e49b7/0eFOIyHldY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iNhC7IuyvAcjXOfOyAubx3mjeb00g4pZcWPG6IKKqn2JXRgNcTc6LvAONDP1qElRC
         mvtcjhQ4X/HFYe3NohY4uwUCIo1xmJzzHQaip4QTP4SfYIOZTphko3rENsHA9P4cTa
         300DbDxUI9+Hv/zjBxJXJDQxD3MTyVpywEEaQCyc=
Date:   Sun, 29 Mar 2020 09:44:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, tanhuazhong <tanhuazhong@huawei.com>
Subject: Re: [PATCH net-next] mlx4: fix "initializer element not constant"
 compiler error
Message-ID: <20200329064449.GA2454444@unreal>
References: <20200327210835.2576135-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200327210835.2576135-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 02:08:35PM -0700, Jacob Keller wrote:
> A recent commit e8937681797c ("devlink: prepare to support region
> operations") used the region_cr_space_str and region_fw_health_str
> variables as initializers for the devlink_region_ops structures.
>
> This can result in compiler errors:
> drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: error: initializer
> element is not constant
>    .name = region_cr_space_str,
>            ^
> drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: note: (near
> initialization for ‘region_cr_space_ops.name’)
> drivers/net/ethernet/mellanox//mlx4/crdump.c:50:10: error: initializer
> element is not constant
>    .name = region_fw_health_str,
>
> The variables were made to be "const char * const", indicating that both
> the pointer and data were constant. This was enough to resolve this on
> recent GCC (gcc (GCC) 9.2.1 20190827 (Red Hat 9.2.1-1) for this author).
>
> Unfortunately this is not enough for older compilers to realize that the
> variable can be treated as a constant expression.
>
> Fix this by introducing macros for the string and use those instead of
> the variable name in the region ops structures.
>
> Reported-by: tanhuazhong <tanhuazhong@huawei.com>
> Fixes: e8937681797c ("devlink: prepare to support region operations")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/crdump.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
