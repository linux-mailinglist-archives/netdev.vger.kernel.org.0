Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B3D1181FD
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfLJIQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:16:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46140 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJIQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:16:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id y14so8645488pfm.13
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 00:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=aTTVUPlmDtE1BfzFoDa5BZau2GtJcVYoVlwBrXDs+gg=;
        b=T2j9I1THrlY1bivofc8N+kPtlFrFGofjsaosVT0/SEJQgBzerIVETOdMPNMBQgcxxj
         lYOtQHTGE6X328zcfZT1gtvQ8QLfCTNTfFii2b6ObvOnLtwsf+sh77i+/OjW8ywNDf7i
         OyDGsmOucpdk5UkyW5X4t5ESKT1hJ+WEIUep9RTW9eEwxC835cOw37Tzt9LOedAQNVAo
         627j4/zVzRKEASHXdefUBKiwnQqA9eLsdrwpjV8iyr/Lp//YqiRyFoSi+TqZ5f9oUGYI
         waRiuaqHuqFywc67+bREcR/TG5X+M+4kdlrCMm+nR8NqKwXrqa2b5+QbGx/L0UaBX/cV
         pUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=aTTVUPlmDtE1BfzFoDa5BZau2GtJcVYoVlwBrXDs+gg=;
        b=QBt0qegrS28wmb44As0uWWrTkc8z6Vm1USRE27AUbgk6piLnOS1WKeBl1TT1pSFuXd
         sxvdOgHleXUppk9Lr3o/ghjwBRxZRzeBw9SUZAD5teW2WiPnYqZS53ZtXIamtrflUVW1
         QVOIF9b+sglqPPwnOEiAQZt2mpf/7ANWswVId0sZ+mAqcZpCOg3O4qGsuKsTVABIpppI
         fzUtMzFAONDHRmNX0i7gYOdwCzAQLzPz2q9ie6DUGwXk6B1pMa2fDpGqZyREh6dhlzgg
         S62l1RezRlyY3JmUhT6bHUm0HKH6QT52FLt1YdQF5DP3fUYOwgldsy+7dz+2R1Pa9yMm
         vR5g==
X-Gm-Message-State: APjAAAUreSaDQg/4PlA0bIcBdMXWUQgC8+DmL0IPCcusSgPWTzhrKyNw
        WJvVU9L15CXDtTL3HGDGn9+gSCVW
X-Google-Smtp-Source: APXvYqyOLktn9jk8Qma+6jic2AQzpNUpm+o5OPS2ROeWqYCXsUZvseAjAiaxZztUnraqnJIhr4Z8Nw==
X-Received: by 2002:a65:6451:: with SMTP id s17mr23271860pgv.188.1575965768420;
        Tue, 10 Dec 2019 00:16:08 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([1.39.147.184])
        by smtp.gmail.com with ESMTPSA id i127sm2361576pfe.54.2019.12.10.00.16.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 00:16:07 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next 0/3] New openvswitch MPLS actions for layer 2 tunnelling
Date:   Tue, 10 Dec 2019 13:45:28 +0530
Message-Id: <cover.1575964218.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
between ethernet header and the IP header. Though this behaviour is fine
for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
the MPLS header should encapsulate the ethernet packet.

The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
MPLS header from start of the packet respectively.

PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
@ethertype - Ethertype of MPLS header. 0x8847 for unicast,0x8848 for multicast.

PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
@ethertype - Ethertype of next header following the popped MPLS header.
             Value 0 in ethertype indicates the tunnelled packet is
             ethernet.

OVS userspace changes -
---------------------
Encap & Decap ovs actions are extended to support MPLS packet type. The encap & decap
adds and removes MPLS header at the start of packet as depicted below.

Actions - encap(mpls(ether_type=0x8847)),encap(ethernet)

Incoming packet -> | ETH | IP | Payload |

1 Actions -  encap(mpls(ether_type=0x8847)) [Kernel action - ptap_push_mpls:0x8847]

        Outgoing packet -> | MPLS | ETH | Payload|

2 Actions - encap(ethernet) [ Kernel action - push_eth ]

        Outgoing packet -> | ETH | MPLS | ETH | Payload|

Decapsulation:

Incoming packet -> | ETH | MPLS | ETH | IP | Payload |

Actions - decap(),decap(packet_type(ns=0,type=0)

1 Actions -  decap() [Kernel action - pop_eth)

        Outgoing packet -> | MPLS | ETH | IP | Payload|

2 Actions - decap(packet_type(ns=0,type=0) [Kernel action - ptap_pop_mpls:0]

        Outgoing packet -> | ETH  | IP | Payload

Martin Varghese (3):
  net: skb_mpls_push() modified to allow MPLS header push at start of
    packet.
  net: Rephrased comments section of skb_mpls_pop()
  openvswitch: New MPLS actions for layer 2 tunnelling

 include/uapi/linux/openvswitch.h |  2 ++
 net/core/skbuff.c                |  9 ++++++---
 net/openvswitch/actions.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 net/openvswitch/flow_netlink.c   | 21 +++++++++++++++++++++
 4 files changed, 69 insertions(+), 3 deletions(-)

-- 
1.8.3.1

