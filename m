Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F21332E94
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhCIS4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhCIS4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:56:14 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DF3C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 10:56:13 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id c19so13789609ljn.12
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 10:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LnmGCjQ4C8zQCydVtjZgL3of8o/zdUX2yEmxWYlFGQY=;
        b=XMMCOIPKj8F9xeHDzmbByf/nxbEXZ1LrxTc4YjjHHM6EwdNwGGRO4/ZUzzhFTFGNlo
         ZhYsDfleSoikwKicPmqFbpH4t6FM8vfo7QU7+W1dLzMyMnUMW1XaTaM/DsTSFHlkc4NF
         0kdywZZLSwAf+aK7J8R9MXdnQyL9p+i00krHrRcjhZD/l2CF9/D8trpliz6sQxXR9lvf
         2GB4OR+ljz7dn0iDtdv6yZVQ729JQDsHUU0JmT+rzLWL4TAlnRJr+NByWh8Aq1rnrUD0
         vckergf5hrqRXHPu/CESJb6EIC0jdghHw/MUx+o2PcWR0sjDA+wvyPtEJO/TTZZQfY/6
         SS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LnmGCjQ4C8zQCydVtjZgL3of8o/zdUX2yEmxWYlFGQY=;
        b=sRRpMoGyfEq7oVAl56ILu6i49efxqyNRzI2NIaDFm+PSgknnQcGOgK7emICMX6CASM
         IKnLD7F9AQlDS6jyCL1BtOyL+P2PLv/XYbs8FQp8GtaK1/AnrjtCLeKfXlEg8KIiaHSG
         +/HsVbKxwaCwrpGVvIQjtkka1e6XoVPez7FMRdj4Frpc3kmOX7sPsYyFk9B5Yk5b5biZ
         tiD0Jh0aQzBLA0D2P2sXd3uxgAN/otehpguMQ53+fxm3Zw2fWhguqXVToJMcI9PlAR4W
         MXK8CPeo7JbN39Z1M6vHF5VIAshugtZA3jDhIhGRKnE7+MgSP+eUGoSly6wKil9oCnvM
         7uJw==
X-Gm-Message-State: AOAM533aXNQfrpVg177MEY1cI+ttYCuYIZ9xr90IfgpBQLBs4s4iaQj+
        TQoYtU+TktYgXRwotQ6MprZ/4vcVNRV8Tg==
X-Google-Smtp-Source: ABdhPJxl2fbongPvVdlJI/UScdXHhFAm1BpbaI442VP1lCqhMEdfXVu4/CGM/nPX5x1mnJv3OHutDQ==
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr8679716ljj.148.1615316172465;
        Tue, 09 Mar 2021 10:56:12 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id k1sm607198lfg.3.2021.03.09.10.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 10:56:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net 2/4] net: dsa: prevent hardware forwarding between unbridged 8021q uppers
In-Reply-To: <20210309021657.3639745-3-olteanv@gmail.com>
References: <20210309021657.3639745-1-olteanv@gmail.com> <20210309021657.3639745-3-olteanv@gmail.com>
Date:   Tue, 09 Mar 2021 19:56:11 +0100
Message-ID: <87k0qgp35g.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 04:16, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Tobias reports that the following set of commands, which bridge two
> ports that have 8021q uppers with the same VID, is incorrectly accepted
> by DSA as valid:
>
> .100  br0  .100
>    \  / \  /
>    lan0 lan1
>
> ip link add dev br0 type bridge vlan_filtering 1
> ip link add dev lan0.100 link lan0 type vlan id 100
> ip link add dev lan1.100 link lan1 type vlan id 100

If I move this line...

> ip link set dev lan0 master br0
> ip link set dev lan1 master br0 # This should fail but doesn't

...down here, the config is (erroneously) accepted.

> Again, this is a variation of the same theme of 'all VLANs kinda smell
> the same in hardware, you can't tell if they came from 8021q or from the
> bridge'. When the base interfaces are bridged, the expectation of the
> Linux network stack is that traffic received by other upper interfaces
> except the bridge is not captured by the bridge rx_handler, therefore
> not subject to forwarding. So the above setup should not do forwarding
> for VLAN ID 100, but it does it nonetheless. So it should be denied.
>
> Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

This is what I meant by having bits and pieces of this validation
scattered in multiple places, some things being checked for certain
events but not for others, etc.

I took an initial stab at this to show what I mean:

https://lore.kernel.org/netdev/20210309184244.1970173-1-tobias@waldekranz.com

I am sure there are holes in this as well, hence RFC, but I think it
will be much easier to make sure that we avoid ordering issues using a
structure like this.

What do you think?
