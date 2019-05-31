Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13B73082B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 07:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEaF43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 01:56:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39649 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEaF43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 01:56:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so3542916plm.6;
        Thu, 30 May 2019 22:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cQGRFNj2P1tBrqgD9mS7YGd2tFxDWtDGZgo5qOSp6Cw=;
        b=Scj2G0cyFoJB9DCHpbEox9/Ye+jY//veBbKuwnsg2072IuSFKFvhoy1+tuE1T6CBp8
         57xIQiJ1COCWew2ouUYteCOozH5LmYDs3/rCLD1hv2ru9GLnuoCn9/8cKcqi8bO1wQL4
         HuCPUSbazF7zZM0kxKB8lWvRg5wvBpKG95YiZ6ntnYQTlr5xexwRG1aAHkAXEatSfhjK
         XDEGPblm4tsh9mFEPhUd4dOIQVYg4afJ6Mz1qOG+8vo+jq0tWhUcxkSq9bxuQA07nql+
         2QgtspdLv5ZT8bw4Mzaspgn4x5FxKNAmHFhWGCWus1swjIZBRm4Z2L0lt2wkWJBNgp6F
         8FMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cQGRFNj2P1tBrqgD9mS7YGd2tFxDWtDGZgo5qOSp6Cw=;
        b=pDuNGhlWWFbAXCdpB/g1Gtt18hPPTGYuwwTpcQsfGsESioPG6up3hAZZ4L2JiX+FDS
         wFZzZ0L9rkdkuvVDhQyFKwprXT65CkfQP92e/YpL3PD4JetMNpNXj4l8y4v2e3SwTTDn
         2uvUxkOzY3bPEjs1U1fy9I0V7Q3xD22knk5QCjBM54qfu73rE6lo8tjkOJuleasMQ0rj
         0/vpRAgJvy2BKdvXY9rRVuIZV2VsogLiNRcQAECqGRt8J6/g5hjCm3Dg3UhTNUwOHEj/
         F7HpxBP2YlEP6stCKjuX769OzJj/mcxETP33eP2SGPn1mWPuc3xCDiB7BjLg5ZDqVJht
         EWEQ==
X-Gm-Message-State: APjAAAXu8An3bTWKZD+zsSmlsbAoLbHKl7tQraxJT9vdjm9YhdJ3Hwb7
        goz2PpM0yCy7OOE9gjB1iLvraomT
X-Google-Smtp-Source: APXvYqyNwUOLqtsAGH8DQOlZ0upHw+cwJj+aOgOb0Ihlx+gQ/glypEabsE6Cy2oQxAzDVD8i+Ofoog==
X-Received: by 2002:a17:902:a708:: with SMTP id w8mr6900141plq.162.1559282188531;
        Thu, 30 May 2019 22:56:28 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u2sm4554184pjv.30.2019.05.30.22.56.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 22:56:27 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V5 net-next 0/6] Peer to Peer One-Step time stamping
Date:   Thu, 30 May 2019 22:56:20 -0700
Message-Id: <cover.1559281985.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for PTP (IEEE 1588) P2P one-step time
stamping along with a driver for a hardware device that supports this.

If the hardware supports p2p one-step, it subtracts the ingress time
stamp value from the Pdelay_Request correction field.  The user space
software stack then simply copies the correction field into the
Pdelay_Response, and on transmission the hardware adds the egress time
stamp into the correction field.

This new functionality extends CONFIG_NETWORK_PHY_TIMESTAMPING to
cover MII snooping devices, but it still depends on phylib, just as
that option does.  Expanding beyond phylib is not within the scope of
the this series.

User space support is available in the current linuxptp master branch.

- Patch 1 adds the new option.
- Patches 2-5 add support for MII time stamping in non-PHY devices.
- Patch 6 adds a driver implementing the new option.

Thanks,
Richard

Changed in v5:
~~~~~~~~~~~~~~

- Fixed build failure in macvlan.
- Fixed latent bug with its gcc warning in the driver.

Changed in v4:
~~~~~~~~~~~~~~

- Correct error paths and PTR_ERR return values in the framework.
- Expanded KernelDoc comments WRT PHY locking.
- Pick up Andrew's review tag.

Changed in v3:
~~~~~~~~~~~~~~

- Simplify the device tree binding and document the time stamping
  phandle by itself.

Changed in v2:
~~~~~~~~~~~~~~

- Per the v1 review, changed the modeling of MII time stamping
  devices.  They are no longer a kind of mdio device.


Richard Cochran (6):
  net: Introduce peer to peer one step PTP time stamping.
  net: Introduce a new MII time stamping interface.
  net: Add a layer for non-PHY MII time stamping drivers.
  dt-bindings: ptp: Introduce MII time stamping devices.
  net: mdio: of: Register discovered MII time stampers.
  ptp: Add a driver for InES time stamping IP core.

 Documentation/devicetree/bindings/ptp/ptp-ines.txt |  35 +
 .../devicetree/bindings/ptp/timestamper.txt        |  41 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   1 +
 drivers/net/macvlan.c                              |   4 +-
 drivers/net/phy/Makefile                           |   2 +
 drivers/net/phy/dp83640.c                          |  47 +-
 drivers/net/phy/mii_timestamper.c                  | 121 +++
 drivers/net/phy/phy.c                              |   4 +-
 drivers/net/phy/phy_device.c                       |   5 +
 drivers/of/of_mdio.c                               |  30 +-
 drivers/ptp/Kconfig                                |  10 +
 drivers/ptp/Makefile                               |   1 +
 drivers/ptp/ptp_ines.c                             | 859 +++++++++++++++++++++
 include/linux/mii_timestamper.h                    | 120 +++
 include/linux/phy.h                                |  25 +-
 include/uapi/linux/net_tstamp.h                    |   8 +
 net/8021q/vlan_dev.c                               |   4 +-
 net/Kconfig                                        |   7 +-
 net/core/dev_ioctl.c                               |   1 +
 net/core/ethtool.c                                 |   4 +-
 net/core/timestamping.c                            |  20 +-
 21 files changed, 1289 insertions(+), 60 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
 create mode 100644 drivers/net/phy/mii_timestamper.c
 create mode 100644 drivers/ptp/ptp_ines.c
 create mode 100644 include/linux/mii_timestamper.h

-- 
2.11.0

