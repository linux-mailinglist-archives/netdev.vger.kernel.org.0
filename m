Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA772D6085
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392087AbgLJPwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:52:15 -0500
Received: from mail.katalix.com ([3.9.82.81]:49056 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392077AbgLJPvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 10:51:53 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 205D186C87;
        Thu, 10 Dec 2020 15:51:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1607615470; bh=Z2/LazyF/ndDgTr+YBy9xrnh/bqsHRQdk+LBgD0DCnY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20v4=
         20net-next=202/2]=20docs:=20update=20ppp_generic.rst=20to=20docume
         nt=20new=20ioctls|Date:=20Thu,=2010=20Dec=202020=2015:50:58=20+000
         0|Message-Id:=20<20201210155058.14518-3-tparkin@katalix.com>|In-Re
         ply-To:=20<20201210155058.14518-1-tparkin@katalix.com>|References:
         =20<20201210155058.14518-1-tparkin@katalix.com>;
        b=2Xsrryiseddss2aP0FB9Ben85V59Js0MjmGxcucd2wFFSqYQPdmAmxUuHmLecnqYf
         r7EHLvCSykfy5ATmrP5BN3pnXU1Y2RAi+DsIBSOT8f3qdWW5wmk9r2TdB9cwSoeZh/
         b3h2hVE+sksbBUt54mfzN6NGfAqBK6Pnr89n2P9KGqYJZb4obU6ZwENWbpSA0VBgIC
         wqjhg5ma3OvVp+o2yZkEB4+aa2i5oxCyQ4TTrt9YU3CHJQrGHOdEe9WeZVNNg/EAAl
         +q+79p302ZpJmwwUaN+7jWG/nQeZ59HzOyGyGwvDVRajKKsz+rk4VgHSuIiuA+0hWa
         aVbuCz3MP7xEg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v4 net-next 2/2] docs: update ppp_generic.rst to document new ioctls
Date:   Thu, 10 Dec 2020 15:50:58 +0000
Message-Id: <20201210155058.14518-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210155058.14518-1-tparkin@katalix.com>
References: <20201210155058.14518-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of the newly-added PPPIOCBRIDGECHAN and
PPPIOCUNBRIDGECHAN ioctls.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 Documentation/networking/ppp_generic.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/networking/ppp_generic.rst b/Documentation/networking/ppp_generic.rst
index e60504377900..5a10abce5964 100644
--- a/Documentation/networking/ppp_generic.rst
+++ b/Documentation/networking/ppp_generic.rst
@@ -314,6 +314,22 @@ channel are:
   it is connected to.  It will return an EINVAL error if the channel
   is not connected to an interface.
 
+* PPPIOCBRIDGECHAN bridges a channel with another. The argument should
+  point to an int containing the channel number of the channel to bridge
+  to. Once two channels are bridged, frames presented to one channel by
+  ppp_input() are passed to the bridge instance for onward transmission.
+  This allows frames to be switched from one channel into another: for
+  example, to pass PPPoE frames into a PPPoL2TP session. Since channel
+  bridging interrupts the normal ppp_input() path, a given channel may
+  not be part of a bridge at the same time as being part of a unit.
+  This ioctl will return an EALREADY error if the channel is already
+  part of a bridge or unit, or ENXIO if the requested channel does not
+  exist.
+
+* PPPIOCUNBRIDGECHAN performs the inverse of PPPIOCBRIDGECHAN, unbridging
+  a channel pair.  This ioctl will return an EINVAL error if the channel
+  does not form part of a bridge.
+
 * All other ioctl commands are passed to the channel ioctl() function.
 
 The ioctl calls that are available on an instance that is attached to
-- 
2.17.1

