Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872A526F13D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgIRCtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgIRCIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E342395A;
        Fri, 18 Sep 2020 02:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394934;
        bh=/RHTbVpcSZRNFlhkHPEVreQtKVkV/+iNtL07Cq+z1jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lej6bXYxNjVekhfLqSi8kmFveGTlwM6cHou6arkSAF9q3kwBLnE/BM+0anrjWF7Fv
         BW3Zya/Nnz5JFMZnjaeYUwpNudtbDWyWRukShrXJOZBGqcaSlGS3d1UgKL6zWFvJXY
         tvNiXKfIQ+41SE2Fl1WhBvRyjz5nsGh+FDV0ghX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 044/206] rt_cpu_seq_next should increase position index
Date:   Thu, 17 Sep 2020 22:05:20 -0400
Message-Id: <20200918020802.2065198-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit a3ea86739f1bc7e121d921842f0f4a8ab1af94d9 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f752d22cc8a59..248bfaf82fe06 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -274,6 +274,7 @@ static void *rt_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu+1;
 		return &per_cpu(rt_cache_stat, cpu);
 	}
+	(*pos)++;
 	return NULL;
 
 }
-- 
2.25.1

