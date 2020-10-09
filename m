Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A22288FB0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390057AbgJIRN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:29 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:44295
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732488AbgJIRN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaaes68viLjGdWWeQr/JIwcQeJ4wcAUfje+JwhRwKnXYMWhKJ4TGnOJzWGfYD4UD5xxXWIogHCpdSNVQasTK4OJVQ9Bnj+pt9o8YKwBpqAPxIcQptxkUihm8gkG7RO1E+vIcy6PeA2vEizvsShpSlGQlAKIETr7YdzR8QOlJAIyRcuZeQC/9PoXfDsmuRv1aLgf2f/sHZEpF//FPg66wvvR1nr0DoEw9knaBP0Bhr38SRFGgIPC2wWusejNlUAqAz0DESODsnXBQJk8cf+FH6YcJc8Y7YomrOT8sOL9cp+V6QdzhDPdxLwQymVygMWUM8B4bJtzCmoSBxbpi5KexLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80BDLOHA2/Tyf/HJKSMkGnqFDkkFta57/fObreAjjKs=;
 b=E8dFhBqkTAd5/GA0I07RDq3LwlgQGG5sM7efgQOilZnktOg74jwJzxNZiMa4T4GX8mSS6OHKo00t3QOJmvvTKLGV4KEIx82zXTASLV0dMEvhdsWESD8zX2NVSXICg02PLxHNiaJOgerev6sZeq8WS6Ci6rh4acnxT+z4tpC1M2tTIiN+mCXoW9MSF92SVzvD5V2PNoo4LCACytlJC3DYBwoSH75HtXs9UBoIYdEzZm/PyesTNG2+kz8rf4qPEM9oK7ygX+6Kl482vv95Kh7dQjM5Zhpl3qdvOt8Z+fS8YLK/dS5T6PhKcM/BERfQ/iDmszYY1mUqjCNG93haqWUG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80BDLOHA2/Tyf/HJKSMkGnqFDkkFta57/fObreAjjKs=;
 b=gHjP/gJQxoGz5NYwFNOUqer2JhqMoJR+7vayBGu0FedK2mvnQQkir7c4a1K/04G23Htw4zY4C1xhegGyEflmVn/ygU0GziG2qP+QSY6MvE8lj8+8fCPROFGNnLoGy4BFRrdiSrPs5B0bf6H/EzUsbrXkkVaqFOm61GBiEBPhzGU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 9 Oct
 2020 17:13:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 1/8] staging: wfx: improve error handling of hif_join()
Date:   Fri,  9 Oct 2020 19:13:00 +0200
Message-Id: <20201009171307.864608-2-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8e7d44c-fb61-4be2-c7f7-08d86c76a0fe
X-MS-TrafficTypeDiagnostic: SN6PR11MB3455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB34556BFC81F704164ABA7A0693080@SN6PR11MB3455.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DljSLcqYJ9vUTrTBy7lpPO78v9FoFB846WTGrNYskwrqgmimzfdWAJF+x/uly3pCU4qHlOx0JaoBCndJ1mVsoe13B6VZamDt20k7IkmEdvscy+TuaV1A+bT1P/1aXdXFLgPvXWKBV/1pvOjeDegVT+TbGUMeGzOdc7AHA1DPg3hXgQ+0aKXKUKKC3zAY+cZtfdEt3qkb2DAZyShQogJNrCX3r+SOvcxTM4SXEBJdc9QqJixYC5eCl8Oir+A0cu36qIbc56hPAtXZFDGT1d+IIAx12aVF9UxEorkNkzL0fWr41RxAwvlcHSYiW2KGZ6aQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(396003)(136003)(8936002)(36756003)(54906003)(1076003)(316002)(52116002)(7696005)(2906002)(5660300002)(478600001)(66574015)(86362001)(4326008)(66946007)(66556008)(66476007)(6666004)(107886003)(26005)(16526019)(2616005)(83380400001)(186003)(8676002)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TxFiOzjzxrvzXC9Q7cnECmSHHjmbkCQAAgf5ipkMF/799ayLIMmXP5yLPMa8xBb4yReuLuOiwqEPoz0N3hCREhn4k25ubG6n0un8vys5I3Qngz7WKPko4h6Jzsjy8z2xTzfPNfPudmyh3nUupx13Ia2h7DsSM5oQpBZgiWOx2iKLFdcHUKr1bkM24CsrijgUK1lFHpxpoRzdk8f4f79fOgKb4cDuXiWS3GFhPZ427RUSW9bZIm3ERDl177UPmbqemOMW4OOFe/5sg51389vQdazDRqOJyB/z8xdTSVo9jGzqnsOk+koOwzITQR74yNJnW54FFJ/cz6t1Dwk1O7yV1iD8Qjg5+eXecA9+kuNjAJDwPXZIQHpJ7MYpwKhMV80tv4Gfa/FOuD/VrCtvgZ9weHgmWhEdzK5X5svXn1rQEv2VCqSRkcNEc9Kyr5Aesg/pXRTjjaLlyIgVb+a2qTcQ1YVc6HtDpql+tpaLGyMsY9Y4o6pEwZ6hOXrGxan9Uig8zEqpkKKokxqcHatzxtwhMBAe3cEqyQvr6fAhAQqYIaQd76ucsszf07fUS8AmU0vEreUREttHFathekVgbrYeqHFHqqpBZqQl9+zCms+42+Evaw/m2c3law3gEdZ2u6d+EXXp+3x7TV0cF+6Mp7Qgfw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e7d44c-fb61-4be2-c7f7-08d86c76a0fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:24.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saFzmPS0W9sBG6p2g8qZM4bwqmQQecnT1oVkseS15Bntx+pDPmzykU64fFIkNelslvhoDOJcS/PUEcVwbuCKpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgIGhpZl90eC5jOjMxOSBoaWZfam9pbigpIGVycm9yOiB3ZSBwcmV2
aW91c2x5IGFzc3VtZWQgJ2NoYW5uZWwnIGNvdWxkIGJlIG51bGwgKHNlZSBsaW5lIDMxNSkKICAg
MzExICAgICAgICAgIGlmICghaGlmKQogICAzMTIgICAgICAgICAgICAgICAgICByZXR1cm4gLUVO
T01FTTsKICAgMzEzICAgICAgICAgIGJvZHktPmluZnJhc3RydWN0dXJlX2Jzc19tb2RlID0gIWNv
bmYtPmlic3Nfam9pbmVkOwogICAzMTQgICAgICAgICAgYm9keS0+c2hvcnRfcHJlYW1ibGUgPSBj
b25mLT51c2Vfc2hvcnRfcHJlYW1ibGU7CiAgIDMxNSAgICAgICAgICBpZiAoY2hhbm5lbCAmJiBj
aGFubmVsLT5mbGFncyAmIElFRUU4MDIxMV9DSEFOX05PX0lSKQogICAgICAgICAgICAgICAgICAg
IF5eXl5eXl4KICAgMzE2ICAgICAgICAgICAgICAgICAgYm9keS0+cHJvYmVfZm9yX2pvaW4gPSAw
OwogICAzMTcgICAgICAgICAgZWxzZQogICAzMTggICAgICAgICAgICAgICAgICBib2R5LT5wcm9i
ZV9mb3Jfam9pbiA9IDE7CiAgIDMxOSAgICAgICAgICBib2R5LT5jaGFubmVsX251bWJlciA9IGNo
YW5uZWwtPmh3X3ZhbHVlOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBe
Xl5eXl5eXl5eXl5eXl5eXgogICAzMjAgICAgICAgICAgYm9keS0+YmVhY29uX2ludGVydmFsID0g
Y3B1X3RvX2xlMzIoY29uZi0+YmVhY29uX2ludCk7CiAgIDMyMSAgICAgICAgICBib2R5LT5iYXNp
Y19yYXRlX3NldCA9CgpJbmRlZWQsIGNoYW5uZWwgY2FuJ3QgYmUgTlVMTCAoZWxzZSBJIHdvdWxk
IGhhdmUgc2VlbiBwbGVudHkgb2YgT29vcHMKdGhpcyBwYXN0IHllYXIpLiBUaGlzIHBhdGNoIGV4
cGxpY2l0bHkgY2xhaW1zIHRoaXMgcmVzdHJpY3Rpb24uCgpSZXBvcnRlZC1ieTogRGFuIENhcnBl
bnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguYyB8IDQgKysrLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IGU2MWNjMjQ4Njc2MS4uNjNiNDM3
MjYxZWI3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTMwOCwxMSArMzA4LDEzIEBAIGludCBoaWZf
am9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9ic3NfY29u
ZiAqY29uZiwKIAlXQVJOX09OKCFjb25mLT5iYXNpY19yYXRlcyk7CiAJV0FSTl9PTihzaXplb2Yo
Ym9keS0+c3NpZCkgPCBzc2lkbGVuKTsKIAlXQVJOKCFjb25mLT5pYnNzX2pvaW5lZCAmJiAhc3Np
ZGxlbiwgImpvaW5pbmcgYW4gdW5rbm93biBCU1MiKTsKKwlpZiAoV0FSTl9PTighY2hhbm5lbCkp
CisJCXJldHVybiAtRUlOVkFMOwogCWlmICghaGlmKQogCQlyZXR1cm4gLUVOT01FTTsKIAlib2R5
LT5pbmZyYXN0cnVjdHVyZV9ic3NfbW9kZSA9ICFjb25mLT5pYnNzX2pvaW5lZDsKIAlib2R5LT5z
aG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZTsKLQlpZiAoY2hhbm5lbCAm
JiBjaGFubmVsLT5mbGFncyAmIElFRUU4MDIxMV9DSEFOX05PX0lSKQorCWlmIChjaGFubmVsLT5m
bGFncyAmIElFRUU4MDIxMV9DSEFOX05PX0lSKQogCQlib2R5LT5wcm9iZV9mb3Jfam9pbiA9IDA7
CiAJZWxzZQogCQlib2R5LT5wcm9iZV9mb3Jfam9pbiA9IDE7Ci0tIAoyLjI4LjAKCg==
