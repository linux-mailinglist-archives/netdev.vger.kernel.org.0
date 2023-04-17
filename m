Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58E06E49D9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjDQNYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjDQNYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:24:09 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2127.outbound.protection.outlook.com [40.107.95.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613EDE47
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:24:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iym+t+1Ug166/TwZ1NMa5MevfI6g2hr4Qixxa8evElJD8zCYTKW2i47oi19AveDiWTDbVWEBAMLWoZTRXJcNMS4lNlq3E1EdYbDQ35/DJP2ghNwSq04Qed4ICCkkUwQiYgLEHxhdNLU+68HZKPfILfGXcvrvdWUKnrc8jwNotwluKaCNzxS9sRcw1GyVCDjkujwJiO+hwr60CYvj70mrPYwwCZpA3kKGdx5S/RthsxOxELQ4UdBU5S9t50LtFjHdGGz4cSAdyLrLyBnhZi9CviSDmrEZWViJLkhCudxf4NhIfk9ovmmqA0vq/lEaCg6QXEKShVx5EqZMxJw5QHJ5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loBdSyt1ax++xaIJCX1E5Nn2FQdmVgyILrLqI4cpaQM=;
 b=c92E3koSIpD2ymldcllM1kqQ9S+5Z0l30fiNOPqqwdFleZKh7hAs5bXrmgyxt73oyOLLszOVzbRd2J1iw/Z9CTJio3HW/TegkVyz3n5ye3lxGNqAuuDL48bpZ4hKtkfkDBr9qNSCXb+tfYwJrIrpptMWBALxynCIdOxGrTfjZ4T6K3IsVQEHo+EomQYMNb6kmexJ196Tn/rjKj/6pXzt+Qh/pWse2dJRxJojhX3rkEghH9FWIswdMfEAC8Deg0VvabNdDtOYRpyAC+iYETXab1GNLmryLUM3PYX2nRy4fyF3gdadyTe08/DUh15i3K0B/9bdD+rcUMLaMOVxA8HgcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loBdSyt1ax++xaIJCX1E5Nn2FQdmVgyILrLqI4cpaQM=;
 b=ntgIR9naGDw38qITWtuSL3lR9TFrFTBXsKLK2B+2gjXE3Dea3pImtSvX830q+YcDeb8P7b6M16xD96mpmt6IzXDWQl1RddZXDxc/oA+9jG2pQJnDxbl13sV/6kDITxFNf8yVvkZb1NmPrc9iWFAtanMgNbi39O8Dc2jlwZTIseQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5744.namprd13.prod.outlook.com (2603:10b6:806:214::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:24:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:24:02 +0000
Date:   Mon, 17 Apr 2023 15:23:55 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 06/10] net/mlx5e: Support IPsec TX packet
 offload in tunnel mode
Message-ID: <ZD1Ia0ZB6mbZkQEC@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <bad0c22f37a3591aa1abed4d8a8e677b92e034f5.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bad0c22f37a3591aa1abed4d8a8e677b92e034f5.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AS4P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5744:EE_
X-MS-Office365-Filtering-Correlation-Id: c56c0a2d-2e70-4ee1-3950-08db3f4702c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8gAIttA4bBhxXrbvs/u8laTcxcANvH61Pu9OEfW0sq0dG5yLCEFzxeF1XHRJMZ5ZNn8kd2uLfDt8xwqWBWiNrTaQkDXrLdK6VRd/T7AKtdCXBcr84jIrKPfzEaCWweetPbzla0b3r8LckjcKUW9Moy75XAefX1qKkvFj+2qTFSRp5ti/vvx29T1CbnfMBJvZR2yY8TfRNE8Jd4wAKicCmKGAYVyhBxmf6LdUSYCZI+Q+Vq5dpN6TRoK3ng0rNpUOwvgsfRvPdXN+saOjBtQs0GHOwEZnSmMbq0/14XHaJj9aDCzXDj2Oo2RG26n7AGHbd047dGzK+HRtdNwzvqBSaI+2aa50PlcSOZMhw3+shezvr7muLmSlmjzqaY/RjtPIF9MnMGMS9gIrdrBAloKXdUuS3UBz2A5m88u3HhmoCN74S8fKP5aPhvk3WnKdsNIgJeHwNL6W8q2n3FJu1TFNnjn+CjYC1S+Tj3clmvrwIJeVX8pc0Q+0pxuH3M8HRm0ohr38/m+d616MPPB7DBg3qOJOkOpN1sjjnTIdAKh88+MiVYrxP/AxswAcrC9ezV1Q+084FnirEX9eXgG850HS6XUl0KwF1lbXgBBH7u07iQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(366004)(136003)(376002)(451199021)(36756003)(44832011)(7416002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(54906003)(2616005)(6506007)(6512007)(186003)(6666004)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b2vqCXvvfo4zu439d6So4A6pSrnbPif+mLl/Nbs70Vm3/jzzpA8Bo1TQyayh?=
 =?us-ascii?Q?8CwXZMBjVmyYxBxRXdSN954R0Yu4y/+1RDzo+VEFnvD/b3s89M7CN1rohsPz?=
 =?us-ascii?Q?2d120kEelX1VtIb0qo8tH6FmGBqr/22fcTIKuOAKl6WR0Wq7YmI0wVCdjL2j?=
 =?us-ascii?Q?KKKr1QN/Sy+ncPEM7L45zj+yymnRVZl4+sEnitRWEXy9XjdOsimLLBt2iODJ?=
 =?us-ascii?Q?G2Pt+UIR8staOCgcW3/X+6NEleWWc1AyJ5Boki/MYUqBGHpgM/S7hFkddXHl?=
 =?us-ascii?Q?epDcmlzva0DEh5xzej0AuqoOyuGq3uEu924AaeGh7CA1Wd0ZWqjp+z0TLoJu?=
 =?us-ascii?Q?UCKI8MbJpdGPu4t/t3SW1o+jyUBKaCdcBkjbk5kdCCizhPJ+TTI/lss8zZ3i?=
 =?us-ascii?Q?NwulVQ81EyqL1b5YNad5T8a0rA3kxQOQam51Q35mLWZrYwq8xAy0PQRgrUfC?=
 =?us-ascii?Q?7GN57F80/vOvkGdsDKg/Uy1ir5FreUYFjVjoB0k/uzTOBojrTsjNR8mx0cN3?=
 =?us-ascii?Q?/KSEfCbiHKdJmWqWoeV5bu1CsDurkdkDiTocblsvZebeEMr2YzilCI0UHgkp?=
 =?us-ascii?Q?cY+9Ga+Zg3SboD6BR37rDmglZzKGvC5KTp3fbXkzx+MhcJIVc31NEqSceJ5m?=
 =?us-ascii?Q?qYiBzZKpltJ8P3nu5yqxwrNGhc9z9rHAdKlKRfdw2PTCriP35CgdEfide7Qj?=
 =?us-ascii?Q?Vog4ZQ3HoO7EeH9X+NjBCfAL6zd3BuEsp/Iri1uBtsDxoCkQEnpej/qDe0Kc?=
 =?us-ascii?Q?jM/UyrNizuQTYtOPNX5ujOWJdIeI9unDYVSo5OI8vadbJuemyjDZHV+dVWqd?=
 =?us-ascii?Q?ig0JoXWbxG04gRUTnASSM6shKN0QKJ2LQtvnVY6ELIjgGd4MPi24spdCFZAh?=
 =?us-ascii?Q?QakTpVDBrZIJoCduaeE5/iXAlh+y36hBzJcBoKY3kMmpdeiFTPtGJA/G9v4o?=
 =?us-ascii?Q?KD44rcFiUhGg1L23p2XxgvySuXuk7ErLlmY9cHCP9rJN/dZjCHVXruucRKyT?=
 =?us-ascii?Q?mKfapjaZeSLN4VSUfNpZ97b2nv46CbV5J5m+YU+JmHfoLrnzSp/vSu1ZAlaC?=
 =?us-ascii?Q?0lq9EU9obXWOKT7Z+a/BnfDKAGayahwRqiF+SQiVotQ/Fafn1S+cKkx7cxmW?=
 =?us-ascii?Q?cJR44yDL3zipSwJOJINTlA6qpkwvUEsVTHg2ICoL6unNZPMb+XTn/8ltM7us?=
 =?us-ascii?Q?K6q8+gQ0Bs8uYPQidEZe6GCAr6yYHJ0BDAJRDkFsdrLyUeL/EUfh8Mh3SvXs?=
 =?us-ascii?Q?2YYgZapdWTxB3cYuYNWGmyn2Yqt9DWN6ex56G8eAoCP4CjceP5APz3K6uHIx?=
 =?us-ascii?Q?8AG1IDYK0yVh6VNCoprOamgKTVijYX0r1GqUOnx0hDYCyi6cUEER85b5eujn?=
 =?us-ascii?Q?0WAK+MVSPwu3K1TiEe2Uxj7q30u9QfYui79Ux1JrRqoY45z4vYYTUjD9KyQd?=
 =?us-ascii?Q?NDYX+9TJP8NurFw4Ty5CCdWU+6LXB3DvW2a9J0/MZ6/0nfGQWIWPM+IdupfO?=
 =?us-ascii?Q?YSRDPNW0JY6OvgjhOy3Ab+HYO84JC5R9Y3W66vcmIdZtvHND95FkvdG4Dn0K?=
 =?us-ascii?Q?ZZaXwQwUM6kyeJTkEnbdyA9QsaKAVJLZ/k5+ZttSbg05WPe+0TqW0SVsAJXt?=
 =?us-ascii?Q?nWKDI0qyUfKP47tl5pwlWsbiFvlvaaeF/wqZf3mSX031ErBufCATKK7muRxK?=
 =?us-ascii?Q?CW5gog=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c56c0a2d-2e70-4ee1-3950-08db3f4702c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:24:02.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3d0/ryCVLYQ+RbjldLCrbrnSvz4T81wc0GFEEhuYl4VcRFa8D+8GuYW1zNZs4T/ecJHIo0N9nyLAO68yPW16KS+CG93aIr2OXoEMYqCKYMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5744
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:24PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend mlx5 driver with logic to support IPsec TX packet offload
> in tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Nit below not withstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index 7c55b37c1c01..36f3ffd54355 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -271,6 +271,18 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
>  		neigh_ha_snapshot(addr, n, netdev);
>  		ether_addr_copy(attrs->smac, addr);
>  		break;
> +	case XFRM_DEV_OFFLOAD_OUT:
> +		ether_addr_copy(attrs->smac, addr);
> +		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
> +		if (!n) {
> +			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
> +			if (IS_ERR(n))
> +				return;
> +			neigh_event_send(n, NULL);
> +		}
> +		neigh_ha_snapshot(addr, n, netdev);
> +		ether_addr_copy(attrs->dmac, addr);
> +		break;

I see no problem with the above code.
However, it does seem very similar to the code for the previous case,
XFRM_DEV_OFFLOAD_IN. Perhaps this could be refactored somehow.

I'm not suggesting this warrants a respin; a follow-up would be fine IMHO.
I could be wrong entirely :)

>  	default:
>  		return;
>  	}

...
