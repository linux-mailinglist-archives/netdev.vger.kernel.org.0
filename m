Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EDE6C5837
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCVU4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjCVU4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:56:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2099.outbound.protection.outlook.com [40.107.244.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F851A97F;
        Wed, 22 Mar 2023 13:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQrNe4kPWj0UqfQm3So523+BgM0bIpldcOcYxWlFRJMh2lNoXgimjPOj9Tsg8EByTlt3Y9J1LHGCDY3oecZHXhILxpVn7rXMBfow75C4DD1l9yQOgu1BFgY6W+BfyPN9D1G4TmHG81fKJBxACjC9MvOh2PJ4Tx7DItb2Ym47YyQaVNrdW8KGWW9Mvnl10KXLpj90eqcF9sDZOyqUOuy7WcQhEGcrpm3GuTzsKC/EGtmp/P5IYFokc3BQfJtaQv6ArKS/yCqVkWNaJAJO3VBGOoGuY8MQFZJhCTY9AEh3yKIpDXaogsRe+oPy4a3832BoSnDTqfuZpRP6iZtEBGAwxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sfParczrYctRoAxJCc8uPC5YrowmsoxBQp0c8TCwwk=;
 b=nYfHJgwuVkIaC4J+qgrGvKlCC/X27QDkolGvjjwUcVTOCXWAA830OXJr5eBebgjERvG7O6+LqiswvC7m+vkaMwHGnH9eHV7lh42CoiXCfIumEbevWzJdZt5yrSA7CP1Hc9f/xpJfz6kOnsEfQ55H21ByD07vZ01x+UkpdDo9fFsSYUj3Wg61loSnpL8YRYXskJAfUkWBmb25ko4NX4IDNiMxdw/VEJXX3kIylYQYrC5LLOkDuUqxZKs6AI0I26S8ejQRC0qDNJ7tUM09fInYwGToYLaaJJjlupGOxPhJqgo48+G2+qSI6qvI6KobOTAmqG09JJ5lRESLtf1BruRokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sfParczrYctRoAxJCc8uPC5YrowmsoxBQp0c8TCwwk=;
 b=qX+hgeXCxE6Zef3V3cjP1aOXa7mktmXepX2omtFreDyQmTzC2W5CmWYsinYXIcVtq+oR5cZUVKwJh2fh9NIvKo8AFSjvLZ9sfds0reasAo3JhCJTgMa3KIUu9GpWAxNXoXexCkH7cV6RZKijPOXAswcmdPy9kpq5aAQJfS0eQ2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3623.namprd13.prod.outlook.com (2603:10b6:610:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:56:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:56:38 +0000
Date:   Wed, 22 Mar 2023 21:56:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: add IPA v5.0 to ipa_version_string()
Message-ID: <ZBtrfLOh3EKBKW+F@corigine.com>
References: <20230322144742.2203947-1-elder@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322144742.2203947-1-elder@linaro.org>
X-ClientProxiedBy: AS4P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3623:EE_
X-MS-Office365-Filtering-Correlation-Id: abf4f003-6195-4ec2-98ca-08db2b17edad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5nz9VmfxxjSBeD8XBfQ3TuOB9frinZkQYupmy07XU1fYSHuKIOEyBVszdOqOLo/SFsknYeZvLyyAY/I2bXKKaibktyQftv/OgtkBAXwkdmi7zaU7VgWEig2Sx8BRaoKlKRyRhr4aAHhbrB4Ncmja4xzimcDffojDYuH50gHMlcyeHwjekENzSxxNdvWJes0vBeHS0ecfRJMeyyUv3h5lmYO+oD5Bb78tRX9xJ8hRgY1Ox51mEDx9ZkTmv6ojHIzFAA05AVobnKc45PNE4ZMpy8uoCfMaVldj9411Twn3lLGmxkAxjaW+mVQWkCtCRQv7qjDmxom8Gq5VbzsWw8gxsqIwLmegWhgSees0f6k/6l6RsQWEav9KVJv0AVqlJPcPGlf0OMgm4b5yNC4Yr4KSHYGSuhcUL7xHRkY5Vw2myaymmbfpFE8fDWW53la9/OH3EkgwSBUAXlqMzeQNo5RzI0qxflty0ZGt1HVQpzq+XFu8PmI6b+ppSYK8dJhSEVWZOL3eTBGUyh4uLFAVuVRJwEf4C6NtWSx8HT+N2LNqUMS3nsDTbSXlNs8dSXgMHfuDc5lYtD2qMNGydVEMleOy90sN5fXh9TlIyL+NuvpSAQeERGsszKyl0pnevVwJDUcJKYFMaDGUgf0jEmSW+CqzcPGYWC4msmyKLulNnRMhaAxkav9QZcmT6LBLMpMCt8a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(376002)(136003)(366004)(451199018)(6506007)(6666004)(6512007)(186003)(2616005)(6486002)(7416002)(86362001)(38100700002)(2906002)(83380400001)(478600001)(41300700001)(44832011)(66946007)(4326008)(8936002)(6916009)(8676002)(316002)(66476007)(36756003)(66556008)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R9dZawu/PKqIpSXn+ghYBYemlLF34EsFyiL3SjrJ7FRZLBHDv4M3uG87hFYN?=
 =?us-ascii?Q?MWV4oWrDaw0ugxXtxjOhty3jfTaiyaqTtBwp+n2VGkFznDOFJyMEYbOiaRhg?=
 =?us-ascii?Q?A8e5GYxGmcwCeaOOq22r/QjEQs2+TczHugDv8sPlW2knR3cO6crmRVMQWpFc?=
 =?us-ascii?Q?d5HElpIJVcaOb0/tWyaDWg+B519mjaHKMDzRB7F2Uf0rIoEM5HznW7yzPRY6?=
 =?us-ascii?Q?uT+EyQ7ywk+lfahNQm+amkeckUFqk5AQDIHYQKYT9feXQKIRIJEpYh2xDc82?=
 =?us-ascii?Q?Vm5hON7/wBuaoEoitIEhGWIZA6iyvxNy+9i30OXMz2WmdHsMBcmaUhsyn3Wd?=
 =?us-ascii?Q?NAiwwrpSsteYfuZRxt1ZmGuHzn3Zp8FwcYQi/TJqFjw17rjyBT8vbcCQ3B2N?=
 =?us-ascii?Q?DoGyzm0smYxDxpWS8+0yTbO04jF2XU9TQIGOY50aCDeQAsCP/03i6vY7Q6Qj?=
 =?us-ascii?Q?Yyi0hwP42I/hCTy+Gb8KeFN/sKunV/D644dZLROK+PxqSgB+KszO4cy1QHo6?=
 =?us-ascii?Q?/nFqfE1I9rTuviM4VDB3DkyBLBwPHkAw54JRJgn4EsKzgoV+XssOmb3BhrWq?=
 =?us-ascii?Q?BYSepNYgWAspwRawWGPmWsGbF6vjU0TXiPh7jU2jq6a6SYp/f6jEEQxJLC7s?=
 =?us-ascii?Q?0voNIjDqvgLXdc4KHzgQoh3bZbSx7vNbhj++2kF5GLSPzgBQkFPHhDdM/n1v?=
 =?us-ascii?Q?4wDRm4MSbz8/V9yx+PwD9T0x5oCjCQEP6utNydb4nrW3yWdqQHS3HJbMXlqj?=
 =?us-ascii?Q?BcWZgEivD5hNtr9KdM3hLJsN79XJssHE3yxA6yqd2t2mMlyBmmlJufStMpXn?=
 =?us-ascii?Q?U4cAXn9gFry4uxJlsliR4Ekob7+O9Mr1bADB6IqRK76Z/cXWVO9u4FYrAXnU?=
 =?us-ascii?Q?+R7Pz+faYYItd59gX09a69spUYMes4pdHaH5UGEXmkh6kQ7j/QTk/o1VINiw?=
 =?us-ascii?Q?XP45e/VLlXDP16rxewr3idLBuio634gMB50ARxo3+z86b3AAqWZQLMBFDpIQ?=
 =?us-ascii?Q?iDlOhbqdtT7byTDcdXjC89bjtyeNsFOSqgSnr0le290EbVoKWl89PzobfzFY?=
 =?us-ascii?Q?XJxXwt5yrqq2ruJTmSzjezHczsdlvsgo9RmFg4g2gov19+UVD7cjTfQtkikF?=
 =?us-ascii?Q?lgtnJN75icOFWBpaHGgESEZKAgzKjD/cmKx7VRPgx21qqoJz3oNYsVsqsG1D?=
 =?us-ascii?Q?JbSmLjtdpBjn4UXLRESOAQYNasBC7RXfxTCFvs/1KJWU/4+01p8CMz9Z4eKE?=
 =?us-ascii?Q?RluvxOuKUmyQXskDtf3n28wN7uVU5acRto/2LqMTmWTHiQTqHH0dYDVd2W7w?=
 =?us-ascii?Q?Dsv3SgscF1aPE3Z3wNuEKvqksfUX4N4SGOf7BzMHKWdhU9Uhu+UlKQcnLceD?=
 =?us-ascii?Q?iGQ540gddD0UYUMyfGM/yDTezLdqJBucVoXSB8oRGuWoTlareLqcfCreV50D?=
 =?us-ascii?Q?CSHPF9r0G+G4+lHWyzicF9Mf15LAdREC4BJ4dIeiUXzNhs4KQ7EE0AhWMJnR?=
 =?us-ascii?Q?ifADqog75fKljeFO5eH7BruxquP4sQvMXGTRDnCVCbb+UXKky40rlS/rRWPg?=
 =?us-ascii?Q?+xONz+Hg3MDkkNYVlL5oUCa+YVlvSGHykuGxA0IwUmFGXODWo8zizf19Xiy9?=
 =?us-ascii?Q?fOcuG28euhgtAAT1A3a558y2F7Ia9f8S06YfECVrh4LjJgZYe26jfWdyVe2m?=
 =?us-ascii?Q?AapmxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf4f003-6195-4ec2-98ca-08db2b17edad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:56:37.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFa1yb58ATk2RkiiRAJsiDbjVkcUzxessd4faGvyyrox2kBF71xqUHWhjP9C8kDEeOY8wA1MNTRcH9jtm0I217xhAtGPMHz6YxjdfGP/1rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3623
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 09:47:42AM -0500, Alex Elder wrote:
> In the IPA device sysfs directory, the "version" file can be read to
> find out what IPA version is implemented.  The content of this file
> is supplied by ipa_version_string(), which needs to be updated to
> properly handle IPA v5.0.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Hi Alex,

this patch looks fine. But I am curious.
Should IPA_VERSION_5_1 and IPA_VERSION_5_5 also be added?

> ---
> This should have been included in the previous series...
> 
>  drivers/net/ipa/ipa_sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
> index 14bd2f9030453..2ff09ce343b73 100644
> --- a/drivers/net/ipa/ipa_sysfs.c
> +++ b/drivers/net/ipa/ipa_sysfs.c
> @@ -36,6 +36,8 @@ static const char *ipa_version_string(struct ipa *ipa)
>  		return "4.9";
>  	case IPA_VERSION_4_11:
>  		return "4.11";
> +	case IPA_VERSION_5_0:
> +		return "5.0";
>  	default:
>  		return "0.0";	/* Won't happen (checked at probe time) */
>  	}
> -- 
> 2.34.1
> 
