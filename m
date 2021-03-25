Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658D03496EE
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhCYQhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhCYQgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:36:40 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A1C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:36:40 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id p2-20020a4aa8420000b02901bc7a7148c4so620855oom.11
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7J1Hc9Q1nkfPP07O9haYGsEYT5C8HfBzL9qm00iTbXs=;
        b=o7rbNqw8ZRfZWSfjJkeghYzxakRRE+daxlbRpnBkFWoekNelVbxCPlrXZGoQEownAM
         T4OpfmKpLaNtnVWaD6FWRiGb/cKcf8Bu3nGzkRELGoCrvuzsZ+6vgsim9GqJ/f9/jMwm
         b0J4/yoahk9CpAt3fw6NocwP5UQ01mXBrrHeoBU3KpruuupdArt+A5JRy+DxfWPze0Fr
         Xcf/rFpv+f4AMDESnxkgWDNb52rRGLjIyGj5XfVW1DGCt5+wvFTMbYTp12CpP9huyrQU
         oP/K0do5GsnBxyOp8FhHJ448T1/pnrUFpyEuUy1u0cQ6Du/PbQ8Zr7Pzqrd6QcHbj0qJ
         +XSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7J1Hc9Q1nkfPP07O9haYGsEYT5C8HfBzL9qm00iTbXs=;
        b=L0g2jR2vLaXqtXBe4RKCET2/pf5dYXYXwmRNjaqh/ctnaL/mqxcUMceNUV5Y6firfT
         ZhNbw/AIbeljjTNX59IRgsunmOTjuLqKHfQXQzvEyQ+26Dpq6P5zyMa/RMXSfyHFr21N
         sq14qyGWjLypyDfmCJ2Okf6Q6H1Y2MeDSpa315lF5BdmyxzmH/nvdchA6m/EGp4ev5zE
         +31H3zZcU9ZjQfTmEPBwo2z04mD2OJnvBvCy20kH3AxYDwbQ7LQixR/ByZz1+pj1pCfM
         DVNPL78Mhzkz3y0kgXoj47DI59k+T/TD1WFM9SQJYuAEiL98LmoEkLvEvJqJfdlSaLQb
         EDDg==
X-Gm-Message-State: AOAM532/37BsT771/zJkYeXDEmUPulUjrGEimuD7+cynZWcgqXqbPuUa
        Q1/dax6bRkaLBSxwVzWOZisPi9hi08j49+Z3Dh9qmSu1Vw==
X-Google-Smtp-Source: ABdhPJwGOHGZsOy2HFBD1Yq+Y/YQIVgNeTk0Uag5/kEQddVfRJw9k1nxxxfR0UH2VLH/9EnBkK11xCDjm01Ic+rqR7A=
X-Received: by 2002:a4a:d0ce:: with SMTP id u14mr7855499oor.36.1616690198283;
 Thu, 25 Mar 2021 09:36:38 -0700 (PDT)
MIME-Version: 1.0
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 25 Mar 2021 11:36:26 -0500
Message-ID: <CAFSKS=O+BCZeLD92ZT5SvkWCgCLsQ2rN9gPmVY_35PCVBqyZuA@mail.gmail.com>
Subject: net: phylink: phylink_helper_basex_speed issues with 1000base-x
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I set port 9 on an mv88e6390, a cpu facing port to use 1000base-x
(it also supports 2500base-x) in device-tree I find that
phylink_helper_basex_speed() changes interface to
PHY_INTERFACE_MODE_2500BASEX. The Ethernet adapter connecting to this
switch port doesn't support 2500BASEX so it never establishes a link.
If I hack up the code to force PHY_INTERFACE_MODE_1000BASEX it works
fine.

state->an_enabled is true when phylink_helper_basex_speed() is called
even when configured with fixed-link. This causes it to change the
interface to PHY_INTERFACE_MODE_2500BASEX if 2500BaseX_Full is in
state->advertising which it always is on the first call because
phylink_create calls bitmap_fill(pl->supported,
__ETHTOOL_LINK_MODE_MASK_NBITS) beforehand. Should state->an_enabled
be true with MLO_AN_FIXED?

I've also noticed that phylink_validate (which ends up calling
phylink_helper_basex_speed) is called before phylink_parse_mode in
phylink_create. If phylink_helper_basex_speed changes the interface
mode this influences whether phylink_parse_mode (for MLO_AN_INBAND)
sets 1000baseX_Full or 2500baseX_Full in pl->supported (which is then
copied to pl->advertising). phylink_helper_basex_speed is then called
again (via phylink_validate) which uses advertising to decide how to
set interface. This seems like circular logic.

To make matters even more confusing I see that
mv88e6xxx_serdes_dcs_get_state uses state->interface to decide whether
to set state->speed to SPEED_1000 or SPEED_2500.

I've been thinking through how to get the desired behavior but I'm not
even sure what the desired behavior is. If you set phy-mode to
"1000base-x" in device-tree do you ever want interface to be set to
PHY_INTERFACE_MODE_2500BASEX? If so just for MLO_AN_INBAND or also for
ML_AN_FIXED? Do we want phylink_validate called in phylink_create even
though it gets called anyway for MLO_AN_INBAND and ML_AN_FIXED later?

Regards,
George McCollister
