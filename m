Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43AB693A53
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 22:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBLVx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 16:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBLVx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 16:53:57 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA16EEFB0;
        Sun, 12 Feb 2023 13:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4grdQEveFkbNjrsxm0kwNwJK3mb6yvOrFe99NZAHX+HTZ926+5r71PdlIP3ophDyq140Uj/qVC+qRvUV+IIFYPPU0NPWofV5WSvmM1KnzeGeOpptuAAaRgYSWqJdxIHDHxbgxD7cCZkehhKru8yIBYRy5fZw4E6povunApyMNSw5AEpFKa4LApcvC75n3+MgZat5fnV5U1wgeJmdg9eZjGhJw9qNhPHyAQ0/xZbmrCxMnHGMSg1KNJa/dzz1ZgMzb1wbsza07dFWIaLuoRt1ocBF9jXwWzS5OmizT5uItuNUAeSSPfaFMn6lCq9+0NqFgJASIq57oN4SaMRTpMJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwryBIZZqsBqQcbe4TUCcAlWGvQq30+0R5l4jWaSZJ8=;
 b=BJ14FcsefubdFm2tLMTu0UyuIa1J3bNAj9MIMJWpauloyIvi9xWq3yg4RuyPa7YP4y8MU4378LlZYnlCLlsyVnQD9DXBGXMnGAL7mLzTlOTTPrsPCggL9WGJn/nliIpF0xH5pYBrk/0pDqVNZRF2HcEe724jtFIsmRdL0Exn9XixVnYSHX2KlgPu5nlu81PqHYGmAE5s3Oc3ko7cZ1KJGvfYwwrIeH+dj5llYTLeYA9+TlO6kcFhGejhJcSEanDP/z1aDPEu83yt4LhBpzT3JMwiNw+TlXKTAhHBO+9vJkCaE37AWc12jrDwQsbBBadiZTC34Ff2ojP1+7h80xNUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=routerhints.com; dmarc=pass action=none
 header.from=routerhints.com; dkim=pass header.d=routerhints.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=routerhints.com;
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 by VE1PR04MB7344.eurprd04.prod.outlook.com (2603:10a6:800:1a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Sun, 12 Feb
 2023 21:53:52 +0000
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd]) by VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd%9]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 21:53:52 +0000
From:   Richard van Schagen <richard@routerhints.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] Do not add all User ports to the CPU by default. This will break Multi CPU when added a seperate patch. It will be overwritten by .port_enable and since we are forcing output to a port via the Special Tag this is not needed.
Date:   Sun, 12 Feb 2023 22:51:52 +0100
Message-Id: <20230212215152.673221-1-richard@routerhints.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: AS4PR09CA0017.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::11) To VE1PR04MB7454.eurprd04.prod.outlook.com
 (2603:10a6:800:1a8::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7454:EE_|VE1PR04MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf22f90-635c-484f-349a-08db0d43a12c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VpNCTB81g/4w2OjQcXlunB06MueTkdKdcCM8SJg5j1ZDfyk3vIlfFavhq1JQka0hfO8WMXjQd8lb4zik9nQUKoGOzECsbDRIRGS1L3JRtqsT1C5tZRDF9LwncTIX/hh6jvJucbOf75tkaQQAO5yxeXazMWkePAVb3WdOuO1xSFo1mwbIVD8/HmpUOZgmIFG1rXae9J3xiLHKXpNQNo9mMRGwdoMpyvJ7RGJB7RPCBq7tYP9MoEUVPe+B6RbIjFZNH/NNDI7MS4w6bDNQfTz7CXtVmb9b8MK1lLaYbv5/XR4hrhNdph0Bzj03Onr8aI+qFfO4w89l8/h2TBaS5i6uYHqLSsmahSQF+Nn/yLTrtoJuT8FCrlEWypV0rTNcnPiMBil38O5ff4oMVgBiPoxZapOgxsArAdZ1xprZ6PPev3K/XqQzfy3nz24JwSyTTmbxLTN3alAgXquQV6vaMYTR2oJjw7j6SAvOe4AcUGbvJb7jQ/4j0/JxCd3l8zOiejk42/tmQFaPmWyxLA7ZiHdTF080Qt7FZWOOW3q1xmJY18oqE1JIUwOcTqQJwi7i4lG7qcsxuwgBVtd9TVptZmvdiCxzu2eaNKgbtMXcsKQ/2nA0yllWMcL9Q+DHOz0ONy26ZUiYFQfnVrdBVHDIV76eZfsm57p9r+WRrls6Wm616IB+3c0wEESM1JEBdN1A2XVfUKwOEB2oVhi+h6ZyaN6X0tsIX5u+Hj+IKPGQtAtmwq33WB0EHFi/XwKkCAA4M/Ds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7454.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(346002)(136003)(39830400003)(451199018)(36756003)(110136005)(41300700001)(316002)(4326008)(8676002)(66946007)(66556008)(66476007)(921005)(38100700002)(86362001)(52116002)(1076003)(186003)(6506007)(6512007)(2906002)(5660300002)(8936002)(4744005)(2616005)(7416002)(478600001)(6486002)(83380400001)(219693005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hJzidEyDyHmtQw5JlRgq04LPFoU2qL4/9UhgtmJq8wlRp46S+y78K+ThvUNm?=
 =?us-ascii?Q?fov7zYkAcJxO5ykPwOvjuL4a36GDQM0BV1DugzWJtUIqaenUplK+vUEXzYK+?=
 =?us-ascii?Q?C2+oSS8092A5hGPssVN/d7YOa0YvMCfRwwvOeUVz1UbF7ixCaRKQcL28MEUW?=
 =?us-ascii?Q?mGxRZ+I0zRomkRElqgsMkyn5eL/zKV64O+WcyhftzJmVHO4wlg3LKu3lCDvA?=
 =?us-ascii?Q?aAo4ZPGQGzMGylDmYBjidh9aNsfyHnBfnS3o6+Kiux9lx2Ar9D1NEngi0rG5?=
 =?us-ascii?Q?tGZ+CrMIcW+mTAhUZdsrWo8aUAbatnNwk0G7BNRG3fuaKSGrZBgzKoJY3OAW?=
 =?us-ascii?Q?N0Q4Xp1OMzUlJA9PIMb1xfapsXICuJ/JpYO5vjsaXkx25Cbc1+BcujX9bRXo?=
 =?us-ascii?Q?3sTSZWpwwyV1FGpdOt35rLn+yi47IV2GdPZVhsA3i+3UyKBC32zbSZpC895R?=
 =?us-ascii?Q?5zyxTIS8amjCbtJMD0aEttcUU6DTsHPgL9XvXdDP0uqGxW/S+Ugrv89Ni7k6?=
 =?us-ascii?Q?ZsSfJw7Fmqq3f5Afo7fW+jpIEzRInQUWzDW0BcZVALr6yjs+KOx3nmxzlHxO?=
 =?us-ascii?Q?lko0QZURD22oLjd3Q+QLOoBnk+ucasJzLtvco9hkpwQirAmj+cTnlifJ9cpe?=
 =?us-ascii?Q?nlBH6ERH9PtcngkCPpPwsW+wr6khp9jh9RUW8jiYPIrIkt7TtG3GsSER9pnv?=
 =?us-ascii?Q?W2V0LH5o0QWlSQHKW9T1cGmW91ld+n4sHErZOYfVMjrJyhxinuRxtI/tinUe?=
 =?us-ascii?Q?zDxvi7pTE8diGPN9Qzh1bviDeSWanmd5aZVyCCYItay3SlGSEvEmqShY/mHC?=
 =?us-ascii?Q?dsK7WQ2EAy0/LD6R4YH6UVNM73uvmB7C5rrH7qE58cArTrdWHl7Q0thLYydr?=
 =?us-ascii?Q?iAyvW7AZOcoyIFQKxbjrqob2tZgQOfRpFY6CPtljw5byGxWkfZmmrbFf8rib?=
 =?us-ascii?Q?7SNADCI3mq9ZlAfHF9EDxbNOrvuAJRFlWLomRrRuPFG96OyxwbZZ+cRYkzog?=
 =?us-ascii?Q?f3LTcyAlPcQw9ZRSO2uv5VG68bdIKoTC4nafA45hB5JYMAQwdTNM4CDJ+UUW?=
 =?us-ascii?Q?WobG39SvaZbplmOwbfpYXF93OzFcHAHtEetLoXyp7m0VaWtjU2sIPbrKJQS5?=
 =?us-ascii?Q?5ZWxOADxU6deWy2t4Ps14gllHo41RmSnxKPfgMcCXKdb4MHQLx9Q9c9HTPV1?=
 =?us-ascii?Q?maSar0lFXawDWUWV1kC5S5d/9+SKey8Rj10zlNyiZGKpfkL6Oks85JtEspHy?=
 =?us-ascii?Q?2LsSsZAiSURDndtGaTCQLgXUUpbRCZeOvgpoktFYhTcSJT82QOkUVpINhUxa?=
 =?us-ascii?Q?necAm4HqBZZK7esq2Kw3zYXLAEA0JhQ1aD2nCkCCqaaENckdHEuJTmmoAbia?=
 =?us-ascii?Q?wvyh65gfEWf/yz5BGAlotMLmtKrlfJHx9AnydXWCtKhKbUqjKGv3RtGO30n2?=
 =?us-ascii?Q?VpDDyOe2fQlbTPy8htZjDefpkeuHrmVVVOOylsxtJxMs2tGGdaPBzGfuJ03D?=
 =?us-ascii?Q?LtY07nu5T3iF8ZUQqdxwvCMAwCmzXunqj5YIAv2J/d38zsV4fDoNl7UUJ+/q?=
 =?us-ascii?Q?cxpIY+Dr8pz8gdjL6jgmU5XTn4ZRqvDwg2OjTnhAV441kT9NvIbz8wH37TQj?=
 =?us-ascii?Q?AgeGmXT9Ox6NEjTR6z5d29hQ7F+7o427RQQWXHkWKjF2pQP13IX0cExmScue?=
 =?us-ascii?Q?xQqQew=3D=3D?=
X-OriginatorOrg: routerhints.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf22f90-635c-484f-349a-08db0d43a12c
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7454.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 21:53:52.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 28838f2d-4c9a-459e-ada0-2a4216caa4fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWlnnpFkw/Emu6hJPqxCfL9mKcWiDVxrxWXWROCDof7q74dk6UW/Ti5xismHpImol67rg6+2eH1f0RCv/jc/wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7344
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 drivers/net/dsa/mt7530.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f456541a68bc..f59f706d176e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1019,12 +1019,6 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
-	/* CPU port gets connected to all user ports of
-	 * the switch.
-	 */
-	mt7530_write(priv, MT7530_PCR_P(port),
-		     PCR_MATRIX(dsa_user_ports(priv->ds)));
-
 	/* Set to fallback mode for independent VLAN learning */
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 		   MT7530_PORT_FALLBACK_MODE);
-- 
2.30.2

