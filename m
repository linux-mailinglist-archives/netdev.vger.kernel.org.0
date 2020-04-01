Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B81119AA60
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgDALHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:07:17 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:6053
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732363AbgDALFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euKpgOBqfmicGLOb6g3zoGBoUZCZQx3qzaV/iIUBBOaqvGFOivr8ljOB/V1fmNpPMrufKjA18ekGonmzeHQ3B6LwiwurwSIfgQCwm9bBvdlT1o2kPuV0zlS4H2LmBFTaJsGmBp/2K/bYnsCZn+TGsYclqYrr1v7/onWsGQ1S/SN1UmSkqSUR8cASAnT3SKpXk6JLoZAyU7q3v7VZDPvGSxAC0Ks4Zk6AtqgNy3vp67H5UYKTB3JDRlaKssFH/U9lAxwNE+TlP37CIXW6hGTdcA1YbElQgg5g6ccyaWklBmMnCpfgIcg6kPTzJQuL26ybLbena9SOzxEqUmDsBRAmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77gQiqNqTu8gkEiMjIxwEnynF727rXFv9lLt0W2uKIY=;
 b=R1jyV6ZmpiyTeODFRN5oj1lDAJpaoNx9LiNuGTFt4M8DFLeB/eJxKMzJaPt/hgdxB1UA9MkGqYtY5QnPNYfC4ZXIGQ/rW4V2mWatmcb04D0aCfwSMazOK8IBKjTSB1X0J+27aIre6MpumUlfrf5ohqHOGqAOAA0BB5UEVFmdK77B5ccYkL6OTadX5vDP5bnAJrTiB5OVmzOc0aaFutolX2KjEhC5UDycgCcWtaWKZqdnx8f143YO0KfcQnz1eZ3nSOpeAZFDQaizX3gkCKZgFMbfbgRJ6GjRG7UPBnR/Ml0ZJ9APmV1C8+Tdh1znnbzCEk/4ZA4ODpBD5wXS2Fw0cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77gQiqNqTu8gkEiMjIxwEnynF727rXFv9lLt0W2uKIY=;
 b=e4XAfeQZ2cVRxMUZOahTsBTCr70cM/XTnmL9KlfCJnsOGEinwQzG2d1RohlqOnaEh9DAbUgyPlvABcHTgs5XNV17KrZhpuqdRNBJkn+u+ml4oXgerzj39l9RwQSh4Yz1FI2qP6H9Faxs8Coryd/DKUjqo+06kLB8qdMirVYe0jQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:52 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:52 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/32] staging: wfx: do not rely anymore on link_id to choose packet in queue
Date:   Wed,  1 Apr 2020 13:03:49 +0200
Message-Id: <20200401110405.80282-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f5f50cc-3dcd-4c24-360c-08d7d62c80ae
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB42852E87CC1D5ABB56592D1293C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2z9tuh274ARHIwheXGSt3TCVuwChHBom4pLMjIGAoS+/KXQZ+RF/UmZAN6Mc2lfKE+jJjeH7DTJJYqZhN4eFXKZC1HhY0CRbPBd4gZnxmFbFpu8o/OdJdqNA3uvCMZUOt1dqa3lp5hRJdkbUekULx5EUSfumdVVD2eKamnsIeOIzqKwJ82MMaRVAtxpXmh2VXf+1d35w7QhUx4ZvX5oqs9TPv6pRsA69WMagUAx00sPMG5Wndnv7+8OztcXEw/ph2sazHo9QFotOBZytRstR4ApwrGNWGBWd/AMCKNHC7w7I1FmRbQlrYwBAi2QKOowVAaeOpyi/WIl8d0zmNvfeusCSRsYv48+ugcHCKNmnDnMiH0+SMDRwjRGVTE40NkLCTgansCirbIY2F5LpPv8Y4olDdB1Gw5yruMUmZm9JtgBAngWR9Mzdl48Fh9T/EWI
X-MS-Exchange-AntiSpam-MessageData: T2ryQobBzi7NqWWFHTc+TRgIXiwIH510hLcNTxbJscVN4cMNgMnG1FFD8F5g97Os+FOX8QxePwOvJR6JKHDo4AJneqO72Z++2hSm1IPLINWuCcvUEasiSjhVEdcFVmvN/n5iIVj5l63dwzJ5PU6gtYIGQ2nZXRvHf0MWlLUg5/6w7iyvL/IqBHJ2va/m6ltHuiUHcyRqVwDq6GTjDYKjVQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5f50cc-3dcd-4c24-360c-08d7d62c80ae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:52.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zij2WY1dl7SM3KQ2X4OyBal7jl8lBC5jzkQTv+UwgFutv8DJvagZGtogMFNOb8pVBMZ3ghSXOAfanRwinWdQpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbGlu
a19pZCB3YXMgZXhwZWN0ZWQgdG8gY29udGFpbiBpZGVudGlmaWVyIG9mIGEgc3RhdGlvbi4gSXQg
d2FzIGFsc28KdXNlZCB0byBtYXJrIGZyYW1lcyB0aGF0IGhhcyB0byBzZW50IGFmdGVyIGR0aW0u
IFdlIGRvIG5vdCB1c2UgdGhlCmZ1cnRoZXIgcHVycG9zZS4gRm9yIHRoZSBsYXN0IHB1cnBvc2Us
IHdlIGNhbiBkaXJlY3RseSBjaGVjayB0aGUgZmxhZwp2YWx1ZSBpbiB0eF9pbmZvLgoKU2lnbmVk
LW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgot
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyB8IDExICsrKysrKy0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpp
bmRleCA4MmMyNzgxYjFmNzguLjA0NmFiYTc3NjE4YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpAQCAtMTU4
LDE2ICsxNTgsMTcgQEAgdm9pZCB3ZnhfdHhfcXVldWVfcHV0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2
LCBzdHJ1Y3Qgd2Z4X3F1ZXVlICpxdWV1ZSwKIAogc3RhdGljIHN0cnVjdCBza19idWZmICp3Znhf
dHhfcXVldWVfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCQlzdHJ1Y3Qgd2Z4X3F1ZXVl
ICpxdWV1ZSwKLQkJCQkJdTMyIGxpbmtfaWRfbWFwKQorCQkJCQlib29sIG1jYXN0KQogewogCXN0
cnVjdCB3ZnhfcXVldWVfc3RhdHMgKnN0YXRzID0gJndkZXYtPnR4X3F1ZXVlX3N0YXRzOworCXN0
cnVjdCBpZWVlODAyMTFfdHhfaW5mbyAqdHhfaW5mbzsKIAlzdHJ1Y3Qgc2tfYnVmZiAqaXRlbSwg
KnNrYiA9IE5VTEw7CiAJc3RydWN0IHdmeF90eF9wcml2ICp0eF9wcml2OwogCiAJc3Bpbl9sb2Nr
X2JoKCZxdWV1ZS0+cXVldWUubG9jayk7CiAJc2tiX3F1ZXVlX3dhbGsoJnF1ZXVlLT5xdWV1ZSwg
aXRlbSkgewotCQl0eF9wcml2ID0gd2Z4X3NrYl90eF9wcml2KGl0ZW0pOwotCQlpZiAobGlua19p
ZF9tYXAgJiBCSVQodHhfcHJpdi0+bGlua19pZCkpIHsKKwkJdHhfaW5mbyA9IElFRUU4MDIxMV9T
S0JfQ0IoaXRlbSk7CisJCWlmIChtY2FzdCA9PSAhISh0eF9pbmZvLT5mbGFncyAmIElFRUU4MDIx
MV9UWF9DVExfU0VORF9BRlRFUl9EVElNKSkgewogCQkJc2tiID0gaXRlbTsKIAkJCWJyZWFrOwog
CQl9CkBAIC0zODEsNyArMzgyLDcgQEAgc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0
KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCQkJZm9yIChpID0gMDsgaSA8IElFRUU4MDIxMV9OVU1f
QUNTOyArK2kpIHsKIAkJCQlza2IgPSB3ZnhfdHhfcXVldWVfZ2V0KHd2aWYtPndkZXYsCiAJCQkJ
CQkgICAgICAgJndkZXYtPnR4X3F1ZXVlW2ldLAotCQkJCQkJICAgICAgIEJJVChXRlhfTElOS19J
RF9BRlRFUl9EVElNKSk7CisJCQkJCQkgICAgICAgdHJ1ZSk7CiAJCQkJaWYgKHNrYikgewogCQkJ
CQloaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7CiAJCQkJCS8vIENhbm5vdCBoYXBw
ZW4gc2luY2Ugb25seSBvbmUgdmlmIGNhbgpAQCAtNDE2LDcgKzQxNyw3IEBAIHN0cnVjdCBoaWZf
bXNnICp3ZnhfdHhfcXVldWVzX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAogCQlxdWV1ZV9u
dW0gPSBxdWV1ZSAtIHdkZXYtPnR4X3F1ZXVlOwogCi0JCXNrYiA9IHdmeF90eF9xdWV1ZV9nZXQo
d2RldiwgcXVldWUsIH5CSVQoV0ZYX0xJTktfSURfQUZURVJfRFRJTSkpOworCQlza2IgPSB3Znhf
dHhfcXVldWVfZ2V0KHdkZXYsIHF1ZXVlLCBmYWxzZSk7CiAJCWlmICghc2tiKQogCQkJY29udGlu
dWU7CiAKLS0gCjIuMjUuMQoK
