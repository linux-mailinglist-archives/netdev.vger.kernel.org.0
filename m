Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7EA2D6077
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391885AbgLJPwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:52:07 -0500
Received: from mail.katalix.com ([3.9.82.81]:49046 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392073AbgLJPvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 10:51:48 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 30D9F86B47;
        Thu, 10 Dec 2020 15:51:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1607615465; bh=Al9FjfhevIoV0rbcvtSRQOidD3xJBr4wXcFRnSMfb+0=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20v4=
         20net-next=200/2]=20add=20ppp_generic=20ioctl(s)=20to=20bridge=20c
         hannels|Date:=20Thu,=2010=20Dec=202020=2015:50:56=20+0000|Message-
         Id:=20<20201210155058.14518-1-tparkin@katalix.com>;
        b=Rikvy+sODGDlZg3kfAWuRskbavXGi55lDDBF7gg+TV0HZI6tJ4kxsGAEVhrTEH2jU
         1O/4tH9XWupSRuRHPuzx8OHo9dk7hI/4bsPGnsnzQjjFzs0X6dq19qIEL5L95AHlLa
         Tt4Aaa+O11+2/t9ZE91//2caZo3GxkUWoS03AMa4vvI5HoavWjlZmacH56VrXzdEnA
         fx+xovTCPRAM/+NwPkXdygyDQKCGUDba2dYJy7uPaow3PrzTYxEULsI1r6kl5QrIgN
         qNX99GbtPomLxOKWxM10V2bx5M2XwzrxKwaORyQngoMxcjdHaSz4WsExJqcSbrqG9U
         fti5RbTilolig==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v4 net-next 0/2] add ppp_generic ioctl(s) to bridge channels
Date:   Thu, 10 Dec 2020 15:50:56 +0000
Message-Id: <20201210155058.14518-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following on from my previous RFC[1], this series adds two ioctl calls
to the ppp code to implement "channel bridging".

When two ppp channels are bridged, frames presented to ppp_input() on
one channel are passed to the other channel's ->start_xmit function for
transmission.

The primary use-case for this functionality is in an L2TP Access
Concentrator where PPP frames are typically presented in a PPPoE session
(e.g. from a home broadband user) and are forwarded to the ISP network in
a PPPoL2TP session.

The two new ioctls, PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN form a
symmetric pair.

Userspace code testing and illustrating use of the ioctl calls is
available in the go-l2tp[2] and l2tp-ktest[3] repositories.

[1]. Previous RFC series:

https://lore.kernel.org/netdev/20201106181647.16358-1-tparkin@katalix.com/

[2]. go-l2tp: a Go library for building L2TP applications on Linux
systems. Support for the PPPIOCBRIDGECHAN ioctl is on a branch:

https://github.com/katalix/go-l2tp/tree/tp_002_pppoe_2

[3]. l2tp-ktest: a test suite for the Linux Kernel L2TP subsystem.
Support for the PPPIOCBRIDGECHAN ioctl is on a branch:

https://github.com/katalix/l2tp-ktest/tree/tp_ac_pppoe_tests_2

Changelog:

v4:
    * Fix NULL-pointer access in PPPIOCBRIDGECHAN in the case that the
      ID of the channel to be bridged wasn't found.
    * Add comment in ppp_unbridge_channels to better document the
      unbridge process.

v3:
    * Use rcu_dereference_protected for accessing struct channel
      'bridge' field during updates with lock 'upl' held.
    * Avoid race in ppp_unbridge_channels by ensuring that each channel
      in the bridge points to it's peer before decrementing refcounts.

v2:
    * Add missing __rcu annotation to struct channel 'bridge' field in
      order to squash a sparse warning from a C=1 build
    * Integrate review comments from gnault@redhat.com
    * Have ppp_unbridge_channels return -EINVAL if the channel isn't
      part of a bridge: this better aligns with the return code from
      ppp_disconnect_channel.
    * Improve docs update by including information on ioctl arguments
      and error return codes.

Tom Parkin (2):
  ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls
  docs: update ppp_generic.rst to document new ioctls

 Documentation/networking/ppp_generic.rst |  16 +++
 drivers/net/ppp/ppp_generic.c            | 152 ++++++++++++++++++++++-
 include/uapi/linux/ppp-ioctl.h           |   2 +
 3 files changed, 167 insertions(+), 3 deletions(-)

-- 
2.17.1

