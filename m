Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1E6921B3
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjBJPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjBJPNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:13:16 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD87D4673D;
        Fri, 10 Feb 2023 07:13:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4puLoq+WcQYN2ThI3T+C+wyHGak1wpYV3xbUfvM71ycPTXQ1IvBTU4RA40ldBBU6woAnnAj4wTUFqL8HJ9mPCBz5cQr1Hqr4X1497QdD+trn+dVVpIiBjQmr/6WCrhIadQ0ttZEmRTHa3z11nxM6kbcw/b+miuF2sV4/YwUOYfXNfOb3EVb7mZmZuUXdS9WOhYRmsymvkG+UmWqubNpkdre5IKemQeNQ1+B5UqMH4kmFiAqIVUIrOR0IU4T7DlnnOSLEUtBS5yEodo4NltTgIaM4DbHno0lzenWC+Ua38WCAvD7mL97Hk/Gu2O8SbrbhMSPoKxymvtpqbA/zlpmzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYuHEcs0/SkbyH2VsVZbN4LMkhogXTkouTH+Z6oqw/M=;
 b=NNGkPXmmh5FeThFwMAQ3KbMj2lRfarqf/hTo13oqV3V5X1qrN1OMkeQ5ovzZfl0xJz0AOEw639OFh5JhVQBmQ1dL1fGsG+RGBBP+F3gfR47OnFn38Ix4VnZ7MYa+ZZ9mrRHKOWzlpcuox8l0bh9HDDFvW44vk7I2hbMJnzd1BU/clWtpy/06gb1A+CK6u0jL28+9h8eG7Pz5j8ms5pi7NHxnC+vWQ9A5mke3Z8WkilLxhr2+AhyVA0362FQtdSKAVM846vAO6fZzsN9UH/Dobm9vqLtzbJkqBDxYSbOBU9b2Bg61Nd5PlKIHS1ZKy3JDjuCAbeZJmpvw59lABADuMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYuHEcs0/SkbyH2VsVZbN4LMkhogXTkouTH+Z6oqw/M=;
 b=WKH74PeFbpJhJgXFlQPMEDjF0m5/ey9Mja0CSM8LL8wOoyXtzdOLLPDvFwvK18x6qsUMJSn4TnayfwooUQoo2Ewpb9g3yoPvRa0Z4Ydh7l4BmF+unReo9doExk8ZrDe8qxd4KhemUm4ShARWv/ZuBHvLU7dFKudt+2lG5p/kkc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4496.namprd13.prod.outlook.com (2603:10b6:5:1be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 15:13:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 15:13:12 +0000
Date:   Fri, 10 Feb 2023 16:13:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        saeedm@nvidia.com, richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org, maxtram95@gmail.com,
        naveenm@marvell.com, bpf@vger.kernel.org,
        hariprasad.netdev@gmail.com
Subject: Re: [net-next Patch V4 2/4] octeontx2-pf: qos send queues management
Message-ID: <Y+ZfAC/5NjiuPfQE@corigine.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-3-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111051.13654-3-hkelam@marvell.com>
X-ClientProxiedBy: AM0P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e616a76-6f94-479a-960a-08db0b79533c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yz3rczhTu1mmvDGLwRWYftvT+PoBhHmMNhN3NloOdR63ywN+jlZcx6qBo9Fv4mYJckUdRquyXP7+bLB3CuS1+k4oZnBM0NA72XwzKqXXAtby3MmIpPU2Yia2ZDIXcIJ22F/cAC9321LpAk6nbUrB+QO2WRr4Cizzwn5Hmh5KooA0q4zs32BZrtFrcmHG8mSu1hmrENt1cQYQa6bbOWSeF30/coc3Zj0nnvl0kkz59FkjPeoF4KQspT4ZcUsIm7dKDY+EaE3HFqQ1KgCThPu0IazB6++C2RAo5IJjRWem2IcIL6tKibe2p9hQgj809G7xPOJIUR4cW8TsWaO3R1D/0GMQmV19yNi15tjYMPUlp0UXL5xsCOCvRv72++vGMhxPQr7e4Soxb5/1EmxRPfY5ZbWuGJ5sdsVZdY1FtwloxcoeDlO/ntAhSuTPokwkHeXtR+6UVYPj2d5J7uN+owilfldAH9XqlmMqXDt/qki+lQ+y+HpfTplz9BTxA9RZZHkmAe4tc3jqztTE/Q2uB98iKPcl21OUaJ2lUmQNB6HOh1aq05szilgQhiGbvj7DClDWI2PhRaNHOgKxlzvXBKm9q3AxMMN/Dvs67F5jx8iQ+LFPWJ85CAz/NbNUU1cMyVzKK+UJEn6hJ7so2FGcrF14Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(346002)(39840400004)(136003)(451199018)(316002)(5660300002)(8676002)(4326008)(66946007)(66476007)(6916009)(66556008)(41300700001)(86362001)(36756003)(38100700002)(6506007)(6512007)(186003)(6486002)(6666004)(2616005)(66899018)(2906002)(7416002)(44832011)(8936002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PftRIJIVoCai694UG6ZTeOWnuDD+OJo02E5SkzP3RjccBuG8xVbhpHiPaJu4?=
 =?us-ascii?Q?3r7TJF5c9Z81O5uGCXbchEhA9/6s2JeGQyn4zFUI58jYYb6p/TtsFhqPCRRE?=
 =?us-ascii?Q?Zo6ia2NpTDBjSAsbBtIJwrOa36zDLTf0vpjXlvQ0m6NrbrI742yEM6tJ6XkV?=
 =?us-ascii?Q?0tujPTh26eNwxKYtMWkHcVAm0Gux05oVjJhWL9ZbjHbawTDNMPtlZO8g74us?=
 =?us-ascii?Q?yEs2vVo6sdaUcZA3X3EtyAyIb/G9bdxbk4PJT8+e1+mF2ntITd6P6T2oIjzn?=
 =?us-ascii?Q?9Hglmt6nQsAn8UGCDzyeIePKm3fhsOTI+mR9SETGpjVmaydhnZNuPKGbcpvx?=
 =?us-ascii?Q?3HsvWoRpSwkpP3UMGWLlqZ+H9WAoFOXz9hLodmT/8CHpxuyNMVdw8EPPNMS0?=
 =?us-ascii?Q?K6DB8dhNbVG/PZNYLzrxFn/M5nZlqWRlOgQvD90lwTcmNCCGwc+USHv0JJ68?=
 =?us-ascii?Q?r37yejuN+XwiLJZtPhr9ZmndpZ0Y4aAQ+9fMQGhkz9JD/1viO8F3g9fLAjB7?=
 =?us-ascii?Q?8AxG4Qch4nRFSNy7fMk+i4wVJabSHGsG2qnXDDS4hbQPYC2VsEWNGWzMJJQO?=
 =?us-ascii?Q?Dz7wD1FRFQodGcteuq/k0f6ePXgdgVCkKdKbur6FV1kiS89Hvhuk8K2Ku3Fl?=
 =?us-ascii?Q?yVBFA7D5Zdv9AXxaOqL3T3yVxeYmTdbGrE2sJxml516B45LEf8eh2G5EcfRY?=
 =?us-ascii?Q?du7koaAgqkfc9gr+L1AbZE0OGkN4BaKXuZum0x/XBAH3bk4Jborl9IlEk4M8?=
 =?us-ascii?Q?KKtRCqEkug1bM8Qp7zgYQ8z+ceLyzduZuXcQhowrrJxLTNRi18X6TwXp6kVT?=
 =?us-ascii?Q?gJgwVwWpPnKbCVBvV1iNq92S/DJZbBp/IOKU4wjDx3Xx2EA9GZhnZycdmzr5?=
 =?us-ascii?Q?1eFXAM+0vBEaFLBmNkeg4us5NH8/5EUs9zqJhPVKHYEFqvbxCsjvmCpMllS4?=
 =?us-ascii?Q?uGy/iRO7EmmrxWw5EgmuY3tF/uOgznN6dxrCPbOjUcvYRUpIo02RT9pHgSHO?=
 =?us-ascii?Q?fqMmFL+QQNCm6JkkRISqFs+Vy+mg4oU+vVp+jfT7qdyoqjK0OjVvQZ4/o/Go?=
 =?us-ascii?Q?0Qs1r1VdBH4vE9j1t3P45piafmnmJTH6Vo6CUOjMg2NagCxQ2KRFRgswQbHv?=
 =?us-ascii?Q?qZRKln4mCFLE9ByZgcZK/fMSl3wl32l19kMIaDGxnQs8nEY1fVuB+8Ktjw23?=
 =?us-ascii?Q?yScbcNBCv9b4UQOri3+KpRpSefSOPPat64oRxgNn8UxsvKpgujFf9krxJM4A?=
 =?us-ascii?Q?llL8YIcw2q30BOt8JuseA0rG3A85UxkFBhaAl1YjXJyvL6br5VNWASooPvUR?=
 =?us-ascii?Q?M8NLOC8a+LAdNEWdd4Nm+/XFWPapzxn6Ii+1SYRHzaRH6uGfpQ5l+8ckEdQ9?=
 =?us-ascii?Q?qiP/QqEsQsV2odVXOuo67aRmgMj3bnRvInZT/gxJ4TQ7A01F0oykVT9C+eks?=
 =?us-ascii?Q?gelQkrjOlA7b2MUVTuy57F2mNPkJXz4jhtYKEW1KP3VDtoUFDGFFj2xleLR6?=
 =?us-ascii?Q?mXN9JaDC4Epwi3LhnO3peR98Ua4BFNoiGNMWMd1/xJKfU+Z7zNgJnZrifOiU?=
 =?us-ascii?Q?q77nbaTrFf95kf1p1PrnV6r3X6YY8bacGSEno79gbNyb6TR1OeI6tU9nKi32?=
 =?us-ascii?Q?lO3Aly9wzZS/uMpJpkssFRS5aIqepWTprRmoLfIvBb3ovI/yLDeFiyFHiHvI?=
 =?us-ascii?Q?H0OJtw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e616a76-6f94-479a-960a-08db0b79533c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 15:13:12.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAV3g9FUMrBY13BVoGM5yRxnAeJRONUk0Tkn1qHMyvxBis5pHc6YNmxmMGxM1SIlgJGK9IOzedpwnXBG9wzR7XeVl4qlaklHoz9uwZiFxYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4496
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 04:40:49PM +0530, Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Current implementation is such that the number of Send queues (SQs)
> are decided on the device probe which is equal to the number of online
> cpus. These SQs are allocated and deallocated in interface open and c
> lose calls respectively.
> 
> This patch defines new APIs for initializing and deinitializing Send
> queues dynamically and allocates more number of transmit queues for
> QOS feature.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  .../marvell/octeontx2/af/rvu_debugfs.c        |   5 +
>  .../ethernet/marvell/octeontx2/nic/Makefile   |   2 +-
>  .../marvell/octeontx2/nic/otx2_common.c       |  40 ++-
>  .../marvell/octeontx2/nic/otx2_common.h       |  29 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  51 ++-
>  .../marvell/octeontx2/nic/otx2_txrx.c         |  25 +-
>  .../marvell/octeontx2/nic/otx2_txrx.h         |   3 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   9 +-
>  .../net/ethernet/marvell/octeontx2/nic/qos.h  |  19 ++
>  .../ethernet/marvell/octeontx2/nic/qos_sq.c   | 290 ++++++++++++++++++
>  10 files changed, 430 insertions(+), 43 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

nit: this patch is a little long

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index ef10aef3cda0..050be13dfa46 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -463,12 +463,14 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
>  			break;
>  		}
>  
> -		if (cq->cq_type == CQ_XDP) {
> +		qidx = cq->cq_idx - pfvf->hw.rx_queues;
> +
> +		if (cq->cq_type == CQ_XDP)
>  			otx2_xdp_snd_pkt_handler(pfvf, sq, cqe);
> -		} else {
> -			otx2_snd_pkt_handler(pfvf, cq, sq, cqe, budget,
> -					     &tx_pkts, &tx_bytes);
> -		}
> +		else
> +			otx2_snd_pkt_handler(pfvf, cq, &pfvf->qset.sq[qidx],
> +					     cqe, budget, &tx_pkts, &tx_bytes);
> +
>  

nit: there are now two blank lines here

>  		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
>  		processed_cqe++;
