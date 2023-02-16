Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F318869912A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBPK3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBPK3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:29:23 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2044.outbound.protection.outlook.com [40.107.7.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F65D366B0;
        Thu, 16 Feb 2023 02:29:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHRSlArW0G1jBy7FvTrF3rGRLRi7GeiOyLihD5u/0z9xykGepIUhlaAT3cBhqFsAhg3Yf4dcLX7/782Yjq59ukSkTMly0G5vpGgTnC6vD8FcpxZinPYjav8Fma6kltRJqXMCQysbwjx4je+bnXJGmIce/TDcNMHUK/S6R0o7zBNFy8Dl2r5r1t4IYKvXShaHhpd0lD8t+q3xnPzdJulWLGZm+iSRSfk5bf07pcUqnswd+I7KlQoKLsU+hQyldZkQ4Y1sIsCiBzzUF76pbSUhyHXPRRdxsiBKnoki6SJWgVNVONvmRqO16j+AX/MXVJ7U6m4GypwEpS0fUUOUHJOBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/WJ07a6e8A8aGMa/TAAYsnUiMQGLmkthSaTi5EN0/0=;
 b=mTbNQbrgWBhaqpsN+bgx5uI6D6oNOVtoRla1R6f3eyqhdjrW09AokOOBRbn1Nyktny5tAKqTisGo/vSY7hfH8lzNlPaLsRxOENv/dmv1YXYECWyyaFd54jIDL7eE7QEh188zDcYUiD3i+vF6lJ4LDmMUc//OWJxYNesfNNAZu0qnn458KLx4p5c3+OSr+rHybvfDO3O5HINVyjNuVfKEEK5yLW0dpR9Ohxp3yqBAZgROYUuu2d64ckoEWIvJxW+egKPbji0yeVOqbLOmid8seI12t9GVx/fT6eEhpRY/CDllaOvfhxtthNr7+YWd+W1RtZxpbmnQuoVjGUKBHXnf5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/WJ07a6e8A8aGMa/TAAYsnUiMQGLmkthSaTi5EN0/0=;
 b=VTje4NYspStD4zcX5Be7LTQAEc3xIpBacrcJQIM2pVdj75zWZNjsLqpthaIOojt4igGt2suWLX5Op2xy3AXpO2xGqTDLuoIQYB7qSPVFc7LvoLTg1E3YQk6vz9CYkkW826m6FLeqqKO+oCO9ESSaXIRHcU7mwfT/cmhpjIxXw3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7095.eurprd04.prod.outlook.com (2603:10a6:20b:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 10:29:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 10:29:18 +0000
Date:   Thu, 16 Feb 2023 12:29:14 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/sched: taprio: dynamic max_sdu larger
 than the max_mtu is unlimited
Message-ID: <20230216102914.wat37qsih5xx3wk4@skbuf>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
 <20230215224632.2532685-4-vladimir.oltean@nxp.com>
 <87cz6aot67.fsf@kurt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz6aot67.fsf@kurt>
X-ClientProxiedBy: BE1P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7095:EE_
X-MS-Office365-Filtering-Correlation-Id: fea21f7f-c2fd-44f7-a3b4-08db1008a8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJ3szp8cB7GQaAFaFiQD+bD7kzidDG4b8xg5QhdFtVxVN1i9joIJhJuQasqgDopnd45p6fG8seWL8v2KrAUIai8N0mg3gM7PSwdJUEPoJVFwsXbLlKlgQec0C63Fd/FTiJcYb0p+w1WTk2UmRqGeSmaac4Iyaa5k50VaVGmHqYSvtUfkHXzLbl6KTMbRQCo1uh6exFOyah2luHSCmrrR/zoXkUYwgINuSpvgE73hghQXaja+mTwURzKvaSPj3+gMHQEdry44XxRdy1LOVU6SGPeRWFqGBzcbDU7sCQIbdnfyUiTiMVY/dvGOvodf3RO5RCJCByGDF0kyDScChoyByruUbT3tSBAH0k3dz/2h0wc5WXr2PM4JbhsiwLy734jiA76JnInTiDmr2dvzn9TOgbPl+F4UJt53Fr58VOycBTdIIafbA9KtYbsEJq607UYvsckCEo3EtALrkfx5GEI9kZTVgHuVFV1FdA9rPB+fiMKNjq8sFdw/8bwyNgPoNyps58Mdqgez6VPr90AqO5XF/Ddrhqz9VlUvGf+s6UwT5mOM2cIrtqiTDst6AysQEUsc8F42hTkv6N2SVHvocUaNghw9CsUYadcNxMPiOtSp/HoTnj8cZBFEGfTCqF9BokkOsZ6SvjPmTKIOYso4i4GfRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199018)(44832011)(66556008)(2906002)(54906003)(7416002)(5660300002)(8936002)(66476007)(66946007)(316002)(8676002)(6916009)(41300700001)(4326008)(478600001)(6486002)(86362001)(6506007)(26005)(6512007)(186003)(9686003)(33716001)(1076003)(6666004)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZnjQmDFtW6uVzUYzV4jo+oKKUiskpNXYiszkQnLWbtvTzKGJjnMPOhLLIdoT?=
 =?us-ascii?Q?hBWh29/X0bLtHHwD7XpguczW7nBWsZJ6gdLy29mbOrV7e5YNKri11/CWCoAN?=
 =?us-ascii?Q?7avYLYs0UByfrnjrYjr4y7ZjlA3x12Z9OD3cDUKXxghyM0UPfodKHlOyEqia?=
 =?us-ascii?Q?g6ZGZwnHix6J4Ecm+kI+NyWIQqMXx/EYJrXJ0MVd4PUlQebKBN9a8meRU6JK?=
 =?us-ascii?Q?3vF0kX/Ze9SheoWdgW549p0N7M5K1MBcbFebur+gGa222fQLE87xLbvCr6sx?=
 =?us-ascii?Q?VLpoeu1U+pLYwyPRRAAGn0UP+y/RvPOAuTPdw/6M+2XfIEKYPF13QojyVbpI?=
 =?us-ascii?Q?2U/PNkoEhy3Qp+A2iiBGCmM/Hgfy9BRADV38zbep6xsma3thnJ3BwApJuoCX?=
 =?us-ascii?Q?0e09Y+L0J+FrlL/0BRfkQeZ/MBGNh98jjHVHw9W8Mc5hq4qm1ku5q6YyPt9o?=
 =?us-ascii?Q?0LfxMhQKRUc9hoyBTYd8AFfJ11kr6sSdvWw50E9ksqbC0MyI26U3BEyLLB/y?=
 =?us-ascii?Q?Ol2/lDgpTrnKy6+njYi0++lIDf0Dt5YYfEFvIFheqlvQ5aiCqza8OCNsd8Gi?=
 =?us-ascii?Q?cP57ZvtlUTF1EHn2ziWM9htYVQQsgX8H8AIYtIQjZ+mMQQN0XtFUWME30PgD?=
 =?us-ascii?Q?o5mFmrt8hJJPq+W/820IIgW/1ddYEQPIK7BMm+6hM23IpZpIw7aBEDDfdKXA?=
 =?us-ascii?Q?tpcXmcIDu9jRCufEHkxukbyuW6UKqlXtqSvFE78VIoT6VOst50ot2/Hx++ox?=
 =?us-ascii?Q?HbZD57hDh/QHDpuN710VoZShLlS1s+TmziWhHzOqaCiVNZbxTB0+UEsH2FpA?=
 =?us-ascii?Q?fpDxkgaRCRmwEcRre2Y5syfF9ShiGBOked8zxr6n396yhf+c4agi3iYpPA45?=
 =?us-ascii?Q?4v5FP/frmvgL6CbI5xKV7Fvd/wNEIuYAOEu3GpIlp16FVzbEqvDtqci7e/wq?=
 =?us-ascii?Q?OaxNdp1L4+/Nx0s9avifdoIqzufyd2pfvXh/xuIrXcvUWp/O9+Jk/ZPtpPCH?=
 =?us-ascii?Q?pEr1d7GfG5mnHStflXPfFF/Dvc5f1F6zU3+knXJLvyM/c/IvcziuSBcJT2pj?=
 =?us-ascii?Q?pbo64B0GWI1U4nf1T+7qE9BWE27YESVzb1NJozHcBgQRst3yxoIDSPcXGuU5?=
 =?us-ascii?Q?tgkXMhG7f3qLuALC/msqSRgq72H4vGthnzxoQCtvGHMjpoenOUT2h4Y9Wih4?=
 =?us-ascii?Q?WeKuupWXkN2NUlabNOlQC2YyEbcDSlyHWpsLJGyCZ1WhwzHn8NoVDvJy9ahj?=
 =?us-ascii?Q?59GEgUFEzOOZk8bGF+sI5RBahmWv5sdS/Ll4bzS5L489mAwY4VgQu0bjrhmm?=
 =?us-ascii?Q?XTAeqeHyCW/AmIKG0Mw0d8a25J3TWjBKixdcoE1ore804ggFZ5LgUJ2Xi107?=
 =?us-ascii?Q?WSCTJmTITslvrd4rcaBCZIduzveyq5jdlmehQ/xyGZn//SoFYAL+bXKDInr9?=
 =?us-ascii?Q?fHfHRX1Jwc3ekYuIvEbdTcwP3DaWO66un2I5V4HvCqWi+WOIVSnVje7gNmLT?=
 =?us-ascii?Q?dMclSVgbAtvwU+7XS5vZMiiXUhRH2djK642u+EJ9n28ZYAaxKFGa8lTlOvec?=
 =?us-ascii?Q?ocBGn7DYCO45o1cw3WfSuvZMqx0mw+e1I5rQWcF2q0DYApkRdzTNAX0hrFNo?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea21f7f-c2fd-44f7-a3b4-08db1008a8ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 10:29:18.2516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRKFJrOea/vmdVmsuUG/0TiEUgGHYI7Oe+sGU+r9q2RXO6qRPyMagMptijDiNQ6oTaYbuIkWNk5ibVMtrFAYsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7095
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 10:28:48AM +0100, Kurt Kanzenbach wrote:
> On Thu Feb 16 2023, Vladimir Oltean wrote:
> > It makes no sense to keep randomly large max_sdu values, especially if
> > larger than the device's max_mtu. These are visible in "tc qdisc show".
> > Such a max_sdu is practically unlimited and will cause no packets for
> > that traffic class to be dropped on enqueue.
> >
> > Just set max_sdu_dynamic to U32_MAX, which in the logic below causes
> > taprio to save a max_frm_len of U32_MAX and a max_sdu presented to user
> > space of 0 (unlimited).
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Doesn't this deserve a Fixes tag as well?

No, I don't think so. It's just so that the user (and later, the offloading
driver) doesn't see arbitrarily large values, just a simplifying 0. I guess
it could potentially make a difference to the software taprio data path with
TSO, if the max MTU is comparable with the segment sizes.

Anyway, with or without the Fixes tag, the patch lands in the same place.
