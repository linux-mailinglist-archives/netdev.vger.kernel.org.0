Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF69609B6C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 09:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJXHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 03:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJXHfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 03:35:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B58356CC
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 00:35:29 -0700 (PDT)
Received: from ginster.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::45])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <jbe@pengutronix.de>)
        id 1omrzb-0004dS-BE; Mon, 24 Oct 2022 09:35:27 +0200
Message-ID: <247811d0b88b5f57de0bd1496940b89adeb140de.camel@pengutronix.de>
Subject: Re: [PATCH] net: fec: limit register access on i.MX6UL
From:   Juergen Borleis <jbe@pengutronix.de>
Reply-To: jbe@pengutronix.de
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date:   Mon, 24 Oct 2022 09:35:26 +0200
In-Reply-To: <20220920115624.zgycbbzijudr7muc@pengutronix.de>
References: <20220920095106.66924-1-jbe@pengutronix.de>
         <20220920115624.zgycbbzijudr7muc@pengutronix.de>
Organization: Pengutronix e.K.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::45
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Am Dienstag, dem 20.09.2022 um 13:56 +0200 wrote Marc Kleine-Budde:
> On 20.09.2022 11:51:06, Juergen Borleis wrote:
> > Using 'ethtool -d […]' on an i.MX6UL leads to a kernel crash:
> > 
> >    Unhandled fault: external abort on non-linefetch (0x1008) at […]
> > 
> > due to this SoC has less registers in its FEC implementation compared to
> > other i.MX6 variants. Thus, a run-time decision is required to avoid access
> > to non-existing registers.
> > 
> > Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 50 +++++++++++++++++++++--
> >  1 file changed, 47 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index 6152f6d..ab620b4 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -2382,6 +2382,31 @@ static u32 fec_enet_register_offset[] = {
> >         IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN,
> > IEEE_R_MACERR,
> >         IEEE_R_FDXFC, IEEE_R_OCTETS_OK
> >  };
> > +/* for i.MX6ul */
> > +static u32 fec_enet_register_offset_6ul[] = {
> > +       FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
> > +       FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT,
> > FEC_R_CNTRL,
> > +       FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0,
> > FEC_RXIC0,
> > +       FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
> > +       FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
> > +       FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL,
> > FEC_R_FIFO_RSEM,
> > +       FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
> > +       RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
> > +       RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
> > +       RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127,
> > RMON_T_P128TO255,
> > +       RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
> > +       RMON_T_P_GTE2048, RMON_T_OCTETS,
> > +       IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
> > +       IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
> > +       IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
> > +       RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
> > +       RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
> > +       RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
> > +       RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
> > +       RMON_R_P_GTE2048, RMON_R_OCTETS,
> > +       IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN,
> > IEEE_R_MACERR,
> > +       IEEE_R_FDXFC, IEEE_R_OCTETS_OK
> > +};
> >  #else
> >  static __u32 fec_enet_register_version = 1;
> >  static u32 fec_enet_register_offset[] = {
> > @@ -2406,7 +2431,26 @@ static void fec_enet_get_regs(struct net_device
> > *ndev,
> >         u32 *buf = (u32 *)regbuf;
> >         u32 i, off;
> >         int ret;
> > -
> > +#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x)
> > || \
> > +       defined(CONFIG_M520x) || defined(CONFIG_M532x) ||
> > defined(CONFIG_ARM) || \
> > +       defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
> > +       struct platform_device_id *dev_info =
> > +                       (struct platform_device_id *)fep->pdev->id_entry;
> > +       u32 *reg_list;
> > +       u32 reg_cnt;
> > +
> > +       if (strcmp(dev_info->name, "imx6ul-fec")) {
> > +               reg_list = fec_enet_register_offset;
> > +               reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
> > +       } else {
> > +               reg_list = fec_enet_register_offset_6ul;
> > +               reg_cnt = ARRAY_SIZE(fec_enet_register_offset_6ul);
> > +       }
> 
> What about using of_machine_is_compatible()?

Good point. Thought this call requires an oftree handle. Will change it in v2.

> > +#else
> > +       /* coldfire */
> > +       static u32 *reg_list = fec_enet_register_offset;
> > +       static const u32 reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
> > +#endif
> 
> Why do you need the ifdef?

The coldfire variant of this part is already implemented in this way.

> […]

jb

-- 
Pengutronix e.K.                       | Juergen Borleis             |
Steuerwalder Str. 21                   | https://www.pengutronix.de/ |
31137 Hildesheim, Germany              | Phone: +49-5121-206917-128  |
Amtsgericht Hildesheim, HRA 2686       | Fax:   +49-5121-206917-9    |


