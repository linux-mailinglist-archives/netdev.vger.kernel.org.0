Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC2314997
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhBIHi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:38:26 -0500
Received: from mail-vi1eur05on2132.outbound.protection.outlook.com ([40.107.21.132]:35617
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229679AbhBIHiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 02:38:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+du46z5L1zRaOfTRHcvV94fIyQPevPuxebEx/T9VBJ0RPOuylqgwjM7rY1kE6d7TKYa1J0RqEuJm7KRdutRG2NMDym0jbq89H1d8YD5et+PGmHP+JbFnYo2y7H/c0XzAyn6Vjmk9bMl2w87qucssMfXUH/khPMDKmujOjxXbc5WqQu07Yev3Se2pQkVSCZ+/U/sn4QwktKKpgh05o1GCfOIW6WbEHDV7W2a9W/QS1e3vsezOH34pTEXADH9zQIamQyBFu0ZOkMQMqmyGeJThqtU+yhoRNYEjcKYIlyCWKiwQHfFOMZSLY3CXUfuuZVbjKvq0pn/74XiUF4R5kksxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSSkvYvqeXSIsacwtdc2eiwcUj/VHsVVDm9Cb6T9GHM=;
 b=CmrTL7V47PORF6SVfLiHIduEUvDWIEy6R4PlVBeF9WbRIvE18CBCevuAciQhOKKb0FFU+qSWgQaBZOwnRnOpFfsCQ4BQ+6o1xvUwXunKEXF6OQsJnSzAcu/Ugm9xkTIZquAyl47XWSnP7iEFB49PGb1CJIziNxXjvlMdHrn5ULogCl94m++sg30mKWFfQYh8/7rKtX/sL5hVXtJdmgqsRSVjYG+FW6Fx4L4tevQk/NHjp/Ggy1J+2lmw5TglecbKaeKRpJmawORGCWwzDT8WGsg8Adpb8laLocnFEZF2jBfXXu/RC0CgwaPHc4A4O3kR20vegDQsbjsJZ946Sb8nLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSSkvYvqeXSIsacwtdc2eiwcUj/VHsVVDm9Cb6T9GHM=;
 b=l4M3y//OAZjfDm2iVqccUVgGm+hXLEY44YTrpz/XpXwah2MfI7k4TJaO1lIn9bs2Qht0UiwWDEvTO9N5ExxQ1aycN9OBw2/IbET7yST4zZMYHg/tMJH4ZyuSgDZ1jfHvMiOnD95tgzlkVDY8K9RRbbMqcR/LPzhsjr/0aSYpTOs=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3732.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 9 Feb
 2021 07:37:33 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3846.025; Tue, 9 Feb 2021
 07:37:33 +0000
Subject: Re: [PATCH net 1/2] bridge: mrp: Fix the usage of
 br_mrp_port_switchdev_set_state
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
 <20210206214734.1577849-2-horatiu.vultur@microchip.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <181e48b3-54a0-5256-86a2-1f0d45e4b2cc@prevas.dk>
Date:   Tue, 9 Feb 2021 08:37:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210206214734.1577849-2-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0601CA0069.eurprd06.prod.outlook.com
 (2603:10a6:206::34) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR0601CA0069.eurprd06.prod.outlook.com (2603:10a6:206::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 07:37:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73e72902-2ada-4696-e6c3-08d8cccd9010
X-MS-TrafficTypeDiagnostic: AM0PR10MB3732:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3732239C23B956A5EF75D5BC938E9@AM0PR10MB3732.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RuaKdg5e02IgBrUDkm5V6seHe31un6fEkmus53YY4xf3gWTsCMxm5jKgbwDBYiVwW3kfkJ1EbBlzFkuJ3Qye4Kh6RqT9RnJZMB/WcnuPV4he5HM6V2GPilPuosUuU2d+OcMKRETg7t0bcLX4NXR/jusjC+uyvDFvNmAgBHE6/G4QnM41mBBQVJskzh+o7fCBm1Gc5zsurECTyyHmNdDiJYEmkmuJ63vxM2yL7ORkT9WOmh9296YrkxozBSWj/0Ob9xSLDx/w7c5TxnvBPBQS+rgpHIcwKjGgdXZsaZkVKswJsFo/kshJKTvDhhYkqa2+jEv8EJq/Ttd4bA5oAM2oAJFont7OFGT3UnVonAaZXt7OBgN7ak+zA5R5UkgHl7lyASHxAcNEKkvVWgP4hVnr3/XR5S/Dh6XTG0SXbJfAcAs1IZ9QM8CuTOwI0F8MVCB8eL5h7um9gb6ErViCdrh12BDmF6JNSXCYirSmcwUy6zJQV2KqI9Ir7eAA9j/v/AXLt8Urx3L6ijhLcxrVSbMf+7UMRJiXpggx9vC5ka/sYEUNbq8F3M/aW9zAYtSNuXLh5b4IarKrJKY5+u2WsGoKvBMrJXK3hOHGCx/yNehgoUBRNuZjdaKNvqzVhkpuDIow
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39840400004)(136003)(921005)(83380400001)(36756003)(44832011)(8676002)(31686004)(2906002)(86362001)(16576012)(478600001)(31696002)(316002)(956004)(186003)(26005)(66946007)(2616005)(16526019)(52116002)(66476007)(66556008)(5660300002)(8976002)(4744005)(8936002)(7416002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?OUqj99JaphnEeIVwV/XEGHa+RfLjYrt47uRky30ncCJuIabbCgzjqkRT?=
 =?Windows-1252?Q?Fs3caYS0JOwdupY+GKiuQ5vUlq0XBX5R8HF3419JNQZSfmpiLNDg8Bf1?=
 =?Windows-1252?Q?WJ7C/X9ZcQ//qMcGNz3by8uJ2k3gvj2dOluXRflOY36McwFaHE+gFrBx?=
 =?Windows-1252?Q?spXtyQkMVhxc/6VQvl7fzKrLg3vx2FIKJZ9RB7RwzvW1AUpHfbA3oNW3?=
 =?Windows-1252?Q?0CFkf2Npt0guiwgDPjiUVcnbVSfCg5zCC06n0a6cThPgqFnxzGo/LcjV?=
 =?Windows-1252?Q?uay8g7MMaUrH4DBIO7qFt+6hz4b4QbbdLKHPmUpDQ1yQq9v/GcbXMtTM?=
 =?Windows-1252?Q?/okqqJjpqAH04gjvTkibyZwsLKuE8gk8enDAdKZdYdFhdFf0Kq0FjHqU?=
 =?Windows-1252?Q?5+y/8ETYyfnJ2b1GO6rTEUIR3C5Klrj+/N43hg/hiJvBCz5om1tS8xjq?=
 =?Windows-1252?Q?BpLhYQkoQ9lu55FUj38UOJBLcH79/u6jCwzc0rgPWO7DO4MPCO8VgCi7?=
 =?Windows-1252?Q?NyrxcoiuEYSRUWjPihlSxcwYDvL4MtajB3f4FE5ETjjpcFzfuOQYlhaa?=
 =?Windows-1252?Q?X8BBHkNJHtwcadSV+VEB0Dq95pxL+ahqcoUU/zC29ZPjHd9EMyDZYk1J?=
 =?Windows-1252?Q?KG0Fk70+ogKBojM52L0p/YvYagoD0eKjlE2kRPM30lK7kYXmMCTzXHK9?=
 =?Windows-1252?Q?7BVRfWSpjTWvZ3vIb9SbA5O5y7mYk+300fVyp0FQnW4sbhPJovG4cYWh?=
 =?Windows-1252?Q?OSzpcc+uDP1TiaxiFWDYonwTunE6jxrrDyMhDRfbJAq+Z0nnhAjC7GjV?=
 =?Windows-1252?Q?r/2tjvJbjp5YdxSWbifYb1WzU/fXlNWQQtHXgSIabBrv9i92oofB7+aH?=
 =?Windows-1252?Q?VPqMcfwH6P9MLWgQT5+AIVqxyAKqF7qtAuSmJlFYbLN4MLQZ/9fgIg/b?=
 =?Windows-1252?Q?+J8BywqRXWzkaw54o9jR4zuObmFshVeeAPuABlHIM9OOCLmO2yMP8Sn7?=
 =?Windows-1252?Q?Ki8SwXsoLdB8THPZS+g2IJAKvH3cHLhPvGUSJ+waJ/mCG49jVwVJMciv?=
 =?Windows-1252?Q?YPbGUN4hym7+V84bzj6xI7vN6PjvGWLac+KgIWm5H9Ajgn+NVoFO2cNE?=
 =?Windows-1252?Q?wvweZ9I6p/JxdTfdjyZWhVsbFdtjjBNrYxvYKGg4fIX0HRsmeC6pRqex?=
 =?Windows-1252?Q?kWT7NWL1giK63WqTrbff26dX7HES+BQRdQWXRUZSEu1IeBFyOUdVZqzl?=
 =?Windows-1252?Q?yNSNXE+smA+JAASMcsiIUcsYEZ1t+c2qrzby4SPKCCNQil5vEaHNh6PP?=
 =?Windows-1252?Q?oXkTcf3FNzEd5ggWHA0HAlNBeLoquqwj1kM3DvrMkBi4+vDHvpBA22TN?=
 =?Windows-1252?Q?uImOuzMSOpcURkgHwXuzlu6ERPOwo0Okr/psn4HSwG7ByWy1bEORlaiV?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e72902-2ada-4696-e6c3-08d8cccd9010
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 07:37:33.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzPrVWHAfvwIM0FxdMf5d+9IdByssIDROfRP1EwcW1tJ2HIDSCBAgKsG/rVcjiZszo647VbFRHptSM54/G0iqZP9NpY3TqBWyo1JMDVwTu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/02/2021 22.47, Horatiu Vultur wrote:
> The function br_mrp_port_switchdev_set_state was called both with MRP
> port state and STP port state, which is an issue because they don't
> match exactly.
> 
> Therefore, update the function to be used only with STP port state and
> use the id SWITCHDEV_ATTR_ID_PORT_STP_STATE.
> 
> The choice of using STP over MRP is that the drivers already implement
> SWITCHDEV_ATTR_ID_PORT_STP_STATE and already in SW we update the port
> STP state.
> 
> Fixes: 9a9f26e8f7ea30 ("bridge: mrp: Connect MRP API with the switchdev API")
> Fixes: fadd409136f0f2 ("bridge: switchdev: mrp: Implement MRP API for switchdev")
> Fixes: 2f1a11ae11d222 ("bridge: mrp: Add MRP interface.")
> Reported-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
