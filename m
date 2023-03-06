Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608416AC3F0
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjCFOwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 09:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCFOwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 09:52:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2132.outbound.protection.outlook.com [40.107.237.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1965F2ED7F;
        Mon,  6 Mar 2023 06:51:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J88Nev2SkUgLD+7GP5mYdS/2/ZLkMRTqsmCfMaZ48RJfeuGlhgUxRbsxUg/ERiuGxxT1dgivZP6z9cSmOOSAyMVRyg/CEGEUd2zG1s+ayHl2HQbjKscb5ZKj0yTsXDr5fX+cprdcdLTEmo7Bzsz/xCrg2YFixZyO3IeRlpQQkdxGVguTU9akxWb4Zb36GVm7+vuFtFPHibJtKRzKBFAbu3ARfR4sgpodhNLbmHX0UfQQ7+YWb73Uvy0IDc31eJJ6IpZPulEFuX87OMJkyhviJLygqQomwWsygMshqzSf5FgrJtJpI1yrxwL7uhZwpRq7ynm2W0hIOdV+9LcDvUQCrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jn6wrcAXYpv8ZDRycNqkZ3/grMt3Emgff2ADvQaaxfQ=;
 b=ZlctktvGTq/TQYF5r2PHaWtU0itAW+IU6gTLs3wP794kn3rhUyxfVD4whUbEkvBGkZPx5JffAlR61lFP1BSC1FbVQ8FAjlcN5qHl8Xa1UsuNgQ998LvX9WyFpVy8W+xbircMYPBSIeie52yfgwVOcfegyZhtvKYL3+ISzeGNS4l7POeNRXbfz3ZpvQyumW3vVaFehscLdmf+OIJETTZlLFHyJ7Di6RB7rcCWVAYkerrAyPfscQYwGQYUNqNKCquf4/jujLuGN4XzTiJIwERQTIgXwSfTYE3sXLpmz1hnkB+SNuK6zbs+/D3ILzoIs4LaeQfxs0dps6HA5wdPz3us8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jn6wrcAXYpv8ZDRycNqkZ3/grMt3Emgff2ADvQaaxfQ=;
 b=febUlOMfmzNWD5i5el58uc9AlEaR0Eyq/eZ2qNwNBwneD9YbdO9tBbEjPVm2N0/w/pydP6EA8KhY4aPyXypXk0G6PBbbV1bij1078zHoE73TLDR4E3y8iaFgm+nerFyFq+NjqvkKFlfHpWSWwFkJz8Q40+Z3CeYX6cMEBpfe/+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6140.namprd13.prod.outlook.com (2603:10b6:510:2bc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 14:51:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 14:51:41 +0000
Date:   Mon, 6 Mar 2023 15:51:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v2 net-next] udp: introduce __sk_mem_schedule() usage
Message-ID: <ZAX98D91HvKrJBCO@corigine.com>
References: <20230306115745.87401-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306115745.87401-1-kerneljasonxing@gmail.com>
X-ClientProxiedBy: AM8P189CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6140:EE_
X-MS-Office365-Filtering-Correlation-Id: fd36e6b4-5f0f-49d7-28ae-08db1e524c0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOEGzOhC4Opx1iGchD5ThmAORYvRAjCNU6ckpK+oY/mWUEN1UH71opM2YMG0YClJTx7/oJSF5+PuvrnM66yHnPDK2blAa613cRuUrUUwipMTAUVoOGlt6bGANQntJ95Mx/VBhqN5WRsQeSxCQX7tPmmvH8exfoQ0Oj3spNpq4rRUOUtJDpBTBIjUfDaip82VduyKngQq3qTviLpRZoKQ1NxusADpQW69uuO1mYETg2OWwtTd/6lRQabrYpg2r+5d9UtabX38ZqVMo6J0p1Q87U2ZegTxXsvVg3KsMKTUtpAQRlraJNRuR7J/b3GjVAeg8wEXLJ59DdAfGzpXgbLEnrFI2lXhlgaT5e4YxY8EbTp+YR8+4wIMmVnTXpOdls6tU0akqW50qOmY2TC3T1jdqwdldHslEhigocCC5T1ohIxaCia3xGa1bb05QpJEPmE7cHrCagDg7qhyZ81Lu2dlVCAMxDcNEc15BcIDc6ZfdLnQj5EsbLrI9NQ5Q9mew5lVe3fi4AHB4FWALdgXWtwXx/8ZwM9ywTAp4SwNFj5LtkVSbwOBDOKdldCxmZcuIEjkDuICNRuwJVAOfH8dl29ETHz8oNeK/uo0yr90wsrgfnLEn/wW9sMUK0ZAxKKZQ6CuoNDVwf0Fwq9FZflx0+r9Q22nfXojSLKiRR+lqJ0z1plvLPUH3fBUuD/ty2nEHzQy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199018)(6506007)(6512007)(6486002)(966005)(6666004)(36756003)(83380400001)(86362001)(38100700002)(186003)(2616005)(41300700001)(66946007)(66556008)(66476007)(8676002)(4326008)(6916009)(2906002)(8936002)(44832011)(5660300002)(7416002)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dYwfMedUrknaE2btRhKvADiRFzeoTrMWDLuePRCGDscjSW11ZKETHb3yMzdd?=
 =?us-ascii?Q?gcOxu/94TEFXuZ0aABmcXVJo952sqizqsPn+J5rXp87WorXo9BKxb42k6SyV?=
 =?us-ascii?Q?jgj00Y2PVeC2VpeUl8hb3tN81StFAjq8nDroH7j826Unk1iYffWDdaAW9OKV?=
 =?us-ascii?Q?MpxA9eg6dYaymzHPBlj9rduFSTzc0oLsbSZo3yxxq7y9ng0W4xeiS6U6S53a?=
 =?us-ascii?Q?X0WEed1dMN+OEHTE7MEFdF3OKEYdQBE0fXaLbh8Ca1Dd9i7ujQKYxxaYP3CZ?=
 =?us-ascii?Q?XYdpZEjO++wkuywZ37k6dNF0mMrUe4Qly6J9RL0mzMeDfceknp+Xd60q5BR9?=
 =?us-ascii?Q?L+ugz+72nLtQkHGWWHxGOdMPSxJtI6NZlamqFY4M4H7o6CXzHGNlk3JSRAyO?=
 =?us-ascii?Q?TF0QUDY9Hy8XRRckOO3mYzKf7DVaL877EY4nfyd7Z/L49s72G07xC/bcdsQt?=
 =?us-ascii?Q?A47224hZfstAqZHM30slyS3aBbVGElEELEv/d/FOZWbNEVgOba5WLrIgULvZ?=
 =?us-ascii?Q?3TXFR/cC9khGjpuDz+IqUSI2eKN3sk51aW+zUkkp3PTvJnubKlhCOdFSLjht?=
 =?us-ascii?Q?ORF7xaoXNO1jKmG6KgJmmJt5oQRl8Blsj7FKIsXA2HGVmQcNwPW6F+RqbEtI?=
 =?us-ascii?Q?fRYuXfullN21Gwr/MJVM6XvqtkWy8aFSdeBrJCuIAHoydigvquFRVOEOuWmN?=
 =?us-ascii?Q?qmk7OjAAXM53ppKy0pOkDbe7HXCu1b8fvVu4Hn/XcHL64ATayy2benJmEKCj?=
 =?us-ascii?Q?N8DM9q4U0ABPM/Vz9KkalFtWAZjtIHOiAlM4fkJFaIyarcQtg+7K9wkfRhri?=
 =?us-ascii?Q?QjDXNAy3X5LI6S+jH3DCebDvCesIz94U2T1dsT68x0QbmPPE30MYesz7/9LU?=
 =?us-ascii?Q?xcd8DSpzd0s52406Avb7Yg3pHsDSKhuKMq83MLcHfRrknYionOYguiRg3j6T?=
 =?us-ascii?Q?r5vcDAg8k0J/6jXN2bKLMcPIW/ZeN+gy7KDwjXB6UmTrtI1QRwr32MYvFhdN?=
 =?us-ascii?Q?ehMzZiSEk3hqqz8CkAvBUjGR6ZRH08YRfS5Xxd6wgCyrv4FcKOF/+sWO+grk?=
 =?us-ascii?Q?ScH6EQQRL+xkFrHa+OfLBPOA9XJ8iS47613RJ19vRJdLORNCLEGJ9QbKlifg?=
 =?us-ascii?Q?NHRaE9QZDX6ySeL+mKwUXkBCdobpm82z31P6yyuTmOXAgG5GK4MjqpjyFHBx?=
 =?us-ascii?Q?8CJ/KdOX5U1DEfGlNvdk+H+acJ4zPF5Q1THXOSIhc4gfpywVrSCGyrXEpZhU?=
 =?us-ascii?Q?pLXj2VVsWQfU3X+L07AivmyzEXjcOIW1dkmfJZeugOZdiEAEVYVXZ8Bx+vL0?=
 =?us-ascii?Q?H6EaH7/Rnifx3znpJKLyBsO157/qVmM4ur+R0PEqUpmCa7UcVdNXsJH3DtPE?=
 =?us-ascii?Q?2a+XxphLOrsr6zobmq2Xc+OndNZR3Mb08Cjrt4+pSLUB4uOjQkkZdVdPPNzQ?=
 =?us-ascii?Q?daff/5tS1g+3+0pOAsmRlqshFdfX1Th6Saj0C8xwqU58ONbTzfLKP0gq2dW+?=
 =?us-ascii?Q?wDQdwbQjRAOkRrctYy5ZDj31Oj6fHxmjSeAIdlm9L7yFarl1lDFNXRjpMtk9?=
 =?us-ascii?Q?uxRkI7vIbz7Xzp65Djxi+OTpDEiahfyT667/trbaCSumlW6kdYbJ69HU38eU?=
 =?us-ascii?Q?y2HR4WdlDxVhdU5LvfzSZO0lWmS5Yi9bhRBy7/TmXmSWBfiCG2dIAIJn7whr?=
 =?us-ascii?Q?w5g1Dg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd36e6b4-5f0f-49d7-28ae-08db1e524c0d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 14:51:41.7326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Urr+5FV5NJXHBi6Fca9yUWLv0jsYtewhwgz6KEmbzeY+9/W4F2q8lmrHMumC4cAV0pU+VpHVrijenruSK3/6AzGWq6y3zPO2Dp9c+haInI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6140
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 07:57:45PM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Keep the accounting schema consistent across different protocols
> with __sk_mem_schedule(). Besides, it adjusts a little bit on how
> to calculate forward allocated memory compared to before. After
> applied this patch, we could avoid receive path scheduling extra
> amount of memory.
> 
> Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxing@gmail.com/
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> V2:
> 1) change the title and body message
> 2) use __sk_mem_schedule() instead suggested by Paolo Abeni
> ---
>  net/ipv4/udp.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 9592fe3e444a..21c99087110d 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1531,10 +1531,23 @@ static void busylock_release(spinlock_t *busy)
>  		spin_unlock(busy);
>  }
>  
> +static inline int udp_rmem_schedule(struct sock *sk, int size)

nit: I think it's best to drop the inline keyword and
     let the compiler figure that out.
