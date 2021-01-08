Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5304E2EF6E6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbhAHSDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbhAHSDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:13 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB1C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:33 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jx16so15615492ejb.10
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OAdmCHdS2mn5aVyPYX47j0H9AGuWTMSaF+6ffAnnZ1E=;
        b=S8TKRgl8g1wKjytb0q++el8auuuYsT9f88CcPpbW7Fj8qPZhgKN5GH3mhqVifBvER5
         6Y1B4csug4kLpokf2krap9zFvmyf2O+Nl9cuCJyXn2RK+EGxBLKnFavgeySJ34Sq714C
         8tRmvQPC9sg9oYcVjUlGPxS1d8BGbE5rC72YNw6AUe1XUKzmQynYBiqy5rcgOa8FVnsX
         CU9qgTy+hm6CVlVQf4WqH9/6bSxchwhq3XAq0ZHz45e4T/WLzPy66Mp9vERWor8vpa/+
         QqJi+ghMLNMoH/Cd22I+fj7dywLlZBpM/65+J+ixCftbyhco8a0++M3x5b0UgO/wpjFo
         Kz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OAdmCHdS2mn5aVyPYX47j0H9AGuWTMSaF+6ffAnnZ1E=;
        b=S5rdNq8gRa/jxRmBUFaA4H2sX3SjcZZ8uvTuyIyZZTuBbUG+1IMKyjXQ3i12QTCF7r
         Oq/jgQ2KmoRxu9CkGvWMprcgST+29wJ8f5ZDRNs9CnPLjta/O0NdNsJA8PL66Y/IvF4c
         Q8cJImnwulHfu/LwCxcfB6raZHWhlEnv0q6KOdX5ryKn3PZuRoe1dwOWEaxS5gOfN5UD
         Wrg+Y8TdGfSdKhNvcS3B4E4SJvO0aB1bs1zPLIlX38emxp8WZRK7zYPLM8HwQrb77JmS
         pZFwOesQOKAOtQAk5Qb9VpEWdhRx0Ey9iz1abBTkJn/6Q/DF8M7Ehifeq62LuyzX7IGl
         TmEA==
X-Gm-Message-State: AOAM5333fAMc7SQxCHNsjlnCf6bx8YVytgcin0e1OcYn89/JK5m6fwNz
        8mqEbzyK9J1Zg9CWOq+TYlM3OFGjxRM=
X-Google-Smtp-Source: ABdhPJxQjr23rygpQ3vTxhP1ck/YiNy0CP21qCbrIK3gdsci6NI6PaRppDbnDsBXfTiS1PnNEUwwKw==
X-Received: by 2002:a17:906:fc3:: with SMTP id c3mr3574738ejk.474.1610128949968;
        Fri, 08 Jan 2021 10:02:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 00/10] Configuring congestion watermarks on ocelot switch using devlink-sb
Date:   Fri,  8 Jan 2021 19:59:40 +0200
Message-Id: <20210108175950.484854-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In some applications, it is important to create resource reservations in
the Ethernet switches, to prevent background traffic, or deliberate
attacks, from inducing denial of service into the high-priority traffic.

These patches give the user some knobs to turn. The ocelot switches
support per-port and per-port-tc reservations, on ingress and on egress.
The resources that are monitored are packet buffers (in cells of 60
bytes each) and frame references.

The frames that exceed the reservations can optionally consume from
sharing watermarks which are not per-port but global across the switch.
There are 10 sharing watermarks, 8 of them are per traffic class and 2
are per drop priority.

I am configuring the hardware using the best of my knowledge, and mostly
through trial and error. Same goes for devlink-sb integration. Feedback
is welcome.

Vladimir Oltean (10):
  net: mscc: ocelot: auto-detect packet buffer size and number of frame
    references
  net: mscc: ocelot: add ops for decoding watermark threshold and
    occupancy
  net: dsa: add ops for devlink-sb
  net: dsa: felix: reindent struct dsa_switch_ops
  net: dsa: felix: perform teardown in reverse order of setup
  net: mscc: ocelot: export NUM_TC constant from felix to common switch
    lib
  net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
  net: mscc: ocelot: register devlink ports
  net: mscc: ocelot: initialize watermarks to sane defaults
  net: mscc: ocelot: configure watermarks using devlink-sb

 drivers/net/dsa/ocelot/felix.c             | 210 +++--
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  23 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  20 +-
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |  18 +-
 drivers/net/ethernet/mscc/ocelot.h         |   8 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c | 885 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 282 ++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  47 +-
 include/net/dsa.h                          |  34 +
 include/soc/mscc/ocelot.h                  |  54 +-
 include/soc/mscc/ocelot_qsys.h             |   7 +-
 net/dsa/dsa2.c                             | 159 +++-
 14 files changed, 1657 insertions(+), 95 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

-- 
2.25.1

