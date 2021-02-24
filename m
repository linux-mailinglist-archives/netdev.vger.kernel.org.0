Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDE432386B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhBXIQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbhBXIO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:14:57 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33144C061574;
        Wed, 24 Feb 2021 00:14:17 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q20so838211pfu.8;
        Wed, 24 Feb 2021 00:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PCpJcby1iBAS1fFesYulGCT2pYjsVJfuxNnCp/y0Gcs=;
        b=LLaNXdmb+8VIW5Cpuh/9m9ZJyj0VMPMh1G6ZE1tRU33JzA4kv49x8/XaArI+zFBviM
         4C33a3BIr3J0Vve0AfpH8SJtCy6VcR1g4ZyplTmf7J6SfHr/3UNPwFvif6DqaE4Qiyn/
         Y5cDRR42Eef9hFEuzL+tr8TvAN/oIppR1QMiFNIdTuomOayJMm68z7mtw+6MnIdH5C4H
         GJ/Fo2pBao8naqd5Iu7K5Rc0wAW0mH8CQOWb7N9/ibx0hQiYBxtV8Igj8BKMppkbXwky
         FMHtX1D90Uipq/0jp6xKt0rwsuqsC5Jao3XAEhk0W4G5Wt+zCfbYcEpZF2c5JQzkyD0X
         xxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PCpJcby1iBAS1fFesYulGCT2pYjsVJfuxNnCp/y0Gcs=;
        b=qyVApzp0Q5pcAKPTOnuNGyaDoEFeNgHAaGr66lPZKYa+YjYRGXIi+btC4tZLBGCe1j
         9lpxoVLrQt3Um/7PwikP5Qot7jmzG8+XyX27VZ693zObyTY3GinDXCtseHet8jLu343/
         JTcVNipBuIGSjJ+1CNNiWBUqoM6nX8DrFaLoJJneiFbXUBbzhu0KTVg2ofWxaUPtRTeA
         XiuTwfy77XUVI2Rek4trtXHEKcPxz3Kb1JeJdKTBaMFrK1L16hj5lNQiUMzMq/5uSfNt
         l5T+hFCXnqP4kW5XWFosoWT6GTyRwDf4MsMOxUEiO4P9YAmwuuDi0fVUWRp306puwgjj
         gTgQ==
X-Gm-Message-State: AOAM530KNcZPnmdlwFDcRcVWpf4t1YXE/2vEtNqPY/WKPz5Hx+BEBqiH
        XGHx4FEuf/+H/xPDW+gQ5zvTB9uBoQ27cw==
X-Google-Smtp-Source: ABdhPJynSHQ2Y7yri15aTLahqVdbRdDPlUeT4EpNsldp2LP1zSRww5bSdoyCKQ+XlLqnVecYkHKCjg==
X-Received: by 2002:a63:4b0a:: with SMTP id y10mr12427648pga.144.1614154456585;
        Wed, 24 Feb 2021 00:14:16 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y68sm1622029pgy.5.2021.02.24.00.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:14:16 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        Jiong Wang <jiong.wang@netronome.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftest/bpf: no need to drop the packet when there is no geneve opt
Date:   Wed, 24 Feb 2021 16:14:03 +0800
Message-Id: <20210224081403.1425474-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf geneve tunnel test we set geneve option on tx side. On rx side we
only call bpf_skb_get_tunnel_opt(). Since commit 9c2e14b48119 ("ip_tunnels:
Set tunnel option flag when tunnel metadata is present") geneve_rx() will
not add TUNNEL_GENEVE_OPT flag if there is no geneve option, which cause
bpf_skb_get_tunnel_opt() return ENOENT and _geneve_get_tunnel() in
test_tunnel_kern.c drop the packet.

As it should be valid that bpf_skb_get_tunnel_opt() return error when
there is not tunnel option, there is no need to drop the packet and
break all geneve rx traffic. Just set opt_class to 0 in this test and
keep returning TC_ACT_OK.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index a621b58ab079..9afe947cfae9 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -446,10 +446,8 @@ int _geneve_get_tunnel(struct __sk_buff *skb)
 	}
 
 	ret = bpf_skb_get_tunnel_opt(skb, &gopt, sizeof(gopt));
-	if (ret < 0) {
-		ERROR(ret);
-		return TC_ACT_SHOT;
-	}
+	if (ret < 0)
+		gopt.opt_class = 0;
 
 	bpf_trace_printk(fmt, sizeof(fmt),
 			key.tunnel_id, key.remote_ipv4, gopt.opt_class);
-- 
2.26.2

