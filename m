Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8195952667A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381391AbiEMPr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiEMPr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:47:56 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADA9B36FD
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:47:55 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id dv4so6922577qvb.13
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVPMWm25zOhHcKK3aV2ODKA4z42m9j9F3+XivUMKUKM=;
        b=YGKh+SU34NkzMQcCAzKbJ04fSlI1JfgG5iMYeSxt2tifmnjFafQTf5kbjXYDyT8JRc
         7udqoWKoPDjPKf04SRiOJHOW/S8cGv117YuPbRPIVVwEG5Q3bn48LwkgViLXdnRiwjhb
         cltmzzXgtJe2pyoamKOo5VlvmUBsOiAPQZpSdZo/2RsJiaQn7YBMONEhqyOLc9rqad9m
         lw1HL1zxgIF8J7xLa+I2qTzf69rLML7bLO0oS6e0dVNWic4SsYBXk5rT6Bal/ZpnFkap
         GOHQVorL+lecf5bmfcwNb1W5Y+hwgJsFiqxDUz+rMwAsuJFnABp5fkDUeeD6rljMv5Fj
         77SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVPMWm25zOhHcKK3aV2ODKA4z42m9j9F3+XivUMKUKM=;
        b=5VVYTmemKveHGG1K0OH/O5ZJMEmzbOJWKXy2CksDpFw71zVTNG2ZechmjJSGCY6bTf
         P5Sm+UhP7OLlwSdDw8BmQ2uNWI2KL7ilE53KIDQyF9loZscaldaW6tkY+MusLB6CrQjo
         NgVUAq2y0ckYYFvOa0KcQnzBvAJxV62pFdmQ+/D+S92k8skiQJlntNhDo4z4mnGf5lnM
         RiUS9i8LlMMvHTLTjARkxOH0p66ZyYyK/RC7vA7rSnWPbm2/w24Volai1+Yz8WcCY2CA
         xPsItT273QYGOYbCQ8KXNGUH0GFsPEIoszRQJTVWtWLCf/m9J54LWjxaKiQEAzOCcg4M
         P04g==
X-Gm-Message-State: AOAM533PDnNsIS7X0a768TSRVl+Yf+GeJ3RR9BNsLG+KZiSFsMP7me6O
        NT0YyCc8Y6MpOF9Mkht4/20dtyhFxT2bsQ==
X-Google-Smtp-Source: ABdhPJwO61hyMqTHL1HH0oaeepWKWLAGICoQY6cUJ+SScqSMI4SSS2E95S8h2liXG/h3labSWluM/A==
X-Received: by 2002:a0c:9c08:0:b0:45a:a2a1:62e4 with SMTP id v8-20020a0c9c08000000b0045aa2a162e4mr4850203qve.114.1652456874599;
        Fri, 13 May 2022 08:47:54 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a66-20020a37b145000000b0069fc13ce231sm1533762qkf.98.2022.05.13.08.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:47:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH ipsec] xfrm: set dst dev to blackhole_netdev instead of loopback_dev in ifdown
Date:   Fri, 13 May 2022 11:47:53 -0400
Message-Id: <01a8af8654b87058ecd421e471d760a43784ab96.1652456873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The global blackhole_netdev has replaced pernet loopback_dev to become the
one given to the object that holds an netdev when ifdown in many places of
ipv4 and ipv6 since commit 8d7017fd621d ("blackhole_netdev: use
blackhole_netdev to invalidate dst entries").

Especially after commit faab39f63c1f ("net: allow out-of-order netdev
unregistration"), it's no longer safe to use loopback_dev that may be
freed before other netdev.

This patch is to set dst dev to blackhole_netdev instead of loopback_dev
in ifdown.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 00bd0ecff5a1..f1876ea61fdc 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3744,7 +3744,7 @@ static int stale_bundle(struct dst_entry *dst)
 void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev)
 {
 	while ((dst = xfrm_dst_child(dst)) && dst->xfrm && dst->dev == dev) {
-		dst->dev = dev_net(dev)->loopback_dev;
+		dst->dev = blackhole_netdev;
 		dev_hold(dst->dev);
 		dev_put(dev);
 	}
-- 
2.31.1

