Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8073505D5
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhCaRxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhCaRw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:27 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D151C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:27 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w10so10376668pgh.5
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KcS93CN9ibocXNm9sNE5yWBWRwjFdOh6LiJjZnpXdhI=;
        b=VT2A0AchhL8mx3MeN8IzzGSvB4x5r8gFLJOFGTU26He6uixfI29hBX4yftlDF0MA0f
         nfZF3DKHn3lIqJWr7coXlTekQiRd8b3LEe0iDxkhDMv0fL8aIBpZol5FiTu3W6Ay9XSm
         OS3BEHo1r/MfJwRmJuWHBB3wKjftqOpDcaLXb9PvmDwOGbRMTLGujs5wSRTIsiBSwk/D
         z979zxQrJV80o2BMHpyziJFQTJZgH+mdqsqHDCFPhvywfA4PyAjJv+lN22A529TlQbCu
         ILDiZBt8OAmx/hoD3rqizIGcgzRsXANBjC0vZXF0hqouW04YG06LSpE48S25Gzl9n6ZC
         bi+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KcS93CN9ibocXNm9sNE5yWBWRwjFdOh6LiJjZnpXdhI=;
        b=lj30gAdSeK/4budUDngi1/iI7viU5qlFXS+2pE8wZQh3LfASi9v4eF5q8WJDu4Im5x
         ZrNy8b/MRbngdkKM+7fW+D5SDg0JPZFRM6RSenB5BeUK7KbOATXtuO7wbsTg2x8SidQ5
         FfjYH2eutYNgj5S4hPCcB/xp2LzO0y/pLGxCcTksVnZ5jIqZKqqin2mkkpXnvdb5Uifq
         PIBlxFdV+mwsksP2fL/vQJof06ukFK+4gIg2fvIZOd3rQU/lrlPig9I6s5aSNv4uSkCb
         b8nkpPtLunFPTCKoUXJ+f2ZJ/oydaQpVpjm8YLe/RhGrq8Har7o1/Gs1jZGiy6+OsRiY
         1CWg==
X-Gm-Message-State: AOAM5302JNNVxrU2Pqk8U+fBZSx8XCJnrIhQVTmVXXJn83h35lBoJbg0
        fAAod2IFLEVAxSL82LPM3kg=
X-Google-Smtp-Source: ABdhPJyX4y0VZElRQPRz6x+apQ3QItevJNdhs4JTb3RSfUqz/4RE09doPqU/RJWGD5ugZHHjd0gK2g==
X-Received: by 2002:a05:6a00:214d:b029:218:4f9:d5ba with SMTP id o13-20020a056a00214db029021804f9d5bamr4008361pfk.3.1617213147264;
        Wed, 31 Mar 2021 10:52:27 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 7/9] tcp: convert tcp_comp_sack_nr sysctl to u8
Date:   Wed, 31 Mar 2021 10:52:11 -0700
Message-Id: <20210331175213.691460-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_comp_sack_nr max value was already 255.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index fafcedf643832d80ebbd3d1c7c0fd8ac0866b99a..87e1612497eae2fb2c893c6c64d14ad373862f43 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -171,12 +171,12 @@ struct netns_ipv4 {
 	u8 sysctl_tcp_min_tso_segs;
 	u8 sysctl_tcp_autocorking;
 	u8 sysctl_tcp_reflect_tos;
+	u8 sysctl_tcp_comp_sack_nr;
 	int sysctl_tcp_invalid_ratelimit;
 	int sysctl_tcp_pacing_ss_ratio;
 	int sysctl_tcp_pacing_ca_ratio;
 	int sysctl_tcp_wmem[3];
 	int sysctl_tcp_rmem[3];
-	int sysctl_tcp_comp_sack_nr;
 	unsigned long sysctl_tcp_comp_sack_delay_ns;
 	unsigned long sysctl_tcp_comp_sack_slack_ns;
 	int sysctl_max_syn_backlog;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index fd2b35065bb21195f65b80d7a815221320f08eb3..a09e466ce11d04201bb4014e6895243c3bb2abdb 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -46,7 +46,6 @@ static int tcp_syn_retries_min = 1;
 static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
-static int comp_sack_nr_max = 255;
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 
@@ -1330,11 +1329,10 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_comp_sack_nr",
 		.data		= &init_net.ipv4.sysctl_tcp_comp_sack_nr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &comp_sack_nr_max,
 	},
 	{
 		.procname       = "tcp_reflect_tos",
-- 
2.31.0.291.g576ba9dcdaf-goog

