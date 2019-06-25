Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5789A520E9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 05:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfFYDI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 23:08:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42967 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfFYDI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 23:08:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id k13so1994449pgq.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 20:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zExVfQYPlu8nT0CJtzuqIZxBlVwcNRcoQAaprYs9bF4=;
        b=VOqJRbhXB9uGMJ5ABIUJOCPwsR7f7mwphTcc1odyIt5pF1uiLR9cktL7WbqNCdsSKV
         +KeiUUxAtVgdPBt2NqOawG17pj58pMp1cY7lUdh8wRfcsXgdcPyVK8pNzk33Or5Bawzk
         EPQKYq0fkFyLz5LoXnKg88p0uGdD0LItDbqf5zxqNuUSScOBHWVNlIeR5jhczOjeqBOe
         DNUte19yK728oUrAiM2j1Fkt799o3maY2vWPKG7nOV86fmGaQyWj3jwJACix+sdn8f18
         xRVbT1N1RxT4hruCq/RzBMPKYdR3wzgnjuji/oWQOtS9RmAM9SPOBC2PQo5mfsbKwtNE
         hILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zExVfQYPlu8nT0CJtzuqIZxBlVwcNRcoQAaprYs9bF4=;
        b=F0Hs7iIGy8H/Hg4dpCf2j365NuJb+xzvoOOuSj352m3eThGEgwAT33XZ/DB+C8T/nM
         25ZjtErAsXOv7lg4cn0tZmOZqs03SaW4g2crG8Z7twsaRUfLWx3XxW4bC71odVcR4/eC
         SryjO5+5BDiG11iEayYcwneyFWX8x40ciGhl+RHsPZXr882Nl742JvaREF0x9BaebB8x
         5qBZTHGQaSbmEiORWxX8LV1GDWLLNmBMzqteSDKuDrDioqpexygeVDDjjBhi20bblmBP
         VjQCNzk7OGpQ83rCUVTZpdP0hmaKH3GP06BR8m4tVaOQg65ermZZIC3F5BXTVbHEnQEf
         c1UA==
X-Gm-Message-State: APjAAAWJ6Mr1iTTzFQB/V9mOcWJfYvi13SIeOhJQ1n8+5GAcwYxUxr0F
        UkCzHVq+NLsJOTvK6yC6iOkoVg==
X-Google-Smtp-Source: APXvYqxgTwHx16vcj9gEYkBi/DiZVzjaUo2Ng8a8/VD9S52b0KE5xzakjnq2U19lX2AaU/+AUC8j0w==
X-Received: by 2002:a63:f648:: with SMTP id u8mr36137024pgj.132.1561432107914;
        Mon, 24 Jun 2019 20:08:27 -0700 (PDT)
Received: from localhost.localdomain (p2517222-ipngn21701marunouchi.tokyo.ocn.ne.jp. [118.7.246.222])
        by smtp.gmail.com with ESMTPSA id d4sm708016pju.31.2019.06.24.20.08.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 20:08:27 -0700 (PDT)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     gregkh@linuxfoundation.org, jslaby@suse.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH 2/2] net/ipv6: Fix misuse of proc_dointvec "skip_notify_on_dev_down"
Date:   Tue, 25 Jun 2019 12:08:01 +0900
Message-Id: <20190625030801.24538-2-devel@etsukata.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625030801.24538-1-devel@etsukata.com>
References: <20190625030801.24538-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/sys/net/ipv6/route/skip_notify_on_dev_down assumes given value to be
0 or 1. Use proc_dointvec_minmax instead of proc_dointvec.

Fixes: 7c6bb7d2faaf ("net/ipv6: Add knob to skip DELROUTE message ondevice down")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 11ad62effd56..aade636c6be6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5281,7 +5281,7 @@ static struct ctl_table ipv6_route_table_template[] = {
 		.data		=	&init_net.ipv6.sysctl.skip_notify_on_dev_down,
 		.maxlen		=	sizeof(int),
 		.mode		=	0644,
-		.proc_handler	=	proc_dointvec,
+		.proc_handler	=	proc_dointvec_minmax,
 		.extra1		=	&zero,
 		.extra2		=	&one,
 	},
-- 
2.21.0

