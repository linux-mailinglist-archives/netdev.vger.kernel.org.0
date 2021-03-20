Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCFD34303C
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 00:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTXAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 19:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTW7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:59:46 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E588C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l18so6789648edc.9
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GgyxA8G9ZoOCAAiWVwmmt114gfq3cVzfk4ylrlzv0gw=;
        b=LDt5HoJsBATDma8ukuJHfmnKdXVnPYuv+WPwrWBeJowYqhJnCirU294MUyc92KwVJk
         RTqA2ZdEVmltconofbKCzHiclJBBti+rVb2neat0N3ZGQu5l4hyAKRdCghbJgelDRmdl
         21NHKhBwl9z8wSTHWtRVUf9Qq8Pg9dw2BFlHuR/NyBn9Rhn5r0YFRzOPRbYVggJHxAX+
         L5Cpq3E18aWzrl4EBJZaALUYDgj4k3DpKQPpQtlaohLFDeS6WPb2RYZGo/OIJMH3BHsF
         yAij0OjbrkYgHXHX2qK/+j6wnzRvUhDThAaIQDgU35yw3ZIJ7Q/bzst7RBfXxzFw/czZ
         R6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GgyxA8G9ZoOCAAiWVwmmt114gfq3cVzfk4ylrlzv0gw=;
        b=Nz7phWXLidEZm2SeN1ZH6zybbEstXBzPqQCBEPFtqO8hHdWwVoVXZ6ttlUn2Rfr0q3
         diJL7sOrblZet77iW9alz4XNyVcfR6iXkgdrM606QAL50SQXcoFyN5sNBqZLgEVkeMX/
         7xIbPxGeSO3sVIjqMjMnGFu/SUerwZ5S0Jv0/u4b7x+Gme9Z1h3R3rzweWr8BTH1Qb26
         ntXIYm/Xkk2cwf+lL/JLtDf7tyIMfH/BEFT3TeVtmQEOD0q2LlCmCVa2pReH/TDuXoNY
         MkU3G/BeGHc1pi6pCbdPVpk5wozb85MfXtyR14Y85zUyXwT1ns4GngkY4fq9p5vJMpkF
         KlRQ==
X-Gm-Message-State: AOAM531iQGbpE+lvP0pmo/Qq3g/SFJzKIP21H4FIya97302A9EXUvb+3
        R2u7Rnc9QKYCqGjRt4PRMCY=
X-Google-Smtp-Source: ABdhPJxYTCCLycuvuNpaaYANLEqqBgIvvhckswmKaqHF1jUs/gg/4n8laaZrPs24lhMcurQaJhZK8Q==
X-Received: by 2002:a05:6402:484:: with SMTP id k4mr17433759edv.321.1616281184994;
        Sat, 20 Mar 2021 15:59:44 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a3sm6101517ejv.40.2021.03.20.15.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:59:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 0/3] Clear rx-vlan-filter feature in DSA when necessary
Date:   Sun, 21 Mar 2021 00:59:25 +0200
Message-Id: <20210320225928.2481575-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Patches 2 and 3 address the problems raised by Tobias here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210308150405.3694678-1-tobias@waldekranz.com/

The key difference compared to Tobias' patch is that his approach makes
dsa_slave_vlan_rx_add_vid accept -EOPNOTSUPP and silently transforms it
into an error code of 0, while my patch series avoids calling
dsa_slave_vlan_rx_add_vid when it is not needed.

Patch 1 is another issue I found while working on a solution.

Vladimir Oltean (3):
  net: dsa: only unset VLAN filtering when last port leaves last
    VLAN-aware bridge
  net: dsa: don't advertise 'rx-vlan-filter' if VLAN filtering not
    global
  net: dsa: let drivers state that they need VLAN filtering while
    standalone

 drivers/net/dsa/hirschmann/hellcreek.c |  1 +
 include/net/dsa.h                      |  3 ++
 net/dsa/dsa_priv.h                     |  2 +
 net/dsa/port.c                         | 37 ++++++++++++++-
 net/dsa/slave.c                        | 62 +++++++++++++++++++++++++-
 net/dsa/switch.c                       | 35 ++++++++++-----
 6 files changed, 125 insertions(+), 15 deletions(-)

-- 
2.25.1

