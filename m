Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A6DFC5B0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfKNLwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:52:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42055 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNLwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:52:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id s5so4070791pfh.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 03:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=lRjeNlv6a3fUWGiiKJCxmbfheR1iGPEtE+GRaDdZ678=;
        b=cLDr9ar8QB3xFFkOzpxFWbOh23F8DoxS0x3nrfjgcU/8kmDSCZE5H5K/gHwZY2ajTa
         nqXzpTORntEGU47xlQkydX9BvsAiRsJyqEW/tUnkKFeUfHHRT8BMhlE+kBv83qEr+um2
         Q0hluIzbzI+Z1U/uSeabnhw7hzbuJTIwCEfT6VyAoPsUMY7hOG3q1oHdqvHc9rPNqRJu
         KoCsbqn+Nti3qMd2OASDF01DrY/I9iBJoKuqyQrqicB7Gu6VxcFpcdmraDffT2vwnNW+
         es9x59IDgNQEaYrfpprd0cUOiHMrne4HkPvdUDmPEtXWL1B8wwvtembz9ncwg8ZK1Fiz
         kB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=lRjeNlv6a3fUWGiiKJCxmbfheR1iGPEtE+GRaDdZ678=;
        b=SNM7z6doQe+y7MtspUPiU2paoxq4ffoM6UdcwhswnWImkunlwi/35hoP9l96p4roK4
         r+muReg1sVUfNsB364HkFPDS4R+0HeEOwN3K9Mag3uzraCyrke8VZJLWegzTv7kJ1bMW
         cGqc6mLX+G5UI8ygmuuODoNgK34NF1Too1kW3RZMy1fIEf1wM2BQDweKOEgcK7mqHPjl
         +4ayDfbQ/KFbHReIstJNVVzdu0h1r8TZZDMaJXpsOlNb0cVWBzhY7GkMx0O4HmadYrDo
         6cz1qn+cSfLJoRPHdpBWVoPPGvn06C7I0pOff4rH9yahfxmAWfvOfofut474WVhr02x/
         bp4w==
X-Gm-Message-State: APjAAAXNYETdWfhleHQNs6CCj7cMLVhbbnYSC09vNxj8eC/QzzGG+v1R
        unxAsXsARNZRMr32OBko82eyBOps
X-Google-Smtp-Source: APXvYqxb3JXUDWoELCeDCO4q67yteKmfoNQjaGYck/7A/wUXBAqZsv8GdKq6mktWGXpWq2Djwcb8tg==
X-Received: by 2002:a17:90a:1:: with SMTP id 1mr12300833pja.42.1573732337919;
        Thu, 14 Nov 2019 03:52:17 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id q70sm10085748pjq.26.2019.11.14.03.52.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 03:52:17 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH v2 net-next 0/2] Bare UDP L3 Encapsulation Module
Date:   Thu, 14 Nov 2019 17:22:08 +0530
Message-Id: <cover.1573659466.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

There are various L3 encapsulation standards using UDP being discussed to
leverage the UDP based load balancing capability of different networks.
MPLSoUDP (https://tools.ietf.org/html/rfc7510) is one among them.

The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
a UDP tunnel.

Special Handling
----------------
The bareudp device supports special handling for MPLS & IP as they can have
multiple ethertypes.
MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8848 (multicast).
IP proctocol can have ethertypes 0x0800 (v4) & 0x86dd (v6).
This special handling can be enabled only for ethertype 0x0800 & 0x8847 with a
flag called extended mode.

Usage
------

1. Device creation & deletion

a. ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847

This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
0x8847 (MPLS traffic). The destination port of the UDP header will be set to 6635
The device will listen on UDP port 6635 to receive traffic.

b. ip link delete bareudp0

2. Device creation with extended mode enabled

There are two ways to create a bareudp device for MPLS & IP with extended mode
enabled.

a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1

b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls

Why not FOU ?
------------
FOU by design does l4 encapsulation.It maps udp port to ipproto (IP protocol number
for l4 protocol).

Bareudp acheives a generic l3 encapsulation.It maps udp port to l3 ethertype

For example in the case of MPLS -

In the egress direction an MPLS packet  "eth header | mpls header | payload" is
encapsulated to "eth header | ip header | udp header | mpls header | payload"

In the Ingress direction the udp tunnel packet
"eth header | ip header | udp header | mpls header | payload" is decapsulated to
"eth header | mpls header | payload"


Martin Varghese (2):
  UDP tunnel encapsulation module for tunnelling different protocols    
    like MPLS,IP,NSH etc.
  Special handling for IP & MPLS.

 Documentation/networking/bareudp.rst |  44 ++
 Documentation/networking/index.rst   |   1 +
 drivers/net/Kconfig                  |  13 +
 drivers/net/Makefile                 |   1 +
 drivers/net/bareudp.c                | 876 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/net/ip6_tunnel.h             |  45 ++
 include/net/ip_tunnels.h             |  42 ++
 include/uapi/linux/if_link.h         |  13 +
 9 files changed, 1055 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

