Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13E06E8D2A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjDTIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjDTIub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:50:31 -0400
Received: from mail-ej1-x661.google.com (mail-ej1-x661.google.com [IPv6:2a00:1450:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3526EB3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:48:59 -0700 (PDT)
Received: by mail-ej1-x661.google.com with SMTP id z6so4680958ejc.5
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1681980535; x=1684572535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIJ/jeWKp7SBrtxInDfs3IxO+7s3/ZCB6bYZXR/z3xs=;
        b=j7bhANNRoOY7704a7dpmLR0qpQsMi6JyZbzJQ5wf+uyJD+FrpD+ZF81Fdw6fhoY/T2
         oSAkv50dXzz2rQbM2jZaUQoMVg5Ja97DYEDvkSYLBpQQNjQwGc8zkSff35VBMjK1NjJW
         MnwHVqY16ZV3ZrDx/PJd5lK1BhIBmdxaSDNVWtuSoopSql9EnDrs9lwvHwp2TxQ7Uc8Q
         gp7/RZ5sIWBEbvG0ANXJWCMh8cEQ0hbclbjrw/bb5Xz42FVUbqsh0luuNoyuzoSX7WvM
         Atz/wZI51S7rK5AaUWlVgP0l9kYUczhDb9u12qgnslB2513dCp601l64yuDZMHMzuLKh
         k5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980535; x=1684572535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIJ/jeWKp7SBrtxInDfs3IxO+7s3/ZCB6bYZXR/z3xs=;
        b=b/t4vDj+OOQcwfBOnAOd2AEWH3ew8003n4KnWyCLonygDJ5gZUxg1I633neLRGyWXt
         4sOPuKahRNS3s5xf+8WwOzYloy199j0EjPqIG5j18qxAV4FggukV2r8ne6KpLugdBfc3
         K2roZZrieScDaEM4UO2cLaIQbxYqEC7vPHweMPqIrZQNGq8cqGasIA+Th/CFbUhGCouw
         jN8j6/84n8H501IwGUEcKnyd18s3nGZxOQ1dYo6wMS/YD3lZ9c6KJxEq/FSAVgYQUJ1F
         VZmWctmSxWw3OME+YNXIhnQunBcfKiYPX+tmtb3SEDs16nJ7O7CyHZXdJvWudLc4Ork5
         2hMg==
X-Gm-Message-State: AAQBX9c9ZbAXAsIVCacdyjFjcBsAfrOtWZcQKighEcCMfErjQKExfkUy
        1NogITgz8wceahhTc1eUVB8OXnIR0PHGDqp1bvaY97b9LY05gw==
X-Google-Smtp-Source: AKy350a5+rS6GSBhPfP0AOyrD27QPm+SbxE/ySvWCZEPJbUrXFKqnfyqf0rlLRsHNm/Pe5pEGi1ap2mihqoA
X-Received: by 2002:a17:906:dfef:b0:94a:a887:c29f with SMTP id lc15-20020a170906dfef00b0094aa887c29fmr805126ejc.68.1681980535319;
        Thu, 20 Apr 2023 01:48:55 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id qw16-20020a1709066a1000b0094f62d46e4asm378239ejc.125.2023.04.20.01.48.55;
        Thu, 20 Apr 2023 01:48:55 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 12741602A0;
        Thu, 20 Apr 2023 10:48:55 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1ppPyI-0005bn-VN; Thu, 20 Apr 2023 10:48:54 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Simon Horman <simon.horman@corigine.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2 v2 2/2] iplink: fix help of 'netns' arg
Date:   Thu, 20 Apr 2023 10:48:49 +0200
Message-Id: <20230420084849.21506-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
References: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 man/man8/ip-link.8.in | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

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
index a4e0c4030363..59deaa2c1263 100644
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
@@ -465,7 +465,7 @@ specifies the desired index of the new virtual device. The link
 creation fails, if the index is busy.
 
 .TP
-.BI netns " { PID | NETNSNAME } "
+.BI netns " { PID | NETNSNAME | NETNSFILE } "
 specifies the desired network namespace to create interface in.
 
 .TP
@@ -2188,9 +2188,11 @@ the interface is
 .IR "POINTOPOINT" .
 
 .TP
-.BI netns " NETNSNAME " \fR| " PID"
+.BI netns " NETNSNAME " \fR| " NETNSFILE " \fR| " PID"
 move the device to the network namespace associated with name
 .IR "NETNSNAME " or
+the file
+.IR "NETNSFILE " or
 .RI process " PID".
 
 Some devices are not allowed to change network namespace: loopback, bridge,
-- 
2.39.2

