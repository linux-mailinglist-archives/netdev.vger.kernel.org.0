Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CCE68B001
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBENjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBENje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:39:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2113.outbound.protection.outlook.com [40.107.93.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607F03599;
        Sun,  5 Feb 2023 05:39:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRP7QoqDPkFs3bEvIyOZ2E2NPoyS4Qg8xd89cma06M42ipVS0PmvGB0pRakRgRy1iTVnSqBXpe9gpzJhdGpxW0AzTTM5HuORixEw5dmZB8EIroZgVOw28SpsuWTdv6fG+2VcpdI2MT1tFV3kaFyu5XEPrfMbK/fgrz7S+MDhqpTHb4sEvJYZQqKCwVZXZftctjjVhhPrEtPfvH7gnqwDEcv7jr4EtXyI/EOw0VNyXmfyerdlzbOFBhLaGZadY30545kaXCz/BhMHjFK0AjLPOmIVaDkA8Rl63uL7lJjQ2D4625Zj48OckqVIlsIxq3sqRXn3upS903pStCGwS29RzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQG6EoLT7XA+GQ9HCa5vsV/DB/slD9pGst+kON2xK/I=;
 b=Rm3aZA1fwQe2bOyesV78O2oXsfGEFcxG5liaXn5BbbHkf4dDhu5S8YO4dPl1YpprpyW0kc+nnUYWRN/JQd6Wuq/elrOWebwJdFHzk9IEuyJsN4OgAD3h4f9D+xHrv/tPCc0t5YNx0MoFTLxDnI+cnmJ4uiKRC/zGBezxWJyhAKkNRFopb5CByN03B1fHkGHmw8yGj/KAOEbrMbS+QQI8h/HN0P88Qr5lteD3Gfd3XnsCH1KBiYEshlMOG7ry+pKmkaAfWiD2UKNSIOizN3u4v69wSyWSzlB6sfOfipYnHdXpNNZ2xSYpL+Qz01a6eHqUwuzgN+zVXGBrvw4F+hOiZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQG6EoLT7XA+GQ9HCa5vsV/DB/slD9pGst+kON2xK/I=;
 b=RVntAQ80DCdTUCkYhJaMrBiFqstplhf046aVG+b3s6lpSg4hvIhU522iihANHEnXcQYXHSI6qNz0vNjgscNFJtuTqkabCiEL18OOWgE3jGrIBkGPAfOcTxb1DOY3vLztu0ahhXebznoYOwFkB9bGT0+YBJiBfgDX0w0+tffftlQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6114.namprd13.prod.outlook.com (2603:10b6:510:2bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sun, 5 Feb
 2023 13:39:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 13:39:31 +0000
Date:   Sun, 5 Feb 2023 14:39:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com
Subject: Re: [PATCH v2 3/4] wifi: rtw88: Move enum rtw_tx_queue_type mapping
 code to tx.{c,h}
Message-ID: <Y9+xjd3dXneLjD1i@corigine.com>
References: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
 <20230204233001.1511643-4-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204233001.1511643-4-martin.blumenstingl@googlemail.com>
X-ClientProxiedBy: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d638421-8253-47a8-2c77-08db077e6947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GpaC19NDAfMLbZNmvWwr6lAFmDk0gEOqfsgPaCdmNsjyeIyZL6JbpKwkinIS18VYzk7okJvmeE+gsHjwdBZNZBk0GH2S8hl1tVYiam+3ROtqbdosXqvT0oIl2yiTsvXhkvWHDz+s5s2x1s4pPQRsrkYD3+hrMB2fHGrFeLX874uT7QAb+s7MOeRpxucvD6LTv4HYyGLwy5vjSl5TazJ5KyQ0v4YFbZRqMQeOqmGemhfbhTa+9YELMPy22MVwLfwvVD+xoHFUlP3zvazLxdgAlGXvLtcL5FmQmXVdgSS3o8QeaB4OjyhLte7to0Tl0menvA0fJuMKq9gmIswHF3izCBNs9n+fdYDULFF0CVcBbNH/wh+kWDu5pZbw0vBn3S98m8uYfzvvT35sadaasIQRJQlGIGTWbiTxR7O/LbqvRP0ujExI4r41pux0xsKSSFMYgF6Z6oxhhBPoS1Yx96yroC9R62pnL8pzp2vutDt2dpidq9XdS0f1xisJKKGR/OrZrNQZqjM69pJ/MmOMdBBPPLivNYvQm+EPQt/4/dj2JTaMGoRBsCbrmf0ZB+dva75S1ZNWCKfyhZnji+d3zna31JcUzq6gbzsmXIGQABbROLzW0lUTgAZ2lOtZDHo4vhPa4jF3bsNPC7+qLfvfK8TrZ0esRYKcCvCb/jH6+G0qaWK6wq93jyxg0wPENctZ5lAD2Tf3RkJ62QI3W+SYEkNR2sf+IkFiPvj347vCtvYqtnySTuoeNA+4gNtf+UkR8kE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199018)(83380400001)(4744005)(2616005)(38100700002)(8676002)(66946007)(6916009)(44832011)(41300700001)(8936002)(66476007)(66556008)(2906002)(86362001)(4326008)(5660300002)(6506007)(6486002)(478600001)(54906003)(186003)(6666004)(316002)(36756003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Th18IOQbftAmdu/G9lmMyVPlS9jBEe2xQrrXWb2OuQjcvB1NIvzGSsfcuNzL?=
 =?us-ascii?Q?aDafgHUAsRmL4p/CndIHbNXwwPnPtMB8wNgW1Js3Qz3yKixcYHQD71IF/KF5?=
 =?us-ascii?Q?3NTkOpdExUIOt/KukJPIyjYlGfsdgE8XolQ4BfSAGNhNYmNFlcrNrW0FYHlZ?=
 =?us-ascii?Q?t2/xmln6T/xQ7rW7HMb/VWM3SLUV+ubMtccLkDdRoyrx0Z3+P8K4wU9JJMOk?=
 =?us-ascii?Q?MHYUalwoIdlfoE+EbYSGPCQda9TLJJf7FUUe8fNdnCwAK0MKyC03EiTGmn03?=
 =?us-ascii?Q?oZ44PuVMrB3DG80Nxw5cG/s8e141ZSj5qVIvvgRAZIZZ21JLfnCq4qdpKMZL?=
 =?us-ascii?Q?xuAjo3oW55QVSxSyKt2NUibvZrfrHQMBQr9g9eA5PsDjNbxp1jKmDiQPgz+x?=
 =?us-ascii?Q?P9Mgo4sBw/8yGblxsUNxxRt1phX6yfMF8+sO5ZC1ZGVQEYXCqrf7Atb7O+2e?=
 =?us-ascii?Q?VT0tbi8yV+ClU7Fe0G0LI2Qc+zVA9CkiTZqYK4RaPQsnMwzYHtkzvd6P7Kjx?=
 =?us-ascii?Q?CXqLC5j+0efYVvK56grIJFGvqyzBiG0BgOdSNNz6pQPXqufoPTqjqOAxPJvs?=
 =?us-ascii?Q?55lf23NXIWgVW4dlNs01V7aqhRU2exbobYbO91mEg/WGPCSspk4mvRWgX3dy?=
 =?us-ascii?Q?4Tpy4PjFyuG+mICJQbwshbvuXwHRn20xEX6vZVlOSjleKUTgzBvA1wV84o81?=
 =?us-ascii?Q?AtB3Z48t4ugTxLv1XOBY2RicvrXLnkSBbvbgFCt3vGuhuwufzBs4mWyrvl4W?=
 =?us-ascii?Q?fZWpb6CsAyqaTPPBfNWcO46vb4dperpKHFjTJbxK5hy/9CHfzsbByqkZJgi+?=
 =?us-ascii?Q?vbKTU9KaUQSnjoV+r0/CbgI45z10LqxL9pvGxJIzjKmVS+8uc3NUuputvT5U?=
 =?us-ascii?Q?AEvmKOe/iLIYiPjZYqKAfvX56cyE9JxDg+cY1HW4wpuLYkGvQljsA9m6jDDQ?=
 =?us-ascii?Q?ccXRiUu6DHoOXSPQMPZ+BwHkiyjG6J18H57aBiwJTv/yfS7qG+iBW7cM7JMs?=
 =?us-ascii?Q?cAJwyqRPTGBc0jR44e0WLPK2+XRaXqnxrzT2h+U0gJogmAbt3TwiIBSLJ7GM?=
 =?us-ascii?Q?SNufqbKyHXtKBGAcupBVQA/d3Nv8BmtqKMhN1zWfbY/I2wUOG83OeXj9x8TM?=
 =?us-ascii?Q?rCIZ+22buCsl6DK4R3C/z++Y8vx18dJoYucNGp5RvdhqEJNsEFwLAidzL1lf?=
 =?us-ascii?Q?bLWakGjdesdSg3yGMRni2QEkiFYyIC89LJSwsJ7ImaswXVarIrJ0bDfyPEDx?=
 =?us-ascii?Q?mMRQkkc8dRGxCQr9O9Ef7Iw5tH2roAoIV6E75+ke/WEut+nuqeo5f+jYJ3fC?=
 =?us-ascii?Q?SdFUzrtBHmfC32GBcl8WkcynOBdWly2JMJjrzwyKx5xieubBKn3rcdRdIA1P?=
 =?us-ascii?Q?hRD1spFdbPZf0q0Arv1uGpdkIZ9D2SEgAemHcs/+/+r6XqlamMsTvQL5oxYk?=
 =?us-ascii?Q?ush218FNf9Z+cp/+1bAM1uU81ZHekWhHqr9uwG/p/YydDJUQpSTgk7+faLu3?=
 =?us-ascii?Q?Wy9GxKgslM9TyLOsaqPzRAGYhWAhF7rzes6RAH4jNC2FGYiIxB/Aw0lktZBW?=
 =?us-ascii?Q?XpUwlo0iTOdwhdUTN89vF1T6q+TWUadsRCbZYO2bl+DDh4nOCXKrwmjGUw1s?=
 =?us-ascii?Q?b8wyiw54eFvV3+Qq5/x11cj0RxSxvq/hey9mioxfAiFecj8WmBTTgGa/QIOD?=
 =?us-ascii?Q?a/M7xQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d638421-8253-47a8-2c77-08db077e6947
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:39:31.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuLGDjTcaLBLHwyVCKZi/AIY944HUE8KONKCqaH7j7uYzw5UE9l90v9oN0oRRgyCh2qKF17odB9nD/6b1Eof7KN2/tKlukt6PmN9qyWEjUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 12:30:00AM +0100, Martin Blumenstingl wrote:
> This code is not specific to the PCIe bus type but can be re-used by USB
> and SDIO bus types. Move it to tx.{c,h} to avoid code-duplication in the
> future. While here, add checking of the ac argument in
> rtw_tx_ac_to_hwq() so we're not accessing entries beyond the end of the
> array.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
