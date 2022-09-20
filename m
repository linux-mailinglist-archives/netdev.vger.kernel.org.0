Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6E5BEA37
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiITP3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiITP3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:29:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25666659E0;
        Tue, 20 Sep 2022 08:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0436B81ECF;
        Tue, 20 Sep 2022 15:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E147AC433D6;
        Tue, 20 Sep 2022 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663687747;
        bh=EM3orcx2Wj0lL09JWhL9sde4Ts6h1qfL3iPsu2Wmki0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CRxQXPDhhrEVo8haSR8Db4/xVqdwGTMuFnjQEYu5j0+LMZ76OfmBn7POLPzPgr8GW
         iOTCriuD0kLFtgQryhgaRkPZDo8mAM8eQhMZIE3vIJaZvSvnNUD5/WmWt8eW2EARL3
         hx/mTPS+62Uo0ztvioI31LiT+yGdvyfb+3LhCNOBEpX3gZbVTeuhDKPvQ3wkJyn6EZ
         Pe9MW9GanAkrOS6t3p0zYaSUd4bF3MWwF6Y+IJTFxUthUhvpSjMCcFUU6d4bJcX3wS
         buL3E/yhBsCjIDNsJKzJCFOeawvdzOb8blxZteJT/bAMz0hVFAUpSymxYrO/Epsh8p
         rvs2HIDrTFJZw==
Date:   Tue, 20 Sep 2022 08:29:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [net-next v8 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <20220920082905.63adec9a@kernel.org>
In-Reply-To: <20220913122629.124546-3-andrei.tachici@stud.acs.upb.ro>
References: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
        <20220913122629.124546-3-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Sep 2022 15:26:28 +0300 andrei.tachici@stud.acs.upb.ro wrote:
> +static int adin1110_port_get_port_parent_id(struct net_device *dev,
> +					    struct netdev_phys_item_id *ppid)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +
> +	ppid->id_len = strnlen(priv->mii_bus_name, MII_BUS_ID_SIZE);
> +	memcpy(ppid->id, priv->mii_bus_name, ppid->id_len);

gcc 8.5 complains about overflow here, MII_BUS_ID_SIZE is larger 
than MAX_PHYS_ITEM_ID_LEN, i.e. the length of ppid->id.

Please fix this up, the build bots are gonna get angry.
