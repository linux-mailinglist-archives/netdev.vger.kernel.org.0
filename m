Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAE46B9868
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjCNO6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjCNO6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:58:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2098.outbound.protection.outlook.com [40.107.212.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348F56B32E;
        Tue, 14 Mar 2023 07:58:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5+4kh3OA/cND/wgijrjY++hs812NnZ57MlHVff9T590+OqoEahkDfIPAcfuiSk+I7AfDUUZLf7NR+EGsMrLVCti3AJ6hdWzPXkMLxdvzHUtv0eW9v0pBkSdmOsub7B31jzwwEQeF+JPXXvnJWM4ATJF8ieANs5PNMYEAqI2g0vzn4oGfxIYbVJwe0K3gpJ1Oc3upXnsldRiAf2mnwyy+k0yEzZjb47bPd3gQUSNN3y7dRcjI0KVzVTd+MpjA2nRyP+EwVQUw/Pp3zORtp4mqRjNZ89TUjxlArzP8IWIfTJYmmHxk9abtofk5rIQWjknMN9VEYjM3C2BkmP3ugcOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c98WnZ4HMURM3N80xmUiAof2RbpnVOku8heMYh0Gwmw=;
 b=QuzyrBZCsgV/IiKwCQJX5q4GXNVM6cRXCog10CfA3p4KOKKImORpqDotBGzXTa8U9nydGcaivOrOUXre7/qai2BZKkABHdiELn6ADU/ho+BYK4bltXkmSm82NK4BH1EVSOdTeWgjn9M0DmnO3UYrJgSwfORe3hITl907Q1RQd8Y0F6nZMrKu/lXmpQvzpCGV0fPabLx/6V5vnR7CcerGFyOQE1yVqmrdUeIuCQOeLeGQL90o39swT62Tit4rOcgskDgxsV/VTvfhnDh1scVxn+gDq5F0lrlYIBp1eTX3ydcBQc1/dQ4KQ/byCbbUKXqzgnAjVucI9UaI7i1hoM83QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c98WnZ4HMURM3N80xmUiAof2RbpnVOku8heMYh0Gwmw=;
 b=IEQC/ysN9xDttROE93QWaX5IiTi7cwsgPwMEf/byXYI3E/qin3psvNKZpri+9DcUDnoSe/S1K91NLsczTZ3KCPKuQb6PGNjSYSMmUPNKrrYE386TrCOKcPKqTZ8o+nMVsRElQV/V3A295K672ZNMeYyjbHgDFPAZIs/AKLKjdis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4086.namprd13.prod.outlook.com (2603:10b6:208:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 14:58:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 14:58:31 +0000
Date:   Tue, 14 Mar 2023 15:58:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: 6LoWPAN: Add missing check for skb_clone
Message-ID: <ZBCLj3fIeovF27z7@corigine.com>
References: <20230313090346.48778-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313090346.48778-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: AS4PR09CA0014.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d0ae6c-fcd7-460a-a2d5-08db249c934f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kYQLid4/Gta/gJfieSxrbi7ac1NYpLMwYaKIB5DPSMMUnHvmS0MAOOBhEwoq/+u6ulWaZr05blc35zOyjJFLK5YtHiATqp4a63HdJiUSOSPnLY9w3dj7NBHkQihLE484ZHtI518wozrv17QBTgwOQtWi3aWNDw5FtaYytHjtJDp21KkANNqcxIwwCGkXUYK+JrBFxyjkk36CDRe5sZ9lTcYC2n2IpZqZ+nGxcIdaHdWLayaKIBchOeJUeEOoDcxd020ckp/hMs2A9ZtACdAVxgdfKzvlNlMjBSLH72ecINzf+dnf+lgQhTzBe+fANsTmqS0Hb1noFSBCuui6eoSOGi2L/TCS9wKWGurY10WBQcBg+i/lW0lYW0/oUa+MNNcpVhWuVPUiZy2zBAw6Oibauu1ba5TNGKnKuSTAL2pRkVkBlepc1rX8kMyccJ20a149/t2jaCvfX15GwcYhTdghBMwplKokHNysSDU/Gc+B65j/Y6xQUvBowSoRSV3DDTHVGWoQaCXLAg3yhwVHruV379JZI5jI0wU4mg935bgrIGHJTxU1SGMz6m95Gz6TLo2YNc5G5BziTy7oe+7p0zfNSIPLAjB9Kzshz0iZHrvVPffuhkWmdSwYVAf/aJ607MqzwZEjrJw9456ajQrKiVPkjUq3LaZbhVux19TEa+Jd9ZDM5ZEwAa+hHp94uyb8Pr7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(366004)(39840400004)(451199018)(2906002)(83380400001)(7416002)(36756003)(44832011)(5660300002)(8676002)(66556008)(66476007)(41300700001)(8936002)(6916009)(4326008)(316002)(38100700002)(86362001)(66946007)(186003)(478600001)(2616005)(6506007)(6512007)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QQ0iDpE+ZclfjMPW34WMfZCF8vZpnRz9BqfD68oC9iJiIZvpuYpUd88n7M+J?=
 =?us-ascii?Q?0DdU+D7FdyY2vy89K4BAbHrGjvys81+tGz+zYpp2VLRrNZ13awq6HDqEq5Aq?=
 =?us-ascii?Q?QUnEb3VgdFSgQeOJLpkvkXdxlFqgUHmBYieqkxpFw1qOHpGOr3NSUP91NvP6?=
 =?us-ascii?Q?yi7FvQjQ5di5QLUT6XKc45EuMVSmrVRvMAyHH4NS4V+YewPaOR4NMFDvRjK0?=
 =?us-ascii?Q?SUpgW/sfy2CVouV6fEsH7V76hmKIoN2ZRGkNlPPu1Zu6eQ5RssOUrMX8hhva?=
 =?us-ascii?Q?FiCbaQljGOaUag4d5+iSAIj4l3wXVvefoI//tFnX8XuDXapREuwqwLRZyYht?=
 =?us-ascii?Q?R+610WDuQw4EG8kBIqFFW57OmyTdrWtswqqRUP86SxxRp0HP2wo60yNKB9Z2?=
 =?us-ascii?Q?I5Kzmyzv2RUaz9AjPYV7tPOh4jK4MJF7YuLiAU87NG8//R31ZcRKlVOfyqLz?=
 =?us-ascii?Q?NzTzUlJPbAKLAHj1BZZ5VAgVdFo8n7q9wvDdlh/Yalh85b6vHAYzMEO6oR38?=
 =?us-ascii?Q?Iz899Znbh1t83+M/jCzgOhM8M9Fqu1Av1pZavuXu3+HPaVBfonu2NeU/d+wL?=
 =?us-ascii?Q?EJkODFhQGVw2j9/SEYE/8q7Isq+rpe2eMCBS1ZZ3UTLzJ6k6Bqt421X2OlJR?=
 =?us-ascii?Q?+X+b6tAMIdiFjHp1c9GIsbxaz/L2aLL/gVHlySArInZioqhWBZgv89kindbV?=
 =?us-ascii?Q?4gomjqV6G+WtJpKG6NTBhypEEqyG7C2ZkQJPU3TvyQVxCe1AU7+gc0SaporB?=
 =?us-ascii?Q?o7Hf1gy3d44rU17RbWzgpiwaa13HVtsYHJLNpnYhiSGsSawL/9IEJOvmkvz/?=
 =?us-ascii?Q?JsbXteajNW1/sKmiW3uDOkJ377QI2ZMkRhAXJwB+LJINrq36xzDHWUb0y6LS?=
 =?us-ascii?Q?TAuVx49eAWHuYjOhdKZbCiwYn2QI6TCbfMqH/YB4+7GGWjnLCQ28tqMDcC/L?=
 =?us-ascii?Q?73RHFnXohj755Uso0h12DRqs3Ad0Qubw0BFsa5lWHJMhuMWCu2IdG8wQsf3F?=
 =?us-ascii?Q?bUOzb8peoxO7mhVzxX94GiK5Lrqj8vS0GKJtMtmXIupFi+FfMt2VhoGRD1Vf?=
 =?us-ascii?Q?WWOcAHda+0hnePMeiG7K58KmBHpmre7l9HqeChl0Eujrjj5jBa2zX41w09SA?=
 =?us-ascii?Q?LXWYpUyBmQUSeyj680GZJPPhxMA4nqsA0jZIcq22jxIq7/kcbv3O6/3mJ3zS?=
 =?us-ascii?Q?iz5kHdcFxo/SlpJkeGdXbXK1tmwbASE8u0u9x5FBtU2Ny3wXRT79MuFzpplq?=
 =?us-ascii?Q?f2EM5jkpL3ADVZKMKpcuDguKD5fJvbSIYbQBDOqRE+PlPn0zYkDoR9shkOKd?=
 =?us-ascii?Q?p3xYeWrgJj6TzNTaFb+wQBxonUqsUeqjXMKjtLBkx+v88Lr5Yh3Z6w5TgWBQ?=
 =?us-ascii?Q?QycPLW2/XuQ4E50jzGyp8E0d/uv1drfiPTXXCbTi1VD/9fQ7MdFSsZZcRllw?=
 =?us-ascii?Q?2K58nHoNbIvpSMBdJYWTpKM8hdrNUUGGvkyVUL0lOj0og9C1hlOPwE1mmb0v?=
 =?us-ascii?Q?FO8A3lp5uFhUhgKwmqlaBfRBhAkR8bhhB8c57v0+csFHZvxPDoQNc7U8c3or?=
 =?us-ascii?Q?dRyZyEGo9Lrlv3DmocsHqmL5aTYnsRs2Mvtbw0dUEYDps+uLYMiBjzpY3E5S?=
 =?us-ascii?Q?KwnWkXdlxCgchGDk0BWtzrtqIKY3/iYhylbTWN7GmqSV3lVSk65PK8XEFz1l?=
 =?us-ascii?Q?XpxDKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d0ae6c-fcd7-460a-a2d5-08db249c934f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 14:58:31.1461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZOCAfNwT5CaVopejtf8XJcuAhpygYyKMfdfQK4cw70AwjkB13zWcpomOuOBQ7uSTgXQJ7ysAHj+iN2pndUZcNwlDQroPypw3hPsz3jn0S4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4086
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 05:03:46PM +0800, Jiasheng Jiang wrote:
> Add the check for the return value of skb_clone since it may return NULL
> pointer and cause NULL pointer dereference in send_pkt.
> 
> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  net/bluetooth/6lowpan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 4eb1b3ced0d2..bf42a0b03e20 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -477,6 +477,10 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
>  			int ret;
>  
>  			local_skb = skb_clone(skb, GFP_ATOMIC);
> +			if (!local_skb) {
> +				rcu_read_unlock();
> +				return -ENOMEM;
> +			}

Further down in this loop an error is handled as follows,
I wonder if that pattern is appropriate here too.

			ret = send_pkt(pentry->chan, local_skb, netdev);
			if (ret < 0)
				err = ret;

>  			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
>  			       netdev->name,
> -- 
> 2.25.1
> 
