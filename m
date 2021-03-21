Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2083434F7
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 22:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhCUVG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 17:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhCUVGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 17:06:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FF3C061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 14:06:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e7so16918825edu.10
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 14:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bTmObEIche8eOF7eSYOH3clbEkRgDIf7Lfgw4Jf4i94=;
        b=Lhz9AJsb1bkT8VSNE583Pu8IjD6/8OpQvFrxZkthC9SmpQDjmY38eNJ56JwkGDHn3I
         0/cBQbTsrImLiPPMXoMQXZxhC+UuVV1E6Q2Nhk809rhY6Vj5Bmx90MNOfOoqJsUTuUGX
         Mmcn7owFFFCVGA4f7p6iNwqPXqridhY0Sphe28fVelLFZ0BXhwaxUQVzbezKZrUKLws0
         lVNPuQqesE7E4HEt1wBqAVH3jKilTmmGTFFKBfcNmq7DhApigB/HPNcaO1ScrG/9DB6e
         h78myZp820XCFHmvNJwRE22qCDHggPTh92XGVxJISkmpKI7bl91p0GGlPANBAiBQ8zoP
         +6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bTmObEIche8eOF7eSYOH3clbEkRgDIf7Lfgw4Jf4i94=;
        b=kfugTAfXgkPa0usjxSf5XSYsrLNfnWLAhsbxLxAqNikvmsJyCL4QF5cuOJzA+uJTDS
         USgwmx6idNpBFrbbTkdMxLPQTQGkxehVKrPyOEzwPSUM7DZIE0JnKwV9CFWBPdkItHIi
         JrYYRWBfQ1cmDpDCymAWOlHS2ydVDLkUf/nyEqZl3BiNZmLx9ZR3W/mal8bvozm/tSbI
         ZsQF6UwzzYv1D8nJlHz7hcZOekIl8WeiTxJbXtysAkbGuI2FzgBmwUFvZ+4PYd6xbwHW
         W7p3dbtBh+XrG3VvS6LY8qKon4mS+3B4fLhN6kC43LwscsaooKok94ogKCqNDMbwTEV4
         qJWQ==
X-Gm-Message-State: AOAM531BszLDpClvczlrXTB0NqoqD5Hixag8RDywcnZ4uwcVjRd7t995
        APhC9BRx3aYV3d28gWXdMpo=
X-Google-Smtp-Source: ABdhPJxrejjkS+3U4Nk1HN0e/saXKTseb0bpLAOoutKsITJv8SwYKYtCNEym6beVKgxT04b7PPqrUA==
X-Received: by 2002:a05:6402:2d0:: with SMTP id b16mr22652130edx.194.1616360765375;
        Sun, 21 Mar 2021 14:06:05 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r17sm9195664edt.70.2021.03.21.14.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 14:06:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net/sched: cls_flower: use nla_get_be32 for TCA_FLOWER_KEY_FLAGS
Date:   Sun, 21 Mar 2021 23:05:49 +0200
Message-Id: <20210321210549.3234265-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210321210549.3234265-1-olteanv@gmail.com>
References: <20210321210549.3234265-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The existing code is functionally correct: iproute2 parses the ip_flags
argument for tc-flower and really packs it as big endian into the
TCA_FLOWER_KEY_FLAGS netlink attribute. But there is a problem in the
fact that W=1 builds complain:

net/sched/cls_flower.c:1047:15: warning: cast to restricted __be32

This is because we should use the dedicated helper for obtaining a
__be32 pointer to the netlink attribute, not a u32 one. This ensures
type correctness for be32_to_cpu.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/cls_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 832a0ece6dbf..9736df97e04d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1044,8 +1044,8 @@ static int fl_set_key_flags(struct nlattr **tb, u32 *flags_key,
 		return -EINVAL;
 	}
 
-	key = be32_to_cpu(nla_get_u32(tb[TCA_FLOWER_KEY_FLAGS]));
-	mask = be32_to_cpu(nla_get_u32(tb[TCA_FLOWER_KEY_FLAGS_MASK]));
+	key = be32_to_cpu(nla_get_be32(tb[TCA_FLOWER_KEY_FLAGS]));
+	mask = be32_to_cpu(nla_get_be32(tb[TCA_FLOWER_KEY_FLAGS_MASK]));
 
 	*flags_key  = 0;
 	*flags_mask = 0;
-- 
2.25.1

