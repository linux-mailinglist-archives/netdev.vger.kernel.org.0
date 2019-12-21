Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521281286BA
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 04:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfLUDUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 22:20:39 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50660 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfLUDUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 22:20:39 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so4943891pjb.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 19:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=sBtQ4dJ1mZKtnj04BpcPu6P0a3A4u80fzlfrlse3WK8=;
        b=LMAJEmfEKi4b5e4rVXG4PUxWX+b5SHpzHqBBbzbkMkG3C8Llyo+g661GxWgTM3f1b0
         mlFZNTuvASWG1TkZAIe35YCcbKgQfFiLtSLUpmaUPNcJaMTWL2nb4aCMAQDuG7uqU0vx
         48fiCU3xE/1pn9y7uirXYYlG4d6f7/E2PEUJdaIowWqjCMrS4iWVFIbjlbX1B7ZZ/7by
         whRjg69NwQfCB6qjvN9UKwO4uTNbrim3OvrG9cIFsJbXKPqrgr8RWFKSscsr8KDFCVkX
         tYUgLUSdowc0PwFpnnJ6LsvZWIN1EtvnvshbHFcHELD8au3XueXQjE6WCfvH+Hld8nGB
         lNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=sBtQ4dJ1mZKtnj04BpcPu6P0a3A4u80fzlfrlse3WK8=;
        b=gGs3LcqmswHiFtffeWKMlKfXMnR4ngYa5M/zKRYsbEwArya/vJlNKoNmX6Jci0e783
         0p9goBB3ESYEc600Wb2LFXHHMYraX4z6Ox4PxzyQihZpnH559PXDIDFr9UpoivNYLu2/
         qrZICl3203ve9TbdDl/tI3hf1ENeaaIxB3cG33exgeWzkyGqAkV4zYo+p4a+IrmkGNQr
         TLPLHCkvXDDtoKFi79ntqVY8ipIdXmQCbk8bDo9uNACr6Pmh2Qyf3iXpRTezPEgcJ1cD
         ohs3iyA1H/glaH2abkhKLrWR+DrYQ24GMYg6uCDbbBoNtTGzjAyiQ3DiPpw9rAtdKOft
         cBfw==
X-Gm-Message-State: APjAAAVD+MVsfLuFevQpm6oc9RgfBEAgB4ylt2P9Eg65I8Yh7xLFOW/N
        rMKdZiHvk6NVBkebHluAmCB3PUE8
X-Google-Smtp-Source: APXvYqwleyO2a5wA0e3PWmXmPH90i65sPPx3aIMA6tnshEocoXLDxZiFg+gl+XX9RljABsyjdaSLCg==
X-Received: by 2002:a17:902:a616:: with SMTP id u22mr18774493plq.173.1576898438094;
        Fri, 20 Dec 2019 19:20:38 -0800 (PST)
Received: from localhost.localdomain ([42.109.147.248])
        by smtp.gmail.com with ESMTPSA id n7sm2494210pjq.8.2019.12.20.19.20.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 19:20:37 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 0/3] New openvswitch MPLS actions for layer 2 tunnelling
Date:   Sat, 21 Dec 2019 08:49:36 +0530
Message-Id: <cover.1576896417.git.martin.varghese@nokia.com>
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

The new mpls action ADD_MPLS inserts MPLS header at the start of the
packet or at the start of the l3 header depending on the value of l3 tunnel
flag in the ADD_MPLS arguments.

POP_MPLS action is extended to support ethertype 0x6558

OVS userspace changes -
---------------------
Encap & Decap ovs actions are extended to support MPLS packet type. The encap & decap
adds and removes MPLS header at the start of packet as depicted below.

Actions - encap(mpls(ether_type=0x8847)),encap(ethernet)

Incoming packet -> | ETH | IP | Payload |

1 Actions -  encap(mpls(ether_type=0x8847)) [Kernel action - add_mpls:0x8847]

        Outgoing packet -> | MPLS | ETH | Payload|

2 Actions - encap(ethernet) [ Kernel action - push_eth ]

        Outgoing packet -> | ETH | MPLS | ETH | Payload|

Decapsulation:

Incoming packet -> | ETH | MPLS | ETH | IP | Payload |

Actions - decap(),decap(packet_type(ns=0,type=0)

1 Actions -  decap() [Kernel action - pop_eth)

        Outgoing packet -> | MPLS | ETH | IP | Payload|

2 Actions - decap(packet_type(ns=0,type=0) [Kernel action - pop_mpls:0x6558]

        Outgoing packet -> | ETH  | IP | Payload

Martin Varghese (3):
  net: skb_mpls_push() modified to allow MPLS header push at start of
    packet.
  net: Rephrased comments section of skb_mpls_pop()
  openvswitch: New MPLS actions for layer 2 tunnelling

 include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
 net/core/skbuff.c                | 10 +++++++---
 net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 9 deletions(-)

-- 
1.8.3.1

