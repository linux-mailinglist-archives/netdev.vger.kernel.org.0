Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B633A6BBB12
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjCORku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCORkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:40:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633395BDA2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 10:40:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w200-20020a25c7d1000000b00b3215dc7b87so15918965ybe.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 10:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678902047;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=86KxL/FeEM5NYYEL8y90oOKd6si1c/TG3a4QhxaaZnw=;
        b=PJg2QbYdm8FETKVT6uCE/BEP+DzzdUsPh/EU9BVy9yWwhORxv53HQKflyi50Qaiz5j
         SI++sAlr3mlfd4Ue97emiVD8PdZuesRTE61ZZP0Z8Zdey3bU8KMCnTsQBqUIO3a7FiYK
         5pCacmEueijnDOaP83oOK1Vj8/vujcknl0ZXo+dwji/o2p5XFXuT3cK7EHS0JJK4IzjV
         DhePg3hKfAZqKnonSsZ/MjVbee9rHpMcsSntn1nZidGyHJX7rhfdh4f5fOkCiAls+aAs
         bbng4fol0CZKgYXfh1htUg7+lUARb8HskgSTPxhwUTruvJeAvSzcK/TDFkzvmdej7w6C
         FBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902047;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=86KxL/FeEM5NYYEL8y90oOKd6si1c/TG3a4QhxaaZnw=;
        b=j0WAYj9t72/sxbP1iiIExtJLtuBiEUu0D5V6dKpu1wxJV+lzqO78qdLeevr2wE4sPo
         vpOoDUnCBrB8chu3xDCszEmsT0ftKmYWwxWctFBd5JaNyxtEArHjvMtIQJBzRvw92cNm
         vHpL4d7StxXacuxbjADHOAMGi2v5ld/jywh7v4Ov+PaB2JzVgjhUKDU1b4TBHDjrL0lj
         AnOB2YaVyaV5E18g2v8D8QJe0m2jt3FdB4wrqK+dxhmPSVtYFDWPInZOE2o1bras0Zip
         Z+iCrxW7l8qbNdR1MQvFjwnA3JCPFjZ0XeumsuluTVqyuV+2Cg9RXTJmilcYT6m7gdmm
         FkIw==
X-Gm-Message-State: AO0yUKUk/1rfr+h9Vpefylckcai3EisyXfPQbTi6sKibXPpSAuEhPD9v
        NHwh+dIgFgc7jImvWAIy73p/jB9DZBJVDWbxmO7XsiLBO6h0qTfNio0ZgeVXkFBi7GUs2qsbyNK
        ZutWXY8cRzsHRR6AH5ob7ZkgcanO3rHNSM0MoOpI4l6jtccD3V+mlFo3sejiS8FAtuqw=
X-Google-Smtp-Source: AK7set+0gR2Pyhpl7ELRGXgX1mFzgfjN5yqJO82E0J2DDFuCThCqwCsELsE70y+9sV0NDZbhlih3cGvVtT8dUg==
X-Received: from joshwash.sea.corp.google.com ([2620:15c:100:202:8c6c:589:c715:9e40])
 (user=joshwash job=sendgmr) by 2002:a25:1386:0:b0:b45:e545:7c50 with SMTP id
 128-20020a251386000000b00b45e5457c50mr3843339ybt.0.1678902047591; Wed, 15 Mar
 2023 10:40:47 -0700 (PDT)
Date:   Wed, 15 Mar 2023 10:40:16 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315174016.4193015-1-joshwash@google.com>
Subject: [PATCH net] gve: Cache link_speed value from device
From:   joshwash@google.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Joshua Washington <joshwash@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joshua Washington <joshwash@google.com>

The link speed is never changed for the uptime of a VM. Caching the
value will allow for better performance.

Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")
Signed-off-by: Joshua Washington <joshwash@google.com>
---
 google/gve/gve_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/google/gve/gve_ethtool.c b/google/gve/gve_ethtool.c
index b18804e..cfd4b8d 100644
--- a/google/gve/gve_ethtool.c
+++ b/google/gve/gve_ethtool.c
@@ -584,7 +584,10 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	int err = gve_adminq_report_link_speed(priv);
+	int err = 0;
+
+	if (priv->link_speed == 0)
+		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
 	return err;
-- 
2.40.0.rc1.284.g88254d51c5-goog

