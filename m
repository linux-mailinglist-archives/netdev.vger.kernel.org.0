Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE58422CB49
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGXQqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXQp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:45:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE4BC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:45:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so4768295pls.5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7dO7tZEdiUY9tOGjM8VNG2nAtt28ObMbKayjnz3C1jk=;
        b=hRQDS77NKTMW5ry05exZ0aPJQoUWK3I2n/ItdiRwnjjVasluOSSUmURQAMvumMfR10
         BG8QciT1xQw/l59D0P5oxu84kiWIdRwDMU5KEGe3mvLDaILVyPrF4K+1n2RnBOfLgs3n
         x3FzWFa5fQZ4wfJYHaOgZ/2mBY/hI0qvezXrCYlM9l4pUBk+9nqTzSLGynRARnXnNKih
         9ird+5QZuSXKEbxdlZmT5kfqe4631Tv2IweCgCVozJWixq/PnLdfyxlIUWHyKheSFk4K
         e4AMf/AagWa4FmpkNRoIAzhWpWDDEvRdjJkEmN2NsEf1L5FWl5wzT5z1ME/XRGXK8FZh
         QMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7dO7tZEdiUY9tOGjM8VNG2nAtt28ObMbKayjnz3C1jk=;
        b=cWoDjxBG6LpTCnpJ1mu6qseS0r5/+XPn4d1vcL82SmVlGbYqgriuHa2K7wUZ+ywogY
         IE8mXqQIAmdynoov/L4T1i5nPIqiBleru8V4dR7Ep5+eGlapsbs081cJMGa2nu19Nr16
         kPvSXwMEeYzSTChrqTyjI6+gWnMyasNCP1VoUrfn9Iex+YtdD9NEnAgfOTbSfeJn3ISx
         6udK2Ece2/p4d+Q5qLIraPkeSx+xZWhBXwvzn5q7Or2UUb4Y63qSn/sqgbqbo0kJGZuH
         RN226rPw57sISsK9cDm4dAuhkTNNZSLb05cDlkqmQkay51qhRnGKfAZGkcq8WkrX1KnW
         mtVg==
X-Gm-Message-State: AOAM532sPXwy0+w9rbtW4qKhe4UTAiywnlcbQdssygmCrbE+691pHhlm
        ay/TF6H81C0oNjjebqHFsYAJfj1bdow=
X-Google-Smtp-Source: ABdhPJzgA9rTvFBSTfw+zQX2rL7xoLRzLPARbk4HaRj16boG6Q7P89KT+CsFYbCWG+MDHAikmhYAaA==
X-Received: by 2002:a17:902:7284:: with SMTP id d4mr8441934pll.164.1595609156009;
        Fri, 24 Jul 2020 09:45:56 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::46])
        by smtp.gmail.com with ESMTPSA id j26sm6711936pfe.200.2020.07.24.09.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 09:45:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [Patch net v2] qrtr: orphan socket in qrtr_release()
Date:   Fri, 24 Jul 2020 09:45:51 -0700
Message-Id: <20200724164551.24109-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to detach sock from socket in qrtr_release(),
otherwise skb->sk may still reference to this socket
when the skb is released in tun->queue, particularly
sk->sk_wq still points to &sock->wq, which leads to
a UAF.

Reported-and-tested-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/qrtr/qrtr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 24a8c3c6da0d..300a104b9a0f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1180,6 +1180,7 @@ static int qrtr_release(struct socket *sock)
 		sk->sk_state_change(sk);
 
 	sock_set_flag(sk, SOCK_DEAD);
+	sock_orphan(sk);
 	sock->sk = NULL;
 
 	if (!sock_flag(sk, SOCK_ZAPPED))
-- 
2.27.0

