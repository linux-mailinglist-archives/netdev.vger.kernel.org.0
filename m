Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5221EA04
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgGNH1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:27:18 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:38311
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgGNH1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 03:27:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJIr7YarG9IAmIymf+NKKrDFZvN3DPNhgECE16jjZ+tHg3CUkRKLlG3mYjtE/o5PweGjZgre1teFboclY+f163nbp7Vw27hUc9xeVV04I8+kNLWykPsw4oa7ASpukfbCPbpDvja4F+frzp4yDy33eKB3T3GJuHK6KIFWXbATgDAD9znKfz4NZie34PErEa9y6YXGDvUype/azGshkfhPOdmxXLfptPsTEeuVJBrBY6iJrPjjWzDQhkp76jWu9cahrGWmHLssGfD4GsTI9YqzFB9hzBBmC93Qln8WgDblqjnEWkxhIjiqtOivnjSkng/3bCRUyVJKKOJ1P3ZeubCxjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUi3Y41EESpCL0awB2h/zKtMBUovw8DZZsrFQK7kuxc=;
 b=Z5m42PWLFZdLtFTBaSeEDwhuXEShFg+bGQyRSKQ6MYUBSbMzb8dogiU8M+G1BsLtwDiudNxg5fkwEehWKl/Tu7X7h54lObn609CUlnQATJ/uaS8wQvhKVABoEGYtpyL2pLAirrt7a7QYKeYkqaZ502IImCXlNE0cRH6ZyJvoLU+cECqLnN8Gk4DfB/Szkr6GCXtFO57yfoG36WIRjrXGsuddHrEYR5aQF94b4oi4jzUfV/GSITrnO812HKPrKgAU7LyBPmxysQ+FiOA2yQ+3xvjPw/mFjnOS0TYlF7sIUeio9j0gFWKvEQ2h23xAa0tig7wJQuU4ffXBP/cTEasSYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUi3Y41EESpCL0awB2h/zKtMBUovw8DZZsrFQK7kuxc=;
 b=ZkqLMkgaoIzjITb7cmdsRJAA0IwfgYXEBH/pyEvvgpUMHtTONoWGkp1llOOXgugDjQI9hIG4DxeeDdN4cvDzE+5UQ6AqGlEv3TRKgEUMAV7juCPwWBwJb2bWDoCbjp0mY86KpowCoJemDANfoPU8S3QI9Ey9KtwKo4tSBb7YCaM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM6PR05MB5333.eurprd05.prod.outlook.com (2603:10a6:20b:3c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 07:27:14 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b%6]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 07:27:14 +0000
Subject: Re: [PATCH] tls: add zerocopy device sendpage
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
References: <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
 <20200713.120530.676426681031141505.davem@davemloft.net>
 <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
 <20200713.180210.1797175286159137272.davem@davemloft.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <8dd10152-b790-d56f-8fbc-5eb2250f2798@mellanox.com>
Date:   Tue, 14 Jul 2020 10:27:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200713.180210.1797175286159137272.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: LO2P123CA0062.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::26) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [132.68.43.233] (132.68.43.233) by LO2P123CA0062.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23 via Frontend Transport; Tue, 14 Jul 2020 07:27:13 +0000
X-Originating-IP: [132.68.43.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc64fa5d-3d51-49d7-b676-08d827c7543b
X-MS-TrafficTypeDiagnostic: AM6PR05MB5333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5333AEFFA765D040F9569A46B0610@AM6PR05MB5333.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DPP7oN6V2l130QRmcaPPxig+AgktRejJuby3XRnN9j+6XrCjodOnKguCW3090Dq08JJC1wGBMTF0IyWxdaxU+vd65V+juBwmR5UzDR0QwAcSJrgd2Xuj16KBFvAU614sU/Z3O0bNicGe0eYTZthStMo48p/34ZFXa9nthDlCuBAg3yixb0INJelXCR/R0TtvJrDGrhkWwb+uQZWb2lsZSMNGns6Gw/cLq5TTe7Lfg3CBkPXCMWuFPO9QBpykLMXfmqQebEFfBN4x93xbaO00JZlULDHHyCI9pnYAbkoiUblwNxRCT9xXx5aoNAwbhBh9I13KucSK6On2Op1e1iy2gBcq88u7Fwb7o0titVIVqr1kP31BM3lweRTuwqMQEO4YURQ0dCXko4JLhSqykgFJplg2uoXWj9kAc9Y72QRwRL4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(52116002)(316002)(8676002)(16526019)(16576012)(956004)(66476007)(66556008)(186003)(26005)(6916009)(8936002)(36756003)(31686004)(5660300002)(478600001)(66946007)(53546011)(4326008)(2906002)(6486002)(6706004)(86362001)(2616005)(31696002)(3940600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uiQ6ywK1LKElygES/0jUuzzi/pRCGYhgA8p+EAoQ+7bCG+VKWjsLv8Z8lDNoksernU1p9QnStWLE94EvzZNFBsiMuvsqoYI5WIBeUpfYi0RqI/OJhbXswXSLrz+TxxnaXQg34kfUH9srqk9ycRjh8yScoxO6tEraT9s6mqbUjWxOSzuwiO+SbihjsDyyEOPgD0aBlXCBSmmDjnDWDwsPvgXNJx4caLhax5wbECjKFDLiRzPE//5UkL4DnWWdCfYu0hUGsLBSrzi+aKDrPJjHiLtlAE3l5WVKbN/PoeIsjdWsobCJVXYBTE9u5jVgKeT82mkcSkmbYXRT4N0stdf49p/bgt1OzLa4rt6tR871bNoE5BqlS0Is6Xwg9hvJu8SvNvflv+eyB6OOT4kZQB5mqbW3AAkWC3BHCiK46Ka3a8NaI+vZEkeoIgq6a/p85CujAvqz4Qz1ausqpZvv6PQBFCkhqcKQ1lzKPkWPoYMFVfBHholFhLTdst0l+fc5Lhou
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc64fa5d-3d51-49d7-b676-08d827c7543b
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 07:27:13.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IG4j+TGLg05Z6iCTAnkYTA+6sbaeI8Tz8tf1k9rf89nLMd+2/1PQiwOC0mA+C5OeDk9agq0pp2HMGVkSXRTeqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 4:02, David Miller wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> Date: Tue, 14 Jul 2020 01:15:26 +0300
>
>> On 13/07/2020 22:05, David Miller wrote:
>>> From: Boris Pismenny <borisp@mellanox.com>
>>> Date: Mon, 13 Jul 2020 10:49:49 +0300
>>>
>>> Why can't the device generate the correct TLS signature when
>>> offloading?  Just like for the protocol checksum, the device should
>>> load the payload into the device over DMA and make it's calculations
>>> on that copy.
>> Right. The problematic case is when some part of the record is already
>> received by the other party, and then some (modified) data including
>> the TLS authentication tag is re-transmitted.
> Then we must copy to avoid this.

Why is it the kernel's role to protect against such an error?
Surely the user that modifies pagecache data while sending it over
sendfile (with TCP) will suffer from consistency bugs that are even worse.

The copy in the TLS_DEVICE sendfile path greatly reduces the value of
all of this work. If we want to get the maximum out of this, then the
copy has to go.

If we can't make this the default (as it is in FreeBSD), and we can't
add a knob to enable this. Then, what should we do here?



