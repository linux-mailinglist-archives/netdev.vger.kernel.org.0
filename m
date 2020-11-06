Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11E2A8B8D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgKFArg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgKFArg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 19:47:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA9C20759;
        Fri,  6 Nov 2020 00:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604623655;
        bh=FMZxcyC2/nwMLvcjnxteTlYvakaxec0ZPQMZ1qcc9tM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O5Oc3rgB/4hzo1//+HkmHMuJ0d8xxpmnB57KRG1wKCoEqWk9x5DdmZmwub5R7/F7p
         f4EhtfKWxFKxbCM7fgkvTqQh7kdH0W5emNWFXD1OBGHcSilfbQCF+Om93OYPhyDegp
         O7K7JxWRmwB07HGDLeyWD/GoM30E7404igmUFsRs=
Date:   Thu, 5 Nov 2020 16:47:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     santosh.shilimkar@oracle.com
Cc:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net,
        gerrit@erg.abdn.ac.uk, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, johannes@sipsolutions.net,
        alex.aring@gmail.com, stefan@datenfreihafen.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [net-next v4 5/8] net: rds: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201105164733.5d10d899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103091823.586717-6-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
        <20201103091823.586717-6-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 14:48:20 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>

Santosh, ack/nack for this going into net-next?

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index b36b60668b1d..d06398be4b80 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -314,9 +314,9 @@ static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
>  	}
>  }
>  
> -static void rds_ib_tasklet_fn_send(unsigned long data)
> +static void rds_ib_tasklet_fn_send(struct tasklet_struct *t)
>  {
> -	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
> +	struct rds_ib_connection *ic = from_tasklet(ic, t, i_send_tasklet);
>  	struct rds_connection *conn = ic->conn;
>  
>  	rds_ib_stats_inc(s_ib_tasklet_call);
> @@ -354,9 +354,9 @@ static void poll_rcq(struct rds_ib_connection *ic, struct ib_cq *cq,
>  	}
>  }
>  
> -static void rds_ib_tasklet_fn_recv(unsigned long data)
> +static void rds_ib_tasklet_fn_recv(struct tasklet_struct *t)
>  {
> -	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
> +	struct rds_ib_connection *ic = from_tasklet(ic, t, i_recv_tasklet);
>  	struct rds_connection *conn = ic->conn;
>  	struct rds_ib_device *rds_ibdev = ic->rds_ibdev;
>  	struct rds_ib_ack_state state;
> @@ -1219,10 +1219,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
>  	}
>  
>  	INIT_LIST_HEAD(&ic->ib_node);
> -	tasklet_init(&ic->i_send_tasklet, rds_ib_tasklet_fn_send,
> -		     (unsigned long)ic);
> -	tasklet_init(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv,
> -		     (unsigned long)ic);
> +	tasklet_setup(&ic->i_send_tasklet, rds_ib_tasklet_fn_send);
> +	tasklet_setup(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv);
>  	mutex_init(&ic->i_recv_mutex);
>  #ifndef KERNEL_HAS_ATOMIC64
>  	spin_lock_init(&ic->i_ack_lock);

