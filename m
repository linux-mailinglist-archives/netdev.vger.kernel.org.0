Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301BD5FCAB6
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 20:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJLSf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 14:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJLSf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 14:35:56 -0400
X-Greylist: delayed 2315 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Oct 2022 11:35:54 PDT
Received: from 1.mo550.mail-out.ovh.net (1.mo550.mail-out.ovh.net [178.32.127.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FCA5D0E7
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 11:35:53 -0700 (PDT)
Received: from player728.ha.ovh.net (unknown [10.111.172.229])
        by mo550.mail-out.ovh.net (Postfix) with ESMTP id BB6E322404
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 17:57:17 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id B9C432F8FE5EC;
        Wed, 12 Oct 2022 17:57:12 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-100R003037fe447-62ac-4074-adae-940157cc4a84,
                    75377E6B882747309559AE06BD3DFEEF97A89409) smtp.auth=steve@sk2.org
X-OVh-ClientIp: 82.65.25.201
From:   Stephen Kitt <steve@sk2.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     Stephen Kitt <steve@sk2.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/nfc: use simple i2c probe
Date:   Wed, 12 Oct 2022 19:56:59 +0200
Message-Id: <20221012175700.3940062-1-steve@sk2.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 18445899650934343387
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejkedguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeelgeetueejffejfeejvefhtddufeejgfetleegtddukeelieelvddvteduveejtdenucfkphepuddvjedrtddrtddruddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoshhtvghvvgesshhkvddrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedtpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All these drivers have an i2c probe function which doesn't use the
"struct i2c_device_id *id" parameter, so they can trivially be
converted to the "probe_new" style of probe with a single argument.

This is part of an ongoing transition to single-argument i2c probe
functions. Old-style probe functions involve a call to i2c_match_id:
in drivers/i2c/i2c-core-base.c,

         /*
          * When there are no more users of probe(),
          * rename probe_new to probe.
          */
         if (driver->probe_new)
                 status = driver->probe_new(client);
         else if (driver->probe)
                 status = driver->probe(client,
                                        i2c_match_id(driver->id_table, client));
         else
                 status = -EINVAL;

Drivers which don't need the second parameter can be declared using
probe_new instead, avoiding the call to i2c_match_id. Drivers which do
can still be converted to probe_new-style, calling i2c_match_id
themselves (as is done currently for of_match_id).

This change was done using the following Coccinelle script, and fixed
up for whitespace changes:

@ rule1 @
identifier fn;
identifier client, id;
@@

- static int fn(struct i2c_client *client, const struct i2c_device_id *id)
+ static int fn(struct i2c_client *client)
{
...when != id
}

@ rule2 depends on rule1 @
identifier rule1.fn;
identifier driver;
@@

struct i2c_driver driver = {
-       .probe
+       .probe_new
                =
(
                   fn
|
-                  &fn
+                  fn
)
                ,
};

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 drivers/nfc/microread/i2c.c | 5 ++---
 drivers/nfc/nfcmrvl/i2c.c   | 5 ++---
 drivers/nfc/nxp-nci/i2c.c   | 5 ++---
 drivers/nfc/pn533/i2c.c     | 5 ++---
 drivers/nfc/pn544/i2c.c     | 5 ++---
 drivers/nfc/s3fwrn5/i2c.c   | 5 ++---
 drivers/nfc/st-nci/i2c.c    | 5 ++---
 drivers/nfc/st21nfca/i2c.c  | 5 ++---
 8 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 5eaa18f81355..e72b358a2a12 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -231,8 +231,7 @@ static const struct nfc_phy_ops i2c_phy_ops = {
 	.disable = microread_i2c_disable,
 };
 
-static int microread_i2c_probe(struct i2c_client *client,
-			       const struct i2c_device_id *id)
+static int microread_i2c_probe(struct i2c_client *client)
 {
 	struct microread_i2c_phy *phy;
 	int r;
@@ -287,7 +286,7 @@ static struct i2c_driver microread_i2c_driver = {
 	.driver = {
 		.name = MICROREAD_I2C_DRIVER_NAME,
 	},
-	.probe		= microread_i2c_probe,
+	.probe_new	= microread_i2c_probe,
 	.remove		= microread_i2c_remove,
 	.id_table	= microread_i2c_id,
 };
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index acef0cfd76af..424b49a71930 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -176,8 +176,7 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 	return 0;
 }
 
-static int nfcmrvl_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int nfcmrvl_i2c_probe(struct i2c_client *client)
 {
 	const struct nfcmrvl_platform_data *pdata;
 	struct nfcmrvl_i2c_drv_data *drv_data;
@@ -252,7 +251,7 @@ static const struct i2c_device_id nfcmrvl_i2c_id_table[] = {
 MODULE_DEVICE_TABLE(i2c, nfcmrvl_i2c_id_table);
 
 static struct i2c_driver nfcmrvl_i2c_driver = {
-	.probe = nfcmrvl_i2c_probe,
+	.probe_new = nfcmrvl_i2c_probe,
 	.id_table = nfcmrvl_i2c_id_table,
 	.remove = nfcmrvl_i2c_remove,
 	.driver = {
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index ec6446511984..d4c299be7949 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -263,8 +263,7 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
 	{ }
 };
 
-static int nxp_nci_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+static int nxp_nci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct nxp_nci_i2c_phy *phy;
@@ -349,7 +348,7 @@ static struct i2c_driver nxp_nci_i2c_driver = {
 		   .acpi_match_table = ACPI_PTR(acpi_id),
 		   .of_match_table = of_nxp_nci_i2c_match,
 		  },
-	.probe = nxp_nci_i2c_probe,
+	.probe_new = nxp_nci_i2c_probe,
 	.id_table = nxp_nci_i2c_id_table,
 	.remove = nxp_nci_i2c_remove,
 };
diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index ddf3db286bad..1503a98f0405 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -163,8 +163,7 @@ static const struct pn533_phy_ops i2c_phy_ops = {
 };
 
 
-static int pn533_i2c_probe(struct i2c_client *client,
-			       const struct i2c_device_id *id)
+static int pn533_i2c_probe(struct i2c_client *client)
 {
 	struct pn533_i2c_phy *phy;
 	struct pn533 *priv;
@@ -260,7 +259,7 @@ static struct i2c_driver pn533_i2c_driver = {
 		   .name = PN533_I2C_DRIVER_NAME,
 		   .of_match_table = of_match_ptr(of_pn533_i2c_match),
 		  },
-	.probe = pn533_i2c_probe,
+	.probe_new = pn533_i2c_probe,
 	.id_table = pn533_i2c_id_table,
 	.remove = pn533_i2c_remove,
 };
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 9e754abcfa2a..8b0d910bee06 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -866,8 +866,7 @@ static const struct acpi_gpio_mapping acpi_pn544_gpios[] = {
 	{ },
 };
 
-static int pn544_hci_i2c_probe(struct i2c_client *client,
-			       const struct i2c_device_id *id)
+static int pn544_hci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct pn544_i2c_phy *phy;
@@ -954,7 +953,7 @@ static struct i2c_driver pn544_hci_i2c_driver = {
 		   .of_match_table = of_match_ptr(of_pn544_i2c_match),
 		   .acpi_match_table = ACPI_PTR(pn544_hci_i2c_acpi_match),
 		  },
-	.probe = pn544_hci_i2c_probe,
+	.probe_new = pn544_hci_i2c_probe,
 	.id_table = pn544_hci_i2c_id_table,
 	.remove = pn544_hci_i2c_remove,
 };
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index f824dc7099ce..33f8b8ce9132 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -177,8 +177,7 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
 	return 0;
 }
 
-static int s3fwrn5_i2c_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int s3fwrn5_i2c_probe(struct i2c_client *client)
 {
 	struct s3fwrn5_i2c_phy *phy;
 	int ret;
@@ -271,7 +270,7 @@ static struct i2c_driver s3fwrn5_i2c_driver = {
 		.name = S3FWRN5_I2C_DRIVER_NAME,
 		.of_match_table = of_match_ptr(of_s3fwrn5_i2c_match),
 	},
-	.probe = s3fwrn5_i2c_probe,
+	.probe_new = s3fwrn5_i2c_probe,
 	.remove = s3fwrn5_i2c_remove,
 	.id_table = s3fwrn5_i2c_id_table,
 };
diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 89fa24d71bef..6b5eed8a1fbe 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -195,8 +195,7 @@ static const struct acpi_gpio_mapping acpi_st_nci_gpios[] = {
 	{},
 };
 
-static int st_nci_i2c_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int st_nci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct st_nci_i2c_phy *phy;
@@ -284,7 +283,7 @@ static struct i2c_driver st_nci_i2c_driver = {
 		.of_match_table = of_match_ptr(of_st_nci_i2c_match),
 		.acpi_match_table = ACPI_PTR(st_nci_i2c_acpi_match),
 	},
-	.probe = st_nci_i2c_probe,
+	.probe_new = st_nci_i2c_probe,
 	.id_table = st_nci_i2c_id_table,
 	.remove = st_nci_i2c_remove,
 };
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 76b55986bcf8..55f7a2391bb1 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -487,8 +487,7 @@ static const struct acpi_gpio_mapping acpi_st21nfca_gpios[] = {
 	{},
 };
 
-static int st21nfca_hci_i2c_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int st21nfca_hci_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct st21nfca_i2c_phy *phy;
@@ -598,7 +597,7 @@ static struct i2c_driver st21nfca_hci_i2c_driver = {
 		.of_match_table = of_match_ptr(of_st21nfca_i2c_match),
 		.acpi_match_table = ACPI_PTR(st21nfca_hci_i2c_acpi_match),
 	},
-	.probe = st21nfca_hci_i2c_probe,
+	.probe_new = st21nfca_hci_i2c_probe,
 	.id_table = st21nfca_hci_i2c_id_table,
 	.remove = st21nfca_hci_i2c_remove,
 };

base-commit: 833477fce7a14d43ae4c07f8ddc32fa5119471a2
-- 
2.30.2

