Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F042CE663
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgLDDRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgLDDRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:17:30 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC43C061A53
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:16:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m5so2350021pjv.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rM4t2eXx/FS2J7CAO2fnC8vXaIERWWcRjKh6bkZ0osI=;
        b=R92+5YE9KqzDR26hmGKe9GIYFv2HJatvt41NZv8VoCVJ/KJe9aQmdyIV2lAsVhRf8q
         jM17sqo3QmQ+mVjqdXczPtf66ENIAZVD0wf4NIQsAT6skU1Y2FHvjWoU1B//BqhJAXmH
         mOpzd/8VkBpepK35UUtIg88dG6fmVYMLWgsxAwBAnb0eO+VGkB8aCFYWJj6FfuFuiPiJ
         +/gjE6wo8GtRMq1IMmywVNsB5uiVQY9JAqGkfbiG5q8kUcfMt1U/jfgV1hszyzyWfe8z
         sQQzsbvcjhRj33hXHPGXxAx1lWOVWuV6KlJM+rBvzUWDVRibJB9S7O3w2QkpL45ikAR/
         TXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rM4t2eXx/FS2J7CAO2fnC8vXaIERWWcRjKh6bkZ0osI=;
        b=N4YlChpegDhWqK0cmMx+vWQxY37Vyenb/X2FyFEvVYi3T4nnZdNlS3qIMYBXTIedZQ
         ZLDMt+wpMz+4yUBkJumr2SuOw4MQzmwi6PG1E0l0iDQjmHEW+yQ3R4KgdTriZXS8Zstl
         Gugk/8HpX3iLzOy7fVvZojW5J02JLePPh3np/YeTwk9G3GT8qitOXOf1bSuqlN9Pk0Ym
         edMy8RfcJBu/BOjPX5E6XY3mq9aq++wotHeApL+EvVPhGhApYY8fe0rcSjHx5ei5SjUe
         9FgE6SOpIz5AGpKucwRn8SwS2eRITF/1arnvawLHvYvOsXmGRdil7JldFcQCWt5sa1CZ
         nOxw==
X-Gm-Message-State: AOAM533HUfXwMHYNPoXQD/CAHZTRhX68XVhxmbORdDgMqF88caE3Xtt3
        DDbaQZlmtgH1B8vu7gZmXqE=
X-Google-Smtp-Source: ABdhPJyr/lbnckGafVC9J+5/GH2Fuu/6f67pXnGtu/LSpv/ldxpRqc162flhkhyj5w6YmZ16MkFtxQ==
X-Received: by 2002:a17:90b:f8f:: with SMTP id ft15mr2215576pjb.210.1607051810359;
        Thu, 03 Dec 2020 19:16:50 -0800 (PST)
Received: from clinic20-Precision-T3610.hsd1.ca.comcast.net ([2601:648:8400:9ef4:bf20:728e:4c43:a644])
        by smtp.gmail.com with ESMTPSA id s11sm3089696pfh.128.2020.12.03.19.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:16:49 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 3/6] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Thu,  3 Dec 2020 19:16:49 -0800
Message-Id: <1de8170c1b7dec795f8ca257fbd56c61c36ad5a2.1607050389.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 8 of RFC 8335 specifies potential security concerns of
responding to PROBE requests, and states that nodes that support PROBE
functionality MUST be able to enable/disable responses and it is
disabled by default. 

Add sysctl to enable responses to PROBE messages. 

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/net/netns/ipv4.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 8e4fcac4df72..1d9b74228f3e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -85,6 +85,7 @@ struct netns_ipv4 {
 #endif
 
 	int sysctl_icmp_echo_ignore_all;
+	int sysctl_icmp_echo_enable_probe;
 	int sysctl_icmp_echo_ignore_broadcasts;
 	int sysctl_icmp_ignore_bogus_error_responses;
 	int sysctl_icmp_ratelimit;
-- 
2.25.1

