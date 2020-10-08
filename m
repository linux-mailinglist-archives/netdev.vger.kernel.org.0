Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6014286E9D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 08:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgJHGSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 02:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgJHGSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 02:18:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0796C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 23:18:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a200so3112363pfa.10
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 23:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x8r0Ekdmnh3+RzeyD0hVh8+L0tzoK+Jsn3mZ0fzXsqo=;
        b=op+2MJS/Wcxxi+bZlIBN4cgXExImYdPBAkHb4+vr+Rz62oLTPzg27aLSuO8EZWL2Yt
         hH8Aqa7QLJR7ClT0ASg53/NnIqPoYH37f6WrnpmTr6qxwbw7JteH5WGJp5cNlS5VErWw
         OYgZSN1Asgh64UgZz4OaJCGEV7+Sw6DAZrloLQLUOQW1E5f3U7SstaiVMVLCfTEWP7G0
         OSHL06u0ZQgxpaf8EkDZVQ1X1mkpsteUofYRXKMEKLCDQBGodH6qeKSKPbi7WquIZysc
         3bMTVF10ujrWfpb2Mx/SW+iH9moagKK2UHyKeKmrWzyV38J7FsBUVuKHKS4Eb+w6x3CA
         gJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x8r0Ekdmnh3+RzeyD0hVh8+L0tzoK+Jsn3mZ0fzXsqo=;
        b=cUP0jKjSfgegG/5/yh+Ta8hKZmRDph3WW1Kq7RiaJW3Esixi6CzagplEcPBFTHscY2
         BehD1dDnb4bw3+647ZMXTQUB/I3JMvZwhiMq/KSckhaMW70jmr6tEv/Z4pZ/f2SWX5bk
         Y4COtwr6jZm37dRVnaTY3k8IZ4v1pL9ox8YH3mEQ9Op8D71TBeNHVeETwcmI7H/tKC2u
         BZhkS8/RObNHywPXcAc5nHKjqXL3qp0Oap9FMnWzHoj0Jzdd4tcvgL72EvGBTcZS9qgy
         i/XmNFYrbBGN/kGcdOONeNzZBsS9HhpyrbJRi7RRi5uY/7cVhpyrfdwKOnYIohTWucdI
         ukIA==
X-Gm-Message-State: AOAM5323BHlxS0UhUpqYAnNBSpACHooUFtPEGz6ursVHpZQSUoEWzg1g
        pHl+zL1dO/m3AUTT4LSjcQJZX2YZdwxpfw==
X-Google-Smtp-Source: ABdhPJx47CHwU46dGQUfZBOGVy4Mbcp9++s7I5JcuTxDhxo/I9zWmdjwONZ2GSEaUiZfmpgeKvrXLw==
X-Received: by 2002:a62:3882:0:b029:152:127a:e852 with SMTP id f124-20020a6238820000b0290152127ae852mr6265884pfa.21.1602137908978;
        Wed, 07 Oct 2020 23:18:28 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id n2sm5340707pja.41.2020.10.07.23.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 23:18:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [Patch net] can: initialize skbcnt in j1939_tp_tx_dat_new()
Date:   Wed,  7 Oct 2020 23:18:21 -0700
Message-Id: <20201008061821.24663-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes an uninit-value warning:
BUG: KMSAN: uninit-value in can_receive+0x26b/0x630 net/can/af_can.c:650

Reported-and-tested-by: syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: Robin van der Gracht <robin@protonic.nl>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/can/j1939/transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 0cec4152f979..88cf1062e1e9 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -580,6 +580,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
-- 
2.28.0

