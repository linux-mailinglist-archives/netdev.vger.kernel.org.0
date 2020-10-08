Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63204287830
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgJHPwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731392AbgJHPwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:49 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819CFC061755;
        Thu,  8 Oct 2020 08:52:49 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so4622813pgo.13;
        Thu, 08 Oct 2020 08:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HlPYzI9nQBq4QaBi/Kgsez1Nnhuc1CkWKIrGnqKGLAc=;
        b=rsOIclzf2POSE2J8ZJ0eXI9n/CQLBoOcyI/S2+a+q4J6fe7Ma3Mu1ecvrW7T3OcboT
         Zq8q7m13zGPMfMgNSCdnaoFXzFWxS36479co2lwSJi0p4V1/FOL5qcyS73SAlgrlvQXU
         tu9gRxj/ffTRdFhF4Q2IsD0/pHIO+bkxloEc1vfAsnSI5WpGVPYNNELHWr1K4KaUeu0v
         1E+x5UiEQTFDcY0Kjcus4qXsPYll4Orubfsaz7qS9edOOuz64/T7VcF17uOnmReISF9L
         stb8L1It8LQ9jIb+lPaEyL1Xyz6flGXaryL4GoFkrljngKNNbABku6wYZD+oGFDoafWJ
         SnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HlPYzI9nQBq4QaBi/Kgsez1Nnhuc1CkWKIrGnqKGLAc=;
        b=rwmZPLVGRss98UrndeJ583/GjXvOLe9OpFWQSvIkb7VZdynKa3e0Go9ReiklMIONwX
         bQo1k4ZOosHfyoYX4QkeDOCXEw0Esn3A/rbuM/nHEHe4Q4idcurAzJ6JA2ZX+50zxge3
         c91zK+VzYz0wFki7Gfje1+rczbvMjd+SJwymMdUQ4ixa8Ks6Ha9YVzRXTEYfNqK8MHDd
         IkghP1FYEoqKESeOGdxQd55q9XguhsZ40t3ygKpxhagdyJms8EX6SNZnmMym/DJ1KaIv
         HpKN+jaf6J2UHiQ3kX3fjHkufn635yqHOhXaNVE6fQSNBvlMfx9FQVbTqRyI8RNBI7my
         h9ZQ==
X-Gm-Message-State: AOAM532AfUztlrMv2Vz6txK8U0gMvB+9Vms5Du1dVvLJGr3YGRXqSpR1
        HS3fj7MdH7Mde4qIH28GoEw=
X-Google-Smtp-Source: ABdhPJznE5oRNp4t1wseDxlrSEWy0hyQb5F4/8GnIoGYbxvYyb1sTxYWS/IArQegahXd8+aIpbK6kw==
X-Received: by 2002:a17:90a:9415:: with SMTP id r21mr8940389pjo.180.1602172369112;
        Thu, 08 Oct 2020 08:52:49 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:48 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 009/117] mac80211: set STA_OPS_RW.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:21 +0000
Message-Id: <20201008155209.18025-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: a75b4363eaaf ("mac80211: allow controlling aggregation manually")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs_sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index d3366989c6f9..9ce49346c32a 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -43,6 +43,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
 	.write = sta_##name##_write,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define STA_FILE(name, field, format)					\
-- 
2.17.1

