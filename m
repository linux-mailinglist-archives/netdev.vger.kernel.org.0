Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FA9669393
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240146AbjAMJ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbjAMJ6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:58:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E46C4319B;
        Fri, 13 Jan 2023 01:57:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8718E6113B;
        Fri, 13 Jan 2023 09:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BE4C433D2;
        Fri, 13 Jan 2023 09:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673603826;
        bh=Rij9CaLtG5FejKkokKtvp8JNxLZCbr2DOWTlruGoa4I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=L42orzL/gd3jU3WEYnaafjzr/VCAD0CVJQ50G1+De4mvtehyiuRufBHgJzZiHZ+vw
         qC33PzELQkHM1eFN9GKyGjnbYgwxk8gSvEsU4JkL8d7bv6VaPCCO/1SnkAhOmP1fUW
         XF+LmN9Ta/Q7BRw03tQWAIFvha2+Cc9LWOrz5NZNYMc8NCj0ZwcKIPfznuro1zYOyB
         PRNKArYvNlVg+PWPnJQ/uWKykRsby2/ugmPCr+BAeCO1i0XrqZsRwYhBlFw/Pj09FK
         yNY8notb0S16MRY6eO006glp+6ajbyvfL8eFraXGFkRBeZXxecTaBgTDto2VCKUmER
         O5OO/cpQ4OJoQ==
Message-ID: <6e691ad5-a919-75d8-ff65-c11820b253ee@kernel.org>
Date:   Fri, 13 Jan 2023 11:57:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 2/5] net: ethernet: ti: am65-cpts: add pps
 support
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, nm@ti.com, kristo@kernel.org,
        vigneshr@ti.com, nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-3-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230111114429.1297557-3-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/01/2023 13:44, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> CPTS doesn't have HW support for PPS ("pulse per second”) signal
> generation, but it can be modeled by using Time Sync Router and routing
> GenFx (periodic signal generator) output to CPTS_HWy_TS_PUSH (hardware time
> stamp) input, and configuring GenFx to generate 1sec pulses.
> 
>      +------------------------+
>      |          CPTS          |
>      |                        |
>  +--->CPTS_HW4_PUSH      GENFx+---+
>  |   |                        |   |
>  |   +------------------------+   |
>  |                                |
>  +--------------------------------+
> 
> Add corresponding support to am65-cpts driver. The DT property "ti,pps"
> has to be used to enable PPS support and configure pair
> [CPTS_HWy_TS_PUSH, GenFx].
> 
> Once enabled, PPS can be tested using ppstest tool:
>  # ./ppstest /dev/pps0
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpts.c | 85 +++++++++++++++++++++++++++--
>  1 file changed, 80 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> index 9535396b28cd..6a0f09b497d1 100644
> --- a/drivers/net/ethernet/ti/am65-cpts.c
> +++ b/drivers/net/ethernet/ti/am65-cpts.c
> @@ -176,6 +176,10 @@ struct am65_cpts {
>  	u32 genf_enable;
>  	u32 hw_ts_enable;
>  	struct sk_buff_head txq;
> +	bool pps_enabled;
> +	bool pps_present;
> +	u32 pps_hw_ts_idx;
> +	u32 pps_genf_idx;
>  	/* context save/restore */
>  	u64 sr_cpts_ns;
>  	u64 sr_ktime_ns;
> @@ -319,8 +323,15 @@ static int am65_cpts_fifo_read(struct am65_cpts *cpts)
>  		case AM65_CPTS_EV_HW:
>  			pevent.index = am65_cpts_event_get_port(event) - 1;
>  			pevent.timestamp = event->timestamp;
> -			pevent.type = PTP_CLOCK_EXTTS;
> -			dev_dbg(cpts->dev, "AM65_CPTS_EV_HW p:%d t:%llu\n",
> +			if (cpts->pps_enabled && pevent.index == cpts->pps_hw_ts_idx) {
> +				pevent.type = PTP_CLOCK_PPSUSR;
> +				pevent.pps_times.ts_real = ns_to_timespec64(pevent.timestamp);
> +			} else {
> +				pevent.type = PTP_CLOCK_EXTTS;
> +			}
> +			dev_dbg(cpts->dev, "AM65_CPTS_EV_HW:%s p:%d t:%llu\n",
> +				pevent.type == PTP_CLOCK_EXTTS ?
> +				"extts" : "pps",
>  				pevent.index, event->timestamp);
>  
>  			ptp_clock_event(cpts->ptp_clock, &pevent);
> @@ -507,7 +518,13 @@ static void am65_cpts_extts_enable_hw(struct am65_cpts *cpts, u32 index, int on)
>  
>  static int am65_cpts_extts_enable(struct am65_cpts *cpts, u32 index, int on)
>  {
> -	if (!!(cpts->hw_ts_enable & BIT(index)) == !!on)
> +	if (index >= cpts->ptp_info.n_ext_ts)
> +		return -ENXIO;
> +
> +	if (cpts->pps_present && index == cpts->pps_hw_ts_idx)
> +		return -EINVAL;
> +
> +	if (((cpts->hw_ts_enable & BIT(index)) >> index) == on)
>  		return 0;
>  
>  	mutex_lock(&cpts->ptp_clk_lock);
> @@ -591,6 +608,12 @@ static void am65_cpts_perout_enable_hw(struct am65_cpts *cpts,
>  static int am65_cpts_perout_enable(struct am65_cpts *cpts,
>  				   struct ptp_perout_request *req, int on)
>  {
> +	if (req->index >= cpts->ptp_info.n_per_out)
> +		return -ENXIO;
> +
> +	if (cpts->pps_present && req->index == cpts->pps_genf_idx)
> +		return -EINVAL;
> +
>  	if (!!(cpts->genf_enable & BIT(req->index)) == !!on)
>  		return 0;
>  
> @@ -604,6 +627,48 @@ static int am65_cpts_perout_enable(struct am65_cpts *cpts,
>  	return 0;
>  }
>  
> +static int am65_cpts_pps_enable(struct am65_cpts *cpts, int on)
> +{
> +	int ret = 0;
> +	struct timespec64 ts;
> +	struct ptp_clock_request rq;
> +	u64 ns;
> +
> +	if (!cpts->pps_present)
> +		return -EINVAL;
> +
> +	if (cpts->pps_enabled == !!on)
> +		return 0;
> +
> +	mutex_lock(&cpts->ptp_clk_lock);
> +
> +	if (on) {
> +		am65_cpts_extts_enable_hw(cpts, cpts->pps_hw_ts_idx, on);
> +
> +		ns = am65_cpts_gettime(cpts, NULL);
> +		ts = ns_to_timespec64(ns);
> +		rq.perout.period.sec = 1;
> +		rq.perout.period.nsec = 0;
> +		rq.perout.start.sec = ts.tv_sec + 2;
> +		rq.perout.start.nsec = 0;
> +		rq.perout.index = cpts->pps_genf_idx;
> +
> +		am65_cpts_perout_enable_hw(cpts, &rq.perout, on);
> +		cpts->pps_enabled = true;
> +	} else {
> +		rq.perout.index = cpts->pps_genf_idx;
> +		am65_cpts_perout_enable_hw(cpts, &rq.perout, on);
> +		am65_cpts_extts_enable_hw(cpts, cpts->pps_hw_ts_idx, on);
> +		cpts->pps_enabled = false;
> +	}
> +
> +	mutex_unlock(&cpts->ptp_clk_lock);
> +
> +	dev_dbg(cpts->dev, "%s: pps: %s\n",
> +		__func__, on ? "enabled" : "disabled");
> +	return ret;
> +}
> +
>  static int am65_cpts_ptp_enable(struct ptp_clock_info *ptp,
>  				struct ptp_clock_request *rq, int on)
>  {
> @@ -614,6 +679,8 @@ static int am65_cpts_ptp_enable(struct ptp_clock_info *ptp,
>  		return am65_cpts_extts_enable(cpts, rq->extts.index, on);
>  	case PTP_CLK_REQ_PEROUT:
>  		return am65_cpts_perout_enable(cpts, &rq->perout, on);
> +	case PTP_CLK_REQ_PPS:
> +		return am65_cpts_pps_enable(cpts, on);
>  	default:
>  		break;
>  	}
> @@ -926,6 +993,12 @@ static int am65_cpts_of_parse(struct am65_cpts *cpts, struct device_node *node)
>  	if (!of_property_read_u32(node, "ti,cpts-periodic-outputs", &prop[0]))
>  		cpts->genf_num = prop[0];
>  
> +	if (!of_property_read_u32_array(node, "ti,pps", prop, 2)) {
> +		cpts->pps_present = true;
> +		cpts->pps_hw_ts_idx = prop[0];
> +		cpts->pps_genf_idx = prop[1];

What happens if DT provides an invalid value. e.g. out of range?
Better to do a sanity check?

> +	}
> +
>  	return cpts_of_mux_clk_setup(cpts, node);
>  }
>  
> @@ -993,6 +1066,8 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>  		cpts->ptp_info.n_ext_ts = cpts->ext_ts_inputs;
>  	if (cpts->genf_num)
>  		cpts->ptp_info.n_per_out = cpts->genf_num;
> +	if (cpts->pps_present)
> +		cpts->ptp_info.pps = 1;
>  
>  	am65_cpts_set_add_val(cpts);
>  
> @@ -1028,9 +1103,9 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>  		return ERR_PTR(ret);
>  	}
>  
> -	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u\n",
> +	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u pps:%d\n",
>  		 am65_cpts_read32(cpts, idver),
> -		 cpts->refclk_freq, cpts->ts_add_val);
> +		 cpts->refclk_freq, cpts->ts_add_val, cpts->pps_present);
>  
>  	return cpts;
>  

cheers,
-roger
