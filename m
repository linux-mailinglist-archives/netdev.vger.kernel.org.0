Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5449354E208
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376550AbiFPNeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiFPNef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:34:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C221FCDB;
        Thu, 16 Jun 2022 06:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uQ4d+/hCDpXIIuZA6ifN1eXUKkJ4wcl+niFQzW1KPWg=; b=1DqtUF+rjV/XZiC/scS+elV2ov
        JhbCgVmhK8D7fZlYN0fobs4BcsSYsHPad6IxRsc/+LoQfWpZs8o18AK8CZgdQBqRgmQN18NXa6lkD
        nRProzG3HaUzlPlGAZgT9pjJHJKO5UV3jBY8V/GEy23EUNNiKfxjDGNsCwR/gbQIs8Qc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1pda-007Bvi-6c; Thu, 16 Jun 2022 15:34:18 +0200
Date:   Thu, 16 Jun 2022 15:34:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: ar9331: fix potential dead
 lock on mdio access
Message-ID: <YqsxWv79Ge1AFiQx@lunn.ch>
References: <20220616112550.877118-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616112550.877118-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> @@ -849,6 +849,8 @@ static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
>  		return 0;
>  	}
>  
> +	mutex_lock_nested(&sbus->mdio_lock, MDIO_MUTEX_NESTED);
> +

Do you know about mdiobus_read_nested() and
mdiobus_write_nested(). The mv88e6xxx driver uses these.

	Andrew
