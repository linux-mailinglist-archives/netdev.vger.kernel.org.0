Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5A8519C6B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347847AbiEDJ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347816AbiEDJ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:58:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69E81B7A5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 02:55:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id bg25so531601wmb.4
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 02:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6RvorORL4PFjiwR8jtSyupeDZcT3rfGA94o8LYuAkA=;
        b=mAczOFTgt3Hg7NoRdqtz6/y6R0ewMdxlqDoD6Rr/hZxhH6LiKk95yZKUGy2FbFBV0y
         8ok4kTwcokp6cWol5rdsB3I4u7HbK8xaHL0nZpmI5phvV3PkPF7TJkPyLmGj7/vvE8Sg
         lKc6MI33dbHpQqNPEYZeudPu0MCk0bIajYGnKOEzZiO62NSHOst2oDkO5HzsuYN8bnlN
         OjkkVPhASkwbfAKDdKirpySRtIvHmK1o2DjxwgDdGWp9ZfxV8tJUmR2XjXGwTru3rJNf
         L/mrW2SohHrj59MjDUY9Tjy4bIaoTZbv9mCkrzuSUtx+8LXWCzWn2SJu316n2lLZpPi4
         rcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6RvorORL4PFjiwR8jtSyupeDZcT3rfGA94o8LYuAkA=;
        b=b4nU53bGwZZXhjYBKkuIrwgsRottDhERF0RoN+L0M58NVp05UXVq7gpBdkPwHV4CeD
         v4iO25mWuREv7G1cPbDzRRL4AAttgDbaGoiQwBsF06HBdSxJZosXsmVf39800yMZYINS
         jk/DHQWYSYaSdFhQDXl1sueqojsjUSga/v26GiAnDOOmim2qDB0JliAAvP2dSC++eHQH
         SfUXgrZJoYcKjwXXY98tPBMqHaKXVBkCnBtJbtB608ZMuBMWtSuLvZjcHw/4KEtvOajy
         Iis8YIpEWiSTceGO3k5C2+0EV8Q7mqvhWneH4PIAgLUVoUoo+esebywnQeSkoWqz+8aa
         6FHw==
X-Gm-Message-State: AOAM532urWpRMHemR9qYDbgJQLFcCtpZ+YSG3A9afbZAL6ntBmvSu9Bt
        kwyHzef4obf36wuYW7VRX+E=
X-Google-Smtp-Source: ABdhPJz6Oku0kLMfEB+WDiKcobhfU+tip7bliPIenKyUQrETqx0HOPm3BNhTtTvePVRyCalsJAxSFA==
X-Received: by 2002:a05:600c:3494:b0:394:3fd1:2228 with SMTP id a20-20020a05600c349400b003943fd12228mr7042269wmq.65.1651658120013;
        Wed, 04 May 2022 02:55:20 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id ay32-20020a05600c1e2000b003942a244ebesm3501100wmb.3.2022.05.04.02.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 02:55:19 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, asml.silence@gmail.com
Cc:     aahringo@redhat.com, weiwan@google.com, fw@strlen.de,
        yangbo.lu@nxp.com, tglx@linutronix.de, dsahern@kernel.org,
        lnx.erin@gmail.com, mkl@pengutronix.de, netdev@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net-next] net: align SO_RCVMARK required privileges with SO_MARK
Date:   Wed,  4 May 2022 12:54:59 +0300
Message-Id: <20220504095459.2663513-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
option for receiving the skb mark in the ancillary data.

Since this is a new capability, and exposes admin configured details
regarding the underlying network setup to sockets, let's align the
needed capabilities with those of SO_MARK.

Fixes: 6fd1d51cfa25 ("net: SO_RCVMARK socket option for SO_MARK with recvmsg()")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/core/sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index be20a1af20e5..6b287eb5427b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1315,6 +1315,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		__sock_set_mark(sk, val);
 		break;
 	case SO_RCVMARK:
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
+		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
+
 		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
 		break;
 
-- 
2.34.1

