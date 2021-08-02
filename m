Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8A3DDB75
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhHBOrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhHBOrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3790B60F51
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627915663;
        bh=/edlifWAIP5PNoIPZdac5tNO3DC5/VtzmthNRr34WwA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=keBqMJx+34MrMFY7h5qJz/lAhxDCgm+pfSmTkFPsdbqOeMjFDXVthazBrOugCW6Yc
         bPHG2j6Wda9VzKPOwQ/cLg792OAF6Te10mMUsR94B2GTvD1HF7kXjn9mCC8rck47Tg
         hyLwHSba1LXVLwOH9unW1vQlEBHfOJhxpciFMe0gBRYldsL7dxJjD5J3t7Sqn1YBtm
         GxtyJFa3UqG3CAY6pxzHjq6wv43KFjtPYIVD01T7b+OBFt8EQsFUhSfvwLlYrQAFIA
         TsCMYolAOH8Yyh/sBApgovQcfJ6QV5hygShxGxH23uB+xe/p3SvyKCCCtDQAYNy8BV
         QtbdkJSFJIlhQ==
Received: by mail-wr1-f45.google.com with SMTP id d8so21771394wrm.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 07:47:43 -0700 (PDT)
X-Gm-Message-State: AOAM532GbXtqzmAPLMCEu6JFPZtBPK9jQvE1HEUf8osr/M8GlU3Z06PA
        WMLh0fAm2mNtAEHZxm+xqxSh3IcGNnYvCuXTWzI=
X-Google-Smtp-Source: ABdhPJwhiMq/RJN5cRCJXKJpST7WCcxoIW3dSXGnJ93DGSvIfVP4fAdt/aiqzJZ/sY4Csok2ea1rd85BB7hIk5RxESc=
X-Received: by 2002:adf:e107:: with SMTP id t7mr18014609wrz.165.1627915661803;
 Mon, 02 Aug 2021 07:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 16:47:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
Message-ID: <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: build all switchdev drivers as modules when
 the bridge is a module
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 4:28 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> Currently, all drivers depend on the bool CONFIG_NET_SWITCHDEV, but only
> the drivers that call some sort of function exported by the bridge, like
> br_vlan_enabled() or whatever, have an extra dependency on CONFIG_BRIDGE.
>
> Since the blamed commit, all switchdev drivers have a functional
> dependency upon switchdev_bridge_port_{,un}offload(), which is a pair of
> functions exported by the bridge module and not by the bridge-independent
> part of CONFIG_NET_SWITCHDEV.
>
> Problems appear when we have:
>
> CONFIG_BRIDGE=m
> CONFIG_NET_SWITCHDEV=y
> CONFIG_TI_CPSW_SWITCHDEV=y
>
> because cpsw, am65_cpsw and sparx5 will then be built-in but they will
> call a symbol exported by a loadable module. This is not possible and
> will result in the following build error:
>
> drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_netdevice_event':
> drivers/net/ethernet/ti/cpsw_new.c:1520: undefined reference to
>                                         `switchdev_bridge_port_offload'
> drivers/net/ethernet/ti/cpsw_new.c:1537: undefined reference to
>                                         `switchdev_bridge_port_unoffload'
>
> As mentioned, the other switchdev drivers don't suffer from this because
> switchdev_bridge_port_offload() is not the first symbol exported by the
> bridge that they are calling, so they already needed to deal with this
> in the same way.
>
> Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I'm still seeing build failures after this patch was applied. I have a fixup
patch that seems to work, but I'm still not sure if that version is complete.

      Arnd
