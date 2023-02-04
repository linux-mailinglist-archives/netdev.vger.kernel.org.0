Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9394D68AB89
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjBDRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjBDRMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE2631E35;
        Sat,  4 Feb 2023 09:12:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2XbbIIemIDXY1tzDQsMSsVJdSZjxB8bOZI2+9si3erFY6sET/hxiBrgfXM39X2b/R9AIwCAIN4iKCivkaxSZghT3NgrIP9vZ41f+rNL2/cocTrohwEA9ih03GKMJN1TaL4lJ/vTRude7YMxDtONPPCRveF0Es6mnjqSEvxeyrU/0yxdd0DPvQJmKkJVa/GEsQg2ug06M+qNZCwA1wvqXK9xkYWeFM5UC6qfMksYubOPf7ReUjs6gpIjlHfIQPG1btk+UbGyMupeM28bbTYMTAcCnrigSW3f9NPQpoCFzivMsTTAuUufXLrBFZbXoow4JEaLxnUxFzlJpcMRnSOD3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h7q1Ll0Vud3fmNaj+l8wQSaKoYmIij/z+vZI1M+Y+So=;
 b=MOQI+Z7g9f9NYhFuuCVTChXGu6Sofr3DaJv4yAtywBSLrxDrpLZfyRAtXeyzZ31j/x1ID6lw0OG3rKWoZscPdYussddKAB3MB9ZAFRBprjDYl1K+U0msrtb9D1P7Y55mK41u1YBlaO2h51p9/TFqpJwkuG+S/j+dPltHuuiUP0O0glvEMDiYQnMve34l3t5Eu6HCoD6pNW3AwlUqRR8EH7ThAUuCwqygDRl8TRIFYysc83LMsDf5VsQsPVuZjC+zhN5sT8LqOME3RHNJ+huXi5HSddYTY8WGQnU+Im5SfR5P+xCX/T2g6leE6XIOTBYmeSEp1SdHmrPmgoec02KUYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7q1Ll0Vud3fmNaj+l8wQSaKoYmIij/z+vZI1M+Y+So=;
 b=qhQcliDL4/RNYXVo8MCDUyK25jRiNROksPk5VMSSi7lCsRt4y4vnBARbeCuNKVvJnlYkEYaSYG3MknBnLJz5oUKRZQrEShL0gaeqZcS7TDT3lFgolFOSdhi8sgUK3wUIxXf41JEcXGZyP5ka5svoX391lw/M/NHtCTFxoIPD2bo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4604.namprd13.prod.outlook.com (2603:10b6:610:d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 17:12:32 +0000
Date:   Sat, 4 Feb 2023 18:12:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: lan966x: Add support for TC flower filter
 statistics
Message-ID: <Y96R+oEaZijtdaFH@corigine.com>
References: <20230203135349.547933-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203135349.547933-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: AM0PR03CA0007.eurprd03.prod.outlook.com
 (2603:10a6:208:14::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4604:EE_
X-MS-Office365-Filtering-Correlation-Id: ef9c8ec3-5123-45b3-c218-08db06d300d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbpkgUpHUia7ssZGPWVTGCT1uFBbyif3mn4nglND+KXjnTzUxioqARu0BnltgwgEpG/uaJsWZEjoUAKPjvwwDAkOkZBLZtpnT32lxBe9+2Aeo6iTot703kTziZyRh1KyQfVTJjHgi5pV3PrayOOybkTJ8Ktk5wBRQyz2aqowu00h//7df6weWcNBEdkq1s1GQWRAf/gry0zmB3SULtWvOySAxIRu33WR+1dt8rSwLqZmODFgh+hASxXeyh9LYPil+E3YJvQ+9igSohZ2SahI9acAuPywPykUnKXmTV/iPX2KfJBLXtib8ENC+P+SGETwy5thtIwU/ir5q+cWMm/tffrR3F3akUWlY90bYIFpc6tc/hlizmVQcuH4yilDnHwykZfb+VfAujaW2uxo+Q+4zUuBMWBe+rlBdR/sHuDIuTj8p2lf29d0rXwj/7QGUYi67m/+qo8anOPuqq3KwRtmtSyOD7IknN9q1pm86jBl+dbcLIVlgxXQvHiP4OuoN3wtNtRHJdhOIe/NZoQIXNUSs5UlyIthYmeMePxC3c3BSG1QF00efilvPiY+khrE6MECw4jJuikXKRWvuHuicYd+srqoO697RcHpoQbOknBxL1sDUDUDJBqq7+1fAM88Rk3LfG3xs3S8S0ub8UkkJL8zKMDzqxgsXKQulb6Ccq5gtflJSVIWGPB8JiK2mrx5/eoY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(346002)(136003)(39840400004)(451199018)(2906002)(44832011)(5660300002)(8936002)(36756003)(66946007)(41300700001)(4326008)(6916009)(8676002)(66476007)(86362001)(316002)(6486002)(478600001)(6666004)(6506007)(186003)(38100700002)(6512007)(2616005)(83380400001)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7nE/VaPSLE8L/mAHXMg/OVhvYEKGle1PxIDqgLtQBi5rfOGfK2OsCyjs9Xwq?=
 =?us-ascii?Q?CwpITpRPVW5vonJxQApUgmY3OcTGDpBNRvJUrD4q4nP+ekGWmwhMvsEiRfsa?=
 =?us-ascii?Q?KaqkpxNp/g2myq7kSE/6K21dV0UsD4x3FF5fXsupZGxu1k6P4MmBHLUj+GBg?=
 =?us-ascii?Q?AePpqniAgdhSQN9xSyvrcoIHMRXl3PZNJjqy/ycNNP83zLDL/egRaIol8hmc?=
 =?us-ascii?Q?lQluv4YjulcZlT+8/tAgEP15D8ntR2MqWSdT7SW+mMUakDEoIYdyXkReSNdm?=
 =?us-ascii?Q?aY5KM3I5A0BaFrSXvSx7l1H/HacIc8BhGHangfYQh1sxYQPixinjlMCtH4D0?=
 =?us-ascii?Q?L/GtsAgucn6lU7hNHnFztwjFwI/1R0K7UOzY0cAKveR7OjrqE3ADaAnPX9vM?=
 =?us-ascii?Q?MCJmWMlW2VIA4u0BPjN9Di+EdZ+05jjqbTNz/KpdLytLeRFgQkBVEBVQS1Ht?=
 =?us-ascii?Q?MvG7+PLMUPUvBRJ/xVbTks8tcqfyPvryGXYgz8DPaMpAgK4LrfAB828861x2?=
 =?us-ascii?Q?b7FQy20GvJPBTPG/eKjm3qGs0IswsKznXo0dwSTIg8qSqOQJvS/B4MEWGUDr?=
 =?us-ascii?Q?X0EpNjNGL6GQki+fkt5mlbSx4b1lG3Yj/ByIzBVEqqEra1RxKL6+BQ5N5tVk?=
 =?us-ascii?Q?S0IWELQN043e60RIZxelGmalrc4AdQqemYRsAMftq+r07fbgUUTzvAPbzDY6?=
 =?us-ascii?Q?alvU4AwxQveuPzdPy2yDEhZVFp0opeLhuXkw/PKPgUx1OItQhPm+jOmrR7Jc?=
 =?us-ascii?Q?Vz/KoIOscw4K84GbAi9j4RJ/pSYdBd+cIad8Lnyfe0YGCNJvKjJuNYNw14hD?=
 =?us-ascii?Q?EwfTtXlxU8M01nbEZ6CfhxE2wB2wEo/IQNm+Wu3dziYQbMsB7gQ2wZohelPp?=
 =?us-ascii?Q?l3U6mcNp0D8jxChJAwfoxh5yEWSAYwkWa0P6EII7CGc+aNiXHq/EcT4DkjHO?=
 =?us-ascii?Q?RDsriyuzEWgf+//uFSJVqV07FtiMIspjY3G767UcFVq303jkQamtbfAmvl4h?=
 =?us-ascii?Q?28XOLvCXzSotPWiwdSAX3GZJIPxMbMOQ5n9VD8l8RahmF1HnSCUMaFNMx4Dp?=
 =?us-ascii?Q?PFmM3FtK+pgRipk5ViK8zd8Kqn249CvQgI5eAMBWvqYGAS2dHn2FIw3uq4fU?=
 =?us-ascii?Q?0XFJo0b4EY2FXrKo8VXMnxi5E7Axfnn0x6oKyDGKh4q/OhEUs0plO0lsD6q4?=
 =?us-ascii?Q?LfQ/+ZEtnMpsrSflFx2BHV9Q5d50sIjhcgtLXm2mY0zo4rsFV2+QosgMGI0w?=
 =?us-ascii?Q?zwlKL13BKief55HyGnQNvD3MFhhviscPjp4RpsCvdY+Q6F5AqI3zcAEW77ed?=
 =?us-ascii?Q?z/g4xpotVK0cHyjS3eLj8ilhqsRfwr2hPBiHqXFbTGvHVYOqkbRYKj+jiDZF?=
 =?us-ascii?Q?PfEHj9P+x7U7lJb0sY3nWY81MgUGkkYxQeeUD3bCFcPBmdwjPa/ber663oF8?=
 =?us-ascii?Q?g5eKgZl/O0zjHak7RrdqOip26f/Y4lZFNDIjBxvJJazD8jx4mw3ZKJSCZqYn?=
 =?us-ascii?Q?Wb2DEbHKUUIt3ow5TFUxCU0xbDz/sK3Ems8cNijcAsy8I7pZil/pBtdh5UKZ?=
 =?us-ascii?Q?c79eaFARRuIy8KLotPtO25NzKX/ZiB37W28/zwU4EvPGfJuIdHS4ZSmjSf/4?=
 =?us-ascii?Q?wtLuIgcOAqtaFVv0dVkVlrAev+PiZPxTpUqCu8e7T0Oz6+RGKX6xNdG5yMEh?=
 =?us-ascii?Q?5gxy+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9c8ec3-5123-45b3-c218-08db06d300d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:32.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgKeqsILhPyDgUYe1GNGy62O+V68MGm4RwpnIE+Ybvj9CaUb8YxTUdICqD0WhCCmeK/ntURKKG7Jck0aD4kvEK8zbiv4UnZvysih9WZOtho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4604
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 02:53:49PM +0100, Horatiu Vultur wrote:
> Add flower filter packet statistics. This will just read the TCAM
> counter of the rule, which mention how many packages were hit by this
> rule.

I am curious to know how HW stats only updating the packet count
interacts with SW stats also incrementing other values, such as the byte
count.

> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../microchip/lan966x/lan966x_tc_flower.c     | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> index 88c655d6318fa..aac3d7c87f1d5 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> @@ -234,6 +234,26 @@ static int lan966x_tc_flower_del(struct lan966x_port *port,
>  	return err;
>  }
>  
> +static int lan966x_tc_flower_stats(struct lan966x_port *port,
> +				   struct flow_cls_offload *f,
> +				   struct vcap_admin *admin)
> +{
> +	struct vcap_counter count;
> +	int err;
> +
> +	memset(&count, 0, sizeof(count));

nit: As was pointed out to me recently it's simpler to declare
     count as follows and skip the memset entirely.
     No need to respin for this!

     struct vcap_counter count = {};

> +
> +	err = vcap_get_rule_count_by_cookie(port->lan966x->vcap_ctrl,
> +					    &count, f->cookie);
> +	if (err)
> +		return err;
> +
> +	flow_stats_update(&f->stats, 0x0, count.value, 0, 0,
> +			  FLOW_ACTION_HW_STATS_IMMEDIATE);
> +
> +	return err;
> +}
> +
>  int lan966x_tc_flower(struct lan966x_port *port,
>  		      struct flow_cls_offload *f,
>  		      bool ingress)
> @@ -252,6 +272,8 @@ int lan966x_tc_flower(struct lan966x_port *port,
>  		return lan966x_tc_flower_add(port, f, admin, ingress);
>  	case FLOW_CLS_DESTROY:
>  		return lan966x_tc_flower_del(port, f, admin);
> +	case FLOW_CLS_STATS:
> +		return lan966x_tc_flower_stats(port, f, admin);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 

Also, not strictly related, but could you consider, as a favour to
reviewers, fixing the driver so that the following doesn't fail:

$ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
  DESCEND objtool
  CALL    scripts/checksyscalls.sh
  CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
In file included from drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c:3:
drivers/net/ethernet/microchip/lan966x/lan966x_main.h:18:10: fatal error: vcap_api.h: No such file or directory
   18 | #include <vcap_api.h>
      |          ^~~~~~~~~~~~
compilation terminated.
