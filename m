Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1E1C17C
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 06:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfENEmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 00:42:17 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:39892 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfENEmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 00:42:17 -0400
Received: by mail-it1-f194.google.com with SMTP id 9so2646132itf.4;
        Mon, 13 May 2019 21:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=OK+amOIyoJqoqKtJQ8fZgnv70LQ09z+QT/CtisP33vA=;
        b=CkJevJMHG3DdojgneEqgpSlVEXQ37TfODb/h8CqSiAEVrLOZPv8A3fw13LV+ZAtFSS
         JBOPiQUAnNnqgyTg5oWVpNThm6q8ul2ZsBHSg7tiiEnBF9F7JiOFVoDz+FJORULv+Kce
         ykPV57bD0R5OPnJtIDIG4T+KOs595ErbNfF39VCxnd88Fy72s6EGm6NB1zOZCt/pn2bp
         SFRIt2CryJJMAN6w4l6vuPUT2Jr4J1t2ErfUiYCm/lcxGFhC+n7N0TdhFHYTpvt0Kyk9
         NLO9naZF1/Z+PYyw1vNbq8XYTNoVgInGzmWmPT+hjHH9Zx+xIFJqUU5U+vBN3YcP6vlG
         7azA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=OK+amOIyoJqoqKtJQ8fZgnv70LQ09z+QT/CtisP33vA=;
        b=r6aaWx7Fv4mOrV62i4QmrXsUZjgD/DSSyADMUrwa3ZPpfVcy76uPZOm9dPXsRlZKbI
         XI/d75L3FBLLseFJd7BrSp2KHLBUKbKivCrV1jkNsRklcPBQqn4A+hB0Qo4UaFiDr5cv
         REMqa5Efnpf5VRT8rHkjJmA3TWPrZBndfLSUipEV6xpvVlMtkE+beFuamf17trTPXhaP
         BMcd3Lpl7PqWT3jGcxS6ey24KeQmx1ZUVQpXvupE7HUT60qW0c9l0u3YE6CgYvTtyqZm
         whmOPB/6udOvaSTIATY3WggRrlRA1+i7aWel6mp+tbsARsm/CHEGA4e5JcB6s8TMdfF+
         zozA==
X-Gm-Message-State: APjAAAUMYFpgMRwRrvPo6KX16pBa4r6yDpnkPtes661v+wroqQKdC0Hm
        iTM0Xj9DIvpcmCOaBMT7qmr9C+Kc/7Q=
X-Google-Smtp-Source: APXvYqw8jHakmSmdEon2t+dwXLuxZIJwyxhTyGr8bCIcsyfoXksr0nNZpu8ulFNNIAcokFlwCfeb+Q==
X-Received: by 2002:a02:37d7:: with SMTP id r206mr22245076jar.127.1557808936273;
        Mon, 13 May 2019 21:42:16 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g13sm5605818iom.46.2019.05.13.21.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 21:42:15 -0700 (PDT)
Subject: [bpf PATCH] net: tcp_bpf,
 correctly handle DONT_WAIT flags and timeo == 0
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 13 May 2019 21:42:03 -0700
Message-ID: <155780892372.10726.16677541867391282805.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_bpf_wait_data() routine needs to check timeo != 0 before
calling sk_wait_event() otherwise we may see unexpected stalls
on receiver.

Arika did all the leg work here I just formaatted, posted and ran
a few tests.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: Arika Chen <eaglesora@gmail.com>
Suggested-by: Arika Chen <eaglesora@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1bb7321a256d..27206b2064db 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -27,7 +27,10 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 			     int flags, long timeo, int *err)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int ret;
+	int ret = 0;
+
+	if (!timeo)
+		return ret;
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);

