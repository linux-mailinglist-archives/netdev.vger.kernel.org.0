Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B422A63AF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgKDLzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgKDLyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 06:54:05 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD097C0613D3;
        Wed,  4 Nov 2020 03:54:04 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id b19so10198422pld.0;
        Wed, 04 Nov 2020 03:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nJxfeZf4oCT8ps++04tgib7TfaS8R9ADOdaXcOvploA=;
        b=MP4ErakQDu+vqkuF7A9mIq0ruDnqUdfdjZrkjD42qyJ0oUu/aq6P9ps/a+2YfAiacd
         PhbbM4oqZozce/F3RCyMtNx8wb8+chIuZBvW9mp4HVIXdGFd2R0r+rn+JZlnRTiNwoo4
         JBhK4bN/x1re+ygxVbjAsiOChFTKDTgJVxQP+F8pJnfKiO1WxR+rgiOfoxarjyM2iIlo
         /5YDkH+BAdCJ7qvs6rRi0QqD1aOTJ9/zolrNNoPCaHXTZkPLnk2u6U/AsOdXYol4KgQ3
         i/tJjRR2nVomPDVjOufzRngy7vpA+ANEQp0c6EO+iNpICPEbPbVU7yb9FSEnQHJ6mYte
         5V/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nJxfeZf4oCT8ps++04tgib7TfaS8R9ADOdaXcOvploA=;
        b=MdcqPIjjATzFqfhsP9MEhT7meNxkJrsp1J4Lctkr4tnUblq1OJMJuiyyE/qXaPVlfF
         3OQGLcD4qjj/uk8IYkW5C7aNss76w6rijjnASSjj4mWYGsqNpPTDd7bZ69jYpfFOdoEh
         x0oQN+yQo5eYr3uzkTisCLV+SI0NAtbysr3khXxfA3OYRL6iuOLWzcL2YyDO4QQHjqqC
         bz18Dh5zhQ9hJkUQlt6KtbrYouIewEZbS65zmU3un3fqGnxB67+4Kpp1msIh6rA5QYgY
         e8FA+40P9+YulBUGjjvlx6QoShC+ZGcVId+7ZTF3yAcibS1nKRbq4DkpJ7RY4qI49L3c
         Vs2A==
X-Gm-Message-State: AOAM531QgA1arOimCKWNLYaj0439dUAWHZMoTfWJEVga+KUlCKW2igUE
        3/nD1ShLMz770hZC1LPakPY=
X-Google-Smtp-Source: ABdhPJwXogO6HMUywYGJacVTVcdqHQ83z7S+Byal8k+zEZRhrHx+YVJRsllUoRzJLk/RzU4CM/bMsA==
X-Received: by 2002:a17:902:6bc8:b029:d6:d9d:f28c with SMTP id m8-20020a1709026bc8b02900d60d9df28cmr28915048plt.17.1604490844427;
        Wed, 04 Nov 2020 03:54:04 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id y124sm2181982pfy.28.2020.11.04.03.54.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 03:54:03 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingtianhong@huawei.com,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: macvlan: remove redundant initialization in macvlan_dev_netpoll_setup
Date:   Wed,  4 Nov 2020 06:53:11 -0500
Message-Id: <1604490791-53825-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for err with 0 seems useless, as it is soon updated
with -ENOMEM. So, we can init err with -ENOMEM.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 drivers/net/macvlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index dd96020..a568b39 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1096,10 +1096,9 @@ static int macvlan_dev_netpoll_setup(struct net_device *dev, struct netpoll_info
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	struct net_device *real_dev = vlan->lowerdev;
 	struct netpoll *netpoll;
-	int err = 0;
+	int err = -ENOMEM;
 
 	netpoll = kzalloc(sizeof(*netpoll), GFP_KERNEL);
-	err = -ENOMEM;
 	if (!netpoll)
 		goto out;
 
-- 
2.7.4

