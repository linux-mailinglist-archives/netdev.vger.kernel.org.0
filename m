Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C06406F22
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhIJQLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:11:23 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:59105
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233332AbhIJQJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:09:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOme+4a6sHhU6Atl19NARD7dL++YNJvvQYiJL+7grUYLIdx/3QLkMo8t8vgbKdmQiSjD5QL12zyr0gqiJnnG7dfa4/lWJSQjUyFoZd25DlfaQVO+maGvI6mCJyybLRn+5wiXkQXXE/NsGtvAKPjdwJnePsMT/Ck6TLSTmuagNIs60GkxtV7oZMb9wLOJ+nSSNhhyCltZgQiGndYWJk4edMJavchHl1Yf+Aautnt7I/c84hlh/b89Ycj7EGinxPmIGFZ5FSHWSit6tti0/OY7c0RZ2lg2RyMgmEJlKe0ZMcBAtA37FQlIGg0sCnqM3ItV5/yiIApjV5NaXwfYqPrvlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RWqshuUJt4MwYDZxaRfz3PfeusUa7v9Ig5zzMvV5bCw=;
 b=Vsk6hOIKB9hzwmTIZpsL2rMt0mSfuCuRrlheSq1znTWsa6Oa1u03YKWMtNlczIt3Lf/fzzQpFEieBlTp6P67E/arrSd0wTS+Ndiyz2MIwc+k6T2bb6DgjEY9/wZiJBXEh68zKH3lljbKNakcgJALdEUNQEVG6QZJTN/JwY03JVr9FPoQpboG1/2zZbwSSd47dprUoC3XIthrKC8b2JStt+oOWbLRBYIWzzMPQEI6NOWMe2frbdJunQxtgsbJMp/0i+0hTdufuCHNsnC1B0c1far4a2cSBtlDnRyp9p26B37QQot2gAiZOvz8nSzIygR1wrkO9Mc0dRQ5kWeq+pILGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWqshuUJt4MwYDZxaRfz3PfeusUa7v9Ig5zzMvV5bCw=;
 b=Sr8xAEbV5jK8AY/0fSVHC8HhPgWqVQIFKL/WtUIHDPO/2QOl1tqJCPKKIyJZRiMRWn5KPrGKnPcyGtMma1NW/T93moLZIvqZ+/Uqog0K/nUWGBi43ZpOSIWKI8SQz24gTSC09IhdiIF2Xn4nXcAULp9ovpLcds/5VAh/SFJP1oc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:06:01 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/31] staging: wfx: fix misleading 'rate_id' usage
Date:   Fri, 10 Sep 2021 18:04:48 +0200
Message-Id: <20210910160504.1794332-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1a9a9d9-61a4-4a61-339c-08d97474e278
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3118761BCA3F525594B7EE0B93D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29itTLI6GgbOtsD/NXoYXM09PhwnOZqSFTWPsGoIu57dKbzOX+v4a0OhcVvQX0jiZB8dSvCZ3GZrJIX8MR6EfRU517bH/OZdJ+bvIansF5o2ksdBlwgsFwADMUMfE3WWgPsEPuq3j2ph4fnbZhuJG7wvYNtIGVsCzI+a6eJMC5/DoSvSn80MpuOMcFdQrFll2rDvOBvaUdaFhkIsza6RlfcaI7dsO5aKIvDMlk4XgZUSNhZBdHqAJnh2RkHXMVMs+dS0rakW87WKRwI0CUDau4EyIKRxAgjIu3NJXRye5s/kSExKvP8BTqyrki0ZtPCvYRkC+gSqyKnQ3ueC955qLiGEkGl+i2EcVc11+Aa8VOOWElGfRLNbEUnSmz5GW8bBD3RPT/I2LjCnvN/VCEA2yJTENcsX/Tyzyb9feE+lvjVldVHZEA7s1tHxd+GDRuZd6q1zeDPcYccgqLQiQq4lBW1rDeHLyHblSo3DlG0rAGp+2JVbpvoACuD5srAnYJUYIi4KFWk2x5w0lYxPEEFhSwbkC+RYu6AyjMXER+TlHvLiYMLPrYKMIZHTJI34joPi7OLW7nd508pbOd2fBl6W25aD/YkMCb2Djfr9BPe0oV3/9vvpbZSr1qIkcSrJBf8cY1KaRVXnpDMZkgg/VRcPzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tnh6WmhKeGc1aEV3RElnM1JMTjNhamdwalVIU2ZabWdZUGsxWFNZcHFJalI5?=
 =?utf-8?B?RjBZeFdLSVBPdXE2amlwbHNxY3YybGJjY2tSMEVmL2owUHdmMHFEbXhvWm5F?=
 =?utf-8?B?V1pVK3o1aGF6Y2tJYk8vZ0V3cjFQOTdCSWs2cXdqSm1peUJhSHdMb2YrbkJv?=
 =?utf-8?B?Uzk4clRZc0srSVoyOVZWYXovNWRzMFZrbFcvQkVQbjRrblBJZE8rR1FkTHhW?=
 =?utf-8?B?MVRkZ1I3RXovMEgrQ0lCUnY1K2RqV3hHdm1nMVE3LzZmQmxUZWxIZkszOG5J?=
 =?utf-8?B?T2N3TUxHWHRYSkV4NkZLV2QrL0dPcGdwN2VHSEdFM1ZIMTV2N1BkUzQ1ckI1?=
 =?utf-8?B?UllFUUpYVCs2aXFHamI5SjFrRHd6L3J6NnhXNGhjcWE1NDlFNCthd0FWdXgx?=
 =?utf-8?B?cTQyZGR6V0lDeC9NamovYjR1bzVSY2ZBSUJaWHZ3UnJXQjVjQndZcWZsU0tX?=
 =?utf-8?B?VS9PYXkxUjAvVGszMGRzR3Q2NGxnT2JCa1RQSVk0cjU4R3BWa2RneVB1NHVP?=
 =?utf-8?B?NHQzTzFram9IT2ZrZHNPMlZhWmdrQ1A1d1VJeExYZ3JXRk5jZzZ5VmltWFd0?=
 =?utf-8?B?VzVWeCt3cG9YN1RzZk1VbzlPNmp0ZktJMGpLeDNNRHZhT2ZZNEJ0RmVQN2tM?=
 =?utf-8?B?aEM2aGc0dTlSalhTbVdBcFVGakZLZnliY01SYlM4MlplTXQ4OG5Dd0Uyd3Bi?=
 =?utf-8?B?NWh4L0lPRVNyYWJsQ2kvNnY5bFBlT3JGVGxvNXBtVjRvNmNhUUJHb3JtR1NX?=
 =?utf-8?B?NkIzNk1kMldKZ3dXK3VYaVlkWVVQb1BLVWxGWHdMb3lvamo4SWpxeFAxMlQ3?=
 =?utf-8?B?WHF3SC9GREpOSnlKUSs4bkRiL3kyWXk3MktVUWZITEdpOHNGbllmYnFnUDJz?=
 =?utf-8?B?alFrOWdSSXFNQVJQL2hkMXllTWZkbVJJOFpDcXNHMXF2eWdTTUtodFZnKzRK?=
 =?utf-8?B?Y1FpTDZaZ1ZmYWdFTmRRdVpqTzhUcFl2SDlYT29QVWJ1djk3THUrS2duSkNi?=
 =?utf-8?B?V29lL2NCSFlvWlN5OEVOMEFpbnl2b3lsUC9CMm5MTzcrRmdXY3BDdEoxOFIx?=
 =?utf-8?B?QTBCdHBzQ0VlZnRtVjFkS1hWSkkxa254WkZXcG5yV0NkTHVhZ2JJaDZlTFhT?=
 =?utf-8?B?dU5XL2ZCU1ZwZ3hzdExzUnprU3k3QnAxamFYVnRNQzNYa1VLeHByQmI4bnho?=
 =?utf-8?B?dnp3bkRjWGdIRWlMMGs0dzZuRmN2TzZPc3VKV0VTWjRwejByWDZ2M0xBeHZq?=
 =?utf-8?B?QmRJZis5MVdjZllRYWR2T3lEdHFkNURrS1F4WFJDc2llaGprMVlpelpvbnFE?=
 =?utf-8?B?eUs5a2lzaXN5ZlJjZVY1RVFzQjlCdnZCaXZFRUJjZS9pMW5LVkxMbFpRUkJl?=
 =?utf-8?B?ekNWYWYvSjZ5bFdFc0ozWFNqT2Q2MklaVVc1b3dFbmVhS0FuMnR0b0tUNDN0?=
 =?utf-8?B?Vng5c0JSL2RlYk1JYVpaWGdoaTZva1RjTkV1RzRNZ0JqZ1pnQ2Q1VWp4ZktU?=
 =?utf-8?B?RE4rRzN6b0s1MVZoODBuYnlXUXNzY1JBM2VPSEJsa0hORkFtcG5wT2V3T0hB?=
 =?utf-8?B?TWg3c0V5VDhwTUhMbGRHS3hMV1FWUkRCSkp2QnNOQitmNUNNUjdoRVZQMzJM?=
 =?utf-8?B?RDJiaDAveC9ialdNbjY4UEh4SUxEZHdNeEhHUTFtMHZSY0JxSmM4ZXZrUmNT?=
 =?utf-8?B?UmRZelNMeG01OGliTy9DZkpDYWFHVFJzTU1tMlg1MUNJa2tlejhDWFNub2dQ?=
 =?utf-8?B?ZjRxS1NjQ25NWDJGbmROcEN4aVhIeXcrWTVwdHRKNUVIdCt4Rm55bXdPbUl6?=
 =?utf-8?B?Njc1d29sSWgvTzRhTVV3cExxc2JyNGJwMzVrbC95SlhEbXpmN3cxNENtZHUz?=
 =?utf-8?Q?EufJryITuCkrF?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a9a9d9-61a4-4a61-339c-08d97474e278
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:01.6791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aow5JgABJdvunVLqda3t9vgHabx8CiMait8OKd4hDgXPxf6Ll1qFsUuDbLz2JavUhkU1lMf94ocIkS4E1T7ZQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRyaXZlciBzb21ldGltZSB1c2UgdGhlIHRlcm0gJ3JhdGVfaWQnIHRvIGlkZW50aWZ5IGEgcmV0
cnkgcG9saWN5Cih3aGljaCBpcyBpbiBmYWN0IGEgc2VyaWVzIG9mIHJhdGUgSURzKS4gVGhpcyBp
cyBtaXNsZWFkaW5nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwg
MTUgKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNzdmYjEwNGVmZGVjLi5jYWVhZjgz
NjE0N2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0yODUsMTUgKzI4NSwxNCBAQCBzdGF0aWMg
dm9pZCB3ZnhfdHhfZml4dXBfcmF0ZXMoc3RydWN0IGllZWU4MDIxMV90eF9yYXRlICpyYXRlcykK
IAkJcmF0ZXNbaV0uZmxhZ3MgJj0gfklFRUU4MDIxMV9UWF9SQ19TSE9SVF9HSTsKIH0KIAotc3Rh
dGljIHU4IHdmeF90eF9nZXRfcmF0ZV9pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCSAgICAg
c3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvKQorc3RhdGljIHU4IHdmeF90eF9nZXRf
cmV0cnlfcG9saWN5X2lkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAorCQkJCSAgICAgc3RydWN0IGll
ZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvKQogewogCWJvb2wgdHhfcG9saWN5X3JlbmV3ID0gZmFs
c2U7Ci0JdTggcmF0ZV9pZDsKKwl1OCByZXQ7CiAKLQlyYXRlX2lkID0gd2Z4X3R4X3BvbGljeV9n
ZXQod3ZpZiwKLQkJCQkgICAgdHhfaW5mby0+ZHJpdmVyX3JhdGVzLCAmdHhfcG9saWN5X3JlbmV3
KTsKLQlpZiAocmF0ZV9pZCA9PSBISUZfVFhfUkVUUllfUE9MSUNZX0lOVkFMSUQpCisJcmV0ID0g
d2Z4X3R4X3BvbGljeV9nZXQod3ZpZiwgdHhfaW5mby0+ZHJpdmVyX3JhdGVzLCAmdHhfcG9saWN5
X3JlbmV3KTsKKwlpZiAocmV0ID09IEhJRl9UWF9SRVRSWV9QT0xJQ1lfSU5WQUxJRCkKIAkJZGV2
X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LCAidW5hYmxlIHRvIGdldCBhIHZhbGlkIFR4IHBvbGljeSIp
OwogCiAJaWYgKHR4X3BvbGljeV9yZW5ldykgewpAQCAtMzAxLDcgKzMwMCw3IEBAIHN0YXRpYyB1
OCB3ZnhfdHhfZ2V0X3JhdGVfaWQoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCWlmICghc2NoZWR1
bGVfd29yaygmd3ZpZi0+dHhfcG9saWN5X3VwbG9hZF93b3JrKSkKIAkJCXdmeF90eF91bmxvY2so
d3ZpZi0+d2Rldik7CiAJfQotCXJldHVybiByYXRlX2lkOworCXJldHVybiByZXQ7CiB9CiAKIHN0
YXRpYyBpbnQgd2Z4X3R4X2dldF9mcmFtZV9mb3JtYXQoc3RydWN0IGllZWU4MDIxMV90eF9pbmZv
ICp0eF9pbmZvKQpAQCAtMzgyLDcgKzM4MSw3IEBAIHN0YXRpYyBpbnQgd2Z4X3R4X2lubmVyKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCXJlcS0+cGVl
cl9zdGFfaWQgPSB3ZnhfdHhfZ2V0X2xpbmtfaWQod3ZpZiwgc3RhLCBoZHIpOwogCS8vIFF1ZXVl
IGluZGV4IGFyZSBpbnZlcnRlZCBiZXR3ZWVuIGZpcm13YXJlIGFuZCBMaW51eAogCXJlcS0+cXVl
dWVfaWQgPSAzIC0gcXVldWVfaWQ7Ci0JcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXggPSB3ZnhfdHhf
Z2V0X3JhdGVfaWQod3ZpZiwgdHhfaW5mbyk7CisJcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXggPSB3
ZnhfdHhfZ2V0X3JldHJ5X3BvbGljeV9pZCh3dmlmLCB0eF9pbmZvKTsKIAlyZXEtPmZyYW1lX2Zv
cm1hdCA9IHdmeF90eF9nZXRfZnJhbWVfZm9ybWF0KHR4X2luZm8pOwogCWlmICh0eF9pbmZvLT5k
cml2ZXJfcmF0ZXNbMF0uZmxhZ3MgJiBJRUVFODAyMTFfVFhfUkNfU0hPUlRfR0kpCiAJCXJlcS0+
c2hvcnRfZ2kgPSAxOwotLSAKMi4zMy4wCgo=
