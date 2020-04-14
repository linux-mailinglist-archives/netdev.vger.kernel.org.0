Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C3B1A7794
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437738AbgDNJrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:47:01 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:60001
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729436AbgDNJq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 05:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sqqp/zm0Au0XfCSK4q868wpxWRXPV3RMILtjr75J39Jo3BY1RnQEq7bKqNtN9fYkyKlGtjqZvls/nxZ8W8Qnl5yTU01w/nD1wR6sUrWCqspWLuMSMx5V0Uq+lOoO91DM0Ko0qdT6LGCZH1orNrxkttMnKR7wjVhUsdJ+lc8XuTzW/AisCmIeY7Hn7GKWIGGV1rrsTZrLvI/ak9V3qlVWTmV0ymeHc14k4DSPkGI3OGoFFPcP04t/fO4qYQJ3JQBfqaRh1oAnWfw47D9Bul0cTAoxntz5IhpFetxLtBx5JPf+xmW9DjJAevTIGjqxV66CLnnE7FfM3SN6ipY+6vBLNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PzJcNATMhbTLN1G7dJFrlDuWNSaPug0hEuC+MC/Ies=;
 b=b8kmmWCsOgbnhJR/6MIIit5v4fZ/MWu2LCdTRX/jcw1V891Dh+tVDfk7vqVt1ltRM++B8aIwR23NWWINgYX7FGwYBG6a3eB+kESGEot/FkCMmkI2iLZZSisIqBw5Z5bPildKs9Q0CCDgs3zCUQxg/hONv04L2GCibF+IqdOqPyf/j+18WnzR+IKBgJf8STN/WGclG8nKGAuJFvG5I5YaoR30WT+36twKYjOw9RVUfIa7cJoprgOovQfLeSDfw6DtCkCLtV8UpduTHw57cer/H50YCdrOLJqHIximbRKgV9sYYB1aQnq0G97lQYc588kBxNbDMMAu6oyW8l+Ah5n3Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PzJcNATMhbTLN1G7dJFrlDuWNSaPug0hEuC+MC/Ies=;
 b=Fq/ltk2vsqNEHCWWQwf0LRYMr62P4ZT8RLc8vFsaGPowxI33YzqtXtryNuNR/xgnNHvhXXaz8nCeJEW9xeeLB7Is3vDypIw6ZrxoHekKVP1buDkqhRst1AWE+Xq34PSj56BAtDjo2Wr6YlV6/zY9Z6BywBIve+rS6MlYwvbdsAo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=julien.beraud@orolia.com; 
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com (2603:10a6:206:3::26)
 by AM5PR06MB3105.eurprd06.prod.outlook.com (2603:10a6:206:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Tue, 14 Apr
 2020 09:46:54 +0000
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b]) by AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b%7]) with mapi id 15.20.2900.026; Tue, 14 Apr 2020
 09:46:54 +0000
Subject: Re: [PATCH 2/2] net: stmmac: Fix sub-second increment
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200414091003.7629-1-julien.beraud@orolia.com>
 <20200414091003.7629-2-julien.beraud@orolia.com>
 <BN8PR12MB3266F9F1656962A9D1675AE9D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Julien Beraud <julien.beraud@orolia.com>
Message-ID: <310f0a67-7744-3544-126f-dff1fcb75ef4@orolia.com>
Date:   Tue, 14 Apr 2020 11:46:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <BN8PR12MB3266F9F1656962A9D1675AE9D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0385.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::13) To AM5PR06MB3043.eurprd06.prod.outlook.com
 (2603:10a6:206:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc] (2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc) by LO2P265CA0385.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 14 Apr 2020 09:46:52 +0000
X-Originating-IP: [2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30eed5da-070f-4194-fb9a-08d7e058c39f
X-MS-TrafficTypeDiagnostic: AM5PR06MB3105:
X-Microsoft-Antispam-PRVS: <AM5PR06MB3105A83CAAC0432F85DF4CB099DA0@AM5PR06MB3105.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3043.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(39840400004)(396003)(2616005)(186003)(81156014)(6666004)(5660300002)(66476007)(66946007)(86362001)(66556008)(31696002)(31686004)(6486002)(8676002)(4326008)(316002)(8936002)(2906002)(53546011)(52116002)(16526019)(110136005)(44832011)(36756003)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: orolia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhExflgq8bbp3sXxK5wiEB6Fq/fQDnMixa5IMiQhXvf7rb9eByAQNRnnLY5ZR5XApCxfSGlg5LMoToMVu9hhRQjyr8xX0Hwfr0PikYxJ+K9iWvErFNgP7qpThqxuL1XYAVuKfx6ivC+HZCsENvd4lPBZqiyctmpl0aGAObr21M3ZRIrkHf4I3WpdZakjKpyTwmtwlNpndOVjnb7PQC8gOFf3pGPuA50rNjRV3n4OlJJlX1UFzEGMGmVpMzi5JPjc2X4sXS8b723/khuKfywf2rQ8jQi/pOEJRIFGiurfB4Fq9gc/rz16xpQgeFHt+S6pZ3Tsft4t2k4su7lI0lI5lmC9koAKwnnfkag/A4ebnZk0UcUQ7T9lvFlmvpdkJGDENr8/KlQme9quYpSyomi9FUQItj5zQXwckMl0L9d1nqFJd0d+E1cb1GZesUH+w896
X-MS-Exchange-AntiSpam-MessageData: SV6Cz3FYiTt55qg1quLbeoaLjV4MY8dhS4k3959bc9ysQtHyzZsgXVk8Um7sE4ad6jg1L5rwcSXz9wtGDIwQyFZ/zQKzTYqOk6Uj/iBXwXLHgm3lMQFDZFAsCcTcbV7KCt4HxC7DtDw/E2IrwukfyoH8zu/HhPz5HxTpTtO+sLsaWC+RWXjkvs9C4L/8ADnbg7pYT1fiHTzppgigo1fSiw==
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30eed5da-070f-4194-fb9a-08d7e058c39f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 09:46:54.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mtigl6T/Uh3EudcYvYey+ylNdvER5b04yLEYviTuadeqRsG7jw7wkJRddWgB9vA8HTEF2dEOItO5CtT7LwvNNC1SeMqhqoVtiy4jcNB/wVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jose

On 14/04/2020 11:15, Jose Abreu wrote:
> From: Julien Beraud <julien.beraud@orolia.com>
> Date: Apr/14/2020, 10:10:03 (UTC+00:00)
> 
>> This will also
>> work for frequencies below 50MHz (for instance using the internal osc1
>> clock at 25MHz for socfpga platforms).
> 
> No please. Per HW specifications the minimum value for PTP reference clock
> is 50MHz. If this does not work in your setup you'll need to add some kind
> of quirk to stmmac instead of changing the existing logic which works fine
> in all other setups.

The numbers I have in the documentation say that the minimum clock 
frequency for PTP is determined by "3 * PTP clock period + 4 * GMII/MII 
clock period <= Minimum gap between two SFDs". The example values say 
5MHz for 1000-Mbps Full Duplex. Is this documentation incorrect ?

If this clock is really limited to 50MHz minimum, we could explicitely 
forbid values under 50MHz but silently making the ptp clock not 
increment doesn't look right.

Apart from that, the existing logic doesn't work. The calculation is off 
by a factor 2, making the ptp clock increment twice slower as it should, 
at least on socfpga platform but I expect that it is the same on other 
platforms. Please check commit 19d857c, which has kind of been reverted 
since for more explanation on the sub-seconds + addend calculation.
Also, it artificially sets the increment to a value while we should 
allow it to be as small as posible for higher frequencies, in order to 
gain accuracy in timestamping.

Regards,
Julien
