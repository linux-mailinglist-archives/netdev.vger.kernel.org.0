Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4FD2885FD
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbgJIJez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:34:55 -0400
Received: from mail-db8eur05on2108.outbound.protection.outlook.com ([40.107.20.108]:49632
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgJIJez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:34:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aieIm9CDBRHphxMoViMbVJbZ5hAud7uZ3yTGi7+i2GRIfShygcWXvPnd9BfaKSk31Nkye8yHA++S1Ojcqi5MZk6djr6uybAjcdmaK26vo3htVSR2TOhu1zrbKWujjESmkYDXahOFaT77JQtG5J75RcMgApHohbruoMfV6wheVD+tzAivrDrmG3/mBGITZgrotB/TdE2pI1mFftn3QcyxaWVsOgYRgHcZ+Rqjd3LffMrI7gvrOtUbC/DCrhgUAtqpahOapyAJpSHzA6b/TscAXXeOycM22WkT7OoAP/VVlFn0b8l51KVrgYDVUPy0SzPsxHZslqOTaS6UmROKeG0lHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CQytxdpuUeylTm1MWj4+YApZhDVANNeJd2vH1F1+Kk=;
 b=cGu5Nl1Db7M5YiSoU9h8ZHMs8vLQfErhpCNtY63xMcn6cpGYce77QlgVtesjUXNzfgvU6yWbbnSavcSpiZwCp6tyC3zcLQkwcNHR01vW1IPaQh/W5f1+JQDRjbI8OhpkReYZXHkoIDgw3JMCHfUowpz1I83K0gdqfN9Va+knDAKI5GdZ0dlZBkWzGZ/MV9XFxZnoILVJ4ATZYKPBE6Okta9Ev6uS4SLX4b7XjAyD822GSA6aDoxjwhNKcQe1lyr/SB0cBmK2e92dehvcZkHcahiIUKjsvM+gh6kwm6D45ho1inHqzyU3PGYmpGw7Su/vpPmqvG6dPpbwSL5k7LGWAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CQytxdpuUeylTm1MWj4+YApZhDVANNeJd2vH1F1+Kk=;
 b=ThkfbExWIcA4n2oALs3/sj9kgwWB9P9okFytx3wHhrwazQb9tOLUlV3HPi5hQqDb5KIv4XTPTPGJCDJmJ4Jax6BiqerR/sxemFBIEf8E+tPdHNjLuTS2FrXsqPM/vfqxUw9HEqSlflNTB5rSELog8uc9+6nX+Yf0BMIFVd2V5XE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB5556.eurprd07.prod.outlook.com (2603:10a6:208:104::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Fri, 9 Oct
 2020 09:34:51 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f%5]) with mapi id 15.20.3477.011; Fri, 9 Oct 2020
 09:34:51 +0000
Subject: Re: [PATCH] staging: octeon: Drop on uncorrectable alignment or FCS
 error
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20200108161042.253618-1-alexander.sverdlin@nokia.com>
 <20200110124832.GA1090147@kroah.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <4fc15baf-313b-27fc-b2e6-46552d6a1630@nokia.com>
Date:   Fri, 9 Oct 2020 11:34:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200110124832.GA1090147@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.166]
X-ClientProxiedBy: HE1PR0701CA0085.eurprd07.prod.outlook.com
 (2603:10a6:3:64::29) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by HE1PR0701CA0085.eurprd07.prod.outlook.com (2603:10a6:3:64::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Fri, 9 Oct 2020 09:34:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8401b2f3-54da-4d1e-0882-08d86c36927d
X-MS-TrafficTypeDiagnostic: AM0PR07MB5556:
X-Microsoft-Antispam-PRVS: <AM0PR07MB555617BB6FA7F0FDE7C6C42F88080@AM0PR07MB5556.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VoXHXZ0c3Bcf3nuEdZF/S0a97HEkU1dlsFsw+6I6HBGI0T1/GZj65PnRfGNsVHvmZZ/ec+Vh1ZQxp8XYGcEEPMfr0gn3L7VevJ8TjAfiUX8F1j0k7wwu8/MU+HH8gaSatFEileec3GDan71j0zemD5LTcxYfJklWS15m2f7ykPZfj7vuZi0MFN5hSpc3uY95uZOEtrzTuCj3JPY169BQWV0uApa9/ywRbsMspep8fhFC5CXJsfV/SICn6H+iFWSKB4L9A0h68klRQimmMmxWLyShZpUGLxHpoduugnvteqz0eY1rFtoj0ZnJNYv1uukisFg3iSNzsyCH11s+yML7q/yEH1E9+FZwvCs5CxC0wBflLFA8ZWigmIGffxkWm//
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(66946007)(6506007)(53546011)(4326008)(66476007)(66556008)(16526019)(54906003)(26005)(31686004)(186003)(478600001)(316002)(956004)(31696002)(86362001)(6916009)(52116002)(6486002)(2616005)(6666004)(6512007)(5660300002)(8936002)(36756003)(44832011)(83380400001)(8676002)(2906002)(4744005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: oREHljRHHfHIN8jjEu4tprVqtNQcajzBTpSBhHRTPv20jFPV3Auc4iH4Gqco2SPcgy8e1pNd5+fU9CgUIfnphQuR9dFRDphTWU3hG+8XKb4K3Baw6k0x+d5I9HhWFZVi01Qnalp7ZFWqezS67iMn9igp083dJHp0kyK7ztFDsCeXltpWWqIWsbspuzIR7tLWOW82icVe8m+refKlb/9XujBMtFaVb6NeO/niADnJEBvOYc52GbiFOodcVZyUjE5MlPx0wZa/zAxYDwygZ1qdnNot6F+78zEI55HWSXJ2gZldI0++khu/fKvVUz4peOAHuKUAchIkwmQgn6GbCsANH3apL4arxs34nAVDWnG6rBl6iw6GJHZ5W64yXC5wROMbk+WCarSlxUHvcWR1xyCTrZrvkh2mDC3tCs64izD6+hgRwibLt1H8QSF/cvAGyK0C7D7zvNHEmBQdIn8DBojLscbOszVYi6XmNUVS31HpCdNdzgtVMKm0qbWq/VHxEjG83zrU5sGowu+ODP6vwuZv57qpln0Xi7enPnO7/NlPdJqO1JaLW1toVQMeAzHtu+EeJoILzo4RuQimoluMMuABxV6j8dw1e7jx6ktfoahHec3aCKseGK958M2za9hd9KrSRW+cGqSW/WhK/71oOQ7sgQ==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8401b2f3-54da-4d1e-0882-08d86c36927d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 09:34:51.7285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0VwsBAHGWb7PNDlOJVhNFDYemoPyml4TA8HFIAfW8m0YSXGTATcNvxo7D+tvqGO6k6ixMSUIKKTFed/CCnSWOZujkCbyz9n+DPez8l6b1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5556
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg,

On 10/01/2020 13:48, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2020 at 05:10:42PM +0100, Alexander X Sverdlin wrote:
>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>
>> Currently in case of alignment or FCS error if the packet cannot be
>> corrected it's still not dropped. Report the error properly and drop the
>> packet while making the code around a little bit more readable.
>>
>> Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
>> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>> ---
>>  drivers/staging/octeon/ethernet-rx.c | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> This driver is now deleted from the tree, sorry.

Now that the driver is restored, would you please consider this patch again?

-- 
Best regards,
Alexander Sverdlin.
