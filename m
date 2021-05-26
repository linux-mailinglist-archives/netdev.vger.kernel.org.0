Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490363914FB
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhEZKgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbhEZKgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:36:42 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33041C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:35:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z130so427611wmg.2
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QagbrrbfuznYLLVZmStNLsguOOps8/b623md9vLtpPk=;
        b=sLNa+QjzDa3Qb1qW58xfql+fiSsBoAg3V3BrSoN/Zv7L3CBxGZJAsRAK3st5dGTPzP
         h7xd1KNLweBIH/PqUPgxTG3FJZJZivKFUABltMjA7jF5Nvvsel8LcoOLmo6/ToilsQib
         VXqlpt9JP3pyhp6kpOjYPsytX/sB70ILpP4Pr1/1MUCXXqP+UsXXjft4WjQ9b7uf8vkx
         7546I8laERvR9VruV0kBBjVpaV/0wqG5+o6EGR4bI6192sQupwlceQCk1ls/DYjDo5Qb
         aeHMbPZ1Ri6D8bJ4q0tcan0WpB21m0tGLIipiJwQ/3cLlppjny9QJ7mKDQT9wIjA7qWw
         RngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QagbrrbfuznYLLVZmStNLsguOOps8/b623md9vLtpPk=;
        b=pXuwLgvSxaGEpqvr4/M+XiGB51Pdxdc5bRSbVO2mWcM9AKQUVxQIM9SMvdGx6ibQAF
         IDgzPzx4/W8UsFDXvzOE05YFxrGAzEvs7IKoRS+PMs/WTJTc0UpcFGC/9RLxPu481pn9
         Zkk3kFATjiCuLtH8ZwGytnkv1mTZkgkiiMSYf9fJtwL5wVAi2TU4hzkx0wPrEvqvCXb6
         vsiFzP/hv7p4DZRatjKuD6uT6RQasrG6Q+ivju/tJeetDlGTZ2PG/u0YHfBeKDWrqS5c
         mVTL9Zcl8Wb8U7NZjoEZIFlueBo3l/G+YDe1WJ+xL80UcWXCdVUh5jmNrS6OR5tAv/uS
         pn/Q==
X-Gm-Message-State: AOAM532uTzpaZ3+n08KgwHGalxkiqT/CQc/HS5niwISzBUbqqT5QyfWZ
        ugkEuyi7Fr4X7s+jSu8PDtPfR96RKFZq8lx5ppg=
X-Google-Smtp-Source: ABdhPJy1EJVHcxK7FPyf+4YM6J3yFIbfnZBAuYQTuRzEsOO7jQd+9UODwPbfth0wgqMXGTjm/qcNfg==
X-Received: by 2002:a7b:c152:: with SMTP id z18mr16753869wmi.136.1622025309833;
        Wed, 26 May 2021 03:35:09 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id k11sm5981836wmj.1.2021.05.26.03.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:35:09 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com
Subject: [patch net-next] devlink: append split port number to the port name
Date:   Wed, 26 May 2021 12:35:08 +0200
Message-Id: <20210526103508.760849-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of doing sprintf twice in case the port is split or not, append
the split port suffix in case the port is split.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 06b2b1941dce..c7754c293010 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8632,12 +8632,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->phys.port_number);
-		else
-			n = snprintf(name, len, "p%us%u",
-				     attrs->phys.port_number,
-				     attrs->phys.split_subport_number);
+		n = snprintf(name, len, "p%u", attrs->phys.port_number);
+		if (attrs->split)
+			n += snprintf(name + n, len - n, "s%u",
+				      attrs->phys.split_subport_number);
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-- 
2.31.1

