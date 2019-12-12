Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631F111CFDE
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfLLOeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:34:13 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32781 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfLLOeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:34:13 -0500
Received: by mail-pl1-f195.google.com with SMTP id c13so678877pls.0
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 06:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=SCkZFwM8n2F4RqNbTjXJ51nEWqZYFX+j6eOvQtb0Zks=;
        b=ZZNwniwYcUhsFKDmKVr7rzKs0RtqBfpx5C2df7IBM4cnJFaeUyE4XxbYYG/5VR04uO
         mDwKO9eb1AoU3qPVRxCaHgseenPqKkJUoSciReFO40wnGDFhCYnM/+PoSlMon9q7FRRn
         HBmBvofx185lgpn/RKYinw4yNOHWCBT7wdhnxPtH+iALAH8BwenavXk7koPvIVUAPXSF
         pXnly7XUG49yrNzXlV9njC3xLiuF+qWSK3IzhTDyx4UadA7tVPg6wZYaNoXW/RZ0g/u9
         Pc1cEj0+KLfUwvCO2xVNcKtZspYOG5AXniMtdeliQQnVBcZtwHEyhZ0ycbmX2wNNNpbx
         lvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=SCkZFwM8n2F4RqNbTjXJ51nEWqZYFX+j6eOvQtb0Zks=;
        b=daJEXe5QqYfTNehQZOtg97bdUhCSXx9Linztj7mL2cMG65E1ShKVA0X7Wd0RpI51eT
         E0h8kAHk9y6BkXsk8iTIPxEaaONRmhBid4AfT469pII68h4Fs7ZAJfWiGeS6CR36jEqk
         2whnXFrgg12JFhg9jBuRgK8avy8C0IYZXxIdvqBPxKu+75Y0hPnpMq27XIy5fqpjMmnA
         bi5oYWbe3m3jKiLUlYTpSDpISPTv6lSFWhXKDNfBDuo8gm2KO+DscZrsnHIiR1frOJSf
         Z6Y/MutPfaoqq2LloNYc4cJdmI/Gy4QBFHP7bttQ9W12g6tp61KGlhicHqvuBBfbKca2
         K8mQ==
X-Gm-Message-State: APjAAAUKsT8A7mV4iN745k10yKDwOK0/vGiZKKCTOh9Nbnsw12bFZrUD
        s7OpXo0PQeT48TCkGt09MSxaiZiU
X-Google-Smtp-Source: APXvYqwd+Oz9MESomRgweRwQL3itwUH559tl3oFXUHWfplZFYpmXcHgct5VEFQIHOulw7MyravywdQ==
X-Received: by 2002:a17:90b:30c4:: with SMTP id hi4mr10311581pjb.62.1576161252442;
        Thu, 12 Dec 2019 06:34:12 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id u123sm7594259pfb.109.2019.12.12.06.34.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 06:34:11 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v2 0/3] New openvswitch MPLS actions for layer 2 tunnelling
Date:   Thu, 12 Dec 2019 20:03:28 +0530
Message-Id: <cover.1576157907.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The existing PUSH MPLS action inserts MPLS header between ethernet header
and the IP header. Though this behaviour is fine for L3 VPN where an IP
packet is encapsulated inside a MPLS tunnel, it does not suffice the L2
VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
encapsulate the ethernet packet.

The new mpls action PTAP_PUSH_MPLS inserts MPLS header at specified offset
from the start of packet.

A special handling is added for ethertype 0 in the existing POP MPLS action.
Value 0 in ethertype indicates the tunnelled packet is ethernet.

OVS userspace changes -
---------------------
Encap & Decap ovs actions are extended to support MPLS packet type. The encap & decap
adds and removes MPLS header at the start of packet as depicted below.

Actions - encap(mpls(ether_type=0x8847)),encap(ethernet)

Incoming packet -> | ETH | IP | Payload |

1 Actions -  encap(mpls(ether_type=0x8847)) [Kernel action - ptap_push_mpls:0x8847, mac_len:0]

        Outgoing packet -> | MPLS | ETH | Payload|

2 Actions - encap(ethernet) [ Kernel action - push_eth ]

        Outgoing packet -> | ETH | MPLS | ETH | Payload|

Decapsulation:

Incoming packet -> | ETH | MPLS | ETH | IP | Payload |

Actions - decap(),decap(packet_type(ns=0,type=0)

1 Actions -  decap() [Kernel action - pop_eth)

        Outgoing packet -> | MPLS | ETH | IP | Payload|

2 Actions - decap(packet_type(ns=0,type=0) [Kernel action - pop_mpls:0]

        Outgoing packet -> | ETH  | IP | Payload

Martin Varghese (3):
  net: skb_mpls_push() modified to allow MPLS header push at start of
    packet.
  net: Rephrased comments section of skb_mpls_pop()
  openvswitch: New MPLS actions for layer 2 tunnelling

 include/uapi/linux/openvswitch.h | 21 ++++++++++++++++++++-
 net/core/skbuff.c                | 10 +++++++---
 net/openvswitch/actions.c        | 26 ++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 15 +++++++++++++++
 4 files changed, 62 insertions(+), 10 deletions(-)

-- 
1.8.3.1

