Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C975812FA39
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgACQWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:22:21 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41637 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbgACQWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:22:20 -0500
Received: by mail-wr1-f46.google.com with SMTP id c9so42940213wrw.8
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 08:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=evzD0JK8LSn0ZimlzI9kK570jZJqixSLv6BagHOwVBY=;
        b=D/uyn74NsoOZZDLoIBT+vfDAvfmrTzLUJeeDoSF7hwDTrWW/WKVhaHDcSw4cZZ9dTJ
         MVssK1EjiDi8P1W38Rij0dce0rgE9AgN0TQFUDTiqFUQLVrhhgCJaUToyh6RWk3kHFXl
         bBXo/jWS7LgapOUmHOth+KmYm80IE9FpQ1j4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=evzD0JK8LSn0ZimlzI9kK570jZJqixSLv6BagHOwVBY=;
        b=JyORrrtiuhKPicGk1s1QQIrrFSG9AQuaCwbT3oU45SP856+GcOt4C8XDrlsR7vRJa9
         1etBXvr44+UKW3BaOqgEDrS48sIcdesqQ+sg2w5RgZWn5OC6HoJ5Oz239g2FLKtGOzJu
         oTSKjhTnE+1uOaphJG8BliUwDQ7Qcma9dNoZOiusM0u5tb5o0SuAbR7YXaaSOvRRbIFR
         ibzQlEHGAF1tRseXAJRrzC69a+ahzXc9RzR1TnAyv2vKkw5jzauuwjpe1H3QZBfgyJQ3
         QanibpkG2OvQV9KdPszWZQ38Rxd4MaUzeV9gV3FrZiU9exjaO64KN8DvpFMsQUPElU1/
         7fAQ==
X-Gm-Message-State: APjAAAVv/JmheSDKlviHpoCxunZnhSyYPENZxfqiB+8qEGS/YXf1IuRm
        r1CipQ350EATKAEK303VHA5V+A==
X-Google-Smtp-Source: APXvYqyc9zP0ci94atqGfdtju2skV9XC2T3/AMgZm82OCBtWLKbOikxqihCEIAiksFtod1JZ9VKNvQ==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr90610098wrt.367.1578068538425;
        Fri, 03 Jan 2020 08:22:18 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id n8sm61348706wrx.42.2020.01.03.08.22.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Jan 2020 08:22:17 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>
Cc:     vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH INTERNAL v2] firmware: tee_bnxt: Fix multiple call to tee_client_close_context
Date:   Fri,  3 Jan 2020 21:50:03 +0530
Message-Id: <1578068404-26195-1-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix calling multiple tee_client_close_context in case of shm allocation
fails.

Fixes: 246880958ac9 (“firmware: broadcom: add OP-TEE based BNXT f/w manager”)
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/firmware/broadcom/tee_bnxt_fw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index 5b7ef89..ed10da5 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -215,7 +215,6 @@ static int tee_bnxt_fw_probe(struct device *dev)
 	fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
 				    TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
 	if (IS_ERR(fw_shm_pool)) {
-		tee_client_close_context(pvt_data.ctx);
 		dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
 		err = PTR_ERR(fw_shm_pool);
 		goto out_sess;
-- 
2.7.4

