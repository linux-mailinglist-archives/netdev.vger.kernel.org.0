Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98F51B10E0
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgDTQDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:03:31 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:44353
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgDTQDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUEgI+vipasbhCZmuv/jCy0vDYJHZjhnZwetRIrWO81rsGvRfqlOyKEAsqSrqqve8wJLszygKl56V8ykzBm36fOvMTE9zssAlgQ4MDwT3hWXWemRPlFQ9xCWNelO5N11CPOw4rSsjXlxAyJjdBKhQH8xDjLAHdhWJAY6BpARUsATu84Fya5KjxDdD/vEzLrr9dSv/SvPEFJuKueTKcFS2RWT/SLjEt0Flc1YFi3A/OS5Tgojrqsx2y4H+IdQuQO95KVoiKleEOWIpFtRHT8qwnNnAMrQ7guK/mJlWHJZj0RrsJavZqRn/fjrtSLDvgY8/h7MmMZ+j9TiTILy0mSdVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raGdsA+cWhxtd5gNxZXf7OAPVJ/6Gb/lnmkq14nWq00=;
 b=aqCZyBa/w0hnzDA8+zRFDXZfUnD2aTk2qunrzsKDkOrywhE3ojB9drMGnwzOFT0pZjX7jDJVrzCAerpMcJZdzbxIYX8y4F/J5ktrsELtAppMEZiwlVbjJNLuHJFehHRy9GCr9FbKIMLVyTWDMqmcexbL0EN8m1BNvzCE8DruQy8e9y1aW7tWka5mrG/ra5mclwwcppv4YOF7T4D0CXLMARKHBgCDJ3Eu60fIu0X/w6hZt9kVOyrErR2cf/hP7GUZZVfuk1lrQZyqtm9sgkIlBnPtOzYfW74FV/uauY9zdzhAQ4wVJ2xpOrhm0JTqRJGrT9RA2v4PtEfiyvECrQdVtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raGdsA+cWhxtd5gNxZXf7OAPVJ/6Gb/lnmkq14nWq00=;
 b=UThVWtu/yFwGqSRIWjfyjCh+/TaJm9RAn9PdRAnxid3NqnL/Zte8TjMSuI9Suur99Mk8Hmg68+yZFFxwF1Q+NSXTsCnShbfHJgZUt6CKmo7tkZ6gCfjhVc14D0NM2LzoW+bC5Zg+Ptl26S6ugmJXX+nRIZc7vKmRk2NfZSKhQ1E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1487.namprd11.prod.outlook.com (2603:10b6:301:b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:03:27 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/16] staging: wfx: rework the handling of the connection loss
Date:   Mon, 20 Apr 2020 18:02:55 +0200
Message-Id: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:25 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0253a687-242b-4885-b41e-08d7e5445c70
X-MS-TrafficTypeDiagnostic: MWHPR11MB1487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1487631C1835F27C866362D193D40@MWHPR11MB1487.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:407;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(366004)(136003)(346002)(376002)(2616005)(6666004)(66946007)(66476007)(66556008)(7696005)(52116002)(478600001)(6486002)(81156014)(8936002)(8676002)(54906003)(86362001)(186003)(2906002)(16526019)(107886003)(66574012)(316002)(1076003)(36756003)(4326008)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sX4HkdTsocsmK6HASk46tF/3HzONy5Ia2jt+ardyL9KjXUHTSJrQjzGR99M1nRxOf7EWbIrxbtdP7Ml+UAIJ7toASpsIJEMTR2n7PfvIraKsJUrLG1DirNT1ovOXZWBwQwmc9zyhdD08nbooSiZNgEuJmTw7LiOjNqFvByimn6hT2PTwMUKBpMREBXjzSvJH43MzTjCX/CMv1UZGT6sIeCxWo82xQNZK5pPESun/Z20xINZdlarIkHVl9YhRLzwgylV5P75JHx1vKZK0CvrxJ1SSLDlu37k6ch1UMbMuExY/gWQuO3DTEpiAE8rRicoGXk3xZB1z3k+LUdgTpZegyBBP/N4cQ98mx57hCmw0U7NnZzaofFBrFIXpNLRDRmo1BscGYmNhUyd5EzkWg8xhFFmgqrpHrjK/AOlBETIVhekDBw9gGS8Ke1dKI9OiyY6E
X-MS-Exchange-AntiSpam-MessageData: 2xojT9rm4uvyDw8upqx0vE5VDCR/G0UX+MGBf0v/hldfoqEHf3m6yLXM43rbCiTgRVUl+My211ntDT63JXliI7+QT2GtcMWRCpTcO853TaPtD3j764+1e2lcmIxeVKyZRWtEXGoMBCn6dOFd66X2iSlKpr5IysRIK4V6KQHrO8iTWaZzOm31Yr34yZcq4NIooWDNIIgVKM9HiaNoRLy6DoCQ4KMxAwlpe0lC7s2WhBszWdnL/HMHdXo6rwTzN5fmssPaShIunATJwXnULXtPQkq/vqex3YV5U24NhODWfrSc4soLbfdsBCoQHUds5Opd4S4nHVC+a39I0Uo5p6KCUvA1hJUlMC1PL42b53yfsIbBkMdIMpRsikoLyxyHfsBrBDrPraTIRji3VocoNbFFdRsSTYbOvEHwZ/Lke/RxL9/BV96plGTOT195psZF7JLX4AqkvJ6qPAOCefxigGPBK7cnj0OYyJx8KhWBIv/Z3cA7rh/xzz3S6KuemcOhJn7WrWcJ4RaJ+9XyBDRwWVIvz+2HfM/Mai9Sbof8XC7/eeKtVs7PmO9gC5yh02bEPJxQcTlnudwUxVkXEWHTlKn9Mb4yWANO54sPbz5CticihoEY6jGrHVU/+Tuo0wN3yBFAVWQvkRH9eNMHnp0gpUVflaXhJKv1i+GCymZD5jlz/ZA6HyK1CavE7TtMe9Q/q5JFaHfulsyjU1qIuqxvR1Uuaubzdu5fOPPUzhFpv3XWgmz/gKa393FiJGOr0+mxKLReOccnR840ZfaDzqFQH93Jj40m2nGMijxKHdcCKL/WUIzqkjvv639nkC8bqtJCE2dxV4cBtiMXhI8fewsbvNaPQuRHbAB9awgxIdtM5EjJTgE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0253a687-242b-4885-b41e-08d7e5445c70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:27.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKgH5MibNQzg+c0g9fheeCX21NBfiEh1byITxF6khuOYCw7A01rdeFS1ayg4hiRv+3Ntv5S18cJGpUpIIOlEWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1487
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW50
aWwgbm93LCB0aGUgZHJpdmVyIGhhbmRsZWQgaXRzZWxmIHRoZSBjb25uZWN0aW9uIGxvc3MuIFRo
aXMgc2VyaWVzCmFsbG93cyB0byB1c2UgaWVlZTgwMjExX2JlYWNvbl9sb3NzKCkgaW5zdGVhZCAo
cGF0Y2ggMi8xNikuIFRoaXMgY2hhbmdlCmFsbG93IGEgYnVuY2ggb2Ygc2ltcGxpZmljYXRpb25z
IGluIG1hbnkgcGFydHMgb2YgdGhlIGRyaXZlciAobW9zdCBvZgp0aGUgcGF0Y2hlcyAzIHRvIDE2
KS4gSW4gcGFydGljdWxhciBpdCBhbGxvd3MgdG8gZHJvcCB0aGUgaW5mYW1vdXMgZW51bQp3Znhf
c3RhdGUgKHBhdGNoIDE1LzE2KS4KCkrDqXLDtG1lIFBvdWlsbGVyICgxNik6CiAgc3RhZ2luZzog
d2Z4OiBzaW1wbGlmeSB0aGUgY2hlY2sgaWYgdGhlIHRoZSBkZXZpY2UgaXMgYXNzb2NpYXRlZAog
IHN0YWdpbmc6IHdmeDogdXNlIGllZWU4MDIxMV9iZWFjb25fbG9zcygpIHByb3ZpZGVkIGJ5IG1h
YzgwMjExCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVzZWxlc3MgYXR0cmlidXRlICdic3NfcGFyYW1z
JwogIHN0YWdpbmc6IHdmeDogaGFuZGxlIGZpcm13YXJlIGV2ZW50cyBzeW5jaHJvbm91c2x5CiAg
c3RhZ2luZzogd2Z4OiBhbHNvIGZpeCBuZXR3b3JrIHBhcmFtZXRlcnMgZm9yIElCU1MgbmV0d29y
a3MKICBzdGFnaW5nOiB3Zng6IGR1YWwgQ1RTIGlzIG5ldmVyIG5lY2Vzc2FyeQogIHN0YWdpbmc6
IHdmeDogZmllbGQgb3BlcmF0aW9uYWxfcmF0ZV9zZXQgaXMgaWdub3JlZCBieSBmaXJtd2FyZQog
IHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9ic3NfcGFyYW1zKCkKICBzdGFnaW5nOiB3
Zng6IGRyb3AgdXNlbGVzcyB1cGRhdGUgb2YgZmllbGQgYmFzaWNfcmF0ZV9zZXQKICBzdGFnaW5n
OiB3Zng6IGludHJvZHVjZSB3Znhfc2V0X2RlZmF1bHRfdW5pY2FzdF9rZXkoKQogIHN0YWdpbmc6
IHdmeDoga2V5cyBhcmUga2VwdCBkdXJpbmcgd2hvbGUgZmlybXdhcmUgbGlmZQogIHN0YWdpbmc6
IHdmeDogZHJvcCBwcm90ZWN0aW9uIGZvciBhc3luY2hyb25vdXMgam9pbiBkdXJpbmcgc2Nhbgog
IHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIGNoZWNrcyBpbiB3ZnhfZG9fdW5qb2luKCkKICBz
dGFnaW5nOiB3Zng6IHNpbXBsaWZ5IHdmeF9yZW1vdmVfaW50ZXJmYWNlKCkKICBzdGFnaW5nOiB3
Zng6IGRyb3AgdW51c2VkIGVudW0gd2Z4X3N0YXRlCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVudXNl
ZCBhdHRyaWJ1dGUgJ2pvaW5fY29tcGxldGVfc3RhdHVzJwoKIGRyaXZlcnMvc3RhZ2luZy93Zngv
ZGF0YV90eC5jICAgICB8ICAgNyAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgg
fCAgIDYgLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyAgICAgIHwgIDM5ICsrKy0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICAgfCAgMTIgKy0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmggICAgICB8ICAgMyArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhf
bWliLmMgIHwgIDEzIC0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCAgfCAgIDEg
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYyAgICAgICAgIHwgIDY4ICsrKy0tLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2tleS5oICAgICAgICAgfCAgIDIgLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMgICAgICAgIHwgICAxICsKIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyAgICAg
ICB8ICA0NCAtLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgICAgICB8ICAgMyAt
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAgfCAyNDggKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgICAgICAgfCAgMTcg
Ky0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggICAgICAgICB8ICAyMCArLS0KIDE1IGZpbGVz
IGNoYW5nZWQsIDc3IGluc2VydGlvbnMoKyksIDQwNyBkZWxldGlvbnMoLSkKCi0tIAoyLjI2LjEK
Cg==
