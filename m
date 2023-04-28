Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC3E6F1AB5
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbjD1OpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346079AbjD1OpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:45:15 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF70E26A5;
        Fri, 28 Apr 2023 07:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGBHwSwcZj+UtM56X2GpuW7yc+UhN5cuZVTQnEi7TCNTcdZMH1xbmuetE4gnwRICP3O6oNsvZGIXX0GV1CJ4LBqmZxFADlSyj+UvOekH7Cr0vOgZ9fiLCRshmi0Yv8lxFuhP22DT1DaSxORJKzbeQstlANzFV6uBaut8DeoFa0TE3SM3pzh6DSK/Kcd4lfh/5oaK9IMfVs5VYyloDkOZolTzgemMkdlNDvxXpxuhXHyw8J5M6pLRcmTKI9PyaOcdZwEGI72wd2UZZ006RMaHjC6SzZQkzFMhAgR+WCsXuwROPUfklzE2aHFmoQ8Wx+LV+5UmydFb4AxvakNrawzT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nn2xf7V2z9qcRFgAdUxz5VmDNQ7pbFvCCyG5SeW3tIo=;
 b=e3hB3JyxvZb5a9Mch7bKKwDQkp8MLqHiMu3roJ5kgbaaLUBiBuQhnLJhsXO4wO4Q60dsH95BcYl2VDK0dMgBX8bYb/eQLic0FoAvxjTwpgNxwTrzOoQfdDAo3kVgf4PPC7QkxzCJU1meSr1V5giuhRi0tchgcQc9okMyBUlTbvGyW8zRWcw7Reeo11pVsXu90A1CSsJz0CG3NYlCU+95my1L1MI/onv/Iv2zf1czhFUHfIcyD4PT/rG1B6gN8fXnoMDRNmLHhgFB3wbae+6mnVRhdO/ddD0v+P1/cHz2b2TPPxvSbV6OsU2TEh8bJcBM89IjmjBhlBoFpCSgpnRZIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nn2xf7V2z9qcRFgAdUxz5VmDNQ7pbFvCCyG5SeW3tIo=;
 b=UY3ygNSMqMGzvDcVfiWwhj9HYMCcjnLGinv062tmigjg/5tEUqE8palf89VvtC0Sk4YZqZW4xAg9XqQk64ATHJfmNax4ue1Jjdu3nEo5334tXGhLPV5wSLYb239m14S4oZ9OjxW++0+btbS1cIaibn1yVTIadHmEDO3uz5eiBME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6285.namprd13.prod.outlook.com (2603:10b6:a03:52a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 28 Apr
 2023 14:45:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 14:45:09 +0000
Date:   Fri, 28 Apr 2023 16:45:03 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v5 4/9] net/smc: Introduce SMC-D loopback
 device
Message-ID: <ZEvb7wYWoTySzU9O@corigine.com>
References: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
 <1682252271-2544-5-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682252271-2544-5-git-send-email-guwen@linux.alibaba.com>
X-ClientProxiedBy: AM0PR10CA0113.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: 57cd38b9-383f-488d-0657-08db47f72a5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pP0W/12qFfdHUIcFPhWTSXBWfB1NRGXLz8+nfDkUYNRoDPmqGoBeCgCU7hsqQHxEjwGzIhXIbBMHS5QrPjFWw32MK8RcJfoEthCVSMezXkQbIsbKkFaN+pkSzCkxJZAMUugbMx2OmdlZKAlqdvHcy7UNuxxAuFSjo22ftVHWceTvuEf7GYGiZnsrluInZ8j7WiK7KUahyBDqbymFpRcOSNEA12a7Im7bVe7NZEUBYqNr5tglBAuLE4fpAD9tqqBzxGQZYOM037B1gQS791x0KbPKRZNb+lFYcjzaetXogoNOUvmdtnnxMk4bwLr+bDyCiVUXWD4I0QbbIDQEHhXZqYX1y5bMSKsUfPEADD7W8WYFV9I4OtwOYy1MJK8HQdvCcQGEuIGYdT06sLofTPX4RHXkLQjSY8BXlkyCGLbYd42Y+sy6vDCuY47T19EVMIfMp1t2kewHE67ZXyjO9aqagVADsE7FzJgq7zNQadS1jP9dBMCgBdYe1qfPvZ2w5QB25PFPIUnmvbuRk4tT77lDc2tNyyUUWtfbCDSJ7Yp6C0hZNGjwS3ZvmWCFdIU/qvCU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(376002)(346002)(396003)(451199021)(44832011)(6512007)(186003)(6506007)(478600001)(36756003)(66476007)(6666004)(66556008)(66946007)(4326008)(8936002)(5660300002)(8676002)(6916009)(41300700001)(316002)(7416002)(6486002)(38100700002)(2906002)(2616005)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gxjRjN1MW3WLV5v1PZcuKauRz3vnCnPmUeVuXP44v3ft8xfa0wo3BbXs1cw?=
 =?us-ascii?Q?g0FSTwNLeRpVEo8thXjNwKWY6LFPIiBRmcLlNnRcF+A3lbKcFjKCqEwbFcWt?=
 =?us-ascii?Q?0qCqt1dA4MO1g3tJhVGkeaK/O/fv0AVy309iCCqlyhowwZtC9200I2tVYDcA?=
 =?us-ascii?Q?Q30WHg5GBEQmw0NeCULBXFpcbWl8ulR9IMin3HBBE3khDvpXA7MJx3qbofPM?=
 =?us-ascii?Q?vOcQoGfVzbm/xrlPlOx95+BZCRiA6denmY9j//dSKTQXN0ZgRbWKpMaaQJj1?=
 =?us-ascii?Q?2y28RIWkkfdzrQRIUtXoV8/pXoXRgDpDXB3RCNfcavLU3lLdcunYubE6ft3j?=
 =?us-ascii?Q?Ykvu40wNB3cWtT1TqQF6Y3bQA8PoExskQdrMvEfB6A9i3BSwfB8UmAsBuwfl?=
 =?us-ascii?Q?E8eIg7ngySBgxSy1/X6B+c5yZmjwYeE3PB0XdpnYN2X2dp0S8OEpNfBqzMXv?=
 =?us-ascii?Q?MjStNFoRSXzQGgvjAVbCXeM7wgw5smd/hAw0ngSuoEF3oqy95sVTNfrKIYnq?=
 =?us-ascii?Q?aZQff5xVWpkN1RBQiEKRzEGmWcb1TYvrnYzIR8v0ACjMRdv8nTi6ubQ6pyvO?=
 =?us-ascii?Q?Ti33QGMUe5kx/k0cEgdVOqxysO5owm4J+vR1gS14fULHUvxv1ArNb35YGraZ?=
 =?us-ascii?Q?nIA0tN9y/U1cwzbUxBJe4p1avDgg2j5zytk//7cMZEH7+jsl4FH2lbshsnDC?=
 =?us-ascii?Q?gU7MyVUMbZcLUDd7KHbx3WaPJst/jyUUv5pz0Jk1oMbFK79PmayN653fo7Pu?=
 =?us-ascii?Q?+rGilAs3R/w3azKwhDt8BTOjjcGWnTFJgQAZIdQne5gSADuSXOASmqyvjKHx?=
 =?us-ascii?Q?58t4ozm5zFNrg6yVmo/N39WjXeA2NlHtPzrUEdpeVwqPtYnvi0KzD0VO/hzG?=
 =?us-ascii?Q?9mQSU6SunWGNGNo8N1iSci+SAyFc/QdXyGCNyZc+8OWnD/CZAplYPMIdtVsQ?=
 =?us-ascii?Q?okUBz9xJtHNEdozj80pruGmFNzXvWnIBQyJLIZSR2Ax+W3/Kn8mVettVBYkG?=
 =?us-ascii?Q?ze1Ex0qCoUaIg4mlo1G2tZjCZq0s9C1DX5TJW0v0yHlVp+MTqlcE2eQL0JUl?=
 =?us-ascii?Q?J+J+Cp8NmjYlNK/vz+lPZQ0rYewJyWfqXlV62lIPg2jLA3ydoSLfHmhIMrK/?=
 =?us-ascii?Q?j2gMMm2FhzXNYoWYlDUji27LX03t2AOYPqr/SZr2Q6MxuNlgMwTstau+33QS?=
 =?us-ascii?Q?aUh6HyOL5Le1yHsNaHgYsqKmbFdhKbgU/6aOgKWpwJEwkTyoDHa6F8HQIJGY?=
 =?us-ascii?Q?Dg3fv5MP7oh8TZNnJ3zKrnUINTWgHGuzHcx2NnzS99eu/GEC4QB/oHOmc8+6?=
 =?us-ascii?Q?7Bg2HSLLVF2h13PTCfbmVNkLNn+xbK4L6WY8CIQ5An8J22xiw4++ih5CwBs0?=
 =?us-ascii?Q?uVxd5BFk4AZtjj0lhmfcuKMrCvWQAoZRpSWtVjQ8x68dNvyu772wnTD1flam?=
 =?us-ascii?Q?Jm7WEzyxRX/apyGpE2JFgWNvLRWwtPEObORF9XLedU0XwkJwKpYjLv/8FC5a?=
 =?us-ascii?Q?UXKvfV/Wb4r6v+MFnmnigl+0w1hBwvaKokrs3I1qLqpuNaoDvNHr0E9SFfoI?=
 =?us-ascii?Q?Q9iKV+rzQOVnywfpFPQBeiXW7DqIjPAt3rey94yHDlGfKE+IeZ5ijtMMFYim?=
 =?us-ascii?Q?M8+P7U+E+CRFFgKGKsgfrDVjyqHa2KJOAf70v03DtKV4UBbZwA0l0dN4E0H6?=
 =?us-ascii?Q?syf83Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cd38b9-383f-488d-0657-08db47f72a5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 14:45:09.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xec5yzWAgj7tfmuZRMjjGkoxKp2fDH9c3V9Q4zZx9K3Kq3gidEBS6eD/5VHOq1KUmle/URq6UWtctGimF9NJCIWvkq4YdSoz97PJJhPzjmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6285
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 08:17:46PM +0800, Wen Gu wrote:
> This patch introduces a kind of loopback device for SMC-D, thus
> enabling the SMC communication between two local sockets within
> one OS instance.
> 
> The loopback device supports basic capabilities defined by SMC-D
> options, and exposed as an SMC-D v2 device.
> 
> The GID of loopback device is random generated, CHID is 0xFFFF
> and SEID is SMCD_DEFAULT_V2_SEID.
> 
> TODO:
> - The hierarchy preference of coexistent SMC-D devices.
> 
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>  include/net/smc.h      |   6 +
>  net/smc/Makefile       |   2 +-
>  net/smc/af_smc.c       |  12 +-
>  net/smc/smc_cdc.c      |   9 +-
>  net/smc/smc_cdc.h      |   1 +
>  net/smc/smc_ism.h      |   2 +
>  net/smc/smc_loopback.c | 406 +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/smc/smc_loopback.h |  51 +++++++
>  8 files changed, 486 insertions(+), 3 deletions(-)
>  create mode 100644 net/smc/smc_loopback.c
>  create mode 100644 net/smc/smc_loopback.h
> 
> diff --git a/include/net/smc.h b/include/net/smc.h
> index 26206d2..021ca42 100644
> --- a/include/net/smc.h
> +++ b/include/net/smc.h
> @@ -41,6 +41,12 @@ struct smcd_dmb {
>  	dma_addr_t dma_addr;
>  };
>  
> +struct smcd_seid {
> +	u8 seid_string[24];
> +	u8 serial_number[4];
> +	u8 type[4];
> +};
> +
>  #define ISM_EVENT_DMB	0
>  #define ISM_EVENT_GID	1
>  #define ISM_EVENT_SWR	2
> diff --git a/net/smc/Makefile b/net/smc/Makefile
> index 875efcd..a8c3711 100644
> --- a/net/smc/Makefile
> +++ b/net/smc/Makefile
> @@ -4,5 +4,5 @@ obj-$(CONFIG_SMC)	+= smc.o
>  obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
>  smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
>  smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o smc_stats.o
> -smc-y += smc_tracepoint.o
> +smc-y += smc_tracepoint.o smc_loopback.o
>  smc-$(CONFIG_SYSCTL) += smc_sysctl.o
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 50c38b6..3230309 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -53,6 +53,7 @@
>  #include "smc_stats.h"
>  #include "smc_tracepoint.h"
>  #include "smc_sysctl.h"
> +#include "smc_loopback.h"
>  
>  static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
>  						 * creation on server
> @@ -3482,15 +3483,23 @@ static int __init smc_init(void)
>  		goto out_sock;
>  	}
>  
> +	rc = smc_loopback_init();
> +	if (rc) {
> +		pr_err("%s: smc_loopback_init fails with %d\n", __func__, rc);
> +		goto out_ib;
> +	}
> +
>  	rc = tcp_register_ulp(&smc_ulp_ops);
>  	if (rc) {
>  		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
> -		goto out_ib;
> +		goto out_lo;
>  	}
>  
>  	static_branch_enable(&tcp_have_smc);
>  	return 0;
>  
> +out_lo:
> +	smc_loopback_exit();
>  out_ib:
>  	smc_ib_unregister_client();
>  out_sock:
> @@ -3528,6 +3537,7 @@ static void __exit smc_exit(void)
>  	tcp_unregister_ulp(&smc_ulp_ops);
>  	sock_unregister(PF_SMC);
>  	smc_core_exit();
> +	smc_loopback_exit();
>  	smc_ib_unregister_client();
>  	smc_ism_exit();
>  	destroy_workqueue(smc_close_wq);
> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 89105e9..2f79bac 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -410,7 +410,14 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
>   */
>  static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
>  {
> -	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
> +	struct smc_connection *conn =
> +		from_tasklet(conn, t, rx_tsklet);

nit: I think the above can be on one line, as it was before this patch.

> +
> +	smcd_cdc_rx_handler(conn);
> +}
> +
> +void smcd_cdc_rx_handler(struct smc_connection *conn)
> +{
>  	struct smcd_cdc_msg *data_cdc;
>  	struct smcd_cdc_msg cdc;
>  	struct smc_sock *smc;
> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11..11559d4 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
> @@ -301,5 +301,6 @@ int smcr_cdc_msg_send_validation(struct smc_connection *conn,
>  				 struct smc_wr_buf *wr_buf);
>  int smc_cdc_init(void) __init;
>  void smcd_cdc_rx_init(struct smc_connection *conn);
> +void smcd_cdc_rx_handler(struct smc_connection *conn);
>  
>  #endif /* SMC_CDC_H */
> diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
> index 14d2e77..d18c50a 100644
> --- a/net/smc/smc_ism.h
> +++ b/net/smc/smc_ism.h
> @@ -15,6 +15,8 @@
>  
>  #include "smc.h"
>  
> +#define S390_ISM_IDENT_MASK 0x00FFFF

nit: I think GENMASK is appropriate here.

> +
>  struct smcd_dev_list {	/* List of SMCD devices */
>  	struct list_head list;
>  	struct mutex mutex;	/* Protects list of devices */

...
