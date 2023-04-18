Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5506E6739
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjDROdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjDROdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:33:14 -0400
Received: from sonata.ens-lyon.org (sonata.ens-lyon.org [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADED83FC;
        Tue, 18 Apr 2023 07:33:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id C82DA2018B;
        Tue, 18 Apr 2023 16:33:11 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ggrempUKGqz6; Tue, 18 Apr 2023 16:33:11 +0200 (CEST)
Received: from begin (unknown [109.190.253.11])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id 95A4520181;
        Tue, 18 Apr 2023 16:33:11 +0200 (CEST)
Received: from samy by begin with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1pomOJ-00C9qp-0h;
        Tue, 18 Apr 2023 16:33:07 +0200
Date:   Tue, 18 Apr 2023 16:33:07 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] PPPoL2TP: Add more code snippets
Message-ID: <20230418143307.hth4yjkopy5se4md@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing documentation was not telling that one has to create a PPP
channel and a PPP interface to get PPPoL2TP data offloading working.

Also, tunnel switching was not mentioned, so that people were thinking
it was not supported, while it actually is.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
Difference from v1:
- follow kernel coding style
- check for failures
- also mention netlink and ip for configuring the link
- fix bridging channels

 Documentation/networking/l2tp.rst |   97 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 93 insertions(+), 4 deletions(-)

--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -387,11 +387,16 @@ Sample userspace code:
   - Create session PPPoX data socket::
 
         struct sockaddr_pppol2tp sax;
-        int fd;
+        int session_fd;
+        int ret;
 
         /* Note, the tunnel socket must be bound already, else it
          * will not be ready
          */
+        session_fd = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
+        if (session_fd < 0)
+                return -errno;
+
         sax.sa_family = AF_PPPOX;
         sax.sa_protocol = PX_PROTO_OL2TP;
         sax.pppol2tp.fd = tunnel_fd;
@@ -406,11 +411,95 @@ Sample userspace code:
         /* session_fd is the fd of the session's PPPoL2TP socket.
          * tunnel_fd is the fd of the tunnel UDP / L2TPIP socket.
          */
-        fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
-        if (fd < 0 ) {
+        ret = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
+        if (ret < 0 ) {
+                close(session_fd);
+                return -errno;
+        }
+
+        return session_fd;
+
+L2TP control packets will still be available for read on `tunnel_fd`.
+
+  - Create PPP channel::
+
+        int chindx;
+        int ppp_chan_fd;
+
+        ret = ioctl(session_fd, PPPIOCGCHAN, &chindx);
+        if (ret < 0)
+                return -errno;
+
+        ppp_chan_fd = open("/dev/ppp", O_RDWR);
+        if (ppp_chan_fd < 0)
+                return -errno;
+
+        ret = ioctl(ppp_chan_fd, PPPIOCATTCHAN, &chindx);
+        if (ret < 0) {
+                close(ppp_chan_fd);
                 return -errno;
         }
-        return 0;
+
+        return ppp_chan_fd;
+
+Non-data PPP frames will be available for read on `ppp_chan_fd`.
+
+  - Create PPP interface::
+
+        int ppp_if_fd;
+        int ifunit = -1;
+
+        ppp_if_fd = open("/dev/ppp", O_RDWR);
+        if (ppp_chan_fd < 0)
+                return -errno;
+
+        ret = ioctl(ppp_if_fd, PPPIOCNEWUNIT, &ifunit);
+        if (ret < 0) {
+                close(ppp_if_fd);
+                return -errno;
+        }
+
+        ret = ioctl(ppp_chan_fd, PPPIOCCONNECT, ifunit);
+        if (ret < 0) {
+                close(ppp_if_fd);
+                return -errno;
+        }
+
+        return ppp_chan_fd;
+
+The ppp<ifunit> interface can then be configured as usual with netlink's
+RTM_NEWLINK, RTM_NEWADDR, RTM_NEWROUTE, or ioctl's SIOCSIFMTU, SIOCSIFADDR,
+SIOCSIFDSTADDR, SIOCSIFNETMASK, SIOCSIFFLAGS, or with the `ip` command.
+
+  - L2TP session bridging (also called L2TP tunnel switching or L2TP multihop)
+is supported by bridging the ppp channels of the two L2TP sessions to be
+bridged::
+
+        int chindx1;
+        int chindx2;
+        int ppp_chan_fd;
+
+        ret = ioctl(session_fd1, PPPIOCGCHAN, &chindx1);
+        if (ret < 0)
+                return -errno;
+
+        ret = ioctl(session_fd2, PPPIOCGCHAN, &chind2x);
+        if (ret < 0)
+                return -errno;
+
+        ppp_chan_fd = open("/dev/ppp", O_RDWR);
+        ret = ioctl(ppp_chan_fd, PPPIOCATTCHAN, &chindx1);
+        if (ret < 0) {
+                close(ppp_chan_fd);
+                return -errno;
+        }
+
+        ret = ioctl(ppp_chan_fd, PPPIOCBRIDGECHAN, &chindx2);
+        close(ppp_chan_fd);
+        if (ret < 0)
+                return -errno;
+
+See more details for the PPP side in ppp_generic.rst.
 
 Old L2TPv2-only API
 -------------------
