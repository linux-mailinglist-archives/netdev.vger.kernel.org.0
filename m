Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CE16903D4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjBIJdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjBIJdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:33:12 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F62D627BE;
        Thu,  9 Feb 2023 01:32:54 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id u9so2232447plf.3;
        Thu, 09 Feb 2023 01:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RSCzSrWqqFCSoi85FBiCMe7hRIEtbX3lmwkUIluqIE0=;
        b=pBoefyZ6s2xqr+IWMGdZvzxq+YAqAa0nAZYyzT/vV+X6OyOxBsGpjGKeQXB8O9aTLG
         gYSszmAarJ3/T39rr7O1Wh5F3jjDuStb3rHTF0GzjJ9kApQhSm7ijJ0nKcB3LpI6QkYu
         AY9K8XCJYJcyVcmi3X7otABZoLPZHZOAzV0Av8vLIwJUmcFIdZRimhm8/feM2vjPQDtI
         KdOwNLI07ctCHu2ucoUd1OrqgSJ39PbeCMqb6Qd6cwS378GWclJ/TxNCgdeJJ7CHL3GM
         RVT9YAR4A//A0hMn7pNh34F2lFXq3ES0X3F4FQA6MGmo9vv3UM71rAx01hSwR991jMPZ
         l1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSCzSrWqqFCSoi85FBiCMe7hRIEtbX3lmwkUIluqIE0=;
        b=Of3p+GOME2rY1p3RTKDxvVGYEdQOpyBo6SIHka7p8Q5Zf6JePmFknZm0LFXPxHx+ly
         AhsyRzpdjRkcabSYnBG6adojz2q6vDjCWLnfFjbAsnaW+9lDNorwh+zhafOxApQl1q8b
         SbOFlLkbWtNvS2JkzESf/CmGwtjNPCB1wU1wgVXBMGxv8FeFev6i3hCp+JgWjL+RMt+D
         66/twDgBhnv0DZ94Je3fJpg0TXnIhZrP6Ehx1j/YFqVQ4N5nsh6GXhs2deKmta77KUcO
         VDgCPWxH6GjVBDFQRBOnkrIAWbkVJcw2oGAE8EcWXqW6tE4uebI/WFHvuitfuR54MYep
         wg2Q==
X-Gm-Message-State: AO0yUKVOcAo3//sxO7HUN7qebA0nDYfEpZnOj3brN6n05NSJ19krP9OG
        xUMBA+qBeTjy1OtR47waNuM=
X-Google-Smtp-Source: AK7set8yQ0RJ4MUM7zshG8MgcCoU9ZatSrW5D3SyCiuGZJdQdUBDKsJMh4F/RtZjXXiNpopRFR7tKA==
X-Received: by 2002:a17:903:1107:b0:196:3f5a:b4f9 with SMTP id n7-20020a170903110700b001963f5ab4f9mr11140316plh.1.1675935173906;
        Thu, 09 Feb 2023 01:32:53 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902a40a00b0019663238703sm989116plq.109.2023.02.09.01.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 01:32:53 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        echaudro@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
Date:   Thu,  9 Feb 2023 17:32:40 +0800
Message-Id: <20230209093240.14685-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

old_meter needs to be free after it is detached regardless of whether
the new meter is successfully attached.

Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: use goto label and free old_meter outside of ovs lock.

 net/openvswitch/meter.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 6e38f68f88c2..9b680f0894f1 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -417,6 +417,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	int err;
 	u32 meter_id;
 	bool failed;
+	bool locked = true;
 
 	if (!a[OVS_METER_ATTR_ID])
 		return -EINVAL;
@@ -448,11 +449,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock;
 
 	err = attach_meter(meter_tbl, meter);
-	if (err)
-		goto exit_unlock;
 
 	ovs_unlock();
 
+	if (err) {
+		locked = false;
+		goto exit_free_old_meter;
+	}
 	/* Build response with the meter_id and stats from
 	 * the old meter, if any.
 	 */
@@ -472,8 +475,11 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_free_old_meter:
+	ovs_meter_free(old_meter);
 exit_unlock:
-	ovs_unlock();
+	if (locked)
+		ovs_unlock();
 	nlmsg_free(reply);
 exit_free_meter:
 	kfree(meter);
-- 
2.34.1

