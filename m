Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8196721FEFF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgGNU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:56:14 -0400
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:7130
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbgGNU4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 16:56:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKfv1euTBqs42v8Xkzhuroz0aEphLPgEzu9tX54aK3Fwjv7xF13JLA0V/YVVeJv4CJJE/eNK2BEsI0tBu+ZAlt7/VD89b1cq+Mogr/r/csOGisT0TXt/p6cfwGfB5utGioA20sTH9XVPf0WvfRLUtLK90SnR9G+5R0xIYnJsdAKo5wKaHhZRFR17rF9nk76x4MOjp3KAfad+WkebVTV99H9TYV15mhVNUhtNE9CA9ShNpUBxMEXsMyie8OFCpff6ntK7vIwqjGnXLkhOgI10LoqtMKbyBmOQuXheW7ohC+ND7Oz4zKN6cyCJlHzeIkQaqH0EDt+dlh/LLIMhJd5oug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3XZ67ClhhmK/kvThHPHcROqygm4zdz2JuMKJE2d2Ic=;
 b=SuiNSXZy3oq/SvEWELrtS7TwyyZzNyHCoujV5hwMlFhyppn3PceiJqooIXF3uAs5r6kf4AGBhCnqYfTe1o19RYsa442wM5rueBY9SWI8gdT1bej9XsyKOGbSKeEI7GUaPNlWigpfUo2YQ57gM/mADoft8YeCNKNsMUS/HR1N9wHsJM5GliY0pEYdVZmgOty02oHjmeeG9R1SbW+SkneoU8nqJ6pHEXarDtJQEHBQkCWgLrqEzqnLHqj0y2kMqY4x4CrVoclG/m5yEA+4inM4S4gunfpUQVIfuykduZDMXOhYXBhRdWwR6i8rgpgSDhQHWY+iNNm70LNiU2WEP2J12g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3XZ67ClhhmK/kvThHPHcROqygm4zdz2JuMKJE2d2Ic=;
 b=LF1QKHgkQHr6jVWbejChfUif2yt+xb60ouQjXs29pqfR2KWYZFxSV1pXPJIC0qEnnxwxkfqb8qQikd3rdfQzOJMv3wFu8BbjtMI5Jv+BZeYGmU+WokgpEZS6vn+nXQSwtKQd8Plcp51B+wwcRMuhkZHfy6nOUvjgmdJ3XtXW140=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM6PR0502MB4006.eurprd05.prod.outlook.com (2603:10a6:209:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 14 Jul
 2020 20:56:09 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b%4]) with mapi id 15.20.3195.018; Tue, 14 Jul 2020
 20:56:09 +0000
Subject: Re: [PATCH] tls: add zerocopy device sendpage
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
References: <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
 <20200713.180210.1797175286159137272.davem@davemloft.net>
 <8dd10152-b790-d56f-8fbc-5eb2250f2798@mellanox.com>
 <20200714.134251.618655351471501947.davem@davemloft.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <a933b0f6-7f34-7030-41a0-a015f2c5b1be@mellanox.com>
Date:   Tue, 14 Jul 2020 23:56:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200714.134251.618655351471501947.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::18) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Tue, 14 Jul 2020 20:56:08 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d239aab7-dc70-4569-16c4-08d8283855b0
X-MS-TrafficTypeDiagnostic: AM6PR0502MB4006:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB40069F80DCDFF0DDACA6BFC2B0610@AM6PR0502MB4006.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +p+z8tplWpN8KmJ/S5SuvM3QPE7uDH4c9Lq+I4lcd1A6V+jDftIvi3+ibwzI9z1KXTR8XgarYEX9mW/b17haMJa+vnpU0yvqsWB/VcZGb1xoE2cvFMCp1Ill9A1W1folF+YwBVMRu8zEuuflzkeYxeif2YtmgS+5DbeWYJ0A+kRwqwVj5CAl6rOqA/IUpr/bZyEezo7iyMfOJ2iP1Ww8tzrlYvL/4Jsek7Tfd4Awf+TY9kFSBla2zxW8sXcfvcXMudIZnHeHLaR0mnG9EFqA9LktqkpjP2gMcpH2YKT4aiL24ENYCnTn1rk9iN4kJvAc4H5RAgo0WMPKPiqOxQmbVirU0bkcRiYdRBrL+OCgFtgtT9qSUlj3HLl3Bg5x479l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(66946007)(53546011)(2906002)(5660300002)(66476007)(66556008)(186003)(31686004)(16526019)(6916009)(31696002)(6486002)(86362001)(8936002)(8676002)(478600001)(956004)(2616005)(52116002)(36756003)(26005)(83380400001)(316002)(4326008)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fDT5pPCErmizCv7vfZfs9l0moeN8G/OGcV64O8tQ5dwCHRR/ZS5FM8qOdF/tdVDSf9VW7czXrkSwngCec+3HYoq1yzqTnRIlkGAS6v+YFd1FbBT3AC6dZ/NjFat/qvioONvj+sBBbEXSKZW6PuCWduV0YQ2hSeXpnoTzXs8izIN8tY3cIXNPXDcjJVyKTFlNeymiBkG+cbkbph5B3mbcQakIGKgKXEkpUglkXQC9N3zMnm8Obuu6Nqb9LyC7l4FfgXhqPuvUhMqqWwnvp7qJB3q5hooaj6g/aPl6VOeZBV0wTg++Vf8n4YuaVkszQtCpN+S7ff6WmzDiwQZPFLTxhOcTGrrZNRKZJsM4lJ5ypmTz1BsVZSod8VIPkhF6IxYnUe5pVmzbMKPYa4Wv6m0KdPmd4EOIN7ZiTF/flCxEznv2yBN+Qvs9WcUHBGVQNRicsJqnXWoxPn04mckZfVOl6rLVRBkcxohLHejnk0/C/i7yEWvkY5cZ8SLbaIsDPLgX
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d239aab7-dc70-4569-16c4-08d8283855b0
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 20:56:09.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BeSupIrYKTJ7NXtY7UkkicYIAdf7YeRkST73XIXiNaAvmyGpjZBw5aVtBd4mKRIM2wlg1Vw65dahtrLD5nXw8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB4006
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 23:42, David Miller wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> Date: Tue, 14 Jul 2020 10:27:11 +0300
>
>> Why is it the kernel's role to protect against such an error?
> Because the kernel should perform it's task correctly no matter what
> in the world the user does.
>
>> Surely the user that modifies pagecache data while sending it over
>> sendfile (with TCP) will suffer from consistency bugs that are even worse.
> No they won't, often times this is completely legitimate.  One task is
> doing a sendpage while another process with access to the file writes
> to it.
>
> And that's perfectly fine and allowed by the APIs.
>
> And we must set the IP checksums and TLS signatures correctly.
>
> I will not allow for an implementation that can knowingly send corrupt
> things onto the wire.

Not even if the user knows exactly what she is doing. For example, when
serving static files?

>> The copy in the TLS_DEVICE sendfile path greatly reduces the value of
>> all of this work. If we want to get the maximum out of this, then the
>> copy has to go.
>>
>> If we can't make this the default (as it is in FreeBSD), and we can't
>> add a knob to enable this. Then, what should we do here?
> I have no problem people using FreeBSD if it serves their needs better
> than Linux does.  If people want corrupt TLS signatures in legitimate
> use cases, and FreeBSD allows it, so be it.
>
> So don't bother using this as a threat or a reason for me to allow a
> feature or a change into the Linux networking.  It will never work.

This isn't what I intended to convey. I've used the FreeBSD implementation
to emphasize that the performance gain justifies including this despite
the implication on user applications.

> And, let me get this straight, from the very beginning you intended to
> try and add this thing even though I was %100 explicitly against it?

There was no intention to hide the correctness issue here. I've proposed
to expose it via a knob for this very reason. I'm sorry that I haven't
conveyed this more clearly in the commit message.
