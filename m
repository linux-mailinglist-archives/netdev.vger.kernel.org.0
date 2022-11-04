Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B616197E3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiKDNbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDNbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:31:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569221C9;
        Fri,  4 Nov 2022 06:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7tLMpJgWljDAlxmwj9PUYVBNLxVIZhvlNdcukf0xZoM=; b=0nGRgygsAdOuKnuDCTsgZVCxf2
        nbqDLEyiDDF8b8HmGZcc2IFGoZDmoGfL90yq+SalAmQrYjAKR38DEA2XLVC4sVXXdKGFExLO+1iSx
        X1P1sYSm0dSJtBEpnGkpeJc99ne+G6oVmtxOQTNsPhVGhkWo1a51pXX0AjCHNRxNOvWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqwlv-001QWI-71; Fri, 04 Nov 2022 14:30:11 +0100
Date:   Fri, 4 Nov 2022 14:30:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chester Lin <clin@suse.com>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y2UT4yIqk0pV6FHA@lunn.ch>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
 <Y2Q7KtYkvpRz76tn@lunn.ch>
 <Y2T5/w8CvZH5ZlE2@linux-8mug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2T5/w8CvZH5ZlE2@linux-8mug>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here I just focus on GMAC since there are other LAN interfaces that S32 family
> uses [e.g. PFE]. According to the public GMACSUBSYS ref manual rev2[1] provided
> on NXP website, theoretically GMAC can run SGMII in 1000Mbps and 2500Mbps so I
> assume that supporting 1000BASE-X could be achievable. I'm not sure if any S32
> board variant might have SFP ports but RJ-45 [1000BASE-T] should be the major
> type used on S32G-EVB and S32G-RDB2.

SGMII at 2500Mbps does not exist. Lots of people get this wrong. It
will be 2500Base-X.

Does the clock need to change in order to support 2500Base-X? If i
understand you correctly, Linux does not control the clocks, and so
cannot change the clocks? So that probably means you cannot actually
support 2500Base-X? Once you have Linux actually controlling the
hardware, you can then make use of an SFP or a copper PHY which
supports 2.5G. The PHY will swap its host side between SGMII and
2500Base-X depending on what the line side negotiates, 1000Base-T or
2500Base-T. The MAC driver then needs to change its configuration to
suite.

	Andrew
