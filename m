Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D875A0B2E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiHYITt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiHYITt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:19:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A67A570A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:19:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r4so25082341edi.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=HfOnpru6pv/yUTGvHvT6wG2TBK0TLh+AM+luevI/Stk=;
        b=rtEmQyv6iGDZEu54uxfuPb1WDwYPsDBUo9xjlgUvI35I2xaHEVfZpadBSp9y4+S2FX
         WKyGACVPGeZT2nsYGofjyC82iuVY5zqQ2tPw4PzYEUwXlz0l7TpU1vc8BsPYIS6dmwYl
         XQ8s1KrfldOWi+hT2yLGRMdd4XIhw0ImMqtwtDjVc+l6CpIbi1wyVZFBBT13rHb46KXf
         GQcbJaapOxdn8VOC2+V6+/pfIlcqYwuxaqwV0CqA5W2ymO1+sjkyP5FjwOkF9aYG6cln
         6KVwm3t9i/yo/vnJ8fJtSuC4Tgo9cZvpKc/p1sCDKZj2PJesg+/XGbo8vBIJf1fdkwbL
         juOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=HfOnpru6pv/yUTGvHvT6wG2TBK0TLh+AM+luevI/Stk=;
        b=o3zcMwj9bIIZzaQYWkMuzLkdCVrvSjP3KE5PGZ+4J4EDIgEL9g9YqUS3mfFtvEGFi0
         KrZWSYZbprMvM6fbYKwellK/BKd+BxbXNwKFljZkt35rQv99TakVV6op+/Qvre1rIWO6
         lFbIIB+3BxTA9aCS/9NnUdq5vHrbkdIVS0BdMW7DGBo9rLqJ2cx0gAmf0+5lpTcBldrW
         lmR7tinPnAxQ5bCbJTTJZHcZMkSDzSzWWUWVtYYOOixRQqW2JXR8KJ6ScJFHjt6Sf5+u
         fy5iZ5hP22K/iK4wggi2D3CDPR3Tornjbhw9MEsvkWqo/XSI+24ClbnWxNU2dnFVvs1X
         bSpQ==
X-Gm-Message-State: ACgBeo0buJ9Foowzhecc4XfXwlvpr/Ph4ZqUUXYcPwyDwWtBY7K4losM
        zrLXn6tlzTDarT1cmjAQk0TSe53kSVLdYrnp
X-Google-Smtp-Source: AA6agR44TG/E/L1U1oVZO1yLfMh9vRQuezD03nDnlYevigYraONl5HIAQNnEZlRM1sOMV2Swl1IZKg==
X-Received: by 2002:a05:6402:51d1:b0:447:103b:7a70 with SMTP id r17-20020a05640251d100b00447103b7a70mr2263043edd.365.1661415582213;
        Thu, 25 Aug 2022 01:19:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ss2-20020a170907c00200b0073d753759fasm2085807ejc.172.2022.08.25.01.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:19:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, jacob.e.keller@intel.com,
        vikas.gupta@broadcom.com, gospo@broadcom.com, fw@strlen.de
Subject: [patch net-next] genetlink: hold read cb_lock during iteration of genl_fam_idr in genl_bind()
Date:   Thu, 25 Aug 2022 10:19:40 +0200
Message-Id: <20220825081940.1283335-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
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

In genl_bind(), currently genl_lock and write cb_lock are taken
for iteration of genl_fam_idr and processing of static values
stored in struct genl_family. Take just read cb_lock for this task
as it is sufficient to guard the idr and the struct against
concurrent genl_register/unregister_family() calls.

This will allow to run genl command processing in genl_rcv() and
mnl_socket_setsockopt(.., NETLINK_ADD_MEMBERSHIP, ..) in parallel.

Reported-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/netlink/genetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 57010927e20a..76aed0571e3a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1362,7 +1362,7 @@ static int genl_bind(struct net *net, int group)
 	unsigned int id;
 	int ret = 0;
 
-	genl_lock_all();
+	down_read(&cb_lock);
 
 	idr_for_each_entry(&genl_fam_idr, family, id) {
 		const struct genl_multicast_group *grp;
@@ -1383,7 +1383,7 @@ static int genl_bind(struct net *net, int group)
 		break;
 	}
 
-	genl_unlock_all();
+	up_read(&cb_lock);
 	return ret;
 }
 
-- 
2.37.1

