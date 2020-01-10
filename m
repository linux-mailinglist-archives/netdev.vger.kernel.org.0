Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8716F136D39
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 13:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgAJMim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 07:38:42 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:44618 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgAJMim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 07:38:42 -0500
Received: by mail-qv1-f66.google.com with SMTP id n8so631497qvg.11
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 04:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ajojXkhC07nfmlfMk0mmx6ju9z8VrJZrUJgcGwXjOm8=;
        b=Cl3NlCYACfwqcK1MCO4pp2J3SfqgCcDoxor1E4V6lfqGJt72dJ7xhi+F64r2wto65R
         NQHxDdHXp6ASuxJUSdV6lXjUNbeFwfI+Kp60GsVKzRmkyP9AmsW/VDfbf7cBgJ8ATyKp
         0frVzxirpLxnouqhPUkbutEhqOdBNuMgPsePtRjRV9qhFb+y8r0tSpDRo6MwkHQYW0Ab
         LwOyw7wrhRv4avdUJZG//p/dxtlCcmLktVOIRyekSiSsMjNW+4EA+Bm2UZWpVFw1b4Qq
         +PWNUsNsEKthv+q9HUv5PiwCgjCzRhtdwjyA/u5EjYuWL1ubJqi0ho5nZm5lmlytz0qs
         uWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ajojXkhC07nfmlfMk0mmx6ju9z8VrJZrUJgcGwXjOm8=;
        b=pZFX5QHVMJKfPCBAV1BVUHIO1K2sTlGBx+QEAiTu57Gb7w7QEaarxFF0ezoysYxat9
         3/77/kuDeW6iRqvc4hHgH+yW/M6XHf3rqLv5ZwpXE19M/xVNvhCxyt2RhLaQlLJAWKQa
         Os1JVRgnUmE+7Nq8MGIpxBGwNgQ0NZVCK9xFGd6hvdQMvpd4vWV27b5Gh8DmFfxv4CvS
         PlaPrSq+dYlAFyXXhTynQGbw5C5JTP9KWwK6T+XyOYKBfPyvkEST9lu4Vla66O/nL9dN
         TTYtl6TU4lQiT9CjnBlqFOgIsuQQg6ymw84AYgCDM+zzl2KCe6E+DsBgXWDK1C7ngj5H
         avZg==
X-Gm-Message-State: APjAAAU9RDLCJhCRKVm5kgpZ8KeFA2LOP2xpAuZ7fgsRnmHcn0nMpwgN
        2FxBo8fOfjIWFzD2avIrs2G/Fw==
X-Google-Smtp-Source: APXvYqxFLPOu3GbXqZlMcyX4fth7Tu7kJlrHlp2u2ojjKGSCYTtJicI0auf5HD1UQ6cr1AAf5W+e4A==
X-Received: by 2002:ad4:47ad:: with SMTP id a13mr2531692qvz.29.1578659921651;
        Fri, 10 Jan 2020 04:38:41 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t29sm780882qkm.27.2020.01.10.04.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 04:38:40 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mallesham Jatharakonda 
        <mallesham.jatharakonda@oneconvergence.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] net/tls: fix async operation
Date:   Fri, 10 Jan 2020 04:38:32 -0800
Message-Id: <20200110123832.1086-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mallesham reports the TLS with async accelerator was broken by
commit d10523d0b3d7 ("net/tls: free the record on encryption error")
because encryption can return -EINPROGRESS in such setups, which
should not be treated as an error.

The error is also present in the BPF path (likely copied from there).

Reported-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence.com>
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c6803a82b769..bb229dc0fa81 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -772,7 +772,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	psock = sk_psock_get(sk);
 	if (!psock || !policy) {
 		err = tls_push_record(sk, flags, record_type);
-		if (err) {
+		if (err && err != -EINPROGRESS) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 		}
@@ -801,7 +801,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	switch (psock->eval) {
 	case __SK_PASS:
 		err = tls_push_record(sk, flags, record_type);
-		if (err < 0) {
+		if (err && err != -EINPROGRESS) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 			goto out_err;
-- 
2.23.0

