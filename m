Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70AB6E3C88
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 00:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDPWHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 18:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjDPWHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 18:07:09 -0400
Received: from sonata.ens-lyon.org (sonata.ens-lyon.org [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E19F211C;
        Sun, 16 Apr 2023 15:07:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id 684102018B;
        Mon, 17 Apr 2023 00:07:04 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9aK28YQjlEw2; Mon, 17 Apr 2023 00:07:04 +0200 (CEST)
Received: from begin.home (apoitiers-658-1-118-253.w92-162.abo.wanadoo.fr [92.162.65.253])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id BDA6220189;
        Mon, 17 Apr 2023 00:07:03 +0200 (CEST)
Received: from samy by begin.home with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1poAWW-003eXA-0I;
        Mon, 17 Apr 2023 00:07:04 +0200
Date:   Mon, 17 Apr 2023 00:07:04 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <20230416220704.xqk4q6uwjbujnqpv@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing documentation was not telling that one has to create a PPP
channel and a PPP interface to get PPPoL2TP data offloading working.

Also, tunnel switching was not described, so that people were thinking
it was not supported, while it actually is.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
 Documentation/networking/l2tp.rst |   59 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -387,11 +387,12 @@ Sample userspace code:
   - Create session PPPoX data socket::
 
         struct sockaddr_pppol2tp sax;
-        int fd;
+        int ret;
 
         /* Note, the tunnel socket must be bound already, else it
          * will not be ready
          */
+        int session_fd = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
         sax.sa_family = AF_PPPOX;
         sax.sa_protocol = PX_PROTO_OL2TP;
         sax.pppol2tp.fd = tunnel_fd;
@@ -406,12 +407,64 @@ Sample userspace code:
         /* session_fd is the fd of the session's PPPoL2TP socket.
          * tunnel_fd is the fd of the tunnel UDP / L2TPIP socket.
          */
-        fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
-        if (fd < 0 ) {
+        ret = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
+        if (ret < 0 ) {
                 return -errno;
         }
         return 0;
 
+  - Create PPP channel::
+
+        int chindx;
+        ret = ioctl(session_fd, PPPIOCGCHAN, &chindx);
+        if (ret < 0)
+                return -errno;
+
+        int ppp_chan_fd = open("/dev/ppp", O_RDWR);
+
+        ret = ioctl(ppp_chan_fd, PPPIOCATTCHAN, &chindx);
+        if (ret < 0)
+                return -errno;
+
+Non-data PPP frames will be available for read on `ppp_chan_fd`.
+
+  - Create PPP interface::
+
+        int ppp_if_fd = open("/dev/ppp", O_RDWR);
+
+        int ifunit;
+        ret = ioctl(ppp_if_fd, PPPIOCNEWUNIT, &ifunit);
+        if (ret < 0)
+                return -errno;
+
+        ret = ioctl(ppp_chan_fd, PPPIOCCONNECT, ifunit);
+        if (ret < 0)
+                return -errno;
+
+The ppp<ifunit> interface can then be configured as usual with SIOCSIFMTU,
+SIOCSIFADDR, SIOCSIFDSTADDR, SIOCSIFNETMASK, and activated by setting IFF_UP
+with SIOCSIFFLAGS
+
+  - Tunnel switching is supported by bridging channels::
+
+        int chindx;
+        ret = ioctl(session_fd, PPPIOCGCHAN, &chindx);
+        if (ret < 0)
+                return -errno;
+
+        int chindx2;
+        ret = ioctl(session_fd2, PPPIOCGCHAN, &chind2x);
+        if (ret < 0)
+                return -errno;
+
+        int ppp_chan_fd = open("/dev/ppp", O_RDWR);
+
+        ret = ioctl(ppp_chan_fd, PPPIOCBRIDGECHAN, &chindx2);
+        if (ret < 0)
+                return -errno;
+
+        close(ppp_chan_fd);
+
 Old L2TPv2-only API
 -------------------
 
