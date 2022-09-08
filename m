Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928EE5B176D
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiIHIoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiIHIoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC02DFBC
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 01:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662626670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PR0OHA6g3nNPNSAta8bHJ7Vq/hVWXnGeVaXd9AFdy+c=;
        b=WshjxHZrPxHeXrnunvf52cGNORmfTc5DqMTHd8+SIBG7L62Ty2cpuQ+IjJFGnmzPBKfRdS
        c5kQX5pBJUgwXkiy9iKnIJj3NMEbXuSYPw1UWnMMC5WaKUG401cn1y+x1ynBriVrJgIXKo
        tQTUhtEswg+tquv64oYGc4ET206kp6M=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-_kOhRmzCN_6ZqbkYalxjiQ-1; Thu, 08 Sep 2022 04:44:24 -0400
X-MC-Unique: _kOhRmzCN_6ZqbkYalxjiQ-1
Received: by mail-qk1-f200.google.com with SMTP id bm11-20020a05620a198b00b006bb2388ef0cso13966931qkb.5
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 01:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=PR0OHA6g3nNPNSAta8bHJ7Vq/hVWXnGeVaXd9AFdy+c=;
        b=e5ZYM+JRtCcdD8kHBmwZoXhOwzY3GIkuJUw/zZyXUIZ7V0btfu4mXIZG6bg0jA/8rL
         JrIOMH0CDdjxekn6ZezxGxnraAnEC+CwHxCmha5jYjGVmgG6n4LpuUU8f5X/76wLBwNG
         of6Ij6ryNrT57npiutgixIITv9+HVAk4Qpp85MLtbIRjYlWcob2NNNADezv8kLh6oZt9
         e5sybEZ96qZ+bHCehvWOTe3wXeZ6ayyqhXJdFksU4tvstC5+lqIXNwgXUSX8w1C6a9xM
         WHobbK/KI7mRWCkWUquNxrATCjbukaWmWG6fvh8vzCANQjhzJRg7Wq2Jgb8N/TLZd1f8
         jFUQ==
X-Gm-Message-State: ACgBeo2yJSLoMOyUC387x8smoEOh7KIAMa0P7zdkgeclpgzu9wGBezN4
        fEkWOytUCHEsQMPpuIyocVZGP+1HlOMSD4RJl+rY1p+joCFVo73ZIOWAYYbYBe6YwfGQQjhRgqi
        2sh669oDH3+WxwBeV
X-Received: by 2002:a05:622a:1003:b0:344:b4cc:b5f with SMTP id d3-20020a05622a100300b00344b4cc0b5fmr6878231qte.301.1662626662929;
        Thu, 08 Sep 2022 01:44:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR65B8frPO0hz8yE5tJx4RvRemLiUIO32M65Dv/PGXSlAykM9hh1WV+26li2zPcb+tcvc9tE3g==
X-Received: by 2002:a05:622a:1003:b0:344:b4cc:b5f with SMTP id d3-20020a05622a100300b00344b4cc0b5fmr6878213qte.301.1662626662516;
        Thu, 08 Sep 2022 01:44:22 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id fe7-20020a05622a4d4700b00342fc6a8e25sm14575149qtb.50.2022.09.08.01.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 01:44:22 -0700 (PDT)
Message-ID: <67a7ada098b9a65aa078733c7bd373677711e5bb.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: mv88e6xxx: Add functionality
 for handling RMU frames.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 08 Sep 2022 10:44:18 +0200
In-Reply-To: <20220905131917.3643193-2-mattias.forsblad@gmail.com>
References: <20220905131917.3643193-1-mattias.forsblad@gmail.com>
         <20220905131917.3643193-2-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 15:19 +0200, Mattias Forsblad wrote:
> The Marvell SOHO family has a secondary channel for sending
> control data other than the ordinary MDIO channel. The
> switch can process specially crafted ethernet frames
> as control frames. Add functionality for creating, sending,
> receiving and processing those frames. This channel is
> best suited for accessing larger data structures in the
> switch.
> Use this control channel for getting RMON counters.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c    |  73 +++++--
>  drivers/net/dsa/mv88e6xxx/chip.h    |  21 ++
>  drivers/net/dsa/mv88e6xxx/global1.c |  76 +++++++
>  drivers/net/dsa/mv88e6xxx/global1.h |   3 +
>  drivers/net/dsa/mv88e6xxx/rmu.c     | 310 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/rmu.h     |  28 +++
>  include/net/dsa.h                   |  20 +-
>  net/dsa/dsa.c                       |  28 +++
>  net/dsa/dsa2.c                      |   2 +
>  net/dsa/tag_dsa.c                   |  32 ++-
>  11 files changed, 575 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
> index c8eca2b6f959..105d7bd832c9 100644
> --- a/drivers/net/dsa/mv88e6xxx/Makefile
> +++ b/drivers/net/dsa/mv88e6xxx/Makefile
> @@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
>  mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
>  mv88e6xxx-objs += serdes.o
>  mv88e6xxx-objs += smi.o
> +mv88e6xxx-objs += rmu.o
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 6f4ea39ab466..81fd9b7a9afa 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -42,6 +42,7 @@
>  #include "ptp.h"
>  #include "serdes.h"
>  #include "smi.h"
> +#include "rmu.h"
>  
>  static void assert_reg_lock(struct mv88e6xxx_chip *chip)
>  {
> @@ -1233,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
>  				     u16 bank1_select, u16 histogram)
>  {
>  	struct mv88e6xxx_hw_stat *stat;
> +	int offset = 0;
> +	u64 high;
>  	int i, j;
>  
>  	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
>  		stat = &mv88e6xxx_hw_stats[i];
>  		if (stat->type & types) {
> -			mv88e6xxx_reg_lock(chip);
> -			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> -							      bank1_select,
> -							      histogram);
> -			mv88e6xxx_reg_unlock(chip);
> +			if (mv88e6xxx_rmu_available(chip) &&
> +			    !(stat->type & STATS_TYPE_PORT)) {
> +				if (stat->type & STATS_TYPE_BANK1)
> +					offset = 32;
> +
> +				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
> +				if (stat->size == 8) {
> +					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
> +							+ 1];
> +					data[j] += (high << 32);
> +				}
> +			} else {
> +				mv88e6xxx_reg_lock(chip);
> +				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> +								      bank1_select, histogram);
> +				mv88e6xxx_reg_unlock(chip);
> +			}
>  
>  			j++;
>  		}
> @@ -1311,8 +1326,8 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
>  	mv88e6xxx_reg_unlock(chip);
>  }
>  
> -static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
> -					uint64_t *data)
> +static void mv88e6xxx_get_ethtool_stats_mdio(struct dsa_switch *ds, int port,
> +					     uint64_t *data)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int ret;
> @@ -1326,7 +1341,18 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>  		return;
>  
>  	mv88e6xxx_get_stats(chip, port, data);
> +}
> +
> +static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
> +					uint64_t *data)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
>  
> +	/* If RMU isn't available fall back to MDIO access. */
> +	if (mv88e6xxx_rmu_available(chip))
> +		chip->rmu.ops->get_rmon(chip, port, data);
> +	else
> +		mv88e6xxx_get_ethtool_stats_mdio(ds, port, data);
>  }
>  
>  static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
> @@ -1535,14 +1561,6 @@ static int mv88e6xxx_trunk_setup(struct mv88e6xxx_chip *chip)
>  	return 0;
>  }
>  
> -static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
> -{
> -	if (chip->info->ops->rmu_disable)
> -		return chip->info->ops->rmu_disable(chip);
> -
> -	return 0;
> -}
> -
>  static int mv88e6xxx_pot_setup(struct mv88e6xxx_chip *chip)
>  {
>  	if (chip->info->ops->pot_clear)
> @@ -4098,6 +4116,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
>  	.ppu_disable = mv88e6185_g1_ppu_disable,
>  	.reset = mv88e6185_g1_reset,
>  	.rmu_disable = mv88e6085_g1_rmu_disable,
> +	.rmu_enable = mv88e6085_g1_rmu_enable,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.stu_getnext = mv88e6352_g1_stu_getnext,
> @@ -4181,6 +4200,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6085_g1_rmu_disable,
> +	.rmu_enable = mv88e6085_g1_rmu_enable,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
>  	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
>  	.phylink_get_caps = mv88e6095_phylink_get_caps,
> @@ -5300,6 +5320,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6352_g1_rmu_disable,
> +	.rmu_enable = mv88e6352_g1_rmu_enable,
>  	.atu_get_hash = mv88e6165_g1_atu_get_hash,
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6352_g1_vtu_getnext,
> @@ -5367,6 +5388,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.rmu_enable = mv88e6390_g1_rmu_enable,
>  	.atu_get_hash = mv88e6165_g1_atu_get_hash,
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
> @@ -5434,6 +5456,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.rmu_enable = mv88e6390_g1_rmu_enable,
>  	.atu_get_hash = mv88e6165_g1_atu_get_hash,
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
> @@ -5504,6 +5527,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
>  	.pot_clear = mv88e6xxx_g2_pot_clear,
>  	.reset = mv88e6352_g1_reset,
>  	.rmu_disable = mv88e6390_g1_rmu_disable,
> +	.rmu_enable = mv88e6390_g1_rmu_enable,
>  	.atu_get_hash = mv88e6165_g1_atu_get_hash,
>  	.atu_set_hash = mv88e6165_g1_atu_set_hash,
>  	.vtu_getnext = mv88e6390_g1_vtu_getnext,
> @@ -6861,6 +6885,23 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
>  	return err_sync ? : err_pvt;
>  }
>  
> +int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
> +				   enum dsa_tag_protocol proto)
> +{
> +	struct dsa_tagger_data *tagger_data = ds->tagger_data;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_DSA:
> +	case DSA_TAG_PROTO_EDSA:
> +		tagger_data->decode_frame2reg = mv88e6xxx_decode_frame2reg_handler;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
>  	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
> @@ -6926,6 +6967,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
>  	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
>  	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
> +	.master_state_change	= mv88e6xxx_master_change,
> +	.connect_tag_protocol	= mv88e6xxx_connect_tag_protocol,
>  };
>  
>  static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index e693154cf803..c7477b716473 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -266,6 +266,7 @@ struct mv88e6xxx_vlan {
>  struct mv88e6xxx_port {
>  	struct mv88e6xxx_chip *chip;
>  	int port;
> +	u64 rmu_raw_stats[64];
>  	struct mv88e6xxx_vlan bridge_pvid;
>  	u64 serdes_stats[2];
>  	u64 atu_member_violation;
> @@ -282,6 +283,17 @@ struct mv88e6xxx_port {
>  	struct devlink_region *region;
>  };
>  
> +struct mv88e6xxx_rmu {
> +	/* RMU resources */
> +	struct net_device *master_netdev;
> +	const struct mv88e6xxx_bus_ops *ops;
> +	/* Mutex for RMU operations */
> +	struct mutex mutex;
> +	u16 got_id;
> +	u8 request_cmd;
> +	int inband_seqno;
> +};
> +
>  enum mv88e6xxx_region_id {
>  	MV88E6XXX_REGION_GLOBAL1 = 0,
>  	MV88E6XXX_REGION_GLOBAL2,
> @@ -410,12 +422,16 @@ struct mv88e6xxx_chip {
>  
>  	/* Bridge MST to SID mappings */
>  	struct list_head msts;
> +
> +	/* RMU resources */
> +	struct mv88e6xxx_rmu rmu;
>  };
>  
>  struct mv88e6xxx_bus_ops {
>  	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
>  	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
>  	int (*init)(struct mv88e6xxx_chip *chip);
> +	int (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
>  };
>  
>  struct mv88e6xxx_mdio_bus {
> @@ -637,6 +653,7 @@ struct mv88e6xxx_ops {
>  
>  	/* Remote Management Unit operations */
>  	int (*rmu_disable)(struct mv88e6xxx_chip *chip);
> +	int (*rmu_enable)(struct mv88e6xxx_chip *chip, int port);
>  
>  	/* Precision Time Protocol operations */
>  	const struct mv88e6xxx_ptp_ops *ptp_ops;
> @@ -804,4 +821,8 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
>  
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
>  
> +static inline bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
> +{
> +	return chip->rmu.master_netdev ? 1 : 0;
> +}
>  #endif /* _MV88E6XXX_CHIP_H */
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
> index 5848112036b0..f6c288ece0ba 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> @@ -466,18 +466,94 @@ int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip)
>  				      MV88E6085_G1_CTL2_RM_ENABLE, 0);
>  }
>  
> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +
> +	switch (upstream_port) {
> +	case 9:
> +		val = MV88E6085_G1_CTL2_RM_ENABLE;
> +		break;
> +	case 10:
> +		val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
> +				      MV88E6085_G1_CTL2_RM_ENABLE, val);
> +}
> +
>  int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
>  {
>  	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
>  				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
>  }
>  
> +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +	int upstream_port;
> +
> +	upstream_port = dsa_switch_upstream_port(chip->ds);
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +	if (upstream_port < 0)
> +		return -EOPNOTSUPP;
> +
> +	switch (upstream_port) {
> +	case 4:
> +		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_4;
> +		break;
> +	case 5:
> +		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_5;
> +		break;
> +	case 6:
> +		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_6;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
> +			val);
> +}
> +
>  int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip)
>  {
>  	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
>  				      MV88E6390_G1_CTL2_RMU_MODE_DISABLED);
>  }
>  
> +int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
> +{
> +	int val = MV88E6390_G1_CTL2_RMU_MODE_DISABLED;
> +
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +
> +	switch (upstream_port) {
> +	case 0:
> +		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_0;
> +		break;
> +	case 1:
> +		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_1;
> +		break;
> +	case 9:
> +		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_9;
> +		break;
> +	case 10:
> +		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_10;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
> +			val);

Minor nit: you should align 'val' with the open bracket or even better
you can use a single line for the whole statement.

> +}
> +
>  int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip)
>  {
>  	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_HIST_MODE_MASK,
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> index 65958b2a0d3a..29c0c8acb583 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -313,8 +313,11 @@ int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
>  int mv88e6185_g1_set_cascade_port(struct mv88e6xxx_chip *chip, int port);
>  
>  int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip);
> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port);
>  int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip);
> +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port);
>  int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip);
> +int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port);
>  
>  int mv88e6xxx_g1_set_device_number(struct mv88e6xxx_chip *chip, int index);
>  
> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
> new file mode 100644
> index 000000000000..7bc5b1ea3e9b
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.c
> @@ -0,0 +1,310 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#include <asm/unaligned.h>
> +#include "rmu.h"
> +#include "global1.h"
> +
> +#define MV88E6XXX_DSA_HLEN	4
> +
> +static const u8 rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
> +
> +#define MV88E6XXX_RMU_L2_BYTE1_RESV_VAL		0x3e
> +#define MV88E6XXX_RMU				1
> +#define MV88E6XXX_RMU_PRIO			6
> +#define MV88E6XXX_RMU_RESV2			0xf
> +
> +#define MV88E6XXX_SOURCE_PORT			GENMASK(6, 3)
> +#define MV88E6XXX_SOURCE_DEV			GENMASK(5, 0)
> +#define MV88E6XXX_CPU_CODE_MASK			GENMASK(7, 6)
> +#define MV88E6XXX_TRG_DEV_MASK			GENMASK(4, 0)
> +#define MV88E6XXX_RMU_CODE_MASK			GENMASK(1, 1)
> +#define MV88E6XXX_RMU_PRIO_MASK			GENMASK(7, 5)
> +#define MV88E6XXX_RMU_L2_BYTE1_RESV		GENMASK(7, 2)
> +#define MV88E6XXX_RMU_L2_BYTE2_RESV		GENMASK(3, 0)
> +
> +#define MV88E6XXX_RMU_RESP_FORMAT_1		0x0001
> +#define MV88E6XXX_RMU_RESP_FORMAT_2		0x0002
> +#define MV88E6XXX_RMU_RESP_ERROR		0xffff
> +
> +#define MV88E6XXX_RMU_RESP_CODE_GOT_ID		0x0000
> +#define MV88E6XXX_RMU_RESP_CODE_DUMP_MIB	0x1020
> +
> +static void mv88e6xxx_rmu_create_l2(struct sk_buff *skb, struct dsa_port *dp)
> +{
> +	struct mv88e6xxx_chip *chip = dp->ds->priv;
> +	struct ethhdr *eth;
> +	u8 *edsa_header;
> +	u8 *dsa_header;
> +	u8 extra = 0;
> +
> +	if (chip->tag_protocol == DSA_TAG_PROTO_EDSA)
> +		extra = 4;
> +
> +	/* Create RMU L2 header */
> +	dsa_header = skb_push(skb, 6);
> +	dsa_header[0] = FIELD_PREP(MV88E6XXX_CPU_CODE_MASK, MV88E6XXX_RMU);
> +	dsa_header[0] |= FIELD_PREP(MV88E6XXX_TRG_DEV_MASK, dp->ds->index);
> +	dsa_header[1] = FIELD_PREP(MV88E6XXX_RMU_CODE_MASK, 1);
> +	dsa_header[1] |= FIELD_PREP(MV88E6XXX_RMU_L2_BYTE1_RESV, MV88E6XXX_RMU_L2_BYTE1_RESV_VAL);
> +	dsa_header[2] = FIELD_PREP(MV88E6XXX_RMU_PRIO_MASK, MV88E6XXX_RMU_PRIO);
> +	dsa_header[2] |= MV88E6XXX_RMU_L2_BYTE2_RESV;
> +	dsa_header[3] = ++chip->rmu.inband_seqno;
> +	dsa_header[4] = 0;
> +	dsa_header[5] = 0;
> +
> +	/* Insert RMU MAC destination address /w extra if needed */
> +	skb_push(skb, ETH_ALEN * 2 + extra);
> +	eth = (struct ethhdr *)skb->data;
> +	memcpy(eth->h_dest, rmu_dest_addr, ETH_ALEN);
> +	memcpy(eth->h_source, chip->rmu.master_netdev->dev_addr, ETH_ALEN);
> +
> +	if (extra) {
> +		edsa_header = (u8 *)&eth->h_proto;
> +		edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
> +		edsa_header[1] = ETH_P_EDSA & 0xff;
> +		edsa_header[2] = 0x00;
> +		edsa_header[3] = 0x00;
> +	}
> +}
> +
> +static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip, int port,
> +				   int request, const char *msg, int len)
> +{
> +	struct dsa_port *dp;
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	int ret = 0;
> +
> +	dp = dsa_to_port(chip->ds, port);
> +	if (!dp)
> +		return 0;
> +
> +	skb = netdev_alloc_skb(chip->rmu.master_netdev, 64);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	/* Take height for an eventual EDSA header */
> +	skb_reserve(skb, 2 * ETH_HLEN + 4);
> +	skb_reset_network_header(skb);
> +
> +	/* Insert RMU L3 message */
> +	data = skb_put(skb, len);
> +	memcpy(data, msg, len);
> +
> +	mv88e6xxx_rmu_create_l2(skb, dp);
> +
> +	mutex_lock(&chip->rmu.mutex);
> +
> +	chip->rmu.request_cmd = request;
> +
> +	ret = dsa_switch_inband_tx(dp->ds, skb, NULL, MV88E6XXX_RMU_WAIT_TIME_MS);
> +	if (ret < 0) {

Minor nit: bracket not needed here.

> +		dev_err(chip->dev,
> +			"RMU: timeout waiting for request %d (%pe) on port %d\n",
> +			request, ERR_PTR(ret), port);
> +	}
> +
> +	mutex_unlock(&chip->rmu.mutex);
> +
> +	return ret > 0 ? 0 : ret;
> +}
> +
> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const u8 get_id[8] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
> +	int ret = -1;
> +
> +	if (chip->rmu.got_id)
> +		return 0;
> +
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_GET_ID, get_id, 8);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
> +{
> +	u8 dump_mib[8] = { 0x00, 0x01, 0x00, 0x00, 0x10, 0x20, 0x00, 0x00 };
> +	int ret;
> +
> +	ret = mv88e6xxx_rmu_get_id(chip, port);
> +	if (ret)
> +		return ret;
> +
> +	/* Send a GET_MIB command */
> +	dump_mib[7] = port;
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_DUMP_MIB, dump_mib, 8);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
> +			ERR_PTR(ret), port);
> +		return ret;
> +	}
> +
> +	/* Update MIB for port */
> +	if (chip->info->ops->stats_get_stats)
> +		return chip->info->ops->stats_get_stats(chip, port, data);
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
> +			     bool operational)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct dsa_port *cpu_dp;
> +	int port;
> +
> +	cpu_dp = master->dsa_ptr;
> +	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	if (operational) {
> +		if (chip->info->ops->rmu_enable) {
> +			if (!chip->info->ops->rmu_enable(chip, port))
> +				chip->rmu.master_netdev = (struct net_device *)master;
> +			else
> +				dev_err(chip->dev, "RMU: Unable to enable on port %d", port);
> +		}
> +
> +	} else {
> +		chip->rmu.master_netdev = NULL;
> +		if (chip->info->ops->rmu_disable)
> +			chip->info->ops->rmu_disable(chip);
> +	}
> +
> +	mv88e6xxx_reg_unlock(chip);
> +}
> +
> +static void mv88e6xxx_prod_id_handler(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	u16 prodnum;
> +
> +	prodnum = get_unaligned_be16(&skb->data[2]);
> +	chip->rmu.got_id = prodnum;
> +	dev_dbg_ratelimited(chip->dev, "RMU: received id OK with product number: 0x%04x\n",
> +			    chip->rmu.got_id);
> +}
> +
> +static void mv88e6xxx_mib_handler(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_port *p;
> +	u8 port;
> +	int i;
> +
> +	port = FIELD_GET(MV88E6XXX_SOURCE_PORT, skb->data[7]);
> +	p = &chip->ports[port];
> +	if (!p) {
> +		dev_err_ratelimited(chip->dev, "RMU: illegal port number in response: %d\n", port);
> +		return;
> +	}
> +
> +	/* Copy whole array for further
> +	 * processing according to chip type
> +	 */
> +	for (i = 0; i < MV88E6XXX_RMU_MAX_RMON; i++)
> +		p->rmu_raw_stats[i] = get_unaligned_be32(&skb->data[12 + i * 4]);
> +}
> +
> +static int mv88e6xxx_validate_mac(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	unsigned char *ethhdr;
> +
> +	/* Check matching MAC */
> +	ethhdr = skb_mac_header(skb);
> +	if (!ether_addr_equal(chip->rmu.master_netdev->dev_addr, ethhdr)) {
> +		dev_dbg_ratelimited(ds->dev, "RMU: mismatching MAC address for request. Rx %pM expecting %pM\n",
> +				    ethhdr, chip->rmu.master_netdev->dev_addr);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
> +{
> +	struct dsa_tagger_data *tagger_data;
> +	struct dsa_port *dp = dev->dsa_ptr;
> +	struct dsa_switch *ds = dp->ds;
> +	struct mv88e6xxx_chip *chip;
> +	int source_device;
> +	u8 *dsa_header;
> +	u16 format;
> +	u16 code;
> +	u8 seqno;
> +
> +	tagger_data = ds->tagger_data;
> +
> +	if (mv88e6xxx_validate_mac(ds, skb))
> +		return;
> +
> +	/* Decode Frame2Reg DSA portion */
> +	dsa_header = skb->data - 2;
> +
> +	source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
> +	ds = dsa_switch_find(ds->dst->index, source_device);
> +	if (!ds) {
> +		net_dbg_ratelimited("RMU: Didn't find switch with index %d", source_device);
> +		return;
> +	}
> +
> +	chip = ds->priv;
> +	seqno = dsa_header[3];
> +	if (seqno != chip->rmu.inband_seqno) {
> +		net_dbg_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
> +				    seqno, chip->rmu.inband_seqno);
> +		return;
> +	}
> +
> +	/* Pull DSA L2 data */
> +	skb_pull(skb, MV88E6XXX_DSA_HLEN);
> +
> +	format = get_unaligned_be16(&skb->data[0]);
> +	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
> +	    format != MV88E6XXX_RMU_RESP_FORMAT_2) {
> +		net_dbg_ratelimited("RMU: received unknown format 0x%04x", format);
> +		return;
> +	}
> +
> +	code = get_unaligned_be16(&skb->data[4]);
> +	if (code == MV88E6XXX_RMU_RESP_ERROR) {
> +		net_dbg_ratelimited("RMU: error response code 0x%04x", code);
> +		return;
> +	}
> +
> +	if (code == MV88E6XXX_RMU_RESP_CODE_GOT_ID)
> +		mv88e6xxx_prod_id_handler(ds, skb);
> +	else if (code == MV88E6XXX_RMU_RESP_CODE_DUMP_MIB)
> +		mv88e6xxx_mib_handler(ds, skb);
> +
> +	dsa_switch_inband_complete(ds, NULL);
> +}
> +
> +static const struct mv88e6xxx_bus_ops mv88e6xxx_bus_ops = {
> +	.get_rmon = mv88e6xxx_rmu_stats_get,
> +};
> +
> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
> +{
> +	mutex_init(&chip->rmu.mutex);
> +
> +	chip->rmu.ops = &mv88e6xxx_bus_ops;
> +
> +	if (chip->info->ops->rmu_disable)
> +		return chip->info->ops->rmu_disable(chip);
> +
> +	return 0;
> +}
> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
> new file mode 100644
> index 000000000000..cf84b7005331
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#ifndef _MV88E6XXX_RMU_H_
> +#define _MV88E6XXX_RMU_H_
> +
> +#include "chip.h"
> +
> +#define MV88E6XXX_RMU_MAX_RMON			64
> +
> +#define MV88E6XXX_RMU_REQ_GET_ID		1
> +#define MV88E6XXX_RMU_REQ_DUMP_MIB		2
> +
> +#define MV88E6XXX_RMU_WAIT_TIME_MS		20
> +
> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip);
> +
> +void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
> +			     bool operational);
> +
> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb);
> +
> +#endif /* _MV88E6XXX_RMU_H_ */
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..5c8dccc8bc3e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -130,6 +130,11 @@ struct dsa_lag {
>  	refcount_t refcount;
>  };
>  
> +struct dsa_tagger_data {
> +	void (*decode_frame2reg)(struct net_device *netdev,
> +				 struct sk_buff *skb);
> +};
> +
>  struct dsa_switch_tree {
>  	struct list_head	list;
>  
> @@ -495,6 +500,8 @@ struct dsa_switch {
>  	unsigned int		max_num_bridges;
>  
>  	unsigned int		num_ports;
> +
> +	struct completion	inband_done;
>  };
>  
>  static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
> @@ -822,7 +829,7 @@ struct dsa_switch_ops {
>  	 * in current use. The switch driver can provide handlers for certain
>  	 * types of packets for switch management.
>  	 */
> -	int	(*connect_tag_protocol)(struct dsa_switch *ds,
> +	int (*connect_tag_protocol)(struct dsa_switch *ds,
>  					enum dsa_tag_protocol proto);
>  
>  	/* Optional switch-wide initialization and destruction methods */
> @@ -1390,6 +1397,17 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
>  void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
>  				unsigned int count);
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout);
> +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> +{
> +	/* Custom completion? */
> +	if (completion)
> +		complete(completion);
> +	else
> +		complete(&ds->inband_done);
> +}
> +
>  #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
>  static int __init dsa_tag_driver_module_init(void)			\
>  {									\
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index be7b320cda76..2d7add779b6f 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -324,6 +324,34 @@ int dsa_switch_resume(struct dsa_switch *ds)
>  EXPORT_SYMBOL_GPL(dsa_switch_resume);
>  #endif
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout)
> +{
> +	int ret;
> +	struct completion *com;

Minor nit: please apply the reverse x-mas tree order.


Cheers,

Paolo

