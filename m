Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF61CEA30
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgELBlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:41:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:9229 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgELBlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 21:41:51 -0400
IronPort-SDR: exlohjUI850FVKrEPwdfA9SVXRUXE/iIcjK6epf52DKSSyvsiQ3lSowllvIdR1m/2Ya/eDOkGL
 RlVpMKP49jdg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 18:41:51 -0700
IronPort-SDR: wnh2eKpbeDdDj9ggrOoM0lv7opNBNP7149lSboourFsKOItRoVF61HxP51QwoBbiI+wsxPro+z
 tyl2wAZaleog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="463593457"
Received: from schittir-mobl.amr.corp.intel.com (HELO ellie) ([10.212.37.169])
  by fmsmga006.fm.intel.com with ESMTP; 11 May 2020 18:41:49 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        linux-devel@linux.nxdi.nxp.com
Subject: Re: [PATCH v1 net-next 3/3] net: dsa: felix: add support Credit Based Shaper(CBS) for hardware offload
In-Reply-To: <20200511054332.37690-4-xiaoliang.yang_1@nxp.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com> <20200511054332.37690-4-xiaoliang.yang_1@nxp.com>
Date:   Mon, 11 May 2020 18:41:49 -0700
Message-ID: <873686rkte.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaoliang Yang <xiaoliang.yang_1@nxp.com> writes:

> VSC9959 hardware support the Credit Based Shaper(CBS) which part
> of the IEEE-802.1Qav. This patch support sch_cbs set for VSC9959.
>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 52 +++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index ccbd875c7a47..d8d1657ee8ba 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -208,7 +208,7 @@ static const u32 vsc9959_qsys_regmap[] = {
>  	REG(QSYS_QMAXSDU_CFG_6,			0x00f62c),
>  	REG(QSYS_QMAXSDU_CFG_7,			0x00f648),
>  	REG(QSYS_PREEMPTION_CFG,		0x00f664),
> -	REG_RESERVED(QSYS_CIR_CFG),
> +	REG(QSYS_CIR_CFG,			0x000000),
>  	REG(QSYS_EIR_CFG,			0x000004),
>  	REG(QSYS_SE_CFG,			0x000008),
>  	REG(QSYS_SE_DWRR_CFG,			0x00000c),
> @@ -1354,6 +1354,54 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>  	return ret;
>  }
>  
> +int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
> +			     struct tc_cbs_qopt_offload *cbs_qopt)
> +{
> +	struct ocelot *ocelot = ds->priv;
> +	int port_ix = port * 8 + cbs_qopt->queue;
> +	u32 cbs = 0;
> +	u32 cir = 0;
> +
> +	if (cbs_qopt->queue >= ds->num_tx_queues)
> +		return -EINVAL;
> +
> +	if (!cbs_qopt->enable) {
> +		ocelot_write_gix(ocelot, QSYS_CIR_CFG_CIR_RATE(0) |
> +				 QSYS_CIR_CFG_CIR_BURST(0),
> +				 QSYS_CIR_CFG, port_ix);
> +
> +		ocelot_rmw_gix(ocelot, 0, QSYS_SE_CFG_SE_AVB_ENA,
> +			       QSYS_SE_CFG, port_ix);
> +
> +		return 0;
> +	}
> +
> +	/* Rate unit is 100 kbps */
> +	cir = DIV_ROUND_UP(cbs_qopt->idleslope, 100);
> +	cir = (cir ? cir : 1);
> +	cir = min_t(u32, GENMASK(14, 0), cir);

Please rename 'cir' to "rate" or "idleslope".

Also consider using clamp_t here and below (I just found out about it).

> +	/* Burst unit is 4kB */
> +	cbs = DIV_ROUND_UP(cbs_qopt->hicredit, 4096);
> +	/* Avoid using zero burst size */
> +	cbs = (cbs ? cbs : 1);
> +	cbs = min_t(u32, GENMASK(5, 0), cbs);

And please(!) rename 'cbs' to "burst" or "hicredit". Re-using the name
"cbs" with a completely different meaning here is confusing.

> +	ocelot_write_gix(ocelot,
> +			 QSYS_CIR_CFG_CIR_RATE(cir) |
> +			 QSYS_CIR_CFG_CIR_BURST(cbs),
> +			 QSYS_CIR_CFG,
> +			 port_ix);
> +
> +	ocelot_rmw_gix(ocelot,
> +		       QSYS_SE_CFG_SE_FRM_MODE(0) |
> +		       QSYS_SE_CFG_SE_AVB_ENA,
> +		       QSYS_SE_CFG_SE_AVB_ENA |
> +		       QSYS_SE_CFG_SE_FRM_MODE_M,
> +		       QSYS_SE_CFG,
> +		       port_ix);
> +
> +	return 0;
> +}
> +
>  static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
>  				 enum tc_setup_type type,
>  				 void *type_data)
> @@ -1363,6 +1411,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
>  	switch (type) {
>  	case TC_SETUP_QDISC_TAPRIO:
>  		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
> +	case TC_SETUP_QDISC_CBS:
> +		return vsc9959_qos_port_cbs_set(ds, port, type_data);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 2.17.1
>

-- 
Vinicius
