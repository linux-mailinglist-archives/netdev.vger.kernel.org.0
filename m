Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC912CFF0E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgLEVFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:05:19 -0500
Received: from mail-eopbgr30133.outbound.protection.outlook.com ([40.107.3.133]:42967
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725270AbgLEVFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:05:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4VKsxTez0ahwiJWT8n1EJ7QbDLny7Wtrn8FNMKXfRauJHTS8OY8eC+j8sAcGRqu15g0rgNc0icfomdqNL1zPMtoRFDU8vuCpgejIoFyOGV0LSAH4wWfm/VMgoTZKfA3U6C27di4jDOoTBaMr4i9jIvwD+VaooUilansKOkHOVwRkrbNyREDOFeep/9u84sOFBq7lXTmYNvUt56l4/jXZqwoOvY6rt/aVDeddb+BSv0RaAQwa+8FznxeakR1GVPWgVmZ76/Eayjv2k2ZcNV+iEVj5WFycdazCW0Og5cIcY51kROwRWWnjW950OiFtQIO/zHIUe2SWiBnoWlRVh+7xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zSmnppYM72OQiJR8CHbFiXXNBwHH9lQdWrvMuGHSpk=;
 b=ZRmX9Q5Bvy+129oY4EO60QnaTTCegs+RllUTKkRmrqMhoaDksBWvrUBeljli+OngXFOVnqb1HpwoAfUNcNLprZb4LoVzFkaF0/Rd6zSDJxswVRqX/HypCn4SN4w3qS/f0MkCupcvBVPAxRCvKs7nLSR6KX/Py9i04KQMDiRo/2hvOYV+HMLodxaafU61wnB2eAT6D40YgxUXWFFptkKby9nWgptRQEc0woJji+6eE8eMS7MErV1VqnYrbbYFKvCyyeLRKImUZK1lJkbrg2b2P6XWRdhqAnT65yJnffINunhdyOF3FcSCyNL2EokH9oOmOUZQFSew03B5PILydIfvIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zSmnppYM72OQiJR8CHbFiXXNBwHH9lQdWrvMuGHSpk=;
 b=cX28HdP4wo9Y3g04sLx3/56yCfP7p0MOiANSsLVGBc/05jTHgYIXQoVHpNLqvrcYd13cbXy26yqxhV87hRHF080uICo5CTPFPTmwGex5FfsFtGbeJuvVAeQ41igxAeulxYImpXmEXKd7xOkM+QwGtSrjKNIBWsCapeIGfq3ipNk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 5 Dec
 2020 21:04:29 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 21:04:29 +0000
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
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <4d35ef11-b1eb-c450-2937-94e20fa9a213@prevas.dk>
Date:   Sat, 5 Dec 2020 22:04:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205124859.60d045e6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR08CA0040.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::28) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR08CA0040.eurprd08.prod.outlook.com (2603:10a6:20b:c0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 21:04:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20a8062-042b-41cf-3633-08d899615b2c
X-MS-TrafficTypeDiagnostic: AM0PR10MB3252:
X-Microsoft-Antispam-PRVS: <AM0PR10MB32525A074C9EB579EAD89E7393F00@AM0PR10MB3252.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThGVKxw7q0fHdfvIoOEy1N8A2xsVc+bGjIBW6hnkv8uPk7qYpHqaWwLaXcw2D3XltqfTNKdAQCa2XxTyZMC57KCgoFmgo+vxFXYDb/g1+n6qDfOI/TC8B0OdEkJnLhXW+gOrYyZfF9fnr2398nfsjZLtKyvycLxxvW+emQPDY7qzuTb9gK8tNxhKpDI2bl9m89m8PRUjIm7P1hvKb5VFAyQ7owlKybLl6sVeekdGi65tuCJcIjddBDTrlz7zkzG5FaIwVvnvmO8g3Xkf+rI3d5FgKX00hUYHPI5Nnk1BuNGEXEI6xrCJhd6wAtkQ8NoUCnNW+vJCsalJqPDK2Sko3xOTN4+NmqxHIMK7aPvQSdKfDGqW73wkUg96GMpHXNzgxULQng5DOBwr5GX1raJ0VuPNVyDcl4attZ1cWIVA17Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(346002)(376002)(366004)(136003)(396003)(31696002)(86362001)(956004)(4326008)(66946007)(66476007)(66556008)(8976002)(8936002)(478600001)(26005)(2906002)(16526019)(83380400001)(186003)(8676002)(36756003)(2616005)(44832011)(5660300002)(52116002)(6486002)(316002)(6916009)(31686004)(4744005)(16576012)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?m3xvaT5DLp0q5NIjuF2jkgfFnsTGktuarDorCjYeakITWmBe+rzPzH8b?=
 =?Windows-1252?Q?7wOOQ9n1xqCsprb7rrhhMd9aquOCLiZPko2MOhv3GsBqJLF+FWoXzUiX?=
 =?Windows-1252?Q?UsythqI8lXA+DWknbudTu7Omthu8KUYXRhPM/fdAeyrBnwH4Vp72Uv43?=
 =?Windows-1252?Q?T2yZlKbKR8UL4Gx/6ElrbDNZrLlYaAYEepdkeFH5mvQBJLxGFO+zMGv/?=
 =?Windows-1252?Q?MzoYjOpf2Vyxtqbf53O5mljyCjSj3Tnn+zHbz376q10obXDRhZn9KcP9?=
 =?Windows-1252?Q?4GbfSu1GwWxC/bcBOgo6I2o3pS5CoYd3biI08CiWsBuk5w5uHqqeS6GF?=
 =?Windows-1252?Q?VWvGos3kM6nJsSeSNkDVpjJlhZxBWUB0aqXpVK8kA04hNjNy3xMPTSoE?=
 =?Windows-1252?Q?OH0d3XDuirktkzg/c5niiMieEXkuuvVAhSKBRXL9vL6xDy5AliYNwoJ3?=
 =?Windows-1252?Q?HaLxKvjkzQMIcubMZwcSd2gpXroh221aRJFjyvORr+Di8VMNba3uIBjS?=
 =?Windows-1252?Q?R8WFGpWynmdwQcPDa7VZVl4Ks1P6zi5R44pYmOTExnXjrc/+yZOKzMKZ?=
 =?Windows-1252?Q?+dDv6WtI1lTo/tBp0yXO2S7lAYJMl1xUoynE8bZztnwXjNuOPLXfXxHQ?=
 =?Windows-1252?Q?DsJZ5hWMDue9GhTU5FZQrqUkWJp1rM67NzOA1XVz8WPHj6QZGFSx0n6W?=
 =?Windows-1252?Q?/ycKqhQyUiP2l2Fc76E7ZY9l7gyuCLUwQ0c92d/JQqc1AWDW8kcXWkAO?=
 =?Windows-1252?Q?K4sT7CbqXjexdOYevltpDWWWUSfDI/cPUU1VI1n44Lp7jhUy5qcZhPh4?=
 =?Windows-1252?Q?8nGgcybGi0uG8uTIeL8Mo3Yqizj3LazskgMZ0AzGyobQk3TelscT66ZU?=
 =?Windows-1252?Q?PyH3/CH+rPzNfv8Q8b7Lj52Mu3QyHU3/611uztNrYQBSQKhQf+0a8OLA?=
 =?Windows-1252?Q?b9gd6YKXr8qszBl5KXDNIEyfZCbFXroqjwE9lQiDb6iuN6O6/9q/pi8J?=
 =?Windows-1252?Q?1qf5aWUmRR9D3I3w2e3NN8deyRkrpUStRIoE7/X2kirQtdmbx/pqoV/b?=
 =?Windows-1252?Q?JoM6JbShJ/wNM+m9?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f20a8062-042b-41cf-3633-08d899615b2c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 21:04:29.5865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ctVCqGfUEPFM8kHoZ3pbLSYdY238uoiahMhPR4Fokvm1wpp01pnX0ckV6MEzfzRVbu4KpYfX7HqQPoSSW1od1BVpFjwI/ILVrLsHGkuZhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 21.48, Jakub Kicinski wrote:
> On Sat,  5 Dec 2020 20:17:34 +0100 Rasmus Villemoes wrote:
>> -	unregister_netdev(dev);
>> -	free_netdev(dev);
>>  	ucc_geth_memclean(ugeth);
>>  	if (of_phy_is_fixed_link(np))
>>  		of_phy_deregister_fixed_link(np);
>>  	of_node_put(ugeth->ug_info->tbi_node);
>>  	of_node_put(ugeth->ug_info->phy_node);
>> +	unregister_netdev(dev);
>> +	free_netdev(dev);
> 
> Are you sure you want to move the unregister_netdev() as well as the
> free?
> 

Hm, dunno, I don't think it's needed per se, but it also shouldn't hurt
from what I can tell. It seems more natural that they go together, but
if you prefer a minimal patch that's of course also possible.

I only noticed because I needed to add a free of the ug_info in a later
patch.

Rasmus
