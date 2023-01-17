Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E3266D90C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbjAQJA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbjAQI76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:59:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2104.outbound.protection.outlook.com [40.107.237.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0F51D91F;
        Tue, 17 Jan 2023 00:59:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN7Z0a0XIfFrpeb7E0y2RRaC89x0bXK8OG1jjF5s3wxj8gtdxHMdD6XFgd+NdPlUOL0POdhP8BtF50mYcEUvt0nsLMyIBOSH6OuRr54gpirlbemYMrAhBRpzU0aFFptOZCBVu/we4W/5TuEfzUM1N5K24gJq2BLZ9CumilMtUNMdOoKu+U9GwZe76GlG8tfr3BtdbDbWs864OYJ/BkUPGZlahbfVRabJklUE7HwZ7dHH8PYTItolWUhbRdWX8K+DYRBkdNFsA/ZSaPV30YI8tFVX40HMD8kdX+YhTIR6JDhbgQZaeRM2oLdg+TfI25ZbaQQi/GmYlBXfqf/rbavaGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzkQowbY7n4G/e1S7ouqM8pPZO4R4Ng1SmH8pKMgouU=;
 b=im0jvMkUFDjI4T6rsv6W+IR+QbJje0ex5TvWztO9xr8zgGslSP2L3mi2guV4RmTwgYu/ZzdaqXLg50f+q44VdLS/im4lNH8gVNc2FkyMmq/h39UgBPygG2VXwVZxdW4wR+9aqkq+pcKI7BzUkVqDc62zypUbu080dxBOgI47zJsDWn5gYD/GyF1xOLrsfSeCTu90zZl4KfKknNu38/1Oh/TePmeD7MiVK/X9qUZo/qedICoIb1kUHt1iNSFK90Grln+ZPAxgtFl4eF7LckDToh7zhswInpTBoq4T47007BRn5d1H3VSJFFykwYjT/Kb5tgud/IdtxPjz0/bTvTbC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzkQowbY7n4G/e1S7ouqM8pPZO4R4Ng1SmH8pKMgouU=;
 b=lM5ThGS8VHl+4ss+iq7BkgAtkCgSlQW0mD5ReEVqupDUkg+ZBlZmh20iIMsq3hI19Pklat0vL2XjpGhrgN8mdZxnR+RaVBbhZa3oLBrwH9N6ed5RF8qEt88XQmMa3Who2y6N+vq8PIYkML8VxRA+NlaT9ZkVAL6qCNsqYGiwTqE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4647.namprd13.prod.outlook.com (2603:10b6:408:129::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 08:59:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 08:59:43 +0000
Date:   Tue, 17 Jan 2023 09:59:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Doug Brown <doug@schmorgal.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/4] wifi: libertas: only add RSN/WPA IE in
 lbs_add_wpa_tlv
Message-ID: <Y8ZjeKeNx0eHxt7f@corigine.com>
References: <20230116202126.50400-1-doug@schmorgal.com>
 <20230116202126.50400-3-doug@schmorgal.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116202126.50400-3-doug@schmorgal.com>
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: 10491783-affb-428d-56b7-08daf8692c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQlPW+2hLLYIlNwv6j1Ky0NDlHaebisa6urcMbNl+oAjdtOzWEDn11aeW25J5HHXUsxd+IcaMem2xlUTH5StZsUkuB6lh70wZ0H8Jq1dwPeR5ss9QnuxFEtXC32boTDOcVD4hgGwBvkdGt7OFqtR66bNVNVWndlw9V8mcz0M3H7uDt8hQP/3cnIrmlh2h/QLSQeNcI60Jiw+Jv8GSiFF/kfJiPwdUM0BNoi3jm4Z5D6+4zZ3L8PZs3yFJNDdM+6BgghgzRXCmh9jsh3gQnzvIEwM2EXCMPR1c6VssHqDVZXKt+RXrSXGRglU0QTKSo9N0clAZ2EeItn85ciiSXA24tTSxsaqgIlfZvicij0pO3LWBRI3SzkwRO1W5ZLSDFaiev6buIn9z7iW/Qchr5spo52ILfIQCMUa6UqoW5LH7FZt3TJBbRExSWvlGSrkFmKUqq7wVUms19pJFeDCOqzoWKjEJykf3lIti+DPVpT0VXfnmnvI77PcQfMN+pMdhgwRJzr61HGJwquHuWyMJhbpuAkGIq4OfYNc36KbW/8RHRRk5v6UR+LThH++x4L9BPWFSp59pIOkgP5sV55aNGmBdJz5Wq87jqby1ycNSTdJvxfhXVbLSQVkTxsLfOQq/RphdLUru1GQYy35HHzdj02vcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(376002)(366004)(346002)(136003)(396003)(451199015)(6486002)(478600001)(41300700001)(966005)(6512007)(38100700002)(186003)(86362001)(316002)(54906003)(2616005)(66476007)(66556008)(66946007)(4326008)(5660300002)(36756003)(6506007)(2906002)(7416002)(6666004)(44832011)(6916009)(83380400001)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8blp8j6k8C89JmiBAF5G4FNee+VyTGsJztRgVkoHnpXr3f8EawGqVYR2HM+?=
 =?us-ascii?Q?bzBRv20FQhRYlAtzw53cQo3ojkEXpHAZES31eOEA2BBKBDva5L8BU5cwsb86?=
 =?us-ascii?Q?kx8V9MWzQlL8j7RgWeqLzB7Yemdt4x78O/WkVzaAPtM3IWJDes9TPheBJNVT?=
 =?us-ascii?Q?1a5B7LnknWh6bmDypwi9iBK9hozBnBVDB6NHdShQh+wMM5WDYPv1v7iNMe2U?=
 =?us-ascii?Q?hL4kUFDV7K5LVOG5VJR0fMLo6JdaEo+ZAk8xJ/U+9L5xq5+Inv8jLhpmNY+G?=
 =?us-ascii?Q?Gw0qDf0rYf2bceC7t6MWRlj0+CoQ3djcmLSs2doLvVfCPB+05LqOvEz3O7mQ?=
 =?us-ascii?Q?HXcAM6+0kUWtYvkuenYy3lf6lLrgarOxzHspPpQXs12mJAi1MZZIxPG95jtk?=
 =?us-ascii?Q?PUSnyt3FCfkqgWTuNDyddOoQ2wSJAtyPHoyu3sDfoZIBGv0s1eZcLVhVT69k?=
 =?us-ascii?Q?BegYmWea6QUR2i2qmzm4Jf/KiwJ5+ER27UfPM2BfL0NeW4URoIn4WugjbcHq?=
 =?us-ascii?Q?CexxrLRecgJW5rx9zDD+QcDd/JsG5vZ2b8ysItgO8vFh0R1B9M32xo00G9ag?=
 =?us-ascii?Q?FR+4xxE++d/OhPFGWFmwd8t/t1JKKkeWKwaRp9mx6gpXNWxQ2lqu2nzPO2FN?=
 =?us-ascii?Q?lpnOHIyf0TVwMoTZF6Q8YWATUiQXzHo0JSpt5D0WVY4KS0Dv4uUF5wnxPDBV?=
 =?us-ascii?Q?V8KHoyWBvzreRu0G/rCyXgBC8AZ3FR1MUSi+r0FF/DgTL3dT5IIoQOMmUBKu?=
 =?us-ascii?Q?U/F02bbPG+79FHPWNqanX4mfNZOwkkf8Un+1Am5plRB2hOMvMBuu5hY3V2cK?=
 =?us-ascii?Q?IAAbwnTVLyf/JMBoJj5vjgcimfMxbELG9OqMaDsn1g9NPv5Hq2beoaFZgeyp?=
 =?us-ascii?Q?n/MljP1vt+//yisj1zZIPUDV7NA7jrTUvQA6H5N3lRKKrUYGs0YPmXuKyYR+?=
 =?us-ascii?Q?yo7xQ4D4aEAvDfpYrmnMJ+gddcmdcAkmvAo6x8xmZhD8vv18FqcufYVjObeN?=
 =?us-ascii?Q?49jh37V5DbJS8zsQeF6oKW67k/dF8+EXokH3znMvPUqZ9iAlTm13EQL3+caw?=
 =?us-ascii?Q?andUd4IK6qXY4kfc+4o/q3cG+ZGX8gvtLWQosf7pSau0icPKVmKn8wQyOmQk?=
 =?us-ascii?Q?EwnJc58nNcFXZiODSeaUaCuokpoBXuRQygA7yn6rnSUk0abegTSg5dtsnl7U?=
 =?us-ascii?Q?5J7bFdoRnwNUzwRHeDe1S05WRVGCZZdtxE0ztNJTKrWjZJz0vOyUBbTPaN0A?=
 =?us-ascii?Q?kieXsPqNbDS49CSzwvc8SuxGd+J4/TIIBBQMQcd3ypzrKmVqkiDEOiDJkBRr?=
 =?us-ascii?Q?AL6j96mQtwaSfTjayHby3OYmbeCqbeUcYeALnRtm0vDfOYoznBiTw10heI9v?=
 =?us-ascii?Q?QhRTJCUy+IypnsmEYAwuj/wRLPImksob/vdw/Ri/wNXhggYiuRu/aRoqiH+T?=
 =?us-ascii?Q?YQl1sBA+ORTTPZw6Wa3czya7w/7Xuo3KavMfJUzBzs7h/g9Qx81jhkpbkr0O?=
 =?us-ascii?Q?oLzeD2eivuVuTuaHKhyzYuJdqL93gC2K36Vxb+NK0qeF+ad1CaR1R3oL8R7w?=
 =?us-ascii?Q?GrcAaxnBFSljWWLhFwz1rum67qBPQQH63I/w8eOpW7CccS9OXWCtdBbitsFz?=
 =?us-ascii?Q?E/Jq+KglzzO6g8Zsk0qGAoIhzNuSxw1uNnJafnMNORGI1Px8hAEc1E+kQgWr?=
 =?us-ascii?Q?y03dDw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10491783-affb-428d-56b7-08daf8692c7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 08:59:43.0225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3mo/j2Vl3EhQ67wWqyA7dYKPOFMCpXX4i+9xeFtCo1OufLhxDanh0/sNU+OqV5MlEbqjm3zLCZjpBOQr4JJKJrHsnuaVPZujDupWGcpOUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4647
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 12:21:24PM -0800, Doug Brown wrote:
> [You don't often get email from doug@schmorgal.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> The existing code only converts the first IE to a TLV, but it returns a
> value that takes the length of all IEs into account. When there is more
> than one IE (which happens with modern wpa_supplicant versions for
> example), the returned length is too long and extra junk TLVs get sent
> to the firmware, resulting in an association failure.
> 
> Fix this by finding the first RSN or WPA IE and only adding that. This
> has the extra benefit of working properly if the RSN/WPA IE isn't the
> first one in the IE buffer.
> 
> While we're at it, clean up the code to use the available structs like
> the other lbs_add_* functions instead of directly manipulating the TLV
> buffer.
> 
> Signed-off-by: Doug Brown <doug@schmorgal.com>
> ---
>  drivers/net/wireless/marvell/libertas/cfg.c | 28 +++++++++++++--------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
> index 3e065cbb0af9..3f35dc7a1d7d 100644
> --- a/drivers/net/wireless/marvell/libertas/cfg.c
> +++ b/drivers/net/wireless/marvell/libertas/cfg.c

...

> @@ -428,14 +438,12 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
>          *   __le16  len
>          *   u8[]    data
>          */
> -       *tlv++ = *ie++;
> -       *tlv++ = 0;
> -       tlv_len = *tlv++ = *ie++;
> -       *tlv++ = 0;
> -       while (tlv_len--)
> -               *tlv++ = *ie++;
> -       /* the TLV is two bytes larger than the IE */
> -       return ie_len + 2;
> +       wpatlv->header.type = cpu_to_le16(wpaie->id);
> +       wpatlv->header.len = cpu_to_le16(wpaie->datalen);
> +       memcpy(wpatlv->data, wpaie->data, wpaie->datalen);

Hi Doug,

Thanks for fixing the endiness issues with cpu_to_le16()
This part looks good to me now. Likewise for patch 4/4.

One suggestion I have, which is probably taking things to far,
is a helper for what seems to be repeated code-pattern.
But I don't feel strongly about that.

> +
> +       /* Return the total number of bytes added to the TLV buffer */
> +       return sizeof(struct mrvl_ie_header) + wpaie->datalen;
>  }
> 
>  /*
> --
> 2.34.1
> 
