Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52F513AC22
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgANOT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:19:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44048 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgANOT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:19:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so12339603wrm.11
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 06:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nPqB+Cem3nsKtjif7nd+gcRBzg2FJkl2yJVJZWi6w18=;
        b=lYEfXF2af7Na84/6Iq9XpO5p2YHlpY36DXj0U/Yi4+/Bh7lpS05vhwHnt8T69c7zzQ
         FvkMMTpXY5eoZYUTughSPMiob5jyoITpv6QwndvooHxctnYtKkbvErqT0wLobjRlnqd+
         hfNs1FxVyWxZVxf+W5vciS7liUwGQ+dxgxrVK3Q9t/aHJQb8CxSUjfsnKBX+E9dNqDTK
         qBvyPIiN/OI1GVxciBsEHD9BzX91NuHfEuQpSVgSeFoDHu82W7NKt50R2V973dSWnPAK
         mBZlMHlkGcSTP/84bW1XbOA7LADZjtlGKJhOaVwX12Z8YO0CoGjd7cqzxlCEmyVwAKQW
         vVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nPqB+Cem3nsKtjif7nd+gcRBzg2FJkl2yJVJZWi6w18=;
        b=PBtERfpy0zOdZF5S5KOofy+NHkxe0FmRSzYNAVMqfq4W7NQ/cqqRIj7lvbUGZR+SMz
         b5izrsMQv02D00VX882lRoRS7AwIml6dl3bTTNG46oerIi5w5j4BzV9Ux2ihkdESPMHX
         whcG3wpp14SKoVnVVbvYnp5Rw1BGFbRyPICSVWZI+cCnm9strS5bnuE52RkYpzJh8LTm
         d3BDLLA1+dc8ixbaH/8PU0s1ArQtbmSBgWb78iaqYrnbQ9ZlzDbkGZUNEJvaNJtSl1BH
         SKKGZkhZGIY+iwEEwSTXRVi5CTeRyxYFfj+vanPnZPvGzNQCzAhgTNwIV1JPjEgWwHbq
         QEoQ==
X-Gm-Message-State: APjAAAWtptSAmwQtFjAWui85LB3N9tBYVt2Uxlj3PCl6Lfw4mEOzl2Ld
        6Nm3QO6GYhJj+X+GOblzxIkQEANOaHZ6zA==
X-Google-Smtp-Source: APXvYqx9wyen2t4zQlpWaDed9+jwKKcIZfHpyG2RZSvG1wG3ldmPlufOXEjp1NAmNBA3Nq/XpwRUzw==
X-Received: by 2002:adf:81c2:: with SMTP id 60mr24528310wra.8.1579011593085;
        Tue, 14 Jan 2020 06:19:53 -0800 (PST)
Received: from gir.kopla.local ([87.130.86.114])
        by smtp.googlemail.com with ESMTPSA id v17sm19754830wrt.91.2020.01.14.06.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 06:19:50 -0800 (PST)
From:   Ulrich Weber <ulrich.weber@gmail.com>
To:     netdev@vger.kernel.org
Cc:     xeb@mail.ru
Subject: [PATCH] pptp: support sockets bound to an interface
Date:   Tue, 14 Jan 2020 15:19:43 +0100
Message-Id: <20200114141943.11856-1-ulrich.weber@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use sk_bound_dev_if for route lookup as already done
in most of the other ip_route_output_ports() calls.

Since most PPPoA providers use 10.0.0.138 as default gateway IP
this will allow connections to multiple PPTP providers with the
same IP address over different interfaces.

Signed-off-by: Ulrich Weber <ulrich.weber@gmail.com>
---
 drivers/net/ppp/pptp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index e1fabb3e3246..acccb747aeda 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -155,7 +155,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0, IPPROTO_GRE,
-				   RT_TOS(0), 0);
+				   RT_TOS(0), sk->sk_bound_dev_if);
 	if (IS_ERR(rt))
 		goto tx_error;
 
@@ -444,7 +444,8 @@ static int pptp_connect(struct socket *sock, struct sockaddr *uservaddr,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0,
-				   IPPROTO_GRE, RT_CONN_FLAGS(sk), 0);
+				   IPPROTO_GRE, RT_CONN_FLAGS(sk),
+				   sk->sk_bound_dev_if);
 	if (IS_ERR(rt)) {
 		error = -EHOSTUNREACH;
 		goto end;
-- 
2.20.1

