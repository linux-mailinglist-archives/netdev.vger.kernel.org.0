Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B21B6C581D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCVUuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjCVUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:49:42 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2106.outbound.protection.outlook.com [40.107.95.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864AF52F5C;
        Wed, 22 Mar 2023 13:46:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fT7vRo6mtiSDKcjn1ybzi6iARH8cgTIiL1nCJf4qT4GUuf+B076U4ohjviXlRMNiugTrYXWXRj5/2x12TWj4/vB0A+2PNXm9BwTnpiNGOQTBxDisjquw4UFt0eyz/9q0/fBMtODJWpD/Z0vGUBjh6ZgngvJ3T2OzRhhp1U9MkLNJac9ExuF9b92ZWqFr/7MbZOeJn4LV6VFlbUaCKsjvAIGsJ4DLBOiCuBiy3XmB0YnqWzlGIvB5U8xafKAPIq1j5GaPN/SJkNR8q9yoVw57OkWF7OdofzVVgfOfDdW+ARqq3ro+d5Hey3KXujptydBZBQMPwgK25faOidry49Qzkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsMgamfoEyC0XWkgUEke/qFa5YwyQA4+xJk019e3auo=;
 b=Q23w7rNV3LMblwUyR/glv0HK+0xdlxQFY6JAk6umskcjbkYyNxPxg9DMpeCiCvZs6sGeaWQgTTxgRYX2jxREddv2/4ueAvxd7gjrsHQfI3dR2aQMJ+OxOTBQe8bkRe65Y6o4Bta+h3+8Or36+jdWgyWT5uLC0bkECBAVRkQsuWxoGymu/73ou8zt0e68th1Tj9nogoiBz5uIRds7vS544TZaJD5A9ymY/1upAlx2k+NAPhkXQwWnDjEVo6rgEWfxacDNa1ouJAgTUbqv4L4f9qO/KSICzAkrgEds05GrKMrqB7Q7dz9g1xcww6chkbrcvcYu/sRiLuNmar0jinvsaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsMgamfoEyC0XWkgUEke/qFa5YwyQA4+xJk019e3auo=;
 b=HvoMhLSJQhp3oExO+il80U4UvAedT10WtYA8Ok2rW7Y1FLqVuwYE7QiosdX3GaMAHhBM2YwqUcgv7xv7Lh+htmNSNxnXEGfRFEDc7/VEkEz0YQAJSjc0EovdQ5PN0pZ6h199ygH69Kwh+f08VlkyOAzq+V1JDU8mcu44h/2G5Ko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4706.namprd13.prod.outlook.com (2603:10b6:208:322::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:46:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:46:36 +0000
Date:   Wed, 22 Mar 2023 21:46:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Ashwin Dayanand Kamat <kashwindayan@vmware.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        vsirnapalli@vmware.com, akaher@vmware.com, tkundu@vmware.com,
        keerthanak@vmware.com
Subject: Re: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Message-ID: <ZBtpJO3ycoNHXj0p@corigine.com>
References: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
X-ClientProxiedBy: AS4P190CA0038.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4706:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f22b4e3-7297-40cc-ca8a-08db2b168751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntmTL63VdDGwlvW16aJfqvAwrooKhA1LZzPriTB5emRwKw4poXqRqVG9VxCd98JoGWZOxOJxq0Cs021XtMcYq5X/Kn5AN8gy8c6T/xfkTEkGB5nvhWnfVGQDEHTwBTW8njixLUAWeKXbvqsqnFv8YJrQzopBahCfuD3t8lLMMyBZ7k6CgXxAYjoSXCtU7aE1M8cVcb2uNqLjg8bk4QXiu9V7AMtc09DZ9vmx53EpNvpNnnSNwrepzU2pFn92uq1I8B6ypz6oRV3PrTy5dy3othWLzmR+JDI7z2xcoXIho/nL0+rTGigeNdGnKjsfxwTVgDaXxS+Nqbji1h7+QHnV2LygB012xsyn2+xTFs8DldNQO2dJ/6ju7tU5p7x2SlXaQh97Qixo/4xzl/fwNbLI7MfDI2KMTXa52gklmR5zVda7M0xN31D7Ur8FpXra6zyYUjj+Cl1ZUnxs+xNeRRxUUd7KzvJ3/1b7gtHeqLc9L2rPBWLXYomqYVisUwbAtxRT2fy48strk5IHfIGgvC3F4vnsaOZOpO7y5C0aQrxEYl/ldN+fT6FUP8Ew69kkEO3FU0rd2JpaT+gQjvtXw1Fx6eAJFCayKQItkwS2V75PuRpRlSku8nkOCzIzNa2W7cqXEF+szcu3vwMmykmJdPbNwuNBdWxWBN/Yck7rnosgdQ9qqcwZSDGFLvpCelMhfhYz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39840400004)(366004)(136003)(451199018)(38100700002)(86362001)(2906002)(83380400001)(66946007)(8676002)(54906003)(44832011)(316002)(4326008)(8936002)(41300700001)(36756003)(7416002)(6916009)(66556008)(66476007)(5660300002)(478600001)(6666004)(2616005)(6506007)(186003)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jmHzQii8f5uG7p0xvUnFgQ0gh9XXpCyCwVrs2uW4+hmrhayhNp6WtDRBwBdX?=
 =?us-ascii?Q?ZZOmA2RR4Lir+fc2SEfdSWmzXXqcUFaN2AUgPwQsuuIqoiCwCbSlKh2MF3IE?=
 =?us-ascii?Q?45Kxt8TgfYvR/kpOHbtDcKQcZdDnQJlnyAlgtEkhJ3i4L+R6oj7wz9pldd8L?=
 =?us-ascii?Q?eIg/2RpxoaI8gx8iiGnYZijt1OrVdGZN2OU3jqGbdjK+/6+b3UW8mpqZQzUd?=
 =?us-ascii?Q?GrFJdlf8n+8Qfcau5H63ADBDsK/FyPiM3V6NfP4ArI6IoFgnUxyQs3LkKn7r?=
 =?us-ascii?Q?3SWIyJtjLV19ce3R7zASsblagm3qb4Xn/qnAkD8i3wZJVod8NdulKbwF1Pr9?=
 =?us-ascii?Q?u0NG8jPf3VvRXBO671/P96BdAt/iYTkADl56KhXBbRnuS113reMpgaK+Z/Xa?=
 =?us-ascii?Q?RK4Owbw9IhzPrhu3umntTLbyTcGY6JCSNDTdHPzHHhQ2T3Gac9Lvvad4xe4x?=
 =?us-ascii?Q?9QsMou2t+8h8XteUOpSrqgmUTOgwORAT67xDRTDjDDDjvnsdljbC35phAj93?=
 =?us-ascii?Q?8PmKlgmrPTOkTKAjoJejDcEvZuTchhyWHdvylUWpDZvNIZG5mr6rr0Avyl5i?=
 =?us-ascii?Q?nJFoQpTMt7I/UJ5q4qaIUVpdZ2UKmEfgFFtDn1kCeXPlNigYkaAbYo/CsFIe?=
 =?us-ascii?Q?FXTdmuuvA9yHZFwyvFhUPoQQgavxQAdrBmAUqPfUN4zuhzKdgIi39mu4Td6o?=
 =?us-ascii?Q?oV54aZ5l0wMKEZ4ifkJgXl/l4QgDDilRJBxZbFWHHPwlsH4K1lAwpML6B3K9?=
 =?us-ascii?Q?FDj38sCKze78Op+xnAOT2E5WXFCR4FiW4wVb0kfC6uxlQ2HQ5IoA3obEPDZY?=
 =?us-ascii?Q?dVTfpfNp0S7oEDlDJZeNSTT2G0cgiXby9W8Dfi1Caf7oPelup30Zdd4nc8j2?=
 =?us-ascii?Q?m5oMVT5VYA/XyDsFTDngnLjX0oTCuOpVw4fqPMu0Q6zC4G+jaFxVP3GAJlHv?=
 =?us-ascii?Q?vYZSY/+Qebtxq5KQ+zx18CwhuT5DpZMh7x5M0IV/7HhFGgToDNWqmmpbJsuO?=
 =?us-ascii?Q?BRNir0sz2qvjSxKUAZh+xr3GVjfjWbVwn7jVK1i6/1JVK7dORD+rsv+EJzJ0?=
 =?us-ascii?Q?vJBEcF793i1Q33Y6ssp4rxnSDVHweNBvNspHw0nTZYH15/R8GHzjn8OHfRw6?=
 =?us-ascii?Q?5FluTpvQAc04FAi+JYKx+2Rs0UpjII30l2IdBANNTLGm8GDsZ1ASdBP2CjRQ?=
 =?us-ascii?Q?8nzbtPxJCzsAWEDt0gyf9L0qvsOjx0OkQgaZCWI+XGCp14yTJgsOHCHpJvAQ?=
 =?us-ascii?Q?iLNbPtJXwP59W4TpLcDO7z9uZxV4ggYzQuGIjJIIzROK/aFEU+aroQPaj7dp?=
 =?us-ascii?Q?M9A30gSGS4jWJujXQhIwJZbOJc1Xp3m9sqeENHvFtYUvQoLmkybs8aQhZFl7?=
 =?us-ascii?Q?apVKN75XYk54mIMlopj6AAXFFZi/vGQC7mveHsOQcHzvubsKHa47gILxBaJP?=
 =?us-ascii?Q?22NOMitBMzaxE7EArTuMkglvy7MAYmybGYDeeZZOJzIMi12U2KZvl1mgvgXI?=
 =?us-ascii?Q?3mtUlruwc1UcBqaS1G9ddNccjKVpa3dp210B1xWD24NCJOalX537WyJvIcn4?=
 =?us-ascii?Q?hCNPP5TOnfmYlBqGpfVtoRDmow9gGOLQFu3vR84t9Pvw/rqaBo1SENQ0YtWE?=
 =?us-ascii?Q?VFz0VmaipKux+/NTAWac0yC4LrrCfQPdqtpoYcxuT4s3/1DhtT1l5vugIany?=
 =?us-ascii?Q?nEkMKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f22b4e3-7297-40cc-ca8a-08db2b168751
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:46:36.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cK+l69GiqqD+yV/Jlm1EWE54OltK7103VBpwc4a79jWOAq5/bMC2cSlFS9dnxynQEzYwm1Fh6EEz+1nWJocszjIljHvU+4BcmWJaTnbVsWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4706
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 07:34:40PM +0530, Ashwin Dayanand Kamat wrote:
> MD5 is not FIPS compliant. But still md5 was used as the default
> algorithm for sctp if fips was enabled.
> Due to this, listen() system call in ltp tests was failing for sctp
> in fips environment, with below error message.
> 
> [ 6397.892677] sctp: failed to load transform for md5: -2
> 
> Fix is to not assign md5 as default algorithm for sctp
> if fips_enabled is true. Instead make sha1 as default algorithm.
> 
> Fixes: ltp testcase failure "cve-2018-5803 sctp_big_chunk"
> Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
> ---
> v2:
> the listener can still fail if fips mode is enabled after
> that the netns is initialized. So taking action in sctp_listen_start()
> and buming a ratelimited notice the selected hmac is changed due to fips.
> ---
>  net/sctp/socket.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index b91616f819de..a1107f42869e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -49,6 +49,7 @@
>  #include <linux/poll.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> +#include <linux/fips.h>
>  #include <linux/file.h>
>  #include <linux/compat.h>
>  #include <linux/rhashtable.h>
> @@ -8496,6 +8497,15 @@ static int sctp_listen_start(struct sock *sk, int backlog)
>  	struct crypto_shash *tfm = NULL;
>  	char alg[32];
>  
> +	if (fips_enabled && !strcmp(sp->sctp_hmac_alg, "md5")) {
> +#if (IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1))

I'm probably misunderstanding things, but would
IS_ENABLED(CONFIG_SCTP_COOKIE_HMAC_SHA1)
be more appropriate here?

> +		sp->sctp_hmac_alg = "sha1";
> +#else
> +		sp->sctp_hmac_alg = NULL;
> +#endif
> +		net_info_ratelimited("changing the hmac algorithm, as md5 is not supported when fips is enabled");
> +	}
> +
>  	/* Allocate HMAC for generating cookie. */
>  	if (!sp->hmac && sp->sctp_hmac_alg) {
>  		sprintf(alg, "hmac(%s)", sp->sctp_hmac_alg);
> -- 
> 2.39.0
> 
