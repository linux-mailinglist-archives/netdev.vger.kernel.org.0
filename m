Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD79269770
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgINVKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgINVKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:10:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2535620735;
        Mon, 14 Sep 2020 21:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600117843;
        bh=TY31Md14FJPXqHRgvfhLcEu3HGZCkkpy5Ps85ur50s8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZoNEXIoSAF/u0VcPY7kcNXtUiJYHYLz/yNlDzDG6zNDrpn+/ITs7Vm1uSTlbRDMp5
         87EndxYTLVk044Sye5Q/bLhf+D2uKKB0ADzoFhJ66i4m8+5AB3Djiwy9PrFFPO1JQr
         QOOOcD6EzFyZ3Np4vYlbRVuOiruZ/JjPn8Rf3Xo0=
Date:   Mon, 14 Sep 2020 14:10:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] ionic: dynamic interrupt moderation
Message-ID: <20200914141041.570370fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200913212813.46736-1-snelson@pensando.io>
References: <20200913212813.46736-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Sep 2020 14:28:13 -0700 Shannon Nelson wrote:
> Use the dim library to manage dynamic interrupt
> moderation in ionic.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Let me advertise my people.kernel entry ;)

https://people.kernel.org/finqi53erl

My somewhat short production experience leads me to question the value
of DIM on real life workloads, but I know customers like to benchmark
adapters using ping and iperf, so do what you gotta do :(

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 895e2113bd6b..f1c8ab439080 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -42,6 +42,19 @@ static int ionic_start_queues(struct ionic_lif *lif);
>  static void ionic_stop_queues(struct ionic_lif *lif);
>  static void ionic_lif_queue_identify(struct ionic_lif *lif);
>  
> +static void ionic_dim_work(struct work_struct *work)
> +{
> +	struct dim *dim = container_of(work, struct dim, work);
> +	struct dim_cq_moder cur_moder =
> +		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);

Could you move this out of the variable init? Make things hard to read.

> +	struct ionic_qcq *qcq = container_of(dim, struct ionic_qcq, dim);
> +	u32 new_coal;
> +
> +	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
> +	qcq->intr.dim_coal_hw = new_coal ? new_coal : 1;
> +	dim->state = DIM_START_MEASURE;
> +}

Interesting, it seem that you don't actually talk to FW to update 
the parameters? DIM causes noticeable increase in scheduler pressure
with those work entries it posts. I'd be tempted to not use a work
entry if you don't have to sleep.
