Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5193913DDBF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAPOnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:43:35 -0500
Received: from mail-eopbgr30121.outbound.protection.outlook.com ([40.107.3.121]:58887
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbgAPOne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 09:43:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XN5U31trqD/vVP5uxQN/VC416QBtnd9PYw9DjfePTq9WRZbCGJA5G/hXhxGQa4cDujTJkP0ghrQqY14Ndr1iYiv/LdpwKVYidxVDbTrhr2sJR/7eeUTiGgGa5HPOf6QxXWFc5VhQGT/q5O0aubyYx2XEzYz/K+ups0Y0dURsRnfuo7cwWUdDp5Ty1/bjffMNp+9bZmCLC+S4U5oHSoS9RzsB4ol6P4yUIxQcxQCHzV2+sj7aRGjLi1HIr/3DLNpjgmzNhRYB48ZPvq2zpEi1EIQKIpQMxJsPh1L8onI7A4UfggdXA1wj6DXJoD0atrQ6d+mxg4NIVfzgtjdAPFxy8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSa6nWHGcmv3nzh0xLY41y3CKfM/dExFyQdTJh0iPhE=;
 b=BIAqxerADgPWJ+Kfd9M9/rPZ1/S3mUAkYhhPAz8HkQD+Q6RQ+LJBZuSTS8qDCqDV3xdPews+tJnZx1OzF9Qx8qgTmQJHFUtKegC1m5jsgSv1wDLWGf0ZpzmfA5Ax5f/CyDfD2FfJiK6WauDhlEc6AyW4pIwG73LiG/97xU9ON3j+k2BdjNs967AJDJj464NBfL/vifnaXYkHVDhHy9RoK7C8/qflG3dLhzLgYchTF6VtKFSg8RZKYVDblFeGic3z0a+8SIo8z/1jJ017+gMgFjkY0fB4EZZiEkILkkYvIoSiLZRF0OsUOTMqZcLFMN38XOl11d7sNmQvSs0ag3tQKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSa6nWHGcmv3nzh0xLY41y3CKfM/dExFyQdTJh0iPhE=;
 b=lrmcwlxqQSbowlu3l9U3u1c0LmD/0DzeEk+yFSnMECVgvdZf0Me02IKHyVI2DaPdTCsJuf9BBjf+aXVY3R02VSAaUnnXZKuo8cKm4RvjqQrSiIUMTi89g6JeB1tSKggjS0go29SMCO9/9KD9Iu2rTcUnv8KhOEJvgV955y/vjQ4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=niko.kortstrom@nokia.com; 
Received: from DB7PR07MB6010.eurprd07.prod.outlook.com (20.178.105.146) by
 DB7PR07MB5578.eurprd07.prod.outlook.com (20.178.45.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.10; Thu, 16 Jan 2020 14:43:31 +0000
Received: from DB7PR07MB6010.eurprd07.prod.outlook.com
 ([fe80::181a:aaa0:df96:8bf6]) by DB7PR07MB6010.eurprd07.prod.outlook.com
 ([fe80::181a:aaa0:df96:8bf6%6]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 14:43:31 +0000
Subject: Re: [PATCH] net: ip6_gre: fix moving ip6gre between namespaces
To:     nicolas.dichtel@6wind.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org
References: <20200116094327.11747-1-niko.kortstrom@nokia.com>
 <8c5be34b-c201-108e-9701-e51fc31fa3de@6wind.com>
From:   kortstro <niko.kortstrom@nokia.com>
Message-ID: <6465a655-2319-c6e6-d3ca-3cf5ba27640f@nokia.com>
Date:   Thu, 16 Jan 2020 16:43:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
In-Reply-To: <8c5be34b-c201-108e-9701-e51fc31fa3de@6wind.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: HE1PR05CA0222.eurprd05.prod.outlook.com
 (2603:10a6:3:fa::22) To DB7PR07MB6010.eurprd07.prod.outlook.com
 (2603:10a6:10:86::18)
MIME-Version: 1.0
Received: from [10.144.164.64] (131.228.2.26) by HE1PR05CA0222.eurprd05.prod.outlook.com (2603:10a6:3:fa::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 16 Jan 2020 14:43:31 +0000
X-Originating-IP: [131.228.2.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e631305-31e3-4ae0-38c3-08d79a927528
X-MS-TrafficTypeDiagnostic: DB7PR07MB5578:
X-Microsoft-Antispam-PRVS: <DB7PR07MB557811FEED01E63EF57DF8968F360@DB7PR07MB5578.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-Forefront-PRVS: 02843AA9E0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(199004)(189003)(66946007)(66476007)(6486002)(6666004)(66556008)(52116002)(86362001)(81156014)(4744005)(16526019)(53546011)(81166006)(2616005)(956004)(8676002)(5660300002)(31686004)(16576012)(316002)(8936002)(36756003)(2906002)(186003)(26005)(478600001)(4326008)(31696002)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR07MB5578;H:DB7PR07MB6010.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nPmY+hz6qBx60Loup/20IDVYAFRLSQTDQGrOqI/+aWGVos63vxMaceNDZ8E5UOjLctFbhoRTi4DKA4TnKLymBnsvqpJ1NauZYoly5x3fgMTjeGkEu+fPUsmMxFweRd9zzl0S3a/uL3yquMQph1yz9RWZY5T06ZISYue3ZTSwfO6DEYoBWPPuU/Ff3vD20jQQi7bxsZNt2vJANgBbqQIwt4xPHhR7XlgXxK2iQaOztyz41FgHISZZ8y8OCRAvIav9yWmn3XcFWDXdMDKzvyn6BjgDY1Pdj+ChfOyYarnkgZJ4LsTJxclCwD1kbGLy7T/gWsXEHEce5fhxhB+NoK9ixpQ5wgf6XJ/O4OopXYnvqoLWGLysLcAdslAuuhhSdMQqI/jzNQjR0Va8waVbD85wQD/3R60KIG5LPOoJ8yt5UU3+fJSa7+yhxPggzkKefV3RplT6llipSXGYjvCxZC5rnRbwCR6bFJ/k/m21o/oH5yKQakQfA+EOMlikZOHJX7us
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e631305-31e3-4ae0-38c3-08d79a927528
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 14:43:31.8846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gaEI182z9TEEtiCJGeqryTx8uCCqWrW85xNR9tvNYjzW0QMdAYbQroGhyqeQlvqZLsZmnuNt9ZcW2fVV/+alTvToN+9GT/uE2ew8vHIX5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB5578
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 4:02 PM, Nicolas Dichtel wrote:
> Le 16/01/2020 à 10:43, Niko Kortstrom a écrit :
>> Support for moving IPv4 GRE tunnels between namespaces was added in
>> commit b57708add314 ("gre: add x-netns support"). The respective change
>> for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
>> did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns to
>> another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag from
>> ip6gre tunnels to allow moving ip6gre tunnel endpoints between network
>> namespaces.
>>
>> Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>
> LGTM.
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>
> Did you test real x-vrf cases with the three kinds of gre interfaces
> (gre/collect_md, gretap and erspan)?
This was only verified in real use with ip6gretap.
