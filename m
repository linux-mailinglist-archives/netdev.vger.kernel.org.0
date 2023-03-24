Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C66C8301
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjCXRMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjCXRMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:12:06 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1CD21953
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so1459896wms.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679677923;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SWubI3gP1geg1ucxdfNQCa8sYMENfAIXdm+9lJqXCzI=;
        b=1LYEdnpyKt13LPHR0Js0qUP5t+OnGaFyqRaMxeViU3Kq5CTMOkpOK/00hnCs8YmT4L
         AqDhULy4Eu8SUxOl9PGB8dHuSHy3sZl8IFh2AHX6H2kBU11CfgLChoJEIxEkWirBMu5D
         wbPa374Qaw8AFfWmcA42AGfJqsziQsQVyJvVAMqrlY7wS+f7w6l+3KM4pogNgrydT62o
         u3CIt1jUwD9M06OqsrGHJVFN2mM3sFSPmfGteXD/86O/YSYYyRuvM8RoyK/W3y22eMKZ
         7RYGHzrF0poDr8u7gSXl3mvWxMzgY6xPkXRNQsgqSq2+2u/lYVrNsM7xREPzUuHfR9J9
         XzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677923;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWubI3gP1geg1ucxdfNQCa8sYMENfAIXdm+9lJqXCzI=;
        b=8DVHYRibbiR9dVbK4RZUJgUOSJqpdh7iSoHnirieTlOkssH7T5/VQYGWMzFy9ZgMDP
         8TjUt5akqT+suEAEh6igIAfVnBqlxK1oaWEEXjMCbnr3wGdmijAKg6mgePm0r00SoPxK
         JhfYM44xRdDrHSttvem5NN2L4XSlt7uQQb+8RWkgu53kvPRQHlV7t3KDo/XPUEUAfkpZ
         I2yQwsiR+dbFHp8T1rBneLPjY259J3bvRKQ4BxH/fkO5JAY8e20ijSKZB8S8jVlTTHYO
         R0ppKx3wkPLU05k0qufb/E2W/L4gDXyhO3Il+KKsOStE7Y+JCnSvtRni1PMS/gxrszjR
         mniQ==
X-Gm-Message-State: AO0yUKVH6bSb9uyZpZkKKUioSpTa9WLK3UMN9x89PoQPe5eSu2NT7ty/
        UcvVOHktd7suzGfZahr8HtSR6g==
X-Google-Smtp-Source: AK7set+UDFwpZN4PVC6ZyaQv2nlh8nuYaIVQZAe5dyvI453GkzVLNHI2+QClIncuHwSO9Tr+MZkq6A==
X-Received: by 2002:a05:600c:d9:b0:3ed:46e2:85fb with SMTP id u25-20020a05600c00d900b003ed46e285fbmr2915358wmm.33.1679677923137;
        Fri, 24 Mar 2023 10:12:03 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n17-20020a1c7211000000b003edf2dc7ca3sm5336285wmc.34.2023.03.24.10.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:12:02 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 24 Mar 2023 18:11:30 +0100
Subject: [PATCH net-next 1/4] mptcp: avoid unneeded address copy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v1-1-5a29154592bd@tessares.net>
References: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=740;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=So4mzRtrXIJRD2ZN6IwFIBWGw9rUyByeoDq6UPFlPB8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHdnhUE6bujCgMc7JoONVNk9QEbRSg69X5Zw2U
 MLvfYdnBWOJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZB3Z4QAKCRD2t4JPQmmg
 c4AgD/sHGKIbvtwQeGEX+uDffWu8d2299L7UjnsA2GofJy3mNHrGy6qTZv7SyNMvUxgne6rLjuV
 VQ+ErPrh7GxNKGZrcDZupDgsWG37g00b8d9LNJ7Ah+mbv6Q9jhK+6adtPfTsyLcXYmhcASzSTUq
 G6+LbH97tCsRgnnDm5XU8YpU0LwBkkO6wqVmGC2nIeQ08BrqZdFz2rV1TNCAm5vydQJp8vUQc31
 /a+EIpIyJNs2o15vrLkY86IU5y8Cc6uUnSBLMJeBv4sxO5s6pK5EX1agdMtKHVI2UgjdspQolxu
 utE6+WSenn2cMCFU2rDsMPIQPKbomy22hLWYqXLJsecwgFrJ32rYDFeVb0DQ8WYnVP2pvhOxWA3
 xpuMf60+Uerl4Y3eZtqGja5C7SPYJBBX/UPKHJzmF+UGLDSUzQWcKrqININyfltivPl9x55VpLd
 jKnx4XF1YFr8qRHwyn+Gl0Js1SL+EQVJ+hMXgWKgWN1qm5ZIXgdYpVsv24Q/gTRqB5BYlR2+Pyd
 zC0wjSQaL3qiTAy4EahAlbXgvF4S+GzxHP+7vrF6SSsS6EYuaQ7BMUA0dKA7Y0/FjIWz3tq7Zfj
 J0zyVdVdFv+hOSmi3UaX7+h4lzzJb/8v4Df/qjf0Yb2ZU1JUNhlYTn4rTfPvThbwBpXe2vx1xrt
 V9wRVwhZL4Rtamg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

In the syn_recv fallback path, the msk is unused. We can skip
setting the socket address.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index dadaf85db720..a11f4c525e01 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -821,8 +821,6 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto dispose_child;
 			}
 
-			if (new_msk)
-				mptcp_copy_inaddrs(new_msk, child);
 			mptcp_subflow_drop_ctx(child);
 			goto out;
 		}

-- 
2.39.2

