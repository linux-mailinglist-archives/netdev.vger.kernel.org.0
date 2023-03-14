Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45B36B9980
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjCNPgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjCNPfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:35:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006AFA7A88;
        Tue, 14 Mar 2023 08:34:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhJuZQW2BGhv8CL/2tkuyKaPPhH1UltlN1//r4/QdL626+VE19ArroC7kH5gXQgHP4Mv57oxE7YgHRJuucCqstaFJjdP63VHNwaa62arvB0J7iDev8r2RmJR4PfilB6bKkf7ZqjIoE1/ZER+GjBHcykVIyO6J47rOKq0MV5tmgHM2WLMcf8ednBGJ4b0KpXPpXyuKZ9DSPV6bFZYWzIwxsZunWemkV8w6TPWEcG20B0GtdfSkC9WbiQAs0Eh0eyL6sm228VtXeu5qsXXS9R6WIisol9k6TeMaN7Cog6XzBn93tZSzqw+/IZFOgqiFMQygZD5ZJojbOrNz2RSA5mmkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFNsUTpSnm8yKzHPY+fp1Yf0tpPUua3q34AWIRnHe68=;
 b=l5dOEarKwAWmNZUiO9eF7NjmDryEXzf5P5UvnOYWFT2bTyG3hGcjJKm83DwZwGQmcwkfXqUzq1EonD2wXI6czwowZG5/1P/sQpcbaTE6xJkWG8Esnqi8P8z6gYhMrv9LeKntAu07bik2jUF0mZIsqzsYP8G+LDyNtPrhIBQWHbJsV+o8GCktKlwyWM+vBR5GGhoct2HR/Hev+nuUr5uBBQdCfv3bZxkmancyLeUKAgqDw3Xl/vAML2+yFMv8LxOl0AVIZe3Q/+CAK6PUIbPvvpDFtfNK+aAnnwDt/MTdyiUcnWG6ZJBQF1JU+hJsU3ahmAHnQ75vJMgm6hfDh2SlWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFNsUTpSnm8yKzHPY+fp1Yf0tpPUua3q34AWIRnHe68=;
 b=aoJBkS7xAC+NVQ4Z3YJmrjBL/jjnqPzb3ceo4BGi4/wTR9KRdbKCiDi/lK24od1VPgZFo6D4eBmmMoSG5qvY29aEH6GiwgS24YbFAn2C9EPOWqD3JbNx2PIEahdn/Tw0xP7sAWILsGlQc+0Dtdan+8uW949EHHrWPSaLqic0fYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6395.namprd10.prod.outlook.com
 (2603:10b6:303:1ea::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:34:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.023; Tue, 14 Mar 2023
 15:34:14 +0000
Date:   Tue, 14 Mar 2023 08:34:10 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH 05/12] net: dsa: ocelot: drop of_match_ptr for ID table
Message-ID: <ZBCT8iB/vzOHrv3B@colin-ia-desktop>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311173303.262618-5-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230311173303.262618-5-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: BYAPR11CA0100.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::41) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MW4PR10MB6395:EE_
X-MS-Office365-Filtering-Correlation-Id: 438cb48d-ffe4-46b0-a471-08db24a190e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8sSijxcdflSZqi4NlrtXgBgI0LDf9YavIgYFuKv4sZakndck7EIMvhr+d7HXfKV5VFQ37dpkx/9VeC5eMQqyk42YdgPdpivj3nMBluh57KDtEMJ32/RIIqRSVDymaJQSEiHf2wlmzxQfkdVnLqSzkq2JKoVOYMT/S1jlEqRrUsK+A3Kg/m3/cwZbAOlXdxAl3xjVFIZNCHRjuZDQCeLJq5lIFL0gvZOSmXnM8hM+ryQgKNdbF5EypCdNeQDhDj4uqyr9U6Qvmh/y9AqDXVdxFOOevkmMqqWl983wKivDZbUBl5vdlCWYDeI80UxPdXG+CgLPMjY0hRcjJwgXhjHK533TDV05n8L2DDY3B2NoFHPganfPIy/QKxSyHwKeJr9uJYT04li7q//+rjzZ6fr6yIT4+P8xn6fAsfc692PHi796GFIO7JRgK4e5JQKQlwQNSPJe8NyFJlgTe90aE1rtkkTh+9jSZjTTU/sfLvmQa7cYwzfmksL3sKZSc4tuzRhmYd5aEySY/hyQExymWJimzCl21HBNpOnzFqddcuoRk9+0kaO1vfwCvXNTgo2QXyvJ9YlrsTUiKjOz3jhEJXlkRj71ZYDaA2Ai86UzbVMDL8QXrvReVsy9tx7pIzdmBoDJGGYyWg777ABfqWkJ3N15ZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39840400004)(346002)(376002)(136003)(396003)(366004)(451199018)(6916009)(41300700001)(5660300002)(9686003)(4326008)(8936002)(186003)(7416002)(6512007)(26005)(6506007)(86362001)(33716001)(44832011)(2906002)(83380400001)(6486002)(8676002)(66476007)(6666004)(54906003)(316002)(66946007)(478600001)(66556008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aURhNzFBZTZlTDZCWTlRRFlCM21IYjVlU1ZncENMVlVKQUZQUVZoaHk0TjdX?=
 =?utf-8?B?eFR6aEpwbEJzOUNacWxPWGVMMFFGUXEwaG15RmJmT0Mydllmc0pETzA2VWYw?=
 =?utf-8?B?ckRuVGc5aXY0a0NDQkFKVUx0cDA2NWdEbDEyQkJWME9hY2lIaEZ4a2s1cVVp?=
 =?utf-8?B?T2hoeWN5d0pLTjlOSFJYRnoyc0RibkNuVUF6c09pOVlJMm1iZytYK1ozVTQ0?=
 =?utf-8?B?ZEFRdnNKNjZVVHZoOGduTytxWDZGby9pM1FacWpYQ2FENTc4VzlsMXMrU2dW?=
 =?utf-8?B?YWZha1gwR2VYajVibUxiSVE2bVY2TWZRYkNQY3d4L3MwSVBxUldrOG4xbjZF?=
 =?utf-8?B?SDBzdlMrVzZKWUJrNGdrNVVhUTRrY3RmTmxzSFgzSm9Qc1dhbWdjTE5hemdR?=
 =?utf-8?B?SFVhb3YrTWptd0VqZ3VEYTY3NVdheUJPVm1IREw0TWl0Y1lwN2U2UG9yU3Fm?=
 =?utf-8?B?NUhZbVZhQkdqQVlJbkxFV1pWb1lueno4Y0dqQVlNL3dnVmtpVjRjWWFDL3Y1?=
 =?utf-8?B?cHc4MjhEUjh3dGdoYnA4ZEdZNlRjaS9HdHdpWjdlOGxXdWF1UGM3dUpYcFZa?=
 =?utf-8?B?T2FYRFEvQ3cwd0Fwcm5OOGdYclhhUHVmYm5GYjcxNEJic0ZnZVJJM2hpUGNB?=
 =?utf-8?B?ZC9hYUtiTE9idFN5K2xlUnoyemVXYmlXR0tlZ2Q1QjFRekh1Qm9LcnNFRjJi?=
 =?utf-8?B?TzJycENWOVZ4TVBPTlU2ckRpZmFJUWc4RVJoMEVKaDN3c2J2TGlaU2FNclNF?=
 =?utf-8?B?YTB2T2Z0a0VYbXdORS80Tk1WNXpoYjFyWXBkYzYycnVpZWZ0dVZHeExhdXJ4?=
 =?utf-8?B?dHdUdUF5Ukxla3F1emE3bkhqSERjSXYzUE1ibTI2Vlh6Uk53ZjdFTEhxYVFx?=
 =?utf-8?B?d2hFV1A5U1hrbzhiWFl4cHVXUGFCM2NCcEY5ZFdSaHVtdVAxVjNqR1FZQTVW?=
 =?utf-8?B?YXJPZjd0S2VFVm5kMXNoOS9mZ3h3OU9hS1lEcnY4cWRlUmFML2dHTWVPR09r?=
 =?utf-8?B?Z0NFeXAwaDVoMk9tVWxMZDErS1Z6QUJHS0c2Z21BVHJ5cjBZMjJmTzBJSlBW?=
 =?utf-8?B?aDFWOXhPeTRDZmZnYUlMMTF2RVdxdHZoQkpIY0lPTmJsenRZYjdraERxZVMr?=
 =?utf-8?B?L1hjZTJqWm9qeW9DWmg4N3B6ZHY1OEJ4K3pDYnNDN0oxb0xFVE1JNjhERW01?=
 =?utf-8?B?bGQ1YnhoQXhVSDIxNHVSUk43dnZmb01KVldYRHlDWVJ3L3N1RTZYRE80YkRE?=
 =?utf-8?B?TVoycHluaFF4NmZTNnIvMDJoc29BRHdHZFZ3UU16dlJmdUwraEFLNG54Nys3?=
 =?utf-8?B?NU84TmgxRkcvQkpXNnpqb1l1MVd1dys0eTVwVit6Sit3WGJueEJpa2RyVW5T?=
 =?utf-8?B?V1d6VUZETUhmTkFWZ1MvR3poKzRxTS9GVllQa2tKbzZ5Q1R6SitEVEtZa1o1?=
 =?utf-8?B?MEJnOHptMlB6dTNEQ3d4NWNzVXdzclJ4ekpseUhjdVpGbUxkNTdrcWlDWjJo?=
 =?utf-8?B?QVo5VitlOUxsQXdiNCtyMnNqK3QxdEZ4cng4ditndkxTVHFIbW9FZW9USEE1?=
 =?utf-8?B?enluaEhLdFhUZVBlUWVZY2kzSXdNLythYVFWdEJVd0o3Q2dqbGxOY3FMOXA2?=
 =?utf-8?B?dCtlVDNkY0hkWjhNQ2pGaDFRckNkNy9JMGphTjJQT0hVNzlVaFlNSmxEQ0xv?=
 =?utf-8?B?b2ZsVTI1elZiZzZhYU9DMG9lNmltNHZ1ckNUdE1GQWdZYXNsazJtS0k5ZDJh?=
 =?utf-8?B?R2hDcjJJKzlpTVQxWlNyTU5UZzB1RzZYMWJvYVhlRVduaWNvSTRJNDl3cFBp?=
 =?utf-8?B?bE1wNjJKbjBHZ3BLc2NEcUM4amt6K0ZVQ2phcVIyYzEzMzEzYmNVMUQrU3Yw?=
 =?utf-8?B?T0YwVzFKRE9jY0FwQmJrbE1sS2tneldrM0FmSHcwRERQdCtBSXVOTExzWUE1?=
 =?utf-8?B?Yk5Gc1NRN3R3MW1kVFFHb3QzU1VURHVGOHFKeUlNUnYwSzlUbHZoUTF2cURG?=
 =?utf-8?B?VVpNYnlSUjdvWW81dlQ2aEhBS09KRk94RzdvcHM4S3hTenlnWVdXZEY1Yy92?=
 =?utf-8?B?ME9ONnRSME1yNG1sdW93Z0ZLeUZuZm9EVUNXTHlSSDF4U0ZlbkdNQkNXNzlh?=
 =?utf-8?B?TkJ5RTYyL0hoSXlwSmJYc1d5eTB3VlNVRzd2WmJMd0M5RWtpTG5lQmtHbW9W?=
 =?utf-8?Q?Rp6Qqr5fmeWw3G53sJR80eI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438cb48d-ffe4-46b0-a471-08db24a190e6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:34:14.6019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6947RnQSyD/E3WPnhHitkh/UcB8dDpL1pX/VM8zixYpyo8A8PBcx2Y1sBuvRgunXIzjLIauZ2c534C5MQ+MyYjLkQI50hGpCZ7BT1AcGYtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6395
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 06:32:56PM +0100, Krzysztof Kozlowski wrote:
> The driver can match only via the DT table so the table should be always
> used and the of_match_ptr does not have any sense (this also allows ACPI
> matching via PRP0001, even though it might not be relevant here).
> 
>   drivers/net/dsa/ocelot/ocelot_ext.c:143:34: error: ‘ocelot_ext_switch_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/net/dsa/ocelot/ocelot_ext.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
> index 063150659816..228737a32080 100644
> --- a/drivers/net/dsa/ocelot/ocelot_ext.c
> +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> @@ -149,7 +149,7 @@ MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
>  static struct platform_driver ocelot_ext_switch_driver = {
>  	.driver = {
>  		.name = "ocelot-ext-switch",
> -		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
> +		.of_match_table = ocelot_ext_switch_of_match,
>  	},
>  	.probe = ocelot_ext_probe,
>  	.remove = ocelot_ext_remove,
> -- 
> 2.34.1
> 

Acked-by: Colin Foster <colin.foster@in-advantage.com>
