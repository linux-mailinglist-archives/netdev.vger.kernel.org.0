Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5458D27F3E7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgI3VHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3VHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:07:22 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9C9EC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:07:21 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 1EBC796D86;
        Wed, 30 Sep 2020 22:07:19 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500039; bh=yftLbdVMoNG+5ZrgMnYeevwaf3baUdgLyvtWUF5hUuA=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=200/6]=20l2tp:=20add=
         20ac/pppoe=20driver|Date:=20Wed,=2030=20Sep=202020=2022:07:01=20+0
         100|Message-Id:=20<20200930210707.10717-1-tparkin@katalix.com>;
        b=oyDOMsAZekWUXNkJEDLwykhQkAurKCaWjvOPgcmiswo60LGpqwQFe/pziPv2AhgJR
         RoyiX5fIIU1Zux9KePnMGzfKaUr9FX3hRkQPvl6xIFRAsdBxUlxG0wYpCBrRhz7qTR
         +llXNnkN1gPAbeKUGwuC/uNJvHpPtC116f3xMfXdV5xLBWyqyY79ylZXVI25MkGBGR
         nNgTiIpc4j136bnsBFx1QbErmEGQ42BybXf1FI4ybcvybQd3tZUSn6IXIjaRHRWDV5
         SOvS3+erPxbO9Ro/KBcaLZhvR4Z5+8qNwX9OUJXDzdTA6aqo70tb43iiXm6TMUzmej
         QSP/VSSVWz+qA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 0/6] l2tp: add ac/pppoe driver
Date:   Wed, 30 Sep 2020 22:07:01 +0100
Message-Id: <20200930210707.10717-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

L2TPv2 tunnels are often used as a part of a home broadband connection,
using a PPP link to connect the subscriber network into the Internet
Service Provider's network.

In this scenario, PPPoE is widely used between the L2TP Access
Concentrator (LAC) and the subscriber.  The LAC effectively acts as a
PPPoE server, switching PPP frames from incoming PPPoE packets into an
L2TP session.  The PPP session is then terminated at the L2TP Network
Server (LNS) on the edge of the ISP's IP network.

This patchset adds a driver to the L2TP subsystem to support this mode
of operation.

The new driver, l2tp_ac_pppoe, adds support for the existing pseudowire
type L2TP_PWTYPE_PPP_AC, and is instantiated using the existing L2TP
netlink L2TP_CMD_SESSION_CREATE.  It is expected to be used as follows:

 * A userspace PPPoE daemon running on the LAC handles the PPPoE
   discovery process up to the point of assigning a PPPoE session ID and
   sending the PADS packet to the PPPoE peer to establish the PPPoE
   session.
 * Userspace code running on the LAC then instantiates an L2TP tunnel
   and session with the LNS using the L2TP control protocol.
 * Finally, the data path for PPPoE session frames through the L2TP
   session to the LAC is instantiated by sending a genetlink
   L2TP_CMD_SESSION_CREATE command to the kernel, including
   the PPPoE-specific metadata required for L2TP_PWTYPE_PPP_AC sessions
   (this is documented in the patch series commit comments).

Supporting this driver submission we have two examples of userspace
projects which use L2TP_PWTYPE_PPP_AC:

 * https://github.com/katalix/l2tp-ktest

   This is a unit-test suite for the kernel L2TP subsystem which has
   been updated to include basic lifetime and datapath tests for
   l2tp_ac_pppoe.

   The new tests are automatically enabled when l2tp_ac_pppoe
   availability is detected, and hence support for l2tp_ac_pppoe is on
   the master branch of the git repository.

 * https://github.com/katalix/go-l2tp

   This is a Go library for building L2TP applications on Linux, and
   includes a suite of example daemons which utilise the library.

   The daemon kpppoed implements the PPPoE discovery protocol, and spawns
   an instance of a daemon kl2tpd which handles the L2TP control protocol
   and instantiates the kernel data path.

   The code utilising l2tp_ac_pppoe is on the branch tp_002_pppoe_1
   pending merge of this patchset in the kernel.

Notes on the patchset itself:

 * Patches 1-4 lay groundwork for the addition of the new driver, making
   tweaks to the l2tp netlink code to allow l2tp_ac_pppoe to access the
   netlink attributes it requires.
 * Patch 5 adds the new driver itself and hooks it into the kernel
   configuration and build system.
 * Patch 6 updates the l2tp documentation under Documentation/ to
   include information about the new driver.

Tom Parkin (6):
  l2tp: add netlink info to session create callback
  l2tp: tweak netlink session create to allow L2TPv2 ac_pppoe
  l2tp: allow v2 netlink session create to pass ifname attribute
  l2tp: add netlink attributes for ac_ppp session creation
  l2tp: add ac_pppoe pseudowire driver
  docs: networking: update l2tp.rst to document PPP_AC pseudowires

 Documentation/networking/l2tp.rst |  69 +++--
 include/uapi/linux/l2tp.h         |   2 +
 net/l2tp/Kconfig                  |   7 +
 net/l2tp/Makefile                 |   1 +
 net/l2tp/l2tp_ac_pppoe.c          | 446 ++++++++++++++++++++++++++++++
 net/l2tp/l2tp_core.h              |   4 +-
 net/l2tp/l2tp_eth.c               |   3 +-
 net/l2tp/l2tp_netlink.c           |  20 +-
 net/l2tp/l2tp_ppp.c               |   3 +-
 9 files changed, 527 insertions(+), 28 deletions(-)
 create mode 100644 net/l2tp/l2tp_ac_pppoe.c

-- 
2.17.1

