Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC82C6944F1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBML6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBML6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:58:44 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236B75B88
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 03:58:43 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s11so4779566edd.10
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 03:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HPTC10CcR6eZvGJZ7K5TkigXZHjG3e6oRR7l8lgkhjo=;
        b=4AztL1A0T025WNjJXzq13gxZQe3Vh4WYVU9dk7teJ9QdaKy5PoGvB9j033jAJ8nV5X
         +W39x+aCMtxKcCUqcTGF+i7BqmSYLFh9RqWmAS/skfgkl+YG3yePeQMUwIlyEEdJQjdE
         YGRYaz5URxayGbcFsiIa5j2vq95mjHUJVgEcLqTefAQ2Uj8POzGFzD5F4ZWgxZm/BNyc
         xiQ7/cLSh1W8Zx6H3JqZIz6xZqp9tutuaUALqnklwzO4+DAHrcAb4JUMGMXQXq/Z6hVx
         xukV5HuGuBAU12Va7J2yJ6LjUoUh4uAo9Godx4hrBDaVDLsrf6u5x3i76alvSxIcZOsv
         +eRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPTC10CcR6eZvGJZ7K5TkigXZHjG3e6oRR7l8lgkhjo=;
        b=xnj27YRozAencr/ULPdZAiYBSJwIw4WRGvovrRZeGntTcp8ZrCSpvuc2JrJF+GG9AV
         NanQll4uOK2M9Kqb9lv46OEZd7VQ3jeCDfIdfJ5VAwxU6UdBFwaVge1e64DPb/Xt5/yo
         A8L47MhAlQkdXBR4Bykchc7vwNm93S17dFZHFD4Bof9e1CQNTQp6d7WtoTDWshiBfRDH
         iHqGoLxCMwFM7sNgKUgGJa68PT3C4pzRyVTCCh5ImvsqHQLrerCusYk5MGl5Z3XmuGeK
         yRvvsbhYUSVRfwt4/DeluapX54DNDXarRFL+xpTwJxf7iKcNL44wtXwTY8hnHu+9HPAb
         bJ2g==
X-Gm-Message-State: AO0yUKV9NCjWWtlVe/Q+uAg4JggdQyIx523PiOa8WMv3rejf8dgOFMEK
        mQPyU9n54C9+Ypl/N2IisG/BflngbAq2B4C3gq4=
X-Google-Smtp-Source: AK7set+6kS/Z9LNx+K83K8brvK6iZ4FM7PZ2rkMf8nvdd7ET4md6ZfrRBIUJPnUMFLQZZuG0VyRGrw==
X-Received: by 2002:a50:c053:0:b0:4ab:c411:8ac5 with SMTP id u19-20020a50c053000000b004abc4118ac5mr10627099edd.17.1676289521741;
        Mon, 13 Feb 2023 03:58:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r10-20020a50c00a000000b004acd14ab4dfsm372608edb.41.2023.02.13.03.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:58:38 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com, moshe@nvidia.com,
        simon.horman@corigine.com
Subject: [patch net-next v2] devlink: don't allow to change net namespace for FW_ACTIVATE reload action
Date:   Mon, 13 Feb 2023 12:58:36 +0100
Message-Id: <20230213115836.3404039-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
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

The change on network namespace only makes sense during re-init reload
action. For FW activation it is not applicable. So check if user passed
an ATTR indicating network namespace change request and forbid it.

Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
Sending to net-next as this is not actually fixing any real bug,
it just adds a forgotten check.
---
v1->v2:
- don't fail in case the user requests change to the current namespace
---
 net/devlink/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index ab4e0f3c4e3d..b40153fa2680 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -476,6 +476,12 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		dest_net = devlink_netns_get(skb, info);
 		if (IS_ERR(dest_net))
 			return PTR_ERR(dest_net);
+		if (!net_eq(dest_net, devlink_net(devlink)) &&
+		    action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Changing namespace is only supported for reinit action");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
-- 
2.39.0

