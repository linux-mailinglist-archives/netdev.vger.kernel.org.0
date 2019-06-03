Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632E532D3E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfFCJzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfFCJzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 05:55:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D4B7C1EB1E0;
        Mon,  3 Jun 2019 09:55:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8315E60C44;
        Mon,  3 Jun 2019 09:55:13 +0000 (UTC)
Message-ID: <94e7d8feb29bf7d7b2add710a997bc095990a019.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] net/mlx5e: use indirect calls wrapper for
 the rx packet handler
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Date:   Mon, 03 Jun 2019 11:55:12 +0200
In-Reply-To: <1b740c86d3917640657934961b40fe4b288c2a40.camel@mellanox.com>
References: <cover.1559304330.git.pabeni@redhat.com>
         <74fb497974fe8267c2c5f0a1422a418363f0c50f.1559304330.git.pabeni@redhat.com>
         <1b740c86d3917640657934961b40fe4b288c2a40.camel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 03 Jun 2019 09:55:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 18:41 +0000, Saeed Mahameed wrote:
> On Fri, 2019-05-31 at 14:53 +0200, Paolo Abeni wrote:
> > We can avoid another indirect call per packet wrapping the rx
> > handler call with the proper helper.
> > 
> > To ensure that even the last listed direct call experience
> > measurable gain, despite the additional conditionals we must
> > traverse before reaching it, I tested reversing the order of the
> > listed options, with performance differences below noise level.
> > 
> > Together with the previous indirect call patch, this gives
> > ~6% performance improvement in raw UDP tput.
> > 
> 
> Nice ! I like it.
> 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > index 0fe5f13d07cc..c3752dbe00c8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > @@ -1333,7 +1333,9 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int
> > budget)
> >  
> >  		mlx5_cqwq_pop(cqwq);
> >  
> > -		rq->handle_rx_cqe(rq, cqe);
> > +		INDIRECT_CALL_4(rq->handle_rx_cqe,
> > mlx5e_handle_rx_cqe_mpwrq,
> > +				mlx5e_handle_rx_cqe,
> > mlx5e_handle_rx_cqe_rep,
> > +				mlx5e_ipsec_handle_rx_cqe, rq, cqe);
> 
> you missed mlx5i_handle_rx_cqe, anyway don't add INDIRECT_CALL_5 :D
> 
> just replace mlx5e_handle_rx_cqe_rep with mlx5i_handle_rx_cqe, 
> mlx5e_handle_rx_cqe_rep is actually a slow path of switchdev mode.

Thank you! This is exactly the kind of feedback I was looking for! I
hoped some of the options was less relevant than the other, but I do
not know the driver well enough to guess. Also I missed completely
mlx5i_handle_rx_cqe, as you noded.

> Maybe define the list somewhere in en.h where it is visible for every
> one:
> 
> #define MLX5_RX_INDIRECT_CALL_LIST \
> mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe, mlx5i_handle_rx_cqe,
> mlx5e_ipsec_handle_rx_cqe
> 
> and here:
> INDIRECT_CALL_4(rq->handle_rx_cqe, MLX5_RX_INDIRECT_CALL_LIST, rq,
> cqe);

Will do in v2, unless this patch will be dropped, please see my reply
to patch 2/3.

Thanks,

Paolo

