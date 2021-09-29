Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06741C2A2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbhI2KWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:22:13 -0400
Received: from mail-bn7nam10on2137.outbound.protection.outlook.com ([40.107.92.137]:40896
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245447AbhI2KWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:22:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O//Aq6N0fdslnuiZ9MMI1vS4ecrn26p6ikBPLQ5HSaaEXZaFs3Z1nCeRn9OBI273XzW4ATcb+fORZNarMAlf1e0p2BXJ3+6vH8JfN/Y98aZkm4Y08hZMIeGiC46lp4pzWemNP5GF9qvt53WgLkXqcZdCxONzO55d77cdEqyZhRIFwfh1Elk7408ZIcNQfBbyU4ccA9agOexQr7pY768TSQaZu5hJOmh3/RM21IwXDeS3LpnXKsgmS6gZI6r1gzBicp+xUMzx59SryKlXvkAVLjckIAAMYIqlo/kLE1kvGXpYNZrgfPAtQ8170WLkw0VFHYMnFAIfkoy7YSAil8060Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOZlWPLXQPY0gPvirnsZcJ323xMITNDauCcvQz4Sbao=;
 b=fi8pv894u242W3VqAdsamgIMhRYk94KAQ2sEItAteQiNPXBp2U/lsYMaec0M5ZxWrlnxYnVu0qCmSh5k0fudjPb2dEQ2EKTEO5ossxSFLGttfUDgJcU2V2iqsehUbrVsYm1IpcJfU1SL1frLwTesRGeDChXPccpVQfYYUDhu+TgnmX64OCYyNR6FcWjgiH9xEx6tk9cRUHjWZ7q2IiRfEcem0D5hjkLiqNucbU9zp7t8J7yT4Lmj7VhUVESnbH4s2LpgY43858cbReiw9m5RTvOG5QlRu1oP/cAYjUhkQ4Lud6x+f+I+IXufjB0e3fpIJQMM7eHntefiLw8uX/V43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOZlWPLXQPY0gPvirnsZcJ323xMITNDauCcvQz4Sbao=;
 b=B6uhtD/zeUjWRHhjdYAOcv1/w5xar6nFNGfPKiAcZRnMC5QZAO90A/l/emnthLvFMo1MagfNtM2qe/Cf1wDh0p4T1RJ7jY6F3DiCM+oUe6kFdSA99AlrVQ/+9qJGceTvakWdlDrirGYFocWPx6YVlelKg0HEYNUHnPo6iS2oJ5A=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5549.namprd13.prod.outlook.com (2603:10b6:510:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8; Wed, 29 Sep
 2021 10:20:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 10:20:26 +0000
Date:   Wed, 29 Sep 2021 12:20:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next 2/5] devlink: Allow modification of devlink ops
Message-ID: <20210929102012.GE13506@corigine.com>
References: <cover.1632909221.git.leonro@nvidia.com>
 <0e07ad986db7d2f033a97e4c8253940676128237.1632909221.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e07ad986db7d2f033a97e4c8253940676128237.1632909221.git.leonro@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR02CA0151.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR02CA0151.eurprd02.prod.outlook.com (2603:10a6:20b:28d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 10:20:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45303152-c089-4d83-108e-08d98332c176
X-MS-TrafficTypeDiagnostic: PH7PR13MB5549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR13MB5549B963C4E6CE0498109274E8A99@PH7PR13MB5549.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0gwb6enp47sIQDxhgdBlKmP+I863XqUB46DqX41Ie2As42nbFupYuA2oA+Kvs93rCbAeLkEpEjlKDTujXTnaadI0qdrdUQ2idU3Q4YffpJLHhi3chu4n61HsI0VVCOFZQ6B4ILXAjMh2NPmUouwSLzUItbtvTwCzATTBKssS2RUK8YWcpv4G5GuPUCTDACled4kEe/V9Qpo8t8NrZwio6YC9tehasCvMrcNX7+wVFfAbSJCWAzajcT0pQvcPOapOKqmGz4clkvX4sCTiK2HkEfVvj2DKhTN2BZ/WJmiYyXFa1eiIlJx2+vytuWyKhJfxoJZgrZVrLBOl1BHtZiW280SSmgpi7u7rlwXE78/EbpV+XAm/QdCxWYtBzOe/OqB89l1omhqvJY2OUckDhvtyQVmG/DFIZxJAUt0C0hnTiQCFsVxz2xkF8Mu9q29P0ch+ebcdAE4P4JKTyDPfCSCY4edZ2C3M1bEeXIAfKHiISoDbdnyx7skZRCV4/4eT7fKfzqpnbWLJp7uh35CV48aCX0Vlg85YB1+Bn6b+BePf5y6veAb4WUVCUmBq3E9f3UYXPryv3IhpCmjSZlbxWpTYmtHOHP+aS4APLU8uWpWoJcDEgY7ptg9+mwh+23Zvv0tXT0dKdC6KItpbPd0VcsyQog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(376002)(366004)(136003)(396003)(7416002)(8886007)(2906002)(7406005)(7366002)(36756003)(5660300002)(6916009)(186003)(4744005)(55016002)(44832011)(66946007)(8676002)(54906003)(66476007)(7696005)(33656002)(4326008)(6666004)(316002)(8936002)(66556008)(86362001)(508600001)(1076003)(2616005)(52116002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z5R5e9yLtZwmq9QgyBkYROkwqmvZdBMTN6DeeTjW0Vwq6v15PIhelCAOinxm?=
 =?us-ascii?Q?CYI0OiyzywcSq1IRH2JNPy1FpYmAU/+E9eXB0bZ8guYf0R9gvgM1ETey6o/s?=
 =?us-ascii?Q?13LuO/XEfRZh7A1amW0u9sG0ei3a9/hf3jtE6uZOCPVZ2u4LGh6DnIG7mhtv?=
 =?us-ascii?Q?I39uO2prchWCO48imBalWIX0qRwqW5LBH/PbJhBSC5QfWMjU5vG3+Tvj5Oai?=
 =?us-ascii?Q?cHdlMyeWrp5Er2lldCGKDVt2zIETCdRXgIuVWr1/bblXSMXGaM9OeHeT4/I5?=
 =?us-ascii?Q?P6Vm0EY4aeTM+V/Yk5lfz6nU3GxSbNTRGtJSMLWCqxu1R3UzfOv12maD9027?=
 =?us-ascii?Q?IHxDG9QysNKNj2fDJR0OpOF2HCNznsYSjOD0Ygv5TutoRrXOEd/uXcgUQbQ2?=
 =?us-ascii?Q?z4rQ881uYFgRvf50hIFgNtLNpQkz0/Dhi18x/VStQzGdZTfOmFLHx7s/bboQ?=
 =?us-ascii?Q?Ss30whPAClIjKIU79q+QyPFkD3Wh01QGPs4fjhtcJJO1ClPPTOvt1gpeTJN5?=
 =?us-ascii?Q?uaQ2aCz8G9XBi+XyUSKmw+jzFrWGtpE7OyxOH0w4XE5zKgK3sjuEzTXwq+R3?=
 =?us-ascii?Q?TPjpBSiWpPJLZXxWYiad1rce1FTqQas1WzXjaqulUZ4JxDPjRoqsuD/SIlC1?=
 =?us-ascii?Q?6pvQFSPkVTC1yOMSCRCm1jydymgqv7matOGg/lS10oVvdFalfH5srfn2jpO1?=
 =?us-ascii?Q?FhkUyicOyV3SHqcDGuFW4dY7ZM042vz5IKsfeNFeTImFMxVb7CDJLLGW/DA/?=
 =?us-ascii?Q?CLc730/7iRkDC/vBaUzpFBlLzgcuYrFbArKwOgFP0Sy5+YBo3j9XqTH6VdzP?=
 =?us-ascii?Q?nzXz4ft7BIGPykDg12C2RR2GhctvGFGTsZOwZLi5NyVHhBreRCLKzzoIIQT0?=
 =?us-ascii?Q?dsCQ5XVDnuZpYVEL2sgVtfRZHNKg+wfqkq/6mHZeHVV0zV/FVKZD0Xsi4kwe?=
 =?us-ascii?Q?b/XFFdihtjjBmpK3kbt05IKnxWIw995JMjBUbKUSFhXkoauC2RHRpT8j/RYL?=
 =?us-ascii?Q?APlFCqV9L4iRJChMD8H9SVs3O0uKXF3n+GuHDWbl/0rLM+qeSPQ34v9cEV1d?=
 =?us-ascii?Q?uuyJ/wAAqwXbfwcu5qxyUo1se81+r/porvJi17BQx5CLbcjrh9oJkF7+JAfg?=
 =?us-ascii?Q?Sn484pzX5cGLosBFuRlS+qLHa+0EvIEhlwrcfQn85HWgA9jm124PGtGcKskI?=
 =?us-ascii?Q?UCkGm8qYA/pzLMJ8DMMa7n1zbS+UMep09VXttdZrrcpKvJRprQYqFtLZMv1P?=
 =?us-ascii?Q?Wayn3aeUG/Ab6sAEOFBIHo6AUCVga4C4vVYnM7Z8zA+C29Szpd4IXFnlBZFw?=
 =?us-ascii?Q?PSkX4fEp/hqge6bfZ71RWsbPQF0ArWXVfO5WY4i04ji5Aq/JBzGsj2o46U2a?=
 =?us-ascii?Q?d4dskpp7uVHF3yihSnXe0LUs8EUY?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45303152-c089-4d83-108e-08d98332c176
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 10:20:26.8522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XyILxma9ANFLKXogIyiyKC9P/dKtepSCYORj279p1yh0zb2p9JEQE3LJH4E1aZ5ad77bvx9POH/UNvqy2xVhJV0XGkvzKV0Hd56rsDSZ4tE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 01:16:36PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Drop const identifier from devlink_ops declaration to allow
> run-time modification of pre-declared ops.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Thanks, for NFP portion:

Acked-by: Simon Horman <simon.horman@corigine.com>

