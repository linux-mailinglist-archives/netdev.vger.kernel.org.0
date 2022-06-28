Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EE55C980
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344867AbiF1KIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiF1KIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:08:53 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60082.outbound.protection.outlook.com [40.107.6.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944062F39D
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0x1ILr8wiJcYfOBP6BvnAXPYUuW+VdpqAbu6x2P9mZvTNm1SEfLkXgVKfSa2uuRSh1Rwy7bq3/hdINdK/uogX1xhV4nCesbXPKdVhIcafTq90Ne9ycY6o/uoloKNNwph95AdJbD6qDJP++aOPaJF+XQLUaM3rfy7xdy/xgHMcwntlcLjNa/S6i99sWvNJ5i5mUmJUGlMRa7pymML7s+fHACJwZ5UPepZeBg9oEK7TI5SlrOx8MLughUzY1NYta6VXd8n9hu0pKuZD+2dh68w9q5hiGD9V1tvcJ0cYOrFBkA7BNzIvTkRmo3W1uUFQYvsObOAgKiROnPEM7VnxXW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MKYQB0Bhqa7Lt8P6IIBDwqsDx9bzJWrJIVVuOyMc24=;
 b=Wf6/o29IX+UGDtvPMxXgHrhB/5PD+7LcFueFuG6AYwUUovqdPCkcdgZFBPEq5wIKIdozSey2guBag+YWlPyxj06MZQrq36yp95/4712EaKTvfm2sWGYpoUwkxhjeC41WFcc40zMNnh4FizjA310AcjWyhNHxeC+qlZGy8L6Y7CnEACO9xiI9pf6WDElcbes2oAiPVwG1AnEefo/ipNRTx2tM+PnzyI++nD079mLMKE30iv3F8qMQsIBJ9dttEaywRCDKB0vxBxZI9PsCdjpX9p2wmAEKjbkGDx6lC5cQE/TZlYcdR+KeQt34BBEWN8wA8xYfWjnzm6DcGyMI4kNpJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MKYQB0Bhqa7Lt8P6IIBDwqsDx9bzJWrJIVVuOyMc24=;
 b=stUNC8vFCibJNRB36+BQwd+7mY7JAs/EvXeJnOIRyZUHAEbhIiHdNDM86ryv9kSTJVSOzgaoT/OnY+P+MSuI6xWT1E+4yNztSQxJpwIkrzAwyKRsbveBDv4nN1zoMqdZ1GOyGK0iyKrS6FZZD2PCw0yPzP8NZ5yQFtdot0U56y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR04MB3077.eurprd04.prod.outlook.com (2603:10a6:6:8::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Tue, 28 Jun 2022 10:08:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 10:08:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] net: switchdev: add reminder near struct switchdev_notifier_fdb_info
Date:   Tue, 28 Jun 2022 13:08:31 +0300
Message-Id: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0111.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d36fe3ef-eaef-468b-9cc8-08da58ee2ff4
X-MS-TrafficTypeDiagnostic: DB6PR04MB3077:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26qiy5BmPRp+TQEtHM3VP3av/lrpfJD5M59kJ+bAs4lA02xt83hZw420W7Irvjp4F47aE48byz6zxRnwPuN5sFBxmcEE8VpFZ9Imfdn0BEpTuSmzZ05oMtW0oFKCNZN18jrfQEeDlXGm1/gM9BrmrDT9eL2w5orNPGq1dnv9Bsf3ESNIbaZa1ePGYBO8r+E2TkcS+5E1cOcw9VljVDf+M5TOM0T/xOQ4UtZAKfGyBK+w0TdyawuBwIP9MMypz0iwrqa9uL2h0A4oQ01HuyAMnKXKkh0CxhdwL0AVsOkdBDgZNL3wu/RSxX/oDD4RhjHLKkOTCBC6uNg59eZuxjaCxNXquo6VRCDkTa9rDWn9qwgZvl5GniE0BP+lj/YN/N7LBaqayw9h1aFbShnTBlCxR392CmRFDQ3AF9SfL65Soi4qO/q77GqBbnrE238yhs6aBo5Vk6XNEBg5PioXJXL+askSyaf+5XM6MGeJPj9XLxDeUpz8VAJUOoVUtfVpC+wJNpPG4BbiHvreaVhwx+4pZxfcPl7Tw24NFiKkzSZZ9P/hx6stZ3enR+4duAwuz2LKc6cu4z5TD1e/zdjIbV7ZRfxdkSTtrmHX2qAF17qHNIszP7ZRpVGlTFcB0irON/5Uxkl+23XHMbZAgHzXEnsSEvgsV2PsZSURPuL/f9FPUixSKsxFAAwJwfxoNqV7Al5vCgo7R8kve95YwWiGfqr9YplsSwFg+v4EowKVTUjYdqyyJKX2lmvNUZeeaL7U4DfTgS35OnipXmcPlfyC+E6cy3W/jmO67nrSYljXSM3yQlnW/KFAYN1/COv/1n8uBvrMhzVGAbkKG86AEW92Ib3xgOz1piZJQubrvotd6jRfDoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(26005)(4326008)(8676002)(66556008)(8936002)(52116002)(66476007)(38350700002)(54906003)(6512007)(38100700002)(66946007)(83380400001)(316002)(5660300002)(6916009)(186003)(36756003)(2616005)(86362001)(2906002)(41300700001)(6486002)(478600001)(966005)(6506007)(44832011)(7416002)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Zw3T9cFaYz2bmLv3qfXtc/RT6AYicyfmKAIg+jzoO7OhL5KSlOXsryS/jmX?=
 =?us-ascii?Q?8WrOfR01aNi1So+JR/Q+a/DPJYp5SzIHW8I26FDReKk6thKCihRPJJbrjDfk?=
 =?us-ascii?Q?Xwf8PSOa/wbZs4QfpNol2fOPGmcVw/Ud75GkDpcE/26bv6ZPtAprSQQAGrIe?=
 =?us-ascii?Q?o6mcMIcVtFx72tyEKlCZlrlo5FsTbk3kAKX9jiiTiiBlALPA53HE/anYNbNw?=
 =?us-ascii?Q?P+ZgV//sD0E7K0zxu5CSPYZ4HgSMoz++gtUl/0GkH0WEwWbFMZWWr+1/t/Z7?=
 =?us-ascii?Q?qou+aaH66UikPzVyhkVNCbHO3OkLNPz62bcHhd+8osVJRoVQlpk5lTll9gC3?=
 =?us-ascii?Q?mWif3QGg5azKEyNV//3ur2ZVMQo+pnb3F6kTFUx/rnenLUodmMSWxAHJThJ5?=
 =?us-ascii?Q?FemPHCY+gjUt7ECE4JHb4pE3xXwY+Bk5u5opcxLhbaOejZXdsoL2Fr7RSqnG?=
 =?us-ascii?Q?4vbiwwraXly7jBH1SoDjjht4lx8AdmMAuX6xdlbH/lH6kIYRW3hzo+78vpYk?=
 =?us-ascii?Q?mJDbOQeTAe9LswTynu+6vaR4frx46U9KD4Jkwrh6zTEfAH2Rc8n8lTZqdyJM?=
 =?us-ascii?Q?TJf64+VVPOvyb7OXrjMuuDZw3mVANlNbCLD3jE/HRMK9Yp33GZpQSdfSpt9x?=
 =?us-ascii?Q?IwJNPSOLuxmK69vxmb2Ulskbg6pVmY8u8msU1+s4Xf5ncBnCAul6rs3uSudn?=
 =?us-ascii?Q?jek39j56HyqJhvnHYKczcYftNasvX4hZwNwO94/iPNsk4LhxEmS3FZzKTUlK?=
 =?us-ascii?Q?7RzxCgfUujJYoNCUVBxStYkwuCHQnYjTpLxhMlHE6FwUp86Hx91xGMmmOo5n?=
 =?us-ascii?Q?Xk7X+YSwCU7ogkLsW52mv3CP9nI5UzxvfmpnyQ4cKtUIU5ee/EhPWggqlxsN?=
 =?us-ascii?Q?ZftyXgPRu9trEkQktiB2/KW0dJPGWFgcp0Nxdh2vs57Fiw2OqAWninged3Yc?=
 =?us-ascii?Q?oXUrUcT/HT3ebLLvgRVFaRmVaA1dCFOAvAT2EucjqDyU/SaMXWwRnq9LI7UY?=
 =?us-ascii?Q?QTPexc++dHlLLB6GH8P1SzDStWIU9NfbEs88aM3CMAq8PmUjYUcVKUXhwE/L?=
 =?us-ascii?Q?8o+l80gdNGuXdg8tTlBnO7Yfmme/Xox6D6XI5A7fEB8NWDNKzsHA3BAx20fK?=
 =?us-ascii?Q?i/OLfDjvjakyRuqU6Q5pNH12J+18LOVeQRzb33s2RT7eRHpUmlqQPoNklZug?=
 =?us-ascii?Q?kntP/dLSvnLrB9TR3h0w3w0+IHNH/5P50LadwWzcVyg906FtjydnMDj8bM9p?=
 =?us-ascii?Q?9K+pYALSe3sOMt2sGPZtk/AkFM5GcfwgFrWP/4MQWKKTqe7PNDoOnD+sawy1?=
 =?us-ascii?Q?oObxYjvG0i0tnCV2G7cbMXYYhlq6yziWmZMde3P8BrMg1InVw4K036PD27Vf?=
 =?us-ascii?Q?Rv6swJajrjHm52brPtBl65lsC4yTZvIsYYAyAD+H1fw+6KRdirlZpoBXfUWM?=
 =?us-ascii?Q?lH9xgYo98qxijVYwgm28zoku9RrAOkGot9NkrwK8V4kAxEMOaTaG4gH64WbR?=
 =?us-ascii?Q?43cDeGC1JCF3McDYqfLm6uFM3FCfBpnK0eWHCobUHEuHaQfRLTFZ+wakQ9E3?=
 =?us-ascii?Q?CUz0EEHtfPQxPG7UpAR/dR3UQN+of3Y/x2IqWAbkZDGMMEHFfKsdLuWDnp4L?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d36fe3ef-eaef-468b-9cc8-08da58ee2ff4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 10:08:45.7773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNgnhA5lgfQJyzl64hZqkbVvU6QMonSlMm7p9Toc4KeThHpqKRTRujUlSbIZO96oiXQX32iU8QKNLwRxIS01Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_switchdev_fdb_notify() creates an on-stack FDB info variable, and
initializes it member by member. As such, newly added fields which are
not initialized by br_switchdev_fdb_notify() will contain junk bytes
from the stack.

Other uses of struct switchdev_notifier_fdb_info have a struct
initializer which should put zeroes in the uninitialized fields.

Add a reminder above the structure for future developers. Recently
discussed during review.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-2-schultz.hans+netdev@gmail.com/#24877698
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-3-schultz.hans+netdev@gmail.com/#24912269
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aa0171d5786d..7dcdc97c0bc3 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -239,6 +239,9 @@ struct switchdev_notifier_info {
 	const void *ctx;
 };
 
+/* Remember to update br_switchdev_fdb_populate() when adding
+ * new members to this structure
+ */
 struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
 	const unsigned char *addr;
-- 
2.25.1

