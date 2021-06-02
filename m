Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985CC399635
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 01:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhFBXQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 19:16:52 -0400
Received: from mail-mw2nam10on2074.outbound.protection.outlook.com ([40.107.94.74]:56224
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229828AbhFBXQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 19:16:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBoAqpW96NKBvDdquXJZPJrJyK9eynys9ysqYMPWn6kITe6smoSmMVqvfSIWbTtFO6RtYZ/+AgFsK+ANW8Uh/wCSx+8oq9+VUHpk6s1jJ26gQNnGygk5R1e/UeUkSVfrtrbBHbrWRH6gIuLyb1J9aQGQk/DHDVEyPsIcRUzx+4q6xWQVzRph3HncyZMXbCwHKg/2RQu4FQZSx24yXiqGkTMVjRK2zfSoQPyWRZHdEG9LDDOTuW4uQhdCksZIwCZzLxPyZgFW0azlxOxSZh912bJbtdfDqM0eUZquZFV2SLdljmHkaIeWChMUylkNBKqEiQ/8ze//oh91iIMRBcQZ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3BNA2CFy9qcOIr7pfZRoKm67BYY3DiBkW+v0ybRL3g=;
 b=l/8fd7Bkt/IjQIBSTMiut9TzOXuOMdt9WvppAO1/JokAlSIKTSxPvkaU8z0JOaXwKOJq0FAcTCXbO2apl2scjGFWHksTEKlcYbcns/S/H/RuMFd25nGSYGesEh0LDUA2Fpev39IatK+Uh4SmCLygdGQWC04KhtmUnPeY5h0YNIQC6Vw0qkvCfTB02BDRUSMqlIMm7GQyqKhWFhjKfe3TVUKiJ/sqk8xifGe8q+flvPJOcWi7/laMrbTeEVco6182lAezf38tt1XspRibcnlduAI6snWVm+M08U1STPPWh6/PG8UTDOpo6raBByGDMrDjTosurnq/873tmPqhYzlC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3BNA2CFy9qcOIr7pfZRoKm67BYY3DiBkW+v0ybRL3g=;
 b=hzujVkS9U5ra9+2u5zwxT+Gdn+YwuNtmsVbjfovusTC/DHcCm2X++yHuArEnZY93R4+6WXdyIskfYOx5xq2Hxj02e85bzJZmL9Wf6cTd8NGhbPZZ5gA0VRu6ml2oP2RmUC3oRPMTjNUY0w5y6CWui/T84vGscR2wxFwDajCyjPixBZlv2Qfnhhuzdpm53Sy/qPWct2FJTKOqr01FMYtM6169oROn6l40pcHwlVlz3IhTwk6+KVT/pNrfglI49LWEywn/pWVRyc76FTwLOLhosBShb+u7uNzLt8PNyNbRPYAjc5l7H+bJaFeuJJKjf9vapbwtqwaMQfmYkj7FMfNhEg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 23:15:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 23:15:06 +0000
Date:   Wed, 2 Jun 2021 20:15:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        gustavoars@kernel.org
Subject: Re: [PATCH v7 00/16] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Message-ID: <20210602231505.GA188443@nvidia.com>
References: <20210602205138.889-1-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602205138.889-1-shiraz.saleem@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:208:d4::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR04CA0002.namprd04.prod.outlook.com (2603:10b6:208:d4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Wed, 2 Jun 2021 23:15:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loa4n-000n3l-58; Wed, 02 Jun 2021 20:15:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b900451-ccbe-49e0-1ae2-08d9261c421b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5336AFC80CFC98E8EF77DB39C23D9@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: viP1fPfIU/Ouqr3Oc9bE/AQvQEc8u9nMg0Ngv4vnSfzElKGJlJZYSompQ+w7UhiRtA/dJC+LtTHd8lRC1AmzHgdBS+D00fX0G4hRpbsda1XpxElmhX7nlToD9vtrMaW0jN1vW94PIEvzeNMh4QwoLoBfcbAs2s6Q0HRfe65l1SFPLBlxJ3l4cg2uKUDDzhU13TXXP/SrSfEgnMRSn376PGEBzbTWz+8l+pgJXWfqe1dYVSEOh4xYRrog/ab4+bq2QihzXileCmLwloUEJzF2YFc92UfospJEhDH8ewMAFXtKoL+UrRqXBM4G4k5kFaXJC5uYB5wZC/XHtAyKCHmfO7fH4LVs00YJZea3Nzqzn0qKWCygrjaq2zj3SS9Bvm3tY4eFWptxVD8IufnsOU92z4ANUGBmOABrDsX4VHsoWVoZaetiwqDSxHO1ehEPptsu2XMUUxrbOlX8vVsXUvs+L8Vy+jCgbuo/3LP7OIxuQxCCNLQ5OYAT23HOM/RcF/gUOcbPGoSe2keQ39Ot/0CYKAlZIMmo8COGrJU7qchJChFuXVxvCMBiZuLZ000VtpWqgUyKylInxoKqNnN+gDmW37Y1mth0oX0IwmuVz4MT1h0AKdex07N8Xd7lS5+XC9AxrAQbN8ou1z3CjkEfTYW0H/P59GrEdVZ1AmjSL/uaxCA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(66556008)(83380400001)(66476007)(66946007)(33656002)(8676002)(8936002)(5660300002)(186003)(426003)(2616005)(4326008)(1076003)(478600001)(26005)(6916009)(86362001)(36756003)(9786002)(9746002)(2906002)(316002)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9ZrwmYNGn/Fh2rm8Uvee9j26vyWzxZGv7foBxOc2PE8L8h/R3CEmpLc6M41n?=
 =?us-ascii?Q?MGuVEqwsuX7pxwKVjJi5QW8tDTnXJdpsnX6GGxCL+CwVGDEnNzExWbUXmIH6?=
 =?us-ascii?Q?D8h49jdochOT1fexM97mWECaIKfcfedlTxEdtkOZ/WdT1dbai4SL+6WOYajd?=
 =?us-ascii?Q?R6jJCzTA6U5oTZ5vtOpMWW6es9vtHawPipYrS01jw19kZaiWav0D605698RV?=
 =?us-ascii?Q?4FSvc3jy476CG3G+zWK/HTb6AedQVtvhClxK90uEZHhL8YT6I5jcirzm4dv+?=
 =?us-ascii?Q?zvIVxk8xegc1DM3JaQ9Chhp/iR6BPhfbu1gUXLLs87mQWaBwnMIiH+znhlHD?=
 =?us-ascii?Q?aEu/bvjPoxabV4MeNldVgnvY4jhmVUoFbLi5ZK7uqZrI8Z+sifwxlju78QkH?=
 =?us-ascii?Q?AmN/mSMO1ZH/oAqwYwCnOZ/t/Qrx7It+GErkK6DaAE8NnWjwy5y7m58FLRKj?=
 =?us-ascii?Q?GY04heFUx6Kfp4AJ3rhjubU5+3QoyjL9P5EkKuz2eyBotpNGVJme0EgXW5mO?=
 =?us-ascii?Q?vy+P+CThRBNJjpGPnI+seHPXSVgr82PIj2+wbDi5AK9MFqSdzXxYRvr5PLgo?=
 =?us-ascii?Q?60mtpeWYu/m1BgnSSLhjfE0HGjVsf15BieXiKZ5XnFF2Hn/W+PgRfgfshnpX?=
 =?us-ascii?Q?Jr02bCAFNeuVeAVGH/f+bIADh2W2WZAX4Xf1BVzDciHZZBT0ZbQZ91de3x0x?=
 =?us-ascii?Q?EM66NoTFn2Tku0VPBtVurBVcdwlxWpmwf0HERekQe15NcD5g8DzjyGHx2icW?=
 =?us-ascii?Q?li89Sk75J9RkemGtIhS0DGEAnd+b53Z+hyJ9JfnOODAe9S7mnziih/SCjdla?=
 =?us-ascii?Q?qQk+Sr1NT0K5vAHyYkjhOT46ul/uTaiy7ouI8M0i2abbB+nbBEERLiItnRIi?=
 =?us-ascii?Q?DWzXB71csosetdp+1xaNqTV8CS96pWGSqPG93d2gLOu3GxQWJ8XehWeRE/Zy?=
 =?us-ascii?Q?L6d/jzHWRhaWuY4gfJsSAkX418WUVxvaUVoIHxtRKnTPqQSQidA5tt4C4SYT?=
 =?us-ascii?Q?gu6plS/15BHMHtKz00QmDDlYLfr/Nzg+1m55gUcMN5yKAHYH9FXxg4E9H7Vc?=
 =?us-ascii?Q?u/VDyHBEtHVc/sGe+pSBwC6dL5Iz7wqEEshBJNRYlSXRPPb5OuSVIebnYbTn?=
 =?us-ascii?Q?i3Evve96qj3cwvhaS/83hylUG3A7Vc84BBKorelz0CVk5Tvgpcmfi1rL7ELF?=
 =?us-ascii?Q?92CjBbFTWX6gBZOpn+r6J4CFNTWsChzd43XFsMVrVYe17Sskw9YVLpOHuwWO?=
 =?us-ascii?Q?BEVTxSEeyAMlnw/5k7UQaFpgmTa3QtsKSXGd3UxriTNixOqFKWTvaMOmN8Fe?=
 =?us-ascii?Q?g7lwm0xLeUAdaPmi+9qe6zBm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b900451-ccbe-49e0-1ae2-08d9261c421b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 23:15:06.0972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vg2XZetmqjIOfyHZZF6M7YVMY5+0wFTnNq9PLrUGcSJM5gF6K1SP7Dm6q7Egod+b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:51:22PM -0500, Shiraz Saleem wrote:
> The following patch series introduces a unified Intel Ethernet Protocol Driver
> for RDMA (irdma) for the X722 iWARP device and a new E810 device which supports
> iWARP and RoCEv2. The irdma module replaces the legacy i40iw module for X722
> and extends the ABI already defined for i40iw. It is backward compatible with
> legacy X722 rdma-core provider (libi40iw).
> 
> X722 and E810 are PCI network devices that are RDMA capable. The RDMA block of
> this parent device is represented via an auxiliary device exported to 'irdma'
> using the core auxiliary bus infrastructure recently added for 5.11 kernel.
> The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA devices
> with private data/ops encapsulated that bind to auxiliary drivers registered
> in irdma module.
> 
> Currently, default is RoCEv2 for E810. Runtime support for protocol switch
> to iWARP will be made available via devlink in a future patch.
> 
> This rdma series is built against the shared branch iwl-next [1] which is
> expected to be merged into rdma-next first for the netdev parts.

Okay, applied to for-next, please keep on top of any 0-day stuff that
comes out. I need it all fixed in 2 weeks

Thanks,
Jason
