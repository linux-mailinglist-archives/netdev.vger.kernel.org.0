Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853E467D778
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjAZVNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjAZVNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:13:15 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473867DB1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:13:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYSso2vgr8S3tVoFAgMjHLWhiFyjuXGOD68OoWI7CtzDZVaX4GOozlVHl5G+BmpvcjROcjg56kNtMwskNIggnjNfiWdqbbocvVKoMHrO2H3T4MVfNNUl3vQZA5r+nRb+h7v8HW9Sh/VmeD0pDZi5bNU9qkkHB+LjMOsTEqKyEvN/+SnsXoehDOKzBUN7ip5s0zBeMqC3QQsI9xTN2Sd/J1NmUHuuasi4GqnVbhkzy1wJw0BaD++mazhCKgc5rfijKFveXRYwS0O9Ox7Z5YCK2uv12dhddMfyMXHGSLAaw0mshS7GaQ/UshmNldsrRyl/QIC01hZbb2J5wbsEk2GP/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdF7WIoCslNPWLrI4YGqEZ+wajYkPX3G/RPmj/PEUwE=;
 b=Lnze6HQOBbv0F5zh4jB1AHIf3CCTPqtKE0QFPusVEBCXMH719dbH2ncwlfuwEilKS7xLlIao2OwocVxYWGlzjiwKgp1ccYYh9ovPxvmc1EGKBgRdV6pcV2lk6pzjEmurJSj9ea74um2W2f2EQW5tvuBTddaZDhImsMDnbzmzRQjScLo1dXTM33OVDir18Jh7hhYxCBvhSwnB5eU61Fl7l4x86rpdLu7LGrKMvM8Uf2dICO1uMbNFmZr9qFnNzCjsxNLp8YDNWyArUXZWlKlFr20loURBdWF/8PgLo1mfCTMbQ74Do2zBtzkOtYWW0MNJ5wBZRmetAkf2SUvaCs7b4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdF7WIoCslNPWLrI4YGqEZ+wajYkPX3G/RPmj/PEUwE=;
 b=nTlwH0WwoqrLg3MakY8ZxoYuO69PoZw6CTC1GQmocLOZmAzyW/w3jxNXnK2LXjHAsAZVwJD1NJX6eSU2B2xtAJWRdMLg+9kVcPt7X/FprO4RGSxofr7/7VKG1B1NUC2034zZgkDP35kh5A2yeTPoXqCcd4vVXlF1c/M5JojZ31g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7262.eurprd04.prod.outlook.com (2603:10a6:800:1ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 21:13:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 21:13:10 +0000
Date:   Thu, 26 Jan 2023 23:13:06 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: Re: [PATCH v2 net-next 00/15] ENETC mqprio/taprio cleanup
Message-ID: <20230126211306.en63337stfaf4epp@skbuf>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
 <20230126084620.154021f4@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126084620.154021f4@kernel.org>
X-ClientProxiedBy: BE1P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VE1PR04MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa2658a-f8d4-47c6-124d-08daffe220b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MCH2WJ0eGcdzM1BjwEXSTqyyFAFMgTKHRwFv5k9ppxcpGguFxdsA1upuPVkTGAtJgrJYcHl0dFF58acMrDLiQitOk3/XzX04NChkPsGl/nS96vvVfrV2n7r2pgygmajLLgwrv0Gs+CsFajNvC4ZrdKFTVUYTiOGdSARZus2K9i+MBz46M6327A2WXVFuS+T/HcGQgFX+LTr/C2/Eeyj1Olno54bzlM5+ipix7ljMH5MWdg9wh8YDDWANlKQW+tYoym+zXyBIaydUt4hUjklUwmwQez1cwuJodrqgph1axmIfm/okacCyEf5aSLlLx+TdLy1McNge5H0r1sbSV19k2ivmi5xl3VmgrPGpzCw7D51PGaV2fXfJTiGWQ7WvV6Okw89C2JPm8UwCQ0nHFpNrR7Kn1JbqwvCFSWI0j275LGxn02+We2yaz/Ztdq+QMK6DpDy6r9rfSLlHuySwU83+WzZzx94NR7+t6gZcgdo7jh9aiUupugtILtI3fmtBcvRItSPu1ONleZ499pp4XlxRd9sZKHhUY5gzFqxTEBRxHg0bEZTambhIYSkmvUXz+hmurPcs5vVhmbwLhK2ZZ2il1PtKlVbNhUvL+5KSJIOpqkNdIMJKSuotSEUNU9ItGsoEx2ok3u+0MkSu4BHmmGAIBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(1076003)(478600001)(6506007)(6512007)(26005)(9686003)(38100700002)(186003)(6486002)(83380400001)(6666004)(86362001)(6916009)(4326008)(2906002)(4744005)(5660300002)(33716001)(44832011)(7416002)(8676002)(316002)(66476007)(66556008)(66946007)(41300700001)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TGKgNHhn9MM6Iq/De/acZIzZPf5R3ospKFM/Gr1lj2kuRkNV1LmfKx9ITp9N?=
 =?us-ascii?Q?pAJL4UJEnCtXJ6ESuxdZYl6uvI2U0WcWjEU7sQ7GJCeAYRCnxxca6wu5ApRz?=
 =?us-ascii?Q?FDOebxhFy+JpZ3ptKMRMl4fjgXXhhvEZGxWVkDJPMK6BQfAumQP6zsRskSHH?=
 =?us-ascii?Q?N0lQx2yVWoSSpvfiiZm9nCKlrV/56ZTrMrebVaS9tyx0J5h4dGMrH5U56gur?=
 =?us-ascii?Q?H3zI9XfA3oDU4rg5yMZhaLjKVbPBx8quCheLtkEQPWvlZYLKstNIIzYwqgq4?=
 =?us-ascii?Q?tNEe0lF6pxwmIKkUc1kc7ZSUIPbAUksa4/HvQPx1x/GCLveMURxcuRXe1iXB?=
 =?us-ascii?Q?WwGYYg1RiD/OpzytJfKYM/onsa3uTPtUJGrsdfHTx2FsnqgXW6anNhwQLBEF?=
 =?us-ascii?Q?Fae2Vp2NTt1MZXNYn0oKvoZUkFpO2MwlSJPJUlmq02IFeGi3KFeWX94RfGSb?=
 =?us-ascii?Q?wZGWB3bIPH9PCrWBGZYf6G+RN+WnqqGZE92+ME3FZVraU2rBuqqN+0XrVaiR?=
 =?us-ascii?Q?viHz9yG9OqbOiQEw6JAWJNU37MSy6w9DE5N7STS31f78jlXSvnJFsaSazifF?=
 =?us-ascii?Q?qWWZz43Y539J5engBmnsmLrdqvmcxygKyIbrSOvywl2EsAfGR0eeQDr49b82?=
 =?us-ascii?Q?rYwuQSZYNhzpdd1vC/0Vnd+ubc+4hUjAPus5eSI9aoPUbQbIJF7oDPVyBCZA?=
 =?us-ascii?Q?Afn5oUtBMcT+1FyrRTtsOFhrZG0iNCa6mRNRWMJrngquAXnVttBa0yg6mA3P?=
 =?us-ascii?Q?Fb+lyI47DF2Cq/H/m189zl1QXOJjNVFW9Ko/YXZSqC7l/pvOkNAWj4hQRTby?=
 =?us-ascii?Q?NdoAmfs/3M2QnZDU8LNvaF6y2LgE4JxV4FdpJdw78e/P8HPJklB9cb+Gdp+v?=
 =?us-ascii?Q?gqX/6PavPcpmSoPJwZfnk14af3snWcQr+5epDzuRGQw1WrK+94bi83JbAvvT?=
 =?us-ascii?Q?lCeFEOBquJK0qU4pEyanZv7AdnPk+6y8hOGLWTsOE/3uXZNMKBkAnP3F0E4k?=
 =?us-ascii?Q?HJlOCcJ9+ueR51bO2HfUXAWSBB8OD/GvpHM4aX3ytw4r7RdQsMmQgkuDglrP?=
 =?us-ascii?Q?tWJNcpJoDxO/E7aFXl3v/sLKCOsnmspsQQY6H87KWt4Dbc26WQ9/PZWgH1Uk?=
 =?us-ascii?Q?dJgvkMUPYTUANW1CpLMeAEbMzGtls8V/eL1VRdidWkk6UMQiR+AG7oxnmyl6?=
 =?us-ascii?Q?EHbpV1aYTs3+8r0sQDaERLP/QlZH1KtxvUNOI/zWqYKJLLdlexIkaQ7jEL58?=
 =?us-ascii?Q?DmvafeH7L+gD5fhF1+u1Wou73RVwCiMWPf+Y5I7zG1iEdZjnAtPoYG+wxcTt?=
 =?us-ascii?Q?EfH3vjBSJ8BTsvH4nZ8p70S2DqDfilfTQPtms7TGl8F3UjYeTcHOOUVVUtS3?=
 =?us-ascii?Q?DvUDOoHAxsnnVQFFHG2ZQBf3RRsc87nnqkR6I2kLwC2tluE6PiaRTx16VPUQ?=
 =?us-ascii?Q?5a2PuA2whZs3RqZTy0KypOV3U3EB3/s4jE4gIuXWVPwyMwgbsEiOcQOqFG6C?=
 =?us-ascii?Q?hjTMSkDio+EDyo3CI75/beuZpzqY2TubPHEhmApZogTCXsyNLDgu/Zk4RB89?=
 =?us-ascii?Q?78POelfr3T5q1lruk1PpdmPM5wsHrhlmOIC6bSD32ZgAPzc66DspPeddP36m?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa2658a-f8d4-47c6-124d-08daffe220b2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 21:13:10.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzmBEUDQxC7OCmG6TV0rVR+Vf8g3UFPpAgrKLdHM1idLbnF5g/W023N3Em2SRB7BPZpQsq1OujfPbEGytgWPrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7262
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 08:46:20AM -0800, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 14:52:53 +0200 Vladimir Oltean wrote:
> > The main goal of this patch set is to make taprio pass the mqprio queue
> > configuration structure down to ndo_setup_tc() - patch 12/15. But mqprio
> > itself is not in the best shape currently, so there are some
> > consolidation patches on that as well.
> 
> Does not apply?

Does not apply. I guess I'll make a change to patch 14/15 ("net/sched:
taprio: validate that gate mask does not exceed number of TCs") to make
it non-fatal, and resend.
