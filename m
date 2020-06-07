Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278241F0F9C
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 22:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgFGU2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 16:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgFGU2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 16:28:44 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A538C08C5C3;
        Sun,  7 Jun 2020 13:28:44 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x18so1446779lji.1;
        Sun, 07 Jun 2020 13:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version;
        bh=iFVK6T7mzGjOxx/JmauiHPsqIRO2z2WuG+ZMZIcwVqo=;
        b=lx7xbUmKVNZ6m3ubB0bjZkaMvbGlZCjUfViAnzvxo/HI7FAF5Xvc6Byo/ewVl7h1qw
         n8RFIa4uKuvPs4EiIGjP0Cv6sABrElT4ke9CxAu0J4qMJxP7yTOnyQQKL6u6vqcfZ7Uz
         ZmjlJi5TThxOy4lz04H9/1nVSLMh/swG7jJCTPsAfJOBltRv62K7NGW6KSH6CbzgEAfl
         1ywC2KtDSM7Umfvy7ln4NAuHieVu6PRyCYefo6oPvO47BeiI8zES69fUABrsaXqw/sY2
         ogLaqngnSePlQjl45aajdpn36fM+PiyXd9caLV0MVLZNHUuhtFptxcP7bENXfHZn/wY7
         oDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:user-agent
         :mime-version;
        bh=iFVK6T7mzGjOxx/JmauiHPsqIRO2z2WuG+ZMZIcwVqo=;
        b=CQkO3TpnfTAAx9EYiKuNBhnN9CP53UvR3fFeun3xqJKf5mYSLuHsi9zm8CQbCIjHnq
         gGDByoFQpz3pnVfK7B68t6eNBngculW/56lM4gTLA69kr1yyPWZ+Yh1m/rPoVqJFJgD0
         7bi4mP8stRpmA+fHXPg+keO6znHNf2kYZ0dxcoNBe38TxVVIbrfO3bZTK1qUNIFEoQmt
         vqxc3Fvqgz1nPkhW8lYSKJr26y9YPOjFX9F0J1GVA1yjqAmFANqNyxdALz8aF2NDmd7m
         LJTzPkRXu+PBo9sVzhIlxOG6V4ly0svf8UbwZC8pSYs6eLW0ZukqVT9UeXV5/w0V+hIH
         kytw==
X-Gm-Message-State: AOAM5338MCDdPlVzA36N0+dukKjV8Uz8mVkUog/aNvJvaOYkDs1Dxec1
        1Ft64HAR0Yj7eqnv+AEK6453DC5L
X-Google-Smtp-Source: ABdhPJxvJ7ov+tMzMbbwiPZ3dCyV2yFPVYR6dLmPbgpVyHjoeiPAy2+ePLym3GRhyJ3ZNyHo8yhwqA==
X-Received: by 2002:a2e:b88e:: with SMTP id r14mr9070233ljp.197.1591561722546;
        Sun, 07 Jun 2020 13:28:42 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id r9sm1685046ljj.127.2020.06.07.13.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 13:28:41 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, "NXP Linux Team" <linux-imx@nxp.com>
Subject: iMX 6SX FEC: broken hardware timestamping using external PTP PHY
Date:   Sun, 07 Jun 2020 23:28:40 +0300
Message-ID: <87r1uqtybr.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm using DP83640 PTP PHY connected to builtin fec1 (that
has its own PTP support) of the iMX 6SX microcontroller.

Almost everything works fine out of the box, except hardware
timestamping. The problems are that I apparently get timestamps from fec
built-in PTP instead of external PHY, and that

  ioctl(fd, SIOCSHWTSTAMP, &ifr)

ends up being executed by fec1 built-in PTP code instead of being
forwarded to the external PHY, and that this happens despite the call to

   info.cmd = ETHTOOL_GET_TS_INFO;                                                                             
   ioctl(fd, SIOCETHTOOL, &ifr);                                                                     

returning phc_index = 1 that corresponds to external PHY, and reports
features of the external PHY, leading to major inconsistency as seen
from user-space.

I chased the ioctl() problem down to the fec_enet_ioctl() function in

  drivers/net/ethernet/freescale/fec_main.c:2722

that specifically for SIOCSHWTSTAMP (and SIOCGHWTSTAMP) explicitly
calls

  fec_ptp_set() (and fec_ptp_get())

instead of delegating to phy_mii_ioctl() as it does for the rest of
ioctls.

I've then commented-out this fec_ptp_set() calling code, and now ioctls
go to the external PHY, but I'd like to have proper fix instead of 
quick'n'dirty hack.

I checked DTS documentation, but didn't find a way to disable fec
builtin PTP support (nor would I actually like to, as it could be
useful as a hardware PPS source), or its timestamping feature.

I need to fix this, and, being newbie to the codebase, I don't even know
where to start, as I can't figure what's the supposed way of selecting
which unit should be used for hardware timestamping when there are two
of them on the current active path of newtork packets. I mean,
configuring PTP clocks is OK, as they are accessible separately through
'/dev/ptpX' interface, but hardware timestamping is to be configured
through (single) if-name, and there doesn't seem to be a way to address
different hardware timestamping units.

I'm using rather old 4.9.146 kernel, so I checked the tip of the git
master, and the code there still looks the same. I also didn't notice
any relevant commits in the recent git history.

Could somebody please help me implement (or point me to) proper fix to
reliably use external PHY to timestamp network packets?

-- Sergey
