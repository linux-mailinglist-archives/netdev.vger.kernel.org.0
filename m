Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7800D6EA528
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjDUHr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDUHr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:47:27 -0400
Received: from mail-wr1-x464.google.com (mail-wr1-x464.google.com [IPv6:2a00:1450:4864:20::464])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3E9272C
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:47:24 -0700 (PDT)
Received: by mail-wr1-x464.google.com with SMTP id ffacd0b85a97d-2febac9cacdso866530f8f.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1682063243; x=1684655243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiVGHCxBrB3tms7HTTeWNZRDkGRhXAhNxfchi233Bdc=;
        b=UBy66uHmC1ehI08Yf/U6K9zkSXho/15j5avJnhRpMlZjn3jvB1z+XYMpd8eYTVMtCL
         3q4A5x1RqEGvWz5jivX5s8Wp+6OP79iGuy85nsuOueA2dM6o1DOqCogamk5VJMNQvb4G
         +4O4xfLdfBVJbXcB/zkbZo7JnUnrKGB6vKVyZDjDtUT6ufL23uVENsJ5OfIrpfit1mja
         Mq/UBgg+NW7adooGhIXkjMGsqWr7EIulI08EdxksQISuzx08W6nEYtUVaWVlE6lI6y3C
         SSQ//3gOp8l3rtYJp3r7xhJfs6EBMfNOwm3cxZhPXX5JDJseACcM5OfU1SsFAPxhAqFk
         nAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682063243; x=1684655243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiVGHCxBrB3tms7HTTeWNZRDkGRhXAhNxfchi233Bdc=;
        b=WNSg8H/0RNVssoBURoYgKYkDDwwAoJ/hr+CbNuxcZFAwJ67yT/h2PMdtSJkotMhZsn
         o3JyY1+Sn8l0pIw7mc5vSAD4FY7+z88TyoGJsX8pSIhfneGaPg10l5DOdR+xxFp0m0jV
         w/Su/b9old945LZdrSKu+iEoiQ3jkMnJMyShN6xUeJkAWVtvI04oFepsvkZFh5troWg8
         hr1IfM/77jajMthwVH+cDUJ1TV6Khr+6/eLY/k2sWpso7zJusAlZ6MvT5Jbwuil+XLSV
         tAzqdxyyHEGRYmIdIf5ndEWb62WGvyuf4iNUsHQgqvwpPYF3R33s3ARPzIEPwUVQWQUP
         Qceg==
X-Gm-Message-State: AAQBX9ct2WMuFbtw6mSJ/yti6rVOKp0HCQpfj+YRsEszvbEs4PPvCQMi
        nFbSWCJROsd1QVlb6kb0nP5ZmZlplYnphrvxZyvtZtUYFd3rDA==
X-Google-Smtp-Source: AKy350YMWDDFM8ikeSzRrdcL00UR4xGltuSbhaBE4fqLKM6MdhwRjCG4CztI7VDflK3ZUfltppGcReR2miaR
X-Received: by 2002:adf:f7c6:0:b0:2ff:c0c0:532a with SMTP id a6-20020adff7c6000000b002ffc0c0532amr3089587wrq.25.1682063242846;
        Fri, 21 Apr 2023 00:47:22 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id m1-20020a5d56c1000000b002fe882d1e52sm537230wrw.114.2023.04.21.00.47.22;
        Fri, 21 Apr 2023 00:47:22 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 96CF8601D3;
        Fri, 21 Apr 2023 09:47:22 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1pplUI-00089g-Fo; Fri, 21 Apr 2023 09:47:22 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Simon Horman <simon.horman@corigine.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 v3 2/2] iplink: fix help of 'netns' arg
Date:   Fri, 21 Apr 2023 09:47:20 +0200
Message-Id: <20230421074720.31004-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ip link set foo netns /proc/1/ns/net' is a valid command.
Let's update the doc accordingly.

Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/iplink.c           |  4 ++--
 man/man8/ip-link.8.in | 26 +++++++++++++++++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 8755fa076dab..9ac3b8cb2ad5 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -63,7 +63,7 @@ void iplink_usage(void)
 			"		    [ mtu MTU ] [index IDX ]\n"
 			"		    [ numtxqueues QUEUE_COUNT ]\n"
 			"		    [ numrxqueues QUEUE_COUNT ]\n"
-			"		    [ netns { PID | NETNSNAME } ]\n"
+			"		    [ netns { PID | NETNSNAME | NETNSFILE } ]\n"
 			"		    type TYPE [ ARGS ]\n"
 			"\n"
 			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
@@ -88,7 +88,7 @@ void iplink_usage(void)
 		"		[ address LLADDR ]\n"
 		"		[ broadcast LLADDR ]\n"
 		"		[ mtu MTU ]\n"
-		"		[ netns { PID | NETNSNAME } ]\n"
+		"		[ netns { PID | NETNSNAME | NETNSFILE } ]\n"
 		"		[ link-netns NAME | link-netnsid ID ]\n"
 		"		[ alias NAME ]\n"
 		"		[ vf NUM [ mac LLADDR ]\n"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a4e0c4030363..e23474b3589c 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -49,7 +49,7 @@ ip-link \- network device configuration
 .IR BYTES " ]"
 .br
 .RB "[ " netns " {"
-.IR PID " | " NETNSNAME " } ]"
+.IR PID " | " NETNSNAME " | " NETNSFILE " } ]"
 .br
 .BI type " TYPE"
 .RI "[ " ARGS " ]"
@@ -118,7 +118,7 @@ ip-link \- network device configuration
 .IR MTU " ]"
 .br
 .RB "[ " netns " {"
-.IR PID " | " NETNSNAME " } ]"
+.IR PID " | " NETNSNAME " | " NETNSFILE " } ]"
 .br
 .RB "[ " link-netnsid
 .IR ID " ]"
@@ -465,8 +465,15 @@ specifies the desired index of the new virtual device. The link
 creation fails, if the index is busy.
 
 .TP
-.BI netns " { PID | NETNSNAME } "
-specifies the desired network namespace to create interface in.
+.B netns
+.RI "{ " PID " | " NETNSNAME " | " NETNSFILE " }"
+.br
+create the device in the network namespace associated with process
+.IR "PID " or
+the name
+.IR "NETNSNAME " or
+the file
+.IR "NETNSFILE".
 
 .TP
 VLAN Type Support
@@ -2188,10 +2195,15 @@ the interface is
 .IR "POINTOPOINT" .
 
 .TP
-.BI netns " NETNSNAME " \fR| " PID"
-move the device to the network namespace associated with name
+.B netns
+.RI "{ " PID " | " NETNSNAME " | " NETNSFILE " }"
+.br
+move the device to the network namespace associated with process
+.IR "PID " or
+the name
 .IR "NETNSNAME " or
-.RI process " PID".
+the file
+.IR "NETNSFILE".
 
 Some devices are not allowed to change network namespace: loopback, bridge,
 wireless. These are network namespace local devices. In such case
-- 
2.39.2

