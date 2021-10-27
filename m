Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434A243C0D8
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 05:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbhJ0Din (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 23:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhJ0Dim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 23:38:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379B6C061570;
        Tue, 26 Oct 2021 20:36:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so4008501pjl.2;
        Tue, 26 Oct 2021 20:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6xaYTr2yWjUBeCP+AGHBbGfXQcj2h+HSqZ43DJ6I6fE=;
        b=FFaeR/x9b0tGSn1FA75wFI26yb2L//bjXo6MTc2SVuEDURfqqH2bPVixeHwWGc7YeE
         ghbcK/y2G6thbWHPdQJs40CY30DGIvp9HidnYC9QNGDfdBgW2UrRBWgjK/viWXGaedpf
         Hc1J4m4X0ijPdqHy8kKfVzKPTLvlGGWnVQv88+86hV7dd6BVc/0l9viC4a+r5blEhnHQ
         0WT85C5YWPVeaP17A3epz4QrIcCyICZIey3gbnrCo7q+wMHfMsR6aSVkQXaGTMi+6DCZ
         hYD1B7OP0slqFo/0L/e5+CKJ2/5ebCiDr/907VgLM+tdORWGFl0vqqUL2kruavjdKRj1
         Hb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6xaYTr2yWjUBeCP+AGHBbGfXQcj2h+HSqZ43DJ6I6fE=;
        b=4Ax/2b0eQ0ni2firA6hKhIyOld0TD7cWA3TIEhxjv+U3MThRfeWy0vOBQyQOjYtjZj
         P+FC4EABbJ2tPTCdR+s0FDwJqfj7gc2vOdRvyenImtkfFqZ9xKqiu6qEdY8HVUpD6kwF
         hip0igK4ovjaAy/anBotuY57HghJYFlsTgW8iLNfboV9N5vcACIPX4V/Be7E1zuGi2h9
         J0C0SdPSh/ABso+kJuXaNRqKTOVeAltM+s7JbxP02UNLujfVfcIzWaUJcoWCpLZDNJen
         ++F0a2qy2FV1xVikVvRNyDCOXvOO2WUYf2cTxWpEeweTU/m8Uqt3YU7/Yzy6tSj/waMb
         Mfrw==
X-Gm-Message-State: AOAM532eTrluWdXiOaLGz/RqDPZaubShbm2TZlG+hoR4snaWmvTWzrps
        AkFy99BgdK9/YpJ16YABHBRCRwMdcMo=
X-Google-Smtp-Source: ABdhPJwhOvK9K1KwzLWsLl1L0veeKjT2YaiO93eILXxH0bHfrvRElLLZUnAOgsbjiBC+V4lfxcB7qg==
X-Received: by 2002:a17:90b:4f90:: with SMTP id qe16mr3138876pjb.137.1635305777687;
        Tue, 26 Oct 2021 20:36:17 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p1sm12080847pfo.143.2021.10.26.20.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 20:36:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-kselftest@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 3/4] selftests/bpf/xdp_redirect_multi: give tcpdump a chance to terminate cleanly
Date:   Wed, 27 Oct 2021 11:35:52 +0800
Message-Id: <20211027033553.962413-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027033553.962413-1-liuhangbin@gmail.com>
References: <20211027033553.962413-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to kill tcpdump with -9.

Suggested-by: Jiri Benc <jbenc@redhat.com>
Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index c2a933caa32d..37e347159ab4 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -106,7 +106,7 @@ do_egress_tests()
 	sleep 0.5
 	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
 	sleep 0.5
-	pkill -9 tcpdump
+	pkill tcpdump
 
 	# mac check
 	grep -q "${veth_mac[2]} > ff:ff:ff:ff:ff:ff" ${LOG_DIR}/mac_ns1-2_${mode}.log && \
@@ -133,7 +133,7 @@ do_ping_tests()
 	# IPv6 test
 	ip netns exec ns1 ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
 	sleep 0.5
-	pkill -9 tcpdump
+	pkill tcpdump
 
 	# All netns should receive the redirect arp requests
 	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -eq 4 ] && \
-- 
2.31.1

