Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1749C123FD2
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLRGy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:54:59 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41379 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRGy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:54:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id w62so668784pfw.8
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=mKccIRzS7L8pXaNK1gob15ECc3YRRTJEJcMvgprwiyU=;
        b=F4wTvUI8xTYqYLObnzC6YBzwawLg/l6eZypbkHJOQ+h1Kkrog1GvlNEnHAn+oZ33xg
         nMhXF6J4fFZ5F79Yf/57psovofyAnwfv5xUaH4IsDIqTnMvgGB6LIcpymRm0h4sCgKVR
         LEU+Va4ZEEsy8tIIl4dVVGbKsWRIuSPYV9iUMHX4iecdwJOp4fuueqSQ0EuaQFjc/1pK
         IEyR7+n+3GnCnajY8ZEjfEJ4VQlBUl6v5gvrguqud+j4KgSe2rgTa0aZXHbhDn/X0juK
         Qmf1F9EPUZNaOmcjVQvUv5GFnVFw8e8bOgaIT433ovzHx5tbTYWhCri0g6ldi0QOG8YG
         Iuzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=mKccIRzS7L8pXaNK1gob15ECc3YRRTJEJcMvgprwiyU=;
        b=W9BMmc9XU71e+g56tYhQ8rwGtZl2BHNuAYudO1L4/YuteQxUHltE4+t4tpwDzXT0qI
         l3o8la7Ii91zO5o6Pd7OMmt6laBGmHPwNQGlSIpuZEZ3yxFGJIOIBmgb2tgSxXwRTIoN
         KiCm9tcqf5vkcFN8jURXVbsCagy5JCg4CobK1jpyuebNbsNgf4AvNeJOquk2qMfYxkmM
         DAvms12L2jRTnz3yyj0NEwWXfrBwH9/Wmg8V7LCsFNUJ8IE2A8snwr8Zj0JLw5OHf/d/
         uqbk1QYijRb5tBYj1w/FZtPZgE361CkD72A+5p3vy8vESlxQJfgra2ZnzO+Y2Xjrg2tW
         1j0Q==
X-Gm-Message-State: APjAAAWmHic2Nzlk8doDO3B72hO+sQcVItjVkgyMNYeoBqBjeN83zgU3
        Bn8Ev/3Ue0s66qFSQCMsAohOCN/i
X-Google-Smtp-Source: APXvYqxXISZNDAJ/fgk59C8P/SbYNdQaxeLbxIzZkV9DKUi3zAuyUGfgAgN4WbXdo68QOyfFtESedA==
X-Received: by 2002:a62:3781:: with SMTP id e123mr1343686pfa.98.1576652097869;
        Tue, 17 Dec 2019 22:54:57 -0800 (PST)
Received: from localhost.localdomain ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id n2sm1431176pgn.71.2019.12.17.22.54.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 22:54:57 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 0/3] New openvswitch MPLS actions for layer 2 tunnelling
Date:   Wed, 18 Dec 2019 12:17:21 +0530
Message-Id: <cover.1576648350.git.martin.varghese@nokia.com>
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

The new mpls action PTAP_PUSH_MPLS inserts MPLS header at the start of the
packet or at the start of the l3 header depending on the value of l2 tunnel
flag in the PTAP_PUSH_MPLS arguments.

POP_MPLS action is extended to support ethertype 0x6558

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

2 Actions - decap(packet_type(ns=0,type=0) [Kernel action - pop_mpls:0]

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

