Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1EC6DE5E5
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjDKUmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDKUmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:42:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2E75257
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:42:28 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l26-20020a05600c1d1a00b003edd24054e0so6773740wms.4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681245746;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJSkDzvHDv+IldvOKYCUeGWLBa1YxITsKTNgz5UKiD4=;
        b=0yNawdYCXfHfH1a2o5KD4daFIw5hxojs6Vivsduai6u32Icbn0QMEKlF5qVaEZydDS
         ZTi9tokkuRtihm1pcqaeBvUBvBhvYDEm/l2HgI7DYHn5HZyqah9ur1KYEiAJrVRHsdat
         qRpEIWdvc3CC2VJ/LyrPBmaKibCPdsCFRYIz7fxF1COXjWcgpaSbP/+1pUZpcdtmCfsI
         j6Q2FG2UXt77b61OSneGev8C9QKvzefw+IAMTDuoTWa431wBo/XBJuh4VkkpXAd+hjFn
         +nZAPNILDcvS/6x24zbu+Hc+1/r3wQ78p5c+9llT4dXddUY9oAOq0WtF+cdbZfagIt4v
         wheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681245746;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJSkDzvHDv+IldvOKYCUeGWLBa1YxITsKTNgz5UKiD4=;
        b=nmsqhR+SF30RQjIyRucRUzcKMx4fLmLhRlmfAKfMkQjpDrC/DBl26b9TWjVKVCBKSh
         5vPv22N25h35JbjMTdzg2q+azm0pEI3qEflkgSxVr9Fn7ruNxeR+sSNUUPv2wbv4yjt4
         iDTPHuoY6IJGhqf9UMrVb/Ebs6xO1mi2ftooZoUqW7y1Zs6+i094he7mWbps/kZbtTfj
         ZsZEpA+koM1xjirlXKccSzI0XKGejz8Eem748ILXviO2OV+oSkd2vAsnQ6vPLz0sMwLK
         s+/Z5JAFadvvmy83+B4n3C8ixUG/mgoc3t/C5k8riy/LEN4e4+2+GyiElncDjJAEl8Nn
         jccA==
X-Gm-Message-State: AAQBX9eZIQz79SQFjHC0iFA7h3c8cOC1CQYEyL8Tq5FtQYiHZ4vXsmVp
        LT8MplTkPkNHl8RDTeBhHaoMBA==
X-Google-Smtp-Source: AKy350aIa6jYhKVLXpHR/Nd/AgNCfOHPkHJFHkAnJcVDq7eVZ/9K1b7yxtV82ST3VPC1yLZBlohU/g==
X-Received: by 2002:a05:600c:1e25:b0:3ed:24f7:2b48 with SMTP id ay37-20020a05600c1e2500b003ed24f72b48mr279773wmb.8.1681245746479;
        Tue, 11 Apr 2023 13:42:26 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003f0824e8c92sm86887wmc.7.2023.04.11.13.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:42:26 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 11 Apr 2023 22:42:11 +0200
Subject: [PATCH net 3/4] mptcp: fix NULL pointer dereference on fastopen
 early fallback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230411-upstream-net-20230411-mptcp-fixes-v1-3-ca540f3ef986@tessares.net>
References: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
In-Reply-To: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Dmytro Shytyi <dmytro@shytyi.net>,
        Shuah Khan <shuah@kernel.org>,
        Mat Martineau <martineau@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1313;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=M0lbg2vrKXi+X9w75ix6Wwp/oOxfY96lIrVHUJdPEwE=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkNcYuUYRtIKl0zwJ/mKGDzxR9gRBkAHRRLlrq4
 oIYSLoVXneJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDXGLgAKCRD2t4JPQmmg
 c2/hEACJPabxn8n8GOLIdaDIhZa3hSUPMXr+LVjq3jLWwu2tFeLrppZQpoNO50UqV5Lui8cDLjw
 JH1Y6vIxKp1Bptqd194v+luCJ3HvCC+oshWSCDjfRD1nHSNE41BMe52hiFk+a1RBfiUhxwA6MLb
 QMy/EDQMJYJyJrJnGsH3tOBHN8oQFXlfqj1Oe++zYK3joDZFIgJRJq1UNUIfsrBA/LQsb28KPe3
 UhSL/xflT3pdVZzzAG1R0jhLAIjOf/MpD82d3rmQLaz1AAB/1sCqSQRgjQFEPKjYPHXLrjO4Ud0
 ks7j9FOefboDIUG1zEe6xOJuGPHUV9vHDL1DTXkSHLKzgrBOryPELBNfMauvzlEcAUr5HJJsXEL
 l0IWbret5sg+uWszLZth+6nv8XU5MOkmA1HRaQcbFdg6Ni+KVe7XFuroxMeU9vd+y9H6OqlnEep
 zWi12vS5L+5zvmPZlfkIBwOBH3y13xIqa68AL/3SasDxeG5sncUZLI2tSFu6l2Hgxsh7yj6Kg2z
 vc55pl0aIjoRU9Lv0a1e79/y309ZUK6iHwaUtj6wHNgrI58IP/3PjXvVyIaUvwcTnUJ8osQp+AW
 07Qdpdn1CQhNnhhAPQeTCfShcCvBISudqowh+fQBf7tInGC0v7sACxSfqxyD6U6V2+au0tFkE3w
 KHw2vyIrQNnmdBg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

In case of early fallback to TCP, subflow_syn_recv_sock() deletes
the subflow context before returning the newly allocated sock to
the caller.

The fastopen path does not cope with the above unconditionally
dereferencing the subflow context.

Fixes: 36b122baf6a8 ("mptcp: add subflow_v(4,6)_send_synack()")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/fastopen.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/fastopen.c b/net/mptcp/fastopen.c
index d237d142171c..bceaab8dd8e4 100644
--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -9,11 +9,18 @@
 void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subflow,
 					      struct request_sock *req)
 {
-	struct sock *ssk = subflow->tcp_sock;
-	struct sock *sk = subflow->conn;
+	struct sock *sk, *ssk;
 	struct sk_buff *skb;
 	struct tcp_sock *tp;
 
+	/* on early fallback the subflow context is deleted by
+	 * subflow_syn_recv_sock()
+	 */
+	if (!subflow)
+		return;
+
+	ssk = subflow->tcp_sock;
+	sk = subflow->conn;
 	tp = tcp_sk(ssk);
 
 	subflow->is_mptfo = 1;

-- 
2.39.2

