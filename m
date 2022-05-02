Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CCC51772A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 21:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiEBTMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 15:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiEBTMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 15:12:40 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2125.outbound.protection.outlook.com [40.107.113.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F26EDE9A;
        Mon,  2 May 2022 12:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dotncbRWEQ4rXv68qV4JEuN5YSFwfbiT1RoP6Azjr1PwBYQo8ZGsVnPNHCa55heTH5dSBpGDaRCZ+EMF9PNaUZPmbpBq2M/TWEXEtVuPupr/zK6qBLDEVbC75TtFOPOy5MZtB37l/z079E36kdLOfQbyFALUPyQejSpSe3lYseyhm1mRjxQlat1cjtPjPXgiGAeMuswHsndQqqaMl7nGEeU6uBNwYT9x4HR4i3Tr7LIyGXydiNfN/D26izZIDNNQEcsazmZAT0r1JOWWCG9AqCAZSPmvFU73JE4h1/nS5Zy36qR7TcrlWbXDbc7WrIgySv0mrY5y8rkdxYOZnsreeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4qAenCjxyF0nIuOGAxQRa4xnXE90/5GsHIHQNaa6ms=;
 b=Me4WKrQT4cSUXx7k9BMc1TF7GkIpVauwH/EvjWCGDeC19dwuRzh2T3QzAjelb3bQRLoIDQJptUlkJGkFwr0YN7YvRQ/TaV6odNz/25spp2EO7tGrtmiLP2V3qp+5xrcOrp67RaLvVk2NJlef6nET4l7NII6g8DjsaAmj1goKyFCAFBShONlqndUPDscpyl/pvkuXhoyhoSjKWD4SCI7OdU31Yw3VkESGLeO8YUPjmK6ygNO+9XrZN7RpJJNLLR4yDgpgUkymbu2THK43bprCOgC3w/1RfOvBGLqAFXed5CXzSgMhpVOjMWIhhYpjmQpmXequ014jKw3UyTJ33TQqjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4qAenCjxyF0nIuOGAxQRa4xnXE90/5GsHIHQNaa6ms=;
 b=aECFdoIub2SiV+qZmuoZCRyn4zIzz7Ju+K+TqMn3uwLnDVETzUALq1WLIxj2zR1tJ0XOkG5P1/cR/p2k7MMCRLj4kGR80ro973ShKuShun87DYUsUjKaSTu5PMjImO6aPik00JyMxlSFrdI81qN6hOPhwUHxwxdZC1tXXsx4BAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYCPR01MB9570.jpnprd01.prod.outlook.com (2603:1096:400:191::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 19:09:05 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.012; Mon, 2 May 2022
 19:09:05 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v3 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
Date:   Mon,  2 May 2022 15:08:49 -0400
Message-Id: <1651518530-25128-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0306.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::28) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3c870f6-fac8-48a2-18b7-08da2c6f3a0a
X-MS-TrafficTypeDiagnostic: TYCPR01MB9570:EE_
X-Microsoft-Antispam-PRVS: <TYCPR01MB9570BB60FBA99A4DFE048331BAC19@TYCPR01MB9570.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1dZL3Y/3lvCchhT3IoBn4PChbT6SKAmMy0oDBzecF7c7H3ba/udbuZlONrscgulhM4muZRnYSihHQPuQ994KSiuxiVPISWPxtcyT31b5gJv6oimak9h/2BYQ/qw4L+J28PE80yoBrDJX2S24wRVa3k3BO4MUfOO2HDR13I/fxyWTs2kvtxC2zz0nJuWu6JLaRIFdb0iHiZCTI03j4nrbpRpwfUncetJHgWDegRJzK4yES/AH5Ie/eCmIUBhc0FgogoC58SW+f479vr+qtIqqFfcPlJ9EVEZ+W1OaeFzyb0sM+e0Kq5OsAIBix4wXQEBU4BLRUgfmYYTxdAt19iKPBGgb0mNZbzpADJ5RhjKqrI4s+3DlMFGJmD6skO82Z0IHelNE2U4OBafgxr8hUohl37TZn7KSsEv/27IHUEvAImkhBKpdc4g4qpQv8IKYeVtPvCuHe/VwOOu9jHhyvjgncLC+UdVZOD9lCO2ZpVkFjOhw+8Qvzr/iV3hESOlf8VaTiKTI++v3jmIzXj9GXOgWYNIbQchJ4mSDWzGWob7zVfpY9JeY3KfOgrl2N7LHgt6jm2Hi1S30fQuKJeIhtzSJadgrNII3QDOnJ00OtYOr3bpAmJZv1NTtYVCvc7uAjz0VYyyPPbOFhKb4j0LNBWuvKDsQQwFxnNOU2y7cMrG8NaJe/UYK3hGZ5ab/7L2HFTBpIVJ959TVF/l9JOLhpLD8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(508600001)(8676002)(66556008)(83380400001)(2616005)(8936002)(6486002)(66946007)(86362001)(36756003)(2906002)(316002)(52116002)(6506007)(6666004)(38350700002)(6512007)(38100700002)(26005)(30864003)(5660300002)(107886003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?41ggzTeP1qCzU3jKMOtFDC14/JfzZGlgQIgOELwBc6KzW9rElwWNZDgAzIaS?=
 =?us-ascii?Q?UvW12EJVwuBVwayKajnx7+/lMkVynFY467DBUO/mTu1Wcyw3DkxfZdbmQDvj?=
 =?us-ascii?Q?DXpohusMRkxLGkq5EMT+7M50/kqL1O6fQHEmcK69RlkYGvQx0bBsk9escIMu?=
 =?us-ascii?Q?+0506c6MHLiXmDyNKQ0v4blWC1QMfVMqJkbdcAYN8XLtbE5uk7EKY38aWWf4?=
 =?us-ascii?Q?vdmsMag38+AWZi2VqIVd2hc6Hz33/FjGeqaL1rTGAqWHc7/RSeGY0MxGE7Yd?=
 =?us-ascii?Q?b1oCMAwqOeVzfFGL6germ/38rDmqJ+4LTQNE4NNbXi9Z7UrsKkbR0x+uxUdn?=
 =?us-ascii?Q?cXOfMMwLiXYii8qoVxkmMN/nRb/OqeThrK8pDwP8tka+nqT80F8MLdLZohGb?=
 =?us-ascii?Q?DLowsjgFWBcoM7cxSZi21Mjo7xTiAMSfzTinIRhcYRyAzLzjSzbVJFgHwgiF?=
 =?us-ascii?Q?4YMQqq/XoHYKbYdvsJ9L2NYyT93vik88sTHjbwmoxM5c1R7OmETO9Jw3hsXC?=
 =?us-ascii?Q?mqZDdKA3uERLoMnK82Gl/eLpaNCvOB3SuLFW+zhGZ/YPb13mG4nnE6SyhsfK?=
 =?us-ascii?Q?fuoiR6qhfsN3RjIs+VNVs7JUD7KdwyddsW6mGuBdjb/Vu/QPw97CTDBHUjJ0?=
 =?us-ascii?Q?XOfLE/npPTC93XiW4mWZgkbwoSM2S9SMkqRbOdGJONiRxFgETwmo4bkjVi71?=
 =?us-ascii?Q?3dnefyN0HeQ0/BlYxN1kgKbWyNQDBJvDr+ipimH8QsPnrpEc8LcRVMGyHge+?=
 =?us-ascii?Q?TTz044ODzC/jExbov0SbYTqdr4K6vGGYw8hqctxJXc1nEGr/HBCh4eim2L1H?=
 =?us-ascii?Q?G7Mdi0fqdeQpFPy963jS86IZSHXIEBveVrcAfjSL6uvheRbN1PjQecW5QjO5?=
 =?us-ascii?Q?BN2NTuM4zJsLTunnCc1hktqr6d2uAobNi7HFfd1b4undg9aqlEuMn2s0OuU9?=
 =?us-ascii?Q?5EtYd9/ijoJRzbBOrPOiTK5JISI/eGYI5p/t4CqUYOlJLiKnWq0UTFwEXaWd?=
 =?us-ascii?Q?siEJUExakLJFrXjjzOdj0jmO+f2XTDBtOona8JGZRlp94n7J89aSM+NShqlW?=
 =?us-ascii?Q?aScaZmqrniQ62JtqjbheIB+BzylNHphsdMYGQkHkRy2fMVnHsMfIcu7aeV8h?=
 =?us-ascii?Q?EXZLvp0CTw/DSLbmmr5c1As7X3wW5yIRsdofjyBtSirWikCfFbdnAOkGnBVH?=
 =?us-ascii?Q?yHmBNUndXlgRkUL6ZUhUj31jHe0al7Swf22cCdeQfk65R+lYTscVXAMZ2zPh?=
 =?us-ascii?Q?UyGoWUL31kOBzk8DNygCtND8elR6caYGFjPSJyb29UIDCu5hEy/7rwZQEF0e?=
 =?us-ascii?Q?ULja+SXHsJQDZNrOfy5zDDEI9AojXxpeHE4xixGnp+ADP/FkWge8X/NrkjqW?=
 =?us-ascii?Q?kea75HDqz7CZfeuROZSXXxDmdEcFSm7HR59LKvaHVTZ8eGtMNI1pnNEdly0z?=
 =?us-ascii?Q?KMhr4PNuEYkanDwQFumQYwH/1kQPA/hG6mNjZImkNGG9TzxBuSl4IMB4R3S9?=
 =?us-ascii?Q?FzaQFRQjA8BvQmNSdV9DJERKepUVU68AwUMu2DZ8bp5kwCl58t/RksVancWs?=
 =?us-ascii?Q?jnN/lLNtuAqdGEQrL6tTJQjTcVVV97phwtHPO5z/sCVvkSSkboFNtJxwaEyO?=
 =?us-ascii?Q?NrX3GIJKjxLXF8Ede/8+esWFhK+gCfXdgbXEgR+R18UuEi6cKLj4Tv0P//7D?=
 =?us-ascii?Q?QoUhWLwHFw1dRRXN2Uv0SexEDaNa956zJbsxsyTjKyY+0YPawT9e7MM0BIym?=
 =?us-ascii?Q?/Y2uwnEJp3u9v2vd9J2BWWK7mhvEr24=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c870f6-fac8-48a2-18b7-08da2c6f3a0a
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 19:09:05.7922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0aE0N5CWIbO2JwOoT2zX7Zug0Zs46YeGx3DuGPiZHpzrxI2sfTbfG1jJEvZqcl/EVo5Cj/ZZUuhONPh6CRjkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9570
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
for gettime and settime exclusively

Signed-off-by: Min Li <min.li.xe@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
changelog
-use div helpers to do 64b division
-change comments to comply with kernel-doc format

 drivers/ptp/ptp_clockmatrix.c    | 295 +++++++++++++++++++++++++--------------
 drivers/ptp/ptp_clockmatrix.h    |   5 +
 include/linux/mfd/idt8a340_reg.h |  12 +-
 3 files changed, 205 insertions(+), 107 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 08e429a..d8c7e80 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -239,73 +239,101 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
 	return -EBUSY;
 }
 
-static int _idtcm_set_scsr_read_trig(struct idtcm_channel *channel,
-				     enum scsr_read_trig_sel trig, u8 ref)
+static int arm_tod_read_trig_sel_refclk(struct idtcm_channel *channel, u8 ref)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
-	u8 val;
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_SECONDARY_CMD);
+	u8 val = 0;
 	int err;
 
-	if (trig == SCSR_TOD_READ_TRIG_SEL_REFCLK) {
-		err = idtcm_read(idtcm, channel->tod_read_primary,
-				 TOD_READ_PRIMARY_SEL_CFG_0, &val, sizeof(val));
-		if (err)
-			return err;
-
-		val &= ~(WR_REF_INDEX_MASK << WR_REF_INDEX_SHIFT);
-		val |= (ref << WR_REF_INDEX_SHIFT);
+	val &= ~(WR_REF_INDEX_MASK << WR_REF_INDEX_SHIFT);
+	val |= (ref << WR_REF_INDEX_SHIFT);
 
-		err = idtcm_write(idtcm, channel->tod_read_primary,
-				  TOD_READ_PRIMARY_SEL_CFG_0, &val, sizeof(val));
-		if (err)
-			return err;
-	}
-
-	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 tod_read_cmd, &val, sizeof(val));
+	err = idtcm_write(idtcm, channel->tod_read_secondary,
+			  TOD_READ_SECONDARY_SEL_CFG_0, &val, sizeof(val));
 	if (err)
 		return err;
 
-	val &= ~(TOD_READ_TRIGGER_MASK << TOD_READ_TRIGGER_SHIFT);
-	val |= (trig << TOD_READ_TRIGGER_SHIFT);
-	val &= ~TOD_READ_TRIGGER_MODE; /* single shot */
+	val = 0 | (SCSR_TOD_READ_TRIG_SEL_REFCLK << TOD_READ_TRIGGER_SHIFT);
+
+	err = idtcm_write(idtcm, channel->tod_read_secondary, tod_read_cmd,
+			  &val, sizeof(val));
+
+	if (err)
+		dev_err(idtcm->dev, "%s: err = %d", __func__, err);
 
-	err = idtcm_write(idtcm, channel->tod_read_primary,
-			  tod_read_cmd, &val, sizeof(val));
 	return err;
 }
 
-static int idtcm_enable_extts(struct idtcm_channel *channel, u8 todn, u8 ref,
-			      bool enable)
+static bool is_single_shot(u8 mask)
 {
-	struct idtcm *idtcm = channel->idtcm;
-	u8 old_mask = idtcm->extts_mask;
-	u8 mask = 1 << todn;
+	/* Treat single bit ToD masks as continuous trigger */
+	if ((mask == 1) || (mask == 2) || (mask == 4) || (mask == 8))
+		return false;
+	else
+		return true;
+}
+
+static int idtcm_extts_enable(struct idtcm_channel *channel,
+			      struct ptp_clock_request *rq, int on)
+{
+	u8 index = rq->extts.index;
+	struct idtcm *idtcm;
+	u8 mask = 1 << index;
 	int err = 0;
+	u8 old_mask;
+	int ref;
 
-	if (todn >= MAX_TOD)
+	idtcm = channel->idtcm;
+	old_mask = idtcm->extts_mask;
+
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE |
+				PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Reject requests to enable time stamping on falling edge */
+	if ((rq->extts.flags & PTP_ENABLE_FEATURE) &&
+	    (rq->extts.flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	if (index >= MAX_TOD)
 		return -EINVAL;
 
-	if (enable) {
-		if (ref > 0xF) /* E_REF_CLK15 */
-			return -EINVAL;
-		if (idtcm->extts_mask & mask)
-			return 0;
-		err = _idtcm_set_scsr_read_trig(&idtcm->channel[todn],
-						SCSR_TOD_READ_TRIG_SEL_REFCLK,
-						ref);
+	if (on) {
+		/* Support triggering more than one TOD_0/1/2/3 by same pin */
+		/* Use the pin configured for the channel */
+		ref = ptp_find_pin(channel->ptp_clock, PTP_PF_EXTTS, channel->tod);
+
+		if (ref < 0) {
+			dev_err(idtcm->dev, "%s: No valid pin found for TOD%d!\n",
+				__func__, channel->tod);
+			return -EBUSY;
+		}
+
+		err = arm_tod_read_trig_sel_refclk(&idtcm->channel[index], ref);
+
 		if (err == 0) {
 			idtcm->extts_mask |= mask;
-			idtcm->event_channel[todn] = channel;
-			idtcm->channel[todn].refn = ref;
+			idtcm->event_channel[index] = channel;
+			idtcm->channel[index].refn = ref;
+			idtcm->extts_single_shot = is_single_shot(idtcm->extts_mask);
+
+			if (old_mask)
+				return 0;
+
+			schedule_delayed_work(&idtcm->extts_work,
+					      msecs_to_jiffies(EXTTS_PERIOD_MS));
 		}
-	} else
+	} else {
 		idtcm->extts_mask &= ~mask;
+		idtcm->extts_single_shot = is_single_shot(idtcm->extts_mask);
 
-	if (old_mask == 0 && idtcm->extts_mask)
-		schedule_delayed_work(&idtcm->extts_work,
-				      msecs_to_jiffies(EXTTS_PERIOD_MS));
+		if (idtcm->extts_mask == 0)
+			cancel_delayed_work(&idtcm->extts_work);
+	}
 
 	return err;
 }
@@ -371,6 +399,34 @@ static void wait_for_chip_ready(struct idtcm *idtcm)
 			 "Continuing while SYS APLL/DPLL is not locked");
 }
 
+static int _idtcm_gettime_triggered(struct idtcm_channel *channel,
+				    struct timespec64 *ts)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_SECONDARY_CMD);
+	u8 buf[TOD_BYTE_COUNT];
+	u8 trigger;
+	int err;
+
+	err = idtcm_read(idtcm, channel->tod_read_secondary,
+			 tod_read_cmd, &trigger, sizeof(trigger));
+	if (err)
+		return err;
+
+	if (trigger & TOD_READ_TRIGGER_MASK)
+		return -EBUSY;
+
+	err = idtcm_read(idtcm, channel->tod_read_secondary,
+			 TOD_READ_SECONDARY_BASE, buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	err = char_array_to_timespec(buf, sizeof(buf), ts);
+
+	return err;
+}
+
 static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts, u8 timeout)
 {
@@ -396,7 +452,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 	} while (trigger & TOD_READ_TRIGGER_MASK);
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 TOD_READ_PRIMARY, buf, sizeof(buf));
+			 TOD_READ_PRIMARY_BASE, buf, sizeof(buf));
 	if (err)
 		return err;
 
@@ -415,65 +471,40 @@ static int idtcm_extts_check_channel(struct idtcm *idtcm, u8 todn)
 
 	extts_channel = &idtcm->channel[todn];
 	ptp_channel = idtcm->event_channel[todn];
+
 	if (extts_channel == ptp_channel)
 		dco_delay = ptp_channel->dco_delay;
 
-	err = _idtcm_gettime(extts_channel, &ts, 1);
-	if (err == 0) {
-		event.type = PTP_CLOCK_EXTTS;
-		event.index = todn;
-		event.timestamp = timespec64_to_ns(&ts) - dco_delay;
-		ptp_clock_event(ptp_channel->ptp_clock, &event);
-	}
-	return err;
-}
+	err = _idtcm_gettime_triggered(extts_channel, &ts);
 
-static u8 idtcm_enable_extts_mask(struct idtcm_channel *channel,
-				    u8 extts_mask, bool enable)
-{
-	struct idtcm *idtcm = channel->idtcm;
-	int i, err;
+	if (err)
+		return err;
 
-	for (i = 0; i < MAX_TOD; i++) {
-		u8 mask = 1 << i;
-		u8 refn = idtcm->channel[i].refn;
-
-		if (extts_mask & mask) {
-			/* check extts before disabling it */
-			if (enable == false) {
-				err = idtcm_extts_check_channel(idtcm, i);
-				/* trigger happened so we won't re-enable it */
-				if (err == 0)
-					extts_mask &= ~mask;
-			}
-			(void)idtcm_enable_extts(channel, i, refn, enable);
-		}
-	}
+	/* Triggered - save timestamp */
+	event.type = PTP_CLOCK_EXTTS;
+	event.index = todn;
+	event.timestamp = timespec64_to_ns(&ts) - dco_delay;
+	ptp_clock_event(ptp_channel->ptp_clock, &event);
 
-	return extts_mask;
+	return err;
 }
 
 static int _idtcm_gettime_immediate(struct idtcm_channel *channel,
 				    struct timespec64 *ts)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	u8 extts_mask = 0;
+
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
+	u8 val = (SCSR_TOD_READ_TRIG_SEL_IMMEDIATE << TOD_READ_TRIGGER_SHIFT);
 	int err;
 
-	/* Disable extts */
-	if (idtcm->extts_mask) {
-		extts_mask = idtcm_enable_extts_mask(channel, idtcm->extts_mask,
-						     false);
-	}
+	err = idtcm_write(idtcm, channel->tod_read_primary,
+			  tod_read_cmd, &val, sizeof(val));
 
-	err = _idtcm_set_scsr_read_trig(channel,
-					SCSR_TOD_READ_TRIG_SEL_IMMEDIATE, 0);
-	if (err == 0)
-		err = _idtcm_gettime(channel, ts, 10);
+	if (err)
+		return err;
 
-	/* Re-enable extts */
-	if (extts_mask)
-		idtcm_enable_extts_mask(channel, extts_mask, true);
+	err = _idtcm_gettime(channel, ts, 10);
 
 	return err;
 }
@@ -1702,6 +1733,9 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
 /*
  * Maximum absolute value for write phase offset in picoseconds
  *
+ * @channel:  channel
+ * @delta_ns: delta in nanoseconds
+ *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
  * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
@@ -1958,8 +1992,7 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 			err = idtcm_perout_enable(channel, &rq->perout, true);
 		break;
 	case PTP_CLK_REQ_EXTTS:
-		err = idtcm_enable_extts(channel, rq->extts.index,
-					 rq->extts.rsv[0], on);
+		err = idtcm_extts_enable(channel, rq, on);
 		break;
 	default:
 		break;
@@ -1982,13 +2015,6 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
 	u8 cfg;
 	int err;
 
-	/* STEELAI-366 - Temporary workaround for ts2phc compatibility */
-	if (0) {
-		err = idtcm_output_mask_enable(channel, false);
-		if (err)
-			return err;
-	}
-
 	/*
 	 * Start the TOD clock ticking.
 	 */
@@ -2038,17 +2064,35 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
 		 product_id, hw_rev_id, config_select);
 }
 
+static int idtcm_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+			    enum ptp_pin_function func, unsigned int chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_EXTTS:
+		break;
+	case PTP_PF_PEROUT:
+	case PTP_PF_PHYSYNC:
+		return -1;
+	}
+	return 0;
+}
+
+static struct ptp_pin_desc pin_config[MAX_TOD][MAX_REF_CLK];
+
 static const struct ptp_clock_info idtcm_caps = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
 	.n_per_out	= 12,
 	.n_ext_ts	= MAX_TOD,
+	.n_pins		= MAX_REF_CLK,
 	.adjphase	= &idtcm_adjphase,
 	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime,
 	.enable		= &idtcm_enable,
+	.verify		= &idtcm_verify_pin,
 	.do_aux_work	= &idtcm_work_handler,
 };
 
@@ -2057,12 +2101,14 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
 	.max_adj	= 244000,
 	.n_per_out	= 12,
 	.n_ext_ts	= MAX_TOD,
+	.n_pins		= MAX_REF_CLK,
 	.adjphase	= &idtcm_adjphase,
 	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime_deprecated,
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime_deprecated,
 	.enable		= &idtcm_enable,
+	.verify		= &idtcm_verify_pin,
 	.do_aux_work	= &idtcm_work_handler,
 };
 
@@ -2174,8 +2220,9 @@ static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
 		n = 1;
 
 	fodFreq = (u32)div_u64(m, n);
+
 	if (fodFreq >= 500000000)
-		return 18 * (u32)div_u64(NSEC_PER_SEC, fodFreq);
+		return (u32)div_u64(18 * (u64)NSEC_PER_SEC, fodFreq);
 
 	return 0;
 }
@@ -2188,24 +2235,28 @@ static int configure_channel_tod(struct idtcm_channel *channel, u32 index)
 	switch (index) {
 	case 0:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_0);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_0);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_0);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_0);
 		channel->sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
 		break;
 	case 1:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_1);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_1);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_1);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_1);
 		channel->sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
 		break;
 	case 2:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_2);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_2);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_2);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_2);
 		channel->sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
 		break;
 	case 3:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_3);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_3);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_3);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_3);
 		channel->sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
@@ -2221,6 +2272,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
 	struct idtcm_channel *channel;
 	int err;
+	int i;
 
 	if (!(index < MAX_TOD))
 		return -EINVAL;
@@ -2248,6 +2300,17 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT CM TOD%u", index);
 
+	channel->caps.pin_config = pin_config[index];
+
+	for (i = 0; i < channel->caps.n_pins; ++i) {
+		struct ptp_pin_desc *ppd = &channel->caps.pin_config[i];
+
+		snprintf(ppd->name, sizeof(ppd->name), "input_ref%d", i);
+		ppd->index = i;
+		ppd->func = PTP_PF_NONE;
+		ppd->chan = index;
+	}
+
 	err = initialize_dco_operating_mode(channel);
 	if (err)
 		return err;
@@ -2302,26 +2365,40 @@ static int idtcm_enable_extts_channel(struct idtcm *idtcm, u32 index)
 static void idtcm_extts_check(struct work_struct *work)
 {
 	struct idtcm *idtcm = container_of(work, struct idtcm, extts_work.work);
-	int err, i;
+	struct idtcm_channel *channel;
+	u8 mask;
+	int err;
+	int i;
 
 	if (idtcm->extts_mask == 0)
 		return;
 
 	mutex_lock(idtcm->lock);
+
 	for (i = 0; i < MAX_TOD; i++) {
-		u8 mask = 1 << i;
+		mask = 1 << i;
+
+		if ((idtcm->extts_mask & mask) == 0)
+			continue;
 
-		if (idtcm->extts_mask & mask) {
-			err = idtcm_extts_check_channel(idtcm, i);
+		err = idtcm_extts_check_channel(idtcm, i);
+
+		if (err == 0) {
 			/* trigger clears itself, so clear the mask */
-			if (err == 0)
+			if (idtcm->extts_single_shot) {
 				idtcm->extts_mask &= ~mask;
+			} else {
+				/* Re-arm */
+				channel = &idtcm->channel[i];
+				arm_tod_read_trig_sel_refclk(channel, channel->refn);
+			}
 		}
 	}
 
 	if (idtcm->extts_mask)
 		schedule_delayed_work(&idtcm->extts_work,
 				      msecs_to_jiffies(EXTTS_PERIOD_MS));
+
 	mutex_unlock(idtcm->lock);
 }
 
@@ -2342,6 +2419,11 @@ static void set_default_masks(struct idtcm *idtcm)
 	idtcm->tod_mask = DEFAULT_TOD_MASK;
 	idtcm->extts_mask = 0;
 
+	idtcm->channel[0].tod = 0;
+	idtcm->channel[1].tod = 1;
+	idtcm->channel[2].tod = 2;
+	idtcm->channel[3].tod = 3;
+
 	idtcm->channel[0].pll = DEFAULT_TOD0_PTP_PLL;
 	idtcm->channel[1].pll = DEFAULT_TOD1_PTP_PLL;
 	idtcm->channel[2].pll = DEFAULT_TOD2_PTP_PLL;
@@ -2420,10 +2502,11 @@ static int idtcm_remove(struct platform_device *pdev)
 {
 	struct idtcm *idtcm = platform_get_drvdata(pdev);
 
-	ptp_clock_unregister_all(idtcm);
-
+	idtcm->extts_mask = 0;
 	cancel_delayed_work_sync(&idtcm->extts_work);
 
+	ptp_clock_unregister_all(idtcm);
+
 	return 0;
 }
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 0f3059a..4379650 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -10,11 +10,13 @@
 
 #include <linux/ktime.h>
 #include <linux/mfd/idt8a340_reg.h>
+#include <linux/ptp_clock.h>
 #include <linux/regmap.h>
 
 #define FW_FILENAME	"idtcm.bin"
 #define MAX_TOD		(4)
 #define MAX_PLL		(8)
+#define MAX_REF_CLK	(16)
 
 #define MAX_ABS_WRITE_PHASE_PICOSECONDS (107374182350LL)
 
@@ -90,6 +92,7 @@ struct idtcm_channel {
 	u16			dpll_ctrl_n;
 	u16			dpll_phase_pull_in;
 	u16			tod_read_primary;
+	u16			tod_read_secondary;
 	u16			tod_write;
 	u16			tod_n;
 	u16			hw_dpll_n;
@@ -105,6 +108,7 @@ struct idtcm_channel {
 	/* last input trigger for extts */
 	u8			refn;
 	u8			pll;
+	u8			tod;
 	u16			output_mask;
 };
 
@@ -116,6 +120,7 @@ struct idtcm {
 	enum fw_version		fw_ver;
 	/* Polls for external time stamps */
 	u8			extts_mask;
+	bool			extts_single_shot;
 	struct delayed_work	extts_work;
 	/* Remember the ptp channel to report extts */
 	struct idtcm_channel	*event_channel[MAX_TOD];
diff --git a/include/linux/mfd/idt8a340_reg.h b/include/linux/mfd/idt8a340_reg.h
index a18c153..0c70608 100644
--- a/include/linux/mfd/idt8a340_reg.h
+++ b/include/linux/mfd/idt8a340_reg.h
@@ -407,7 +407,7 @@
 #define TOD_READ_PRIMARY_0                0xcc40
 #define TOD_READ_PRIMARY_0_V520           0xcc50
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
-#define TOD_READ_PRIMARY                  0x0000
+#define TOD_READ_PRIMARY_BASE             0x0000
 /* Counter increments after TOD write is completed */
 #define TOD_READ_PRIMARY_COUNTER          0x000b
 /* Read trigger configuration */
@@ -424,6 +424,16 @@
 
 #define TOD_READ_SECONDARY_0              0xcc90
 #define TOD_READ_SECONDARY_0_V520         0xcca0
+/* 8-bit subns, 32-bit ns, 48-bit seconds */
+#define TOD_READ_SECONDARY_BASE           0x0000
+/* Counter increments after TOD write is completed */
+#define TOD_READ_SECONDARY_COUNTER        0x000b
+/* Read trigger configuration */
+#define TOD_READ_SECONDARY_SEL_CFG_0      0x000c
+/* Read trigger selection */
+#define TOD_READ_SECONDARY_CMD            0x000e
+#define TOD_READ_SECONDARY_CMD_V520       0x000f
+
 #define TOD_READ_SECONDARY_1              0xcca0
 #define TOD_READ_SECONDARY_1_V520         0xccb0
 #define TOD_READ_SECONDARY_2              0xccb0
-- 
2.7.4

