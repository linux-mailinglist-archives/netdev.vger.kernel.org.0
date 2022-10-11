Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592B75FBF8C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 05:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJLDqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 23:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJLDq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 23:46:26 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA278796A9
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 20:46:23 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221012034619epoutp01dec1db117c0f9b169a696e4f8fc34922~dNZuEPxnV1986219862epoutp01b
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 03:46:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221012034619epoutp01dec1db117c0f9b169a696e4f8fc34922~dNZuEPxnV1986219862epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665546379;
        bh=9Z/+w+F454z0H7x0XmWxlYencJ1CYBTi6E82IACKXlc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=mD7LdkPo8qKXm5P7YzrOSpYY0xHfZejYeUoKbv1z7Fn/FNMTgyDqew83J/KzOakWO
         OxYMO2YbQtAX0BBecfrTjB06San1xxpN8pPHOjX0nt8CvbBJfiYE/P9J/fal2xKoHR
         MjJtn6zzoEvdpUKau+2hHymgFM0RBtIa2r+/Jsxs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221012034618epcas5p1a27ca887871381c60ecbad50866ea445~dNZtZCbiH0912109121epcas5p1Z;
        Wed, 12 Oct 2022 03:46:18 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MnJTz0sMpz4x9Q1; Wed, 12 Oct
        2022 03:46:15 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.8B.39477.68836436; Wed, 12 Oct 2022 12:46:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221011120147epcas5p45049f7c0428a799c005b6ab77b428128~dAhCDyTuS1761517615epcas5p4P;
        Tue, 11 Oct 2022 12:01:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221011120147epsmtrp222a75feb8614315677f467942b54324c~dAhCC9G1R2226422264epsmtrp2c;
        Tue, 11 Oct 2022 12:01:47 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-4d-634638862f05
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.32.18644.A2B55436; Tue, 11 Oct 2022 21:01:47 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221011120144epsmtip2ff82626fc431fb636abb0859cf6df5f6~dAg-kpFeb1451514515epsmtip2X;
        Tue, 11 Oct 2022 12:01:44 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH] can: mcan: Add support for handling dlec error on CAN FD
 format frame
Date:   Tue, 11 Oct 2022 17:05:12 +0530
Message-Id: <20221011113512.13756-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmum67hVuyQXMXs8Wc8y0sFk+PPWK3
        uLCtj9Vi1fepzBaXd81hs1i/aAqLxbEFYhbfTr9htFi09Qu7xawLO1gtfi08zGKx9N5OVgce
        jy0rbzJ5LNhU6vHx0m1Gj02rOtk8+v8aeLzfd5XNo2/LKkaPz5vkAjiism0yUhNTUosUUvOS
        81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5VUihLzCkFCgUkFhcr6dvZ
        FOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRn3HikXHCBt+LZrJes
        DYwTuLsYOTkkBEwkZryczNzFyMUhJLCbUeLD3efsEM4nRolDkzdBOZ8ZJd78fcUG07Lh0g6o
        ll2MEkc7lkM5rUwSC5tmsoJUsQloSTzuXMACkhARWMUocWn1LaB2Dg5mgWqJA0f4QGqEBSIk
        1h4+yAISZhFQldjzKwEkzCtgLbFw0jFWiGXyEqs3HACbLyHwkl3i1/YVTBAJF4kd6y5DFQlL
        vDq+hR3ClpL4/G4v1KXJEjv+dULVZEgsmLiHEcK2lzhwZQ4LxDmaEut36UOEZSWmnloHNp5Z
        gE+i9/cTqFW8EjvmwdgqEi8+T2AFaQVZ1XtOGCLsIXFs1SlmEFtIIFaiq2sH4wRG2VkICxYw
        Mq5ilEwtKM5NTy02LTDKSy2HR1Nyfu4mRnAC1PLawfjwwQe9Q4xMHIyHGCU4mJVEeBnnOyUL
        8aYkVlalFuXHF5XmpBYfYjQFhthEZinR5HxgCs4riTc0sTQwMTMzM7E0NjNUEuddPEMrWUgg
        PbEkNTs1tSC1CKaPiYNTqoFpS8fSmdJOzC9vTz10f85OL41NDelvPC/aXv9gWBXW5jj95+Tt
        Qb+Osk+f186/687W4xc3cZ9leSSQsOAZw9WtMf/TorcXb+xMbeSQd2t9ybPUNu7Srk0H2nTP
        hC+qTLFoi934sPy30dY3az+83Zukw7ZovZTb9wtOjTvul91mdXxiyLn4yMpDWTvOJjabph2R
        fuR/LXpb1FLOQ6oX/Hy4vDc9s0id3DDlTsSfZTXHJpfmGXMtY6/bXPt/3coTIh0C/+0Mf1h+
        +nXrT+/Z1eInnq9kS1vxZ5rRkQyDcof5/y+fmd//puCI8XX53R+C3GavC7FnKn3+RNj4q8fK
        6R2FiXLz8p9xO8tLJh/OnainuUaJpTgj0VCLuag4EQAeAIvPCQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSvK52tGuywesXTBZzzrewWDw99ojd
        4sK2PlaLVd+nMltc3jWHzWL9oiksFscWiFl8O/2G0WLR1i/sFrMu7GC1+LXwMIvF0ns7WR14
        PLasvMnksWBTqcfHS7cZPTat6mTz6P9r4PF+31U2j74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL
        4Mq48Ui54AJvxbNZL1kbGCdwdzFyckgImEhsuLSDuYuRi0NIYAejxOIZO1khElISU868ZIGw
        hSVW/nvODlHUzCTRefAAWIJNQEvicecCFpCEiMAWRomDixYzgiSYBeol3p25yQ5iCwuESUxd
        3A+0goODRUBVYs+vBJAwr4C1xMJJx6CWyUus3nCAeQIjzwJGhlWMkqkFxbnpucWGBUZ5qeV6
        xYm5xaV56XrJ+bmbGMHhqKW1g3HPqg96hxiZOBgPMUpwMCuJ8DLOd0oW4k1JrKxKLcqPLyrN
        SS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1Oqganw7EOTU+XJ12+ovezy4VvUzs5s
        c2Eb14makl0cKc+fKB36zTu3PPL2579x09d8Fz4xq9Rin8955Y25+bUXyi/aT02afbNMtHrP
        Vu+3MnUxGTq23+4u9bNrezvP8NSr+xaxtRu0rvIGMjy6V1t8/OW+gq6jbVbZzxbMXzJP8rrJ
        woVdjWVm+Rd/X3ueoPVdblrtjpLs9eL51j0zxJc0X/3JV2UneEkmXMDx/7kLElfae87G97of
        W+18x3bGMq+SG5VvpY/+2L6z9epEI0aezEeXXROPe3lEb3a7Uj7X7fS9dPYFV1w1BIIPTtjL
        Z6N5I3pOUvPupz65QstkZx9Y+uC7yeaH6me2XJQ8lNb5yCtFiaU4I9FQi7moOBEAmP1kRrYC
        AAA=
X-CMS-MailID: 20221011120147epcas5p45049f7c0428a799c005b6ab77b428128
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221011120147epcas5p45049f7c0428a799c005b6ab77b428128
References: <CGME20221011120147epcas5p45049f7c0428a799c005b6ab77b428128@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a frame in CAN FD format has reached the data phase, the next
CAN event (error or valid frame) will be shown in DLEC.

Utilizes the dedicated flag (Data Phase Last Error Code: DLEC flag) to
determine the type of last error that occurred in the data phase
of a CAN FD frame and handle the bus errors.

Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4709c012b1dc..c070580d35fb 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -156,6 +156,7 @@ enum m_can_reg {
 #define PSR_EW		BIT(6)
 #define PSR_EP		BIT(5)
 #define PSR_LEC_MASK	GENMASK(2, 0)
+#define PSR_DLEC_SHIFT  8
 
 /* Interrupt Register (IR) */
 #define IR_ALL_INT	0xffffffff
@@ -870,6 +871,7 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done = 0;
+	int dpsr = 0;
 
 	if (irqstatus & IR_RF0L)
 		work_done += m_can_handle_lost_msg(dev);
@@ -884,6 +886,15 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	    m_can_is_protocol_err(irqstatus))
 		work_done += m_can_handle_protocol_error(dev, irqstatus);
 
+	if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
+		dpsr  = psr >> PSR_DLEC_SHIFT;
+		if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
+		    is_lec_err(dpsr)) {
+			netdev_dbg(dev, "Data phase error detected\n");
+			work_done += m_can_handle_lec_err(dev, dpsr & LEC_UNUSED);
+		}
+	}
+
 	/* other unproccessed error interrupts */
 	m_can_handle_other_err(dev, irqstatus);
 
-- 
2.17.1

