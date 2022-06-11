Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE77954763B
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238865AbiFKPus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 11:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiFKPur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 11:50:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F7D2E8;
        Sat, 11 Jun 2022 08:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xv1QWDfN+pMOMjcRPK9HZ6apjXb/JqFW9eOeMHDl0ko=; b=6Z7MqSXb+AeT9JnALtIjBFGwGO
        bEvIKhH2/5lWYoQ8bP+A4FMPGwo5Y2l0aPuqWPZrapsf2OYKQPRhmy5CmYu61dzoMrRLAsrXgM/oM
        VeCnEeXlzXQYy4ihgqi+isJzGIWPPZ6mRyvESECh2JwYDBpUd4S9f8BIT0jrlJNvmO4Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o03Nj-006War-69; Sat, 11 Jun 2022 17:50:35 +0200
Date:   Sat, 11 Jun 2022 17:50:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <YqS5yxrRX4Y4LTWd@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608093403.3999446-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1840,6 +1840,46 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>  #define MASTER_SLAVE_STATE_SLAVE		3
>  #define MASTER_SLAVE_STATE_ERR			4
>  
> +#define REMOTE_FAULT_CFG_UNSUPPORTED		0
> +#define REMOTE_FAULT_CFG_UNKNOWN		1
> +#define REMOTE_FAULT_CFG_NO_ERROR		2
> +/* IEEE 802.3-2018 28.2.1.2.4 Fault without additional information */
> +#define REMOTE_FAULT_CFG_ERROR			3
> +/* IEEE 802.3-2018 28C.5 Message code 4: 0 - RF Test */
> +#define REMOTE_FAULT_CFG_TEST			4
> +/* IEEE 802.3-2018 28C.5 Message code 4: 1 - Link Loss */
> +#define REMOTE_FAULT_CFG_LINK_LOSS		5
> +/* IEEE 802.3-2018 28C.5 Message code 4: 2 - Jabber */
> +#define REMOTE_FAULT_CFG_JABBER			6
> +/* IEEE 802.3-2018 28C.5 Message code 4: 3 - Parallel Detection Fault */
> +#define REMOTE_FAULT_CFG_PDF			7
> +/* IEEE 802.3-2018 37.2.1.5.2 Offline */
> +#define REMOTE_FAULT_CFG_OFFLINE		8
> +/* IEEE 802.3-2018 37.2.1.5.3 Link_Failure */
> +#define REMOTE_FAULT_CFG_LINK_FAIL		9
> +/* IEEE 802.3-2018 37.2.1.5.4 Auto-Negotiation_Error */
> +#define REMOTE_FAULT_CFG_AN_ERROR		10
> +
> +#define REMOTE_FAULT_STATE_UNSUPPORTED		0
> +#define REMOTE_FAULT_STATE_UNKNOWN		1
> +#define REMOTE_FAULT_STATE_NO_ERROR		2
> +/* IEEE 802.3-2018 28.2.1.2.4 Fault without additional information */
> +#define REMOTE_FAULT_STATE_ERROR		3
> +/* IEEE 802.3-2018 28C.5 Message code 4: 0 - RF Test */
> +#define REMOTE_FAULT_STATE_TEST			4
> +/* IEEE 802.3-2018 28C.5 Message code 4: 1 - Link Loss */
> +#define REMOTE_FAULT_STATE_LINK_LOSS		5
> +/* IEEE 802.3-2018 28C.5 Message code 4: 2 - Jabber */
> +#define REMOTE_FAULT_STATE_JABBER		6
> +/* IEEE 802.3-2018 28C.5 Message code 4: 3 - Parallel Detection Fault */
> +#define REMOTE_FAULT_STATE_PDF			7
> +/* IEEE 802.3-2018 37.2.1.5.2 Offline */
> +#define REMOTE_FAULT_STATE_OFFLINE		8
> +/* IEEE 802.3-2018 37.2.1.5.3 Link_Failure */
> +#define REMOTE_FAULT_STATE_LINK_FAIL		9
> +/* IEEE 802.3-2018 37.2.1.5.4 Auto-Negotiation_Error */
> +#define REMOTE_FAULT_STATE_AN_ERROR		10

I'm not sure there is any value in having these values twice. They are
expected to be identical, so one set should be enough.

	 Andrew
