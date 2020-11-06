Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD02A8B90
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732750AbgKFAtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgKFAtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 19:49:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C4C20759;
        Fri,  6 Nov 2020 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604623792;
        bh=OpRdVui3T2NlqA/kRY3evvjy89MLSsTThjMFT+NNqyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pzB77C5TddVsiPrl7iDbZ7XoMkpLU+uotUepTtyRWuT3jsH5viT6VkuUO7TYr2COG
         NXso7IFRbBtYBVu8vuzaQifHSvFTNKIeE7aMahKzjoPzQyXVXDz25tFP6y+JZVv4zf
         iEgiZyHnRfaIMaD48Hf/qnrN9ImHG3ZnTObVG7CM=
Date:   Thu, 5 Nov 2020 16:49:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net,
        gerrit@erg.abdn.ac.uk, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, johannes@sipsolutions.net,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [net-next v4 7/8] net: smc: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201105164950.2bcfc230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103091823.586717-8-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
        <20201103091823.586717-8-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 14:48:22 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>

Ursula, Karsten - ack/nack for applying this to net-next?

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index b1ce6ccbfaec..f23f558054a7 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -389,9 +389,9 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
>   * Context:
>   * - tasklet context
>   */
> -static void smcd_cdc_rx_tsklet(unsigned long data)
> +static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
>  {
> -	struct smc_connection *conn = (struct smc_connection *)data;
> +	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
>  	struct smcd_cdc_msg *data_cdc;
>  	struct smcd_cdc_msg cdc;
>  	struct smc_sock *smc;
> @@ -411,7 +411,7 @@ static void smcd_cdc_rx_tsklet(unsigned long data)
>   */
>  void smcd_cdc_rx_init(struct smc_connection *conn)
>  {
> -	tasklet_init(&conn->rx_tsklet, smcd_cdc_rx_tsklet, (unsigned long)conn);
> +	tasklet_setup(&conn->rx_tsklet, smcd_cdc_rx_tsklet);
>  }
>  
>  /***************************** init, exit, misc ******************************/
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 1e23cdd41eb1..cbc73a7e4d59 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -131,9 +131,9 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
>  	wake_up(&link->wr_tx_wait);
>  }
>  
> -static void smc_wr_tx_tasklet_fn(unsigned long data)
> +static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
>  {
> -	struct smc_ib_device *dev = (struct smc_ib_device *)data;
> +	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
>  	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
>  	int i = 0, rc;
>  	int polled = 0;
> @@ -435,9 +435,9 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
>  	}
>  }
>  
> -static void smc_wr_rx_tasklet_fn(unsigned long data)
> +static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
>  {
> -	struct smc_ib_device *dev = (struct smc_ib_device *)data;
> +	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
>  	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
>  	int polled = 0;
>  	int rc;
> @@ -698,10 +698,8 @@ void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
>  
>  void smc_wr_add_dev(struct smc_ib_device *smcibdev)
>  {
> -	tasklet_init(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn,
> -		     (unsigned long)smcibdev);
> -	tasklet_init(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn,
> -		     (unsigned long)smcibdev);
> +	tasklet_setup(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn);
> +	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
>  }
>  
>  int smc_wr_create_link(struct smc_link *lnk)

