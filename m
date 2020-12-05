Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438E82CFB99
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 15:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgLEOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 09:51:42 -0500
Received: from mail-db8eur05on2123.outbound.protection.outlook.com ([40.107.20.123]:43296
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725922AbgLEOus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 09:50:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq0/c2vX6JahelZ0vUOFXMdeGDOTyOTu5RY46wJiVS/ve7ThO8rXhOjALit0PLpyZGiqIrI8OdL3/T76B/vAzf9KXmnFonx7qEbbFVNDhyMo6oKzTToumAkA0OWrpVXear6bS1NA7yQPL2ZN7rW37POb7JPCqDML2vHdCVoquCjRj1hBiccOwyOrL6g0MbMein6UAUeaG2S2rrp/juZxPsVSHPlYO0Ou/EKl2PgsJECPnF+C/f2s5SX/yYn8TnDpwFCBL1ya0r3Tzs20ycA6suVeebA5iu7j/jqWtqVRJCnYITibku5nM4Nk3o9hNtV5m2WLvwgI38JK1kr06IQ1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7+FEa0tz255nMFYMeELu8rj1gJP+2BOhbX9aMfcJWk=;
 b=YPCJ9ehxlXCBw1oam6sdh0IEN2iKU7FLdgZW3Ocb9oPGDFTT+Zqao8viQGKNnSfoYxc+JemZbqWNGVh4Mq98Ua+soKSXKY7v78UtyY+lSkJ6SjPSiYC7I+aAd7QxcGyiHC1PMAQ/Fhzr5rSGOYKRMPuiOKyoEWGXqeoRTG8ZITiiJTNUVtFS3iBaq7fyyJcJ820Jx4U/1rj6YbU43JqxdAGQOZL/C5u3Q0F0WF5N32psnUME2SzqM2QeKwCX3R5Txz3jR3U3on6pNQfuwH5RUUZpi+DdeXjSkWCQ1uvA2Hn8+yWvLs42MAO34UPoXJK4cBdCVxOAVfsWdbEYU1jAkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7+FEa0tz255nMFYMeELu8rj1gJP+2BOhbX9aMfcJWk=;
 b=SMOLRV7Y6LxQIpigwiqUD/YvYoHUdcF2BoAa2MjZ+D+whRo3d1wjff1CJ7xMt6bWXyxyLdsmntZ6dlvT+xBvTUWV3xm0IubQuIT6XjodUf5LFMr2XLkd+bp/TVMk7630sAQh55sqHkkQ60UUZPsTZN1rmhYyTk37ccJtq4gb3p4=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3330.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 14:49:04 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 14:49:04 +0000
Subject: vlan_filtering=1 breaks all traffic (was: Re: warnings from MTU
 setting on switch ports)
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
Message-ID: <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
Date:   Sat, 5 Dec 2020 15:49:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P191CA0098.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::39) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P191CA0098.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 14:49:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8202c50-b458-4190-d248-08d8992ce8dd
X-MS-TrafficTypeDiagnostic: AM0PR10MB3330:
X-Microsoft-Antispam-PRVS: <AM0PR10MB333048FD24DC1CF44B1B763A93F00@AM0PR10MB3330.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7S9B/gFZayL9qL/0asylQ8bFwXTm0R2+rLYU5QLrRQQt05UPKh9rf4DBX5H5/E1KH3ZQgV8gdj/33r9sinJkcPzf5eejTqpCCunW49L++F7yHs1vo8JN92KoadBd1FjQn9HGnth6D41si4OG05eUYNFM4oZj4zJqy+fdzxIHLzOUSJl7xC5EFgVgYZDshliH0XzRFVGeGuxiz/TIZNtmm5sRmoZ5Q8bOZedRQdit8EkZHWplsv02VLIE/Pky/6bqyZeyNnWIUSMbXDtKp5/D3oig4ZpDq2ztYyOzFR5IKrXLHKEdLRDLaoqINbUNjFj1lVEp+hWfsGTq+JceZIuhNhPl8M72EOPSKqtc5KT0YCD+dJi8Dw5ukD83ZVrEN4SQZWUtFcQLLWQVweY/RPdVSA4GBbo2PtJjS5nZ6hI5+hC6XjTS6LwlnKtiujIZj4ayFJwDTOk6skG88099dYYUqWdVVzpbOsfr5k3kymuLEK7S7fm0XRX96Nxq5gHbTWq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(39830400003)(396003)(346002)(136003)(52116002)(8976002)(8676002)(8936002)(16576012)(54906003)(316002)(31686004)(26005)(36756003)(83380400001)(16526019)(186003)(6916009)(478600001)(5660300002)(956004)(2616005)(2906002)(44832011)(66556008)(66476007)(6486002)(4326008)(31696002)(66946007)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?/8Rc59BD1tDSsnri+bUZuXc3JwChbyyO8Gn9KS6CrzoR+UQxZrnP0If7?=
 =?Windows-1252?Q?WpqBBKIe+OlSQ7yKSTXNa29fKDNYcDI+zlGdRikU0zD9cMnerggeHQaf?=
 =?Windows-1252?Q?12jp7706uO3sH+JSnbDm4U/B06sd6oGW/NsmqmCerQLr+bshbpUqEYk5?=
 =?Windows-1252?Q?CgTgHUz4u6TLqAjELWQ4cZuDbn4MIk/OikiUIbwoQbWDvhzEco93gAk3?=
 =?Windows-1252?Q?J1ePI7lejEfwP+Nvz/ZXLw5bR08E1M+RkC5tMIq7X92hpSo6H8P05IrZ?=
 =?Windows-1252?Q?tvBpmt/YbbciQ9gAxLVlho5reAcJiTsy7HX9dkcTt8MR9hJrCgNpWWFX?=
 =?Windows-1252?Q?n6kuAGT+lDxG6V4TTzaoGHabyLfi7kyU+l72chvHY/EHZ/KTT/tQ3u22?=
 =?Windows-1252?Q?keXQhmnXAUhHvMp02gzc54QFIa+wXKPzdRq412pXlPp/S22kcHnCP/Px?=
 =?Windows-1252?Q?jrrpNqRBfK8V4pZudD4HBxe8lVsgZPgW35NiO2Dpntzo4/OfkVaeyDr5?=
 =?Windows-1252?Q?NWuW9+Uo+SWeQ9GvWjCYu5fIvCoBOFL2lmwCgDUjWFlRA3Z3XbBo8NIT?=
 =?Windows-1252?Q?beiogG/xH9N8T3JZfPqtlGDCrhMlOy7Pc9POmkS21RB8EXmEaSqX24kC?=
 =?Windows-1252?Q?bdqc2ohpdNyeOZ+9hM3hjrnnCujFrXe46gvJxVkCNxqirg01hO0Vgv96?=
 =?Windows-1252?Q?ewNTDHytXCJOdtpttYrp4wvQKjL0a7YLvK8wdX/uDFVvtHWBH1Me//cA?=
 =?Windows-1252?Q?/j6OG7SzC0002DkLi1BfaAjmqe8dCDWLZsWPi1V+5T995QAFHoTeusnJ?=
 =?Windows-1252?Q?o4V5BHiYg9T8bNq91T6i5I957U4aQ2vEFh7AcMcbEwR4LlaywLtjeX5c?=
 =?Windows-1252?Q?WnGp3lzhveU79vHviAogeo/Xbap7o1pNljfgevzax8WO4ZoZM5owSGo7?=
 =?Windows-1252?Q?iD+Y3OFE0fHI5+aK7M3f6jzQn7Q0UwcffbKnEeGekPY/94T3tX3jIVum?=
 =?Windows-1252?Q?2WwnrwXB86lx5Q5FyhkD+odSozMx4bNbirLkQuF+rBPrlg6aVxW2Ipsb?=
 =?Windows-1252?Q?tUgsUs9h2F47PBw8?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: a8202c50-b458-4190-d248-08d8992ce8dd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 14:49:04.7051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fE4kVIA41nHPQejU5ljcYSmn5BICjKjoqPe2vEYVXySz7v3usC18+Tl+FMICch72jig+8XgOgKH0iD3Bs4+KA0cvLL59cjEF0hT7AgHHn88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3330
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2020 23.13, Rasmus Villemoes wrote:
> On 30/11/2020 17.04, Vladimir Oltean wrote:

> Thanks, but I don't think that will change anything. -34 is -ERANGE.
>> But you might also want to look into adding .ndo_change_mtu for
>> ucc_geth. 
> 
> Well, that was what I first did, but I'm incapable of making sense of
> the QE reference manual. Perhaps, given the domain of your email
> address, you could poke someone that might know what would need to be done?
> 
> In any case, something else seems to be broken with 5.9; no network
> traffic seems to be working (but the bridge creation etc. seems to work
> just the same, link status works, and "ip link show" shows the same
> things as in 4.19). So until I figure that out I can't play around with
> modifying ucc_geth.

So, I found out that the problem disappers when I disable
vlan_filtering, and googling then led me to Russell's patches from
around March
(https://patchwork.ozlabs.org/project/netdev/cover/20200218114515.GL18808@shell.armlinux.org.uk/).

But, unlike from what I gather from Russell's description, the problem
is there whether or not the bridge is created with vlan_filtering
enabled from the outset or not. Also, cherry-picking 517648c8d1 to
5.9.12 doesn't help. The problem also exists on 5.4.80, and (somewhat
naively) backporting 54a0ed0df496 as well as 517648c8d1 doesn't change that.

So I'm out of ideas. I also tried booting a 5.3, but that had some
horrible UBI/nand failure, and since the mv88e6250 support only landed
in 5.3, it's rather difficult to try kernels further back.

Does anyone know what might have happened between 4.19 and 5.4 that
caused this change in behaviour for Marvell switches?

Rasmus
