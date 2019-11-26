Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110BE10A6C0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfKZWob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:44:31 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:45274 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKZWob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:44:31 -0500
Received: by mail-pj1-f66.google.com with SMTP id r11so1129952pjp.12
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 14:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uLUkE7GruPWMQQ52BTtxh38fV4cbrfRZ0q9F0W5fncU=;
        b=BMnTHtRi/FgtwpUjzI8sNRjRbmZUdGYpbSC87j2UTRk9TgEYBz/SBS0npfGL8I+CiQ
         /7Oe2L439iFFjbygm18RXX8WgMN3nFuqhut4C28hZp4wlCvWobob34lVa5v3WEPaXeHU
         nzpXf9p3qbpWi8vJRBjyI3E0yFAb7aPBk02uTug1kLRcCnSlOIGeRrW+K7JXOoDoAzZB
         J4xP3/R7MphQ4cX1nftXG1USS0qdVv4XhVIC4cE0emjkMDibObs0DmDG1adB7YoOdNgX
         QbSYC+CsT9vQMwKBeOd8i214+uoZ9/amyKItSnoeGyP+5px0zRBVqPssO78fuq3Af/g5
         T7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uLUkE7GruPWMQQ52BTtxh38fV4cbrfRZ0q9F0W5fncU=;
        b=Y9WzcsPtZEBCr9HQrisdAVsc3aLujwfEfWOYIrRgiQUyF8nReXGujXrd3KUvee5kSN
         9cJmjCANzL7205/Dy+h5tuHu9m6JYYaYne17NkTHupD8z9yArk6SP/ZF+3rpf3l2xA3Q
         4dmK2aJLj/RixFGAJKb4FoGJAWCQ2114GSrvAJIzNoV012JF161DS7H4qQH4zfjE6zA+
         PwiR5tj9N0nEBfYEWXNYIJJLO00GFci/StI+t35X1h3YCBmLTBHbWC/MByE+nFSC00ZS
         0r1R5mARWGoRYJCae6jBMa0Q90me9w4hU0s2CQbmgi2dxfvBvark0+VlmHWnqmwUJT7K
         7Kyw==
X-Gm-Message-State: APjAAAWkLrVgywpDlUth9iDeomVg6uIy8laWwRLlruMwT9YlMU2vEXHA
        8Te9he8M8PC51FssxnizxN5H66Up
X-Google-Smtp-Source: APXvYqwbfhNcKVyZaMFudh/azbyEA1DguTF+iLuqxt5iFzaT19Yb5N/NqRDf8jIE0d9A9boNLPQugQ==
X-Received: by 2002:a17:902:7089:: with SMTP id z9mr743408plk.292.1574808270083;
        Tue, 26 Nov 2019 14:44:30 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p3sm13614383pfb.163.2019.11.26.14.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 14:44:29 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: inet_is_local_reserved_port() port arg should be unsigned short
Date:   Tue, 26 Nov 2019 14:44:16 -0800
Message-Id: <20191126224416.23883-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Any argument outside of that range would result in an out of bound
memory access, since the accessed array is 65536 bits long.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ip.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c823aa279d21..cea69efe5322 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -339,7 +339,7 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
 void inet_get_local_port_range(struct net *net, int *low, int *high);
 
 #ifdef CONFIG_SYSCTL
-static inline bool inet_is_local_reserved_port(struct net *net, int port)
+static inline bool inet_is_local_reserved_port(struct net *net, unsigned short port)
 {
 	if (!net->ipv4.sysctl_local_reserved_ports)
 		return false;
@@ -358,7 +358,7 @@ static inline bool inet_port_requires_bind_service(struct net *net, unsigned sho
 }
 
 #else
-static inline bool inet_is_local_reserved_port(struct net *net, int port)
+static inline bool inet_is_local_reserved_port(struct net *net, unsigned short port)
 {
 	return false;
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

