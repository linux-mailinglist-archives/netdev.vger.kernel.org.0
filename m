Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8809B6B27EC
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjCIOyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjCIOxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:53:05 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FBAF0FD7
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:51:12 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-17683b570b8so2493762fac.13
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7aVI4e2OdlOYVuMUfrd7oCECSdqBtHFzJOKgjTLxG8Y=;
        b=tGsVthprhw/reHeu0kXsKQ3G4aAujKF/o6r1dMxPdSzLo1GiCnsDQ0KP9zqhy4akt+
         ukd3KSdcnCj5w52bz0EPCD3kMAKw5C3kJrMv5cwpujHZdeqj0rbb1f4oTlWaPgoie+Fi
         oqPWTGV7PEU+54huXmLOmPhHK9oZpLdrMFhz5v/1emVPZghgLVbJwEnmNuyF1WtChcS0
         kfeqgsjC7b22IuH3T+k+40V+QXjkkeG0yKo+dMARhKjOqsRoGsUwOZwVSXLT1dk7xng0
         HWI4UHtO28QAfPRmmLK0F28oPs0iOV1/3ETbHznFLB/PNBCR1vSv0sR6kYQmnLM54Ji0
         j0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7aVI4e2OdlOYVuMUfrd7oCECSdqBtHFzJOKgjTLxG8Y=;
        b=F9Af3KzdFUiiJ1l2SZk/T0dIfd1wvX4Kw/RChf9SDK+P9pI85P8kOWfGtmwynYLCz/
         +uMRN1Qmqxbtp+f4C8cn0Cr66ymTvlCRwE3QwQohVBS8Ppoi98Pc+i6gYRRMcI1OAD1q
         +7YkjLnClG5OpzA9/+CmkIbL9w3Rh6JfoS6ls8LjKcqIqOXFjCaGldFgGovPB6weICW/
         dxmmr2QAYBUZvu2/KBps2bZhQgICf+U6E+8SetNeEo2LzIhNYizvzCaudniPxg6TRpQo
         lh2byh7CLg8sv3L7+pQopyB7Kk7qMTsEbYGbuj5XIy9nH9lMlzN1FMCuunj30Afy1xF1
         B87Q==
X-Gm-Message-State: AO0yUKU2RTfROV7Ocn/PHdTLvX01SGPwYlQRRtNu1UxtnKkqstmRJeLe
        ePhhbBI98XF4zl8HS6b9YNBYhg==
X-Google-Smtp-Source: AK7set/BxsPcC+kHi85xoG6nN7cO/XktZA2laWYayamgxbuDGcc1aRzL0J6Z81vp8brLfoyc73CXcA==
X-Received: by 2002:a05:6870:ac1e:b0:172:a40f:5ff7 with SMTP id kw30-20020a056870ac1e00b00172a40f5ff7mr13766983oab.15.1678373470400;
        Thu, 09 Mar 2023 06:51:10 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:51:10 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Mar 2023 15:50:02 +0100
Subject: [PATCH net v2 6/8] mptcp: add ro_after_init for
 tcp{,v6}_prot_override
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-6-47c2e95eada9@tessares.net>
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
        Geliang Tang <geliang.tang@suse.com>, stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1660;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=jwqxBRvOjpFpJeOhBbQNAMdCMsCRiyb+3+BlXnlrYos=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhvNkzCHxVtYQT3XvqIPehwKS4POj6L7ylM
 Oq6BtJKQB2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 c/zGEACqL6+KKaSjgkuLXw9CX+Naqdq9ZO96zwpEXD95zrKUK4O8JaHHSLNyzKq2NksdN2iRwhZ
 7oj2fI8FvM8nguDeHJiGuVFewPfMJBtz+DW4sqf/+Sq4TUlZCMNwIpizXW153YGZL9JE5B5xqYs
 FFWqRTBMSRlVyubNDj6heuregejJ2Vwvf6voTRb83e67ueY9fGG8BPhVxl224aZcEK0Q7ToDRVp
 Utrkr7QFId9CYkRdXst2qrWcM/QsLbJJ21IwgXQuepgOB2tMtbYkAjpWfRieUuhTPCDrqw078+L
 hVg8gr6iFvBWecQUE6bQpqM20Tfpq2OxyYpHTzPBy2+Z3ZBsNeNlru/VBXHOyDbRk24z3XqWYXz
 MueoJdJ4o1rFgpLYgrYGsnTDX228EOkG0vKs8ZAaXSFZ5IPGX7shVBsH/IZ84fdhAMtivP/WAXI
 6bkTzSB8sH0D9c/kQWd0CFwHPHBg/c75C9Jz+uGEUXjUJebvqaXEMgkA/lI9IGsCc+b9cn/55qw
 /HXEUy7bjKFRJKFuVtetgL8+hn9tANC0g4uF8DfInATFIch2IUGR6zgkMq5hiHOuT3um7qRkvm1
 Q0WbH6u3/OdBAO8L+hMiKx+ALYG2iNcXBinxP4k47I8XBgux36FUMdargEBkINqaglBHHLeBSkC
 q1JUskp+9rIuAyQ==
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

From: Geliang Tang <geliang.tang@suse.com>

Add __ro_after_init labels for the variables tcp_prot_override and
tcpv6_prot_override, just like other variables adjacent to them, to
indicate that they are initialised from the init hooks and no writes
occur afterwards.

Fixes: b19bc2945b40 ("mptcp: implement delegated actions")
Cc: stable@vger.kernel.org
Fixes: 51fa7f8ebf0e ("mptcp: mark ops structures as ro_after_init")
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9c57575df84c..2aadc8733369 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -628,7 +628,7 @@ static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
-static struct proto tcpv6_prot_override;
+static struct proto tcpv6_prot_override __ro_after_init;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -926,7 +926,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 }
 
 static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
-static struct proto tcp_prot_override;
+static struct proto tcp_prot_override __ro_after_init;
 
 enum mapping_status {
 	MAPPING_OK,

-- 
2.39.2

