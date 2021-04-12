Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F235D0D5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhDLTJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbhDLTJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:09:15 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FA5C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:08:56 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id c6-20020a4aacc60000b02901e6260b12e2so779578oon.3
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXxCrEO7CYAIwJlAS2nL+QQkrjAZzGkaGlGw6KnkrnA=;
        b=jSCV4bbv3iZCPNoCp3uBjmMMlKNq9nLlSSSrXdrl40dtAjf4TWkZj4Z4E0d4F4tf/x
         RwkHlFoQ8pQMprFwt3tJ6PutZmvy5Cb2NlIIFMkFE1OwQJKyCqEz9RF8t67o2FbNu5lC
         FN6Wfo4rye1Y1hlJmelT+4zRqAgnjt4oueRTCHWI0n5S/ex01c7gKZ18OPC9w8b5Yoqd
         biGNeP7NB+cWqaoJ3mURT9YrMtXNUuwnW0Gb0Beba+DZzJs5GFpc98gxgHAbkkma8hr1
         TqQ0Qz1NLwb+MSDJj9hCcasUBKlnbWuy6deJ2uQlaxWxeQm52gJD3A7xwlSV72Zk+/fl
         uZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXxCrEO7CYAIwJlAS2nL+QQkrjAZzGkaGlGw6KnkrnA=;
        b=HRtJoB4zq0sUj/n4lX/OKargCE43LCDJfq87iMa6ru4MN8UJU0Pw4fmJwQBfzfVaEs
         fUQs9YuZ6056A12PIQ3y+cDm17PpUDYUl3hH+Dfilash6PfFA0Ng+53hPsSF1FxXpPdz
         hnrYobQdMwVdIh2KF/AoWYUpBdZyRH+c4EnJin/GWq/WFgD14Ma5mWJnALymr5PzBTyi
         3pULZZzHQceNGPrzMzpH0jwSSe+XSgYK0EgL/Ix/nawQSdrilm1D/Ck2VrAhJjplrcCp
         XZ4eTvfGMshAl6F+zYYP3xauua+YAxayhgJ6QwL4kdAwXo9QwxkwrLSYMI4YWvuBKy8D
         i3lQ==
X-Gm-Message-State: AOAM530G5MHTCY3O7ZzH2gTuR0zyAOIPEl4qJfnnnElbSDHu7bUpXAmA
        nXbQRbQW+45MTdL5X/uLkf+WAmRnHdA=
X-Google-Smtp-Source: ABdhPJw2MdcoMmxeqVqDsleFtMdOfq+2/nJlz8+Dt9PmAaO4sW4/PYyJ9cC/Nm87EjJ/5YOpPGbP5A==
X-Received: by 2002:a4a:604a:: with SMTP id t10mr23943449oof.87.1618254536205;
        Mon, 12 Apr 2021 12:08:56 -0700 (PDT)
Received: from aroeseler-ly545.hsd1.ut.comcast.net ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.googlemail.com with ESMTPSA id c9sm2328411ooq.31.2021.04.12.12.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 12:08:55 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next] icmp: pass RFC 8335 reply messages to ping_rcv
Date:   Mon, 12 Apr 2021 14:08:45 -0500
Message-Id: <20210412190845.4406-1-andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current icmp_rcv function drops all unknown ICMP types, including
ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply messages, we have
to pass these packets to the ping_rcv function, which does not do any
other filtering and passes the packet to the designated socket.

Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the ping_rcv
handler instead of discarding the packet.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/icmp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 76990e13a2f9..8bd988fbcb31 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1196,6 +1196,11 @@ int icmp_rcv(struct sk_buff *skb)
 		goto success_check;
 	}
 
+	if (icmph->type == ICMP_EXT_ECHOREPLY) {
+		success = ping_rcv(skb);
+		goto success_check;
+	}
+
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
-- 
2.30.0

