Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2268ED28
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjBHKkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjBHKkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:40:03 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2120.outbound.protection.outlook.com [40.107.244.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED9E49545
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:39:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P28d93hpqCu7fsc+nUY01eug6nU1I9fcwdd6NqHMXXF3fK03kPNHeHVWAq7PKUkxxNPHlD0qrXwb2MWmZ97hm9CiIURcWqq9Asb71A/YQM8NB0aU8R/zXcAVijQ2dgggGQyTjFW84y71jpDHgI6GAS7D8f8P24V2+KuCA/9sgZ84r5R8PXa2fG5HeBKjBIyHM9EReA95mTCGWfaDhQfKnhpUnDa0WLTvPW1gvYusBMvLgZp6RecHVwXDYO1yNRYZCEOeYVjs7WbLPWHogdQNlbUDHkoFpTox+4NKSBWaNEsVaJgJJyDRWh0grfROvqDY4t0JmGKMXBTetrHo9wV+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9qq07DuxkJsLIz1vIZLVTcANgHjFmO6fsRLyeb3CiU=;
 b=ODe9335Xb32zvNTyEtb3VicuZjEl46CpgAun4TDjavgr64ILYcKx/7tDRX/Mqsnz7nSseMWQo9ppEaDbb2aqV65Ya/Mzv5g7HpB7slxLV6uvMSgvVVozmTGXFL74oKOR/6/W02+iP6D732ZkAPjxVfN2TDHuegUhxMPNu3tMXToe8Dvoq7ORFjyCpaV83Sokx2P72dDIBdrpFLWsmuaw7yb8pLG1XXOOPX19FupuhvKM57SKzQUuK2QHnAQ+E5tSOBv1iv5ut31Tx7NtWJGZEdbcI+tO45rx7WPzM/5UPEnBjaoEsScETpG1KW91ftjBXU6iVipuoJoPXlhLdskLPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9qq07DuxkJsLIz1vIZLVTcANgHjFmO6fsRLyeb3CiU=;
 b=uEw4Sai95L2Pacs9Jk0SdZMhQFqxm9LgrR8lRlD17+3VpDH/Uns9AYr2lVFMTJLK8l+LQK+gSUR2jV+TAO3ZHbH8oyNe8ntezx69zPg6e2IIRyrmhmuexxfBC6vYOpIXKUVNrp9n9xZL0HGyvilfJ4X6x6LzT+la5t+SW9cPKFo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4678.namprd13.prod.outlook.com (2603:10b6:408:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 10:38:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:38:49 +0000
Date:   Wed, 8 Feb 2023 11:38:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+N7sc5bc4MP/woq@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206184227.64d46170@kernel.org>
X-ClientProxiedBy: AM0PR03CA0081.eurprd03.prod.outlook.com
 (2603:10a6:208:69::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc87d6b-03e1-4382-4394-08db09c0a98d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YfneooOEMsWxB+FiFKwKbiCAzAkXvB39nNYEhmDo8lTqBCfwrqp94G7w3LuFSXeyAIjGTyXzNjADJBrc68rz83zFK5AzPwQc028Cv3Q/99EWsIDRxUk/mQn+h9zXUX+mY5sJ0QA0uPqnnSg9F6nR13qc1f7/N0JABfzxD7tEPkPtzGqZvwgAV+UKeh9gli1dPNCYsf6jl6KxGfhC735eSkuln0Hg6+foDVonGl+zsAOKIf5MliAf6t2XqjD+sqBZmL4Kr2zqP+tiF2EpH1eK7oN3THijZyN3R+V2KR1HwlUllheq/UiZqmjyFSy9RAFMq0RXax6Zw+DZF9age9/sChYQugnQVlskqgvscSKpOKjCbfesMm9Gi9Uzjmy480zMxw7KiWW1l/KcqK7a79X4/y5n+MjVap+FDQU+y6O2hui4hX9cIu7WM7TUk+KwrC6ZkvA4FQFpQHpxboCqSk+nEIb4PGaOOBBERnvy484Ni9P5Gbyrgg8caIbpUJ3l8uOkNAb6T5eTCqugy4AQaI1PQEiV0/NGxPr2arJzIk0foLdcEf0WBSVn5782sohCLyau2a5+yU+1UEyxl0enaD2/J+1rQ+CJePIs7AcjB4SZzCxPI1t953ZMXPAVdQKenYXzP+nMCPQ5kDbKfLDOuxoYOCCCUd9OspdM/osfE/426ngKXWlF79JWUTZCrT72FVdn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(39840400004)(136003)(346002)(451199018)(5660300002)(36756003)(44832011)(7416002)(2906002)(2616005)(38100700002)(8676002)(66946007)(4326008)(54906003)(66476007)(6916009)(316002)(8936002)(41300700001)(66556008)(6666004)(107886003)(186003)(6506007)(6512007)(478600001)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oofcXPjeRqIUcMjGXJ5kop8STkENw+2/BMPVt74GBfp9l8er1Is8GyEzkGD5?=
 =?us-ascii?Q?l4hvShIzSNYoRQUQwlOP28YtIFW3Tb4bXEwqz9nARQbVog2UMQ6a6osaj2C6?=
 =?us-ascii?Q?Mw8NhJiRYSl1hU8EEMNNM24FCTlzuGviUnhBmbLVuMtXYaV8s6cLn0r0Zlwn?=
 =?us-ascii?Q?1HPbJMH5aIlC1b9AAZq6GWGHb3noRZz/usgt7h0tabZ9StwFDTaJnBvGrwLk?=
 =?us-ascii?Q?hRJwADhF8AxxXA7UthVD3NLXQ5bs7RCk0QZQBb/ahca08x4IxCG3XzEUpRDz?=
 =?us-ascii?Q?mGG5+/MI1lVsAJ03aMsn2iRX3A7e9+gKmEIX66Gz5StA6dkIzLAO2kfZk6/L?=
 =?us-ascii?Q?4RY0TdBYPwONmb2NRxaUgPl/PUJJenI5AmK8uOdLt1K0TE1UkHCugRzjOnNE?=
 =?us-ascii?Q?b6FoebiOeDtGXduWpNJQ8UiNlpobldJ4NqAyU09MFv6Gj/LrdE2caEC3h0Uv?=
 =?us-ascii?Q?xV1UICfQYou+PbP+tumuHutQMEq+aS6nOI3N4+w5iNC73Iu/9YoVjboa62ZN?=
 =?us-ascii?Q?40Og24ZCFcO6R/6Q+UmyF9CK64eOgNDPt4aZaSD4RlHZF14liZRmC1H898fP?=
 =?us-ascii?Q?Ji7LISIFXog5DMz56PTZr05rESMo75LnuWH5gHeZan5ovCKVyLOl87CfeHlB?=
 =?us-ascii?Q?kt/igLxmkOcT3f8Sw712hoYaL8c/b52CluIsp/KxggX1didMkweAhXgzOgIU?=
 =?us-ascii?Q?PaT4LHCqXwHGWeUN5YbrIG+R+TtVHgncxrGfDYcDqoH//ib1XDPZMHKt6UsL?=
 =?us-ascii?Q?HOhUXyqOX+3AvbATFPV8Jfa++uPAa5YNUI+BePymFVd0/hj8u4CkcFBek4Am?=
 =?us-ascii?Q?uh/SG2u0zxn9zc6yeNXfBi8QTL1perZRvqmmQSlsxtRTPdIvNnF4oBG4U8LJ?=
 =?us-ascii?Q?2hcrLMpUyDi+WIMwOiYH5SFtBHmGaQj/9mR3dT+f3/7iyv6da9c7FAw5w3j5?=
 =?us-ascii?Q?/VeK2WowBQeMDyJwfpdNANeTJh+o9s3yVrGN9adtB61p8GNKQi/8+TJ0rI+m?=
 =?us-ascii?Q?hvJhx5JZmvgMGHvKJ1ChkBfC7ouqtSn9qzYhnufbEKR1v9rSYmsWzbxHOas8?=
 =?us-ascii?Q?1Jy39ddIP9tNOO7tXodiEQ3OAthy1VYqVkGfUk1VSwjP09AuL94EIqpqv0Hs?=
 =?us-ascii?Q?osJ4Ua6PXOHC6iSSoInR4OVVvKAfU3eIQ0lw8Tw2Y7f1MQpR9K+IGdDve5kH?=
 =?us-ascii?Q?Lfjn6tw9KRaSpC7+ViE0EaiJ7v5DlzCzQBQeaMEaaaoADjRQsbLeyIvx0px1?=
 =?us-ascii?Q?4tCrwy6awBa1+kqyvyr5P0T0zaWR28tIX4PMTeP0XdTBlgWSrqRRNYWSGgVe?=
 =?us-ascii?Q?s8YvZpQrGeDk20WeRr5bOAVkeJV9UBxIOSJNRIuZsfFaSRMog/ATSkKeXlR+?=
 =?us-ascii?Q?jnm2OYwVhlW0yDom0J9pXrNDDh8K0viPJ38649HWT0RTi0z4xne54ULUWJ7U?=
 =?us-ascii?Q?rje6j2Z6kM8zNQ7rFOSBd2NW2tjktl+n7D8SzYn680j0DTljsCjUWMrBWLX3?=
 =?us-ascii?Q?GqYK+IpZXAacvuMQh7IX/hITRPuwRnQH9wyOLyNuGKSRIKK40BbR6i8/vu6M?=
 =?us-ascii?Q?hLUPXzUK1rxXu+TwzS7240LB6/oh7b3HWpC5bd5zOMIxgfJ5z2WVf+oJIUIF?=
 =?us-ascii?Q?D+rCD5KdWpXc5bpIMBCph38bRXNlBdEl861fQPL6pURYBQ7a6Eupwq6AtOMb?=
 =?us-ascii?Q?7TMO4g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc87d6b-03e1-4382-4394-08db09c0a98d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:38:48.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SrADKX/fgEPHGfvk4TF0ExPzu+lrQtxmhzUNtKEsglNXkcZjvB95oQTDehs6KtxPv58ABpXOr6tGxoWXbBr5ydljdjmOsKjSnSn0MdzQs3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4678
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
> On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> > +VF assignment setup
> > +---------------------------
> > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> > +different ports.
> 
> Please make sure you run make htmldocs when changing docs,
> this will warn.

Thanks, will do.

> > +- Get count of VFs assigned to physical port::
> > +
> > +    $ devlink port show pci/0000:82:00.0/0
> > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
> 
> Physical port has VFs? My knee jerk reaction is that allocating
> resources via devlink is fine but this seems to lean a bit into
> forwarding. How do other vendors do it? What's the mapping of VFs
> to ports?

We are not aware of any non-vendor-specific mechanism.
If there is one we'd gladly consider it.

> What do you suggest should happen when user enables switchdev mode?

Thanks for pointing this out. It ought to be documented.

Prior to this patch-set, for all NFP application firmwares supported by
upstream (and I'm not implying there is anything sneaky elsewhere - I am
honestly not aware of any such things), the embedded switch on the NIC
(which as you know is software running on the NIC), allows forwarding of
packets between VFs and physical ports without any partitioning - other
than what policy may implement.

This remains the behaviour if the feature proposed by this patch-set is not
enabled, either because it is unsupported by the application firmware, or
has not been enabled, i.e. using devlink.

If the feature is enabled, then in effect there is a partition between
VFs on one physical port and those on another. And some sort of forwarding
in software (on the host) is required. It is my understanding that
this is the dominant behaviour amongst multi-port NICs from other vendors
which, by default (and perhaps can only), associate VFs with specific
physical ports.

This is my understanding of things.
And I believe this applies in both switchdev and legacy mode.
