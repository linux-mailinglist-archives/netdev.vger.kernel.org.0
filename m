Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940A66CF0E3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjC2RT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2RTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:19:55 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD1F10CB;
        Wed, 29 Mar 2023 10:19:54 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDTRsO008928;
        Wed, 29 Mar 2023 10:19:42 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pmdqhkt41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 10:19:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHCUbaydku4yFp2ATsU/09k9mgNWL4YmfO0s+He1JIxtv/KjJ++cXRIdUTOeP+q9sR3hRIW2TrKzIB3RbvxDFfzzh0oA2i54NwqBx3r9i8LyTwrvE22rU+ZQL5CRXgZNTVquGW1itW32Bvzc1OHYo0a3BqPGMKouLYvQWETZshlOsk4KqEkm+PZZAbnfnRAuxIpvfXHZTNSVc5Hc3WJCEdFInhwasIxf3gtnrU2ulwt5w+/lAAG1YyYrRy3KfZWwa30s58QaxG80/lcDZVHTSLIzc5LAjCIHSYQ7JOnPtpV/6p9OnAMIMX1RjAi1T4EdnGoiF56fe/trkVvjHAnZow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBMCdAORKtlFtNhn+w2PwtjK2k/y9gyAnFndTiVY5lE=;
 b=ijCu/LwXCcC/ZG3edoBMS3sAh283KPa8iQj5UVPpirbFtw9Debhn7fw/qBVz+5KWt7YDXUBZpjK/QHMOqtqZjcSzVveFp5FgpBaG41w7MDU+UiB117I0GWrU6VQzZ8JE1fsrlkWe7fJHVt0obgj3xRDA404tgcMAXhaZiHV0kMrFmW7++T3QoJ75cnOXMCs5X/97LMkZP4DVXoEiCZZAeaBrBbbGIwububwf7YluXsDrghBEVDX2/fn8AfU72sjKeAFlVCw53/VRnU2Yx0rpm7fq5Dzn6H4LVgHg4d0CUvezSMaZ5H9v3ef8R1gwyoPbwyPuvh0V8VElqiUaHd8Zyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBMCdAORKtlFtNhn+w2PwtjK2k/y9gyAnFndTiVY5lE=;
 b=teflkoQIozea7CwsyTKstk3CcWE9HT5b/QlXGgYXyjdz2GZsjRk5AKbnT1l0XeB/MFhzt0ombXbzWmwaIa9Cz8bjIuVVaIdL91nBbSmj2chEoU4eJHKqbkr+YQ9MLKkcwd1LeQ1Z5ztJJRMeJ+qkpw2jZx8N5FeHXmhwCN86iMg=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by PH8PR18MB5291.namprd18.prod.outlook.com (2603:10b6:510:25b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 17:19:38 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::6968:a4c6:1f37:3ec0]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::6968:a4c6:1f37:3ec0%8]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 17:19:38 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "naveenm@marvel.com" <naveenm@marvel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>
Subject: Re: [net-next Patch v5 3/6] octeontx2-pf: qos send queues management
Thread-Topic: [net-next Patch v5 3/6] octeontx2-pf: qos send queues management
Thread-Index: AQHZYmKkh30hN16dn0isZP1bs+NTRg==
Date:   Wed, 29 Mar 2023 17:19:38 +0000
Message-ID: <PH0PR18MB4474D7DA8B343FB842A9E649DE899@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-4-hkelam@marvell.com> <ZCL9CbpBuH0M3OJU@corigine.com>
In-Reply-To: <ZCL9CbpBuH0M3OJU@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctZTAyMjdkMTktY2U1NS0xMWVkLWI2ZGUtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XGUwMjI3ZDFiLWNlNTUtMTFlZC1iNmRlLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMTUwNyIgdD0iMTMzMjQ1ODM5NzU2NDky?=
 =?us-ascii?Q?Nzk0IiBoPSJVeFQyNUowRzVaNXQ3elNvS0p5cUVBUzBXclU9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUQ2?=
 =?us-ascii?Q?LzN1aVltTFpBVjhBNG43RjVscWNYd0RpZnNYbVdwd05BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUJRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|PH8PR18MB5291:EE_
x-ms-office365-filtering-correlation-id: bffcd033-4473-4894-b79e-08db3079c696
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KNUC9LV4HuIOZqMPjazfQLYeZPtlQDkS4uaiIny/OfCrGb0KMPizNaNKRV5Xlp/d5hi1mnRxItMCFtbmg5nms+vkx24h4hxmxlMQemkKVq5fykNT5THfBFNkL0pGRJqpNnLwtjP+m1aCULVQzSgvyJRx/PE01mnSkpZtMQS75reEzun+0L+/LYCio2khxW4UXH65H9qpTpddG0AbHnKpU66At5MWfr1VO3MPFEBkEtzsqpAbmycGGQDpfNrU+5FqxCTH4jzvuRQdUEKijcI1pAclJt2Tjm50qeD6YJ5CIPPjKUzEGm4CMJAbdhg/wKe15LFjBwoFn6BywmzFkVwO22ZFwIlo0Fnf0WazDQi6+W6a5uaON3+wjaN5/fneExCwWHkEsMyCkvt+xmPucifwUUOZCuhcKzBE1HDzkXBxmt8JoFeIn23xkR/tAXilYvGUDOm7kd0kvDiHskbUOzA8hb8kYc0upavgCj4eZDT/WCG8iJWLMvubID4JEtkjwwAlBdYVJtqyEzYAEOI7Z1yqUCZuticW7KffP46ZnCwQfV3kbw9bH9RPvO2Iin0/Ho3xZaNGmCo3ktuDhMMvNrgSCCFnId2VC2ytiC2Rv96pIrYeVGvlAWEVnaDfWUxuMNlh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199021)(71200400001)(7696005)(26005)(6506007)(478600001)(6916009)(316002)(54906003)(76116006)(186003)(66446008)(66946007)(66556008)(66476007)(64756008)(66899021)(8676002)(83380400001)(9686003)(122000001)(4326008)(41300700001)(38100700002)(52536014)(5660300002)(7416002)(2906002)(8936002)(38070700005)(55016003)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m30cBokGkl3HZamxj/ea0ibu5nKosI/JRJDxHGwFDsoXwoYkmozIsqMb5fLL?=
 =?us-ascii?Q?BKpOZktakNZyuNBpAzEkvcG32Dvl0KbC5R8Lto8VgODB6D3m36r9uD0DIkVB?=
 =?us-ascii?Q?qM5GV/SjlCQqMPc0dehoJ48PVPOrAOegjR5bBXkl1jg3q1foDja3TZ5PuLpn?=
 =?us-ascii?Q?q0jwxSbqH+vcpguPZX9LYaXCOccxfzj3HTovWkbHT/2O+iw13gbrblcJa9V2?=
 =?us-ascii?Q?OrI/nt0RxAw+NoJ07rdyk6zxdBSq7dwJKqO2UcDxAVQeTPsIbAt5iir48A/P?=
 =?us-ascii?Q?UT05uwv0PUhEAr+p+3GboedeXfvOLI8vpFWi/acKOuVmJDNoJ4KJJRv8IcIc?=
 =?us-ascii?Q?dJugzi/JPiCio8EQ7Rtgb0Kt/SpajEvJ3mgm7CXNXRybAUVB75OYCmM23nHY?=
 =?us-ascii?Q?/8dHNMDhx+Q9V637citTa6D8+pptQ/Kc/Nzd4i6arWgrvIdqnhKFWR8J43FY?=
 =?us-ascii?Q?AivIguNGocrwHQa6tdBLIJYFq4Vo0oDsrqUQtv+I+NZUevegNTkIa9PDx4hk?=
 =?us-ascii?Q?2ebA2uixCFuWc9JzH0zToON3jPj4qkmgfHq25ecAJTmGjl8llMcP4uVogF9k?=
 =?us-ascii?Q?cFvc8Vbu6EAobJpIvPs+kcLV7uTc1cAVG6zhBFwWdLp3DiuTj7HCOuy0oOX6?=
 =?us-ascii?Q?brDmcseYv3yLURXjhTbXsvxXYydDBAnVJQ4tReXxBXIGz72FWyAspgX79PHl?=
 =?us-ascii?Q?2YcKaVRPMemtp6hGUbt2zs+CBiJoPbKgzA1zkLmDUc57o6jcsApnmF490V5p?=
 =?us-ascii?Q?hg/5TEUBWSPrInT4eArbSjGgqSdNn++OLtItlncgXEAfJid259idKLgzB46B?=
 =?us-ascii?Q?1QKgma7cN/rvkiQmilxOSvDzTUgPiVckAdp1rB3A7GUCfdDz1seq35c9UXFq?=
 =?us-ascii?Q?8xYmVw9xY/PNjHtYdjcJF9HKyBZ5mpD653ri87IrK/GKoTxWYnnMA/XUpLka?=
 =?us-ascii?Q?WnGIf3AYUnM9rzeK/iotHPhy0s1G2IT+Qju1dVef5femZ5msXlfcaEy3/Iax?=
 =?us-ascii?Q?+BxSwlx6t1si8u1eCZ/bDUbX1ACIQpZ2CTrGMEUZAgSd8pbcERcyf6Ic9iHh?=
 =?us-ascii?Q?g9CdIUciCet0UFPM9HtmHwHGu5UxZdF1Gt7k31nF8IABWK5+n3vBpxsQRlw/?=
 =?us-ascii?Q?R9h/HOc3w6dP8lCTQ+aZZC53VWSIElrTCTwatRBMBCBnI2nqPl5xEXxufZ0l?=
 =?us-ascii?Q?B8Hh6I00GmbToVm+EfkAkGp3pAyj+eJtyfAUpl3V1aKhQDCEd30YqXkv7MYj?=
 =?us-ascii?Q?ySw5+6qcZyLNKU+AMpv4hRUScqupC08WwNpeTxjmv94WIZ4LeKgg98sm8CBb?=
 =?us-ascii?Q?4tL1lqamzwNEryN/2wHdTXcehzl2B+6siypowUkDfq+EtTsC+tVEYdXL254b?=
 =?us-ascii?Q?378eOwC3x5GOMsvBu3MlBPeOWz8On8KnufXDdLPi0Tp0SjlkKino2lOwggaQ?=
 =?us-ascii?Q?ymSxO/9szex5ZxlwT2DWLcvihQHAMJQ4d4peSW7qZDsIN49B9CNotd9Jc9gf?=
 =?us-ascii?Q?c3ySQXgFwn4yEcWLJpqX5ve8eXMhCwCOT9tHOIQzkJ5c1ssf7h6kwo2UImgA?=
 =?us-ascii?Q?bjbdGlEx7bIBEGXTrvg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffcd033-4473-4894-b79e-08db3079c696
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 17:19:38.3598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rceKUP5UjtmV8j7t1R0+83PBcpHTiWL0dowW/krN9STBpQL8MLcccF17I0LfF5WJf2aMTpS7Hp9egeXyzaxs7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR18MB5291
X-Proofpoint-ORIG-GUID: 5upjUeSQJVUid6omyJVHX0azXMYLRNF4
X-Proofpoint-GUID: 5upjUeSQJVUid6omyJVHX0azXMYLRNF4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_10,2023-03-28_02,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sun, Mar 26, 2023 at 11:42:42PM +0530, Hariprasad Kelam wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > Current implementation is such that the number of Send queues (SQs)
> > are decided on the device probe which is equal to the number of online
> > cpus. These SQs are allocated and deallocated in interface open and c
> > lose calls respectively.
> >
> > This patch defines new APIs for initializing and deinitializing Send
> > queues dynamically and allocates more number of transmit queues for
> > QOS feature.
> >
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>=20
> ...
>=20
> > @@ -1938,6 +1952,12 @@ static netdev_tx_t otx2_xmit(struct sk_buff
> *skb, struct net_device *netdev)
> >  	int qidx =3D skb_get_queue_mapping(skb);
> >  	struct otx2_snd_queue *sq;
> >  	struct netdev_queue *txq;
> > +	int sq_idx;
> > +
> > +	/* XDP SQs are not mapped with TXQs
> > +	 * advance qid to derive correct sq maped with QOS
>=20
> nit: s/maped/mapped/
>=20
ACK , will add the change in next version.

Thanks,
Hariprasad k
> ...
