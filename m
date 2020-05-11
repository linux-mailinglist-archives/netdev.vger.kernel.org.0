Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22961CDF7B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgEKPuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:14 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730632AbgEKPuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+H2Ml6W4qHY2IwA9fhT1pxI64ZUkfM75udC1y4LY5FprUJwOEDlXNHQ1rAfzwm3EQJteEH0EPduegl9JAVsJYk0RYYw9WZcmHDHmCYqR/3VsbQkp/Q5b+S87Q/ewLg7fInCyu6JuY335wx+Jpx1RFeMX+3maedLrofa7pbC3B59B/G2feoGMtI8Z/w69R0TDQwSvwZqInleR3YDfdG/5a8Vf4LJ09sc+1HPPusiy2Cn+Bs59BGo/94fi/HgjpDRxdduC0C/ma+wDwtczZ4H5R+A3m0Ec4oN5ro8OlzZU17jYPwCa7X2/bP/xK9Be7O7qU10OJorra86J/0akpjXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkzghTDCsqoKkN2RTocV98XMJiCXurzeGJcUFs2XUWs=;
 b=cbsUKprzXhFVpBC0EL4/KOOXplGMcqjlSOKcrG6iQrZoTo64zm19ASBgbHklzBSbR/MMyI814cII/vBkKihBKGM+q5W0e/D56FnD9U3T7j9IsT1Tu7aU7h0iCZxCHCG/qar37efvRuYt0Wfg4sZ9bs37A6vCrCAo2ZCu/xj5BUeIb6+A6HHSgQ2OkkHqNHf6qXXYzfI3X5hl/UcBUxfM32Ivjxs8Tlvw5PUG41nTOuJlrdO04mGfHevKD1xcb4GpuzbF+nsOo+R4WkGLmUY1p2/6MNK1ldibBYFfKyKmpUoajKx1gnHbtJ93Oqrsus0dqXzNKSkeC6v/wbrBJSKSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkzghTDCsqoKkN2RTocV98XMJiCXurzeGJcUFs2XUWs=;
 b=aSXGO1y33LD/8uWfAHluzr4vafNeqWWAMXVels4ZJjedEGh7uDrNxX+qp03xZxlQLvMN7zsYmEylkfM77OMm7yyy0OKiiR0phdpesVyzhrjk3jmx2GPI7Ih+sCUMKcVgRsVsWNelTB13lPwJa3ynIeeJ1z6FK8SsmdFkLsVoebk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:06 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:06 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/17] staging: wfx: fix access to le32 attribute 'indication_type'
Date:   Mon, 11 May 2020 17:49:23 +0200
Message-Id: <20200511154930.190212-11-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf73410-0d10-420d-2073-08d7f5c2f993
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB19687BD65F7C62E5C6A6BB6093A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1r8v55+MJVQWEFel2GBnLa7b3G7ylhaH4X+QE/Id2kqtt+cG7F+QAnduHCZR2tHKVpKjFpYwrjQQj2pyYy4jikN6ErF8cC+JamKKsGzcVEhOCUl4O8m31CwSyyk8BB520+6GEXbOWBSw3mAsl4CP4Vlhr1o+E2nrY+x6zjdfadFDgUY0IYzicnryiZZt5xe726S4vzP/tG3V/lCZb9+i5ypUg7XDXFWolfoestE5VUBw+TSX/MGQtpiS+HGkhPTWlS3yUSXZy5s2Ggj3Do8cyOC/TFldv6HcLFU2X84dvGXa7H/MqTdI/P0D9mmzoztnysn/jYlI9h6ctslhruNIxFnexPZ19omjiVtIfmaC/DDBzPg22cDGIb/8ttFXBRsOrN5FguhfKEKFByzZBcNjRouctCzMiJfyRrZO9ZkTaNaufxrVIFwAdHmKymPmdn3DmMCQkAWk/Y4tKRedNmJ6xrVC1gkvif34ZQCBxL0l0zGb2cVljQxz6MtpNHcMavOwU8kKDVfMnzVtRivUr0SJ/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cwtcq3NXHTwZkHpz3JWXP9n0Ih4q3qq0/eU5qBVMfYCb9dLn+GdZLT4QWpi76cseWt5Xmou/Xs7sC6OWaqe7x6u0ILrJ7TT4nH6L8VJfWpYMQ/0Z48oMSF4KEYvthsXVHPJqlMXj4x+ocLgXHOMpmWFbgzVkjhlYyiweHLGvx4zEcxkPGSvb72/5HQW0ilf2ElCYsdAYwjqCRI4LotwEKreXy2q52W0AYtLePMIIHM+3J8z8a/Z5uVQCdAN2AypCgulLqNuZ+n9e0N7OYVpKvUqwz0iwykYpYGwicEXkXrXmr9+pTwj2sOjCqHtgF07xGuUb+s374Hrk77hu9ulizukMdvixu9SE5ye/Wl7Pr5UDzQdXAMBzq/QqjIyer/fFb5pZVjBemFvi6NHj8Xtg8rHsKXZaPGMIwf4TtN7eYl0KDgDiDshnIYHjqGB5uY+Ek61KRPnaLrdw1cDQSWZ6XqI0zET4//kVOrTG7ibY7WQ=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf73410-0d10-420d-2073-08d7f5c2f993
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:05.8602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O03P8vlpgvOrnvpkC+p3dlKqhZLmJlqx8Fdf3Daj/RHypCd8Vyc81JC6z79pqtlxy7OehZedkdWA18pBPfso4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGF0dHJpYnV0ZSBpbmRpY2F0aW9uX3R5cGUgaXMgbGl0dGxlLWVuZGlhbi4gV2UgaGF2ZSB0byB0
YWtlIHRvIHRoZQplbmRpYW5uZXNzIHdoZW4gd2UgYWNjZXNzIGl0LgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgfCA4ICsrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDk2NjMx
NWVkYmFiOC4uZmNhOWRmNjIwYWQ5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTI1OSw4ICsyNTks
OSBAQCBzdGF0aWMgaW50IGhpZl9nZW5lcmljX2luZGljYXRpb24oc3RydWN0IHdmeF9kZXYgKndk
ZXYsCiAJCQkJICBjb25zdCBzdHJ1Y3QgaGlmX21zZyAqaGlmLCBjb25zdCB2b2lkICpidWYpCiB7
CiAJY29uc3Qgc3RydWN0IGhpZl9pbmRfZ2VuZXJpYyAqYm9keSA9IGJ1ZjsKKwlpbnQgdHlwZSA9
IGxlMzJfdG9fY3B1KGJvZHktPmluZGljYXRpb25fdHlwZSk7CiAKLQlzd2l0Y2ggKGJvZHktPmlu
ZGljYXRpb25fdHlwZSkgeworCXN3aXRjaCAodHlwZSkgewogCWNhc2UgSElGX0dFTkVSSUNfSU5E
SUNBVElPTl9UWVBFX1JBVzoKIAkJcmV0dXJuIDA7CiAJY2FzZSBISUZfR0VORVJJQ19JTkRJQ0FU
SU9OX1RZUEVfU1RSSU5HOgpAQCAtMjc4LDkgKzI3OSw4IEBAIHN0YXRpYyBpbnQgaGlmX2dlbmVy
aWNfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJbXV0ZXhfdW5sb2NrKCZ3ZGV2
LT5yeF9zdGF0c19sb2NrKTsKIAkJcmV0dXJuIDA7CiAJZGVmYXVsdDoKLQkJZGV2X2Vycih3ZGV2
LT5kZXYsCi0JCQkiZ2VuZXJpY19pbmRpY2F0aW9uOiB1bmtub3duIGluZGljYXRpb24gdHlwZTog
JSMuOHhcbiIsCi0JCQlib2R5LT5pbmRpY2F0aW9uX3R5cGUpOworCQlkZXZfZXJyKHdkZXYtPmRl
diwgImdlbmVyaWNfaW5kaWNhdGlvbjogdW5rbm93biBpbmRpY2F0aW9uIHR5cGU6ICUjLjh4XG4i
LAorCQkJdHlwZSk7CiAJCXJldHVybiAtRUlPOwogCX0KIH0KLS0gCjIuMjYuMgoK
