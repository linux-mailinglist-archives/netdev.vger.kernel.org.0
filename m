Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2585FCBEE
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 22:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJLUUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 16:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiJLUUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 16:20:49 -0400
X-Greylist: delayed 4201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Oct 2022 13:20:47 PDT
Received: from 7.mo560.mail-out.ovh.net (7.mo560.mail-out.ovh.net [188.165.48.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D5BD18CC
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 13:20:46 -0700 (PDT)
Received: from player691.ha.ovh.net (unknown [10.111.172.147])
        by mo560.mail-out.ovh.net (Postfix) with ESMTP id A3B3224DC6
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 17:55:24 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player691.ha.ovh.net (Postfix) with ESMTPSA id 069F92FB3C813;
        Wed, 12 Oct 2022 17:55:09 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-104R00506d95ab5-9e13-4dff-b839-e211efc44e30,
                    75377E6B882747309559AE06BD3DFEEF97A89409) smtp.auth=steve@sk2.org
X-OVh-ClientIp: 82.65.25.201
From:   Stephen Kitt <steve@sk2.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        George McCollister <george.mccollister@gmail.com>
Cc:     Stephen Kitt <steve@sk2.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/dsa: use simple i2c probe
Date:   Wed, 12 Oct 2022 19:55:06 +0200
Message-Id: <20221012175506.3938001-1-steve@sk2.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 18414092980370638555
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejkedguddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeelgeetueejffejfeejvefhtddufeejgfetleegtddukeelieelvddvteduveejtdenucfkphepuddvjedrtddrtddruddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoshhtvghvvgesshhkvddrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehiedtpdhmohguvgepshhmthhpohhuth
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
 drivers/net/dsa/lan9303_i2c.c           | 5 ++---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 5 ++---
 drivers/net/dsa/xrs700x/xrs700x_i2c.c   | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/lan9303_i2c.c b/drivers/net/dsa/lan9303_i2c.c
index 7d746cd9ca1b..1cb41c36bd47 100644
--- a/drivers/net/dsa/lan9303_i2c.c
+++ b/drivers/net/dsa/lan9303_i2c.c
@@ -29,8 +29,7 @@ static const struct regmap_config lan9303_i2c_regmap_config = {
 	.cache_type = REGCACHE_NONE,
 };
 
-static int lan9303_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int lan9303_i2c_probe(struct i2c_client *client)
 {
 	struct lan9303_i2c *sw_dev;
 	int ret;
@@ -106,7 +105,7 @@ static struct i2c_driver lan9303_i2c_driver = {
 		.name = "LAN9303_I2C",
 		.of_match_table = of_match_ptr(lan9303_i2c_of_match),
 	},
-	.probe = lan9303_i2c_probe,
+	.probe_new = lan9303_i2c_probe,
 	.remove = lan9303_i2c_remove,
 	.shutdown = lan9303_i2c_shutdown,
 	.id_table = lan9303_i2c_id,
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 3763930dc6fc..d4f4ceb11e86 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -14,8 +14,7 @@
 
 KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
 
-static int ksz9477_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *i2c_id)
+static int ksz9477_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap_config rc;
 	struct ksz_device *dev;
@@ -120,7 +119,7 @@ static struct i2c_driver ksz9477_i2c_driver = {
 		.name	= "ksz9477-switch",
 		.of_match_table = of_match_ptr(ksz9477_dt_ids),
 	},
-	.probe	= ksz9477_i2c_probe,
+	.probe_new = ksz9477_i2c_probe,
 	.remove	= ksz9477_i2c_remove,
 	.shutdown = ksz9477_i2c_shutdown,
 	.id_table = ksz9477_i2c_id,
diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index 54065cdedd35..14ff6887a225 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -76,8 +76,7 @@ static const struct regmap_config xrs700x_i2c_regmap_config = {
 	.val_format_endian = REGMAP_ENDIAN_BIG
 };
 
-static int xrs700x_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *i2c_id)
+static int xrs700x_i2c_probe(struct i2c_client *i2c)
 {
 	struct xrs700x *priv;
 	int ret;
@@ -148,7 +147,7 @@ static struct i2c_driver xrs700x_i2c_driver = {
 		.name	= "xrs700x-i2c",
 		.of_match_table = of_match_ptr(xrs700x_i2c_dt_ids),
 	},
-	.probe	= xrs700x_i2c_probe,
+	.probe_new = xrs700x_i2c_probe,
 	.remove	= xrs700x_i2c_remove,
 	.shutdown = xrs700x_i2c_shutdown,
 	.id_table = xrs700x_i2c_id,

base-commit: 833477fce7a14d43ae4c07f8ddc32fa5119471a2
-- 
2.30.2

