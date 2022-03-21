Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7C54E2772
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347813AbiCUN0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiCUN0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:26:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403F3546AC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647869102; x=1679405102;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nfiPO0ZVUD1R2nVf3Q/DO81jYICI3tRkrwLe1wt3Yu0=;
  b=G3YASPIjKLMl+Twi3LiK6Vs6L02Q3dMXVUj/eOPi43VfDaJfnulqM/qN
   H7uD+gLKKw8nML1vv6DFXbqT3+9cZDcmPbyH4pqqGiuiOXPjfhZirn9rq
   k6E3RPGtVE6N6+YsNIxtAj39EjwNdHnVbBxBCwGYGB7d5RBIJHHR+CdMP
   mXaqjxwHhP3Oj6W8u4R/TK+sUTss1OeuisBacTZx/nskac7OxOhIe2wRZ
   EjSX71u419IGpDUs0NWXoj647zdbSXVPJl4F1hk8hxih7rHwP7yy4Knkh
   ES8pLTHAndV3cpL8Jyq74JRvRTVSllvZZVoPBIArxizdBYcLZilhQRZQ/
   w==;
X-IronPort-AV: E=Sophos;i="5.90,198,1643698800"; 
   d="scan'208";a="89597950"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 06:25:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 06:25:01 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 06:24:59 -0700
Message-ID: <8fc16e374a9e5b0f6ba370b5f54304597b057f7d.camel@microchip.com>
Subject: Re: [PATCH net-next 1/2] net: sparx5: Add arbiter for managing PGID
 table
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Date:   Mon, 21 Mar 2022 14:23:38 +0100
In-Reply-To: <20220321101446.2372093-2-casper.casan@gmail.com>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
         <20220321101446.2372093-2-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casper,

On Mon, 2022-03-21 at 11:14 +0100, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> The PGID (Port Group ID) table holds port masks
> for different purposes. The first 72 are reserved
> for port destination masks, flood masks, and CPU
> forwarding. The rest are shared between multicast,
> link aggregation, and virtualization profiles. The
> GLAG area is reserved to not be used by anything
> else, since it is a subset of the MCAST area.
> 
> The arbiter keeps track of which entries are in
> use. You can ask for a free ID or give back one
> you are done using.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  .../net/ethernet/microchip/sparx5/Makefile    |  2 +-
>  .../ethernet/microchip/sparx5/sparx5_main.c   |  3 +
>  .../ethernet/microchip/sparx5/sparx5_main.h   | 21 +++++++
>  .../ethernet/microchip/sparx5/sparx5_pgid.c   | 60 +++++++++++++++++++
>  4 files changed, 85 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile
> b/drivers/net/ethernet/microchip/sparx5/Makefile
> index e9dd348a6ebb..4402c3ed1dc5 100644
> --- a/drivers/net/ethernet/microchip/sparx5/Makefile
> +++ b/drivers/net/ethernet/microchip/sparx5/Makefile
> @@ -8,4 +8,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
>  sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
>   sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
>   sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
> - sparx5_ptp.o
> + sparx5_ptp.o sparx5_pgid.o
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> index 5f7c7030ce03..01be7bd84181 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> @@ -626,6 +626,9 @@ static int sparx5_start(struct sparx5 *sparx5)
>         /* Init MAC table, ageing */
>         sparx5_mact_init(sparx5);
> 
> +       /* Init PGID table arbitrator */
> +       sparx5_pgid_init(sparx5);
> +
>         /* Setup VLANs */
>         sparx5_vlan_init(sparx5);
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index df68a0891029..e97fa091c740 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -66,6 +66,12 @@ enum sparx5_vlan_port_type {
>  #define PGID_BCAST            (PGID_BASE + 6)
>  #define PGID_CPU              (PGID_BASE + 7)
> 
> +#define PGID_TABLE_SIZE               3290
> +
> +#define PGID_MCAST_START 65

This overlaps with PGID_UC_FLOOD above.  You should drop this.
Please see this description:

https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html?select=ana_ac,pgid

> 
> +#define PGID_GLAG_START 833
> +#define PGID_GLAG_END 1088

You do not appear to put the GLAG feature into use so you should remove these for now.

> +
>  #define IFH_LEN                9 /* 36 bytes */
>  #define NULL_VID               0
>  #define SPX5_MACT_PULL_DELAY   (2 * HZ)
> @@ -271,6 +277,8 @@ struct sparx5 {
>         struct mutex ptp_lock; /* lock for ptp interface state */
>         u16 ptp_skbs;
>         int ptp_irq;
> +       /* PGID allocation map */
> +       u8 pgid_map[PGID_TABLE_SIZE];
>  };
> 
>  /* sparx5_switchdev.c */
> @@ -359,6 +367,19 @@ void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
>                                  struct sk_buff *skb);
>  irqreturn_t sparx5_ptp_irq_handler(int irq, void *args);
> 
> +/* sparx5_pgid.c */
> +enum sparx5_pgid_type {
> +       SPX5_PGID_FREE,
> +       SPX5_PGID_RESERVED,
> +       SPX5_PGID_MULTICAST,
> +       SPX5_PGID_GLAG
> +};
> +
> +void sparx5_pgid_init(struct sparx5 *spx5);
> +int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx);
> +int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx);
> +int sparx5_pgid_free(struct sparx5 *spx5, u16 idx);
> +
>  /* Clock period in picoseconds */
>  static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
>  {
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> new file mode 100644
> index 000000000000..90366fcb9958
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +#include "sparx5_main.h"
> +
> +void sparx5_pgid_init(struct sparx5 *spx5)
> +{
> +       int i;
> +
> +       for (i = 0; i < PGID_TABLE_SIZE; i++)
> +               spx5->pgid_map[i] = SPX5_PGID_FREE;
> +
> +       /* Reserved for unicast, flood control, broadcast, and CPU.
> +        * These cannot be freed.
> +        */
> +       for (i = 0; i <= PGID_CPU; i++)
> +               spx5->pgid_map[i] = SPX5_PGID_RESERVED;
> +}
> +
> +int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx)
> +{
> +       int i;
> +
> +       for (i = PGID_GLAG_START; i <= PGID_GLAG_END; i++)
> +               if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
> +                       spx5->pgid_map[i] = SPX5_PGID_GLAG;
> +                       *idx = i;
> +                       return 0;
> +               }
> +
> +       return -EBUSY;
> +}

You do not appear to put the GLAG feature into use so you should remove this function for now.

> +
> +int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx)
> +{
> +       int i;
> +
> +       for (i = PGID_MCAST_START; i < PGID_TABLE_SIZE; i++) {
> +               if (i == PGID_GLAG_START)
> +                       i = PGID_GLAG_END + 1;
> +
> +               if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
> +                       spx5->pgid_map[i] = SPX5_PGID_MULTICAST;
> +                       *idx = i;
> +                       return 0;
> +               }
> +       }
> +
> +       return -EBUSY;
> +}
> +
> +int sparx5_pgid_free(struct sparx5 *spx5, u16 idx)
> +{
> +       if (idx <= PGID_CPU || idx >= PGID_TABLE_SIZE)
> +               return -EINVAL;
> +
> +       if (spx5->pgid_map[idx] == SPX5_PGID_FREE)
> +               return -EINVAL;
> +
> +       spx5->pgid_map[idx] = SPX5_PGID_FREE;
> +       return 0;
> +}
> --
> 2.30.2
> 

