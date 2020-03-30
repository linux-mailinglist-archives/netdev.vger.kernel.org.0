Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D6197CC2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgC3NWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:22:49 -0400
Received: from mail-eopbgr50125.outbound.protection.outlook.com ([40.107.5.125]:45354
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729976AbgC3NWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 09:22:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpBKrILBDTVRiLrZO/dzJ00EYjpWVda1iQs/Q9NOdXHx541X8OAsg5Ulaup31yAJLS+K9bBFMbyywa0eBeOb+uWSMxhJzgB5QDs1NEY8OZgaQG/Ginottf+tPbC8MZReUkiFw/DdYsoSxdkRqeqIdpnoVDy4OAQj5UVixKRRG1GgOg+DWVRMmh29VwJu2+GqBgwLSmXx+AkSu4YG7WbKeXfltNvaUelutZsCQfOwGs+7e76Gt75WTVpH5sFCPvQYQUky3yHL4QAvzrTIXufArvXRCuHxt+jKnAvXuZ4Dlz5b9waUE97rwtJSeOG2vW7h7zDUdOt9nNeqQ4aBdTMRPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnsmYwmAS4lxLze6hO74E9+y4r8eKrAkKex5ZWZrdU8=;
 b=BYbQbq6MHbp2iIi+93mEjjHK6osUfaQwwiemZhsQvd5P4fcnCBBxmXdfu6dD3iI3JkzYsWVutnKXaYgPrwyVedEF+3FKbjftjZWY6S4myVi8pTvN3YHEq9E2Gz26/nCVi18YW+ULtQyQ6qRK1axbXhaRL2jLQBGudx9zsN6w1wV2lIIUCJUEzKFf9qng3PNrcqtsFoX0xPeC159LmnFt0f0JJq3JyqYzYLnObqYyAeb015wfIVdec3WN1cvpPW2SmtKXpvXiOekSDiJTpmSX0vvb4CNMa33FpCJ36BbYcuamNuj4GwQqc1HivEbE2ISVn8kWkQDovW26j0UYwPSKBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnsmYwmAS4lxLze6hO74E9+y4r8eKrAkKex5ZWZrdU8=;
 b=g8VjKeebLfU2m/LrQanI4zDdjRTJ24CqeanH/AV0qawhIgfl3ECM11MCRx5T6L08/Bal0Ovd1kKuhsMFJ4SjVYb5Erg3oFTA2Uz5pDNf4bu27NDS9Bn7Mw9d9S/RPpj0CwJp1ou2u78KyczFZujsrfw8ZEIx9EJZ2TNPPb2Sx/4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=rasmus.villemoes@prevas.dk; 
Received: from VI1PR10MB2765.EURPRD10.PROD.OUTLOOK.COM (20.178.126.85) by
 VI1PR10MB2253.EURPRD10.PROD.OUTLOOK.COM (20.177.62.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 13:22:46 +0000
Received: from VI1PR10MB2765.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e58f:1097:b71d:32c7]) by VI1PR10MB2765.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e58f:1097:b71d:32c7%5]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 13:22:46 +0000
To:     Network Development <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: ingress rate limiting on mv88e6xxx
Message-ID: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
Date:   Mon, 30 Mar 2020 15:22:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0402CA0015.eurprd04.prod.outlook.com
 (2603:10a6:203:90::25) To VI1PR10MB2765.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.116.45) by AM5PR0402CA0015.eurprd04.prod.outlook.com (2603:10a6:203:90::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 13:22:45 +0000
X-Originating-IP: [5.186.116.45]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cb58fd4-89cf-470f-48fe-08d7d4ad6f37
X-MS-TrafficTypeDiagnostic: VI1PR10MB2253:
X-Microsoft-Antispam-PRVS: <VI1PR10MB22534BF846CF5707299B9CD393CB0@VI1PR10MB2253.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2765.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(376002)(39850400004)(366004)(346002)(136003)(44832011)(316002)(16576012)(6916009)(956004)(16526019)(186003)(54906003)(2616005)(81156014)(26005)(81166006)(6486002)(31696002)(52116002)(36756003)(478600001)(86362001)(5660300002)(2906002)(4326008)(8676002)(4744005)(31686004)(8936002)(8976002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: prevas.dk does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vc8zI7/rLsSlC2ZLBIXrh4z1e2FGYHd+SNXvkYFN+pdG6MI72gHr3KIao2OSs69No6E93XxcQscoCgeJCF8buk9R0J4KjhDTZ4tAzuqka2N35FaYYVrwgjtDKn42pcMWG/tBZVFtnt4+FSDesOr83dd+yPeJXU5e6avRunvd1ZXYI7d2H91UaQ+ZCiTZj8I5cl6FTrLpv4yy6PH7DnWBV8hSSF/BTiXE8DDOg5MgJGf52ufgx+MX6RGkv7YvWHmLFF1YCwV+NciO5UIJGxEHDTEx66chQ6vVFYUGzVHr1zjYtu+eaHWrYWbM+5Nuypbl2DWS/keEH2SvEgSH6z3oj9m8xXxyb4NG4zRmrVd1A9fpVzX4QPSaFkNEhInD4kM3sOJIEKMPLBXbML/90ApMAOpDTwjYX6K8bzmTnaDHTuzLxzcGSuxf8V8LCurFOvno
X-MS-Exchange-AntiSpam-MessageData: 0Nujdj/meaQZ972YoUsSBmL9/IiA5mdD1p3P5yYmHarm8BYq5bLmWzqPJUHTL2+fMlfx5Kc8bGt074NtzlhWzixAakdN9++xDX2i8jhacXESFuFWRCgFz9ytl6OKD5k0J0G9FkjIYxePXIGVCMqQIg==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb58fd4-89cf-470f-48fe-08d7d4ad6f37
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 13:22:45.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8TIazX12cSCXkC0L6hsHtxeVNzhLIr3h2sssF7YAYgqI4gZqhZInQAtvZHDtJuz8LNVwGmVXmmbKmCplSNLBY5FdRlkS7nEoE/V/hxUEetE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2253
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying to figure out what the proper way is to expose the ingress
rate limiting knobs of the mv88e6250 (and related) to userspace. The
simpest seems to be a set of sysfs files for each port, but I'm assuming
that's a no-go (?)

So what is the right way, and has anyone looked at hooking this up?

Thanks,
Rasmus
