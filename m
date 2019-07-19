Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514BC6E4A1
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfGSLAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37497 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGSLAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so28594795wme.2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rEOn4HQ8dsci/xjkTfI6GwNTGaHJkaj8mkd1tYtV+28=;
        b=Pz3O2dnKCsNL/pwpbQNFHPb2aogKkZdV81gHgCPNUk2TzKId8jGAy/7GYMPZtk6mSd
         Ay5M/0FPmOzHJkqkXYe+nYLnH53m8PnPLidvA+/qdMsnwAMgFo0C6g5KXPwL587WHHHU
         cOO+4NDNd5HX2/VDepLLXVgHZmAjFE2esNL6s4d2ZcwWwpExnz9jo4Q02reFZRuvrgkx
         SDV1Od7TfGnHYEzKOmupi+knhk1qd3uT4YbJ/lH89irpZuM2Z3ARgcd/2WPTW+WIN4Aq
         yRb7YBkfUqh8s1sz1lGTpXK+c3WdsDknBv5AOmUtOfnUO87uOF52cidh3d09a3OzwFkT
         zyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rEOn4HQ8dsci/xjkTfI6GwNTGaHJkaj8mkd1tYtV+28=;
        b=OHI31lZgRngpfWbfKQxlgyCf3bdpjhB7vIPknu7j0jeZRfbL3JR8yHvrq73zTWrsmP
         APe5ODUEk14UNDxAlbatqLGa2Ac34FshuFdxwO/DzRq1Z0pn7ZY96OR1o+yrjfeXZwXh
         FwqWXU4PLoEUme8ayUWn5qGmhfPz5BLXrf+UJvSW9RrVe6+iEZcIfowu4OvaTT8zlLO8
         ADRTOcKX+A7mc5YSyDKS26pyYMB57Fz7EKsPTOTsR9nlwEcXGCN6hJcVIS/zKhczZ0Qt
         E44PKCt2Gkc53kCAhRlbiHB9xFVb+6cknaz0MlBRbcZcEv/CSYmxwKq1sTn5qfM1m47Y
         h7QA==
X-Gm-Message-State: APjAAAVee6IuBcPyFHb0SLcyUU8mXb9pu/NWKrxxZp9ywhINH/slTbQN
        MXw11xiLnalzcls4/8xZETyllfj/
X-Google-Smtp-Source: APXvYqy82zum4d2oMX/ETDsyfgSlKnWJAtpIdWGmiCTemNUvV9+QZccpH5HPcAaEXGTDvCEzvYqFOA==
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr48497766wmj.65.1563534035580;
        Fri, 19 Jul 2019 04:00:35 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id x129sm27163882wmg.44.2019.07.19.04.00.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 5/7] net: rtnetlink: unify the code in __rtnl_newlink get dev with the rest
Date:   Fri, 19 Jul 2019 13:00:27 +0200
Message-Id: <20190719110029.29466-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

__rtnl_newlink() code flow is a bit different around tb[IFLA_IFNAME]
processing comparing to the other places. Change that to be unified with
the rest.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/rtnetlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f11a2367037d..8994dc858ae0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3067,12 +3067,10 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else {
-		if (ifname[0])
-			dev = __dev_get_by_name(net, ifname);
-		else
-			dev = NULL;
-	}
+	else if (tb[IFLA_IFNAME])
+		dev = __dev_get_by_name(net, ifname);
+	else
+		dev = NULL;
 
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
-- 
2.21.0

