Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5251D488B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgEOIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:55 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728344AbgEOIei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krHkc+fWyHE6nOwxoR+k7/MmYtQoP2+bE/d0GFaK+HjRXISzhHDp1hQFjmvABCtcSINgjyqXxoY06KN/qXg1zEF9PiB5OH/mgPXo7YWezA74JtJH1asNR0lH1KrHioTuesq8mDYqVZrrfPLwS4MKPxli0wKndvB9zPED1/IjrSbeVZkitqJKolpqF/GLzp3JBCNQ4xA4PQMZpP63ky3irpPOVvkjZcZAhnQgWikBValSpuq93SfB5sFjPzKm8Oz/zbZqVLzSRgZ3R7pQp9Pg0+rfHLALMzTW+N+WEavHUJe5JCtywpjitSBj09zQzyqgOenWYjCDELuFcIglJI4K+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSbIlKTe3enIqg9YTCmAByx5NCD0EeouBjtUegseYYU=;
 b=EH7fqbfCraRuto5q7MFisH7iztjz8qEpJc/FUrQhe4Z9bncPBjJbuy4D6AIi8GRfy5ADbYrZ3yF5Zv2RsztLZZT0VYCeBAJjC0BhMvIvoyfAwNMA6O3QDrpftGwj++17SrrQCtbtHePH0+O6vjuutXxNZcLr8BWz+6dGKJ6Po3ZUJJEU6EhtZMvpOq7jxvLOM9jTmfXKLkU5uCEqNk8cmmc1ocUfSz/emYRAWuQqdVJ9YjBp+vCOxWs+xxdZO9T3gRSrHE0DGpSxetaGUEsQLBFlLsjcD0hCOyaDEOoAmqL5o8LbcuW1Xv9O9lcW6d9vHvaL40RZqUDUvEsw+XAekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSbIlKTe3enIqg9YTCmAByx5NCD0EeouBjtUegseYYU=;
 b=gBCBY2Ph8Fa2tj0PWz0Ytuz88QUyxq6oahaTIlyjq99S2+Y1u4HcWEBv0AQKRGe09kN02BIFkAMwKITIHdqnDemvJt1PybMirjWbbvLtxSYOfXOw1KiNY+IuoTfq673i8vqScWzCvvKq9sMU+DarBzNWtj+CH6dIyBF61tPCXPU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:22 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 18/19] staging: wfx: trace acknowledges not linked to any stations
Date:   Fri, 15 May 2020 10:33:24 +0200
Message-Id: <20200515083325.378539-19-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c43a91-d1fb-49d1-5773-08d7f8aac4b7
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13107481135F2C30B3798E2D93BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYb2UtXedCp75ekRa6RPesk76BXq/5yaxjDmXuTXbTEZugF2FYqWwM3L/E60VX891Mxu07xcjrtWvrQv0XumCYzzAiqyq6FKhdLfig4k5U2u+daYRWHjed5RKrlehhnGc8+JIjA9V1+01XY/oiFM/fEbuL3ZOnQPuVT1/CjRAlQUBUAlrWJP3d8+i4BlxZ41zLf0hi5cBMl6tWlYGzjxCA4OHLFUIMP0creovKlatZyIruIOQwF2wwe5ACRSVVYxSnKG1H9+gCE0lMIII28jyseeB5LpLYw12janyAYt9Sdk+RlfuN64+Z3C7h2a18sHge6ewxkpaGQ1OZghFeIjD9zX0/0wjKJh6ZslO8LsGU7ePSrtMizx95yURx4Ac7r1KibJknMop3IEefmNJFDXSg3l7xMC1IDxW/DYrIjmU2qZHM8Lj7u/gVzwXtj1R0ym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(4744005)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: n5TnXYb/si5hi1eG4/zNN8NPvKeew/p+dQnqWqH874TiIlNS0PT+4nFMQarO6y5H1BhB40buBa74hU5ov0ggXFXb23pIl7tikju0AsMWklbdHqVj8c701UUp/Re10QUWIVODgemomE2/A5/LVZnrtbiWMoJkmMC2VXgNlLhFTwevqHTFWC+HcZqlW0e1CwcvnVSgZ1mMA5fGOicdNm8gRdN+sRA1q7RTZNfAqxwhUbBqrqdcLhuwI4Zafs2/nQfrPRLBYZBAowMlzaLsyr8tXsrXyAhYmz+1DE4OS/2H04IKXrU/laMLZiuCX2pNY1+0bYciUONolvj2ngI3anw59vH6UBqRALbJY8yDD/Lehg3kliYLj7tT8p7plY7bXV/y924H20sAJwFZHZyrGCQ5HvMlkSUmojkGce8a38YuLcyWKwmkIDGeM3FA0eYqVe11/Rl7ik3xuAx5H5xXdLZKGa3GGBSHJTh7WEN5AqPPiow=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c43a91-d1fb-49d1-5773-08d7f8aac4b7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:22.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnoYlfXH466jUDuA8tuom+8LYDB6DD3Bd+TA8grh6/TllKm4wbVlAcXufCsFjGEdMgEiIhOR0vSLB1UTO39o1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU29t
ZSByZXNvdXJjZXMgYXJlIGFzc29jaWF0ZWQgdG8gdGhlIG91dGdvaW5nIG9mIHRoZSBzdGF0aW9u
cy4gVG8gYXZvaWQKYW55IHJlc291cmNlIGxlYWtzLiBJdCBpcyBpbXBvcnRhbnQgdG8gdW5kZXJz
dGFuZCB3aHkgYW4gYWNrbm93bGVkZ2UgaXMKbm90IGFzc29jaWF0ZWQgdG8gYW55IHN0YXRpb24u
CgpBZGQgYSB0cmFjZSBmb3IgdGhhdCBwdXJwb3NlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jCmluZGV4IGQwMWU2NzliMDg4MC4uYTgyZjAwZjhmMTdiIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYwpAQCAtNDgxLDYgKzQ4MSw5IEBAIHN0YXRpYyB2b2lkIHdmeF90eF91
cGRhdGVfc3RhKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRy
KQogCQlpZiAoIXN0YV9wcml2LT5idWZmZXJlZFt0aWRdKQogCQkJaWVlZTgwMjExX3N0YV9zZXRf
YnVmZmVyZWQoc3RhLCB0aWQsIGZhbHNlKTsKIAkJc3Bpbl91bmxvY2tfYmgoJnN0YV9wcml2LT5s
b2NrKTsKKwl9IGVsc2UgeworCQlkZXZfZGJnKHd2aWYtPndkZXYtPmRldiwgIiVzOiBzdGEgZG9l
cyBub3QgZXhpc3QgYW55bW9yZVxuIiwKKwkJCV9fZnVuY19fKTsKIAl9CiAJcmN1X3JlYWRfdW5s
b2NrKCk7CiB9Ci0tIAoyLjI2LjIKCg==
