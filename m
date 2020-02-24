Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5D169DB2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 06:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgBXF1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 00:27:06 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36851 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgBXF1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 00:27:06 -0500
Received: by mail-pg1-f195.google.com with SMTP id d9so4527060pgu.3
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 21:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=V8pK0khU/RL5LIBP7HFPmkZJcgty09NZXabRn/E72uY=;
        b=AwboZg3SOAtkZO9sGZxsoC2qB+JjVeS6cQ5WVYMxYIBQtSoONMuFzO4095vjwLCoaH
         JVS4EMGISJuiaO4I/OOfS/6FpptVk+3h3RlUC4Z+9FXJE2U+vduJLFTMQYHDWjeKSgQG
         7kI/5Ht0qlppDBkHJPJlKPQAUmYBM4vTsZ6B+nWsE5tODpb2pI9QJ+cb+Tccz5PvkOOV
         N20YMNHTPfABb/QKqNdwtCcIUnr7ZioKIF+8z7TaiGa04gC2EhjXbtvUc5Iq3A2QG9mi
         zBoXuZYIJ80djxeQqDHYb6C5lx5dUBFS2vw6qCMgE6zu8Si537h+OwGvs2yFa519ecxP
         csfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=V8pK0khU/RL5LIBP7HFPmkZJcgty09NZXabRn/E72uY=;
        b=s2zggA9r/P2hcGA5WCjXa0iwCYVP4sQhM5zekeP3+bSTBenPoPNSc+Arsh7LXHibcZ
         /p0Gy8XQyHU+0VEtRwnR9riECtPk/VOOmJFp2Q+3G7G1eZvSeU9IlEz6KErnQj3/o3uH
         G/2rwYDW/Hkzx30lbFBPaaiQRXwPtLYlk7JZl32Ylf61Fo49KOBaDsSbT2HFnGLalW6D
         MBbOa/vLCQA+S7mAHt4ye4ruIPBIPmSfhWa4WCCJs/MUztEaF/n9le7i+k9Q6b2oNzEe
         m41/iX/frLcG/JD8vHX7pVxt3CbZlZKQSjsIE9AC2r6wFAtDxYiYXGTPR6eiS4C/3lSu
         iTIA==
X-Gm-Message-State: APjAAAXIQV/mrQkkDTJfksQoomo9p5jhr8rdW7Z1SBDpnzNhz7nt7e9I
        tgkj9eGyhcjEtUVebufsUs+5pBsfeXY=
X-Google-Smtp-Source: APXvYqw/0G7IceVb1w0KQglyFrQXyowH+Pw4Z1jJ49IoJaGgJZTteykvrHmrfPbhOc3RgAQ5M68qbg==
X-Received: by 2002:a65:6090:: with SMTP id t16mr25430948pgu.2.1582522025371;
        Sun, 23 Feb 2020 21:27:05 -0800 (PST)
Received: from localhost.localdomain ([137.97.103.72])
        by smtp.gmail.com with ESMTPSA id z13sm10360051pge.29.2020.02.23.21.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 23 Feb 2020 21:27:04 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com, eli@mellanox.com
Subject: [PATCH net-next v8 0/2] Bare UDP L3 Encapsulation Module
Date:   Mon, 24 Feb 2020 10:56:56 +0530
Message-Id: <cover.1582518033.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

There are various L3 encapsulation standards using UDP being discussed to
leverage the UDP based load balancing capability of different networks.
MPLSoUDP (__ https://tools.ietf.org/html/rfc7510) is one among them.

The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
a UDP tunnel.

Special Handling
----------------
The bareudp device supports special handling for MPLS & IP as they can have
multiple ethertypes.
MPLS procotcol can have ethertypes ETH_P_MPLS_UC  (unicast) & ETH_P_MPLS_MC (multicast).
IP protocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).
This special handling can be enabled only for ethertypes ETH_P_IP & ETH_P_MPLS_UC
with a flag called multiproto mode.

Usage
------

1) Device creation & deletion

    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847.

       This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
       0x8847 (MPLS traffic). The destination port of the UDP header will be set to
       6635.The device will listen on UDP port 6635 to receive traffic.

    b) ip link delete bareudp0

2) Device creation with multiple proto mode enabled

There are two ways to create a bareudp device for MPLS & IP with multiproto mode
enabled.

    a) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 multiproto

    b) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls

3) Device Usage

The bareudp device could be used along with OVS or flower filter in TC.
The OVS or TC flower layer must set the tunnel information in SKB dst field before
sending packet buffer to the bareudp device for transmission. On reception the
bareudp device extracts and stores the tunnel information in SKB dst field before
passing the packet buffer to the network stack.

Why not FOU ?
------------
FOU by design does l4 encapsulation.It maps udp port to ipproto (IP protocol number for l4 protocol).
Bareudp acheives a generic l3 encapsulation.It maps udp port to l3 ethertype.


Martin Varghese (2):
  net: UDP tunnel encapsulation module for tunnelling different
    protocols like     MPLS,IP,NSH etc.
  net: Special handling for IP & MPLS.

 Documentation/networking/bareudp.rst |  53 +++
 Documentation/networking/index.rst   |   1 +
 drivers/net/Kconfig                  |  13 +
 drivers/net/Makefile                 |   1 +
 drivers/net/bareudp.c                | 804 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/net/ipv6.h                   |   6 +
 include/net/route.h                  |   6 +
 include/uapi/linux/if_link.h         |  12 +
 net/ipv4/route.c                     |  48 +++
 net/ipv6/ip6_output.c                |  70 +++
 11 files changed, 1034 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

