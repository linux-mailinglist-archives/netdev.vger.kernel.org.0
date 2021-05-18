Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0E388078
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 21:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351776AbhERTZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 15:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346055AbhERTZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 15:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC8E86112F;
        Tue, 18 May 2021 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621365835;
        bh=/mP6Erw322PpPg6b6lvo9yzRRokiUZwurYU9C13mWB8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CAm490MOlXhaav0kS2KW0+NCqPO0iPTrPp7pxsSE0tVOmmIl19kRUHOydxlHVtyiN
         LHbWNSBmTbDEJaEp6gCgVxwv9xlx5kaEP1wkKSM7yNjSfRuA2H7ZLS/kqDw3Awv53t
         uILWZ4SecZABQAmo2EnVWuXpYsldc3FW/cCHlJ9C8T4U2NDy6c19BoY8pC9HRyxasU
         uWgciONCbjNZ4B5GEi/MvDb+PEzzkjZYePiwsfaGLKdE4YDC0WCwmxqel29RONuCip
         oVePxgjTt+WEjPIW74FCEmDlZd6oAj9O8r66MKr4IU2FRKJhJwdk3QROQ+oFLqf+2K
         sfFm77+bbePtA==
Message-ID: <040bc4de947fc4cca74dcad89464c5b714c5949d.camel@kernel.org>
Subject: Re: [PATCH net] mlx5e: add add missing BH locking around
 napi_schdule()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org
Date:   Tue, 18 May 2021 12:23:54 -0700
In-Reply-To: <20210505202026.778635-1-kuba@kernel.org>
References: <20210505202026.778635-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-05 at 13:20 -0700, Jakub Kicinski wrote:
> It's not correct to call napi_schedule() in pure process
> context. Because we use __raise_softirq_irqoff() we require
> callers to be in a context which will eventually lead to
> softirq handling (hardirq, bh disabled, etc.).
> 
> With code as is users will see:
> 
>  NOHZ tick-stop error: Non-RCU local softirq work is pending, handler
> #08!!!
> 
> Fixes: a8dd7ac12fc3 ("net/mlx5e: Generalize RQ activation")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> We may want to patch net-next once it opens to switch
> from __raise_softirq_irqoff() to raise_softirq_irqoff().
> The irq_count() check is probably negligable and we'd need
> to split the hardirq / non-hardirq paths completely to
> keep the current behaviour. Plus what's hardirq is murky
> with RT enabled..
> 
> Eric WDYT?
> 

I was waiting for Eric to reply, Anyway i think this patch is correct
as is, 

Jakub do you want me to submit to net  via net-mlx5 branch? 

Another valid solution is that driver will avoid calling
napi_schedule() altogether from  process context,  we have the
mechanism of mlx5e_trigger_irq(), which can be utilized here, but needs
some re-factoring to move the icosq object from the main rx rq to the
containing channel object.

>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index bca832cdc4cb..11e50f5b3a1e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -889,10 +889,13 @@ int mlx5e_open_rq(struct mlx5e_params *params,
> struct mlx5e_rq_param *param,
>  void mlx5e_activate_rq(struct mlx5e_rq *rq)
>  {
>         set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
> -       if (rq->icosq)
> +       if (rq->icosq) {
>                 mlx5e_trigger_irq(rq->icosq);
> -       else
> +       } else {
> +               local_bh_disable();
>                 napi_schedule(rq->cq.napi);
> +               local_bh_enable();
> +       }
>  }
>  
>  void mlx5e_deactivate_rq(struct mlx5e_rq *rq)


