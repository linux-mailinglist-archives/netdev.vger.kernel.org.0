Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4704C449D1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfFMRoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:44:19 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36172 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfFMRoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:44:19 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so29028389edq.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=5iDTftYhkmGPM9diSLnXz5kVoL6u24HYP+2v7wwkwOw=;
        b=HqV303k3C9ezjZORlrUfHheyjfNSi8Hd2F9vvgr6Nxjq8A2pWN1lCrlGQM+wbxJSOP
         GncmMQI9xp6LhG3v3UMIgeogN8oAn5xdAe64ywyrFcK3NkOFFQbG2ICnyQxB17OK0Wiq
         mZe45vHQwqgUBEfpriQOq3piDf2FKETvWkKK7VTJRvt7FblO4datvuFkFwSWqmzRrC2I
         Azjp3tvgVQ/7DJtEEw4JhDPPutKFqc1Pao9ZsBF9QGtaoKtqJ1gmUJ/lCBr2JKAmwnub
         NUIojhkePyJXeZ17SLjmTyF/ql96l2ZbyhQwYgHmOMwF5No5GcSPfZL2COFTK+jCWfRl
         NtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5iDTftYhkmGPM9diSLnXz5kVoL6u24HYP+2v7wwkwOw=;
        b=TDNDVdCZrMEM5+kHBr+AZx+bMhWNoBcWqKfAKh+8S8i5EMz/Aa2c/ITremDyrM0OUw
         4PZ+hnf2sZ/yjV+vSjw5F9pqnCZnq9MGGZ8AgGPloppa8Gr4Niv65NRljBzGcpaG7Dno
         PBmMVM/+N/tUTWCJxG667SlybEjAjNaDqTkpvesVVE4LI9gE+JZ0mjM7zsobJObiy5EU
         LS9criOhVYke7eP+RPMjJImKYcuhIRJUCuiwOIQuZCpq3HgwLhZtwe8FjlWARTMiRKU0
         psHhNVL8qXmJxKk4uzsH/4CMpJafo2mrxW/SkZOr/Fur2bjO81sHbFfwalFweVeQ7Tbf
         oWPQ==
X-Gm-Message-State: APjAAAVS1pQH9MD+3bVas2seEI5RU6iqeiajqLUGPRm9/+eEMq1Bis6p
        iDZVAp/mEYsfAjEne4HH6dHCT4TPIO8=
X-Google-Smtp-Source: APXvYqzfk2adWR+HK3uXLaRRqfC42+VbMQQ+Ebqmk73kbfhpk5XMWWc3IX/hGUleIbgFl7pQUqWeUw==
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr26856291ejd.300.1560447857266;
        Thu, 13 Jun 2019 10:44:17 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id e22sm115162edd.25.2019.06.13.10.44.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 10:44:16 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 0/3] Add MPLS actions to TC
Date:   Thu, 13 Jun 2019 18:43:56 +0100
Message-Id: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces a new TC action module that allows the
manipulation of the MPLS headers of packets. The code impliments
functionality including push, pop, and modify.

Also included is a update to the IR action preparation code to allow the
new MPLS actions to be offloaded to HW.

v1->v2:
- ensure TCA_ID_MPLS does not conflict with TCA_ID_CTINFO (Davide Caratti)

John Hurley (3):
  net: sched: add mpls manipulation actions to TC
  net: sched: include mpls actions in hardware intermediate
    representation
  selftests: tc-tests: actions: add MPLS tests

 include/net/flow_offload.h                         |  10 +
 include/net/tc_act/tc_mpls.h                       |  91 +++
 include/uapi/linux/pkt_cls.h                       |   3 +-
 include/uapi/linux/tc_act/tc_mpls.h                |  32 +
 net/sched/Kconfig                                  |  11 +
 net/sched/Makefile                                 |   1 +
 net/sched/act_mpls.c                               | 450 +++++++++++++
 net/sched/cls_api.c                                |  26 +
 .../tc-testing/tc-tests/actions/mpls.json          | 744 +++++++++++++++++++++
 9 files changed, 1367 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

