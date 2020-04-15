Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F35A1AAD9A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410323AbgDOQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:15:44 -0400
Received: from mail-eopbgr700077.outbound.protection.outlook.com ([40.107.70.77]:38433
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415208AbgDOQMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iv+v3roAq2CxG1em9YkenbvLrO1QCzl4VM2GbhKrxGxOeywNYmw5H8qD+aTfcCzIPFT+oA4TgAu6gdRu4kO0FFktVRu5RSnxnOTHQtomjiFoZkRAqjhyX+jueh5bdXJmUeoCrwHXzDKyS6jUX3nauM3JRocJwFhQgHWBNA/h7YawkBTejDQ3zjXhRnWG4Hy+Neg2gJp1a0NTPpSMWO309OyE1AWQxy5P11OQMJqWfNqYLDwvh0bzlRql9/RLxfumetIfSrCZ5B+sGAyNm9CYBfOYFKAwzvsxIey1dtnMfwqmbcsla7q0K3yjETUu/fjtJxA4JBbN8jl4nSQvkpoNaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxulB34wil+80Clk2MTntwTOBSVESVKF8em79hHSyRA=;
 b=gjZRvSx1v7V0nInKsou2kLFcV/JTLwolWQSdGac8lplL0W6a3Yk3a3/RYJZWcTMZD8d+cUSukiOKTes0CBR+UYU+visAVl5oFk35jgYtZojCyNB+7qgJDDC3Na19Vzt6pgdn1he3jZHuf+tXSOBl5ZuMoIcJNvJbJq1LBM0PdufTfZSBbscjfxREDwlvbUfoT1F1jg85OpLet14SMVP7aOIyFrSYqvQHjIstpocMbVXJb+rIcEMmDfGCYmeBLreTN+ac9qwGeCZF+16L/BICEYYFn6vQm0pujhESQoSmb1h0PsfBCK+MHYE7t5sCWqsVHN+JgtRrjxgOmIfu83CsUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxulB34wil+80Clk2MTntwTOBSVESVKF8em79hHSyRA=;
 b=abQmF4FtVdGncQt0iJsAhKuVkXbzRpMQPg3xUWYUymKzd1ib+MX6/Ln2v0AbRPmi06Jz19eJmHl09a+QaMl3uJu+gvufyCJmovbMiYb52m81ht4/3vcg0ZRzUvtOYOQ9VnQM8dRpjQwEVi691anxMVdRM3s5L7aHzUnX3oxJgiE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1408.namprd11.prod.outlook.com (2603:10b6:300:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 15 Apr
 2020 16:12:18 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:18 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/20] staging: wfx: rework wfx_configure_filter()
Date:   Wed, 15 Apr 2020 18:11:30 +0200
Message-Id: <20200415161147.69738-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:15 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bcf12df-12b1-474e-2b9d-08d7e157c529
X-MS-TrafficTypeDiagnostic: MWHPR11MB1408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1408F80691AED952593DDB0393DB0@MWHPR11MB1408.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(396003)(376002)(346002)(39850400004)(366004)(8886007)(8936002)(5660300002)(2906002)(6666004)(86362001)(8676002)(478600001)(81156014)(66574012)(1076003)(4326008)(52116002)(316002)(54906003)(107886003)(186003)(16526019)(66556008)(66476007)(36756003)(2616005)(6512007)(6486002)(6506007)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jW8jBz2bc3zjS7i30fOOJKmxbe40tKGxhDT2INm46/CvzL5hmlh3Yi31lNhJDTrRit3eqTRitWjBZLvNbc2/uCWxRsXKLuQ9MGp1RDpLbSme6WpRuBX9Um/9yPCchZIaIwUWopNd0SmC3SyAlP+A0mFiYJDxbIC9sth/aDzgwmrQnS8DdnkfS42nKfgNx25p6IExMpC9FFSwlggduz0mf4gv+SbjFgjD8Efel2C+EVdYJoepRnLPkGEzi0FtWa0gkP9ZTI+Pwclc0G/CnDNewNUqMtO2cH4gBWDbtJ4bszDOQjANINS4rprxJUAtQS2oaQeSD+pLPC3n2r5/eHKjbMBGlxqFY2VtwmXSkpIwVrngXE9OPoJL3l3RZx6669hV92clr8uLI4uV3/OS/XnCxj/cTA4wlcFVKuQskPkwxmH5O10WUBrGh/QlZnROzFV
X-MS-Exchange-AntiSpam-MessageData: mnGDHs53Gvntec9HGDU3dQuM+0jYy/8e9t/LV/vkTlOieokFL1aTkxYdxQJj249JrSL3Q3TV8S06qe5IfEg9SWh+GgCIPKzlIOCKzKIEya3bqO0e73vACN6+to1mW0VQ98xtShBJC/gNiglCe6AnaahdDqw89yzkdjGkZeuHBmAEkCRNHmcp0hex+V9by5PeVkFQeJuBblwjDR4RW4grRA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bcf12df-12b1-474e-2b9d-08d7e157c529
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:18.6646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCeFJX0oHHdaL95xgoQMdEovtvEBtEiOh22nJrHM8bQsjQb+6JgyUb4No4b6qduGD721s5nAW2HUAAybLCGp7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2NvbmZpZ3VyZV9maWx0ZXIoKSBsYWNrcyBvZiBjb2hlcmVuY3kuIEluIGFkZCwgc29tZSBjb3Ju
ZXIgY2FzZXMKc2VlbXMgdG8gbm90IGJlZW4gaGFuZGxlZCBwcm9wZXJseS4gUmV3b3JrIHRoZSB3
aG9sZSBmdW5jdGlvbigpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCA0
MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAzNSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDE0ZTJm
MTA2YjA0Mi4uZWM5NDljZTBiMjU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTIwMyw3ICsyMDMsNiBAQCB1
NjQgd2Z4X3ByZXBhcmVfbXVsdGljYXN0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJCQlo
YS0+YWRkcik7CiAJCQlpKys7CiAJCX0KLQkJd3ZpZi0+bWNhc3RfZmlsdGVyLmVuYWJsZSA9IHRy
dWU7CiAJCXd2aWYtPm1jYXN0X2ZpbHRlci5udW1fYWRkcmVzc2VzID0gY291bnQ7CiAJfQogCkBA
IC0yMTgsMTYgKzIxNyw0NiBAQCB2b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LAogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gTlVMTDsKIAlzdHJ1Y3Qgd2Z4
X2RldiAqd2RldiA9IGh3LT5wcml2OwogCi0JKnRvdGFsX2ZsYWdzICY9IEZJRl9PVEhFUl9CU1Mg
fCBGSUZfRkNTRkFJTCB8IEZJRl9QUk9CRV9SRVE7CisJLy8gTm90ZXM6CisJLy8gICAtIFByb2Jl
IHJlc3BvbnNlcyAoRklGX0JDTl9QUkJSRVNQX1BST01JU0MpIGFyZSBuZXZlciBmaWx0ZXJlZAor
CS8vICAgLSBQUy1Qb2xsIChGSUZfUFNQT0xMKSBhcmUgbmV2ZXIgZmlsdGVyZWQKKwkvLyAgIC0g
UlRTLCBDVFMgYW5kIEFjayAoRklGX0NPTlRST0wpIGFyZSBhbHdheXMgZmlsdGVyZWQKKwkvLyAg
IC0gQnJva2VuIGZyYW1lcyAoRklGX0ZDU0ZBSUwgYW5kIEZJRl9QTENQRkFJTCkgYXJlIGFsd2F5
cyBmaWx0ZXJlZAorCS8vICAgLSBGaXJtd2FyZSBkb2VzICh5ZXQpIGFsbG93IHRvIGZvcndhcmQg
dW5pY2FzdCB0cmFmZmljIHNlbnQgdG8KKwkvLyAgICAgb3RoZXIgc3RhdGlvbnMgKGFrYS4gcHJv
bWlzY3VvdXMgbW9kZSkKKwkqdG90YWxfZmxhZ3MgJj0gRklGX0JDTl9QUkJSRVNQX1BST01JU0Mg
fCBGSUZfQUxMTVVMVEkgfCBGSUZfT1RIRVJfQlNTIHwKKwkJCUZJRl9QUk9CRV9SRVEgfCBGSUZf
UFNQT0xMOwogCiAJbXV0ZXhfbG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAJd2hpbGUgKCh3dmlm
ID0gd3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxMKSB7CiAJCW11dGV4X2xvY2soJnd2
aWYtPnNjYW5fbG9jayk7Ci0JCXd2aWYtPmZpbHRlcl9ic3NpZCA9ICgqdG90YWxfZmxhZ3MgJgot
CQkJCSAgICAgIChGSUZfT1RIRVJfQlNTIHwgRklGX1BST0JFX1JFUSkpID8gMCA6IDE7Ci0JCXd2
aWYtPmRpc2FibGVfYmVhY29uX2ZpbHRlciA9ICEoKnRvdGFsX2ZsYWdzICYgRklGX1BST0JFX1JF
USk7Ci0JCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIHRydWUpOworCisJCS8vIE5vdGU6IEZJRl9C
Q05fUFJCUkVTUF9QUk9NSVNDIGNvdmVycyBwcm9iZSByZXNwb25zZSBhbmQKKwkJLy8gYmVhY29u
cyBmcm9tIG90aGVyIEJTUworCQlpZiAoKnRvdGFsX2ZsYWdzICYgRklGX0JDTl9QUkJSRVNQX1BS
T01JU0MpCisJCQl3dmlmLT5kaXNhYmxlX2JlYWNvbl9maWx0ZXIgPSB0cnVlOworCQllbHNlCisJ
CQl3dmlmLT5kaXNhYmxlX2JlYWNvbl9maWx0ZXIgPSBmYWxzZTsKKworCQlpZiAoKnRvdGFsX2Zs
YWdzICYgRklGX0FMTE1VTFRJKSB7CisJCQl3dmlmLT5tY2FzdF9maWx0ZXIuZW5hYmxlID0gZmFs
c2U7CisJCX0gZWxzZSBpZiAoIXd2aWYtPm1jYXN0X2ZpbHRlci5udW1fYWRkcmVzc2VzKSB7CisJ
CQlkZXZfZGJnKHdkZXYtPmRldiwgImRpc2FibGluZyB1bmNvbmZpZ3VyZWQgbXVsdGljYXN0IGZp
bHRlciIpOworCQkJd3ZpZi0+bWNhc3RfZmlsdGVyLmVuYWJsZSA9IGZhbHNlOworCQl9IGVsc2Ug
eworCQkJd3ZpZi0+bWNhc3RfZmlsdGVyLmVuYWJsZSA9IHRydWU7CisJCX0KIAkJd2Z4X3VwZGF0
ZV9maWx0ZXJpbmcod3ZpZik7CisKKwkJaWYgKCp0b3RhbF9mbGFncyAmIEZJRl9PVEhFUl9CU1Mp
CisJCQl3dmlmLT5maWx0ZXJfYnNzaWQgPSBmYWxzZTsKKwkJZWxzZQorCQkJd3ZpZi0+ZmlsdGVy
X2Jzc2lkID0gdHJ1ZTsKKworCQlpZiAoKnRvdGFsX2ZsYWdzICYgRklGX1BST0JFX1JFUSkKKwkJ
CXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIHRydWUpOworCQllbHNlCisJCQl3ZnhfZndkX3Byb2Jl
X3JlcSh3dmlmLCBmYWxzZSk7CiAJCW11dGV4X3VubG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsKIAl9
CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLS0gCjIuMjUuMQoK
