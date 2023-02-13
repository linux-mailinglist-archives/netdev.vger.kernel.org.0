Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA47693E26
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 07:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjBMGTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 01:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBMGTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 01:19:20 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDD6BB86;
        Sun, 12 Feb 2023 22:19:19 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D6Hjd2003837;
        Sun, 12 Feb 2023 22:19:05 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98ukg6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 22:19:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrH1juskGDXIECo+6K/X29vSnmnrDboTQTB5LQpQ4HZwZ17F6u04c2/UtMUoAdpuOS7Sk12PLxpwFthl0ymm22ODn31Mfer6Kef8JYrWsv9Y3aismHV8RyNV9Z1Tp8tIRFOpMKNPKY72eFN37dzABMPaSaHRSHR75FeY6JOP66+xENNeAw3V0cipwQ+HBcXJHm7q1Ujjd3CjRnYxmZcPekkrxyXPmdkl0/CkmJxy8t6luzxQx7c/LZvwTP6P07gD1VpjcSzGoiGKv/Mz58lb2vfRjqxII8+Mn/CrCjbwbEgodaz/syyFGhJw22oFCLduRO4V8ykqYRgYaEub86z+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLTBM1bZBXvhfDE7/aoh1RXixkboNeFUyrVhAxgibZU=;
 b=I0+HfGNT2l9ncvTkd3+rhwlu6HE6eOoVPGCvMKRKVaMbW/A3MM08zT46OFq0l3cgg9OC0gJDtjxxYYdnaqj0ru935wb7HXstMX2zpM+c/nd/1NWKi3xX97EZxTwqYMpFiESLrOsPGii3TfpVyCo8n5fpWHhoC7nKRYyz7EuhrC3VNMRcSP9L63G3F8RtQe2GKKcnkdtU8LDYCwOdULB8Uy8RRynL8EW2KcxZkeX9QJfo3nm7FyBkKio0fUkGy6D9yvNTKyknQhwMsqPuWnK2MDVgRop+5MFXNLhSEEF5MwDgyl2VmD/F63WE3oVQ9ulpoamo8KAZWBmDdFJKTDF1OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLTBM1bZBXvhfDE7/aoh1RXixkboNeFUyrVhAxgibZU=;
 b=mGJ1IDDYfdn2pnX+Z0lYuFSTSw593SsdgCBHXwu12lq49tyfTAJSx2znAHxmCMsPYWt0rx+NvGisEIu81JPGOfA6PkbPXP2zE2Qzns/iV/ttX96lhStDvDaxcqwcHYEfObOeSUvFructUJyFkgkV653pgoZt4smwDDorCz45jb8=
Received: from CO6PR18MB4467.namprd18.prod.outlook.com (2603:10b6:5:355::12)
 by SN7PR18MB4016.namprd18.prod.outlook.com (2603:10b6:806:f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 06:19:02 +0000
Received: from CO6PR18MB4467.namprd18.prod.outlook.com
 ([fe80::8c60:52c6:59eb:3696]) by CO6PR18MB4467.namprd18.prod.outlook.com
 ([fe80::8c60:52c6:59eb:3696%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 06:19:02 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch V4 2/4] octeontx2-pf: qos send queues management
Thread-Topic: [net-next Patch V4 2/4] octeontx2-pf: qos send queues management
Thread-Index: AQHZP3MQZvDbYymWt0CrV5vTm5G1tg==
Date:   Mon, 13 Feb 2023 06:19:01 +0000
Message-ID: <CO6PR18MB44671631BA1F0148A8B9D405DEDD9@CO6PR18MB4467.namprd18.prod.outlook.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-3-hkelam@marvell.com> <Y+ZfAC/5NjiuPfQE@corigine.com>
In-Reply-To: <Y+ZfAC/5NjiuPfQE@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctNGMzZWI0YjYtYWI2Ni0xMWVkLWI2ZDQtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XDRjM2ViNGI4LWFiNjYtMTFlZC1iNmQ0LWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMjg5MiIgdD0iMTMzMjA3NDI3MzgyOTI5?=
 =?us-ascii?Q?MjI5IiBoPSJHT2UrOVNrUVNWSUhIQUNqaThBaWkrZm13ek09IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUJO?=
 =?us-ascii?Q?WjVvT2N6L1pBY3FpVk5rMG9yTmp5cUpVMlRTaXMyTU5BQUFBQUFBQUFBQUFB?=
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
x-ms-traffictypediagnostic: CO6PR18MB4467:EE_|SN7PR18MB4016:EE_
x-ms-office365-filtering-correlation-id: 2d79abbf-ec11-4298-a239-08db0d8a3344
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tDSvOp/1LvuN3T9Hd1X+88w+MVo/cW6Ojs2o8dfSBdORPj02ADLn4xX+dKfaCsOcezGSWMhMBPboKzMFmAXfynJK6uCGLiZ2pMQ+d9uPOOD+dNzn0z9YBJS9PSgEUgbg1Y8MVmc0g/Ms0HI2rAodIVf1q/rU+hBTqvXFlqOGO9Z1lI+D2gSGzW9H1YHxN899RhkahqchrBktEUqxRGYUMMLY8vO/CDHI7YuAp78ku2MS5ny2arQ517YnNhwyjGbA8m45K/EUfKJGUWJaGQS7Yoff9Co1EwfGP2S4zEjXwzZjC8Q5DVlv3G4FgoQrjPqUyfPxG9+nXfYIy9jNSwSen1a0IIi3FjLnVbX5AAQhKlHT/ZxKHNXvkATeqeBc2ZxaAaIDBD1q/vgQ3eDKkPia7K4BkIB3mIKJfOOAvuixB3V36m3i9NDWyXJHJzCCjpPldhi68Xg+CtIcl2C9CuwtMzNf9l1R4uNqaH5EiSsaZtpTOxfrZOu5PLr3O5faWyF+7oxCFVziEVAV6+klpWYta+UeTl4Tnj9E+9BIAXMNkTI9VheKHcyOharmiSSCpn+9btyQi+75JIjJUbz6z13W9Hx+gfgatF3X/jjy6dx62aGNIhN7qr3hPCy8rNWm35NkxMStnvO+slJ7sJN3+4wJx986gszv7SSJCqZsV81qFqbB5FwBH0VwIR0AZkmc7s3URt4VFUfVXgzAAjuxgnHUPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4467.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199018)(66899018)(41300700001)(54906003)(316002)(4326008)(52536014)(64756008)(66476007)(76116006)(8676002)(6916009)(66946007)(66556008)(66446008)(38070700005)(38100700002)(33656002)(55016003)(86362001)(122000001)(7696005)(71200400001)(186003)(26005)(6506007)(9686003)(2906002)(5660300002)(8936002)(7416002)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AkA7ffWm0y+f+Qn4c7p6LeG5tHIC4NkgyRJRcH9UijOPY9SAqbNdShyq8ryk?=
 =?us-ascii?Q?jLKAq+15r+Jdo1lokZceSKDu9OTMidWs6l+7mGTcK81CP2T33HVTqd4gQyOb?=
 =?us-ascii?Q?aq6QCK96Z+2a0GHDyQ4bu+7Ykn1YeISQVKM3hZ3Wlhb14lt6eGnDSKIcPF6I?=
 =?us-ascii?Q?m4xSVoMWBgcNQRbAfV0xXUb2jMK2cfUke4hUhqZEjR4Um16ewXLSZqTNpEYx?=
 =?us-ascii?Q?Ia9Lj/d7uuVbWjAhEzVrjf1XQmICQYmh8Eg+oRsCBnLM3qF9eXoYEnR6wko4?=
 =?us-ascii?Q?grxZcx8d0ZUQa1cCHlwO30j+yQ0Qzmp8hnw0Im2JHHQnV4agheebwPReUJzR?=
 =?us-ascii?Q?0WeBYMW1W06KS8+f1ds+LhCi3efVVpzy11NShi10Jfgt/SIuvIlE49HT5ZVb?=
 =?us-ascii?Q?kUfFDJc9WEAp63WuTiP8Mo7CSmCTpWkETa652H8Dq7kr9NA103OAjAyV2QjY?=
 =?us-ascii?Q?uU8pkS2ODs9F4Xk+FqbJkmm9DvpOtW/+pNYC4DXzZ591QKcpVFXYNpSWSJwX?=
 =?us-ascii?Q?1wQtooPY/cFGQ+5leMZNiHrBIza04ro1MjilFZlNlZ7tTogAcjxxrp1crLsF?=
 =?us-ascii?Q?ErO9cQdpqrwUW56O0g788nAn2ZonQBpyBlgTfoael5I2NGh0g0CbaI6/bVNB?=
 =?us-ascii?Q?T84sXffVg7weWpspH3qSzf1xYXnTvL+/dR7HZpgQUpa1lCD+qbkFPxHE/KJ8?=
 =?us-ascii?Q?U86qt1VFUBkekCbxT9UIJwvS4vEIKpH3Ms45goLxAfdDKIYSKKDEC7afn8Be?=
 =?us-ascii?Q?bI7TpHyleSB+ZJD69KV6ltLP8QDOT1yedq+fepkdgPkD0QXXwf51EkvE4pTf?=
 =?us-ascii?Q?cLOR8UkcM7HeUZ+rTuIzpudOpGEbIhNUEeIFkKS+Alv7UUFRtHwAm+u6iilj?=
 =?us-ascii?Q?eE76mJk8fFQApKRb0o6S3Zis+aEFdsb4SY1xqoKXzWY2NRbtfHMufRsyIi61?=
 =?us-ascii?Q?Q3kj0X9yIHD73QtNtCB0fWKcfOXZrP1uBSBV+eaeoXJno7rk6I/btgoKuFI/?=
 =?us-ascii?Q?Eiz8iDMhwx1YyJBAou+xjfBpUBz+uGKuyZ8eCw8ssNp47J3mMzxlCdsNWUeV?=
 =?us-ascii?Q?cEoT3xPaRHB0kXq9dXZovbNvut4kjeATf9ytQsWotftqm+aJSFA5kz9IES9H?=
 =?us-ascii?Q?okRwtuR1neYJnSHs4RNPWHGLVbM3rcEaQgPQ/GppD6uOCATmuo2IszEzs3Ik?=
 =?us-ascii?Q?Zj9N5ro6kK1is+J4v9sKlj6U3EdIY93GaN/R0GF8A/we3/DbcJ2fonjAIxk9?=
 =?us-ascii?Q?jM9pbeXluTNeJkH0Dqkbev6OfWMxwK54UTwapnL/pOl1zWD1ewl/QDa76Kdn?=
 =?us-ascii?Q?2WAC2tqQzudx/m/82hrSa+72XoOIVX4iMED/7qLIKeFE4VDmT/ruYbRO9QrZ?=
 =?us-ascii?Q?H0BQZCvLr7mjvSvdc1q9ugSHPo4sRUBzGwVymW0925koaCO1EIeSw2OwJ40c?=
 =?us-ascii?Q?4evfS8GKFLPsSIfw/6aG2oKsCbcgZLPpASugxBruC3QYUKJGuIgu3zVvG5Hm?=
 =?us-ascii?Q?h6K0+yXMwZa3upHdF+gXI1DBoVput2m/j1lPbRPMcT6kvqG9gC9XIWTmAOnL?=
 =?us-ascii?Q?+JBMzwPON1L4TORcxoXxV6APi+qAAYWFO/Ebicz2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4467.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d79abbf-ec11-4298-a239-08db0d8a3344
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 06:19:01.9372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5TWKdAhJIu+ZEDyQIS/j4IZsxMyhqWMJ+X/xWQwgxUhYu++4DJflNujWAo6wmLC7IQqMGcHbZeOUneHhASiFcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB4016
X-Proofpoint-GUID: 27-uWUfcYJ8s1kGfv-HGTKIGWy-jDuxu
X-Proofpoint-ORIG-GUID: 27-uWUfcYJ8s1kGfv-HGTKIGWy-jDuxu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_02,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> On Fri, Feb 10, 2023 at 04:40:49PM +0530, Hariprasad Kelam wrote:
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
> > ---
> >  .../marvell/octeontx2/af/rvu_debugfs.c        |   5 +
> >  .../ethernet/marvell/octeontx2/nic/Makefile   |   2 +-
> >  .../marvell/octeontx2/nic/otx2_common.c       |  40 ++-
> >  .../marvell/octeontx2/nic/otx2_common.h       |  29 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  51 ++-
> >  .../marvell/octeontx2/nic/otx2_txrx.c         |  25 +-
> >  .../marvell/octeontx2/nic/otx2_txrx.h         |   3 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   9 +-
> >  .../net/ethernet/marvell/octeontx2/nic/qos.h  |  19 ++
> >  .../ethernet/marvell/octeontx2/nic/qos_sq.c   | 290 ++++++++++++++++++
> >  10 files changed, 430 insertions(+), 43 deletions(-)  create mode
> > 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> >  create mode 100644
> > drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
>=20
> nit: this patch is a little long
>=20
ACK, will split this patch.
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > index ef10aef3cda0..050be13dfa46 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > @@ -463,12 +463,14 @@ static int otx2_tx_napi_handler(struct otx2_nic
> *pfvf,
> >  			break;
> >  		}
> >
> > -		if (cq->cq_type =3D=3D CQ_XDP) {
> > +		qidx =3D cq->cq_idx - pfvf->hw.rx_queues;
> > +
> > +		if (cq->cq_type =3D=3D CQ_XDP)
> >  			otx2_xdp_snd_pkt_handler(pfvf, sq, cqe);
> > -		} else {
> > -			otx2_snd_pkt_handler(pfvf, cq, sq, cqe, budget,
> > -					     &tx_pkts, &tx_bytes);
> > -		}
> > +		else
> > +			otx2_snd_pkt_handler(pfvf, cq, &pfvf->qset.sq[qidx],
> > +					     cqe, budget, &tx_pkts, &tx_bytes);
> > +
> >
>=20
> nit: there are now two blank lines here
ACK, will fix in next version.

Thanks,
Hariprasad k
>=20
> >  		cqe->hdr.cqe_type =3D NIX_XQE_TYPE_INVALID;
> >  		processed_cqe++;
