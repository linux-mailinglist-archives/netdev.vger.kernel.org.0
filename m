Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE57E63C5A5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiK2QvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbiK2Qux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:50:53 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495176F82B;
        Tue, 29 Nov 2022 08:46:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLR05mVsp+reJWBk1RrjhkdFXjrzHpC/siQk+78TvtoyeOpfSDHvk+vR5LKxBF5bOeqyEgNdrbUtwY0PaiCLOHML4Zhq2Gcb66461yKZzj5Vlwuj77mPxslIvVb7cxZRt8FU3ETtmFUEFMA8CYtGTWTnxk12ZjAxRgJEsc7VyVO+UBtA5mSnQNAGB+nNVroNXtqcTZG50VpJrDquOPAXDs5ijMYJEb3tzFp+ZUdMNwpvavzTgtQ0dydJdJSA/7joZp1u2eXc0CXKBwiWu6yizYI3EczFEXX/CX6iQl9UwYejRBmsSfMKWJBTQeCnr0IrIGdY3IMsqPfsBw7pHEyjBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+nFg35RId0EloQSkdfwvWZAjifuD6NH3QxRXFfRzCs=;
 b=XbYWCF4Gd7FRu8hCufQCYAYN7yt+Zks+YKNkpsm/dqPaBP+UHKOFlsHlG4O/8Y/rQZm63fdT2QGH53Te/QvENjweJzUIaaXNJR7XzaGgGrJXOhILeZpfZRc4oAZa7ubBWHRmlrTLuVINcV0xU13tcJKkp1mliHsE62o+R2twCTE+f0Gsgjcb4kZcsRkp2/tSA30Nh53Fqwpf/pOd72sTS/OkiH1sgZREebIqcmmShpB0lHYGpo6oyf6rpnhTMje5XxqgkCmY7nyop7E+4kbBME1Q5o3pOAokEBmXYiDMMbXMtd/d109exlNAlch4fIVEAs7luc0981dGNLX2tp324w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+nFg35RId0EloQSkdfwvWZAjifuD6NH3QxRXFfRzCs=;
 b=iY/iGDhN3SFjpNGnGOVn0F4RwNyPa7bmKqTUNJfyVEPzDS5mNXAbTQo0aRMX5QOuQbPXbY6x1F0C3kOzHI0mbBS5tqFe7mUAJbFMTvb+338aGaD8INdMLxpVnO+WCr3HQjTbxKFvdWk10KiTTBkQfLufkyNCA0S1NjofaBWRx5E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8545.eurprd04.prod.outlook.com (2603:10a6:20b:420::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Tue, 29 Nov
 2022 16:46:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 16:46:23 +0000
Date:   Tue, 29 Nov 2022 18:46:19 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vigneshr@ti.com, spatton@ti.com
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Fix RGMII
 configuration at SPEED_10
Message-ID: <20221129164619.mq3b4y4cxj2vvl24@skbuf>
References: <20221129050639.111142-1-s-vadapalli@ti.com>
 <CALs4sv29ZdyK-k0d9_FrRPd_v_6GrC_NU_dYnU5rLWmYxVM2Zg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALs4sv29ZdyK-k0d9_FrRPd_v_6GrC_NU_dYnU5rLWmYxVM2Zg@mail.gmail.com>
X-ClientProxiedBy: AM0PR10CA0088.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::41) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8545:EE_
X-MS-Office365-Filtering-Correlation-Id: 50602a3c-8aac-462c-e778-08dad2293fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07T/Uj+ZlOnLYeutcGFzyugXYQ33HZPd7iTf4qE2sySKXmh86onwGrSHITPiMYlLAQsIDpcNSeDCr5dmytB1V9O/QtmmakX9wn5xCTsuZmMCBQT+Og0rxhiVcZ4awZrntjL6qilV7041IqBDBUNHptpNkTLqc8hmz31+mnNeByxEVFq1m8bIDIld5iI17SYUpOEzSGUGnwuUyRfLPQm6DCd9Ko/C6yPffoePB72nK5Sx75qPH49ZwrGJLMmtWQgQxfAWG4gjTWximLR88B1fp6Z3Zerd3GjCYZLBa9DUfqptHI5IcIQ/VgornTEf4S/dGHL7XuM86cWgaZ/B1R3STw5twKtXBrAsuNWKP/hhPaGFHgaccUzMd88Imwxu3C5hlFDf6R8xVOfg6uVV/57zXkFQpW/mws5JIIe1LSg2e+0LHwxxNNQuE/z4Dd+DIPb5ff+LbbyuAScNt7ZfOqDPQt6DCAPl49pMGFtgBPZKNerbCnIk1gaZG5udI024+q4GE+DIgmnFqUujKEBlBBpWzwj9v0KzZ7KMdtgLHW6o7UX1vyYTHPt6clVRVRtlrF1uJLtvgi88vetVnqJQJN3E6cv+oi6T3FadaJtf3xGr17v6nTrryRLfV2EOGW99qZ1zQ/oUxL99cTzond5qB9WK/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(186003)(4326008)(2906002)(1076003)(8676002)(66946007)(66476007)(86362001)(6506007)(478600001)(6486002)(6512007)(26005)(6666004)(9686003)(6916009)(316002)(66556008)(38100700002)(4744005)(5660300002)(7416002)(44832011)(33716001)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M7mIV4pPna+AgC202W7gXnSI09FvvHCWQ4PIKj7OPgXY8sIQCXglKd7y7una?=
 =?us-ascii?Q?6llbKYMm6UPWUoho/mJvwKzjWHdtVWktQtHwEgL9PYCuK1FTQC7unBPv4nlR?=
 =?us-ascii?Q?OuEkbzgBmP8hi2Dam2tdQl85kvA75J8OIFDb+/UJDk6dtw70IFNYPgByhBYB?=
 =?us-ascii?Q?J7VOZcn0PkggwCd+imTIcTZ3HUljHZOnCtOCiv9wjGO8FoeZUPFPyntaHcI4?=
 =?us-ascii?Q?/xpeh4q60ZQhc0YTvzyL9zXHOKizfwBPlh6q5FYWB/JxyOtVgybjNEo/8Agd?=
 =?us-ascii?Q?bGumQcjHnDU4eeLKeaLiGBBw5LqxmtazN7lhQRIlm24oWzfBpdQEfPX0Q9y3?=
 =?us-ascii?Q?ZilwAUHSnYBCJp6k2w3AT/vzcDMAhcStfRwqS2MpoIBflpCWfzlqujWB2MEw?=
 =?us-ascii?Q?12XFwvs1J1Qql2YxULkT2NV9eEErToQXy56JgzTkhsTlFq0z/8pVw2p3OkWv?=
 =?us-ascii?Q?W6JWp/EvBY9obaAaSjd7EueBl+RQtOWOMlpkunVJ6g6bdcbNQo1s3ADSpK7K?=
 =?us-ascii?Q?4J1S7w6O4/3/McOtwy6v5odPk5lli7kKnwIH+l1wvpBzWDh8ktsh8RlEehNH?=
 =?us-ascii?Q?XH7Duwxb8UtZ9RxqoX4WAzJE2ITLoOI+JcWv/K8xLzlEeAYwfxIglBgRTBYu?=
 =?us-ascii?Q?kuWhTWazWR9boBKvZnVsb1o5V4wjTSQVJgb0ndrI+e429oCe4CWvKlo3mwEK?=
 =?us-ascii?Q?UcuFrVOk1vDdrZob67riaQASmMgyXCUnuZo7IeQNcn0JTXXhOlppbpAAAA/R?=
 =?us-ascii?Q?67JUJ0Ff6C+xD4BBXBcTZVm2gYwU4uCWkZIT+kpB8Aks06A/T1TwZCqYdEqj?=
 =?us-ascii?Q?PjQu1Xf/iR4dMBj6+8w6Oeda2u9PCK6jC3Pg3al0IpMffbq66iugsh8veND2?=
 =?us-ascii?Q?XRVxCyUDLjYZAXBzg7BHz/puFG97wYWSfNKCIG+Ev9ueoEwV2XXSBMnYyNeZ?=
 =?us-ascii?Q?h9/IPSDeK5s6OUix+ehXcDxcWx2YDjIYM3kl7qtsBF9jwkCVqPbe3shP/etq?=
 =?us-ascii?Q?J6oufp1tBKQhVdqMd7RmjH/ZnxZTortbQ3VpGwLkOlJf1pD8UwOHzPwEMgWQ?=
 =?us-ascii?Q?jp1qAaSX0xjWyvhlofPGKaDoP0f0tBnVUVXktBxi/O7krEsxmbhcFvuSKTVA?=
 =?us-ascii?Q?AKRc7UM+2LAo789mIMFPqatO5dEE6Wyjk9QfgwyfIwSj1iVsrCf7RJDpGhuT?=
 =?us-ascii?Q?rJbAfZirdTc5fc2l/zJ95k9GHcEcZPZMg00zTw6EEEGLXmnz9CLGrxRUTaoo?=
 =?us-ascii?Q?jcz1fiVgjN3Slgh4QZegXKHZvKLuqYzj7jCaoLR443c+fM91teCctd6HyaXj?=
 =?us-ascii?Q?v95kEgZCM6ByYXm6RC1Cw5tmhygWtadUJRBjMaSRHey0WQjaUNi54sU6U9rL?=
 =?us-ascii?Q?+ITsb49QqFuLhghVRTrh7MFlHG4S6KvPj9s5wasQvFMN6M2bA7s66x/0ZaSK?=
 =?us-ascii?Q?GzPuJ7YqIHwpdOmx+xkWmGZtbyAV5wb5iil8NucMj1yclRTpUAKTYvescJZF?=
 =?us-ascii?Q?wptz0pEC7FSzpOa9jJKcA6ZwwRlzGtSqyYKENXwTgo9Bwvc3JoW/2Na0eQMI?=
 =?us-ascii?Q?oxEospHnCgvPkS7p+kPo+SNIv1c4TNhx5SSGqdsX7nO75GQOwZgK6tHSA9ot?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50602a3c-8aac-462c-e778-08dad2293fe3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 16:46:23.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrKBLMEDnuIzGtnoHS7uuwJQeo41eUrQSoCZ7cA9kh7csqtbkL+6v1UOodX81alturMNMeoREYYn910CObGi0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8545
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 11:16:42AM +0530, Pavan Chebbi wrote:
> Looks like this patch should be directed to net-next?

Do you know more about what CPSW_SL_CTL_EXT_EN does, exactly? I'm not
able to assess the impact of the bug being fixed. What doesn't work?
Maybe Siddharth could put more focus on that.
