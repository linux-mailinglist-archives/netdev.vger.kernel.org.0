Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D573967C577
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbjAZIFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjAZIFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:05:07 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2098.outbound.protection.outlook.com [40.107.237.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429C65C0E9;
        Thu, 26 Jan 2023 00:05:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENAgIpcE6b8PzGIUVfyixu0ojB8WGRi3iPbFiZBepxGI3DMJKfpmImRYIgxEkZ0mHuYjMflUQ4jTQ4RVrtvyHh5o3YCxPtMNjASVxuVL/DJ685bkHbiNasiJnZnhjgt1gWSYS9cbqVv4AZLjeIBJaQVmula5kISaV/lKPtL9LbUQs+ysGGEQBhn6MLb09x3u36LmNqWjNtRZTIBDSl6L3JpzbMLr7ec7VaFkyMhYdS9q5L4wJRIxDn2V37PhLNkj/4Y3LzdOtqa95R7b3CBzre+9Du5c3gs3+QblAvLdEGMc0WZwCGJWryeqP5U2unTeaAHit2W5mVDQHrACpp2LcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/EciPoGgWY8aUxzKHI7WMT+VObzAlBXq2DSBPdfMK0=;
 b=K9J+cx7xywY5iEaUszNSj8XM470iG/GqoUPEeq74EhnX+c0zMh3ZHmUfHnFdknTp6gQxe0Skd8t2+B3wTKLAhm4gQMOp8CiSeveRwtr7KNHMfhKXTVvTb3azfMja4T33vPT59omrPSUmxOWmhcDNBhUa9sy8OJFYtIRFFMBJPuCs39otEErLS/iRTAMLXijfrH/JSAaVJokAsgxs/aYxwKshha51d3ob6L6r7gegrPvq3kQluyPftkTolqTpDe7a2i3xjouWI4xl6RUpbGcN+Ky1MPCyvITfsTUii4sRDKsFlvH+06hTyQakwxJEbP8aOWzTWt6zjwWpyEkCGl++lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/EciPoGgWY8aUxzKHI7WMT+VObzAlBXq2DSBPdfMK0=;
 b=IsQ9GRCs7N8ByDECGHuuc+xh+n8dR4Y1h2PD9XZIRBPdLOaIidva2Uowkuf+10BgBWXkW8Lt9R3119kpRSfYWMapt8oWu1no1WNtgu9k07ha0TBnJHjJvoxzRnHpzmMFcJVYu0NUnVQeuQG4Z5DdH2XvXLtujlharAf7AeMM2fE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5324.namprd13.prod.outlook.com (2603:10b6:303:14b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 08:05:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Thu, 26 Jan 2023
 08:05:03 +0000
Date:   Thu, 26 Jan 2023 09:04:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/18] can: m_can: Write transmit header and data in
 one transaction
Message-ID: <Y9I0KEeWq0JFy6iB@corigine.com>
References: <20230125195059.630377-1-msp@baylibre.com>
 <20230125195059.630377-9-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125195059.630377-9-msp@baylibre.com>
X-ClientProxiedBy: AM3PR07CA0101.eurprd07.prod.outlook.com
 (2603:10a6:207:7::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5324:EE_
X-MS-Office365-Filtering-Correlation-Id: 97604de9-93a1-47f1-d76b-08daff740731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ngZ6XtDca7QKYQ52zzo3I+u+NUcijV8e8kC/dwJUBf+w2wauE8hFDnTKzvKR1y35QzPOnbG4kggChlv1kLyN02hsRadETE5zuK5mQzHinLZuTlqZC1ffr81NwtUH7xQrSN1mIa9JyZBXg4d9ya9YEyZB0+UznoGNbD8hcmkhkA8bjabj6gE+GrfPz63pV1iNysnCGAjq9tJcK/yVXuyQdCUnQGorBU5kkjhyBZw9/QQYOJMll2NFbLWez7qsXDoG574OVeLN/72RtWdLihl+ZSSoUBEJMtdQXtY2biYFc3r9f9LJIlGquLIkESFng+iL0ooejtMK+FiXioRwmG7xoX7lhOWeO/OYWQroETNySpRQfztVHD+gWLO4tLh60mo4wAodQMLAMMb3kj3RF/9n6Bds1bK+r3+PoGdkof6WsMNhcvf23HZmZutbGc1KD8jqBqjypPkYiIsr6v2TU4yNmapCYW6sB+jwBoxnOBXgplfN/9tzfugBsfpdN72nRNIer4wi8Yb4T/AaXxVab7OJEQJR9AY7G/IPAIB1R+bnFmUcRzJ08hrJXNJ0Boo/7AibiMAdKS4oCrghn9Ns/Af3HHOMF0pF9lKyMggpBr385d3srDNufSeC0kJn3fpMrKHJ1EyjPtR/tI2YCxMyR7m/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39830400003)(366004)(396003)(451199018)(41300700001)(66946007)(66556008)(66476007)(8676002)(6916009)(4326008)(83380400001)(38100700002)(44832011)(2906002)(8936002)(5660300002)(6486002)(2616005)(86362001)(478600001)(6506007)(6512007)(186003)(6666004)(54906003)(316002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+mCmgCfEQ7Fp2UrP4tc9RW0iG1lykY6dBNrO85/qhUu4yYQ2/41uqyKxxvOJ?=
 =?us-ascii?Q?u9+TDRIEfD9qMyTBYgRnin1emIYaUErWsyZSnAgAJFz+Ta4yxmg07OpJgB5N?=
 =?us-ascii?Q?UnKD99u8CSN1uNbkj/c5rm0QDaYdX+ge/SA/mErwfVVLNqqQP15M2V1Vc+jL?=
 =?us-ascii?Q?lSwNNmydpwDR+KEv5CyckmyOY2H5hF0O22hPiBZDoBOz2SQiTKMkgy9WlQ92?=
 =?us-ascii?Q?5UWzaGRyo6W5osY+j8ebPBiYugrxbQ0VTiYakZgEFC7xVxxx3Wmw7fn6UYYq?=
 =?us-ascii?Q?xF3WXnzSXA6SQTsn/04nesf40h3lCplIwmpigHQlyOddkUUTujNXsi1syQ1G?=
 =?us-ascii?Q?ok0eXWDUT/oyq7PhOgc6p4IpYaC/iYfpqif6BScJz8RYu5vYH/PimhVJlR6J?=
 =?us-ascii?Q?hdykJtTh0hSa4s5gDgooNwnkQHMjVMZ0rfuUdqO35eHg70Iw7iMoTGAdm+Po?=
 =?us-ascii?Q?w3wvqJkbvwlc1qnRatvJYJZ+CnSSm8iiM7YUk3DdLS4qiGgUWUn+OfOCvFnP?=
 =?us-ascii?Q?c/euwibDtGhvbyn/N6IKsnjctdYqYdkjnW5hN3omilcX+p4nWF/+dgpqtggP?=
 =?us-ascii?Q?oUB5tJ+9cNPYocvXHTrcIVsQSR0yjYe4R4reZRqsOzz/59GlUlsor8kEXpa8?=
 =?us-ascii?Q?A0VgrCmtuRlRk7zReUUNvFv285HTg+0U1uhiKuxfJQhhu6j1DhGq/cMo8Xdj?=
 =?us-ascii?Q?b5FVn+3ubL36DeFx0OqxUKaE28sRfh40fd/c/ONJC9nGUk4bpl3EeIsBlXn2?=
 =?us-ascii?Q?M9rOinhrMDAGKvDLLZVM6U/P9DTlhlgJrhWNMYdaMHQliNk2MmNVjpB3zwZK?=
 =?us-ascii?Q?sj2jhbvxxeZB8RZesYDk5+aFKKc2yHXzBf99IvgpgEphlu1Cz0v/UNxv5fRR?=
 =?us-ascii?Q?PCGH40ix9E7jozNADL3L166F795khoYN4EhLecVoPRnPQJUzXkry885Qb+Wy?=
 =?us-ascii?Q?qL7vS5MVPB0BsPz1+hMTWLoJ7rkbd7gJEzrOOe0bfQn+miieyuxJP6CP98qb?=
 =?us-ascii?Q?LmTBkFS3UBH/xBq46HRTkZwpbeYEEx4TawfKUF6vLx5dB+Ra2FRiddqS9wsZ?=
 =?us-ascii?Q?pTsEugJS5bFIrKtVZp7orJtk5UwOAqYvGVXttEYauh26gcuxzO31/6JkYUjJ?=
 =?us-ascii?Q?hNdSnLvC/GfuWYvIVV6wKuGHRXbAQ7Tyt+IRFzmfB2SZwywMZHPmi5DyF25R?=
 =?us-ascii?Q?zYcOdRwbVrHWo8WihLjgicVuRlkaYeMaAZpPV9bhm7wKIYQPJxpe5ISkSD04?=
 =?us-ascii?Q?0rIxNhClHtYMifS/LiUqTLGH5kLk3Jl3yt+jodoHuXQO0VT81ZEsdXh4kfqj?=
 =?us-ascii?Q?MX24rRWov0bcX++mW7FVIoEWF5IUhvgRULmcwTwirVu8AFGPUL9OK8IsBAlw?=
 =?us-ascii?Q?Xkj8lm3pe0shCt9CYXs+s8FuqJ51ui9PyyfwSkRT0vPgwOgUm31dxORGt9Af?=
 =?us-ascii?Q?1fcp1R6/rAHDJvyWh6rIi7FPDxMrhmi4JP9q1T5cU/l8SrLTYdBPBjVZONdb?=
 =?us-ascii?Q?d8XKXrTtW75nTlF52qfkkSiZcMjfFlAYsgfv78OnLShLkY3W4S730pNI403O?=
 =?us-ascii?Q?5MhDoF+7DNEsuxdRlBFG8hBauiPIN824NuMBEyM//yfRrP8cGHqdXJkVdUA0?=
 =?us-ascii?Q?zIvqhFG+7KJ1FsWiWhNoSnTL404wsKUkN/hA7sTKkNyxGkFiF6gvNYB46dkw?=
 =?us-ascii?Q?frS/qw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97604de9-93a1-47f1-d76b-08daff740731
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 08:05:03.0842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxZVzc5OmjT1mMPLUNm+jSmzl8F/Fc15h8/D33zHg1GSGIGfmjYLLhZvHUtqKOQg2955MzKcKykHSm41BZons+aTNwO29KlLMeEDy66lyOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5324
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 08:50:49PM +0100, Markus Schneider-Pargmann wrote:
> Combine header and data before writing to the transmit fifo to reduce
> the overhead for peripheral chips.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 78f6ed744c36..440bc0536951 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1681,6 +1681,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
>  		/* End of xmit function for version 3.0.x */
>  	} else {
> +		char buf[TXB_ELEMENT_SIZE];
>  		/* Transmit routine for version >= v3.1.x */
>  
>  		txfqs = m_can_read(cdev, M_CAN_TXFQS);
> @@ -1720,12 +1721,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
>  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
>  			fdflags | TX_BUF_EFC;
> -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> -		if (err)
> -			goto out_fail;
> +		memcpy(buf, &fifo_header, 8);
> +		memcpy(&buf[8], &cf->data, cf->len);
>  
> -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> +		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> +				       buf, 8 + DIV_ROUND_UP(cf->len, 4));

Perhaps I am missing something here, but my reading is that:

- 8 is a length in bytes
- the 5th argument to m_can_fifo_write is the val_count parameter,
  whose unit is 4-byte long values.

  By this logic, perhaps the correct value for this argument is:

  DIV_ROUND_UP(8 + cf->len, 4)

Also:

- If cf->len is not a multiple of 4, is there a possibility
  that uninitialised trailing data in buf will be used
  indirectly by m_can_fifo_write()?

>  		if (err)
>  			goto out_fail;
>  
> -- 
> 2.39.0
> 
