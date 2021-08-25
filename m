Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077A93F70E1
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 10:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbhHYIIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 04:08:42 -0400
Received: from mail-eopbgr20070.outbound.protection.outlook.com ([40.107.2.70]:22233
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230124AbhHYIIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 04:08:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oe4w2+7RZ8rg7C5Rv15m2cfHjcbA8lwh2YCDDm8soDrSZIJM89VPXqNWlzNiSq6rwkhOC5LR79gQRfOKINbphfIKOvIpwrcwrCVH74F2yiuzAVD2svG3skBf9a4RRwR+McWD0lGSWl3O6ra19UR7zOrJOhTaAMaGUSy/6lxMnbZKgvXRnCk9SGFn13ERwVCjN3VkyVDaYYwciI9v10gw/rXfGiGZsYFQd9I2NWzuJeZ+RJzqynLSBMR3Rl1BXsfJYkTCWEVwpGg7pDkGORo6idZn2v+sPoCWXomA0LMphT9rF64xGVPq8hb1IOyinqeDAzIICP5GpZvXd6QqC1ty9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGWth44mKFJt21SCGPMhP25wyv6Uvt0M0rD7ferGNJU=;
 b=NvstFEVN3sAGKKefG2Q3I4x8J2tZBsnm2qUSbkFqseZWPVb5q7KBl53B5tZnPrG3RShU57Ia/JxbnnYjqVGGrS9QPbcZs25G5KJ+pQV6ObBC0u5OikIn3rkw5aq1bM4g53/ePLxo2D6Xh2x+HMGIFheSxYqd5d/t49/ASX85Bgx6k3BcspTmwFUt4//FzilmEXRhGTOcpPNGC/VNXXPWICxK4O2D9zgNfkOkEr8X5TizNq054UlHa1/sAR5139k9uxX9pN4r3k07xIewbfI3csyzj1Rwg0EYjzOYGjX7QeEFZ6fg7Dk6ia1W0LDfbQLJaxNQ4mldHF9fFUWfp1/WXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGWth44mKFJt21SCGPMhP25wyv6Uvt0M0rD7ferGNJU=;
 b=clYrMj1dNVTo3+uZf44DtPWjrX7Q0s6rZ3vn74KBwzae1QMJli+dhXmDebob/Y64Q4h0H5tBr3MzPRZ/9jK7H9yTFKl6QxCRnBZGukhXGx6prRyV3zTMlxu+mlSp4FSiSEd7rm3ewsAnBrnGj9gdTWhRUqqMKozaodBgtPrTtGE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wolfvision.net;
Received: from DBBPR08MB4523.eurprd08.prod.outlook.com (2603:10a6:10:c8::19)
 by DB9PR08MB6795.eurprd08.prod.outlook.com (2603:10a6:10:2af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 08:07:49 +0000
Received: from DBBPR08MB4523.eurprd08.prod.outlook.com
 ([fe80::ade3:93e2:735c:c10b]) by DBBPR08MB4523.eurprd08.prod.outlook.com
 ([fe80::ade3:93e2:735c:c10b%7]) with mapi id 15.20.4436.025; Wed, 25 Aug 2021
 08:07:49 +0000
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
References: <20210823143754.14294-1-michael.riesch@wolfvision.net>
 <20210823094425.78d7a73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Riesch <michael.riesch@wolfvision.net>
Organization: WolfVision GmbH
Message-ID: <60b707af-b138-3c31-726d-d78ac0e1c5f4@wolfvision.net>
Date:   Wed, 25 Aug 2021 10:07:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210823094425.78d7a73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0302CA0001.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::11) To DBBPR08MB4523.eurprd08.prod.outlook.com
 (2603:10a6:10:c8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.100.125] (91.118.163.37) by VI1PR0302CA0001.eurprd03.prod.outlook.com (2603:10a6:800:e9::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 08:07:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c455afb6-f8d0-4b12-a243-08d9679f6e43
X-MS-TrafficTypeDiagnostic: DB9PR08MB6795:
X-Microsoft-Antispam-PRVS: <DB9PR08MB6795BA1EFEA5AAC620D76942F2C69@DB9PR08MB6795.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41FcsKWz01u8s5NxeuotwKIklKtgvBPlPxUx0PnD3Uu+zfYrKnCt5V5cGjSolE1hDPA/ZQcdpaZIx1DqbBDlqCOhjHigvXUe2uouUYRrTTB67oqhGu9C3wDdV00RScMSBq78W/LUSX0l+wGY6Nz3FtyfUnT5IbA0c74n6bEaFo3C4n34wN4gv03lHhILnxlcR3TBsjR3yZLDuuTC1+vysvq6CJBusKAb8TlTjuFBzaG+LO2FSS1Vfr/mJMp7h9c3ziOHTAWO0Tjas4/FWSAuqKiiwR7VHbF3bexu2ytFW/EaLkIV3qIOxGCd9fXJW5eUzARIE4zlW5KZx2puc8G2L7ON6g+FTNf7GiN4r+6YuqXEcACj9h5+TAwL0m3U5Luwm9htSPfeQSAz+KuYQyfrcop2KeBF6EZQJL8uweL7HS4B57RpkS/uq/JLbLXaNauFhQi05dyk0/FxRtXAKVeZZc3UerkKAJye1u295simrhmWkB+QR2VcQkTAqzQEEO7SVyL5NUYcTs/b4CottsEAws2Duxo2ZaQiU41YOdc46dOCcftZ61SDgkcSHJtSBzDeEcs0/+/3CsPia0NavDKb48+jemfcaraxiXCLRhTjW0TEpUTNBwzA81eFMysP6cSQuTjz4HfH6VrQGG+Hq3lWAR+OfTVplLZoX2QMKe5WGlBOuhXlQ9LRR2ZOCEWvtYOYLk/hphKmUUdOr0it3jCL60A+IizlmiqHFvrjkRr22lW5bpjjiXd6phyCQpUvDj3GvpyeV6BHawrK/ff8sUV7QQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR08MB4523.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(396003)(376002)(366004)(136003)(346002)(6486002)(66476007)(54906003)(26005)(2906002)(16576012)(4744005)(83380400001)(52116002)(4326008)(66946007)(316002)(31686004)(8936002)(478600001)(186003)(44832011)(956004)(2616005)(5660300002)(31696002)(7416002)(38350700002)(38100700002)(8676002)(6916009)(86362001)(36756003)(53546011)(66556008)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUlLQzRLYXZYVG9zTzhHN1FnWG1lV3p2U3llaUg4RlAzUnR2ckowU2ZxV0J2?=
 =?utf-8?B?NEkxZTVvVVNWMUpjYmFSNmZvZnlVc1lkYUdPMW5EQ01wTkxnMzE4RUFvUGNY?=
 =?utf-8?B?L2VTbFh0ekVIZWNPaXFERmI4aGQxaWsrK1lNbDhES0ZvYURHQm9aOS9sQjhz?=
 =?utf-8?B?eEswYmpKaFZVa3RaaGlTRm5iRlFyZDNXdzRFWlAwK0VtOG10dytyNlI4aWtk?=
 =?utf-8?B?blVXQitwNzd5TjZQaHpxcFp1M0JLRkZxQ2ZNVlhWRjZ2TVdZeElXbk5BV2lN?=
 =?utf-8?B?ZmZNVzFURFRlWDdJbWRIakYvQys0Wi9aVnYxYVh1U3F3MDhlTEVlRUVyeEZZ?=
 =?utf-8?B?ZEo5T01BVGl0OGoyc0QyUUVuM21YR0xkZFRsdzE0dWtJTVR5bm9VQ3lvYWVz?=
 =?utf-8?B?L1hNa01xME5MZGFtWnVUMkJQdDQ2RDBtV2lndWdnQnRuLzBnMUM4VUdjZmY5?=
 =?utf-8?B?aG1sS3VPZXF3QzAwdGc5VjVLejdOdEEwTzVwd3lQcDBXejZIbFlRUnA5UnpT?=
 =?utf-8?B?N3VhQVRxZDc2cXFzdldmaUJrWlIvVEp0TVVSdjVhZ0RsZ01BTlZudkVNb29w?=
 =?utf-8?B?V1R3RGNwUFVBYWJkWFlkRStuWjU1ZU1Yb0ZGYlZhNUdGQ0ZNMXRuLzRsb1FE?=
 =?utf-8?B?UTZDeTRiQ2MvVk9Uc0p6cmtJOXhXZlArbDZ3V2dYQkcwdS9Db3k1WngzYlVM?=
 =?utf-8?B?NHZvK2RaQ2ExY0N5Y2JoMDVZRlh0WGtsbm1pV0FrS0pmSTd0bXJqRnJtOXdS?=
 =?utf-8?B?bG54MkVkSzhiT2xNOXNKOUlYazZPQ1I5c3oycHVsbVRXQVpCSGgvT3E4VkN1?=
 =?utf-8?B?bkZ2b044MG9YeFFzaFIzV1RJZmcxQTZ4UTY2VVdQWjB6Ti8yWEVKN0Q5ZXNG?=
 =?utf-8?B?VXpablJmdm40R05jdHF4c2NBUHNTWmFDUEpXNDc4ZEM2aXEwUHR6b2hCVVo4?=
 =?utf-8?B?dUVmUERSUVdiOFFqbks4bFhTbXl1NEx0RnBwTysyMjI1T0JkVXB4eUhUbFN5?=
 =?utf-8?B?WFJuOEp4U3FBdzc0RmpyZFNzaHY5WDYwcG5rTTFzK2xLL1pZdE9VcGZLTElk?=
 =?utf-8?B?eXZySk4vZjNPd2ZWdXlwRzVIREdLMThxbXpsZ3EySmJmWW02YWlKVGJqOVRT?=
 =?utf-8?B?MUV2Sll5VFp3WjZkNUNSMENHYStrcDJUMnl2QzBwNEVDeDdNSXM1Rk5FcmhE?=
 =?utf-8?B?em1mK1FNdmRiNHBOZDNoUzFyVjVLc1Z2cmtuMFlCeGFkS2hyRFJGSjI2ZDRT?=
 =?utf-8?B?bHoyOWFLbjJzTTRkWVdHNkNXcnR6MEtsczBXR3EvUmZIeWtjRnlEMVlIYTZz?=
 =?utf-8?B?L2tPRmZIYVVpYjZGTC94ajN0TVpEczBDRS9IcVRuMUk5ZFAvTldyTVI5NWFj?=
 =?utf-8?B?Qnd3OUJ2YlZGdWU3T2QzSmdrZ0RHL3AxTUN5d0ZuZ3J1TmRYVTB5NURUQ0pk?=
 =?utf-8?B?MldMcnUxMjBHWUE2MXd5c0luTUdjdG8zWkZVZXphWktXZHZwaGVpZG5SaERm?=
 =?utf-8?B?VHk1a0hZTzg1ajgyOUpjUDdrU0pLUE9Ia0tJNzRUWTRJdE9GRTJ0NmpwZjAr?=
 =?utf-8?B?TjZNTHo4aE01bktTVEFOdXNIMEFBVTZGTzhqQ3I5MTdSeHBUODFTY3V6VG5O?=
 =?utf-8?B?dXJLbjUraTIwNytFMVRFVUNJQ1pldzEzYU8xbWJNTzA3MzdyK2VXWEVML3pw?=
 =?utf-8?B?dGRkYm1ZaGEza3Y4d3pKLytXM1BCakUraElDTVFQSFBMV2NhcUhmZ2dydFJi?=
 =?utf-8?Q?a4Erum7QcXKO73yOT7BckIRq7Y/oOydPUyZwD6q?=
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: c455afb6-f8d0-4b12-a243-08d9679f6e43
X-MS-Exchange-CrossTenant-AuthSource: DBBPR08MB4523.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 08:07:49.8012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDdDwTFGNW2NxNqNhg5oDnISnwGphNKGHrpQZKw1xjoYumV1sZZW/2liOnvh/GQSp+7niSJOPCkGsKWupdgASUBfHUKGyEmO93euz6GJRGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 8/23/21 6:44 PM, Jakub Kicinski wrote:
> On Mon, 23 Aug 2021 16:37:54 +0200 Michael Riesch wrote:
>> In the commit to be reverted, support for power management was
>> introduced to the Rockchip glue code. Later, power management support
>> was introduced to the stmmac core code, resulting in multiple
>> invocations of pm_runtime_{enable,disable,get_sync,put_sync}.
> 
> Can we get a Fixes tag? I.e. reference to the earliest commit where 
> the warning can be triggered?

Of course :-)

Fixes: 5ec55823438e850c91c6b92aec93fb04ebde29e2 ("net: stmmac: add
clocks management for gmac driver")

This commit introduces power management support to the stmmac core
(stmmac_{dvr_probe, dvr_remove, suspend, resume}).

Best regards,
Michael

>> The multiple invocations happen in rk_gmac_powerup and
>> stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
>> stmmac_{dvr_remove, suspend}, respectively, which are always called
>> in conjunction.
