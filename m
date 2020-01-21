Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DDA144394
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 18:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAURtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 12:49:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40366 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAURtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 12:49:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so1886357pgt.7
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 09:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=fqFasVja7+9IJhYrjrhwrJjRPd5bb5r7jFamIuDrbwU=;
        b=rqrD0Zbn6yyYtQaSlYC+fGR5j6x8FTfnGF1DdRYZfSIsuv5TIXgBPPtBYmfudhmFzR
         VrlFK6fX4JgN2MidoVbgN0WBKIEvIu351Ns3asCemXC7yZVbGRAkQsOuutlSm7cnuVh9
         lPtXC9dFtgxNegvQDsDw9M3qHEUEbHjcnGK5hLiyaPotJXd26B/z240nPgCn+0l8MMYD
         14L5+rsrobx0MZzpIrCwsNxthJG3l63Rt5OJD2I5WL8tVmNj4bwJiu3YibjNcilC16dy
         EWlffrLD0w23vcPphWybFZ7vTHnkTF6z7wWt2Go7rJv4bKjtQ7EFNok2lL6EQCRbxUeD
         hcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=fqFasVja7+9IJhYrjrhwrJjRPd5bb5r7jFamIuDrbwU=;
        b=mp+MMQQq8NXHbf5uwaaePepxAFMOLCUM+iS7eKqxUdSquhtgMy1bWWgzia+vXJhy0a
         /jIKMNl7UaLOhi1KI7+If459T57cHzQphjGys4GXao5TnDFcpiBZUO/GVdj+/cc3OyTN
         JE276TIbZa2x2+MtFvvlZuQ2+xeLL42hdI64wyXN/Dw+xiA29jwkfyHygLi3CVs1XiZk
         /8Bt7XBKRucFCrdiSjShI610r4D/yepGNfF+7QZBSvFbtOHrxTesY6C3CRo8wqVbYMlr
         P86WvUI7isCQVl17KW0MH5cyLqheEAiGub7dbUXGvEQkJYf6HrJxifNrdjTMuHx4zfBj
         CEQg==
X-Gm-Message-State: APjAAAX6faIsFcw+0E+5LAEScCyBYZ9CSQqGqHhLpPFFHm6KG1hTV6qz
        Shyu9qQlyHp9QJ9vq/c+/whJOAhu
X-Google-Smtp-Source: APXvYqwzmKRyu1fGkT++9qi+op2yU503MK41wx2W4IBFSyzwuweypx59hSnECrtme3dtyTggKtSxWg==
X-Received: by 2002:a63:c511:: with SMTP id f17mr6489930pgd.198.1579628941072;
        Tue, 21 Jan 2020 09:49:01 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id a9sm43648919pfn.38.2020.01.21.09.48.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 09:49:00 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 0/2] Bare UDP L3 Encapsulation Module
Date:   Tue, 21 Jan 2020 23:18:53 +0530
Message-Id: <cover.1579624762.git.martin.varghese@nokia.com>
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
FOU by design does l4 encapsulation.It maps udp port to ipproto (IP protocol number
for l4 protocol).

Bareudp acheives a generic l3 encapsulation.It maps udp port to l3 ethertype

Martin Varghese (2):
  net: UDP tunnel encapsulation module for  tunnelling different
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

