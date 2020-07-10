Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C5921B80A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgGJOPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:15:07 -0400
Received: from correo.us.es ([193.147.175.20]:35932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgGJOPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:15:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47F4A3066B5
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 16:15:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17169DA792
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 16:15:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F204DDA858; Fri, 10 Jul 2020 16:15:03 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E672DA72F;
        Fri, 10 Jul 2020 16:15:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 10 Jul 2020 16:15:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 316E742EE38E;
        Fri, 10 Jul 2020 16:15:01 +0200 (CEST)
Date:   Fri, 10 Jul 2020 16:15:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/13] net: sched: Pass qdisc reference in
 struct flow_block_offload
Message-ID: <20200710141500.GA12659@salvia>
References: <20200710135706.601409-1-idosch@idosch.org>
 <20200710135706.601409-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710135706.601409-2-idosch@idosch.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 04:56:54PM +0300, Ido Schimmel wrote:
> From: Petr Machata <petrm@mellanox.com>
> 
> Previously, shared blocks were only relevant for the pseudo-qdiscs ingress
> and clsact. Recently, a qevent facility was introduced, which allows to
> bind blocks to well-defined slots of a qdisc instance. RED in particular
> got two qevents: early_drop and mark. Drivers that wish to offload these
> blocks will be sent the usual notification, and need to know which qdisc it
> is related to.
> 
> To that end, extend flow_block_offload with a "sch" pointer, and initialize
> as appropriate. This prompts changes in the indirect block facility, which
> now tracks the scheduler instead of the netdevice. Update signatures of
> several functions similarly. Deduce the device from the scheduler when
> necessary.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 11 ++++++----
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 11 +++++-----
>  .../net/ethernet/netronome/nfp/flower/main.h  |  2 +-
>  .../ethernet/netronome/nfp/flower/offload.c   | 11 ++++++----
>  include/net/flow_offload.h                    |  9 ++++----
>  net/core/flow_offload.c                       | 12 +++++------
>  net/netfilter/nf_flow_table_offload.c         | 17 +++++++--------
>  net/netfilter/nf_tables_offload.c             | 20 ++++++++++--------
>  net/sched/cls_api.c                           | 21 +++++++++++--------
>  9 files changed, 63 insertions(+), 51 deletions(-)
> 
[...]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index eefeb1cdc2ee..4fc42c1955ff 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -404,7 +404,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>  static LIST_HEAD(mlx5e_block_cb_list);
>  
>  static int
> -mlx5e_rep_indr_setup_block(struct net_device *netdev,
> +mlx5e_rep_indr_setup_block(struct Qdisc *sch,
>  			   struct mlx5e_rep_priv *rpriv,
>  			   struct flow_block_offload *f,
>  			   flow_setup_cb_t *setup_cb,
> @@ -412,6 +412,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
>  			   void (*cleanup)(struct flow_block_cb *block_cb))
>  {
>  	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
> +	struct net_device *netdev = sch->dev_queue->dev;

This break indirect block support for netfilter since the driver
is assuming a Qdisc object.
