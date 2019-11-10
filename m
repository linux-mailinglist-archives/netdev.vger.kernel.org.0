Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1634FF6731
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 05:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKJEV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 23:21:28 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:42502 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfKJEV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 23:21:27 -0500
Received: by mail-pg1-f181.google.com with SMTP id q17so6776146pgt.9
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 20:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7hlf/Gv74yLgIepPXw+m5+Vj57+1QzFIx6T+inHw9gk=;
        b=RYAbGxHxIFHLw/YDQOTepebU22h75nKQKyVhqZABRfK5PBPdhNyimfDmnYYAIJmtmk
         lVFJWbf0erIJxY7ltNtoHrhHHXPSiFQ80zU1qp2eJHxeCVoAHVrldrb98O0khbGy3y5N
         7zL8KS5LLTqcDoKYEZ6X6PGoHohEBrLIekbWXM9u4iyFiKq1iEbxEW9OS7dZQcqgsMVm
         ygCW0eGF4WqDj9Gs1XUBjuxHiGqfm5Czg3u8F8PAPnh5LsV8a7rmQI4JCgVieSM3woup
         M4FMjtU3ubmpAOCy6DpF5NIMAhnKmXg5glPiKzAsanleDi5L9vdxJXu7lfzi+7uzmWb8
         BTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7hlf/Gv74yLgIepPXw+m5+Vj57+1QzFIx6T+inHw9gk=;
        b=bhKpYPGl6lI7CtSTbYd+8cXptecqhdF9f3uctqED/6/JlbExCpco0kuWdBeOjDWwep
         fQ2njKa7ODdvNvDsnulSYp6a2w0A8/PvCPAE8lWmTjzZq7FZXYV5LaK+X0gI5RDYSHvx
         R99SIYJCFQY+Q1BdaGVX4Z/xDpVfyaZSXDxKplbnersND22DuG1JQtbyt+mJWG+s4Liv
         I6U2MR3JpWg8teH/n+QXFUuLMTdpdXBNLpejzDtB5m7YjzFjMqCcPfWetKPUDz7r2scV
         w9FPPoPL8KQFIGbJQyFbgD9l3+0CtpYWlyT6EVmheiA7dgXPIQiRlSCjnpimPwzAJZ9L
         n5xw==
X-Gm-Message-State: APjAAAUbAXvDAYIAT24e2UEARqOU1HXMmndekgfUkwEdVRIxWMn4uY2E
        fG/Yx2gqHQKe70MSFPBT2GUKRZf5
X-Google-Smtp-Source: APXvYqyltUHHU5nFXmS7foXSMZzdw1AEmjpKynjBcSKfTUcSkfYX8571bzXg/gO0jgMWMALJW9mNhQ==
X-Received: by 2002:a62:e708:: with SMTP id s8mr22485683pfh.80.1573359686810;
        Sat, 09 Nov 2019 20:21:26 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p16sm9781619pjp.31.2019.11.09.20.21.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 20:21:26 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] lwtunnel: get nlsize for erspan options properly
Date:   Sun, 10 Nov 2019 12:21:18 +0800
Message-Id: <ec64223f823f0915d6ffe0952944263a591a5623.1573359678.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

erspan v1 has OPT_ERSPAN_INDEX while erspan v2 has OPT_ERSPAN_DIR and
OPT_ERSPAN_HWID attributes, and they require different nlsize when
dumping.

So this patch is to get nlsize for erspan options properly according
to erspan version.

Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index ee71e76..e444cd1 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -613,9 +613,15 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_VXLAN */
 			   + nla_total_size(4);	/* OPT_VXLAN_GBP */
 	} else if (info->key.tun_flags & TUNNEL_ERSPAN_OPT) {
+		struct erspan_metadata *md = ip_tunnel_info_opts(info);
+
 		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_ERSPAN */
 			   + nla_total_size(1)	/* OPT_ERSPAN_VER */
-			   + nla_total_size(4);	/* OPT_ERSPAN_INDEX/DIR/HWID */
+			   + (md->version == 1 ? nla_total_size(4)
+						/* OPT_ERSPAN_INDEX (v1) */
+					       : nla_total_size(1) +
+						 nla_total_size(1));
+						/* OPT_ERSPAN_DIR + HWID (v2) */
 	}
 
 	return opt_len;
-- 
2.1.0

