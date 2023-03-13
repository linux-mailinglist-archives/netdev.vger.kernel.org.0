Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23E6B8149
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCMS7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCMS7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:59:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2106.outbound.protection.outlook.com [40.107.220.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2051E9F2;
        Mon, 13 Mar 2023 11:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoN533+V4wOv0p9N4BfS88q4xmJLGTU6PlDNbAA2Dk9maxQMfevzsgv3JuOJkdLy5OelHiF+HcevsNSGidq9TgrA9GHcQQYJsv9l35TGn5r99yR4Dpn3irZZt4cG2Dm3Jme+ZwyswUSe7KZYwQZSrOMRN9xw4qVEd//RC5B567AfZFfxAyIoBMus+IYk2f7rSlD3vclEGUvBM89G8XidEeDJoXqxekJpD0v/PUJobt0QBqvsvi3TLDCggV1MvsXKLXD516lk65EhC24boZkpJYJyAsBpyOikAmZIk0YJglkrCtxOJsTyEyBlSoKsbR9jAW6YboSSFAAPdHCRPkHc2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HKfgrOOam8tiQOfuFWHT+uFz8vyXhtvkD6FoMGFE+I=;
 b=Qy2gWrbBH7Xnoo+EYbsCzDwiW/iRuwgCWs6PtSKYAUqQYgCUwcyJE52DTFirGdBdL0evTlPj1cnMJvmkEXcD/M27eiU8Zr1Cgm8orHDzQIfIl93w67EhZEvPmOL414Tmb+W/HUnaZyldVxMeLINgIFWWZJaqHBlKj50fYC5hPSBaNRkLNTwphBi/IiXJF3/tjcjJm80DGp+00yFIYZKN4ZTxxH9jzhBTwnPliR4uihorvFQbPBy3U07/YmjHJ4jM770ro0OlriCcUq9AISgXfuTQVKEgJkP2+/+QiTzzXBo7/dNXIX/1CxXsw9DC7CtOdAIlV/+8pI4VBzaBtUeiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HKfgrOOam8tiQOfuFWHT+uFz8vyXhtvkD6FoMGFE+I=;
 b=ggdZN16GKCq//bbYXEK0DvBW5u1wSj0+NqDmOEVoYXLE4OHXFue2DkxnFCNWgDkdwgcw7UtrKVf5PCW+KEhJk/mXWQFTv90WEiTG3+TZsswHieyhIB9TEB/zm7vW+DF781JHdUAwmSchdKpVZR0LtHs+ebVuQWEEvQinDqELx4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4936.namprd13.prod.outlook.com (2603:10b6:303:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 18:59:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 18:59:34 +0000
Date:   Mon, 13 Mar 2023 19:59:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Danila Chernetsov <listdansp@mail.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: dsa: vsc73xxx: Fix uninitalized 'val' in
 vsc73xx_adjust_link
Message-ID: <ZA9yj1FT7eLOCU34@corigine.com>
References: <20230312155008.7830-1-listdansp@mail.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312155008.7830-1-listdansp@mail.ru>
X-ClientProxiedBy: AM4PR0501CA0061.eurprd05.prod.outlook.com
 (2603:10a6:200:68::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: b70e7677-14d7-4651-fd5c-08db23f5157d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqNJvSS4J7XHcOgkGlBvF7fLzbg/HA8El70absW3ohFk7rs4qxh3/XqD09xqEsCWD18HM4AfX7iT2Q8ZbjQfI5r3ryJwWyIFBng4IPxNB4Ybsj70aYg8FJS6UNQEfqFT9CE9S/UphdJSgBSz63A/XvdtVR+fkYLRQfM6vLKDGKk7TnaZfsuVVBqA0Hv0poa46R72BVkdtntp8rR7oqEmZ4x/QgB1VcHQ8ydAny1Z47QL9zJKNL2LIeuVQx7zGpaiRrm2ZJcl5XEXKg3xcCbrO9Vo2/9J/5rp1al4h5FlkkomyV14VZ9VVox/FwfiBJoJyVxHjyFIeMivdUo5H8euzifzitkERPfATd2Y0AAtDlxSWhiCZaLd0mP5J4EBrCv+VpunJhNpoCMhukovfWLhxeAygVIWIErqlykbMLv8YDlO5LC7GMNFosYOAqPh1MAJpoh7a18UeGDnrvytekhSo++FM9vrAZlFJ3oj5ZdPb3e80KfkdKE+JWD7pcClhp+iz7iQ3txxYMtErsl7tw8Le7owfP194RVarS/8IhUJ7ghYqonMWg/1LC6qTSeEHDUWqE02QH2awIM0M24+f710RciEk5WK0aCgWSPeBweZzA7RldpktS4RcbWNT5mTvGRm/g6mhkjz7i4heBJDgLFq+GIChYIOD/heofcob8BzUA/keI84MbNYmSdLkPoRIjmN1KGZiRttXcZl+5EEn+vI4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(346002)(376002)(366004)(396003)(451199018)(36756003)(86362001)(38100700002)(8936002)(66476007)(66556008)(8676002)(6916009)(66946007)(4326008)(41300700001)(478600001)(54906003)(316002)(44832011)(7416002)(5660300002)(2906002)(2616005)(6486002)(83380400001)(6666004)(6506007)(186003)(6512007)(241875001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5fXVRR7K1h9aAEqpFoMeG4nms2xUb5ZYLkHAKVDswATLaaL3mIWmOUZDlq7Q?=
 =?us-ascii?Q?t1Fw12Ap8Xukr0X8KSpBjA2eO9j3VOa706RclCk9129pRpV2cp7TkIZsb4CI?=
 =?us-ascii?Q?fm5l08AFv5T8RlaLeGdd5Vlw8vrn+BM4U4rarH3E1OTf/kkxolu0ZfHxm1pM?=
 =?us-ascii?Q?pG9YOPpG/Tch0mgB1rps43/fIZn+7bbqMIfyztlXvodCIv8pxFak08QoCmLY?=
 =?us-ascii?Q?smc0F2EQTcOeAfku2q5sEiB+ps97pKaXRV1MoZIeZkYN0Ad2ncnnaCqKJ2SS?=
 =?us-ascii?Q?h0rHjVzlj2SqmXQTLauHgXahEvdy5InLjW7VaRhy5Mu5sjdWceHEbsJyQF8X?=
 =?us-ascii?Q?l1XtFhEInAl72eMCJ+r0StQTgCMyHH3E+5s9FUGRRWJ++QRpQeAy9gBoVIJX?=
 =?us-ascii?Q?31tUaDy5llndRc5XFYdZ6T7XZie1T/kqnzJZn3cZogwBZQhVOPbMIphDTR4g?=
 =?us-ascii?Q?02O71K0IoLv5hbBp4W0auwt7ebfbaDhsjNdr205hNiXHxIbK1mgAt502pqVG?=
 =?us-ascii?Q?jdhNaPhIAUlXnLrNX3kxxJYsiVZm5QMwpZh4S3r7KezsHtHxl/qy3RWNx3bB?=
 =?us-ascii?Q?O9v4al0yy6U5Hk6H5RxMKCUbRHRRFHXw012vEP0ORzUFnVOUEyo90GO90CxB?=
 =?us-ascii?Q?khUrTPTjzeZPCBR7em6lLiaOp9pV0MGe6G7miwtmZ6dMWMLLRi54lhHpDDza?=
 =?us-ascii?Q?OY32tjbBxLIK3sr4LzavfjZYwCRAnVev2Xvs1T/8pAcB74Tv37V4cwVMJfis?=
 =?us-ascii?Q?6K9jg2svxx4A6je7y1KRHOEZta6yWs94l/a8XLH2MxX/N+rJlId4WIuu3ZT2?=
 =?us-ascii?Q?yqQTcd6bmrqoiMkplIiu/3swNeiDZwkqh4hSW9cl5KGWV7P3TnVbsYvw6dPn?=
 =?us-ascii?Q?/YrJyR7jAlqmko6NEs0/IB72F1W0stCSLFwAZPtTs1fxU4vv8aYXNKATQIf2?=
 =?us-ascii?Q?2ppLHGtJCiNe7nHpKliJAFE1tRhsSQhk934Y8EQSrE531mNeJEaewiK/EhAv?=
 =?us-ascii?Q?pECKf8YYuU8JyzdT0zgZcpvU0hDsmRedkmtUL+0JVahtse8S3ThfYkq22Lne?=
 =?us-ascii?Q?wB3y2bXiDiEfu/2H8z2B01ruiR2vZhii11fGCsO9rkNB/UQK9o1hJS7esyhF?=
 =?us-ascii?Q?U+L2Qa/9KXSDiqUWFYXl/Mj9C1cltJDUIwPoAT10CxoKosZJATLkZc6ZNfgE?=
 =?us-ascii?Q?r2R+qcKLBnPQGguIFtC0q3T3efzpaANCu+s3wcGCud5B5SE1hzNjWkI+Hkfw?=
 =?us-ascii?Q?ohtrUd9KNf5xYwQN+s3qeiZVReNHqgST9+ph3zb/o+fiKiLITFhC55CSZrnR?=
 =?us-ascii?Q?ww70DaYDRGWZYHDWAgPBun8BacQVWopmPVbvcbkn7PEAqrc1P6oV0GZu8Bk1?=
 =?us-ascii?Q?IZS8yyQAlTOZP4ebXaPfQZ+W4jL4W4T/Pz+w22OPjkcd3nzXUHF+ywPpcrh0?=
 =?us-ascii?Q?587TMWLIKKY4lQ8WresHbK3+1+MzjUk8JujjRdxpkjaCFUhSBmxqvTalkhIJ?=
 =?us-ascii?Q?lgN4ewJ/KpvLRJfdbcHnNTK9LGzt6gn2t5DFHdY3JemgD5+nDVFkqHb38PEi?=
 =?us-ascii?Q?rAyCqONFdJggXaViGEeLZW6eJKxnJUL8NbjucRrVxLqLsS+emzens/rrZjzt?=
 =?us-ascii?Q?51STIFKyUOksao9fqguS35e6BNHtT20wyJl6BVQi0NSH02SFRpyZbyDTxl9L?=
 =?us-ascii?Q?Bwi+Hg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70e7677-14d7-4651-fd5c-08db23f5157d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 18:59:33.9938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSOLQDGmO59vtQOKo/SUu1Dgz4CWcuGUbhxbxX7WgJ6p2L+LJlkZYg+Z+O71xnmDf81WG9jfKjsUxH0e5PHuidC9wyU0LMv9reYRc7BLM84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4936
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 03:50:08PM +0000, Danila Chernetsov wrote:
> Using uninitialized variable after calls vsc73xx_read 
> without error checking may cause incorrect driver behavior.

I wonder if it is:
a) intentional that these calls are not checked for errors
b) errors can occur in these call paths

> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 95711cd5f0b4 ("net: dsa: vsc73xx: Split vsc73xx driver")
> Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
> ---
>  drivers/net/dsa/vitesse-vsc73xx-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
> index ae55167ce0a6..729005d6cb7e 100644
> --- a/drivers/net/dsa/vitesse-vsc73xx-core.c
> +++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
> @@ -758,7 +758,7 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
>  				struct phy_device *phydev)
>  {
>  	struct vsc73xx *vsc = ds->priv;
> -	u32 val;
> +	u32 val = 0;
>  
>  	/* Special handling of the CPU-facing port */
>  	if (port == CPU_PORT) {
> -- 
> 2.25.1
> 
