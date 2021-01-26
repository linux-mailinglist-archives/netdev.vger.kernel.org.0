Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F54304D9E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbhAZXMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730373AbhAZV0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:26:16 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D111C0617A9
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:25:36 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 31so10472589plb.10
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X7gu5A51tL9YPi5LoUxBw5Jx+DrDIpoTbAvrNR6HW1Y=;
        b=JtWWjcJ94b85HHELHKP28xWT7cBxodjlJTnh1Ct7XXswGJIg6lDHeA7/v6MIqTXW68
         B/SKL3eCrMbClp5ZBnJPLSu1wJYU/DPEvVbuDBTBRknip4qyH0wkrUivgo3NzeVk75vo
         QTeaqd+/2l/PP0vgWgwpMNEa8/82G4VjMyBn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X7gu5A51tL9YPi5LoUxBw5Jx+DrDIpoTbAvrNR6HW1Y=;
        b=jW11gJga4pSJQBN97odwPY49nqcNC+uY4s5b68XdlZEyc9zU6eIJyD8WZNicLsCUoC
         wrIyWSqrL8/A5tKYc4+PO4r2z47+FBmIJ4fPaIopldG5vmBtPAi516hlZwUtAG5RanOU
         R4+ZeJlX3gWK31PUc30qYiapcH59hXxBTqR/78pPJmnat+NethNFVcnjNSvCmjL5mhcS
         pyMsFB9ZrHpKLCQABr9cGuxWw9dj3o4KP3ayHSPypff6475el0nFj3yZkwaHXN44/Xuv
         7F4Q0WbaRk+NJAA6w7jsuQ0kGhAwxotAmgGZsrtU+Xa21zrN3hH5teXg8Zy7U7OQZIHk
         27cg==
X-Gm-Message-State: AOAM533ugb1BwsRMepNxk5pJ1/CXNHO+TrVvs6VWHTBVylM/NQWjWkTj
        GWjtAff3fXN61v62WYqeyvilWw==
X-Google-Smtp-Source: ABdhPJy7DAD2OlxGOaCEvLg+YTJKsk1Mnd1AK7+EU5EoRfmnCEfO/OODa1Z3vkXw8AjgvD/pLG52ug==
X-Received: by 2002:a17:90a:b392:: with SMTP id e18mr1814182pjr.156.1611696335531;
        Tue, 26 Jan 2021 13:25:35 -0800 (PST)
Received: from localhost.localdomain (c-69-181-214-217.hsd1.ca.comcast.net. [69.181.214.217])
        by smtp.gmail.com with ESMTPSA id j9sm20432482pgb.47.2021.01.26.13.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:25:34 -0800 (PST)
From:   Hariharan Ananthakrishnan <hari@netflix.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Hariharan Ananthakrishnan <hari@netflix.com>
Subject: [PATCH 0/1] net: tracepoint: exposing sk_family in tcp:tracepoints 
Date:   Tue, 26 Jan 2021 21:25:29 +0000
Message-Id: <20210126212530.6510-1-hari@netflix.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
distinguish AF_INET and AF_INET6 families.

The following tcp tracepoints are updated:
tcp:tcp_destroy_sock
tcp:tcp_rcv_space_adjust
tcp:tcp_retransmit_skb
tcp:tcp_send_reset
tcp:tcp_receive_reset
tcp:tcp_retransmit_synack
tcp:tcp_probe

Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
Signed-off-by: Brendan Gregg <bgregg@netflix.com> 

Hariharan Ananthakrishnan (1):
  net: tracepoint: exposing sk_family in all tcp:tracepoints

 include/trace/events/tcp.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


base-commit: 24f97b6af9a000bfda9ee693110189d7d4d629fe
-- 
2.27.0

