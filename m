Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5685C1CDF9C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgEKPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:39 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:17760
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730718AbgEKPuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljSRE0UWQ/I2aLx7FPewcUiT3Fpb4dTD4VyKJCVMZIhEDtpjIdWEeVO0vNsr/Du7k/No/+KW63IMqdMO0R3CAQqMXkemubxVqF6GPaVuw2mxdvt/pvU1GCY4RXKNjrzLbzT575SUYharaU19FbW1yn6VApDIzx6530tQB6D5SObO7X34L6P5Yaveq9ke+a2NQgzVIvSPWIAWMc2eeKDIcqopTh446VRqyjlpPQizPJjjnJkE53XYly93qVgA5FyQGwGkC+nBxm8Bmg0DGMNSBRImwWQ3/h6jCWejR/bYF91/BG7fWuTuiNOseSoVWjxXhW8q4cdbvCwZoibhzVS0zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5DYbo8vfnRWOM1AWqeRAX5SzRDmtdoARdW+TIHTLK0=;
 b=cAX074RzNpktt0bm3uDGP+0jPRgo6Bgx/9o/XaK7nnFw8OqrxnNSBQS9EsXTSan+Js4H87XcuQL2c6RGNMAtMha34zqJUyWi5Mbzeko1ZbNFvDZl2+QakyQ+LfQRPUSz2HCQpgttL9eDaxhMI2ozCTxvbTqc1UzA8yu2KBIKWpa09XPZqh5HsEqkX7HiAN1jAELyX3c13M/zzvcEekX+6Ngay7dDTRi9GfRkgAZ79OTU1YlCeF+dN4zu6MjmsvOxQF0ea2JO/sCQ98BTOVZbvVV//wi5vH7cJFtRltA0fMNQns0ReQwxi6kWnrOpqSoGhvNkJRjBv6kTVEutuWJzEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5DYbo8vfnRWOM1AWqeRAX5SzRDmtdoARdW+TIHTLK0=;
 b=cpHnlbFhNLVTb4oZSxi6+Ix3DS21VtnOY4SsqmI6r2L8lA61o9J+d7pNklwcJce7xGzFl5ZN6h38rTcitfc37KjgQdTwbb6BSukuDYSZp/ChmUGujBPRLNHQcYlAcEqJ26Ak2MGdh4IJaHXn48RH52+BWuigsgbPrrN/08m6/SQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:18 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:18 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/17] staging: wfx: fix endianness of the field 'channel_number'
Date:   Mon, 11 May 2020 17:49:29 +0200
Message-Id: <20200511154930.190212-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef4b35b3-206e-4781-1407-08d7f5c3013c
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB196850B7CE5CB1D27BF12C5893A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2II7x0R2PKwBuH9YIRALnI4MzEivi9KQ4UXbVDb8f0FQPp1Po5GEK6aZq3B+r6edUJZtsdlC6+5FyWaQW3DzFbBmHDBzYbXPHs7d4JXNO1BFjYot+SclPqZ3CY2sh+Ugij2e/TYCEKxCnLap1rWUjXBijJbOHKpfROsWE7w3Dr3tCpFrn3vABY3c9MVYThKqhxVPuOf5Ro2jxwBUZs9c+c0G2HDynhsRCatB2f0ofCsyjMvpPt8ONn0FGyJVNdys2zr8vxj17O+hOWgEq44bz15g3Y+QIImTrNcTfigwISk/8p3VaaERZAruWRhAepy6ig2Xfc/WdpGVDJQdzdtJzMG6hyqvYPYzyAvQMqS5a0yvgJ78ZAp8MbewIJSqouszGTIllJhC2HhD7x5sx9tlHLQAisiBG+6XlCITZInJIQkDXmssVDvszi4MFTnOWvIh48JT5mWqNMrlPl54XG+tJv+9uzS3bpo3WgiKTENTQnwt321TIodzYGwifzozUEK7YmIUXEr0eXxT1GMr+sYnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p3GLcGYYzp+Ku2CgIDJKjnX7jTvhJfCTBvfYNRmmTP15o6Uv6miZkAqyesb/4WYpT2FhF9bj+0b0D50jRaWglG4zJ9KBYUqLB1VnFyaYAD0qfzXFj0H8rgb2papgVCw4LX61MHFR24Jk6F3JqcqnI2BWSinGaKHu2HNQGEiuaQ+6RWui7KOiVPSdxFeAyx3j50Ktfl/JT3LcGmYC8i9QSPa7P+1R9UE/FcGrg8bwGZ0JHrLz5V1B5T4uxbj5nFHbl+Bjg1+TftvpknwdKaibwCTKfyIjQP5/sh6J0gaiCv57NXFG8rhDjJ8ZvBvKJQC0tTgUa3hTnpUQh6XQlUnp8MD0lPJb6uogehm08LKt99fVAlzLXN14JPQj1gcZPMjUjGhrb5OAxBUrssR6O1l17L7SDhdiOYvD3iGaiO7U2duHwoaKIeuPG6Y6ID6Ld+pdzQoeXXY/Rb4vSF3QK6Cdvlch9fYeIXZ3U+hXBVZPfzE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4b35b3-206e-4781-1407-08d7f5c3013c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:18.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXXT8mSljjQYIJPt4P+4FNHHMTvgBVx3IefUIxP8vI3o6/zrHlISJ42w0sJvAs4kaqiyXuw09Kq6ZbYjBtWQjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICdjaGFubmVsX251bWJlcicgZnJvbSB0aGUgc3RydWN0cyBoaWZfaW5kX3J4IGFuZCBo
aWZfcmVxX3N0YXJ0CmlzIGEgX19sZTMyLiBTcGFyc2UgY29tcGxhaW5zIHRoaXMgZmllbGQgaXMg
bm90IGFsd2F5cyBjb3JyZWN0bHkKYWNjZXNzZWQ6CgogICAgZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3J4LmM6OTU6NTU6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFyZ3VtZW50IDEgKGRp
ZmZlcmVudCBiYXNlIHR5cGVzKQogICAgZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmM6OTU6
NTU6ICAgIGV4cGVjdGVkIGludCBjaGFuCiAgICBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcngu
Yzo5NTo1NTogICAgZ290IHJlc3RyaWN0ZWQgX19sZTE2IGNvbnN0IFt1c2VydHlwZV0gY2hhbm5l
bF9udW1iZXIKCkhvd2V2ZXIsIHRoZSB2YWx1ZSBvZiBjaGFubmVsX251bWJlciBjYW5ub3QgYmUg
Z3JlYXRlciB0aGFuIDE0ICh0aGlzCmRldmljZSBvbmx5IHN1cHBvcnQgMi40R2h6IGJhbmQpLiBT
bywgd2Ugb25seSBoYXZlIHRvIGFjY2VzcyB0byB0aGUKbGVhc3Qgc2lnbmlmaWNhbnQgYnl0ZS4g
SXQgaXMgZmluYWxseSBlYXNpZXIgdG8gZGVjbGFyZSBpdCBhcyBhbiBhcnJheQpvZiBieXRlcyBh
bmQgb25seSBhY2Nlc3MgdG8gdGhlIGZpcnN0IG9uZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl9hcGlfY21kLmggfCAxNSArKysrKysrKystLS0tLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgICAgICB8ICA0ICsrLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXgg
OGM0ODQ3N2U4Nzk3Li4yMWNkZTE5Y2ZmNzUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgK
QEAgLTMyMSw3ICszMjEsOCBAQCBzdHJ1Y3QgaGlmX3J4X2ZsYWdzIHsKIAogc3RydWN0IGhpZl9p
bmRfcnggewogCV9fbGUzMiBzdGF0dXM7Ci0JX19sZTE2IGNoYW5uZWxfbnVtYmVyOworCXU4ICAg
ICBjaGFubmVsX251bWJlcjsKKwl1OCAgICAgcmVzZXJ2ZWQ7CiAJdTggICAgIHJ4ZWRfcmF0ZTsK
IAl1OCAgICAgcmNwaV9yc3NpOwogCXN0cnVjdCBoaWZfcnhfZmxhZ3MgcnhfZmxhZ3M7CkBAIC0z
NTYsNyArMzU3LDggQEAgc3RydWN0IGhpZl9yZXFfam9pbiB7CiAJdTggICAgIGluZnJhc3RydWN0
dXJlX2Jzc19tb2RlOjE7CiAJdTggICAgIHJlc2VydmVkMTo3OwogCXU4ICAgICBiYW5kOwotCV9f
bGUxNiBjaGFubmVsX251bWJlcjsKKwl1OCAgICAgY2hhbm5lbF9udW1iZXI7CisJdTggICAgIHJl
c2VydmVkOwogCXU4ICAgICBic3NpZFtFVEhfQUxFTl07CiAJX19sZTE2IGF0aW1fd2luZG93Owog
CXU4ICAgICBzaG9ydF9wcmVhbWJsZToxOwpAQCAtNDIxLDEzICs0MjMsMTQgQEAgc3RydWN0IGhp
Zl9pbmRfc2V0X3BtX21vZGVfY21wbCB7CiBzdHJ1Y3QgaGlmX3JlcV9zdGFydCB7CiAJdTggICAg
IG1vZGU7CiAJdTggICAgIGJhbmQ7Ci0JX19sZTE2IGNoYW5uZWxfbnVtYmVyOwotCV9fbGUzMiBy
ZXNlcnZlZDE7CisJdTggICAgIGNoYW5uZWxfbnVtYmVyOworCXU4ICAgICByZXNlcnZlZDE7CisJ
X19sZTMyIHJlc2VydmVkMjsKIAlfX2xlMzIgYmVhY29uX2ludGVydmFsOwogCXU4ICAgICBkdGlt
X3BlcmlvZDsKIAl1OCAgICAgc2hvcnRfcHJlYW1ibGU6MTsKLQl1OCAgICAgcmVzZXJ2ZWQyOjc7
Ci0JdTggICAgIHJlc2VydmVkMzsKKwl1OCAgICAgcmVzZXJ2ZWQzOjc7CisJdTggICAgIHJlc2Vy
dmVkNDsKIAl1OCAgICAgc3NpZF9sZW5ndGg7CiAJdTggICAgIHNzaWRbSElGX0FQSV9TU0lEX1NJ
WkVdOwogCV9fbGUzMiBiYXNpY19yYXRlX3NldDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IGU2NTNl
YmJlNTA2Ny4uZWNjOTliNzY1MzM1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTMwOSw3ICszMDks
NyBAQCBpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVl
ODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJCWJvZHktPnByb2JlX2Zvcl9qb2luID0gMDsKIAllbHNl
CiAJCWJvZHktPnByb2JlX2Zvcl9qb2luID0gMTsKLQlib2R5LT5jaGFubmVsX251bWJlciA9IGNw
dV90b19sZTE2KGNoYW5uZWwtPmh3X3ZhbHVlKTsKKwlib2R5LT5jaGFubmVsX251bWJlciA9IGNo
YW5uZWwtPmh3X3ZhbHVlOwogCWJvZHktPmJlYWNvbl9pbnRlcnZhbCA9IGNwdV90b19sZTMyKGNv
bmYtPmJlYWNvbl9pbnQpOwogCWJvZHktPmJhc2ljX3JhdGVfc2V0ID0KIAkJY3B1X3RvX2xlMzIo
d2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBjb25mLT5iYXNpY19yYXRlcykpOwpAQCAt
NDM1LDcgKzQzNSw3IEBAIGludCBoaWZfc3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0
IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJV0FSTl9PTighY29uZi0+YmVhY29u
X2ludCk7CiAJYm9keS0+ZHRpbV9wZXJpb2QgPSBjb25mLT5kdGltX3BlcmlvZDsKIAlib2R5LT5z
aG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZTsKLQlib2R5LT5jaGFubmVs
X251bWJlciA9IGNwdV90b19sZTE2KGNoYW5uZWwtPmh3X3ZhbHVlKTsKKwlib2R5LT5jaGFubmVs
X251bWJlciA9IGNoYW5uZWwtPmh3X3ZhbHVlOwogCWJvZHktPmJlYWNvbl9pbnRlcnZhbCA9IGNw
dV90b19sZTMyKGNvbmYtPmJlYWNvbl9pbnQpOwogCWJvZHktPmJhc2ljX3JhdGVfc2V0ID0KIAkJ
Y3B1X3RvX2xlMzIod2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBjb25mLT5iYXNpY19y
YXRlcykpOwotLSAKMi4yNi4yCgo=
