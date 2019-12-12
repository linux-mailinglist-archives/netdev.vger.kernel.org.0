Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CED11D9BD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 00:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbfLLW7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:59:35 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43229 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731036AbfLLW7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:59:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id h14so204365pfe.10
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sMBnAEeraSfPGQP+C7503fB1T0zEbsk9vYFpO8TVdhQ=;
        b=HsEWSY7HbTxWBEiEKd93O9lcCuv1z5uv7YAf2HtbrJU411G/lrWDiFqJDC4/N1UZYN
         NLFxCpyzxfT6jBeUqRvA4aZCpw/8eZVD0byZap7lAbi20YrqmGjVjsjqcJwLN+6tYvLF
         Gu/mUsLnbvY7YVFVWN5ePtGz2kUuVh+GHOpnr1MFxh2ZjVh/zzo4HjBr8ZmXs0WKh7ce
         0JEAeVl65up/GuTninYNaHrT8eOu/CGQTyTV4Kx0I0jZRWQls6SlPySviZP1N9i7pBs1
         i+Uu0kZBrr0oH7hq9LPCfn75+5S+y0GZA6mC0nRmGsdFf2UZh+gH/PboyWdfDaQdvZFR
         r9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sMBnAEeraSfPGQP+C7503fB1T0zEbsk9vYFpO8TVdhQ=;
        b=ex+tdy0EzpmBjMK06tplQ+1a1hnLEh0vn5F4xkv/WoQ4NtQR4vCrzkfViU9xkHvlXf
         M4TMSY45UFviXXLM7/TZusubwZy+9A+pu4ufC7RUCIbmvqUfqvdhWIsP5DRfYE/4zatB
         jFrRAnMFaKOexfkz0f1STwF/UZAKkw65pEDGJo0yLCRgG0YhHQ8q7++vEVqPhuRD8R8e
         fyiSc56s9EhfIkmkxFgl69GsvdvHshel8ZprCWzwyJcgaKLVnjVb8zAolFB3skC/s2TC
         sjYPMqXBJEuvsZCgY7NKzFdFCwVsfc/2z+HWbGqfHIh0hFX/potnbWETRnKBQMJZu2bp
         z5rg==
X-Gm-Message-State: APjAAAVxIMhkKGCJtfujXrPmGkl4d7h1uYQdT7esvviSfl+ITolycxPE
        5Xv5Pn15lPcsW/2xe88oFcY=
X-Google-Smtp-Source: APXvYqwhGBXebvLX+5ieGdJGTvT4PQekPJrtA9tJ6ADFWQP8fR9VDv9nUEaW3VgJ9OGUg7uAwc+LbA==
X-Received: by 2002:a63:2355:: with SMTP id u21mr13136613pgm.179.1576191574329;
        Thu, 12 Dec 2019 14:59:34 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id i24sm8650180pfo.83.2019.12.12.14.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 14:59:33 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com,
        Arjun Roy <arjunroy.kdev@gmail.com>
Subject: [PATCH net-next] tcp: Set rcv zerocopy hint correctly if skb last frag is < PAGE_SIZE.
Date:   Thu, 12 Dec 2019 14:59:30 -0800
Message-Id: <20191212225930.233745-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, if the last frag of paged data in a skb has < PAGE_SIZE
data, we compute the recv_skip_hint as being equal to the size of that
frag and the entire next skb.

Instead, just return the runt frag size as the hint.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>

---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 34490d972758..b9623d896469 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1904,6 +1904,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
 			if (skb) {
+				if (zc->recv_skip_hint > 0)
+					break;
 				skb = skb->next;
 				offset = seq - TCP_SKB_CB(skb)->seq;
 			} else {
-- 
2.24.1.735.g03f4e72817-goog

