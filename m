Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7842CFF46
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgLEVgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:36:10 -0500
Received: from mail-vi1eur05on2114.outbound.protection.outlook.com ([40.107.21.114]:40705
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgLEVgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:36:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhNap0cufGs7eiwqpPt7IyvXgyNqQ2eVGKZSbyKs9BAR/2nlNCFjRnSg3eRx7rEbbDpWQHbUWTXibhowEJC/t4sT34xs76y8trncK2XHUpC74YJehm/1Lnr0GLQ/bCmv7ZioUdCEZmo40iPgsscxOQv3o+jvEfSaE7zfizYpUMYuXirFwSuVgxGFzbir6iUDKz3ona5ZINdA4OFAprCQo0iqgxaU9mZNy7IeVKvQcdz3Yc1EcM40n+g/nKDukVfp+dr+gZ2nl6vEeGKn9+HnlSPtuC+EvvL1cPfdbJdntP7hAQKiDdV+s6QmwASb9NOhbiyRjqBhJ5qSkl/HzZxohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKmwu893nNVdUNAcIvo34IQWBqWCn1Fe06QZafqij4Q=;
 b=TcRgTWQKhjVXSsN7xZorwv2lZVQn3wPfkF77TYrbd7nNwxdiLP8v75kOcZf3l6eVB/046O2RSik6RwTZuBii7UmbaMCoVIhp6UYzc8N4TkwjVRpSGrSkFZvrDwl9Gw/jzln04cr8PT7juCIex3R4D2kYOIJkWzDT/wiGlmAEwp+ezPePNNws7XGSh8KGtjF1BDPPUcvE1dSnEElZF6hDy4bdAoSMYAs7/7oae6sNPTJJzdksaLP1jjfXcf8bsbNQDrfCfV5wTMh/MUOMrXgVXzLDKC/nBI3lW8m6ChoWl9PWDJ+b5Li+rHKm5PC045uigA33dlDcpA2r4tiE35RVtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKmwu893nNVdUNAcIvo34IQWBqWCn1Fe06QZafqij4Q=;
 b=Uvvi/3QbPszUVpc+3iQiyh+RQ0f4tUVxF60qtlau0z5PdUa0zSzMFma1hXqEQbyyjFeS8rVTyoEeeKA/A46wHuNQiKaCG9iIm2SGZpPhh5cnhYtrTQLQPf3Fc0ooZdr0e7avRIR3Qv+dM0b5MWjnMNnEbLoB5XwhtzElMYKRMNc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3171.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sat, 5 Dec
 2020 21:35:20 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 21:35:20 +0000
Subject: Re: [PATCH 11/20] ethernet: ucc_geth: fix use-after-free in
 ucc_geth_remove()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-12-rasmus.villemoes@prevas.dk>
 <20201205124859.60d045e6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <4d35ef11-b1eb-c450-2937-94e20fa9a213@prevas.dk>
 <20201205131928.7d5c8e59@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <15915cb7-45bb-f62a-e603-0250053b7aeb@prevas.dk>
Date:   Sat, 5 Dec 2020 22:35:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205131928.7d5c8e59@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0083.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::28) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AS8PR04CA0083.eurprd04.prod.outlook.com (2603:10a6:20b:313::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 21:35:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db4ca50a-6b27-431e-6c86-08d89965aa6c
X-MS-TrafficTypeDiagnostic: AM0PR10MB3171:
X-Microsoft-Antispam-PRVS: <AM0PR10MB317132C276CCA3352F896BE193F00@AM0PR10MB3171.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bz7DRNPdIkDojVJWiacfuyn8CfX5kOdu70sDJmLKyOsBEcwfwpXTe8tVbAsQedNNy+xLhL7zVm2uxfZXNGEcniKH0VpajYQAmBv6xHGD5k2qPE+9p9RJoimKNYsvIQ96qmQBOTnFJ0UbzUyuFOAMUrVp7o/w1LmVGQQENx6Uq19bHd4zgtVpCBqohgO5Ow7Y1RgB33ckJjKyS44MjPBWl/a9WpBU0vpxcwVhq1WLdAcrGXz/gt+rORRKR+47pifT8sF8AiBNHPMaQ9pGgm/Tc7xMywCfqYxgMUhqJF40h95sDj8Glsr/W1S8qzNzCFoSbkOIme0AcqfdW5DEys5BNVtUU6VcT3je89DlGY+vlixDPj8zbf+wc3o30A7R/5Z1wC2Enwxv1z4Mn847xaFIUUK+0iRs1i1py7VUGMJdA1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(346002)(39840400004)(6486002)(2906002)(16526019)(26005)(186003)(36756003)(66946007)(4326008)(8936002)(8676002)(8976002)(478600001)(66556008)(956004)(44832011)(52116002)(31696002)(6916009)(86362001)(31686004)(66476007)(54906003)(5660300002)(316002)(16576012)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?s4mD6qI35JMx8NXseHqFlJS0wrntkg3AKSwRmp/JuKxIrmXiWGXQMuoD?=
 =?Windows-1252?Q?z9Bkj5PNDYKmX3UF+qezfEYjgnElIhnjOqlsmQiUNTB3U6/lf38+1sPA?=
 =?Windows-1252?Q?esO7AbaBlPJBdndfu2EdkXyqWk00ekVmENK7mRzdBCCLmkgwxAe/5SUk?=
 =?Windows-1252?Q?Dq4WSTo4BpfVvzzs/YQe/V+zW0+P5hH7tGPvq/LWKMZ+QmrzVB94AH3d?=
 =?Windows-1252?Q?M9WbMarzSTVH3p0BQODzsFmzQpwRX0XrJEYS59T9+fewPA8JKhCjOpDn?=
 =?Windows-1252?Q?HZN7Se9fKCEmyJ3VcXmnei//DXKMpdEkGV+xp7EGmMO6ALJ4c1BduQc/?=
 =?Windows-1252?Q?qHqXl280LUVfgPoBbfYO9/vwGjoHS0wS4X81ksIk/Sb2A7C4VMcR42J0?=
 =?Windows-1252?Q?2v8JEZnVTLg3US9owmBQTYlncQKrQTC67r3m7mURap1DVunGSv2uZOt0?=
 =?Windows-1252?Q?DJCZl54gnMYNg2QR/7Nk7l9EvS7rp5WtGefmxnyAe1S76R5yfkSSjyK2?=
 =?Windows-1252?Q?25nN26B7RUjcsosCr8LG9gWhWr4O/BDZ1+iZJnZcFS6Nps4MFXsVBEhR?=
 =?Windows-1252?Q?trEOu3cLi3cF1PbOo6R9MZtsayvaerRMfsSgbPn+Dv3RZiMcY6mNcBNa?=
 =?Windows-1252?Q?5BrjDftWgcCXGQTyS8ykFEWCmnuCLhR89gFQZVpZxQa87u0oiD6G4Ay4?=
 =?Windows-1252?Q?9vsb6j41HlVcph4SaNC+Vtyt6j0zgPhPbsrZdYaea1SW/Sl3CxiOmiuM?=
 =?Windows-1252?Q?Iw0t3rRT1We6AZRWHEF6RgYxqxfgwwpP196qrIHxqcHBRg9pxQdKlK5E?=
 =?Windows-1252?Q?gvwr9czZjdydtS3qzjTqGsIkJaT4/Qq8tWpdr/HEnNczPzJLc99Fb0Ic?=
 =?Windows-1252?Q?KW6hzK5znVGlVciIS5+YUx/l1mX3hTV6YWLYy4MhHvh4Js1eJmTYSYnp?=
 =?Windows-1252?Q?W0UP0W3a3mS7Itvd96ug6JQBqLD1wYGxoK3CSPUS9ve6D4Kuz9Xh2wTn?=
 =?Windows-1252?Q?Qx4JeFjsVD/yF7BfxTNPPyr62oYS3uJclGELQpA2gpWFKtzCKnHLy0lg?=
 =?Windows-1252?Q?IMdIpvIjtPKD/nMk?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: db4ca50a-6b27-431e-6c86-08d89965aa6c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 21:35:20.4923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqBI2mZqILu8wRhx56eLuyII519VoiIWrp4KjDi1WZb6lMBxoMoD9QLe8sf95TGQBib1pmvyNNDPGUb/jmJQFYxbBV4kXiWtZ+UjNHgFPSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3171
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 22.19, Jakub Kicinski wrote:
> On Sat, 5 Dec 2020 22:04:28 +0100 Rasmus Villemoes wrote:
>> On 05/12/2020 21.48, Jakub Kicinski wrote:
>>> On Sat,  5 Dec 2020 20:17:34 +0100 Rasmus Villemoes wrote:  
>>>> -	unregister_netdev(dev);
>>>> -	free_netdev(dev);
>>>>  	ucc_geth_memclean(ugeth);
>>>>  	if (of_phy_is_fixed_link(np))
>>>>  		of_phy_deregister_fixed_link(np);
>>>>  	of_node_put(ugeth->ug_info->tbi_node);
>>>>  	of_node_put(ugeth->ug_info->phy_node);
>>>> +	unregister_netdev(dev);
>>>> +	free_netdev(dev);  
>>>
>>> Are you sure you want to move the unregister_netdev() as well as the
>>> free?
>>
>> Hm, dunno, I don't think it's needed per se, but it also shouldn't hurt
>> from what I can tell. It seems more natural that they go together, but
>> if you prefer a minimal patch that's of course also possible.
> 
> I was concerned about the fact that we free things and release
> references while the device may still be up (given that it's
> unregister_netdev() that will take it down).

I guess you're right. I'll fix it locally (and pull the patch earlier)
and wait a few days with sending an updated version to give Li Yang some
time to say if he wants to handle the series or not.

Thanks,
Rasmus
