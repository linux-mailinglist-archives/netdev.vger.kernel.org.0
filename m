Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C88194BA6
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCZWlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:41:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38789 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZWlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:41:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id f6so3442819wmj.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7GjfuVWE6pe/5T94lJeKw2bc8fiAlXra4gpuV7vCwN4=;
        b=I6fwoucigIVt7np3JwCrGtxiCVOKdITB/+NyWWCxSR7AwRah8qkMGU+WhTx0Zh22cY
         wTYUF5JvFjMEIWlV/+X8ibOOLlX6iM/wwBcDBDPyuo5u6sRAOGkpWczn0U7woepxRXvF
         7UNPLhlQ/zl8DDryA/rnynEasYi+rJZWvzaXD7fwWOuCGOVcspe2wPNYFIZhnDHnAGSW
         vbtr8OREDxlnePsaxakfJhMzVWZyRbJ4Qo8CV1daJs/p3YVTl+j1LM/oVeEKEMhonG/z
         fjLhq9d8uUg986HX/3YHa86LDaxkZqrIwIME1gT+5/lfZI6eiayV74iDZ8DBqYBcgJ+j
         fRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7GjfuVWE6pe/5T94lJeKw2bc8fiAlXra4gpuV7vCwN4=;
        b=ByK4dlery8n/jGbB4gIhao1UJxbeWwpJpjQYraF5bl//35ov7HNj5ieQJ1bYZyAXaw
         Cfo+9kSujo4KIln/y+UeB4/YVgbAehmepgrLY4FS96q9w9a6Zs4b90g9IGuar6c1nWp3
         nGV4MbDX/XTOEHnsJB1lGznktV3ONzFLubeyiaEKpaiPnbxf9smkf57RQ4SSR4w/67nv
         5Yc6DFiHzj9iIwlEAplX5GnorndT8KIGW+/EvEQC/isNxd6oWPD1RDcJIcRqxciXVvrV
         +jwLF+IsOYxPqNFyVRpYNa7unWnGJSrj9TRL6gsoFTvhn7M/2uvvcCG+qUAddIoWs8Q1
         Qyqg==
X-Gm-Message-State: ANhLgQ33rBH6GkEGG36nBf+Xaj81RbEFY1gHNCaXhIZoUMp/EoVnGsPj
        ZQZl8NCKtWI70wnESFCdmK4=
X-Google-Smtp-Source: ADFU+vtZn210UeakTyn/Um66ovNOwlCalor8tCS95c+S/tZHIRxVXUjdbNuv0+/qmQ4bFrq3eXM3wA==
X-Received: by 2002:a7b:cd89:: with SMTP id y9mr2310699wmj.142.1585262462090;
        Thu, 26 Mar 2020 15:41:02 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t81sm5522783wmb.15.2020.03.26.15.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 15:41:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 0/8] Configure the MTU on DSA switches
Date:   Fri, 27 Mar 2020 00:40:32 +0200
Message-Id: <20200326224040.32014-1-olteanv@gmail.com>
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
 net/dsa/master.c                       |  23 +--
 net/dsa/port.c                         |  13 ++
 net/dsa/slave.c                        | 219 ++++++++++++++++++++++++-
 net/dsa/switch.c                       |  37 +++++
 20 files changed, 502 insertions(+), 48 deletions(-)

-- 
2.17.1

