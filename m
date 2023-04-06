Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0F6D9070
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbjDFH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjDFH3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:29:13 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C5B76BD;
        Thu,  6 Apr 2023 00:29:10 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 50A0E1C000B;
        Thu,  6 Apr 2023 07:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680766149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3N0MhR4UYPZqjjIJvCfac3PeMhUE3Q3jLEyIQ0jdrco=;
        b=EUYCN/AWFMTjvujuAKiAKwj/VmBeL/nIoOV0dvYnKt3iBE5JMxuOOT9akAY2HcqPJ3z0nu
        SlJloGIh0syhJSYVb2Fp1+2jd2/wzh+8PrUC+dx2A9o9oFsPMjpQHvYRsQDQqsOOK5obTi
        v5jH2wATkipLFNTyV0flAZn/6r0H/Jy5BkCWm8oWoGT4LG/hzEGaI60x8y7tQJNxmNG+mA
        u/S5tDyZowoNjr1UFuJOkXN1V/jQdph98yrrrcbink3ugR9u6t2x17UZBnqnWk8xLX3M5k
        d58+/CRAgk4AixYwBOOYVPy7WcyqZ0C9oODAhH78rg+Ua7ObCuZNso1kpo6EWA==
Date:   Thu, 6 Apr 2023 09:29:06 +0200
From:   Herve Codina <herve.codina@bootlin.com>
To:     Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <20230406092906.658889a2@bootlin.com>
In-Reply-To: <20230323103154.264546-1-herve.codina@bootlin.com>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I haven't received any feedback on this RFC.
Have you had a chance to review it ?

Best regards,
Hervé

On Thu, 23 Mar 2023 11:31:50 +0100
Herve Codina <herve.codina@bootlin.com> wrote:

> Hi,
> 
> I have a system where I need to handle an HDLC interface.
> 
> The HDLC data are transferred using a TDM bus on which a PEF2256 is
> present. The PEF2256 transfers data from/to the TDM bus to/from E1 line.
> This PEF2256 is also connected to a PowerQUICC SoC for the control path
> and the TDM is connected to the SoC (QMC component) for the data path.
> 
> From the HDLC driver, I need to handle data using the QMC and carrier
> detection using the PEF2256 (E1 line carrier).
> 
> The HDLC driver consider the PEF2256 as a generic PHY.
> So, the design is the following:
> 
> +----------+          +-------------+              +---------+
> | HDLC drv | <-data-> | QMC channel | <-- TDM -->  | PEF2256 |
> +----------+          +-------------+              |         | <--> E1
>    ^   +---------+     +---------+                 |         |
>    +-> | Gen PHY | <-> | PEF2256 | <- local bus -> |         |
>        +---------+     | PHY drv |                 +---------+
>                        +---------+
> 
> In order to implement this, I had to:
>  1 - Extend the generic PHY API to support get_status() and notification
>      on status change.
>  2 - Introduce a new kind of generic PHY named "basic phy". This PHY
>      familly can provide a link status in the get_status() data.
>  3 - Support the PEF2256 PHY as a "basic phy"
> 
> The purpose of this RFC series is to discuss this design.
> 
> The QMC driver code is available on linux-next. In this series:
> - patch 1: driver HDLC using the QMC channel
> - patch 2: Extend the generic PHY API
> - patch 3: Use the "basic phy" in the HDLC driver
> - patch 4: Implement the PEF2256 PHY driver
> 
> I did 2 patches for the HDLC driver in order to point the new PHY family
> usage in the HDLC driver. In the end, these two patches will be squashed
> and the bindings will be added.
> 
> Hope to have some feedback on this proposal.
> 
> Best regards,
> Hervé
> 
> Herve Codina (4):
>   net: wan: Add support for QMC HDLC
>   phy: Extend API to support 'status' get and notification
>   net: wan: fsl_qmc_hdlc: Add PHY support
>   phy: lantiq: Add PEF2256 PHY support
> 
>  drivers/net/wan/Kconfig                 |  12 +
>  drivers/net/wan/Makefile                |   1 +
>  drivers/net/wan/fsl_qmc_hdlc.c          | 558 ++++++++++++++++++++++++
>  drivers/phy/lantiq/Kconfig              |  15 +
>  drivers/phy/lantiq/Makefile             |   1 +
>  drivers/phy/lantiq/phy-lantiq-pef2256.c | 131 ++++++
>  drivers/phy/phy-core.c                  |  88 ++++
>  include/linux/phy/phy-basic.h           |  27 ++
>  include/linux/phy/phy.h                 |  89 +++-
>  9 files changed, 921 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/wan/fsl_qmc_hdlc.c
>  create mode 100644 drivers/phy/lantiq/phy-lantiq-pef2256.c
>  create mode 100644 include/linux/phy/phy-basic.h
> 

