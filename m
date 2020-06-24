Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E1B207A1D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405469AbgFXRTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405391AbgFXRTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86807C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:35 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n2so1287119pld.13
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aprpFk4khDRXI59E9proW6IIfXD4QomUQ0QEthUeBSw=;
        b=uufpB6pMuP62Patz3Po1Hh2iXyCXTjGJ2SpyczCe/aq45/2TRzl58NvZJIaFlnWKyj
         ACy4hVXwOMo9qp7zs4Ba8al3+aKPrjKp7gJYaIXiejcinzFNeoeudmHdlwFbcXWrDcEJ
         m49DN91Rz/+5T3KYJYPzRPHRh5UkRbbNvMD2h+DhfPb6OhB93OscSN5vddF5xbeBRryl
         CbXT0Ym+sMav/rJZkNWNPUcz5/kTwttXZVZV4XepVwXxgbkiPAUdr6Xp9lqEJ+id/EeY
         rBQ27+gt/A2VlCd7XBmfVqXe1GgGYI7DJYq0oPTtDYrk0rkpV+/eymMOdoafNsumEtch
         5AUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aprpFk4khDRXI59E9proW6IIfXD4QomUQ0QEthUeBSw=;
        b=tLjI1/RpWzf8rlMp+3YNiAHlqK47+OVOvdPPEwXHpkLh5E9bGLQpc3f96n8mxBxN3X
         jInwqY7D46x5Fto1kfOVF/6rWTZRMKii5mBOlle6lVIavcx11nV1zNNx+VMTVoshhGer
         m8XLBIE3xI+zLtWKBIeTKy/ON9TtSMxyCDf5bYtsOjL1Wou6uqMrCKvotFTBlKzYcMQ0
         j9Uaf5ryAtBHkQKT9USVuG8vQ36iqx0MzTTnDg12if/0+5YTKWIMODhXIJxiEJpq34Oo
         II1rUBLmCtind4gL+ZR94WE/NEu9LiF3fz/LsceoJztuSU6JwXDKDWtgrbMfdWLxWtjC
         OYww==
X-Gm-Message-State: AOAM5301VncHQHbIdkmCsJGg0xu8TK/+IWBY3fzqGoagg+HmfTtXSjmp
        jtM7xPyALUgfCLKeXqYrsllz7x+jg5c=
X-Google-Smtp-Source: ABdhPJw/ICN79rSM9/8oHI/nd9ryhmGFa4U78DphjGdl9BujMC2rSjLZ66+uTC3+U8w0Z3obR9Glsw==
X-Received: by 2002:a17:90a:266f:: with SMTP id l102mr4580583pje.144.1593019174582;
        Wed, 24 Jun 2020 10:19:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:33 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 06/11] net: Function to check against maximum number for RPS queues
Date:   Wed, 24 Jun 2020 10:17:45 -0700
Message-Id: <20200624171749.11927-7-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rps_check_max_queues function which checks is the input number
is greater than rps_max_num_queues. If it is then set max_num_queues
to the value and recreating the sock_flow_table to update the
queue masks used in table entries.
---
 include/linux/netdevice.h  | 10 ++++++++
 net/core/sysctl_net_core.c | 48 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d528aa61fea3..48ba1c1fc644 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -804,6 +804,16 @@ static inline void rps_record_sock_flow(struct rps_sock_flow_table *table,
 	}
 }
 
+int __rps_check_max_queues(unsigned int idx);
+
+static inline int rps_check_max_queues(unsigned int idx)
+{
+	if (idx < rps_max_num_queues)
+		return 0;
+
+	return __rps_check_max_queues(idx);
+}
+
 #ifdef CONFIG_RFS_ACCEL
 bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
 			 u16 filter_id);
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d09471f29d89..743c46148135 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -127,6 +127,54 @@ static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 
 	return ret;
 }
+
+int __rps_check_max_queues(unsigned int idx)
+{
+	unsigned int old;
+	size_t size;
+	int ret = 0;
+
+	/* Assume maximum queues should be a least the number of CPUs.
+	 * This avoids too much thrashing of the sock flow table at
+	 * initialization.
+	 */
+	if (idx < nr_cpu_ids && nr_cpu_ids < RPS_MAX_QID)
+		idx = nr_cpu_ids;
+
+	if (idx > RPS_MAX_QID)
+		return -EINVAL;
+
+	mutex_lock(&sock_flow_mutex);
+
+	old = rps_max_num_queues;
+	rps_max_num_queues = idx;
+
+	/* No need to reallocate table since nothing is changing */
+
+	if (roundup_pow_of_two(old) != roundup_pow_of_two(idx)) {
+		struct rps_sock_flow_table *sock_table;
+
+		sock_table = rcu_dereference_protected(rps_sock_flow_table,
+						       lockdep_is_held(&sock_flow_mutex));
+		size = sock_table ? sock_table->mask + 1 : 0;
+
+		/* Force creation of a new rps_sock_flow_table. It's
+		 * the same size as the existing table, but we expunge
+		 * any stale queue entries that would refer to the old
+		 * queue mask.
+		 */
+		ret = rps_create_sock_flow_table(size, size,
+						 sock_table, true);
+		if (ret)
+			rps_max_num_queues = old;
+	}
+
+	mutex_unlock(&sock_flow_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(__rps_check_max_queues);
+
 #endif /* CONFIG_RPS */
 
 #ifdef CONFIG_NET_FLOW_LIMIT
-- 
2.25.1

