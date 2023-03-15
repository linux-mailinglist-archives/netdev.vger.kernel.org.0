Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12016BB911
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjCOQHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCOQHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:07:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9505B19C57;
        Wed, 15 Mar 2023 09:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAAz5HE4+BNy/IKCLEjmb7UyhkyvpGU92DGIximJwsT5sOKTvP0lE6Irm00ACnxtWIQUDtHxlqxj2Bd+y7LZmD5EdtczRAA8Z4BjLN1Sui2b4KWxluX+KoZ1Ho4AckXT35iL3ClRYVdqy46y9NekTM/fKtioZJfbRkjOG22aE2eeRz0XY6ffw/mk1gE1x2EHHGeLOzofvwmxcc0CyUAMnMT0Ni9ikdYVAKtL/jaJhTeyOg8B3JQG08gdKw1KvJJDxXP+MYKhfOx0zAtyJRaIxqKa3yVmKMKWigMTZgtFMagRVajjQNswXGKLVbvWPAGEf6uLqKCqKQcBtPJwjpENbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lI6GiX+7bEITUcY7J0CwXYWd5bq9uoCRQ8uKBukM384=;
 b=SV/+/WXPimasEuGnCvG3Hpu1fWVPmQ5/qHXbbwdSlSBqTT5+tr1caaIP3DlWQhblVv2iO0opS5qdeJoxpzxZHC96kXQb3W0jM04Wlrh0wiqQ/CPm8DyxMUptbAvkCNCRQLNf8qjOu1W2U0SG8zHlRaZQbC/soT5qraAXzpqusTm6VRyRZu0qQkDez2kXtKNG1ACHnhGlNNmW8DGojSjRpiX0JL/ygRYmGjQMmrSXsH0zRY7NpDd9NouIkhApvsJXTkmtvmuSUMxVg0d6Sx/CqesJ0Bj3jxkBFikTWTR91QAGpoHFO7FKY2qSR74yDebwiAY5yPQi8XDqDHQy8orgaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lI6GiX+7bEITUcY7J0CwXYWd5bq9uoCRQ8uKBukM384=;
 b=lEVZ8bjD3Y9WpG7LOtQtdaTF3kbRlKCiKwkDp94wEJUKJNIO2B1xVJfg4R451lUAbfx13fc8lm/sgCe4s2CeQSFg0yFKQekRyxW048PDol3W97taXozVOXpr44609ZBr6oI8fGlgR1CSZTBCUOL3mm154oPYjLn9w5RwXA0r4jY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4484.namprd13.prod.outlook.com (2603:10b6:208:1cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 15:59:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:59:43 +0000
Date:   Wed, 15 Mar 2023 16:59:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/9] net: sunhme: Alphabetize includes
Message-ID: <ZBHrao2ooO2J8zX2@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-5-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-5-seanga2@gmail.com>
X-ClientProxiedBy: AS4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4484:EE_
X-MS-Office365-Filtering-Correlation-Id: df18539f-5c28-4ef1-08cf-08db256e4ad9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1ZWQGQNVCDAKcPzmf4+kIrL/4QrVzJgyipER4M3OW9wM44ogvsQsGWV5dCtvRlIYhb9EILRRNbh0+0otZepMQsYb507VX6EREB1Uz/GyiQavQhDrcIxeSX09p1mPFSV+f41hlMRht4QgnYi9SYKIDq5snMMOq/V8ZGBTgKKgV4JYTRi+Xrh0xiWGRm53cdjpVtC7eUWagkNf4nsvr12J7Eo2Tm1EVg7g2m8GgFzEi3QiHZPbiWibrrMZFAZt9Bn3zgf8P094GLZJXIkJOmWAgcylOeEYIVIrBDf8lw7fCJu7Gx3LO+WxQp09Wg5aMuGtiMJpq586Gs0V0bjWKaBudUJOTbZShGDuH3FAeBOMfpkmlahuOk7eXi16WQGPcMYjtGoM9mLe3zFJzDYAbrj69Xy1hhbEiOLPdraUp22AZy9BUcXZ6yvVsqV28A8QoNCHievSFYKGtWTAWr1D95VBDM24zgrVJhEv/Pk0uEGLuB93wTzcEjhRXd7gFnMTAKAbsSUCHAUV0bX/IzYK3vHkCUMjwyFZTu4INBdDtQVrLFtSwPDK+A/ldPOeLJyUgJgeACOlLQIIcD8lXtFSMFmEwGvnPAmQgQAxROTCRR/jUcITi3tlXP5ZTXuaIiNdpHMVP/lKtPEm7kM/oo74t284qrTXeoZyQb1RaOZXBjveV60PuKE/ZID6Bmfna2Z9oO0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(376002)(39830400003)(136003)(451199018)(8936002)(44832011)(5660300002)(41300700001)(6916009)(4326008)(558084003)(86362001)(36756003)(38100700002)(2906002)(2616005)(8676002)(6506007)(6512007)(478600001)(186003)(6486002)(6666004)(66556008)(66476007)(54906003)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y4eAEIZ21y/4JFNxYi9l5RTRaJHZr5FuOF6cKJYE8UhxpP1p5q1TAqOil/WS?=
 =?us-ascii?Q?+6VMutSvfpsTElJI/VUdpX61f5TzxT8eCqUJvXDD6nyxN8ktXuHTun/b2Sv8?=
 =?us-ascii?Q?Lk4oo3ba2BttJa8EJ1fbqciQ5IXRYwpz+5B2f1fSo1cAaPe60ja4wPKdqsjm?=
 =?us-ascii?Q?LOR0O/iuL3MyyGUM8nSXYXKMOr622rtI25snvbwAJOGrGi4kNrtT4A9X7Sko?=
 =?us-ascii?Q?F5v7L5rWdrDLMMmSMH5CDoJPjD0glfYWfcxT82QHH5vq96NJg1cnKQWn1JOI?=
 =?us-ascii?Q?kL0aSj2OrKueGa/NcQc0rcYuSUsHYWi5cOkawazG703gTPU+0Pb4agEMIgjY?=
 =?us-ascii?Q?crwNjNrUv8eHSYEm82/LsYI2fXPN+bIrWdWNcd8y+GAukMNH3G+fduqGIV1M?=
 =?us-ascii?Q?ZdAS1JwkplLDgZwcd1B+rqfYMfSAaSbK6cZibNu74ovH/uYuCe36qMQHEdss?=
 =?us-ascii?Q?CY2u6dmeypRKTOrelZnGQQCpv8dl1DiMs6KWPrO+dQH6PZfKMEa3kL4F9okC?=
 =?us-ascii?Q?uAFNX8M07cSev5rMzxktEmEYLA2ZRr4F9N/RcaOkGk7ILxpuOviVYJVITGVF?=
 =?us-ascii?Q?JYJk1E1+3CKbDXqRKbu5rKMLdeRZMfIJoTxjA3eXBXmzl1AGby/inB+VtIyF?=
 =?us-ascii?Q?Q+LSBpuUQwf6ZoAkN+OjRUDrDGURq1WsCxKQEBaEV+53DTtN78xZUYBRKDRj?=
 =?us-ascii?Q?f1IVZPaTKMxu9EjBHco9fIDV3vhmiVS+NYc+EnwRmMGe42JnCjH4mSIlKgOR?=
 =?us-ascii?Q?QQzqEDuabhMJkt0CPs4PBiKkH7SUD/Kk0MTBNnc/fog2v8OHAEWHO2KQ0wah?=
 =?us-ascii?Q?hlkkRlfaLTMl2ZZ9W6hrvNulLvboy7seWlu3ix/1Z5ArXyoT69RXReDmGj4A?=
 =?us-ascii?Q?gePyfEh2Jh1B1ZcB3ioqJMSgRNdQv15OOx9Ww4jl6yXrMkRVbxXjnm9a1bSt?=
 =?us-ascii?Q?6X+rblLiV+q0MWGxQahP5bLWbDFf1bd+KpR4/PJ3Ty6ARc4HjCRliVy5lrav?=
 =?us-ascii?Q?sPGbzXoaJTmAt5v+Kly+AW881D+sW0ePF5arEFfDb5qVI2bPtqQ0HJRMlrNu?=
 =?us-ascii?Q?yrvDmib+ged0GU+xg27S9CWzLnhivoQhlpoA2ZiDp2HbpZ8FnPR9aPDyAb0d?=
 =?us-ascii?Q?z097ZQByByyVmPrm2wvVQ5cEJaL2BBhB6WjV2fY+DYnj8r6/BZO/0cawhsJB?=
 =?us-ascii?Q?FxJfHHhBlGkBDHX7a+bDeChIH125q3pAA5iN59QwhNEd7EjntTjwtHv2tSM6?=
 =?us-ascii?Q?FQWh/Ix+Izfg8QDS4wSAlXZE2Zy2XHrm96wFcxCTr2CfW3vMbmF7QiO22bxn?=
 =?us-ascii?Q?EDZRA2oUcFV+/i3XqrnmIZ6Mt1XUeBa05+iQuieQ8AcIkql46a9H3Ju8lYKU?=
 =?us-ascii?Q?JHcZid7l1SkMV/6+MzuX1OGA4uTTGHMrkAjzfSeuWu3ktx8glR2qOqHswn1W?=
 =?us-ascii?Q?l2sPdTZn6u32s3z4mKG6Kk3S3Cw8KZiuB4goBuFeDYh4Grm5xIzZEJ1eE+YT?=
 =?us-ascii?Q?Ncwr7v8h9L7JmhP73mGwe2ab+fkivHo62XFQpy0ke8N9/UbaUr7PCRpwxY44?=
 =?us-ascii?Q?pYzsKWzuyJpmTYW0R4qJYZXctjdfLr6qzlLNrlbe0/pmZ5rjzRYlarqVkMh/?=
 =?us-ascii?Q?l0gR+amYSSNRAwJvKyGBlHbol+PQXB+lxBTMxGGlUXnZ8LnqKFHrry4dFQyT?=
 =?us-ascii?Q?2+BUXg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df18539f-5c28-4ef1-08cf-08db256e4ad9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:59:43.6830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/UzFEglHVZHeqfnWZejjwqecJ8c3LGHbuHFlTanS6tACY9xRmPzbNTlvthtczq76QyYTQPNG42ZjHn4Ybr9FNeOx7P2a+lA6z281VXuWfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4484
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:08PM -0400, Sean Anderson wrote:
> Alphabetize includes to make it clearer where to add new ones.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

