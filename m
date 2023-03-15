Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0206BBCBF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjCOSyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjCOSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:54:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2104.outbound.protection.outlook.com [40.107.96.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EB585B29
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:54:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SztMpJIN/OewkxCxWU6ui/91PizychoYLjzV47P6vFmwddg2ixvFboxRyFW3EClolkInp9Bd6XLx6OyBCndrB3a9WVf17uSmZxsx6xRONC0w+xs2ZPUm7feXutxgUOumTKymanzN3K28VzHgMxUJ2c1kokBy37DQhx/enhZnZV4uroQUmyrj8r7UUv5FF9XfRo+oDOFnCDoDUJIYaJGL4uxwIILRLjbuMiaufY7n+90/jAYB/Ea+zrGCtrAIfEFT1jlUVTkbH/grxbwTauI83pD9mfx1j+bbvZueBW2kYz6dho54cUfp7A7hRHQXlk0mTs6XtnNL4NLXnHcbaKkUcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UNoVI7CntlqFejiHKW4+GL4q0YyPlmi/6DKOZtCN3U=;
 b=ecLObTs1NKpueNWek3105D7rqtPqCeVO0EwERb8Lxiau/Ao41N6ZiNHwhGiSbAtb2AY3t68Lwi9RpNhCqrwQFcWcj05GCcTiFjzOHEDNbX6BnVyWeirDCfS3+zVMyX4TUh1KoU7STgR/dAlfGiiMgYDfNlsvYrZciW3jz2z5f9XoFPeSrAMacf/x2SEISuh4z97mRl3uevvugpKI2XixQdCkN9XI47Qv/dP35ZdkaMqnyAbkGPB2/D+nCjHdJNh04KXFrS5Nd9blRdjWQj7uafDwxclTtaYctZoWt864QFuyDZgFP7gn5PzopsDpnsNGw1V+ZxAQw4Os2xAU2jiTqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UNoVI7CntlqFejiHKW4+GL4q0YyPlmi/6DKOZtCN3U=;
 b=afs6CYCBLcVWF+53dd6GVuPI6uyxdKtO3ElVT3Y7NQFLA6KT2ZHuLxAQMM+kl9Y2j6ZQxO2Rj5qH26W3z1N/g7ITQzdEd0qBwMIRrj0HgYLeJxZ7igxKXaHvivf+BUVO7eXC6AnTjsnAe1iG6VZcoS1JZFVlQmXjhp0Sc4AEH4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5584.namprd13.prod.outlook.com (2603:10b6:303:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:54:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:54:10 +0000
Date:   Wed, 15 Mar 2023 19:54:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 6/8] ipv6: raw: constify raw_v6_match() socket
 argument
Message-ID: <ZBIUTJdXs1e1v4fz@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-7-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-7-edumazet@google.com>
X-ClientProxiedBy: AM4PR0101CA0051.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: 727b244d-9e7c-4de8-1774-08db2586a957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wbd8mcXeuzf8vyormdHhPTxqIdIa4COr2LGedtNCKXsor/NXIyP+nPYRl091UDtGIkOREhS/kmAhrs7huoftOX9pQ/9l0yOiwiotjXZkVP+nyZY1xPZG/rXteY3to/zOwwh0XChsAFIyCXihccftAnqyDxBemxxau9WkZZnSl4J/smOAiPP6LBb36pJIiRn+O7OjGbMjRt5+MhmMAVjORLrso/MkEja6QUJp9aWARZpW7lNOlZufEnP/kSTCFusIiKWWRqUZkzELxTmL7apN1CBnLw8Ot4/dAwTxv6B3u77N9J2OLDQYkDkD0Qw7SfnWdd4YqYaM9s3qyPSz8u4TmJY9TkYY9cJrZgIuDwioAMjTysk8aNW3sWmWLTOECkxiD2CX0/gl0PBC8LuqJ/kqe0Dq7ULEImM95q5GGF5h+qnJHVdaPsjW7m3e6p/s33FNCN9NeEwBwjFBqc0nQyQypoTyHtSYybZfks4kDsTWTzrDS9dEJj5Ez/9gQL1YHm3Re7qgz4KR+PVhtVlIgmyZ/eGYkzSzd0hDedW0pWCWK3mRzT3Xt1GqNB6BxmodvxiocbyGGassGSD4Vc2bYcoyzlYxcvpoGq8dNr8iAKiXtzzpuBcYTYa/VxsCu6Rdf3dDktNMLJvjClHg+moNrVjhbdlN3HM7p2l4axK+c+Yn6xRIIY0DINsyiSde4r768w2j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199018)(36756003)(86362001)(558084003)(38100700002)(41300700001)(8936002)(2906002)(5660300002)(4326008)(2616005)(6512007)(6506007)(186003)(316002)(54906003)(66476007)(8676002)(6486002)(66946007)(6666004)(6916009)(44832011)(478600001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GP7QqP+KmHPgQ2/yEl/QPT3PIBMJ4ftoAAhC5xfQDZ9TG6TIKiY98ss1KmKu?=
 =?us-ascii?Q?XtHKe/90edZszPGCICqFT7q2n6oRQayVpp5yo2y44sSoaKF9fvWxu/RSWrsv?=
 =?us-ascii?Q?z0okl1Dt+Un1Ayj/iUUaa+khP3l3IqC7g0APsy9Nh1IJfEXwBNwWouQWqjAX?=
 =?us-ascii?Q?Lryj/HZr7w2ulbqi6K1qxokC5N/bi75KtM1Sl4uPtOlz6YH1d06xu+fe7DiV?=
 =?us-ascii?Q?0fjbc6+hvWtEz/w9fPuTl7VoCLIhHbv6Lguo6vXliN+VAp/PG1Sa9y50Bjje?=
 =?us-ascii?Q?JniLtxasNI9dKW8Yw8OBR2dmxRKxySATiXZMv77wq6N2Qj+SVuFFDzy3M/Tb?=
 =?us-ascii?Q?0xR8I7gw70Z+TMAkvvzb5B49+iUM8+8YT48HIusYoj2ss4cnrEIjP6xCLpK3?=
 =?us-ascii?Q?AtZ84tmVbHYGhOYbGaoXsR8rRjhwRQI/7W+Wp9PC4wK5SVzbDqveIYN2UXU/?=
 =?us-ascii?Q?jAyavu4rKljPTUGwk2nXqJpat5tjC07JwH36QeUFL2QvPXf3vJEhgntqpEO6?=
 =?us-ascii?Q?Pdhwjcu7YtSbDc9k6TCLwZwVF+EvrqxpmXykY79oBOTb5TE1hkrjjC+Z16C5?=
 =?us-ascii?Q?ErYTWSQje6BMj0FrwCIMpkx77WUc18hdYhIk7DNTRZRBh9Q3NXkFogxm9A2t?=
 =?us-ascii?Q?1XFoStCyJYX7jDY8h/e53JH3wrAJ19/VKNFdTODsm5MxLTy1MjiMpu/KG+G/?=
 =?us-ascii?Q?MPwIGksTM70fSgEcVQRG1XCMDvcucagcNxlD0sfp+eBkkl+1lyKOi3XL5v93?=
 =?us-ascii?Q?BL5XuihGX1+YwCYe+1+jFleQuDqP1+Pvi8Pr2cz93xROMlFeXnU3UVpPHh5y?=
 =?us-ascii?Q?cFt+LNM617VEJDWNIrgpOYRVdHkjLXxyhD3ASuqzV28LdG49bSWX7ySjtiVd?=
 =?us-ascii?Q?lj4ZtQsbvJfMrJNmYzw8VENR4WdNcvpZIK1gmvgMQWOe4wtTh2C1H4N63xcE?=
 =?us-ascii?Q?m9c/ubTjGG9ph9iMlzkg1ysApj3n/BGynoTKLZyCBSmOrvE+Y76Vom8BQ24R?=
 =?us-ascii?Q?J0j/4iySHuQrkbRLN+Sjxk7mCqGeKp3rm9XDD/c7SlhPXaR/1aSXgepL3Wig?=
 =?us-ascii?Q?wts2xwyVhNbKGdinotdjAvqj1LDpOk7bj0bd6a2A+1RrFOqZUtwQDXPIbVpy?=
 =?us-ascii?Q?nm1lOaH501Sn6ZyX/czfPPp8n9As4rAhES2j01ovS9LX/ToCzHi2a1aiZSSv?=
 =?us-ascii?Q?SnXtNVc/YmfwEzc5Fi7Q0dXGpW1JzHQowBxCG6LZDsrh8owtRrABaVSNSlgw?=
 =?us-ascii?Q?lGnM+YROAI+iy8HFgLVp4nuLVBKOQOUKXWWFc3TiHVx6xd97/4RpygU47NZg?=
 =?us-ascii?Q?5fUvt8ZFPe+vDYVGDlyb0hDRtsheoxx9JoDOhU3VqLqGPlBsczg9J6vQ60qt?=
 =?us-ascii?Q?+STwr9UmCx5kyhB+t25pxHJqs7xPTxzgGm6BqyJquzgP5G+ivCy3psj8+M2X?=
 =?us-ascii?Q?ZkEQ4joLCud2L3pUJXIDnhqTGSPoRQGTyP+GCPop5/gr6RNIz3Sb+rb3Bi8k?=
 =?us-ascii?Q?OxQe/Lg/BQbtj7SP6vF1jPemEEY86FMniBaKzk14GQSzgfgn4AVRfqP+tax+?=
 =?us-ascii?Q?dRZNLAmSN25ybwCpkUxKEJNrupxRTh2+2AIjOksHAWsxgH1XNcXjBoMT/rV+?=
 =?us-ascii?Q?2Td4Mmcu0KkZoUEa7Dxrw3ZsAB4JmKouIQuy2NSD4MtYyRy13E7YeBLlZ8q0?=
 =?us-ascii?Q?Hoq6rg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727b244d-9e7c-4de8-1774-08db2586a957
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:54:10.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVhE5eHP+RnE9Ul//HoSjcOK75KQZsN37eo7Bn83EVy9HLpuJ/RogdCSL3e9PG6QDagnc9AkK6YEG2V/lufBX2JqxgCUlPW7fOe9rMB11bY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5584
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:43PM +0000, Eric Dumazet wrote:
> This clarifies raw_v6_match() intent.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

