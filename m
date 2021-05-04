Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34093372E71
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhEDRGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 13:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhEDRGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 13:06:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52424C061574;
        Tue,  4 May 2021 10:05:30 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AEC572224F;
        Tue,  4 May 2021 19:05:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620147925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P86yv15f5mdm2USC11n29XyVm3m0pHGOL8lHax5UfAo=;
        b=Fi1Uy/OfiVn/WtcWORzbuNlvppU4ai3v/qDfJlNJBckhlDecjfVcfpyJc3sj2SXidmVhPj
        ht8G4bRsQVTp3YSO2PgHA0w58vhaJwua9fvjmT9lSu4mpO8xu2X8rJJuC8k3Hy2ry6jPzm
        meV87A6vQxvBIpjazxkqzSpP6hzjS6k=
From:   Michael Walle <michael@walle.cc>
To:     xiaoliang.yang_1@nxp.com
Cc:     Arvid.Brodin@xdin.com, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        andre.guedes@linux.intel.com, claudiu.manoil@nxp.com,
        colin.king@canonical.com, davem@davemloft.net, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        joergen.andreasen@microchip.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        michael.chan@broadcom.com, mingkai.hu@nxp.com,
        netdev@vger.kernel.org, po.liu@nxp.com, saeedm@mellanox.com,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        yuehaibing@huawei.com, michael@walle.cc,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS config
Date:   Tue,  4 May 2021 19:05:14 +0200
Message-Id: <20210504170514.10729-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
> this:
> 	0: Guard band is implemented for nonschedule queues to schedule
> 	   queues transition.
> 	1: Guard band is implemented for any queue to schedule queue
> 	   transition.
> 
> The driver set guard band be implemented for any queue to schedule queue
> transition before, which will make each GCL time slot reserve a guard
> band time that can pass the max SDU frame. Because guard band time could
> not be set in tc-taprio now, it will use about 12000ns to pass 1500B max
> SDU. This limits each GCL time interval to be more than 12000ns.
> 
> This patch change the guard band to be only implemented for nonschedule
> queues to schedule queues transition, so that there is no need to reserve
> guard band on each GCL. Users can manually add guard band time for each
> schedule queues in their configuration if they want.


As explained in another mail in this thread, all queues are marked as
scheduled. So this is actually a no-op, correct? It doesn't matter if
it set or not set for now. Dunno why we even care for this bit then.

> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 789fe08cae50..2473bebe48e6 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1227,8 +1227,12 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>  	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
>  		return -ERANGE;
>  
> -	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
> -		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
> +	/* Set port num and disable ALWAYS_GUARD_BAND_SCH_Q, which means set
> +	 * guard band to be implemented for nonschedule queues to schedule
> +	 * queues transition.
> +	 */
> +	ocelot_rmw(ocelot,
> +		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
>  		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
>  		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
>  		   QSYS_TAS_PARAM_CFG_CTRL);

Anyway, I don't think this the correct place for this:
 (1) it isn't per port, but a global bit, but here its done per port.
 (2) rmw, I presume is read-modify-write. and there is one bit CONFIG_CHAGE
     which is set by software and cleared by hardware. What happens if it
	 will be cleared right after we read it. Then it will be set again, no?

So if we really care about this bit, shouldn't this be moved to switch
initialization then?

-michael
