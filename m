Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C763413EE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhCSEAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhCSEAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:00:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A66C06174A;
        Thu, 18 Mar 2021 21:00:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so6056578pjq.5;
        Thu, 18 Mar 2021 21:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TegYIsZ25A3LfiaM2DL4uTLW6gJgEq61GqpsbzZMT/0=;
        b=qe1Vqar6Tsd1OFiOeSWEZ//dNASci8uru9fFdIOHOUp1oK1lpEcu3peLYYenouhDE+
         0GRWZMf/EWaxBcLjpKl+R4Um0CBqGHL/YVb4f+hnL9mVa/oPABnYmX68+yqzlGOsXb9K
         6ctPIsceMFSKeEwfP5M9K0SvXqSHlnjewck44PM1PX+EEoWC5FZoMwwV1YrvvrHr6UFa
         n6sRr7is4iJMak5Fhr0zgNXJ3jfE1rKe7h/53oZmcsoqfRD8OK/mUVBtha3HkhzEKHpz
         4uv000ZmwM7PAhTjV8SS4Kcv/jdNl7UfjBxYuQpWmr4UD2I3WBcVAqw3D95kfKT+fTJT
         EB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TegYIsZ25A3LfiaM2DL4uTLW6gJgEq61GqpsbzZMT/0=;
        b=bJeU8aFvjCjXxxqr2LGTIA5Xr5lWn0F+jBMrb7yxrd0LlnwtOCrlszb72baOQTUBp2
         b/oKYqzXKo1U6Fn3QBxck9rzdaTSlqq2luTBSZBi/FrAKnQ37eHGWAgx5pIqKS9fI2FW
         V2T498dQZ+e6LNT9ctfQ077zMDaMTnyy1D0p/htQ8qVvyJ1nZ0cbwbxT7V/DL9eaFZ4E
         AV8vKYLdb2nO2uBcmML6T2cP394hzBQBxBDYIlL4ei6c5C/fb6QAH5Af1Uw8SMd+cJRm
         o3/RGcVZ821oTODrDQGjaai20iUcBtMNIrYHiG6Yf6RM4AghXPT2h1BvX+mAAa2rtLQc
         JbRA==
X-Gm-Message-State: AOAM5318JrjKhW0C/OPXFyb29mOoupdoL5ctdJzgkwFCqPPWunQGiBdS
        PcGW0A3zSYi5rg7qdGGz2GLtTgXwnxU=
X-Google-Smtp-Source: ABdhPJytB0j3J3YRHSbAr7m6iZtkAI7eTVwVcc+IWLMBMqRi5CzIxxiZ6fgVeMwPOVaYHhiQ0flCxw==
X-Received: by 2002:a17:902:7888:b029:e6:b94d:c72 with SMTP id q8-20020a1709027888b02900e6b94d0c72mr13268865pll.8.1616126436380;
        Thu, 18 Mar 2021 21:00:36 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([115.164.184.3])
        by smtp.gmail.com with ESMTPSA id gi21sm3055881pjb.2.2021.03.18.21.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:00:35 -0700 (PDT)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     chris.snook@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH net-next] atl1c: switch to napi_gro_receive
Date:   Fri, 19 Mar 2021 11:59:22 +0800
Message-Id: <20210319035922.343-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing to napi_gro_receive() improves efficiency significantly. Tested
on Intel Core2-based motherboards and iperf3.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3f65f2b370c5..3e440c2dc68a 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1851,7 +1851,7 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 			vlan = le16_to_cpu(vlan);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan);
 		}
-		netif_receive_skb(skb);
+		napi_gro_receive(&adapter->napi, skb);
 
 		(*work_done)++;
 		count++;
-- 
2.17.1

