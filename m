Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61028160F55
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgBQJxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 04:53:52 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:44958 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgBQJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 04:53:52 -0500
Received: by mail-pl1-f179.google.com with SMTP id d9so6498464plo.11
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 01:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8TQW2MMPyzSIqUDhFwAM22VWp8oXFENVG+pkQxcxX7Q=;
        b=Y/g2XTp24fXzvJAwyUAB+Dl36/QukLMjhJQvxN4bAM2OTvVCDz7YbUm/pmopTqWj35
         3hiurwwf5iQmiXqCIbqjTnImVlMgLzPX6EI2jba8TZqqBMPKvdf1dDkKZqPsMHh4am72
         6LQGBtjIuYcKa5UyWFIR6F20fYTZF1T860Se05Hv4Q4FLRsQJoU5nxyCGq9vcnwRmcZY
         pmYasqVq6ov6W4nS6x+r1kcnSClN7fQ9QKkPGTiYHgN/x+ieEfwpnm/1t40mccBAcAbx
         6iwemw+rKhuI5h3OcXIcgn6XFRRFlQNL1750mboTUnKx2+8V4kvRkkeu4TpywFEObmEr
         xd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8TQW2MMPyzSIqUDhFwAM22VWp8oXFENVG+pkQxcxX7Q=;
        b=GPkbp48oqFMkwsD/TDIC7ETXp84xZZGgY0oxBcrZWd4e9AK3imSDYaDGb/Z+ooKmln
         zYuAZxpoA0iVK5d+fyptMu3Y2I4USXXRbzfRMqur37Go+rPp74impy15F+Nd2vLrnhgu
         ctZAiPJBAdbpi4/CvLTm/LqHsSTolGLW2ABLz84skyP2Nyr68w6vcTggqQo0s/LhYeUF
         9e2N17c5yV5EJOhsj9yq0CI7coLAFngnEeM7RQz6nAhsxPiF2nXGzWR8Rd0ISL/0N7pH
         5ozXMwlXHYgrF+x65M+ffwalSwz/Q5pVftEfn5olGQcYjrsSCgtbPkduOoR4BUAZLz24
         /5gw==
X-Gm-Message-State: APjAAAUOJxLdduQ13MB4UnZOT0MkWXFb0OJx4E8TpvF9UcY3LU4iXVSO
        aJFmyHYEmwzplRHovgYPiQ0qlcHj
X-Google-Smtp-Source: APXvYqwczLe0RI8vm+HvvBvGWqCdpOx3baJjbQNUHt43F1gO2dl4wISi6uGbsQX//wJ+OS3CV3+JIQ==
X-Received: by 2002:a17:902:d20f:: with SMTP id t15mr16018677ply.55.1581933231388;
        Mon, 17 Feb 2020 01:53:51 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t65sm15823235pfd.178.2020.02.17.01.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 01:53:50 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     William Tu <u9012063@gmail.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2] erspan: set erspan_ver to 1 by default
Date:   Mon, 17 Feb 2020 17:53:43 +0800
Message-Id: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581933223.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 289763626721 ("erspan: add erspan version II support")
breaks the command:

 # ip link add erspan1 type erspan key 1 seq erspan 123 \
    local 10.1.0.2 remote 10.1.0.1

as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
won't be set in gre_parse_opt().

  # ip -d link show erspan1
    ...
    erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
                                              ^^^^^^^^^^^^^^

This patch is to change to set erspan_ver to 1 by default.

Fixes: 289763626721 ("erspan: add erspan version II support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/link_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index 15beb73..e42f21a 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 metadata = 0;
 	__u32 fwmark = 0;
 	__u32 erspan_idx = 0;
-	__u8 erspan_ver = 0;
+	__u8 erspan_ver = 1;
 	__u8 erspan_dir = 0;
 	__u16 erspan_hwid = 0;
 
-- 
2.1.0

