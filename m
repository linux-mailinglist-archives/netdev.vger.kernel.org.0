Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6A2A9BEC
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgKFSWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:22:05 -0500
Received: from mail.katalix.com ([3.9.82.81]:43090 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgKFSWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 13:22:04 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2020 13:22:03 EST
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 45B0B96EE8;
        Fri,  6 Nov 2020 18:16:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1604686619; bh=nLZbPVTzgZRSBmlwfL1F972zxXyM6VmRM6S9TF3oBOE=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[RFC=20PATCH
         =200/2]=20add=20ppp_generic=20ioctl=20to=20bridge=20channels|Date:
         =20Fri,=20=206=20Nov=202020=2018:16:45=20+0000|Message-Id:=20<2020
         1106181647.16358-1-tparkin@katalix.com>;
        b=Bsdz6POK9GT5xH0ziWrMFTnUZp5iqWMLxeXJUOr4xWptkSiNB6YGKpvdfqCL3KMfT
         aFMMvv8HBGD7UBcOt6hnV2oAG6V46LaISpkU53y5l9gUQBHFiJuuls6VV1NjjsihP+
         Is7Bd8vxQBXbsGGluAJyVt93lpOzDOjrCYulIljmlF1nB5fusUAkyTZGKMo4zpbDGb
         CE6LMIBVU3mpneyJcXItnL85zZoGVExMm83R3xqVI9EbGy8DgZOlYaGHLf6cBGR8Ay
         IlqHv24Dg+fL/d1juHhSj0B+5ekM5KULCzY+OMjFLsEYhJV66llIXqkkSZ8n7NnwvJ
         yBygPlPzSK/vA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Date:   Fri,  6 Nov 2020 18:16:45 +0000
Message-Id: <20201106181647.16358-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small RFC series implements a suggestion from Guillaume Nault in
response to my previous submission to add an ac/pppoe driver to the l2tp
subsystem[1].

Following Guillaume's advice, this series adds an ioctl to the ppp code
to allow a ppp channel to be bridged to another.  Quoting Guillaume:

"It's just a matter of extending struct channel (in ppp_generic.c) with
a pointer to another channel, then testing this pointer in ppp_input().
If the pointer is NULL, use the classical path, if not, forward the PPP
frame using the ->start_xmit function of the peer channel."

This allows userspace to easily take PPP frames from e.g. a PPPoE
session, and forward them over a PPPoL2TP session; accomplishing the
same thing my earlier ac/pppoe driver in l2tp did but in much less code!

Since I am not an expert in the ppp code, this patch set is RFC to
gather any comments prior to making a proper submission.  I have tested
this code using go-l2tp[2] and l2tp-ktest[3], but I have some
uncertainties about the current implementation:

 * I believe that the fact we're not explicitly locking anything in the
   ppp_input path for access to the channel bridge field is OK since:
   
    - ppp_input is called from the socket backlog recv

    - pppox_unbind (which calls ppp_channel_unregister, which unsets the
      channel bridge field) is called from the socket release

   As such I think the bridge pointer cannot change in the recv
   path since as the pppoe.c code says: "Semantics of backlog rcv
   preclude any code from executing in lock_sock()/release_sock()
   bounds".

 * When userspace makes a PPPIOCBRIDGECHAN ioctl call, the channel the
   ioctl is called on is updated to point to the channel identified
   using the index passed in the ioctl call.

   As such, allow PPP frames to pass in both directions from channel A
   to channel B, userspace must call ioctl twice: once to bridge A to B,
   and once to bridge B to A.

   This approach makes the kernel coding easier, because the ioctl
   handler doesn't need to do anything to lock the channel which is
   identified by index: it's sufficient to find it in the per-net list
   (under protection of the list lock) and take a reference on it.

   The downside is that userspace must make two ioctl calls to fully set
   up the bridge.

Any comments on the design welcome, especially thoughts on the two
points above.

Thanks :-)

[1]. Previous l2tp ac/pppoe patch set:

https://lore.kernel.org/netdev/20200930210707.10717-1-tparkin@katalix.com/

[2]. go-l2tp: a Go library for building L2TP applications on Linux
systems, support for the PPPIOCBRIDGECHAN ioctl is on a branch:

https://github.com/katalix/go-l2tp/tree/tp_002_pppoe_2

[3]. l2tp-ktest: a test suite for the Linux Kernel L2TP subsystem

https://github.com/katalix/l2tp-ktest

Tom Parkin (2):
  ppp: add PPPIOCBRIDGECHAN ioctl
  docs: update ppp_generic.rst to describe ioctl PPPIOCBRIDGECHAN

 Documentation/networking/ppp_generic.rst |  5 ++++
 drivers/net/ppp/ppp_generic.c            | 35 +++++++++++++++++++++++-
 include/uapi/linux/ppp-ioctl.h           |  1 +
 3 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.17.1

