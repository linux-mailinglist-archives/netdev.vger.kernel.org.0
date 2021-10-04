Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310AF421612
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhJDSJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:09:09 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:15840
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237375AbhJDSJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:09:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+CXOkBnOIWe0wGG41pgYtq9jk4kK1N1gcjoBvykZv1ry78Hudh8C5yDp75tXUabSXuyrfN4YlVR39u695MOhq1eVBM751Cd4TOQzh5ljJQJx8ArTi3hgAPTwNP595ljQjMv8NJf2mUD3A3EhAocDk6ZW5ZD/lBfHyLf6wQz/aWmxB0elx/87zBDrkbdFYHyt7tplOVPDX1FWqfKp6w7by51KlwP3fw4SETaCAJ8IAFkl9MhZiDW1Du2AVM4qOlZ6hazlKHbNNgY/SsqUL3lKoaPaprXZOwHOZ/CirKrjDGxn+Qr2d1T9MG1hV16p2dxTBUGkqsCKyz+Ml2cYvOfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8voRhB20Oxi180zHnPIHzB72j85t3sBLOy1n9n+Des=;
 b=B9L4DqxbANWZqlGMdEMqom5DHnG+XrbMnyozP7tJ2BXN12JdlsLiVdAYekHAC54xcUOmEqi3TiZyQ6kaHu9I/vZFtfLtlR/EW5xb4/sxXiAmEQ1PbKdaVr8H1BgaV30yQpqAYb4PR9FruRmLMnYzRPVnYLdoG3yoTd7CNvHMWg+kPMJtYzpQwqIbphjpt29YzMB7f6llTL7aZKfVN+GZH7TVdRDqTNZrrpkuaYQhMrH7yAQcRdoD7QaLgZSrwj+jBcKCwHKpZJmMahmQaznTUNfAiTOk0QzcFwVheT+3QMXjmyisdB4ex75DIqhspOkfdMe7P8CB+NkbA7DNkZFvAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8voRhB20Oxi180zHnPIHzB72j85t3sBLOy1n9n+Des=;
 b=FbrtT+yyYlaw4DDGMmHQUyThHa08W7AuSdH0pslV7WxljdMo3QDEDKlkAXW6S6YOSekS/zeTnoVpbGD/IVd26+su8hqfnSzXCvy/QJEUFUB8zmMmRWEP7oQ91A7tM4Zvbklz5Y7aOhuYr13QNycOeDCSbIhlrq3HIjjaWTay5TRIRCCxF77pV2W3n+s6Fu+DPVsrYMUPIgSzcMUyhe2x3VxttXgjmnN3DyVxFN8W1wBDMHK7vXo7TnsKax+csWpLEYMAFG23zozcOf0nEEjPtslCcVBDpDV2oeB8uPWD6to/ctPC4vHsZb3irtrcm14wBvfNoHe0VNsOVUaDZ1VR3w==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 18:07:15 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:07:15 +0000
Date:   Mon, 4 Oct 2021 15:07:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v2 13/13] RDMA/nldev: Add support to get status
 of all counters
Message-ID: <20211004180714.GE2515663@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
 <e4f07e8ff4c79eabc12fd8cd859deb7b3c6391f0.1632988543.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4f07e8ff4c79eabc12fd8cd859deb7b3c6391f0.1632988543.git.leonro@nvidia.com>
X-ClientProxiedBy: MN2PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:208:fc::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0016.namprd02.prod.outlook.com (2603:10b6:208:fc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Mon, 4 Oct 2021 18:07:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXSMs-00AYlQ-MC; Mon, 04 Oct 2021 15:07:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45faf9c1-4238-400d-cdba-08d98761cc07
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB511039F6C9C276E552966A8FC2AE9@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QBYb59CFJDODmeqxA9x0QBDnwtxBEdKGCBJG49YqlFwZ/PQDL+G0dD50nTPHGpkF7Q7q7bErRRt6ZtLXCjv3ZkB8OPTfb3xR0Vc2/KhXOB/A9iIxXxb12ZQMxDwqm2+zjkmD6XnVVPPL1XEK7gajwrC2I2v6kIEPS/m1hxEW/ikWI6qgsdC012p46Bt3w7YrJuEpjl+6YW42/6/HGtGriLLLZHHFoxzzo53hAZYzAUpcGjZjlv2UOdWiTDeMB4u2kshOsQ9NjcnunVpc0Q3tbEGbfmVHZxw9MJUA2pTNkprWnreG3/MrtIGm+H2pF6IdUTr+fE4GJHudeOQz1FFxFNThFaMz1kyxz9NmyMcup4y1wSdFZQ+uwcXtbQpzjChXCoe4ROGPAVPKdThBjLmUq0bnbtEpM2xq7TSUw/CaMZjpkulK0J+iqQC3/qLq2tzuzeKkM/au9a1cdl9xde22aoK9bKtZGc9XJwoOEeAYdKqzktXw7LPyyEtXKX9kv2UDlwUb7nOnUCst1fgmykTKigdv75EJDX6jU9hCbWFKAtEbHtT75CEI4X6QlAQXCtc4aimJQpZQDc8HaYEPDMpIKOEM7Z1y0ctlhsOZCOlmMwvpzKfKKD1Y8uKCA5Qdlb4qeF7R5tbJWYc6MtGTICxsJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66946007)(8936002)(5660300002)(86362001)(36756003)(33656002)(1076003)(9786002)(9746002)(26005)(66556008)(316002)(66476007)(508600001)(6916009)(54906003)(38100700002)(426003)(2616005)(2906002)(4326008)(186003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+z36Lk/sGFCEiMKTprx0hALCTduai/bP1G3T8vbgS031TygGzSfqq3lDNjEi?=
 =?us-ascii?Q?ZV+FaGPxNqs5qz7BR4HEGi/RJL7wcD1KCqbiyNDBLlN/bgZ7a5gINoMiComa?=
 =?us-ascii?Q?CFdJ4o9lAPdV3EMxJHa5YNEhbxOj54wfSj0CJgW0/1nuFjwcnFkUpf2Du1yg?=
 =?us-ascii?Q?UYXoR8jUfepIEPx70CD/2qYV0CCLq5BqydMQIkppArlOh4yaAThsRG5zhqyf?=
 =?us-ascii?Q?1525odUrToUTmI7OLF4jbVQRgSEVezO2YC9tdEddvg4OqSqvGXRmieloKscb?=
 =?us-ascii?Q?t3ytZEE9mFKV+eLkbskj5y2HxsBZzCWxiVxIGXyx3+CDZKK7q/HcAYT6V+97?=
 =?us-ascii?Q?siqujyQBjLKhm8FYMnL/o3xc2jMIrLqZKvyXPmsvPT1/VokHuXQls4FSHkhn?=
 =?us-ascii?Q?tLjLdEkMSqYe/jHIgvcBuumc+PeaCb7k0wfU/Ucge3JN/MLXHwHJ/uWMdwKo?=
 =?us-ascii?Q?oZ65itkrIULXQqVWFsce14bX2/uWukjnVgOFE5wPZN/5Dq27IbrTCVjGRcnJ?=
 =?us-ascii?Q?swiHCCz+XEG56akdNBovbHkg47zKLybO3YL2iGVarKbPBi1VUF/iw633Q8iT?=
 =?us-ascii?Q?D6kqGLWuGNKxZzNsV4Hag3xr40DXL4zrNlJaAb+hbTXGMwZd3HWt+V8LpxST?=
 =?us-ascii?Q?ViLlXPf8dWroMTVV1WjZHjFp46h64J3CpN8/kW1YuOgDj1OlSzuqWCd43vP2?=
 =?us-ascii?Q?631HpHfeCvY9XPalX59lajIsAuR5CzO9eWNBrPp3mCZTt8Y+W+Jky28ayKex?=
 =?us-ascii?Q?VYZsFLAxa69x58NdXKyMIHjXFgSeFYtATCGKS+Y1Apa9aj/MYtMiGRiTkaOZ?=
 =?us-ascii?Q?Rd5zSGw9MfNhQYn5T8QqouE+JBlEyVkfZQt8pZN89vN2l4VpymZsx2uGghIp?=
 =?us-ascii?Q?9yEGXOwfB9wHM9xUy+CdiMPyB0CXYJuJ1AzajlPxvNBsbZojrnx8Bb/bcgnj?=
 =?us-ascii?Q?++S/3UWEynh+SvZCxWJz18FXHgCoLXWjHPW3SND+vTI59JbtDU4IYON/Il+h?=
 =?us-ascii?Q?obfWCi167qV1M5UOpjWlKmcjsMRdk1+ibNbXVxQZ8exoRXstOLFD6bqE1dDS?=
 =?us-ascii?Q?TjfORVPsWuUJPsLRZ3tY/ybnrKK5xa5xf4MO9SedylJ58IQvaGRT4DWrTitP?=
 =?us-ascii?Q?STsodah2yM96jtvXdTt3wKOhNzx5qFHBcaA6kGsUtnEA2ToBtAy3Wi4PPAAZ?=
 =?us-ascii?Q?LbedFr66oVkkZhV3vi8vI/U8ybXkf3y58TN+YzidVkWzAYdzcCQ2zaJ9a4Me?=
 =?us-ascii?Q?UY/hU796waN1pIKzxr5sEGmLubhlRsFSh3OaqskI2E3rmnRfmxS97VDnYIzB?=
 =?us-ascii?Q?aOi6pk6qYM7G/LZ7cpFz5x4Ab9zr2iJfJD3aZPFB5UKblg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45faf9c1-4238-400d-cdba-08d98761cc07
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 18:07:15.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEZ6T6/i1EiyR83cWA7lsJ2jA/tjwbEYWsPBXzwB+s089TPjHgxmSI5Id5c0UgwU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:02:29AM +0300, Leon Romanovsky wrote:
> +static int stat_get_doit_default_counter(struct sk_buff *skb,
> +					 struct nlmsghdr *nlh,
> +					 struct netlink_ext_ack *extack,
> +					 struct nlattr *tb[])
> +{
> +	struct rdma_hw_stats *stats;
> +	struct ib_device *device;
> +	u32 index, port;
> +	int ret;
> +
> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> +		return -EINVAL;
> +
> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +	if (!rdma_is_port_valid(device, port)) {
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	stats = ib_get_hw_stats_port(device, port);
> +	if (!stats) {
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
> +					       device, port, stats);
> +	else
> +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
> +						 port, stats);

And this is still here - 'gets' do not act differently depending on
inputs..

Jason
