Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1984D36D50D
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbhD1Jxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:53:48 -0400
Received: from mail-bn8nam11on2119.outbound.protection.outlook.com ([40.107.236.119]:59504
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238070AbhD1Jxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 05:53:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLqqHUi6+nSQPVC9mD+JP01AEhskF1M97143G2iKF0Cy927uCeMD/aJYjLUkoFpbjjReV11NOY7VykfRRSDRh/TP4svDP3XJtH7b4igHR4BGh66AFOdOgEJXQZj3EwQui2LyCOJpvPzhzBEUqkiJqugj4FNx7BDFTd/dSyjR02prU547gVUTRm+j9nk3ZKyd8XyyDp5HpfTQslFv6YG85gMLrY1qKzs/7LJQSDldpzm1/LG01X6X+q6iRNjJeid91cNJTGQ8Wp2y0lMoZbQZ2qrSjcKhVIhZjvCnzmQGxYDsYqT/96ScXP9sMKtezakkpY4e7T3IqfNYiihtRgwryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqwnIiaUO+t2u37/HPjCesg17lIksITTsHhW0tcTAq8=;
 b=hUbHOXJK3O8n1eKnfS1wnF1UnQ6oNC9JVN4E7Ke0Z3UfjiEB5luA5EgFskwYhKY2dOdD9wJdvdOSsP/zOc8+ubGJp/ZSOXUGTraM0AzsYOa+Si+uEblOWrQC7tGC5yPPG6fYOhQvoskv9jaUqRWdiHxgCiwqIhLTRlQ99zTQaYUcT8xWy3slKESr8T0ilJumhie7cx5muPxTuxv4aAx3J55/7tBHOBA1UYtpvHBN4tZnx+tfZDpTHoPTMkN4W2DFfphw9fmW//98Kxm3ojIoTLBWKbboHyzy0ntg1zj6fsoO1VOjXwLeYeYOUpluhZuBz9R8Ggarkx01T6Ul6iug1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqwnIiaUO+t2u37/HPjCesg17lIksITTsHhW0tcTAq8=;
 b=Q5+c8Ab7fVrxH495qqmID8PJueq8foaBzTuE+dRVahtIWBVRvTLxysMZpKvx4T6JMrqrTtewLTHtsTvajq/6FPXheIJ+lJVCBnuDcL8pUTdio4hJbQUMQ+cVeruw41SEWqq2YlJ2lDmBCQq+h7SiVFTuDdsJnMVbbahi8IUskN0=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by CO6PR22MB2451.namprd22.prod.outlook.com
 (2603:10b6:303:ac::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 09:53:00 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::141:6464:43a7:d230]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::141:6464:43a7:d230%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 09:53:00 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     "avem@davemloft.net" <avem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PROBLEM: potential information leakage in /proc/net/ptype
Thread-Topic: PROBLEM: potential information leakage in /proc/net/ptype
Thread-Index: AQHXPBI+M3oOChfkBk6wv9ofd2cD3g==
Date:   Wed, 28 Apr 2021 09:53:00 +0000
Message-ID: <MWHPR2201MB1072D842B011C3880193765AD0409@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [38.94.111.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e907b23-e628-4f59-c4b4-08d90a2b68c3
x-ms-traffictypediagnostic: CO6PR22MB2451:
x-microsoft-antispam-prvs: <CO6PR22MB24510753ED14EB70705005D0D0409@CO6PR22MB2451.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9y+M10UkRYuEgHw5NKUzF4k/8xqYdW9ANwmLwRoZnBoY4ThGswkCvbmD/qrnIqtwhx0So+aIVok+hKydpqTltFEPTVrqLPFcSKTMivGSzgsEFldvMIlB6F6S24jkCYZd7vkuyw8lxae2lK2sQHsUAGtMbu1Dy3pah+KhbA8M1GSbpjzhxslPhSC7d4v01XU8lG2NQNkrC2Hlnhou8QjQ9P0VRu2bnBvqSUzFjOK9i7nI3QE5LSnix+wUMEGHLBmgfsqDhYly8dBamYxCe4pA6pFIW2qG780aoZKgRrqcjO37YSkt/6RiSeeJ8tch9Ei8nFyb63RHiXcj6UB3qWshf1gDkD4r0mkspkbcGk25tTTpS6Q2V3t973TfeuZIengspcsV3VAH5SXD8/dzMOgG9RUsO30KIC3V4Ve6LAgoOyQTnVlBwKSpxn43uAfjHXBHnuIpm6UQrwEJqdH06Xgh+GwhAPx+ArxUdRazSbGMLo4ZYnnmQBnMgfD2P+tfhZ904diWHrZtm3SrVcGv1d9VFnuJ+gW/o/xkypS9aq0c5jSs4YUnCPgnQpopO5BiwRRV1rl1h4bBKI6yQCfDpI2PaZ3xWPCziWaRXYscUKtRiUs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(136003)(366004)(6916009)(122000001)(6506007)(8936002)(316002)(186003)(55016002)(26005)(2906002)(8676002)(75432002)(5660300002)(38100700002)(33656002)(66446008)(76116006)(86362001)(71200400001)(64756008)(786003)(66946007)(7696005)(52536014)(4326008)(66476007)(478600001)(66556008)(9686003)(83380400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?gb2312?B?cHhhQkoyR2lPU0w4ZDl2Z3dRS3VsRldZUHJleXJZV1dOS1R2bTUxQTJpUEN6?=
 =?gb2312?B?cEdlV0F4SURyY1VCRkswZ21mK0tyTUIwdVFLNy8xR2lKdHZlOVFndjEyNk13?=
 =?gb2312?B?V2ltSUc5VmJpNzg1K0srVWxCd2RPNEp3NlJ5OVY2MkZGWnBMTkVuSzhpOHhU?=
 =?gb2312?B?WitQSnJSQzdxWnBJZkx0d01ialAvZUJGUk1td0FETFJkRExacTRXdDdlbnFN?=
 =?gb2312?B?UEJaakpxTm1WNWRiakpIMjBpOEVUbFBuQzh4ckxoeUgyOUNYWXpyL01jWFBm?=
 =?gb2312?B?V0FPOGRaODZBVHFmNDB2R1RpbEhzK2dCUm9LaUpQZjVaUTQzelM1N0g1MTc5?=
 =?gb2312?B?SGlWNVFFUXJkSm9HeFU4UmtjQy9Ma2lHMm5oNnFFSmVLdU5sUkNScCtpZnQv?=
 =?gb2312?B?NXh4ZzBEOEdUaUhFUEdWZDYrZ3NkY0JQZ25FOEJ0TTlrd3pEaktkcVVzb1NU?=
 =?gb2312?B?VEFPOG1TbWFiQWt2U2FjVmdpbzlPelRpZ3dXY0pjNEtJY1hpOExJUmNYYXlS?=
 =?gb2312?B?Y3A5OGI4bFFKbE5MZENlS2h0M2lyNlpTZzBoMWJjWitvalZ0TGNrOHZXM0lS?=
 =?gb2312?B?ckVvUWhHT3hBQlEzZkIxRUdwdDJSeDNpYXlaZlBVeWplMTI3endhSkF2c1Jt?=
 =?gb2312?B?RjJtZ2tvZFNwZWplck8xZHFMUXNUQ1VyUkJnNkpsTmpCZFlGZlQ2dW9hUkxk?=
 =?gb2312?B?TFBGbFF0ZTJtOC9vZloxSjUzUGZybHRWdVRuRU9ENmdLbXpaajd2bkZRUUE1?=
 =?gb2312?B?OStvSWUxemlGdXRWUzdnb296ZFVZSW1MQUdCc0NnR2dWNlB1NUJWOXo0RVhj?=
 =?gb2312?B?bkw4VlB1Y2VsMFF3QkF4VFgwa2s0TWlKbXljVkpjUTljTEIrYkxXOFF1VjBE?=
 =?gb2312?B?RUdyRGRuc0pMd2hmTk9nNE9mRVBRMmliWnBjaU9xdVh3ejdWZlR2SlJZdysy?=
 =?gb2312?B?SUhZbmhhV0VUbG5FVXZNTnVLVFh1MnZTQTJvT0QvYmxVVSt6eEVFeHlsWFJV?=
 =?gb2312?B?bmdVRGtzdDIvd3Qzd29nNFFjbDdRU3RZSDhicDRPVVdzVUQ4Wm5xK1lzaUpC?=
 =?gb2312?B?bGtuM0dhSEFzZkM4NVl0M2NMTmo2T0N3K2tOditzTElQMnZCZUxqeHBVU1Nq?=
 =?gb2312?B?OG5YbDhSdlpIcnRUQ1NZbGUyOWQ1aWs0SHE2cVNFbi95VEk2SUMySTFFanNE?=
 =?gb2312?B?d3VFZzY4RDlkNVJRS2xCRkVOa0dSMld4ZDkwblV0a2k0aWxyQ0xtdWFmNWFS?=
 =?gb2312?B?UzhxRDd4eWRtakV5bUtWQ2FzTlJWR3hLa3Nac3VRUXhzc3R4UmNvVkZXWEU5?=
 =?gb2312?B?L1VXRFNBMkcyWFZIWDd5ZHdveHVZcjd1UXBVWHFxOFRHYUdYQTVtUklsTEFX?=
 =?gb2312?B?b3M1NnJmVHdTNnZxM3EzdWQvV3ZTTy9oaGJPem5mRUhxN2JIek5XMVk2S3ZN?=
 =?gb2312?B?SEdBakx3QnhJYUFWc1RpNHQ1MGp4Y2pDcGk3Y25iK01NWno3U2hWZEdVVnln?=
 =?gb2312?B?QjdScVExSDZrWGVaYXQzUDh2RC9UUVFvM1FYeG5PWTZVRmxuMGRJa2hXemR1?=
 =?gb2312?B?ajIrTCsyL3VsQmpMbnZuWkRzS2orZks4ZjVJTHJ1N1Y5QXMzT1J1TmxGTkRV?=
 =?gb2312?B?SS9kcjhHSFhwQ0VNbC9sRUpBVXRFN2wzOXBWanpPemx5Rk1zaVRWUTBRVk5E?=
 =?gb2312?B?cFYyTmQ1SFJ0S3YwSE9xRzc2eWlOTEpFdXRGZi9NdzZ5YUNxV2VNYlZ5SVNV?=
 =?gb2312?Q?Em4AuC770kHV3CO3us=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e907b23-e628-4f59-c4b4-08d90a2b68c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 09:53:00.4119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zhcp/7xg4+dtYwkdXfjlTGWD1OEpUBaIHofAwBRJQm3GbH9V9FLYqEoqsW2h2tMtX/4l3nS4h9yCgX7g0jp+xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR22MB2451
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGl0bGU6IFBST0JMRU06IHBvdGVudGlhbCBpbmZvcm1hdGlvbiBsZWFrYWdlIGluIC9wcm9jL25l
dC9wdHlwZQoKSGksCgpXaGVuIGEgcHJvY2VzcyBpbiBuZXR3b3JrIG5hbWVzcGFjZSBBIGNyZWF0
ZXMgYSBwYWNrZXQgc29ja2V0IHdpdGhvdXQgYmluZGluZyB0byBhbnkgaW50ZXJmYWNlLCBhIHBy
b2Nlc3MgaW4gbmV0d29yayBuYW1lc3BhY2UgQiBjYW4gb2JzZXJ2ZSB0aGUgYSBgcGFja2V0X3Jj
dmAgZW50cnkgYmVpbmcgcmVnaXN0ZXJlZCBieSByZWFkaW5nIC9wcm9jL25ldC9wdHlwZSwgdGh1
cyBpdCBjYW4gaW5mZXIgaW5mb3JtYXRpb24gYWJvdXQgdGhlIHByb2Nlc3NlcyBpbiBuYW1lc3Bh
Y2UgQS4KCkJ5IGxvb2tpbmcgYXQgdGhlIGNvZGUsIGl0IGxvb2tzIGxpa2UgaG9vayBmdW5jdGlv
biBgcGFja2V0X3JjdmAgaXMgbmFtZXNwYWNlIGF3YXJlIGFuZCBvbmx5IHdvcmtzIGluIG9uZSBu
ZXQgbmFtZXNwYWNlOiBpdCBvbmx5IGludGVyY2VwdHMgcGFja2V0cyBmcm9tIHRoZSBkZXZpY2Vz
IGluc2lkZSB0aGUgbmV0d29yayBuYW1lc3BhY2Ugd2hlcmUgdGhlIHBhY2tldCBzb2NrZXQgaXMg
Y3JlYXRlZC4gSG93ZXZlciwgdGhlIGBwYWNrZXRfcmVjdmAgcHR5cGUgZW50cnkgY2FuIGJlIHNl
ZW4gaW4gYWxsIG5hbWVzcGFjZXMgdmlhIC9wcm9jL25ldC9wdHlwZS4gVGhvdWdoIG1pbm9yLCB0
aGlzIGxvb2tzIGxpa2UgYW4gaW5mb3JtYXRpb24gbGVha2FnZS4KCi9wcm9jL25ldC9wdHlwZSBz
ZWVtcyB0byBiZSB0aGUgcm9vdCBjYXVzZTogaXQgZG9lcyBub3QgZmlsdGVyIHRob3NlIHB0eXBl
IGVudHJpZXMgdGhhdCBkbyBub3QgYmluZCB0byBhbnkgaW50ZXJmYWNlLiBCdXQgSSBoYXZlIGFs
c28gbm90aWNlZCB0aGF0IHRoZXJlIHdlcmUgZWZmb3J0cyB0byBwcmV2ZW50IC9wcm9jL25ldC9w
dHlwZSBmcm9tIGxlYWtpbmcgbmV0IG5hbWVzcGFjZSBpbmZvcm1hdGlvbiwgZS5nLiBjb21taXQg
MmZlYjI3ZC4gU28gSSBhbSB3b25kZXJpbmcgaWYgdGhpcyBwcm9ibGVtIGlzIGFuIGluZm9ybWF0
aW9uIGxlYWthZ2UgYnVnIG9yIGRlbGliZXJhdGUgYnkgZGVzaWduPyBJZiB0aGUgbGF0dGVyLCB3
aGF0IGlzIHRoZSByZWFzb25pbmcgZm9yIHRoaXM/CgpUaGFua3MgZm9yIHlvdXIgdGltZSBhbmQg
cGF0aWVuY2UhCgoKVGhhbmtzLApDb25neXUgTGl1CgoKQ29kZToKI2RlZmluZSBfR05VX1NPVVJD
RQojaW5jbHVkZSA8c2NoZWQuaD4KI2luY2x1ZGUgPHN5cy93YWl0Lmg+CiNpbmNsdWRlIDxzdGRp
by5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHVu
aXN0ZC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4KI2RlZmlu
ZSBlcnJFeGl0KG1zZykgICAgZG8geyBwZXJyb3IobXNnKTsgZXhpdChFWElUX0ZBSUxVUkUpOyBc
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9IHdoaWxlICgwKQppbnQgbWFpbigpIHsKICAg
IGNoYXIgeDsKICAgIGludCBwaXBlX2ZkWzJdOwogICAgaWYgKHBpcGUocGlwZV9mZCkgPCAwKSB7
CiAgICAgICAgZXJyRXhpdCgicGlwZSIpOwogICAgfQogICAgaW50IHBpZCA9IGZvcmsoKTsKICAg
IGlmIChwaWQgPCAwKSB7CiAgICAgICAgZXJyRXhpdCgiZm9yayIpOwogICAgfQogICAgaWYgKHBp
ZCA9PSAwKSB7CiAgICAgICAgY2xvc2UocGlwZV9mZFsxXSk7CiAgICAgICAgdW5zaGFyZShDTE9O
RV9ORVdORVQpOwogICAgICAgIGlmIChyZWFkKHBpcGVfZmRbMF0sICZ4LCAxKSA8IDApIHsKICAg
ICAgICAgICAgZXJyRXhpdCgicmVhZCBkIik7CiAgICAgICAgfQogICAgICAgIHN5c3RlbSgiY2F0
IC9wcm9jL25ldC9wdHlwZSIpOwogICAgICAgIHJldHVybiAwOwogICAgfQogICAgY2xvc2UocGlw
ZV9mZFswXSk7CiAgICB1bnNoYXJlKENMT05FX05FV05FVCk7CiAgICBzb2NrZXQoQUZfUEFDS0VU
LCBTT0NLX1JBVywgNzY4KTsKICAgIGlmICh3cml0ZShwaXBlX2ZkWzFdLCAmeCwgMSkgPCAwKSB7
CiAgICAgICAgZXJyRXhpdCgid3JpdGUiKTsKICAgIH0KICAgIHdhaXQoTlVMTCk7CiAgICByZXR1
cm4gMDsKfQoKCg==
