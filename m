Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96141B10E4
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgDTQDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:03:36 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:42592
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgDTQDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5hn2jbGsYFGA3GfgMunN3MbtdY6yZOIo4nJxA6lVi+wWYZuU6ku3ncv0IkIY7JHs43UFjho7Sjip/fol51AEIQsvzd/HE4T07OVceJjU4IsihdEHyCypfc4g4ilKNFZFZ+lnPYFzXS02Vu1pne51JhUQwHOLPwhp7/0/7ncjGs3PKr9s0xkI50FlI+wXk3T9/iV8MuEd/iFvoNYeVvNRC52pKo0c7cOiMXolvKt31+OM/CYEPFDFDYZ7dtnKdvCUOfK2iBmEt5VK4gy5WM8GyopZP+wV3qhengfx4MSF1op/HIidkrlPeFjJf0hCAljluyKAQaCTNjn24AK1/K4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqA2+f9GFYHXZ6NB4wvy/DWJvlpjT/1XaQfi0f585U8=;
 b=FCK0D+uokm+2ynXe+plJW7ccvn226tsD5G/Qfrh0zMGUJCPFUC6HLRejuFqPsU8GomK62Bu3q/24HRGDINUX7IW9/j4XwVbK/kUfT8r246a+3R0nzSQ5/KDNtDy7mu4bE8k7JlLySMtvulPUiED2NgUe1vqtvcdz15NIwG/U0TidHU5KN17rlKIZGF0zzmnlsVPDeBKNHYNlldOftqeXpVB8y19rVIutsqhGkh0mcc3gK3IuZ8esL+CqfPy+u17W+g3TqbIdSSb8l24WXfk1izl8wBl+vy1KO15ouoPwP34qERkNUWae4VOFi8BR2AIHBYGPkiYrZZChFcbqJFgL8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqA2+f9GFYHXZ6NB4wvy/DWJvlpjT/1XaQfi0f585U8=;
 b=EiLCaAQKQvm4EpVBW8n8ETQtzThFClP1kBOTXVa4b1GhX0fu43M3jQfShkRuS3fw+fO8EcErsm48CvF/kezR9gvYbZt8pPot5z/sSVaJYQ5Q571q/DR0oPMIP7yXlt+LyWW9Wp0JPGvrTpgB+8HbOu5rZLY5QcCsQ98vDj4CaCw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:03:29 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:29 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/16] staging: wfx: simplify the check if the the device is associated
Date:   Mon, 20 Apr 2020 18:02:56 +0200
Message-Id: <20200420160311.57323-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:27 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4030c4f4-1cc3-4dae-cf7d-08d7e5445df1
X-MS-TrafficTypeDiagnostic: MWHPR11MB1792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17926B816D89860C99AE7EE993D40@MWHPR11MB1792.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(346002)(376002)(366004)(396003)(136003)(66476007)(66556008)(186003)(66946007)(4326008)(86362001)(4744005)(16526019)(107886003)(6666004)(81156014)(7696005)(478600001)(52116002)(8676002)(66574012)(54906003)(316002)(6486002)(1076003)(2616005)(36756003)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gQx9ZADTHbuufVVxdN+TTFrWcX9MHzHkGdiQwc8LcLz0SRvKXN6uzZxu8seIl7TkweuA+RmREV669CsmuY/xW5lBH2NHwQoIxyAozPGddVLZTQK2nR8hGiqXJxf2F0oz49eFMEwVKaYQaJy0XAsb5YIU9INNf21f6DHq5fcVHTiLf5CdEhXySC1v2K37pFKbXyonkgUfECzChvEeSwvLVpHAUFuOTK5afYTz7Z6hc4EIjHdjGKzZswzf790v3omII1af84StaHDPvY3klNzy73MBVX+3dgi/UDX2iUbidgNXlBr67YzEQyJ7T4k66Y9UhWPE7n/vLySaN3Jr8bht+HNabNBH0e9BAaWyFTgyew46aZQMyuhA9YX857X50V1ztyaeP+4xSv1sy6KvfaKf6NKpGm2gNIx5XRunsKyrfGaa3fqvZmHVcBMg0An6a3n
X-MS-Exchange-AntiSpam-MessageData: fiW+nvO5MgzdbzKNm8nUnyrqU13qLCLE7ZWfUqkPuh+a1JacSAlzun/UTrMLkNtO0kHXImSGjtgljwgIF0SKv4dyvZnK5yIvPHp+ddld0/vkK3b/HXgWTnwagGylc+fFNipdmjAimdcABGaHE+W0eHnIAp8s5ilI+yPxn1CxV6Z5YOhhEnqCc1IMsRnSsSW9kl6dGtCN29NsrvuNVba1g1uc2onEarzHqeX+zV1+o580yPrMVjGS59l8i/iv27vbVXZ/9ezZK612oEX1Da64fzLVvuFBZ53q8thtFvfteWODZ2kR/xTOGApsefPsr2qLYnAVzVMzzmtqacST6kFpXBNIPNhtfxp9Bd4ZxYQFOa2AIei9UYlzrVoRUq4N5vgok1rgPz28aM+m22zVUfn1zCzPIYFdSG3KLLsGPjTbfjTAQPXxbw3sd4ZIr8Evb44kyY2YRwzHTSSjET7k8DzWZw4cL6tnf4H4awtMp2BOZxPdJsmOnK7IXSa1ABuym+F/MsGUkcjJinarBde7MyL/CjHARhkxzjqpisgzQjvOYEQU2x0u/+HURi36tEPqTOnWfVhumR0E6m0D8MBxzEJ9j9HQMy0wenIub1UmyivWb9YPSTUWW6DZUPeHD/e4/C8WXwOU9o5vPKZtzuYvPNkqrPlzeRseEHkPAFr4hMtb0qYd29mVFM+/7NurHn70omvW/q9SlGHXj2Dw+bHVszMElqQqvCJPkQjRJH9QhCNs17zpmMkpm4UMA8RtePOofgU8S2rFQ9+T+s57cPybXXUEmnZCI1RSskv8H+n8euRNpbRw3AOeXg9PqYuLTcl7y4wjkRwAfwH/XJaxYtspzEtcjTUYTlKJX+/zV46qpaWpL80=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4030c4f4-1cc3-4dae-cf7d-08d7e5445df1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:29.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6K8a9RZGnsM7KtoivQtB6DNHlCBQXzEuEhjDhCXx1+NJYDXeaInlLwI76GdJureZRs+blPqT++gGU1TiJf2Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmly
bXdhcmUgZGlzbGlrZXMgdGhlIGRyaXZlciBlbmFibGVzIFBTIHdoZW4gaXQgaXMgbm90IHlldCBh
c3NvY2lhdGVkLgpUaGUgY3VycmVudCBjaGVjayBmb3IgdGhhdCBjb25kaXRpb24gaXMgbW9yZSBj
b21wbGV4IHRoYW4gbmVjZXNzYXJ5LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIg
PGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYwppbmRleCBjNzNkYmIzYTBkZTguLmMwYzNlYjk0NTk2NyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CkBAIC0yNjMsNyArMjYzLDcgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3Znhf
dmlmICp3dmlmKQogCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbjAgPSBOVUxMLCAqY2hh
bjEgPSBOVUxMOwogCiAJV0FSTl9PTihjb25mLT5keW5hbWljX3BzX3RpbWVvdXQgPCAwKTsKLQlp
ZiAod3ZpZi0+c3RhdGUgIT0gV0ZYX1NUQVRFX1NUQSB8fCAhd3ZpZi0+YnNzX3BhcmFtcy5haWQp
CisJaWYgKCF3dmlmLT52aWYtPmJzc19jb25mLmFzc29jKQogCQlyZXR1cm4gMDsKIAlpZiAoIXBz
KQogCQlwc190aW1lb3V0ID0gMDsKLS0gCjIuMjYuMQoK
