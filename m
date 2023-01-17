Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB49966DC01
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbjAQLOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbjAQLNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:13:21 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E43233DE;
        Tue, 17 Jan 2023 03:13:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpzEb6wwHQn+gWzWiKPTsx0RsHpvBbfhbwJVFoqglq/kY1TyH2/p0My7McMzbgGxiwzLSHKLgj3DV5bQ6RGtdE1L/1Z8fVqd9+sGZPda/vmdcm0ycEYFOCfg/iSaxRRmD0fCjUouqVHhsccXRHx91G0+LFon8ZSRUobQwbcundXZIUngqAGxspqfjzgHLKtAeHH8i7K8jIQaGTUp9v3KMiBeMBdYzrBdWsLT7AUfGgRcR8BO8wI3Ue5J73vT8HqpqFkoe2SwBuMfXOKiolUeCrQxWNQAQpGpjy6tq7Cy6ri25uBElYQXTnl76Jv7f7oSVenPCR5cBbFqAFjMnzYT8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NCt8nmZ2bxL7h1gaLOPIAQWaWj+m3ngQwyE+1Pbs+g=;
 b=aRVTajUCAXv2v95bpjltl7+MuxkRl1JJ9C//MBPdE4imSKrdXPBYXtImAsuOyDFxjT3RUzDhUgeYHx6JCBEVyA5RqQYfO9FLkWR3jvAl3MPR1mPGSI0soacuBmb3rxrPALowkgHJ0x2phFD7DFTC4Hqq9tukcufNZzMqZfX5C2Jx46HcHp8bDlApvGzRKCZb3C5VKvf6WMUxtGCwBREVX0qESCoguEwMb38BbeoTA90k3w4+xiu1AP/HQst3Z3z3/zfdZFFbF5c6d3zowdVQ/8vA41wssxuiqWFqq1qNykzy2oIoZNTNZ1Bbam6mDksjO54PEFGGQMdgu1RFIBIXBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NCt8nmZ2bxL7h1gaLOPIAQWaWj+m3ngQwyE+1Pbs+g=;
 b=WJa4M3GLAK1qGYSilyPYZoVIujV7fqP2VqIiGc+phUlyR1B3jcI1xMlHzxtFXH4hb4haWNKgZoV+ksE6DDxJpeMP+YkYxQVeemutV7g996y7fzOCO+XGy8PMxiql7UJlkKZQBGpuU/b6abYeP8MLgUwaVQSznbnITfvVvv8KakY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4632.namprd13.prod.outlook.com (2603:10b6:408:116::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 11:13:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 11:13:15 +0000
Date:   Tue, 17 Jan 2023 12:13:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wataru Gohda <wataru.gohda@cypress.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: brcmfmac: Fix allocation size
Message-ID: <Y8aCwr0BEi6zZEwO@corigine.com>
References: <20230117104508.GB12547@altlinux.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117104508.GB12547@altlinux.org>
X-ClientProxiedBy: AM0PR01CA0075.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4632:EE_
X-MS-Office365-Filtering-Correlation-Id: e34ab34d-7096-4aa7-9bb6-08daf87bd40f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NC8p/eEhFsLDGW8vX80Xxeotv0LyWZk3ZGD4QYhUdIKLdfeb6UwKTrKRX2t6QRTtHLtAWLec6z5eVBLjnsr7NY3Z8/FogGTb18UrD9gViVSZDTBGKL+zld9bfdN61mtUm9IeC6Z/TYELQFk0+lmJt/gFKIXxiC6cksN4Wyeu1P2ZUpguCLvpGFZxOLna3J3Em7M4UnSlzzrp4yXx5wTisc3mLPFqG6ENEmZt+I4Nn0dgrpTDx9KaMXEZijqd3e70SPNPq7u1N6zvbLtohWg7uJwN9uH7sv78RNuath5+xiAcCMwixvwBW7YG77+LiwwndN/gITPwDFRsC6s5tERb5Qld+fszoc+zOGMWcuavtvkS7US3aTtx9uV0k/Wboj2y3faQWVCxwfhXC6KQ6kwRm99AwNvi7Ti9WjqHLeyMVBkrz4R79RqemJaeC5KKK1iXJ6wOjxn7w9cnYLczBmFEygbewLyehZ+MMivHF73OpIGJiYDubFQgkK1aiQQG/cYjAAeaVJ8ogxJ62MrmoRIMQqp4LZ92W/LEX8+61rsAeYtZOAwEudKbgCGbdDRFXqbz1OM7OdboQZGlpoXnHTSPjr8i51be6wUd0DxkAonASKF4cGFYCJbEftxhl5xAFqhZjSQLu10ScdReKPJTKBzSb8mAFinlDvXC3dPDNwvsPfhDZksawZ38PTlUYp/tRJFt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(396003)(39840400004)(451199015)(83380400001)(86362001)(38100700002)(7416002)(8936002)(4326008)(2906002)(5660300002)(8676002)(44832011)(6916009)(66946007)(66476007)(66556008)(41300700001)(2616005)(186003)(6506007)(6512007)(6666004)(316002)(54906003)(478600001)(6486002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ncwLsgLtB5i1oMayd9V3YBqPTaBb2GJ5kzKz2t2T64j4IwmTm6HNd07iGwUq?=
 =?us-ascii?Q?Bmjc6/cgvluCUTQeQwLWtHi+LVEPTIzKZlO7kEjOS78tq0lZXprn8Xp8gpKw?=
 =?us-ascii?Q?Dv3WJOtK+putMyF9KW2E+tT5BYjIw0yuFlPdSlgH1Kr5jTF0ATBXsptHF+my?=
 =?us-ascii?Q?iqZ5IMlxcMZBaQU5SHBsm8UzXM4WAGuSK33MNPvZRgx66Z07AQoaaeAG4pSj?=
 =?us-ascii?Q?DfABfk/iT4vWjvP3CbM3unibGB7yD0wNHOe0jvC9g4fFqgvGMnqYMn2IMWo+?=
 =?us-ascii?Q?+6qsCaeQScYhYZSYtulfICbVE1QAZxPoLPvIt5dhpit+Gv+k8M+wnSPF93rF?=
 =?us-ascii?Q?hEfpyx9I0UiwDAfs1kaDwGEjZq667+lD4ZQs3kTyl4CJaFOYxH589TJjzLiQ?=
 =?us-ascii?Q?1rZkxhrHeRvKITh4AQLFKS5XP4elqcXwUM/QIFWstAaJ0477wwa8Ep9Xhze8?=
 =?us-ascii?Q?qXf08qpl0cRZ31EMd6bTxjSvkoWyNWMjow91fJtJ2QJYB4UaShNbXtmF1rw/?=
 =?us-ascii?Q?727D1AQUtXANttDCjovXJClbFZbS4DlT8Jyer8jJpp0DvCr8SzQ4kr/dy4Em?=
 =?us-ascii?Q?n+ruwoiigDkR5fbAf7IGCdvuk2UJE9oNmRule/fx9792OfeI/kNNRYM+Ny7A?=
 =?us-ascii?Q?QY9j0nzIfqLXc0sqK6V1voMPPCmaq2yBVkh+KjqXDWsRF/o7xqmKXry1ZYbR?=
 =?us-ascii?Q?odlr/z2GASz9qcCRTEmLDcsRHGJcbiXwIqZrltNV1AI4+FvhWWn2Av7sUG7+?=
 =?us-ascii?Q?jQR9jOftw2cuUt+gLAadochx8UcQc2zEnseM2rjEYWd/9ol9pCfY6xfCjnkS?=
 =?us-ascii?Q?G1cCXf8EC51vO6pAFe/IA6dFoHpvvliMAxtiT7zQnFPz4VLb9kWR6bzpzXqo?=
 =?us-ascii?Q?kkwr4pmDlyCGhdnT2l9I5vbI9A7gBQTrdbzXdra1OFI63NNte9UzvusOB/0n?=
 =?us-ascii?Q?fLs+j5Ep0BG2Kr+PXKYmOJuRhNPVtzvayA8R2xz3VkQ4NKKwy8y1uUS1VCAC?=
 =?us-ascii?Q?zKI/1etP73szEeq4WJnVfJ+QBCuDW1FFnR6k8/LuVVU86AF0EbXQBE/uND+l?=
 =?us-ascii?Q?nl+WMmiJmpbAqTprpT/zKaFE5bxlq6KLqtjku5QeuQ49oCnE08kibhTLvYhb?=
 =?us-ascii?Q?hKd8Gy0o2fkkl0orGNXY22cRD62eM7OP8Bp2oQoQ1UovV4AZ9SWH3Uoj1Jsn?=
 =?us-ascii?Q?nqiZQZ58m0JF8IGAwWTHSsJQ4fUOBsZDhvhd+nYxae2nvYu+Twgm83c15JBy?=
 =?us-ascii?Q?yXq+LTXpKMcQLyuAPLGsWrUuk2ipXlh1vJkvLzb/E4b+1HdQ/z+/4+9rA1/n?=
 =?us-ascii?Q?/fZvJ3JBEIt2A07qPt+V7FMfkluGFyJwni21xZNMeO1N6p03LDFweAPTi3oD?=
 =?us-ascii?Q?v6L+bymQKEkME+8vmJyCoys3QVq4kt10r6sWcPr4PTs7hPheLTmcl7h8Gk8u?=
 =?us-ascii?Q?7kODzXI/lb3orSWK9K9w3hQAYswAKTvDpGpLiT66kZgaYDva3FQzAA8nfMxl?=
 =?us-ascii?Q?e0EYmNNGmK6xVNXX2oGcrqXD3tj8XUHI+/IYGeKMzPQkeWVaJTn/CQOk9Aox?=
 =?us-ascii?Q?fzX6XE/AXamzri2inEpv/OeBhrKELZJZVjJ5bljvL18wPIyvj2b0eV1vRbKL?=
 =?us-ascii?Q?VxpUgZm1mhwi7BxYt2kUwYzS28z75LnytxW3PdlpgZ6lQbOyUGPacDa5cS3K?=
 =?us-ascii?Q?ucMBKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34ab34d-7096-4aa7-9bb6-08daf87bd40f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 11:13:15.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chq5BU5CiuUsCywwtMo2HbKNER4W0rrTy2k9eyLb4+nU8ikrGcg1uaQtXs0M7eOQPGb5TjQq4mrRRoLlKsZRfce1h9p4jtOJbV60Cv9mN78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4632
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 01:45:08PM +0300, Alexey V. Vissarionov wrote:
> The "pkt" is a pointer to struct sk_buff, so it's just 4 or 8
> bytes, while the structure itself is much bigger.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: bbd1f932e7c45ef1 ("brcmfmac: cleanup ampdu-rx host reorder code")
> Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> index 36af81975855c525..0d283456da331464 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> @@ -1711,7 +1711,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
>  		buf_size = sizeof(*rfi);
>  		max_idx = reorder_data[BRCMF_RXREORDER_MAXIDX_OFFSET];
>  
> -		buf_size += (max_idx + 1) * sizeof(pkt);
> +		buf_size += (max_idx + 1) * sizeof(struct sk_buff);
>  
>  		/* allocate space for flow reorder info */
>  		brcmf_dbg(INFO, "flow-%d: start, maxidx %d\n",

Hi Alexey,

This is followed by:

		rfi = kzalloc(buf_size, GFP_ATOMIC);
		...
		rfi->pktslots = (struct sk_buff **)(rfi + 1);

The type of rfi is struct brcmf_ampdu_rx_reorder, which looks like this:

struct brcmf_ampdu_rx_reorder {
        struct sk_buff **pktslots;                                       
	...
};

And it looks to me that pkt is used as an array of (struct sk_buff *).

So in all, it seems to me that the current code is correct.

Is there a particular code that leads you to think otherwise?

Kind regards,
Simon


