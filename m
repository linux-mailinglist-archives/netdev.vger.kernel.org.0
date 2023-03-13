Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6902C6B7CC7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjCMPxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjCMPxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:53:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4597177C9C;
        Mon, 13 Mar 2023 08:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+HKGv93ivA/XkUA8fRN2zxs60EcuS5B9YUfK+iuE6F/IzgP6YlcgmX4epf1Bqrhu+qdWNb60xTvgY8HLQaC707KWiZsNiWe4m0RqdtT5VgnZusYlZ0DiEcz1197oTzM6ki4n3v/X+Ur2FEovs17Wir6ddFA9di6v2B2l3UEE8LN7bMcbeSbGh+j9N6XeYX8KhMXYSxFGLYTJBdhzOZPQhz9T2zeuUYpgsA+FEsBW0zk9YurKSxlshrF7yK2IoJmmIu+QpqmRJ399ZyakpcPDTu0dsoAUT+ACq/kIKzNcjDzvLjl61Xi8U/0q4EAZ/GjvMD2nJxFFfZT66HEV36DdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2mW4qeUvtV7A6ah6eGUMTz3z0xTgp3CHhnliC70Eu4=;
 b=QLj4pdZUa1hYHxcYeCealR9R5DDv23leJ4WJndt2zZqc2UOad++WX4xrOHdWf/+xrG8qhPQo5SuYNMPGl/zFL2voJ1s6bIXSOGiUqER6yQPVq1JzLsTXLWBew7V1tOOJRzNTwG1S4ilsfmlYYDdnpA7aVfhprmnF8j2cO/uPtF65XyVNP1RL6Ve/1IUP4vFjPPzJGoift9GleXt8ZfAGv61qcNp2NzJGaj6DQXg9M30tcHkUYRH5Rj18Zuriext7UTc3/weQACoPxvFW9RCbBcuJensggMacR80m3qr91kQrbTNd3txXrst+hqryikgmJ8ZQwwLWppGRrz4w/m03OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2mW4qeUvtV7A6ah6eGUMTz3z0xTgp3CHhnliC70Eu4=;
 b=iUnc+O24iay7M2kpKljaaxvTNWDQQ3hU5gKjlVTp2f3kuFia+UggMps7wnab27aXPYqKOaKPsrXz79FFe0aAE+gpPbVc0MmqdAqPxWkYZPciytiR8BP8sSw+Zy/PChldedlmvpYOp5yeCEW9lVdmWqIvGsN9AAGyQf0nvYe4ARM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5196.namprd13.prod.outlook.com (2603:10b6:208:343::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25; Mon, 13 Mar
 2023 15:51:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 15:51:52 +0000
Date:   Mon, 13 Mar 2023 16:51:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <ZA9Gj8j1AZIGj/0R@corigine.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
 <20230311215616.jdh6qy6uuwwt5re7@skbuf>
 <ZA86mThUeARDfnN/@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA86mThUeARDfnN/@corigine.com>
X-ClientProxiedBy: AM0PR02CA0096.eurprd02.prod.outlook.com
 (2603:10a6:208:154::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5196:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb75bd8-a0cf-49ed-311a-08db23dadd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBgQoTVI1I3sfM3p48p9Ld+upAi4xfHped9JwW8NY4xP9vDwTobmgs85zzpRIVACWoUQPfFtLz4jLR28PzYaV7+YiMkGz5tZoCem15PO9VwiecdhpZze3bBu4nIvBc+FV35s4KpvIV5IgpPQgJpIhRZAciLzxV3c+6WMjoBCHCyz80Ten0cm4DL71KvQBZ3oapvMdkmH+VF2qbVY0rHrE7jDuYOGuyRr+RmooJI7bKNKcffZkMfPYOdB/hvl9YXwzeXTMWtHRGzMBgdvfHqAHWAr8FIqsKwmW2qXbcAInzrZpJGr4sIGvHZnmbvYhUkW76/D4JK4eFogkGUthwNwy1G0jNapdyM4uiUWeiaII6QUPb4EEo9Z4ZA5RbNojLnLPv42+G9fEFjzBjBNQPg3iw1+yfjS0yxxJNnNgW5ouJM+U4p+cDfVx/QibKMJRuMgA/DXToklIuyVsl3vG+BqpVrGmFf+M5UZ2ZtUMRmWUpYVrQ7A10s9Q2Zz36cHvscGY5yNnarLkoQB9RkR4tL6nN8G1QSCjxc2wV3K4NsBnsoA/7zMZ8DXDL9UBHO/lKnOxmYzhKtvp28Xx4qrujc+F0z4JjidRVFIJmGdVWuHqhwf9AE0lGZKjFJVoeVesHuFD6RTdpqmq7dcZunNgYL7/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(366004)(136003)(346002)(396003)(451199018)(2906002)(41300700001)(8676002)(66556008)(66476007)(4326008)(478600001)(316002)(36756003)(66946007)(54906003)(86362001)(6916009)(38100700002)(6486002)(5660300002)(4744005)(44832011)(6512007)(6506007)(2616005)(186003)(7416002)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hEbP+LuFVWwsQlmpVdZP8ycdEETeir+UxKaZg5vQvVMrUe8v99Fm4oyi55H7?=
 =?us-ascii?Q?6lXVnaIuTVixXbLBJ0/mmnJhtJF7PADMCULfkSjF+Nfaq09DPr7O54DlpoOQ?=
 =?us-ascii?Q?qkmPNmszwvCkJw/IyPi2oppsRiRE13hVLBZhOPdAmi2Vz/68yqyxC1sFXYW8?=
 =?us-ascii?Q?OkRY8c0rwuQj9+HND/7Iq8+IeLdjVyTdkV3WR+YajZhXeqcpL/Gr8OujPSTJ?=
 =?us-ascii?Q?dSJeGghf8ihClkY3OuuR/xAjLsEckXj0cvrmg7BE5Qx7021J5T7Km3R2lbVL?=
 =?us-ascii?Q?pHCwdb05sm/lcfVxvw9du+Wd32U5S04NDPRtlOLW8m4D341sUfjnHxshxvzI?=
 =?us-ascii?Q?Rkw36Pkjk9PgmPJFvnMY4jfrdFyg+JnfRoeqNL1D4lrIbO8EbnokO/n2iVjo?=
 =?us-ascii?Q?QQ6wqtLtTHm0dNJ/6O/Ex8T2SL2CdFv9ERxGLRug3vDxxYmY4tiYqaRUmAfF?=
 =?us-ascii?Q?rPbidgd8cpt2kKFzLGt8BnEC0XwlMkeE0IHGW56TddurpXPgZVlxPhjESJxw?=
 =?us-ascii?Q?tBIRMN/mVx9aBZlYDoxZd6YomgdJoEtynKdZcY6XySS0v732iyQy5NPwEqD6?=
 =?us-ascii?Q?koclBcRPrWQz7XC+LTlhN7k3+FC/XLQPZmQifK2ATMtX5PyVxzHt9anz4k7c?=
 =?us-ascii?Q?NEyjLVXDCRd7rr9saCH9MLwpJjWi0yNqHMZIu3BMbJavn547xJ1Fx03xdANx?=
 =?us-ascii?Q?N27goAQYdhlyh9CQuVxNMK/GZ7vLMNALYbOxuOqw0ULct1CVumvf2r/vAQSw?=
 =?us-ascii?Q?b7rZaeczWsufOMC6agxHUtoBxGF5qea6ofCrj0d9HI59Qe5q4J+srg/X7DW0?=
 =?us-ascii?Q?DcPUmhM+1nuM0YTDGmO33sLK04OSwpACa8r1aAA9VDyynpBTWXTrMQjobK6l?=
 =?us-ascii?Q?hHRIkQJpQy+PvEYrffdDw1dUO3MNTPgg0T1oOYxfQRhrpH5TZQGJ3bAgAwdh?=
 =?us-ascii?Q?LLyo9ci1LQ8ssL0XPqw7bT1we3qw17oIhxOaW3azlEZwn1/zbNjkauJDsI03?=
 =?us-ascii?Q?9CXW5AjUD90fz0YasU6UPmFDDB8C847KOz94Ufb6v5s9BidxoUPITvNchXsp?=
 =?us-ascii?Q?5sdab1LQ53kXtc3t4rWdJ2mAC78JgB4TdzPYkGeFiZhKBZ0V3BXV5u5patCv?=
 =?us-ascii?Q?U4+es+6TjTZYNeasstJWzixp6kR8iAYnf5fqwVUpDewLmjHz2SU4RLoRY9PS?=
 =?us-ascii?Q?133nrZsXu82N+h5pCGH0ngf0kBU3yFpMWwqV39i+3bsldFXZSAbSiwyxwumS?=
 =?us-ascii?Q?i/m9vDpP/a0e1QwJOTgclFA3Qptzbsvt2w6kB2e4CxX4dRb87WZKugmxq06/?=
 =?us-ascii?Q?JtdqMpxMYrd9aQadUWLrB8l9QfoDkUtUXtxqKS4JK0R1BkYcaqdB+YlSxqs3?=
 =?us-ascii?Q?26/FIabE8h9qq1W8D8vcYDzwRBktqTsialqIwrx/39nz6KUHMFsO4LgxQ/4J?=
 =?us-ascii?Q?CKsTLgWZoY/8z5/p0KLfHnJMam29gtzK8Hal0V2JA+og0FDU+YSvfHtRQ7Z8?=
 =?us-ascii?Q?+vo8PoGQTfkhYSt/xmNs7Z/1Jil46IJRYXS45WOGU0A0Wb429o5ehZZwPDgd?=
 =?us-ascii?Q?t9J37N0UwAeVf6h4x57mYzMGiirlR+N6AOOzaS2HfW+ub79jH8NxNIPNcPUz?=
 =?us-ascii?Q?+XY5NtNUv3IjSKXdw/LlH5HdIadvZS8puEPgHaTzIWNFiW3yJZ+n0+DV0uV+?=
 =?us-ascii?Q?oMxcIw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb75bd8-a0cf-49ed-311a-08db23dadd16
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 15:51:52.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9acnsOr+4m6PuW88wEEyGQa6m0++/wBQ5bzl1LMWFw9f/iHHR+Muh5HOMkm2Ea492uMcZcLgYPejVaAJpz+sfZmxMAOmrlrchMW6SGiLACo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5196
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:00:53PM +0100, Simon Horman wrote:
> On Sat, Mar 11, 2023 at 11:56:16PM +0200, Vladimir Oltean wrote:
> > On Mon, Feb 20, 2023 at 02:23:30PM +0200, Vladimir Oltean wrote:
> > > This series proposes that we use the Qdisc layer, through separate
> > > (albeit very similar) UAPI in mqprio and taprio, and that both these
> > > Qdiscs pass the information down to the offloading device driver through
> > > the common mqprio offload structure (which taprio also passes).
> > 
> > Are there any comments before I resend this? So far I have no changes
> > planned for v4.
> 
> FWIIW, I am now reviewing v3 - I missed that only the first patch was
> was applied when the message from patch bot arrived. So far I
> am up to patch 08/13 and nothing stands out so far. And I can just as
> easily review v4.

FWIIW, I completed my review.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

