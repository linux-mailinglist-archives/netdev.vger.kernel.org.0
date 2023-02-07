Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED62568D806
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjBGNFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbjBGNE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:04:57 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF8E7A91
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:48 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g6so5500047wrv.1
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LOpSixpkQdgVar2A+zecF275+TNibOzBkrBgKo8zNk=;
        b=Mi8N6Iq2DI8Ul1mH9lMJJRrndmrDMvovgwpackgY4PdmKqJoW0+QLwR3POasUEYrZA
         uOBTki03AnF5sJ2JCFsG4wFchwFa4Bd2mNSYWCbOodWOdlcZpdcNNIPqFDbX66064UtG
         UOa76jSMsBZYPs68Cn6Kz+XjInIbVpYcLOeejoV5MuzC9ctkqBHU947UBVFsOQnSU+MT
         mNkNYB2JZftpHBEv8WGMJohb0WMUblsv4czx8XmeJio0VNwgcufa7AxfspF6MyVfwF6x
         td5fm0tjAQl1VcJFc1i/eVGmW0oMwUYatCJeQNrdya+9k8PidB8Mu+A2tKmuBwfnUKv2
         N3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7LOpSixpkQdgVar2A+zecF275+TNibOzBkrBgKo8zNk=;
        b=Qd5xQ0D8xxUOzZIHjkPFXuw8uWXpYuDoSgY9KwX6fuvrg2K7vf08+ZFonxrHPruhOJ
         FvQnd9Mxm76+5PqMsR6R2YSB1POCqhRlNImv8Nji1Gib3jW29FU6oWpvTsRJZtUmommS
         f1MmfKOknDEbSrpFp5D3HbkttnkFFd2PcBkGWe+v04dTKiRnEkegV64iIfKTPy68320i
         kWC1yidEreVG2wS+K1iCsDZkIrhSeY9h2OV4IrW31mThgFpwIPJ7iImdWKPD55O2NwZQ
         f4285VOyRuWfw097wQ5ieUbFD723VTlGR2YsQDjYgc+WJ8Z9FHYlNqLgZxkfLK7z+1PK
         JVbA==
X-Gm-Message-State: AO0yUKWOzxs6M/GPU5g59Sy25vUibhGH7kGXfd309IqF41GOMZMhDlar
        +oRwmMWW5MMGNao02GFnPj6JhzA2nmNtfbCvtls=
X-Google-Smtp-Source: AK7set9f5GaKmutrLEu2WZcxvZaneTWgw5s0q0HCSv/IuL41zx278i9qCNPiIyJG3ZXk35mqgnLtJw==
X-Received: by 2002:a5d:494f:0:b0:2bf:df72:fe03 with SMTP id r15-20020a5d494f000000b002bfdf72fe03mr3138556wrs.70.1675775086305;
        Tue, 07 Feb 2023 05:04:46 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:45 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 07 Feb 2023 14:04:16 +0100
Subject: [PATCH net 4/6] mptcp: be careful on subflow status propagation on
 errors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-4-2031b495c7cc@tessares.net>
References: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
In-Reply-To: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2148;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=XAts6+yHbdNSvA+xupWdCh0k36YlOwYaclLeEeUJtYk=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxotj/IXQmKVqdQ2qxY/yMJkzCN9cpHlAfkz
 KxpMx1ZmEmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 c3snD/4hsygAbCvAnR+5LM/7q6FyHNQQJ4NENc9Srbahyd77zaYHqqgOZMeIeXIiPIHvFSnN2t2
 prsfQQHP9L7XH48Vdah4QsdCxUE5ElsFUcTUIPo8A8we1vlWCF0KgT6Oh4EITgYms+VV7mMOi+7
 /zJTG9Fcb6kj9PPKqhTpuLdri/ZqVzsdcX4EiisPtcflwF7o2t/H5fj1zj7d6AFsr3xXA/B5+Ip
 41X0RJXwFcNmwz5Wznk05fz6vDmgXij66vFOEAOyLvRVkBd/on11Up+IVZuDF+KM0/FZJyJtzgj
 Vprpo50N9RFYudzFDg/X0rXbCYtL08ysOjNKr9HBMZ0SCUJAVHhatFlRxHHC34o3OCcVom7deQN
 nL65VC5VxHCSoclkPHKbjGgvqTqxtoMZQfWWPWvBp6PIrU0DerZXv6e20cVlMBKVrljytPhTRa3
 Rr69eY8aVp4HFOEySXCNcSCDugNItDqMAY/uAHluBWzKK996oAQpEMiRF/pAP8GHSR+veU/vx3w
 97Ft05WIwrTWByKEkQBlmDhPz4bSwWKV7T0WQV2qsZytyQ/Mbya7Lvugzvp/v3U9w5cA9KxWbfw
 uUghkOHb8CmK3SYg2YlUQcYGkUXJfjD5/LhSxFrw6GXT5TseAU8B8CB8CwMKbG1YTRUhEzHmpGk
 /Jql0l/SAPHwc0w==
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

Currently the subflow error report callback unconditionally
propagates the fallback subflow status to the owning msk.

If the msk is already orphaned, the above prevents the code
from correctly tracking the msk moving to the TCP_CLOSE state
and doing the appropriate cleanup.

All the above causes increasing memory usage over time and
sporadic self-tests failures.

There is a great deal of infrastructure trying to propagate
correctly the fallback subflow status to the owning mptcp socket,
e.g. via mptcp_subflow_eof() and subflow_sched_work_if_closed():
in the error propagation path we need only to cope with unorphaned
sockets.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/339
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a3e5026bee5b..32904c76c6a1 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1399,6 +1399,7 @@ void __mptcp_error_report(struct sock *sk)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		int err = sock_error(ssk);
+		int ssk_state;
 
 		if (!err)
 			continue;
@@ -1409,7 +1410,14 @@ void __mptcp_error_report(struct sock *sk)
 		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
 			continue;
 
-		inet_sk_state_store(sk, inet_sk_state_load(ssk));
+		/* We need to propagate only transition to CLOSE state.
+		 * Orphaned socket will see such state change via
+		 * subflow_sched_work_if_closed() and that path will properly
+		 * destroy the msk as needed.
+		 */
+		ssk_state = inet_sk_state_load(ssk);
+		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
+			inet_sk_state_store(sk, ssk_state);
 		sk->sk_err = -err;
 
 		/* This barrier is coupled with smp_rmb() in mptcp_poll() */

-- 
2.38.1

