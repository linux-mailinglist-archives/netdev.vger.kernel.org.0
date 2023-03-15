Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547C06BAFD2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjCOMEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjCOMEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:04:20 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2071.outbound.protection.outlook.com [40.107.241.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF4E17156;
        Wed, 15 Mar 2023 05:04:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJfzLj1Dk4NkeuihVoahU+1EZCSKKghkeV/262tbONKEMENqHT95HDIlaBdfo9GL3JluVePbVTLc72eRuW5IxpOkRDeoC1E9//61MNe2uTxi2w2anXdNYBGufYqaS19wIIKhYCthfD2lTeOnTvv90BPRmIoR8Xih2VZTD5lVvCYcvEDPWapVkaPmVhaR/tN2Hz51+I0W2KN+yvgmv215DjiBI7HTM0JlV8v3EnSM5uUM7jFSMWhg7kskgD0f2k7Yi4g19XshHck2+bqSi6Mp7JO1u9BNFztloBFBGOiPZbN/yqzqKJKBIbFkjcdP0clPR49uFScb4D+aXGpd+Wkghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9h6VVthgpah7G60qrDKCw7o0qLugUfnyM87b908ubwo=;
 b=Q++5/l0yJ1DPYdv4Mq6dalWAyJBdT1+EQvZDLQBunwFrFj2ykVRYCCefE/mbStI0MC1oD3iQBGfgLOFkcjrx2Ypmk8sniLI3iirHCMRb9wSRqS7OJeGvT/Hify9eDbk/BqUJHmPbFWSqNqeICj+OuYi8+x6S28r3C/7rGLc6yuk6xV8bPuvTk23dnNqGz4EbopP85CvSuPmHG4s5pyD3fbKufY1/Yz6GQ6hh6OUeI6yRkc+GwaR08tgFSTSDgZG2VuYXdCcAaRa+ZQLZM+JATiKH7P1DaUCF144NlZ5sL4TaEqkEyQed+m9T7gLficG3ron5HFfwC4Mg76DaVRzxmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h6VVthgpah7G60qrDKCw7o0qLugUfnyM87b908ubwo=;
 b=HbdKD/JIRdehgE7o14hGzJod2IrLw/IZq/rh5iF9xPNTHURlp3STE22uVaih+kzLGdleaE/oQLKjVC1eQqfkXlI0UmT/KU9DLeIP4C1mdIaRIwDuuJT+A+Idv8BH/lCp75uTaF6DClmP76av9WetSowyG0DF5MEaomNAtrnEneY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB8629.eurprd04.prod.outlook.com (2603:10a6:10:2dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:04:04 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:04:04 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v12 1/4] serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
Date:   Wed, 15 Mar 2023 17:33:23 +0530
Message-Id: <20230315120327.958413-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0096.apcprd02.prod.outlook.com
 (2603:1096:4:90::36) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB8629:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b606c6b-6896-4e16-2532-08db254d5f02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9sl8Q+w4YkPWh1ZQw4XzGc5TLfRlOJAZaDrd+p1KVWCUrizpNPRZmq7vIGtZaxjH4eHGq1ojg4fT/YAETG6IjuenvR6Ta2y1Px7O6dejXlyhWGB6jN1pFtNdkI6txyqiNJB9zwL1fIOMKjPViw1lbhjfcrys5cZNuV2cq2QLvoqxpVPqlTvYsnZ6X1ZUjlF6lMw4n7H+p7w5y+WxA3yBe/dSN8JWy3pfVI1O2V/bDGdE+8JC2w7DrZ2FBrcHzxVgS0HcHnkUNq6DxxZK+WUG2ycaYy4H4DvLIwFMuiogvYOFbAvh5Uf8PL6oOjEFdVls7kCR485fr+ewbET7nUJGYSIGB0XfgdErdyskLLZ/XY4zcMUWZEoge1Va09EOcace2ZoSkdrTi0RPZ3bp76UzuOr6bd7nhOvZOciL2qOPbjxwQuP8nNX9XUS40/OkHvBwMC2U9+dPSskFzEx3O7Haf/8lYYSXCeVpTrlO3Ssioy1p4l4toJvwCSjLCmzboFDumnSjHhp0eqNyxQdXeIc8lshxW2SP64BqRypYkXucyw+j8QNOz3Nop41FedPnw5uaLrxjbNGIphW+p7/3rnn3r0CYGCLlARq05C/Nl/7frg5NZoIhdy/59hLApzZESZyg87meLPj+PoGfFfSgtkQVyb3CPz9wcEp/AZPxc7Y0fx/QWyCGdeTYLJ2iPm4r+5vKA4RPEDbBV8Byp5bxBYLm+V7HTW5XqiqrVwcP7Q3FSkA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199018)(66946007)(41300700001)(38100700002)(2906002)(316002)(38350700002)(66476007)(66556008)(8676002)(4326008)(8936002)(478600001)(5660300002)(7416002)(186003)(52116002)(6486002)(921005)(36756003)(6666004)(6506007)(1076003)(2616005)(26005)(83380400001)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fw0RFDsOfQ5kxKJyBHKVW6mJl/aAshaak1T4PekkN0o82uzA7nRA2SF/+kb7?=
 =?us-ascii?Q?IJnhb2EwnigD8LQyZwBkdAseu/GCjuFeWygwRmcoiljo+XST5TeTEWqlr4kB?=
 =?us-ascii?Q?oYvpt1yvCrv8/cG8pf+KXurB8hxYzghuvGkbFvePZfhtRyP5+efb8DxQP+fP?=
 =?us-ascii?Q?AjemsBB0SyNPDeXdiAInBwcTIV66roR3iLW7Sf4HhaVGLdzDbjpKUZd4K6HJ?=
 =?us-ascii?Q?bGAsQNptOVT2b0GzTSMkpLtIMEImqL5Wy5c7CFoZe0blZtI8O21Rmr/HzqEU?=
 =?us-ascii?Q?dY+Db/xe/K0bdKypovuD7ilqm8zNn4zxTCP0cujboU1Ah4I19deioJ8VHlMR?=
 =?us-ascii?Q?mkstlHLxTxZ7+5zHzImqXJ0IaSUkR3CLfL3AI/rDMyX2kzsfQHxTDtmdAYgx?=
 =?us-ascii?Q?TRaz4cL1kYqIwyrmDtmurfGBPRhnPqAn2Y8I37byKivADLH0CjNkXa4lkXoY?=
 =?us-ascii?Q?StT9R8ZJJZJyUyseDq9BjBjvgAW0weJbzfjTp1zqCRi7GbDd72CxVh+ym3iV?=
 =?us-ascii?Q?SGSyunD65bzXSRUnUsK36KjzufISFIjDGJg8AaIwjPi03bNgynSD/1vhBox5?=
 =?us-ascii?Q?njbfv4mp4whUpoLL1LhChYwbzVaM2xyjLTen8aIY4FMJxMiwTysCCfN8Hthp?=
 =?us-ascii?Q?422NH14zK/JTLhN7gjUPCkaYZIP2i8jZ2gAOU7BCJE5r4a/Tww1szj0hmYKE?=
 =?us-ascii?Q?0v1BNrofGM8ZEr2IkzKWvljvKfcko6FjTUa7/Q3gcAm+VsMhbzXF2Dut9fc3?=
 =?us-ascii?Q?9XjHpEHOnYjS8vrzYrNSN0JfH4Eg5MRTA+kJF195XUVCjaK5geGDGjkZNsb0?=
 =?us-ascii?Q?O9PgT1/jt7HNHGKW+qnQ3lqbaBO3qHL14atY6Ezjma9Im8SawyrfX7rsglon?=
 =?us-ascii?Q?F2hD+hfhQBUJuCfj5oV4HDyyKks/atKhgZ8Ux2DlfNKliddX3fhnqHxjjwtw?=
 =?us-ascii?Q?NngPoPJKH+byfzbbPXCYXQHpBTEftKMVx7WrZFOiGAlwI8DpUwLdKGpIlPWl?=
 =?us-ascii?Q?9AKUmQ5U6/VwKwgHbbz+ZLFLi1nlez56T9A1TIpcZ+uwQENo6Kp2t7ib493Y?=
 =?us-ascii?Q?9JqCSKumuu6p52zz+C5m7YW1K+yzgNUwUGB5WskH9s7J9lbKw6wYvX8VocHd?=
 =?us-ascii?Q?Cy0PeyrIYIHofH5iHR1Co8mULBF9BsjBSUNdEpMHsVsetDGmAfGfqQhrnvOv?=
 =?us-ascii?Q?AqyPN7BCoHcx8I2RU1pD2aLJDQauoAhkkdGelXRUlW/CqACdIVAsL2wcKLEn?=
 =?us-ascii?Q?fY6wJsVm0X7rucFiD2I6EHqzbmBs+A2KXG7/GPCtCAVekHlYm7+fdsJWQ78o?=
 =?us-ascii?Q?9ozBwOzAl+5NFPWbGFpRjBBLrFzUiDHtgoxLdNL0KJnY6IkjkB1qWfC7zEDl?=
 =?us-ascii?Q?DK9W/qBOXGqL1r/T72tTC7kmxp4YYdeHW0y+muAospql0s521BG6oMUKlwTr?=
 =?us-ascii?Q?e+h30iq3yv59PUQcfIH2FdONorkrjEH7HKoWY/u2212CkPoVl9vV7HusmaJ1?=
 =?us-ascii?Q?sNmWh4n3SCPTrT1kqaUuBVqOf10Qos1vDIecrvEjpJIzefmwhFGLeN/lHkeN?=
 =?us-ascii?Q?Zd3fGI3qbe+V03Ypy67RzGVrcLMbUUcTdTT6fmdkq/XZBT/NBKdYhG1VdbJp?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b606c6b-6896-4e16-2532-08db254d5f02
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:04:04.1863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATzy78OEBYXLJo+jlmw/08SgnQMPGboWB2CrmoWTUKBbgjGKvZxbpjrznkAzPM8bh/IX73zkaYLIiTMBzG1/dxa2gEB2ZgC5ieKmpinApNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8629
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces all instances of ENOTSUPP with EOPNOTSUPP since ENOTSUPP
is not a standard error code. This will help maintain consistency in
error codes when new serdev API's are added.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v11: Replace all instances of ENOTSUPP with EOPNOTSUPP. (Simon Horman)
---
 drivers/tty/serdev/core.c           | 6 +++---
 drivers/tty/serdev/serdev-ttyport.c | 4 ++--
 include/linux/serdev.h              | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..d43aabd0cb76 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -366,7 +366,7 @@ int serdev_device_set_parity(struct serdev_device *serdev,
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_parity)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_parity(ctrl, parity);
 }
@@ -388,7 +388,7 @@ int serdev_device_get_tiocm(struct serdev_device *serdev)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->get_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->get_tiocm(ctrl);
 }
@@ -399,7 +399,7 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_tiocm(ctrl, set, clear);
 }
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d367803e2044..f26ff82723f1 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -231,7 +231,7 @@ static int ttyport_get_tiocm(struct serdev_controller *ctrl)
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmget)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tty->ops->tiocmget(tty);
 }
@@ -242,7 +242,7 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmset)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tty->ops->tiocmset(tty, set, clear);
 }
diff --git a/include/linux/serdev.h b/include/linux/serdev.h
index 66f624fc618c..89b0a5af9be2 100644
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -249,11 +249,11 @@ static inline int serdev_device_write_buf(struct serdev_device *serdev,
 static inline void serdev_device_wait_until_sent(struct serdev_device *sdev, long timeout) {}
 static inline int serdev_device_get_tiocm(struct serdev_device *serdev)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
 				      size_t count, unsigned long timeout)
-- 
2.34.1

