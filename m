Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F10408BF0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbhIMNHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:07:22 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240214AbhIMNF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:05:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nddEfKx6wxTYP3fTe5m7mV5BI7LJnNvAafe3xxKj5mnh18BuXBe2E+DPTYkcERy83C/3eBd9m84yH7vFCetctMQn7sdacwgjWuQ+ATRZtpO3fiZw/aU5ReRhzeZL1hcaxEMpjhl8RQiTh4+C+2nwZYn1M0MXWNnc1hb+3M6oTfpgzSmS5ML2k1fKV3JvJfFbKimkvkBqV1cg7NV1G3zdGtQbDf1/2Q8GYLPHSNXRqANmo717LXckjYHDnVKUq/lw9b8tCvSOYW6ZJl7rsnZF08mVIl0AgtnMmdxbL0sGGy++C8uCf8AbddIFDVExWlCaBhdB087X5zLx4lXuopQp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NVQa1Hl+G/9t4WPq9A8FoAFRyiuHTVPsPDclPMhrcNY=;
 b=ldOpjwK9JAnij9f3NaDKGVBYDtLpyCRS7mRJj1TbD9aoj2M6zfaDZnPxxpaWdEOySh8JGH+PVVcoHzqz9Q0dkibxAibKWYh8UXbeuzeyKFxyxoj35+fivogT3MMSuVTL12051LTHFJ17SFVG79m7Tkfi6ITB9b/8loYbURNvFCXhL7DYDf4A7WM8xrshh3gGz7+SqZYNWK36JWSVi8HC2D4U4M1zPiHCyvNv0fGFgYvT5jCK7Em+X/d/tjG7mmXeq54SoTN3DM7khhwZEzaZ41qwRgEXOlbl+bN6W+gXukfVSo2Be8az8Dh21h9m43ZqgGX33kM05IPA8MLNALMCvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVQa1Hl+G/9t4WPq9A8FoAFRyiuHTVPsPDclPMhrcNY=;
 b=ad3yuMhsaj9JSnKim0V/rFUCHeOmwwedM0H04cT9NRD0iC1JtaTHdTvIOMGktoJFMvLxWN1mAzFlWLKoFRICuPVKWiRKE0An31YRkVUP7b1WxBqYlyUweln1OIWkBFAqZk9Zy22DNw0o14y0CkpKd0kbTTFHd23ghHqVoHuILe4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:49 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:49 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 17/32] staging: wfx: simplify hif_join()
Date:   Mon, 13 Sep 2021 15:01:48 +0200
Message-Id: <20210913130203.1903622-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31d99350-ba92-41a0-8d78-08d976b6c96a
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860ACFE4C2AF5F82788BE9793D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsRKnF0pb0cIQiHjjI/hdnwzII4TGfPCOx9pumC8p6PpIffAn96foX1Vr3lbKr9FW46QubQHtvOpMK/zdgYseo8qsVbBFghB5H89NylSlONuzuRErprHi1K5s//OfJ/D/ZcZ+1jGD5EKHbIp13EqGZgXxP5TxKG5sy30P4ZdBLozgaqZguvA58cNj3P/2E7y4nm7ccqgbBjTDmi8P87FZqomD4Hu5OIYtpzoIv3F9gsE1xe9hxg6ftQqRPgr5w8z5466e9gK7ngPyNYxPbvW8tLG1dA/2RWARKQTqJD4bEN8Q0xpw02z5db5TUyqiW7T6uWkQxlgzIUssHIe1xKVoq/yx2G7WagE+JV71UwsEf4MBGn0gX9Sl9DwHNB+EI2FXNmiSI/xmy5YaaUQNPA+QtUkao72Zz3oRhJfygFXJOcUmsa1+1vocpOOfYbTMbW2HimAR0TF4+uTD9V9DBDrvgJi2kFAEZsD2VeUv+gHti3nSd7Qis01lM4d9PHnXGcrD6LgU1HHitDe6ss2XRJ3vVHzBM0SGHUZKPzsF6pu1JdGNZW53C/KHEb/YrgivN9tUKV3tTETSkYYsBqHLFTBzRWRGiOSQmdDCbXcrAfgzYtGgosvde6U8g+2saNGPYFYmrgYaGadvPEuhIYOfZ8t+jF3OYKxGoxtZopdBCOplM9xoKWCGBlKOKzY0rvkz3vM9LVa0MWFIP35dNCi4/IJKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(4744005)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHREajhaMmRkRU1GeHdGUkNOTzQ2VE9GY0hldERqVWxuRkhoejlqbXhTdGgz?=
 =?utf-8?B?WW5tNTNIbUVxRFJNNUJCbnF2Q3hIZEFUdnlpcUdMK2dwc0NCYTU5UkFlVHlz?=
 =?utf-8?B?UFlzd3paZlN6N0U0bDZYSG1QOG5QYy8zc1d5RVYvQTdsRmViVGd2T3VCeFRW?=
 =?utf-8?B?MHlmMlBjWHg3aUpuM1ZZVllXOFBvUDdDYnlRZXNHVThRT0R1UjV6Qm5mRWpT?=
 =?utf-8?B?bVYzWDVuRDdKM2FGdEZJQ0xVZG5EaE1WaXY0bkhJbm5rVDEyd29YS0R2emxj?=
 =?utf-8?B?Wlpobi9nNHhDaU91QXl3NE9FaXVleE5iRnVlcVpQN25MK29kNStQR2NtYXBm?=
 =?utf-8?B?NklVeW11MHZCT0ErcHBkdkZPeUVNVWpkbm1DSVp0bWVIeHk0VHNkZmExbGdB?=
 =?utf-8?B?Q1JRUXEyc1JPY2FpSEJTSnZNQXpSdFR1K2o1ZFRPbVVpeHBxRUt1bFhOaDNs?=
 =?utf-8?B?cHB0QTd0cmswSHIwbndqdzdZZHpMZDJkMERVazQ2d1BpeDh3SUpHR0djYU9H?=
 =?utf-8?B?d0dlUWJ3MmxEUlcyVlVPa1paRzh2Zk1UUzh1YUhhbjgrVk5YcURPOTRSWkpO?=
 =?utf-8?B?S1Z1MjN4a1ZURjVtTTI3Z3JTdmxkK1NCeVdmbG93S1M1clpENFc4WGoyZjdu?=
 =?utf-8?B?TVhDVDBnNkFIK3l3dlVEbk1wUXBXRzZMNHVIN0RWR2xkbnVpb1ZlSzBvVVJx?=
 =?utf-8?B?WHBYSEdZMko0VEc5UWdUaStmaFJ2WE9nZEsxVzV0UHIxUTJJR1c2Y0VrOUdB?=
 =?utf-8?B?MlViQjZtaTFDWGRoS3ZqZ05IeVZGcTdyL21lQU8ydXhhUVF6T3AwZmJrdEth?=
 =?utf-8?B?SXMrM0NPL0wwbklVdUprT3JIZW53L1pCTFNkWEpIV2JlYkZtbXFZUTY3eWlz?=
 =?utf-8?B?REF5dmZmWVlMcHAwV3A5RzQ5M3Z5Zmh1Mnk2bG56VTZKdEQwUXBaaHZGVkVW?=
 =?utf-8?B?RjU3ZXR2MlpJYU92LytVZ1ZaZUpZbkp4aTErY2J1dkovWmo4aGZ0eWFJSG1y?=
 =?utf-8?B?Z25zWkFMNjIyckhrQU5qdllHbHVWWS82NmptRWdHOGUvT0Z5TUEwV0k1NWRY?=
 =?utf-8?B?NWhqUWxqVXhwYllTN3NQSFJtcC9vcnh1V0c1aFhSMjV5c1YveVpjc3IzQXhD?=
 =?utf-8?B?NEJsZ0h3SmdvMFVzdUVyS2Voay9abjlVUTBneGNmckc0Rkl4dUhNVU93c2Fq?=
 =?utf-8?B?NU5BT0tJL1BJcDhJNGlPR2drMUZPSmpKM1VESUNFUXFMaWhiUlQ0T1VwYXg1?=
 =?utf-8?B?MlZ5UkZ3eE9XVlZ0Z296NTNpd0JvNzRkdmM2ck5uVFpGQWFJRE55cWRtajg4?=
 =?utf-8?B?Smh2aWtweHhscUVvMHhHSzY0Ni9VdSs4NEE0MUNXMHk0allydEZpUFdoWUVj?=
 =?utf-8?B?VkJTS2xhSWJSQ01sMjFIc3cwNnNkRGV6L3NOaEloTGJxSU1VQ25KRW52Y0lw?=
 =?utf-8?B?WHVja21rY25jZzcrcnhYcEJsREVKeU9GU3ZjT09UWUx5M0JGZ0dWd0tISjUr?=
 =?utf-8?B?M2s1K0sveG8wZHlrU213ZzRzSnlJWlNDYU9FVzlqNTVibjcrMGRDQmZRTkxE?=
 =?utf-8?B?K3cycnhOTmVYYm9wV05JVnU2V0JoZkh6RWhEYiszNnlvdmRUOTlpMXgxK2Rq?=
 =?utf-8?B?ZzM2SUZ3SmMzMzJROE4xY29IQ0NWNkNwcmwwb21iZHJrcEo5SXN1anlkcnZG?=
 =?utf-8?B?YXhjVGJhdlBmYVRtRXhYekxWaFE3cHNvL0x0RVhJeHBTV3VaQk9lcHJHeENh?=
 =?utf-8?Q?mncnoRqFD5ZuRc3L4hyAPBPA92APupfd/hdl/Im?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d99350-ba92-41a0-8d78-08d976b6c96a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:48.9292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZGV7SD0RApLDhyI8UlSsMvRDThTGpJvlW/V8QJOXyOj3XCMn+XdmQDyB0/2KzXv7X7dYMZi841UeH4e5r3TjIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG5ldyBjb2RlIGlzIHNtYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguYyB8IDUgKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCBmY2NlNzhiYjMwMDUuLmM1YWIxYzJlMWUwNyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC0zMDUsMTAgKzMwNSw3IEBAIGludCBoaWZfam9pbihzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiwK
IAkJcmV0dXJuIC1FTk9NRU07CiAJYm9keS0+aW5mcmFzdHJ1Y3R1cmVfYnNzX21vZGUgPSAhY29u
Zi0+aWJzc19qb2luZWQ7CiAJYm9keS0+c2hvcnRfcHJlYW1ibGUgPSBjb25mLT51c2Vfc2hvcnRf
cHJlYW1ibGU7Ci0JaWYgKGNoYW5uZWwtPmZsYWdzICYgSUVFRTgwMjExX0NIQU5fTk9fSVIpCi0J
CWJvZHktPnByb2JlX2Zvcl9qb2luID0gMDsKLQllbHNlCi0JCWJvZHktPnByb2JlX2Zvcl9qb2lu
ID0gMTsKKwlib2R5LT5wcm9iZV9mb3Jfam9pbiA9ICEoY2hhbm5lbC0+ZmxhZ3MgJiBJRUVFODAy
MTFfQ0hBTl9OT19JUik7CiAJYm9keS0+Y2hhbm5lbF9udW1iZXIgPSBjaGFubmVsLT5od192YWx1
ZTsKIAlib2R5LT5iZWFjb25faW50ZXJ2YWwgPSBjcHVfdG9fbGUzMihjb25mLT5iZWFjb25faW50
KTsKIAlib2R5LT5iYXNpY19yYXRlX3NldCA9Ci0tIAoyLjMzLjAKCg==
