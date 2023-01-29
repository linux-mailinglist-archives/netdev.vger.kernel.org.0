Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BDF6800D1
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjA2Sf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2Sf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:35:26 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F178196AC;
        Sun, 29 Jan 2023 10:35:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVBjt+zC8JvykZG9jg0VT0UT2q8k0qDquM0AVlJSulsWQ8LfmZdNRiQsg0hec5QqOs5MxfRAREi0WAvzBZxpuUcpNmWR52rgljbJ/tAZuTFQDeY49fysUsyPldXavAY/hkTYJ37kyx81G1rh9Was3s9j0cjHDKawnppdce6IEIaNwGyNCrcpzQQErPyvTPB/nnQi8oS/34+GbbfsNmP7UvfD79j53SO7jdQUWqw92sQybpzWc0RPWDhDXK9JaG/beajMQaY6JxdqX2fKNcetIy7Shqq+fqOPlGqB73Gg5Ymd62gyYoTx5Kp8usF87XW02ae6sPkvdv0cdP0XF9sL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykyTsM+iy8GvAP8iFmqak/909J/gLs3uehqeySLRqC8=;
 b=RQhddmNyUgtliOcjIUKm1d94AfZVS6jctZmyM+cG/6FP5gouojBgrgEaBaM/j7g1/pX4hDDOXnCQiKiAk3v3Xwyf7Q0Onoz6DGjFn++jVeKDWUnVM4cBx30d9zPMrwiF+W+wVwZlYl12bqYaZOtwX9w94LfW4hScPGV77fXKKPbphzPImT0I8JFQ/88AMIYz3fZYUk677jpiAjH9q0ipNtt8gRaCcRj7Y4bpRS/jtJR9NWHzdy+e4hH1p2sIWQjXH3IiLOC/xH0cH9uvuoeNodpHLSngfN7VAH37T/5+l8z0davcTVQZmjxVZSuPQqIrIMjHlYNArOqQmOjhI3ud6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykyTsM+iy8GvAP8iFmqak/909J/gLs3uehqeySLRqC8=;
 b=eGLCEznKTUFAmS5B8qjvw8gQHgRxG20LRm6wuC2krromrA8yfdrua3Pp5eWHqWSnbbDdIQv4SPtOkV3mWDfTo5F3i22HafGGx5GKP3WFry+omk8XQIG1cshPzxy2IR23CLU/B3ztilq+Q5WbT9bawzJcCWUMLwCvg0UQpl8Q6Ko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4773.namprd13.prod.outlook.com (2603:10b6:303:fb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 18:35:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 18:35:21 +0000
Date:   Sun, 29 Jan 2023 19:35:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: Fix a typo ("defualt")
Message-ID: <Y9a8Y7BZ7wIIZFbm@corigine.com>
References: <20230129154005.1567160-1-j.neuschaefer@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230129154005.1567160-1-j.neuschaefer@gmx.net>
X-ClientProxiedBy: AS4P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4773:EE_
X-MS-Office365-Filtering-Correlation-Id: ef972fc3-979f-4d12-bf75-08db022793e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZURKAu3k0I60NDYZOxdrl23JseJkJfqklaPKeNZqzwPyhMVzq3ER6Nmc9UfgQDaaJLP/2BKs0TLjJVtnEtMdoo6hwW3D7fFKC31hPGAL7CSIL3q//ZzOvKgkg+y2eUyBCA+cxjtmeOBKeNIho8i+sfdKFacOzLVBszjrCEK6zRNNngRv0RSLmDCjToeeuZ+Ky2zZtsUAuiV2XdjUTRQjvW/m2jrqBACYNQzAVCh+y2Vab8VLcesrvs5vcXG27UTYLsNq9I1Kv2/aMAHTMWTcT1BSTME+/8quVmXFGKD3BMsRX9xjiUxk904H0uCAiSpP0l0WgCdTKuj8VowIMYls2UbFkc+pY7aCE2XPydTXz9dsW6R+31fM8+ww2edddPogcJIv7xxs31IVkW2+a8Fjto9X8p0rSOMWkPboFhFSpcGmM0M0YBfrQ4+GKUSRTcmkgzr1nAK0J9ek7mr4ejeLtCfT6AupwT4NlWWTfZKS+9NBiepsJmcmcBPQFxjbeag23r6OvoIKYdYukR1W7dajjFDJSM7stBViDVeoe9xeHMBIw1DUa6C7KEZ8Lp2xbcS5m64oJgYr0QvIY1hsC/jfRNwONguCi1DcawgvO/7a339MQDFcS76V+ukQyde7Fnv1FcVLpqpDYKGreNQk6GORAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(136003)(366004)(376002)(346002)(451199018)(5660300002)(44832011)(8936002)(41300700001)(2906002)(66946007)(4326008)(316002)(8676002)(66556008)(66476007)(6916009)(54906003)(6486002)(478600001)(6512007)(6506007)(6666004)(186003)(66574015)(83380400001)(86362001)(38100700002)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckxKaGNERUtsSVdEZXMzYllBOG0wbHlyQWYrbm1wRWtKbmROWHRyMUpOYW9k?=
 =?utf-8?B?dldqVzlXT2FYdDNPcjZnalVlR2lVWnRnTUhYRGpIT3JvdmxaeFIwOGFwckhX?=
 =?utf-8?B?QnNEQzVZOFZRQTNTZGxya2RaU3B6UmtyV0dabmRJa1htNVJqOGpEd3l6eWZB?=
 =?utf-8?B?THJ3akgzT1Y3Y2ZrZWdSM2Z6dVBhZVlVSTVFOEdkREFJMGdDSFVOS3IzcnRs?=
 =?utf-8?B?Mks2bXU3L2VBZFpOWEVIS2NLQmxUajdCcmhJR0RSSnJwc0g3K1pNTm1KZEQv?=
 =?utf-8?B?cmVMcVQwN2NrNFkrMFlmejd0T2MzZFVSRDJYWDczbWVxNlNpRklSMlYzaWp1?=
 =?utf-8?B?YkFyRmg4Q0tpZW1obnJnSHNOODR4N2Z1aFpTc0lvTkZkcHlTZ25HM084QnVM?=
 =?utf-8?B?Ui9xaWZ5aVcwSUZTNVJLL2tGZ294VStadVV6VWpQMHZDMXBlaVNqazdPU2N1?=
 =?utf-8?B?OStKdzZSeG9taHAwdXBZTzVxM0lRNTZERmFoMnNsMWdmbEVGYi94ZGtBTi9l?=
 =?utf-8?B?M3czUFZlUDZZQWNYVUhpNXJVK2hNVzcvbHFJaThYR3ZKQXNNdGdFYUlXZ1Ux?=
 =?utf-8?B?WkFTVldwUUdzeGtEemE0a2lmYmNQczBxNDhUVWRMWkVQQU1DUHMvOVlOQzd4?=
 =?utf-8?B?UU9EWWVUb1VKcWN2eU9CMTlmbEFEM3B0eGhPdGZuZ2d5VXZzZFBuR2tGWTZO?=
 =?utf-8?B?RUVVK2JHWkFwTGRjWiticXlsd25pQisveW5OU3lBbGdkblBmalJqSkdxdFMw?=
 =?utf-8?B?K2ViZ3VSNmpwNGhwL2RjK05RN0VmbnBZTHRSRWlEbUZva1o4dkhVUjFRTnNR?=
 =?utf-8?B?bUd4dUtLZXU2UzYxbXpTSmdYcWE1eVRVemZuNXBTcUZiTzQvZ25COHpMMDVF?=
 =?utf-8?B?YXVtdTNjVTN5RGJQVWhoK0lDMEprTDNQU1kreDk5R1FuL2UrWGZDRkN4MkZZ?=
 =?utf-8?B?ZnlqUGZWSHhLU1h6NXJLT3FyaWtBYldJYmg1K2VxU1lOeUdKUCtBcUJmN3F5?=
 =?utf-8?B?Q3plMGFvMTF4STJvNXNmRXhMT1hvRHpER1BCeWVXQ3pLeUpOaDE5a1dZcTgr?=
 =?utf-8?B?eVQ5OWRUNzBBdHhVMjVHNzdNK1dQOThBY3dzYjJSb0I2a0tzMVhaU2swa28x?=
 =?utf-8?B?YmN4ZXhRMktScE9PM2R3WElBaVJBNkRWOWZhQnFxTE1RNUFaSnlvMURaaWpp?=
 =?utf-8?B?c2Nxa08zckVmSEV6S0FpS0hZeGZBa3BqRk80QUxVRnFHUElTaVEwMTJBVXVx?=
 =?utf-8?B?dlBSSUhjbHB3c0NCa2xQYTJJRmU0UURKdGVsNWVzRUkzL2ord3NaaWlJZ3hM?=
 =?utf-8?B?TTJzM0RlWWtHT3cyNEVJYkNhZUtqOS9QVUVKclpKZWRGRmFTb25HNWtaVWJS?=
 =?utf-8?B?d3JMT0R5QnZEbldXZGZ4aEZoOUJ3Mjc5blJZYUZsK1lXVFFDSjdENUFPdDZ3?=
 =?utf-8?B?M201NjBIWnVNaWtMRExab1ord1RMQmFzZkFxd1ZlNHBJZ1F4aXVORnd0dUtU?=
 =?utf-8?B?cDBIdkFmRDdKSFZGQjNBcHAvemtTZlFhQTVONVJReHpxQUpSa05pVkZwVE9Q?=
 =?utf-8?B?WHZPU0pSNnc0RCs4bklmdEV5VGptTWhIa21QWDVHdm1OTDZ0YWVCMUFicmdD?=
 =?utf-8?B?Q1F1bDVia2loRmJKaWRwT2dTWVE2eVdzN3UvRnZ5bURmR05HZVdOeWNqdmJS?=
 =?utf-8?B?ZkJuNW95bk5hd1M4V3d2YjI5ZHhaU0ZBdS9aR2lpRSt4NnVoUE8wUkZDa0pm?=
 =?utf-8?B?WFVxb0VobkFzL2VhdnNqZnNjWGxwVnpvNWRZeU5rQlhPQnFDb1FocXc3bGRp?=
 =?utf-8?B?bk5rMVpqY25OWTd0bWlVM1ZZSlFNOEwrTURIdXNIVkJJYllMMzhCWmlJUGFl?=
 =?utf-8?B?YVpGdzdwb0h4RDhiK0tlbS9LcGsyZFE0L29tSml2Q1ljTVZaT0VXZUFPL01n?=
 =?utf-8?B?TC83N21zOXFpZ0d2YW9MaGIxS1U2SjJoSEZwVzZQWFdSR2Q4eVhaRFFnTHQz?=
 =?utf-8?B?SDBuOVV0cVdZbGJBeThQNEl5SXRzQXVUbk5mSkV0L3p1ZjZ6dExqaW5wK1Mw?=
 =?utf-8?B?NnRDZnNoRjR0NmVKZnFuMTJZOUI1N3JCcTY2Yzl0dWZSaVRsYWIwSFQ3aWd6?=
 =?utf-8?B?UnhDMTZKQmNaSHgyMy81Z1ZSR003YzJRaDdDdzdYOXVRcGxVbkVUTXd2d1po?=
 =?utf-8?B?UE15WjNTVGtmQWVrK0w5WTJhaUVsZ2hVRE5zd2lyNXo4NFJCUFl2NURZYmN6?=
 =?utf-8?B?cFhPRlNnZFovL3RQT3RGY3dOK0lnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef972fc3-979f-4d12-bf75-08db022793e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 18:35:21.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5Uh5Qt/mdZIRmgS43FUnXE/LX2SSbud5lm9kg2w4eIs+CJF8noQu+mDMTRWUznmzilQ1mlaXVdQxaDj8hgLSYNCYI+gOIAtuetJNJ5skg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4773
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 04:40:05PM +0100, Jonathan Neuschäfer wrote:
> Spell it as "default".
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Looks good :)

There also seems to be a misspelling of heartbeat (as hearbeat) on line 277.
Perhaps it would be good to fix that at the same time?

> ---
>  drivers/net/ethernet/dec/tulip/tulip.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/tulip.h b/drivers/net/ethernet/dec/tulip/tulip.h
> index 0ed598dc7569c..0aed3a1d8fe4b 100644
> --- a/drivers/net/ethernet/dec/tulip/tulip.h
> +++ b/drivers/net/ethernet/dec/tulip/tulip.h
> @@ -250,7 +250,7 @@ enum t21143_csr6_bits {
>  	csr6_ttm = (1<<22),  /* Transmit Threshold Mode, set for 10baseT, 0 for 100BaseTX */
>  	csr6_sf = (1<<21),   /* Store and forward. If set ignores TR bits */
>  	csr6_hbd = (1<<19),  /* Heart beat disable. Disables SQE function in 10baseT */
> -	csr6_ps = (1<<18),   /* Port Select. 0 (defualt) = 10baseT, 1 = 100baseTX: can't be set */
> +	csr6_ps = (1<<18),   /* Port Select. 0 (default) = 10baseT, 1 = 100baseTX: can't be set */
>  	csr6_ca = (1<<17),   /* Collision Offset Enable. If set uses special algorithm in low collision situations */
>  	csr6_trh = (1<<15),  /* Transmit Threshold high bit */
>  	csr6_trl = (1<<14),  /* Transmit Threshold low bit */
> --
> 2.39.0
> 
