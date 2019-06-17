Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B8348999
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfFQREm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:04:42 -0400
Received: from mail-ot1-f74.google.com ([209.85.210.74]:43473 "EHLO
        mail-ot1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFQREm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:04:42 -0400
Received: by mail-ot1-f74.google.com with SMTP id w110so5169026otb.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PvuXpDexDxPOK/auQF0wWfSUrVmG9Xj+h27GpJM7Sy4=;
        b=p5s7QoBHhbmOEU0Sfoa60z30RPlpLUnxf1r3uhj7BvtzHRJa16yzK8ztXBMrvzpT9C
         QwgCbVTVeK8tKzII6Yd5bJMbZPZVvPvTLVx8UZmxc6o8LeY4GCyzge7yztVUR7ZqJQd1
         IFtBFu6w2DjCOjIXuTWAw9jjEQda42+KfJIsrMEGVBsb46oVV1j9Oh/3dzt+zx1UTshw
         eQOhfjdFdXjXe5eA+PvbfRFgqxPPXpJ9k7kGCJaZ85A6QZ7CZxcAEto3B2XsbD9Esfxg
         BaoFjym8DXI3e9HqguxdpAkTvwKEl1b9cpI9lRzWCD4xS5Q3NSeG5dZbozXDsnUjgrvw
         XnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PvuXpDexDxPOK/auQF0wWfSUrVmG9Xj+h27GpJM7Sy4=;
        b=VH7gD1qMw/6lUghbMA4nGY31RPL4hRyPDahhIGRf0RGZ1KequOU06Yw1RzzKkyjZHC
         Y35fRxRMcfUs23Fv8Jqje0m4L1000HX9wbO2ZZYzGA0zZp/kxrtRIS0fjKnuJODZCkrC
         W3wGOrGe4nJ11QsSPKydeaPJfmy781gvl+CuBBLnATyOb6n7eDudLWqp1xojqV9ajfUK
         x26l8kLH1NrX+rLvMx9kALQXRbaDmzZCohS38sQSHFGg1oDX1TiIazWYzdYh815+LvR4
         SxV/XppXEyAUcJwMWRSjtzxwq+YkgDiAnzB78AsnPEfxRW3Q4guiH9K/0QKfUbmrruyO
         p0jA==
X-Gm-Message-State: APjAAAXDDNuD4+uO/aUSpKANHaePzQeNjuJ0vcqjgEymEHhyXte+EIq2
        SmNpILu/rMypGT5vhIQlWYM5zIhmTgoqUg==
X-Google-Smtp-Source: APXvYqzjnCkcb0+fvWRAklbERaImcL+p8gDfyTNonXyRYf3nWm8e+PW/Zf9ObHGpfARU9FD5G1Xm1W3ZKwSmCA==
X-Received: by 2002:a9d:61c7:: with SMTP id h7mr2154746otk.357.1560791081576;
 Mon, 17 Jun 2019 10:04:41 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:03:54 -0700
In-Reply-To: <20190617170354.37770-1-edumazet@google.com>
Message-Id: <20190617170354.37770-5-edumazet@google.com>
Mime-Version: 1.0
References: <20190617170354.37770-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 4/4] tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If mtu probing is enabled tcp_mtu_probing() could very well end up
with a too small MSS.

Use the new sysctl tcp_min_snd_mss to make sure MSS search
is performed in an acceptable range.

CVE-2019-11479 -- tcp mss hardcoded to 48

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Bruce Curtis <brucec@netflix.com>
---
 net/ipv4/tcp_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 5bad937ce779ef8dca42a26dcbb5f1d60a571c73..c801cd37cc2a9c11f2dd4b9681137755e501a538 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -155,6 +155,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 		mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
 		mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
+		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
-- 
2.22.0.410.gd8fdbe21b5-goog

