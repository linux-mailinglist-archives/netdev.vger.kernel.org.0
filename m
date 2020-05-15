Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B4E1D4875
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEOIei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:38 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728303AbgEOIed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTSx5UFlK9EToNKOfD9CJiEi3v4bUe7IbYqig09FcpoaKf3FHaYw1KqdZEqXmIys14WVf7Xw/zupMVzrR6NUR6V4cIzhWW7FiZYV+dYkzKOCOoPtdAZSzqaazIgU/3+Uk3TsDDtJwxAyPSOcX4OGSalNGBOragkyZG1FVulM1JKyaxZDI0cmg2zg6cS723jCcDR7TrRkBBXAsUx5Y+FLj2huw+XMpENGlvUPSHKYdBFc7EOzf1bPKWvAJxJ6eNrEGsheFp1Dehxu/AOM44iysAIJtivs9jHGalawKkp7LiQq5Lt9TRh45UKaEwMj715dQZMHMRTiDX08GPMOFcob+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iAr3L+Z/U5t5GrzA6d9+xJ7lD8R0AItbO5PmLu8DFE=;
 b=JCl2U09O841AbPYfZZIuZWmYq1DcUA+vHh/JMiIPRMRbxwAG5OIkAOe4Qm1mWLEkJZLrcyNiBFDx9n9x0wJmwb+60OiF0lW/e6D+PBrX1u9wURp5C88/xwlsiR1+lkQjqiB9VP4ekAbnfN+J54Guz2eu1rs1dwtbcg0N9wdalYcyounRbIx6gXMDGdP22jkBTaBfkArtVQYEndxhmJsyCxx0fXQ1nBLndyrNey4YlT/x7j+2iVngedfJTKczPDH7h0vuNC+mtn6g4c/rzM1NMWY8lxBFQ0w5HleUtXNodIAV48ld+3iEDaJpiiYwE9SoQE1N8srKHLm/6zRtxdtOZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iAr3L+Z/U5t5GrzA6d9+xJ7lD8R0AItbO5PmLu8DFE=;
 b=FNKPYNu1Z1Xmj3brbHsmZxlI/iBRuIHL342Agrgg1VXvCMBnYXvTWUHfc/oBHQY13IWhs93xCqekjJcMuOWRSU/eRrKBu8fbrB6zym7Fe4/JTj22UEhEiRgHkAGh50cy5lu3qVS8uirFQdsTAYCtE1HVKvocyhCaSu+oKR/DMqY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:15 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:15 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 14/19] staging: wfx: fix PS parameters when multiple vif are in use
Date:   Fri, 15 May 2020 10:33:20 +0200
Message-Id: <20200515083325.378539-15-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:13 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8d50d96-1e6d-44cf-62dc-08d7f8aac045
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13109502A119353C7E8357EC93BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bzGvCb1WQ/RubSBUK5pd+SmW2W2vDmXBstshyO5aVG6s3vCLHrw+BjSDRVMWTRmD86HVcD6JpzXh7GlUdsi78+j9QRghcPu6iuTfat1uVgZgsSrNqlxf8ZZk2rfJZPGCgjJmZ9574UYnMmgSPS95PvwIN+gIDbP8ah0vhSVoOVZ/8KZ9zwp8Ls6hhvdOgasBHjNCDnahWyujWFr0/PGIuswc6NgtWLrzjHKmiEnRuAfz0uJWX95yjd/h0fsWGWFjCNuqK/PamGe02zyQSatvftsVXKxmjRw09i6RbhqyjlspVI6IADIfQKMVO/J+sGpO3R8+UZzhSX/J18diHBXgR+T6f7yXk565NHLylEku9OX1S7dRFURd63eBmGwtIODpOfy8m3pvqXGn7m5FnS41DGo/ya+3R39xevv28eKxS2vu0Hw1AKVcYth++AFJawHW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /t9FMCg6CBlr7DuEMuwdg+cebTy0uAgKfF75CBYXIA0E0exf3Ts0Z6x9Dj+rhN5+5a70r4utN86bN6nJ9u6NRBUrKMCbt1y0Ubwynl4ehEl8hmJIvMj5eeovI7wjQu77L7jkDgWtrmLWZ2GbJp5/dkPpTgshTcxK6zsvwSMYbZdX58d6jc3tNO4xvEFlv8hBFK+wFIARzNEkOiU5p5EcJ7/d+oBJMzed+giOOz68/RQR9BPpvlA1dHp24AMvhGY0BHPU0dRwBbuWDwhrVZplLpRodc6gOOz+RMjA86dkI7jIZjPbBIrp+WG+/VJcDOgIYxb4TQg6cx/7ALwtcRYyyJAM8qIIo1zkKwo6kcBSkLdadw/crfhZh/FLH5v4zGy0EQwfVSIRX5dFzA0y1HeD1tf45eQbuq82AbcUH/qomKoqh7kKm/sGLjcSspPEp1+ER4++wWVFNf/TWkjPV1qp178+O99nFNYmZVKiqBhi60A=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d50d96-1e6d-44cf-62dc-08d7f8aac045
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:15.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTZBDplFjlO2dV+FPKiSfWAhrfuzYwLo/b+22W4kBvYxz8z02zFVBDVFe4IUX7H0n99V6yHVw50mMoeDF4itkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBtdWx0aXBsZSB2aWYgYXJlIGluIHVzZSAoPSBvbmUgYWNjZXNzIHBvaW50IGFuZCBvbmUgc3Rh
dGlvbiksIGFuZAp3aGVuIHRoZSBjaGFubmVscyBhcmUgZGlmZmVyZW50LCBpdCBpcyBuZWNlc3Nh
cnkgdG8gZW5hYmxlIHBvd2VyIHNhdmUgb24Kc3RhdGlvbi4KClRoZSBmaXJtd2FyZSBjaGVjayB0
aGF0IHN0ZXBzIGFyZSBkb25lIGluIHRoZSBjb3JyZWN0IG9yZGVyOgogIC0gQVAgY2FuJ3Qgc3Rh
cnQgaWYgUFMgaXMgbm90IGVuYWJsZSBvbiB0aGUgc3RhdGlvbgogIC0gUFMgY2FuJ3Qgc2V0IG9u
IHRoZSBzdGF0aW9uIGJlZm9yZSB0aGUgYXNzb2NpYXRpb24gaGFzIGZpbmlzaGVkCiAgICAoPSBi
ZWZvcmUgdGhlIGNhbGwgc2V0X2Jzc19wYXJhbXMpCgpPYnZpb3VzbHksIGluIGFkZCwgd2hlbiBv
bmUgb2YgdGhlIGludGVyZmFjZSBkaXNhcHBlYXJzLCBpdCBpcyBuZWNlc3NhcnkgdG8KcmVzdG9y
ZSB0aGUgcG93ZXIgc2F2ZSBzdGF0dXMuCgp3ZnhfdXBkYXRlX3BtKCkgaXMgYWJsZSB0byBzZXQg
dGhlIGNvcnJlY3QgUFMgY29uZmlndXJhdGlvbi4gQnV0IGl0IGhhcwp0byBiZSBjYWxsZWQgYXQg
dGhlIHJpZ2h0IHRpbWU6CiAgIDEuIGJlZm9yZSBoaWZfc3RhcnQoKSwgYnV0IGFmdGVyIHRoZSBj
aGFubmVsIGNvbmZpZ3VyYXRpb24gaXMga25vd24KICAgMi4gYWZ0ZXIgaGlmX3NldF9ic3NfcGFy
YW1zKCkKICAgMy4gYWZ0ZXIgaGlmX3Jlc2V0KCkKClRoZXJlZm9yZSwgdGhlIGNhbGwgdG8gd2Z4
X3VwZGF0ZV9wbSgpIGZyb20gd2Z4X2FkZF9pbnRlcmZhY2UoKSBpcyB0b28KZWFybHkgdG8gYWRk
cmVzcyAxLgoKVGhlIGNhbGwgYWZ0ZXIgaGlmX3NldF9ic3NfcGFyYW1zKCkgYWxyZWFkeSBleGlz
dHMuCgpGb3IgdGhlIHN5bW1ldHJ5LCB0aGUgY2FsbCBmcm9tIHdmeF9yZW1vdmVfaW50ZXJmYWNl
KCkgKHRoYXQgaGFuZGxlIDMuKQppcyBhbHNvIHJlbG9jYXRlZC4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jIHwgMjAgKysrKysrKysrKysrKy0tLS0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCAxMyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDZl
OWYzOGQwNTFhYi4uMGNiNzMxNWJiMDUwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTM0NywxNSArMzQ3LDIw
IEBAIHN0YXRpYyB2b2lkIHdmeF9zZXRfbWZwKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCiB2b2lk
IHdmeF9yZXNldChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKLQl3ZnhfdHhfbG9ja19mbHVzaCh3
dmlmLT53ZGV2KTsKKwlzdHJ1Y3Qgd2Z4X2RldiAqd2RldiA9IHd2aWYtPndkZXY7CisKKwl3Znhf
dHhfbG9ja19mbHVzaCh3ZGV2KTsKIAloaWZfcmVzZXQod3ZpZiwgZmFsc2UpOwogCXdmeF90eF9w
b2xpY3lfaW5pdCh3dmlmKTsKLQlpZiAod3ZpZl9jb3VudCh3dmlmLT53ZGV2KSA8PSAxKQorCWlm
ICh3dmlmX2NvdW50KHdkZXYpIDw9IDEpCiAJCWhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlm
LCAweEZGLCAweEZGKTsKLQl3ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOworCXdmeF90eF91bmxv
Y2sod2Rldik7CiAJd3ZpZi0+am9pbl9pbl9wcm9ncmVzcyA9IGZhbHNlOwogCXd2aWYtPmJzc19u
b3Rfc3VwcG9ydF9wc19wb2xsID0gZmFsc2U7CiAJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZ3
dmlmLT5iZWFjb25fbG9zc193b3JrKTsKKwl3dmlmID0gIE5VTEw7CisJd2hpbGUgKCh3dmlmID0g
d3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxMKQorCQl3ZnhfdXBkYXRlX3BtKHd2aWYp
OwogfQogCiBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKQEAg
LTQ3MSw3ICs0NzYsMTIgQEAgc3RhdGljIGludCB3ZnhfdXBsb2FkX2FwX3RlbXBsYXRlcyhzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZikKIGludCB3Znhfc3RhcnRfYXAoc3RydWN0IGllZWU4MDIxMV9odyAq
aHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiB7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYg
PSAoc3RydWN0IHdmeF92aWYgKil2aWYtPmRydl9wcml2OworCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2
ID0gd3ZpZi0+d2RldjsKIAorCXd2aWYgPSAgTlVMTDsKKwl3aGlsZSAoKHd2aWYgPSB3dmlmX2l0
ZXJhdGUod2Rldiwgd3ZpZikpICE9IE5VTEwpCisJCXdmeF91cGRhdGVfcG0od3ZpZik7CisJd3Zp
ZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7CiAJd2Z4X3VwbG9hZF9hcF90ZW1w
bGF0ZXMod3ZpZik7CiAJaGlmX3N0YXJ0KHd2aWYsICZ2aWYtPmJzc19jb25mLCB3dmlmLT5jaGFu
bmVsKTsKIAlyZXR1cm4gMDsKQEAgLTc4Niw4ICs3OTYsNiBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZh
Y2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiAJ
CQloaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3kod3ZpZiwgMHhGRiwgMHhGRik7CiAJCWVsc2UKIAkJ
CWhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweDAwLCAweDAwKTsKLQkJLy8gQ29tYm8g
Zm9yY2UgcG93ZXJzYXZlIG1vZGUuIFdlIGNhbiByZS1lbmFibGUgaXQgbm93Ci0JCXJldCA9IHdm
eF91cGRhdGVfcG0od3ZpZik7CiAJfQogCXJldHVybiByZXQ7CiB9CkBAIC04MTgsOCArODI2LDYg
QEAgdm9pZCB3ZnhfcmVtb3ZlX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3Ry
dWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAkJCWhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlm
LCAweEZGLCAweEZGKTsKIAkJZWxzZQogCQkJaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHd2aWYs
IDB4MDAsIDB4MDApOwotCQkvLyBDb21ibyBmb3JjZSBwb3dlcnNhdmUgbW9kZS4gV2UgY2FuIHJl
LWVuYWJsZSBpdCBub3cKLQkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKIAl9CiB9CiAKLS0gCjIuMjYu
MgoK
