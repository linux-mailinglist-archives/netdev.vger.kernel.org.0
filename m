Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF501C0FED
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgEAIrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEAIrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B2BC035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so4293509pgl.9
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJPngCR/Ze6ailmvb88DA3u06U0ScAsor5iE6iNKdCE=;
        b=I73Hl9zApEO0pCfwK56ggvOUsbd1FV7Ih/yIHFQvl0jQo/+DOZ2RULUWcZKSa/HwqP
         T89nULEtrFZwP5zTu6MFyMkW9GkzVC34jc4WV9tVDRsk2i47AMlNkUQKfv9YDv30IjN7
         1yOQopUtE4UZ/1rpfGBpz77Q/LOblpIFAhmM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJPngCR/Ze6ailmvb88DA3u06U0ScAsor5iE6iNKdCE=;
        b=Nk2HlTQxKfNuW3uVc9URqV1kf0QYcZi05wce0FP0xna/cF22ALLZInoIviTP3AjkQA
         wT+iElNMBmTL03CXsFbCasEQvgDv3fxB6OaOlxjW7UCpxxPm/Nex/LSdvdX6BawR0QqN
         vin3igrMxISQiDwWIxmrgbCHwmFpw7iwdGLF77IoCFbLPQRzEeGXG+MhwWejRmh6q1bC
         gHBwmd9QdLTtiQ7m8P5sPqui/bbqKK5qOirpaQg+H9yNW2a2Rbnumv55NhXzrk8Np5ci
         oJXmuEoJ/Ytwb6R0skrwX6q6CNDXas4pbEwEf4PiaIOtJraAkVeQwAXHdce9eB0sLhnH
         DQYg==
X-Gm-Message-State: AGi0PuYJog77X1LigkK09H8xAnkZkmPAB1unlrm3xyodlwuK9BXTzmGY
        uOvl75F2JQJps9YowMaBXaHhu9iRqUs=
X-Google-Smtp-Source: APiQypJGu+9HjY3HlMV2TGCYP/1EhkABK8HDO3cNva9KKtSqDx4Egl2qwM+RDiCWhkrKBJW6ZTCWqw==
X-Received: by 2002:aa7:95b2:: with SMTP id a18mr3299115pfk.91.1588322850507;
        Fri, 01 May 2020 01:47:30 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:29 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 0/6] bridge vlan output fixes
Date:   Fri,  1 May 2020 17:47:14 +0900
Message-Id: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More fixes for `bridge vlan` and `bridge vlan tunnelshow` normal and JSON
mode output.

Some column titles are changed, empty lines removed from the output,
interfaces with no vlans or tunnels are removed, columns are aligned.

Changes v2:
* dropped patch 1, "bridge: Use the same flag names in input and output"

Sample outputs with this config:

ip link add br0 type bridge

ip link add vx0 type vxlan dstport 4789 external
ip link set dev vx0 master br0
bridge vlan del vid 1 dev vx0

ip link add vx1 type vxlan dstport 4790 external
ip link set dev vx1 master br0

ip link add vx2 type vxlan dstport 4791 external
ip link set dev vx2 master br0
ip link set dev vx2 type bridge_slave vlan_tunnel on
bridge vlan add dev vx2 vid 2
bridge vlan add dev vx2 vid 2 tunnel_info id 2
bridge vlan add dev vx2 vid 1010-1020
bridge vlan add dev vx2 vid 1010-1020 tunnel_info id 1010-1020
bridge vlan add dev vx2 vid 1030
bridge vlan add dev vx2 vid 1030 tunnel_info id 65556

ip link add vx-longname type vxlan dstport 4792 external
ip link set dev vx-longname master br0
ip link set dev vx-longname type bridge_slave vlan_tunnel on
bridge vlan add dev vx-longname vid 2
bridge vlan add dev vx-longname vid 2 tunnel_info id 2

Before & after:

root@vsid:/src/iproute2# bridge -c vlan
port    vlan ids
br0      1 PVID Egress Untagged

vx0     None
vx1      1 PVID Egress Untagged

vx2      1 PVID Egress Untagged
         2
         1010-1020
         1030

vx-longname      1 PVID Egress Untagged
         2

root@vsid:/src/iproute2# ./bridge/bridge -c vlan
port              vlan-id
br0               1 PVID Egress Untagged
vx1               1 PVID Egress Untagged
vx2               1 PVID Egress Untagged
                  2
                  1010-1020
                  1030
vx-longname       1 PVID Egress Untagged
                  2
root@vsid:/src/iproute2#

===

root@vsid:/src/iproute2# bridge vlan tunnelshow
port    vlan ids        tunnel id
br0
vx0     None
vx1
vx2      2       2
         1010-1020       1010-1020
         1030    65556

vx-longname      2       2

root@vsid:/src/iproute2# ./bridge/bridge vlan tunnelshow
port              vlan-id    tunnel-id
vx2               2          2
                  1010-1020  1010-1020
                  1030       65556
vx-longname       2          2
root@vsid:/src/iproute2#

===

root@vsid:/src/iproute2# bridge -j -p vlan tunnelshow
[ {
        "ifname": "br0",
        "tunnels": [ ]
    },{
        "ifname": "vx1",
        "tunnels": [ ]
    },{
        "ifname": "vx2",
        "tunnels": [ {
                "vlan": 2,
                "tunid": 2
            },{
                "vlan": 1010,
                "vlanEnd": 1020,
                "tunid": 1010,
                "tunidEnd": 1020
            },{
                "vlan": 1030,
                "tunid": 65556
            } ]
    },{
        "ifname": "vx-longname",
        "tunnels": [ {
                "vlan": 2,
                "tunid": 2
            } ]
    } ]
root@vsid:/src/iproute2# ./bridge/bridge -j -p vlan tunnelshow
[ {
        "ifname": "vx2",
        "tunnels": [ {
                "vlan": 2,
                "tunid": 2
            },{
                "vlan": 1010,
                "vlanEnd": 1020,
                "tunid": 1010,
                "tunidEnd": 1020
            },{
                "vlan": 1030,
                "tunid": 65556
            } ]
    },{
        "ifname": "vx-longname",
        "tunnels": [ {
                "vlan": 2,
                "tunid": 2
            } ]
    } ]
root@vsid:/src/iproute2#

Benjamin Poirier (6):
  bridge: Use consistent column names in vlan output
  bridge: Fix typo
  bridge: Fix output with empty vlan lists
  json_print: Return number of characters printed
  bridge: Align output columns
  Replace open-coded instances of print_nl()

 bridge/vlan.c                            | 111 +++++++++++++++--------
 include/json_print.h                     |  24 +++--
 lib/json_print.c                         |  95 +++++++++++--------
 tc/m_action.c                            |  14 +--
 tc/m_connmark.c                          |   4 +-
 tc/m_ctinfo.c                            |   4 +-
 tc/m_ife.c                               |   4 +-
 tc/m_mpls.c                              |   2 +-
 tc/m_nat.c                               |   4 +-
 tc/m_sample.c                            |   4 +-
 tc/m_skbedit.c                           |   4 +-
 tc/m_tunnel_key.c                        |  16 ++--
 tc/q_taprio.c                            |   8 +-
 tc/tc_util.c                             |   4 +-
 testsuite/tests/bridge/vlan/show.t       |  30 ++++++
 testsuite/tests/bridge/vlan/tunnelshow.t |   2 +-
 16 files changed, 210 insertions(+), 120 deletions(-)
 create mode 100755 testsuite/tests/bridge/vlan/show.t

-- 
2.26.0

