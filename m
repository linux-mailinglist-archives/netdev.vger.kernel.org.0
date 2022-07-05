Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83792567176
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiGEOr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGEOr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:47:57 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2094.outbound.protection.outlook.com [40.107.92.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5101E02B;
        Tue,  5 Jul 2022 07:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FocwQaDeylJNxEeeloEy8mB8Bl66pIERVrzUPJoR1BLEQjMsYO3AXDWKjbT3OJrwW0DbRhScOIY1BEBYgIp8+fF1B8y1Gres7XIBEXEA7mdA3bGkS1QYHO54WPEF1edqbAQ654bVYFBw3DLTo48Z/F8erN8hrwrtYdNV36KIn19SDpWznkQc+JZSQxE5IZt89jxOQYh1oWHka6HIevEa4tvjzugYI8qnDvF/d6fvcEPzGzXtczalXdQXGuK0Rpb9JTU+1j0YRnUa5Xq37LdK5a8Qw7DdDeILtxTR57HrNJMsAjVNMKCKlVdfr5iUW8ib28lGVOi2ItT7A+w89px4Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63CJL3SiiF6aAydC7CKqvc1CDvIlsHFD39d06LNhmDo=;
 b=hBDzqf+nkC0Z898lI5+CE9d91FtHXdaaDvTPTfU0a9UxQ2oaL3E5SxObA23ElEJkCLGOpIQ20yL4T3u/sKS90XJ7pePmeUiE9XNoMJUNGPdbE+HDMsLEII7eOmez/eM+8laTArTvg7ul92WxTiNlezjUTAmsps84Uixw9bop/A5HNFk8Hng3Nv/DW0V8gn9cNrashGRGU+OiFp8mkd2yhC8pSMNZL9/O0UDxxKxrOL6Db2TPxVVfjXzWB45dgWIL/qUvh51DZLsacbtS3iZTgXDYUZRm13XVvXW9pc5spGKGDm8kj2ykZDXxiuqv3VWMyRDsT6wUp/YZBtz8MIAdxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63CJL3SiiF6aAydC7CKqvc1CDvIlsHFD39d06LNhmDo=;
 b=ZgqPHQ5Yw7bieuZO1C7aC6g99KalxzxDy2CGFOeJRnE1/mpZLdP8GD3pzeN1PCJVXxGkV6jL/ydP4NTzK+ty10EtYlyNtf0mp1chICPzU6XlQZ3VXyIL1JdHwXgFumbZ6ad7cr9FTovyWJxaoY6tIJIvOGRl10kZnQGb2Xupj0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4850.namprd10.prod.outlook.com
 (2603:10b6:208:324::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 14:47:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 14:47:54 +0000
Date:   Tue, 5 Jul 2022 07:47:47 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sched: provide shim definitions for
 taprio_offload_{get,free}
Message-ID: <20220705144747.GA1522144@euler>
References: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: CO1PR15CA0084.namprd15.prod.outlook.com
 (2603:10b6:101:20::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f69054a-3b56-4a71-8297-08da5e95579f
X-MS-TrafficTypeDiagnostic: BLAPR10MB4850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QYvE1ZncRqyn9kvFbVun9b6RXSuLpXWwLMeWNdG80LFA7BCr1uUTQtInFqUBgjSiKjxUnvLJ+AJO3BrJFG6NutHB0509jLSfd6FSLJZxwKyYE8GaLzlRskGBYfMOSeuCbu99QjkwhYSHKjHy5Al3ZZ5RU4R18m85HOY4naTIVSBbeSbs823Ymw8ENz6q9hKwte1vTwIPm0hflNjWehZ/e3v//kBfYf5u5pxxsEYt41/npkhovnEyl7UaJdpmy7pu5XRTZzB09NfTUQVzDsMUwLLMhLQ8GPze/ANvVtgtAjVav0szs9vu6uLi9zi+mURRg2nVX3ROUnMphCrSOKYCV8NwuFLWNRipVqP01hzirtcHHXDc6JYXUnxr/l8RraedNg0DVEa9GN+Q+YHx7wBm8EERgmT7//FpYuqYFIOr/Md/s1u/Qi6IxzFhmcW56BS0rRt1xSv+cPpA9oz/nrpFyFiAGBaBNoiwc4BkVS3sFiF2dX5lAlIVxRJBMyFP2gPFjYnDXSzTfxJi7itd4fmXygye5JJEKcGd930uCpQOYTO7st9LQtcRWV3yQB8PdxnTDhbfZJszh4wqIeOIXj/Cvngw16Mt4LwR98BrkOf5gngKXN9vHqRvBJvD4YH+kPJMLt96VATNRe4Sbu2G3vsXXF9iuTgJbW+iwVGoF56RFyWrxBXm8NpkEYhaEKP48xgN68wEMKMm7DiekSuYwalR29qzjoRm8WLPRF0qdgAPZlka5XuCzAjzaBF+ahDP4mDD9+XE4c5sovv1+s0exV/3YPy8K7/6zHPcq5qgDTBerFfncr821QdtFhi0pjc2j0KC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(136003)(39830400003)(376002)(366004)(346002)(66476007)(4326008)(8676002)(66556008)(66946007)(186003)(1076003)(33656002)(2906002)(6506007)(38100700002)(33716001)(38350700002)(7416002)(26005)(44832011)(6512007)(9686003)(6486002)(54906003)(478600001)(6666004)(41300700001)(5660300002)(52116002)(86362001)(316002)(6916009)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T4dluZP2WnG2XTmEvNtNoGs8TYT1GH/ahCGV8i7QCll8FoOQKvqVqpaA+1e+?=
 =?us-ascii?Q?FkFrE/PBQP3YnbY6C8MEFbuRsa5n+NHMRvm+5ZBFml/4yKSR7xkrZSZRiO6r?=
 =?us-ascii?Q?dkvF3aaJ4qSiJroVqEN4psUUFSnVqNmqL87QEiln/UIwq6T6S6NnSNXUTRj0?=
 =?us-ascii?Q?sjKYs9TMKFxJBNJNlLkB+XL4pl/f8+G3AgsGgdzb7NKGiTXk6sfYLhoplnJK?=
 =?us-ascii?Q?ASXuA4JTOpxRJW1cvHRbUCswvZTcoiz3nj7DVjvdLQNd/fhCuqknTQP2hGob?=
 =?us-ascii?Q?KaZWWLAKFi6s1hmxjg/pZFyvs+9HVC/HFsTBkES9A+CT3RtZzbleAc1A92G6?=
 =?us-ascii?Q?MWB3xINeqI/aoDmyVvj+zsDHd6dcYRo/Svowgs5Prga48FOvBR+PT2tzyhM2?=
 =?us-ascii?Q?Vi7j6Ea8MlfFfB/SLr1D0vkMDFb82Jx6bKY8mZvNOjG6zkNWPbou1oeR58Hw?=
 =?us-ascii?Q?63MMGMDNb4m45gPj3PFL63yGvwPjd/IfCRlEK5S8fAZ+B2rsfzJzl8wohra3?=
 =?us-ascii?Q?mel/kNzW+XwpbPkUmT22+RjL8nP/aoUQ/0BzcwlxLN+siVH51h+vQAvO7Fta?=
 =?us-ascii?Q?/NoHEi/fcYudy+GrnQSOmVl2hZUx8LMFPnMHA0qeyk12bSnmm4zW/Cv46akv?=
 =?us-ascii?Q?U0nj/bM2f3ZzXweyjwcyWC7moIdgbnBUJ1s2FkcKtoGdn8k0keH2SyDe+BSr?=
 =?us-ascii?Q?ulhBTU3vxzuOEmShjvP8FXwLcTiE7g+22tJs1smXPxSIRDa7tguNVzKODZ/L?=
 =?us-ascii?Q?VpFp/WBuF16/nqvHFwGbNO/D49Kqk6vpCx3VdEaE3c/TsfY7AlHAYAlPyE/B?=
 =?us-ascii?Q?2YJmQjzKr7QzoOoX7xwZQj2IgovSIbbV7xpdPMj/A/96DS3/lgBDSO8bEjCk?=
 =?us-ascii?Q?2kwFQvmLm9yJohhC0/ASgGaPrL4B6f+NWOvsJ555hsDM3ogXCC+Snpj+xHH0?=
 =?us-ascii?Q?+bS4nJR+oA4Pu5qLlTMu1yfEa2TENaIUOsuLu8agGBW2qbrDIU/BoGFcSX3j?=
 =?us-ascii?Q?hJv5KY427UslaMxA5VXcNVSaJZJ00szQ3jth++yaHOyPKpq9S7umRy91nsKZ?=
 =?us-ascii?Q?sRcMr0qBsEedJ4A3ZckcRtNqh7eW6hKrUj1BrosvuPIadZ2TXu34qgYbXi/v?=
 =?us-ascii?Q?c+x0DbfVofHp4hjn3xdTxIqW53MrBypSBnrs6U3mlokvbqlneaH6kjEy/7SS?=
 =?us-ascii?Q?gWc9NuJaH+jfQITn0VuqPyLht6+qsvxMSb2eb0nGyTQsm3JJlkZJtZUAzEyf?=
 =?us-ascii?Q?RU0QaXE2AKYY1vTJxK3evqIn3QoKVY6oHSlP2ieZDR8dPdOwNRa7RVihaDxh?=
 =?us-ascii?Q?VfWQBCdKUrTSAmN+Rt2pDyhdnGV/WvoGyw5ilbiD1P/hQgdG9OJ+DJ7Nz0Pz?=
 =?us-ascii?Q?Ynv3LkRmq3xQ5IUrnfh0WZtNhPZs99+e6kyLLmQ+WnniTGydA7HK5TYDwB4Y?=
 =?us-ascii?Q?eBFXeIsMp7Qmi2ZCR2P4OJUDPTbi+nsdXPopVqppr+UA1hV4fvPlFeh+cT4k?=
 =?us-ascii?Q?K4v/EaYs9/GM9w4kUtm3Bj0XsuVoH5THq3JkMJEbF9ZEsQYQlbHU0Z7ckKf5?=
 =?us-ascii?Q?W4X8WWEbcO5ri2jeSwb67/ve+6hPZTG6jftWHCuDK13PLHhi6IQp4sXo7JpW?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f69054a-3b56-4a71-8297-08da5e95579f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:47:54.2993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXeZC+hIPha7FGdJf4Uxo01+1lq6tOAtHhc+sx6kps1oygH+jCwuHGr2KnIF/dV4XuusP1jOFuuunzjVFYvOWikSWcCX0ExfEh1URQX+hWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4850
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 10:02:40PM +0300, Vladimir Oltean wrote:
> All callers of taprio_offload_get() and taprio_offload_free() prior to
> the blamed commit are conditionally compiled based on CONFIG_NET_SCH_TAPRIO.
> 
> felix_vsc9959.c is different; it provides vsc9959_qos_port_tas_set()
> even when taprio is compiled out.
> 
> Provide shim definitions for the functions exported by taprio so that
> felix_vsc9959.c is able to compile. vsc9959_qos_port_tas_set() in that
> case is dead code anyway, and ocelot_port->taprio remains NULL, which is
> fine for the rest of the logic.
> 
> Fixes: 1c9017e44af2 ("net: dsa: felix: keep reference on entire tc-taprio config")
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/pkt_sched.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 44a35531952e..3372a1f67cf4 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -173,11 +173,28 @@ struct tc_taprio_qopt_offload {
>  	struct tc_taprio_sched_entry entries[];
>  };
>  
> +#if IS_ENABLED(CONFIG_NET_SCH_TAPRIO)
> +
>  /* Reference counting */
>  struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
>  						  *offload);
>  void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
>  
> +#else
> +
> +/* Reference counting */
> +static inline struct tc_taprio_qopt_offload *
> +taprio_offload_get(struct tc_taprio_qopt_offload *offload)
> +{
> +	return NULL;
> +}
> +
> +static inline void taprio_offload_free(struct tc_taprio_qopt_offload *offload)
> +{
> +}
> +
> +#endif
> +
>  /* Ensure skb_mstamp_ns, which might have been populated with the txtime, is
>   * not mistaken for a software timestamp, because this will otherwise prevent
>   * the dispatch of hardware timestamps to the socket.
> -- 
> 2.25.1
> 

Fixes my build!

Tested-by: Colin Foster <colin.foster@in-advantage.com>
