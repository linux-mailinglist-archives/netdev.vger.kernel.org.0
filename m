Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E413985
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfEDLrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36420 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfEDLrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id c35so9736743qtk.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QGiMRvogrK768dGOBGeCPAuMoJ6DP96jLISoEZYbYpU=;
        b=k/MNCFFaw/hHWrxgqIGxhMt9F/5xVpocILwzRazavGYog8nvxyTG7VH6U19qosUAFw
         4x9wP2+nfeHtgT13ZBDTP+me828MxxMIS9jb8MMA6oljMQR4WbdIZTAWcD7FFsKgumPq
         2aCmMwJZDnvpq+vV+KJ6y6Nhlw970RPub484sNlP+Sz8aLyvMgvVUf3cgy/9b1Co2fyr
         2Jh9sBTRA7jsEzUG5oNJgBC1/Bc4QwsIy43pcc5Cm35LeXrVXurErDH5EMUFnvc9Dh/f
         Kbu2A7phFN+WsddRK9GH0WC08MDhJRRPia9l9YyTh0rvXU3s4dDVTKE9N7B91SebiddD
         kSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QGiMRvogrK768dGOBGeCPAuMoJ6DP96jLISoEZYbYpU=;
        b=uEgmKghgA5HCSbgL1Qad8q+XLK+1Skabf8/utPgq6ss8rpz8n0Y+a90MDEv8lVWOC7
         KAu/rLafTwlquYppyHMvVb8Fj71qpN73+9Urzof0ADthdQsUHVNFci+ISG3aBpV02oqh
         C0AyBvsE/Isq4zYq/YSuyztee74LSf6TQRmxxACSpQPG2IdQXWITXL1rxlFiteSiGQGK
         ECImaNukzJuYdu1mzMafCHMoeTR7QqkwASCR6kJ+Xm+L5zvkk2u++6zvmxI3rHRoDAQg
         egaHhyR39HOcu/dCZ1sH8d6KRQf+AhUNDRZspBrzxhLY3PvnRxHdRVi7bMFRB2rwGg6S
         se2A==
X-Gm-Message-State: APjAAAV+c23+QCZ3g+6ALjIxA6n2aSA4FyoL+mYfYUirhfcm4T01cxhr
        NneABvtIEq6gPa55NrLnZtKxUg==
X-Google-Smtp-Source: APXvYqzFZ5WOkZAX5neG2894TmQKLH7STzTTK54YVpEDeB/qFZOYOMn80BDe7utuxXKz3qC5Mx780Q==
X-Received: by 2002:a0c:ee29:: with SMTP id l9mr8729289qvs.151.1556970419700;
        Sat, 04 May 2019 04:46:59 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.46.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:46:59 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 00/13] net: act_police offload support
Date:   Sat,  4 May 2019 04:46:15 -0700
Message-Id: <20190504114628.14755-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this set starts by converting cls_matchall to the new flow offload
infrastructure. It so happens that all drivers implementing cls_matchall
offload today also offload cls_flower, so its a little easier for
them to handle the actions in unified flow_rule format, even though
in cls_matchall there is no flow to speak of. If a driver ever appears
which would prefer the old, direct access to TC exts, we can add the
pointer in the offload structure back and support both.

Next the act_police is added to actions supported by flow offload API.

NFP support for act_police offload is added as the final step.  The flower
firmware is configured to perform TX rate limiting in a way which matches
act_police's behaviour.  It does not use DMA.IN back pressure, and
instead	drops packets after they had been already DMAed into the NIC.
IOW it uses our standard traffic policing implementation, future patches
will extend it to other ports and traffic directions.

Pieter Jansen van Vuuren (13):
  net/sched: add sample action to the hardware intermediate
    representation
  net/sched: use the hardware intermediate representation for matchall
  mlxsw: use intermediate representation for matchall offload
  net/dsa: use intermediate representation for matchall offload
  net/sched: remove unused functions for matchall offload
  net/sched: move police action structures to header
  net/sched: add police action to the hardware intermediate
    representation
  net/sched: extend matchall offload for hardware statistics
  net/sched: allow stats updates from offloaded police actions
  net/sched: add block pointer to tc_cls_common_offload structure
  nfp: flower: add qos offload framework
  nfp: flower: add qos offload install and remove functionality.
  nfp: flower: add qos offload stats request and reply

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  38 +-
 drivers/net/ethernet/netronome/nfp/Makefile   |   3 +-
 .../net/ethernet/netronome/nfp/flower/cmsg.c  |   3 +
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |   3 +
 .../net/ethernet/netronome/nfp/flower/main.c  |   6 +
 .../net/ethernet/netronome/nfp/flower/main.h  |  29 ++
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 366 ++++++++++++++++++
 include/net/flow_offload.h                    |  23 ++
 include/net/pkt_cls.h                         |  36 +-
 include/net/tc_act/tc_police.h                |  70 ++++
 net/dsa/slave.c                               |  16 +-
 net/sched/act_police.c                        |  52 +--
 net/sched/cls_api.c                           |  14 +
 net/sched/cls_bpf.c                           |   7 +-
 net/sched/cls_flower.c                        |  11 +-
 net/sched/cls_matchall.c                      |  65 +++-
 net/sched/cls_u32.c                           |  17 +-
 18 files changed, 654 insertions(+), 108 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
 create mode 100644 include/net/tc_act/tc_police.h

-- 
2.21.0

