Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A30D340FA6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhCRVPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:15:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhCRVPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:15:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMzzC-00BkQ7-H6; Thu, 18 Mar 2021 22:15:18 +0100
Date:   Thu, 18 Mar 2021 22:15:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 3/5] dpaa2-switch: reduce the size of the if_id
 bitmap to 64 bits
Message-ID: <YFPC5ojxMvCsPfni@lunn.ch>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
 <20210316145512.2152374-4-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316145512.2152374-4-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:55:10PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The maximum number of DPAA2 switch interfaces, including the control
> interface, is 64. Even though this restriction existed from the first
> place, the command structures which use an interface id bitmap were
> poorly described and even though a single uint64_t is enough, all of
> them used an array of 4 uint64_t's.
> Fix this by reducing the size of the interface id field to a single
> uint64_t.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  .../net/ethernet/freescale/dpaa2/dpsw-cmd.h    |  4 ++--
>  drivers/net/ethernet/freescale/dpaa2/dpsw.c    | 18 ++++++++++--------
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
> index 2371fd5c40e3..996a59dcd01d 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
> @@ -340,7 +340,7 @@ struct dpsw_cmd_vlan_manage_if {
>  	__le16 vlan_id;
>  	__le32 pad1;
>  	/* cmd word 1-4 */
> -	__le64 if_id[4];
> +	__le64 if_id;
>  };
>  
>  struct dpsw_cmd_vlan_remove {
> @@ -386,7 +386,7 @@ struct dpsw_cmd_fdb_multicast_op {
>  	u8 mac_addr[6];
>  	__le16 pad2;
>  	/* cmd word 2-5 */
> -	__le64 if_id[4];
> +	__le64 if_id;
>  };
>  
>  struct dpsw_cmd_fdb_dump {
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
> index ad7a4c03b130..ef0f90ae683f 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
> @@ -773,16 +773,18 @@ int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
>  		     u16 vlan_id,
>  		     const struct dpsw_vlan_if_cfg *cfg)
>  {
> +	struct dpsw_cmd_vlan_add_if *cmd_params;
>  	struct fsl_mc_command cmd = { 0 };
> -	struct dpsw_cmd_vlan_manage_if *cmd_params;

There is no mention in the commit message about replacing
dpsw_cmd_vlan_manage_if with dpsw_cmd_vlan_add_if. I wounder if this
should be a separate patch?

       Andrew
