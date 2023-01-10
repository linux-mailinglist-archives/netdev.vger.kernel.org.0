Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D0664505
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjAJPhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjAJPhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:37:22 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF51EEF2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:37:10 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i9so18152880edj.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7NIQeuqySBIn+/uDaa/soJfoHNgcOoKhnCbDXaRsxm0=;
        b=zqh6Mgg82B1tXQe7W9TP1iNKzPVo0xchv59YaW05C7Yku6/PTD8KofxLrzGeWU4Ra/
         rMjD40FwxLHOPeheHMsIRiqpGv7yARDE7wU62JKGc6faYcnjohKSUjGrjc+O/Xe76nQP
         q3tKzbjGiw9kfa01cSsil6K346g4xAdO+pF8KIguqW7LPoUjEvDjohAuUbWT4mHWLA5x
         OAzEaQryqEtI9wTHtUpbTszHIbNrPxByk9nDxTesIB3epVze6t0O4CoIqaL+tWDfUUo1
         sJVrDDGFOQ/HskDqP/iaadoHKSpBEyw734arLRPW/HplmO0JUcqjH65VqR6dDBMDz7aM
         i1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NIQeuqySBIn+/uDaa/soJfoHNgcOoKhnCbDXaRsxm0=;
        b=3wAsHSD357W7wDnjszeC+8Wnta/XkdoVVcltpwcoxlIYxwSIHkZ9R0SKWls6ZNhjXX
         LBNU6u/BEe/R1VQwcIJHtghRKwXDz38FXaVciL8Lq39pJt3xKt/IYzGriETuUMb21V+1
         0M/1xzcgJYY0BvTuWICLXMTlD5ZHNdbB2jabFMtG8Vxz2nhGrLUwK0jeVrePgqVkUTfm
         JFMNcHBcx+ckmC3R0XzMwQ5tryzQXsO8HQk3GT7iyhyUsSr+IWQzG4oYtXdBCMSWaT/i
         /qUxxtwF/yhSxVicsDsDXf99DJwr20Lx+nzhg052M+azAEhdfGl6EYUak/JMjYICFuw7
         mIJw==
X-Gm-Message-State: AFqh2kqqGaTMvbOQ1FPf8JfIm7qvQDjZytzoSZCCmgP80I445koMYuuQ
        LDuT1d1wMXDFStENgI4CglJubg==
X-Google-Smtp-Source: AMrXdXtcp7K3vPf9p5zACoPucDR8gxDti/v5Ic+Pl2ZROby/+0iDmXPIyKJUz6KeIyZN5fAtABoeuQ==
X-Received: by 2002:aa7:c24e:0:b0:499:c083:fd2e with SMTP id y14-20020aa7c24e000000b00499c083fd2emr4105381edo.36.1673365028536;
        Tue, 10 Jan 2023 07:37:08 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id y11-20020aa7c24b000000b004954c90c94bsm5047068edo.6.2023.01.10.07.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 07:37:08 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 10 Jan 2023 16:36:20 +0100
Subject: [PATCH iproute2] mptcp: add new listener events
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230110-mptcp-events-listener-net-v1-1-88a946722fe7@tessares.net>
X-B4-Tracking: v=1; b=H4sIAPSFvWMC/x2NQQqDMBBFryKz7kCi3dirlC6S+FsH6hgyqRTEu
 zd2+T68/3YyFIHRrdupYBOTVRv4S0dpDvoCy9SYetcPznvHS64pMzZoNX6LVSgKKyqPKcJdB6TJ
 jdT8GAwcS9A0nw9LED3nXPCU7z95J8ll/VT09DiOH1gC38mMAAAA
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
X-Mailer: b4 0.11.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2802;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=QqWVX+k2rpTiwxxRFOs9wtaop9d+Tb6WckSGb/ajKOs=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjvYYjAtm5ss+jKqAb/yvhlh2gJnz0lCPaPrp1C5pB
 KYEeHZKJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY72GIwAKCRD2t4JPQmmgc7KqEA
 DUiQlADKZjtugI4einqwFhOD0Kwcof356ffKZJt9imhU91XNn9Yd1OECQrVWUUeNW9jbvvH9GW8b5h
 mswh0B1bNFc9h2r9zFxNspZnPDdYRmbzoVvh4uW9rBLb8MIs1cOYLH3Ri6kyUP7EX7hHx+MDAXSTtV
 el2O4Hip8J6RhgJiR7QvEOfyjOBho4dsorMwaIG0jlF6h1/43SS6SCxxj2TYg71VC3tjlvlHxUonKP
 AKfj1JSh9u2u2GwdAEyKob9fJkZzPAfB45gG+RIPPQgsWh9IC7G9YOfpC4bsbTo7tonjQ9cRE0ag3V
 IArkx3JidQYpe5+AC5M9D+IkaolWdDz+AIbWTDokO1UUhUgmTPsqVh8YTOfSKTwxMpc1WQlGejVtKt
 szR5H5/t9EqcKxh11SouezaMYoOGWEwA4sRdfIh0MhXX3hInPEs2eOUwvVE0tiZTbM9/ZT1JOnkpQT
 fRtTclrW4O4V6bHUwGE4n8OQbgFD5TLmoapfEqz1LGvlVLnh83vxbosxvY3awFdaYIkVsgHPbV8Ezt
 V0RjlczkCdwBM0hryGQkuEMeKv8M8kWIPJGk0va8g362xTQgXVSo96y2JTb1khDVE+UAh60s4m7h1k
 X1A+bDHHUZ84zvIn6/3Xd8MgJ9bg4PFWcHbBTHuvEUqmXnSSfmdIvhWf0a0g==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These new events have been added in kernel commit f8c9dfbd875b ("mptcp:
add pm listener events") by Geliang Tang.

Two new MPTCP Netlink event types for PM listening socket creation and
closure have been recently added. They will be available in the future
v6.2 kernel.

They have been added because MPTCP for Linux, when not using the
in-kernel PM, depends on the userspace PM to create extra listening
sockets -- called "PM listeners" -- before announcing addresses and
ports. With the existing MPTCP Netlink events, a userspace PM can create
PM listeners at startup time, or in response to an incoming connection.
Creating sockets in response to connections is not optimal: ADD_ADDRs
can't be sent until the sockets are created and listen()ed, and if all
connections are closed then it may not be clear to the userspace PM
daemon that PM listener sockets should be cleaned up. Hence these new
events: PM listening sockets can be managed based on application
activity.

Note that the maximum event string size has to be increased by 2 to be
able to display LISTENER_CREATED without truncated it.

Also, as pointed by Mat, this event doesn't have any "token" attribute
so this attribute is now printed only if it is available.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/313
Cc: Geliang Tang <geliang.tang@suse.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 ip/ipmptcp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index ce62ab9a..beba7a41 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -454,6 +454,8 @@ static const char * const event_to_str[] = {
 	[MPTCP_EVENT_SUB_ESTABLISHED] = "SF_ESTABLISHED",
 	[MPTCP_EVENT_SUB_CLOSED] = "SF_CLOSED",
 	[MPTCP_EVENT_SUB_PRIORITY] = "SF_PRIO",
+	[MPTCP_EVENT_LISTENER_CREATED] = "LISTENER_CREATED",
+	[MPTCP_EVENT_LISTENER_CLOSED] = "LISTENER_CLOSED",
 };
 
 static void print_addr(const char *key, int af, struct rtattr *value)
@@ -492,11 +494,12 @@ static int mptcp_monitor_msg(struct rtnl_ctrl_data *ctrl,
 		goto out;
 	}
 
-	printf("[%14s]", event_to_str[ghdr->cmd]);
+	printf("[%16s]", event_to_str[ghdr->cmd]);
 
 	parse_rtattr(tb, MPTCP_ATTR_MAX, (void *) ghdr + GENL_HDRLEN, len);
 
-	printf(" token=%08x", rta_getattr_u32(tb[MPTCP_ATTR_TOKEN]));
+	if (tb[MPTCP_ATTR_TOKEN])
+		printf(" token=%08x", rta_getattr_u32(tb[MPTCP_ATTR_TOKEN]));
 
 	if (tb[MPTCP_ATTR_REM_ID])
 		printf(" remid=%u", rta_getattr_u8(tb[MPTCP_ATTR_REM_ID]));

---
base-commit: 1ba8021057acde2ea06f5b52c370f7cc86fb2b3e
change-id: 20230110-mptcp-events-listener-net-9cbe043ecd09

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>
