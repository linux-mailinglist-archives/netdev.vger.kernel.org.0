Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF226B27F2
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjCIOyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjCIOxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:53:43 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F71CF2FA0
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:51:20 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-17638494edbso2510632fac.10
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373479;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzm/x7TOjLOgi7CwKs4YCZ1LBGnvx2xB9lo0ysTnYvA=;
        b=H4PVIGDTl6WnZIPkjc+EFidMIA/6sgQ8MLWYqnDcXuN8hA6Qfw54b0x9GKQmCs98R6
         OVI2quuA1TxFEl6utPmQQ41Xik06vszzJ4jDmqkCQyWducURrSp6FHKyJ+d8aCBeDD7e
         WFnRNbfgRhHTpDKtFmaeMOF64z4wjvyfYKXFuvMBHnT+X//VITbr8y0e65CEvs1u4cbV
         Vae9aasikEPye6Moacpey80/g3Z1PmWsL4kjOjmt54pD5HewSgVMFDphEBt26OCG71Bp
         5lKP4wnu6U6vj/ghMghMU0qvCuhwhRh+rJX3TRGGntswCK7rdtsFc8r1QaxMgzmMGe2m
         CPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373479;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzm/x7TOjLOgi7CwKs4YCZ1LBGnvx2xB9lo0ysTnYvA=;
        b=Zi2IVufn0mipAcsN7tyeWd03B7dPevF34df1SD2aTXDXd6KE3vbpRILtA8GCJCr5g3
         0Oc2ifQ3y4hYcmoMDYVWFiHvKN2cOxR1NPzqkUTDe3rPvOJ+E4VvSlF1zBf1GBsNAbP/
         oIyAr+KJ5ExxR5oQvwo/AXzZB5l2GIaKug1zxBFIdWDu5aqvQDUSVlAnWQZUrGf8HDL8
         wATI9v8mTdY2x0hjklUCTYlLkwLA/EJfZMrgD8dEGhIXX+dQN9WMnOthf4mrfPNFCUOF
         xmE5WUciWmwrofOxIlDrUXkuvlwqqcbJ1TArB/qc8J+OJ/gZ8dQp7PEYL3EL0SOZJIbZ
         9q0w==
X-Gm-Message-State: AO0yUKWBwy8eUqQOW2X/DvEvTaszdw3LsDjgcTsVUz80B10c16RsqHro
        MTJvcWDiC7ZaQvHHT2dftYqaYA==
X-Google-Smtp-Source: AK7set9GO0zxZyi7mefBy78H7fTBv+s+weKltD5HfFkitvia0cbS4wrAj2uYkuZMQfIaQ5I5Z1fUeQ==
X-Received: by 2002:a05:6871:285:b0:172:45ff:6293 with SMTP id i5-20020a056871028500b0017245ff6293mr13952175oae.26.1678373478812;
        Thu, 09 Mar 2023 06:51:18 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:51:18 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Mar 2023 15:50:03 +0100
Subject: [PATCH net v2 7/8] mptcp: avoid setting TCP_CLOSE state twice
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-7-47c2e95eada9@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <martineau@kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=963;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=YhQrvwLHpqWFuACAI0OELxustQ1PVT1SBUl80EUsJ68=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhVzi8yguOmSTvdyb8Fy2uvF6oIcbmQZxef
 8MjZTpDu0OJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 cxQSEAC4h1EXetyTEuncZ+ZrvfqSoNohT6csTHKoNAOLWuSclc59xfJaNgQIAwPM7xwuUWM7W2U
 exMVLsI/GsR40waIDVGGUMRg5xCaLmv7KbImOzKLMLkKmRrWMxh91KMu40MCX28+AciHyVE0wfy
 hechXKwj8Y7kKHbbXUci4IzgwKQB0yHzMbBokX5cgdUdtsnLR2S5PPA3Vf8Aab9YuKYoUZG+aEz
 hxvIRyHAhH3sxN5tFr7+ulbbV6dCHORkjvVEpl2D4WYfNcmDnDzOdSFE4TgylW9TSed+5rSn+na
 SVZFWh1RG35f2lY4WMBxUC2RcEdtvchCEtyAh/ap2a083hgL+1mbzpcWBh5osPhXDXbhmWlcrIp
 BJaNNIANTekYvltIiNBs3hKyb0uefUG004sa7HZ0hSB+GZ8eEOp+NAYciFhicjK2sGRIb0Pp4ZE
 XG9laaTdW56tm/lh1jYVKY6clGMg7AfRcOpfZmfaa44esDWF1F4/4oCp2608iWNZEjo3a5I6yfk
 LvaforUNuJR5142U+zVtKkwc8X3xKzYwUn+JfNHCgem/AZn8JoMN0+yk6MkYWQ0sX6Vx6Z8sloO
 qb0+x87j//OOxFenXNscRCMYVBH0iGpDvu5pu7UQdpIxGtNNOAjwCyu0oq77pTlmOhBNWKJy42M
 WHNWz+uJ35COdTw==
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
index 2aadc8733369..a0041360ee9d 100644
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
2.39.2

