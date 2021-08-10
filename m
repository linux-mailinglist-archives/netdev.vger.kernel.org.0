Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7F93E53E4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbhHJGvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJGvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 02:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E072961058;
        Tue, 10 Aug 2021 06:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628578244;
        bh=JjReMicYs22Uk8N6pHcKsGXWWy4yMa3MVM4yZqWclpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmSRM6debqIguNMgoIJvU5/hS5KrulbaDN/jmM3CCB/e4Mj8Hn0Yb9QmB4xzxqzpN
         MDrXLdQ4fsUuM7WwrBY6pUet9TV4+t8/pMTRUBkBrK6dPhRPahNuO/CnZm/gNGZpKs
         dA3V2Hc5Px1iV0BfoiJ2erYfUOo2/Rq2cOC6YaPamNfKU6xRQJPRwng9Qdiy84B87o
         ptYKg9IIN1W3YHm1heotEjrsc/MgxCbsu1tyYUhq+BzZaAvbAu5pLTn95Ixm6f2YHb
         3ThByDlQ3XS1owI72yryXV88qugMv0dBn8fOoYcxyimLvFucXdIftTxfgwjtxmhjHB
         pe3uQOS1J+WWA==
Date:   Tue, 10 Aug 2021 09:50:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-s390@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Message-ID: <YRIhwQ3ji8eqPQOQ@unreal>
References: <20210809131152.509092-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809131152.509092-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 04:11:52PM +0300, Vladimir Oltean wrote:
> The blamed commit a new field to struct switchdev_notifier_fdb_info, but
> did not make sure that all call paths set it to something valid. For
> example, a switchdev driver may emit a SWITCHDEV_FDB_ADD_TO_BRIDGE
> notifier, and since the 'is_local' flag is not set, it contains junk
> from the stack, so the bridge might interpret those notifications as
> being for local FDB entries when that was not intended.
> 
> To avoid that now and in the future, zero-initialize all
> switchdev_notifier_fdb_info structures created by drivers such that all
> newly added fields to not need to touch drivers again.
> 
> Fixes: 2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB notifications")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 ++
>  drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c       | 1 +
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      | 2 ++
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 1 +
>  drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c    | 1 +
>  drivers/net/ethernet/rocker/rocker_main.c                  | 1 +
>  drivers/net/ethernet/rocker/rocker_ofdpa.c                 | 1 +
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 1 +
>  drivers/net/ethernet/ti/cpsw_switchdev.c                   | 1 +
>  drivers/s390/net/qeth_l2_main.c                            | 2 ++
>  net/dsa/slave.c                                            | 1 +
>  11 files changed, 14 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> index 0b3e8f2db294..cf60e80dd3ba 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> @@ -750,6 +750,7 @@ prestera_fdb_offload_notify(struct prestera_port *port,
>  {
>  	struct switchdev_notifier_fdb_info send_info;
>  
> +	memset(&send_info, 0, sizeof(send_info));

This can be written simpler.
struct switchdev_notifier_fdb_info send_info = {};

In all places.

Thanks

>  	send_info.addr = info->addr;
>  	send_info.vid = info->vid;
>  	send_info.offloaded = true;
> @@ -1146,6 +1147,7 @@ static void prestera_fdb_event(struct prestera_switch *sw,
>  	if (!dev)
>  		return;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = evt->fdb_evt.data.mac;
>  	info.vid = evt->fdb_evt.vid;
>  	info.offloaded = true;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
> index a6e1d4f78268..77e09397a062 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
> @@ -71,6 +71,7 @@ mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *
>  {
>  	struct switchdev_notifier_fdb_info send_info;
>  
> +	memset(&send_info, 0, sizeof(send_info));
>  	send_info.addr = addr;
>  	send_info.vid = vid;
>  	send_info.offloaded = true;
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 7e221ef01437..8a7660f2d048 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -9086,6 +9086,7 @@ static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
>  	if (!dev)
>  		return;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = mac;
>  	info.vid = 0;
>  	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
> @@ -9137,6 +9138,7 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
>  	if (!dev)
>  		return;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = mac;
>  	info.vid = vid;
>  	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
> index c5ef9aa64efe..f016d909bead 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
> @@ -2510,6 +2510,7 @@ mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
>  {
>  	struct switchdev_notifier_fdb_info info;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = mac;
>  	info.vid = vid;
>  	info.offloaded = offloaded;
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> index 0443f66b5550..fbc3f5e65882 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> @@ -279,6 +279,7 @@ static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
>  {
>  	struct switchdev_notifier_fdb_info info;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = mac;
>  	info.vid = vid;
>  	info.offloaded = offloaded;
> diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
> index a46633606cae..49d548be9fe4 100644
> --- a/drivers/net/ethernet/rocker/rocker_main.c
> +++ b/drivers/net/ethernet/rocker/rocker_main.c
> @@ -2717,6 +2717,7 @@ rocker_fdb_offload_notify(struct rocker_port *rocker_port,
>  {
>  	struct switchdev_notifier_fdb_info info;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = recv_info->addr;
>  	info.vid = recv_info->vid;
>  	info.offloaded = true;
> diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> index 967a634ee9ac..7d954fd24134 100644
> --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> @@ -1824,6 +1824,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
>  	bool learned = (lw->flags & OFDPA_OP_FLAG_LEARNED);
>  	struct switchdev_notifier_fdb_info info;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = lw->addr;
>  	info.vid = lw->vid;
>  
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
> index 9c29b363e9ae..81d2b1765a66 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
> @@ -360,6 +360,7 @@ static void am65_cpsw_fdb_offload_notify(struct net_device *ndev,
>  {
>  	struct switchdev_notifier_fdb_info info;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = rcv->addr;
>  	info.vid = rcv->vid;
>  	info.offloaded = true;
> diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
> index f7fb6e17dadd..446bdab06bdd 100644
> --- a/drivers/net/ethernet/ti/cpsw_switchdev.c
> +++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
> @@ -370,6 +370,7 @@ static void cpsw_fdb_offload_notify(struct net_device *ndev,
>  {
>  	struct switchdev_notifier_fdb_info info;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = rcv->addr;
>  	info.vid = rcv->vid;
>  	info.offloaded = true;
> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
> index 2abf86c104d5..843dd4f4d8d7 100644
> --- a/drivers/s390/net/qeth_l2_main.c
> +++ b/drivers/s390/net/qeth_l2_main.c
> @@ -283,6 +283,7 @@ static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
>  
>  	QETH_CARD_TEXT(card, 2, "fdbflush");
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = NULL;
>  	/* flush all VLANs: */
>  	info.vid = 0;
> @@ -693,6 +694,7 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
>  	if (qeth_is_my_net_if_token(card, token))
>  		return;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = ntfy_mac;
>  	/* don't report VLAN IDs */
>  	info.vid = 0;
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 532085da8d8f..1cb7f7e56784 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2298,6 +2298,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
>  	if (!dsa_is_user_port(ds, switchdev_work->port))
>  		return;
>  
> +	memset(&info, 0, sizeof(info));
>  	info.addr = switchdev_work->addr;
>  	info.vid = switchdev_work->vid;
>  	info.offloaded = true;
> -- 
> 2.25.1
> 
