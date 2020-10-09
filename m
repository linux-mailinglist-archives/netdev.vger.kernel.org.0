Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0608A288FBC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbgJIRNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:45 -0400
Received: from mail-eopbgr750058.outbound.protection.outlook.com ([40.107.75.58]:34017
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732874AbgJIRNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGVMiVl94j2vVEPE0rHXZT3SfMNjDUvh3aqi8n3zSieryTRxtD/Lf5mYVtb1SxygoY8M/TL1PkI41mjqGUpNESNpk8+ggFeZwjd3fuirXNt3n3o2FvfxcEBYdWlaSEA0Ax1G12PageeKOHJLrinGVXJw0QRIvBpReUWt6XPTPSHVrQyNY7IslJ7zHm3gdTHMt7Cjvy9J12G60fj2wL0TJHELqw9mM1fjr+k++NaxCo26o1Zq1BiHqoZRbgHLl65Rp+Y4luImmHCyergZIIhgDAR4be1YLoYMnwThDqw0k5G0lSyg2P2I5zot3RzIxLaS5KTjWQGfPEDEpaUp6tpmQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9C+nIAJ1Ffqm1I50uRTHzLfaztPt1wHruwY6oFnFbU=;
 b=gCizNDo5XlrFE5cZzion8KADijIt/Cd+ZKUoAUv+u6CJF9YTfJQ3ly9LDQlC/fxtahrZan7CpSqTgBLBg6rkU+Qevet+3n2WCbBg8P1p/wg4+Ypzy7fOu67x2BwFS/AYoJr+3AupTa0/j3Z7qDIqgmF8JIxUnfKomDURfOWEg7W4vmruH93j6uEL1Mk+diYrLVXkcixyPhjC+bH96zO2SwP8w4pTenTK/voPUFABr4jFkTx29ImsbhkOreX5Vnhbv3V+/IJcFmGtpsFSIMZ5gAIQY/p24ENiTmRUY5L/fGA7Q7Gi/yInGqzyKgOrA+Gm4qa8W9pVRInkGBANuO4fhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9C+nIAJ1Ffqm1I50uRTHzLfaztPt1wHruwY6oFnFbU=;
 b=CiuKDi6Rbtb4mGhXUD6tfzecpNVHaZnReeZCO6JuYOWsb996IBH9A9kkKkmlIWWoiEqE9bzvdcCSXRHF1okCrjQvBXRdi6I/FOFtdL34UGDB5BmwUYvKfuiQo5kQORTYruJwC+odCeEAgEM8xf4l5ZBRISdOQ4L/Qy4TKgRMAEQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3087.namprd11.prod.outlook.com (2603:10b6:805:d3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 9 Oct
 2020 17:13:37 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:37 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 8/8] staging: wfx: improve robustness of wfx_get_hw_rate()
Date:   Fri,  9 Oct 2020 19:13:07 +0200
Message-Id: <20201009171307.864608-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b1fcbf6-7a09-401e-3028-08d86c76a948
X-MS-TrafficTypeDiagnostic: SN6PR11MB3087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB30878B6ACC4811FDA34D469B93080@SN6PR11MB3087.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCzwWUKBOo+OzGc81x211GCOlkiUqy4bb9mX+dN7HA66AiI8BudLbrJwaaCv8/u+xvNYCkRSWI93Mc3fDBJ/x/gkBuVzuBC0TB2BTUsLgQFz9uoe8i/TGy0gcKjOHGKLDnej8Z3p8YWfhNSmKUo6/PcK6dyHVPvDzlPZ/W3Me+ZcTSHsF2oA2N650WFoGjBUgXgECKPWdN6IqADRfPyEMTIaz636UE9egvAAZUbRPeOD1NvCzUSmm12Ntbw4Ujea/xafPChNRDKw3ELpWcrGICqQsPwP6qK2uwdDpxUukBirwzf1uWn2ydEqEPfSAXUB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(136003)(376002)(346002)(366004)(7696005)(1076003)(2616005)(66476007)(36756003)(66556008)(956004)(478600001)(2906002)(6666004)(5660300002)(54906003)(316002)(6486002)(4326008)(86362001)(8676002)(66946007)(8936002)(52116002)(107886003)(186003)(26005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: A9DOVVcnwFEVj6Wt2IkdU5ZywAmdTQOCDrcQTGyo0/xcBdwCv9WFpSLV/FD3HabQoIkL71v8V121V8EciSYoqcXljkE6IYr7VssYaM/U4MPJfAhYLgg+yErTUgkmIsRoLiQMTneClD07DtECs5y3dPuvv/o6A3QtaIKYCXun/PlrlZyadZcBT4GyjsFjq87Pdm/N2ZZbc9i4q2KDTaN8ejDRZ38ZQWmcFeKPsB0yS14DJbHMmrgZx0MD22eiJiXECIoZit99RgDGytEuyW4F6HewHTzbkhWt6AoTLHIPFDIW+XIuvz8jboqpAnOKmoAxu1bnXXZAn9cqunNoavTKseitm3DGifBvt5Zf+gdP9guMMqP83DSxu7/HgcjDesPVKxPCfreue02tlWeEUaG5OIy11YdLEges+YYQOKXelupbrfT7Uw2BYxcntznymkbLeDU8uEIZkn8+y2vIHiOoPRqb4nr23nLObJmo1UEMuCPetcDXegOGhB5HNVbRIB0UtP4rldNpAif0Qc6afhJTtKeA+IeDSsezt+9x2d+4W6w2CEC4Hss9tWxdjFh8LTCKbZkUlAhL4LEiMKVL9UGw7Ajpix3yGAVbtJ4EkJp3RdNQruQCKEoRqY4QlMdajr9Ee2W6Fo3WH8gQ3/sftSaqzw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1fcbf6-7a09-401e-3028-08d86c76a948
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:37.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQ8E02dQnRBJg0JTHjA3zezDx0UH542T1w0y7XZCnEY8stl0JhKxjeAXwur66hoktJlov+yjvFCG9lF8AMmleg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgICBkYXRhX3R4LmM6Mzcgd2Z4X2dldF9od19yYXRlKCkgd2Fybjog
Y29uc3RyYWludCAnKHN0cnVjdCBpZWVlODAyMTFfc3VwcG9ydGVkX2JhbmQpLT5iaXRyYXRlcycg
b3ZlcmZsb3cgJ2JhbmQtPmJpdHJhdGVzJyAwIDw9IGFic19ybCAnMC0xMjcnIHVzZXJfcmwgJycg
cmVxdWlyZWQgPSAnKHN0cnVjdCBpZWVlODAyMTFfc3VwcG9ydGVkX2JhbmQpLT5uX2JpdHJhdGVz
JwogICAgMjMgICAgICAgICAgc3RydWN0IGllZWU4MDIxMV9zdXBwb3J0ZWRfYmFuZCAqYmFuZDsK
ICAgIDI0CiAgICAyNSAgICAgICAgICBpZiAocmF0ZS0+aWR4IDwgMCkKICAgIDI2ICAgICAgICAg
ICAgICAgICAgcmV0dXJuIC0xOwogICAgMjcgICAgICAgICAgaWYgKHJhdGUtPmZsYWdzICYgSUVF
RTgwMjExX1RYX1JDX01DUykgewogICAgMjggICAgICAgICAgICAgICAgICBpZiAocmF0ZS0+aWR4
ID4gNykgewogICAgMjkgICAgICAgICAgICAgICAgICAgICAgICAgIFdBUk4oMSwgIndyb25nIHJh
dGUtPmlkeCB2YWx1ZTogJWQiLCByYXRlLT5pZHgpOwogICAgMzAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiAtMTsKICAgIDMxICAgICAgICAgICAgICAgICAgfQogICAgMzIgICAgICAg
ICAgICAgICAgICByZXR1cm4gcmF0ZS0+aWR4ICsgMTQ7CiAgICAzMyAgICAgICAgICB9CiAgICAz
NCAgICAgICAgICAvLyBXRnggb25seSBzdXBwb3J0IDJHSHosIGVsc2UgYmFuZCBpbmZvcm1hdGlv
biBzaG91bGQgYmUgcmV0cmlldmVkCiAgICAzNSAgICAgICAgICAvLyBmcm9tIGllZWU4MDIxMV90
eF9pbmZvCiAgICAzNiAgICAgICAgICBiYW5kID0gd2Rldi0+aHctPndpcGh5LT5iYW5kc1tOTDgw
MjExX0JBTkRfMkdIWl07CiAgICAzNyAgICAgICAgICByZXR1cm4gYmFuZC0+Yml0cmF0ZXNbcmF0
ZS0+aWR4XS5od192YWx1ZTsKCkFkZCBhIHNpbXBsZSBjaGVjayB0byBtYWtlIFNtYXRjaCBoYXBw
eS4KClJlcG9ydGVkLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDQgKysrKwogMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggOGRiMGJl
MDhkYWY4Li40MWY2YTYwNGE2OTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0zMSw2ICszMSwx
MCBAQCBzdGF0aWMgaW50IHdmeF9nZXRfaHdfcmF0ZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJ
fQogCQlyZXR1cm4gcmF0ZS0+aWR4ICsgMTQ7CiAJfQorCWlmIChyYXRlLT5pZHggPj0gYmFuZC0+
bl9iaXRyYXRlcykgeworCQlXQVJOKDEsICJ3cm9uZyByYXRlLT5pZHggdmFsdWU6ICVkIiwgcmF0
ZS0+aWR4KTsKKwkJcmV0dXJuIC0xOworCX0KIAkvLyBXRnggb25seSBzdXBwb3J0IDJHSHosIGVs
c2UgYmFuZCBpbmZvcm1hdGlvbiBzaG91bGQgYmUgcmV0cmlldmVkCiAJLy8gZnJvbSBpZWVlODAy
MTFfdHhfaW5mbwogCWJhbmQgPSB3ZGV2LT5ody0+d2lwaHktPmJhbmRzW05MODAyMTFfQkFORF8y
R0haXTsKLS0gCjIuMjguMAoK
