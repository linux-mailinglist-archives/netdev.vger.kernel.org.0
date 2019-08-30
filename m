Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B8EA2BE6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbfH3Axf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:53:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54289 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfH3Axf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:53:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id k2so4066086wmj.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fpie0LVs3JvkthYMwpH8W4HcaDPyVptXJ2Sag9vYk6o=;
        b=IFIVPtl/NsqoGHDO/kb//XOddmp/Xtb/MTqT9FB7ySW8MgM5gP7NvUkRIEiIW8MKmd
         X2l+TEfr7D2afC4BGEYf9F1cHql9zicj7UAaBRj6g2dJXO//bvNrc7KlAa7siENt72vd
         pScAdXewwN4HQaYu/DKNinWytQS3+Ffsr0Z586QB8p3/Nz2DPvUA4znSEvwrf7vG9u4v
         9+jddvxXfBftIOZYrpd8aAnccz29ekHzGRm+52gg826HfraZIxfxkdM2qwt2mpQIvxRf
         fuGnON1nvOl8jKp6zGAq6j9T5v/oOUb8UT6dg8QIqjt6PEb6aKIZblpNCWz9LEnLAPvf
         CzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fpie0LVs3JvkthYMwpH8W4HcaDPyVptXJ2Sag9vYk6o=;
        b=rKN2fYlURGoVR59w2JSMpsdf3UOztOUobD3bvbwhc6+tBIVf4Z73D5ELlShT+gyBIj
         0YTb6QIFD+yedvlAIn6AZQ7DePfmPkLjTV8O55EiHz09lT0OnismVR+uQx8HXkYoqQXJ
         wqcOw9BBiVZ26bNVzvMbsZHFEtrkFbBU16quqintWHsUqDsxQ4r9rvPLwIVOCD3jrX1J
         FquTsxjSSO/fBotXbexw8iBEYR2IzACIfTBrKbXN717O3DMKw1nxVEYyK6fcMXZ2i/HO
         l1h6KJFr3bh+zHhZgQQXR+I/Mxr6sKdetp2WrhRBuPoz5gbqWPUvHxg10QNRPjG8Lru3
         5qfQ==
X-Gm-Message-State: APjAAAV0DeLIq1xQoHFzeWkvLMHhDHqURSBvelEIQ76BD3YvmqEeAh+A
        YtPyDoZPPMEvTRjODyNh3fc=
X-Google-Smtp-Source: APXvYqyB2pDp6I7pEYU69fihYUJBga6WRJ6aYKjbS5zGsO4JHVBnX3Gt8zJUZZ3osOVLE6cOdzfbwA==
X-Received: by 2002:a7b:cf2d:: with SMTP id m13mr14613464wmg.120.1567126413063;
        Thu, 29 Aug 2019 17:53:33 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id w7sm4691669wrn.11.2019.08.29.17.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:53:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 0/2] Dynamic toggling of vlan_filtering for SJA1105 DSA
Date:   Fri, 30 Aug 2019 03:53:23 +0300
Message-Id: <20190830005325.26526-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset addresses a limitation in dsa_8021q where this sequence of
commands was causing the switch to stop forwarding traffic:

  ip link add name br0 type bridge vlan_filtering 0
  ip link set dev swp2 master br0
  echo 1 > /sys/class/net/br0/bridge/vlan_filtering
  echo 0 > /sys/class/net/br0/bridge/vlan_filtering

The issue has to do with the VLAN table manipulations that dsa_8021q
does without notifying the bridge layer. The solution is to always
restore the VLANs that the bridge knows about, when disabling tagging.

Vladimir Oltean (2):
  net: bridge: Populate the pvid flag in br_vlan_get_info
  net: dsa: tag_8021q: Restore bridge VLANs when enabling vlan_filtering

 net/bridge/br_vlan.c |   2 +
 net/dsa/tag_8021q.c  | 102 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 84 insertions(+), 20 deletions(-)

-- 
2.17.1

