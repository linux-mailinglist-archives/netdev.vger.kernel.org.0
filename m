Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4BE2C53E9
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKZMYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:24:39 -0500
Received: from mail.katalix.com ([3.9.82.81]:40042 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgKZMYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 07:24:39 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 132FB96FB7;
        Thu, 26 Nov 2020 12:24:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606393478; bh=+ynyZhkOq3LGM4Q/vjkDVIloAI7rliP1IfEv1A5Go+s=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20net
         -next=200/2]=20add=20ppp_generic=20ioctl(s)=20to=20bridge=20channe
         ls|Date:=20Thu,=2026=20Nov=202020=2012:24:24=20+0000|Message-Id:=2
         0<20201126122426.25243-1-tparkin@katalix.com>;
        b=3ESYcbNnyWXPdPGEYkJ+241+DOhn/+ttTBisWi1tAuBKX1i/yn99VjKV8pbK8SXC8
         7JpvvcgaqaZ3u40y3hVkm+01Ohuf6pfXMPAMAiGXkYGSygt/uiO28Khdp2f6oeL7zc
         QEvzJhPZ7X0VIbJ7CH9/MdOI08Z9O+9EnYF/HgibeJW7IhEsf7u49550MZ1W3WwRty
         NeQwEQW/UJKJAGXFAxj/wjC2xHs0XItPGshDJsd3ON+KWCpMIzEMERPcF5e/9l4Hqk
         KlUn/r7QadOlL+7hCquCHKv8MLsdUyP4rxMN56fqd0cBvQIj/K78GP7ZWGoxxbv0vO
         GgoBLk6CdhP6A==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 0/2] add ppp_generic ioctl(s) to bridge channels
Date:   Thu, 26 Nov 2020 12:24:24 +0000
Message-Id: <20201126122426.25243-1-tparkin@katalix.com>
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

Tom Parkin (2):
  ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls
  docs: update ppp_generic.rst to document new ioctls

 Documentation/networking/ppp_generic.rst |   9 ++
 drivers/net/ppp/ppp_generic.c            | 143 ++++++++++++++++++++++-
 include/uapi/linux/ppp-ioctl.h           |   2 +
 3 files changed, 152 insertions(+), 2 deletions(-)

-- 
2.17.1

