Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB3E1CE546
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731619AbgEKUVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:21:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA63C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j5so12640536wrq.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6rFEKMlnsiOScrDOzYNv+p8C8DeDvKotLBfTYLf6KPI=;
        b=IRo98Ly5CyvHIQiaDGkErPgFz5V/x30LJzTrVynXrHZgCmEuSiOnU5u3FMw32qp0xJ
         z6OaT+jDp2PfmYcluxuqZP5/m4ESWeVlxSJpLUwfrLbSWfUhn8P66WgplAnuIlF308dJ
         ixi4mEyBOFC0144P7tITt1oqwntsaflOiZ2Q81MPjXbFQeAkdOylQaLLneuVb7+4EXPh
         gqrqi/X2Ya8fRxWwBPuwcQMKMK86dXIyzS2TJGHHFHu5JFBjdHCpEVcwA2URMw/7R2ER
         Zrtm7ac4VXKA9MY2ZCTYAOI9gEtK2VGjkApeSpxQ6xvOD6r8Ic/ArSlKDHht/KdPQngv
         DKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6rFEKMlnsiOScrDOzYNv+p8C8DeDvKotLBfTYLf6KPI=;
        b=B30tQlucwyEebX63l2kdYS6019ZmmK4z0375dMNV9yMUHsOm8Z+7iPGG2L7+C9VrQX
         c89ZWmCuj4G13Cd2b5gp1UmCBcXSCZSfu0SXhHeL7NhBRXyf9ZlMjQgYhoz/Mm/sz1CP
         pCIzEXKxOcx/FD1wHy6rltkA8v/XS/Uwh5SoPpIyAWcb5vTT93rqSGtHtn6JUqYTMDYR
         WHcwjHIEuOmOtHZ4sL9JTGb9VF7n6XBePxQiX8H6ci/UTbMq1tXS1ONoyHWVQNU0+nyN
         dBJ6bij6+6R+S8wXYk86/G1cj/FvIsxCU1zsGpXfBBe/iPboOmmVhLAOFLk7LGjDk+ZC
         M+cA==
X-Gm-Message-State: AGi0Pub5GXyS7zyNDWq2LUy9QlzqDR2lga3476vHjElouFnFrrA/DbNG
        9jvbxeddLvCzZM70lN+EGUZ6Z6Vx
X-Google-Smtp-Source: APiQypJpMPIUHkMgSFW1r+eiG3bvDFEJ2p0YJpmlJSz4CmPtCUWQM11teJgdTOrzQIYHMF+NOJlIog==
X-Received: by 2002:adf:db4c:: with SMTP id f12mr13630135wrj.387.1589228459562;
        Mon, 11 May 2020 13:20:59 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 77sm19811305wrc.6.2020.05.11.13.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:20:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code
Date:   Mon, 11 May 2020 23:20:42 +0300
Message-Id: <20200511202046.20515-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The initial purpose of this series was to implement the .flow_dissect
method for sja1105 and for ocelot/felix. But on Felix this posed a
problem, as the DSA headers were of different lengths on RX and on TX.
A better solution than to just increase the smaller one was to also try
to shrink the larger one, but in turn that required the DSA master to be
put in promiscuous mode (which sja1105 also needed, for other reasons).

Finally, we can add the missing .flow_dissect methods to ocelot and
sja1105 (as well as generalize the formula to other taggers as well).

Vladimir Oltean (4):
  net: dsa: allow drivers to request promiscuous mode on master
  net: dsa: sja1105: request promiscuous mode for master
  net: dsa: tag_ocelot: use a short prefix on both ingress and egress
  net: dsa: implement and use a generic procedure for the flow dissector

 drivers/net/dsa/ocelot/felix.c         |  5 ++--
 drivers/net/dsa/sja1105/sja1105_main.c |  3 ++
 include/net/dsa.h                      | 13 +++++++++
 net/dsa/dsa_priv.h                     | 22 +++++++++++++++
 net/dsa/master.c                       | 39 +++++++++++++++++++++++++-
 net/dsa/tag_ar9331.c                   |  9 ++++++
 net/dsa/tag_brcm.c                     |  5 ++--
 net/dsa/tag_dsa.c                      |  4 +--
 net/dsa/tag_edsa.c                     |  4 +--
 net/dsa/tag_lan9303.c                  |  9 ++++++
 net/dsa/tag_mtk.c                      |  3 +-
 net/dsa/tag_ocelot.c                   | 29 +++++++++++++++----
 net/dsa/tag_qca.c                      |  3 +-
 net/dsa/tag_sja1105.c                  | 13 +++++++++
 14 files changed, 143 insertions(+), 18 deletions(-)

-- 
2.17.1

