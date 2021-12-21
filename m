Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912E447C79F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241857AbhLUTkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241842AbhLUTkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:40:09 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEA2C061574;
        Tue, 21 Dec 2021 11:40:09 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id p8so21510ljo.5;
        Tue, 21 Dec 2021 11:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/uKyyOqK31yVvTxepIWf3C0/nG0qY+9vHEVmcazif6A=;
        b=mDwpKytDas5WfYtyTNm4aXCVrv1Kd6hSyQs6O1BA538BAsxZY8NtZgVeZShQZSi+PL
         Upe8i69lpPviyuHiY8D+DBnvF45fWgVNKhIaOoqnVWBmnEBhIFw1VyqZRNzTFRW/rlwH
         DrB1ZGxIIs+29C99QacgeQpeqpl/C12yHB6hwrs990lx2fx8yAfoCt1W1R86Q+7foYM9
         D9jcfsfW2gohC/FVxcAP58zLL/JuSN+Kn6YVcQKuizG00o187cNbD11I7AD7puhIhFNK
         6A5IgcYpjyI4bc262CsymBb3DoBZhILlrNaRnWA0jiVI2EB4yr7asIFLCPCAjqY5czRl
         7H4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uKyyOqK31yVvTxepIWf3C0/nG0qY+9vHEVmcazif6A=;
        b=Q1Yi4VXEW5XO1+QFtcKN0XZ8Q0SlSsa0l4T++C9mIEZyNnm/UigWih7WIPrd8lcnYh
         C6rwie5ybMgBdg/COgksTyAJqTTNmODY4oOr0rpAgtMIw+hGRjCIrG/77m3YhLSEGi9f
         /fTgq3yQH4hhcEfJBgVGDPwYtrEMliNfaGjKQyvcKmOo6cN+mSsZbKsCs6bRsUGotz0c
         6YMXV+3L/YM9PNmQ8VFmbnojHQE1wiBpsgK1XACilLreXkXeC89bJkHtCmbd9jTVjaUa
         RZtwC+MzoaLhuXKrlKUvHIAF6FX/UAidKbi9yRsHNijxDJ8yhOvY6yt4+lrB/dzMMWgx
         Vqow==
X-Gm-Message-State: AOAM530SJevlhxgdw792XijLWTm3MdMCwQhoFVTuJ0jGmjXzTYpWLsaQ
        zwBJQ28GdC088MwfwOsCz7M=
X-Google-Smtp-Source: ABdhPJxCT5s/kKAWn+YxAhCAhMXMP3dAl+/J/UAgVhopQojePuKy41uetIeiPF5CNpqFiUhXZIUnUg==
X-Received: by 2002:a2e:8e88:: with SMTP id z8mr3540873ljk.197.1640115607420;
        Tue, 21 Dec 2021 11:40:07 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id j21sm2819061lji.88.2021.12.21.11.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 11:40:07 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, robert.foss@collabora.com, freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 2/2] asix: fix wrong return value in asix_check_host_enable()
Date:   Tue, 21 Dec 2021 22:40:05 +0300
Message-Id: <989915c5f8887e4a0281ed87325277aa8c997291.1640115493.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
References: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If asix_read_cmd() returns 0 on 30th interation, 0 will be returned from
asix_check_host_enable(), which is logically wrong. Fix it by returning
-ETIMEDOUT explicitly if we have exceeded 30 iterations

Fixes: a786e3195d6a ("net: asix: fix uninit value bugs")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 06823d7141b6..8c61d410a123 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -83,7 +83,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 			break;
 	}
 
-	return ret;
+	return i >= 30? -ETIMEDOUT: ret;
 }
 
 static void reset_asix_rx_fixup_info(struct asix_rx_fixup_info *rx)
-- 
2.34.1

