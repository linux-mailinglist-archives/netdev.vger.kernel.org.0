Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E481B2AAB1C
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 14:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgKHNUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgKHNUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:20:13 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27943C0613CF;
        Sun,  8 Nov 2020 05:20:12 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so5861956edj.13;
        Sun, 08 Nov 2020 05:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XAr/eL1VZ2XcBlF2qTl3XTkSwOvM8Dzq1eN8MYa2AkY=;
        b=Y6w3TCvBm/1WI8RxhnM8eXllHco7G1EwSJUl9ocsRhEXsmY/icGx3ewrRind8oXtV6
         d8/16wacPREPbGFuJrn5ApOHK/DypsdWdZW4UHVTrXszvt6MgBcsFVKdV08Qse5oh4Ci
         Bk/QzvqqfDuZXIAmQsrn3s0qSKKiZ/ixlkMRnqw7MRsM+6OWQB0zQiplzkkDZ85PGyUg
         TKGqrcqoF7kn1yAka2G40sySbikn1DoGiOlsfwwQ9x0tDiGTa/9GqooSr0fIet2AAn3t
         3pnS3ird/nEFPjCATmq62UDDTZL5Qqvk9XD2pjFvHraqs8mQqqjSED9XyBiBirXnAo5l
         1XPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XAr/eL1VZ2XcBlF2qTl3XTkSwOvM8Dzq1eN8MYa2AkY=;
        b=nXAvN7sm2o8F+d0BgxpupEGcOEkz6A6yHf7kgNVWWLxUYdR4imq2ag99oXJlvxsK7m
         wc6UK8TgNf2Dg+9OXbdnZ3io4d6YgNSTe9Tgwzht6urklbVXMfCEsB06sJBvMLNCupj+
         b8svpCs2LQa/w9qQqu6KLNBdEM59g6I0o8Vlqqrn+u3+7ZhWIK2gdxQlOfm1KIBVhgPk
         q3joMhm6c8mdUL39CSk4KSq6LaVmLzxsezn79Jk3iSv0E8CKh24rFllA/SOlpj3NWK+X
         2RX7N6wUHI838uAJUebzYozT7Y2/VdXzRsHZhhcXGc1BRryX/6b30USpjN8yROx0pHq4
         lJ1Q==
X-Gm-Message-State: AOAM533gqsuliaNbdGH+dahJnp1Sufzk6LADfnUvm9OetLQE+eGlJ3YJ
        MNswMxz16T7IW+B3r+k2SV0=
X-Google-Smtp-Source: ABdhPJxALYjFqRPjJxLgVOIfLZxPvXKFK+SbNjwoh2cR4AG8rh3ss60rcWn0vqHgKUP3GC/HOev7Vw==
X-Received: by 2002:aa7:dd49:: with SMTP id o9mr10553347edw.143.1604841610687;
        Sun, 08 Nov 2020 05:20:10 -0800 (PST)
Received: from localhost.localdomain ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id og19sm5967094ejb.7.2020.11.08.05.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 05:20:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 0/3] Offload learnt bridge addresses to DSA
Date:   Sun,  8 Nov 2020 15:19:50 +0200
Message-Id: <20201108131953.2462644-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series tries to make DSA behave a bit more sanely when
bridged with "foreign" (non-DSA) interfaces. When a station A connected
to a DSA switch port needs to talk to another station B connected to a
non-DSA port through the Linux bridge, DSA must explicitly add a route
for station B towards its CPU port. It cannot rely on hardware address
learning for that.

Vladimir Oltean (3):
  net: dsa: don't use switchdev_notifier_fdb_info in
    dsa_switchdev_event_work
  net: dsa: move switchdev event implementation under the same
    switch/case statement
  net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
    bridge neighbors

 net/dsa/dsa_priv.h |  12 ++++
 net/dsa/slave.c    | 160 +++++++++++++++++++++++++++------------------
 2 files changed, 110 insertions(+), 62 deletions(-)

-- 
2.25.1

