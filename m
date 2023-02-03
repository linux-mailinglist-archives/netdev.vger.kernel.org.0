Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25569689395
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjBCJY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjBCJYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:24:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B182ED4F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675416246; x=1706952246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R6be8kkuBuebrbZ+PO2iLe4MmaLTEcPZVo005GkRjn8=;
  b=ObeUOREF8cNS09ZLchfdf+tYsDN/bUhBaH6uZHo5yCyKzrh5N+nw6nhu
   rtC0tYxdxIRwT9saTFP7VN3HiQLAMLnuLWukviU922g6NQ3gevl2vEg8N
   2bneCHFR2GXGL0/k97Zdm10LDcMRrBtAkATWfBihUdvnURp8YNYBmz1cx
   pGGyM0M8tnxATwSkTLWP6YKQFIpwUWbOBs6Q+eghR1xsR0BSy+g8PIu1x
   ++vECrXc8JtWKeGA6Vl5rGIYCE6+YeYDBxQuj2ZA4mJSOpVvYRG1+MZzp
   FRKGNw+MjagCQz+xoDdEJATB/nl4uBli+aTi639gIOLTpBU2BQGNDzGuT
   A==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="199194411"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 02:24:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 02:24:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 3 Feb 2023 02:24:05 -0700
Date:   Fri, 3 Feb 2023 10:24:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        "Richard Cochran" <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: microchip: sparx5: fix PTP init/deinit not
 checking all ports
Message-ID: <20230203092404.rc7bzrlbnmkjtf4f@soft-dev3-1>
References: <20230203085557.3785002-1-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230203085557.3785002-1-casper.casan@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/03/2023 09:55, Casper Andersson wrote:

> 
> Check all ports instead of just port_count ports. PTP init was only
> checking ports 0 to port_count. If the hardware ports are not mapped
> starting from 0 then they would be missed, e.g. if only ports 20-30 were
> mapped it would attempt to init ports 0-10, resulting in NULL pointers
> when attempting to timestamp. Now it will init all mapped ports.
> 
> Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
> index 0ed1ea7727c5..69e76634f9aa 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
> @@ -633,7 +633,7 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
>         /* Enable master counters */
>         spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
> 
> -       for (i = 0; i < sparx5->port_count; i++) {
> +       for (i = 0; i < SPX5_PORTS; i++) {
>                 port = sparx5->ports[i];
>                 if (!port)
>                         continue;
> @@ -649,7 +649,7 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
>         struct sparx5_port *port;
>         int i;
> 
> -       for (i = 0; i < sparx5->port_count; i++) {
> +       for (i = 0; i < SPX5_PORTS; i++) {
>                 port = sparx5->ports[i];
>                 if (!port)
>                         continue;
> --
> 2.34.1
> 

-- 
/Horatiu
