Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723AF3D1F89
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhGVHSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:20 -0400
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:59110
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230200AbhGVHSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZstyQIPgTHv1DXOYyNTR5Aq6Maa5sVVC+CFe/8QLp0YmwN9/KZwod8DUNttZO79Ur8b1m9WtTM9JFwk1ZgcBH/KRC2vY8gc6CiZz5NlGmXx/8eDlfsD2gGJRSlRtqclTnWNr8PojvBeCbq13Ux28nFd0fQ9M3p9e8tojgPMUIbPE+IopfiS/4ypcmrAmFWzf5+g+K7yIdCNRp8lfSfGQQLOVOZlPmvFlulCRS0PKmj7DrXWdxM7BbzEMBaRQhfDsQzB33LMIHevJtsK6sIYZeKkGF79QOO2b9yxVW+JEaKQWkKfSDv9m6bHTMRzWmKSAwwws49bWep7rLd6ze+alQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7Zi2uRmzpQEOh7LvDdQnVAWUHWHUVCLWo+RKsyC9Ag=;
 b=Mj05iWovcprburSLfUV0IsDOoyw91n93pG6DO+ewt2gdbrKhGUbYIjh9ozXL43wD2IFY+VcbwHAux+1/ESaoyUkrRTXSypZPkM1Je9aaSh4F8DtGB6yPiw4uAt+Adu+LE8iYCKxJliQbA+YlkuFjlJBKdjDYGJ6j5DuKBjW2Zfa/0++y+zth0hyrC+8Y9d0SgUERlF98vMs3/WiujhKBhdVGh8gLx9fCUFncgKRjOA0OK7QabyEGV1AzhjewS+NS/0BKN/98FO3hw+RV9QEbWmteqbNmGPZqGglb5tD/sYfhdfVVsj9cpJCSpK4ZTNWW3p4O8gIVvzCKBXaikYDHGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7Zi2uRmzpQEOh7LvDdQnVAWUHWHUVCLWo+RKsyC9Ag=;
 b=ClzFqUcsDlZLFsvBUODtPEI3rUdcsYLCIakHS6IlDPMJ5VoXPh/DAJmbyIcVz6aQBzr0SZmxi9ynk3n/ky9g6On0bNHt751qjBZJc0fHA5jWXfdCku9qtdv+PbIdtXkZgQNM3bW/DFJ6B8BRtbDnRVikBoqHKPinTJX1SOn1r6I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 07:58:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:42 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 8/9] nfp: flower-ct: add offload calls to the nfp
Date:   Thu, 22 Jul 2021 09:58:07 +0200
Message-Id: <20210722075808.10095-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f365d605-688c-4d57-fd5a-08d94ce685b9
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4778C81B8702269FD7DA02D3E8E49@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jeS5Oieb53PP585jcQyz3MF1NvJokGjwyo2x6ceDu5tT/4CIr6vK+DfJ3eDJ7JZfF3OxjfvNMJ8b/zblBPLXwbc3PUTbydi+lv8mNbcaTbDFQf2KX+mr0ySIeZMtXTqDhuwhSZM1fAqNh/OAemT9akA7oGBEgJcqfShR7FSExzIKzcUxVcqT/aThBP2ztyhqIkX3F1gLxYlkMh3u+zcQv6uSZXhpPI/5K3//Sreo7QWLNWZaV3M1IYqwq1dhkedhemI4sO3I/XupA9S1y9aochCoSQq0FfxEUAzUghoJtcZhUwlbrSQbnU8gSPcFRw8KTHyKepHZKikcCWpBd5P1GV6ycZBRwHFRcXUVnUJLDqif3f59uksuT5i/mveFeDO98N00TSFKWNqVLmjE3Tsy3AdnxwW2FAkltL9a5Y3qV+uOIohsbU9chOIU2VNy76fUX8vGRy9ttxzklT5rnHjdB0CulH+P1y4Tj5WbT7IqdMhP+R5tGuAxpORldYAtpUzvm0F3rHrFb+5/52noRadpOMJjgTbN1JDvB4Q6/ESW083hqlBiYKBzhQjP3W0RqGp1AzBSZs60z/dXxW/o9rN4oLF/TVNKoMQ7O+FyNDp3HlDW3juiV02UyGVVqc+15AB8gKV0l4ianInJxUJg17GfGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(39840400004)(366004)(44832011)(2616005)(36756003)(66476007)(8936002)(66556008)(8676002)(5660300002)(54906003)(6486002)(107886003)(186003)(38100700002)(6666004)(478600001)(2906002)(66946007)(6512007)(52116002)(1076003)(6506007)(110136005)(83380400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cj58ddFIMyrdukd1KYnYEm+MkRdmoegBFWp7p7unH1F4TU9eYGGvY37txoRy?=
 =?us-ascii?Q?067AXCrJefchQ8P/HFKOdf+zpY3BHPHekvUwgu4UZUFIKOurGawwUAp1QdE1?=
 =?us-ascii?Q?e3jWYq/Fc8mnKY+K9cYEOpSCV2XSbg33RVorLXFK4/d0jFEJu0uzbpptA9Ym?=
 =?us-ascii?Q?gDpOs0zgeE/ea1bd9WHiiMevp6uMKmTYlVWNPGHGC5eX+MLt1D83r3x0++3P?=
 =?us-ascii?Q?1wTwPrOJ5sAVgdcK72Uv8sg0kEaY51m+MTEQ4QMVjK9v4GEizEGscXbeGKeX?=
 =?us-ascii?Q?pILyGmuimmOS2OKVpaLESYeaOcFCn9tCEj5qbbkvShWHqVoxsr9xteMqXBNv?=
 =?us-ascii?Q?YdOq76OrtTtIiDxkZzCCeJ+zNW2fhPpov+v5wiTQVzo2/SNtHxIZ7gmikBDD?=
 =?us-ascii?Q?3Nj/WqgVPio21vKMbzmT7RpKSnW3lSG4Ftjh0PG4GBRx5Tm8hMWhCEv9AfBZ?=
 =?us-ascii?Q?5Bl8/eeHJxm9t3q5K0+nuY2EAdLYRvhyd+pFYBh6CkVOtArfhTr7V0ZeAtii?=
 =?us-ascii?Q?YJkJlsRN8iZShH3hUob/YAqW4i+X5jxRSWUh3boClU/s1UnnAXpbIgTdwYZY?=
 =?us-ascii?Q?b+3JHQCDHNEDvij8pmeHR1fw/lS6qgT2wc7UygMzay8MfKHkqC9CRvZIIBno?=
 =?us-ascii?Q?j41Z6v62RAFKy/JLmldE0dQ86TsqgrkmMs9l1bUoiQvxwo0JeBBFe6buKrS7?=
 =?us-ascii?Q?5ONlfO/D1I5jyDY8GWCvsXbz1DJPC85xPrx+uZXcB8tETb7sIvF18lt7jgFp?=
 =?us-ascii?Q?a6Ott/RepK6/X5jwjFWNZAKQ0FXUoOmEAKJBrQGu/dOR1lHPNjcvoYK95DEv?=
 =?us-ascii?Q?Z8T86YTSINIj5BaHurDZP7Lop9JwiIlOjncTioL0kYmAQ6NOxMHutDOQ9RAb?=
 =?us-ascii?Q?96k+3LH55vJVM1PBCOgTJvd1GmF1GvCspu9Ja6Xcybc+vrKrDqQyTMKYNNu0?=
 =?us-ascii?Q?eXNUioPoRlatdtk/pYS4fLpnaLNy5OhHvlf2c89vdafUSs74xnNv6JohZxng?=
 =?us-ascii?Q?yWzQXdaIMhbJ67CLWk6nt7UJxhOkMjLDy+nZPcxG4tQEE3thbCYTJw0J3qj3?=
 =?us-ascii?Q?EmpHGCM4brCdWuSGF03I4guFIgIi9l9ZYEpAwcOiaYElk6AcFFSu8a8pkXXJ?=
 =?us-ascii?Q?C1N2nmfao9NnTAR2kACrFnNBTozrZ7AzIjpZehvv3TDwgfP8SDEmCqK00NZS?=
 =?us-ascii?Q?Bfek54SMdXK54msn5hZ0YlcEQA8+o/3qiCUG0F3HbzS5qv43wsvoCoAqwJJH?=
 =?us-ascii?Q?2sE5O6l5AyRgF8+CVMuE6IF2t/T354eRj8Vr6kRix/sqbHANTYzrQw5psk+p?=
 =?us-ascii?Q?D9y4Duo7Lb6TUMlTtnVAXAs2jAUqp4h8hobW3RakXYfe0lq7N5YhroBPS9dY?=
 =?us-ascii?Q?ucGjw1kVXGdW6qLuKnaw7tgfA7am?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f365d605-688c-4d57-fd5a-08d94ce685b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:42.0568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1SJ5+Ce/017F//9pUver8t/goWUYzNvmHOCq8PwretdqxCIKk7b8Bkv2KjGtOJc224zctdAV+/UpfA/2GFCaRaOwHfdbgSBZumMVM6kVwWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add the offload parts (ADD_FLOW/DEL_FLOW) calls to add and delete
the flows from the nfp.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/conntrack.c    | 12 ++++++++++++
 drivers/net/ethernet/netronome/nfp/flower/main.h     |  3 +++
 drivers/net/ethernet/netronome/nfp/flower/offload.c  |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 8ab7c7e8792d..df782a175a67 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -813,6 +813,11 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	if (err)
 		goto ct_release_offload_meta_err;
 
+	err = nfp_flower_xmit_flow(priv->app, flow_pay,
+				   NFP_FLOWER_CMSG_TYPE_FLOW_ADD);
+	if (err)
+		goto ct_remove_rhash_err;
+
 	m_entry->tc_flower_cookie = flow_pay->tc_flower_cookie;
 	m_entry->flow_pay = flow_pay;
 
@@ -821,6 +826,10 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 
 	return err;
 
+ct_remove_rhash_err:
+	WARN_ON_ONCE(rhashtable_remove_fast(&priv->flow_table,
+					    &flow_pay->fl_node,
+					    nfp_flower_table_params));
 ct_release_offload_meta_err:
 	nfp_modify_flow_metadata(priv->app, flow_pay);
 ct_offload_err:
@@ -865,6 +874,9 @@ static int nfp_fl_ct_del_offload(struct nfp_app *app, unsigned long cookie,
 		goto err_free_merge_flow;
 	}
 
+	err = nfp_flower_xmit_flow(app, flow_pay,
+				   NFP_FLOWER_CMSG_TYPE_FLOW_DEL);
+
 err_free_merge_flow:
 	nfp_flower_del_linked_merge_flows(app, flow_pay);
 	if (port)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 9e933deabfe2..d77b569b097f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -563,4 +563,7 @@ int nfp_flower_calculate_key_layers(struct nfp_app *app,
 void
 nfp_flower_del_linked_merge_flows(struct nfp_app *app,
 				  struct nfp_fl_payload *sub_flow);
+int
+nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
+		     u8 mtype);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index e510711f6398..2929b6b67f8b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -91,7 +91,7 @@ struct nfp_flower_merge_check {
 	};
 };
 
-static int
+int
 nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 		     u8 mtype)
 {
-- 
2.20.1

