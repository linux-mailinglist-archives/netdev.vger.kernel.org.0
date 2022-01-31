Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C174A3C42
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 01:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357153AbiAaAY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 19:24:58 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:41992 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiAaAY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 19:24:56 -0500
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 419ED72C8FA;
        Mon, 31 Jan 2022 03:24:54 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 2F3347CCAA4; Mon, 31 Jan 2022 03:24:54 +0300 (MSK)
Date:   Mon, 31 Jan 2022 03:24:54 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 2/4] net/smc: Add netlink net namespace support
Message-ID: <20220131002453.GA7599@altlinux.org>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <20211228130611.19124-3-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228130611.19124-3-tonylu@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 09:06:10PM +0800, Tony Lu wrote:
> This adds net namespace ID to diag of linkgroup, helps us to distinguish
> different namespaces, and net_cookie is unique in the whole system.
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>  include/uapi/linux/smc.h      |  2 ++
>  include/uapi/linux/smc_diag.h | 11 ++++++-----
>  net/smc/smc_core.c            |  3 +++
>  net/smc/smc_diag.c            | 16 +++++++++-------
>  4 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
> index 20f33b27787f..6c2874fd2c00 100644
> --- a/include/uapi/linux/smc.h
> +++ b/include/uapi/linux/smc.h
> @@ -119,6 +119,8 @@ enum {
>  	SMC_NLA_LGR_R_CONNS_NUM,	/* u32 */
>  	SMC_NLA_LGR_R_V2_COMMON,	/* nest */
>  	SMC_NLA_LGR_R_V2,		/* nest */
> +	SMC_NLA_LGR_R_NET_COOKIE,	/* u64 */
> +	SMC_NLA_LGR_R_PAD,		/* flag */
>  	__SMC_NLA_LGR_R_MAX,
>  	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
>  };
> diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
> index 8cb3a6fef553..c7008d87f1a4 100644
> --- a/include/uapi/linux/smc_diag.h
> +++ b/include/uapi/linux/smc_diag.h
> @@ -84,11 +84,12 @@ struct smc_diag_conninfo {
>  /* SMC_DIAG_LINKINFO */
>  
>  struct smc_diag_linkinfo {
> -	__u8 link_id;			/* link identifier */
> -	__u8 ibname[IB_DEVICE_NAME_MAX]; /* name of the RDMA device */
> -	__u8 ibport;			/* RDMA device port number */
> -	__u8 gid[40];			/* local GID */
> -	__u8 peer_gid[40];		/* peer GID */
> +	__u8		link_id;		    /* link identifier */
> +	__u8		ibname[IB_DEVICE_NAME_MAX]; /* name of the RDMA device */
> +	__u8		ibport;			    /* RDMA device port number */
> +	__u8		gid[40];		    /* local GID */
> +	__u8		peer_gid[40];		    /* peer GID */
> +	__aligned_u64	net_cookie;                 /* RDMA device net namespace */
>  };
>  
>  struct smc_diag_lgrinfo {

I'm sorry but this is an ABI regression.

Since struct smc_diag_lgrinfo contains an object of type "struct smc_diag_linkinfo",
offset of all subsequent members of struct smc_diag_lgrinfo is changed by
this patch.

As result, applications compiled with the old version of struct smc_diag_linkinfo
will receive garbage in struct smc_diag_lgrinfo.role if the kernel implements
this new version of struct smc_diag_linkinfo.


-- 
ldv
