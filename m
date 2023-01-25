Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDE767A805
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjAYAxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjAYAxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:53:41 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2065.outbound.protection.outlook.com [40.107.21.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381B7903F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4YRjac29js2kEXM2iZ/6aqH+fJmkWuJozoW3m9HWJNwQi2EZ7aRs0t1zi3SDjLu978qI87MzyM+DdGfaLuAXXwxM1BQAKr9lKh8Zy2GAnY7SXA9pNQc7GBtH9A9NbiyEZH34ZBAR0irOQ0inHqPl0T+QV9GtPdfFLieVjUxNBxqRUtCvb5p4k+CeXNL7yXVTB0HnEJSSXheWcqp05U6BRLmY7dihhQ126UMdk2RyMk5CedfiWNJbXzDMuXvVNaPMMSIy7DsTHJbNbQZQNO579LSW3UcqkXId1O5l8gSwVLFVxsiVqFR9dEHTRaU7Ajv8zE3dkYm3m411+JqPZY17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWtSiKShh50jl4X6tmt8p7pPhLMxqtIkjcHAxMhJCWc=;
 b=djsrLxTZ3LK4FE1YGZdKQWAr+PxgwSlqG4PZZ7hRogZRNA5HwgKiiLdt3kQIDkaV5wmD/Y+kDAs3kb+SdA3YwgKx+Mzv0XfJQiVPpSfv1UyXAY2L3ulbr4AuOwPeXXJcVQOgx4H+XFcRT7oA4R9oaYEDZx6tq5Rh931zb3Esihj7zzrzhxUqUg69bY8Wq/jJQcqkjNmv4y0CEAJJxW8iduNf5CXrAlkK5gS674a32BYfUSV7WNu/VjboDwBz/Lu72UbDf6MJ697qNukEs+Qx7Nx6/Pkixts1G7i34hJVdvuiDpJpMeBebdjpy6kVUor0xoFn6dXEkvgqmWRwsVnM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWtSiKShh50jl4X6tmt8p7pPhLMxqtIkjcHAxMhJCWc=;
 b=Du46dN6vsKv66dIay1GnYWteecBxUorQT8k9H2EbIdyFgBTYDRj9bOcKiWcGtqIONEc6UWG/D1y7VBmR2MdZyuEzfeld9qunZ5Wcq2Qa8f6K2/IRwOxJu4X9QZ1znRr+TQq5TYVJOqDYCFQU1Lf2CybXEvyV8zLOeunrSihZo1k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9061.eurprd04.prod.outlook.com (2603:10a6:20b:444::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 25 Jan
 2023 00:53:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 00:53:36 +0000
Date:   Wed, 25 Jan 2023 02:53:33 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
Message-ID: <20230125005333.dmphl4vuwnh66moa@skbuf>
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
 <20230124162347.48bdae92@kernel.org>
 <20230125004517.74c7ssj47zykciuv@skbuf>
 <20230124165223.49ab04b5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124165223.49ab04b5@kernel.org>
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: 78d99980-7056-400b-a603-08dafe6e96fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fMLo4B54jXGpoBsNxD0cF5kYu9fd4/Gct0ThKu1Q2C257YZxjMxW8AJUFp1B8hWn+I0/6RhBS7PCQPGz+bCAK79jAQvZ3zZT3Y2hs6jdi/s5nOAcGmgLGItqlqcKOdWQ+7OsDxsPs2HSsmYW1zbbzQyq/nmlnsVx9m45Z0wJ/f66J2dl5x5AoQa4Zs605Htjjdo3YzRFeBW6VxqeMblcIy8/BkN1x0UQiB1O+dTu3f/pQwhMDQhDm+2ITArvGv+z3uZQKQS4zNHLqlpqpPlJZbgub3aERZgjk+OinXtFhZmfr1hfrieFaN/th7NNYcdoFkwwJKoMXOsAOLStOLrhaEaNlKix7tmJxKQD0wUbMXF4P7El0LMeXJOAjmJXVxcc6fVjv1JfcOJ39mK3uWYce8rpk6CWxs+Wb8RKZJkp6gLhroyFKFt+S/5SJgeR9ugOSfUBbUANh+SvTECmgOBSO6lcowC7IdRnFEZbKF+7qdoGO+THvcprsam8qmZ8oKQcPgTGQg63U90d40xnqclCkjofOv4EGW+jBJS2A55Mj/JSTWymXL0YKj6vVSsDiHpey8949FtfcrRvRH4aCbdnn5p3jW0datsGnHHGMzaRulMhL4duS/uuu55HNuMdctZFnQFjVAQygTxS0rlXB1DYZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(186003)(6486002)(26005)(6506007)(1076003)(4326008)(6512007)(66476007)(8676002)(66946007)(8936002)(66556008)(54906003)(6666004)(6916009)(9686003)(5660300002)(4744005)(41300700001)(44832011)(2906002)(38100700002)(33716001)(316002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0dyxpF7YGDP3H36fdDC6RTkGfGzBoiAI1LpTvH6viVL2Hq1SKUdStEXIHipa?=
 =?us-ascii?Q?QN8tQ/MuCL8+pMzzSopj8vGAR7Ui1+UBW7/ACwpI8DKbHC0oCVQAYoG5ObPL?=
 =?us-ascii?Q?apDmUQZKaXrH1TGnwGJ/Cm23Y93ELSkJFp+w+0WrIC3K77zgJHX6GBynXzZi?=
 =?us-ascii?Q?CVYQy88yFSzgCzKg/xxMitmHX6HnIYFpMqHPYvVC3hn1jpvTYj5wWQyfSrgy?=
 =?us-ascii?Q?Yv85oNdwa0pisySonn9tb7z2hJJMmS+U5z13mAPrWQl3PPhcT5IpKgwygkOA?=
 =?us-ascii?Q?koEMb91nQ5dylPIQbtrlf0YSsRAFlE71omf2cDryXimYpoGuiaZqPxkwl/z8?=
 =?us-ascii?Q?y5ORp84dGkY3rxjsf+uGJyw70mQCr8b9cab4YRS7atAVnkHSqOI2s5klknU9?=
 =?us-ascii?Q?1qgaHBJdOYOVE/tgM+CvL8T7v5ayzNXrZ2EV7vXpGHC2Q0WhTn4+pYYhKFn2?=
 =?us-ascii?Q?pmR6+qIv76F87LTHnGvxo/kxy5HaI9aVc3ZBlXmCNteYQtSsrgLNb+vtRJDb?=
 =?us-ascii?Q?I1YgwASioHsRetGHi0zskrTd79ev1bnFnRFhl8dUOpYxi0S3tBpDX87RXJ9T?=
 =?us-ascii?Q?6vkesMIcVUR6yPjZe6Rnl/bmKaDSCbrYOEfA6TdX6saIPUcDecm8clc5dxGS?=
 =?us-ascii?Q?huf7pELxMpoXB/SlaL9+UO1XDxThQNhl15yWbJnIBvHM/D74vw3qqh4Bxmrq?=
 =?us-ascii?Q?T39TMlBJDYTpbo6bjS8SLJ6MvyXK2fEy7oHIOWk8jmHKqmjMbqdS3MOKFFUZ?=
 =?us-ascii?Q?vpkYrbEx6a9g/sXp/J0P/PQgXMUMXU6MAJp8FmYevgNYzS1W+7I+Kyc7Nfpg?=
 =?us-ascii?Q?rcVah8yANpAevvxJ0wP7QYpWc/i8oPRi8Ab4rQItJIfhx/0tIf1JZG8i0dKC?=
 =?us-ascii?Q?s86f8CeP86RFNSSzx/t5XDolrRpD1lvI2fT5YHOphzSVUnhiACcSh8R4aZN5?=
 =?us-ascii?Q?XWrL2TdKYrve5nzkZXZMUbThceac8jx41fhKyppGH+00MA9E0ww9kuKnOOUV?=
 =?us-ascii?Q?uEVetGkj6qHUebShPdpdiTjJciOuqg01Vxrog6A9NHLbFY3+/INS2Vk2dcLd?=
 =?us-ascii?Q?Tch7glcqWeUdY2Eq3uyKWGXNSNx0kjGtARMwNQUWwqC89EXej0I22VWuOs12?=
 =?us-ascii?Q?XnNcYWq8mzYNGX3552t5m3LmbV+NmEsvT0G/uAmxboMmksiq1eGKOqqQKaaR?=
 =?us-ascii?Q?qw11ITW8pN1/WcRISWi++UFxKUpsgRVB//qGZI2gHB7OGUb5Vzhp9KMi94iq?=
 =?us-ascii?Q?T7pzOzZ9ffdhz0sQOpFCjeYIE6f0V240UBjibPeGA5fLsoldt3B+q/4iXE/l?=
 =?us-ascii?Q?+sC/GxxRXaFRYbV2abL5MWydIwytAYG22Vkngkk32eQa43JuQl7V43PbbNfP?=
 =?us-ascii?Q?IbbZDigpgW11LhcLQ0im6bfZoS3kC2dWWJAzRengnTOM+jaUekRF4Mz38+aR?=
 =?us-ascii?Q?S+dOkU6LG9hYwkhEoEDdvfCaFI73TeEZg0iiUFPdgirvNCp4w9cQlxoA2nEt?=
 =?us-ascii?Q?v/a8r1YBAiz+cOxDNlLjczpYMZZlsdWpDCSY6CPOsmsgat/6mZ1OkJNShGLX?=
 =?us-ascii?Q?7tu0iZaNXMvUf6BiRii8bpfabDMyL6rMFJQF7Ww7AlTVs+uKGqyhfoULu036?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d99980-7056-400b-a603-08dafe6e96fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 00:53:36.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HSuYpZTJdVgshkdsMw6Ra0Cy4+OIqeUoJSP/Eesbl7R3sXdDzZ1BYc0Fox/MP2A+f8g1uum5Je05IYDqD+LCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9061
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:52:23PM -0800, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 02:45:17 +0200 Vladimir Oltean wrote:
> > > Choose one:
> > >  - you disagree with my comment on the report
> > >  - you don't think that we should mix the immediate fix with the
> > >    structural change
> > >  - you agree but "don't have the time" to fix this properly  
> > 
> > Yeah, sorry, I shouldn't have left your question unanswered ("should we make
> > a fake struct genl_info * to pass here?") - but I don't think I'm qualified
> > enough to have an opinion, either. Whereas the immediate fix is neutral
> > enough to not be controversial, or so I thought.
> > 
> > The problem is not so much "the time to fix this properly", but rather,
> > I'm not even sure how to trigger the ethtool dumpit() code...
> 
> Ack, makes sense. I just wanted to make sure you weren't disagreeing.

Since we're talking about it, do you know how to exercise that code?
