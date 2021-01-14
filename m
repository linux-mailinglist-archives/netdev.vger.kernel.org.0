Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857982F62DE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbhANOQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhANOQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:16:21 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AA6C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:40 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id by27so5826429edb.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YOsfsYCG4KPYbzzxL7WIggy6PjFtADiBQf9hN5Nted8=;
        b=Jp9ijrCnLqlANRMWCkavPGbZXQQ77IUFYV2tzAV7rs6rRpURH/wAyJb9t6e2TfKTso
         Yig3jufTxNTWZgCITi1vVY2mEc0qraPW5sNHWESFSQAd+YLPsfYaJOEKUUUSpdejYCSE
         8C98s+1HscheOwgylsgL52/btjQ3/mwflLqwdsxmT5yzF2ndfInnNIgmZAwAzd1ojHn2
         72WeVJ8sRxozKOrkk9/B9ypHXryeqhQ07pViw7pMNAlESq+Hhnxb/YC/dcgYU+08/wEh
         CWclxE8BXqGpj072XpM+9J3Xyzpq/bAe0A6RhPJkCpELdoaAZ5SbJMvDjNKiiyN308RS
         ldSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YOsfsYCG4KPYbzzxL7WIggy6PjFtADiBQf9hN5Nted8=;
        b=HcixSPXs+3KXJ8D3Jivjwaz+vCLKeG+0ftDJIw6ge8/uGF7tVPF7Ra+n+RiFaBjf7u
         hqzoQmsgubzJk4AxC/RvGFpnpGEpU9LdcNWwL6t88yYKRJOqiSnYLgid9sKOgp5Y9Zb7
         He05A5wy9WzAnkuxJkPqMtvkTLMtYKB88rJQ2J+QOJhK6TJ9mP0i0IityDutQZcFANSR
         Cp5McsFo458BSG2vsPl9tqCVxdVtrQCfqZJugoonHu4Urk+8xychjIy2UgiOaGkabMjN
         /3vT+vEOyAIPKP+b/tJl2cKK4aXLSHCHXlbioRiwpJ3Wf/bcE/6MhT9cr1M9CGxqoKkg
         ibcQ==
X-Gm-Message-State: AOAM533z1dOhvKgbzQ4Ok2S6fEDLdDBBL1ZZGcX8/5iuEJ3A6yhJy4yd
        gIjCpdVIk6GX1s3wCcQ68fo=
X-Google-Smtp-Source: ABdhPJwEQIlPk3caYbQnLQcMdyG7I8e4erXYAldkdyT6/eLuVxV8XoBC9xLhSQCQWVgoD12HAv4rAA==
X-Received: by 2002:aa7:c64e:: with SMTP id z14mr5986433edr.69.1610633739252;
        Thu, 14 Jan 2021 06:15:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 00/10] Configuring congestion watermarks on ocelot switch using devlink-sb
Date:   Thu, 14 Jan 2021 16:15:12 +0200
Message-Id: <20210114141522.2478059-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

 drivers/net/dsa/ocelot/felix.c             | 205 ++++-
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  23 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  20 +-
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |  18 +-
 drivers/net/ethernet/mscc/ocelot.h         |   9 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c | 885 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 206 ++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 146 +++-
 include/net/dsa.h                          |  34 +
 include/soc/mscc/ocelot.h                  |  55 +-
 include/soc/mscc/ocelot_qsys.h             |   7 +-
 net/dsa/dsa2.c                             | 159 +++-
 14 files changed, 1664 insertions(+), 108 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

-- 
2.25.1

