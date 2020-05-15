Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623D81D4894
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgEOIfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:35:19 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728272AbgEOIeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxzeQpgfV/FLNtZ+A1nAcxYQFDLud27TTmhjIDpkgu+H0jUglnzq6bob3slIGmeaqH5uTysB2ngZhZTj+6deIf8H+7ES1sr5kM4ltN/6liq0sxVEurnNuz2RMqxhcQO7uWJnPiEpTatnmWe39GJC0paLVrLIQUF0XBwqWPYUqSsMckq7HrE0zyiEpEXrUMYEo8bwI0ajzPE5SIiJhkoSq1KMXYhm43MJBF4cJ9Pa4FPWoVeOzHhVtFzLM5EomQTdGcWrkTyNX9NOoOOhpQ/LA8ATVJvJgjHRpALbn0INjx8zx0mxXKA6sVFwk7Il2/FxNRR6UslpZBJVTHBCgr0dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIdi0OfIf4U/a1I4T0zQSQJkaEp77HTnXw31zXyAl6Y=;
 b=TQ8SZFTPyfOdsCl5OM6dnXSgI6MHvz88HD7pbuiyzq+bG3kGvMow6RxTcBvhECxuEjiHXZ5EVICSYYg09nk8YaU27A6f6ARBXSUoVF/b/9NTYOxhd+GsbIou2m2zEOTneWGqxtSTCKtSkx4aEClojQaUclddfEPTsoKYKZ5SYZ3ip9HFIG7rP9Anoisgy49IlcHJ5niYBfth7iah0pI6IaG1L5FSK9mJcuVQnxuYfYs1b++xldyHJj3NZfjijYUEH8h5p/09L7pII191Y92JfAvBlozUYMAuwPg98tf9iJfnb1R2Et7/Pp7XJmOCIjtO/Re+g3RUHnmrVXxgykGUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIdi0OfIf4U/a1I4T0zQSQJkaEp77HTnXw31zXyAl6Y=;
 b=Owso4xi7af8KgRQK3yTraa4M+f7RT7vVdmDizkRsL1C+/OmA1TzTHDsxRDABHrPm33t9MZm7LqNFiwLdBN6rAYTxFITiCvSNCpZBMBsEq06rZYFwP0G6VxNdoXTUL2dsPx1lplCkEO9vFrf5O8ZqCBEGrYfLlE2NLjRBsJl6JlM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:13 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:13 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/19] staging: wfx: fix potential dead lock between join and scan
Date:   Fri, 15 May 2020 10:33:19 +0200
Message-Id: <20200515083325.378539-14-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b11781d8-7919-44bc-8b4b-08d7f8aabf32
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13108C756D13B4FFA627DDEE93BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jvYECiRVwMPGmjp/uCCqfoyHw9gxC/TrBgMFfgnjC1ktH9Se16XhGx5ZXSrgPzg5ySeWEaNQOPSrcaAeKwoOe40UVzhb3U1NJFJjy9Md+F3k3RtWqbAaO7dKJPO5VS8Tba6EJ/C0keI+z2p3AY0n+St2d0ush0NX4sQhy5YuywpKHBngVnF75+t6d4j02bV6FeSha106ZmuyqJnmF27LYhjhxxilgWrAf8Ks27JC+bA5EluGQkcTztCeJqezTNfl2paFXdtNAlfwQowt4SuQw39tE2utqYn3qrNgm7b4uXFZdgc/GM4VBHWaNP7X4JsTHfWjQmyIr/TLbAM3c2x0pztU48n50XAvXoYkdkUvy+G4qHQn5AR7paPgjk9z47cAprSl0vswW20HIwrDenSRmsOaBB3xKyWHe3Dz5dc3qIDhGss14d4bcE7eP+mihy9p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Azbewu1Tyn/YS8cETNK9/rwn2mgG9UDW/leibxhhQsd0JKLr5U/D/7qQS+mKxbDU/JCst0+HHkcW+sMJQtPj4wz0/FYsc+cFc+v5gVhWRc9+LhdKKnrMKfKeUFv3EJOX5R1t+86CuPtkfGEd+UF7soNHe1g3LPX/7c5O7R93ZF2I92RrZS99p+R6kpBxt+sl0qJnChsMJ5SbtxWhuZcBEQ5KWpa0wCUjQQ9T+1mIE6A7fBfj3WwWPNwUFGOixKgR5AN2Mvdnogu0tWcKqk8IhaYWplXFC8spRd0s57u5BQV5tgM0+uXIg/Kcus8WmnZDsqtUBIaIqF5sruHaiLxEZJYPrkFLjdkzezBin143f5JGj66fhu6woALyOsVA4ZBp7fmjC2g846Fd2ydGF2NVHM/3oIEtL2Pj6jHbVqPLAG1K91jGMu8mJDY+7Fi3UiqgAKdOm4Suk9ooat2otucRbHQqQSIdvBwpTeFXnu+n1go=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11781d8-7919-44bc-8b4b-08d7f8aabf32
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:13.3273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrRaQEDS8bQUhJGgrxFz0OpJcxXQYC9vc+qYhQR7Wri/+wUO37PQKapRgDa30K8YyYddBHLOQbFgeL0FaoPPnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBkaXNhbGxvd3MgdG8gc3RhcnQgYSBzY2FuIHJlcXVlc3QgYmV0d2VlbiBoaWZfam9p
bigpIGFuZApoaWZfc2V0X2Jzc19wYXJhbXMoKS4gVGhlIGRyaXZlciBpcyBub3QgcHJvdGVjdGVk
IGFnYWluc3QgdGhhdC4gVGhlCndvcnN0IGNhc2UgaGFwcGVucyB3aGVuIGFzc29jaWF0aW9uIGlz
IGFib3J0ZWQgYW5kIGhpZl9zZXRfYnNzX3BhcmFtcygpCm5ldmVyIGhhcHBlbnMuCgptYWM4MDIx
MSB3b3VsZCBuZXZlciBhc2sgZm9yIHNjYW4gZHVyaW5nIHRoZSBhc3NvY2lhdGlvbiBwcm9jZXNz
LiBTbywKdGhpcyBwYXRjaCBqdXN0IGFib3J0cyB0aGUgYXNzb2NpYXRpb24gaW4gcHJvZ3Jlc3Mg
d2hlbiBzY2FuIGlzCnJlcXVlc3RlZC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3Nj
YW4uYyB8IDUgKysrKysKIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgIHwgMyArKysKIGRyaXZl
cnMvc3RhZ2luZy93Zngvd2Z4LmggIHwgMiArKwogMyBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCBiZjdkZGM3NWM3ZGIuLmU5ZGUxOTc4NDg2NSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMKQEAgLTkwLDYgKzkwLDExIEBAIHZvaWQgd2Z4X2h3X3NjYW5fd29yayhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAKIAltdXRleF9sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211
dGV4KTsKIAltdXRleF9sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOworCWlmICh3dmlmLT5qb2luX2lu
X3Byb2dyZXNzKSB7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgIiVzOiBhYm9ydCBpbi1w
cm9ncmVzcyBSRVFfSk9JTiIsCisJCQkgX19mdW5jX18pOworCQl3ZnhfcmVzZXQod3ZpZik7CisJ
fQogCXVwZGF0ZV9wcm9iZV90bXBsKHd2aWYsICZod19yZXEtPnJlcSk7CiAJY2hhbl9jdXIgPSAw
OwogCWRvIHsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDdkOWY2ODBjYTUzYS4uNmU5ZjM4ZDA1MWFiIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKQEAgLTM1Myw2ICszNTMsNyBAQCB2b2lkIHdmeF9yZXNldChzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZikKIAlpZiAod3ZpZl9jb3VudCh3dmlmLT53ZGV2KSA8PSAxKQogCQloaWZfc2V0X2Js
b2NrX2Fja19wb2xpY3kod3ZpZiwgMHhGRiwgMHhGRik7CiAJd2Z4X3R4X3VubG9jayh3dmlmLT53
ZGV2KTsKKwl3dmlmLT5qb2luX2luX3Byb2dyZXNzID0gZmFsc2U7CiAJd3ZpZi0+YnNzX25vdF9z
dXBwb3J0X3BzX3BvbGwgPSBmYWxzZTsKIAljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJnd2aWYt
PmJlYWNvbl9sb3NzX3dvcmspOwogfQpAQCAtMzkwLDYgKzM5MSw3IEBAIHN0YXRpYyB2b2lkIHdm
eF9kb19qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCXdmeF9zZXRfbWZwKHd2aWYsIGJzcyk7
CiAJY2ZnODAyMTFfcHV0X2Jzcyh3dmlmLT53ZGV2LT5ody0+d2lwaHksIGJzcyk7CiAKKwl3dmlm
LT5qb2luX2luX3Byb2dyZXNzID0gdHJ1ZTsKIAlyZXQgPSBoaWZfam9pbih3dmlmLCBjb25mLCB3
dmlmLT5jaGFubmVsLCBzc2lkLCBzc2lkbGVuKTsKIAlpZiAocmV0KSB7CiAJCWllZWU4MDIxMV9j
b25uZWN0aW9uX2xvc3Mod3ZpZi0+dmlmKTsKQEAgLTQ4NSw2ICs0ODcsNyBAQCB2b2lkIHdmeF9z
dG9wX2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlm
KQogc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJ
CQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICppbmZvKQogeworCXd2aWYtPmpvaW5f
aW5fcHJvZ3Jlc3MgPSBmYWxzZTsKIAloaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUod3ZpZiwgaW5m
byk7CiAJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDApOwogCS8vIGJlYWNvbl9sb3NzX2Nv
dW50IGlzIGRlZmluZWQgdG8gNyBpbiBuZXQvbWFjODAyMTEvbWxtZS5jLiBMZXQncyB1c2UKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oCmluZGV4IDA5YTI0NTYxZjA5Mi4uY2M5ZjdkMTZlZThiIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAg
LTY5LDYgKzY5LDggQEAgc3RydWN0IHdmeF92aWYgewogCXUzMgkJCWxpbmtfaWRfbWFwOwogCiAJ
Ym9vbAkJCWFmdGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9pbl9pbl9wcm9ncmVzczsK
KwogCXN0cnVjdCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsKIAogCXN0cnVjdCB0eF9w
b2xpY3lfY2FjaGUJdHhfcG9saWN5X2NhY2hlOwotLSAKMi4yNi4yCgo=
