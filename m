Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9C71C60F4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEETVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEETVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:21:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11016C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:21:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r26so3612753wmh.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RE9MSCrNeYHcvAgFSLFOH8zHMrbbJlhoM5O5vdjjOWI=;
        b=UXBk8KiZAYW7Db0/mo1Rz802fcSwIs7loK1gdpoQGNuTd26gHSmNagHSe4ADArAscI
         qVUzzxwfNJS9R8Ngb+K5XkcUQclEeJ30X1bYa3Br2QdMlSjJP5RUTS0JpbZ5J7PIHmps
         eKooIUSbx0J826nehdemOLn6ZJkat9TgYUqJh5Juy9Shmx8xt6nRyMybAsIX+qEbcKef
         zeAD1lDg0y6Gq/FjoZLOT2Xc99rEz9gi2POr9gF5O/M4E8v9H2zBI4b51BEGO8l6HtKo
         t/qeA1fgjVwMnzZg6668PcUljqO35ybolUwBRmt4yfTbZIqr0sZjM+kGytACddEEnv7s
         DAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RE9MSCrNeYHcvAgFSLFOH8zHMrbbJlhoM5O5vdjjOWI=;
        b=bZKIIS4/CCrT5dpjEPPhMU/Co/eCjUSp5LXtUT8oKeVbRrCuYSA2UlqwA/M7hpoEJu
         8dsnDuREIij4F5p+gw+uwXs+Xz7vKMrmUU1Nkd7pzya5gt3oHvFb5yNc11n21ydn2xav
         xCDsIrw/IhTOuP4eMj1Fy9gv3srSZiroIy31erdJJmFkH0rGS0F3n8LS8hXlGrwh42OO
         Uf3VAfYlURaxYaQcwjGqtLi3wJnTzw8UDK77tHm8+VqgzFsDlPBFmN+ildzbQEn/d7Tx
         R+/mwZLSIVhejXH64XknqUoklkpOUXC2qwLDkaMVgE6sHII9W972FforpHmXSQQuCXE2
         Hcmg==
X-Gm-Message-State: AGi0PuYo/ZLcs5u505wfMMVcLpRm5yie+xlsbMv2TtnOW3goQjF35QP+
        SZojnAqw2QwcTMw4humTx2NDi+j7
X-Google-Smtp-Source: APiQypJd3GQ5NbIM15b/rzgtaegltBJP826g0DAtMn28PzsAutOFZ+oVrN6I9159UMs8EdTWWyrA7g==
X-Received: by 2002:a1c:9e51:: with SMTP id h78mr100208wme.177.1588706462544;
        Tue, 05 May 2020 12:21:02 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id z16sm5090681wrl.0.2020.05.05.12.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 12:21:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com
Subject: [PATCH v3 net-next 0/6] tc-gate offload for SJA1105 DSA switch
Date:   Tue,  5 May 2020 22:20:51 +0300
Message-Id: <20200505192057.9086-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Expose the TTEthernet hardware features of the switch using standard
tc-flower actions: trap, drop, redirect and gate.

v1 was submitted at:
https://patchwork.ozlabs.org/project/netdev/cover/20200503211035.19363-1-olteanv@gmail.com/

v2 was submitted at:
https://patchwork.ozlabs.org/project/netdev/cover/20200503211035.19363-1-olteanv@gmail.com/

Changes in v3:
Made sure there are no compilation warnings when
CONFIG_NET_DSA_SJA1105_TAS or CONFIG_NET_DSA_SJA1105_VL are disabled.

Changes in v2:
Using a newly introduced dsa_port_from_netdev public helper.

Vladimir Oltean (6):
  net: dsa: introduce a dsa_port_from_netdev public helper
  net: dsa: sja1105: add static tables for virtual links
  net: dsa: sja1105: make room for virtual link parsing in flower
    offload
  net: dsa: sja1105: support flow-based redirection via virtual links
  net: dsa: sja1105: implement tc-gate using time-triggered virtual
    links
  docs: net: dsa: sja1105: document intended usage of virtual links

 Documentation/networking/dsa/sja1105.rst      | 116 +++
 drivers/net/dsa/sja1105/Kconfig               |   9 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |  59 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  51 ++
 drivers/net/dsa/sja1105/sja1105_flower.c      | 215 ++++-
 drivers/net/dsa/sja1105/sja1105_main.c        |  13 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |   2 +
 .../net/dsa/sja1105/sja1105_static_config.c   | 202 +++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  65 ++
 drivers/net/dsa/sja1105/sja1105_tas.c         | 127 ++-
 drivers/net/dsa/sja1105/sja1105_tas.h         |  36 +
 drivers/net/dsa/sja1105/sja1105_vl.c          | 796 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_vl.h          |  72 ++
 include/net/dsa.h                             |   1 +
 net/dsa/dsa.c                                 |   9 +
 17 files changed, 1746 insertions(+), 44 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.h

-- 
2.17.1

