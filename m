Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5701D4873
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgEOIe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:28 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728228AbgEOIeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UISsZ+IQCOAc3jGEJDmIBLx+reWz92eWxTFua0UN7g0VaoewQOvA0C9pg6cr9gKge4k5iEl8ZIIiW6CkohOeGJpUlezsApDUNQKjZRj3Lw7CQAK/TURTNhe45SHNiPWfl610biLtpyS+rxGi1byY9Z5iscPIfm+U2cHg/p9Teh9DJsUzBxYtARsdOlX5VfYJRUmwi0L1aETrQF7a4PHd/ctWbopo+bGvvjvTUwLs05ZijRInEHvWLdGitQM/Bp/1EPYmhxTwSVt+KReVemsfWWODatypfys3aQDyqrypeyLJAmQRkb76rc5csByPc/hWsvi2d5gdNkOV4B60UbwyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2/uJBnFXK1MccmUxLJTBKzXkhhxxrrgq2O7Ydk7FRw=;
 b=EZnbDTall97ToupXoSEy+CI7pa2UwDEZXxv3fgVC3n3+37StG5wJ2t6l3eEue+/Dtu+44f3CMldNlTGKRW00Fn8FYR3+lAXU908KcIfTVmcBMMRo60X1K6+oGpYaPIF+Xq1e2ZbF4SxIkahB6ZBOnNXnSaIYNwjiD5KVLTLJKxHjFy39IBgqDQHUpUwx3ZAtQIf+TwaukMUILjoYNacOTqtlDNwiUkUkOMxRODyfO7K9aSmrrsKw3BsqdU4bISe/qgssXir2HS3e7wv/Q24PBYBIPwqWXd6E5f0+867rG6JyEtbB6NcGsvw2DDs6E+vV0I5tWzZz7W9oeWL8stVYBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2/uJBnFXK1MccmUxLJTBKzXkhhxxrrgq2O7Ydk7FRw=;
 b=RPz4QLf+Jx/YOD7gbtDJxYktT4xmRxOPLnvnrU0EjEnbT+jcUWkwCV6vv9GWbNc4ENdPbgQLN6TJGRkERVe+1+8AjXGqP0hf8HjG8h0LxWG/feKape6VcTljZNzy5/uGHTw3UH7fX279XkxRJ89Xj8uoSimQd5Jk++114IzlSOQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:07 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:07 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/19] staging: wfx: fix potential use-after-free
Date:   Fri, 15 May 2020 10:33:16 +0200
Message-Id: <20200515083325.378539-11-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 141ff5bb-92f0-4cfe-62a6-08d7f8aabbac
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13107364ED13CED46968974293BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g10O0dick9Axs7LvbpGPnOZRJAAFwDJJR9oehfWBBMkJKIh/Wek0g16XhSby/Nj5sNfOD7TuywKlMNi+Djb4/6UOE8Lq60FW9z81iMIdUaFHfgR7XXDT+ZRPEmYxBeuT8/fEeDFu6flZxGGdxnoQBiFoFCPZndpq33Accog6xStWrFsqfPvQYf71f3TYdjzFf1Ul5D9DnIV9Cq1AjepJqASPHNZCHHal3302BE9hIey0XsUZ9PSxGuqMk4SxQcu1sEMqNqA1VsML0Fx0pe7QnB+b794qU1rq9hRLRq5ccslAzJ66i/Jz8/5he6BUBrmnsWH9AUU4HNJkjrhWQb+0yGM8HEc6hi+u3tipaKI54UKdasIrU+7th8Cpi0vcSCednPdtbnHqlVaI81lhE0pPF09s4ZW3DHx5hgpc4s9VTYUloXIFByg7m/Jaek2wBVdK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(4744005)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vsxLaBW+KtWbiaWQYiGiL8mLPmd/vRbHAjN7Z9HW/RHy5cLucF4eUG6S2uB+xHVZS6J8zfH1clXp8Yi9Nr8oeXvJ4wsrutPpeRFCmx+Je8iND+OnDB+8vqAV+RwlT5tQy2K5cyaOk0vmpLG79jwtWUxFyaAbCVyp13wit7DWAJhlD2+HPLnkhO8b7GM4CKF7jSYc+iKDDSXvU+nTUlUSv2ioAXX+CwBZYqVgz4WFjPsekbPPfuVPl62VhY/dhkXost8nMGFCkp/NnzYboeNUXH+OdONghk02mRh51unuWic59xmrvkwwg7oF6QIWvO/uqsDuSa5xJt6GuULML65OzInZvQr4frb4xTRxattkml+dQiRLEzIxZLUuZ7ijMUn5fMpzaLzQDr6ZN5B4x/yzyOAq1T4brCMtiFFWuSi9aobNZGo4MjIh7uqZn3rEsH8wFD17UDk4oVxIcPkFeFXQLK3DhPcEjO4C6vwetqJngKo=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141ff5bb-92f0-4cfe-62a6-08d7f8aabbac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:07.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3qjQrSmlEfp3IoHTDqUgzw80SW9BGHxYWnExmiu/ZBKKEYK1/JUhDhOEKbFkJ5fHWMStMhcLo1B/uyLBmJ5vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3BvbGljeV9wdXQoKSB1c2UgZGF0YSBmcm9tIHRoZSBza2IuIEhvd2V2ZXIsIHRoZSBjYWxs
IHRvCnNrYl9wdWxsKCkgaGFzIGp1c3QgZGlzY2FyZGVkIHRoZW0gKGV2ZW4gaWYgdGhlIG1lbW9y
eSBpcyBpbiBmYWN0IG5vdApyZWFsbHkgZGlzY2FyZGVkKS4KClNpZ25lZC1vZmYtYnk6IErDqXLD
tG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggMzE0Y2MyNzQzYTJiLi5k
MDFlNjc5YjA4ODAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC00OTQsOCArNDk0LDggQEAgc3Rh
dGljIHZvaWQgd2Z4X3NrYl9kdG9yKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKQogCQkJICAgICAgcmVxLT5kYXRhX2ZsYWdzLmZjX29mZnNldDsKIAogCVdBUk5fT04o
IXd2aWYpOwotCXNrYl9wdWxsKHNrYiwgb2Zmc2V0KTsKIAl3ZnhfdHhfcG9saWN5X3B1dCh3dmlm
LCByZXEtPnR4X2ZsYWdzLnJldHJ5X3BvbGljeV9pbmRleCk7CisJc2tiX3B1bGwoc2tiLCBvZmZz
ZXQpOwogCWllZWU4MDIxMV90eF9zdGF0dXNfaXJxc2FmZSh3dmlmLT53ZGV2LT5odywgc2tiKTsK
IH0KIAotLSAKMi4yNi4yCgo=
