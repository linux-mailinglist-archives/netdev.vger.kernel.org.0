Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54AE19AA0F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732479AbgDALFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:15 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732411AbgDALFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFYpCKtgphHq0uwn92Ukw+1yshAUqXTLbD3Mbbganza4dVtbo6momBu+1/hxAwRJPtZAXx04sTi5JBpqOicz9T933knheOxgYifF9bM5TWyiLXqbPPH1Qs/edk1sOU8zxGpK0sRCGXLVJSXivAQEwYLt68I2zQZ6XU4U8QG736p6745K/9dwzwO/pORNo4cHfX6vU45cXEmLyzjS2M7m57sWhupAMw3hzfhX6Udz0JnigVXjN3Ih23mgVDiWM36ylLzlkF4Rczmq+HmQLeJcNPNELmBTvFwbAxqkuFbjgEEeo/YjKL0dE3WljEqP8MfyWvCS2hXPxUN0ljCwn0WAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KByH8CMeALcWNBVr4ZyAF71eawkmjEy+Ct0mBPM1yJQ=;
 b=V6GhFGvuzlIkLHYDA3VnNUcXzr9+TY06ZQU1IzyHJu5iYSZvk/pUFN83BkfAdk/1UsnpcBXrl8EYU1bsu8Jz++FaJTN2Ge1hmY/EpQxqrV6ZHzBiKJX//oG8IeB4ANRIz5ehrjnJ+SQeWa63pu4uZAtvwOGbhMEcVUugOh6zQsHP7SlxG/ycyH7FsIyzWBeRkCrMMrLxvBr43qY35tUqjjf2rUZZ43rL8b0EJNhpaLFq7O+b76vNpYbpR4wl7QAgq+4Z6QcJTkmoh9+QiioTGDMBllYIhE/CNcro0dTRr8HOf62t4Ysu50ma+G2dihopTOl2vtl/6xUw6sYZUx2PIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KByH8CMeALcWNBVr4ZyAF71eawkmjEy+Ct0mBPM1yJQ=;
 b=lZbxPuzjFlfvomYS6bmLo+2nCZ4HyMEUNB8ye1gOIeboJz5ysH6667MXsFlvTe656Z5SXWjzDYbgnT70w8yy5QGoEFcits8Ff6TgjiObOTVEh4/DokYUviMCGyC5fr/RmPh00zRCKRqLGbPuan3AJ+xa1Qsjb3CEMiHiR+nDUyw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:03 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 21/32] staging: wfx: introduce a counter of pending frames
Date:   Wed,  1 Apr 2020 13:03:54 +0200
Message-Id: <20200401110405.80282-22-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:01 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47540c5e-2a2e-4c04-3ebb-08d7d62c86dc
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285A49C0E0F8D0391835D6693C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFlBb6duW27fpd3n7YV3JtJ/W3bgOhFcc0LmcTa7hbXcyREFG7WURlK8ojzdIm/LSWWRZuLMALj+TeEGT+A+aciuT6IuG3oCGz/x/AiFd5cIKq8xizR6kDdrmwG1S4IqTBPGMAslOQ98SqDJeqQh1odw9twDvoLywO41mP37Dac0hKHW2FkhB/J+wRpl3oko3wGvMolbsdNftZBhQ/vayA9ulcPxJuGEvUpx0LavdouvHCtdeTF/Jx7S+TReLc1f2yh3lOWoNZb5N/oJE+YPxdTyL5oilVsoAxzX4CaMqy65PSw3TCj/qPeCyu60qHaw3OGQuXxln/ZFTEaHA4y3sb9Rs4QwhFfOHa9O2I1CRClIAnkMc35yj6U+KYXFe2j7VbnOo/+PzppSV+rG2Ym5xzKAmii2hPhN43YueFMYXUepUM3pi8VTx40jNh2Z4nxX
X-MS-Exchange-AntiSpam-MessageData: ahcmKjOT8kZv+4WIlGS34xr3TyXYS0CwNUMS7ysg4e4+3dbwy3S8cqea4H2TuaN9I1Ch2Cy52rqtMsi4oqMpDghEjSbU/Zjq9DtCFqHRnGc0Y0INll301YOtUGGhsFAK9JPg0mIeUIFa4nRETJhqvXCgON+Pdi8xajanTwT3k7fzx2Y+85EU2KP6+LLnrlDyrsTK1OPQCMzwuNxxmSm9QA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47540c5e-2a2e-4c04-3ebb-08d7d62c86dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:02.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQatUSOhByYXZ9QHFhqAigf88hWAiQJh6plaQW7F99ZGrFkL0Rhv2ENUTvAIjXGpgqnQgE8i3q+52EYPCSxIAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBjb3VudGVyIHdpbGwgYmUgdXNlZnVsIHRvIGtub3cgd2hpY2ggcXVldWUgaXMgbGVhc3QgZnVs
bCBpbiBhCmZ1cnRoZXIgcGF0Y2guCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1
ZS5jIHwgMTUgKysrKysrKysrKysrKysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmggfCAg
MiArKwogMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmlu
ZGV4IDRkZGIyYzczNzBjZC4uMjFhMmM4YWFiYmI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0zMCw2
ICszMCw3IEBAIHZvaWQgd2Z4X3R4X3VubG9jayhzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHZvaWQg
d2Z4X3R4X2ZsdXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogewogCWludCByZXQ7CisJaW50IGk7
CiAKIAkvLyBEbyBub3Qgd2FpdCBmb3IgYW55IHJlcGx5IGlmIGNoaXAgaXMgZnJvemVuCiAJaWYg
KHdkZXYtPmNoaXBfZnJvemVuKQpAQCAtMzksNiArNDAsMTIgQEAgdm9pZCB3ZnhfdHhfZmx1c2go
c3RydWN0IHdmeF9kZXYgKndkZXYpCiAJcmV0ID0gd2FpdF9ldmVudF90aW1lb3V0KHdkZXYtPmhp
Zi50eF9idWZmZXJzX2VtcHR5LAogCQkJCSAhd2Rldi0+aGlmLnR4X2J1ZmZlcnNfdXNlZCwKIAkJ
CQkgbXNlY3NfdG9famlmZmllcygzMDAwKSk7CisJaWYgKHJldCkgeworCQlmb3IgKGkgPSAwOyBp
IDwgSUVFRTgwMjExX05VTV9BQ1M7IGkrKykKKwkJCVdBUk4oYXRvbWljX3JlYWQoJndkZXYtPnR4
X3F1ZXVlW2ldLnBlbmRpbmdfZnJhbWVzKSwKKwkJCSAgICAgInRoZXJlIGFyZSBzdGlsbCAlZCBw
ZW5kaW5nIGZyYW1lcyBvbiBxdWV1ZSAlZCIsCisJCQkgICAgIGF0b21pY19yZWFkKCZ3ZGV2LT50
eF9xdWV1ZVtpXS5wZW5kaW5nX2ZyYW1lcyksIGkpOworCX0KIAlpZiAoIXJldCkgewogCQlkZXZf
d2Fybih3ZGV2LT5kZXYsICJjYW5ub3QgZmx1c2ggdHggYnVmZmVycyAoJWQgc3RpbGwgYnVzeSlc
biIsCiAJCQkgd2Rldi0+aGlmLnR4X2J1ZmZlcnNfdXNlZCk7CkBAIC0xNzYsNiArMTgzLDcgQEAg
c3RhdGljIHN0cnVjdCBza19idWZmICp3ZnhfdHhfcXVldWVfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LAogCXNwaW5fdW5sb2NrX2JoKCZxdWV1ZS0+cXVldWUubG9jayk7CiAJaWYgKHNrYikgewog
CQlza2JfdW5saW5rKHNrYiwgJnF1ZXVlLT5xdWV1ZSk7CisJCWF0b21pY19pbmMoJnF1ZXVlLT5w
ZW5kaW5nX2ZyYW1lcyk7CiAJCXR4X3ByaXYgPSB3Znhfc2tiX3R4X3ByaXYoc2tiKTsKIAkJdHhf
cHJpdi0+eG1pdF90aW1lc3RhbXAgPSBrdGltZV9nZXQoKTsKIAkJc2tiX3F1ZXVlX3RhaWwoJnN0
YXRzLT5wZW5kaW5nLCBza2IpOwpAQCAtMTkyLDcgKzIwMCw5IEBAIGludCB3ZnhfcGVuZGluZ19y
ZXF1ZXVlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCXN0cnVj
dCB3ZnhfcXVldWUgKnF1ZXVlID0gJndkZXYtPnR4X3F1ZXVlW3NrYl9nZXRfcXVldWVfbWFwcGlu
Zyhza2IpXTsKIAogCVdBUk5fT04oc2tiX2dldF9xdWV1ZV9tYXBwaW5nKHNrYikgPiAzKTsKKwlX
QVJOX09OKCFhdG9taWNfcmVhZCgmcXVldWUtPnBlbmRpbmdfZnJhbWVzKSk7CiAKKwlhdG9taWNf
ZGVjKCZxdWV1ZS0+cGVuZGluZ19mcmFtZXMpOwogCXNrYl91bmxpbmsoc2tiLCAmc3RhdHMtPnBl
bmRpbmcpOwogCXNrYl9xdWV1ZV90YWlsKCZxdWV1ZS0+cXVldWUsIHNrYik7CiAJcmV0dXJuIDA7
CkBAIC0yMDEsNyArMjExLDEyIEBAIGludCB3ZnhfcGVuZGluZ19yZXF1ZXVlKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogaW50IHdmeF9wZW5kaW5nX3JlbW92ZShz
dHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IHNrX2J1ZmYgKnNrYikKIHsKIAlzdHJ1Y3Qgd2Z4
X3F1ZXVlX3N0YXRzICpzdGF0cyA9ICZ3ZGV2LT50eF9xdWV1ZV9zdGF0czsKKwlzdHJ1Y3Qgd2Z4
X3F1ZXVlICpxdWV1ZSA9ICZ3ZGV2LT50eF9xdWV1ZVtza2JfZ2V0X3F1ZXVlX21hcHBpbmcoc2ti
KV07CiAKKwlXQVJOX09OKHNrYl9nZXRfcXVldWVfbWFwcGluZyhza2IpID4gMyk7CisJV0FSTl9P
TighYXRvbWljX3JlYWQoJnF1ZXVlLT5wZW5kaW5nX2ZyYW1lcykpOworCisJYXRvbWljX2RlYygm
cXVldWUtPnBlbmRpbmdfZnJhbWVzKTsKIAlza2JfdW5saW5rKHNrYiwgJnN0YXRzLT5wZW5kaW5n
KTsKIAl3Znhfc2tiX2R0b3Iod2Rldiwgc2tiKTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCmluZGV4IDJjNDcy
NDY5OWVkMC4uYzI0YjhjZDQxYTc4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCkBAIC05LDYgKzksNyBAQAog
I2RlZmluZSBXRlhfUVVFVUVfSAogCiAjaW5jbHVkZSA8bGludXgvc2tidWZmLmg+CisjaW5jbHVk
ZSA8bGludXgvYXRvbWljLmg+CiAKICNpbmNsdWRlICJoaWZfYXBpX2NtZC5oIgogCkBAIC0yMCw2
ICsyMSw3IEBAIHN0cnVjdCB3ZnhfdmlmOwogCiBzdHJ1Y3Qgd2Z4X3F1ZXVlIHsKIAlzdHJ1Y3Qg
c2tfYnVmZl9oZWFkCXF1ZXVlOworCWF0b21pY190CQlwZW5kaW5nX2ZyYW1lczsKIH07CiAKIHN0
cnVjdCB3ZnhfcXVldWVfc3RhdHMgewotLSAKMi4yNS4xCgo=
