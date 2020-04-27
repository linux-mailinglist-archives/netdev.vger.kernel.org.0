Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F791BA52E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD0NlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:10 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:9980
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727844AbgD0NlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gk1nkiRT5yPJ1/FwZOzneD7SUjTeuYre5WQho4yg4jHK6qoPWdUDgRTdIK8Ygji6XhhHO+NwOSvy+UYRAUjM7pB70OvNbBQ9NCX2hEhr7Tox1tpScXrCE8yoZeC95ghxG0SqAZgs3YZWiQMpjJdhBsxxxqFgjxP2EHNLWeXc8nNt8RYS8jAy6MrR6Q60hqwQhN7MMxh+T8WG+hyh9T34eUq5oHMj2rLhG7qFZAvYnM2gWk5pPyhWI4G3TM/n+dD9p+HuiNDrbVxbxgdTAXp7HDT+Md4dO8rb9qSSG8g0BkB4zwdA2d5igFrzAhPibYYRA5oy+VoQAkwfK59j+IQpZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GxryEBoOR/UFhLpgEEXMeXqf2ZX0cZxiTA24EZdFIA=;
 b=X+mDhhAvnErGDfjW9GbZH4BOICN2uMBM//+Pptj2mjcUoaohUTkk2AWSjb+tg1KSSaot9Jvp/lv/TpBZZYZ6HGmiR8Xq/LcBByZld6gBua+WXX/7pZoxRtMwWmXjyzZO/QO0WHquot7WjL3r9zvIZmXGMOJH/mviErYudQAm8Lw4CqI77aCqUXaXOzo+jmVmv1YPu3sIKb1R4XNCxHsCW+bYz2CRpnhA1nmNOCaYCVSoxIg3MHW1yCOGRjUiLRimnF7Vv5z2wruVVjzR/v4tKC8FXF5eQzGVKTf/3UOiZLp+K17XaGumvUovqGlzFGRnLySQACkleqclEPcuV3CKTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GxryEBoOR/UFhLpgEEXMeXqf2ZX0cZxiTA24EZdFIA=;
 b=HfNwU2dacg7IlkDqxpKpjr86sNT4SgN4drcItbUQ3XINXZk1tzMkFn8sFuPVWryK/KL1x8IQD9GOgFxz64rBu/QPEtSajFTDF4CDQ6N46+/htmFJ1KK5Rp4eZYPA3n+Acln/HejmlyuIYXZGYsfuIyqgwDgWzSMuNzI02Lgx2aI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:05 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:05 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/17] staging: wfx: mark chip frozen on error indication
Date:   Mon, 27 Apr 2020 15:40:17 +0200
Message-Id: <20200427134031.323403-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:03 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d14050b-f51e-4fd5-fd92-08d7eab0a244
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424CC7F1C34626193BB51FA93AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4744005)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1Aa3xMXR/2539ZlHeausStvOiGTprkIdAnB3yT6dtpcmgy3BEHFPBBKmUuwN6zzSSnhiLNuRZuh3ihJer8nrvy4V8mc9fGiE9HamP86tqvMe8ZNL9Nr/1C8ibtv5GHBQi36A0WCNkaB1M9a40wkiByDBu7r4lxGBLDzqTI31n9UimMQioEAGPbBz45ot7CPR3cDzmoY0l+qkkPifQTkXSTquElQP/QnbGWnIpyh08lTpFOtcAhO1va/miKrOhq4d7sru3xsyBRBpUCbBNQc7U5XZsik/UKVTuUM3ioyvnqOZsItiYosF91LzqCnVXthfwzFsA5qzCmIdlSCIoHkFb4//bbmKos7P1dYT7IoRmopZ3SxqZ58LC05D+oamODG2kg9mezKcLlCJnJjq5XKjFP2PbQxt2BKWurzuGul07sfKEeEF89a2agAE++MmOUe
X-MS-Exchange-AntiSpam-MessageData: K6LDB0godt2pNvO0BwXidIWEmrIt7qkbbzxDMFonY04WK2yKnsDP3714ATtKrBVsFFlJu8gWkzE56OiQKcldh/bQaFt+F0IB30a8sDvovn6HfIKQxHk+JvHCE4tr3kdBJ6ENo/RrGbKCkTGPnEb6a9GthafGumt2vudqKA8xQano1xO9ln+GADvXxAw82QVvm9pyJGqpP+SNHOdrQOucZp67e6KsrsEBNKeZk/nwrsCvm4P1TIcosJH0dnXPbpHnxU+bjddMUk+kc98GHOv8vLdzEHzpnLAPXdsRS/lR7S9PQA2hcDUk/G6c3pmY2XXHZUjuEAfKhgVd2tau7415r4sQ9l1OlCSIK4l7t0hGTx4MduTCnaRFKe4z9aS7dSziBrMHklaiDyiuN5/7k11bj+7RIStnNf4H8vvsLSm8038I/3SrzDCdEp4h44KjVVRCdmWeEH5S8Sx5ywe5LbxWLtqwI/8qyztb1ZF5Ni5hYyHTumgN76kXD/FfREitLsk9sghz10nnh7A6YRPg9NRWrgMtHppfIjTnZtdEN/rDdlA3WsVlXFDKajbfk2IFYrNcECh6/Kz0UN0+wxdO9PZiyj1M6nO1oxQlWQ2sI3vQBP2ojQgrbDWJOoO1k/rQsZ/OY/D5ZUq5LVTgrlaefAU3mcqdWFxUNC7SVi5dKsyaCedc+hqXs3kUp82A8pKfIle5/om3Fu0vwUzwrsW77SrwD5lozIolxnnNN/TMT8IYjSS9k5Zpm2331Mb7UacEd1XZ4lnpYuKOmPwatcgbaj/ihpAzJvIPlmcw/Csx2OHhaKpbTGmeYZrHMDrIFfdco+JxyG0UaqK9zYE1AJ3vfwjX2FKtfG4s7YxlbzkLui0xyKc=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d14050b-f51e-4fd5-fd92-08d7eab0a244
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:05.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2GEOGWkHymZdAzG7ae1oOb1ECwAQJ3+lH1eImD/lkz7LxBcIeFhhQtK/frfAfgUhFFr5NNJ6QqA5wV5cKlubA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB0aGUgZHJpdmVyIHJlY2VpdmUgYW4gZXJyb3IgaW5kaWNhdGlvbiwgaXQgbWVhbnMgdGhlIGNo
aXAgd29uJ3QKYW5zd2VyIHRvIGFueSBjb21tYW5kIGFueW1vcmUuIFRoZXJlZm9yZSwgbWFyayB0
aGUgY2hpcCBmcm96ZW4gd2hlbiBpdApoYXBwZW5zIChhcyB3aGVuIHRoZSBkcml2ZXIgcmVjZWl2
ZSBhbiBleGNlcHRpb24gaW5kaWNhdGlvbikuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfcnguYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3J4LmMKaW5kZXggYjU2MTM4ZmVmMGJiLi42ZGJlMjg5YTM2OGYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYwpAQCAtMjc2LDYgKzI3Niw3IEBAIHN0YXRpYyBpbnQgaGlmX2Vycm9yX2luZGljYXRpb24o
c3RydWN0IHdmeF9kZXYgKndkZXYsCiAJCQlib2R5LT50eXBlKTsKIAkJYnJlYWs7CiAJfQorCXdk
ZXYtPmNoaXBfZnJvemVuID0gdHJ1ZTsKIAlyZXR1cm4gMDsKIH0KIAotLSAKMi4yNi4xCgo=
