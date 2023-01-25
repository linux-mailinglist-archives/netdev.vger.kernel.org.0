Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9267B036
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbjAYKsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbjAYKsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:48:38 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA1356ECA
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:09 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso961280wmq.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iwuYRtkt97pXgnGKWsmcpjqW50hTCzYJA93KmtVKokc=;
        b=HlBx+O22XMPaRLdCY8bRkkNnoQJ3DAxxgJTt7+b3L5EnG+s9hHIj24S3udDB+1KfW7
         HZ0hL+LUIfBGb1uKFmNhFDiNCII356m1bfIK6t0E2xQznWe0FEXZIx8dgzuwgEZeMOwF
         /hcSGndz1WVTXeHHHppYGMiA21hiCtFhh8urKHlrj/vPURK/VCRSWGO6sN8J/tG2V6Xm
         mFBS/amTW0N87ynwbWdMtAZPzV0N8GTJy5hwEMNd8fUSAmzHuliy7L+dbWamv14dzCc3
         Qkehd+7bhHzWXbkT41nYaeVpbt77GgCDR3zVmcqLTLDoGPfdVietxdIm/74TVc1hkFST
         l5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwuYRtkt97pXgnGKWsmcpjqW50hTCzYJA93KmtVKokc=;
        b=GT6BqnKDJgOVGVgTG3t2LaPJX2umMPKg9p32Aul+I6Hg6T23DWSnqtFkNedr+vR61e
         7Cczq17b/pcGhRaH7yrJlRrkVaE1h5Bix4enl93zxO8A46iVbUyd1HC1un4+8j7ZzN6N
         ZPL1cfMbbml6Gt/b5/u7YSLOS0S5uI40S9z+Bp2vSDHKf0eQMTYaPjXFwDrpw2kAd12d
         GZv5ap64VvE7gdsAJ/MD3npDIrrwFKYCyjUv0oHjQvW7E+XahhxzHGNbhHbEzsDKx1kJ
         GEhMvrBXinc3dXMSA/BwiNnj0oi4fwBz2vnrY7lzE2alGOq6VFWasWQ/vVGLmpT/sMmn
         T6MQ==
X-Gm-Message-State: AFqh2koLfFVtJcd3oqtf4sCRVgCXY7VD9pw1fDN8aLPxTU+WfP2yPcjT
        FCrecVcceKNY0Oi9OM5gM0Tfmw==
X-Google-Smtp-Source: AMrXdXu1N0sNPouw7E9jGQXXTooMoM8qqp8aPt8Kz6TIc+lbChljM7ALrlyaIpvd2IlXeB30KE+ILQ==
X-Received: by 2002:a05:600c:1d89:b0:3d9:f37e:2acb with SMTP id p9-20020a05600c1d8900b003d9f37e2acbmr28251589wms.20.1674643681186;
        Wed, 25 Jan 2023 02:48:01 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c424100b003d9a86a13bfsm1423692wmm.28.2023.01.25.02.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:48:00 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 25 Jan 2023 11:47:22 +0100
Subject: [PATCH net-next 2/8] mptcp: propagate sk_ipv6only to subflows
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230123-upstream-net-next-pm-v4-v6-v1-2-43fac502bfbf@tessares.net>
References: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
In-Reply-To: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.12.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=934;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=iniaX7WemA+f5FmXFhQpwMPskZ2OOjDI5WzLlog0AB0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj0QjdHh80nGr6vqKKMF2Ns21cQ6F9LNF4+fGARnIu
 So5WZVaJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY9EI3QAKCRD2t4JPQmmgc3bzEA
 CmmmRHlTlgzud6oeE9klZQXjAG/8elx0t/GIPA7wHH2EQK004iT1piDLDA7KFbf59FjKqe1u0bGK9b
 5HwJ0jeOUp1yuZ2bjmhp224fuCwe/dlsle9Al55jQKL5f0V7wM2r6eQCiD/zSkiKUSPJlO/o9uUmnY
 lh2rtI1Hg1QjOoN/zpLop2TkeT+gg/jJaFOD/fdNGVJHjLn5mgloZnsGVfOxzkR397K5jHuIhqAdyN
 /2uv0Q4loGyCTBjV8MK+QNzk5uWh3gb8gbDy/bYknm7DYuvgp1bNTP7P7vw7hdPZwhpQ8vu1TLupzL
 ttDBxwQAGNW2py7qtmU8yE+DlonogGH925IT6d1Aj25NuT9JJljZegjZ1N/3/uEiNKFWZqYXNue+RV
 jBlnNOVM1sK2aBUK2jAchjbn+si1VndP4cMkVoxsx/w8Mor+E95Cq9cCucNKlVlcL05/4l4vFlUfp5
 aQgwIp27S9fn8svwPgdhNxS/dKLkRwaWY48LWagW5xpn30Kru9T5rufLyDtju8ofPCaXCj1z8iYKr/
 Cke1t4uOSgxWUF+oXY8DMsl7M2o9uEpJI3gmuEjutwwAkwy9c/HiSEHnjbprdcHxulcYOLHdh3IiX2
 g6wo/shmcYvnxUGDQZ8epmYG1dTu+6mBe2KbJtBzeMEbP5jlONGzjjuJlwkQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually, attributes are propagated to subflows as well.

Here, if subflows are created by other ways than the MPTCP path-manager,
it is important to make sure they are in v6 if it is asked by the
userspace.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/sockopt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 582ed93bcc8a..9986681aaf40 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1255,6 +1255,7 @@ static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
 	ssk->sk_priority = sk->sk_priority;
 	ssk->sk_bound_dev_if = sk->sk_bound_dev_if;
 	ssk->sk_incoming_cpu = sk->sk_incoming_cpu;
+	ssk->sk_ipv6only = sk->sk_ipv6only;
 	__ip_sock_set_tos(ssk, inet_sk(sk)->tos);
 
 	if (sk->sk_userlocks & tx_rx_locks) {

-- 
2.38.1

