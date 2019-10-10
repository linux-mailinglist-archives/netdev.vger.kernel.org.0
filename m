Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D507D2B12
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388244AbfJJNS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:18:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36578 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388178AbfJJNS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:18:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so7881791wrd.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZe3fuEWz+4bL/5dUjIBq1ybmloXTjvkgnr1lSYgxIk=;
        b=du9TCWpkDwzSV6oBSOgksEgMrilBq+QFmgjQJoXq5fkzhsCDWsQ2x4/uKZXF0XNFo+
         5g5yUBqmP7VplUWmK7pajLPLvejphHu3o25yJO5Uem15mB8dCePb2imF7iMy8iijBN3F
         5FFyZd2pr7SWS1lb3omlOYconc+zlKgFBayp+0srr+yqBjq9b7FnOzyZkVZsVIVbQN8C
         /EwfZS5XcyX/g+BqWoMx8casXct7coO/3DOZ2TAQ3fKUnIAyYmjsOSd0Ng46aA6TAjMi
         B5NvH246myV+bq4m8zpTAf2OgB7Hf+lVYTqhJgP7kf4qN4P8uo8ORQocMIdY0+JiiktM
         hi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UZe3fuEWz+4bL/5dUjIBq1ybmloXTjvkgnr1lSYgxIk=;
        b=hdjk0+FG710Q0n/vTltgmJ8lBCqaLsGQRe0ijUQ8ZA30TGTca36Hj9RSjjcL7iDRTc
         66bNcM06KwrYIRn9WWAdRDMRWDXkHLsMugzKJgErnc23XXA0qEinhjW+fiXwD8sLXcUq
         3CMnFcpRvC7Q2asmG+pzXnrv14vGh8Q/YYyP0aiIhmzcENeoRhPogZrMkODFm5z9c/UH
         N8vAxcRBO8xQBNYu99B+rDHYQLpxIqgYtgPwlOf48t3oBwJvjbuTq8AEt1aj1+QVoaIH
         BHgS38v4iin8ZgmEG99U/s9p0oOXwSivvnmFT6IERSLRAbVQYlHWA1V9vJcApLis0gj9
         7KXw==
X-Gm-Message-State: APjAAAVmOrZ6omhs2XySlA4Ffr/8VtYrKScpcmY1AxtZeyCBOaamM0mo
        dzJNHDEu+YLF9gexHdi5cjQR5m95PjY=
X-Google-Smtp-Source: APXvYqz8gI2xAuxX9IF6q+jCO86HxEMFRAvcNnSe/57Q/bYZmXUP3bds99SWW4gkOMEcESf0JtCopA==
X-Received: by 2002:a5d:4b09:: with SMTP id v9mr8146532wrq.127.1570713534598;
        Thu, 10 Oct 2019 06:18:54 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n17sm5875020wrp.37.2019.10.10.06.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:18:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 1/4] devlink: don't do reporter recovery if the state is healthy
Date:   Thu, 10 Oct 2019 15:18:48 +0200
Message-Id: <20191010131851.21438-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010131851.21438-1-jiri@resnulli.us>
References: <20191010131851.21438-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

If reporter state is healthy, don't call into a driver for recover and
don't increase recovery count.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index eb0a22f05887..95887462eecf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4851,6 +4851,9 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 {
 	int err;
 
+	if (reporter->health_state == DEVLINK_HEALTH_REPORTER_STATE_HEALTHY)
+		return 0;
+
 	if (!reporter->ops->recover)
 		return -EOPNOTSUPP;
 
-- 
2.21.0

