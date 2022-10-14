Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51D15FE874
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 07:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJNFhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 01:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJNFhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 01:37:06 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2927A183E00
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 22:37:01 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221014053655epoutp0317b4aa957b82ccc7e44cc82a81610c31~d2M3BipFR0096500965epoutp03c
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 05:36:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221014053655epoutp0317b4aa957b82ccc7e44cc82a81610c31~d2M3BipFR0096500965epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665725815;
        bh=ZnJVFbTzP9eebVe4+g0M0rZLfcEg5nFDzB4HwJfDe78=;
        h=From:To:Cc:Subject:Date:References:From;
        b=eReF/GEI9wFA2aIdwFABYvT09Y6D9llikK1ZB8icpgx0Wja3xFxzf+3/rv4pzaTuw
         10RZPXk9F6sHynJNDyXfQl9tyZVU1mCUAP2FWoe6ZTttgyRlL1iQUVi3wtvTUJxxsi
         j96KwYvYG7c6B/qoOY/vD5RVzr9alcxXXULsPsUs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221014053654epcas5p1d6fad50fcdebff57f75f39f035231188~d2M2ZsMnS1072510725epcas5p1W;
        Fri, 14 Oct 2022 05:36:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MpZrg59xWz4x9Q2; Fri, 14 Oct
        2022 05:36:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.05.56352.375F8436; Fri, 14 Oct 2022 14:36:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221014053017epcas5p359d337008999640fa140c691f47bc79c~d2HENp0kk1178711787epcas5p3L;
        Fri, 14 Oct 2022 05:30:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221014053017epsmtrp163eb7e2924d33763218bff35a59b19d5~d2HEMp-FM0388403884epsmtrp1A;
        Fri, 14 Oct 2022 05:30:17 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-6a-6348f5732f05
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.88.14392.9E3F8436; Fri, 14 Oct 2022 14:30:17 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221014053015epsmtip12390955ca821a42ae222ef6fde8ee9a5~d2HCIU6j60123001230epsmtip1t;
        Fri, 14 Oct 2022 05:30:14 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com, ravi.patel@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH v2] can: mcan: Add support for handling DLEC error on CAN FD
Date:   Fri, 14 Oct 2022 10:33:32 +0530
Message-Id: <20221014050332.45045-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmum7xV49kg3ft6hZzzrewWDw99ojd
        4sK2PlaLVd+nMltc3jWHzWL9oiksFscWiFl8O/2G0WLR1i/sFg8/7GG3mHVhB6vFr4WHWSyW
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMfx+6mQqu
        8FRsfbyNsYFxJVcXIweHhICJRP857i5GLg4hgd2MEkeXbmPtYuQEcj4xSuz9nwOR+MYosXXP
        dGaQBEjD2bmHGCESexkl1i85zQrhtDJJXN15mR2kik1AS+Jx5wIWkISIwCFGiZVtz1hA9jEL
        VEscOMIHUiMs4CNxcvJ7sHoWAVWJ1UuPsYDYvALWEkf2PGCC2CYvsXrDAWaQORICb9klGp4d
        gEq4SPyadpgRwhaWeHV8CzuELSXxsr8Nyk6W2PGvkxXCzpBYMHEPVL29xIErc6Du0ZRYv0sf
        IiwrMfXUOrDxzAJ8Er2/n0Ct4pXYMQ/GVpF48XkCKyTopCR6zwlDhD0kHmxYywIJuViJTYcu
        Mk1glJ2FsGABI+MqRsnUguLc9NRi0wLjvNRyeDQl5+duYgSnQi3vHYyPHnzQO8TIxMEIDDUO
        ZiURXpcQt2Qh3pTEyqrUovz4otKc1OJDjKbAIJvILCWanA9Mxnkl8YYmlgYmZmZmJpbGZoZK
        4ryLZ2glCwmkJ5akZqemFqQWwfQxcXBKNTCt1jL8cuioP2ty12/vDR8+VE2Zzp01vzLGSdhQ
        xV+y/NssYY9ne1Yulf0x5b3u5HszfG/5/ln058hq01dsC+b2PnH9asSyIlPx9PGIhAXSspvK
        dlV3H7KPZ148tWrr1pUyf4rW5a+dFLan+mLOyXe9KRNsH3cdvvZS5YsYw6xfX3w/tRTbsj0I
        Z9239/7ltdIsunoG+7r43reuNvB65/C+P0rSVNmYQ+fklTlX5jzq7Cqa2x9lf3+KSNE3/twt
        +5qThB3/XY/kN55kMf/61yfJ35Xm6r8ps0pvSs192b0qbfutppfz32u7R+sEP94r8ujd1I9L
        d2pJOHPufb3Prv1SHYu1v8rti7c8Oeafd3fnUWIpzkg01GIuKk4EAGMZH3gOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSnO7Lzx7JBhOncFrMOd/CYvH02CN2
        iwvb+lgtVn2fymxxedccNov1i6awWBxbIGbx7fQbRotFW7+wWzz8sIfdYtaFHawWvxYeZrFY
        em8nqwOvx5aVN5k8Fmwq9fh46Tajx6ZVnWwe/X8NPN7vu8rm0bdlFaPH501yARxRXDYpqTmZ
        ZalF+nYJXBn/PnQzFVzhqdj6eBtjA+NKri5GTg4JAROJs3MPMXYxcnEICexmlFhxbRM7REJK
        YsqZlywQtrDEyn/P2SGKmpkkfp1fxgaSYBPQknjcuYAFJCEicI5R4vn6H2AJZoF6iXdnboJN
        EhbwkTg5+T2YzSKgKrF66TGwqbwC1hJH9jxggtggL7F6wwHmCYw8CxgZVjFKphYU56bnFhsW
        GOallusVJ+YWl+al6yXn525iBAenluYOxu2rPugdYmTiYDzEKMHBrCTC6xLilizEm5JYWZVa
        lB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDU3zXCh+uCzKSgsKvZk1S
        O/wgWY4/12pRv9PxO403WIPOJTBtOqu52WzX/OVR+W+Dv3S57c5iDPG8um3fL6HeOm2LOjHL
        wuoec74KHbnH6V1zeFnTBZLWcay8dkhe1c67I4/3YVZPS/ryZPHu8EWX6x01om5e2nOx5ltF
        W55KfbNuyl7H2R/tIst1/zouZfCwSQ2/cSMpdZXJ2S8WjEc3+5QdF0isY9qfp/aA3/5X8mK/
        SXliLkH3jrxf/UAg426hyKHa7hPaLJK7Vz7crNqp9mSj0xuPe/+vrDzfn6z+d8nFDTmlqkn+
        z5i8vas032w+bdyZyLFpk+yfpP97Qm7Y8AlvSBafrrGM41eT+1klluKMREMt5qLiRAAs8XlI
        vQIAAA==
X-CMS-MailID: 20221014053017epcas5p359d337008999640fa140c691f47bc79c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221014053017epcas5p359d337008999640fa140c691f47bc79c
References: <CGME20221014053017epcas5p359d337008999640fa140c691f47bc79c@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

 drivers/net/can/m_can/m_can.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 18a138fdfa66..8cff1f274aab 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -156,6 +156,7 @@ enum m_can_reg {
 #define PSR_EW		BIT(6)
 #define PSR_EP		BIT(5)
 #define PSR_LEC_MASK	GENMASK(2, 0)
+#define PSR_DLEC_MASK   GENMASK(8, 10)
 
 /* Interrupt Register (IR) */
 #define IR_ALL_INT	0xffffffff
@@ -876,8 +877,16 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	if (cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) {
 		u8 lec = FIELD_GET(PSR_LEC_MASK, psr);
 
-		if (is_lec_err(lec))
+		if (is_lec_err(lec)) {
 			work_done += m_can_handle_lec_err(dev, lec);
+		} else {
+			u8 dlec = FIELD_GET(PSR_DLEC_MASK, psr);
+
+			if (is_lec_err(dlec)) {
+				netdev_dbg(dev, "Data phase error detected\n");
+				work_done += m_can_handle_lec_err(dev, dlec);
+			}
+		}
 	}
 
 	/* handle protocol errors in arbitration phase */
-- 
2.17.1

