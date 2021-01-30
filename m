Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE54B3091A9
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 04:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhA3DXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 22:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhA3DLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 22:11:35 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C259C061793
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 18:41:23 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id p5so12145051oif.7
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 18:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=EerNCF/ZN+3JAZY/8jvdgN5YvG+O6/RrznIcMvrR7X0=;
        b=tpRB6ziKPPAaZWk+8H7Q2tGDeAXL2vF8UT1oe6x0Ku0nBKxMLzXmNVBe0MMMu4JniN
         VJcC/LPGMs2qJ7qSCsHZPe9EhXbcKptWmfCS2t4mabaMwvKZYeJ34uoT0QzTvU7Ke3J5
         J3vy9EPk5ht95tv8gDkR5J+1f526DvxP7Nti6QjABuvK09VppE2msTYvm8C7jPIqIwiX
         EvdKMiZtrafPR1jJ8Um1M+7njXXnScK2Seh92uc7I3fAhhn7MQfQXTX8pxq/uiwD5nvv
         UaCt9HTx10Fvyu9lcuHLnHrk0ZvbNhm8Zvd4hcPNZqAv7M0EXSsAc8yXPq+SEEKpGnLf
         V3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EerNCF/ZN+3JAZY/8jvdgN5YvG+O6/RrznIcMvrR7X0=;
        b=GiL7lrGeFcYKiy0lMVbC1spAgaMzHdiT6pzc7UxIeiOJ1fQ7tePOQZRXd83+ODLsLo
         J1JhYeKziBPX4cckvogNzpZu2ffBYHJgsn4ZVhBmDS4DUd/frFMngYnr3LOUVtFKn7+v
         22OdseoKAz2B015V8/11TTOcjOfw0zCU0WkOf0xe/2Ih5G2JEe6XQ4/hblI8DKJqIqEq
         JGVd46LSI0C49RLvlC85XcV0jsb/0LK8zqGipwyBYDpbI2pHdm48oV42er3UP1zOXMAl
         AKnifdQDXzCsWSAUkEuRBHcJnoW7HNgyWTXKyhjwJRiEGSqIx0gr0L+EsMz1WRsFEupC
         tmpg==
X-Gm-Message-State: AOAM531miomzmfvkV4R3pc1yk9ZJHPCTDLN4ZOc6hvgRR02Gr4+4j3Gj
        HaTc5W/9LLQxgVIXfDb0lJ9zOsesYdPzvZo0tZuDhveChusWOw==
X-Google-Smtp-Source: ABdhPJyZZGpC7LanJHA9q3W5fCyNCnhvg+Wk5uieh5yIISW77SyQFO5iKXYUmcPakQLww/Dcd6Ig4Nh1GKVVLqsdo+w=
X-Received: by 2002:aca:3150:: with SMTP id x77mr4426385oix.52.1611974482350;
 Fri, 29 Jan 2021 18:41:22 -0800 (PST)
MIME-Version: 1.0
From:   Robert Hancock <hancockrwd@gmail.com>
Date:   Fri, 29 Jan 2021 20:41:11 -0600
Message-ID: <CADLC3L0vBXwLLdqKxox9E-K4dSH07ZhHZ5u_kaANb=16jon0zg@mail.gmail.com>
Subject: Patch for stable: iwlwifi: provide gso_type to GSO packets
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Figured I would poke someone to add this patch to the stable queue - I
don't see it in
https://patchwork.kernel.org/bundle/netdev/stable/?state=* right now.
This patch is reported to fix a severe upload speed regression in many
Intel wireless adapters existing since kernel 5.9, as described in
https://bugzilla.kernel.org/show_bug.cgi?id=209913

commit 81a86e1bd8e7060ebba1718b284d54f1238e9bf9
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon Jan 25 07:09:49 2021 -0800

    iwlwifi: provide gso_type to GSO packets

    net/core/tso.c got recent support for USO, and this broke iwlfifi
    because the driver implemented a limited form of GSO.

    Providing ->gso_type allows for skb_is_gso_tcp() to provide
    a correct result.

    Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Reported-by: Ben Greear <greearb@candelatech.com>
    Tested-by: Ben Greear <greearb@candelatech.com>
    Cc: Luca Coelho <luciano.coelho@intel.com>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=209913
    Link: https://lore.kernel.org/r/20210125150949.619309-1-eric.dumazet@gmail.com
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>
