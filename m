Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BAB52831
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfFYJgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:36:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43640 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbfFYJgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:36:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so8518772plb.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6HNwNaPLplG5BWxVkXtF32GfO13+hJyWBrOxC/do45k=;
        b=fn/yt9qOBAvTIm5NzkJCI4WUy+SAlICgvQXONNNA4p97G6iaEq+KwRtFsDZhIR7uiY
         gk4gLq9kmwuhECmvKDdylnCitZcka/HueV4kzakXFEWX56qdfdsXrcVrrUcXePazR9t1
         /sj80TdX8RUFPMdPKDJ76WEACh32vV0DyzhuqhY8684nhN0LoRFH8+wjS0uAAIZDfWOC
         JsifV3iD9H7sJG8nUbXWoYO5InT1xGTGuNaCvP3exhWK1CqTl6E5Mz6SVK50kikSCfYN
         hRC8PXSHqgBl4WV07fVX72/UfQrORH8Zstp6CERv9AsnFmZAbc9b7xwmeV2hGSfAiEyR
         BcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6HNwNaPLplG5BWxVkXtF32GfO13+hJyWBrOxC/do45k=;
        b=XvMtHEm5ifZmf7ItWNVLinxRtArr4mZT82pjsWf+yGpXOgBYQp6BsS18lZeH8TeUgj
         U2AQjNvQ67WyS0VJiZuoKw6xCOEf+I5WGyY33TXAzXulyq1TeSAdCnkuU8FmKXrOfyEz
         97ei3W7iECUfyIUWYwWxWf3Megyc0vzj53JZ44jUPlEcjLzAiwEL7TKUOotQYgygzjK1
         C4eizQuOBYnMSHY6vYGbSohMFcqXyvRX/nUnPLizPQgoyPNeMjCfI5OYR80lxMYv0FUw
         V3STV4QpL8Mhl1S10oJ0Vdb6/D5AUSIPxYUmC+HB1AntjvjvHnz4vQxRyc8V6WIENJol
         0GCg==
X-Gm-Message-State: APjAAAWCvlfN6De7iJB6KFf57zBcdNk+omvr8ywjTPP38WBF/TTYc4Zh
        1I4oCF7IJEVnGJdZOX3qnRNez0C/sNk=
X-Google-Smtp-Source: APXvYqx+cjchVk4irxiJKW0/Z3PcZH/4rmHHnHWyVCLa3wNZCe2RPRHUiOHslkAFxAwEdZcGLP5duw==
X-Received: by 2002:a17:902:296a:: with SMTP id g97mr79438293plb.115.1561455377731;
        Tue, 25 Jun 2019 02:36:17 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm20561776pfw.33.2019.06.25.02.36.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 02:36:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Andrea Claudi <aclaudi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2] ip/iptoken: fix dump error when ipv6 disabled
Date:   Tue, 25 Jun 2019 17:35:50 +0800
Message-Id: <20190625093550.7804-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we disable IPv6 from the start up (ipv6.disable=1), there will be
no IPv6 route info in the dump message. If we return -1 when
ifi->ifi_family != AF_INET6, we will get error like

$ ip token list
Dump terminated

which will make user feel confused. There is no need to return -1 if the
dump message not match. Return 0 is enough.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 ip/iptoken.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/ip/iptoken.c b/ip/iptoken.c
index f1194c3e..dfd22734 100644
--- a/ip/iptoken.c
+++ b/ip/iptoken.c
@@ -59,13 +59,9 @@ static int print_token(struct nlmsghdr *n, void *arg)
 	if (len < 0)
 		return -1;
 
-	if (ifi->ifi_family != AF_INET6)
-		return -1;
-	if (ifi->ifi_index == 0)
-		return -1;
-	if (ifindex > 0 && ifi->ifi_index != ifindex)
-		return 0;
-	if (ifi->ifi_flags & (IFF_LOOPBACK | IFF_NOARP))
+	if (ifi->ifi_family != AF_INET6 || ifi->ifi_index == 0 ||
+	    (ifindex > 0 && ifi->ifi_index != ifindex) ||
+	    (ifi->ifi_flags & (IFF_LOOPBACK | IFF_NOARP)))
 		return 0;
 
 	parse_rtattr(tb, IFLA_MAX, IFLA_RTA(ifi), len);
-- 
2.19.2

