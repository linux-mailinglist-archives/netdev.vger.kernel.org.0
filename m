Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0122B2AFC
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKNDYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgKNDYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:24:04 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E90C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:24:04 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 35so1308581ple.12
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gwBdhPmSI5a7WujO9iGH/b77+h0jcMM/Td7CNtnnb6U=;
        b=XOOfClxU7aItcD5Loc2I1HD3H3n8gk/S631gu3/EjzOCdLJdsVCUfDSc9hUh8jn9OU
         TtEDuC3ffWhgjDnFQNSavbGmcVvzUtSJpti6MN+qDB3E71YBjQZlNnonHpQDEPcYg4jT
         IQXHD1j2DdbcYBBsktladb5AvVxbIBmLpiXIsdOSCSF9TP+AppeDX0ZpjsCMmOR92Kme
         sEqzKVcoRk7majccoAQmUC7o1WvhBwbxdx9irAJmUAahipCKdw5WBtTbsy6NhpRIDlix
         k8yYhITLocenN0ty3kXeaR4eLM/gz8BRpGRD3IRRk3aMfnFFn39cIwOZH9NR2p2GAoAM
         tDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gwBdhPmSI5a7WujO9iGH/b77+h0jcMM/Td7CNtnnb6U=;
        b=KSy4yvAODH5o3YXl8z1joAHEohAYFKVmVC4h1CiJmA1NnjOfjp2SzQri1BQwp9Z39i
         /pfy1/SemzeOqYgN90A5z5KUD2G267pRLfBuKUI0H691DOCVFbS5ndD+K+cFz1Je2+pl
         jFMhWhXmwKvXfKLfbr9CbxjUq19LzAXmn59apkKNzZRgpKpSYwia6KNE2wJO5Claz8Tg
         N5yxHwSsYT8wmLufFlr1w+hBKnTdzT/icXMDG4wCm4wiqs6Akvfsa74oYrow1ywK1nfz
         SGB8oCyZasqscsFjyfr9PMvKQ7auFAMd3PA8uCULYYnupyciF56l/76A3zrtIzpFRd8L
         fBPg==
X-Gm-Message-State: AOAM5326+yO5HqyuzBZx5mFKoJlicg6U39kSI81G6omdgE4XGmCXScAE
        zoitfPIxWj/998vrHWMjlpE=
X-Google-Smtp-Source: ABdhPJzQiK5qcl94JA14+4s3WkKZ/4ZOcihlBy92ab4mBhVHJJgBucTj/gaEhpkRLrL8Eg4Bjo3RGA==
X-Received: by 2002:a17:90a:2d6:: with SMTP id d22mr5125271pjd.38.1605324244010;
        Fri, 13 Nov 2020 19:24:04 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id u22sm9875729pgf.24.2020.11.13.19.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 19:24:03 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/3] net: add support for sending probe messages
Date:   Fri, 13 Nov 2020 19:24:02 -0800
Message-Id: <63bf7511ad13c956bc0d243b180c17eeb113b5da.1605323689.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
References: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modifying the ping_supported function to support probe message types
allows the user to send probe requests through the existing framework
for sending ping requests.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Switch to correct base tree
---
 net/ipv4/ping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 39b403f854c..70cb505f3e9 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -303,7 +303,7 @@ out:
 
 static inline int ping_supported(int type, int code)
 {
-	if (type == ICMP_ECHO && code == 0)
+	if ((type == ICMP_ECHO || type == ICMP_EXT_ECHO) && code == 0)
 		return 1;
 	return 0;
 }
-- 
2.29.2

