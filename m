Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209906B9149
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjCNLOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjCNLOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:14:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2096.outbound.protection.outlook.com [40.107.102.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F65410B0;
        Tue, 14 Mar 2023 04:13:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHneikn+pRqnX5So6+kiZpAGlNCEMWSIH1z+fO7Uf8gR5dGNTXZB85p9Hun/sq1ze1O0FNI1vhqmxeEvMjf2PWa3Ip/Ok/TwGmXkVd3Ej5ZU9T9iFBJ4xUHBeGLOrAA7FCDPEK3lNcQkKv1fFEVZXQDzXRTz/vK+rhyuOJi8Ztdlt8yGpeB1Uu/Vf9C0AkFbkD3y52MQvnSo67REwWpd4jMjcuittEyfgO8JFeOKi2bZFC/2vgvgGLDNwO27jKFjz099Zg7oVqRyN5DCGYS5j9uDr/++hvIjjI6QTf9CQD6bHUNEyM+e2fOo1Q8/Oq6M4sVe07LIDno3HNnpREbcjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psyujY4oXhJmo+FZ3GUdWtghcCVSkCTVqJ7dXHmqnU8=;
 b=CWwpG7+EQh3iIPKmPfTvr+4mkd4iK+xkgMGl1qt5GQPviMeQ0mCgnzkPrhsYpziJl8SolT85HS4+ACMvCLJ+q0QdCS7W5qKA3BBheIGu6MB7ApBPdt6+/xt2BXJBb4DPZ0Q+9vwfMp2jKn9BIEK5w3R4a+bfZkUL1f9cOUVKI80mS8buzY3AkvCUNF3paZPsTkjTzckEK87QxRV0uPP/fXeJH1GYOq59Kyx93PmcVAdh1KL0v2Iq5v1mCCfJ3Ug31yQvxgowh78lslmLJcr5vop1H8Ku+GrBaWmE/1EbU033SY5BeeuR3THvtCwsv4PGTFwTQL9xXbfnPQPw5wHh2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psyujY4oXhJmo+FZ3GUdWtghcCVSkCTVqJ7dXHmqnU8=;
 b=QpeoiuXfR4Yo+ESJAu108kQG1S1h0y1XPj2MrPkXu65B3kVgFAN+Zv8RzLZ2dt9SHnVD3HYQjPQG/PQxKDBwlvXYQtnS71oMlGP5QFOmWxYkP4YxzlVFQ4qU3N5WSjzc5oDudelJmxM3kFhDKZN8Gk82Asim/RrKf9JtjkveFww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4606.namprd13.prod.outlook.com (2603:10b6:5:3a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 11:13:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 11:13:29 +0000
Date:   Tue, 14 Mar 2023 12:13:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dan Carpenter <error27@gmail.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Message-ID: <ZBBW055iKkvNyiy0@corigine.com>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
 <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
 <ZAdoivY94Y5dfOa4@corigine.com>
 <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
 <8a90dca3-af66-5348-72b9-ac49610f22ce@intel.com>
 <ee08333d-d39d-45c6-9e6e-6328855d3068@kili.mountain>
 <20230313114538.74e6caca@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313114538.74e6caca@kernel.org>
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4606:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bec6387-c811-4c8b-042b-08db247d23f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdSq0l5t03eeK7CS8IpmCDLUmVHdn92SI6V0M4aH9kM1/7J7kwJYtbMaBsZrgrGoIG68Sc6lsUzAYscAS8Cxz/ApSPC3mTpNni8OfUyFgJkNSIfsNKKSxS9qz3KY24KOv1WPWfZyTNXZwRrbLGlm9lPevhhre823fyPUV2Ig8aSQsmIvE4sKAIZi3YXXMW6D1oB9p+DQ3QMqp59BC7fFT+2TpPmNI7Xr+T9cgutRU7Aac7q/DnKu3dnyrGN7KqySsGMR1Sit0sjE2k+B7PcbVR2ERNGh5sVe8HTdG+u9/ERYOuNol8npSCbymwNSVqXXtazQ4MFoVNhZPm5l/e/QphC26CvWcqRsfqqTbW4/kLZmUBY6jvyE0OA2QXI/L7VgIMH6ubLu8yKpVBi53ni/pKWt0fDP81eepbE/Gc1Hfsnsh69mpaFY9M7CcOnjxObLeAP6jZk9H4vduCFSxnFZjeJYabz9DqLOjDm/xAafQGIe5lAXQepfCJjH4dlt2nvn4uvWNkHWS0sAoQTlttWBdWcwjBPhUu6hdrPo4yEt7P/V0uiL5txApsIfW9KGIn2rjr6czPbOQ5kVrWBy9aYrNXfi2U4B+DRf/y032pgXqlNjBNFmtYPnZ87A7cDcDXOD0PnLHertWt/Wv0MH0v1TEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(366004)(39840400004)(396003)(451199018)(2616005)(7416002)(186003)(44832011)(6506007)(6512007)(8936002)(6666004)(38100700002)(6486002)(5660300002)(66556008)(2906002)(8676002)(41300700001)(36756003)(478600001)(66476007)(4326008)(54906003)(86362001)(66946007)(316002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yLA4x+1PPbLVOlFM5KOHWOlp/yfm6JSJ1k9KS3zFgDPWYu0UGdqOvNY0Znsv?=
 =?us-ascii?Q?AiKYAuplIYpXZuKiMAlOUW7A8BVnFUK6QmQKeOaV1Xl148S+FH+2ZBegdTfX?=
 =?us-ascii?Q?FFSaoFZozgF4ovXvILKhEOe66+ane/krDlewmuFQFYI6Fthx1BfpUZ4E6Qva?=
 =?us-ascii?Q?w5aXDkZ1jSNouIn8Wz4SYqSeLumFW/h1f+Yd60sE2/O7g+LPRIWz5Z2VX98o?=
 =?us-ascii?Q?4TvG7Yc0WjVCRMBSvHn8N3lzXNxslLVProOSMgRbeN9+dvQ9LPyj9777wbAU?=
 =?us-ascii?Q?dcyfYolnFZPDJmOpCsKUriYneiCs0nPk3fmeV7C5SqtQSLKgwZHPC8XP2ew8?=
 =?us-ascii?Q?CmCbQZwvsWz253T6WX94HT98X6xuIO2+ONEyVxi2z3CE35DxAsFmAxVqwWkS?=
 =?us-ascii?Q?NB40igAO8lQyzm5G8Y7VUqypbtjI3/SaLpAGh3nr6IcbQDlIn8liqGJtosub?=
 =?us-ascii?Q?mU11Zo0SqIdg7aGnV14bchR8ovWmtG0B/4Z8rwpknGqaCZWBX7UQtBvEo+fx?=
 =?us-ascii?Q?GJa4SBgGq2E4k2o/TbXmg1RAQBj1oRbieEDCispyGQIqquIDvxATH2HI3aLS?=
 =?us-ascii?Q?6kfpwT7EYAmmdg9vAhwauKKZ9ZFSx6KqUX+P0P4RwLABbfz5zq3e5xvCHg9G?=
 =?us-ascii?Q?rt4NRUTdHWA4+UA9wy3THGQj8/NYUQSmFlbxnfSS4No1T5Bm7C2l/lZQ/POR?=
 =?us-ascii?Q?+FLO9Lumk0PJ0Pm453vsDP5ILMvfAAEahKufw/hMbvsPTJCAiLXf1mBaB24y?=
 =?us-ascii?Q?fI5WchNSOr1v8H92ZU+qSQLnjLzX7yTZmTCxr/RJAdwKGlxKUjYoOC4Jb6QQ?=
 =?us-ascii?Q?yz45nTrUwl2keKDj5N6fkFG8nN1qnMezt3UuT6Fa24bxeKrHInDdEiN3/kOy?=
 =?us-ascii?Q?/z3OVLjQsbk3iQxbJUO/gJbU22xwqfAjGrhlA6N2FyKWEJz6wg6KfQP2RPIp?=
 =?us-ascii?Q?NlTVqPCV9FhaGtmkdUgmVd+DzzHkBVRpccdw3AwDDIeGy30INXAPI4YFOQ/Z?=
 =?us-ascii?Q?GjC52a/JAhRmlOf+3ORPU70pyNwnCbVWaQOuHsrbMHCRW8sTe7t1X/NHph2F?=
 =?us-ascii?Q?q9RiFs/feD/8Qy/7ppUc6DrDE4JK0cqA8SEHf7zL3EKFKSvIHZK8vfU+vWAb?=
 =?us-ascii?Q?Fcg324JPbjswtmlp9FhFgisb3Lnao+CbxRBb2RBPLLoomSw9Pmgi18CzAi8d?=
 =?us-ascii?Q?O3n3GuRl03LCT45hskYGGx87otMhpCxjcxcalLURycV8lYGKes1hNJkyJfDT?=
 =?us-ascii?Q?wUKxgdWtQeAguYwuvEp6m14tfa5EWBlfZggkYQDg2YFIsn6r0xjpYLUhk4q0?=
 =?us-ascii?Q?fUvXxfHYNTz+uujIcMNRcxH1ogY37p6K/1IEQATtecKsaRN3x1Nw/6HVms/G?=
 =?us-ascii?Q?eQ+X/q35lkA5o5WGurIq9MuzEc4bFXi8PzAcvij+aIOdvXnwUAx0Ip9La4nw?=
 =?us-ascii?Q?QFv5c8e1pzq7ZP3A6J1KMfGA11c5dU9u8Um0qgz47RkWKxTS88vUTCsgfk8u?=
 =?us-ascii?Q?E4UPznSd+AtX4Rkher4P6lAqzz2UkWuOIoxWC9S4u/Fg5Qg7FolzDVvJzbtS?=
 =?us-ascii?Q?cSj5SRxFZy1SubviJIwbeewlwEi4OZQsEe258Sq+anHnUtbhAdwRgazMeW+8?=
 =?us-ascii?Q?7DX5or8CDIa7BltDqw+yOkIiL4+9jrUdgtRM6wku7G00JnTcsWF/an5FavKQ?=
 =?us-ascii?Q?BuASJw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bec6387-c811-4c8b-042b-08db247d23f2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 11:13:29.7663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzJEOpeb5VR5AHZpWajI5VugSHdh+SOvHMx1psbyZkkaOjPNltIiBUUdJkB3q5NyOv9DK+FgI+aGZfAz+/m1BUZRIgVjsbmNo0VhP99Ps/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4606
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:45:38AM -0700, Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 11:46:57 +0300 Dan Carpenter wrote:
> > This is only for networking.
> > 
> > It affect BPF too, I suppose, but I always tell everyone to just send
> > BPF bug reports instead of patches.  I can keep track of linux-next, net
> > and net-next.  No one can keep track of all @#$@#$@#$@# 300+ trees.
> > 
> > I really hate this networking requirement but I try really hard to get
> > it right and still mess up half the time.
> 
> Don't worry about it too much, there needs to be a level of
> understanding for cross-tree folks. This unfortunately may 
> not be afforded to less known developers.. because we don't 
> know them/that they are working cross-tree.
> 
> Reality check for me - this is really something that should
> be handled by our process scripts, right? get_maintainer/
> /checkpatch ? Or that's not a fair expectation.

I think that what we are seeing is friction introduced by our processes.

I'd say that for those who spend time contributing to net-next/net
on a regular basis, the friction is not great. The process is learnt.
And for the most part followed.

But for others, developers more focused on other parts of the Kernel,
or otherwise contributing to net-next/net infrequently, the friction
seems real.

I do think tooling can help.
But perhaps we can also explore other ways to reduce friction:

* Aligning processes with those of other parts of the Kernel
* Streamlining processes
* providing an alternate path for contributions of the nature
  I described above.

Just ideas, seeing as you asked.
