Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173C56EA2A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbfGSRbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:15 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39843 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731433AbfGSRbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:13 -0400
Received: by mail-qk1-f193.google.com with SMTP id w190so23786868qkc.6
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2MMCFCBJboEB1CIyV6dVGBXQRDYkVd8+DYCGoW0iWWE=;
        b=AjeF2M5J0BU1eQpiEOd0rKkfPUbNSRlth8FdcP8Rk+Hd8JlQ/sGAkCzuT20PJ+izCE
         Z6HtIg6NUXZ+VpIXRWMH0FqjsXZSkMUL0dGYc6FBBeK/tCoAYgNXKAJc4BNjU9jdmINL
         SsqezIaXnIAepoF0zqrLZ2BT0TshNhQ+nSXquZMovPNZg2rEWFVD21gLqcC4Sgzu6xaB
         aFKwzJUKsTnZy+Df1UGXgMhCXAfQl4obUz680uOWe2beItkT9VTLD2cYvlhBvA4o2S3z
         0kHK9QRVXApKaNmYYvcGE13MeJi54C2WRjv55PEEDnKxleBBnEZ234DJgyvvWE7QbH7j
         66KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MMCFCBJboEB1CIyV6dVGBXQRDYkVd8+DYCGoW0iWWE=;
        b=m4OknxowjJ3eW4Bcg3dp3/4aRHwNMOPlC0zFM15YsLXr3o8jhE1IRLWd9oWDdb6qB8
         zNCq1vzZSkIsdyGv7rWapdN+GMrX2BR0mhl7TzJ5DQd/gKovw19OA0SKzJzkXISgQXCQ
         2QCjlxozAoIMp6sTJsAJwEnMA04EJJ0m7iYutWjkTDaUi4ws7MTGXs7CvWe1ZflI3+Uy
         vVoy11y5AzwAsq4RQxnUB1Dfiz4/0PU3X77Fa8/Z+IlRINYWTrYVwRLUjdLMBw9tGg5J
         VhfOraZTdibymWYUreD6lVhb8+4DXOAJsb7j3bir/tjy544nRAIIrgBHy5c5BFq9eJ/s
         unFA==
X-Gm-Message-State: APjAAAUhkHs5lrFVezybGBNF5jRYjva0KdA5LYZXh+S/F+7WgR3JUxoF
        Rep2QRrodT9ErWQii4t9A+LCPQ==
X-Google-Smtp-Source: APXvYqwSnFM499KiZ0X7Qn+TSKes60QYSIBBhJr7Ycrd5UAt1Ywy2z9C+oyJfDqCUgGTIKzFCsCOiA==
X-Received: by 2002:a05:620a:533:: with SMTP id h19mr35861754qkh.325.1563557472146;
        Fri, 19 Jul 2019 10:31:12 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:11 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf v4 08/14] bpf: sockmap, only create entry if ulp is not already enabled
Date:   Fri, 19 Jul 2019 10:29:21 -0700
Message-Id: <20190719172927.18181-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

Sockmap does not currently support adding sockets after TLS has been
enabled. There never was a real use case for this so it was never
added. But, we lost the test for ULP at some point so add it here
and fail the socket insert if TLS is enabled. Future work could
make sockmap support this use case but fixup the bug here.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 56bcabe7c2f2..1330a7442e5b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -334,6 +334,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_psock_link *link;
 	struct sk_psock *psock;
 	struct sock *osk;
@@ -344,6 +345,8 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
+	if (unlikely(icsk->icsk_ulp_data))
+		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)
-- 
2.21.0

