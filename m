Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A6D42A2F8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhJLLTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhJLLTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 07:19:07 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C25C061570;
        Tue, 12 Oct 2021 04:17:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q5so5538971pgr.7;
        Tue, 12 Oct 2021 04:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=toin2qRutuPFHVWf+g8domdh9ga8LXuWYrISewj7CEM=;
        b=j0050LnyUGXdh7+N0cUFjwwpgCK+nBjYRj668ZBSS+1KLxHmQrxXIb/5qyKAQ40ToG
         Hu6ge+c26Hz1/Ad+kY75fcr5aWzmS9vSo3ThWdyxcFcbnxwV0iERsRQY8AldmR7Qcccx
         rmsm853DLLhxZSVVlhhXoKr6vmmo/b2wmHB/CIDNgUDNTUmemSdftPF19+xsyBOozOp/
         Tv6xbI1iCD/ghms30JSUznvToFpursgOUWShVDTetiSik2VP4D6q92T8LY/Lk4wjnXXc
         tTuFGCSLj685t2IYUBDTRSjecEWPruU+sn0tY0GFK81a27vzgeyVZkI4dJqecG7LwBav
         7x6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=toin2qRutuPFHVWf+g8domdh9ga8LXuWYrISewj7CEM=;
        b=iJ4mSOc6UNkKNgSpmg2tknwagkJ/1/QcYZBToPuAQMhvpg3vkI1zCaL6TO6R3i0gcy
         jBAxs531k/zlB3qmfyn4Ryzjx16wYBIdf+S5746pWT06DcR6k+Q8QdBi4KvLgGC1SlnK
         GBtEvmvTS802NiS4CuRSQfOcflDqhaAuNnsOeehicAmPHONOaKxPLgTCCRPcBh0RVPzc
         9/VZ3SI1DWDLfpc1pNa0NZwJ5pKUo+mJj4C8rilILEKzReh/78YoDtpIJ65tuhLnmY1z
         ZFeK/f3MJslSsnTWeXo2EPKtyNoSGRCz0+L/oidAwUApZJ5faIjNooLXC14Ybqb9JFrF
         7JnQ==
X-Gm-Message-State: AOAM530pL0vtLCq508R2Xm1e9KA2xtVZR1rtr+TnvS1v787gVPhCPyFr
        SzEENsb0ILRXglEooGmH0nc=
X-Google-Smtp-Source: ABdhPJyzPsKwhgLrlj2Aty7rX51eUmE1cPtuzka/4Nm3SSRKgPQhrzgmjJlZFXmDyyZ93l5PoetOOw==
X-Received: by 2002:aa7:814f:0:b0:44d:626:8b96 with SMTP id d15-20020aa7814f000000b0044d06268b96mr15953073pfn.65.1634037426042;
        Tue, 12 Oct 2021 04:17:06 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id 63sm10383409pfv.192.2021.10.12.04.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:17:05 -0700 (PDT)
From:   davidcomponentone@gmail.com
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Yang <davidcomponentone@gmail.com>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] Fix application of sizeof to pointer
Date:   Tue, 12 Oct 2021 19:16:49 +0800
Message-Id: <20211012111649.983253-1-davidcomponentone@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Yang <davidcomponentone@gmail.com>

The coccinelle check report:
"./samples/bpf/xdp_redirect_cpu_user.c:397:32-38:
ERROR: application of sizeof to pointer"
Using the "strlen" to fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
 samples/bpf/xdp_redirect_cpu_user.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 6e25fba64c72..d84e6949007c 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -325,7 +325,6 @@ int main(int argc, char **argv)
 	int add_cpu = -1;
 	int ifindex = -1;
 	int *cpu, i, opt;
-	char *ifname;
 	__u32 qsize;
 	int n_cpus;
 
@@ -393,9 +392,8 @@ int main(int argc, char **argv)
 				fprintf(stderr, "-d/--dev name too long\n");
 				goto end_cpu;
 			}
-			ifname = (char *)&ifname_buf;
-			safe_strncpy(ifname, optarg, sizeof(ifname));
-			ifindex = if_nametoindex(ifname);
+			safe_strncpy(ifname_buf, optarg, strlen(ifname_buf));
+			ifindex = if_nametoindex(ifname_buf);
 			if (!ifindex)
 				ifindex = strtoul(optarg, NULL, 0);
 			if (!ifindex) {
-- 
2.30.2

