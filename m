Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA5D0D5D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbfJILEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:04:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40138 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbfJILEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:04:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so2341964wrv.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZe3fuEWz+4bL/5dUjIBq1ybmloXTjvkgnr1lSYgxIk=;
        b=zuDlikSr96JHhH1ubLWtII7U09CjiaOBmPYZdYpURQHzXpvIK2xDYass/9Es1wH0O7
         +Jx44MU91OkldteMqGiTPfPMTSviN0oluk7EuGfwbc7cp957N9cSNLxfDMwqvrMXZSC1
         PY/kBDIRFCR6z13yhdVgGrpJowySup20ncv8w2BWtkowrV+pS+I/zFl3ZMOnRaU7ysDn
         x1Fbqmj2d78ewEofG9gadXuPfL4I+VZMnTVW6kXNvw3awrYisXv/Nx9iGozgKRByOSs1
         l16tGU1mWx4vxgGgpHMfVvnmGQEzE4KCTaTLkvsRtHY3g6ls4IIbcS5nw7UoVjkq02W3
         Yu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UZe3fuEWz+4bL/5dUjIBq1ybmloXTjvkgnr1lSYgxIk=;
        b=LlKFdDF0poi6U7QCMAYVWCl+FZ/tcDq8p6WPpQexpG1H7ENxL3///TthAllmOmrO5f
         23G+aqRtkNgPYgMFtccsdxA+DbCjIkJx3U8Qu2IK9tUSsRdnuNuHADMpbqjgTwaJEsz3
         +XmSWspcx45YD5OQyr8ywIbQmIalMhZOHHZ6ugEDIZCixCYUnX75Lo7juVcOeYXHbLsM
         5JmPay+YrQix5Y9D/1KuwM21GZ1Xbg2QEk3hGhxp2O77tQNThzaRvR0jrhf5vV69QMTg
         P6R5xoU4TnXBmkzzmj8RxkmsjOk8gRMOjCyWzaKM0LFbRX1HptZdmkZ1Rd5geYWqO3NH
         szcw==
X-Gm-Message-State: APjAAAW3dqMwwzvinpkiT3ZOoxFfTLW2UXtuX0mwGn5rd3ZK/OpnrBbU
        ivhY6pFByLK3cG1vtnaLp26zdveRTLg=
X-Google-Smtp-Source: APXvYqzFXFyiYt2Sjt7VExpaiE5hH459lqn+6bcx3w6PAQz0tftOq8mgrtMxT4Vp5U5KWQmDykeCHA==
X-Received: by 2002:a5d:67c4:: with SMTP id n4mr2332411wrw.39.1570619087225;
        Wed, 09 Oct 2019 04:04:47 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id s10sm2947885wmf.48.2019.10.09.04.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:04:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 1/4] devlink: don't do reporter recovery if the state is healthy
Date:   Wed,  9 Oct 2019 13:04:42 +0200
Message-Id: <20191009110445.23237-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191009110445.23237-1-jiri@resnulli.us>
References: <20191009110445.23237-1-jiri@resnulli.us>
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

