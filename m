Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37B53EE45C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhHQC0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236315AbhHQC0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 22:26:07 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CB0C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 19:25:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d17so22932001plr.12
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 19:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Yhah9w6Oz1Cp7fGCsyUa97hPweEEg5SbqlwrhfzFmlI=;
        b=r7R5rOHCng4u96v0UC0C4ZVZEmObmQz96gF3dAo8CT4X+FfWicNvuR6P/y15PRobbh
         xMArUCyAzGPyFjAIk6FmsU8u139RJa2+h1dwfqZt8zRDcvbpXId7CPhc4J41+HcSJTi7
         54Me7/pRR1pacDtxmWwZadGmCL21D1KHBOjPsuU6tZ7dSofKAbTgUg0BEnN4/ft8DCYD
         v9pNu/olC3V3MDOwQFFUQszTxVqO7jGivJCrd2/lyFCnik8inMTjl1giX8MhxiwfQAqo
         OZK3IRh4SM94oAI8wl9NTFLtFZVqM+8SAjreE9p7utKGCLL9lAK/1aUcNlqCtyWG/OF4
         +92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Yhah9w6Oz1Cp7fGCsyUa97hPweEEg5SbqlwrhfzFmlI=;
        b=sg8hMDxpMHhczB2AlFiBNiKpw9VtvW+ngHgNHnjA0J7IUihhEnLSHqbI8IwnQWbE87
         kkHp+9y1dZ3jI8vxh+VO/Wx5QQtq+2SBQv08EPGEgLI1zQ+IrjChc5oGISgtTNMNRpeQ
         n2fxaRCsf0L7hSTFyX2KRGkmYgPy9PNM9pqhC2TT7vq6sFsqV3/jcEqKmtATqfchca88
         XIiH3YRSjKbiaApgu/Mh5ub8rNrSF2ONpbm54O7d97ixHfkv8DsbOtBh5oUbhh3qWVT6
         t0xR0zblTw9PTNMvOAOphshXfCOdkXj2y2vDcHPTH+qF/bOdzJRJuDix0pV7cSoDH6lY
         jaBw==
X-Gm-Message-State: AOAM533L+c8AxLcVQpJ7iKuET53bnqMsNrvIOzBvGknjfs+oO/iWTt4V
        /hHZJL9HjtUvzDFt/vFVHwdwCrfdJ4eB2FArW4pi+A==
X-Google-Smtp-Source: ABdhPJzoUPJgN82Wxl/tUvgCsNwZ5kb2o5gr4LvFKRjPGJTS+e2YOK0R7Nm8A3TAxGwsApBlncwLQ3N5If9H1VfWR4E=
X-Received: by 2002:a17:902:7406:b029:12d:3bc1:3812 with SMTP id
 g6-20020a1709027406b029012d3bc13812mr1004277pll.67.1629167134944; Mon, 16 Aug
 2021 19:25:34 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6IyD5byA5Zac?= <fankaixi.li@bytedance.com>
Date:   Tue, 17 Aug 2021 10:25:24 +0800
Message-ID: <CAEEdnKGsHx5kiUm6SViYru3y8GFLjcLunoGa=0_UQrGi+i7jwg@mail.gmail.com>
Subject: [External] [PATCH] ovs: datapath: clear skb->tstamp in forwarding path
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
doesn't clear skb->tstamp. We encountered a problem with linux
version 5.4.56 and ovs version 2.14.1, and packets failed to
dequeue from qdisc when fq qdisc was attached to ovs port.

Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
---
 net/openvswitch/vport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 88deb5b41429..cf2ce5812489 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct
sk_buff *skb, u8 mac_proto)
  }

  skb->dev = vport->dev;
+ skb->tstamp = 0;
  vport->ops->send(skb);
  return;

-- 
2.20.1
