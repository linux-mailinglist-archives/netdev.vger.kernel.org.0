Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E163D68D9C0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjBGNz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjBGNzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:55:23 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2089.outbound.protection.outlook.com [40.107.15.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB58F38EAD;
        Tue,  7 Feb 2023 05:55:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkvGjWMvsZWYDgI3tWl5ClxwmEJbnNOE7t6ncdIOvAfB5D5Yej18WuY05UfqJ6G339S9TE+Tw9fOHMNCz9+OlCownQLssm0bLXF6mQXW+/ScEyJANjy7huZetKMB5L456PQEad8UNbkJUkqPZqwQLcA79gBhTwfCO7QieIqT+DfloS92Lwzsv81b+HHB601SPyI+KJfsW3x0t0+Tq4NCZv0RI4AQsLFe4QPb7kdzBgoejnuJI7Uv5Erd2vcB8Pci9iWy/Qo9fGhSEkzXQXqVxQxeabzdiMvVnO6QL5G+UQbQpmHUfAsMfYb3vFI10sZfrPbwNB7GxI3c7H71Wg0GYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFYn1LUwHig6bqMdHhQTcZdRtANbkDTMUdKiVG+jejE=;
 b=JAZtB3UYndaYCM74VnyooNLkBOOVcQHGkKEX72PK80Jt4SkEjfFS/CbcuK6+j3NVszppIY8u1LS8bph1eiTjkkM238JhVcboU4zFrNQZOwqE5MPO4XoY1wIzo3KUPZwHBlY+LA0/b2uccrkmZJIDsYfUzuPl+mFMUXPC1CzYxdMH2KSLaEHvH1Bt+X6uXjFFy3HQLTlZwiWO5R4cIoR1RORenV3U7gnW0bWhMYFis9VS9i4EF9mdHO4jSYtsBNtVtX1qyMvOso4PsPuxIQupMFancf/RjzSd8rTj1QsXhmB5EZ0426tXJI5Nzzz5g1SFQfM7vmCKG29EhQHOpDe5rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFYn1LUwHig6bqMdHhQTcZdRtANbkDTMUdKiVG+jejE=;
 b=QoOF426T8rA3IVDmGxt4ErkmYafZOcpxYIMnAuWj57f0RJAB1QfU7WzzxTGEFd3OWv6J4cdgtx1vkGHrabvCcwStywE8dicpiTYFanY+ZTT2pCKlmThDCFEQfhfIe3+G8xj4N4QyoUazGeJL4FQWbFicsEr2marTvLD7sJNUbh4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 02/15] net/sched: taprio: continue with other TXQs if one dequeue() failed
Date:   Tue,  7 Feb 2023 15:54:27 +0200
Message-Id: <20230207135440.1482856-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 865c8c28-d67c-419c-4d9e-08db0912eb3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nVR8tYHFHve1f+7siCcuqVc3Uk5NpKF6RigXxdRmt4dW8xUXC4sH0rbdUwq4OB9y8acYXKhmtceSbWD1IYiRgWWvFFNz4nHBsxPHHTxuGXzovZ0mxOi8MR5srwj6FPIMP01j4Kfn2/4rmhWq0Kq0JseqV8qxB2HsFSRptr5NqV4rVQf+eTgIfKPeB1I7xCpc2HZ2gobofCjqIGPn7yCTYoUuQHVx/932dYwU/pBELoI3V3W0rHa7zfzsQ6TnpVroxMLNqRmagInPBMPnO2D4U6S5VWXlOh0l4TVeQcQvDDo+UWsXp6uSUX3QQL8+OYOi0Aq6HWbZ/YnTkec3MfdgaX1iew7eNC2pi0DjQlLAhC0NOH+4+oeDdMIzWmttlzO9nIo//gtgx+gEhTAAqzzkj033QPRik0+IfROGq6NCoxKe19KTbtB4myC6nU7bHQ/bcsqKNLjW1OFz9MAUoY0ZpbB8hUVINSnyou7R9Wo7yI+4k//VDUzWTya8CA+ZiKUjtSXnCRdBF2ZT7UOxUwUSIBSvrYgcpo1Wtzaqsyvbm1GYi7mZHCGH109drziXOIrarEaFpWQ54gdwoVROs2ddbbyWOhCe3N/TDZOlqgjsvHR4omUqy7tSuerEhqNv+onFw2g1pk/DhuU35baC8YEG+neVjcVcoWNTfFQKUDJFQiv9U6LvoP86oKHXl8XEKC6uB4N1En6pAzL0kzJ8o/vJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ysDQypWn5AaN0x1tXMq1nha2TuhqA1+pYkbbLAJFD8TycpgihJO8DVUE1pp?=
 =?us-ascii?Q?ErOmI2rPAHvyU5tLl5XG8qEbvJtboAeIW4W69QnpQ3azbtR9Y333PgYPojvF?=
 =?us-ascii?Q?wR3Ny5ZuT07cYI+j4BjpIWNULJD/p3wFVlCtOckDpQg/sjBY8DbSreVE0j4C?=
 =?us-ascii?Q?fLThcBXfnDGRXuuqe3lvr0Fd45sGyoNufUtKjSc53HR85iA1dM65MbyrhCNA?=
 =?us-ascii?Q?ZD43RS1B9G1zksgQ9vWbqc2Rp0f1Spxtrqb+YWExCuQPNMdFAB5VfFI8e1Gc?=
 =?us-ascii?Q?iamFdwZPqobHOpe9XU7MjVfFpRpQ3AC6CcsEGcOy+A8v8qx8bbRpkW1VthTD?=
 =?us-ascii?Q?wvnt1kg/T+BMcnMjWWYlW8Bm5owOIS6sO7dYQmlSVIuuuxmj89lcP4IInebf?=
 =?us-ascii?Q?X5Hq7F/0kCZ0vMEebWJIOkHY1pbIFR5woGRsdhJDuF86ZIqvt5UKMwSxkH6Q?=
 =?us-ascii?Q?dZNBLmaepOTeflt4EkDl1oaXzeY1iCoR7rE5HUIFBCuQaZuW6LFfI4ucZAA5?=
 =?us-ascii?Q?1J3rDWqSxXofD5v8ijrGtc3WwQ6cUmishHbDHW0enioxr2BQrBDqQ95padC1?=
 =?us-ascii?Q?zxV8ndhYI795Jdy9B+jGBfXPJo+WguWqes2T4y/RL04/Gw7mJ9K9DHNQa+KX?=
 =?us-ascii?Q?gMTIxa6X8c6FprOaGYeECpF+QkAvfjeZx0TBtSrUmxPutqKz3C4oFnQolCto?=
 =?us-ascii?Q?Pi5CIsLGgY9jktrf13q10q/B4dfcN2ap9LnvEB826PjP7tseoPoSihbkclI2?=
 =?us-ascii?Q?CgCAJ2jucs7kM4UmNvbNxPWkEW/FygrhjBY/fNOnHMudWlXVyWHhnOUkivi3?=
 =?us-ascii?Q?PmqBvwyuadAYYIyV3xIKr6hoeO2LdX5VsXSJM5ir+PcvHlAzO/IfKdNI5Z4z?=
 =?us-ascii?Q?iS0NTEZx5GIdsHH4bQlgMf9eZgnuIusb1DHnuzyK4/FfG4GTDifeZsRNGK/P?=
 =?us-ascii?Q?bYU72unzAo/d1bXyWgQ+3xakNkOrTbW+E2g8DhOxbnP4EhTJ2ZUmQ5FWc1mS?=
 =?us-ascii?Q?fpfo7Ct6d8Kw95vfHx30SnA4a/Fw/kJXotInzlrEdwQU0Z9Imln26g2Hz345?=
 =?us-ascii?Q?YQ2Qo1Ra3zXJNnbW8soMbVW21GCAYyz0U241um38bEzgx75gWLtPR3St6jd2?=
 =?us-ascii?Q?kV+Rb8OqZOiCQk1tHDUFqfaSrXSpCKdqjwh0e+M9GeF79jbTXCXIWYhrZEu0?=
 =?us-ascii?Q?kBfAaH8V+2yllo/56w9FXoOb39FcjgM/tjPCF2v7vUEJHnM7pMNNVIaqj0/h?=
 =?us-ascii?Q?e3oIb5WoUDzTagqlk40QIHA+bqQKFhANPp8m7KfR64rs4xZ7s69AshrQYlj3?=
 =?us-ascii?Q?EHgPTAnDKjDM041srImpTxlKT0uFflI9ZXqhWB2eyJJn8BChGn1q9JQxqxzl?=
 =?us-ascii?Q?iCF9kP5I+u6TjPW7k/74f2f435ySE4hFSvv2iaEc8VdgHjvpSE/79ITDsE1c?=
 =?us-ascii?Q?3Ba+fzwGxQCLh2DbGydYvnqrhKwx6ZgDN4Jzo2bkpDjoV/gJZcsPfjgc658w?=
 =?us-ascii?Q?wRKkFKJK3f0clItgrMFjq8Xp6OHMiNgP7s+qWVb6SbsfO9CC7GapQGnog7F9?=
 =?us-ascii?Q?nxasbr1398b2kVLN37KVS46ywVjaHiWwks90dRnBGmWcgqNxxqgMy7ySRu1V?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865c8c28-d67c-419c-4d9e-08db0912eb3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:06.6906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVdRDMN1Y3EpGCtgavt4PwuSltua+1KH9DK4e3vbjfMgqENz6zgFRVlUNGeD7G3sGGOM4R+QMpVakFcYsVKO5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changes the handling of an unlikely condition to not stop dequeuing
if taprio failed to dequeue the peeked skb in taprio_dequeue().

I've no idea when this can happen, but the only side effect seems to be
that the atomic_sub_return() call right above will have consumed some
budget. This isn't a big deal, since either that made us remain without
any budget (and therefore, we'd exit on the next peeked skb anyway), or
we could send some packets from other TXQs.

I'm making this change because in a future patch I'll be refactoring the
dequeue procedure to simplify it, and this corner case will have to go
away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: none

 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index d9e26ddaa7f2..0fde303978a5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -587,7 +587,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 
 		skb = child->ops->dequeue(child);
 		if (unlikely(!skb))
-			goto done;
+			continue;
 
 skb_found:
 		qdisc_bstats_update(sch, skb);
-- 
2.34.1

