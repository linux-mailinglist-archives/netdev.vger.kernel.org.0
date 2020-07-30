Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3454233A49
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgG3VHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbgG3VHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:07:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C47CC061574;
        Thu, 30 Jul 2020 14:07:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z18so22586393wrm.12;
        Thu, 30 Jul 2020 14:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=usQcY9oDo/TU/kpDDIL7ZCIRsakMj2eP/7ZBDv4aLmk=;
        b=gI9EGo28Fw5DgzGOZG3CRYoUrpJGcJDOFOFxNyiGWQUoEf7/fuR1sRdGJpUKXVcnf2
         7Aymy2EOe753pjs2b87T43lrfhU6v+7s6ZUiU51yR6MDvSVwwxhrD+whD63mHM6PdI63
         azm5LoFPSdXKtXYlL3oJ2PvUMbnzxb17ojCyyPaZ/ytIuT4gc2X/EYwiQoDPeRUebGYh
         /CmZjFEG7XlviH1msN7GgpZ0cVeDQZC/cCSL15Xo5DzUwse/9c7IfwaCD6HuEcCgv9/q
         Hjpn4jxbnd9Xcx9kZtwwCJZrckjAgvaEE0v3KdLgn3lJaj7v21EV+gDDoNRgJyxHw82/
         W47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=usQcY9oDo/TU/kpDDIL7ZCIRsakMj2eP/7ZBDv4aLmk=;
        b=tpGtkdcULb/hIHkt7WdzmNIAZckjlO3IDdE9G01Ll79w1csUB7OB0+3V4vC+hvCjYv
         M/iTckwUjKq974U5wnskVK4Vn3QFAc2QGKmJNzyFOmbSpN+YAVft1gPEmADFJ+xIrTab
         7VTx2wIIWUooYz41mttInvNT9VSTJAT8kLaXqaEDxdyadOKf9nSe0oXnC45Ntr4i8yjx
         N0VSyqHHjjbSBoUSht86kXwDoge5Zce/h+9r8Y18VBwNLfA/juuQc/lhNEpFIf/cpyjw
         0Jigea+wkmIlLNOu4XDTYq9qCy+tiP4EJgsnCOKQNXSTWyQCKTA0di+6HYj3jd7VVqse
         MZsA==
X-Gm-Message-State: AOAM532rVXlSf2JD/YWNaWG61GvTlhJ7Nr8lxN2e39ZmxLP5YW1tyAcg
        6ZDO0+gL8AlenXfjbMhyNtAl01tZ
X-Google-Smtp-Source: ABdhPJwBMoft9EK79eR8HN0ypo2bEGapPKka/0b4F4GLOAi2yG88olq5Pl9gXahi3x5AQw8XhD7hKg==
X-Received: by 2002:adf:fa4b:: with SMTP id y11mr473551wrr.349.1596143271526;
        Thu, 30 Jul 2020 14:07:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t17sm10085433wmj.34.2020.07.30.14.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 14:07:50 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] tcp: Export tcp_write_queue_purge()
Date:   Thu, 30 Jul 2020 14:07:27 -0700
Message-Id: <20200730210728.2051-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After tcp_write_queue_purge() got uninlined with commit ac3f09ba3e49
("tcp: uninline tcp_write_queue_purge()"), it became no longer possible
to reference this symbol from kernel modules.

Fixes: ac3f09ba3e49 ("tcp: uninline tcp_write_queue_purge()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6f0caf9a866d..ea9d296a8380 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2626,6 +2626,7 @@ void tcp_write_queue_purge(struct sock *sk)
 	tcp_sk(sk)->packets_out = 0;
 	inet_csk(sk)->icsk_backoff = 0;
 }
+EXPORT_SYMBOL(tcp_write_queue_purge);
 
 int tcp_disconnect(struct sock *sk, int flags)
 {
-- 
2.17.1

