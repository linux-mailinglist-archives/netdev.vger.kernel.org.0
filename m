Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03494330926
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhCHIHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhCHIGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 03:06:37 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D718C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 00:06:36 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id u4so19633316lfs.0
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 00:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=sV1py7eP7mIZzJ0YRdW/Q5PSAusaIBUDzfB0Urz/gQ8=;
        b=qonQxelSxaskpYku99DacNr0T6nnzLaeNfNj++tme3azTUfDCgW97aUM9Fhq4PBm9Y
         NO231oU0ds4uJjgmy/oTLEQdoEPrHncCOXHVuSwgU0tL9ck2v7WXjcxgrS9SL6uSF/rn
         ix9RKAOAIQWWGGkCeu0/V64ZtDlL9L+Z2ebMUu6V0334UmxwX1iUTLPbF9PBW+h6JIVe
         HHxyBb16USrWMj41OfO+lZb4/0hETLh14LJ6fWHmizr98Ldnvvp4FbpQnHyV5vjbPNC+
         wAWOwXNxF6EUxkHoNhQ5mNlF8lTatdyw1sI4iTlkBEiU2IA9lHojqwW5tWr6y1NSJ1Iz
         yeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sV1py7eP7mIZzJ0YRdW/Q5PSAusaIBUDzfB0Urz/gQ8=;
        b=D2OidCuWmZYOO4exwI3RN4K/2U/f4I8wJhOq4JdcXWY7RVveH/G/JVlM+22svPUfJT
         NcOGnJkcgqsRkt924F+m7W3VV4JrMofLlbzk4ZcWGK9eoNvUW+ozqTqrnnvmHUBTDg+k
         z/d8UAtXouKY5D6jKhCpLI+tzZYoXk5z3Iw+dtmEYH86G/RE64Y8MO3jnsFGvYBJyfTF
         EPQWe1VnCoVpCItZRL1TbwX+3heDB46JBDvTAfDl85qgj73HaXuAz+w2qHU+wnQkcg02
         69csKTejYnOVFB/b9txoBj6f7BEDcaJ49DhI/36HoScTJDtvb5mgapMUdh8GCrl00PP1
         UNlw==
X-Gm-Message-State: AOAM532KCQlRb7GICBdH3G7oQDBEqQQEPEuiarVFbdad2PwZZhN75DC+
        lOFh3nKQtCyeRxa3cjK+lsn2Cg==
X-Google-Smtp-Source: ABdhPJyxtUuC7eXhqLWrczhNq56Cj9SnKsHTVYKxkmFv8eqtcTIg67BUa/npjz141yBXn1ZYekjteg==
X-Received: by 2002:a19:7709:: with SMTP id s9mr14198345lfc.250.1615190794878;
        Mon, 08 Mar 2021 00:06:34 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p21sm1261865lfu.227.2021.03.08.00.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 00:06:34 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net] net: dsa: fix switchdev objects on bridge master mistakenly being applied on ports
In-Reply-To: <20210307102156.2282877-1-olteanv@gmail.com>
References: <20210307102156.2282877-1-olteanv@gmail.com>
Date:   Mon, 08 Mar 2021 09:06:33 +0100
Message-ID: <87v9a2oyra.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 12:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Tobias reports that after the blamed patch, VLAN objects being added to
> a bridge device are being added to all slave ports instead (swp2, swp3).
>
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> bridge vlan add dev br0 vid 100 self
>
> This is because the fix was too broad: we made dsa_port_offloads_netdev
> say "yes, I offload the br0 bridge" for all slave ports, but we didn't
> add the checks whether the switchdev object was in fact meant for the
> physical port or for the bridge itself. So we are reacting on events in
> a way in which we shouldn't.
>
> The reason why the fix was too broad is because the question itself,
> "does this DSA port offload this netdev", was too broad in the first
> place. The solution is to disambiguate the question and separate it into
> two different functions, one to be called for each switchdev attribute /
> object that has an orig_dev == net_bridge (dsa_port_offloads_bridge),
> and the other for orig_dev == net_bridge_port (*_offloads_bridge_port).
>
> In the case of VLAN objects on the bridge interface, this solves the
> problem because we know that VLAN objects are per bridge port and not
> per bridge. And when orig_dev is equal to the net_bridge, we offload it
> as a bridge, but not as a bridge port; that's how we are able to skip
> reacting on those events. Note that this is compatible with future plans
> to have explicit offloading of VLAN objects on the bridge interface as a
> bridge port (in DSA, this signifies that we should add that VLAN towards
> the CPU port).
>
> Fixes: 99b8202b179f ("net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored")
> Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> This is the logical v2 of Tobias' patches from here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210306002455.1582593-1-tobias@waldekranz.com/

The issue related to the combo of software lagged ports in a VLAN
filtering bridge is a separate one, so I think this is fine the way it
is. I will address that issue in a separate patch.

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
Tested-by: Tobias Waldekranz <tobias@waldekranz.com>


