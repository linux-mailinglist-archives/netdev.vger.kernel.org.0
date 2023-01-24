Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1759A679BBD
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbjAXO0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbjAXO0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:26:21 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2A23E0BF
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:26:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY6+ZoXCTkJdGm0htA+0IEncj6KB0JOkW9y9aMiwSsGGBwiasUqddJuMofDkWHAgHhYL4ZbYe3MPzJ88edx67LZiD5w9ZHdKhx40YYx+oRCYonS386E/Y4zoCxHMxdF6jbLC603XmobtMk+dhBKGj4AhAvorzBP1yTcHb2wjqjRObZSvRQ8F7MlNNHrQ8SZYrWh/wYI3oAczxhWbllKG6uhDklHQPDKsJX0uW0zu0sXfG19In6ZfjyzVtER0v6ZKeLVxBZX5LaRy1QX/C7emvXMjZSLYfUCdSynnl0nrL0tdboyrv9qCrOYnCxdn5yez2+hcdGnXIZmky+sQnMIkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+aDVJdBxVtXMiQhz6rIGSx6g36Lsuu3bY0mhfJyZ4E=;
 b=CvbflOuaxFHV8ur9Y9Vf/SuI4PXROSml/+hgbdn7QhLtLtEPw+w3u8+4qXgRs/F3ZP3XDqPwmaiq2nOzYTMeRzaHm+GgFvnZnuAMkQCS79AW6Oa4TgUtNX6Ky50Y5BwkJfQ/fmsKbDnuZga7g6A/aKhrUdf/i606xAJ/KWj2rm4zZTmu07Q2ml1tX2cOWYYXTxev18wRwXFCtzjZWQKLWYSVi6jWftqvxr+jjZrivlxysCBsmI0vG2pGKIsUuI4jhpEaiVWPgUODhnea62mKY9sZWKLsVt4L0q417gs2E1lRvmHArbdJkvph/+fsmZegTzqdfHzsFsP8f7bFOV7Ttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+aDVJdBxVtXMiQhz6rIGSx6g36Lsuu3bY0mhfJyZ4E=;
 b=o3KexHQWjk7dxZkFd/UxbIkF2NNB+oJizTc6vIlgXyFgH/5Xvn2vvX9ScsIjqCXSgBNI5imnXpwrN8vfxOPExoUy4eRwPeCWyjrJjyjr9sxpm0Fpb7Pc5+ve83uv2vsZPxn+sV2CDzp/wrIXg/FhCW4wxsuGTRTRawqQpYbB2yI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9197.eurprd04.prod.outlook.com (2603:10a6:150:28::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:26:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:26:17 +0000
Date:   Tue, 24 Jan 2023 16:26:13 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Message-ID: <20230124142613.avrrz44lr4dcqxc3@skbuf>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <3c8934fc-c783-11b7-a2a3-3e29b544d5ff@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c8934fc-c783-11b7-a2a3-3e29b544d5ff@intel.com>
X-ClientProxiedBy: BE1P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|GV1PR04MB9197:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dafc831-e8ff-4543-1254-08dafe16f43d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48Vfkm0sfny/bqTjiMHlsJBlrFjc2nEWGn5p5ZSPWARIeBVgqnxxH6dv5cE+v/aEH48q7JBt3TiEP6TqLXJRNNLgq9RbRoIOdV1mpARufcIQP6IYXaxRHJSK8PejvFi7mJCycmPKNWRC8Dcje+8VmI5hLIPiV4Ev/tQ9QB0EFhBU4rTeVUhC2v9ODmJFfGD4xyl7cbeIQIjF1zPgOOSidb0kILb1pcZzeYDsUmLCZ/LVjXCA7Mufkl1CoA66uUUG4s5oDCia+lq7bZLdzVNf6Y5JS0B297EwYxIzobS/5En2+AFV4SL6jml5qcyYlqrt3+txkLU5ZrbM2DVLWFe7jDhninXFrBHqa8te0nA2dwOSz8IvM5/mzJw592k+540Nu/1MOss/JPkUYbhsH7f3K/kPpMl7frDKMP69QdG7RfgOvrpvQoSH0OarhQ6EQlMYtJiWLCAD6+b07LI7E9h0XUem1aouaj4xPEB/z0uORfWq3TehWadgVVNV1gGzznQgQvatHUKLUZuysNjcJ8yCo9D3mDV1sI3bNghqZaN4/K9Fv83KfYciBt0Hh2IcJHzfKgxvTaG6lH2u/JhpbY5LNC8ypaTl/FVJ6afcXW6yfk+1wJfLMDMUc6zTqEW/oeleFQx3QCWj7loUePHyvkU+fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199015)(33716001)(1076003)(41300700001)(2906002)(38100700002)(8936002)(4744005)(7416002)(44832011)(5660300002)(54906003)(4326008)(8676002)(6916009)(316002)(6506007)(66556008)(86362001)(66946007)(66476007)(478600001)(6486002)(6666004)(26005)(9686003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9orMvJYFx2+CFHgTSsjfLjX4RabN/jSUfWJ5nk9EokX/JVt3t6CoFP2DmUnj?=
 =?us-ascii?Q?FXBXGXa3qpJbU8ZlKqJZyHcjn0+1LXrIo9c7ZSXjLh0tI37ivUPlswAvFCiF?=
 =?us-ascii?Q?dm1bddFShNMTxm+1bdgHFPIGHUAM0I3kK9WgvXhfwlPVnM4DOPGatGnPffr1?=
 =?us-ascii?Q?7T22SfzXcuNKSgODSCCTl3lVj0sUCu3vE8kgwOAsQM0wLiz1KD/3YS6Y9DoK?=
 =?us-ascii?Q?OhofMnyVBqinKLrUqbu5OgxyYJB2CO0cVMt703uA/l9FbQVvGQTMrf8vqP5m?=
 =?us-ascii?Q?FFE5OoPXvSUTzYnnzC5jimUOnOgWylA31kD/BHE2KkE+GQcZdu0s5bO3cmSC?=
 =?us-ascii?Q?kbz916cBXDyMHNQpbd00E4AW6fO5MQpLv74mlgRS/YD2zRT9xfhwIcSO/1Cu?=
 =?us-ascii?Q?gVHzZBWDA5JI9wZi5R5dvAgcIq3wfIcCO7OAGwQAKL9xSEKR029w1VoJtoCS?=
 =?us-ascii?Q?h0o8Huxbrf7cKJc+f/2GK88+y8eb6jNbyu4+1D0ZM/Psk5YF6lbTcOUzacX2?=
 =?us-ascii?Q?lACp3A9I4FMyZVcgI+/LTJ+UjZPL/tTnpeJw7aW/73q2aL6Ps57PpNmpeXED?=
 =?us-ascii?Q?nhLVpX6PoW6JuuY29kjcVjEMqfdho5EElgastpAUFvRaFxeEOnAGaaJHrvnH?=
 =?us-ascii?Q?znuwRiYy9dmvyuqKBSyvMVA+Jf8DCgkZ/PRDNyeTII1pP6lhP01RfFx+wiij?=
 =?us-ascii?Q?mZ/WKlWsfoOCwNGeUV1MRzC2g5vKznDKh3inJLIyAOnHm3+O895JQkirUlT0?=
 =?us-ascii?Q?o978XmB6AFy7QyjAja1b9gCccH4bvz0APPNFlV31MXWZQyqsN7kQYjJylKCM?=
 =?us-ascii?Q?sGtk/8VJIgZzAD88er7BVhvb0oou2m1xI3J5hjgiXB4mMXzOSmfpNhDBZgWF?=
 =?us-ascii?Q?5kOwD9QzHU81CKxK/FeOwkmaGjdGlqdWJRKO24Ir//YEJ38vnmJI2HJEbtxN?=
 =?us-ascii?Q?uB7Bh3kC47jnjZ3Q9aVpn9tSikxHab6VolqSjunV5CLjQNmKcQd1/MN409vD?=
 =?us-ascii?Q?e9g5LfM0udO7Sbr07Qyatafmj5d8Pnq66HZY9cqfyVfkb+rhQYqsuhNkc30A?=
 =?us-ascii?Q?2lEwwoVS3evbDrDa33vaiI48Ck1RAF68NWIQ2U3P5wt+J/1XGJbZS9bspGGG?=
 =?us-ascii?Q?vUDHpJ8OJH5AGlYaiNoIdEx9/xzFm8hx3mp2VmsPnLxqnpTpPCjPPFzSzcdF?=
 =?us-ascii?Q?SftXqmUpnwH2sqZz5lKWZJoqP3C+NvUwnwYPH0RjhC1RuLz+/Fsak4NEzBD2?=
 =?us-ascii?Q?eqAzftBKCSJdz831KHI61oHtKigDA6W2CapMGB90YwEpZ5vLgTOutGjRmx15?=
 =?us-ascii?Q?tLznx3NPMw5w09gjeMGunEfV/bCGZXQd7qTAoU2xPvrLKcM1boMe+oSvGLwp?=
 =?us-ascii?Q?pW7evfnh80XVgxHRJ/6GHTbON3Jxj/iUQStGQM5kGny3ONjy+0xF42Oz0M9U?=
 =?us-ascii?Q?it1ku9S9oPtER/5xT8aNjZu4cP6pdHwH94v+MgnAvAGb8rUBcwFGdPZ7u90Z?=
 =?us-ascii?Q?RhK3HzxwAU711ci+aLFNKAHnuihpybxVsQTcbP5XrkAtn51wXshxkHlOoGK+?=
 =?us-ascii?Q?uTvmvNeNyBmC5V2q327uR7+HtkrO/FEMv/d4ONutnzpzQQEgded+wAVhzE67?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dafc831-e8ff-4543-1254-08dafe16f43d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:26:16.9068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Truq4G02PegU0vyLoxfA5sK7EbVhHNwVkp1SV1gIZeQP3g0tSJFGKIZq3fpF+KOlerwd/h94LrNzEUSB1fmBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9197
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacob,

On Mon, Jan 23, 2023 at 10:22:08AM -0800, Jacob Keller wrote:
> I don't work on igc or the i225/i226 devices, so I can't speak for
> those, but this series looks ok to me.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

For clarity, does this mean that I can put your review tag on all
patches in the next version?
