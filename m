Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16806BDCD0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCPXUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPXU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:20:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B75166F3;
        Thu, 16 Mar 2023 16:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679008825; x=1710544825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O1jHjEbYbpqFiJyhifBYrEpgoyEcjH6v2vhO3Ok8R2Y=;
  b=C9G854jtphGnSITpl72klmkjwRirNu/RJcwJt1deSECclXhBviFWcYFI
   RPTt0k4bWRKHKTAP/WZBi6AUZkHexemnTO0eFU6BCDEtdAlsBss1Bfqcg
   4jlkaTtTGS3hT82Rh6GRLwueYrVhxWGYFXOR7NAeo6EabeLNKHlEyjk5C
   +HYtCq2JnkY8L//Gx/kUjwG9vpJdbKDLViZ1DFtG0MQIzk2fCssMQQJ1Y
   FSqXxCZD1d2c/sH/dv9d+r+pcysAm8PiMK9Praf5i9GTs1JYa3n9yOkMQ
   HqK832zg+RH+lYienWrQW6adFZ5PMS/98uZOVDKwHl0UFsJsKKXfvtX8I
   A==;
X-IronPort-AV: E=Sophos;i="5.98,267,1673938800"; 
   d="scan'208";a="205494179"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 16:20:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 16:20:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 16 Mar 2023 16:20:22 -0700
Date:   Fri, 17 Mar 2023 00:20:22 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
CC:     <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net V2 0/2] net: stmmac: Premature loop termination check
 was ignored
Message-ID: <20230316232022.4xof7vguvpr3brgn@soft-dev3-1>
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/16/2023 08:59, Jochen Henneberg wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> As proposed in [1] here is are the fixes as a patch series that do the
> premature end-of-loop check within the goto loop.
> 
> The commit messages now tell us which rx path has been fixed.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Jochen Henneberg (2):
>   net: stmmac: Premature loop termination check was ignored on rx
>   net: stmmac: Premature loop termination check was ignored on ZC rx
> 
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> [1] https://lore.kernel.org/all/Y%2FdiTAg2iUopr%2FOy@corigine.com
> --
> 2.39.2
> 

-- 
/Horatiu
