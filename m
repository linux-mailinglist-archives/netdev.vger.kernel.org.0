Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70F03053D8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhA0HBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316931AbhA0BBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:01:25 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C0BC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:43 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g3so302151ejb.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fUXyf1oadQBPG9dQOZpK2kETmKrmf0MdC3Y5RBE0BWY=;
        b=XMBbmnFFrZZTyUzsq4pf4ikmlrLkECjU20YhfkKtHKQ8FrtiLskat2jIwTjAsFmiF1
         mtUec+yA5BtGrERYZLVeSiLVvvoHVkvLAipNuyQddyYNuveJYl2GO1dnT9cMYCJQm1VN
         66bGfnEW5V4PkVl9agZSf+GHA0yN4SOizbsVC8DSniNRd2U8HhZQbpRBP7FkDfds58FF
         RnG+iBZbsQvzdR0JKcLgMH5dtN+l450/inI58pJkRUndpMt5UTT6zI9rX3hPz85MRB7Q
         h4nPH9j8F2Ti4WjLOGucvZA/LtAgUObSon6l7HPfaRPldAPs2PVBpu2fnDhAa/v0gRps
         yaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fUXyf1oadQBPG9dQOZpK2kETmKrmf0MdC3Y5RBE0BWY=;
        b=N+TVkElsb3oYL3hLwqbdxVqeVHG1qyWcbss1M42R9ssYQhu1DuGDe/HjZDbCkBf0pO
         RipJUkvwfyycN0KSO0v/eDZc0+I0d3SyOlA+86y12UCT3ARQFFgyXM50TWb5Q3BLOBr4
         KPvMQfDMNCOTUHuP9gdZR6d8CvH0dJO1VZ5O1YJJu8G5lzENgeN2trr/Wa2PpuTqXUHO
         RlUcpyv6/MUH54C3rRg42I6hWIvhFEV2muGWWzFKDX6c3ZaHTngE0LbkTSmk8/OUFyPT
         3g1hW2OKIY7OzaUyF1JNGVWS6uSohxinRor4/ohX9JY08jj5t8v1WANaPw+HMKYv+P5i
         8+7w==
X-Gm-Message-State: AOAM5335FzB+HB32HdzCUq3rALZOgKiJu8rlrkUhNkHGJNjXo4Y3CI8F
        9hwIqvfBZc/N6m2FnGXN4vU=
X-Google-Smtp-Source: ABdhPJy4MHgR9EM7qDgT3bNNxknqJZ6YAPYMY5WEDAgmo2gthzVqErO+ujsINUo5uFJI/fDd1d5uMw==
X-Received: by 2002:a17:906:a1c2:: with SMTP id bx2mr5267771ejb.138.1611709241945;
        Tue, 26 Jan 2021 17:00:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ko23sm115897ejc.35.2021.01.26.17.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:00:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next 0/4] Automatically manage DSA master interface state
Date:   Wed, 27 Jan 2021 03:00:24 +0200
Message-Id: <20210127010028.1619443-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series adds code that makes DSA open the master interface
automatically whenever one user interface gets opened, either by the
user, or by various networking subsystems: netconsole, nfsroot.
With that in place, we can remove some of the places in the network
stack where DSA-specific code was sprinkled.

Vladimir Oltean (4):
  net: dsa: automatically bring up DSA master when opening user port
  net: dsa: automatically bring user ports down when master goes down
  Revert "net: Have netpoll bring-up DSA management interface"
  Revert "net: ipv4: handle DSA enabled master network devices"

 Documentation/networking/dsa/dsa.rst |  4 ---
 net/core/netpoll.c                   | 22 +++------------
 net/dsa/slave.c                      | 40 ++++++++++++++++++++++++++--
 net/ipv4/ipconfig.c                  | 21 ++++++++++++---
 4 files changed, 59 insertions(+), 28 deletions(-)

-- 
2.25.1

