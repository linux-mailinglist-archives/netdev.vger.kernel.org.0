Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1E195F56
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgC0Tzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:55:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52239 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0Tzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:55:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id z18so12766269wmk.2
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HlSSvWudQIKVm3GXbLT6JxSimcra+Y+tImSSAaf8xKg=;
        b=U8YtXlNaXfKndKIE/WuhkXT7AnxtN+hH1ktZ06Lxc2SuVLReiKvrLr1cSSQjKCp3EL
         YRvgxOsNdHMdh/pr21JEd5z/WxaGIiCUXMMMiJRW6ALpbwhLwIs4WcSB7ZhsLjUl/Mn9
         pKjA8agNwHeoq6d6+zTlASD8L62uJ8RG6F5AzpJw3ssoRAoy2QWbQzJlem7doybGpDUQ
         89k4Z5OyCoNM5pVBdoO9U6vP5qO9QsxJXV1bj2oqVE1uonB4jkQbRYjTlJjI8rSDKdY6
         QIJ0tExVTy/geYV/RcipepCWiFAPqYUF/zPom54PvMatyOd4GonGLFua6NlQtFFsn1pP
         1fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HlSSvWudQIKVm3GXbLT6JxSimcra+Y+tImSSAaf8xKg=;
        b=rqApQYy1kgllvtsJdT9I8oNpkJhIUn156JUMqMqw78q+31S/kT7V7mtpI1C3RJXxb5
         0fE97vLNu2H8a9l6SVvQcrjI2qYYImPXVNdANIygGDvCXiPCuGfzCrhBi+aiRpbp36+C
         t6mQh2o/4fXpq7Bigtv+wZgG4tXLfmahg/2AXqCjza/NR7XC44Z89kcLTZXiM8BRavQt
         XKYx7GB5e8YNpuRGr0I3YrEwMZ+7hjoXWKtGhuCfmVuNbCb4iVTNihVobWXIpX8bqitm
         gtBTmQUfRKwLktt5mXImP6KKuil76761JpunMBspEqb7MWG9/dEjCboQO1MnZbBTZch9
         6xnQ==
X-Gm-Message-State: ANhLgQ3HppnKUrZMkO1u4Q4ZjVq7N5T9BtFGy61i4G+Mo2lI5sNDOxW5
        C4msxABYb+45byARQK8OV6E=
X-Google-Smtp-Source: ADFU+vseW4wCVCL80PMKBrahiRPp6xFArLxJthncM9m6AxgT9f/K12c21BIF1aQSsTmv6G9aD9Nchw==
X-Received: by 2002:a7b:c08a:: with SMTP id r10mr390593wmh.120.1585338952281;
        Fri, 27 Mar 2020 12:55:52 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:55:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 0/8] Configure the MTU on DSA switches
Date:   Fri, 27 Mar 2020 21:55:39 +0200
Message-Id: <20200327195547.11583-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for configuring the MTU on front-panel switch
ports, while seamlessly adapting the CPU port and the DSA master to the
largest value plus the tagger overhead.

It also implements bridge MTU auto-normalization within the DSA core, as
resulted after the feedback of the implementation of this feature inside
the bridge driver in v2.

Support was added for quite a number of switches, in the hope that this
series would gain some traction:
 - sja1105
 - felix
 - vsc73xx
 - b53 and rest of the platform

V3 of this series was submitted here:
https://patchwork.ozlabs.org/cover/1262394/

V2 of this series was submitted here:
https://patchwork.ozlabs.org/cover/1261471/

V1 of this series was submitted here:
https://patchwork.ozlabs.org/cover/1199868/

Murali Krishna Policharla (3):
  net: phy: bcm7xx: add jumbo frame configuration to PHY
  bgmac: configure MTU and add support for frames beyond 8192 byte size
  net: dsa: b53: add MTU configuration support

Vladimir Oltean (5):
  net: dsa: configure the MTU for switch ports
  net: dsa: implement auto-normalization of MTU for bridge hardware
    datapath
  net: dsa: sja1105: implement the port MTU callbacks
  net: dsa: vsc73xx: make the MTU configurable
  net: dsa: felix: support changing the MTU

 drivers/net/dsa/b53/b53_common.c       |  27 ++-
 drivers/net/dsa/ocelot/felix.c         |  19 +++
 drivers/net/dsa/sja1105/sja1105.h      |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c |  50 +++++-
 drivers/net/dsa/vitesse-vsc73xx-core.c |  30 ++--
 drivers/net/ethernet/broadcom/bgmac.c  |  12 ++
 drivers/net/ethernet/broadcom/bgmac.h  |   5 +-
 drivers/net/ethernet/mscc/ocelot.c     |  45 +++--
 drivers/net/phy/bcm-phy-lib.c          |  22 +++
 drivers/net/phy/bcm-phy-lib.h          |   1 +
 drivers/net/phy/bcm7xxx.c              |   4 +
 include/linux/brcmphy.h                |   2 +
 include/net/dsa.h                      |  16 ++
 include/soc/mscc/ocelot.h              |   7 +
 net/dsa/dsa2.c                         |   2 +-
 net/dsa/dsa_priv.h                     |  15 ++
 net/dsa/master.c                       |  21 +--
 net/dsa/port.c                         |  13 ++
 net/dsa/slave.c                        | 219 ++++++++++++++++++++++++-
 net/dsa/switch.c                       |  37 +++++
 20 files changed, 500 insertions(+), 48 deletions(-)

-- 
2.17.1

