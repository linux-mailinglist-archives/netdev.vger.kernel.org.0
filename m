Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E421230F56
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgG1Qb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:31:57 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:55424
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731458AbgG1Qb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:31:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjaICE/3kgImeJVhIBvlhhln3ySfdPbH3nFGiB7fHpQjXog9np4kslxUozTpnrii9xB7i8K1O+dllrMQFShQ+kz7O5KCk6lkkSFg4acKwC5Qp8iLmsE3Y6SdQAShtEFccyAkt4M0v4BK7yIkodFJO+E+nLHQUVWVUDsPzr+5XF0zrLJI60mB3UbDhh+/gl+ZHvabtgqTFaJdEKwTnlIfintNIRlOoN/xym1HahKBXstGdoMRc309PyXre3ov57wPlfRYUe2DNBcE1HkfWMQ87rP1my140EptZXt326wmJGigprRwZcHpAcHliAEA+NdEro02ELfTvqsaCHDIy1Wt5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+PNPvN2mgSRx6Qcev8P+OPpjySEeEbmHvjVKUqu7is=;
 b=mttsbbeHB24xSeCsEZT1fVZ+cTg9UhDx0hGrPKumn5BjDJN0IkXAd8F5m7TJDSDmmwcPI1vi2RTlwB6nWWHWqUSedAKMz71eb+tn3g8gNaCtUC1FsuI8pAqkig0TD1dYmq7Opaa5zsp5x3NkCoex3Ky1sYCuQj1E+0gCG8cEWNkQ58iWFpiyw9dh0Sb9tedLlV7dXl7X6NJzwjs+cLkw0MfOgAQBlhPbqTB6usu3Lhxwdx+FFYsaV/5zCVBpaaTgUxArvlsXCMqX40LfQk9R3S3e9zlV5pxGB/Wf+WmEYQIBAFdBi22SrQlF53GfTO4i/gRx96mrUmAYW4WoJSZvEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+PNPvN2mgSRx6Qcev8P+OPpjySEeEbmHvjVKUqu7is=;
 b=inmBPBfLm+dQBwa7/vye7I12FXKQOb/lt2jhX9TEa+BF2MGbKVhMDfjkwLLBEhygVOVeKJavfJ/OVRHK3tB0/34bx4MrND88OFjBn+ksc15cr9DxbI7yIIJAbAlNyGp+TZ5v2gmFE7WDrV00bwd8MjmJM5lyiaefaGxqPsy6Tvs=
Authentication-Results: lists.linuxfoundation.org; dkim=none (message not
 signed) header.d=none;lists.linuxfoundation.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM5PR11MB1308.namprd11.prod.outlook.com (2603:10b6:3:e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Tue, 28 Jul 2020 16:31:54 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::b16c:41d1:7e54:1c4e]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::b16c:41d1:7e54:1c4e%6]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 16:31:54 +0000
Subject: Re: [PATCH] net: tipc: fix general protection fault in
 tipc_conn_delete_sub
To:     Greg KH <gregkh@linuxfoundation.org>,
        B K Karthik <bkkarthik@pesu.pes.edu>
Cc:     Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200727131057.7a3of3hhsld4ng5t@pesu.pes.edu>
 <20200727132256.GA3933866@kroah.com>
 <CAAhDqq2N6nTHpz_CNTwh-ZRK-rQO0uUXO41iOouKn690R494Ww@mail.gmail.com>
 <20200727142416.GA186956@kroah.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <6d6197ba-ce38-09ec-78a1-7feb59cd7a90@windriver.com>
Date:   Wed, 29 Jul 2020 00:15:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200727142416.GA186956@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0075.apcprd04.prod.outlook.com
 (2603:1096:202:15::19) To DM6PR11MB2603.namprd11.prod.outlook.com
 (2603:10b6:5:c6::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.155.99] (60.247.85.82) by HK2PR04CA0075.apcprd04.prod.outlook.com (2603:1096:202:15::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26 via Frontend Transport; Tue, 28 Jul 2020 16:31:50 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c1610d2-7d57-4d9c-820d-08d83313bd05
X-MS-TrafficTypeDiagnostic: DM5PR11MB1308:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1308F678E538FEB1DAC715B384730@DM5PR11MB1308.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3dkVMIrlle2nViNIvYy/YZn2d6Jk/NyrX830jPjmh1r7AyldZ7CuCK25B3+Lm2aVoCH6zb/fCFLcna9HpZAD4mlnySU3CNCpNwJLKDjXVsgNySiZpvpPW8f+mb0yn7DPtJO1TXIPH+rMJm+TrYuppfgDw97CG+e6GMIlqj3Jq++nPheQPVkjFD4h3XnLAbp1xvpR4/vKi51K6s7E4Cz070q05gtdE3IF2BLsEudbMTeW1UXWE/kVmWGQosS863KtXmFXBQr0UnviL4UxLlVfGuuLOOW10aLQPfBs19FZIUByoliDcL9N0ApYzmi3FiuzBkyJt++4tRA5+oZuKJaH5Kq7KRAeb6fd6OSPv6FkuWmPacoUm6D80ELY2oHf2jQuOUL8IztcIjfQC3fMBZ1kKAnsHWQm2wVjVjkhggxiYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(136003)(39850400004)(376002)(4326008)(7416002)(26005)(52116002)(6486002)(66946007)(186003)(16526019)(31686004)(53546011)(66476007)(5660300002)(66556008)(110136005)(8936002)(6706004)(31696002)(2616005)(86362001)(6666004)(956004)(478600001)(44832011)(2906002)(36756003)(16576012)(316002)(54906003)(8676002)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cAsyHxW7oyfvM9z06l9zOe9w+Td11WlQwxxGrwaCj3twyUx3CgrcFnPiPpYhIC3FWQtLCDf9r130tZpeQ3AQonNgqckCtdov2O5iU/f/Vw5v6nrgAdEE9ElljUsnQfOYZXIv9B0TxTZ0FzAh0D4awb8x3wJaVvB9QQ/ntC1VEdNGW1fitas2eRylPxj0cJGkl1fwSaIAcGD7uXpy24p3t23yHMB0cShJIzHKoCQWN5GvtXk3H4aIBs/wnwhUWOq4jAafuHGi0YM5FGN0PlcM9g/Dr88/jyYUO7v9uYJ3ep+IfQ6amEF+J0jE/0LWYgOvtVNcu9RS5tSJdh0CD2I5+jjQLdbA4LF1Z+eSvh+gqcfMQXWZMu1qOGY62RruiHXb00xqWYUzo4/jG4Yo12+QrXtCvDx0YkcJOC59j1TDVHsoMJhyoZibmN5gyHCCXwpqfTQItSx1l8D5w4WFxr8l2NiwscYMlohQn1m4/zqMGac=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1610d2-7d57-4d9c-820d-08d83313bd05
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 16:31:54.4013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHwmvmknEscZTXZ0qowsfoFUcKz26uIHd4RnNrXoSJywNfhf9PT4zDf6ZSTFsAN5ffIfZEd13zEBfhfBiEnbjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1308
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 10:24 PM, Greg KH wrote:
>>>> diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
>>>> index 1489cfb941d8..6c8d0c6bb112 100644
>>>> --- a/net/tipc/topsrv.c
>>>> +++ b/net/tipc/topsrv.c
>>>> @@ -255,6 +255,9 @@ static void tipc_conn_send_to_sock(struct tipc_conn *con)
>>>>       int count = 0;
>>>>       int ret;
>>>>
>>>> +     if (!con->server)
>>>> +             return -EINVAL;
>>> What is wrong with looking at the srv local variable instead?
>>>
>>> And how is server getting set to NULL and this function still being
>>> called?
>> tipc_conn_send_work makes a call to connected() which just returns con
>> && test_bit(CF_CONNECTED, &con->flags)
>> maybe we can add this check to the implementation of connection() if
>> you agree, but I found this solution to be fairly simpler because I'm
>> not sure where else connected() is being used, and I did not want to
>> introduce redundant function calls.
> That's not what I asked here at all
I agreed with Greg. The key problem is that we need to understand why
con->server got NULL, otherwise, we probably just hide the issue by
checking if it's NULL.

The topology server is created in kernel space as an internal TIPC
server and its life cycle is the same as TIPC network namespace.
Whenever the topology server accepts a connection from its client, it
will create a "con" which will be used to talk to the client and the
topology server instance (ie, "topsrv") will be attached to
"con->server". In theory, "con" cannot be died before its server, as a
result, con->server cannot become NULL in tipc_conn_send_to_sock().

So I suspect there is other potential issues which caused this problem,
for example, the refcount of "con" is not properly taken or put and this
case is triggered before of use-after-free, or race condition etc.
