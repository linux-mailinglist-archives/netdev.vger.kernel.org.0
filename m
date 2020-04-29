Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649AF1BE398
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgD2QT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2QT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:19:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B10C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:19:58 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so2677529wmh.3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NdSk54qfi3ZCMHgRSOUOC81zXRS/IGM9oQqQNQ6lwdY=;
        b=NgUp2RUup+3th55kyNbO4O1lVtL6YM8ZTv2JB8kVqraxlJV4HpK7jznzCFynpYO1ms
         sRwfi9DWeQEyc/QKiQgWd2AoqL7bbfmLaRlP96ILu8WYVGBZwgsD1coqy0oHuCfYApeR
         ip5xWTwUv8kJ1IfuqF72QE6SD5PmqP/NAP5XDT9+mCdjHQfJhC2fxOkDiFbXV5zPbJ0b
         HAngkEtuCxZXTr4YL8XaYsoLoWLsV7gmtKjEcEGzbxuBrVJRTg4uHahzl3xuiBS9SnrF
         dr/bswzWQCttA3zTHeeat3/ZNd7VaLGAOtAuCItq6gkXdHdvMVH7NABNXqK58QWERhTK
         ddHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NdSk54qfi3ZCMHgRSOUOC81zXRS/IGM9oQqQNQ6lwdY=;
        b=nmtYYtjtxrsdOzltS0wo1ME9v19rrImdSsmk4UXaOlDq9ETkykazpx0F2F8QPfW1K5
         vfGYA9sgwrg32cv1HawRk8+WkPv3JnoCIwQweZZ77ffRFTuSlKkxPTflfgpZBCm4j/oV
         tOauFE27GsylydOJbxIsT2gwyVGZkg3rrbnwLLKIKHBrfpFrF/CgmCZ5x7LnEejKKhD8
         vR7FtewUWRoSAX1FrC82IE+hwVZIAejqn35JznR+lpJjEbHrPdHthCwOUgYkGtx7SsSu
         sTJhqbGaOW/tJD2MIll2tRIZkZTkpbe1tKZuQiP8xyn1D9TAOLAVYX928QG7CA6KGuWV
         x07w==
X-Gm-Message-State: AGi0PuY/21RjPP7aKSGu6QXnKkthGxJzjWt9PN9kv9lj4sbgHYH7DbPN
        qZYphYfA4C2wuVGHJg9A8aUjirWg
X-Google-Smtp-Source: APiQypLkJHuaq/TFHqjLxl+QAM6/jzgb/qJE98FDCjIZpCwrN9+T7+irvnRq2BTmhfZaXSxXbxkWTA==
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr4217262wmj.34.1588177196905;
        Wed, 29 Apr 2020 09:19:56 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r18sm28132609wrj.70.2020.04.29.09.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 09:19:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com
Subject: [PATCH net-next 0/4] Cross-chip bridging for disjoint DSA trees
Date:   Wed, 29 Apr 2020 19:19:48 +0300
Message-Id: <20200429161952.17769-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for boards where DSA switches of multiple types
are cascaded together. Actually this type of setup was brought up before
on netdev, and it looks like utilizing disjoint trees is the way to go:

https://lkml.org/lkml/2019/7/7/225

The trouble with disjoint trees (prior to this patch series) is that only
bridging of ports within the same hardware switch can be offloaded.
After scratching my head for a while, it looks like the easiest way to
support hardware bridging between different DSA trees is to bridge their
DSA masters and extend the crosschip bridging operations.

I have given some thought to bridging the DSA masters with the slaves
themselves, but given the hardware topology described in the commit
message of patch 4/4, virtually any number (and combination) of bridges
(forwarding domains) can be created on top of those 3x4-port front-panel
switches. So it becomes a lot less obvious, when the front-panel ports
are enslaved to more than 1 bridge, which bridge should the DSA masters
be enslaved to.

So the least awkward approach was to just create a completely separate
bridge for the DSA masters, whose entire purpose is to permit hardware
forwarding between the discrete switches beneath it.

Florian Fainelli (1):
  bridge: Allow enslaving DSA master network devices

Vladimir Oltean (3):
  net: dsa: permit cross-chip bridging between all trees in the system
  net: dsa: introduce a dsa_switch_find function
  net: dsa: sja1105: implement cross-chip bridging operations

 drivers/net/dsa/mv88e6xxx/chip.c       |  16 +++-
 drivers/net/dsa/sja1105/sja1105_main.c | 122 +++++++++++++++++++++++++
 include/net/dsa.h                      |  11 ++-
 net/bridge/br_if.c                     |   4 +-
 net/bridge/br_input.c                  |   4 +-
 net/dsa/dsa2.c                         |  21 +++++
 net/dsa/dsa_priv.h                     |   1 +
 net/dsa/port.c                         |  23 ++++-
 net/dsa/switch.c                       |  21 +++--
 9 files changed, 203 insertions(+), 20 deletions(-)

-- 
2.17.1

