Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A6B65EA73
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjAEMLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjAEMLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:11:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2123.outbound.protection.outlook.com [40.107.94.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB38D3F106
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:11:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnp6p5EPQ1wufqC3GSsUa6droGc9T9IoNGB66vzJckjT7SwB0V3ekM7eqJfwzrlPPC8GNmOzSClK92WzNoz/SnJnIsvua3aaQ6lHJkVVS54u2hyn0epqrNwGfVpCvurCGf/PyM4XbDc1INgpBEaPHg/KxY1VyoGP2KgeMN1dHXPp19ioswA3wazFJvButKTYFnc4+vnk/2rVeQt6yUR0CXTwkP6LTzlzZXFarb5oIzD99vzX5ZbOrL4N47rpxmHvqU1kMnv+Bn9lPLfv5+cy/Kzg7aSqdVLqW9caJQujCPi5QWPAEFya1EJbJaBqPTPSZujcR/S92hLlZQVpM2na5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xV/rCu0ObSQH3rEbYREVDk4k34a1713SCCOwQFFjmBg=;
 b=ggfST8NvLQLPfMjRc9aLD2RQW7pEXFkZW6UuZrA3SSU/nue+eZ7fFn9PQIb4tCDY0HskNpGTRj7fTWj2NKMTkgja69eQgeFPRV0vLPdhoRBq+cxXQCY7lNYQN0ZAvDTanx5JgJQna4WWyrMAeEPpgTrMdwzsZ/YaRaB6Yt8TNIKIHSq916ZIcn1Lxu69jSJcyTiFOKUHwJfHV1XGu8MmAvtZJsC4TIEMUSynuDglRle0Xg4usUFCuW4SscUtjzu5VHmtEynORdpZpic9qh4LlINfnj3LmFwFgMEddqCO49xP1OrPgkaAg2cxs78pRaJg3rVT+iVTD2PKrifQYkVZ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xV/rCu0ObSQH3rEbYREVDk4k34a1713SCCOwQFFjmBg=;
 b=A2cCmAMS7JRNyTCNK4z73E0oRHr7sN9VY125x5++3lCyOUnvYL90wEmp+cJvnE51GoGwsDKEfOg/HF6x589e0dtV8oEA59Xddj8VInQAaSotNuGmqh/bnVCQ9sx/a+ZuWLSjtCj2onc6IEXDtdc02fStjv8p5ZrTmw7pRBvwdUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4054.namprd13.prod.outlook.com (2603:10b6:208:265::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 12:11:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 12:11:39 +0000
Date:   Thu, 5 Jan 2023 13:11:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH ethtool-next] Fixing boolean value output for Netlink
 reported values in JSON format
Message-ID: <Y7a+dS2Ga5fdPJ1Y@corigine.com>
References: <20221227173620.6577-1-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227173620.6577-1-glipus@gmail.com>
X-ClientProxiedBy: AM4PR0202CA0019.eurprd02.prod.outlook.com
 (2603:10a6:200:89::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4054:EE_
X-MS-Office365-Filtering-Correlation-Id: 294ccf2a-01fb-45a4-5db1-08daef15ffcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8+bwml4xZNm69bmYtrnltJ7MB/CUsgKO36/iv+/932em0S1JQ7mz9VnAAE1QTDYXv+VkTbxXbCy163CgtlXQRh5H9bgplp2dbYHFHfMCWZrBIGKipy40jfuBQf5l/JCR5uDqG2HrtyBZy3NGJKQQ8Lz9UkqD5akJxTXTMPjRVDnE+EjKpN3+UiHl7/BOF400+sBAOklC2smutTjfiGHEzjcZUF5Rj6L81NljvqCPNpgqTDMKrXV91ruIfeEbIMUCCq4DnPDbeR6/sVh2yhHW/pMEbd7V0H58LufNBQtIQJInqF1RDWmJwHKzm1XUcNQYTc7ga7VSpoyx8WpdijISOBQdy8X7WQWYMjqZreKkQ1gGOqTZ/mVjpB18APc93dQC8h8VKtnj0skI8D0oLgJFdVGSfCcZQQTjsWFjpp0lnz7hs7/PIUGSh8A6pvSf/u/vyys0isDnM7DvI5/uTmK8Vn4p145p3E77dx2o4S05uSiLFeuqxrgg4swrNS+ynA0zaPU1ur2oh9kBV9YehzvcpLL/V2JdZUZZzoHie68AhjDlPVv705VtHHY7T6sE+eT7q6JMEZ19C5MZpWFC2Z9Jo1lh/VcQ2M4sTGHTiLj5es+cFySGRcuP/7LCPSG0JFDxLnszwWCr1MG7Ny8HIC5Wa14fimLAPH5sUDMJ8ARhoMAEgqGIpfUasCVstZpbR7dob5mnpnCmPBSdxfv4VjqjclSb52H6yuylFqdfjvtG18=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(376002)(396003)(366004)(346002)(451199015)(66476007)(4326008)(66946007)(66556008)(41300700001)(6506007)(8676002)(86362001)(186003)(2906002)(83380400001)(316002)(6666004)(6916009)(478600001)(44832011)(966005)(6486002)(6512007)(38100700002)(8936002)(36756003)(5660300002)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aeUDq7w9/w4ygozcg4tAKS8upIWqMdE3ikVeyPXSE5IBAdc6bfI66hi9LdsV?=
 =?us-ascii?Q?6ofXeJBoVaQtE0L/M7THf2k758pEWVBNbd491sZpYLuTsnRZdNOm+zHcg1Nf?=
 =?us-ascii?Q?0XjqGqk8H7tiDS5IvVKXnP4R3EBCcr7qc1uOc9cHfzopayFfdvRS6D5sc/W/?=
 =?us-ascii?Q?qpGgaxVuC2oHg6aR72kUD/F7Ja0GxDm3tI1kQw0sAd0zUsadagO038jMJ/5M?=
 =?us-ascii?Q?e4yWJWroqWMXe134N0hZmoq+3kwSGkT0QhWXRjOFFGDlcvymASCpSLeJt+Pe?=
 =?us-ascii?Q?aBx4UVvdWQ0M2cwPHrh6ss4Dga+3PzOBjnOqsK63uWnf8hCEycQKfZPTkJnv?=
 =?us-ascii?Q?fVWJgu/JnR0MY9w9TGc4qA0iGbB7/W8bJaFpBqDOajJpze4uB6f7JtqN8Lsg?=
 =?us-ascii?Q?pgdG3ywDA1/6ngtP/DLSjJsJr4gyZeKsKt32EewuJUH2Tqs0ank87PhbGTFF?=
 =?us-ascii?Q?3Qh+ybf5cRVEQ7hYB4hpW5ImZgoaBIgPT6EenXGY08y9GXUWBm75Q0mlUkgx?=
 =?us-ascii?Q?bYncwiKALoOkg0OjWrwmeB1YXjC3caddThqdtnaUYvEXOlI5QDquT0MdAfKw?=
 =?us-ascii?Q?N5keMDpX+eXTQ5iv0cLhKvvnHr0Q80BfUL+htcVbALe9L11Gyf6BZhrH3hp6?=
 =?us-ascii?Q?CKQG0zHCfI0CvjK+DRs02fMmjMp/PoRYr+gTIeUSCvPH2ZBI4jaylOsT+9r+?=
 =?us-ascii?Q?lIachTpqNmvJdKl0ZnV4m7SnFMbr24DEaXvXmFBAEdcMzalUwbPjZiPdfW7o?=
 =?us-ascii?Q?FeDzVlMr2YP03YaIS9bRlXC7uUGhA63UoDCpWB/nE2OvU1a2OaUEhc+2gAun?=
 =?us-ascii?Q?ox2RdliJ4DoidiTCxN1LHV7CUVAC8molk0GmuI7HwJ6qtDn1DhuceNEurobb?=
 =?us-ascii?Q?3dSKwtxJhBEV94U/lv3nrpNDaHgf09rw1+tns0jJzepBWToGigHhd+Y/x9jV?=
 =?us-ascii?Q?TUtJS59YOJwSNFccLlnBLyRid+YjtkNMpRFEIA9/3VCANTfPb3Nw1t81DP+/?=
 =?us-ascii?Q?eQi4aJoY2Ddb4XzvpJq8IPe0t5Fo1cX6o8CIArAh1eIZyrSJ9xRpDPd3n3wY?=
 =?us-ascii?Q?lFCrxgBPABzaALmIMJws71J+2Fgsyrx8iC+VD63sNdZUPZgBRQqaDYWdy7jF?=
 =?us-ascii?Q?gXDfamSSST/Nqkz6mgWzh4qwX0fKaJLF+lnMLvL0d6Kft/yQKWo6Xfn0Zip9?=
 =?us-ascii?Q?hAolMtVGfVcgR3kxLKk4AGiljy6BT3V0Zi3x/Hy/LAWewnitVaymQkM/nlS9?=
 =?us-ascii?Q?dFGSSZFWp1F8+Aq/ZEJd60pdrf1Xk1WRmdAG/H2y1y9+w8DYVrB+PZ55fa+Q?=
 =?us-ascii?Q?OgfZCgmYStPJc4R6QOHy3oRVXzftBgiBnYJFcEumQJiPZskfZbkzc6Mm4rw/?=
 =?us-ascii?Q?qOEpoPGK9avB7rqkXKdkZhYb1mdsiz9WJ09imNfqgBtJusNOPVeLJQFYpGXa?=
 =?us-ascii?Q?vratuWs2AjfV6xSvR23i1YY5Z0gkX0IlK9svx4tWLBjZ7MH/mR6mJW1h44dQ?=
 =?us-ascii?Q?XTuOImOgjKLK9Oyb8wbW20dSAFUiAUkeolkbVo6xQ1GksM4uYK54d4nift6D?=
 =?us-ascii?Q?NOHn5MdV6n1CFcWwm2IwgfCXa66IB8RPhMN4ULZf0Qnt3GL8Dv5yPUUs39tA?=
 =?us-ascii?Q?m+OUVXPP5zctcv3mABpnTLvf9Naxe1voyfNAURYWownfdj4TaxqOP6uHaRam?=
 =?us-ascii?Q?tmwoUA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294ccf2a-01fb-45a4-5db1-08daef15ffcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 12:11:39.3312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFK8UQ8Seec2TxFWkCVuyaBGGqt6jFfxiU8XfWxjkJMe6lOI0Ph2jFeDGtiKQab5vwNF3gyRh8Ts3W0EIJ3AsQzg7dcG9i9vhErBS9xGZ6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4054
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 10:36:20AM -0700, Maxim Georgiev wrote:
> Current implementation of show_bool_val() passes "val" parameter of pointer
> type as a last parameter to print_bool():
> https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/netlink/netlink.h#n131
> ...
> static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
> {
> 	if (is_json_context()) {
> 		if (val)
> >			print_bool(PRINT_JSON, key, NULL, val);
> 	} else {
> ...
> print_bool() expects the last parameter to be bool:
> https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/json_print.c#n153
> ...
> void print_bool(enum output_type type,
> 		const char *key,
> 		const char *fmt,
> 		bool value)
> {
> ...
> Current show_bool_val() implementation converts "val" pointer to bool while
> calling show_bool_val(). As a result show_bool_val() always prints the value
> as "true" as long as it gets a non-null pointer to the boolean value, even if
> the referred boolean value is false.
> 
> Fixes: 7e5c1ddbe67d ("pause: add --json support")
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I'm assuming that val is never NULL :)

> ---
>  netlink/netlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/netlink/netlink.h b/netlink/netlink.h
> index 3240fca..1274a3b 100644
> --- a/netlink/netlink.h
> +++ b/netlink/netlink.h
> @@ -128,7 +128,7 @@ static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
>  {
>  	if (is_json_context()) {
>  		if (val)
> -			print_bool(PRINT_JSON, key, NULL, val);
> +			print_bool(PRINT_JSON, key, NULL, *val);
>  	} else {
>  		print_string(PRINT_FP, NULL, fmt, u8_to_bool(val));
>  	}
> -- 
> 2.38.1
> 
