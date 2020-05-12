Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8381CF850
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgELPEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:04:34 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:45896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbgELPEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWjVHWxU37HMKo7LYsGJCNIIfPeT+AgPVvEhnbsCRI1wVyTRR2zWuin2bwkNeTRE/5zVz1N6Q5AijVzJ4+MsTbFqGqZQfDsx/djBxlqhVsMOU1rO8+qRHEErWrUUD9nDw3lv/SkA2McStJqClIsJGSOOtKncDyaL723DijFHukF5ZzFIBPRjXoBo0PICR9CwgmmF5bq3es5aOqOy6VK5knyECrSKoJ60dV/rUWydPiMS2q4LxZQmabbVPZZaXKF7bPKSjqBeby9PWdLPVgv2L8doigH6pLdsSNFSJCnYAO1dClDH18c4MDLN7xhNvnBvmFKtMvL9Ev1OLKzey5MwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0ScSG6O/SgnJ5N95Xp7pTa0lFCcqLWbqYqFSzPaeqk=;
 b=k55pmHBIJRsPm2IvyNoF1i78AAayu/w7uBLS9euk7BjpLFY68sGSixmjLw9Uv0OO+6lYiLqddA/J4lwXl7HDbXp8LmmwXTi6esaWFyaWGhkknaG9Yi5E6CIJs8rUZUzwlFkrMZOgMhNAi4W/Isg/RRvb40cPtFd5x4a5C5+11ue93R6NnfI+n5e1z7auzo+qk1FS+2zjCgkx64UH4TobMbd+OLROhfP6smTnyNwFPqQLvKT8fGqs1zcC+iiHta8XzaeadhJM/e8mZcINesXJg3Yf2uODvlbwMLhjV/LO25mypRt6k5z7cLHmxDJq36KjoW+GI5MLWonWY+waE/Pdew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0ScSG6O/SgnJ5N95Xp7pTa0lFCcqLWbqYqFSzPaeqk=;
 b=Ue88eahujOGwRz9Tn1PNsvbgDvTV53A96G5J6Fb9uJ3KfO56Q+JoxqH8hqMgV/wD6EI8re42bhu938gpfl/Cmt4M6+TvTFEUCP1Swg/ka8WfW7/GqD4Uv3tQrQXqcx6e0vmVRDuxScWyORZyi/7IQqGLr8I7wo+9DNm3Y0qZEd8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:30 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:30 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 00/17] staging: wfx: fix support for big-endian hosts
Date:   Tue, 12 May 2020 17:03:57 +0200
Message-Id: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:28 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c093921-2ad5-492b-3064-08d7f685c545
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1741B2C7E2514B352AE5566593BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVnmTjoKhTUHfNAt/2NzRPYPS5qAawG/HCujWv3UC/TOpO3CSKeCUlx4R1k+MobapdNxDumroNMkbFbfk5YKlE7BdjqcvW3flnJDpo4/EA+UouPj6/sB44lrAY5mbDiPvxrYqCeARyIhgg2BPSPge6olEPDFVrV25WCPWw29fUX9ayLCIa3WCE7p8ds+QeVv3gssfopCFSwumYkKW5AFl2P05W5UTyHMFjgMCdIf5nyOQeyxjMkQWfY9Hos+YzfLQBpDX5k3n9Vyh71diYLCC1TUe39EN6JmAmEXnvn4osDSm3kd6LgnX9cd8vgLxolvKM50u2lFDQt1BgjOno4iOr0FAva8Cm8pcvBF6AKX3eVT54oJ5chdeM3cbDYAg0f8vRtpFa3CeNfnfKMAsvz4qMKtmyer8mbTIXqMdp58y4mU19Rdxn5nW8u35/GVMSXE7jF1hpIVo+C8FK93g9SIbKmoE+6/e3Bp1Uhv87J/HMW49P+shm937q3qyWNmFiVRaGC7PqqOzcKCqp8EOGh9d3LLq82qoz45HQvq+iNu1SvBWAgPpmwL6Kz31UhHoHsXqKmYMrFEOr9yDOtV2Zn+NcqUmkkCEDvvC6m2cscHITA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(966005)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FXcOdu6E7yAj3G1GVUpm2gjCjnulLCIbp0eaTM5QRBV28bEjis/8VgR0s9ZkhPzdNCElsyxPuh1qxPCzYB3XNRxm+yws2gNMe5JWW3dOZ8Ectnquqs8D6q3f+LpIj/fUSvW5aKtK/hyxvhH2cnCUo4ajwqUsOFhvbU/A1dci3KU+M0fO35p0vQTqOf/PheXlfF8wYUbQDBefay3gT2+QxL2PHszjZqfa9cVUlVusMH3XPC8hxiKjVixRSYoZGYjc3YTAuk2fYWExx1XV5GzwaWUrbGQLrPYq27K6w97W2wlQRxjg8w12bzjMH5YWKq8xJoDU8o7S5iE7pBMhr8nrfSbqs1fm/EBmGQeuPd/PCvORY3stw3Dc1J2539DJU/DqXPTJMh/WCZMa4DXb5AK1cHNyfYcq1NBf9cLRcn3sof4v8tR+Csl54UCHmHoUigkZjvsZpxlCUHYPBRpe6nfmUGTKhRUwSQphP67QenehxJU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c093921-2ad5-492b-3064-08d7f685c545
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:30.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8HRO/63+0NAN0xV+jhUP4V3kMD9ToCXX9SkRvq6KrQyY3TqBhDiPdCUW/SpUji88L/GC1yy9dUv0WOkXDNW6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8sIAoKQXMgYWxyZWFkeSBkaXNjdXNzZWQgaGVyZVsxXSwgdGhpcyBzZXJpZXMgaW1wcm92ZXMg
c3VwcG9ydCBmb3IgYmlnCmVuZGlhbiBob3N0cy4gQWxsIHdhcm5pbmdzIHJhaXNlZCBieSBzcGFy
c2UgYXJlIG5vdyBmaXhlZC4KCk5vdGUsIHRoaXMgc2VyaWVzIGFpbXMgdG8gYmUgYXBwbGllZCBv
biB0b3Agb2YgUFIgbmFtZWQgInN0YWdpbmc6IHdmeDoKZml4IE91dC1PZi1CYW5kIElSUSIKClsx
XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMTkxMTExMjAyODUyLkdYMjY1MzBAWmVu
SVYubGludXgub3JnLnVrCgp2MjoKICBSZXdyaXRlIHBhdGNoIDEzOiBrZWVwIHRoZSBlbmRpYW5u
ZXNzIG9mIHRoZSBmaWVsZCAnbGVuJyBhcy1pcyBhbmQgZml4CiAgdGhlIGFjY2Vzc2VzLgoKSsOp
csO0bWUgUG91aWxsZXIgKDE3KToKICBzdGFnaW5nOiB3Zng6IGZpeCB1c2Ugb2YgY3B1X3RvX2xl
MzIgaW5zdGVhZCBvZiBsZTMyX3RvX2NwdQogIHN0YWdpbmc6IHdmeDogdGFrZSBhZHZhbnRhZ2Ug
b2YgbGUzMl90b19jcHVwKCkKICBzdGFnaW5nOiB3Zng6IGZpeCBjYXN0IG9wZXJhdG9yCiAgc3Rh
Z2luZzogd2Z4OiBmaXggd3JvbmcgYnl0ZXMgb3JkZXIKICBzdGFnaW5nOiB3Zng6IGZpeCBvdXRw
dXQgb2Ygcnhfc3RhdHMgb24gYmlnIGVuZGlhbiBob3N0cwogIHN0YWdpbmc6IHdmeDogZml4IGVu
ZGlhbm5lc3Mgb2YgZmllbGRzIG1lZGlhX2RlbGF5IGFuZCB0eF9xdWV1ZV9kZWxheQogIHN0YWdp
bmc6IHdmeDogZml4IGVuZGlhbm5lc3Mgb2YgaGlmX3JlcV9yZWFkX21pYiBmaWVsZHMKICBzdGFn
aW5nOiB3Zng6IGZpeCBhY2Nlc3MgdG8gbGUzMiBhdHRyaWJ1dGUgJ3BzX21vZGVfZXJyb3InCiAg
c3RhZ2luZzogd2Z4OiBmaXggYWNjZXNzIHRvIGxlMzIgYXR0cmlidXRlICdldmVudF9pZCcKICBz
dGFnaW5nOiB3Zng6IGZpeCBhY2Nlc3MgdG8gbGUzMiBhdHRyaWJ1dGUgJ2luZGljYXRpb25fdHlw
ZScKICBzdGFnaW5nOiB3Zng6IGRlY2xhcmUgdGhlIGZpZWxkICdwYWNrZXRfaWQnIHdpdGggbmF0
aXZlIGJ5dGUgb3JkZXIKICBzdGFnaW5nOiB3Zng6IGZpeCBlbmRpYW5uZXNzIG9mIHRoZSBzdHJ1
Y3QgaGlmX2luZF9zdGFydHVwCiAgc3RhZ2luZzogd2Z4OiBmaXggYWNjZXNzIHRvIGxlMzIgYXR0
cmlidXRlICdsZW4nCiAgc3RhZ2luZzogd2Z4OiBmaXggZW5kaWFubmVzcyBvZiB0aGUgZmllbGQg
J3N0YXR1cycKICBzdGFnaW5nOiB3Zng6IGZpeCBlbmRpYW5uZXNzIG9mIHRoZSBmaWVsZCAnbnVt
X3R4X2NvbmZzJwogIHN0YWdpbmc6IHdmeDogZml4IGVuZGlhbm5lc3Mgb2YgdGhlIGZpZWxkICdj
aGFubmVsX251bWJlcicKICBzdGFnaW5nOiB3Zng6IHVwZGF0ZSBUT0RPCgogZHJpdmVycy9zdGFn
aW5nL3dmeC9UT0RPICAgICAgICAgICAgICB8IDE5IC0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2JoLmMgICAgICAgICAgICAgIHwgMTcgKysrKystLS0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3J4LmMgICAgICAgICB8ICA0ICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRh
X3R4LmMgICAgICAgICB8ICA3ICsrLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyAgICAg
ICAgICAgfCAxMyArKysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oICAg
ICB8IDQyICsrKysrKysrKystLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
YXBpX2dlbmVyYWwuaCB8IDQ3ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfcnguYyAgICAgICAgICB8IDM4ICsrKysrKysrKysrKy0tLS0tLS0tLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgICAgICAgICAgfCAxOCArKysrKy0tLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYyAgICAgIHwgIDIgKy0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaHdpby5jICAgICAgICAgICAgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9t
YWluLmMgICAgICAgICAgICB8ICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oICAg
ICAgICAgIHwgMTAgKysrLS0tCiAxMyBmaWxlcyBjaGFuZ2VkLCAxMDQgaW5zZXJ0aW9ucygrKSwg
MTE3IGRlbGV0aW9ucygtKQoKLS0gCjIuMjYuMgoK
