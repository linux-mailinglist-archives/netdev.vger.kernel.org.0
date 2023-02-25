Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9F26A2AE4
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBYQ4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBYQ4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:56:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2095.outbound.protection.outlook.com [40.107.244.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A179014233;
        Sat, 25 Feb 2023 08:56:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR3rjR29R4PDwNdEr/1cSRVFcs5NI4LQOTRYO9dohLC8qzOTKyh7NvC+LbnM5TkTBgRWNAyFGN59WRFybBkfyKXCOmmbGIVQZmX5eUrQUAEBJYTWtNHVVKNSiykTTKKt5GLvHknULcQUDSSmYTOzrI/JYjJF9PxyPAedEdYJ1Tbff633AAw58FH+VexS+rpNAiib0fw5BfFC8tH3HLYe3v7jvoRvI5nlHh/yAMOMZRanJxZUvXQ1AnIYwWwZCxJ6UHoJCGAwmWeuubXPGwXfbkkErb+E71QjHmihBAAU+nAT2Dp89AXwAGWhtMHL7rTs51DVg7nQceSp59DqDbIHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5TyCbz0+7CRXO8zjN1A5nQO/RPGltupgmAZzMhaSxg=;
 b=l56LeGOgTS21Zko3ruQAGcbXVbSm8SklMD4UAGEjS6xvB9jlBRVZTp4vr1nfaBERyO5LCcwH+CpP3SHK/JybiuCDOvsLd4R3Xp+tMQ9/5uv6wg5LmCkma4K6w1wQX80x1J37ejJV2r4s+wdVHb4SZih5z8wGtg2ZWFoeVFLabtF1UXR9Qe81Y3VNMTqmBaKnFUsrV7Uony/Uru0emfmdRcMKaYoGZyA94gbgo5SaBo3MMVBMlm9MBgIX1za+oqVpLUnqKEfJYwX4gD1zi6d0YQr+tUTUAUO03Lwq+Rt3vLWg7i+ePATTXkX7IO/ai83M2cm+2/fDA7Ga8qjt/1nmuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5TyCbz0+7CRXO8zjN1A5nQO/RPGltupgmAZzMhaSxg=;
 b=YbZcohvidCFO16U1hwlOtu7Ky5iyuoIUsQ/nzVev2w6W001EgTHB311tN6AGFCknL2qek3ax8gPuxHb/ywTdqmbpdDfTroN21rX28SasXBnpNrlWuhpwZS+r9OatRqT9wBMrzhSF6dLh9tHzNo/4YVcT7DZEhe0PiRfF4OIu95k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3892.namprd13.prod.outlook.com (2603:10b6:a03:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:56:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:56:29 +0000
Date:   Sat, 25 Feb 2023 17:56:22 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/7] net: sunhme: Just restart
 autonegotiation if we can't bring the link up
Message-ID: <Y/o9tr8bV/eW4xOI@corigine.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
 <20230222210355.2741485-2-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222210355.2741485-2-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR02CA0102.eurprd02.prod.outlook.com
 (2603:10a6:208:154::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3892:EE_
X-MS-Office365-Filtering-Correlation-Id: a8204d53-35fb-4790-a2d5-08db17513d09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VW1gx1YiPOAViCQdrLJs+sJue6szKbJn7IM89L6iL1mCIBnyrqWSU+ybK8PSqWxCFOTCP16UxKb1mRj+I4nn10dpLYLnD037TfygZppH+t1lw6tSNGUo+OsxBTFvywu61oxwVk4I4YDgoH+dYoQB5Ek/DP2MS3kBDoRKg56xhk5UFyl0Hd1AgScZ8j/vdJpBa80oKU1iErKjjiyoBetd4E1bEFgPv+eCfhBZRd5wx72pBVRlWdV/1sKJOPDkMgHiTAy+wbOjh8314DLheEjedUVUd+hH4MDzXCyRJSLH3S8ZK475F14KxvgqhKkO6H5/KkGr7vSzhrE1rA1yabIakHNZDXcM0xC2pEJnndKyQPp6piMWKnHTV5qmIdgxIeMMr7W3lNgxgGIeb+bchhvcWfAEeVIfEusxEOGInVrSvvJiIoc0iD2yBJ7Itr8f7RjfFVfmqeRzCb7kNNeXQiUb5i/msSc0u/lJahTW5HZUs8D+qQk0+vNo24zJNH85QyYepNJjptDrqkIpRDPQ0d35IpbklQ9ueFs8Jk9ArPGxDjWxRs6yw0Dhm79U0kGnSqFp17xXHKAnH3gnF4JxgKe9XNf6jnMB2+BL7+hG/l3JKSfv//g59Ahw2ii1iTSrSYWo0Kp9M3Q89OtCIQCWjDmQy2r07GO2+5/UjdXquhUAOiQGp2qltXFRJ97AsQNrPcTd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(376002)(396003)(39830400003)(451199018)(2906002)(83380400001)(44832011)(5660300002)(8676002)(54906003)(36756003)(6916009)(4326008)(2616005)(8936002)(66476007)(66556008)(66946007)(186003)(6506007)(86362001)(6512007)(316002)(6486002)(478600001)(41300700001)(6666004)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGuuAKxKWeo9wPis/iPJsC6s5HKJKKB/RLXuqhfvL7YdcW98FGq04vKfHx1n?=
 =?us-ascii?Q?XP9PBj+SaznUgc/GoPi+3cWElYg7g1HY37qZgf5GPah9eGVrJSa93rcZuFQG?=
 =?us-ascii?Q?XzOinAOvSZvw3a7eK3ERMirkQcEtAcN6S5c4aiAqy6GbeLvHWRfGBpy0wh6T?=
 =?us-ascii?Q?afB5fxKyEsyWdtJfUVOswRIROCDT5zdFOZ/Hl9/JycCXGsAhkf9K+t2zRjgi?=
 =?us-ascii?Q?DgVB0p+yNzOBXG5iJfSmx0wL0G6fGeeKe8R6ae8/LHQ3t9qTwa+mNfWugTbO?=
 =?us-ascii?Q?O7DS/hOEhN/UvkJSUuOHxsuBqXOB7RFjpZoFHhYaJpdfxE/D7hmg6PnB2fJL?=
 =?us-ascii?Q?srOe3ocT2icmHuyrFiJVi85ct+8/Yu+uxRacW7HxUpsYfdG/TxKC43QJZ1+e?=
 =?us-ascii?Q?6Q3nvAUYysx1ZhbZvFpxA+NljfvxE5irL8wuAs8fd1y01aFGpSiLX+kBBPel?=
 =?us-ascii?Q?p9CPKanaIOaEAwYc3GfIyZvnaTG3HY508qEjB+3Gf/AXD+FiM2hgELODVq9b?=
 =?us-ascii?Q?lqU0AEG4SvrD5xS3B/etHv8Awcdq66+u91V9kg5TTozCJ6gItYpEnLS2qfoq?=
 =?us-ascii?Q?l84Kyn3qb+ZG5xZtgr5NxSki/JivQaR1WKBKbpL16N4FuaQjE7/gIUp2OD+s?=
 =?us-ascii?Q?bO3SEzBW77cfCTifYC4id8NHKsxik2OF7j4TZP1ntD3AK87LgTxFLg4U0znA?=
 =?us-ascii?Q?WQjpc3mI1gyi4/bnJN3+WH6ds1dxxjG3u8VTxHPguGofsgyNxevyjvDo0QlK?=
 =?us-ascii?Q?10uTR4atUx6MSDkqrLhujK93lVAf7JKHSvx4Jrv0vLRrcJp6YlPBp0fjbyKn?=
 =?us-ascii?Q?Bmm14xBLYAnu+Si422qWJCMALWwjBl9MILjQqcFaEQHroVgyLe2eR6f232H2?=
 =?us-ascii?Q?oq1cPyBB1k6FHgX7vHc3Aco4TaV7Vw6ZTs4tTzyx2zIsjGgP68n9BqW7VUKJ?=
 =?us-ascii?Q?KwSPgcu2dEH0y/XKdgFQ6rv+5prhtPzSTG1+W33dR91XrxTczv0oONu+sdE4?=
 =?us-ascii?Q?jA4tZqTCZr7sPBcck/snmAOgqO0XjK/lzoTa3h145cAec4/+/0ojpEEKYQL5?=
 =?us-ascii?Q?UAfrM0X7bjZRv+2ewI08DBCXjaESozSQi0C7XHd3hCrZ70+8MFRJ2Ov3LiLq?=
 =?us-ascii?Q?HeuAYjgE7mq5vb0sKvLFfOnobgHzZlp9YjASfg89GWefdKqitjGDYtkX7oP0?=
 =?us-ascii?Q?OyYuaS8QVzudoVKsVAMRqs07PiQ8ZyYaYrVzTUFfTlYL1KVNjHtQHID26jT/?=
 =?us-ascii?Q?qwFMFtsWLeROlQlbZ118GxE7VtRL6xGsPSyvbRuUC8Ig2jrNsURc0Fi+Odn5?=
 =?us-ascii?Q?F79jNKJzL4dTMRYMJONjgew8BGlVc4TE6mwHcRowYuor7RzbmI3obPpRKWs6?=
 =?us-ascii?Q?HhP9Xo1RlC4pgM/gm5BsyG59C2RapKGtwVQIbzZZ03DpNXd7Z/qiCL9fdOKW?=
 =?us-ascii?Q?U5NrLTVXpuDkVSXKlqO4bb14UwY5sMe/9G/CV1cUtpiA41XZDPvJHt414zAP?=
 =?us-ascii?Q?8DTCQlROPlDabcmAufPZ4bDzKz+YbfOzWQLPPsnsPZnGiua7oItWH4fFGaBm?=
 =?us-ascii?Q?vsQiCb9siLWw3JBUh6uwCuuDMoh1C/KsG7NE00Z855bwMKeKAXIUYp6weysp?=
 =?us-ascii?Q?uMi7ZRO2AM8Ii5z3U7YNGsjO1wkjw7HK9TkjqOziuJn/WMnwi9ML/9/bvs1x?=
 =?us-ascii?Q?NBXXfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8204d53-35fb-4790-a2d5-08db17513d09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:56:28.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +05yC0o+KvI797JnlU9M0Wcl7puOrv3ycYNLJhuJXhSGEsZmsVLFsBh0EByxC22wN3f7My3uX7srUH5wQjwK2wCeMnjdnTIwD4wjY5OGXRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3892
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:03:49PM -0500, Sean Anderson wrote:
> If we've tried regular autonegotiation and forcing the link mode, just
> restart autonegotiation instead of reinitializing the whole NIC.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
>  drivers/net/ethernet/sun/sunhme.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index dd14114cbcfb..3eeda8f3fa80 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -589,7 +589,10 @@ static int set_happy_link_modes(struct happy_meal *hp, void __iomem *tregs)
>  	return 1;
>  }
>  
> -static int happy_meal_init(struct happy_meal *hp);
> +static void
> +happy_meal_begin_auto_negotiation(struct happy_meal *hp,
> +				  void __iomem *tregs,
> +				  const struct ethtool_link_ksettings *ep);

I think it is preferable, though far more verbose, to move
happy_meal_begin_auto_negotiation() before happy_meal_timer and avoid the
need for a forward declaration. I did try this locally, and it did
compile.

>  static int is_lucent_phy(struct happy_meal *hp)
>  {
> @@ -743,12 +746,7 @@ static void happy_meal_timer(struct timer_list *t)
>  					netdev_notice(hp->dev,
>  						      "Link down, cable problem?\n");
>  
> -					ret = happy_meal_init(hp);
> -					if (ret) {
> -						/* ho hum... */
> -						netdev_err(hp->dev,
> -							   "Error, cannot re-init the Happy Meal.\n");
> -					}
> +					happy_meal_begin_auto_negotiation(hp, tregs, NULL);
>  					goto out;
>  				}
>  				if (!is_lucent_phy(hp)) {
> -- 
> 2.37.1
> 
