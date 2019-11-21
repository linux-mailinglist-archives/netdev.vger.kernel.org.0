Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68555105BC2
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfKUVTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:19:21 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36276 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfKUVTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:19:21 -0500
Received: by mail-pj1-f67.google.com with SMTP id cq11so2080928pjb.3
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHDIZ71LoHne5AiJ7I84KDJ26EIVE8CZ/k6+hUCaAe4=;
        b=ruly4/nSvxmnvM/MMmuXwnAMZ3/Pa4V1RyJQoWftk3fsX7Lo0o7Yg4+ElMspy1zp7q
         r7hbB3LOJjMrdXFsbSf1Z3LhsA7SdMPfS42GRkXw4K8FQKO9ffZ/E8aBWZeH/LdCd2N8
         IeeBexkoaaklpszF/7l4cayJtroeLiDjgpHIX4oHkR6yn5ZlYx8vgSKN51oR7xvLVz6t
         VLDqjaeX8Ua69B7q8qsdNlMA/bDyoYBIPXb/jxNtse1nU5fCYaDrznsZhgZ9/KDxmkoQ
         xsGdmrH4Cu9PjiUZ5daa8hElFuuRaTPswzPvN1wtEA7GKNPUYStcv9G/W8akjf3zI6LN
         gihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHDIZ71LoHne5AiJ7I84KDJ26EIVE8CZ/k6+hUCaAe4=;
        b=OAvSfHW1OyOMTWSnurnZlcqMkL5gsRYr8JoZsQ8VuTK/phlwuSSPur3OcWGGiH7CGF
         3sEdC0wwybtFl4TRDnKNHr3p24GzkNVF88H2KxVpTCk/ImDhfsJvXJRBRqN3/Bc+++/S
         IdhTXHuGbPUq5YVkuVSJ9TAm+9j0pqGvaAqPxDyNDsw8EX20Hvggb/vdTSTiNkBvrdO+
         iGrz/rKM/6DWnHWdJD1yg75wSVUmemqelx3uW0Qb4xlK2Ykcz75qY0k2RnjKqimZZ3HY
         5R6LNblFED5AMbIweOoy/Se6soPjHlDWXD/UZEDAz8EtIJ76tKEurJ2P1AsDllS8LOzo
         oc9Q==
X-Gm-Message-State: APjAAAWRzhnqaFQPzPJj03tpjNgRYRXWVFg1+PyIRe5Xp4NGKZh8zjzY
        B3E37kTN6aUkAyKlqPBYcSE=
X-Google-Smtp-Source: APXvYqxCLgHKgPJyTe817QPxZlmHhIyXC7g2Fe+oqtG0f89+1I0OHVMotMxmlvN4Q3/TJcPOIbp8DQ==
X-Received: by 2002:a17:902:a508:: with SMTP id s8mr10732506plq.26.1574371160650;
        Thu, 21 Nov 2019 13:19:20 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id 13sm4142170pgu.53.2019.11.21.13.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:19:19 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net-ipv6: IPV6_TRANSPARENT - check NET_RAW prior to NET_ADMIN
Date:   Thu, 21 Nov 2019 13:19:08 -0800
Message-Id: <20191121211908.64187-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

NET_RAW is less dangerous, so more likely to be available to a process,
so check it first to prevent some spurious logging.

This matches IP_TRANSPARENT which checks NET_RAW first.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/ipv6_sockglue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 264c292e7dcc..79fc012dd2ca 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -363,8 +363,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IPV6_TRANSPARENT:
-		if (valbool && !ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (valbool && !ns_capable(net->user_ns, CAP_NET_RAW) &&
+		    !ns_capable(net->user_ns, CAP_NET_ADMIN)) {
 			retv = -EPERM;
 			break;
 		}
-- 
2.24.0.432.g9d3f5f5b63-goog

