Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6EF4E654D
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345126AbiCXOfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351199AbiCXOep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:34:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1911DAD10D
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648132379; x=1679668379;
  h=message-id:subject:from:to:date:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=LRlpHRlZyX9BQ9QLoH9VD9ueyrrx41N5+gfveevgGLQ=;
  b=at7k080oP9iFX5yuHCriom/grC8jyMDivggwNzvGfO600SklEl3lymS+
   AWyjVeOwkq5KWdVQC6WKC3ATUZWPpJGj8UjJ8jid7qvmqrOyr9eEbSVx/
   uWlBomMQupgJxkgApO2Nc71UICgkNq+TJNRBZsKWBoRT5vTC/EScJkaCk
   P7kFR0b1KKAlnUdkgrfhvvaZ8TAHiSzyAxgxllS9K5A2fqM23r6LYfU3Q
   Edwdd+brq5NI+o7OoL+IGjq5rcdVm6hjW1HR0eVhXPvAD2ev0LaBYnwp0
   Iz53czF7QZBTzICMa5ia7mQD8J8PkIUw6q8+YNwdU8fwE3PZzAI3wMj4I
   g==;
X-IronPort-AV: E=Sophos;i="5.90,207,1643698800"; 
   d="scan'208";a="150301675"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2022 07:32:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 24 Mar 2022 07:32:56 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 24 Mar 2022 07:32:54 -0700
Message-ID: <8c099860e0c0dc70bf4936cb672c6579c2553495.camel@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: sparx5: Refactor mdb handling
 according to feedback
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Date:   Thu, 24 Mar 2022 15:31:32 +0100
In-Reply-To: <20220324113853.576803-3-casper.casan@gmail.com>
References: <20220324113853.576803-1-casper.casan@gmail.com>
         <20220324113853.576803-3-casper.casan@gmail.com>
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

On Thu, 2022-03-24 at 12:38 +0100, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> - Remove mact_lookup and use new mact_find instead.
> - Make pgid_read_mask function.
> - Set PGID arbiter to start searching at PGID_BASE + 8.
> 
> This is according to feedback on previous patch.
> https://lore.kernel.org/netdev/20220322081823.wqbx7vud4q7qtjuq@wse-c0155/T/#t
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  .../microchip/sparx5/sparx5_mactable.c        | 19 ++++---------------
>  .../ethernet/microchip/sparx5/sparx5_main.h   |  3 ++-
>  .../ethernet/microchip/sparx5/sparx5_pgid.c   |  3 +++
>  .../microchip/sparx5/sparx5_switchdev.c       | 18 ++++++++----------
>  .../ethernet/microchip/sparx5/sparx5_vlan.c   |  7 +++++++
>  5 files changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> index 35abb3d0ce19..a5837dbe0c7e 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> @@ -212,19 +212,7 @@ bool sparx5_mact_find(struct sparx5 *sparx5,
> 
>         mutex_unlock(&sparx5->lock);
> 
> -       return ret == 0;
> -}
> -
> -static int sparx5_mact_lookup(struct sparx5 *sparx5,
> -                             const unsigned char mac[ETH_ALEN],
> -                             u16 vid)
> -{
> -       u32 pcfg2;
> -
> -       if (sparx5_mact_find(sparx5, mac, vid, &pcfg2))
> -               return 1;
> -
> -       return 0;
> +       return ret;
>  }
> 
>  int sparx5_mact_forget(struct sparx5 *sparx5,
> @@ -305,9 +293,10 @@ int sparx5_add_mact_entry(struct sparx5 *sparx5,
>  {
>         struct sparx5_mact_entry *mact_entry;
>         int ret;
> +       u32 cfg2;
> 
> -       ret = sparx5_mact_lookup(sparx5, addr, vid);
> -       if (ret)
> +       ret = sparx5_mact_find(sparx5, addr, vid, &cfg2);
> +       if (!ret)
>                 return 0;
> 
>         /* In case the entry already exists, don't add it again to SW,
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index 8e77d7ee8e68..b197129044b5 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -65,10 +65,10 @@ enum sparx5_vlan_port_type {
>  #define PGID_IPV6_MC_CTRL      (PGID_BASE + 5)
>  #define PGID_BCAST            (PGID_BASE + 6)
>  #define PGID_CPU              (PGID_BASE + 7)
> +#define PGID_MCAST_START       (PGID_BASE + 8)
> 
>  #define PGID_TABLE_SIZE               3290
> 
> -#define PGID_MCAST_START 65
>  #define IFH_LEN                9 /* 36 bytes */
>  #define NULL_VID               0
>  #define SPX5_MACT_PULL_DELAY   (2 * HZ)
> @@ -325,6 +325,7 @@ void sparx5_mact_init(struct sparx5 *sparx5);
> 
>  /* sparx5_vlan.c */
>  void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable);
> +void sparx5_pgid_read_mask(struct sparx5 *sparx5, int pgid, u32 portmask[3]);
>  void sparx5_update_fwd(struct sparx5 *sparx5);
>  void sparx5_vlan_init(struct sparx5 *sparx5);
>  void sparx5_vlan_port_setup(struct sparx5 *sparx5, int portno);
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> index 851a559269e1..af8b435009f4 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
> @@ -19,6 +19,9 @@ int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx)
>  {
>         int i;
> 
> +       /* The multicast area starts at index 65, but the first 7
> +        * are reserved for flood masks and CPU. Start alloc after that.
> +        */
>         for (i = PGID_MCAST_START; i < PGID_TABLE_SIZE; i++) {
>                 if (spx5->pgid_map[i] == SPX5_PGID_FREE) {
>                         spx5->pgid_map[i] = SPX5_PGID_MULTICAST;
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> index 2d8e0b81c839..5389fffc694a 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> @@ -406,11 +406,11 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
> 
>         res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> 
> -       if (res) {
> +       if (res == 0) {
>                 pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> 
> -               /* MC_IDX has an offset of 65 in the PGID table. */
> -               pgid_idx += PGID_MCAST_START;
> +               /* MC_IDX starts after the port masks in the PGID table */
> +               pgid_idx += SPX5_PORTS;
>                 sparx5_pgid_update_mask(port, pgid_idx, true);
>         } else {
>                 err = sparx5_pgid_alloc_mcast(spx5, &pgid_idx);
> @@ -468,17 +468,15 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
> 
>         res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> 
> -       if (res) {
> +       if (res == 0) {
>                 pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> 
> -               /* MC_IDX has an offset of 65 in the PGID table. */
> -               pgid_idx += PGID_MCAST_START;
> +               /* MC_IDX starts after the port masks in the PGID table */
> +               pgid_idx += SPX5_PORTS;
>                 sparx5_pgid_update_mask(port, pgid_idx, false);
> 
> -               pgid_entry[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid_idx));
> -               pgid_entry[1] = spx5_rd(spx5, ANA_AC_PGID_CFG1(pgid_idx));
> -               pgid_entry[2] = spx5_rd(spx5, ANA_AC_PGID_CFG2(pgid_idx));
> -               if (pgid_entry[0] == 0 && pgid_entry[1] == 0 && pgid_entry[2] == 0) {
> +               sparx5_pgid_read_mask(spx5, pgid_idx, pgid_entry);
> +               if (bitmap_empty((unsigned long *)pgid_entry, SPX5_PORTS)) {
>                         /* No ports are in MC group. Remove entry */
>                         err = sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
>                         if (err)
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
> index 8e56ffa1c4f7..37e4ac965849 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
> @@ -138,6 +138,13 @@ void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable)
>         }
>  }
> 
> +void sparx5_pgid_read_mask(struct sparx5 *spx5, int pgid, u32 portmask[3])
> +{
> +       portmask[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid));
> +       portmask[1] = spx5_rd(spx5, ANA_AC_PGID_CFG1(pgid));
> +       portmask[2] = spx5_rd(spx5, ANA_AC_PGID_CFG2(pgid));
> +}
> +
>  void sparx5_update_fwd(struct sparx5 *sparx5)
>  {
>         DECLARE_BITMAP(workmask, SPX5_PORTS);
> --
> 2.30.2
> 

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

-- 
Best Regards
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com

