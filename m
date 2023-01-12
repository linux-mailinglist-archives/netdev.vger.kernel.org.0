Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08421667D9F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbjALSO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbjALSNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:13:51 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB466DBB6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:43:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g10so13731252wmo.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QiTuEY+XxNm3ybPyz+48mvw3MWfXIDkBz9A8P0bhXlA=;
        b=rL9Hw8uromb1tmWzaFdNP0RzZSeHuZEMFaPHO43kBsrbPhytZcZXbwkVpCK/GlLAAD
         MikurqYTuwb7Ce3QhPz3HOVomK+gvH2o11VbPnrpq7ddeV98W0WdoCU61W0U5uyS/w7p
         lrSadqajmthZah+VMgp6uWvyFgSl0kdCmuUWDfmdfv/pkAGwUt+ySJhAhhjxgbstwsej
         QfZ4+DskUsK60jm4SbGETMSsXC2VJ+MnQ1dqyoZvsatqiLP/eOinSKSWWXAqkDY0R4UK
         cPQIdSfaMKHGGjKz7OGqSEHJIHtpKURasIu0i/i/TDE2ga3o6c9TO3vXUJmu6urDgkVe
         QkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QiTuEY+XxNm3ybPyz+48mvw3MWfXIDkBz9A8P0bhXlA=;
        b=4VsWqWwILX26es+zddbaRTRdEphjxsGxCFyGSAKOWFuR7U6DYb+2YyFLUilMLWUSlp
         XAArdiAKbngSlpGBTOoS/vr0NPKoQbP1WclCu58TzECvzyHZFPWQZOMNexA9DnNTHCNJ
         5YVclL4Y9P/Ih0z+F3S+u/isVOmX6gj+PJoLk+W1n7CaxUwUBQwzpAsmzDn7Y3RS5QSV
         knCekvI3mrA9J6DmhAm+xW8XHlm25BxwoItvrSTzNs/Q9P0yd3INW+H9SCm/WwW0QSit
         p8Chljic4dJmH8qPbgmI19FcXc7o8v9hS24M76O1M2yaL4Sg+luxAadTVQ0xPXNCAev1
         BDbw==
X-Gm-Message-State: AFqh2koErEt9eL17P/q0MI79t1K7+jjxFTwJIBecgLe4c8VIXOy2nrfy
        YCxSkE6LJTU/xLmnrHwojRiHOw==
X-Google-Smtp-Source: AMrXdXuXok4BEMzyXnGeDPxwcjgXMFMJ+rRZQrQPRKGsR9tBWnbGCYJPiJVzTNxy7mkFNs+MI9mq7w==
X-Received: by 2002:a05:600c:5119:b0:3da:79f:8953 with SMTP id o25-20020a05600c511900b003da079f8953mr5774861wms.41.1673545397855;
        Thu, 12 Jan 2023 09:43:17 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id hg9-20020a05600c538900b003cfa622a18asm26448769wmb.3.2023.01.12.09.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 09:43:17 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 12 Jan 2023 18:42:52 +0100
Subject: [PATCH net 2/3] mptcp: netlink: respect v4/v6-only sockets
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-upstream-net-20230112-netlink-v4-v6-v1-2-6a8363a221d2@tessares.net>
References: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
In-Reply-To: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishen Maloor <kishen.maloor@intel.com>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.11.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4111;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=e19zv1aFHhB9nt3VCW/8O5Inf4FqFwI97vxJoTjVzvA=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjwEayt2N4UkguuURJPSqJpm5I3q5acpoa3IF9e41e
 NnK2xM2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY8BGsgAKCRD2t4JPQmmgc9qNEA
 CiHnvCqlld9a8saTmqmnZls7uZM1pDORqxzuHNfyEtGzDrK7FVB/aOsmW4OgllDM+Q+iPndQ5NZT/5
 TzG+cMAXhi+1BbsOQlPLGwEpdZyWPrQJvNyd4PW/OEqc8PV0daIhLFT2JpgsWENuWeITuX1FkQgyHL
 aGttAFCxZOmCNawH37GRCO5dnc7kf8bbPgdEvo0BQF4JJ1101p0RdSY+qfhqB+eT+kYDVzIpY64evq
 D0F/+3HKgGJzmr2aeg8okDDpxkt4FhEVbPu4BBkI7rM7WcHVX5YhYsmI88HHXEl8RWSFdP6jD/lOhM
 HpWGAxjjRlmsxn+CRtM0kmut2EelP77cRuDlmA7u5mMqDSXMlA72qGc729kMDBF9abSY6rRZVC+ZMm
 VLeGsF0t6bdLYgLfEhlcyf3o0s7zmB8m8+4HqDBQfwDpyhbvzik/2YfrmLeDg6Zwjq5h+ri6hPb9Fd
 7Yte7aekugwVEKuarRZ7l60wytz+EYkkOa/NySTfB93V5FIPjsJawstmh/LSqrxs3+qQROqe8bo2i/
 7oQLdJQ7FSnL4iCFySgLs9va/XiApuk2zd9jpvwgl4M1J1oFDH7B0WjQfLu0JS0CbirLoTSYtfX/lT
 LxDI8kICPTQ/v31KbZhOgBO+O1Ou0T3lhDXpzJ/ap2CTZ4Urop47yLdqvWhA==
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

If an MPTCP socket has been created with AF_INET6 and the IPV6_V6ONLY
option has been set, the userspace PM would allow creating subflows
using IPv4 addresses, e.g. mapped in v6.

The kernel side of userspace PM will also accept creating subflows with
local and remote addresses having different families. Depending on the
subflow socket's family, different behaviours are expected:
 - If AF_INET is forced with a v6 address, the kernel will take the last
   byte of the IP and try to connect to that: a new subflow is created
   but to a non expected address.
 - If AF_INET6 is forced with a v4 address, the kernel will try to
   connect to a v4 address (v4-mapped-v6). A -EBADF error from the
   connect() part is then expected.

It is then required to check the given families can be accepted. This is
done by using a new helper for addresses family matching, taking care of
IPv4 vs IPv4-mapped-IPv6 addresses. This helper will be re-used later by
the in-kernel path-manager to use mixed IPv4 and IPv6 addresses.

While at it, a clear error message is now reported if there are some
conflicts with the families that have been passed by the userspace.

Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm.c           | 25 +++++++++++++++++++++++++
 net/mptcp/pm_userspace.c |  7 +++++++
 net/mptcp/protocol.h     |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 45e2a48397b9..70f0ced3ca86 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -420,6 +420,31 @@ void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 	}
 }
 
+/* if sk is ipv4 or ipv6_only allows only same-family local and remote addresses,
+ * otherwise allow any matching local/remote pair
+ */
+bool mptcp_pm_addr_families_match(const struct sock *sk,
+				  const struct mptcp_addr_info *loc,
+				  const struct mptcp_addr_info *rem)
+{
+	bool mptcp_is_v4 = sk->sk_family == AF_INET;
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	bool loc_is_v4 = loc->family == AF_INET || ipv6_addr_v4mapped(&loc->addr6);
+	bool rem_is_v4 = rem->family == AF_INET || ipv6_addr_v4mapped(&rem->addr6);
+
+	if (mptcp_is_v4)
+		return loc_is_v4 && rem_is_v4;
+
+	if (ipv6_only_sock(sk))
+		return !loc_is_v4 && !rem_is_v4;
+
+	return loc_is_v4 == rem_is_v4;
+#else
+	return mptcp_is_v4 && loc->family == AF_INET && rem->family == AF_INET;
+#endif
+}
+
 void mptcp_pm_data_reset(struct mptcp_sock *msk)
 {
 	u8 pm_type = mptcp_get_pm_type(sock_net((struct sock *)msk));
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 65dcc55a8ad8..ea6ad9da7493 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -294,6 +294,13 @@ int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	sk = (struct sock *)msk;
+
+	if (!mptcp_pm_addr_families_match(sk, &addr_l, &addr_r)) {
+		GENL_SET_ERR_MSG(info, "families mismatch");
+		err = -EINVAL;
+		goto create_err;
+	}
+
 	lock_sock(sk);
 
 	err = __mptcp_subflow_connect(sk, &addr_l, &addr_r);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a9e0355744b6..601469249da8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -777,6 +777,9 @@ int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
 			 bool require_family,
 			 struct mptcp_pm_addr_entry *entry);
+bool mptcp_pm_addr_families_match(const struct sock *sk,
+				  const struct mptcp_addr_info *loc,
+				  const struct mptcp_addr_info *rem);
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);

-- 
2.37.2
