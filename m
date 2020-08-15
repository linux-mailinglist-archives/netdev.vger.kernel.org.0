Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B645245393
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgHOWDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgHOVvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B204C0A3BFD;
        Sat, 15 Aug 2020 09:53:45 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l64so11223604qkb.8;
        Sat, 15 Aug 2020 09:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ub/tWuszopXYAR+w2VtlhPZQPDBBIzMElKorytVXus=;
        b=F6YWSSf7ggwCowXQ1pd+nByIQIoaDBJq8wmld8OTn1b0OwpPdw/vTQmPQoILja/Na+
         QZfF1yT/nart6fUcoBXIHXUnKgZsLcBMemdzihu7vI1yb6Uqw3zuQEb7R9Q7/Aa6+LLs
         YWcC+SpeSjV6uXgisIzu+SBAr8RVJGP0kg5cT5XexUTaqEN0Pi5dH65WtO6kzFGX6jRM
         ldC16Xl1ehtvRIXd8uOK7yZwA9vfju93tbZ+Ij8crVERvYCIBzV+YIG4pWrBTxJFyB7G
         vl6l4sstS693sCPt58cQi8cNvQK3hrExnRKBIYrNXvjjm1oZKCGRGbSPf5UMx8051TKP
         yicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Ub/tWuszopXYAR+w2VtlhPZQPDBBIzMElKorytVXus=;
        b=eCRB/JF2XKjbK0sLrh3ZDjmBpzKSPXaLWPww/UZcHiQeCftWOE7Sd+ll2bnPxltpUE
         oDTc3PM5hl42cwe4tTBi8LWuUu7m9exbPs+vhK1UvK0axrgaProg/i5MdugPTzdLZuNh
         BxQK7ttaeEsbgwNb+8H5IuoipZlikiGr477BXaolJRhRBpHs9g+5TDYRhFehASHicbyn
         2GMNU23gLTMOxcmUFtw9ZnsdP6CglHn4K8Jfo7TBCgu69gaPfNqc5v5tDuG9xrIInK+i
         YPvGUgQUp7lHYSgvWRgTa9TGSLP9LyJQ31WazEtD1PdzqtW3c1gGor3jnXVzheg4SV7L
         xGsQ==
X-Gm-Message-State: AOAM530ABhVV8EE1ihP83ANTwyz+shFc8ZVjQLpSt4+wTHGkqYgotF/2
        i8LxR9umY0POiT1Q1/nQXkY=
X-Google-Smtp-Source: ABdhPJyzw4iNpkx4ZgbYXyAK6WaxOyCQVQCZzeS/SRwW4PrZjNcFqYJDKFW3ljP6kcdjVRDaqVpptA==
X-Received: by 2002:a37:8301:: with SMTP id f1mr6555671qkd.86.1597510424332;
        Sat, 15 Aug 2020 09:53:44 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c100:b9d:4032:a79a:238d:9f7a])
        by smtp.googlemail.com with ESMTPSA id b37sm14584866qtk.85.2020.08.15.09.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 09:53:43 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] netfilter: nf_conntrack_sip: fix parsing error
Date:   Sat, 15 Aug 2020 12:50:30 -0400
Message-Id: <20200815165030.5849-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ct_sip_parse_numerical_param can only return 0 or 1, but the caller is
checking parsing error using < 0

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index b83dc9bf0a5d..08873694120a 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1269,7 +1269,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 
 	if (ct_sip_parse_numerical_param(ct, *dptr,
 					 matchoff + matchlen, *datalen,
-					 "expires=", NULL, NULL, &expires) < 0) {
+					 "expires=", NULL, NULL, &expires) == 0) {
 		nf_ct_helper_log(skb, ct, "cannot parse expires");
 		return NF_DROP;
 	}
@@ -1375,7 +1375,7 @@ static int process_register_response(struct sk_buff *skb, unsigned int protoff,
 						   matchoff + matchlen,
 						   *datalen, "expires=",
 						   NULL, NULL, &c_expires);
-		if (ret < 0) {
+		if (ret == 0) {
 			nf_ct_helper_log(skb, ct, "cannot parse expires");
 			return NF_DROP;
 		}
-- 
2.25.1

