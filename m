Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2477824C2CC
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgHTQCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:02:00 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:47585
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729565AbgHTQAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:00:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCVDYpD7UgQNykUWi6co5jvdEuWFvebHpsl6ZyMW1ScKp78bnKao0/tvbd3xGhJYtCvrjAYnA0kKvZp6Ey5HuXZlwf8U50CcC7sqfiJXjioQfArr0Ao11hmCS0Vf/7BU0EhvsoF7TynYAK6RLQwM4jxtVaFfvcaNBPioZzb5OPsNGXKdS0dG8K/29Lwpl4z52HBjZ8YRzTqiuW1o393NgYyea3NsOsKyMBWBlqtF0V3RZv81sfsCKKeKy0lOhTEkdVPdfvF5TGkGXw7ouCVfBUTTBxOaMo1Gyh3e7BFZsqUWW/TL/24DVsnHR98uxJMdwBcMUBbpINSvB0YOhHRGHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54rBtP5u0nh32OciXaVgs0skqMaNtbGtASNU92LkxqA=;
 b=UJjFFMlLSrFrPROwf2ubraJ6c99MgxYLYFodAn3PV29z291+pQLp2+lKblJ1vipFKXCHPwnCY7BQ4xD6NmqrTRtNt9/URMTmcXjzRRSydz3nlgA/3aB9t1GXXk++VmI0foiWTjM126lw56nGM6CBwOZRhsVJ988SRsvqiUHNfPDlz00HlMA6v5GFdHGTQ414ff2s3Qd+StGEGaaMq8A2sAsdkTQYYaPlivRWNjkl+9ihuU9qTYybsq4e/gvF25QBjTgEZEE+Vwzy7ibEbZaOCMRz9D1QuSJ5xBnAAK0cNZIyLC9D04PJr3s4hAjoNPcBoPGsHLYjyFfBTCK+AFIiGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54rBtP5u0nh32OciXaVgs0skqMaNtbGtASNU92LkxqA=;
 b=OU/RdnLS0ZP7KK1BJTclR8sV8/ilbj8OGBsMNC5niE+PMkLX7AGY/AcqDuRBqvy9CQbIdK83tYFSqq64lPiW7TdptYnnXbsbbJtBpcsk/X27CIxBmXfcp/BuGtWse25u8In0OyHwIM39LBO/+qLlCexa/NDC1NcsxWbBpfHQ6t8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:38 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/12] staging: wfx: enable powersave on probe
Date:   Thu, 20 Aug 2020 17:58:56 +0200
Message-Id: <20200820155858.351292-10-Jerome.Pouiller@silabs.com>
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
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:36 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb0095dc-721d-4d7e-beff-08d845220a96
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB45413DFD041A30727727CA35935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kicwAWBU7vWPQ/UmPH6HOgqcn6fDF/+f7dU+wqEJCNN6lTFg+6Dbh3Vey0s6reYzfWbgJ1FXbWJsE6bhcPY8mjb22TuGe1cSDqAGXmqml8VNbH9Y5XuWhL2CSygWDhtu8SXHOxFIJxkpm4sEhDy0u6y3HURjZxu5LQl1uAy8ftnZc3ck5CiOl3dN5AVpTtym2ovcmzgq16BllaI61G7T4RBVxogbe+m1xTRea6+hYXk4WXqNJ4Ael623vYSlhfUCagecMrQgcZlxCtHhYhJmaikRqRi2PQB1e1BcRpXjVNW8jvIdFhwhvvK7PY6mLJBWd16r+dI44/9ZEIFSZsRqH1QXDZ/Zr/pp994xD+NOY82fkANQ+ZrPnoDgSDU9ZcFe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(4744005)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M1/hw4xYXdcIWjCEtOTjSmr/ppfwYoG19OMBn8eOkrUWD58N9gztCxRoIvdTry6G9VifsxkjY7/IJ/zPP93uIEvBLPZhPGn1nVGbN5ZlSWTdIpTkhAUyaXmuFnboI5lGxVU9oHVqjhgSh+Dqz9cikcHgP+tJ+iIweCim1dO+c+hBilXmRvZ0YEOrNc2tlv0Qe+Xen/WP3+jyueRQS3SHMCY/BWKlbb45EWJxbDj8CzBIJjqdzQByz2ScEW6sUBW7gRtyrvv/i2vf+3PY9wZeGtp1h60P2PRmvhR6z7AXbWCviRWKvLvUT6NWMhlKjZbZjDtBmlx4inkc0Cn7XYpkw0n95i36PgIyQ42lJ7dfKMuTNcg4aMvk040flOLJHxk2cE0qwN2hxV4Pu+IoaIgnhajRUktrb8Dj0alw7dy+7xnCBz0o76v67rROXbm3AB/ob1LtouRg4LKO7WSDtfB11nx9IYtEfuqV/Uwf9KtnXQ4cRRZSiASkEiuYkn4eM82Pgc/dYIFNnp/c2k4Td7KEmyzLq7n+tDboNQuCsS3fjtqK6sWIrF/rDHM6xKN6SI2zA4i1MOr/iasV3HyPvDIb4DzwQgVvqmhmQxS7ME8AWaHbStyN6VW8+Hhfgt4sRcEZvmKKRwBuOKG/LeQaXcHj0g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0095dc-721d-4d7e-beff-08d845220a96
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:38.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcWGWOU3mWXaUFkEMqOjZsn5KSmK3Q8o1islYDQOLwNsHuN9I69d4DHtuVpfFD+NFGoVqdc7TGsHkdQwlLqokQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIG9sZCBkYXlzLCBpZWVlODAyMTEgcG93ZXJzYXZlIGhhcyBzb21lIGltcGFjdCBvbiB0aGUg
Unggc3BlZWQuClRoZXNlIHByb2JsZW1zIGFyZSBzb2x2ZWQgZm9yIGEgbG9uZyB0aW1lIG5vdy4g
VGhlcmUgaXMgbm8gbW9yZSByZWFzb24KdG8gbm90IGVuYWJsaW5nIGl0LgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9tYWluLmMKaW5kZXggNWEzMDE4ZTE0NDQ1Li41ZTJiODI0OTkwMDQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5jCkBAIC0yODUsNyArMjg1LDYgQEAgc3RydWN0IHdmeF9kZXYgKndmeF9pbml0X2Nv
bW1vbihzdHJ1Y3QgZGV2aWNlICpkZXYsCiAJaHctPndpcGh5LT5mZWF0dXJlcyB8PSBOTDgwMjEx
X0ZFQVRVUkVfQVBfU0NBTjsKIAlody0+d2lwaHktPmZsYWdzIHw9IFdJUEhZX0ZMQUdfQVBfUFJP
QkVfUkVTUF9PRkZMT0FEOwogCWh3LT53aXBoeS0+ZmxhZ3MgfD0gV0lQSFlfRkxBR19BUF9VQVBT
RDsKLQlody0+d2lwaHktPmZsYWdzICY9IH5XSVBIWV9GTEFHX1BTX09OX0JZX0RFRkFVTFQ7CiAJ
aHctPndpcGh5LT5tYXhfYXBfYXNzb2Nfc3RhID0gSElGX0xJTktfSURfTUFYOwogCWh3LT53aXBo
eS0+bWF4X3NjYW5fc3NpZHMgPSAyOwogCWh3LT53aXBoeS0+bWF4X3NjYW5faWVfbGVuID0gSUVF
RTgwMjExX01BWF9EQVRBX0xFTjsKLS0gCjIuMjguMAoK
