Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4772229783B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756097AbgJWUaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:30:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45601 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756089AbgJWUaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 16:30:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id 19so2171830pge.12;
        Fri, 23 Oct 2020 13:30:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MKY2uUU7e614hoiweINhwcRyaCwzzO8pKsLTU7KZm9c=;
        b=asY8A7o4L9JaJAkUbQDUak4SQElh7yQ9kdo6DODz1qZHluN6L/I9HPFPCeau7yHbw3
         akocQKwq7jYpNG2IG1HrwL7iEr7Z+2wuv0h4i+ufrfBfIxf9fCF6pW8UjvGp1I09DNfB
         zncLf+e3jG8H1ljRBSND6CSrq9eNrdWKNKuTQsxzA9dGIsvmKtcvfZl9nTw9mK9x/iC/
         lPN1kLC7r6ssjKo8DBBLVd6zMc/UpQi3WGqegu5JQ4Ppizusg5wKjVmYmoJcRPw8NPlE
         C+KOz0fFqgGlDKcGfQl52vJ3RB3KcLblRY9RRipzmn6e5cQecFw52qiY7X4SrYgtO72P
         /QQQ==
X-Gm-Message-State: AOAM532xx779lKMKhyhZNkCpT1SNXvsS8FBOnNN65YqhyxUki2FfNrAo
        nA5d4QJsUCggt4r/tyJqh5xI9HZTTTY=
X-Google-Smtp-Source: ABdhPJw7vBg/2DYX50TXenouXLeq9Xi/Lyxur1tOBaf4pYqMSaJMzF6WZGy5a3NNcpZZekr+PH5whg==
X-Received: by 2002:a62:e104:0:b029:152:4f37:99da with SMTP id q4-20020a62e1040000b02901524f3799damr841514pfh.17.1603485044953;
        Fri, 23 Oct 2020 13:30:44 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id g1sm3757346pjj.3.2020.10.23.13.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 13:30:44 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lucyyan@google.com,
        moritzf@google.com, James.Bottomley@hansenpartnership.com,
        kuba@kernel.org, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH/RFC net-next v3] net: dec: tulip: de2104x: Add shutdown handler to stop NIC
Date:   Fri, 23 Oct 2020 13:28:34 -0700
Message-Id: <20201023202834.660091-1-mdf@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver does not implement a shutdown handler which leads to issues
when using kexec in certain scenarios. The NIC keeps on fetching
descriptors which gets flagged by the IOMMU with errors like this:

DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000

Signed-off-by: Moritz Fischer <mdf@kernel.org>
---

I'd consider it a bug-fix but Jakub said it's a feature,
so net-next it is. I don't have a strong preference either way.

Changes from v2:
- Changed to net-next
- Removed extra whitespace

Changes from v1:
- Replace call to de_remove_one with de_shutdown() function
  as suggested by James.

---
 drivers/net/ethernet/dec/tulip/de2104x.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index d9f6c19940ef..ea7442cc8e75 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2175,11 +2175,19 @@ static int __maybe_unused de_resume(struct device *dev_d)
 
 static SIMPLE_DEV_PM_OPS(de_pm_ops, de_suspend, de_resume);
 
+static void de_shutdown(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+
+	de_close(dev);
+}
+
 static struct pci_driver de_driver = {
 	.name		= DRV_NAME,
 	.id_table	= de_pci_tbl,
 	.probe		= de_init_one,
 	.remove		= de_remove_one,
+	.shutdown	= de_shutdown,
 	.driver.pm	= &de_pm_ops,
 };
 
-- 
2.28.0

