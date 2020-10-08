Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9592878DD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbgJHP43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730921AbgJHP41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AC6C061755;
        Thu,  8 Oct 2020 08:56:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o25so4681042pgm.0;
        Thu, 08 Oct 2020 08:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/f4da3WxUt9YIhUxMkS8dd98PamwjnIQpWmDemwepeg=;
        b=GQ5ZZXFoF/f7LofHz5F7a6xXe5tOAHFkHE9G+Ntdflpy9NnL0Grf5p4x4N3WhCaRZq
         GXfL3X6cRYUwtE1rJ3XY/+KZQFyh/IVZBcsi0OxpHdaGcrlBwGOnCasW6n+w7LRnlCCE
         fx4pGakWdLApOs3kI+iXu8ygHLmoGNyNXLVVPK2sMZSAOU9cxUh5bA0CjLS2YER72+Df
         Fp9zh1u7rKDR6lq/WrEJ280sc+908zZwPHI9+Jgbg1VBHTuNDVJXPzq+arXMdaeS2qhE
         g71ebgGtPw47AJvfqCAa+2JQozIuips05U/3y1LjgBJuLv68y/ALPYAH05Xor4a40gMQ
         dcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/f4da3WxUt9YIhUxMkS8dd98PamwjnIQpWmDemwepeg=;
        b=Mo+vzDM0UyvBN0PythiL93E34Z9SKHv7MsMKuNzc3Oby1HbyMcyciImZfo+FV6QWgL
         QlNrQn4g1VPY3A6IOM9hsTVdXyTfbjxnePWm9eO9e10ve/B6+UaPjF2ZKREKlvv+JO+z
         GRP6J5JpkuQfZikruTASrt8GurzqnyA1D88fy5pcZPZ/vDrqfbWQdqYfXbtZ8YkCrL2X
         w3hQI6lXHF5d6G73QZUNCxAgpIDDskBUfYbO93H2st7QQybdw8zT85aUp/+hZjfClHr7
         hd0eWra2S7keJpPbffo/z6OYKrLick7veh9xpNazbrj9kHLiczFNo3slc18HvfHmvcQt
         qksw==
X-Gm-Message-State: AOAM533I86qT/BwZVzkdxQ8VN+JKe3lkWI/z0a6m0nDI6TfINq5SGS0O
        LQZHHX9sfkdcDj0gwcTFa8o=
X-Google-Smtp-Source: ABdhPJwcxy4wYlZIpO14BIMupwdghkx2znQZnjRtrRGuEsXd8CWbviRWbdXRswEzqOk5lnpJVITbAA==
X-Received: by 2002:a63:c0b:: with SMTP id b11mr8177308pgl.416.1602172587014;
        Thu, 08 Oct 2020 08:56:27 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 079/117] wil6210: set fops_pmccfg.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:31 +0000
Message-Id: <20201008155209.18025-79-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: dc16427bbe65 ("wil6210: Add pmc debug mechanism memory management")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 57f2d6006fb0..8c37af09a84e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -945,6 +945,7 @@ static const struct file_operations fops_pmccfg = {
 	.read = wil_read_pmccfg,
 	.write = wil_write_pmccfg,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static const struct file_operations fops_pmcdata = {
-- 
2.17.1

