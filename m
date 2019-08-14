Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7028CAA7
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 07:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfHNFcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 01:32:08 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45875 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfHNFcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 01:32:07 -0400
Received: by mail-oi1-f195.google.com with SMTP id m206so71239182oib.12
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 22:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=rLEmw0nAL2pXqAMUzCvVEHpZZJWNT3ynrIheggGh5IY=;
        b=OMSkxSnRXKGC5OicX05KCRK1u9pT7Mk35wydyuHcu+82gfOJiXj+ft4YFR2BS418dp
         E+oSLYADjfBcpNg5PSP1OPG0KsOGENOjtu9/bBKow3n9SjW0Ogn2pW8gchGh6+AdAAuw
         iOxGMZfoGPNj7UerQM1sz+SG3zdHfKZI+Cxx0G7LyUaOFCxMUaAR0VRnHw5QG1tUBu4u
         6Iy4mRN1pKuGMHG6wGBhdjTFNXsdaaIIx2ACJVAC5KSo1WdJAj46H3xheO5xoq+WwudD
         8aEcXTVhDzG+FkO7GZZY/D22F1iaGGCYqmLLN8Hr5H0WVQ+pq69S3XDx37zQFjGfA7Im
         NEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=rLEmw0nAL2pXqAMUzCvVEHpZZJWNT3ynrIheggGh5IY=;
        b=sS25Q96sHWNO/HtJjEDiqfIEy7lrnWGkQFUeNmP0TrulyVjfkT4BV0hCagPQghA3gA
         xb9PBcrvQKttuJsYL7zm9sb3XretTEmsth0FjI2vufJH5p+HabdatLPGvfKwiuQqoqCH
         VmwdecrUJGta3ydvOWBfD/dOx++UqRxzeNnFkhIyxYJg6wGRkgdFvALGwnCdfNJ/aeRr
         yv7EdUeaCPYCm39fYC8kDoBi7RAFaQP3ezGzbleBcxizNs3zDE8vlXbC1xxdeU3AkTTP
         ABU+RSq5HaLoedNzo/XLjS7dFd7nSvgzexgoFwG5wFj2nj8IYJNoMixrWyZixgnl1Fu6
         CLtA==
X-Gm-Message-State: APjAAAVykg8FifAloaURdnIc67DthcR2TzRiWSAEOCwRflWcG2RMjgAY
        hluf9Dz/QMLIurN0F/77l0Y=
X-Google-Smtp-Source: APXvYqyk9LsSpzDnEqKkVlc7O4J7D1YVNM8ZUB7IX0uoKBu+N1DR2bQhHmMwF/UCDeZRDUqsMlyWXQ==
X-Received: by 2002:a02:c487:: with SMTP id t7mr1492533jam.99.1565760727079;
        Tue, 13 Aug 2019 22:32:07 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i4sm134396625iog.31.2019.08.13.22.32.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 22:32:06 -0700 (PDT)
Subject: [net PATCH] net: tls, fix sk_write_space NULL write when tx disabled
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     ying.xue@windriver.com, netdev@vger.kernel.org,
        john.fastabend@gmail.com, andreyknvl@google.com
Date:   Wed, 14 Aug 2019 05:31:54 +0000
Message-ID: <156576071416.1402.5907777786031481705.stgit@ubuntu3-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ctx->sk_write_space pointer is only set when TLS tx mode is enabled.
When running without TX mode its a null pointer but we still set the
sk sk_write_space pointer on close().

Fix the close path to only overwrite sk->sk_write_space when the current
pointer is to the tls_write_space function indicating the tls module should
clean it up properly as well.

Reported-by: Hillf Danton <hdanton@sina.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Fixes: 57c722e932cfb ("net/tls: swap sk_write_space on close")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ce6ef56a65ef..43252a801c3f 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -308,7 +308,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (free_ctx)
 		icsk->icsk_ulp_data = NULL;
 	sk->sk_prot = ctx->sk_proto;
-	sk->sk_write_space = ctx->sk_write_space;
+	if (sk->sk_write_space == tls_write_space)
+		sk->sk_write_space = ctx->sk_write_space;
 	write_unlock_bh(&sk->sk_callback_lock);
 	release_sock(sk);
 	if (ctx->tx_conf == TLS_SW)

