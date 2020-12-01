Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6452CA1D7
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgLALxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729002AbgLALxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:53:35 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 812C7C0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 03:52:55 -0800 (PST)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8844983169;
        Tue,  1 Dec 2020 11:52:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606823574; bh=seWsKo6RBYBJIg6bhtydKrl2SI/nVi28ijU7IN/biOk=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20v2=
         20net-next=200/2]=20add=20ppp_generic=20ioctl(s)=20to=20bridge=20c
         hannels|Date:=20Tue,=20=201=20Dec=202020=2011:52:48=20+0000|Messag
         e-Id:=20<20201201115250.6381-1-tparkin@katalix.com>;
        b=oBSyvpHFwHthbMGkwzHwMLt8Fhy/LnFgQySqw8V+yF2Bmb6YcyXdnWkYiITKevk9/
         u14m40ZOqLwvovm6z93WkZKmqGCJ6VCAmpdeqoHFR25c6Kln1ZQ00nVDlwJSvWLB73
         62ZSMezbE9NCV//EKcVKI/S1bJN+jfqa+ZuHWM01LeWCvy55EbL5H5rUYUVg/5kBkS
         Qm1A70ms5H6ChgtChW+EHzJYheL7yZxRWinaPqi6NO8KxyV570xfU8tifjIoctiRmy
         ihyPQ0rldAf8u8ot/sbRxPMQsYEPUCjGkFOvWfdalSnCmO7k26zD7E1Fmij6YhFnhP
         XvwPpOhxEDjmA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v2 net-next 0/2] add ppp_generic ioctl(s) to bridge channels
Date:   Tue,  1 Dec 2020 11:52:48 +0000
Message-Id: <20201201115250.6381-1-tparkin@katalix.com>
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

 Documentation/networking/ppp_generic.rst |   9 ++
 drivers/net/ppp/ppp_generic.c            | 143 ++++++++++++++++++++++-
 include/uapi/linux/ppp-ioctl.h           |   2 +
 3 files changed, 152 insertions(+), 2 deletions(-)

-- 
2.17.1

