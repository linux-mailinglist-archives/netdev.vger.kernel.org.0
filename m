Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104FE6BCBF8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCPKFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCPKFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:05:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C3B5FFA;
        Thu, 16 Mar 2023 03:05:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwqVFgvCf8h7lpWf/6exz0xlxwTpzrxOZdgeI37f4vsA93Ga7Qmt1e+oBxLDKHSVLem9vSNOKexhVRsXIEx9gm+cno8YhuzLnyC6Yn22TUpbdr8FWdBhVL0RPzuQPojjietk8tpkKkxLXdPoZTC+QmJw1MSSIJiGjZFnXriU+YuDwQx6fijpo08DtSgKLpXxLTPtjtBBY3U83brLWumI0H5Sxpb9E2AutMthonLsB0wxRY5+byXcgMPvi8Upkd0KZ5hIecLaQti8auBvK36IDgUC9qTcQP44IN5mKsaDtVlUrNTZMRkRrR8LF1d0qWHnf8le6gNQe9jpnB5jOMNwJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sA5eh3AxfgrRdgzLbsJu+ooXEGyPszJzvbhltoSqbXc=;
 b=VCeoii/1R70eA2ismqXfBP4/GC3IcuUhiMU/3bpXp+EoIU+PB1qT0N8qRm9wdDQwCKzUS1a3Gj1YaEO2USvCIjin7gVyrl27PvsX5nTqfTVGlW+xyUsFnU82uZEZWflUHOl5rvMVUVrqFO3W1Je7zFYbg56Bj0vWfXifH/0vTs4AOliWUKMmnTHuA/EJ4mxRRctuptzyxYR1FJfjBqTDtHvGEL6rV94O3FpvkeHA6oTbmgn37X9yJkkCXzoZOygQuOWBiLCSa9k3EkoVoExmv6nc5S8Z5g4o8JZi2pc13Dvb63cpLxQWyLt4WU7wA/6a25LycGFJbE4aMQwWso1mrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sA5eh3AxfgrRdgzLbsJu+ooXEGyPszJzvbhltoSqbXc=;
 b=MWp+3P4aHY/P7M10AMMn0EUfchPWXO0+PxoeBDe31hKBlVNBc5cdMXymgADaioihvzwrcVThua+9lv8eL1xobN7pKzEj+vyTXwHLmy1EHKtwPkORL323VvcnhtoCKfmzUaN5zZ/b8xp41bYvRMQHqWonpySfLfiMOKO5TmeitIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4066.namprd13.prod.outlook.com (2603:10b6:5:2ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 10:05:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:05:30 +0000
Date:   Thu, 16 Mar 2023 11:05:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/16] can: m_can: Add rx coalescing ethtool support
Message-ID: <ZBLp5G4qARbScJw0@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-10-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-10-msp@baylibre.com>
X-ClientProxiedBy: AM0PR04CA0060.eurprd04.prod.outlook.com
 (2603:10a6:208:1::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: 455a3ba5-3461-4ee7-d2e8-08db2605f935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SxHZavhh1VFh2gu1PbQJ8IRTr1DywrtjXG2l0GaFD2anmUumSBi4O+z3usJbNQhjrUF6YVzUiOLXgxccigthMicdu/D4m7LN5iN4x/0RPHV48bItXcXjcsuTx/7DjC6SyiOBEqUF7hbMIDaTMGRGnFs5c/qCoKLNEdBhhXe5QUOJJZzUTrvWmc7fA0w+BFBWFVPvRB7zRYfmbQeX6N/Da5+X4yc4F3E5NJhJbpJfJtEaT3qO9Yp/7osKl9AfdedyZMALlU9dXFn5l0vpH8Tb+gCTuFPpK0jwfH80uVAuDeMWpAWL1wIvBIx/e4cJWatD+UPV2oQfvns4FkziaPfYeoH0tzygsZobGmNeRmPWazVKyXHHn9nSPUey+Yr+9oLj3fcfU2zzMb0I8le2ZBl5cVdhF8FPtquR2fI4Wb1U/RKKfjJ88HNfqesgGF1BQsfQiYtAJnHCQjIly14CQglkDKfBa/IKIQbf6Tu6mIOXOXH8/cHaLwQjo+9rwcANrhOeyk0tXiHxkWl20q0ya78DJNoJOdbV+ikFMxQxaTheJ4apn4z+HKf4EZNfrlfMmUO8ENlruJmSbziGxDTRqtVfl1D01JoujRUwoiq+sC44wMo17VtMe91onU0y9OiRIroOFkv8kXINyEoCchtv0Vx0Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(376002)(39840400004)(451199018)(36756003)(44832011)(478600001)(2906002)(186003)(316002)(41300700001)(2616005)(54906003)(6512007)(6506007)(6486002)(5660300002)(8936002)(66946007)(6666004)(66556008)(66476007)(6916009)(4326008)(8676002)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TM7Jo+h7oLPM/EbAJn3L+rOuk+nWp/y+pAraO8Ex+VErTMr8Em66Ny/YsvdI?=
 =?us-ascii?Q?3an+h+YD4Pe8A6NMVWxIpCIP4xGVq7kBIZiQiJoDmmTW8SRrClpUyAzJqzmy?=
 =?us-ascii?Q?4Lc2Nr/E09pIbNEfOhc9UbgEtNcyFAFrUZNkZtbDZ9kSbVSW30u0WoP+dFAr?=
 =?us-ascii?Q?54/iYYyOKE2FMWnSo66g2FEONvu5raMOMQl5T7sD5oF6TGPK15VEnnY6IvCW?=
 =?us-ascii?Q?TfpkEw/r80ekc/cvZc77wBoUEHnT98EOBQQGp3q5VAS+j5sud9pfeJa62wr0?=
 =?us-ascii?Q?miuA6NU3o5IAgqw+DBTKkhTIIGFMd3NUx8rF3aCKGxkjJQmT1XmFiTVSBOl8?=
 =?us-ascii?Q?AqPzapNTW4GxdsyxsJkQRPzvDkyTn62yvLvmUGXLeDPAhWBZbaYtmuCAWsDb?=
 =?us-ascii?Q?o8zYvwDZa9CRuJLbsrWqUgBTVyaTBrnHkeFlJATYJsf8WJNUL6bA4BvhOo+M?=
 =?us-ascii?Q?OOWv/WRL7qJzGWGt8uUDndH6YgOZ/p4OGGcsAN4Y5IjILw88NbndZPb/9pPf?=
 =?us-ascii?Q?TiUAHL03j/6cDD15o+9C5Y+K4B0fuuWU2CP24uaXuIXwTYYFlafGePiAToyG?=
 =?us-ascii?Q?3BzzmCH7BOvHkyqeENuf/S/XQOReGlnHwUPiH2ouF2KsIOq861XXe83Ck4us?=
 =?us-ascii?Q?f+wBJOwVhCt71UJuw2F7ySTbx/hugpboa232GEau8jiP/1czCOglbLhrRwJy?=
 =?us-ascii?Q?S5XxuOPao9BNnZ8szT8D7M1MXUtoi5hoQFhsNuA2nln2L4Cxvm/9p2Vsh9TW?=
 =?us-ascii?Q?d1qYn1KWEsinOEy4NVJxkWILMyTI+0aE9OwYSreA20WNdPTTrKB9b1cVsU3P?=
 =?us-ascii?Q?MsB6rSdji5LWyvCHTb/CmhZ3iJV1yJr0kE7u2jfSK0NsRaKU1itpuiI1qw02?=
 =?us-ascii?Q?SIn+AUvI7XpmV1ufh/u9LqihVg2ch974iLnkDiVPAin4L9/LTurCVQ7DENEZ?=
 =?us-ascii?Q?br1k7ClBhNS8uPLzBECswi2xMU1MuUFuwA/d06rJkqDmOCTBDI+xgMcVxdPd?=
 =?us-ascii?Q?N8V3uRJyUcjW0Ngj/lfZrqN6Cyx0/fAxx25Q/H72E/BPV5yNVk8UHED+lf88?=
 =?us-ascii?Q?QmhBv31nihdRDIryhILrAcvcSCq++KuU5sIeKgTLqrXXqAU8o6oUOr9r3vmT?=
 =?us-ascii?Q?XTkjwmeioA1rI8f7KzzT+HOnYzVt139hBRunzg49SKG6xUMxtjFL7j7HFTqP?=
 =?us-ascii?Q?IcBDf3ewB1rpE/n5UkJCW2Gr88xtPLXZ3YYFivFrNtOcOWs3agg9sMvKLGxn?=
 =?us-ascii?Q?c2FcfKCRRLb1DJa9/13Y/WIuYajIvpCSZyytSurfywgiQaJgnmlMd3rcth2B?=
 =?us-ascii?Q?gFcR4d5cyOOhO4Trde/PFO6Et5uKzADtjZV5Tfm3jBRfnmIH8MbokDHLdit2?=
 =?us-ascii?Q?Qf7g2jjZxRn3BXziuDPwaoPy/IJMjuhnEHU57zoPrz5IJiRQa1YCrVkkspPf?=
 =?us-ascii?Q?f0gCSU+/6G4JgCqIuqnGJ/r1NYdvOYC9M5fZBHQ6gXfaZQi1bsvSM1o1qPYh?=
 =?us-ascii?Q?HwX+FV3YBkbFdEBYZ1S39Gx9pPjuWKLODJ9ngH5xnKpn+5RNl+8Tmu4JR2DH?=
 =?us-ascii?Q?xKyQQzIdT7iDmVg0JR7LF/qvXyQSgTEdsLYA2r943nn8HiVaHppoQFNcqCli?=
 =?us-ascii?Q?EEv4KaqmWVbq4lP3WrsO70Ttg0Bm7AYo/FGFxTXPRfGzncD1PDnn4q+CDAgh?=
 =?us-ascii?Q?jI0hew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 455a3ba5-3461-4ee7-d2e8-08db2605f935
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:05:30.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3q4e3jirFICtplEj8Nv22f4g70ArB3NCc4XHOPhQngdWLlF5xwoTh9Jh5VzQqB1BgfSsFkGsY21OVXnwSpc4MCd30mhZOSqwIiqzV15OMF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:39PM +0100, Markus Schneider-Pargmann wrote:
> Add the possibility to set coalescing parameters with ethtool.
> 
> rx-frames-irq and rx-usecs-irq can only be set and unset together as the
> implemented mechanism would not work otherwise. rx-frames-irq can't be
> greater than the RX FIFO size.
> 
> Also all values can only be changed if the chip is not active.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Nit below not withstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/can/m_can/m_can.c | 46 +++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 94c962ac6992..7f8decfae81e 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c

...

> +static int m_can_set_coalesce(struct net_device *dev,
> +			      struct ethtool_coalesce *ec,
> +			      struct kernel_ethtool_coalesce *kec,
> +			      struct netlink_ext_ack *ext_ack)
> +{
> +	struct m_can_classdev *cdev = netdev_priv(dev);
> +
> +	if (cdev->can.state != CAN_STATE_STOPPED) {
> +		netdev_err(dev, "Device is in use, please shut it down first\n");
> +		return -EBUSY;
> +	}
> +
> +	if (ec->rx_max_coalesced_frames_irq > cdev->mcfg[MRAM_RXF0].num) {
> +		netdev_err(dev, "rx-frames-irq %u greater than the RX FIFO %u\n",
> +			   ec->rx_max_coalesced_frames_irq,
> +			   cdev->mcfg[MRAM_RXF0].num);
> +		return -EINVAL;
> +	}
> +	if ((ec->rx_max_coalesced_frames_irq == 0) != (ec->rx_coalesce_usecs_irq == 0)) {

nit: checkpatch complains about unnecessary parentheses on the line above.

drivers/net/can/m_can/m_can.c:1970: CHECK: Unnecessary parentheses around 'ec->rx_max_coalesced_frames_irq == 0'
+	if ((ec->rx_max_coalesced_frames_irq == 0) != (ec->rx_coalesce_usecs_irq == 0)) {

drivers/net/can/m_can/m_can.c:1970: CHECK: Unnecessary parentheses around 'ec->rx_coalesce_usecs_irq == 0'
+	if ((ec->rx_max_coalesced_frames_irq == 0) != (ec->rx_coalesce_usecs_irq == 0)) {

> +		netdev_err(dev, "rx-frames-irq and rx-usecs-irq can only be set together\n");
> +		return -EINVAL;
> +	}
> +
> +	cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
> +	cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
> +
> +	return 0;
> +}

...
