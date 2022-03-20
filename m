Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B8C4E1958
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 02:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbiCTB2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 21:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTB2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 21:28:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FD019ABC6;
        Sat, 19 Mar 2022 18:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XZkDac96686HEwtu5EZHDefx4fWrumtlPEc96k5BdnM=; b=nBqhmSZwsAoQ4Kx5szo9hwEVoX
        dgTr9y+3e/X08m3ocp9i/zl+Bvd4zUUJI+WHttaYRE8zPnyCYyLJf6gmb3zDxP7cFE0X0iD/RtrTD
        HyNkgAISVKai7vpxNPfWk/iHIZWUhPAG19tpMYcKBXQ3IaGg+neX4BaUPc0KvqNDFCxs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVkL9-00BljN-C0; Sun, 20 Mar 2022 02:26:39 +0100
Date:   Sun, 20 Mar 2022 02:26:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 08/11] net: dsa: microchip: add support for
 ethtool port counters
Message-ID: <YjaCz0gqm846RAk5@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-9-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-9-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 02:25:37PM +0530, Prasanna Vengateshan wrote:
> Added support for get_eth_**_stats() (phy/mac/ctrl) and
> get_stats64()
> 
> Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
> along with relevant lan937x hooks for KSZ common layer and added
> support for get_strings()


> +static void lan937x_get_stats64(struct dsa_switch *ds, int port,
> +				struct rtnl_link_stats64 *s)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port_mib *mib = &dev->ports[port].mib;
> +	u64 *ctr = mib->counters;
> +
> +	mutex_lock(&mib->cnt_mutex);

I think for stats64 you are not allowed to block.

https://lore.kernel.org/netdev/20220218104330.g3vfbpdqltdkp4sr@skbuf/T/

There was talk of changing this. but i don't think it ever happened.

      Andrew
