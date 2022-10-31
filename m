Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363E56136BB
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiJaMno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiJaMnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:43:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D639BFD2A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id cl5so4148683wrb.9
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeEG84ShhdCfRruT4hxrr8t/aoGHb3f77grm4bwgQyI=;
        b=u7MKRpAaX+GGpr3/P92jSR9hhsC3UCnaxjkz5NReREpRL3QJGKUJQdXyU8RcvT7EnV
         ip86uJCuQt9/XJKiPj+U7HrzztBIKfMSLhj4CPwVF7Io9QFpfBdGoCgvzN5beVUcMHCz
         F1LYcAXvLbHZhwCID9yPksdoGsdTpu1FPj51ZYuCnZhakYTAvyqFpLNrsx/SRVZT5AW2
         DKGzJ1raTRd2gsROW6fRCw8E0Riw+3x8Ju2Hl2is/YxfSLLaFclwY3odEBc3vfhsPJB0
         0Jw31FFSwIC8tjuddnhC0WG5CBT9RPLW03MN46HC016jezYICDtZMEvI47YEoq0MDZ1f
         LMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeEG84ShhdCfRruT4hxrr8t/aoGHb3f77grm4bwgQyI=;
        b=ltYA8IzRKvk9iTfw1Lct7ByUK5TMp479kBmloK9HKkTFp4DjZa5/vuK6Wuj16RNOyu
         YhJvjhB7ijZE0Xfq1+Yk2MQMhCQjIMLvpBy/W/ai8KdfQLeaOF9pNhu/try4Ae6nX6ZF
         Lw74gnOCJdc2CNQ/UKpR0u2hKJ2pa0t2Pnuh4uNK3XoMqjlZRH6asv/ExuY5KOXJpcVd
         LfgHwutr+egNrZ5izjLTvAladbBMk+37LYKVfJCPF0+pDhRnYIWtqkSaBzy72AExjfcz
         0pE/mFpe46TFNjzNaOq566rCEAGlY9QUVzDjaQPbwJjXf6Rea5V8bO9nayXOv6DRufXH
         KKCw==
X-Gm-Message-State: ACrzQf2nV+y2BgVtwpi2KRjT3ArTOIV8ISiHOV5Mn5OtFJ9cHb4QjCbG
        AnXJsLQHg3QO5EFMKNPLRObx0ATh6q95CnAB
X-Google-Smtp-Source: AMsMyM7kXrFnTz++tNRO/Yqi9WFexEYBou2SAFa5FcidRV13uB7akp6ktITzVHKH3NcF7HtTEd/MUw==
X-Received: by 2002:adf:d0c6:0:b0:236:6e66:3510 with SMTP id z6-20020adfd0c6000000b002366e663510mr7730513wrh.488.1667220182299;
        Mon, 31 Oct 2022 05:43:02 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 123-20020a1c1981000000b003c6c182bef9sm7893773wmz.36.2022.10.31.05.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:43:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 10/13] net: devlink: add not cleared type warning to port unregister
Date:   Mon, 31 Oct 2022 13:42:45 +0100
Message-Id: <20221031124248.484405-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

By the time port unregister is called. There should be no type set. Make
sure that the driver cleared it before and warn in case it didn't. This
enforces symmetricity with type set and port register.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 38de3a1dff36..4a0ba86b86ed 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9977,6 +9977,7 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
 	lockdep_assert_held(&devlink_port->devlink->lock);
+	WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-- 
2.37.3

