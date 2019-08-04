Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B48280B5C
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfHDPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50999 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfHDPK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so72459707wml.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=qQSEQWQ0FzBagCnHx/Hg9UeadZWemk2zrCjNyzMWVj0=;
        b=rVJEMK+UHDimIhMlWR5cbN/5/CXA89Mi9M68NNlF+cZ/1BDeoPNWDgfShC23MSMvzn
         /IDn4mL00DibcymMiAoAKGclHwjFbIlaIOz1S7nTeQRai0AoMyz3UhlCuqwlFQ7IemwP
         fqVeILhJ1I5GiY51YzJHboC16kNeLuq8LUmg1jHSucNLLLWTntK9G8sRGbm3dgyHdEwf
         2xO4m7RI1e7u7xBF7B2BA9hgCDw/4XR+t4/NeUIzno+4/IDAdEI9zFocY9qqf4h753Yh
         ODX/xmocjWK4XZEQbffWOcP5ZtxHY6ayuMEyBHSkTrbJE+Bo5MyZeoLlWYUqFX6L5Nif
         uQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qQSEQWQ0FzBagCnHx/Hg9UeadZWemk2zrCjNyzMWVj0=;
        b=FeFozRUCTuU1MJ9mvzpZCqgmHrCgrSFpzo/f6qRC7PD5K3EJU4QRTXHTHJuHMQHmiK
         m5QerFTodNH2tqheWnNzW1uDZY1t3aNrU8sX/PQoTS00wDGV2hJUVh1CjGT5l10hsj8m
         OWZYwFEaXVvoAwR5BoOt8nDRHfDGlsAVMbl3XEbJ2XFd46KcV1DOsDDBb29wKS4j5UvQ
         KhvjeQODzZANRZULoL6UPEUC0/bl1ErVnyMwRvNgyDDXkmLw4mcgkY9d7dxpPqA2bn+q
         P8fgaiTmQ/hTPH6eDVsjXGpnu0+HS+bmbSIu6ZxpcRMVjJjFXc+ARtmgprJpzbkjxU3d
         zTyA==
X-Gm-Message-State: APjAAAVh0PZVIL0NE9wSwwpG5Rb1cGXqKaoHMt8n/r2wD7Kmout8AeAj
        wZVARG7Wlwmum2ERs6xyCHE++NWu5p8=
X-Google-Smtp-Source: APXvYqy9jzE3/EBfRnWwS0CTGJZZbbldteEzIVgMIdFHpgBEh+kUdG5hr0XxGdMsNRjaKJKr8iIAZg==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr13849469wma.68.1564931424035;
        Sun, 04 Aug 2019 08:10:24 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:23 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 00/10] Support tunnels over VLAN in NFP
Date:   Sun,  4 Aug 2019 16:09:02 +0100
Message-Id: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset deals with tunnel encap and decap when the end-point IP
address is on an internal port (for example and OvS VLAN port). Tunnel
encap without VLAN is already supported in the NFP driver. This patchset
extends that to include a push VLAN along with tunnel header push.

Patches 1-4 extend the flow_offload IR API to include actions that use
skbedit to set the ptype of an SKB and that send a packet to port ingress
from the act_mirred module. Such actions are used in flower rules that
forward tunnel packets to internal ports where they can be decapsulated.
OvS and its TC API is an example of a user-space app that produces such
rules.

Patch 5 modifies the encap offload code to allow the pushing of a VLAN
header after a tunnel header push.

Patches 6-10 deal with tunnel decap when the end-point is on an internal
port. They detect 'pre-tunnel rules' which do not deal with tunnels
themselves but, rather, forward packets to internal ports where they
can be decapped if required. Such rules are offloaded to a table in HW
along with an indication of whether packets need to be passed to this
table of not (based on their destination MAC address). Matching against
this table prior to decapsulation in HW allows the correct parsing and
handling of outer VLANs on tunnelled packets and the correct updating of
stats for said 'pre-tunnel' rules.

John Hurley (10):
  net: tc_act: add skbedit_ptype helper functions
  net: sched: add skbedit of ptype action to hardware IR
  net: tc_act: add helpers to detect ingress mirred actions
  net: sched: add ingress mirred action to hardware IR
  nfp: flower: push vlan after tunnel in merge
  nfp: flower: detect potential pre-tunnel rules
  nfp: flower: verify pre-tunnel rules
  nfp: flower: offload pre-tunnel rules
  nfp: flower: remove offloaded MACs when reprs are applied to OvS
    bridges
  nfp: flower: encode mac indexes with pre-tunnel rule check

 drivers/net/ethernet/netronome/nfp/flower/action.c |  40 ++++-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |   4 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c   |   1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  19 ++
 .../net/ethernet/netronome/nfp/flower/offload.c    | 186 ++++++++++++++++++-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 200 +++++++++++++++++++--
 include/net/flow_offload.h                         |   4 +
 include/net/tc_act/tc_mirred.h                     |  18 ++
 include/net/tc_act/tc_skbedit.h                    |  27 +++
 net/sched/cls_api.c                                |   9 +
 10 files changed, 476 insertions(+), 32 deletions(-)

-- 
2.7.4

