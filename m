Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0831C36E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBOVKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBOVK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:10:28 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F2C0613D6
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:09:47 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so13395990ejf.11
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=skWxX13r3Ll9hAD7PRyKQfdQnCa0EGSQyPFNzzmLNqY=;
        b=B68e62/46XbWVHcHg432gIJnRWFyn+FT36GAdVHW9O9PFcgKkL1OvrxPupWxdlRbTM
         nw2zNZmZx4oRGBlrn0H2Qyhosgr3ZJyCiBtvb0ili0nu0pwZeq8VaXyKr09kk852ksRl
         aQuHq7jFZ+0soxRtVYI/rHnCvRSr8zGmjnHKxSkwticQ+rgM0JEio27AG3CZ6x2cuRE9
         ojL7veR8djOlqdbp/gYuRcsnQ4fKMpndq5WADONgK45jRM2jQFutQ8hqPxW18O5ns2oh
         FdWJZQN7Wt5lDywRK91wukn+Ca3ly1+C6Xr5tpqXrj/XT35H+u+SfTqJBIElJPox6TTT
         9zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=skWxX13r3Ll9hAD7PRyKQfdQnCa0EGSQyPFNzzmLNqY=;
        b=PIPLwpo47RLbEGPA03FeF8CEQmiEn/XHpWpSE+dbjBUMS8tqDtGJcdgHCqG+9K1yBz
         kkdIQNWSu6/SWxMRdgHHxqTEdk0lEWmx0VoBDuERFFqzz/WUNpAzXIgV6gOWo9Ex4EgP
         Yelt0ZeyWPJXeULgaQIKQINBZdogOE1aYeWutkaT0kh9Bn8qSLB47KTSaZK29nRc6Nyw
         bT4zO3Z+9bgva/KmfXHwVJZeOVLlJkpL8XfR+NNhS2KmaKYa2gj3zI4ygYYOTXhKYqh4
         cI2LcU/MtCPGPvKprcaCpYLZXUsMJ7FM+PWCOei6H/j2r09HEA2FiCh2s/lCcMqKKGZX
         GGrA==
X-Gm-Message-State: AOAM530UoHsh0XXswPVvilXMZ9xXALLfFTCwZ/PD3kziPcTeUaVYQQME
        zrJbkgu1yc/O9Xsz/KOlq5w=
X-Google-Smtp-Source: ABdhPJzlcYFLVxzKlFrJWjvOiLoF8zJFwbPObC6qtuIvsSCkqvaHdyL1gNEjpNa3xeO+8+odVZhfFQ==
X-Received: by 2002:a17:906:8890:: with SMTP id ak16mr11633202ejc.398.1613423386405;
        Mon, 15 Feb 2021 13:09:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n2sm4200418edr.8.2021.02.15.13.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 13:09:46 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/2] net: bridge: fix switchdev_port_attr_set stub when CONFIG_SWITCHDEV=n
Date:   Mon, 15 Feb 2021 23:09:11 +0200
Message-Id: <20210215210912.2633895-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210215210912.2633895-1-olteanv@gmail.com>
References: <20210215210912.2633895-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The switchdev_port_attr_set function prototype was updated only for the
case where CONFIG_SWITCHDEV=y|m, leaving a prototype mismatch with the
stub definition for the disabled case. This results in a build error, so
update that function too.

Fixes: dcbdf1350e33 ("net: bridge: propagate extack through switchdev_port_attr_set")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 195f62672cc4..9a5426b61ca5 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -296,7 +296,8 @@ static inline void switchdev_deferred_process(void)
 }
 
 static inline int switchdev_port_attr_set(struct net_device *dev,
-					  const struct switchdev_attr *attr)
+					  const struct switchdev_attr *attr,
+					  struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

