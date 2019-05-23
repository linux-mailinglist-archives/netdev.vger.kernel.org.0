Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4171028C1B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbfEWVJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:09:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33076 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731564AbfEWVJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:09:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so3781396pgv.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0l7QFOq9rpOhcfdcebxs2xSgloj45bF1H4poSZVVNXU=;
        b=bw3P3xpxEOK9DYDEdoiW/viHc52zWXncC8sgrc8cjiSsjfmj00b3B7D5zPiZG8SPA2
         fw15EXzxrEqygF6v0gmsVD37IwEnqRrcrFVp2AkvIRLfWYN35RMb7TvLORt6zQNZohId
         swupTnCebcrc1tjx8+il9dv7vNmMDM/TubQ9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0l7QFOq9rpOhcfdcebxs2xSgloj45bF1H4poSZVVNXU=;
        b=FVD/mZ1uRG0GeE3tFI1OdUUirAYPwfj2bP9y2thCgr+DWkkeDf+qks6GVueojhDAXS
         Kh7HV6mWGOBEyoq9J9cOyR982LCGdwV6qQMWMClK6iYkJLmxjpsrqZEgQDL7DZXKbL6V
         RgguV1IXicTAZhWIilFnhZJv1sEKfV73CZbZLsJbutcM2AqjmPh1uZ7Q/Q681AB8DvuZ
         xqZ82vyMjVYDMn8HDPU0MWDR4iGDhOMsuvAWcaN3cEf8w58d3LMNj7IANEAd/YjCdY9X
         mLLD1A/++sy2JtSt2mwtkjjI014hRxQKYIEZcuTeB+7i+2YxN9MYUZ9z/hT9ar9Sm5be
         vmXg==
X-Gm-Message-State: APjAAAX+D4cTmR0PYycjd606E83f6xGCqOgSnsQ3VQD9HlcBcGgaYPKO
        Yezo6axdhN5aCzULMhsBfsvEzF8aGDQw015z
X-Google-Smtp-Source: APXvYqwfdDfCd2q6qUNP/3/3toCKsl47hLQN2VPf2IAiYwQ3P+CC8YPLYtDyHmeV6TnMDqkJNcnwDw==
X-Received: by 2002:a17:90a:718c:: with SMTP id i12mr4337153pjk.32.1558645744988;
        Thu, 23 May 2019 14:09:04 -0700 (PDT)
Received: from localhost.localdomain (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.googlemail.com with ESMTPSA id y17sm333481pfn.79.2019.05.23.14.09.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:09:04 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
Date:   Thu, 23 May 2019 14:06:48 -0700
Message-Id: <20190523210651.80902-2-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523210651.80902-1-fklassen@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes an issue where TX Timestamps are not arriving on the error queue
when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
This can be illustrated with an updated updgso_bench_tx program which
includes the '-T' option to test for this condition.

    ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
    poll timeout
    udp tx:      0 MB/s        1 calls/s      1 msg/s

The "poll timeout" message above indicates that TX timestamp never
arrived.

It also appears that other TX CMSG types cause similar issues, for
example trying to set SOL_IP/IP_TOS.

    ./udpgso_bench_tx -4ucPv -S 1472 -q 182 -l2 -D 172.16.120.18
    poll timeout
    udp tx:      0 MB/s        1 calls/s      1 msg/s

This patch preserves tx_flags for the first UDP GSO segment. This
mirrors the stack's behaviour for IPv4 fragments.

Fixes: ee80d1ebe5ba ("udp: add udp gso")
Signed-off-by: Fred Klassen <fklassen@appneta.com>
---
 net/ipv4/udp_offload.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 065334b41d57..33de347695ae 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -228,6 +228,10 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	seg = segs;
 	uh = udp_hdr(seg);
 
+	/* preserve TX timestamp and zero-copy info for first segment */
+	skb_shinfo(seg)->tskey = skb_shinfo(gso_skb)->tskey;
+	skb_shinfo(seg)->tx_flags = skb_shinfo(gso_skb)->tx_flags;
+
 	/* compute checksum adjustment based on old length versus new */
 	newlen = htons(sizeof(*uh) + mss);
 	check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
-- 
2.11.0

