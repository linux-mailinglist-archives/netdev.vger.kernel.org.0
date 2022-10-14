Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAFC5FEDFB
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiJNMZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 08:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiJNMZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 08:25:51 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6F4D4CE
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 05:25:47 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221014122544epoutp0200023aa3f5be2b8c9b28d4f4152be465~d7xzwux5B1635916359epoutp02c
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 12:25:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221014122544epoutp0200023aa3f5be2b8c9b28d4f4152be465~d7xzwux5B1635916359epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665750344;
        bh=qYBYf5hhZ7Zi27Hl/Ma70yBBWva895amMf9SeflFxoU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=n3X0FKXnPMbU4BNqPCiNog8zrLsgHLTcZRcWXQXlz2/uhfdB8/IpBRYvFIHzkOL3T
         j3n60CgnKQW/DOf4dGqUGw/XywVMk62AiAMGxPa3AZtzru+oHBjay/CjJgFf2T+jxc
         qos0Y5MaLP5hUxWySY7vMdnG4Fa8pWW8N+3R1xlg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221014122544epcas5p16108a91f55cc1ec451af2da4800ce662~d7xzKqQk70129201292epcas5p1s;
        Fri, 14 Oct 2022 12:25:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MplwL5CFkz4x9Pp; Fri, 14 Oct
        2022 12:25:38 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.C4.39477.24559436; Fri, 14 Oct 2022 21:25:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221014121257epcas5p3805649d1a77149ac4d3dd110fb808633~d7mo-ZBn22694626946epcas5p3e;
        Fri, 14 Oct 2022 12:12:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221014121257epsmtrp10794d9d074fa85fa6f3d1b9eeba237f5~d7mo_ZkNo1590015900epsmtrp1F;
        Fri, 14 Oct 2022 12:12:57 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-ef-63495542a44c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.3A.14392.94259436; Fri, 14 Oct 2022 21:12:57 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221014121254epsmtip2607fb0cdbd839638c87b54055e3fe191~d7mmBjzCq2358023580epsmtip2h;
        Fri, 14 Oct 2022 12:12:53 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com, ravi.patel@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH v3] can: mcan: Add support for handling DLEC error on CAN FD
Date:   Fri, 14 Oct 2022 17:16:13 +0530
Message-Id: <20221014114613.33369-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmhq5TqGeyQdtLJYs551tYLJ4ee8Ru
        cWFbH6vFqu9TmS0u75rDZrF+0RQWi2MLxCy+nX7DaLFo6xd2i4cf9rBbzLqwg9Xi18LDLBZL
        7+1kdeD12LLyJpPHgk2lHh8v3Wb02LSqk82j/6+Bx/t9V9k8+rasYvT4vEkugCMq2yYjNTEl
        tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
        cbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGrmsXWApW
        cVe8XfScsYFxCWcXIyeHhICJxKOVK9i6GLk4hAR2M0pcaNzBAuF8YpToW9cLlfnGKDH16gxm
        mJYNix+zQyT2Mkqs2/WBGcJpZZK487mdEaSKTUBL4nHnArBZIgKHGCVWtj0Dcjg4mAWqJQ4c
        4QMxhQV8JDpOqIKUswioSmydcgSslVfAWmL7/b2sEMvkJVZvOAA2X0LgI7vE5kOtUFe4SHRv
        usMOYQtLvDq+BcqWknjZ3wZlJ0vs+NcJNShDYsHEPYwQtr3EgStzoM7RlFi/Sx8iLCsx9dQ6
        JhCbWYBPovf3EyaIOK/EjnkwtorEi88TWEFaQVb1nhOGMD0knvzWAakQEoiVuPDiMssERtlZ
        CPMXMDKuYpRMLSjOTU8tNi0wyksth0dTcn7uJkZwKtTy2sH48MEHvUOMTByMwDDjYFYS4X2t
        5JksxJuSWFmVWpQfX1Sak1p8iNEUGGITmaVEk/OByTivJN7QxNLAxMzMzMTS2MxQSZx38Qyt
        ZCGB9MSS1OzU1ILUIpg+Jg5OqQamRs6rHxIezfN+znM/OH1Km6vgik49EY1/Nje4ZoR9P/WU
        LzH007G/ycujfsxg1JKYZmr09yNbT5/tl6aqJ4z7Chi1lthsNJ59uPhJ2zw+u8CP/22PeB9l
        7uPzjJyU8sGg6b7Ky/XB0cVfn0aZryudHTY7u2qVcaj7fLXFW46/TFp98dDRhrKtXi6TK2Y5
        7bBafu2UANOGX2/k34jaHeY3YFw9P+Twswv75C7fePrsj9+PdU2vi29mi6m08ovM5Pj1KaH7
        If/cW6p33XXYzoZ+NfNT+jDzzLFai97+1mSWNbNMuKLqmB/5sDMn33vtlNn4L411Vaus3ITr
        dS2TanfsYitde6lCXvmipom0xIUNSizFGYmGWsxFxYkAaK18uQ4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSvK5nkGeywZsJXBZzzrewWDw99ojd
        4sK2PlaLVd+nMltc3jWHzWL9oiksFscWiFl8O/2G0WLR1i/sFg8/7GG3mHVhB6vFr4WHWSyW
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5m
        WWqRvl0CV8auaxdYClZxV7xd9JyxgXEJZxcjJ4eEgInEhsWP2bsYuTiEBHYzShxpuM0GkZCS
        mHLmJQuELSyx8t9zdhBbSKCZSeLTTFkQm01AS+Jx5wIWkGYRgXOMEs/X/wBrZhaol3h35iZQ
        AweHsICPRMcJVZAwi4CqxNYpRxhBbF4Ba4nt9/eyQsyXl1i94QDzBEaeBYwMqxglUwuKc9Nz
        iw0LDPNSy/WKE3OLS/PS9ZLzczcxggNTS3MH4/ZVH/QOMTJxMB5ilOBgVhLhfa3kmSzEm5JY
        WZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDU/6btOCHCxssDO89
        Mpzukp9xfdqZr3rSYndXde3m3OvAWnxNVz5aiUPIq2aZ+te5eqGyFxQZWcXyRQ+aZmUlR8w+
        L/RRTae86UOvykptBgleHs9Lk6J8Y3Y7XpcSEfeUOPShNff4Q71DTJxNUvtkTuRU8Xn1bP1p
        mmeo0TT/RqlZ5tS5AmcWTbb/u/SBSbxq7/b2C1b6ai89UxcZFjqtl5LnYfr5X2LJ9IaD/M2X
        7fVqv224+0/w75aT8UtCpOZmJLaHdG0wb40S+ybnVxvSvOPGF/dkv9idZ2Kf5aurJuW/Unly
        iMNRUeorX1ono6viZMOve3/fe6FbLTXrQ8nKJUdfmtuHPyk7Ida9P1aJpTgj0VCLuag4EQDB
        wpJEuwIAAA==
X-CMS-MailID: 20221014121257epcas5p3805649d1a77149ac4d3dd110fb808633
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221014121257epcas5p3805649d1a77149ac4d3dd110fb808633
References: <CGME20221014121257epcas5p3805649d1a77149ac4d3dd110fb808633@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

 drivers/net/can/m_can/m_can.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 18a138fdfa66..73ce946b5aab 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -156,6 +156,7 @@ enum m_can_reg {
 #define PSR_EW		BIT(6)
 #define PSR_EP		BIT(5)
 #define PSR_LEC_MASK	GENMASK(2, 0)
+#define PSR_DLEC_MASK   GENMASK(8, 10)
 
 /* Interrupt Register (IR) */
 #define IR_ALL_INT	0xffffffff
@@ -878,6 +879,13 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 
 		if (is_lec_err(lec))
 			work_done += m_can_handle_lec_err(dev, lec);
+
+		u8 dlec = FIELD_GET(PSR_DLEC_MASK, psr);
+
+		if (is_lec_err(dlec)) {
+			netdev_dbg(dev, "Data phase error detected\n");
+			work_done += m_can_handle_lec_err(dev, dlec);
+		}
 	}
 
 	/* handle protocol errors in arbitration phase */
-- 
2.17.1

