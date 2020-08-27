Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B190D254542
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgH0Mql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 08:46:41 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:20989 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgH0Mps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 08:45:48 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f47aaf80000>; Thu, 27 Aug 2020 20:45:44 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 05:45:44 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 27 Aug 2020 05:45:44 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 12:45:43 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 27 Aug 2020 12:45:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lThWM13WOqG2lSG2cHRPfTQn0p1OTBwKVSfeIpLBiuMv4uXCkMF7omHzG46Tc4WR3AybYEwhTVJek9jIiPT2zEEyVbGQ73LoiWqkPKEu56FWxNMm6QE9+hdJRhVpET1SYxo+WIQ/ZjY0s905wyuh9oyhV0ENHWYcH6HDULZm8P2CRFZmzCgR4UAmO1pTp1My+cfl64f9FauNJiyqMpI+pfuMW+eDsX0CTTpUb1sHoEFPiLp9jwrFGE6UWWZ5ILZznvC+hgV1OmZPQmBXx/5v+3TVugWoBNP6RFhDd45589Efvrsr6G4cqvMJUsK4jgwOUuK1SfD8Nw+E0znYeLvaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfoMKqeSM3bZOke3po2JaIVv2Wr542dSfQmf6qJeZyc=;
 b=Z2+dS4M1eeVQVmNXxuUC58+nqvJRHpudS/VrEaOUxYt5p65xA7CYTz5oTV6ZFLZCejnQrSe8Ui0fciFU106WbKbPGGsVoPAmmncPMxMTk/NGBxqc7e6rlgVAQy2g5PgrtYEJy2NzpsEfAqQI5n8DI5MA7r2pDhlrBlcXADxo2tq2Zv7Y6s2TribkfRROLDrg7xpEPMJaDXEGQQdR8ww8sy2R7DfB6OyUkjFfZMomacLDGZ5gwoly/s64C4S59tGaaJMK4uzR5JHPKdzCWsZRhJOQgE29I93Gcdzhn+niETjURO6hOOWaMYuONf/aBaJCLXlGNjcLzQGwriMsQisAqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4012.namprd12.prod.outlook.com (2603:10b6:5:1cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 12:45:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 12:45:41 +0000
Date:   Thu, 27 Aug 2020 09:45:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@mellanox.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@nvidia.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Refactor query port speed
 functions
Message-ID: <20200827124540.GA4024180@nvidia.com>
References: <20200824105826.1093613-1-leon@kernel.org>
 <20200824105826.1093613-2-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200824105826.1093613-2-leon@kernel.org>
X-ClientProxiedBy: MN2PR22CA0018.namprd22.prod.outlook.com
 (2603:10b6:208:238::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR22CA0018.namprd22.prod.outlook.com (2603:10b6:208:238::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 12:45:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kBHHg-00GstC-1W; Thu, 27 Aug 2020 09:45:40 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ec8c004-eaf0-4f3e-ef0c-08d84a871b55
X-MS-TrafficTypeDiagnostic: DM6PR12MB4012:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB401267E1F1F95AF0866112C4C2550@DM6PR12MB4012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDTXDnQE57be0J/FgQgB9tuKITv01XLLofnG6QkYI996NYRE3/WrvbN0uIfyaN8v/xh5gPwVt2JTEOnroWSvG8ifbI8c6f9Dz/t9aCWKMFGFvBwNtdiBCaP3y1dbz1VEF+Vu0NzLvCvAwj7wviAVZ+hCgGYjF3taJpHWufhq3YoZj2mbcSm4npQxBkS/M8VeXVcFHt/p3v+bYQKAqNikcXEMz5yKZLLdRSoYQfaIt+iPX5z6Cxa5ZsCHSRXXbQBXGtpIGSSPri99Ju2M2foQSy6t1TCBf9DgIS3Xp0Yo+BGmyRFLAqS5weW8TBPld4WKLIEH3xI9HTVhyzdPi7mxuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(86362001)(9786002)(478600001)(9746002)(2906002)(54906003)(33656002)(26005)(426003)(2616005)(107886003)(186003)(8676002)(1076003)(5660300002)(4744005)(6916009)(316002)(8936002)(66946007)(66556008)(4326008)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VB2BQtO2/SDcCEnFcY+5y8owLXjHdtJWwCnrzGUdTdLmg8Ef6BD7WiyRUOuIuOEj3P7hj9K02vo2ZM6J9qACQHStzzeGl/PvAw9MuWUBChGhPyArtvz14EUI3sVd+i8Ax+lJYy1jWozLpED4/iDjHTL1wri+DH0P/vSvv2jvilB3M94nQQfc365UZWSb3re4wlysSAcH52PsZXbWWXKW69Utgha4EL34hz+dm5Qotlo40KXmlqdSHdn2iusXt6D+rK2ICNMyUL33wckBGXS61wCoC/qNUoTq0BZutLbhY1sPsQXzS/YGIx59BZrZoTzRlxUh8y8FRmF3Wntn9xptnqkcfCBmBtHOdO1XvrWN7la+w/oTGILNu+UUTXvYA09krRvQE4PTcEmOtSZDhhtK/FoeXrmYlLOp0k2kQBrQzW6xXdORyH1PHE9Gyevi758WRQdb05fMpHDJ8oQc1ZzCXTnruP5Rg0wP31p5LcT+8cwixbtrtjzWDQNFc1K2WczbEIfbQgzvWnwh7mpGce6LlMRhFJkeqd3q96zmenHTcljy9DxHK2zrz99WB0kyfjN5hQSsKw4xOASDGftyVitTxO2f134R0fLQtLcBESSmikF4+w+DOOtLFVxUccF0qKS1E4sZBY1y8+8AOnt8a10iVw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec8c004-eaf0-4f3e-ef0c-08d84a871b55
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 12:45:41.4700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YyftykercZp/8lBbIxzExhPFJ9CikmR8/ZWzj9ab3xl373XlZC5I0HNzPuEo7xqj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4012
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598532344; bh=dfoMKqeSM3bZOke3po2JaIVv2Wr542dSfQmf6qJeZyc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Q283UuSbDldImWNiG978FdZr3Q1w/rbOmomfpEDOx8LUnWv/CYbFDDmvoCzXcxA6u
         v0ss2IDQLg983a1ADTWTPZ0CI4yl5qu3E0lwS7lCF03lztmIGbkL1lg+fDoqTcc32k
         wHJortVwWRJPwV7bhfxQ6eZkD9wtZPqlIr0f2BQ2jnaN3+7dRWCiEDvJO4YRHBOtuR
         9Z2Mwo3x8smd5TrF1w9+mItkhCnD56Zhb0PhGCFDEkf/G1WDb+WbtOCqpb41zMrZxT
         R0rNjqnwwya+XGVxc915J2uMwVvNkRMRyh2oiEKkUloLmSBBDDbDyxBIj0v1xuZDFe
         kwPRolmN3b/qg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 01:58:24PM +0300, Leon Romanovsky wrote:

> @@ -490,7 +490,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
>  	props->active_width     = IB_WIDTH_4X;
>  	props->active_speed     = IB_SPEED_QDR;
>  
> -	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
> +	translate_eth_proto_oper(eth_prot_oper, (u16 *)&props->active_speed,
>  				 &props->active_width, ext);

This is memory corruption, put it on a stack u16 then truncate it.

Jason
