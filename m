Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC773B68E2
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhF1TQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbhF1TQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:16:21 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924F7C061766;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e20so16321118pgg.0;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uWW8HGuUDgrrnkGEzBraPNH597iMHRW9Pf/jY6NR5aE=;
        b=KV8DypDgZNdo432vlJYssN68WXSDKFleldfI1QydY1IiGO7JSKsqj4Lx7Xfn4cQdBq
         GsKLCMy2mMYFoPI+8ZmZ1gyhwTdb2gmxs6Gsc/3g5eSLxsoKrff2fhJWF8aqXtPnEjnR
         QXn0qdzbOdrS+RoUNKZ6LMfBGsGA+PF32FFJc1JY3DJ3SM1lFve9q6PZ8++cvGOHGVg3
         RAyWl7XByqVPJMpK8hg4OwMF1JeMkshdtvE5PdV/yiS45975O81A5Ohuccl48nXq2FJo
         ZcPwMTaWSyMI3wZ0fXS3V3vBYZ/QV9TWzHC870XjTaQDV2B34hnJAwdwr/J3Z316nRFX
         fl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uWW8HGuUDgrrnkGEzBraPNH597iMHRW9Pf/jY6NR5aE=;
        b=EcOOvsfbw2m00F+8kM2GmZCDmq3NxLXVqEzcySKB/4yDPuXywIvS953rclRXqdUUny
         +4xE+JH2YuCmUfWvtBmYlKBV8ozmkaXeyd342sG+petyuHMiYu0v3x4XhuZzWRZpL3Ax
         wBjmuGzEyg+MFS4wKSYg6qmai8m2BhbtjAmWS73Itq9mvTccBjZ5I2oCRupY+9KfLGFd
         MoJnm8L/dcVIBoK6DWESk8fQoeVLdsI8+yUVikFFlQOPqkxyN6E7pMucJe+DDgis9Obh
         Z3KWcaE8oKfuJM6f8zVJvJcbvt++Lpbix8xMUdw1QjT58Z4wY5TnWwIX/o7VlAWo4cYl
         zPTg==
X-Gm-Message-State: AOAM533Aitrgl5Dtj31YkYRlvQbpLAa3hKufS6/ZBwJZjUpgGzVwG71f
        2TjaptgN8ph3zI6GSG0taQo=
X-Google-Smtp-Source: ABdhPJxdQ3FEJ+0bJNktIq9UgxEewCQ8ohGzvCRQRMEU4ETWlR/lwP+jQzwb+dMkUGuXiowNIyQXsA==
X-Received: by 2002:a65:614d:: with SMTP id o13mr24541353pgv.351.1624907635147;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:ff7f:d8af:5617:5a5c:1405])
        by smtp.gmail.com with ESMTPSA id e29sm3096720pfm.0.2021.06.28.12.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 31F52C13E8; Mon, 28 Jun 2021 16:13:52 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 3/4] sctp: validate chunk size in __rcv_asconf_lookup
Date:   Mon, 28 Jun 2021 16:13:43 -0300
Message-Id: <136de038e69235a64a7331465951f0751d4d83bd.1624904195.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624904195.git.marcelo.leitner@gmail.com>
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one of the fallbacks that SCTP has for identifying an association for an
incoming packet, it looks for AddIp chunk (from ASCONF) and take a peek.
Thing is, at this stage nothing was validating that the chunk actually had
enough content for that, allowing the peek to happen over uninitialized
memory.

Similar check already exists in actual asconf handling in
sctp_verify_asconf().

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index f72bff93745c44be0dbfa29e754f2872a7d874c2..96dea8097dbeb4e29d537292d31dde5f02188389 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1168,6 +1168,9 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	union sctp_addr_param *param;
 	union sctp_addr paddr;
 
+	if (ntohs(ch->length) < sizeof(*asconf) + sizeof(struct sctp_paramhdr))
+		return NULL;
+
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 
-- 
2.31.1

