Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A193BA24C
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhGBOnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhGBOnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:43:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215A0C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:41:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o4so2618527plg.1
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tI8wEhbw48f/vcApyLYTEILt0gg3BfVeZqqI5Q7XGbA=;
        b=fGrmQtGW6FcEz/mzIvb6/rOOzSXXsC96Uj6KTkWxqZ2aTwlmkKnM0/yh2lRIAS7JRj
         CE4m9s+mvHRcUUPHv+x7tzwK40zQM9lAJ0k+VDQkoFFeHLQ1yL+4L7NE1KRWjKt+II0W
         FWZ2ZuINb4x/8gxCpk6yiXSs2RPx+x+2Aywnrv6+Q2B/cWUnMYYIWI9qImmPCW+ZZWrl
         N43s4q92hLS5GtvBl72FxQtSh1mhvEZ8xeuFCSotz9nHIE+qhzTcP+rFMijFG+lnkIhS
         N64BkLtzHJydb1TjeMmp7sPjVybEmBTW8Hm4WnV4YWc68MfQJT2ucHrI3qdeUNsuNGI9
         OG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tI8wEhbw48f/vcApyLYTEILt0gg3BfVeZqqI5Q7XGbA=;
        b=qAzs5kJwPpwJobOjF7lugZaqD/Yz1N9OFH3osCHmDJ1VH377Z4gFwLhp9AZKIvuWC4
         eC70fB78oNwHzvMiAfLHlkKYBQk+G9wL3y0kM2hI7uBDXGbOLPdcXAij/P6G0s+KjlQN
         4849EH5Le91eT9w6R8cLnUl6reWXVarFJotAU2jSc7oeD2J4C9Xo2taN9V/OdajDOZze
         rUESCh0Zox0kJ+PSsOresrpQS8UaT79f3iFM3kbG+1sDo8edqgMudA1LWcNe5JX7TyJ1
         mfWymCs1fmRhOopQKVomoJbyYyXtwpppBx4fGBKF8ZCpNcVfxElQ7rqpCTwG+umvND5a
         NjfQ==
X-Gm-Message-State: AOAM531eETWXe2Ulv4xqSyp4nvOaFnnV+ZJ5FQG+JpRZ8urjGbmw2TjF
        W8A+Osd3plqYGXXvo01o0bQ=
X-Google-Smtp-Source: ABdhPJy/IbGnde7H5Ey76kNjLGXqxBqrxWn1uhJAen13NH/v+9HcMPDWdD0nAT/Il3j84jOaEVFThQ==
X-Received: by 2002:a17:90a:9910:: with SMTP id b16mr159384pjp.94.1625236865520;
        Fri, 02 Jul 2021 07:41:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7c57:ec32:6dc8:bd6c])
        by smtp.gmail.com with ESMTPSA id p38sm3477505pfh.151.2021.07.02.07.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:41:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Sperbeck <jsperbeck@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net] sock: fix error in sock_setsockopt()
Date:   Fri,  2 Jul 2021 07:41:01 -0700
Message-Id: <20210702144101.3815601-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Some tests are failing, John bisected the issue to a recent commit.

sock_set_timestamp() parameters should be :

1) sk
2) optname
3) valbool

Fixes: 371087aa476a ("sock: expose so_timestamp options for mptcp")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-by: John Sperbeck <jsperbeck@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index cad1071122043183217387cd99f4bb5c2bbc051d..1c4b0468bc2c301cecde6e8e0ceaab1631232cb7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1116,7 +1116,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
 	case SO_TIMESTAMPNS_NEW:
-		sock_set_timestamp(sk, valbool, optname);
+		sock_set_timestamp(sk, optname, valbool);
 		break;
 
 	case SO_TIMESTAMPING_NEW:
-- 
2.32.0.93.g670b81a890-goog

