Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E65E48A4C3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346122AbiAKBKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:10:36 -0500
Received: from mail-eopbgr80128.outbound.protection.outlook.com ([40.107.8.128]:23079
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346113AbiAKBKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:10:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmzDbqxsKPsF186hQ8sJTwnnMv5Jh8i3VyohKdwy5SYJgjniBzYvZyAllEtxQGd5rP+FsAAhw6JFDbv+gvSR5VNvOt5NVQi0KtkH4OCWa4x39mgl8dk0lIRKD6jpKQ6ncUupIdswRMPtD8PjiU/mpnpMwyt5zSrEJt+Nu+gnX6rJ3kOIMkUpoMtTKa9w4EAJwEhCjkbEZx5MdS7g2loUvTjLJjYoOS17YWdxhJhcqL3yIFl0PlYwu1dfiYmb4oNM4BtibI+CKm13CamXf3wMb751Us10yrp/BlqCDEY7c4g1UR7x0i0VWIeTMvn8UVX4agiO1RoYAQC7ARGen68kvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAIutmF1ql4GbCg/6RJqQM+yRgSIcS6rWjDN7zX1P5c=;
 b=Ret7j16bDHBS7xhkRFZCDMEbgNgSqbAHIK6bjIcUZDEMMuVjqJTi47unvYJtTHoDGvI0jLgKiYvJEDciT4+mLpZC8m6Fgq26Jz7szdj6VSyYPzxf7KhYBAgFrs1OF2WK/X6u+xlzscPhVhrW1BzpzR08PghwNAF1GtDUOwVQikfyx5auVRGySxwYTpJZqWIM7EiSOm3sgPADJdGl9j9TCONLPMejfDl4f45sGb4STa7NktINkSz+UxVfwi8xIrmJbPJsAOTpA2KVO+0nspR4WlXmCE6cwnqefKSacnD9E/8zi0IECdIiuYmmZ55QTWiM5Hds7yG/KhUgBSkGsmhAMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAIutmF1ql4GbCg/6RJqQM+yRgSIcS6rWjDN7zX1P5c=;
 b=m5B5cMgXx0ZpF3WsKM83s/teQuwQm771qGmXqPqB/ATuimX7/oLUSUooqM5fmzzRQYgXnMJlDYx8cr7jxneNaDvky6Sa886KlXM95udm2V/Gz58SNG9CqfgYZx/1oAfxgcxdhvNPFexkKl0hdRHMAv+THA7+Ayw630ScDPVRV8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM0P190MB0753.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 01:10:33 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 01:10:33 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: Refactor get/put VR functions
Date:   Tue, 11 Jan 2022 03:10:14 +0200
Message-Id: <20220111011014.4418-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::15) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 010bb0ec-366f-4bd7-7abd-08d9d49f2ade
X-MS-TrafficTypeDiagnostic: AM0P190MB0753:EE_
X-Microsoft-Antispam-PRVS: <AM0P190MB07539E959674E33AB578FD6593519@AM0P190MB0753.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:185;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQ5vfqJVSLSUu/6kh49zTKUofNLrx6zFi4Zl/AKWXk/lAbfxWPUT0okLFZ6Qfvodh4LoSxnXyU+HkfJzg8PpaLOmjvz+4Gn63MsDzN4abYnbeLixYKKA3W40+WYEipLnO6NJaByxKK00YZQ/pq0PAKlHtK8/69wY46UYM7QPvkRjYcRSl51EXmSWI+xSHGHYDW7OFKX+e+T8wbKLpFyM91zCMzBZjxUjqifZ51vJkV+IETMDfS8NCQWjlVfx4zA14gfu6kDoetBPO5yj8M9U2niFMqDVP1alG5YynDtXZhvwYO+P168s0jJHAyewSLq1uIJqfI2Du2NpoHtnxoXpd/o3gQNeBeB6WK1ETcVecyeHvYwu0zr4z2bcurBUWWHrANKP368+/6RMMbAiVFlPh3GfNwAiB4JkY3C3laN4Eri8PddIkEFiX/QmrupEgz56hhmZ/BQ5q/SQsc8U4DAkGDbGq34QCWqPcbMm5G3phl7uIWXyiOu36diR8n2kHln2p9YnmUreb71uO+hq+rKskzn/CxXJJNp38nQaUaa+VD0hdlSPg5mKuA+0PktbPY4vyKcNGYCDOLkyAmdEC7Rjr4kZWjdoxeazVpIRQzzrbaTNzRYzt6qWjIeTpCs6qsQeriKK/mXLFvLz84khEw+6SkYZXHRsyCMESN0u+vNJ8VJXtq+C6KsYX73IDuaZ9dgxntz88ioCJRif8kQN1e7VNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39830400003)(1076003)(83380400001)(6486002)(54906003)(66574015)(36756003)(52116002)(66946007)(8676002)(86362001)(316002)(8936002)(6506007)(66476007)(66556008)(6666004)(6512007)(4326008)(2616005)(38100700002)(5660300002)(2906002)(38350700002)(26005)(508600001)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8auurn9/6x3L7GtKF4ApZ23uAs40N1iqpfy/cqDGrXwPE9g+D09itRwXG9U?=
 =?us-ascii?Q?kYOhm8bOyp2F7QrUfiOlbgbKIw2xJZq2OO8KePtee/oF0HqEMq3uRFw6+i9S?=
 =?us-ascii?Q?kAZoIlPE/r7WIfRjJi0GdKoTngbO6OT0vyObTDMmKKADxHOhvaaHETc8MXQW?=
 =?us-ascii?Q?l8q+Kji4U03u9WrTwH1vT5ejyFMHOVgzW87r+o2wI2KEBGQesUb3rJKQNPq7?=
 =?us-ascii?Q?dnSgEhvB++kOfVm5w2W65SilMTrpRT/fTiSBC8wapA14w52eSmB22AO4wY4X?=
 =?us-ascii?Q?fiRQu9RSf1AJ9CHfqLkXewmvx5Y7MsC8wG9jo7HHRL2V2RjA4zjd/vgdJ3i+?=
 =?us-ascii?Q?kcaw0LtCTfraSlR5oQRyYtXmwXcQnNSwK/8TseGV3MwKIVVwxVRk5Hw4IUNn?=
 =?us-ascii?Q?bnQeo/4VZLiCijzfLhzvOfuSqcalCgHBf3pxP5IBdokJF0A0px4RAd7yWMtV?=
 =?us-ascii?Q?8I7zxWInnWygI102KsJNjfP+fM2f6nXNxpvj7N90xR7ex4icBec7NLXTVvkV?=
 =?us-ascii?Q?hSSLkeOH8w7dHvpMQ7bvuextlMdK85AHE14amHprtwO82HteM3AeE41Rdo1f?=
 =?us-ascii?Q?HyeWnV5f2XJSTLUWGgs8IHRXnlM9TmbxGKqmdEyGQxqhMbnF1sB/iHGzImiO?=
 =?us-ascii?Q?gUOJaiXNuBGsqWl4qjONCxGY7tvpJNfWXjdwbGB5Z/ovk1mRiAE4JOrDvhoc?=
 =?us-ascii?Q?qLt0icY3uukw29ZyAwrbGUFzYCmmOdw5064hKSIsTwvR+d/5bQMT/ACAp5pa?=
 =?us-ascii?Q?PWnn8NA9Hv/b6HCe5ZO4eNcNRygQFytSKwdBtgjwZPEgHVQQq1dpSMc2lLy+?=
 =?us-ascii?Q?Mq9KPd2aAZHQTzCbfDgCB4KUkqWkip0kSN0nKRTQDTQnEuWAPMTrjWAuSkjU?=
 =?us-ascii?Q?VJSC1sfQl3BOhh5MZUvLi2HzEMY3SOU6NE9kAtTrQzDMumffhb+aymAnvJ1Z?=
 =?us-ascii?Q?iYpt6ix8lrNaznFE2Tfm7b0aioE42BABcZGnS7vCuZEh08pUwimiYOAMaO+k?=
 =?us-ascii?Q?UTX63G+MJTpBu8e3FKf9x7Vrvgb0GUgHTQM0oqbHAcu0QFJeFX/ZqsHdwM1W?=
 =?us-ascii?Q?ygF2CHHo8EL98Fo0LKLfKLcCLahU2jJkqHRK/q89QMed4VUgniFrELxJ6ZuU?=
 =?us-ascii?Q?pMHAu2S7b2bzCzXdbvWRixJY2/qeJA/fAeQ1ADnEN32cfwAMAb2tdfumBEx4?=
 =?us-ascii?Q?DC8S7dwknWzi8OcbySARFt9+Ul0h2ZzGqmak+LsxnTNpArXa6nrNBzJVAsOF?=
 =?us-ascii?Q?niXiX+zXyyrQt5/IpTAqs39Zm1QgZNfrVRYTQUKLZFJZJAY7EfQ329IueMCb?=
 =?us-ascii?Q?zSK5X84ejC4q3F86VJxeAqr2BZQa+1Py+3h6MkwuDQfqNOtUg06hwzHqG+Ys?=
 =?us-ascii?Q?2q2kwFrx1kgrhg244nlZjUQrIXExzKBnJru2ItoI+UEsvyL1pRnHwMhwzAAY?=
 =?us-ascii?Q?Sj+SsxZ+9Z6BHpHgFmFk4W4vU6P7CX+Km7EEbfkMq5zWKotkpf1Rk36l5Llu?=
 =?us-ascii?Q?63G54diXWc98mSeIaWqwZ8G8Dq2+KCyq5NcHsL0Ud1VzARCj/HlTA9V0uclJ?=
 =?us-ascii?Q?PwvUe/kE7Z5XQQLRAGK7XPBehhNZN/pG3LpC/PjxBZxt21okiL9h2Cqn3/jG?=
 =?us-ascii?Q?KEGFZfereo6VxnfHCqsbI0Idk4XZW/lKBiXzaOUNUV86kKTQ8KqNZEMoxPT3?=
 =?us-ascii?Q?a497vw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 010bb0ec-366f-4bd7-7abd-08d9d49f2ade
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 01:10:33.4997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EX52ybYBVgwoNewiKB0xe0CtZIKmtGbjoaNNMGYCC6IxDwWOK52Au59lu/t61cliorPG0hFejUty4h/DWRKG8LdwSU8ab0cGQN4v4mkD2Vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Use refcount, instead of uint
* Increment/decrement recount inside get/put
* Fix error path in __prestera_vr_create. Remove unnecessary kfree.
* Make __prestera_vr_destroy symmetric to "create"

Fixes: bca5859bc6c6 ("net: marvell: prestera: add hardware router objects accounting")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router_hw.c     | 32 +++++++++----------
 .../marvell/prestera/prestera_router_hw.h     |  2 +-
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index 5866a4be50f5..d5befd1d1440 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -47,13 +47,8 @@ static struct prestera_vr *__prestera_vr_create(struct prestera_switch *sw,
 						struct netlink_ext_ack *extack)
 {
 	struct prestera_vr *vr;
-	u16 hw_vr_id;
 	int err;
 
-	err = prestera_hw_vr_create(sw, &hw_vr_id);
-	if (err)
-		return ERR_PTR(-ENOMEM);
-
 	vr = kzalloc(sizeof(*vr), GFP_KERNEL);
 	if (!vr) {
 		err = -ENOMEM;
@@ -61,23 +56,26 @@ static struct prestera_vr *__prestera_vr_create(struct prestera_switch *sw,
 	}
 
 	vr->tb_id = tb_id;
-	vr->hw_vr_id = hw_vr_id;
+
+	err = prestera_hw_vr_create(sw, &vr->hw_vr_id);
+	if (err)
+		goto err_hw_create;
 
 	list_add(&vr->router_node, &sw->router->vr_list);
 
 	return vr;
 
-err_alloc_vr:
-	prestera_hw_vr_delete(sw, hw_vr_id);
+err_hw_create:
 	kfree(vr);
+err_alloc_vr:
 	return ERR_PTR(err);
 }
 
 static void __prestera_vr_destroy(struct prestera_switch *sw,
 				  struct prestera_vr *vr)
 {
-	prestera_hw_vr_delete(sw, vr->hw_vr_id);
 	list_del(&vr->router_node);
+	prestera_hw_vr_delete(sw, vr->hw_vr_id);
 	kfree(vr);
 }
 
@@ -87,17 +85,22 @@ static struct prestera_vr *prestera_vr_get(struct prestera_switch *sw, u32 tb_id
 	struct prestera_vr *vr;
 
 	vr = __prestera_vr_find(sw, tb_id);
-	if (!vr)
+	if (vr) {
+		refcount_inc(&vr->refcount);
+	} else {
 		vr = __prestera_vr_create(sw, tb_id, extack);
-	if (IS_ERR(vr))
-		return ERR_CAST(vr);
+		if (IS_ERR(vr))
+			return ERR_CAST(vr);
+
+		refcount_set(&vr->refcount, 1);
+	}
 
 	return vr;
 }
 
 static void prestera_vr_put(struct prestera_switch *sw, struct prestera_vr *vr)
 {
-	if (!vr->ref_cnt)
+	if (refcount_dec_and_test(&vr->refcount))
 		__prestera_vr_destroy(sw, vr);
 }
 
@@ -158,7 +161,6 @@ void prestera_rif_entry_destroy(struct prestera_switch *sw,
 	iface.vr_id = e->vr->hw_vr_id;
 	prestera_hw_rif_delete(sw, e->hw_id, &iface);
 
-	e->vr->ref_cnt--;
 	prestera_vr_put(sw, e->vr);
 	kfree(e);
 }
@@ -183,7 +185,6 @@ prestera_rif_entry_create(struct prestera_switch *sw,
 	if (IS_ERR(e->vr))
 		goto err_vr_get;
 
-	e->vr->ref_cnt++;
 	memcpy(&e->addr, addr, sizeof(e->addr));
 
 	/* HW */
@@ -198,7 +199,6 @@ prestera_rif_entry_create(struct prestera_switch *sw,
 	return e;
 
 err_hw_create:
-	e->vr->ref_cnt--;
 	prestera_vr_put(sw, e->vr);
 err_vr_get:
 err_key_copy:
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index fed53595f7bb..ab5e013ac3ad 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -6,7 +6,7 @@
 
 struct prestera_vr {
 	struct list_head router_node;
-	unsigned int ref_cnt;
+	refcount_t refcount;
 	u32 tb_id;			/* key (kernel fib table id) */
 	u16 hw_vr_id;			/* virtual router ID */
 	u8 __pad[2];
-- 
2.17.1

