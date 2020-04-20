Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9747F1B110E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgDTQDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:03:47 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:6055
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728691AbgDTQDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOQqRBfRsrObs25L4O5Rzjt9pH7C8sttgh561T9F7fIx6w7ry+7h9WWjweT98GSpGcF36ey0nME9/r0ktIbbm5pfFPGGhzeUgXyux+E52+fEMiQRcJ3EHPjOwA0KswlzPtI3OCCYoBhohJt/yMTB/22QOjFhJPTXUhESfqd6nQnSZ/SEyI+UAV36oDETT0MMP+NtigeRkRJPvSy9zaayXEDbaSir44Xk3ekFemr3lL/Yl/XKILrsGJOrvRqiPBBn8lytnIiwppGViE+WkaXRiqXUkTe6bil4BcWvsjYn7kcb7W8gOeI6hHm5quZzMQsQfq8JOrTQneKcYt7nUGujWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggeuuNXuX9ydvLStcV/yrVHa8U5v9ZFTwIl4pzB4nzA=;
 b=k1eSbGA+IWsnTS/VE/k90Xzr3ExCSWMlmAbVokqd0WOyD7k5/IDwcx8LYdbeN//UmcFTKosfQPJ7ZCT8B5PzI9dT9d8rShm6IHYBfc/94EBToQrIzdCLVbnU5RUDyTLgfBgnlvL24gHnycPIjSTuXEuHNXPppkAtHeGKLLsgT8H/fJ+e+XPGx/gpXZN1oSmH3PLwNgkLPSNDGu9NlNtOXX+HB+NIgK2qZSMeURDHyaVJy5WZovsQuYq0Iis/g1TQ9yrYzXKPLQw0X8uhXMYH+iPA+4NEvSEIjwSByaX7oGmBrAbyfODLqZsTYAwAdt1hyNfTm8FlRSpODCIAufdmPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggeuuNXuX9ydvLStcV/yrVHa8U5v9ZFTwIl4pzB4nzA=;
 b=FWti3igTLlQ4xSRzMyj7ECDdxScSSp/k+nVKFDTsLS45TFtfRR6BwdwQgCNUczaZT6pIXNgAxJ/0veDExOtOXiVZtugfu8/Ng9n34UGWDF51p/IL+heuEvdzuefAKPGzLGn03bH0/QsZadjDCfl4kHGcwR3BqIMcdlzevDhUf3U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHSPR00MB249.namprd11.prod.outlook.com (2603:10b6:300:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 16:03:41 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:41 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/16] staging: wfx: dual CTS is never necessary
Date:   Mon, 20 Apr 2020 18:03:01 +0200
Message-Id: <20200420160311.57323-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:39 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6c021c7-f708-47dc-e1e2-08d7e54464cf
X-MS-TrafficTypeDiagnostic: MWHSPR00MB249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHSPR00MB249C3945F9689563CADBAEC93D40@MWHSPR00MB249.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(376002)(396003)(39850400004)(346002)(8676002)(7696005)(52116002)(6666004)(4326008)(8936002)(81156014)(66556008)(66476007)(66946007)(36756003)(186003)(54906003)(16526019)(107886003)(478600001)(2906002)(316002)(1076003)(86362001)(6486002)(2616005)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCCnfp5OTejGxhE+qWut2jnsABbDXpF5Nr+SpFQeNKJ5PASjbwoKAWc6kbufikmzcg4s1rdDP0a4fy8G1Uu3DIqaB4ndWaT+ysX+2b6wGUv4uh75nRdhEOu6tG6tqXGv7+4MPCMpZx6qnCsjjWyA7h3bvsVynxx9NbCNwFNORKEF909O3AL5s4I2PxTWcgFtmKx4iBH3jrSizUzjpo3Gtu/R7JPBknIsD3jcWAqv1DnAeS1r9KyoQxN9a0D/K3hieTHOCBXcOti29jRd8arKiqUR9ChwrNoS8W/wsF38SbeC4A20GIG6jW1GeQDUSAj+DpwuFwjvXjTFYeSoD180lY1Uf3NqZ+vzh50s3T12ubDcj0gwyH0ME55hsUZZUBE7uUWERYa6HgC0hq/3lDKfnqBkteyvLYN/bHDTqx0Ax8xPrwy1fUBzm6m9UKowRGCu
X-MS-Exchange-AntiSpam-MessageData: dgT1W6dZA+JHlq4l9ZTwreg+75A7a8Nwy8HWo/mQLzvZ9gMB/2LL0rqmvJ5xnyBuaY2NC2oFEjpzKBcaTtK6FLNHVeBP+ztD7xKFfQatl4sa7fbfmALO26tQOuEN4ocow2vWgF/iFzG8M1j9IiGXcGucBXucxvYTexdS9euqE1ql2uBOjv0+o8wM9AJCPskx0adiITa7OF0yngGb6/U8Lj7N04SoJ0MefYGYpIk+bfzBBdovMTwmLUxSxnHCbrCZIAek1bqs0NKsWF14+Po9h/GkVmV3gwiQ0NtYAK6MYny3ovXgFJRKJPYTCA+BvObsDUrrTUK3bzhzBrYwh18smRXnQYHRIsjLuoHGAugPKdMpb27G7ejeWEX75i6Z30pw2CbDkAotMEtCzE72uwTN2OslHo2v4wbXV26synTgwN8PtayqD6lhp1jytJYJwlGsn1oUeXImhvuqw3K7opk8wLSCSqt5oVDQDyoZ/pkRD+hBu3ERIducmi4Dkor2cOC/eYX5YcfuweXhH69sbdydsF57IlezLsLQw8Lni8RglLUi9m8JjgOXfPbJXXQdXRyca3wuFCyFfhkrLsZv9RUsAFfQ3ilYGDMFmK95r7Mb7pyFbx0N/Q6OP68qKVQ1XreXcvyfYlFVKI4x40h4Sb/vflTMi02Q+Vd3Fa3tJYsGTgthtiHpJW0wKa6fuQBUlYSi/kya1knQsPkatKiekbMKtptwbhv7nco7taVn5gLS+4N2ZXbDx7yyQxVMcasIFl8561i58JTmafxosXuXLxhcCDUAfO4wBE32KOzEcONB8kTEHxaaWySocdx7sr/ZxnpOStuHcDlrPQLoqOYjIzUdPdudf4iSG/9jSUdg9eGD6jY=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c021c7-f708-47dc-e1e2-08d7e54464cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:41.1855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1Jz1KLkPQw7kyD7mDQl3KtAveI60M9yMNJUsoUEs1XiVZ5o8EFXBGQkT6jTrHWzosGL5oZafGTAUyFDUKDBBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRHVh
bCBDVFMgaXMgb25seSBuZWNlc3Nhcnkgd2hlbiBzZW5kaW5nL3JlY2VpdmluZyBTVEJDIGRhdGEu
IEhvd2V2ZXIsCnRoZSBjaGlwIGRvZXMgbm90IHN1cHBvcnQgU1RCQywgc28gaXQgaXMgbmV2ZXIg
bmVjZXNzYXJ5IHRvIGVuYWJsZQpkb3VibGUgQ1RTLgoKV2UgY2FuIHNpbXBsaWZ5IHRoZSBjb2Rl
LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxh
YnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCB8ICA2IC0tLS0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgIHwgMTAgLS0tLS0tLS0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggIHwgIDEgLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyAgICAgICAgIHwgIDYgLS0tLS0tCiA0IGZpbGVzIGNoYW5nZWQsIDIzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaAppbmRleCA5ZjMwY2Y1MDNhZDUuLjZmMTQz
NDc5NWZhOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaApAQCAtMzc5LDEyICszNzksNiBA
QCBzdHJ1Y3QgaGlmX21pYl9wcm90ZWN0ZWRfbWdtdF9wb2xpY3kgewogCXU4ICAgICByZXNlcnZl
ZDJbM107CiB9IF9fcGFja2VkOwogCi1zdHJ1Y3QgaGlmX21pYl9zZXRfaHRfcHJvdGVjdGlvbiB7
Ci0JdTggICAgIGR1YWxfY3RzX3Byb3Q6MTsKLQl1OCAgICAgcmVzZXJ2ZWQxOjc7Ci0JdTggICAg
IHJlc2VydmVkMlszXTsKLX0gX19wYWNrZWQ7Ci0KIHN0cnVjdCBoaWZfbWliX2tlZXBfYWxpdmVf
cGVyaW9kIHsKIAlfX2xlMTYga2VlcF9hbGl2ZV9wZXJpb2Q7CiAJdTggICAgIHJlc2VydmVkWzJd
OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYwppbmRleCAxZDI2ZDc0MGJkMGIuLmYwNDExNmVjYjM3
MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKKysrIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKQEAgLTM2NSwxNiArMzY1LDYgQEAgaW50IGhp
Zl9zbG90X3RpbWUoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCB2YWwpCiAJCQkgICAgICZhcmcs
IHNpemVvZihhcmcpKTsKIH0KIAotaW50IGhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBib29sIGVuYWJsZSkKLXsKLQlzdHJ1Y3QgaGlmX21pYl9zZXRfaHRfcHJv
dGVjdGlvbiBhcmcgPSB7Ci0JCS5kdWFsX2N0c19wcm90ID0gZW5hYmxlLAotCX07Ci0KLQlyZXR1
cm4gaGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwgSElGX01JQl9JRF9TRVRfSFRf
UFJPVEVDVElPTiwKLQkJCSAgICAgJmFyZywgc2l6ZW9mKGFyZykpOwotfQotCiBpbnQgaGlmX3dl
cF9kZWZhdWx0X2tleV9pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IHZhbCkKIHsKIAlzdHJ1
Y3QgaGlmX21pYl93ZXBfZGVmYXVsdF9rZXlfaWQgYXJnID0gewpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9t
aWIuaAppbmRleCAwZjhiM2JkOWYxNGUuLmJiN2MxMDRhMDNkOCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHhfbWliLmgKQEAgLTUyLDcgKzUyLDYgQEAgaW50IGhpZl91c2VfbXVsdGlfdHhfY29uZihzdHJ1
Y3Qgd2Z4X2RldiAqd2RldiwgYm9vbCBlbmFibGUpOwogaW50IGhpZl9zZXRfdWFwc2RfaW5mbyhz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdW5zaWduZWQgbG9uZyB2YWwpOwogaW50IGhpZl9lcnBfdXNl
X3Byb3RlY3Rpb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKTsKIGludCBoaWZf
c2xvdF90aW1lKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgdmFsKTsKLWludCBoaWZfZHVhbF9j
dHNfcHJvdGVjdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpOwogaW50IGhp
Zl93ZXBfZGVmYXVsdF9rZXlfaWQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCB2YWwpOwogaW50
IGhpZl9ydHNfdGhyZXNob2xkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgdmFsKTsKIApkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKaW5kZXggYTBjNzczNzkwM2I5Li4yYTljN2YyOGQ5MzQgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAt
NDgyLDEyICs0ODIsNiBAQCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwKIAllbHNlCiAJCWJzc19wYXJhbXMub3BlcmF0aW9uYWxfcmF0ZV9zZXQgPSAt
MTsKIAlyY3VfcmVhZF91bmxvY2soKTsKLQlpZiAoc3RhICYmCi0JICAgIGluZm8tPmh0X29wZXJh
dGlvbl9tb2RlICYgSUVFRTgwMjExX0hUX09QX01PREVfTk9OX0dGX1NUQV9QUlNOVCkKLQkJaGlm
X2R1YWxfY3RzX3Byb3RlY3Rpb24od3ZpZiwgdHJ1ZSk7Ci0JZWxzZQotCQloaWZfZHVhbF9jdHNf
cHJvdGVjdGlvbih3dmlmLCBmYWxzZSk7Ci0KIAkvLyBiZWFjb25fbG9zc19jb3VudCBpcyBkZWZp
bmVkIHRvIDcgaW4gbmV0L21hYzgwMjExL21sbWUuYy4gTGV0J3MgdXNlCiAJLy8gdGhlIHNhbWUg
dmFsdWUuCiAJYnNzX3BhcmFtcy5iZWFjb25fbG9zdF9jb3VudCA9IDc7Ci0tIAoyLjI2LjEKCg==
