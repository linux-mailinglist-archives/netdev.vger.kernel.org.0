Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC9E24E822
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHVO73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:59:29 -0400
Received: from mail.katalix.com ([3.9.82.81]:57970 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHVO7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 10:59:16 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 45EC286BDC;
        Sat, 22 Aug 2020 15:59:15 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598108355; bh=6GqCji9pSholddrbSPMfptYUS+vlM+40tL73kRGbVno=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=20v2=200/9]=20l2tp:=2
         0replace=20custom=20logging=20code=20with=20tracepoints|Date:=20Sa
         t,=2022=20Aug=202020=2015:59:00=20+0100|Message-Id:=20<20200822145
         909.6381-1-tparkin@katalix.com>;
        b=xmLEuh+nP682t/ACESGevDEdBxs+ghGpMRZlLRzpR72pGSoIx+yPorRz4ruvmsFAg
         u6x9lwu6fwAncfv7D4qiAiyH+Qs1S7Q3SWhSMn1XTsDW7ZNe/4durUNeMZEA1jG+2y
         K2t4qOL4IOmcVtbaV0zvZEXAbRdtg9StHQEUd90WoIEFWj/2Nkg5I6ZBtqP4DbufTc
         GpodxfLoh0cBJkRR3a/uTA7DvJXxDPSgp9ibjBFxMe0ONCrF9S4ybmf/VdORRknnB5
         sJKxtANY8sbex5qmfsK9gKsZrJOdRC0GEP/zyVczP8ABUAkKedBoqnPTCMQqTBorfH
         BrVHEQbyCZVLg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next v2 0/9] l2tp: replace custom logging code with tracepoints
Date:   Sat, 22 Aug 2020 15:59:00 +0100
Message-Id: <20200822145909.6381-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The l2tp subsystem implemented custom logging macros for debugging
purposes which were controlled using a set of debugging flags in each
tunnel and session structure.

A more standard and easier-to-use approach is to use tracepoints.

This patchset refactors l2tp to:

 * remove excessive logging
 * tweak useful log messages to use the standard pr_* calls for logging
   rather than the l2tp wrappers
 * replace debug-level logging with tracepoints
 * add tracepoints for capturing tunnel and session lifetime events

I note that checkpatch.pl warns about the layout of code in the
newly-added file net/l2tp/trace.h.  When adding this file I followed the
example(s) of other tracepoint files in the net/ subtree since it seemed
preferable to adhere to the prevailing style rather than follow
checkpatch.pl's advice in this instance.  If that's the wrong
approach please let me know.

v1 -> v2

 * Fix up a build warning found by the kernel test robot

Tom Parkin (9):
  l2tp: don't log data frames
  l2tp: remove noisy logging, use appropriate log levels
  l2tp: use standard API for warning log messages
  l2tp: add tracepoint infrastructure to core
  l2tp: add tracepoint definitions in trace.h
  l2tp: add tracepoints to l2tp_core.c
  l2tp: remove custom logging macros
  l2tp: remove tunnel and session debug flags field
  docs: networking: add tracepoint info to l2tp.rst

 Documentation/networking/l2tp.rst |  37 ++----
 include/uapi/linux/if_pppol2tp.h  |   2 +-
 include/uapi/linux/l2tp.h         |   6 +-
 net/l2tp/Makefile                 |   2 +
 net/l2tp/l2tp_core.c              | 192 ++++++++-------------------
 net/l2tp/l2tp_core.h              |  23 +---
 net/l2tp/l2tp_debugfs.c           |   4 +-
 net/l2tp/l2tp_eth.c               |  11 --
 net/l2tp/l2tp_ip.c                |  15 ---
 net/l2tp/l2tp_ip6.c               |  15 ---
 net/l2tp/l2tp_netlink.c           |  16 +--
 net/l2tp/l2tp_ppp.c               |  55 ++------
 net/l2tp/trace.h                  | 211 ++++++++++++++++++++++++++++++
 13 files changed, 302 insertions(+), 287 deletions(-)
 create mode 100644 net/l2tp/trace.h

-- 
2.17.1

