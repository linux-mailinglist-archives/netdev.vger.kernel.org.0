Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4464E2774
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347814AbiCUN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343526AbiCUN1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:27:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14BE54FAC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647869149; x=1679405149;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QnznQV6HTN3cTghGFc7SIme8FZMuhjq1RqKdNx8X++4=;
  b=pkjR7jtpsk6JoKKhRqF1r+wagadD7YdTcQ+d+Lw+udIN6AlsjiF04n7H
   gRpbCZJh03UV0GxJjrZv8L/usAKMHxDiP+VpMD7A/p02ZOQz5frWmOZRa
   7vKoCuxIOs8JOLqHM4EOqBlRPYqCDw+vqf63USmqZVBxU2t3cppBEDmZ3
   QOQCPTtIU1sS5zuTsRVoqzbiR/gNzSfdRHti3su6zGICE1WgnTpzOby5n
   8RyNUWRCqaZEuz/g/wKjVlC32cgmheByTfq/Gec1jYD6Yl0C9pDLgptrI
   1urCpK4C2Ba/oR+ciEIflAiDwFre/WDZcy1BqAm9svpASRAzQiix47OLF
   g==;
X-IronPort-AV: E=Sophos;i="5.90,198,1643698800"; 
   d="scan'208";a="149857597"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 06:25:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 06:25:46 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 06:25:45 -0700
Message-ID: <23c07e81392bd5ae8f44a5270f91c6ca696baa31.camel@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: sparx5: Add mdb handlers
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Date:   Mon, 21 Mar 2022 14:24:24 +0100
In-Reply-To: <20220321101446.2372093-3-casper.casan@gmail.com>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
         <20220321101446.2372093-3-casper.casan@gmail.com>
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

On Mon, 2022-03-21 at 11:14 +0100, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Adds mdb handlers. Uses the PGID arbiter to
> find a free entry in the PGID table for the
> multicast group port mask.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  .../microchip/sparx5/sparx5_mactable.c        |  33 ++++--
>  .../ethernet/microchip/sparx5/sparx5_main.h   |   2 +
>  .../microchip/sparx5/sparx5_switchdev.c       | 111 ++++++++++++++++++
>  3 files changed, 136 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> index 82b1b3c9a065..35abb3d0ce19 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
> @@ -186,11 +186,11 @@ bool sparx5_mact_getnext(struct sparx5 *sparx5,
>         return ret == 0;
>  }
> 
> -static int sparx5_mact_lookup(struct sparx5 *sparx5,
> -                             const unsigned char mac[ETH_ALEN],
> -                             u16 vid)
> +bool sparx5_mact_find(struct sparx5 *sparx5,
> +                     const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
>  {
>         int ret;
> +       u32 cfg2;
> 
>         mutex_lock(&sparx5->lock);
> 
> @@ -202,16 +202,29 @@ static int sparx5_mact_lookup(struct sparx5 *sparx5,
>                 sparx5, LRN_COMMON_ACCESS_CTRL);
> 
>         ret = sparx5_mact_wait_for_completion(sparx5);
> -       if (ret)
> -               goto out;
> -
> -       ret = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET
> -               (spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2));
> +       if (ret == 0) {
> +               cfg2 = spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2);
> +               if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(cfg2))
> +                       *pcfg2 = cfg2;
> +               else
> +                       ret = -ENOENT;
> +       }
> 
> -out:
>         mutex_unlock(&sparx5->lock);
> 
> -       return ret;
> +       return ret == 0;
> +}
> +
> +static int sparx5_mact_lookup(struct sparx5 *sparx5,
> +                             const unsigned char mac[ETH_ALEN],
> +                             u16 vid)
> +{
> +       u32 pcfg2;
> +
> +       if (sparx5_mact_find(sparx5, mac, vid, &pcfg2))
> +               return 1;
> +
> +       return 0;
>  }

I suggest to drop this and only use your new function (or at least let it return a real error code
like -ENOENT in case of an error).

> 
>  int sparx5_mact_forget(struct sparx5 *sparx5,
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index e97fa091c740..7a04b8f2a546 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -310,6 +310,8 @@ int sparx5_mact_learn(struct sparx5 *sparx5, int port,
>                       const unsigned char mac[ETH_ALEN], u16 vid);
>  bool sparx5_mact_getnext(struct sparx5 *sparx5,
>                          unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2);
> +bool sparx5_mact_find(struct sparx5 *sparx5,
> +                     const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2);
>  int sparx5_mact_forget(struct sparx5 *sparx5,
>                        const unsigned char mac[ETH_ALEN], u16 vid);
>  int sparx5_add_mact_entry(struct sparx5 *sparx5,
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> index 2d5de1c06fab..9e1ea35d0c40 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> @@ -366,6 +366,109 @@ static int sparx5_handle_port_vlan_add(struct net_device *dev,
>                                   v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
>  }
> 
> +static int sparx5_handle_port_mdb_add(struct net_device *dev,
> +                                     struct notifier_block *nb,
> +                                     const struct switchdev_obj_port_mdb *v)
> +{
> +       struct sparx5_port *port = netdev_priv(dev);
> +       struct sparx5 *spx5 = port->sparx5;
> +       u16 pgid_idx, vid;
> +       u32 mact_entry;
> +       int res, err;
> +
> +       /* When VLAN unaware the vlan value is not parsed and we receive vid 0.
> +        * Fall back to bridge vid 1.
> +        */
> +       if (!br_vlan_enabled(spx5->hw_bridge_dev))
> +               vid = 1;
> +       else
> +               vid = v->vid;
> +
> +       res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> +
> +       if (res) {
> +               pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> +
> +               /* MC_IDX has an offset of 65 in the PGID table. */
> +               pgid_idx += PGID_MCAST_START;

This will overlap some of the first ports with the flood masks according to:

https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html?select=ana_ac,pgid

You should use the custom area (PGID_BASE + 8 and onwards) for this new feature.

> +               sparx5_pgid_update_mask(port, pgid_idx, true);
> +       } else {
> +               err = sparx5_pgid_alloc_mcast(spx5, &pgid_idx);
> +               if (err) {
> +                       netdev_warn(dev, "multicast pgid table full\n");
> +                       return err;
> +               }
> +               sparx5_pgid_update_mask(port, pgid_idx, true);
> +               err = sparx5_mact_learn(spx5, pgid_idx, v->addr, vid);
> +               if (err) {
> +                       netdev_warn(dev, "could not learn mac address %pM\n", v->addr);
> +                       sparx5_pgid_update_mask(port, pgid_idx, false);
> +                       return err;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int sparx5_mdb_del_entry(struct net_device *dev,
> +                               struct sparx5 *spx5,
> +                               const unsigned char mac[ETH_ALEN],
> +                               const u16 vid,
> +                               u16 pgid_idx)
> +{
> +       int err;
> +
> +       err = sparx5_mact_forget(spx5, mac, vid);
> +       if (err) {
> +               netdev_warn(dev, "could not forget mac address %pM", mac);
> +               return err;
> +       }
> +       err = sparx5_pgid_free(spx5, pgid_idx);
> +       if (err) {
> +               netdev_err(dev, "attempted to free already freed pgid\n");
> +               return err;
> +       }
> +       return 0;
> +}
> +
> +static int sparx5_handle_port_mdb_del(struct net_device *dev,
> +                                     struct notifier_block *nb,
> +                                     const struct switchdev_obj_port_mdb *v)
> +{
> +       struct sparx5_port *port = netdev_priv(dev);
> +       struct sparx5 *spx5 = port->sparx5;
> +       u16 pgid_idx, vid;
> +       u32 mact_entry, res, pgid_entry[3];
> +       int err;
> +
> +       if (!br_vlan_enabled(spx5->hw_bridge_dev))
> +               vid = 1;
> +       else
> +               vid = v->vid;
> +
> +       res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> +
> +       if (res) {
> +               pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> +
> +               /* MC_IDX has an offset of 65 in the PGID table. */
> +               pgid_idx += PGID_MCAST_START;
> +               sparx5_pgid_update_mask(port, pgid_idx, false);
> +
> +               pgid_entry[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid_idx));
> +               pgid_entry[1] = spx5_rd(spx5, ANA_AC_PGID_CFG1(pgid_idx));
> +               pgid_entry[2] = spx5_rd(spx5, ANA_AC_PGID_CFG2(pgid_idx));
> +               if (pgid_entry[0] == 0 && pgid_entry[1] == 0 && pgid_entry[2] == 0) {

Looks like you could use a function that gets the pgid port mask (the inverse of the
sparx5_pgid_update_mask() function)


> +                       /* No ports are in MC group. Remove entry */
> +                       err = sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
> +                       if (err)
> +                               return err;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  static int sparx5_handle_port_obj_add(struct net_device *dev,
>                                       struct notifier_block *nb,
>                                       struct switchdev_notifier_port_obj_info *info)
> @@ -378,6 +481,10 @@ static int sparx5_handle_port_obj_add(struct net_device *dev,
>                 err = sparx5_handle_port_vlan_add(dev, nb,
>                                                   SWITCHDEV_OBJ_PORT_VLAN(obj));
>                 break;
> +       case SWITCHDEV_OBJ_ID_PORT_MDB:
> +               err = sparx5_handle_port_mdb_add(dev, nb,
> +                                                SWITCHDEV_OBJ_PORT_MDB(obj));
> +               break;
>         default:
>                 err = -EOPNOTSUPP;
>                 break;
> @@ -426,6 +533,10 @@ static int sparx5_handle_port_obj_del(struct net_device *dev,
>                 err = sparx5_handle_port_vlan_del(dev, nb,
>                                                   SWITCHDEV_OBJ_PORT_VLAN(obj)->vid);
>                 break;
> +       case SWITCHDEV_OBJ_ID_PORT_MDB:
> +               err = sparx5_handle_port_mdb_del(dev, nb,
> +                                                SWITCHDEV_OBJ_PORT_MDB(obj));
> +               break;
>         default:
>                 err = -EOPNOTSUPP;
>                 break;
> --
> 2.30.2
> 

Best Regards
Steen
