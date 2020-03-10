Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975CA17F4C0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgCJKOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:19 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:6032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbgCJKOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:14:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hv1lWLJ5JG8fqa/KY1otiFKA915NDh6VwnJNX55EkJs9EcGnrIH8HT7nQDPsJlY2eHFQ9aundXCwn6ntRXkGWhV5Y55D4fjKLnVC6VTNwlGWi3S9RerLgJsSMOWZl8yXtsL5GGV6pxtT5rZlWEUusXrx3gmxxQoV1/KBfc8xhQOQ31gPGH3qKqDq/a6ik/U5neEF2jI+eSMvSpP2E6Rf17Jqg+VSBl1oaqytgR4hqUYi53BrdPuGubuR+5R1Rx7KCLVrrXLiR2DCh7v1YTAIavX86I697k92btDZEbX7br1X4wPayU3CVYc43wkfv9u0FqtEgGa/cMvMhJHP6DMOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY0qJf+PC3z1CAdSUCmy7DUXCKeTQ6KLeudf/6A3J7A=;
 b=QJfDzbFSz/QD8eXz+JQyz+OqF6pAOo5OEjfHTYZWX+YIFXHjo+/fiKsilpLb/GpeuVoG8V8Pjimo4l+hFEVVGCaYxgOKn1iWuuw+Qv+W9upnwCDzYEABRSjgRsJBo+OPO2CjRYqO1AUc4R+AbBYhrtkQV3hbtrg1bKBTY7Njc6uCqHAcoK3M9xCa6z7EXVkiy3WSuNu4KkGBGqn6z5D2rvsP5mFhhmqwT2+pyUha8FNcmpoKXIMIX6E0TlHpEZxqmBRLSTwggxGyd6JcHKYPpAkqQkfhC8qjXwR+jjyJVBqCK0uM/PRCH2oVBKZPlRUV9lYRGQ3ZWfG0turQnWovvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY0qJf+PC3z1CAdSUCmy7DUXCKeTQ6KLeudf/6A3J7A=;
 b=OifI80rwFr48Ju+XyjKL1fEMCV4S7tzNe5OWRM+gAQZ6ZS1ZDMQWV1wwoEDWVHqCXY/ozEkpkVX5oCWg4bbNmz/VZC6NRO9hcW8lkC6v8m66TeCmz6MBLxyMHRH7Rj4a30gDCREw89in7850UYxNUW/dnRqd+/SqULMVOeUoPA0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 10:14:14 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 10:14:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 1/5] staging: wfx: fix warning about freeing in-use mutex during device unregister
Date:   Tue, 10 Mar 2020 11:13:52 +0100
Message-Id: <20200310101356.182818-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::24) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 10:14:13 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6741a84-bd41-4207-70ae-08d7c4dbc906
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB361573767AA634DE0C74E24793FF0@MN2PR11MB3615.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(6666004)(52116002)(5660300002)(2616005)(86362001)(316002)(956004)(36756003)(478600001)(4744005)(7696005)(8936002)(54906003)(4326008)(16526019)(186003)(26005)(6486002)(66574012)(66946007)(8676002)(1076003)(81166006)(2906002)(66476007)(81156014)(66556008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3615;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXCkY/6SGnZvNxSZcByR6mQ9EyLmW+Y1nHTtWBJlZFEFxbBbHwT0cxbAlhBOP7Zlh+g+T8yHBxJuvaMZuPvuUel6O8CNtkkupWhyRERrqI9wknpmTjHQbqaAAG5KH+wDQRl+UnydpZas09bpQ6ZbPWg9EPzPeeCYLNVMD50HxxUMPRhvAhCwmpCPziO7OqAuZB5aYG0Ws/lTDOqHqwvqC7PJS+gNpFEgJmaBv7JUjSUMwEMNSjMMvrOeyXsb+PGezGnoC3PYqRLWtd3DdrowzTcp+Wh4vpbrTb6xsNXH6PFTA3ue9+HtsC1U5rY8l7i05QZhEuq66yfZWP+8q5tTmwg0YPngn/TfgksNectziyu+8cU2lbpLHTr0shBecVKvQWKBF7W0X91llBw4CSN9/3jrdy9FZYhr5tRt4t36ygjqrgNiqpucH/BNEqPFoeEY
X-MS-Exchange-AntiSpam-MessageData: vjfCw9P9gqXx04nMUb0gD+L8XpbYerJQIUSmxB+NS4e9yHGbbM1fcsCn/slsT8TpOITv1WZ1ZH9ixXmI14GlqPfsowRAlVTfgRD82RqjWjluGg2XA603HxxzlIN6ylQyJAjYCUvmGavQycMYGEHyfw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6741a84-bd41-4207-70ae-08d7c4dbc906
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 10:14:14.8407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksikP+gNt/SL2Bqr7DpgTBdBWBxGlEAUknsoyP5do7HYvW2d5yQJ9cpXf89H3NrScSVYn2ECOU9fwjjKprv9DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWZ0
ZXIgaGlmX3NodXRkb3duKCksIGNvbW11bmljYXRpb24gd2l0aCB0aGUgY2hpcCBpcyBubyBtb3Jl
IHBvc3NpYmxlLgpJdCB0aGUgb25seSByZXF1ZXN0IHRoYXQgbmV2ZXIgcmVwbHkuIFRoZXJlZm9y
ZSwgaGlmX2NtZC5sb2NrIGlzIG5ldmVyCnVubG9ja2VkLiBoaWZfc2h1dGRvd24oKSB1bmxvY2sg
aXRzZWxmIGhpZl9jbWQubG9jayB0byBhdm9pZCBhIHBvdGVudGlhbAp3YXJuaW5nIGR1cmluZyBk
aXNwb3NhbCBvZiBkZXZpY2UuIGhpZl9jbWQua2V5X3JlbmV3X2xvY2sgc2hvdWxkIGFsc28KYmVl
biB1bmxvY2tlZCBmb3IgdGhlIHNhbWUgcmVhc29uLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl90eC5jCmluZGV4IDI0MjgzNjMzNzFmYS4uN2I3MzJjNTMxYTc0IDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMKQEAgLTE0MCw2ICsxNDAsNyBAQCBpbnQgaGlmX3NodXRkb3duKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2KQogCWVsc2UKIAkJY29udHJvbF9yZWdfd3JpdGUod2RldiwgMCk7CiAJbXV0ZXhf
dW5sb2NrKCZ3ZGV2LT5oaWZfY21kLmxvY2spOworCW11dGV4X3VubG9jaygmd2Rldi0+aGlmX2Nt
ZC5rZXlfcmVuZXdfbG9jayk7CiAJa2ZyZWUoaGlmKTsKIAlyZXR1cm4gcmV0OwogfQotLSAKMi4y
NS4xCgo=
