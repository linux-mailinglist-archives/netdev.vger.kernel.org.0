Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79428446151
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 10:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhKEJYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 05:24:55 -0400
Received: from mail-eopbgr1400095.outbound.protection.outlook.com ([40.107.140.95]:7040
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229971AbhKEJYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 05:24:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzlLP8/GEyGxwnS+QHOyd2y9XKSZfWb1NTYUE5BBGFVhVUcyuCJA6JeK5guSpnm9a5C9KtXvLsoqF+z1Aa5R5iNVV/AQWyQOtTm8hImXLRTMZIFKIQ8d2B+5BTp3CyBcgjBOH8EjUtLvCOXocGwedGAtg9lD5y+bneGvYCD9Mz3hBIozwbfPRdFGEX/fuJBY7+UqMVKMGbpWG/nRr8RFrI4oBWryKAlaEzKJeMXad+ZDjevVE6xyR6/wKRfJDzH/w2CB2Yq+mhUOecGgptVJkUTqVpm1LsgHmgyzLVeIJtjnHu3LQiJtxQBMhvlS+oQwF8N/RyJvU+hLPM9yH92BYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+eKroOIpBbR0cyuLmyaqygvaoSAXAvOLSHMogMPLlo=;
 b=JWdMhZYGOVx62kkLqcH4YF3hNIDnOVra/BWX/Y9Lqle2bOD6AErCtaWpe/hJlJbXZGXUyd1TcT4M/6Gj+ifZryLdWRleWSH43H83bTUBpuxjGeQ3J0099NPlpi1E4JI9WbWGMabci5UN62c0pVLW0DyflpAvDjtFUIArJ5vIu6GBNwXwhEOOUUnQAbbMBT52F2nLHukS+MrYpXEL93c+539eAU6rKd8AK/EY8/t0bTbXm0gmQeNOm8LgX7fXVLEcsQY9gtNar0Aq+CSByGUO8EyfDmefpF7pG7hhpoDEguRMgUSJPGZS/6BHuZ5d8KBfQVHUqfEsqSWUUGpikz35vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.ust.hk; dmarc=pass action=none
 header.from=connect.ust.hk; dkim=pass header.d=connect.ust.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.ust.hk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+eKroOIpBbR0cyuLmyaqygvaoSAXAvOLSHMogMPLlo=;
 b=EF+u7IlUu+zXYI8m1p5JmZnuQNoNcorN666IYylD95i0KRV0bfWtBbK1IZVgBimUyI0S18rHuhfKXlKO+i55raGF+EPFNMQX91FuSlkFtQljc8cyCsMM/OlNFwhWAEu7p+HR0AA1ZqRqf2AJY3ZFOpPW7d3Peoqm8E1bbb7tVgI=
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:b7::8) by
 TYCP286MB0958.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:ac::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Fri, 5 Nov 2021 09:22:13 +0000
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04]) by TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 09:22:12 +0000
From:   YE Chengfeng <cyeaa@connect.ust.hk>
To:     "krzysztof.kozlowski@canonical.com" 
        <krzysztof.kozlowski@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wengjianfeng@yulong.com" <wengjianfeng@yulong.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: nfc: pn533: suspected double free when pn533_fill_fragment_skbs()
 return value <= 0
Thread-Topic: nfc: pn533: suspected double free when
 pn533_fill_fragment_skbs() return value <= 0
Thread-Index: AdfSJhbChn+moLKRRQKXKwLgcIIbAA==
Date:   Fri, 5 Nov 2021 09:22:12 +0000
Message-ID: <TYCP286MB1188FA6BE2735C22AA9C473E8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none
 header.from=connect.ust.hk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4561854-0ed7-46d4-5ae9-08d9a03dc04f
x-ms-traffictypediagnostic: TYCP286MB0958:
x-microsoft-antispam-prvs: <TYCP286MB0958C0A863986713C583ED748A8E9@TYCP286MB0958.JPNP286.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AFHs/HSK/dS+Th+gX0W8d1t09QMbO+eu87+leyrThbGEzH84LAZLfiXhMW+e+qxJsyFNWPsFwh6LOD9PUzCdpmhCFUfk+FD75EpRa/r7yL+dT1EUCyF5T5owD66bXP/242Qzcx2JlmigAU3K4SYIjAfZr4R7VCmhfA8kB+H6y7bLZ95cevksyedQ69CaqV9CUfQz5EmpMAuy1wZ63v8rS1uXYaOGXNXDLeo+3qN/gdYc3z1Jx3jbdRJ2ttXP8EGkbVxcAM3lujJMEHvndGcTGdyqjY6p2H2C4VlASEkRGAE692SGnE0RxrF69rtoIC9CQNXpx9UHy/zOzxAXdO+w9dpY8KYuBSfswUMLGKDxcbpZEXkcCfyLxh3v3l59RLb6tavbDSS+YDqLlWcbxiadNP+9HDidXsFSMB+7SI3j6Fmka37auLBUgm8T1YDa0s9p2z/EfKvGpWmLUYHhGzivt1e7kUJK+QzYJA5Tal1FRcJr6oX4bxBhwFyJXAHxpi+zwTYfzhuPXMyTKBcHedkrGwL11BQH36+unhlOlMWBVRzCpaMkx+QjJaHAEIwG7E/hWyWGDZVUFq6UcvuH6/RWeXmZBP3Qru6BiKLgjXV2UzEsK+nvzMn6NXK8kCDvyyyV8hZjMtUEzUW8Fbd6cqtIsoLyAgy7fc0qv0VY/tCBRZvScEyb2i4VzbrRCgm4h8FR4PgipAfQ33S/vbbDP+NzibZrI8Lw3/3sw78fS4AzaxHU6Ygip1yyXZp8uANIOn8WhzboHvxB+jNJoSONigw98u/p+X7M/kKxGzTYl+UOKPk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(6506007)(5660300002)(4744005)(786003)(52536014)(38100700002)(316002)(55016002)(4326008)(9686003)(66946007)(186003)(71200400001)(66476007)(110136005)(86362001)(7696005)(966005)(38070700005)(76116006)(64756008)(8676002)(8936002)(508600001)(33656002)(54906003)(83380400001)(2906002)(66446008)(122000001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cXRASEMN+3zx7yE8/NVtM8HZnYYMuxK0+4NOqfqR91Fc5kyIdyhUVnzY29gi?=
 =?us-ascii?Q?LtzMErvdf2wgO4tdLJkb4IUW8xH463BHR9re4WU7+eaXA/dbjmXuPP0aPUo0?=
 =?us-ascii?Q?VgilC3W/1X4lcDFfvVlf9jPurPMUTGqwTQGMFFgYaXSZt7V/Hf275K58qxl7?=
 =?us-ascii?Q?H3RRJo135KpNGvvhTuhpTRoyZyMQ5MmyorUqPhFg9BSn7YhqxUaHqMjIbN/j?=
 =?us-ascii?Q?NuFQDSUdQR/2QmvyKXU+tnF2iExP/VENKxecGBB+Td4hC0ZTeNu0k91B7T+y?=
 =?us-ascii?Q?SMauSNAHJ8mwtHA/DIAGLTF6YCH0jOIPj1gy79ktg9q9W0Ej9olXz4fiby0b?=
 =?us-ascii?Q?F8J7G1YYlLLOCBRjmfVcFJwH7dpigZ5r2a8tiF+U40vCAUOX74dabFO67ECh?=
 =?us-ascii?Q?4ZsqVcC9i1AnRA3/YVGO+CUksw6XyuOZYyA+ho2k/TFPF2ksnx4eR3OSuVqm?=
 =?us-ascii?Q?wCGzRmjXs0ECYto5ZS8sQakrG7JLbNjQjU5hIQgR+NOmOcFAbh7+Jn6PZB9G?=
 =?us-ascii?Q?Kyvy8vsDvZznIdZ9nx3BOudxKW71c7JyYsTdaYpSU7OyMmguZeFlOJRLfdNb?=
 =?us-ascii?Q?/SasWStpRxkMUneeqxxX9ANI7ZZRSqqgo4VhZTnqnozvc2dI6zPu+14CdD++?=
 =?us-ascii?Q?fHJyL3Ve34KK5gAL7E6t+NpqTJwDF1IlFeFX+LHFtZyzw6Dw8uFgMxBlMKRv?=
 =?us-ascii?Q?6rMIMPHY0Utqc1SqtAg2NDHcgXlOYwFCqRowd+su12EGpwcFSbCeaX5Wz8Ya?=
 =?us-ascii?Q?btPlWvbfV4GUYgEdElCwYqgn4SBmn2wxZaIWo+5FIqiVMeof4RupZh04ODx6?=
 =?us-ascii?Q?AwTXbHlDv3p13RnuOHeEZsRFGtuipQ1gsVToayn4/BjvgZHIor4L9wuAya28?=
 =?us-ascii?Q?2DGKXNwh18xEdilAAss2IMo/Dz5S8Z9HnUQHEygHYacERZeMZRKUuiDoSG65?=
 =?us-ascii?Q?yVxfWHwxJj/GJN8+65R0Fq/UiqXRyFtOLWKtRkfrKeN+c/PUpflPfKVxmxWz?=
 =?us-ascii?Q?tS0HkhT+tGJQk7qISwme2AJs99geHHYXQ2erD0FZ6ftPTaAtJr3fl8bqggKo?=
 =?us-ascii?Q?H00isWwgzcA9I+IMmi7hNFpQcwCCGa5QergJMhJUbKl3kiqChxWBdPOpwBzu?=
 =?us-ascii?Q?2C4VmcMWqGKqxG4An19TU5o5VcwK39NSpeBAh0Uljs5Q7ebcwBh85FLEd+B3?=
 =?us-ascii?Q?VbPNWVbGtQLjEy47KtSaWCyyxwTZut/rlxnaX70ZyGQ5ORWzsz/ktP+1Kvar?=
 =?us-ascii?Q?LduD25+FENfqaOBW7+XFhmW/wzNVVdN+xyg8nkye8vJi21AIDne30K8nr3/A?=
 =?us-ascii?Q?WAAMntonVek5ZhNGf7dYnsKD2D9fvy8OBVrEsFTOH+WUmQza+33LlDNr3Huv?=
 =?us-ascii?Q?WJ9Eor2NjNRcohSjmFqIAgpkbNujaR6i7qFbgPN2FkJyX70Rvhr/cjtCyM/h?=
 =?us-ascii?Q?wxIkyj8b6gRKHROss8BViT8+emYCf6T1VNwuDq0dXDfknHJbqjFoespRdtPi?=
 =?us-ascii?Q?0m6JrhstVSWPinKtgrFiPMRnnD17rJ3p8dsSTV9pLcFzaWvGo2gMomr0FFlb?=
 =?us-ascii?Q?VkxvRT6WkQsbGAiEsusdcTg+EebegMU6TEWPGZEUdwL6B/75fon6XJqhqTCp?=
 =?us-ascii?Q?ew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: connect.ust.hk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e4561854-0ed7-46d4-5ae9-08d9a03dc04f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 09:22:12.8246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6c1d4152-39d0-44ca-88d9-b8d6ddca0708
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4H7YcWmY4zHogwr0PBULaLWBMYpGX3SAChTX8pddbPItkJr24jJ8rqstOSwY6ESnbZTF9GK0SftwxHeMr4OFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB0958
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We notice that skb is already freed by dev_kfree_skb in pn533_fill_fragment=
_skbs, but follow error handler branch #line 2288 and #line 2356, skb is fr=
eed again, seems like a double free issue. Would you like to have a look at=
 them? We will provide patch for them after confirmation.

https://github.com/torvalds/linux/blob/master/drivers/nfc/pn533/pn533.c#L22=
88

Thanks so much,
Chengfeng
