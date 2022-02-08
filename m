Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193654ADF5E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346362AbiBHRUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384356AbiBHRUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:20:50 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920D0C0612AA
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 09:20:48 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id k18so13425583lji.12
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 09:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=QkvXcwtJm/l2xeml8oCtQV8qg924IjVH+KjNXsPQei0=;
        b=iZvuB57XvX5pbR+VY8VgX+L0phc5Y3biw1Nh1gINmWRY+N7SxFkwqBHSyh5WEr2YED
         T3JHU2FrF8vYSSmmCbVEG7CB1wUrq3AQYaAX9WQWoASTwS2FUWH8zeRf0Jhms88IGtVf
         ZygkRxb0OR5mLiBA1MKBpycyHE85ZQ63WF4caEClSqw3TtdJ/YvamwkjAM+rGgFCcuI2
         YOI61X/at0C/TbvYR8O7xnYv91I51qSxrDgJLmsAsmknkuKFhqFfroyOYyMpTskP/3PJ
         3zkhbxOnyG6ADVnfnuV4ZnB+ZC6qOLMEdnaXPiL+uo9++J7kM4GQpJjH7FdbiSP4GEPZ
         lJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=QkvXcwtJm/l2xeml8oCtQV8qg924IjVH+KjNXsPQei0=;
        b=j71K0FvzjHjWLI4vjTUnwu1ZQl4FBJAXqJ908bZj0Qws/stIOJK9L1uXAm5OHdV2is
         p7UljJfPt1nxS9tZ5UZFKdqmCz284DZc0H+LghhLCQ0nbiy0dvl6OFAjOXtZxIfUiSsB
         M2PvhTX9r2Q7nhhhHPnTHdM2I4euV0QlqziYvNChHZlFjQIiDdYJwT6jKZVFZrMhZX0h
         fwWd7DfJ6Tv7bJ3deKasg5cewXFYH5xk9IuJBhlfPMrmnzL1E/TJSB2aFIzDD9I47AFV
         TnADvMqp6gWRucdaA/+vqoGmzk5dJinIX2NEiaxlBJK1vUcto5WcRa3lGqLy2ltWPA7P
         sufQ==
X-Gm-Message-State: AOAM532Fetv0RRuqEzrLWVswX3GjR3G/euq5Bsv0s/RLOaQQbESjZVxN
        RwqYwbU0BGj7OKxu8l+YzuND3hbuJzg=
X-Google-Smtp-Source: ABdhPJyIs47YvnWhKJQnm76ZbjqieFj1HxgyeitpvEVSN6ti2QTp+q3XeUyIXxF+56W6xH5a/MIyWA==
X-Received: by 2002:a05:651c:4ca:: with SMTP id e10mr3325457lji.405.1644340846583;
        Tue, 08 Feb 2022 09:20:46 -0800 (PST)
Received: from [192.168.88.200] (pppoe.178-66-239-7.dynamic.avangarddsl.ru. [178.66.239.7])
        by smtp.gmail.com with ESMTPSA id u18sm1021597lfs.205.2022.02.08.09.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 09:20:46 -0800 (PST)
Message-ID: <d376d06b-d1e3-c462-3a60-cc2e8ed7a147@gmail.com>
Date:   Tue, 8 Feb 2022 20:20:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH iproute2] libnetlink: fix socket leak in rtnl_open_byproto()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnl_open_byproto() does not close the opened socket in case of errors, and the
socket is returned to the caller in the `fd` field of the struct. However, none
of the callers care about the socket, so close it in the function immediately to
avoid any potential resource leaks.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 lib/libnetlink.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 7e977a67..6d1b1187 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -210,13 +210,13 @@ int rtnl_open_byproto(struct rtnl_handle *rth, unsigned int subscriptions,
 	if (setsockopt(rth->fd, SOL_SOCKET, SO_SNDBUF,
 		       &sndbuf, sizeof(sndbuf)) < 0) {
 		perror("SO_SNDBUF");
-		return -1;
+		goto err;
 	}
 
 	if (setsockopt(rth->fd, SOL_SOCKET, SO_RCVBUF,
 		       &rcvbuf, sizeof(rcvbuf)) < 0) {
 		perror("SO_RCVBUF");
-		return -1;
+		goto err;
 	}
 
 	/* Older kernels may no support extended ACK reporting */
@@ -230,25 +230,28 @@ int rtnl_open_byproto(struct rtnl_handle *rth, unsigned int subscriptions,
 	if (bind(rth->fd, (struct sockaddr *)&rth->local,
 		 sizeof(rth->local)) < 0) {
 		perror("Cannot bind netlink socket");
-		return -1;
+		goto err;
 	}
 	addr_len = sizeof(rth->local);
 	if (getsockname(rth->fd, (struct sockaddr *)&rth->local,
 			&addr_len) < 0) {
 		perror("Cannot getsockname");
-		return -1;
+		goto err;
 	}
 	if (addr_len != sizeof(rth->local)) {
 		fprintf(stderr, "Wrong address length %d\n", addr_len);
-		return -1;
+		goto err;
 	}
 	if (rth->local.nl_family != AF_NETLINK) {
 		fprintf(stderr, "Wrong address family %d\n",
 			rth->local.nl_family);
-		return -1;
+		goto err;
 	}
 	rth->seq = time(NULL);
 	return 0;
+err:
+	rtnl_close(rth);
+	return -1;
 }
 
 int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
-- 
2.25.1
