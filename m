Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4763F6782CE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjAWRR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjAWRRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:17:53 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB573019A;
        Mon, 23 Jan 2023 09:17:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ohc/WzmTvVpKgvMtxsZg7/rzZstAmPmFH2TFiHdXWQ0H9eSjF9pGJJM1b5oCK8AgthizE1aSOWdQVP9UUHAr+8ErcUCFMEL0UNxwGOCrIm5FeYbU8gpZq+sDxcjtIQlF3nHBcfVB0fMJfSDk73TUcBkmVAT5QHjVKo6sz+jDEj/7K8LqfJAB8y7XDsd7L6tZhsSpmUkmmydWu58KP48riC9WxdDWHztgIgPEoeskpkvLa6h1Bv8jkJm6p++QBHd7CtlE7zQBLKz+Nchg0RcS29Poc61/ZAc8fZW9bZL1n5aCfcsIeczbvJDpKn5ybsaUDG2FtZwW1Z1BoTcttW4NXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bsDCTSJLhWpGcU4weNHKRMu4zIlnyVExb7OV0ulAl0=;
 b=dHaX1ErMYuOfB5dKJICsVtMZ8RfCCdJjxUyp+vOQ1csEknQPD9m1ERdmeVb/AZXYr4cRNhRNDxBTeiIWZDLHJDBfKu/qqFXiHFXpbRtcBIiVJqxuMXIZp/5d1bpKOrbgzh621JI+lhHk50nitQeq0FtBILkoKDCji3mvEbeVy0TPxRMVoLYUgzY+GUcLSrH017wWgRgjVKgWFDeYS0pk+Q84Z9LhsoqCFRg/cnHgO0U2T+Z43/Evgl2qgr15U/gTLsoRp+0Q6d5LNR3L99Ld6xB1nSZC4EPFecv4grdy2n7Wf20LF5dFAtr/kYlSSMPxGYKme6rFGcccFEYIFlJKxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bsDCTSJLhWpGcU4weNHKRMu4zIlnyVExb7OV0ulAl0=;
 b=s0YpYjrMvfiiEb2DAfAyLDTzeRbN0eA011GZwK8yRFS6WJsFFqsdQVLpi/cSw2aa82agRFAQjD9w72TZxp96wJwwFwWfUU/QdofXcXsNL7w+vB9dP9XKddO+O0Z7VpEQsxru9+W7KTlu/U5XdvvfhXvBYi4qqwrvkrYSSjL4DBejas6xoH9GPmzmZbfL5BbFCCH3wOjBMRYUZhLs+aUTvvHfDlHdepEWtfAnUTdHMlZw8uJ14QHTsTPjzdVSduK31FjuxapmUxuUk9Z2GnJxL7+lonWZ1BgnY5RizzyvufyWox7GOaQ59o/0hAWfTLNDe7ZDTXF+LuFrkIsdisVqvQ==
Received: from DM6PR02CA0117.namprd02.prod.outlook.com (2603:10b6:5:1b4::19)
 by IA1PR12MB8587.namprd12.prod.outlook.com (2603:10b6:208:450::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 17:17:08 +0000
Received: from DS1PEPF0000E64E.namprd02.prod.outlook.com
 (2603:10b6:5:1b4:cafe::db) by DM6PR02CA0117.outlook.office365.com
 (2603:10b6:5:1b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 17:17:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E64E.mail.protection.outlook.com (10.167.18.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.10 via Frontend Transport; Mon, 23 Jan 2023 17:17:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 09:17:00 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 09:16:59 -0800
Date:   Mon, 23 Jan 2023 19:12:36 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
CC:     Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <intel-wired-lan@lists.osuosl.org>,
        "Jay Vosburgh" <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <netdev@vger.kernel.org>, <oss-drivers@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 04/10] net/mlx5e: Fill IPsec state validation
 failure reason
Message-ID: <Y87ABF5mjBJXaDZF@unreal>
References: <cover.1674481435.git.leon@kernel.org>
 <a5426033528ccef6e0e71fe06b55ae56c5596e85.1674481435.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a5426033528ccef6e0e71fe06b55ae56c5596e85.1674481435.git.leon@kernel.org>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64E:EE_|IA1PR12MB8587:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a850ec-7620-4cc9-9cb5-08dafd65a815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQA8qIzYtz0KPdceBoDix6VLJ5hvfsj/u32wCY03aVQa7QjQxmLlhAy25NOogmBwJYhqJOXHFi6b4FcQRWIRd3YGIqVQtwU3gRofRuFETfqLu3hpHpK0Ik3jK2UdRdy8Gl+JPPQ48ZH1UlRBBdsaeiV54wgYrirulMVdwahBLNq2nb99BqUtKUW7ADarGgkK5DzSwhBceJET/pazGj8nxVuRs9WKsxc18GaXNxECH19MTksnu1FmnGROGqZzGGE0KVJolOGxH+d8dXn9Ev/24aD4O6B/739AX0DA72dHNwtMEyAQiLcOoIjaGSMJ5i1L3Xbx4eUEiCq3TP/EuGtdY5tFw1sbUvhqHQcV5l5aUePjWmcl9WZz2xoO0HavKceMzUZ2a0q+zUkT+6Xjwr4l8ALPcA01K9K0Ff1ku/y4DPDdn+TRoDcpd2Byx6nF4hpXVP4ojbRY9yTOPaCINFC/ubo4ortMxBhTRlk138ua04wuR/QjcJZmkmzBS4QuN2tWR/OfV/ZBGt0tXWUOqqq5Sj/yEC6m6zSX7jX96/1OxUjjVhEcVH32bJoQa7DUwze835WyoyOSuMv/hhRgw2+M7JOIwvjdWdDO091NqwM0HGQuVw8Dx/sfsJxhB7qzOpSB12bo6GUbEDTorAOkhmI4FR960LkF7u2+5CQY5kGNeGSmyJ7Na+QeJHvhgbPwBZ7kiJJ/YMRQijonUFVXLBSn/A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(478600001)(336012)(33716001)(7636003)(82740400003)(2906002)(426003)(41300700001)(82310400005)(5660300002)(4744005)(40460700003)(7416002)(8936002)(47076005)(4326008)(86362001)(8676002)(70206006)(70586007)(54906003)(9686003)(186003)(26005)(16526019)(110136005)(36860700001)(316002)(356005)(83380400001)(40480700001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 17:17:07.8453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a850ec-7620-4cc9-9cb5-08dafd65a815
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8587
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:00:17PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Rely on extack to return failure reason.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Ohh, I need to fix my scripts.


<...>

>  		break;
>  	default:
> -		netdev_info(netdev, "Unsupported xfrm offload type %d\n",
> -			    x->xso.type);
> +		NL_SET_ERR_MSG_MOD(extackx, "Unsupported xfrm offload type");

It is rebase error, will resend.

Thanks
