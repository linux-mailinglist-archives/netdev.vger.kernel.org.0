Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF31066FA
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKVHVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:21:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33922 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVHVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:21:18 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so3068479pff.1
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 23:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=briGRW+1Bpyt/+T5VWxjGbXP3k9kfTLxtS5B30VfYAg=;
        b=JhfzJk/WQHV9MycIrg2pggCKXkbiB1DLppOXKUzOa4YTJmEbsksBOhoYqhvmaax/MU
         ODlp/Lc50uPLb5ZHITGY3i3xbR1Ow3fTBY1t1nZqoINudybM9z67VF1g0uzlY9KHGbJc
         QZ1RnZYTmCbCPH7SIUBZTk91ml/C5kqoOnnbqppOZBxDTz+cFfHQaGa0bpEdj4l6lZ8F
         CoiOaeyIihZQMdXR+VyXzllP9FvsqhCEDSmKoUL64DIouuTJ4tnTaLquzPohY6PFblb+
         lLet9beYMuNrEuJW0Bt4nMg/V2280XdKjEgI9KpvXS4Z/tHYviU0zj2ZepXZ1ravx9F2
         ePIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=briGRW+1Bpyt/+T5VWxjGbXP3k9kfTLxtS5B30VfYAg=;
        b=YkJcbzc7YivZDoQgW/OenRSwH1hgluMEIECaLN0yMpa4fR/TfbuvnZlyUcYBLvlwPF
         VNRcDj8DGrbhs41RApvbX6PYbLtM3deh7vUo200hLMFxbTs5gOiJuf8dz34BrCKXqWrS
         954AVVlKNne76g1LbxWlz/zyJrFCBLR8KuUnrlJRgz99cfO8OtA064Mkei2gjbuq8ao0
         1h9USyiH7rOAMMr6yxQjSFrDOAZH3i8ck7MaBz8XOND15+7c8DiOa3C2SpMxLVOIkLe2
         PzJCtqwWClf0jjr27gIaBVpuiNbEf76oG6LsNPSap1RIg7+8173G9+cH9G3LXlSAob+q
         flpw==
X-Gm-Message-State: APjAAAXeWSseBshBpkmh2iaivV6xleMF4PoBfRPKb/vZoMk3BvStSwb+
        /XZZF6Ca3AiH+cYnHYdhA8A=
X-Google-Smtp-Source: APXvYqwywVLKgx25X2i6pJCpXoWAdY3J8MBxxvPAeSkHhTvxDsDnnYQymMRo/9D+hNI8lJ6L5ZJ9sA==
X-Received: by 2002:a63:3c9:: with SMTP id 192mr14158521pgd.375.1574407277654;
        Thu, 21 Nov 2019 23:21:17 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id s2sm5310646pgv.48.2019.11.21.23.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 23:21:16 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH 3/3] net: Fail explicit unprivileged bind to local reserved ports
Date:   Thu, 21 Nov 2019 23:21:02 -0800
Message-Id: <20191122072102.248636-3-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <20191122072102.248636-1-zenczykowski@gmail.com>
References: <20191122072102.248636-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Reserved ports may have some special use cases which are not suitable for
use by general userspace applications. Currently, ports specified in
ip_local_reserved_ports sysctl will not be returned only in case of automatic
port assignment.

It is desirable to prevent the host from assigning the ports even in case
of explicit binds to processes without CAP_NET_BIND_SERVICE (which
hopefully know what they're doing).

Example use cases might be:
 - a port being stolen by the nic for remote serial console,
   or some other sort of debugging functionality (crash collection, gdb,
   direct access to some other microcontroller on the nic or motherboard).
 - a transparent proxy where packets are being redirected: in case a socket
   matches this connection, packets from this application would be incorrectly
   sent to one of the endpoints.

Cc: Sean Tranchetti <stranche@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ip.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index a92f157bb115..f00e00d15155 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -353,7 +353,8 @@ static inline bool sysctl_dev_name_is_allowed(const char *name)
 
 static inline bool inet_port_requires_bind_service(struct net *net, int port)
 {
-	return port < net->ipv4.sysctl_ip_prot_sock;
+	return port < net->ipv4.sysctl_ip_prot_sock ||
+		inet_is_local_reserved_port(net, port);
 }
 
 #else
-- 
2.24.0.432.g9d3f5f5b63-goog

