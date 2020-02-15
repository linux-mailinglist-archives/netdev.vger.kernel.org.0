Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE11615FD0E
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 07:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgBOGTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 01:19:45 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44290 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgBOGTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 01:19:45 -0500
Received: by mail-pg1-f196.google.com with SMTP id g3so6025902pgs.11
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 22:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ZJuvsYQcrXorljRvfWBDN0Ebxds4fkld46xnw6e7fek=;
        b=Gn6F3erWa5uSRdjU63rOjZnSqP+nVnyHRI6ON1XJKFltnPTejmmuz+ezOCLXzfLCqI
         NEcDT3hRbVBxAJe3i7TXleT76pR7JFWxyyYhXrIFJfoQ8ePncMP7fBKsB8tIja0mycNj
         fhh8nfI5jqJMijgyFpnZ2PiyFvwtUc/ryMWetr3k63qe5Y7Ks3e3wDZ4AfRR3onfYOW2
         nkf1Lip0PuRwqf4Vp6m5K9/RJdcIj/bmxulNWeE8LIp/+0Em63VM3aIz3jQfEoEjbEkv
         zvwSh0m8xHTmv+VDx0aDJYPYSXikyNie7h41uHv9YhqFaeYbk6bVtbUTmtIz83tp7YHz
         Fhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ZJuvsYQcrXorljRvfWBDN0Ebxds4fkld46xnw6e7fek=;
        b=CW/Hz6Mn2cf+jeD8U1jZ7sfLVAsXirupTeRsIqwc1LlGqh4JlQpESZ5R0fGTE1Ru0P
         pDUgWOdKvMIGML7SE12lotawiargA6ncNXx2iGK0D5n2obowz4ectRmgbdkNBizDm1pl
         SmQNRj5dmgoUPTKJtkdW84MseKu7OBN5tolkzcGNSdwRyEUQ9Og0gxGsCnTYaKMV4LSD
         yvsnFl8zyHrvROjxwXe8QCNhqvYsvrOP+W9ESnx/8qfgFB7s+RqNnvb/A63DbvATC9il
         qo1OrmGzD4UVep0p99rLNM/+MA7viy1d31N4SrlKqL9QyvmPZAGgRHMMCzpSVsgUYTVA
         OlvA==
X-Gm-Message-State: APjAAAXx/Z9tr8fVvLHzRvWWfYWHF+Rg+u7GEdst3vkFooJpAiJyAmhK
        XRbp5CByGtqIjazNj4KXZ8a1nJPCrCs=
X-Google-Smtp-Source: APXvYqw/CT7zn+wFPAVzl5lENoFtWwFDPr/z1w+ge3FiSbLRGoIvtLI1sow0R9z39I4xzzKQ6NNVZQ==
X-Received: by 2002:aa7:8f0d:: with SMTP id x13mr7120436pfr.61.1581747584555;
        Fri, 14 Feb 2020 22:19:44 -0800 (PST)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.74.10])
        by smtp.gmail.com with ESMTPSA id p16sm8808575pgi.50.2020.02.14.22.19.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Feb 2020 22:19:44 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v7 0/2] Bare UDP L3 Encapsulation Module
Date:   Sat, 15 Feb 2020 11:49:33 +0530
Message-Id: <cover.1581745878.git.martin.varghese@nokia.com>
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
 drivers/net/bareudp.c                | 803 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/net/ipv6.h                   |   6 +
 include/net/route.h                  |   6 +
 include/uapi/linux/if_link.h         |  12 +
 net/ipv4/route.c                     |  48 +++
 net/ipv6/ip6_output.c                |  70 +++
 11 files changed, 1033 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

