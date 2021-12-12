Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440E6471C2C
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 19:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhLLSTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 13:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhLLSTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 13:19:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C46C0613FE;
        Sun, 12 Dec 2021 10:19:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o20so45812804eds.10;
        Sun, 12 Dec 2021 10:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xf+krmu8h/ehBtsbZ5BQ5Qe6C+vrilnMIuwkvKL/6mE=;
        b=H3nycKDnvAmXQMRC8W2KfQKEymn5xexm17/uB83aAAvfgN1wzCEiEBHiesgcSHwm32
         nuIzRCW8+xlOv9KoCanxGBXu4mJnX4E/b0oKnNWn5dNQTZW7PTFEHDRSFaZosoAfB7PH
         80+1bEPgb7+YPS4s8FOBC1u4tPVUnnYu9qw+JhHeIHrhq+0UY3WmFgqThHoDdNwBJRpC
         XktjqkQpVyOOvv+Goz4OACmhR6RLd2htA24tpQLzuF/LEs/W2yX1gIT5/w8fjf9hiYVH
         uRBYtFd890bSsdiprJBr4aXTKZGCJvUA7aB2dkKOtcj2fcji3If2783F7SDxcz8Buept
         YfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xf+krmu8h/ehBtsbZ5BQ5Qe6C+vrilnMIuwkvKL/6mE=;
        b=grOh4I0jkbopBChC4zk1+FdJDorfvhLEcBwdQ+cmweiQUixRkRbEWq1PVxideWiB8t
         imf7gELRiYDvJab5HRzvv362nqAO9kzKHoqbdbLM7YbdWlKsvbJzvIfyLMdk0lwzo4br
         OVKAdfn76SjIAHJD2Suxkvh3Kul+7AcyEO43iQzDVek/H7HIiwR5KPGqJkjj5PGJA7+Y
         Qx//zFN48PWT92JUabVJ+zleqGNyg3gs+ZEpFXzIYTUB4DyWPha/g7Veu0eppaUjcSAG
         v1eurzaC9WtsJyHVgLuTl5UY7jRFwvhny1NZQfrnb2XWTv5rQJlFW9HajR3pOri8IY0V
         ftFg==
X-Gm-Message-State: AOAM532pX6XnxnGDJTimEIbZhTyzqU5rJhJRVtFTK10Oh+jQpw3l5Rae
        u4WhfpKLmVyihYlFy6oIZEo=
X-Google-Smtp-Source: ABdhPJwNq29X+gjxjtvfbYiUfGzF7kAyxgWjblAeLdrDwrDDFAdL7HDsrPzm4LXPO3Y5Rtivyzbjiw==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr55309200ede.28.1639333168150;
        Sun, 12 Dec 2021 10:19:28 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id d1sm5190435edn.56.2021.12.12.10.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 10:19:27 -0800 (PST)
Date:   Sun, 12 Dec 2021 20:19:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [net-next RFC PATCH v4 01/15] net: dsa: provide switch
 operations for tracking the master state
Message-ID: <20211212181926.he6ld6isaubzubp4@skbuf>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-2-ansuelsmth@gmail.com>
 <723bd735-5edc-88ee-4870-e91c98c7dd22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <723bd735-5edc-88ee-4870-e91c98c7dd22@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sat, Dec 11, 2021 at 08:22:39PM -0800, Florian Fainelli wrote:
> If my kernel is built with no packet scheduler, is not the interface going
> to be configured with noop all of the time?

I made this test and it looks like interfaces that are down use noop,
normal multi-queue interfaces use mq, and stacked interfaces using LLTX
like DSA use noqueue when up:

root@debian:~# zcat /proc/config.gz | grep NET_SCHED
# CONFIG_NET_SCHED is not set
root@debian:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 02:0b:67:72:9a:d5 brd ff:ff:ff:ff:ff:ff
3: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
4: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP group default qlen 1000
    link/ether de:79:92:89:2e:e6 brd ff:ff:ff:ff:ff:ff
    altname enp0s0f2
    inet6 fe80::dc79:92ff:fe89:2ee6/64 scope link
       valid_lft forever preferred_lft forever
5: swp0@eno2: <BROADCAST,MULTICAST> mtu 1504 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
6: swp1@eno2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
7: swp2@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc noqueue state UP group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::a4f4:afff:fefd:fc73/64 scope link
       valid_lft forever preferred_lft forever
8: sw0p0@swp0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
9: sw0p1@swp0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
10: sw0p2@swp0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
11: sw2p0@swp2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::a4f4:afff:fefd:fc73/64 scope link
       valid_lft forever preferred_lft forever
12: sw2p1@swp2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
13: sw2p2@swp2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff
14: sw2p3@swp2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:f4:af:fd:fc:73 brd ff:ff:ff:ff:ff:ff

Would this test be sufficient or do you have a specific concern?
