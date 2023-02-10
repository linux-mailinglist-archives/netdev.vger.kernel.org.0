Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226F0691C2B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjBJKCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjBJKBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:01:54 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AAF7B15A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:41 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l37-20020a05600c1d2500b003dfe46a9801so3679126wms.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUKS7mtXommS44bxzLAEdjwFuxfpnShx9VDHU/6OlOk=;
        b=KgSY/LXQE7/tWmX7k5hkKUluWstqRmtQ1ro8XCpruZlp5uL2HdPQifeyqcO3pGTV2V
         oKzTPdOWlP9f5v8FA4hEwt5XZRElLbp8ZswKz8ady074S6sQ8wDd8UnwPvQT6i+l7sTB
         f9FduzxymWOg1jNqm1Wr1cmCzVcuYdCZAiF4B0TKHfWmq1u2RPaE+aqLiLESmhGZwDQ8
         r87sxOzAMSaVpXyStnVTeQDp/m3ubpf/4m6g4JmljIWzKIyHqp2Ggb/hYQ4fGhfB3yBB
         beXfvf3Hrt0xT+S4RlVfmdR+0JpqC5B5s6blr1JiSJwCVtkVszOpnJJXgUmdvLYaPbFN
         auUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUKS7mtXommS44bxzLAEdjwFuxfpnShx9VDHU/6OlOk=;
        b=juDChM4RYxWVBbshK3g2FcNDTkRwfJTK6YULCtOJn4LRWrXv7hz6xfLfLxGZW3Sv2u
         JLHDk0yZW6j834SLMXUZS0AzOMrpWHlRnScCATFj63ws7iA/F8T57Nu4wXusxAHpRUmQ
         fHBgWUplaknYnDkmhDHs4lDb1pSIHTTGk20jxcnSA2XoZsbtYgE0qshV9elJug6ZwhRl
         x9ldRPzjOzRrNwOup0pE5S2D3JHdN1FTuvM0coKq8OQ467fGF69QsUZT9hkKWp4idbHQ
         KULDz2/KvN7wrPhevvWdacrhwIt9FtzA1/Aj90jmy7InlmPWzfXQJXUHXgdg2M4izges
         9uOg==
X-Gm-Message-State: AO0yUKUt1trJSgM1ybESdfTt3EFStb+uBCLdeal+uS9weF0AhQudZCq7
        3jr++I9h7c5zH8lwz1SBQxMDqgOzlb70DQwK3aI=
X-Google-Smtp-Source: AK7set8Fh07D8S2qHGBgDZvFrxw+XKlutFi6+nB4XhLJ8KTwyD0wuHhxC8QREdhOa2kv09MEyt5BQw==
X-Received: by 2002:a05:600c:32a7:b0:3dd:e86e:8805 with SMTP id t39-20020a05600c32a700b003dde86e8805mr12545403wmp.5.1676023299446;
        Fri, 10 Feb 2023 02:01:39 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003d9fba3c7a4sm7094457wmi.16.2023.02.10.02.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:38 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 4/7] devlink: use xa_for_each_start() helper in devlink_nl_cmd_port_get_dump_one()
Date:   Fri, 10 Feb 2023 11:01:28 +0100
Message-Id: <20230210100131.3088240-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230210100131.3088240-1-jiri@resnulli.us>
References: <20230210100131.3088240-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As xarray has an iterator helper that allows to start from specified
index, use this directly and avoid repeated iteration from 0.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index dab7326dc3ea..c7d9ef832c8c 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1111,24 +1111,18 @@ devlink_nl_cmd_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_port *devlink_port;
 	unsigned long port_index;
-	int idx = 0;
 	int err = 0;
 
-	xa_for_each(&devlink->ports, port_index, devlink_port) {
-		if (idx < state->idx) {
-			idx++;
-			continue;
-		}
+	xa_for_each_start(&devlink->ports, port_index, devlink_port, state->idx) {
 		err = devlink_nl_port_fill(msg, devlink_port,
 					   DEVLINK_CMD_NEW,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq,
 					   NLM_F_MULTI, cb->extack);
 		if (err) {
-			state->idx = idx;
+			state->idx = port_index;
 			break;
 		}
-		idx++;
 	}
 
 	return err;
-- 
2.39.0

