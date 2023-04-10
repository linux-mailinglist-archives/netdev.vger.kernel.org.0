Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2D6DCE29
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 01:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjDJXfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 19:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjDJXfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 19:35:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AC326A9
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 16:35:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e13so5762453plc.12
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 16:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1681169712; x=1683761712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qBNNnBiuoc4JXyCGVr7x6sfUDNe5El4k/2qn6fgM/Jo=;
        b=7IG/muDu2TkCaBOQGY3gKI48gqRhZas4hNQMD4wJcSHnpq2ZfifZyzfdpQNCXh1NYS
         32R2Jss5eV2gjGLbysK2KIyBgzDWKs3ctUxyiW2qXulKNJT+oSw5SD7mSN+cf8ExhvCi
         BH5JDc/VHkKzyiJbpUM9jcFrYzLKG0KrU7CHMoBWY5PbfInLiE3/OJ05l39JbYpW9BtE
         A1L1kI3MMeHVXdkdiwTCEFIWD3EIX6I3gLx48+YE7tlZuH1pPaVrOrF0VQwfO4JH0vOT
         tnZtebAboJg410mh8iplBqaRNGyTGzg6/vTCdP6sUqU5PIhF0huT8JN9Mq21J7vX1DrQ
         dn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681169712; x=1683761712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qBNNnBiuoc4JXyCGVr7x6sfUDNe5El4k/2qn6fgM/Jo=;
        b=uXSebAxDx6DS4YJ+H90dCkaXnZ8VgzZ1YOgYSIFgpCLPXpIHGLjsgEASeGrCu+xysf
         stmEBpEJ9LrMUYwnsNmPtuFuj7OkwhwH4uXPxy0XuBQM2pjx8PxtHi3JPlQCFaJLwo4f
         Wy13Xg7wd7N7JMizWWAb3EhuxDZaGC4oKMLcS7Fzxe6HXY+qI+rI+v/fAAiqbxcqu0zu
         /MtrcdKcoD6etpDzOkzapqnFNGZY0VtmLSNLoa6bceQzwZAT8WSPevJxzPns5vX2JPOY
         Sya7Iqm1rFQcWJY+g7qR6upqTeylolviHVazmufQg1YaTMKmuQj4XSjhPWfLwB8KgXuv
         2Rkg==
X-Gm-Message-State: AAQBX9d9DiL7fm+rkGVaEe1I4IL56I1z6XsewG4FTH0J3+vNLnCap0oR
        rwxf6bT7u12yz7sYUxZF7WNbVDQSxMFPUkCMVmH3IaXn
X-Google-Smtp-Source: AKy350YLjB7k+gDvS7qFwrtq7BZZf1ufghbMmD6w+vz2KNkUpGcaEmUpu0DYTMl9Sq6BkleWtxe3qQ==
X-Received: by 2002:a17:902:ea12:b0:19e:7889:f9fb with SMTP id s18-20020a170902ea1200b0019e7889f9fbmr17184018plg.68.1681169711767;
        Mon, 10 Apr 2023 16:35:11 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t22-20020a170902b21600b001a20791250esm8346801plr.22.2023.04.10.16.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 16:35:11 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     bluca@debian.org, dsahern@kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Robin <imer@imer.cc>
Subject: [PATCH iproute2] iptunnel: detect protocol mismatch on tunnel change
Date:   Mon, 10 Apr 2023 16:35:09 -0700
Message-Id: <20230410233509.7616-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If attempt is made to change an IPv6 tunnel by using IPv4
parameters, a stack overflow would happen and garbage request
would be passed to kernel.

Example:
ip tunnel add gre1 mode ip6gre local 2001:db8::1 remote 2001:db8::2 ttl 255
ip tunnel change gre1 mode gre local 192.168.0.0 remote 192.168.0.1 ttl 255

The second command should fail because it attempting set IPv4 addresses
on a GRE tunnel that is IPv6.

Do best effort detection of this mismatch by giving a bigger buffer to get
tunnel request, and checking that the IP header is IPv4. It is still possible
but unlikely that byte would match in IPv6 tunnel paramater, but good enough
to catch the obvious cases.

Bug-Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1032642
Reported-by: Robin <imer@imer.cc>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iptunnel.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/ip/iptunnel.c b/ip/iptunnel.c
index 02c3670b469d..b6da145913d6 100644
--- a/ip/iptunnel.c
+++ b/ip/iptunnel.c
@@ -17,6 +17,7 @@
 #include <net/if_arp.h>
 #include <linux/ip.h>
 #include <linux/if_tunnel.h>
+#include <linux/ip6_tunnel.h>
 
 #include "rt_names.h"
 #include "utils.h"
@@ -172,11 +173,20 @@ static int parse_args(int argc, char **argv, int cmd, struct ip_tunnel_parm *p)
 			if (get_ifname(p->name, *argv))
 				invarg("\"name\" not a valid ifname", *argv);
 			if (cmd == SIOCCHGTUNNEL && count == 0) {
-				struct ip_tunnel_parm old_p = {};
+				union {
+					struct ip_tunnel_parm ip_tnl;
+					struct ip6_tnl_parm2 ip6_tnl;
+				} old_p = {};
 
 				if (tnl_get_ioctl(*argv, &old_p))
 					return -1;
-				*p = old_p;
+
+				if (old_p.ip_tnl.iph.version != 4 ||
+				    old_p.ip_tnl.iph.ihl != 5)
+					invarg("\"name\" is not an ip tunnel",
+					       *argv);
+
+				*p = old_p.ip_tnl;
 			}
 		}
 		count++;
-- 
2.39.2

