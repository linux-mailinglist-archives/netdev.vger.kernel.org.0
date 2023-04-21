Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7661E6EB0F8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbjDURoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbjDURnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:43:35 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2096.outbound.protection.outlook.com [40.107.212.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14631FD0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmTi8cNUwIBINKkGm3CUSBShirNkrd9ot2f3jp/sKNSf7NU1uEzjQevZMNfVrMZ/suxgGjwCGMcTAOCAEsNkz/WqxhXaELm9pEBfIjtTdV/UGBMQjMgyawphN7P5sPljyfJVC155yz88Szrk8nnoL2KYMvBehYWsGTQUFlEL4JtZ9BpfZnwxNehSkrxGllKYVsSdfjnWWDX4iZOmA3vFRjAuG/pcZbK7gGzV189fi89fNPfNx7RV8VUhQ1Rzh2IPRi7avyivlVQORFzU/PYPNJaDiyoi1cyrv/s3t8qPlZXjeN7g1lg+V7syPIJSaAQvf7G4O5EESsqA5wePpyH6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOxE/CVamOrWwqPWzaE0RLPUiZii4xsDgJXN0KEFTXQ=;
 b=buMMB2WU59GJUxrCNJbJeaG5ltMHc236BGX6kJTPVkI5+lRZljSLpOfoTuNVSgc9qOR6r+KEGyNVBwTgXBO8acIlkdPDOu1C8jCZmDkm4/xLPFdyykT/e+tX9lzOI839ZRCHFUGh1cMdvskab9clewogFhCs+pGUmrmAg5L9Cde0BIHsORaEEhtkSlZwXbnm9v6YQTz5rNuy6eDizwBdzJTGHTp35MjGnQWB3ZhrxdU1Gzep086cg1BeDB00RxZNOn+CG2wT6448Ki7xXB2Co97fRGkFRvy/9mxrvUxetUWOl3TKyWciU1+jj+NKyAghhwIjViwyew3NzCYBih4eSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOxE/CVamOrWwqPWzaE0RLPUiZii4xsDgJXN0KEFTXQ=;
 b=C6ZW1+NEzu/v+vJS3fBzgyKCf0uUeBA35+YJLL/4tb2qsW1JBjSUKpi4tjg2tx1miHbG/mX74fbEPq242+jQuDp+sUYLBX9r0fYiqqB5uBatHxeM5gqUGSfdyqofZWs7+M109usyypoJ/+jfB7dfGGyJiHXkk2cGMfoKUZTXRu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6068.namprd13.prod.outlook.com (2603:10b6:806:352::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 17:43:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 17:43:17 +0000
Date:   Fri, 21 Apr 2023 19:43:10 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, daire.mcnamara@microchip.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <ZELLLv/XQI15IOX/@corigine.com>
References: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
 <20230417140041.2254022-2-daire.mcnamara@microchip.com>
 <ZD6pCdvKdGAJsN3x@corigine.com>
 <20230419180222.07d78b8a@kernel.org>
 <20230420-absinthe-broiler-b992997c6cc5@wendy>
 <ZEKYH0FblGmAOkiP@corigine.com>
 <20230421-gentleman-contrite-bad775caf1c9@spud>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421-gentleman-contrite-bad775caf1c9@spud>
X-ClientProxiedBy: AM0PR10CA0051.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: 034fb69d-f591-4a55-8768-08db428fe3bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhQz8+LJUAjlfProH6z1D4XbOSuNRKTqTuJvEyp+pz4JOWiKjI+BvaqbiJx8EOOsntWOz0TUhUZKruwhxaoAHPZt43UTQakm75dTKU0CE06RAEwnShshFIbX0Clyl4AvJr51/2EePSehhcUZJs95xg6bAl8KgvjFGxQa9VrOoxDXXTKdg5JQZrHOuWTwNe2eew6ccqQFlgZqF/HXS+R7sROi9Zgv9smfH0MY5c8dwe5XM30q/J+yFKcx6RWJT2JOjMh6zWM6G3yxapj+aAcwOwNswRzeJMLiXte611rlKhWWMO9xg3xYGOBRll81mrn21jcypnETdi8s+A6Z0SryL7Co+jOpNpHaxGlm/LNnp0e9z5ZnxItHR8K8DZlaF2cCrQvEjTHxWWk+MGz3gTNpjHuxACKTL3pWQHfp/jfCngx0FfBc6LCA1ao49enTup7dDoTiQpCbPO09PNyQNOCNyX1zp/9D5VzPKEISDyfba4VfQB557YHoBnzqrx/l1vBJRd7wbSUv1yY8WA+GemDktp7l3neqdUz5kaKRg9BIi8ErAPfZlPumXR1Z/M8a/UDY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199021)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(86362001)(478600001)(6666004)(6486002)(5660300002)(36756003)(7416002)(2616005)(8936002)(8676002)(44832011)(83380400001)(2906002)(38100700002)(54906003)(41300700001)(186003)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3oY0YrTL4eBKWd2OBDUm+/BpziCQZNeh+JejT0j8zOvcptB+hDTVuj5+rOuE?=
 =?us-ascii?Q?0ZNCpvqAKa9qx8NpaW5+9A62pauMCUEWzPUhv+RWxAQRQBSEPoDIsNwTQDgR?=
 =?us-ascii?Q?5NvFAU+FU4aTKqt7RToObFzQ4O2mp01KId7sHtKOzjk0hj5g5exqtOOJT/Qz?=
 =?us-ascii?Q?oXZecgVAYoHj/ZS7MnbIEw4BK+PJ/UmVyy/FGrtY3FSyzj+w8NtgJ2BEJB4R?=
 =?us-ascii?Q?JTjcsU/Zrbb3Lh5BZUbSplC5yi6BkWaFlP/ec6YdyNpUZ/ODiapbvMtuYly8?=
 =?us-ascii?Q?1XAl/7QHcYOwUhcJ1OPAX4jM4mgDfHYqPdCH/CGXCY5LzdtTrVAlfDafQE9f?=
 =?us-ascii?Q?aFyvJvTFrl8j49MwYeJfed8ZvSU5Vm9xuxVMPqZDXqNb4cOaoAHk60LCEoAj?=
 =?us-ascii?Q?ByHTpPntcnRJaBObtRoZd5FmWfYhbD3tMJ4d6I2tF6AiY2r6wgOEFCrTqzIu?=
 =?us-ascii?Q?38UHEdgc1+TXqemF7hhKtKRfI79tcI+3zz4xx9g5Bc5wFeDu36QmCVnzgYh4?=
 =?us-ascii?Q?xgVf3cWw8sGZ902cFurd+nvnP/CPxC8LB6js94algUDbwoNQGQF88i8soOey?=
 =?us-ascii?Q?jPPe7U2QZI1CW9rcQteXaiONpwHiRU04zQjPfSOQd7qxDKBcosuWpinM1U7k?=
 =?us-ascii?Q?YQr33J7XrwDAyCMPSYIroi2RReC4YjSfOxbG8RIfnI2/JUUFMHXYTj36GlLO?=
 =?us-ascii?Q?VNb9nK/Rdx5xfN8snTGfsR45+Etyw3lEhcSlLYRCH8r8HtU8cgVrJryRD5Hu?=
 =?us-ascii?Q?07CbYVYK0sErV07jhqqQ095/BpUuzkaJqd8DARHyWFAmrGhQBtKxITqN1DsN?=
 =?us-ascii?Q?YCg0fqztXKY7nNxyzoUDq+Uzy0rGJz4E7i0ZjPDS5SvU5I4ZzW3DyMciAMaa?=
 =?us-ascii?Q?5LqbcVkoM0LtNtjmtyW0XqqoC4pQtgwPxDTDGkX7759JglzWe1iPfsPQV0TN?=
 =?us-ascii?Q?/n9FV8/pcvmdUF4NpiwD555FB5Y9DuaYqSle1cGLBROKJxnMqvPicZh2EnCX?=
 =?us-ascii?Q?IoNuRYH0ulDXhxQ8+uUMAyZwSEaxXdCT78m8DZxGc8Ppw4HGLPt27S/UY22N?=
 =?us-ascii?Q?pFRrdxeEa8A+6vx3f3gWjreSQxvusZEGeUNbQu7XuMwA6OAwNjczirQOpT7f?=
 =?us-ascii?Q?N6C31+LOf/44CmuHzIDD8I6i1M55kEUHsmY7tboROf06QIkpH4xM32m7SZAj?=
 =?us-ascii?Q?KZFCUzYYxF4TwXQqdCHo0df8Mv/TRTdz1Qq1m2r6lEOH/yl/IiXrSfuclGzQ?=
 =?us-ascii?Q?DHPDg4C3Y79UkKZVDpVtybqCZCM3IMj7H9szukT8mMRecdfIeOLBF7Tk4Wmf?=
 =?us-ascii?Q?VFzTzsxZ+z0vd25XwF+7maSqwxqvT+9EIncU8qZUDZqq0M4t1FcGW/CJ76as?=
 =?us-ascii?Q?h2kLEkSKNe4bg6UfwXhcVJ0RoaPgzLBSAx5gFZum9YvMczTs68ywQy58Fju+?=
 =?us-ascii?Q?du+ou2gR60kiNBtqPjwthbgj9drX0E6/XMZ36cNTbUyEjDZlpMgc1oJ0xsyi?=
 =?us-ascii?Q?XeOlAXP3hv8ng+hK/o2UtEjJ8AWn0lXdEpgMQKyYjaIAmfAg2OpEwmfhb+s7?=
 =?us-ascii?Q?6/1y1a4PMslr83vsUvFTN+ccohu0yn1WVjJqttznV2+XB6xGPNuHWQU/gMas?=
 =?us-ascii?Q?dAxBVszZlq2+sietTo7EFthK6Bfzt6zZksBQKPNtDyhtQZyi70FUoxm95pur?=
 =?us-ascii?Q?AiuwRw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034fb69d-f591-4a55-8768-08db428fe3bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:43:17.4801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIrW9b8FRTkZvtb0ROq1tEqEPAjEP5Wxx5hfd4H9xtyMktEPLfY3yqUQLntAAo3kGe1J0xx78KxwILLFZxddo33TWEOAVcFnnFG8H6DhTKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6068
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 05:39:52PM +0100, Conor Dooley wrote:
> Hey Simon,
> 
> On Fri, Apr 21, 2023 at 04:05:19PM +0200, Simon Horman wrote:
> > On Thu, Apr 20, 2023 at 08:18:35AM +0100, Conor Dooley wrote:
> > > Jaukb, Simon,
> > > 
> > > On Wed, Apr 19, 2023 at 06:02:22PM -0700, Jakub Kicinski wrote:
> > > > On Tue, 18 Apr 2023 16:28:25 +0200 Simon Horman wrote:
> > > 
> > > [readding the context]
> > > 
> > > > > > static const struct macb_config sama7g5_gem_config = {
> > > > > > @@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_device *pdev)
> > > > > >       bp->tx_clk = tx_clk;
> > > > > >       bp->rx_clk = rx_clk;
> > > > > >       bp->tsu_clk = tsu_clk;
> > > > > > -     if (macb_config)
> > > > > > +     if (macb_config) {
> > > > > > +             if (hw_is_gem(bp->regs, bp->native_io)) {
> > > > > > +                     if (macb_config->max_tx_length)
> > > > > > +                             bp->max_tx_length = macb_config->max_tx_length;
> > > > > > +                     else
> > > > > > +                             bp->max_tx_length = GEM_MAX_TX_LEN;
> > > > > > +             } else {
> > > > > > +                     bp->max_tx_length = MACB_MAX_TX_LEN;
> > > > > > +             }
> > > 
> > > > > no need to refresh the patch on my account.
> > > > > But can the above be simplified as:
> > > > > 
> > > > >                if (macb_is_gem(bp) && hw_is_gem(bp->regs, bp->native_io))
> > > > >                        bp->max_tx_length = macb_config->max_tx_length;
> > > > >                else
> > > > >                        bp->max_tx_length = MACB_MAX_TX_LEN;
> > > > 
> > > > I suspect that DaveM agreed, because patch is set to Changes Requested
> > > > in patchwork :) 
> > > > 
> > > > Daire, please respin with Simon's suggestion.
> > > 
> > > I'm feeling a bit stupid reading this suggestion as I am not sure how it
> > > is supposed to work :(
> 
> > just to clarify, my suggestion was at a slightly higher level regarding
> > the arrangement of logic statements:
> > 
> > 	if (a)
> > 		if (b)
> > 
> > 	vs
> > 
> > 	if (a && b)
> 
> Ah, I do at least feel less stupid now!
> There are 3 possible conditions though, you'd be left with something
> like:
> 	if !hw_is_gem()
> 	else if macb_config->max_tx_length
> 	else
> > 
> > I think your concerns are deeper and, in my reading of them, ought
> > to be addressed.
> > 
> > > Firstly, why macb_is_gem() and hw_is_gem()? They both do the same thing,
> > > except last time around we established that macb_is_gem() cannot return
> > > anything other than false at this point.
> > > What have I missed here?
> > > 
> > > Secondly, is it guaranteed that macb_config::max_tx_length is even
> > > set?
> 
> These two were concerns about your suggestion, so they can now be
> disregarded as you'd not been seriously suggesting that particular
> if (false && hw_is_gem()) test ;)

Yes, that's right. I would not have made the suggestion had I known that :)

> > > Also, another question...
> > > Is it even possible for `if (macb_config)` to be false?
> > > Isn't it either going to be set to &default_gem_config or to
> > > match->data, no? The driver is pretty inconsistent about if it checks
> > > whether macb_config is non-NULL before accessing it, but from reading
> > > .probe, it seems to be like it is always set to something valid at this
> > > point.
> 
> This one though is more of a question for the drivers's maintainers -
> Daire's only gone and copied what's done about 4 lines above the top of
> the diff. Removing useless NULL checks, assuming they are useless, is
> surely out of scope for sorting out this erratum though, no?

FWIIW, I would say that a patch to address an erratum should only
address the erratum.

