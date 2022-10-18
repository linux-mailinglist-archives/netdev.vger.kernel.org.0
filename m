Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592E06023B2
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJRFUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 01:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJRFUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 01:20:49 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC2E8A1CE
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 22:20:47 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221018052042epoutp03841b3e3cbeaee2cd90548cab71764270~fEj1oGM7P1030110301epoutp03-
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:20:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221018052042epoutp03841b3e3cbeaee2cd90548cab71764270~fEj1oGM7P1030110301epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666070442;
        bh=ZfXHTCajL15vjrEEYPwJK/pW68fZNGk2DdzuWL3LIXU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=nso18HN7FddI8RV08Ym8UEQ1MXqKEwB9a1Ad2Fjx4EgzbUQxAi3HgfR8pkgHyr6Ut
         rQ77tveeI6Y6UbDJyxtKZXSx9tYNJv78qu256GlAZ97QGAAgnGv2RnqTmnwtpDgPX9
         44hLAIw9IPWUOfWxksG/MUDXJ8ZxNdwSTCYc7Q4w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221018052041epcas5p31b257f3be81d4505190cd7197241de0a~fEj1NngH63002430024epcas5p3c;
        Tue, 18 Oct 2022 05:20:41 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Ms2J65BdGz4x9Pp; Tue, 18 Oct
        2022 05:20:38 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.A8.39477.4A73E436; Tue, 18 Oct 2022 14:20:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221018050046epcas5p1ff6339e8394597948f9b26aecb4b51a9~fEScmc6Be0228002280epcas5p1F;
        Tue, 18 Oct 2022 05:00:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221018050046epsmtrp12aaf7320e8c0cbfa250d316458241fd1~fESckIo_Q0729407294epsmtrp1e;
        Tue, 18 Oct 2022 05:00:46 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-ad-634e37a404e6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.49.18644.EF23E436; Tue, 18 Oct 2022 14:00:46 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221018050045epsmtip111a76093fae6d40c2118235d1cc0a6fc~fESaySCj_1193311933epsmtip1O;
        Tue, 18 Oct 2022 05:00:44 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com, ravi.patel@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH v4] can: mcan: Add support for handling DLEC error on CAN FD
Date:   Tue, 18 Oct 2022 10:03:33 +0530
Message-Id: <20221018043333.38858-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmpu4Sc79kg7vfdC3mnG9hsXh67BG7
        xYVtfawWq75PZba4vGsOm8X6RVNYLI4tELP4dvoNo8WirV/YLR5+2MNuMevCDlaLXwsPs1gs
        vbeT1YHXY8vKm0weCzaVeny8dJvRY9OqTjaP/r8GHu/3XWXz6NuyitHj8ya5AI6obJuM1MSU
        1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
        xcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ65YvYSvY
        wFvxYoVGA+M3ri5GTg4JAROJ01fesYHYQgK7GSVOTk/qYuQCsj8xSpy7084M4XxmlFj85Qk7
        TMffa0tZIDp2MUpsbVaEKGplkliz5jBYgk1AS+Jx5wIWkISIwCFGiZVtz4AcDg5mgWqJA0f4
        QGqEBXwkns1fxgxiswioSpxs/QRWwitgLfH/TwjELnmJ1RsOgB0hIfCWXWJy2z02iISLxIFX
        i5kgbGGJV8e3QB0nJfGyvw3KTpbY8a+TFcLOkFgwcQ8jhG0vceDKHKhzNCXW79KHCMtKTD21
        DmwkswCfRO/vJ1DjeSV2zIOxVSRefJ7ACtIKsqr3nDBE2EPiwK9nzJAgiZVYffcVywRG2VkI
        CxYwMq5ilEwtKM5NTy02LTDKSy2HR1Jyfu4mRnAa1PLawfjwwQe9Q4xMHIzAQONgVhLhdfvi
        kyzEm5JYWZValB9fVJqTWnyI0RQYYhOZpUST84GJOK8k3tDE0sDEzMzMxNLYzFBJnHfxDK1k
        IYH0xJLU7NTUgtQimD4mDk6pBqbVelUF+46E3FB4NuWvdvXJvph3zmmFEd89+Y5uzbyqwdG4
        wvZw0tel/M7NTB+n+BmIq4R8fv77OVPoiWf/+l+aPn0qcKybsfzTw/NikZfUrK0XX3ms/GeX
        nO1B7VQn+ekWToea5MUmFnMmnlLKWtj3VrpqUf7SN+e3ME2/tzf5zeLPbrbzmJqezJH6EX4/
        +dZ0F8+eljd1LLumi7IYuF/42s1waIN05ZzUpQs2al7Zp3Do9eOzl9z3rVqv5356+VWnm9Mm
        bNiefK4pPKjVRaqsTnQR51tNn4eZj9RjpHQunPzw4BBvw4l0X/eHc9ZvYjzuapE+gUtEctFZ
        r1uiJst0eVMSpqdce+zcvVB8z4cFSizFGYmGWsxFxYkAU2z7mwwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsWy7bCSnO4/I79kg4NdZhZzzrewWDw99ojd
        4sK2PlaLVd+nMltc3jWHzWL9oiksFscWiFl8O/2G0WLR1i/sFg8/7GG3mHVhB6vFr4WHWSyW
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5m
        WWqRvl0CV8a65UvYCjbwVrxYodHA+I2ri5GTQ0LAROLvtaUsILaQwA5GidtfOCHiUhJTzrxk
        gbCFJVb+e84OUdPMJHFumRqIzSagJfG4cwFQDReHiMA5Ronn63+wgSSYBeol3p25CdYgLOAj
        8Wz+MmYQm0VAVeJk6yegBg4OXgFrif9/QiDmy0us3nCAeQIjzwJGhlWMkqkFxbnpucWGBUZ5
        qeV6xYm5xaV56XrJ+bmbGMFBqaW1g3HPqg96hxiZOBgPMUpwMCuJ8Lp98UkW4k1JrKxKLcqP
        LyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1Oqganw0hZtIen01AV8jnN/F+zZ
        mrVS+wKjoxOLg1vnov5IxYCDp/ekv1gUsTOr1vlH297W7Y6VIa7bLy4OcmK+yLq/un1y7Hzh
        N3Oun1/Asm9HylkW8233rp2flfh44+y7/ximXY4RVDROiJ3El24koPF3zu6DSxdNK5n/eJVr
        xtR18prNT/YlKSUlbHjjuoNxSn8Ra4R3u/hf5YgjOVEXgxSqSib83VdlPf3Fxc0rA/stZ12R
        mDTbpn3bti+35s36XVcfda3QzuJu8/q9MX+znq+47Sa7yEGW+9iXZXlp17nfCN95srRv/Yes
        s73bH5hxdOZN2Dy/YMrLSxEnUh3TCtIOXp9T4JqVVBevZu6z3cdQiaU4I9FQi7moOBEAPOJM
        9LkCAAA=
X-CMS-MailID: 20221018050046epcas5p1ff6339e8394597948f9b26aecb4b51a9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221018050046epcas5p1ff6339e8394597948f9b26aecb4b51a9
References: <CGME20221018050046epcas5p1ff6339e8394597948f9b26aecb4b51a9@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
This patch is dependent on following patch from Marc:
[1]: https://lore.kernel.org/all/20221012074205.691384-1-mkl@pengutronix.de/

 drivers/net/can/m_can/m_can.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 18a138fdfa66..98cc98564ab4 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -156,6 +156,7 @@ enum m_can_reg {
 #define PSR_EW		BIT(6)
 #define PSR_EP		BIT(5)
 #define PSR_LEC_MASK	GENMASK(2, 0)
+#define PSR_DLEC_MASK   GENMASK(8, 10)
 
 /* Interrupt Register (IR) */
 #define IR_ALL_INT	0xffffffff
@@ -868,6 +869,7 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done = 0;
+	u8 dlec = 0;
 
 	if (irqstatus & IR_RF0L)
 		work_done += m_can_handle_lost_msg(dev);
@@ -878,6 +880,13 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 
 		if (is_lec_err(lec))
 			work_done += m_can_handle_lec_err(dev, lec);
+
+		dlec = FIELD_GET(PSR_DLEC_MASK, psr);
+
+		if (is_lec_err(dlec)) {
+			netdev_dbg(dev, "Data phase error detected\n");
+			work_done += m_can_handle_lec_err(dev, dlec);
+		}
 	}
 
 	/* handle protocol errors in arbitration phase */
-- 
2.17.1

