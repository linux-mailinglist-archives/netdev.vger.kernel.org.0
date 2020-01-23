Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA418147044
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWSEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:04:02 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51943 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWSEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:04:02 -0500
Received: by mail-pj1-f66.google.com with SMTP id d15so1550859pjw.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ykoF3RDotyB6iZzwILTMQIMPthxQtaOsbBf9QAyAuWs=;
        b=rgcnBD3ffBU5OESIx8l2HjRGizNtI0BYWdfeBYF1IfbhWw2WnP2dq82UJ41Bg5S0z0
         bsxptktTmd4WzbAWb8h/r36rxh4gjpehWqgwOGZB/8hl76vCgUG4uaANNcLPmfjzAgUF
         d/GjKoiaRD30mYaHCz4jWzBuKG2amYaRHMYsII/C0xgv9Gxw9kyAsG3HGsgRrdIe3pwZ
         1xjOHY75Blauc+c/MfY++4upZh72XB6+bbYHpurlkyi5RmR/Ofba6Tz3RvjoycKZ7NbR
         M1ysEx9HhfjCqHe9NnvO5Db7CyCU5HK6Gpfvdi439xLY74tAARbDxm+nSlRUSSCJRbV/
         Rn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ykoF3RDotyB6iZzwILTMQIMPthxQtaOsbBf9QAyAuWs=;
        b=IhA3Yu5nFjBgr8YcxhhIghuf76kZODfpsc0Epoa7YZUcTDX5ypXiH8iaSIuAKvBu6B
         hpFc7+9OduMKba6bktRJO/3Hef6/faafXnoJ+hCHJWKclrfZK2gMLKlgKGye90Im3Yt3
         1PIeHCWNvsjfHYKl2N3aTYpAdcBIYOdH4jsk7QELs1/39V8iG57oItlMSnrS0c4LORXn
         MK/Yr2iUf3STpFaFPAIQAL9Xf41sjRfczlmMOPm4M/kuP5gZMwRqx40sq/1YwMBatvnl
         fSlN9/O5jOQmSt6EbHSmGGeKCahni+NU8mSRVWTLP332dFbistmWd6ekMKDWCAhg6ayK
         JhUA==
X-Gm-Message-State: APjAAAUKwDKztCGpmxdFUNEkaw2fwfn+/l3l6uXyVrfpgGxuFN/FuMbq
        Fr9RfBsYg2NVhucwIszmLOaODT40
X-Google-Smtp-Source: APXvYqwg2NrNKCYc9ijgdp9lxNhXa5f4C+JOnLgMiMpRunCgUZlA3tTFXbGXquNG+OLanjLRHjacnw==
X-Received: by 2002:a17:902:5a85:: with SMTP id r5mr17867346pli.222.1579802641648;
        Thu, 23 Jan 2020 10:04:01 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id k16sm3618896pje.18.2020.01.23.10.03.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 10:04:01 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 0/2] Bare UDP L3 Encapsulation Module
Date:   Thu, 23 Jan 2020 23:33:55 +0530
Message-Id: <cover.1579798999.git.martin.varghese@nokia.com>
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
 drivers/net/bareudp.c                | 801 +++++++++++++++++++++++++++++++++++
 include/net/bareudp.h                |  20 +
 include/net/ip6_tunnel.h             |  50 +++
 include/net/ip_tunnels.h             |  47 ++
 include/uapi/linux/if_link.h         |  12 +
 9 files changed, 998 insertions(+)
 create mode 100644 Documentation/networking/bareudp.rst
 create mode 100644 drivers/net/bareudp.c
 create mode 100644 include/net/bareudp.h

-- 
1.8.3.1

