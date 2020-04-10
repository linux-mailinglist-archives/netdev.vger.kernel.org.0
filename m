Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901CD1A46E3
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDJNd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:57 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:6130
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726953AbgDJNdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU6rCrCKygu/5TAzGYa1CD8iqOvXC49k2UZkCETmgXqNGnI5XhEnUfZizCf4gpm2cOehFwgjAxjRGNZBi6qrsn0ZbpOsHMx+enimYCsDM17Vt+vNbTOUPaxys4QR0+F3X4FuinHFL7d4HJuHItN/L9abex1gxbma4JZVqmPD0TQzZyZiWrYFwo2DQu+tgDb8eyOSFNWHC702hb8W/xAShA0+xBUgydyxbACbAXwu1P5h1uKClUVr1XxH+YXUW1AmLke1nGq1kEuUpZe5+CpPNeBKV/lQ9wtTvHUgMDy8o+HvX7nUCgLbOTro8l9jmTz87MxD9w9ThkKuevNAYYeqfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1WN53AH335kYeRtxLb+77TvAaP2Hkl2lY88WHoq8+M=;
 b=KDa/9hN2z2LXKypPNbzyYEG8qddom1mxWz7ro7Wt3HAtQFquQEwOkW4PxcviuD5Le6AFbom3hSHFDxbveHlq7kEt37vPgcScZyodXqUsDRuwPd5jWBJsC8VlQtli49iaVYZcSoMgNPo/AlKKbPR3c+pqFrjSNxkY3mBUm5znC3JptpOY9DOAdjz8nH1J6a7Nc/UJzYqFlGJ1XbFp33kRIXVd3SPr1DCDAn9nkJh+RTCE2/YkTgGDfk+ufgTe2Z83o20/i42Bsoj1a3zWEiNbFfiW/3mXe6hxgVf8Knb75nwcPHGbhiEQeGeCXeHecJ116VbBNLkh7KV/XcSKi5k/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1WN53AH335kYeRtxLb+77TvAaP2Hkl2lY88WHoq8+M=;
 b=HcpVaOGiCp/v704OE5Dn4nqj5tFub+l57pNU6UnBMFXMEAZPZz+HzxxcZma1e477uyyTVHsZ76eVQxYe+TcdAg6x5ZRWCoI9s6P1LcfIhfUd9+JWU8QIJx58lBCTDF8/D2QoyghYKl3b+2nuYHCTZLbDHNPgizRhUtSWgnIj4SE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:31 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:31 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 17/19] staging: wfx: check value of beacon_int
Date:   Fri, 10 Apr 2020 15:32:37 +0200
Message-Id: <20200410133239.438347-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1055b76-ca35-4992-c4f8-08d7dd53c269
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43982E597811C8D05377AB0293DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJur2XXEvFQuxt0Yv13icWotaVeMJ1ixRpCLNvyU+ZxYgeN3AKTLYWbOHbYffy4SEtCoPSLthahBCJS9O+7jvphlA/p3s4aHFVQHfQCjzMTJpplgKUmrc5PPHFFpLMCREEO3wKba/lDndFUNvYwvdZStyXTE/SwtGmg5VDCFUZQYgSubWqT+CsEUpnyxhYJdGLTa6oNVhE8CqfEv9z4eVYhXzjrZF7MB7ubuis3vi+8+1jc5nBd68LPXd9A2wowcvStADkKqHXS6DW9+fGPyYB6Uv2WrANhRTCIQqk9buuFhzmFKpv7RyD1HF5+VqqDO/7c6W/oxwudRI/GzR1XKggoyA5DxmPBVNczZYn2ZkhM7lLAEDnYUWu/ft/BgLUZ67jqq7YzgCNqJz8Q2makFomaTrp0ni22RTNYuHkEHghFnw/f2EpC+BAnVDl7u5KnZ
X-MS-Exchange-AntiSpam-MessageData: sAvH7PhvHNVpCeTTQTEDJ8ScsadwreLBWX+PE1qox2c7kM4GTTBf8i3Fmyq6YdEeCBVIBollM6mKb9dNojP9SHzAIyN5I5Zoqfmws1v2sR/dpetGz7ceW91n7MyPELy28wkXXUNArlLgzpRcyq0HmeEFx/mGt5x+fH3AMRRe1S6QAygDWJiKq10rJQslir3W3f4FbsVgE2okOhz7E4f4lQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1055b76-ca35-4992-c4f8-08d7dd53c269
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:31.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZAB+ltIwXCe0PPysfEYfMRQ/n9f8Uf0o/FyogzWyXbwZmucujqYzGVW1W41b+/oYjilFD10Pd1saMrxY7hiIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmly
bXdhcmUgZGlzbGlrZSB3aGVuIGJlYWNvbl9pbnQgdmFsdWUgaXMgMC4gVGhpcyBwYXRjaCBhZGQg
c29tZQp3YXJuaW5ncyBpbiBjYXNlIGl0IHdvdWxkIGhhcHBlbi4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IGQ0NGU1Y2FjYmJjZS4uZjQ5YWI2N2UxYTZkIDEw
MDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4LmMKQEAgLTI5Niw2ICsyOTYsNyBAQCBpbnQgaGlmX2pvaW4oc3RydWN0
IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJ
c3RydWN0IGhpZl9tc2cgKmhpZjsKIAlzdHJ1Y3QgaGlmX3JlcV9qb2luICpib2R5ID0gd2Z4X2Fs
bG9jX2hpZihzaXplb2YoKmJvZHkpLCAmaGlmKTsKIAorCVdBUk5fT04oIWNvbmYtPmJlYWNvbl9p
bnQpOwogCVdBUk5fT04oIWNvbmYtPmJhc2ljX3JhdGVzKTsKIAlXQVJOX09OKHNpemVvZihib2R5
LT5zc2lkKSA8IHNzaWRsZW4pOwogCVdBUk4oIWNvbmYtPmlic3Nfam9pbmVkICYmICFzc2lkbGVu
LCAiam9pbmluZyBhbiB1bmtub3duIEJTUyIpOwpAQCAtNDMwLDYgKzQzMSw3IEBAIGludCBoaWZf
c3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2Nv
bmYgKmNvbmYsCiAJc3RydWN0IGhpZl9tc2cgKmhpZjsKIAlzdHJ1Y3QgaGlmX3JlcV9zdGFydCAq
Ym9keSA9IHdmeF9hbGxvY19oaWYoc2l6ZW9mKCpib2R5KSwgJmhpZik7CiAKKwlXQVJOX09OKCFj
b25mLT5iZWFjb25faW50KTsKIAlib2R5LT5kdGltX3BlcmlvZCA9IGNvbmYtPmR0aW1fcGVyaW9k
OwogCWJvZHktPnNob3J0X3ByZWFtYmxlID0gY29uZi0+dXNlX3Nob3J0X3ByZWFtYmxlOwogCWJv
ZHktPmNoYW5uZWxfbnVtYmVyID0gY3B1X3RvX2xlMTYoY2hhbm5lbC0+aHdfdmFsdWUpOwotLSAK
Mi4yNS4xCgo=
