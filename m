Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071413B107
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388682AbfFJInJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388056AbfFJInI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 04:43:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77DB4307D867;
        Mon, 10 Jun 2019 08:43:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6341510013D9;
        Mon, 10 Jun 2019 08:43:01 +0000 (UTC)
Message-ID: <60228c06200778cd214e9e7448906a7fdaf16df5.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] net/mlx5e: use indirect calls wrapper
 for the rx packet handler
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Date:   Mon, 10 Jun 2019 10:43:00 +0200
In-Reply-To: <248c85579656054de478ea29154aa40c7542009e.camel@mellanox.com>
References: <cover.1559857734.git.pabeni@redhat.com>
         <fe1dffe13521e0b89969301f7b34fdb19964dbdb.1559857734.git.pabeni@redhat.com>
         <248c85579656054de478ea29154aa40c7542009e.camel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 10 Jun 2019 08:43:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2019-06-07 at 18:09 +0000, Saeed Mahameed wrote:
> On Thu, 2019-06-06 at 23:56 +0200, Paolo Abeni wrote:
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
> > v1 -> v2:
> >  - update the direct call list and use a macro to define it,
> >    as per Saeed suggestion. An intermediated additional
> >    macro is needed to allow arg list expansion
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en.h    | 4 ++++
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > index 3a183d690e23..52bcdc87cbe2 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > @@ -148,6 +148,10 @@ struct page_pool;
> >  
> >  #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
> >  
> > +#define MLX5_RX_INDIRECT_CALL_LIST \
> > +	mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe,
> > mlx5i_handle_rx_cqe, \
> > +	mlx5e_ipsec_handle_rx_cqe
> > +
> >  #define mlx5e_dbg(mlevel, priv, format, ...)                    \
> >  do {                                                            \
> >  	if (NETIF_MSG_##mlevel & (priv)->msglevel)              \
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > index 0fe5f13d07cc..7faf643eb1b9 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > @@ -1303,6 +1303,8 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq
> > *rq, struct mlx5_cqe64 *cqe)
> >  	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
> >  }
> >  
> > +#define INDIRECT_CALL_LIST(f, list, ...) INDIRECT_CALL_4(f, list,
> > __VA_ARGS__)
> > +
> 
> Hi Paolo, 
> 
> This patch produces some compiler errors:
> 
> Please note that mlx5e_ipsec_handle_rx_cqe is only defined when
> CONFIG_MLX5_EN_IPSEC is enabled.

I'm sorry, I dumbly did not fuzz vs mlx5 build options.

It looks like that, to cope with all the possible mixes, a not-so-nice
macro maze is required; something alike the following:

#if defined(CONFIG_MLX5_EN_IPSEC) && defined (CONFIG_MLX5_CORE_IPOIB)

#define MLX5_RX_INDIRECT_CALL_LIST \
	mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe, mlx5i_handle_rx_cqe, \
	mlx5e_ipsec_handle_rx_cqe
#define INDIRECT_CALL_LIST(f, list, ...) INDIRECT_CALL_4(f, list, __VA_ARGS__)

#elif defined(CONFIG_MLX5_EN_IPSEC)

#define MLX5_RX_INDIRECT_CALL_LIST \
	mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe, \
	mlx5e_ipsec_handle_rx_cqe
#define INDIRECT_CALL_LIST(f, list, ...) INDIRECT_CALL_3(f, list, __VA_ARGS__)

#elif defined(CONFIG_MLX5_CORE_IPOIB)

#define MLX5_RX_INDIRECT_CALL_LIST \
	mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe, mlx5i_handle_rx_cqe
#define INDIRECT_CALL_LIST(f, list, ...) INDIRECT_CALL_3(f, list, __VA_ARGS__)

#else

#define MLX5_RX_INDIRECT_CALL_LIST \
	mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe
#define INDIRECT_CALL_LIST(f, list, ...) INDIRECT_CALL_2(f, list, __VA_ARGS__)

#endif

If you are ok with the above, I can include it in v3, otherwise I can
either:

* drop patch 2/3 and use only the 2 alternatives
(mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe) that are available
regardless of the driver build options

* drop both patches 2/3 and 3/3

Any feedback welcome, thanks!

Paolo

