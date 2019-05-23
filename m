Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8C728C1E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbfEWVJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:09:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39165 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388177AbfEWVJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:09:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so3230831plm.6
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dWxjjBa0A/xAHkZKZESed79idk/kmC17ydpMN9al/rY=;
        b=rSYSKuL+X6Y4Ew4dkJ9qfTYMNXnuw3BGGEHULcUuCD4WE0GsLI8bMZS2qjaPzqpFXp
         A23xzPsJyAekIe9tRGvZQS4ZcPXtF8BGzzKRsoVvZg0eGB34QTZZnm6QHTA66ObhXsKB
         CC/tX101GPkGRdIUC8eWD+9cdlNUQPVOt7cT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dWxjjBa0A/xAHkZKZESed79idk/kmC17ydpMN9al/rY=;
        b=glVixywuUUyATVTB+VWR8Z2ExO49MwbmjY5qcvAKkSTFTLqN0VUD+PF8tq0JCPj2q5
         6GJkXuAYD9+G8LCqLgIR0rk1t/FF31hU5uPKdFpe698+T/5rIPfIsOjX8Eg2Ed2lImbr
         +NyxlvYctMbruqLzmbDr99wB5xyHbohVHh5UFZwoHfQwOWXhEp9/iS7tArc7h7yZEsqQ
         M2uAXHFiYrhfjh3x2vgHSAQv6eVwJEqDB6t67mJ7t9D4vdBxqBeSu1zfl0kSqNa6M8ci
         e46toMoe0z7TaXkHbKJOsn+V/GHpNPwb0NKDfYqhEJDeak2OP4mcaXPszKJan5Fz1CSk
         TM/g==
X-Gm-Message-State: APjAAAU5K60j8f6HduTJOA+XAEAH9DWFTFZQY3N9oxHflPTzI6rfppFj
        fI8pCriYz07uyfltisSQNjqsgA==
X-Google-Smtp-Source: APXvYqwuKL1lL2awDPJqSwiPV3yM/nA6OmuBTiRvg2vfkb3p8daEtzhahL+pk752VQkrxbWF7sbVsg==
X-Received: by 2002:a17:902:f24:: with SMTP id 33mr100197673ply.33.1558645752680;
        Thu, 23 May 2019 14:09:12 -0700 (PDT)
Received: from localhost.localdomain (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.googlemail.com with ESMTPSA id y17sm333481pfn.79.2019.05.23.14.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:09:12 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net 3/4] net/udpgso_bench_tx: fix sendmmsg on unconnected socket
Date:   Thu, 23 May 2019 14:06:50 -0700
Message-Id: <20190523210651.80902-4-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523210651.80902-1-fklassen@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following error if using both -m and -u options:

    # ./udpgso_bench -4um -D 172.16.120.189
    ./udpgso_bench: sendmmsg: Destination address required

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Fred Klassen <fklassen@appneta.com>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index a900f016b9e7..56e0d890b066 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -378,6 +378,8 @@ static int send_udp_sendmmsg(int fd, char *data)
 
 		mmsgs[i].msg_hdr.msg_iov = iov + i;
 		mmsgs[i].msg_hdr.msg_iovlen = 1;
+		mmsgs[i].msg_hdr.msg_name = (void *)&cfg_dst_addr;
+		mmsgs[i].msg_hdr.msg_namelen = cfg_alen;
 		if (msg_controllen) {
 			mmsgs[i].msg_hdr.msg_control = control;
 			mmsgs[i].msg_hdr.msg_controllen = msg_controllen;
-- 
2.11.0

