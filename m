Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909BB19AA07
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbgDALFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:06 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:6053
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbgDALE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PP0lYD0Fou87gbvQJvrwG0NJog3OEZVqxGpPFAH1Lw3kWKiGxDA4yZNgr6Gzjjdrzp9EkIU2An50WOiH76SMeXKV9MVsKh7S1ZADf2vIFZJff+lyAPM197w1TbnhhoEI99LQbln02//3DNaRHIhXbkDVvz9rOPcq6sLpHUCuJoVuhs+J58rId9fgIUIoRRGoSjWeSPK60AqEojEeTCsCUXxNzn/RRJmFE+ZYXbQ2ujHmvdewEJ9ZHivZkl0SHWgypQekG5Hfw6lSIszO9yU1ypRI42ip8PH4mgWs+eMURXtfLpvlnUUqgken77wqIfD3QZtaXDv/J9xzLecNwtmSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8hXEBmGdi+6ggl8GNIQen6Avc3J9TdGfh1DYAKqH4Y=;
 b=dXl3dagWDgX9HZXlGFAzxV0fHaqjkv+93u4RSnWVI4czxrbvtaGO0e4TAOroXs5ZWxvOObLGmeQxBOtM5IOAwMTjXRH/XAy6qFBBjndxe1JjUuT7HzdkdhE7fIry/oBwAWWw8gSsW51eGYuG9FoKJodkAppUzTahZ4MCQRROZ5iECmuQ2Th8u1VWOvbL0kkp1iR0vivU8Nxt2m83c/zL1kV9yuccM4EIov8HNWukJi2WK8hJ8R5A7YdxLV1ouZrri4mlUyz2Ec133p0SftbPqwJ69eVJdva9k7oxtresa86E4S1VcrE7oiDhxKVvCIKfYcTLXt8Mth1zUfba7xI6SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8hXEBmGdi+6ggl8GNIQen6Avc3J9TdGfh1DYAKqH4Y=;
 b=lI2+gvsMQPhKKxhTtwhwFdRwTUWL5caBvUnPhG7z14z1W6xwkHL7DD5qQArS9MBkIJRVDQs93oMrLRtr2jtRhduq69STVKKjOqmWQzgYxgFUXwR6eGmjQ85jVHHz3vbgr3YbTsNNJDQnp8uUxGLdebv0A0e/KiDephkqsKYX4F4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/32] staging: wfx: rework the Tx queue
Date:   Wed,  1 Apr 2020 13:03:33 +0200
Message-Id: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:17 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49532a74-7511-4e73-c29d-08d7d62c6d1a
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285A3A14C0E0A7D7A375D1893C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yyb6IcznTq1Dw7yq4jkQmWdTJr4qTPIR9O4wzwSBJxsnB4p7jNJtK3jtXsAyGz/MeML5rj+KVUI0WihDmJFA/+WTtsg0VCYNBFfjF4v+qgn+QXntuTJUXmX/NVTXpNvycI0VK91SEsLXMObtzbRM96wxgJ8PWsj0RLuoFWuBe6zorCRR3uRnvMYh7Na8vItPoerP43O1JmTVsnm6V6B/Wzd1TJeq5S0RSF9Jyr2BmXrWJTgZ5fyupfsch2UFyjz3Dfd3feAjRiUrrVh23ot4/AeIMMJylEn3WdrxOOs3tv+h4m0uF6pcAdLo0p8+ryMIOpPB17nJl+DDcfVoo1C5CvE4UkxEmhzs6dWHsCsF0ia8hEjgKBz7wvrVOkkujkgB16ScOPJtHY2UxTt3Ly3qH/k7a4IKVroaMdV4qltmpUqxMaft/Cv5kB7A+GZGldVx
X-MS-Exchange-AntiSpam-MessageData: WP1QgPrkITihwFKirFcqftMNhSBRd8bdN6M5odKszTynqTVeUs9IbKYBxH+3266SzC1QonsvaCzOOLDHK9XkzNaaepDbqoquD39hb6k/vozBHxF0kUFeWgX88BmG1T3tUwTMZaPKim3QRAv5kiSqBZ1RZKcuvMriFVYZYCTDOKkQho9UhvarPUIX3KizJl4zAdXCMV3WRuoiLR+KEclkog==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49532a74-7511-4e73-c29d-08d7d62c6d1a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:19.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6YJcgb2tVL8pA7jZuBjrK0hrdnTC4HQKBw7tAPWR66sR1y+1lpK3dzRfs2Ys1CPzCjE8cB/si2TqVew6LbCVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9mIHRoZSBUeCBxdWV1ZSBpcyBmYXIgbW9yZSBjb21w
bGV4IHRoYW4KbmVjZXNzYXJ5IGFuZCBpdHMgYmVoYXZpb3IgaXMgZHViaW91cyBvbiBzb21lIGNv
cm5lciBjYXNlcy4gVGhpcyBzZXJpZXMKcmV3b3JrIHRoZSBUeCBxdWV1ZToKICAtIFNpbXBsaWZ5
IHN1cHBvcnQgZm9yIFFvUyAoc2luY2UgZGV2aWNlIGFscmVhZHkgZG8gdGhlIGpvYikKICAtIFNp
bXBsaWZ5IHN1cHBvcnQgZm9yIFBvd2VyIFNhdmluZyBzdGF0aW9ucyAoc2luY2UgbWFjODAyMTEg
YWxyZWFkeQogICAgZG8gdGhlIGpvYikKICAtIEltcHJvdmUgc3VwcG9ydCBvZiBDb250ZW50IEFm
dGVyIERUSU0gQmVhY29uIChDQUIpIHdoZW4gZGV2aWNlIGlzCiAgICBBUCBhbmQgc29tZSBzdGF0
aW9uIHVzZSBwb3dlciBzYXZlLgogIC0gSW1wcm92ZSByb2J1c3RuZXNzIG9mIGZsdXNoaW5nCgoK
SsOpcsO0bWUgUG91aWxsZXIgKDMyKToKICBzdGFnaW5nOiB3Zng6IGFkZCBzYW5pdHkgY2hlY2tz
IHRvIGhpZl9qb2luKCkKICBzdGFnaW5nOiB3Zng6IGRvIG5vdCBzdG9wIG1hYzgwMjExIHF1ZXVl
aW5nIGR1cmluZyB0eF9wb2xpY3kgdXBsb2FkCiAgc3RhZ2luZzogd2Z4OiB0YWtlIGFkdmFudGFn
ZSBvZiBpZWVlODAyMTFfe3N0b3Avc3RhcnR9X3F1ZXVlcwogIHN0YWdpbmc6IHdmeDogcmVtb3Zl
ICJidXJzdCIgbWVjaGFuaXNtCiAgc3RhZ2luZzogd2Z4OiB1bmlmb3JtaXplIHF1ZXVlX2lkIHJl
dHJpZXZhbAogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIHF1ZXVlX2lkIGZpZWxkCiAgc3Rh
Z2luZzogd2Z4OiBhdm9pZCB1c2VsZXNzIHdha2VfdXAKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5
IGhpZl9oYW5kbGVfdHhfZGF0YSgpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSB3ZnhfdHhfcXVl
dWVzX2VtcHR5KCkKICBzdGFnaW5nOiB3Zng6IGRyb3AgdW51c2VkIGFyZ3VtZW50IGluIHdmeF9n
ZXRfcHJpb19xdWV1ZSgpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSB3ZnhfdHhfcXVldWVfbWFz
a19nZXQoKQogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIHN0YV9hc2xlZXBfbWFzawogIHN0
YWdpbmc6IHdmeDogZHJvcCBhcmd1bWVudCB0eF9hbGxvd2VkX21hc2sgc2luY2UgaXQgaXMgY29u
c3RhbnQgbm93CiAgc3RhZ2luZzogd2Z4OiBkbyBub3QgdXNlIGxpbmtfbWFwX2NhY2hlIHRvIHRy
YWNrIENBQgogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIGxpbmtfbWFwX2NhY2hlCiAgc3Rh
Z2luZzogd2Z4OiBkbyBub3QgcmVseSBhbnltb3JlIG9uIGxpbmtfaWQgdG8gY2hvb3NlIHBhY2tl
dCBpbiBxdWV1ZQogIHN0YWdpbmc6IHdmeDogZHJvcCB1bnVzZWQgbGlua19pZCBmaWVsZAogIHN0
YWdpbmc6IHdmeDogZHJvcCB1bnVzZWQgcmF3X2xpbmtfaWQgZmllbGQKICBzdGFnaW5nOiB3Zng6
IHJlbmFtZSB3ZnhfdHhfZ2V0X3Jhd19saW5rX2lkKCkKICBzdGFnaW5nOiB3Zng6IHJlcGxhY2Ug
d2Z4X3R4X3F1ZXVlc19nZXRfYWZ0ZXJfZHRpbSgpIGJ5CiAgICB3ZnhfdHhfcXVldWVzX2hhc19j
YWIoKQogIHN0YWdpbmc6IHdmeDogaW50cm9kdWNlIGEgY291bnRlciBvZiBwZW5kaW5nIGZyYW1l
cwogIHN0YWdpbmc6IHdmeDogY2hhbmdlIHRoZSB3YXkgdG8gY2hvb3NlIGZyYW1lIHRvIHNlbmQK
ICBzdGFnaW5nOiB3Zng6IGRyb3Agbm93IHVzZWxlc3MgZmllbGQgZWRjYV9wYXJhbXMKICBzdGFn
aW5nOiB3Zng6IGRyb3Agc3RydWN0IHdmeF9xdWV1ZV9zdGF0cwogIHN0YWdpbmc6IHdmeDogc2lt
cGxpZnkgdXNhZ2Ugb2Ygd2Z4X3R4X3F1ZXVlc19wdXQoKQogIHN0YWdpbmc6IHdmeDogaW1wcm92
ZSBpbnRlcmZhY2UgYmV0d2VlbiBkYXRhX3R4LmMgYW5kIHF1ZXVlLmMKICBzdGFnaW5nOiB3Zng6
IHJlbG9jYXRlIHdmeF9za2JfZHRvcigpIHByaW9yIGl0cyBjYWxsZXJzCiAgc3RhZ2luZzogd2Z4
OiByZXBhaXIgd2Z4X2ZsdXNoKCkKICBzdGFnaW5nOiB3Zng6IHdmeF9mbHVzaCgpIGRpZCBub3Qg
ZW5zdXJlIHRoYXQgZnJhbWVzIGFyZSBwcm9jZXNzZWQKICBzdGFnaW5nOiB3Zng6IGZpeCBwb3Rl
bnRpYWwgZGVhZGxvY2sgaW4gd2Z4X3R4X2ZsdXNoKCkKICBzdGFnaW5nOiB3Zng6IGZpeCBjYXNl
IHdoZXJlIEFQIHN0b3Agd2l0aCBDQUIgdHJhZmZpYyBwZW5kaW5nCiAgc3RhZ2luZzogd2Z4OiBy
ZW1vdmUgaGFjayBhYm91dCB0eF9yYXRlIHBvbGljaWVzCgogZHJpdmVycy9zdGFnaW5nL3dmeC9i
aC5jICAgICAgfCAgIDQgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgMTk2ICsr
KysrLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIHwgICA1ICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jICB8ICAgMiArCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21h
aW4uYyAgICB8ICAgMiAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgICB8IDUyOSArKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVl
LmggICB8ICAzNiArLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgIHwgIDg3ICsrLS0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCAgICAgfCAgIDIgLQogZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaCAgICAgfCAgIDcgKy0KIDEwIGZpbGVzIGNoYW5nZWQsIDI4MSBpbnNlcnRpb25z
KCspLCA1ODkgZGVsZXRpb25zKC0pCgotLSAKMi4yNS4xCgo=
