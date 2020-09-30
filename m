Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40127F3EA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgI3VH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:29 -0400
Received: from mail.katalix.com ([3.9.82.81]:34408 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbgI3VH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:07:27 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4989A96D7E;
        Wed, 30 Sep 2020 22:07:25 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500045; bh=nBPFY+ZtMIS4XKxLcVPojBWwEuJMfYsWfx57QlAQiaE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=206/6]=20docs:=20netw
         orking:=20update=20l2tp.rst=20to=20document=20PPP_AC=20pseudowires
         |Date:=20Wed,=2030=20Sep=202020=2022:07:07=20+0100|Message-Id:=20<
         20200930210707.10717-7-tparkin@katalix.com>|In-Reply-To:=20<202009
         30210707.10717-1-tparkin@katalix.com>|References:=20<2020093021070
         7.10717-1-tparkin@katalix.com>;
        b=bM4r5Zca1VYIYAGmphfsUC51P0AGirn3weQPIZYELla00WA1mnIIy2cytnnqpzmAb
         T7GGdtCUyh2Rx5x0Spyj0UJAbTPCq7tNrZCDtp/xQI/hMZp1rWNjt7g2agCtVi3aWz
         UVzMi8pOUE/TgEOccHRZlO7/1w8m1m3yT5iTxQphaxE1xnDv8TDg4YntWWTmasS8QH
         I9mcFeqZPrZHXM1z07W1B2rJ5d/v33b1WJmmdoyINCzQ6sg0I8ouSfhLRKq9nqPmLz
         huJUsfZj1QPj+OQoZgTuSDnQ5WzhLwU1ZbL3VdtgIAnfemRRbqTwj2zlPWupPZc2q9
         XoIpIdCbym2qw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 6/6] docs: networking: update l2tp.rst to document PPP_AC pseudowires
Date:   Wed, 30 Sep 2020 22:07:07 +0100
Message-Id: <20200930210707.10717-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alongside this, add a bit more of a description of the PPP and ETH
pseudowire types.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 Documentation/networking/l2tp.rst | 69 ++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking/l2tp.rst
index 498b382d25a0..76df531882e6 100644
--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -119,6 +119,26 @@ l2tp" commands). If ``L2TP_ATTR_FD`` is given, it must be a socket fd
 that is already bound and connected. There is more information about
 unmanaged tunnels later in this document.
 
+L2TP sessions, or pseudowires, may be of several different types. The
+``L2TP_CMD_SESSION_CREATE`` command specifies the pseudowire type to
+be created.
+
+================== ==================================================
+Pseudowire type    Description
+================== ==================================================
+ETH                L2TPv3 only.  Pseudowire carries Ethernet frames.
+                   The session instance is associated with a virtual
+                   network device ``l2tpethN``.
+PPP                Pseudowire carries PPP frames.  The session instance
+                   is associated with a virtual network device
+                   ``pppN`` which terminates the PPP session locally.
+PPP_AC             Pseudowire carries PPP frames which are switched
+                   from incoming PPPoE frames into the L2TP tunnel,
+                   allowing the PPP session to be terminated at the
+                   other end of the tunnel.  There is no virtual
+                   network device associated with the session instance.
+================== ==================================================
+
 ``L2TP_CMD_TUNNEL_CREATE`` attributes:-
 
 ================== ======== ===
@@ -177,26 +197,35 @@ CONN_ID            N        Identifies the tunnel id to be queried.
 
 ``L2TP_CMD_SESSION_CREATE`` attributes:-
 
-================== ======== ===
-Attribute          Required Use
-================== ======== ===
-CONN_ID            Y        The parent tunnel id.
-SESSION_ID         Y        Sets the session id.
-PEER_SESSION_ID    Y        Sets the parent session id.
-PW_TYPE            Y        Sets the pseudowire type.
-DEBUG              N        Debug flags.
-RECV_SEQ           N        Enable rx data sequence numbers.
-SEND_SEQ           N        Enable tx data sequence numbers.
-LNS_MODE           N        Enable LNS mode (auto-enable data sequence
-                            numbers).
-RECV_TIMEOUT       N        Timeout to wait when reordering received
-                            packets.
-L2SPEC_TYPE        N        Sets layer2-specific-sublayer type (L2TPv3
-                            only).
-COOKIE             N        Sets optional cookie (L2TPv3 only).
-PEER_COOKIE        N        Sets optional peer cookie (L2TPv3 only).
-IFNAME             N        Sets interface name (L2TPv3 only).
-================== ======== ===
+==================== ======== ===
+Attribute            Required Use
+==================== ======== ===
+CONN_ID              Y        The parent tunnel id.
+SESSION_ID           Y        Sets the session id.
+PEER_SESSION_ID      Y        Sets the parent session id.
+PW_TYPE              Y        Sets the pseudowire type.
+DEBUG                N        Debug flags.
+RECV_SEQ             N        Enable rx data sequence numbers.
+SEND_SEQ             N        Enable tx data sequence numbers.
+LNS_MODE             N        Enable LNS mode (auto-enable data sequence
+                              numbers).
+RECV_TIMEOUT         N        Timeout to wait when reordering received
+                              packets.
+L2SPEC_TYPE          N        Sets layer2-specific-sublayer type (L2TPv3
+                              only).
+COOKIE               N        Sets optional cookie (L2TPv3 only).
+PEER_COOKIE          N        Sets optional peer cookie (L2TPv3 only).
+IFNAME               N        Pseudowire-specific parameter:
+
+                              - For Ethernet, IFNAME sets the name to be assigned
+                                to the L2TP session network interface.
+                              - For AC/PPPoE, IFNAME specifies the name of the
+                                interface associated with the PPPoE session.
+                              - For PPP pseudowires, IFNAME is ignored.
+
+PPPOE_SESSION_ID     N        Sets the PPPoE session ID (L2TPv2 AC/PPPoE only).
+PPPOE_PEER_MAC_ADDR  N        Sets the PPPoE peer MAC address (L2TPv2 AC/PPPoE only).
+==================== ======== ===
 
 For Ethernet session types, this will create an l2tpeth virtual
 interface which can then be configured as required. For PPP session
-- 
2.17.1

