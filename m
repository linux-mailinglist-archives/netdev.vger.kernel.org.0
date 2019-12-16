Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D593D1207D5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfLPOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:02:48 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37339 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbfLPOCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:02:47 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so4514638plz.4
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 06:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=5Wf9lxGDarzcKvk7KasKep1akX9j40EjO8uZVyq7FP0=;
        b=llIvvYF5umDeulT2g11AxbrlISDVWOFjL17vBJyxUmhpYZV5lTk9/8uba7+pJU9m/W
         gkw1PIE2C9UzFC8rox92+QOwWsoN7Fh9icZ8CWOgXPJp90UDtAFy5iW+eP1j1rAol42x
         LiFh+H89w/OSRQyuHo+RpDdizQPcw4MnztI1HyLWmXHWvzWTdQRbWQljg3F07+mLN4Z7
         eRxSg05KO2cmvPFFyGdPF2mRwHXlfnkxVNxMUHPz4CbaJH3HrlukLk38eojAtRr1CT5H
         KlXUPkGUWMf9iqI6fmHCg7MeNuGtL4tWY2p9L+KiqCiNBbI2+1nvEcAlR/U3nmxOxj3Y
         l5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=5Wf9lxGDarzcKvk7KasKep1akX9j40EjO8uZVyq7FP0=;
        b=gHu1HDoz2a5Z6eSJF7dkcDvmIJ9feFPdNYx7cNpVYQuFxxbrsp4eVOciVl5/2+fFzs
         hf2b1cLsgAwjrrOPnEEnAK7+M7dekN3RzF2OtVSLvmdcEtKHoclEWzb2ShBT4caes1XR
         zlFsZZl0FFgfLba7A8t+mZ6RlQJAvsaRoY4eJRLwi02D8l66KU9TSAtjaoCAuOnxFm62
         7pls2lHZDs1byY1aVByV0gC8Gcgx/VF34VTBq+GXQY/aI4NdG8cpfxUyJeZGF9/2I8im
         5lCHAANMQMnYF4cjosvna+pbzaP9zzHYnpp7hBgd90GKNPbClqqm/IDTDQY/kDpoAK0k
         S8RA==
X-Gm-Message-State: APjAAAUc8MU29LFCOo+qLvaFkj1+I/Co3nWnX34k7JYNfrP69WbaN6Hn
        /pc3FP2Q8yHOyNjGKAO0w4I8fGCZ
X-Google-Smtp-Source: APXvYqy/0u1johPYOG2/oAZ8T9fflEnIPt5JE3hk+D4Nnp+MYVRMi5GA+P7K8NOyRdjjg4ATCAdjfg==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr16110736plt.110.1576504966667;
        Mon, 16 Dec 2019 06:02:46 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id q102sm12368775pjq.20.2019.12.16.06.02.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Dec 2019 06:02:45 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v3 0/3] New openvswitch MPLS actions for layer 2 tunnelling
Date:   Mon, 16 Dec 2019 19:32:27 +0530
Message-Id: <cover.1576488935.git.martin.varghese@nokia.com>
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

 include/uapi/linux/openvswitch.h | 23 ++++++++++++++++++++++-
 net/core/skbuff.c                | 10 +++++++---
 net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
 net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 10 deletions(-)

-- 
1.8.3.1

