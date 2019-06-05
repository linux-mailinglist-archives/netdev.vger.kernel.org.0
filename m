Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6425635FAC
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfFEOzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:55:21 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:40052 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfFEOzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 10:55:21 -0400
Received: by mail-pl1-f202.google.com with SMTP id 91so16226950pla.7
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 07:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J009BEsnAJ6BP+DWpLDdQufdYROONhE5OW4Uf4sR39k=;
        b=oc35DxmuYbINUAb9zJLgKb578zI5fwcJiaG6UjZ83qhPeegQ3RIT0HjZLeC/qi+H3v
         A6txzkbC/igXICz8P0pr5fea5+6FbOMunYrEO4ho3hXrU/iIaN1Pqj1qLqY6TMQR9upa
         8VcPHEY4jSt8ylq0wXFktfZ1cEMCGhKOcLuCvvg/6O6z+izSjk9djHgzElTqOy7NeCLv
         P83qZ0l2jiRYVpQIJJGxLHsk7ef/lZVxnYJ1u9nOp/dF+VED0QAfQ4DAHbGHGRH8vvpA
         3ajTpQg1WgVy/I8m5WFtuRiYsiT7uoDBSlTaiUFYQyptrI/F8smxZNArmuWnxaIExL8q
         xm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J009BEsnAJ6BP+DWpLDdQufdYROONhE5OW4Uf4sR39k=;
        b=Huw7opGS55kEWPsd1I16SzRehZkBvTKr+z3z092kUyRGbd9Sv8D2jP5Ay112GYroCK
         1Le5z/CfpjzaZvbZ+AjnFLJd0nfzaHc5qre/FYScsamIK9COwu0erzNN6tIeh7HnWDIM
         h+LMciIaW7zybIzu0CjQbXVaHi7J9U3nD3b4BqWnJwjWbFbYfyIdRpB9afSqlS5nt5ZG
         ms0klMx/Kzoa4t5y/S694G8D+C5ejrCU4EBPtq1j5pS7WEDjjklVnK3+b+LN7jw1s6oG
         9h8oIWljBkMFaMjFcZTXLWqINLdaY4O8vfIUYRtrL4NG+SvquttJ5q8EJIjDboTjx9Eb
         BUWA==
X-Gm-Message-State: APjAAAU+n5XawL0ADwAP+T/SgK1TuHNcM6zMmM++PjBNUWMuVxlflaos
        VHUCl0maI2as2C0L3SRJw5qQFlds1HDNjg==
X-Google-Smtp-Source: APXvYqywEdr3GDXpKYXn3jaD7UDrUfK2P+lk+zCn8syn9komMbv1/0ah3vGGcYbhDOo7fxZy1cwHrbfKHzvVEQ==
X-Received: by 2002:a63:4820:: with SMTP id v32mr4843115pga.89.1559746520255;
 Wed, 05 Jun 2019 07:55:20 -0700 (PDT)
Date:   Wed,  5 Jun 2019 07:55:10 -0700
In-Reply-To: <20190605145510.74527-1-edumazet@google.com>
Message-Id: <20190605145510.74527-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190605145510.74527-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v2 net-next 2/2] ipv6: tcp: send consistent flowlabel in
 TIME_WAIT state
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 1d13a96c74fc ("ipv6: tcp: fix flowlabel value in ACK
messages"), we stored in tw_flowlabel the flowlabel, in the
case ACK packets needed to be sent on behalf of a TIME_WAIT socket.

We can use the same field so that RST packets sent from
TIME_WAIT state also use a consistent flowlabel.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 net/ipv6/tcp_ipv6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4ccb06ea8ce32d614fc0848e1c4e74b441fa1f2c..f4e609a48e68442693936050c2336ca1e80e1710 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -982,6 +982,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk))
 			trace_tcp_send_reset(sk, skb);
+		if (sk->sk_state == TCP_TIME_WAIT)
+			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
 	} else {
 		if (net->ipv6.sysctl.flowlabel_reflect & 2)
 			label = ip6_flowlabel(ipv6h);
-- 
2.22.0.rc1.311.g5d7573a151-goog

