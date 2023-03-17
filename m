Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E546BF200
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCQT4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCQT4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:56:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EC14FCE9;
        Fri, 17 Mar 2023 12:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=74k5DN7kiNpGtzYo2gVAOXmh2+XLFDPJgHM3F+r4x80=; b=fJXG9etkudSRDjLe0RRwBxpy9M
        W0mNmhumhj+MCXdZ1tlax570U7yQWGOJxlv8QeTMdAVOFosQVKf3zX++4ck9l0U101ytWKwLKUigM
        ZKA9S41w3HBbnyov6CUirotKEbJjlAOeT8QBaQ6PnouH98bVW8Kh9ZwV70mfnk5Rc9bo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdGBX-007eCG-St; Fri, 17 Mar 2023 20:56:19 +0100
Date:   Fri, 17 Mar 2023 20:56:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Message-ID: <10aff941-e18a-4d77-974b-1760529988a6@lunn.ch>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:02:07PM +0800, Michael Sit Wei Hong wrote:
> phylink_fwnode_phy_connect returns 0 when set to MLO_AN_INBAND.
> This causes the PHY handle parsing to skip and the PHY will not be attached
> to the MAC.

Please could you expand the commit message because i'm having trouble
following this.

phylink_fwnode_phy_connect() says:

	/* Fixed links and 802.3z are handled without needing a PHY */
	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
	     phy_interface_mode_is_8023z(pl->link_interface)))
		return 0;

So your first statement is not true. It should be MLO_AN_INBAND
and phy_interface_mode_is_8023z.

> Add additional check for PHY handle parsing when set to MLO_AN_INBAND.

Looking at the patch, there is no reference to MLO_AN_INBAND, or
managed = "in-band-status";

	Andrew
