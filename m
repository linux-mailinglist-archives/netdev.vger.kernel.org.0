Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645352F7062
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbhAOCM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbhAOCM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:12:28 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991E4C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:47 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id 6so11163517ejz.5
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5SUS+DYqrVcWhK2lnZoN34JJeLU1z0H9SAPfzFhjQA=;
        b=sd3vfpdg8pm8abSTPrU9+CUaEazNHfr7x4w32licZadi94U6w6McGdIpSntRXgQLlR
         0rt4AE1ccAntcRnsAUPkG1eRdYqAYxTlVNfOiXMQm9x/Eb5jbFZh+5bBpNiz+1wA4cTa
         xrr6qhG9pVdFULvXc4CmhkZThMXDK4gp6XzftHUioX3oh+APpUrtBCRlscoR1L0ru9TG
         eioSaHce3oPm0QnneaLOpxDpAFTSMlIalYbnDpeea8s6c4a/Kz2+4Sr6qA0BNqKgw1n9
         RXYJgKwa612SPMxstOmZJ2kyvA3OkqWEUSPZBowHE/iuxf336gb8f1UUzXUG4JcdhujZ
         uB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5SUS+DYqrVcWhK2lnZoN34JJeLU1z0H9SAPfzFhjQA=;
        b=eGGusw6KsSDyiHi5UmigHNmOCdSnbM/luUAdsVlVDhFh77TQC6cef/2CvUtQfxgUOw
         bfdkU+xeWZ5IFCn8A3JbLojmmd95A+jmPEiAfdXA6eg4PV39h0qsmkVu/DoQedSAGSqS
         QA8RL5JvpXFwG2Tj7Eof9odQbp2Zqn+9bmYh0cUREUF1HIZbTHoDmqf+R7hNZbs3s/ba
         IJkX3gIxK8RUHe60pYQBQzq2u5J4/aktjbbgikT5dGLACo7sNPA889BPuozMwCXUC4t9
         9swXgZldGEZ9vUFfinn0Jp1/xswESX8meW1lphgTRKtYjqhaQL7RsM5hNcpIzy+7RVk7
         WV0Q==
X-Gm-Message-State: AOAM530b/2CPAvQEsfCImd5oi/gfQaUsqfb4UW6xRPUW63Vw+jsvNFWA
        tLAibDZ1apnhqxbyMjM526I=
X-Google-Smtp-Source: ABdhPJyfpWoygHMJ3U73GshfEhfTWt9Rg39kX+361ZmC0jT4BUFxwoVZjn3Qwnlyheyw1USxuIoA5Q==
X-Received: by 2002:a17:906:31cb:: with SMTP id f11mr7468093ejf.468.1610676706351;
        Thu, 14 Jan 2021 18:11:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 00/10] Configuring congestion watermarks on ocelot switch using devlink-sb
Date:   Fri, 15 Jan 2021 04:11:10 +0200
Message-Id: <20210115021120.3055988-1-olteanv@gmail.com>
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

 drivers/net/dsa/ocelot/felix.c             | 205 ++++-
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  23 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  20 +-
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |  18 +-
 drivers/net/ethernet/mscc/ocelot.h         |  10 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c | 885 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 206 ++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 143 +++-
 include/net/dsa.h                          |  34 +
 include/soc/mscc/ocelot.h                  |  55 +-
 include/soc/mscc/ocelot_qsys.h             |   7 +-
 net/dsa/dsa2.c                             | 159 +++-
 14 files changed, 1662 insertions(+), 108 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

-- 
2.25.1

