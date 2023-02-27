Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4506A47F6
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjB0RaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjB0RaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:21 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AB923D85
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v16so4253957wrn.0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=deRiawW7JdNy0QaIv3Yy/aPFkC3toFzqqvaPGWyei48=;
        b=6Pk5Pum7YSnsna2htNtZ4tY+1XBtoXGAfekKOkX/jGa7ar2SGAS6DoDav+oex+/Hz1
         eHedgZLDdIFpfJD9rNYGpKydSdjkYoQvsfxJlhDTJpElH3QNraf5N8QL+0NBlg/SIMUy
         pcBe4q3e5VQpcx3L8IL2BJdcffJJ39mZdmG5JZ3qWGTIYvWntw8vjwfRyJKR+pvlGH52
         5gpD/3yBQkxMpxI6/679DC0mZ7Kkc4IR1vG0gLocmBaohYQGBxGMJANctFk2HQbX3pwc
         QllXXfbbwnDeWITQ01EKy1B31Vi1JV9QfwGahyZncUUyKIr/v3cJhrmJpTYiBVOKIS9v
         YoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=deRiawW7JdNy0QaIv3Yy/aPFkC3toFzqqvaPGWyei48=;
        b=kdocecBnB4WHuGCQGbIhAyhB7utDWNcbmOFkTC9O+mMVxWADxnH3Hf+CMfw+5/G1NE
         cM/RMBwC5PEl+eL6OQx9ROLTO9RxE2DYlK5RqhWzbC3fIsdMMrGzjaTucda4jwpbRC7w
         vMDPFMRUAprU6YHdSoaBiF/hZpn1DF/DqEPx9ortx6P9jvpbdsap79hjQOlSgVO9aVUR
         L+Pcjoj6xHW1zijTSX65IyO6lhMC1ypAReRb/n51E6U3nVwhQHRyTRsEMJXAHh42gFkr
         SEfGhtHnMMb10nketRdZgW73sD25MLJshaCQv6NTyrkL3KGZZ2QurZuo9hFLRQvYnLSx
         Gurw==
X-Gm-Message-State: AO0yUKVt1Gq1s2lS0AFi3OvvlNhr9AEsexBNpr/Qm8TlfDMTyeCT4jxw
        4Pq0SpLybejQSjXgBYgPmzlwfA==
X-Google-Smtp-Source: AK7set8/XDombvwT5MsIh/G8JzGbdq8e5xfVCkBm6t112lsnOD03lHNvPYejla3hWvZROcw51RCHdQ==
X-Received: by 2002:a5d:52d2:0:b0:2ca:8ae5:ea6 with SMTP id r18-20020a5d52d2000000b002ca8ae50ea6mr4965384wrv.44.1677519003021;
        Mon, 27 Feb 2023 09:30:03 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:30:02 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:30 +0100
Subject: [PATCH net 7/7] mptcp: avoid setting TCP_CLOSE state twice
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-7-070e30ae4a8e@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=963;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=ZQAflEk+Pt3pdyX3H49VKj6DNfbIjbdl8OwWNGZf1oo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiSKcNbYspP4is6sagaj4lgSe0AAKke2eBo6
 b0pUvD32P2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokgAKCRD2t4JPQmmg
 c+fQEADo3jnVu0BRlzREUet2ygwyPhNLWvDv5KQ6kMiT0FqqEzpgZEMzhRU5Pi+6JHGMIK01hRh
 RNdXmRQ9kGBwlTmPWhjt2lYivyVJcR3BJY59q6HRnAkCp887qyf/fcUziyaIVXU3HmHWWjr0dGT
 eSjDAOVfa2Tl9PvUhfpor3rC03ayatTiKZrLNbuUpJKkBET4BKWd+OdgA7Le/Nnhz5nZQPAe3Y/
 5O84AUf4w3LKOsSzTeyJ0Yd+s8z0wcAXp5l2S47H7kI/F1BHxKNn+flQSu/yCVjiSb0MEv3dYBO
 cWSG1CFdNiUVrZEsUWHboLw9Ypk67HcAKzOaL7srmEGBzpD7u2sQJw0fuhEViLvjx2WFyxL7jGi
 2PgpvOn3B8F7tA7vKEt8Qap+pjebxrgM/w/gV0uA4XrpFmQQehP5ySO/2s+dKyqHoWaNrRK9HrP
 oVCyRbgOYijYjTsCVHB7SK90jKBamk+bdSbS5JHoNnRZPo0J8fOoP7ElkdrGjuMajjwrnTPxHze
 O6Zc37mBVdeTz2TV7Y9mT47mWrsnanyn7egrdfmtuBLWuDliSC217cBuYZ3Q6ci/NJFCLWQVmrQ
 5new4VkeIto0Y1u85+6Akcs30TfEsmwRC5H/tfDjWNI56eAy6Pe+y/bwk0dQj2NspYxsrl4BPML
 iUOtjUnOdSsJSrw==
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

tcp_set_state() is called from tcp_done() already.

There is then no need to first set the state to TCP_CLOSE, then call
tcp_done().

Fixes: d582484726c4 ("mptcp: fix fallback for MP_JOIN subflows")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/362
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index f6b4511b09b0..b865ba911bc4 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -406,7 +406,6 @@ void mptcp_subflow_reset(struct sock *ssk)
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
-	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&

-- 
2.38.1

