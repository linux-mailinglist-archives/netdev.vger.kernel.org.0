Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C30757178E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiGLKtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiGLKtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:49:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78761FCEB
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:49:00 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id sz17so13573163ejc.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sCN/a2MVbTZkS+BZVTRdpFs1AjNtTS9VIx0Nb+GPVEc=;
        b=LbkWRslNaQ5UuuekH/bWRzeXGS+msdtShPjASI+tmERhMG8WN6bjOfgKXOI1wCiM2X
         MmKe6408vSTUiak7n1r5t+HL1BxkMlDUDROZIKY+hzk5j2Odg0mpxZOcoZY0uWFW0NDG
         pdqCSsB1JuYIxntPA4AekV3pwFq2JyUD/FIqlTsLvUaUkmwBhEQRW9CgLWteHLyxjkI3
         QJNHk6scF6DdAkSgYwNexYXD2jOiaI076dAYgnmvsoUVhM/8OPuohzZDEKWRur24u4Iq
         ZbSwgYMCrQjP8nFHPpt+UYADL3x/9V8Y3ojhIA7w446huqSIKOXTvYYcnggiSO72QEXF
         HpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sCN/a2MVbTZkS+BZVTRdpFs1AjNtTS9VIx0Nb+GPVEc=;
        b=uu7x2cJhaBeudy3lOciB/W8Gm0n6LVqFVAxI9iHICJMFH1Wyobus/pry0TueWGuBOW
         hxM5bqSSiJ1LfIVelQxzzV84r/ifRbWPSNMrmWp+6EYoLMP+U6IDtZt8UJKagIqHgBBH
         5oeEJveZyzGLsUy7P0YYAPeFup7x3xw0tPz7lwL6iS+DF+A64q3t8OLl8T2b0YN2Pl9u
         xpaZc8m3Q6wfgSbWPJTRuu/m25TBMb0Km4qr/Fn8Ifst3Zmg0bGobEBA8azKGZbMU6Mv
         JmwABkB1F3QG1MHPXhgcE6+OgQVDCyekXQFHobu/2E5rOkYviyZqIzTGoXIO2C7zTQYI
         Rmqg==
X-Gm-Message-State: AJIora84hFZpNdSL3w+almq14RIHjfgmxUmPWgjZEhO6i0zL0yE9diM3
        oxyMdHk7UpzorBLHSbTaNjnOW0ifj4u44nP+lzc=
X-Google-Smtp-Source: AGRyM1tm6A6sV3c82dOZW4ciQT478g4yifhd5X1r5xn+2bcxjKtdHB73uC5d0bbBl18ccLr6fKprNw==
X-Received: by 2002:a17:906:730c:b0:72b:4f83:51c1 with SMTP id di12-20020a170906730c00b0072b4f8351c1mr10963950ejc.515.1657622940336;
        Tue, 12 Jul 2022 03:49:00 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ch17-20020a170906c2d100b0072a55ebbc77sm3634764ejb.66.2022.07.12.03.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:48:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 3/3] net: devlink: fix return statement in devlink_port_new_notify()
Date:   Tue, 12 Jul 2022 12:48:53 +0200
Message-Id: <20220712104853.2831646-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712104853.2831646-1-jiri@resnulli.us>
References: <20220712104853.2831646-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Return directly without intermediate value store at the end of
devlink_port_new_notify() function.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2f22ce33c3ec..a9776ea923ae 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1724,8 +1724,7 @@ static int devlink_port_new_notify(struct devlink *devlink,
 	if (err)
 		goto out;
 
-	err = genlmsg_reply(msg, info);
-	return err;
+	return genlmsg_reply(msg, info);
 
 out:
 	nlmsg_free(msg);
-- 
2.35.3

