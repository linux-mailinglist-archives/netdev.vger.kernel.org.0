Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A3421EA0D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgGNHbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:31:32 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:11758
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgGNHbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 03:31:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfdUr+z1c88qsstGvjHuiRXok8DEMSZplOs+uO/WrhqP3I1qbQ32TLnb7Q7kbnbPOduu2m6cDD1SGCJLELNvxHbWMt2rHHzRxy+toO1cU61sWk1RPLZcE48muioJN+tXm8W4W2kvY5Oj0XBVo3Dxe2qjtmkCz6aRnap5CrWUuAYjVVpbPuRL+2dLf/yyS9FLv4NMgpD4DkhQuaiH76v02jF5lbdAYLOM/hhX4400fioMDNEQg6R/GDTvRi5A1w3kLcoRCHTjaWA7sx2micuSDVYmcuW/KWcqTNq3p6qSmyu+NAFKqTUQwI3nwiAMCuKBwKSvPOjV3kEengVsIKjlVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GezPvGI7PAOLqstFyCsvniPRkOJjDa298t4hVjeVTBA=;
 b=Cu6HPA3iLfIf8Mxcm4R0LXN+uxNnBor6L2OM1I/skas8Fwy77+eJ/y0n8Wd8wu10oVCHhNn/eTsdSBPUzdWOYdv4DKq2jouLgL1TSHNNvJjVOMpg6lCNhSWdiNSVs3LzG0o7ytUoFG1rffJr1HdK0yS/bALm9PlUGzf8rWVwpXwsfmaNTc6GYtHQYZeIYqmefZOPN5B38ort2fJCyw3iOeBf1Lac10VA6ncRuERSvm22Yzkh+SK6apWeIZtasTibtyZdzRO6fKsh66mDnA2deI80HUJ6jlMgkkNVmFyAS5HwR6Wy7hKVe2gjqyM1iGsSwwrcZlYXnvsHhyEFT4u5Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GezPvGI7PAOLqstFyCsvniPRkOJjDa298t4hVjeVTBA=;
 b=Arq1Wm6jdCzJ72M+PxxmQ+sjHtGjbTLP/RrvpDZPz9S0x1vwJL0vo8kMR/jNDsz0waCAuteYFIIG44QX0kFXOoknYZeR05RFmdpovTy+j6q6Pd+VISSTQlPiyy222QQTGdUhkMCNpH6wMDr6PnNyCeQ43HniDvnXKQlJJ2LRKxA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM6PR05MB6199.eurprd05.prod.outlook.com (2603:10a6:20b:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 07:31:28 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::b928:e157:6570:d25b%6]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 07:31:28 +0000
Subject: Re: [PATCH] tls: add zerocopy device sendpage
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, john.fastabend@gmail.com,
        daniel@iogearbox.net, tariqt@mellanox.com, netdev@vger.kernel.org
References: <1594550649-3097-1-git-send-email-borisp@mellanox.com>
 <20200712.153233.370000904740228888.davem@davemloft.net>
 <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
 <20200713.120530.676426681031141505.davem@davemloft.net>
 <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
 <20200713155906.097a6fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <e538c2bc-b8b5-c5d9-05a3-a385d2c809e4@mellanox.com>
Date:   Tue, 14 Jul 2020 10:31:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200713155906.097a6fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: LO2P265CA0333.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::33) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [132.68.43.233] (132.68.43.233) by LO2P265CA0333.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23 via Frontend Transport; Tue, 14 Jul 2020 07:31:27 +0000
X-Originating-IP: [132.68.43.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3a95733-f2e8-4816-f30b-08d827c7ebba
X-MS-TrafficTypeDiagnostic: AM6PR05MB6199:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6199A0EAC80247272E5C8122B0610@AM6PR05MB6199.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLPSJMb8XpzD6hpc/EcWz+oT+bIk+wdwmUrVutkCwpbwh34Bs7oqbqpldrFKNMDd3SpGkY97s1mrbSdbHH7vSZ40BidX4y21hFiRpy2FAH3cXw+G1pQWj4tMgr/oT0dUlLwBLadDlXdGpJPTl7xZm4OkOeq+0bfP8Wfj0lkpNctn/PElnD+0+2ANt+/jQqDKrEyMnL2nYW0ZBVouRra1k2MeciXdSt8nFtOMR6CijOhX5jkHlbAJzdHoPCcjYVp8npsbNUSyA+DqfhEdTuSabz4x66lvB85elt0238UBgHTerPLP5O0jRdBKbPyouHBLa4uVdrPVMetqJ3q/yFN+1i7I7xURnUdwmyI5vCHlJw7PFyPSDUIIBby96aBJv/JzSlSy1WpRmag+GidwMiemA1CngbNV6D11huiLzip+wtM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(6706004)(6916009)(31696002)(52116002)(8936002)(4326008)(66556008)(53546011)(66946007)(66476007)(8676002)(6486002)(2906002)(5660300002)(36756003)(478600001)(2616005)(83380400001)(26005)(316002)(16576012)(86362001)(956004)(31686004)(16526019)(186003)(3940600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 61wwiU/hZjR8Njstd6ln/JrtRD4Pki0CkaEIP77laDeafUS7TIJuxg3Xye6Bz81H55pY/oph4ZEuKF30O3x0uULqxIuetirzX6XbOGmncdn8fY4OHxFGcW5dwMGe8i0RDARdMovyFXeK1AyLNb2n52cVxJUO3DRP088nREIWGiT1tgJ6VUbpI+E49K/NWVBue9pG3L3023SUXxbnOtWgJrxpO08ePn/CgqKcDB7nAPpEKoB0tdfx9mf1BOI5tCXorINf/OKcaNobKVnP8Fr7SFUcTF6HmrntOZJonmXocLoF5dgLP80f7SkcATBeurv6oY1b+R7RFTYSnGmm3+nzDI/eaxe70xDHIfU2snrUa4RdV6cHMzQmP/9Hcjt7qQ8O9D79LYoWqIusmBGWw6XT3Or3v9QKvQdSy7PABMe+0ebqtmOpAn1izXyc3m/d5P+oRT5Mo+4lN12+YjaqmKPiR4CP8pfh17+iSMj8e2nkO/ypnMEIREsggBLrT6gpgxgi
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a95733-f2e8-4816-f30b-08d827c7ebba
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB7092.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 07:31:28.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XjzekQU1UlbWu0eDytkQIvbHRm+w61uTzcPu0nJIrrLyxUdq4koXQFjvFQz3rFIL9gcxX5MLvvvM1ADUh++bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 1:59, Jakub Kicinski wrote:
> On Tue, 14 Jul 2020 01:15:26 +0300 Boris Pismenny wrote:
>> On 13/07/2020 22:05, David Miller wrote:
>>> The TLS signatures are supposed to be even stronger than the protocol
>>> checksum, and therefore we should send out valid ones rather than
>>> incorrect ones.  
>> Right, but one is on packet payload, while the other is part of the payload.
>>
>>> Why can't the device generate the correct TLS signature when
>>> offloading?  Just like for the protocol checksum, the device should
>>> load the payload into the device over DMA and make it's calculations
>>> on that copy.  
>> Right. The problematic case is when some part of the record is already
>> received by the other party, and then some (modified) data including
>> the TLS authentication tag is re-transmitted.
>> The modified tag is calculated over the new data, while the other party
>> will use the already received old data, resulting in authentication error.
>>
>>> For SW kTLS, we must copy.  Potentially sending out garbage signatures
>>> in a packet cannot be an "option".  
>> Obviously, SW kTLS must encrypt the data into a different kernel buffer,
>> which is the same as copying for that matter. TLS_DEVICE doesn't require this.
> This proposal is one big attrition of requirements, which I personally
> dislike quite a bit. Nothing material has changed since the first
> version of the code was upstreamed, let's ask ourselves - why was the
> knob not part of the initial submission?

I'm really not convinced that the copy requirement is needed.

At the time, Dave objected when we presented this on the netdev conference,
and we didn't want to delay the entire series just to argue this point. It's
all a matter of timing and priorities. Now we have an ASIC that uses this API,
and I'd like to show the best possible outcome, and not the best possible given
an arbitrary limitation that avoids an error where the user does something
erroneous.

