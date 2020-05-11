Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9461CDFA3
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbgEKPvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:51:01 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730663AbgEKPuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECuuyz3q45KNqG8mrgE42LV4lb1qEN0CZL74vIBuLroCVYs9BNjIJoBaqZRYO6tN1q6nGqznZDVLBPyNoCFVAdTKmqXn0u2PD81viRK0kR5rjzyccPfys1u4KC1q8L57tK0kNLFv6RxZZDtKDK5PcG2Bsw22voGyuwSbsW1/sHDTqUAMwaZhu24StSW29kvdUo0ueNi8086+3WJELkgY0gJENJkNYkRUL8yvaDpC2uDtjtU+GG6VHOGIZxat9N7FdauCAD3RWXA+LvPmZLxhgzPJM6JXxYb94/DGkjYqZsge3NBI5iRLuguwHM91svJgwH30TzgQEjsS9Oy24n5VYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQUEM5ca7coakQv72bsNt+k61HBZZbFyi6u61Mxubf8=;
 b=h+6EGdA1d/z6gaRk1yLEOi+v7TYFCKsO5kpzVqwPAxp3DV4FYfve07PH3+VHqXr+07XJ27xrC3s6xt20FrMc+37kF0pXjEWGEZ3FqRaFqAYJIKn9RncboThdafZ/gF7Qa0IGKVkDJJ/mCUL8L8Vje5421q88UFl4OJq3X+9Wb8YKjZWtAcQh8Oy+XRPIsSnH78Lxw6G3nA2y0RAe2jPNdqS9DX41UHl9w/VzJmyH39lBpdMnP9LossUkAJgjLBN10KFK2gb420Dz3YUjZ0W2T+oYcz3BcnDEaWyf0i9X30WUgylLeXZn2CHj8takCi57i7+8qpzRCuIBIbZ7qFH22A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQUEM5ca7coakQv72bsNt+k61HBZZbFyi6u61Mxubf8=;
 b=eibVwbpsTOAE7rEDwMzbgk1Lt2JqaQnucJwV03wiG5v1swWIM27xVQzFYziu+hEKrSgHK1jasFVkS3BtF1xSeoxnwsxYPLAcwNFDuH5mQ23uVLwgmansBS0FbbNVh4QbsRCFBbF1J8s7k7Lyp5B/YCo7osleydHs0gNicHWy5/o=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:10 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/17] staging: wfx: fix endianness of the struct hif_ind_startup
Date:   Mon, 11 May 2020 17:49:25 +0200
Message-Id: <20200511154930.190212-13-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:08 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38bdffcd-4928-47aa-b5c4-08d7f5c2fc1c
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB19682BCC319FE60DAEB77A3C93A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:248;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LeIKW/OoLuNhzMbQ+FbzBTsBKL4hzeejmvi1iZ541wDHzwusCqrIjg0+UYA7/CRNPrz3eZCVDlZ7OAG8kUY7EwP6fvBqtmHz3QzFv+7Zw+R+V0+hqJffNvQBFdEmhAF/10aZnPS6OMi5KnQT+KubJz9qs6gzcP7xtq3uWYxTwKnUfaDmCrtYOlEbqMUocyNp/ep5kia3XezgT0MzHR5oNyfGbe9SGxWmxy46ThKPM47f7Zz5h+CZOqVOX/k5Ps048/m8ZulN7PUb/c3sEbf7diIJl94D8wysUFfirBSp5K+6ZKe1GH3bvIAFoxyqIE00XCkehX9wDt/ulhu5rQzxIkI6Zfe+S6IYp2Xw63rqkjqR0/qhfdNfLO14JrFojlDOkwF2PjHBR2Y2qKpLU0qGsRUadJrJ0X5W7dl5Xls/78wc72ukKHhz0TZ/TCdTh3k/FaRhFh3tAh/vnlE9h4phWMrlo9t3ihOip8PQuYIHyZe54OzJa0tai3MgwgZzW0JWvqtoKBQi2HxaGlC9rAqyWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 22RpSVebhbVN2Fvq2QnWxpyGzHOOBbABeOJa80h6UUMFi+8nmvTmtdE2v5ef3Y4dW80EGqvuEU4Hrjfj49xrTfe2pMkFlVClEh/mWIQDMqvhzAZQtHBqELuuQe7KknfQqLQVVhd4URNfDpsRhLgeOrCF411Q8LHVnp44rxhu3ZO6TqQJc/QhTfZ0bPmaCPAHNRL99DFIJTrV0nVCoPUmJriDJkBPkI9+DI0LRJW51FBwLc6/PLRQmQ0ArPMQaZbXpzG3vg0icHgXAdO0k9I+zmQd/PQkOC9ghagGPl2qQGzwVv8UBaNZoDzVJLHTdbhAf9iFCjxZttcV/t5+1vES6+BW6eVxs0eENp1ExizAtdMrBPgAxDYZ3HdHxwBu5VotIxp0BAX/LWo7LhFkCQ0uIOGUTVCEi7wPhKwL8XpU1CJDjOwxCpm8MuLWi0jNCm9hByI0KQEq4PUzBwNe10ydUThU/d9KLA8vJmL/wPEwt64=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bdffcd-4928-47aa-b5c4-08d7f5c2fc1c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:10.1203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAflAmfoSGPBOBRlowc9XAzFb+pkL6xHayQf6UDsL4HyRhy7J5u7o1PSO7VireFxYcMz19B9xgTq7QNj+IUtvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgaXMgcmVjZWl2ZWQgZnJvbSB0aGUgaGFyZHdhcmUuIFNv
IGl0IGlzCmRlY2xhcmVkIGFzIGxpdHRsZSBlbmRpYW4uIEhvd2V2ZXIsIGl0IGlzIGFsc28gc3Rv
cmVkIGluIHRoZSBtYWluIGRyaXZlcgpzdHJ1Y3R1cmUgYW5kIHVzZWQgb24gZGlmZmVyZW50IHBs
YWNlcyBpbiB0aGUgZHJpdmVyLiBTcGFyc2UgY29tcGxhaW5zCmFib3V0IHRoYXQ6CgogICAgZHJp
dmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmM6Mzg4OjQzOiB3YXJuaW5nOiByZXN0cmljdGVkIF9f
bGUxNiBkZWdyYWRlcyB0byBpbnRlZ2VyCiAgICBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmM6MTk5
Ojk6IHdhcm5pbmc6IHJlc3RyaWN0ZWQgX19sZTE2IGRlZ3JhZGVzIHRvIGludGVnZXIKICAgIGRy
aXZlcnMvc3RhZ2luZy93ZngvYmguYzoyMjE6NjI6IHdhcm5pbmc6IHJlc3RyaWN0ZWQgX19sZTE2
IGRlZ3JhZGVzIHRvIGludGVnZXIKCkluIG9yZGVyIHRvIG1ha2UgU3BhcnNlIGhhcHB5IGFuZCB0
byBrZWVwIGFjY2VzcyBmcm9tIHRoZSBkcml2ZXIgZWFzeSwKdGhpcyBwYXRjaCBkZWNsYXJlIGhp
Zl9pbmRfc3RhcnR1cCB3aXRoIG5hdGl2ZSBlbmRpYW5uZXNzLgoKT24gcmVjZXB0aW9uIG9mIHRo
aXMgc3RydWN0LCB0aGlzIHBhdGNoIHRha2VzIGNhcmUgdG8gZG8gYnl0ZS1zd2FwIGFuZAprZWVw
IFNwYXJzZSBoYXBweS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2Vu
ZXJhbC5oIHwgMTEgKysrKysrKy0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgICAg
ICAgICAgfCAgOCArKysrLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9n
ZW5lcmFsLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCmluZGV4IGYw
MTM1ZDI3MTIwYy4uOTk1NzUyYjlmMTY4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfZ2VuZXJhbC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5l
cmFsLmgKQEAgLTEzNiwxMiArMTM2LDE1IEBAIHN0cnVjdCBoaWZfb3RwX3BoeV9pbmZvIHsKIH0g
X19wYWNrZWQ7CiAKIHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgeworCS8vIEFzIHRoZSBvdGhlcnMs
IHRoaXMgc3RydWN0IGlzIGludGVycHJldGVkIGFzIGxpdHRsZSBlbmRpYW4gYnkgdGhlCisJLy8g
ZGV2aWNlLiBIb3dldmVyLCB0aGlzIHN0cnVjdCBpcyBhbHNvIHVzZWQgYnkgdGhlIGRyaXZlci4g
V2UgcHJlZmVyIHRvCisJLy8gZGVjbGFyZSBpdCBpbiBuYXRpdmUgb3JkZXIgYW5kIGRvaW5nIGJ5
dGUgc3dhcCBvbiByZWNlcHRpb24uCiAJX19sZTMyIHN0YXR1czsKLQlfX2xlMTYgaGFyZHdhcmVf
aWQ7CisJdTE2ICAgIGhhcmR3YXJlX2lkOwogCXU4ICAgICBvcG5bMTRdOwogCXU4ICAgICB1aWRb
OF07Ci0JX19sZTE2IG51bV9pbnBfY2hfYnVmczsKLQlfX2xlMTYgc2l6ZV9pbnBfY2hfYnVmOwor
CXUxNiAgICBudW1faW5wX2NoX2J1ZnM7CisJdTE2ICAgIHNpemVfaW5wX2NoX2J1ZjsKIAl1OCAg
ICAgbnVtX2xpbmtzX2FwOwogCXU4ICAgICBudW1faW50ZXJmYWNlczsKIAl1OCAgICAgbWFjX2Fk
ZHJbMl1bRVRIX0FMRU5dOwpAQCAtMTU1LDcgKzE1OCw3IEBAIHN0cnVjdCBoaWZfaW5kX3N0YXJ0
dXAgewogCXU4ICAgICBkaXNhYmxlZF9jaGFubmVsX2xpc3RbMl07CiAJc3RydWN0IGhpZl9vdHBf
cmVndWxfc2VsX21vZGVfaW5mbyByZWd1bF9zZWxfbW9kZV9pbmZvOwogCXN0cnVjdCBoaWZfb3Rw
X3BoeV9pbmZvIG90cF9waHlfaW5mbzsKLQlfX2xlMzIgc3VwcG9ydGVkX3JhdGVfbWFzazsKKwl1
MzIgICAgc3VwcG9ydGVkX3JhdGVfbWFzazsKIAl1OCAgICAgZmlybXdhcmVfbGFiZWxbMTI4XTsK
IH0gX19wYWNrZWQ7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IGZjYTlkZjYyMGFkOS4uOWI0ZjBj
NGJhNzQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTEwMCwxMCArMTAwLDEwIEBAIHN0YXRpYyBp
bnQgaGlmX3N0YXJ0dXBfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJcmV0dXJu
IC1FSU5WQUw7CiAJfQogCW1lbWNweSgmd2Rldi0+aHdfY2FwcywgYm9keSwgc2l6ZW9mKHN0cnVj
dCBoaWZfaW5kX3N0YXJ0dXApKTsKLQlsZTMyX3RvX2NwdXMoJndkZXYtPmh3X2NhcHMuc3RhdHVz
KTsKLQlsZTE2X3RvX2NwdXMoJndkZXYtPmh3X2NhcHMuaGFyZHdhcmVfaWQpOwotCWxlMTZfdG9f
Y3B1cygmd2Rldi0+aHdfY2Fwcy5udW1faW5wX2NoX2J1ZnMpOwotCWxlMTZfdG9fY3B1cygmd2Rl
di0+aHdfY2Fwcy5zaXplX2lucF9jaF9idWYpOworCWxlMTZfdG9fY3B1cygoX19sZTE2ICopJndk
ZXYtPmh3X2NhcHMuaGFyZHdhcmVfaWQpOworCWxlMTZfdG9fY3B1cygoX19sZTE2ICopJndkZXYt
Pmh3X2NhcHMubnVtX2lucF9jaF9idWZzKTsKKwlsZTE2X3RvX2NwdXMoKF9fbGUxNiAqKSZ3ZGV2
LT5od19jYXBzLnNpemVfaW5wX2NoX2J1Zik7CisJbGUzMl90b19jcHVzKChfX2xlMzIgKikmd2Rl
di0+aHdfY2Fwcy5zdXBwb3J0ZWRfcmF0ZV9tYXNrKTsKIAogCWNvbXBsZXRlKCZ3ZGV2LT5maXJt
d2FyZV9yZWFkeSk7CiAJcmV0dXJuIDA7Ci0tIAoyLjI2LjIKCg==
