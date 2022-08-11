Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A178358FA41
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiHKJsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiHKJsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:48:47 -0400
X-Greylist: delayed 1603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Aug 2022 02:48:45 PDT
Received: from smtpng1.i.mail.ru (smtpng1.i.mail.ru [94.100.181.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6DD9082B;
        Thu, 11 Aug 2022 02:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=I7Ayg1KJiv/lsQm9ztBCqNb2erJhN1SxZDb2jBhynJQ=;
        t=1660211326;x=1660301326; 
        b=S+xkdw2O9GXq18YuAK7w4Z1VS5RYKMAeZ/6sKy5HgnuViarIewjw7FeilP0atY2T7iTNFQUd/2p6Tyir/uO3JpTgNZd2Fo8wFMYoVxWCwOCk1tY2MtHqs3TbBPp+wDhiKd8omwmexKm1kuyCgBwZA+SYSkBDIDL30vCi1CsoIgTdVvLtGisnq7XnifWXc896F+SK02wMHmUGFjXyf+qTLPPX3cccXp26bRwDvsW3SlRQWv8coWC0X2wJmwXAwHShl4E3jQw/gbKq+CdCM7X8Ap5347ZOcRDHwAogNTHYWH2VbcOXENaxIqqrX+bkYRjkbGdlVr9dVvg3eRxuj0+ZbQ==;
Received: by smtpng1.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1oM4nz-0000WO-9j; Thu, 11 Aug 2022 12:48:43 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Hemant Kumar <quic_hemantk@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH v2 1/1] net: qrtr: start MHI channel after endpoit creation
Date:   Thu, 11 Aug 2022 12:48:40 +0300
Message-Id: <20220811094840.1654088-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtpng1.m.smailru.net; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-Mailru-Src: smtp
X-7564579A: EEAE043A70213CC8
X-77F55803: 4F1203BC0FB41BD9E6910A3ADAF35E02C796E2A9FAE7A70FF34819D73FE20D52182A05F5380850404C228DA9ACA6FE27634576B6644D01E6EAC0F0EE42750A98F118FB95E2DAA457829BDFD23F443B3F
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE78E8764B5BC580342EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006376473F174BDE74BA48638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D82C1204125C8E10C1F811B82B0AF8ED016F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE78A0F7C24A37A3D769FA2833FD35BB23D9E625A9149C048EEC24E1E72F37C03A0BDFBBEFFF4125B51D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8BEC1C9C6CFAD2A0F5A471835C12D1D977C4224003CC8364762BB6847A3DEAEFB0F43C7A68FF6260569E8FC8737B5C2249EC8D19AE6D49635B68655334FD4449CB9ECD01F8117BC8BEAAAE862A0553A39223F8577A6DFFEA7C837C4FEFBD186071C4224003CC83647689D4C264860C145E
X-C1DE0DAB: C20DE7B7AB408E4181F030C43753B8183A4AFAF3EA6BDC4421840F38DCE934C09C2B6934AE262D3EE7EAB7254005DCEDF93A7E41BD21D0010003EFFB447AF238D59269BC5F550898728CF7B057D10C700CABCCA60F52D7EB47B764294357833B1AEF9F1D68E0CC2A0639DA717AEEEEEB887A4342A344B6EDA9D420A4CFB5DD3EFD471D3625173B7561E6A7E167C12CA103CB6A0DC9D209FAD59269BC5F550898DBE8DEE28BC9005CAA1EED9ED2403833638A446BE3E5C627BF0CFE790FC11A7261332C5CB50AE517886A5961035A09600383DAD389E261318FB05168BE4CE3AF
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D3488E5CD2E691F5566232A469B968E82E32782A9967501A1F779C2D41F75F4B3F909F699A8E53CA03F1D7E09C32AA3244C1C100F7CD6EF60E66EA3ECA6EF9EF04B1E098CBE561D634327AC49D2B05FCCD8
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojfXJM3siCnCmYS7facU8ebA==
X-Mailru-Sender: 689FA8AB762F7393CC2E0F076E87284E12C8D11CC8D54F216789068519F65BC498CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI channel may generates event/interrupt right after enabling.
It may leads to 2 race conditions issues.

1)
Such event may be dropped by qcom_mhi_qrtr_dl_callback() at check:

	if (!qdev || mhi_res->transaction_status)
		return;

Because dev_set_drvdata(&mhi_dev->dev, qdev) may be not performed at
this moment. In this situation qrtr-ns will be unable to enumerate
services in device.
---------------------------------------------------------------

2)
Such event may come at the moment after dev_set_drvdata() and
before qrtr_endpoint_register(). In this case kernel will panic with
accessing wrong pointer at qcom_mhi_qrtr_dl_callback():

	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
				mhi_res->bytes_xferd);

Because endpoint is not created yet.
--------------------------------------------------------------
So move mhi_prepare_for_transfer_autoqueue after endpoint creation
to fix it.

Fixes: a2e2cc0dbb11 ("net: qrtr: Start MHI channels during init")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Hemant Kumar <quic_hemantk@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
 net/qrtr/mhi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 18196e1c8c2f..9ced13c0627a 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -78,11 +78,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
-	if (rc)
-		return rc;
-
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
@@ -96,6 +91,13 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
+	/* start channels */
+	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
+	if (rc) {
+		qrtr_endpoint_unregister(&qdev->ep);
+		return rc;
+	}
+
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
-- 
2.34.1

