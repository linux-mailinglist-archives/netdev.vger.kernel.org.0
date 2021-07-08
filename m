Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9992E3BFA18
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhGHMam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:30:42 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:45054 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231455AbhGHMaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 08:30:39 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3C5AB49E0E;
        Thu,  8 Jul 2021 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1625747275; x=1627561676; bh=sydz3Wzh06v4Eeyvteb8BKe1aO3dkHHmVlB
        nZAgf59I=; b=rX48V70vvH7obTYJ25Y6gLAXN8NgPH4D81fWvlgRgKCMWwHhpNo
        xuVtOwkmjmodzzs9scTvwBl9OJV2ySJPZvKhHQ5ILqhEO6NeockGMBcx2cJf6HD4
        RCrwjeWx+R+xVBrre7MuWq1n86NZPR/O+AXdduXPv/3Hw7jBvbmCKqDo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dPFvq68vkG93; Thu,  8 Jul 2021 15:27:55 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 277CD49F56;
        Thu,  8 Jul 2021 15:18:27 +0300 (MSK)
Received: from fedora.mshome.net (10.199.0.196) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 8 Jul
 2021 15:18:25 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH v2 3/3] net/ncsi: add dummy response handler for Intel boards
Date:   Thu, 8 Jul 2021 15:27:54 +0300
Message-ID: <20210708122754.555846-4-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210708122754.555846-1-i.mikhaylov@yadro.com>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.196]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the dummy response handler for Intel boards to prevent incorrect
handling of OEM commands.

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 net/ncsi/ncsi-rsp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 04bc50be5c01..d48374894817 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -699,12 +699,19 @@ static int ncsi_rsp_handler_oem_bcm(struct ncsi_request *nr)
 	return 0;
 }
 
+/* Response handler for Intel card */
+static int ncsi_rsp_handler_oem_intel(struct ncsi_request *nr)
+{
+	return 0;
+}
+
 static struct ncsi_rsp_oem_handler {
 	unsigned int	mfr_id;
 	int		(*handler)(struct ncsi_request *nr);
 } ncsi_rsp_oem_handlers[] = {
 	{ NCSI_OEM_MFR_MLX_ID, ncsi_rsp_handler_oem_mlx },
-	{ NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm }
+	{ NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm },
+	{ NCSI_OEM_MFR_INTEL_ID, ncsi_rsp_handler_oem_intel }
 };
 
 /* Response handler for OEM command */
-- 
2.31.1

