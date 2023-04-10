Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5082D6DC453
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjDJIjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDJIjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:39:40 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1308270E;
        Mon, 10 Apr 2023 01:39:39 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 339N0QVJ020708;
        Mon, 10 Apr 2023 01:39:26 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pu5ms790n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 01:39:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diaihohjafiAILmTS6byYkh/krvDgIJNoqZ1Qd/1VQMnOHEd55tUffKcTwNap1uJzG4aaO64AWze6UP+cacvw2Tm1hsWyaaoEsGloOKMrcSpJToXrfH4JsSwvknzJcLOkrn/qagysRVuvgRbBWUGkbTSWC/TQOfBkeMk0MQy12GQ1oxT5U+2dk6TjnnenVMkGAEO5dBUQz3hx0oeDpSxt1C/iO0u3WH94iQGOail8To8qHQnhpymHbk7ENEj+Fs50907tBAsoMEV4/E3EPJsiRkYWT85k57yPFfgwvFxcVVNjg4xV64DqxcXejlPa1RRe8fpFN2dGc0bSGofSJ9rPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHd8PX3DR2SBYltmGTvKPSj/CsgyNIxxe8KmMc5n1nU=;
 b=jn1qNxsEKlbC0koVHz9l30c9GMpqpOCVINcKoV+CKHllMtZG71MOeO1G8S0snvD5wMTTadSczf0/mwEjFB2aDzUXavFSvr1UZgGSBqPjvRz263bC7Ts3wHMvtNtgJQswX2iM7WMFkaU0JSIcjzQOrOJRRPhuOmGOvF7WzdGkXQw+f6ZdE/WAHPpv75VfqCCSIEoyYNq7J5ajn8ppLakRXvnwwtpzYUIUxS1Y+5PGtJYZfrqshi6p/V8tNx8pFNrGIFFXwoCetW13ul5z4J/TBzcbThNnaq/43KQ4Rd3MT+zKaFhiHoPFA46rxrMjUBbkrunakRuVvuhuWK//ApidhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHd8PX3DR2SBYltmGTvKPSj/CsgyNIxxe8KmMc5n1nU=;
 b=ctM+rxgieu2MtGMgv7hofLGCbbK+sQUCc76kyHFs/gArnfivhzdK4v3d3nlwF3TgIJcyQyT14BrJKa1rMnuy7TTEvlw2rT1IG8APhE67mO3bqJsX84Ri/r405FmVwOr//ZqXCela/Nf/N971FWwFns4SL0MVn6hZmMnksor6vmI=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MN2PR18MB3526.namprd18.prod.outlook.com (2603:10b6:208:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 08:39:23 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6277.031; Mon, 10 Apr 2023
 08:39:23 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v2 2/7] octeontx2-af: Fix start and end bit for scan
 config
Thread-Topic: [net PATCH v2 2/7] octeontx2-af: Fix start and end bit for scan
 config
Thread-Index: AQHZa4fzUQN565m660OOYnGkZZBwew==
Date:   Mon, 10 Apr 2023 08:39:23 +0000
Message-ID: <BY3PR18MB4707B8BFB55EDE119C44FB1DA0959@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-3-saikrishnag@marvell.com>
 <ZDF8+FIFqyKORLjo@corigine.com>
In-Reply-To: <ZDF8+FIFqyKORLjo@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy0yZmNlYzRiMi1kNzdiLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcMmZjZWM0YjMtZDc3Yi0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIxNzAzIiB0PSIxMzMyNTU4OTU2?=
 =?us-ascii?Q?MTQwMjA5NTgiIGg9IkJTVVR6cnQ3c1ZhU1VHRGd4SE4xZkkreEpNWT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQmUzVXp5aDJ2WkFmVUxnVDkveXF1QTlRdUJQMy9LcTRBTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRkFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MN2PR18MB3526:EE_
x-ms-office365-filtering-correlation-id: baaabf3c-3678-4e28-72ae-08db399f15fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTaG3dkXd1mwyi8+/NROnpQmHhtqIMQd2ECkLzSCTb4/3TOJ1E96HYSZ/te6PEuAPg+cbZ3bSS/Hp5Z74qOoVjk+vu3InCC8c+5EpLxQUkQ1Oah3E07vc++0L3Hoe2k+ITNpsM5uqaQFqlcvhpaq7T7WQd8gYbJECXA6kuOUbPdn/XJmrX2OzZIGQQbuzskRs/3s1ynEqjeJN4GO6JBYnijuS6A/jgI4DUvm1t4kY0GImRZtrltSjz8HnC2/eXLlHuq4ZjC6B2LwFDjVwNZ6M3IYexXJm2XDQBTnn64hafdX5iwR6PLUDOA9k01+LA+LCoQLUR2xNwPuWixoSaz8yfObm3w66TBlkM7I/BXULEruuRxWdJCISNoNUQe7RAnIGaXVmjH4KiwzhmEW8nUeWsickQw9Ax3hDkr8Qu9SivNkG6mbcpLFZT8qHlGyraiC2Bdv2QjEmANniPAcR90SgfCWSeHBR1PjDew+2dCiW2KOyFsQ4nY55aAF3jwAi9M7mh1MFESr5WQmO3cj1tdn7eTVfXRvMvk5gCQY7C84YA63liuLM2durRYvlnSVSk26UwcmB5Acvn7ChMk8xMZelXnK0cy4/Sdp78FfJav1KTl1KPn/NFRdjvGO2AMrH/cs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(366004)(346002)(39850400004)(451199021)(7696005)(71200400001)(478600001)(86362001)(33656002)(55016003)(83380400001)(38070700005)(122000001)(38100700002)(107886003)(2906002)(54906003)(316002)(53546011)(186003)(9686003)(6506007)(26005)(5660300002)(6916009)(41300700001)(64756008)(8936002)(52536014)(66446008)(66476007)(8676002)(66556008)(4326008)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AQeRVGsz6/LrEMX99SUd/YgmpDE/vLh+5lfh6x9x9daQ9KXvREzWd83kt+zr?=
 =?us-ascii?Q?3YCm5Itly3+6tOcN3zPUGlbe2rdy8hWYw4RMFucAK585LxFVwKRTd/FJ9UGb?=
 =?us-ascii?Q?I5aFontq83oSeke6gfj28fVykGfoj8IXVvSx/omdhmBHvemd9YthdiSg4jQi?=
 =?us-ascii?Q?2XQ622RfKaDBzyWr1RIQKRNtfp9eA2rvKB5QPfk1m934mTD0muClaHCQ2hIE?=
 =?us-ascii?Q?BXOHCHbDVHeLj1XQyuNeuTNdfCpqEpPEgaQKdZxMJbYBOD29BTyoP1JrVuo5?=
 =?us-ascii?Q?mZxuE1Lu6/wa4myhJBwvfvKuE49QDCOxufIVTO190PAGY18pkFetoUDDvsBL?=
 =?us-ascii?Q?WoMNN4P1JnbrV+nK6ya51tZL89UnoTltNM8L408alS6haqGNJ20MS9vkM2xU?=
 =?us-ascii?Q?ao2mMJnP7Lwe4YGlxVrjs4USKXkIhxhLlF21RjQpYIFriDRH5M/2OIfVL8+U?=
 =?us-ascii?Q?mDHYIZp/RMWhVGSLIDFq7CeLLlL9GpcJt+q6p9FtwkuH3j/Y78BJu6AWmL18?=
 =?us-ascii?Q?ZRT1zkLzsJ3B3sUGk6HL2btimcPV/mOFmPpb+aw1SO1QHa6tIq2zD0L3okoF?=
 =?us-ascii?Q?RKdLutRKsZLK/DW4LSNZKgVCSuvXCFH1Zqgak5qaoDqRtCiNnvCXWVTEZ0IB?=
 =?us-ascii?Q?bpTkEh+uqDAoMjw/44yIhlbC2usDE770ltn+lmxAJxoR+/Gh/Qd1Jc9zZXMY?=
 =?us-ascii?Q?uqO0qQf0DuazS9FniEuxmrQCbmtZFGqu9AYG5JIOhPctEwDpnIO0CFmClCay?=
 =?us-ascii?Q?6h42fSE6fgizne9soEZTz9oTji/+7FsOH0It+08V8W61z9NwhDdBhC/2pxXI?=
 =?us-ascii?Q?dlnNxQV5zjBwygDcKZ4crrDRS0f9JWYBDi0TrSh9pAJStyGTYJLjHU/SdBbS?=
 =?us-ascii?Q?Tc/NQmZwAJD9IvC0kRukO7NBxIDFqLKRCBPSR3jp0etd8uKTp9x+7oamhMsz?=
 =?us-ascii?Q?HsmvaxeZrc7Drm0JBErsR5TCK/dXK0xJatjpyuUpo4fxdoi2Z/zhRJtGqmWq?=
 =?us-ascii?Q?7eN0GILuI0rt9Ivzfo/oVVdFQ5Ly11/PJg1cnzZ+J0pqg+01l4tX/LB/Woyb?=
 =?us-ascii?Q?5KH8vPhrCOJKyUII8AJ+rsFMJnGZdTpwLWyWL8WuZfS2A7dChfQhfpIhzBYt?=
 =?us-ascii?Q?yBS4PJaz7wJw2La+zkI39w9VH7HOfsFnvJgOypgcdC9s1mrpaC22FpXBQI43?=
 =?us-ascii?Q?OKbckhBP4p87S6uMMe8OAN/hRbKuw8f/BL1CA31b2ZIGNDEK/7U3fH152sF7?=
 =?us-ascii?Q?WmNiMQb8oytUmxS1cma6vGY7UIQlGHgz6f9wKvhXko7fgsHJyWH5fPC7lGia?=
 =?us-ascii?Q?9uNsdQHJMGdUgIjv1wlTwpcamaRWkPXjV3iwZnX/WD456aG4uU7Oc8em1CQC?=
 =?us-ascii?Q?ufY/10u+9nLeCEfimk2NJklsvvkDEfearWwKGm27CX1ja0CRpLsBsgwmooEf?=
 =?us-ascii?Q?KPjuRCZx2ygHOkBNKLjb2iMdsDsKIZoaifvLDGcxeXctH6auE8Ir5MbcwZP4?=
 =?us-ascii?Q?uHy11ouqDCpFFsuCSTi3apWRUot9xInLTsFDS/sNHtotzv2X7GgukhZDw3je?=
 =?us-ascii?Q?3aFHR20snFLzpNEMntxyPuzhJSRr1f85Gt+jC4Lf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baaabf3c-3678-4e28-72ae-08db399f15fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 08:39:23.4311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sQu24L5UDgpXNje2M6UdLey1N033AcrEqVa+SBEWZyJSYfjG4wKDmLQMjxwGyElnjsQYh8Q45vM5NaVMsP4p8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3526
X-Proofpoint-ORIG-GUID: BSeE8Ne7cjgLghq7Y4MlbHmzADtK-3T0
X-Proofpoint-GUID: BSeE8Ne7cjgLghq7Y4MlbHmzADtK-3T0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_05,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Saturday, April 8, 2023 8:11 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; richardcochran@gmail.com;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: Re: [net PATCH v2 2/7] octeontx2-af: Fix start and end bit for
> scan config
>=20
> On Fri, Apr 07, 2023 at 05:53:39PM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > Fix the NPC nibble start and end positions in the bit map. Fix the
> > depth of cam and mem table configuration.
> > Increased the field size of dmac filter flows as cn10kb support large
> > in number.
> >
> > Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>=20
> Hi Sai, Ratheesh,
>=20
> this is fixing a number of things.
> So I wonder if it would make sense to break this into multiple patches: o=
ne
> per thing.

We will break this patch into multiple patches and submit v3.

Thanks,
Sai
