Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0644331CD8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCICRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCICR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:17:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6175DC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 18:17:15 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w9so17648432edt.13
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 18:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0k4TbUrH+KycUcv8QsdZcEpplASUSY/uNC84pu62Y1I=;
        b=uah1feUWjEywBwAmZ5QH4rMw/FubIOKuYglx7Ura1dex3F2YHxAnquVP5YA75Ptk1+
         I04S8+uYA1D56o1/vcpFSlNT6sdj+Lr1wteEFaghUnhhchF5hhA4Uk7ZToIo3HTc8FG8
         cew38ALHzmCo+AL0sa20/bhfJIebpaslaH1xXGsCstKhg5LhIXjMsgBf66V1iLwCWK+a
         bVVAdUgaFHO51sCx7nVqo4Ev9cgmY7mO7OkRdqiyK8nJHRw/gfApuEF79qhPkhNgGfd8
         fSzDp+4OPD1mSXWfwccpkz44vsG3HwTEsVnI/GlRH01cub40xqI9zZvafW5i+8tfZFoK
         Q+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0k4TbUrH+KycUcv8QsdZcEpplASUSY/uNC84pu62Y1I=;
        b=ELW1LqjdIu4woBUvfoGI5l9RxfrVnxbIg0L77e1SEXVzPUw7xa4kkNlCizwEVPviWY
         hGrXNM8faiunrxMab52yJZGA8lAEcz4o8PNjZaWTdxXGGtmkHFABErzSK7l5T80cBUc5
         bvj8UVdEEOUMcXVz21Potc4hmGfgfZc1PUVH6HPcbiAGkNSP0E7IoEjjAQU+z5kfN7yZ
         MClb03rKTM0ztLucdQqq2mqye7X/xCxpK3A4io7ALi7QpHAHY5YrHTxn4D13TwnXI0Ex
         KRekcM2pVtuXC7Mqxe+e5K3vpWeVwg9+Qroazdz9LcxWoB1oD5LrUYTqSG+MpJ+N0Gdq
         uLRQ==
X-Gm-Message-State: AOAM533n2diEJTHL4Vvk0oBtiuAiD8VLzS8zLjshOXLd9IYobFFVpJPj
        YxbNhFfeczYXceTjlGWPZRw=
X-Google-Smtp-Source: ABdhPJxVPchvupkQatmO9gHsU1H5AmwuVoPR9XgqKk2zSZpQv+NtuxnwerqxR88IW6C2soai9wTRZA==
X-Received: by 2002:aa7:da0f:: with SMTP id r15mr1451823eds.111.1615256234071;
        Mon, 08 Mar 2021 18:17:14 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bj7sm4364902ejb.28.2021.03.08.18.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 18:17:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net 0/4] Clear rx-vlan-filter feature in DSA when necessary
Date:   Tue,  9 Mar 2021 04:16:53 +0200
Message-Id: <20210309021657.3639745-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a proposal for an alternative solution to the problems presented
by Tobias here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210308150405.3694678-1-tobias@waldekranz.com/

The key difference is that his patch series makes dsa_slave_vlan_rx_add_vid
accept -EOPNOTSUPP and silently transforms it into an error code of 0,
while my patch series avoids calling dsa_slave_vlan_rx_add_vid when it
is not needed.

Note that the series applies on top of this other bugfix:
https://patchwork.kernel.org/project/netdevbpf/patch/20210308135509.3040286-1-olteanv@gmail.com/

Vladimir Oltean (4):
  net: dsa: on 'bridge vlan add', check for 8021q uppers of all bridge
    ports
  net: dsa: prevent hardware forwarding between unbridged 8021q uppers
  net: dsa: don't advertise 'rx-vlan-filter' if VLAN filtering not
    global
  net: dsa: let drivers state that they need VLAN filtering while
    standalone

 drivers/net/dsa/hirschmann/hellcreek.c |   1 +
 include/net/dsa.h                      |   3 +
 net/dsa/dsa_priv.h                     |   8 +-
 net/dsa/port.c                         |  60 ++++++++++++++-
 net/dsa/slave.c                        | 100 ++++++++++++++++++++-----
 net/dsa/switch.c                       |  20 +++--
 6 files changed, 164 insertions(+), 28 deletions(-)

-- 
2.25.1

