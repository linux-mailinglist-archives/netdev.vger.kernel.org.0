Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE24C1E7CEB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgE2MQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:16:21 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:32481
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbgE2MQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 08:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGGo7Np+e6XvgbXPZyJyPGlUqI0G4xhHCPWd+TihVG5tdXZXV2oG9NHD4jOGESTueDg5uVVUjaNnp/IkmgubMWG1637tTUDwX4BMwGYypo48ssKWY7rSd5slbu9J+chJoct7k2TEMJcdzfA91l/+ondqoZHw6O4DMCCLdJrhco7Z7ExQOgAQH3VeXkXnBG3PFmi28O3FsRMkcAaa0/es9mhpWX0SwRzTNFRPYEfst1KAIz7JV6iRjn5DNP9SsCVfcB1LyySfAom3fRt+88FX1IALVFXQFpvzXAy2/sMNUZFPH5Jeb74AJkVLY2ZFQvensLHE6YkLIEkCUq/rmQYSeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pS6GwXPH+vI9+rcmnrxh4DWXzvL4ueY89feeSX+FW1U=;
 b=O+m8daUTuMkiM1YLGjUk8wDlHIfdNzrqgRz/qjrt399qhGmgowIyOtqfOd/3e6Fv2x6k4EeXaq7T1XGosjmY/Af5jNjjO2FL80i+5iVbFGlp3PqV5PdWF6u+AjFfVDMcOLMahw6OU/PpgWz3woW9sbV8+Io2TfwCd4t3poXD8cTZJixO1M/BdDLsq6eo8njWPWhT7gefZr6lXqXEDNq821LhWOxwkPJE+pHKOsO1L+ivmzK776xXJBVdj+9QVNPteU0xNrIVHt4leKCRSzBtiSYwoHpdAI8TRC+ZGPxRE+TSTJG2GXwO3mm5PEIv01eAsYWfPhrIiLTTnishQGDQRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pS6GwXPH+vI9+rcmnrxh4DWXzvL4ueY89feeSX+FW1U=;
 b=HaktJG9yiehg82oXrfBPpUFMkDezls5x1NySyI7BuMzlJ0kHDvH/6mWHyunmR7LRsFari05WC0tRmFcLRAseTLErGLa4pOAe/hXya48gvCDIGeG6FHO7gQ535Kb+KreKWrlpt//7wSlkQzFDF72aa52NVrq5k2b660vM7UH4cmE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2781.namprd11.prod.outlook.com (2603:10b6:805:62::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 12:16:17 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 12:16:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 1/2] staging: wfx: fix AC priority
Date:   Fri, 29 May 2020 14:16:02 +0200
Message-Id: <20200529121603.1050891-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR06CA0051.namprd06.prod.outlook.com
 (2603:10b6:5:54::28) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR06CA0051.namprd06.prod.outlook.com (2603:10b6:5:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 12:16:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d54ee20d-937c-4c34-9c64-08d803ca16f6
X-MS-TrafficTypeDiagnostic: SN6PR11MB2781:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB278100B738222BECB6EF608B938F0@SN6PR11MB2781.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GkU4NvpcvSuhD1so5+0bjiudCBXJrvJpaUkY4caTUweTFzRt94UahjwPjJ+vJ1s+CNHXkAdF+qAXuhq0PFvTCbg4TMvSto/KccBa5u2zZ8scirYhDgZIqTiSETDhUSfrpWdgi2OrR6lvdrQuCAOkhmIXX4ce67a2FaOpBvlJGGrVBgUrJCRCEuc+LUc9gSsBKWiNKcL+YdylAqj465dkIS3Ij0tbuR470b0lcee3Tmr9OoUs4TkPw5mQA1TUYb+wiDWBs9irZ2EEVEw2rq4SgEW3e76Ro3yq7YOpfoYteqtPTSokk5FmiKyDC/fWwABz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(346002)(39850400004)(366004)(376002)(478600001)(186003)(5660300002)(8936002)(7696005)(16526019)(52116002)(2616005)(8676002)(1076003)(86362001)(6486002)(66476007)(66556008)(66946007)(316002)(66574014)(83380400001)(6666004)(107886003)(54906003)(2906002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FSB6aFwIK7JUrfF8IECnQ1hCuoE42SNUilskzmD9OQXCy1+AuO/fM9MurC0OyVpgzn7HsdLLeiDSRV3i6yJL+K1uPVEYBc6Fad8UHVrJ2RFpxq/lcnwr/E77TisO3TwGqHbWVIuJyS93fbELF0A3PHCK8cmR3Fx/GumCYFw6pQ3KyqJejAW7KreRP5VC6nSz5hNgdWj8JugsGIgSh1+gFPt1PfZ37w+NNSie6PyZcA3GjDqr6vuSch+5YS7Xkatv/ZGzW87aZeGkhoGctl0rm9Ep7eKLdCrQ2bbaOlajxOsgRZ+nLCIFa9R5s1/LxB0skUIXHbtl/uA7n/vLRTJLhx8zvF7RQAUITCIV0lRKXV6Dtd1hqhXxfX/Ynewm1e+rlgWJjYcr5YlcriVadPtTuHA0FIG9CKf9SYhkXHcu3bedb1rZ7zOOb4UDta6tLv981cJ//4i++dNapSeNqEMaj1xHoIyqYWhIxQC3ct+jaJTurTymkScu27L2MMoZWO2HByVjz6dPBs96VoZwYjeYom31PyQZ2RJuRyQhmFXN5sY=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d54ee20d-937c-4c34-9c64-08d803ca16f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 12:16:17.8811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwbS4F6vmxHLcuaKjw/C+FQ0YL/fE3HIdqmpfIV87Bw/hOgFdlhntSqX1qQQStWnu4IHHblR/OCozyKqP9CqLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2781
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
b3JkZXIgdG8gd29yayBwcm9wZXJseSBhbGwgdGhlIHF1ZXVlcyBvZiB0aGUgZGV2aWNlIG11c3Qg
YmUgZmlsbGVkICh0aGUKZGV2aWNlIGNob29zZXMgaXRzZWxmIHRoZSBxdWV1ZSB0byB1c2UgZGVw
ZW5kaW5nIG9mIEFDIHBhcmFtZXRlcnMgYW5kCm90aGVyIHRoaW5ncykuIEl0IGlzIHRoZSBqb2Ig
b2Ygd2Z4X3R4X3F1ZXVlc19nZXRfc2tiKCkgdG8gY2hvb3NlIHdoaWNoCnF1ZXVlIG11c3QgYmUg
ZmlsbGVkLiBIb3dldmVyLCB0aGUgc29ydGluZyBhbGdvcml0aG0gd2FzIGludmVydGVkLCBzbyBp
dApwcmlvcml0aXplZCB0aGUgYWxyZWFkeSBmaWxsZWQgcXVldWUhIENvbnNlcXVlbnRseSwgdGhl
IEFDIHByaW9yaXRpZXMgd2FzCmJhZGx5IGJyb2tlbi4KCkZpeGVzOiA2YmY0MThjNTBmOThhICgi
c3RhZ2luZzogd2Z4OiBjaGFuZ2UgdGhlIHdheSB0byBjaG9vc2UgZnJhbWUgdG8gc2VuZCIpClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAyICstCiAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggMzI0
OGVjZWZkYTU2NC4uNzVkZjRhY2EyOWFjMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpAQCAtMjQ2LDcgKzI0
Niw3IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqd2Z4X3R4X3F1ZXVlc19nZXRfc2tiKHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2KQogCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgaSsr
KSB7CiAJCXNvcnRlZF9xdWV1ZXNbaV0gPSAmd2Rldi0+dHhfcXVldWVbaV07CiAJCWZvciAoaiA9
IGk7IGogPiAwOyBqLS0pCi0JCQlpZiAoYXRvbWljX3JlYWQoJnNvcnRlZF9xdWV1ZXNbal0tPnBl
bmRpbmdfZnJhbWVzKSA+CisJCQlpZiAoYXRvbWljX3JlYWQoJnNvcnRlZF9xdWV1ZXNbal0tPnBl
bmRpbmdfZnJhbWVzKSA8CiAJCQkgICAgYXRvbWljX3JlYWQoJnNvcnRlZF9xdWV1ZXNbaiAtIDFd
LT5wZW5kaW5nX2ZyYW1lcykpCiAJCQkJc3dhcChzb3J0ZWRfcXVldWVzW2ogLSAxXSwgc29ydGVk
X3F1ZXVlc1tqXSk7CiAJfQotLSAKMi4yNi4yCgo=
