Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541406C6B4A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjCWOlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjCWOlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:41:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2114.outbound.protection.outlook.com [40.107.243.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C415F22CAE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:41:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3BjYIHa2WjjgenpMtpwvEUVwbR0LMPAXuU2cM+fE5fkr/mO70Fsg3NYZCv+8pUSUnryX/+6WJg4vV97vMwt0If411fbN/gDC9bBN7smxbi/XvrRPVK+0pAS+sh718i+8WPRMO7hHhybbvtT/O2Q8uwTcdt03oHEw6WI7WGX426z6tu3jq/YGFC81GuAMxLuuOZsKJiNDqUrTMEYd7wouFke0I0IUPrr2Thq1sekMQjGMAl9o/L5bXORzVILwEsutRoM5KGt1R6/ADk3HQVz3Fv5+WFcHeILbD7JPmtR1cgk6yFLZN8iD/UTMUSBVYO4fSQqc4DtBunIfnVKSEXO/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2893fDYHV7GWdvrnz5UVAThynzidlm4A/vQiezwiC7s=;
 b=S5q7idzQdf4z8/FyZhYta2RpWKfPDDeiOb6O7FdhVDO26maZrBjcV6DUFyYMvnrgEV8w6Bx+H7fusfow6RdtEEbOkp8AOdjU9aYIyWQwo6waT37ZhCHOOlQKaXJyzv+YBtUWfQM35AJoy7UPSm1Nutp+e7el7zuMQrY6b2H1ReQWjCjpR4ML9I+4WHO+tP7o0uaz/k4VF6k+16oJsfOMRD3EKGhLRfW3L2u0K+Kn9nJ0jQANm8qefd2tzmLuBeU1Cy6FbuydevKNvwvYsQIyPtUHHnfFmg4dpsxtxAeGx3xGEWrQ1IGoaXAaKbQa/7i3jiGnF++iFJAHlwNHhPfMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2893fDYHV7GWdvrnz5UVAThynzidlm4A/vQiezwiC7s=;
 b=nR4HHLVJkX1NH5TncF67eP1J6LXVMVLEayDfSO0Bngu6ez+7krECDDzGbfofES6D1tZIft6qVAg6z5aGDZcod1H2E6jlOpzvB47lM3Ejfv91Xrx3vXxV4ICaR0r1sQWwVxa0XcWpUzzy8xQG1SpiYmbbOBQzzfuzQNQ7S4hCxrU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5169.namprd13.prod.outlook.com (2603:10b6:610:ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 14:41:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 14:41:46 +0000
Date:   Thu, 23 Mar 2023 15:41:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] ipv6: prevent router_solicitations for team port
Message-ID: <ZBxlI7LSDKgxAw3Q@corigine.com>
References: <7c052c3bdf8c1ac48833ace66725adf1f9794711.1679528141.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c052c3bdf8c1ac48833ace66725adf1f9794711.1679528141.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AS4P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee90d96-2798-4b24-ff28-08db2bacb9fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YwwAcqTlvqDSh29Y6zi1YOUFrPP2eZiT0Dih/RujqnXnlOeyEGmsgBhU8zB2XvAX/uBpUtSavK4onQ737Yb9lSLniHuarKzIjw6Kt0TE1InqpN+si7ZepNrXejHJmkSEqqc1i0I8dwIi5iEBtVSVBz4Mn+1voQPlWnjImKsECjA8Wr1byoefuRenkFhEjeZKB7YPaxmkCdxmeDERyVWqmD5DeV2wyelNGdvpplnVTIZX+yRPGilvx76S0b+xmy7DxJyF8Puc2r8JddSm4EgKNgs6Dh504o2HFZkLfDbn+p608vxTl1ojkrUTiLD8mTzWGvUKaL9aghO2S5DK7fQ4lSmq3+F/P6Ao7KU24zAYMLS67TOha4+pcOIjDyWNalQm4cbK+w/WxlXs4rDH798hRlutu7RbPQAH6m+3eYCDTBD1AE6ZRvNT7hkErfqf6GyDXoyFPT4A5QEZIvf1dt8YsZO+NrqFI3ZBcgL7phgSS9IWsrFgbQPpQe3DmvT8ko68sDox5KX9vQDTpOI3HqlpiR5phX60v9ZysO6VGWHUMDk4P9fiiNzy8o2Q9/RoskOUx3ux+ae5mWk/QCfL4CfklK+KUd3AHhX+rHn1cO70igPxHa8tL7MrG6gTmAxm3+dYhnJvbtuROX91+cZ5DfGqxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(376002)(396003)(39840400004)(451199018)(86362001)(36756003)(38100700002)(2906002)(44832011)(66476007)(41300700001)(4744005)(4326008)(66556008)(8676002)(5660300002)(6916009)(8936002)(66946007)(2616005)(186003)(6512007)(6506007)(54906003)(478600001)(316002)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LyeOYCmD1dRF8Nv4zJqG5J/PguAYIeuG9QTXXQdQghW6JQ2G2tUeDW4gKjmQ?=
 =?us-ascii?Q?3S5XBw8IMny8wyhvUD6cB0e6hEpMfvr8ycnzgIUp6GHyXBCZjYWeeqYBEZkd?=
 =?us-ascii?Q?BOCTC4m45sFZTCofAI+tlxKYtedSwtiIvn8CUUvh9cPvdwESiB9oTvsANjxB?=
 =?us-ascii?Q?z0W4B+GhQAHLXR4kv1w2dvitZ+iLEbAsmz7iVUHdgV1tT7/0yPIfrfz8t1WZ?=
 =?us-ascii?Q?Z/QWuG12/dVQc0ymYQZIFaj6eG2gJhj9zbnPr3BV5nRWemlV1sfDs8osLM16?=
 =?us-ascii?Q?ThH6GYVv2DpI2nFHUPD27LGO/BRC7JaetE/QtBymbW9VV0fA+icXSi1mSURK?=
 =?us-ascii?Q?CutDkxXnRfEyPqBAFFVcAntTeBYm/XvhMSDK7O3HyB9RxFIW43B7I/MqEIrg?=
 =?us-ascii?Q?Kap74WFvOmN9thO9iBqQ7r9/g17btyHvL6jHU/re/9UujmMxK/JP7chSXRB6?=
 =?us-ascii?Q?Hfqba/PYGeUAyAZhg24v5ftTVWfN99nyPMonOgnTp/YHXuNVD4Z//7m132eh?=
 =?us-ascii?Q?fRKn4Xi80DkLq2FWPJL+fD7cKvuEsFKwaGi7MeuavWZadKX9PLMm6/bvzgRF?=
 =?us-ascii?Q?ABiRmQ0ezAZCR7Nc0Rs1mA14o1isqeqD3FGktD/eD7xkKn1vipXeqf7XzWLs?=
 =?us-ascii?Q?zuT5ROq3YMwwfW5Zks1a578MgZFnrplJIbT7VbfQ2K5aY1oj8kPvxFXtCvBJ?=
 =?us-ascii?Q?xzHM5ukRdiisGq/ovqKT6Bf5pvjL2lYoBX2L1sFntUu7V4rNwqR8FsxcLs1X?=
 =?us-ascii?Q?bQMBp68ewOAx7if0EIdND/et/t/vRBC4ds57OFPAaplDZQ8EVBNNUHcAqtlJ?=
 =?us-ascii?Q?Sie04QKAc79CvCCYraNpM4FZUXEj7FA1EyAAgJTEgFv1BS9rM5hnSHn1OOkj?=
 =?us-ascii?Q?Rl1rMjgf7jba0fvCstTww/cee8i/dYg9PEjNVf43TWbNohZhAt9rsQFJrj9L?=
 =?us-ascii?Q?x8oro71GHXYc19rap3FA84EKCjVl0//kI+l4SMY97hVlkwimPZyu0ACI+8CT?=
 =?us-ascii?Q?RPFj9NasqB43DYGz6B3DIXv2bmlNcPzhbF8J8+NxLuEFxsg0miuMoWI83I/b?=
 =?us-ascii?Q?X5mjsHOM2DHmqLREa4y812AsU0chSEr29L1JTwV2p4L54uf503+30/HQdi8M?=
 =?us-ascii?Q?Xmmh+HpSEp/P19aaRd7QH/Im12647c/9XipZtgtzaLBkpO6k6qJPANfuj4dq?=
 =?us-ascii?Q?jvQmSsMgABKap7eammMVFNnxQs6T0FNEarw1vvRzJhPsbSu87V7wpunC6K9O?=
 =?us-ascii?Q?q8HE59+Fi4kUonwzBTzhAGbyxC2STwGtaVywXtQCDYbbQc+v71Ozqd7gQDS/?=
 =?us-ascii?Q?HVZXJcQYfi9E+lPFYcVHJ5BuyfVMsx0HhME8Q+atnksH4S+P9uDX3DFTRLKR?=
 =?us-ascii?Q?LQe9loxk8FelQY1DRoaMi/0sF3Qs4QkGfDALB7lXaDtT0kB6t4wix+fLkuf8?=
 =?us-ascii?Q?rgt2VDm2G57sV4jswEd7BuqMJxACnqYKFyuMAI04LmlVtydxYVbBssgBTgGe?=
 =?us-ascii?Q?jAu6gO+IRjpcGVvJZ5VdPbHhpbJDBjs7559mJVo84vx3gNdulsxCjmlgJ3Q5?=
 =?us-ascii?Q?HWxqQV6oISYsk4lbcpKQeitHSAJGGf5NXsvREb9zu10wb7s9nIs4daoHKr8b?=
 =?us-ascii?Q?utQcdVXGmDjShOQS76KrHGBKaROZBqJp8aswqVS9QaPdN/+gmmEWcZqcD86E?=
 =?us-ascii?Q?EcstKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee90d96-2798-4b24-ff28-08db2bacb9fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 14:41:45.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfwBHcQaEd0tjSQk9ab4K5cGg/JGSCcjsMlrAw7sVp0QQwO01p4Qv9eSw/fmFEw5Jow+ORyRnq2+10ngNt2HJz0eBrYKyRGz+UdhW/OfmB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5169
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 07:35:41PM -0400, Xin Long wrote:
> The issue fixed for bonding in commit c2edacf80e15 ("bonding / ipv6: no
> addrconf for slaves separately from master") also exists in team driver.
> However, we can't just disable ipv6 addrconf for team ports, as 'teamd'
> will need it when nsns_ping watch is used in the user space.
> 
> Instead of preventing ipv6 addrconf, this patch only prevents RS packets
> for team ports, as it did in commit b52e1cce31ca ("ipv6: Don't send rs
> packets to the interface of ARPHRD_TUNNEL").
> 
> Note that we do not prevent DAD packets, to avoid the changes getting
> intricate / hacky. Also, usually sysctl dad_transmits is set to 1 and
> only 1 DAD packet will be sent, and by now no libteam user complains
> about DAD packets on team ports, unlike RS packets.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
