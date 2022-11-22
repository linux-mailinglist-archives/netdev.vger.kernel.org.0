Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDED6341DA
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiKVQse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKVQsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:48:33 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CD65A6E1
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669135712; x=1700671712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NC5FXCDCOM5zTcqg5pf8rp+3/NXfFMZIZWCoe6yBrig=;
  b=N5HjHkrD+DfwKu4dI1FCwFeqVKiAy8Rclrq0F7iPFBKS5VtAhT3jMUNR
   yv/qby+eRjMYpudzjdLJFblJzswBDI7ybtFat8hp5jJe08BNVyUuho5vB
   vMgqoUDbAxOp3V+enfI8RWtl+kGF2UZSOe4mSLUWini8q2vZasFtE8FkQ
   S8gUJxb8ld4SnHAvPEOZ7lfvuuGGWL1Jc5AnsugmScoyYpTpgYiEpnc3Y
   iLmsgzYhQObZafN3VGvdss3CEWhz/9iFLyJlgK8BBZgChDaFrrWvw/kCJ
   KfhQ9pgQJh8ZPIfAMVV0G+z+UKxw3Scy3d6Gk3bpDjjHS3KDK4RujGAdX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="297216164"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="297216164"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 08:48:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="783902100"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="783902100"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 22 Nov 2022 08:48:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMGm9VQ030402;
        Tue, 22 Nov 2022 16:48:10 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: ethtool: support reporting link modes
Date:   Tue, 22 Nov 2022 17:47:57 +0100
Message-Id: <20221122164757.428409-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121112045.862295-1-simon.horman@corigine.com>
References: <20221121112045.862295-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@corigine.com>
Date: Mon, 21 Nov 2022 12:20:45 +0100

> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for reporting link modes,
> including `Supported link modes` and `Advertised link modes`,
> via ethtool $DEV.
> 
> A new command `SPCODE_READ_MEDIA` is added to read info from
> management firmware. Also, the mapping table `nfp_eth_media_table`
> associates the link modes between NFP and kernel. Both of them
> help to support this ability.
> 
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_main.h |  1 +
>  .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 56 ++++++++++++++++++
>  .../ethernet/netronome/nfp/nfpcore/nfp_nsp.c  | 17 ++++++
>  .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  | 59 +++++++++++++++++++
>  .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 27 +++++++++
>  5 files changed, 160 insertions(+)

[...]

> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index 0058ba2b3505..be434b01b724 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -293,6 +293,59 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
>  	}
>  }
>  
> +static const u8 nfp_eth_media_table[] = {

I wouldn't use u8 for a bit number, 256 bits is not difficult to
overflow. u16 would be safe here.

> +	[NFP_MEDIA_1000BASE_CX] = ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> +	[NFP_MEDIA_1000BASE_KX] = ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> +	[NFP_MEDIA_10GBASE_KX4] = ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
> +	[NFP_MEDIA_10GBASE_KR] = ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> +	[NFP_MEDIA_10GBASE_CX4] = ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
> +	[NFP_MEDIA_10GBASE_CR] = ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
> +	[NFP_MEDIA_10GBASE_SR] = ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
> +	[NFP_MEDIA_10GBASE_ER] = ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
> +	[NFP_MEDIA_25GBASE_KR] = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
> +	[NFP_MEDIA_25GBASE_KR_S] = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
> +	[NFP_MEDIA_25GBASE_CR] = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
> +	[NFP_MEDIA_25GBASE_CR_S] = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
> +	[NFP_MEDIA_25GBASE_SR] = ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
> +	[NFP_MEDIA_40GBASE_CR4] = ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
> +	[NFP_MEDIA_40GBASE_KR4] = ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
> +	[NFP_MEDIA_40GBASE_SR4] = ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
> +	[NFP_MEDIA_40GBASE_LR4] = ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
> +	[NFP_MEDIA_50GBASE_KR] = ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
> +	[NFP_MEDIA_50GBASE_SR] = ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
> +	[NFP_MEDIA_50GBASE_CR] = ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
> +	[NFP_MEDIA_50GBASE_LR] = ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
> +	[NFP_MEDIA_50GBASE_ER] = ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
> +	[NFP_MEDIA_50GBASE_FR] = ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
> +	[NFP_MEDIA_100GBASE_KR4] = ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
> +	[NFP_MEDIA_100GBASE_SR4] = ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
> +	[NFP_MEDIA_100GBASE_CR4] = ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
> +	[NFP_MEDIA_100GBASE_KP4] = ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
> +	[NFP_MEDIA_100GBASE_CR10] = ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,

Wouldn't it look fancier with one tab alignment? :>

> +};
> +
> +static void nfp_add_media_link_mode(struct nfp_port *port,
> +				    struct nfp_eth_table_port *eth_port,
> +				    struct ethtool_link_ksettings *cmd)
> +{
> +	struct nfp_eth_media_buf ethm = {.eth_index = eth_port->eth_index};

I'm not sure it's okay to do one-line struct initialization. Up to
you I guess, but looks a bit confusing to me, in comparison to the
initialization two functions below.

> +	struct nfp_cpp *cpp = port->app->cpp;
> +	u8 i;

Same here. And there's no point in using types shorter than u32 on
the stack. Just go with u32. And also,

> +
> +	if (nfp_eth_read_media(cpp, &ethm))
> +		return;
> +
> +	for (i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; ++i) {

Since we're on -std=gnu11 for a bunch of releases already, all new
loops are expected to go with the iterator declarations inside them.
E.g.

	for (u32 i = 0; i < ...

> +		if (test_bit(i, ethm.supported_modes))
> +			__set_bit(nfp_eth_media_table[i],
> +				  cmd->link_modes.supported);
> +
> +		if (test_bit(i, ethm.advertised_modes))
> +			__set_bit(nfp_eth_media_table[i],
> +				  cmd->link_modes.advertising);
> +	}
> +}
> +
>  /**
>   * nfp_net_get_link_ksettings - Get Link Speed settings
>   * @netdev:	network interface device structure
> @@ -311,6 +364,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
>  	u16 sts;
>  
>  	/* Init to unknowns */
> +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
> +	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
>  	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
>  	cmd->base.port = PORT_OTHER;
>  	cmd->base.speed = SPEED_UNKNOWN;
> @@ -321,6 +376,7 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
>  	if (eth_port) {
>  		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
>  		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
> +		nfp_add_media_link_mode(port, eth_port, cmd);
>  		if (eth_port->supp_aneg) {
>  			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
>  			if (eth_port->aneg == NFP_ANEG_AUTO) {
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
> index 730fea214b8a..7136bc48530b 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
> @@ -100,6 +100,7 @@ enum nfp_nsp_cmd {
>  	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
>  	SPCODE_VERSIONS		= 21, /* Report FW versions */
>  	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
> +	SPCODE_READ_MEDIA	= 23, /* Get either the supported or advertised media for a port */
>  };
>  
>  struct nfp_nsp_dma_buf {
> @@ -1100,4 +1101,20 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
>  	kfree(buf);
>  
>  	return ret;
> +};
> +
> +int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
> +{
> +	struct nfp_nsp_command_buf_arg media = {
> +		{
> +			.code		= SPCODE_READ_MEDIA,
> +			.option		= size,
> +		},
> +		.in_buf		= buf,
> +		.in_size	= size,
> +		.out_buf	= buf,
> +		.out_size	= size,
> +	};
> +
> +	return nfp_nsp_command_buf(state, &media);
>  }
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
> index 992d72ac98d3..c5630fe88a66 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
> @@ -65,6 +65,11 @@ static inline bool nfp_nsp_has_read_module_eeprom(struct nfp_nsp *state)
>  	return nfp_nsp_get_abi_ver_minor(state) > 28;
>  }
>  
> +static inline bool nfp_nsp_has_read_media(struct nfp_nsp *state)
> +{
> +	return nfp_nsp_get_abi_ver_minor(state) > 33;
> +}
> +
>  enum nfp_eth_interface {
>  	NFP_INTERFACE_NONE	= 0,
>  	NFP_INTERFACE_SFP	= 1,
> @@ -97,6 +102,47 @@ enum nfp_eth_fec {
>  	NFP_FEC_DISABLED_BIT,
>  };
>  
> +/* link modes about RJ45 haven't been used, so there's no mapping to them */
> +enum nfp_ethtool_link_mode_list {
> +	NFP_MEDIA_W0_RJ45_10M,
> +	NFP_MEDIA_W0_RJ45_10M_HD,
> +	NFP_MEDIA_W0_RJ45_100M,
> +	NFP_MEDIA_W0_RJ45_100M_HD,
> +	NFP_MEDIA_W0_RJ45_1G,
> +	NFP_MEDIA_W0_RJ45_2P5G,
> +	NFP_MEDIA_W0_RJ45_5G,
> +	NFP_MEDIA_W0_RJ45_10G,
> +	NFP_MEDIA_1000BASE_CX,
> +	NFP_MEDIA_1000BASE_KX,
> +	NFP_MEDIA_10GBASE_KX4,
> +	NFP_MEDIA_10GBASE_KR,
> +	NFP_MEDIA_10GBASE_CX4,
> +	NFP_MEDIA_10GBASE_CR,
> +	NFP_MEDIA_10GBASE_SR,
> +	NFP_MEDIA_10GBASE_ER,
> +	NFP_MEDIA_25GBASE_KR,
> +	NFP_MEDIA_25GBASE_KR_S,
> +	NFP_MEDIA_25GBASE_CR,
> +	NFP_MEDIA_25GBASE_CR_S,
> +	NFP_MEDIA_25GBASE_SR,
> +	NFP_MEDIA_40GBASE_CR4,
> +	NFP_MEDIA_40GBASE_KR4,
> +	NFP_MEDIA_40GBASE_SR4,
> +	NFP_MEDIA_40GBASE_LR4,
> +	NFP_MEDIA_50GBASE_KR,
> +	NFP_MEDIA_50GBASE_SR,
> +	NFP_MEDIA_50GBASE_CR,
> +	NFP_MEDIA_50GBASE_LR,
> +	NFP_MEDIA_50GBASE_ER,
> +	NFP_MEDIA_50GBASE_FR,
> +	NFP_MEDIA_100GBASE_KR4,
> +	NFP_MEDIA_100GBASE_SR4,
> +	NFP_MEDIA_100GBASE_CR4,
> +	NFP_MEDIA_100GBASE_KP4,
> +	NFP_MEDIA_100GBASE_CR10,
> +	NFP_MEDIA_LINK_MODES_NUMBER
> +};
> +
>  #define NFP_FEC_AUTO		BIT(NFP_FEC_AUTO_BIT)
>  #define NFP_FEC_BASER		BIT(NFP_FEC_BASER_BIT)
>  #define NFP_FEC_REED_SOLOMON	BIT(NFP_FEC_REED_SOLOMON_BIT)
> @@ -256,6 +302,19 @@ enum nfp_nsp_sensor_id {
>  int nfp_hwmon_read_sensor(struct nfp_cpp *cpp, enum nfp_nsp_sensor_id id,
>  			  long *val);
>  
> +/* The maximum number of link modes can be added */
> +#define NFP_NSP_MAX_MODE_SIZE	128
> +
> +struct nfp_eth_media_buf {
> +	u8 eth_index;
> +	u8 reserved[7];
> +	DECLARE_BITMAP(supported_modes, NFP_NSP_MAX_MODE_SIZE);
> +	DECLARE_BITMAP(advertised_modes, NFP_NSP_MAX_MODE_SIZE);

Jakub said that already, but yeah, object shared with the hardware
must have explicit fixed size and endianness, bitmaps are pure Linux
API and have nothing of these two.
I think here you'd want to use __le64.

> +};
> +
> +int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size);
> +int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm);
> +
>  #define NFP_NSP_VERSION_BUFSZ	1024 /* reasonable size, not in the ABI */
>  
>  enum nfp_nsp_versions {
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> index bb64efec4c46..0996fefd6cd9 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> @@ -647,3 +647,30 @@ int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes)
>  	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_PORT, NSP_ETH_PORT_LANES,
>  				      lanes, NSP_ETH_CTRL_SET_LANES);
>  }
> +
> +int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
> +{
> +	struct nfp_nsp *nsp;
> +	int err;
> +
> +	nsp = nfp_nsp_open(cpp);
> +	if (IS_ERR(nsp)) {
> +		err = PTR_ERR(nsp);
> +		nfp_err(cpp, "Failed to access the NSP: %d\n", err);
> +		return err;

		nfp_err(cpp, "Failed to access the NSP: -%pe\n, nsp);
		return PTR_ERR(nsp);

%pe prints the name if SYMBOLIC_ERRNAME is enabled, and the error
code in dec otherwise.

> +	}
> +
> +	if (!nfp_nsp_has_read_media(nsp)) {
> +		nfp_warn(cpp, "Reading media link modes not supported. Please update flash\n");
> +		err = -EOPNOTSUPP;
> +		goto exit_close_nsp;
> +	}
> +
> +	err = nfp_nsp_read_media(nsp, ethm, sizeof(*ethm));
> +	if (err)
> +		nfp_err(cpp, "Reading link modes failed %d\n", err);

Same here. Also, you don't have a ':' in between 'failed' and the
code format literal.

> +
> +exit_close_nsp:
> +	nfp_nsp_close(nsp);
> +	return err;
> +}
> -- 
> 2.30.2

Thanks,
Olek
