Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15F514706C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAWSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:06:11 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45693 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbgAWSGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:06:11 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so1659982pls.12
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=yxDbVma/IiAiec5rslu2trOgPultWipHN/bEQHgHXAE=;
        b=M6N3NVHJCGW0E9haUH2bg9HTH9mgGFLBHmTTdXRJl99UAvnykk0haxaUE1jITrxlpr
         /MRjxogyBc+hO00HAhINOBBriw9UQ14kJIG7a5MYjYtbjgn4MCvz0mPEdj23SjrXLIgC
         zZGMt3nttHNSWDvPe8xVHRloK+xhkoSA9XZdra5gOyzw4kNXXtkQZSq/AgL5jd+pmwKn
         q8v3LHWQQqh4PfBZefh9mZOpoaFQuwZ9pwB/ZbWbU1ZKumBc+FxOecrKrZ87j+31GJdN
         vOhxOuNekVW7b7QyRJKI+axuZTM9w44XSGecL/l+c0JQMsORbj5TIVPfMkmb+I4mWMIz
         yaUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=yxDbVma/IiAiec5rslu2trOgPultWipHN/bEQHgHXAE=;
        b=Ol3IEZK2HBO2Y+cUcKG/Szs6BEWAtqFWM0kFhnHwtoGA5aJUx/YjJU1isZC8eqsJUn
         gDOhnoT6YzNFf5acQWHGE1zlokFT4piMzjFpGkRlYC1aznCFVZaLbjz6RTckwwDPmXfb
         zu9Orm8h7ZdEMtV/NWfjnchBjbwkNr5CNLcE89VtClCQJShuNiW4JBf325JxnZSCYIsx
         G2nulQFQ20r0K1qo1zkzHpUviNLVpFK+cYv5zcUgvYUzS/idRMULHarVawXCWbG2qNRt
         Wx8R6t8qiRPS26eE+dT1ySuDvMJ+D7gc6e2NxmvMxVY5Z2XhDtg/wo/fWh5K+A8sxPs8
         FSDQ==
X-Gm-Message-State: APjAAAUYWk+ohDESfmVLA1Xmg0JTAS1RN33KWjfu79TAeUR1/yfuj9fD
        qe6WLh8HqMCxBz9Q4cl2FGK1Ky4/
X-Google-Smtp-Source: APXvYqxG6n3YqwtrSxrlteorg9yVMjxbhc7KhncpJUijL7s34VGh0OSw5UsjKlHJJ47qwB6JlMBLmw==
X-Received: by 2002:a17:90a:ba91:: with SMTP id t17mr6017450pjr.74.1579802770928;
        Thu, 23 Jan 2020 10:06:10 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id r3sm3402869pfg.145.2020.01.23.10.06.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 10:06:10 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 0/1] Bareudp Device Support
Date:   Thu, 23 Jan 2020 23:36:04 +0530
Message-Id: <cover.1579799722.git.martin.varghese@nokia.com>
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


Martin Varghese (1):
  Bareudp device support

 include/uapi/linux/if_link.h |  12 ++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_bareudp.c          | 157 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  38 +++++++++++
 5 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_bareudp.c

-- 
1.8.3.1

