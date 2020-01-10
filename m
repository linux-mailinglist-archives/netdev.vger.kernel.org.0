Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F439136558
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbgAJCaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:30:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730868AbgAJCaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:30:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 694911573640C;
        Thu,  9 Jan 2020 18:30:04 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:30:01 -0800 (PST)
Message-Id: <20200109.183001.2198948440388440605.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, petrm@mellanox.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110105738.2b20cbad@canb.auug.org.au>
References: <20200110105738.2b20cbad@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:30:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 10 Jan 2020 10:57:38 +1100

> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
> index 17b29e2d19ed..54807b4930fe 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
> @@ -767,7 +767,7 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
>  	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == child_handle)
>  		return 0;
>  
> -	if (!p->child_handle) {
> +	if (!child_handle) {
>  		/* This is an invisible FIFO replacing the original Qdisc.
>  		 * Ignore it--the original Qdisc's destroy will follow.
>  		 */
> -- 
> 2.24.0

Yep, this is the merge resolution you will find in net-next at commit:

commit a2d6d7ae591c47ebc04926cb29a840adfdde49e6
Merge: b1daa4d19473 e69ec487b2c7
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Jan 9 12:10:26 2020 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
    
    The ungrafting from PRIO bug fixes in net, when merged into net-next,
    merge cleanly but create a build failure.  The resolution used here is
    from Petr Machata.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --cc drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 81a2c087f534,46d43cfd04e9..54807b4930fe
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@@ -681,92 -631,33 +681,99 @@@ static struct mlxsw_sp_qdisc_ops mlxsw_
  	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
  };
  
 -/* Grafting is not supported in mlxsw. It will result in un-offloading of the
 - * grafted qdisc as well as the qdisc in the qdisc new location.
 - * (However, if the graft is to the location where the qdisc is already at, it
 - * will be ignored completely and won't cause un-offloading).
 +static int
 +mlxsw_sp_qdisc_ets_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 +				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 +				void *params)
 +{
 +	struct tc_ets_qopt_offload_replace_params *p = params;
 +
 +	return __mlxsw_sp_qdisc_ets_check_params(p->bands);
 +}
 +
 +static int
 +mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 +			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 +			   void *params)
 +{
 +	struct tc_ets_qopt_offload_replace_params *p = params;
 +
 +	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
 +					    p->quanta, p->weights, p->priomap);
 +}
 +
 +static void
 +mlxsw_sp_qdisc_ets_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
 +			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 +			     void *params)
 +{
 +	struct tc_ets_qopt_offload_replace_params *p = params;
 +
 +	__mlxsw_sp_qdisc_ets_unoffload(mlxsw_sp_port, mlxsw_sp_qdisc,
 +				       p->qstats);
 +}
 +
 +static int
 +mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 +			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 +{
 +	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port);
 +}
 +
 +static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets = {
 +	.type = MLXSW_SP_QDISC_ETS,
 +	.check_params = mlxsw_sp_qdisc_ets_check_params,
 +	.replace = mlxsw_sp_qdisc_ets_replace,
 +	.unoffload = mlxsw_sp_qdisc_ets_unoffload,
 +	.destroy = mlxsw_sp_qdisc_ets_destroy,
 +	.get_stats = mlxsw_sp_qdisc_get_prio_stats,
 +	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 +};
 +
 +/* Linux allows linking of Qdiscs to arbitrary classes (so long as the resulting
 + * graph is free of cycles). These operations do not change the parent handle
 + * though, which means it can be incomplete (if there is more than one class
 + * where the Qdisc in question is grafted) or outright wrong (if the Qdisc was
 + * linked to a different class and then removed from the original class).
 + *
 + * E.g. consider this sequence of operations:
 + *
 + *  # tc qdisc add dev swp1 root handle 1: prio
 + *  # tc qdisc add dev swp1 parent 1:3 handle 13: red limit 1000000 avpkt 10000
 + *  RED: set bandwidth to 10Mbit
 + *  # tc qdisc link dev swp1 handle 13: parent 1:2
 + *
 + * At this point, both 1:2 and 1:3 have the same RED Qdisc instance as their
 + * child. But RED will still only claim that 1:3 is its parent. If it's removed
 + * from that band, its only parent will be 1:2, but it will continue to claim
 + * that it is in fact 1:3.
 + *
 + * The notification for child Qdisc replace (e.g. TC_RED_REPLACE) comes before
 + * the notification for parent graft (e.g. TC_PRIO_GRAFT). We take the replace
 + * notification to offload the child Qdisc, based on its parent handle, and use
 + * the graft operation to validate that the class where the child is actually
 + * grafted corresponds to the parent handle. If the two don't match, we
 + * unoffload the child.
   */
  static int
 -mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 -			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 -			  struct tc_prio_qopt_offload_graft_params *p)
 +__mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 +			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 +			   u8 band, u32 child_handle)
  {
 -	int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(p->band);
 +	int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
  	struct mlxsw_sp_qdisc *old_qdisc;
  
 -	/* Check if the grafted qdisc is already in its "new" location. If so -
 -	 * nothing needs to be done.
 -	 */
 -	if (p->band < IEEE_8021QAZ_MAX_TCS &&
 -	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == p->child_handle)
 +	if (band < IEEE_8021QAZ_MAX_TCS &&
 +	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == child_handle)
  		return 0;
  
 -	if (!p->child_handle) {
++	if (!child_handle) {
+ 		/* This is an invisible FIFO replacing the original Qdisc.
+ 		 * Ignore it--the original Qdisc's destroy will follow.
+ 		 */
+ 		return 0;
+ 	}
+ 
  	/* See if the grafted qdisc is already offloaded on any tclass. If so,
  	 * unoffload it.
  	 */
