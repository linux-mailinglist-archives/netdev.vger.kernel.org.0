Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA62514C9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgHYI7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:34 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729625AbgHYI70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P133iMKGyBAAGSzjVKpJWuNJfRNlnUCZzxCZr50dqmBuJjVylxhKP6U51OLf2uEqkvNngGQUv0PvbZ3MTgKx/wjsYg7KD0qJH5GwtUlTaGIErqLkos0JcPPpMBi36SfR8eHrYV/0k4MSdB82cJ4cM8f99keKqYfOwyhsZyQiTn+dBvpWS5LwTSwWVhdDm+kvSQrgoMkJtjRjhji3NOG1aa3IDXEIj6ON0CpM26sAGyFBd0NONBmcfS8L/zu7U3RY6qQOx5mwwS8Q/NP9XFrvV7grdLOORDjqDQYWawhp3crSP+VOQdumAIPmTGXdCuY3cVWMistnnEP7fx7OMsQfKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ak4CIZP3dcXMGBZZ3ut14GrlVvZym3fnk37czMeMAyQ=;
 b=L2I793BUaPgLE6TlK32IlhUVc/3WuooDAvMUYdAxzl+NLaIBvlMOaDDxVXN1OYdjHWHlNdmPRFy5Hw2i/gApRsCsXcVHL/kZYR0AH24Ig+1TEpz4RCdvUu8tcLabWxTECmprBfaZixVJYl2mXJXd5kifcr9iPb3wtSzuobEy6Q467VAtheAF2M9zk0fPZaGZHbHk361fs8uTJmFmOO220nGeDlVPqBDfi3aRyaNqqC+gOXXnU6fLIUDpcmHKkgYP1h8OnFrYnXcNehvTDOYpPvm4SnFfyT0jdAcoDc6CGHKVf/c0d6PPftA3q8W2nD78X3m8Nnn77ArsQ9bg4Mz2tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ak4CIZP3dcXMGBZZ3ut14GrlVvZym3fnk37czMeMAyQ=;
 b=Q5Ta75IgwuVQ+ggtrjFMPnCf9lmCTqSrAOq3M89X/9dy8c6KpdCk2qvr0Ppl3W/kYAjZA2lfhrmdGgarrSRUsCPejhyjR0yKi0qEwmCYGZRsJNSDJJx9UE9kYqg5AsJGbUX1P95cD0oYfV5JkfCez/L8lgwx5pzQU38lUzU6P6c=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:05 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:05 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 07/12] staging: wfx: fix frame reordering
Date:   Tue, 25 Aug 2020 10:58:23 +0200
Message-Id: <20200825085828.399505-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
References: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:03 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 685e85d7-6b4e-4dff-a041-08d848d51e67
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501A1E388C5451A4A7A034193570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5grI8A8nErTT8v+2rGva5D4u9oNlxTz1oH52QZzsMZSWEodEnAMPx7NKkzgtmGy1Um7U/QfLTPcE1xAHWhgRqMU162dgqTtQ4ptBExC50KyLFmo33WQvui+TbUwbxe7na1z0NcSAx8ert+nSrEFdmqqE70ZFOoKp5zeogv533Di2GdCRpxRMp/mc6CcPrdiBKb9fM9B8cYEnCHC6soBeYqwFK3gbqIC0lr9Mj6ULs9XO1DjUE+eonVfgNS1I1JOBcumcT+9YLSkyehibV50xSVwiXcL/8/0wFr5KLHloY58vraFJC87ly5YrVTKK+QYE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HEX90+GxvWi+q6E3CLX7aTrARVmx4U2sZHF/2NaorXVCZ1GYfqq6Qo4ShLt5grKwtVHzePvL0GlXFKq/L2eUTJoIL0iayXWH/MwoygtVtdrgzUdKbQDQuT+iRcMwSeoraX8I2n3wwYapar5QVpeVj+n7ECvoTt+Bvtll3YC8ge+MLCJqAgSQT5J3avW4uwhUL03FH9Z6oS4GgvCF+jK1XPcL6bRNkosW+CVGJQshEzad8uXTtM5iH4CAz/iKTak8b8efyEWKxZwKiUDZ4NePa0ia+QH2g6WsbRM1gepGGbpt3RVlax9FV7LPhb9DEO5QvUlFXLSQHqaPmy4iyt8KRU4/ej3mH6VmnG9nKwqTxEqD8tsJ/DxchJux/hx+rZ8sQD84uvU4bthSrMHawR30jvETWrlCTWmNW8OrVOY8pk06f3UyEgxIXrnF76n+SjKyASUi56x1XbVbcBtOIhStID63cv42wJf3v+qjPQBrw1wk/MwLJG8mvYgPhJGS/vAHShpyg5TuiujrpYI9VLiByIrLKIrk9y3QL0L7+Xg06RUQt/DXYnF2G76D57/2zyLNW73aH1CebGQNT90xRqERvJG0+sfDLUIIQ+qYAHa1lhnw5j5udqvlKSYBjjQZA1lwJtLIed/jTTGUuvxOKttpPw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685e85d7-6b4e-4dff-a041-08d848d51e67
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:05.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWY9Cj0sDgrWvz1gNnX5P08csWHUAvZVnz0j+wPWzIZoiWwe6XYFZOGpvo/Fcjx8A8gl4DjY9CBrR/XsPVMOYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
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
YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAyYjg0OGI4
OTg1ZGYuLjdhNGM5ZjYzYzRhMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02ODAsMTUgKzY4MCwxNiBAQCBp
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
