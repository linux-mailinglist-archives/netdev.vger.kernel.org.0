Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2A60770B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJUMjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiJUMis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:38:48 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A20263B74
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:34 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221021123832epoutp035107b628b38949dba1ebba98cca37962~gFd_gnSRI0793507935epoutp033
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221021123832epoutp035107b628b38949dba1ebba98cca37962~gFd_gnSRI0793507935epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355912;
        bh=NXxJL4i1oJOsidFiGnrxru8pCRE5y8E/9Ytlga4MYSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQDZUd12eWk6vTDPf8HXw+mzI22+ZgnWW+DEwpZ/ZiK1e/NeSuXYdcJ8J1bu55rxH
         PFv4Pkl6koS2eepktrbzsescXByOuCfsiOnXrvvkWmTBUfiN/iTQiP76DYZ3TCeb8N
         3qeQjGoyRC121tbLixOw30AVgRBPciaTJvIuvxow=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221021123831epcas5p442f741c8f51a075806223d8bbddad6f6~gFd92Bjsw2106521065epcas5p4N;
        Fri, 21 Oct 2022 12:38:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mv3sx73jDz4x9Pr; Fri, 21 Oct
        2022 12:38:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.BB.39477.5C292536; Fri, 21 Oct 2022 21:38:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221021102639epcas5p2241192d3ac873d1262372eeae948b401~gDq0q4jKo3051630516epcas5p29;
        Fri, 21 Oct 2022 10:26:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021102639epsmtrp1a542600b6a14ba6b394916f35c125727~gDq0qIMLG1811718117epsmtrp12;
        Fri, 21 Oct 2022 10:26:39 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-6b-635292c5818f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.40.18644.ED372536; Fri, 21 Oct 2022 19:26:38 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102636epsmtip191a748e0c4b4c379ba62a644a9afbf8d~gDqyvVPHR2574025740epsmtip1B;
        Fri, 21 Oct 2022 10:26:36 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH 6/7] can: m_can: Add ECC functionality for message RAM
Date:   Fri, 21 Oct 2022 15:28:32 +0530
Message-Id: <20221021095833.62406-7-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTU/fopKBkg0uvTSwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74
        Ofcde8FtrYpTW08xNjCeVepi5OSQEDCROHD2D2MXIxeHkMBuRonW7a/YIJxPjBJ3L+xmhnA+
        M0qc+LyeFablVO91FojELkaJR3uusEM4rUwSixcfYQepYhPQknjcuYAFxBYRuMsocW1xZhcj
        BwezQLXEgSN8IGFhATeJX0cuMYLYLAKqEs+WbWQCsXkFrCVu/FjPCLFMXmL1hgPMIDangI3E
        q/lbwG6VEJjIIfFj8Xw2iCIXic9LV7BA2MISr45vYYewpSRe9rdB2ckSO/51Qn2QIbFg4h6o
        BfYSB67MYYG4TVNi/S59iLCsxNRT68DuYRbgk+j9/YQJIs4rsWMejK0i8eLzBFaQVpBVveeE
        IcIeEue334YGST+jxLJj15gnMMrNQtiwgJFxFaNkakFxbnpqsWmBUV5qOTzSkvNzNzGCE6aW
        1w7Ghw8+6B1iZOJgPMQowcGsJMJrUReULMSbklhZlVqUH19UmpNafIjRFBh+E5mlRJPzgSk7
        ryTe0MTSwMTMzMzE0tjMUEmcd/EMrWQhgfTEktTs1NSC1CKYPiYOTqkGpl18S//dO/htffUf
        rz085xukDlw8YlUaK3Pv6kxVxwetLtUx/lp2t6IEMk5OtrvoFzH135oNEV47hF2n7e67da88
        66f06hcL/qmvvzxh82sl49Ua/PFZqzSmrHtw6tOZ2sJpBX92zf+05Di7y5653NPWdqif28ek
        sbZslp2cUfSUSbOWH59cvO4Di8TGjt7X3Yb3d2lt7Ox8f7ho1R7B29lf7q2IP3JqcWiQ+ML0
        NZ3P6xNrtP7MuqA4+eHH1X8dpke4x3J+qT8d1cJRwH9tlVh7zJLXj1c8E/30VLiw8cLDXtF1
        M5tL3Q4VPV/pe/N5QFyemLL+D9MvrhOZ+x9f/LbsfOB6610ZauzHjmxepR/1R4mlOCPRUIu5
        qDgRAHE/ufYhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnO694qBkgxcPLCwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZfyc+4694LZWxamtpxgbGM8qdTFyckgImEic6r3O0sXIxSEksINRYuf6
        PawQCSmJKWdeskDYwhIr/z1nhyhqZpK4PmsjWBGbgJbE484FYEUiAi8ZJVrOsoHYzAL1Eu/O
        3GQHsYUF3CR+HbnECGKzCKhKPFu2kQnE5hWwlrjxYz0jxAJ5idUbDjCD2JwCNhKv5m8BiwsB
        1Sx7dJN9AiPfAkaGVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwUGtpbWDcc+qD3qH
        GJk4GA8xSnAwK4nwFrwLSBbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampB
        ahFMlomDU6qBaZXhfJbg31l7TTfZhjzu7doWfGRTA8+tz2VdR69xH58efrEizN3zWqjmZY/J
        7AYHDsV/3PNXU6rxwEzhA/mPS1+se5H1Iyb9wfHnov/2WdYHvNraJX/QTk0s+mdGUUb9J9sL
        fO8cVK9PObDqp+C9/J/9/asefboqv4SpY8ayWbzpHj8zr8Y9S2yXCNGa+s67cfeTSJOaEM7b
        y/fEik1fx+a08IzdHseXbnZyH2QKpXxf6izV9s9ntEv03j/1hf3VhWf+3N7hEXTuaJxLz1HX
        Fbd3Ol282ytqzLFTc7r83WiLKPMDNhsVfvVPibjOIsu/d0tywNTLK/dXZK9o+Z+uuSqRx5f5
        n+rJHxWKjRO7jyuxFGckGmoxFxUnAgDeavGK2QIAAA==
X-CMS-MailID: 20221021102639epcas5p2241192d3ac873d1262372eeae948b401
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102639epcas5p2241192d3ac873d1262372eeae948b401
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102639epcas5p2241192d3ac873d1262372eeae948b401@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever MCAN Buffers and FIFOs are stored on message ram, there are
inherent risks of corruption known as single-bit errors.

Enable error correction code (ECC) data intigrity check for Message RAM
to create valid ECC checksums.

ECC uses a respective number of bits, which are added to each word as a
parity and that will raise the error signal on the corruption in the
Interrupt Register(IR).

Message RAM bit error controlled by input signal m_can_aeim_berr[0],
generated by an optional external parity / ECC logic attached to the
Message RAM.

This indicates either Bit Error detected and Corrected(BEC) or No bit
error detected when reading from Message RAM.

Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can.c | 73 +++++++++++++++++++++++++++++++++++
 drivers/net/can/m_can/m_can.h | 24 ++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index dcb582563d5e..578146707d5b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1535,9 +1535,62 @@ static void m_can_stop(struct net_device *dev)
 	cdev->can.state = CAN_STATE_STOPPED;
 }
 
+int m_can_config_mram_ecc_check(struct m_can_classdev *cdev, int enable,
+				struct device_node *np)
+{
+	int val = 0;
+	int offset = 0, ret = 0;
+	int delay_count = MRAM_INIT_TIMEOUT;
+	struct m_can_mraminit *mraminit = &cdev->mraminit_sys;
+
+	mraminit->syscon = syscon_regmap_lookup_by_phandle(np,
+							   "mram-ecc-cfg");
+	if (IS_ERR(mraminit->syscon)) {
+		/* can fail with -EPROBE_DEFER */
+		ret = PTR_ERR(mraminit->syscon);
+		return ret;
+	}
+
+	if (of_property_read_u32_index(np, "mram-ecc-cfg", 1,
+				       &mraminit->reg)) {
+		dev_err(cdev->dev, "couldn't get the mraminit reg. offset!\n");
+		return -ENODEV;
+	}
+
+	val = ((MRAM_ECC_ENABLE_MASK | MRAM_CFG_VALID_MASK |
+		MRAM_INIT_ENABLE_MASK) << offset);
+	regmap_clear_bits(mraminit->syscon, mraminit->reg, val);
+
+	if (enable) {
+		val = (MRAM_ECC_ENABLE_MASK | MRAM_INIT_ENABLE_MASK) << offset;
+		regmap_set_bits(mraminit->syscon, mraminit->reg, val);
+	}
+
+	/* after enable or disable valid flag need to be set*/
+	val = (MRAM_CFG_VALID_MASK << offset);
+	regmap_set_bits(mraminit->syscon, mraminit->reg, val);
+
+	if (enable) {
+		do {
+			regmap_read(mraminit->syscon, mraminit->reg, &val);
+
+			if (val & (MRAM_INIT_DONE_MASK << offset))
+				return 0;
+
+			udelay(1);
+		} while (delay_count--);
+
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int m_can_close(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	struct device_node *np;
+	int err = 0;
 
 	netif_stop_queue(dev);
 
@@ -1557,6 +1610,15 @@ static int m_can_close(struct net_device *dev)
 	if (cdev->is_peripheral)
 		can_rx_offload_disable(&cdev->offload);
 
+	np = cdev->dev->of_node;
+
+	if (np && of_property_read_bool(np, "mram-ecc-cfg")) {
+		err = m_can_config_mram_ecc_check(cdev, ECC_DISABLE, np);
+		if (err < 0)
+			netdev_err(dev,
+				   "Message RAM ECC disable config failed\n");
+	}
+
 	close_candev(dev);
 
 	phy_power_off(cdev->transceiver);
@@ -1754,6 +1816,7 @@ static int m_can_open(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
+	struct device_node *np;
 
 	err = phy_power_on(cdev->transceiver);
 	if (err)
@@ -1798,6 +1861,16 @@ static int m_can_open(struct net_device *dev)
 		goto exit_irq_fail;
 	}
 
+	np = cdev->dev->of_node;
+
+	if (np && of_property_read_bool(np, "mram-ecc-cfg")) {
+		err = m_can_config_mram_ecc_check(cdev, ECC_ENABLE, np);
+		if (err < 0) {
+			netdev_err(dev,
+				   "Message RAM ECC enable config failed\n");
+		}
+	}
+
 	/* start the m_can controller */
 	m_can_start(dev);
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 4c0267f9f297..3cbfdc64a7db 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -28,6 +28,8 @@
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/phy/phy.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 /* m_can lec values */
 enum m_can_lec_type {
@@ -52,12 +54,33 @@ enum m_can_mram_cfg {
 	MRAM_CFG_NUM,
 };
 
+enum m_can_ecc_cfg {
+	ECC_DISABLE = 0,
+	ECC_ENABLE,
+};
+
 /* address offset and element number for each FIFO/Buffer in the Message RAM */
 struct mram_cfg {
 	u16 off;
 	u8  num;
 };
 
+/* MRAM_INIT_BITS */
+#define MRAM_CFG_VALID_SHIFT   5
+#define MRAM_CFG_VALID_MASK    BIT(MRAM_CFG_VALID_SHIFT)
+#define MRAM_ECC_ENABLE_SHIFT  3
+#define MRAM_ECC_ENABLE_MASK   BIT(MRAM_ECC_ENABLE_SHIFT)
+#define MRAM_INIT_ENABLE_SHIFT 1
+#define MRAM_INIT_ENABLE_MASK  BIT(MRAM_INIT_ENABLE_SHIFT)
+#define MRAM_INIT_DONE_SHIFT   0
+#define MRAM_INIT_DONE_MASK    BIT(MRAM_INIT_DONE_SHIFT)
+#define MRAM_INIT_TIMEOUT      50
+
+struct m_can_mraminit {
+	struct regmap *syscon;  /* for mraminit ctrl. reg. access */
+	unsigned int reg;       /* register index within syscon */
+};
+
 struct m_can_classdev;
 struct m_can_ops {
 	/* Device specific call backs */
@@ -92,6 +115,7 @@ struct m_can_classdev {
 	int pm_clock_support;
 	int is_peripheral;
 
+	struct m_can_mraminit mraminit_sys;     /* mraminit via syscon regmap */
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.17.1

