Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F48408B7F
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhIMNDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:03:38 -0400
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:14912
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236893AbhIMNDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEUwUVH5b8oOJgqnH7rhS5BXiYv0lhkWJYQevswXm6GgtlyMjX38N1ISwKWqNHsLp5blm4eEtePLhFuLD+93oPsYsYlJB7HQZDo4AgRjKlcvmO8hhJvxYL0vI8nY6K/2uWjM/I6n/39cFTKMF1LlretTLPyOVWQxwiIREeGcJV9IFMbH56rZhVlkq5rq301twTZvigIUc82I74epbaeVVOSYOlAZOqtHMxd1F7zVADQ+MakRSc2zC7LTip0//jCLALVGuoLGv68LTWTRhvBtzRt7+0wMzmr0ZM/QxBvIAVOZ++RkTE3pQNX8QN/kBqSY1avWLoHLWLqoGxHaNL4TqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Fib8Y8j+Fw/sN2NX69u9T+P9uNpyVHksmDfyGgxLK4M=;
 b=C97lMExusJSKCp9gP1nmzDJzwL/S2zWLnBp7i587Jz3HuNOQeiVjr3BCXENieqZ5h+liz8W/Ph913e/IcuaNKMGEsn2BsRexY1rwfGLKbLlRzcpqCwEl6ohMn1KQs9pNpoUzg0Y32EHvBYsqP9t/cAtPCEDXWl2tc+iivPLqpQeaxDy8iDSbWWZpDFLFUkuNsDNbaAdD4udGam4qTpfF+eKmrcj7/2yfQ2HnX06e8FYN3K0itxRMYQQCqsfYhHTnTTpbiz0GHEimDLwvXBUqWNqm2HBakBnBGzCyYVOWRHf/Pzq8xl4oXXVBqgAOUa75/YGsmHrMUYllWhyCc0RGig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fib8Y8j+Fw/sN2NX69u9T+P9uNpyVHksmDfyGgxLK4M=;
 b=dIKNzk7yEJ2Zx2dqAAi4U7B5fphy7OuyV/eX/DaLEeEOWBFZkBP/tkJCNHyy+0U3It1hmGi6ijd3F+9/P9Xw4kPVLIw1mkDX4YbT846v4duBX9uBin2k3nHizRI+B83zWAKEeI5qhNRyDVN1MSzN7sEQliNXY8fKN38okHQqET8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2894.namprd11.prod.outlook.com (2603:10b6:805:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 13:02:18 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:18 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 01/32] staging: wfx: use abbreviated message for "incorrect sequence"
Date:   Mon, 13 Sep 2021 15:01:32 +0200
Message-Id: <20210913130203.1903622-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 581b051f-27c1-45e9-1842-08d976b6b794
X-MS-TrafficTypeDiagnostic: SN6PR11MB2894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2894C1B44A1A22454CF7244793D99@SN6PR11MB2894.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PUY9Vz078mPn5SaCxoDe+OaiqDgNVHo7XtaekJ7fnvikufd6ylMWQx0ONDnLXeDNawfYh/nhakjXv+cE0Q9QHfXYg03GmkdYT735AdtATheORquw1NwIA8h6VZMHhVI5Q/k8vC4dt0hLlVM3I7QG8VLGgN3NRXF0aC7GlfQG8f9RCLWJ8olT1QZ0zYCLsCfnFLS05H6hE36rNNESrBB9zPoW571IwgVi4yOiu9fnQTprsQ6yBf73TLPPnxIRyuW7C+t1JtWwcjgdzV0jwFH4cRWpHSINW9Os57fCdUcnELHAyBOnhmWKg9W4s9Vwc1tPDbbV+ecnfWHR9UlsKslPvaWG8hs2uwgXoJpl4/ZiqHpXY2ozBClbZ91BfsOaMvu6uy5Z0RmvZyFhb/eJSuV8IMpWuaJ9SVRFI13Iozk+fjDmEfQbaDXFncJnJxljBSdYUcAPAA3aVXBTZYcRvnAiFAcpBFK6xIjsG53J4vk7xStjC8onjcOkvir7E4w+dSJm8d7kmkQ72jWDvghbqXqSDojjcrPv2JJ5l1cSVvfDTfdUCpC4cDJtWld1XABxq8cRFUU70w/+UObS5AdlNcVbkgTaoGCYGxcSjv1SCTG/PKcCx14xQF/RJTlpU3lSxyReYDe3kH3z+9dCt4nCxW5j7YdiRHjgXm/3/CJQeGYVyauo06qCipJnushO9jxXQR/Jt+tIwFj6LzA5mGG2n5aeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39850400004)(346002)(376002)(5660300002)(26005)(8936002)(6486002)(38350700002)(38100700002)(66946007)(7696005)(186003)(316002)(1076003)(8676002)(956004)(478600001)(2616005)(2906002)(52116002)(4326008)(36756003)(6666004)(15650500001)(54906003)(83380400001)(107886003)(66476007)(66556008)(86362001)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjgvWnI0VHp3dGZwM295YnNUVGV4QVAwRGp1T1BRWVJGQ2Q5bHJmblBFalg2?=
 =?utf-8?B?VXhCNnNaNDJIMWNaeUEyNXAwR2t5UDBYcTY2Y3hLMnh1VGVWVURwQ1gvVG9x?=
 =?utf-8?B?WFZoeW9KZlZFRGFpdG50V0tnWGxtUkdVMjJFb1A2eVdZVlRGOFFBU0lkMFFn?=
 =?utf-8?B?YmgvVTdVN1dqNDAxSjRDNmVjTk1QTHAvZzNZeDV5VkgvSmFQYm9jYXpBcVM2?=
 =?utf-8?B?eWxhWmtNbWxMNVZkMTg5R3pyZHlIL3R3Mis1ZmFJK2o3UHNkbmJZN2ZPUWNp?=
 =?utf-8?B?MlFxNTBSNm9uVWdpZ2ovd0F2SWFzb1ZycWNSZWVLNEtRWHdVUndWc1Fza1hq?=
 =?utf-8?B?dWEwWlJyeUVhSndnY0NiUTI2aUNsL2ZWZ2UvVjZPd1p2alhOT2xUTFFYYWVN?=
 =?utf-8?B?bC9DT1U3THYyblMzS0lTMU1WWU5senJ5NTAxdVpjbDQzZTR2eTBJSnNMTkpV?=
 =?utf-8?B?RmJpK2JnWm5iSkVta08rQk5GRndTWU9aUDZJZEhzNWhTVTJIUThvZUc0WkRO?=
 =?utf-8?B?cGFXNHNxaUFIU2FwSG5jWWYwdTltQTY3VE9tbElTZTczYjYzYjY4dDRDTklz?=
 =?utf-8?B?ZFNMUTYzUG9QQUNtMTdaMUtZMERQR0pOUmhVSE1qcWdiQXE3SnNQZHlySnhp?=
 =?utf-8?B?N25DYkZEZDNYRE5pcis0SkxoL3NFaVlBVnFESkVFZFpoVUtxY295bDI1eXlr?=
 =?utf-8?B?ZThCSlZOczZuMlI0djB4ZmJZRXZtZFZ6YnErZnpiZ0ZXdG1DZlk0a0hOSjM2?=
 =?utf-8?B?eThmMDhZZWwvSTJjTnkyTk1SYVhSOTFmQVoyTFJ3eGFYSFphRFdjUWIySTZ2?=
 =?utf-8?B?NUx6azd1OHVlOERaemJWa3NXR1VaM1BGb0tZdVkzc1dpdFRCZ0JzcUVETnJJ?=
 =?utf-8?B?UnlxLzdYUGNvRCtJeTZXS2phcFdnNkt0S1FKaEgzUW1DUlJvaUxaQURtUzNm?=
 =?utf-8?B?WnRkZTJCK1gxUlpBTnBtMmpiSnpPV0NmaHNTVEl2Yjc4ZTdzOTJhTTJzaDBw?=
 =?utf-8?B?cGY0K2tpSWg4YVQ2clV0K2gweW1HMmNxcTlFdGlzdUdlcjRERnQxb2hTMEVV?=
 =?utf-8?B?bVRYNzYvZlY5S0dCYUE4aThYSE0wYUIwanUxbkloc0xTSXE0R2ZpQjZmSyt6?=
 =?utf-8?B?VVRXWG1nVXEzN3ZpNzk4eXQrNFZyQy9vamxoTjdRRW5ueWg2SmNKaC9Ua0Zy?=
 =?utf-8?B?UlZkVDhBSzlwdXhDK25BeDdKamRNZFZyMFJ4RGlZdWsvR1daUFJ2MW5UYlNJ?=
 =?utf-8?B?dHVvSCtBa25zYXIvblg5cWtrNHBFNXVEaW8ycGkzR2twTkNpcUhlUmVvcVk1?=
 =?utf-8?B?MVFSeTJYVkVVc3UvdjdmRVBCbnY0T0JBandUc3FqbFJvckovdHlweHUxMXpQ?=
 =?utf-8?B?MmRqU09wbS93STFzR1hxaDJObkFyVHYwM2hGWTlqMWNXQTd0NFYyOTBJcmx4?=
 =?utf-8?B?NmUzNVNxYUtFa3RiNXppbm5jc2RMaUwxNnBQVXhVNWE0eWRuYlhMZWh1eXho?=
 =?utf-8?B?dS9PTmRQV01qUmlubW9tMksweVEyRXMrSEFscW5ZMXZQc09lOXIxY1Nnck5v?=
 =?utf-8?B?dDJiK0xqQ1B0Z3RyeHRkTlJYNWhqOHphQ3VqRWhoZ0s0ZXRJa2N6eGhrRnVt?=
 =?utf-8?B?TFd0SmlrYytMRjZtZVU4R0JLVU1mNmtuZUVNRE9GV3U0bytFamRRNzlQNjdj?=
 =?utf-8?B?TTNjcXp0dVAwcTUrV0g1Qk9aYitZQU5Bc3pBUmx2ckJqbW83NHBuckRwZnc5?=
 =?utf-8?Q?aucZg5xmoLt7atBumTZ8IQDs5nQU/DHEeDQha22?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581b051f-27c1-45e9-1842-08d976b6b794
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:18.7776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kimGIzapP8qXiru8Rs7FYQD4Qy89CHpQ2ZrsaQU0wUXslk91+WDI8An6gIOguVpnKLa5JlAtVHG7gtCPywFoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgY2hlY2tzIGNhcmVmdWxseSB0aGUgY29oZXJlbmN5IG9mIG9mIHRoZSBEVElN
Cm5vdGlmaWNhdGlvbnMuIFdlIGhhdmUgbm90aWNlZCBzZXZlcmFsIHRpbWVzIHNvbWUgc21hbGwg
aW5jb25zaXN0ZW5jaWVzCmZyb20gdGhlIGZpcm13YXJlIG9uIHRoZXNlIG5vdGlmaWNhdGlvbi4g
VGhleSBoYXZlIG5ldmVyIGJlZW4gY3JpdGljYWwuCgpIb3dldmVyIG9uIHRoZSBkcml2ZXIgc2lk
ZSB0aGV5IGxlYWQgdG8gYmlnIGZhdCB3YXJuaW5ncy4gV29yc2UsIGlmCnRoZXNlIHdhcm5pbmcg
YXJlIGRpc3BsYXllZCBvbiBVQVJUIGNvbnNvbGUsIHRoZXkgY2FuIGJlIGxvbmcgdG8gZGlzcGxh
eQooc2V2ZXJhbCBodW5kcmVkcyBvZiBtaWxsaXNlY3MpLiBTaW5jZSwgdGhpcyB3YXJuaW5nIGlz
IGdlbmVyYXRlZCBmcm9tIGEKd29yayBxdWV1ZSwgaXQgY2FuIGRlbGF5IGFsbCB0aGUgd29ya3F1
ZXVlIHVzZXJzLiBFc3BlY2lhbGx5LCBpdCBjYW4KZHJhc3RpY2FsbHkgc2xvdyBkb3duIHRoZSBm
cmFtZSBtYW5hZ2VtZW50IG9mIHRoZSBkcml2ZXIgYW5kIHRoZW4KZ2VuZXJhdGUgZXJyb3JzIHRo
YXQgYXJlIHNlcmlvdXMgdGhpcyB0aW1lIChlZy4gYW4gb3ZlcmZsb3cgb2YgdGhlCmluZGljYXRp
b24gcXVldWUgb2YgdGhlIGRldmljZSkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyB8IDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggY2I3ZThhYmRmNDNjLi5hMjM2ZTViYjY5MTQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtNjMxLDggKzYzMSw5IEBAIHZvaWQgd2Z4X3N1c3BlbmRfcmVzdW1lX21jKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQpCiB7CiAJ
aWYgKG5vdGlmeV9jbWQgIT0gU1RBX05PVElGWV9BV0FLRSkKIAkJcmV0dXJuOwotCVdBUk4oIXdm
eF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSwgImluY29ycmVjdCBzZXF1ZW5jZSIpOwotCVdBUk4o
d3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkLCAiaW5jb3JyZWN0IHNlcXVlbmNlIik7CisJaWYg
KCF3ZnhfdHhfcXVldWVzX2hhc19jYWIod3ZpZikgfHwgd3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxv
d2VkKQorCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJpbmNvcnJlY3Qgc2VxdWVuY2UgKCVk
IENBQiBpbiBxdWV1ZSkiLAorCQkJIHdmeF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSk7CiAJd3Zp
Zi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkID0gdHJ1ZTsKIAl3ZnhfYmhfcmVxdWVzdF90eCh3dmlm
LT53ZGV2KTsKIH0KLS0gCjIuMzMuMAoK
