Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973AD1986B3
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgC3VjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43805 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgC3VjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id m11so17632089wrx.10
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iprdHRmHEFhB5+6oGi6JZGOP3iYa/OFSgpkWsrEXEHI=;
        b=nS5t8z3jS/Wp1DaAqiuHW24Xje20j8Fq7BzRgQaEIcbdJ4oVSiHjVCIybamxQOwHqP
         tZJHf/1MQoYipTFE8J/OaDZ9GWa7/e6Je7stTn4O/Ojxins1sDOjgbwatXkei5q4i8Qg
         24fBKzwHLSIquWCRc0JvRHL/zq/3+6e7jzK19KV1FD6TmhXqgjAXoZyVmF9TDZR1GH2Y
         Gg/ffnwnf42acyR6PU7ER8wquDL4atHLC+FanASazsXG6gZE23A/uaE/JQzA4ZwedjIa
         fGJcGulcAj6yJJgT1cq3pwNwAeNm7fi0WrINYGT78tPAtmTigwYhx3USG6sS3hBT/K2X
         wk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iprdHRmHEFhB5+6oGi6JZGOP3iYa/OFSgpkWsrEXEHI=;
        b=eTPMvd6UPhPkB+y1IVne1+5wiWvlVo2xC3gfo0i1tVLLGIzi/OHny/3Cqbe/O8ZL1W
         4fTPueSOi+L4ILPxIAtePUW95agpyQWof8hwwkacH5aUd/LlTCkm+8lfVO+wVTNB8DAO
         gbv9Xkt5COUeLkJfDrfJGeeQUaRtmgTkWaQlKDFtK09ErFrzVBxYzLruiSNaVRsIaj87
         jPKqrYr1qgiUV8OjzTkXo54disWHBPINGwH5aXWAiKQcNeJ8Utmu35xPibUUkQpkPVX3
         PQO9Q8f4m5K9cJMGNl53szBc+fNDPKjreK7ICYW0GFOytXfQ2nsLvxxvGa9wsUQ7+mIU
         wA3w==
X-Gm-Message-State: ANhLgQ1PfepGZ1v3ps44v9PjuphYmz3ajDXFJ/3REuQVYrgr5NHJ7fmE
        LVCcl03S4qclNMgzCQGzyhqmTJ+I
X-Google-Smtp-Source: ADFU+vtUfoapGn1ZHb92wVT37qhXq9gIkx4Ee/mNfdCGxbn4rH+hIvv5wBjyYetYEIJjNCpMwQ4pWw==
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr16004575wrw.243.1585604339888;
        Mon, 30 Mar 2020 14:38:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:38:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 0/9] net: dsa: b53 & bcm_sf2 updates for 7278
Date:   Mon, 30 Mar 2020 14:38:45 -0700
Message-Id: <20200330213854.4856-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Andrew, Vivien,

This patch series contains some updates to the b53 and bcm_sf2 drivers
specifically for the 7278 Ethernet switch.

The first patch is technically a bug fix so it should ideally be
backported to -stable, provided that Dan also agress with my resolution
on this.

Patches #2 through #4 are minor changes to the core b53 driver to
restore VLAN configuration upon system resumption as well as deny
specific bridge/VLAN operations on port 7 with the 7278 which is special
and does not support VLANs.

Patches #5 through #9 add support for matching VLAN TCI keys/masks to
the CFP code.

Changes in v2:

- fixed some code comments and arrange some code for easier reading

Florian Fainelli (9):
  net: dsa: bcm_sf2: Fix overflow checks
  net: dsa: b53: Restore VLAN entries upon (re)configuration
  net: dsa: b53: Prevent tagged VLAN on port 7 for 7278
  net: dsa: b53: Deny enslaving port 7 for 7278 into a bridge
  net: dsa: bcm_sf2: Disable learning for ASP port
  net: dsa: bcm_sf2: Check earlier for FLOW_EXT and FLOW_MAC_EXT
  net: dsa: bcm_sf2: Move writing of CFP_DATA(5) into slicing functions
  net: dsa: bcm_sf2: Add support for matching VLAN TCI
  net: dsa: bcm_sf2: Support specifying VLAN tag egress rule

 drivers/net/dsa/b53/b53_common.c |  29 +++++++
 drivers/net/dsa/bcm_sf2.c        |  10 ++-
 drivers/net/dsa/bcm_sf2_cfp.c    | 139 ++++++++++++++++++++++---------
 3 files changed, 136 insertions(+), 42 deletions(-)

-- 
2.17.1

