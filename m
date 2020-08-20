Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897DB24C2CB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgHTQAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:00:23 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:36576
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729530AbgHTQAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:00:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvE0E/j9ccyezFe4cyujVUKLipwms4n0YJ+4K+q9JJJvqaRuUY3ZR2T6QPvDGoFoXGIxDxvDo1gzDXzVHIUSnd421pp0c9TEZtw2PvyG5B5us3Lmt3KrJAmv0J32axFrzJbIAWM9Lsc/SofhjnP6r5IhbzHVgSugt/WFNPb5b1bO8M7MbXzACdbcMGe1zGk6NgGi494CtU5IG2YEp1e4WdAaGJdhqnIiZipqrowfaonxZJ8X+cKMb8ZoDSU/Ec2f7dXDq0VRGnmEQkItCVi3stK5AYeyBvb8MqKjfjsCjJrZJTEqAn+tIIDlqZ8EWVCQpKXfiOd+xmzaOoAbMvek9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8gYD71gy7M3i6aldIw6atZ5i4c/cPN6j8VNbcXEVXE=;
 b=ikK5GLsjo1oX9iYugjGAUIeLIzn8w05/cnOZwsaBlOn57CtmGdVAvYOSNMZTKcl2tx7EnXYx3Jk+kG9pckx+Bmg8BpkYGfHfqvZa+kcApZMXAe+zI8/fFw3qfIpfbL5fSgMx8b4FMmyAdvFO5xak/I2NI2OrYIIaY30hGsGCAFVGbbSUZ1ClgqW79bU8XOefgQ027ankPEWUhrGst9NdY4uB6mDBINXtDZkg2Ylms0wTFNnFWq/DrV9+QENobf1AXuKCE+S60+uN4c59TducLPKLPwztgxfdBSn6EwbFD17OodvcNKIpVDf9N+pYLEYtjI45Pah+fz5Loiic3iFROw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8gYD71gy7M3i6aldIw6atZ5i4c/cPN6j8VNbcXEVXE=;
 b=giQ+d6NmbE/2Ii0ngdZ0uZ0tR+4reEvsDb/uxGkiWW/7Fuc4Mi38DhIvPoUvyToDIFxK/ndPJqTVotnv30aJLYij66Ye8tDOsSkuFyN/ZZ2k0h7JdUJwQcgY3K+U9ov5cb5DHSI0BeQu2Y8F8a93GA2lwMblELlrr47V7Ej2yK0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:33 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:33 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/12] staging: wfx: fix frame reordering
Date:   Thu, 20 Aug 2020 17:58:53 +0200
Message-Id: <20200820155858.351292-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:32 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a25de83f-7f8e-4226-0dfa-08d8452207b2
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4541D6428967DA75B5736A78935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRe8xhAh4Yi8PVP7qr0BdQwCK1nPaoCjTIzaW07yNYzFj7+0VJXoTqMFdarEes+rWad25JXWgd8n9U+tQX8cyCgWcVYisw77o+jHl6tmQZ+ee+lD8flXzftXaku/nC9Vj3ux5rtTEETXYcKTgCqxT3GJqC8V207tBkJYhvfVVfMdMVzqo1KXD5zwkthwzNnvzeocslaWUE11r+R/EsVinEB4S32mw+09JmIJY6dPyK5CfHhtvS42ZP8RI4vbzyXgpFe+97RAzu7ZKFAUj7DUHf5hsBdjRKu1CK51M1dwIJJhLnFtPJaEaKK4P8iL4k7vT4gKfOB0n4EdhU252m0w2Fe+0QWiNzNb5SsUaAsniGiYL6TRVMJlzmPf1nYBDS60
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eF9jxYMvXsDS889+XqOzrxJshFXioqgU2S5HvpmShuG+QOyEJVMdCsMuCD+iWRPP/bM3G1FIw5eVHCcCuhBjW6FoKVIPEz7Kh7oB2UJ5cHEdwKrf65Jt/l3JksZF8Qyh8DRkIpNPo9tkl4RdxeM+HoAs6ZW+VUVqrjq4a3qw4nl6WPB6U6aQxmB7fEbcV2ttzwXQDXb2Qu0iZN5UdPgMaYAIw+MO2sE6lHKtsnG5HGAdFa3pEww6ZovAeajkA2a3RuxbPMOIKyhcQ0kUccDqKiPtQeKFtMIite9siUnMJ+ofnbrwuzSRqvHxnC6gsg9aptkUqJE8GflmDEQ4voqG0RC6qbRstgRr3y6FdsifNvaNqfWuGvdrhgaYsNkZdMH4mWMsybepUeuSQ4bF/3q4N4H3US1Uod6VBg7HLyQQaKuxiNMxzYrP4nGNU2Brkblj8s2YAGCaATXtWJhme+/rIbhfdE578VibnvyKyiWK5TYRp8W+ZAh2vgFdprVQH2ft8zJcq0jdPsOduGLEjtVYq2IZd/77T8kOZt8T0kPk07bREgc9elkhenYYDIS8NYyq73hS6+TIMpPKYmSY55MVK6wxutLjQIR8euc93xbv66oKMI0t+AeMYeAiOgb33Y5oVlm0ooi6zAf7GaWb3rzXAg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25de83f-7f8e-4226-0dfa-08d8452207b2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:33.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BxTVTuw0j9NjkRRrV4m/9wO4+08I5qBYk8G58UZSiMPArF/5gxvlhQYv7M230TALQLNEnEJwuPbhN0tApJWc9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBtYWM4MDIxMSBkZWJ1ZyBpcyBlbmFibGVkLCB0aGUgdHJhY2UgYmVsb3cgYXBwZWFyczoKCiAg
ICBbNjA3NDQuMzQwMDM3XSB3bGFuMDogUnggQS1NUERVIHJlcXVlc3Qgb24gYWE6YmI6Y2M6OTc6
NjA6MjQgdGlkIDAgcmVzdWx0IC01MjQKClRoaXMgaW1wbHkgdGhhdCBfX19pZWVlODAyMTFfc3Rh
cnRfcnhfYmFfc2Vzc2lvbiB3aWxsIHByZW1hdHVyZWx5IGV4aXQKYW5kIGZyYW1lIHJlb3JkZXJp
bmcgd29uJ3QgYmUgZW5hYmxlZC4KCkZpeGVzOiBlNWRhNWZiZDc3NDExICgic3RhZ2luZzogd2Z4
OiBmaXggQ0NNUC9US0lQIHJlcGxheSBwcm90ZWN0aW9uIikKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgfCAxOSArKysrKysrKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MTAgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAyMGRiNGJi
ZGQ5MDEuLmIxOGEwYjYxYjdjMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02NzQsMTUgKzY3NCwxNiBAQCBp
bnQgd2Z4X2FtcGR1X2FjdGlvbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJICAgICBzdHJ1
Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCQkgICAgIHN0cnVjdCBpZWVlODAyMTFfYW1wZHVfcGFy
YW1zICpwYXJhbXMpCiB7Ci0JLyogQWdncmVnYXRpb24gaXMgaW1wbGVtZW50ZWQgZnVsbHkgaW4g
ZmlybXdhcmUsCi0JICogaW5jbHVkaW5nIGJsb2NrIGFjayBuZWdvdGlhdGlvbi4gRG8gbm90IGFs
bG93Ci0JICogbWFjODAyMTEgc3RhY2sgdG8gZG8gYW55dGhpbmc6IGl0IGludGVyZmVyZXMgd2l0
aAotCSAqIHRoZSBmaXJtd2FyZS4KLQkgKi8KLQotCS8qIE5vdGUgdGhhdCB3ZSBzdGlsbCBuZWVk
IHRoaXMgZnVuY3Rpb24gc3R1YmJlZC4gKi8KLQotCXJldHVybiAtRU5PVFNVUFA7CisJLy8gQWdn
cmVnYXRpb24gaXMgaW1wbGVtZW50ZWQgZnVsbHkgaW4gZmlybXdhcmUKKwlzd2l0Y2ggKHBhcmFt
cy0+YWN0aW9uKSB7CisJY2FzZSBJRUVFODAyMTFfQU1QRFVfUlhfU1RBUlQ6CisJY2FzZSBJRUVF
ODAyMTFfQU1QRFVfUlhfU1RPUDoKKwkJLy8gSnVzdCBhY2tub3dsZWRnZSBpdCB0byBlbmFibGUg
ZnJhbWUgcmUtb3JkZXJpbmcKKwkJcmV0dXJuIDA7CisJZGVmYXVsdDoKKwkJLy8gTGVhdmUgdGhl
IGZpcm13YXJlIGRvaW5nIGl0cyBidXNpbmVzcyBmb3IgdHggYWdncmVnYXRpb24KKwkJcmV0dXJu
IC1FTk9UU1VQUDsKKwl9CiB9CiAKIGludCB3ZnhfYWRkX2NoYW5jdHgoc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsCi0tIAoyLjI4LjAKCg==
