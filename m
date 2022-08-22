Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E34F59BA1D
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 09:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiHVHTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 03:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiHVHTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 03:19:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97C813CDA;
        Mon, 22 Aug 2022 00:19:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so10356496pjf.2;
        Mon, 22 Aug 2022 00:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=03jo1+f8X3EXXKFUBIJeAZG4V9px5mryHYSkj2Zd4n8=;
        b=pA1jdg+xuB/MBjFO+tnrbUfRwIwk8NjKBvPbX+U4uSnJRafMOMjI1atzqhTXmwpcqU
         uqI1cx1w0+la3/N0efzt/xCZPOEr8jcmHKGPbu4eyJY5L8quVq0kMXd2U5jJihWlHLMQ
         t/H2lBPFheBrxEMtX9M/6OZAv9EPCyuL/BS0pTQWMeRDb9JI3dTBNI0ZCkdR+sqRAUfl
         /uR8B/OYtM/yOYbX2ysxkNFmvWqRCURrVsnMtZn4HMoHnmio0uF20f4cxu/6222nHcvV
         oACmN3WweoN00q1OnZ2LXwlHAYxdWhBYcgLFynvR0Dby2+514Y3l8dg63zyQvGRWaeow
         KF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=03jo1+f8X3EXXKFUBIJeAZG4V9px5mryHYSkj2Zd4n8=;
        b=m0+KLSXhLZrKNKjigQ5dRRDsbuXPlsqAlM/zBq8u3DX5rCDLPWajxCiBjT/0HG8YH4
         yYhKQvD1wApaianq8TAuG+i1mJDoaDQs+TM11T0H0KkqQU6/rwDNW3MLta8T0ADrgJUo
         +Cc9M46slLpgQ3juPdTPvjywVR8hz3dnvsDrDPBjK39Cne9GL+reNCNI++z1+mkcHL06
         2IiDTd62RJeitDGzRK5Pirizz18XBd0nXaqXir+6uc0zbqs/kp/PTMcKSnxX8jqHqa+E
         58H5TPo2OfhjMrHCkR165ZHCP9aDDuZC5O8xPrhg7gz1zGonhCtsptSFPriOBhowWt+X
         uWhQ==
X-Gm-Message-State: ACgBeo0LAK2udfrB1PgJsRgqcClWsCt0IVXyCV7JPL4OERvIt5g52tkb
        HBQSrvyME9v0BgRJ8rtF/Iw=
X-Google-Smtp-Source: AA6agR5WnXDUV5MQwujJjQN1TuZSCgnkZwKzqgjYDKUr/W2Bcn0Lx5PJjWBL1OVFtGd288lgYqyGbg==
X-Received: by 2002:a17:903:1d1:b0:172:e12b:71b2 with SMTP id e17-20020a17090301d100b00172e12b71b2mr6141394plh.60.1661152758257;
        Mon, 22 Aug 2022 00:19:18 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id d7-20020a17090ad3c700b001f3095af6a9sm7330394pjw.38.2022.08.22.00.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 00:19:17 -0700 (PDT)
From:   Haimin Zhang <tcs.kernel@gmail.com>
X-Google-Original-From: Haimin Zhang <tcs_kernel@tencent.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH] net/ieee802154: fix uninit value bug in dgram_sendmsg
Date:   Mon, 22 Aug 2022 15:19:02 +0800
Message-Id: <20220822071902.3419042-1-tcs_kernel@tencent.com>
X-Mailer: git-send-email 2.27.0
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

There is uninit value bug in dgram_sendmsg function in
net/ieee802154/socket.c when the length of valid data pointed by the
msg->msg_name isn't verified.

This length is specified by msg->msg_namelen. Function
ieee802154_addr_from_sa is called by dgram_sendmsg, which use
msg->msg_name as struct sockaddr_ieee802154* and read it, that will
eventually lead to uninit value read. So we should check the length of
msg->msg_name is not less than sizeof(struct sockaddr_ieee802154)
before entering the ieee802154_addr_from_sa.

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
---
 net/ieee802154/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 718fb77bb..efbe08590 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -655,6 +655,10 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_ieee802154*,
 				 daddr, msg->msg_name);
+		if (msg->msg_namelen < sizeof(*daddr)) {
+			err = -EINVAL;
+			goto out_skb;
+		}
 
 		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
 	} else {
-- 
2.27.0

