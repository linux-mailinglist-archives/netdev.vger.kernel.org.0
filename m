Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C099440870A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbhIMIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:36:31 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:60019
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238170AbhIMIdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZ142NnM5e1S4h2TwZQFyNAOZjpnnQn9o/waEu/oWYszjFI/4uYrznUzdNXdqqq4IlPc+XswY4bTcL3LOrK827cSO1tZIRZSAPHdbo9vsuQeoFbiZjH/9gSIVySnwuqIXhU0fcf/JnuWlwGDkn1+fYXhbSQGpWRkU+E4hdHnsPMo+0mUuUKEoxEFNjfWTUZOaXhOQHEv7ZpPe5a51dIVwK68MS3lVocPf+PyH9uipiV5veXxYSKDyMsKP13Nh1jvwrWSFqdGKKOMEYvZ+XjOrf1Fk/BRZd/whHwwLyU6Poman0+4c0zVgcx6HSke6pAabX+rSYe8N+L1rnBqIq613w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=C31iDdiNELeUy/7hAICgB5wTgF2daKvEZIoAcBSDHBI=;
 b=kjm6VQMqHwcfyoymZEOtljy9InkbFUdjyQIhePOQ7Y+H4pupbNCfXyLIS6BCv1te7VKoJADryrqfwiGPfcvcSlehvtA8QD3ujnKmH2f5WoAIMP36PdiXHG0hXqMOOKj6jO0uZlgMqzbootkYCaNWu8ZDX1oao5wRtSZH/8ijp+xyLcqhfBpLT90ogG5HOgh6oc5rYg2XqOGeG/ZzXOK1Pgr8MoAmQdOlTl8/pPaZhiVBgWGHY3QHnydaEejfODSJKqQxCrOT7dGtAE5kC2EGRJj1o+y6RdLoixiIJsbElJSgNlISpIHiW76OZp4Zp2o8CoEDUzATe1yLeXzV745cQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C31iDdiNELeUy/7hAICgB5wTgF2daKvEZIoAcBSDHBI=;
 b=ez7+CbSMDPFfks92+nqxlwnOcShaemdORDKquiMpY7y9J45f87PKUpzccQzSGk4aODvLWHbWweTpaS+8AfN/GW1TxcShx+jvqNGGKZyQj73M9s9u6L96+/eR5ZjgCOdBznr4zP/l9XWXthNOL4f5eVqQZMlkmuf/RSolbP2U5MU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:48 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 10/33] staging: wfx: fix support for CSA
Date:   Mon, 13 Sep 2021 10:30:22 +0200
Message-Id: <20210913083045.1881321-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82b7b09d-97ae-433e-7f2c-08d97690dde7
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263A40F10F6CD72BD766F2F93D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CB0UYnHnw3JQ+X0NZS+C5TufdRx1+SJ5Sh7wq0DK4XuBMaHMRNqWTvrPnsXzOvHEr1E6aZa/Ai6mEC6jcmnYLdrvUHKjBZQBet1caHtKZiYZoWwPMZyGbVLF6apQmv7dohLoKT2bNR9hfQyspwjjZbGzvrH2KL979ECYGp18xqCqenQo2LVecJWSbaoCp4odQAClRG0y/Akb6xta/FebjhBn2IOpb8s8zpmg074eorGCYJ2grpALPWF5tj5iPdIYnRxnGlREUSdzvBxKzkShhNjpcXiQ9yrrz5CUDzYgWd0DWflP27XK5JJu4+C57eVOcNrasbU5ngew9Vp0/mcZPuErkYEzlidt4Rn2U+g27zUsTT+jLPmC2kVTXjQrXjQGHWcwA8weV/FYkjY8ZRU/KerQw0EFCR/NAm82u/MvvPSlxNaBLT5Z/w6Ftz+nGYV/QOJ0eS/hRVgULl/aIAWrnsxK3WEd1GCduPNoqSUbwHyQ2uA5+UmzUHhthy8inwDT9f2OL3FVZaNQfnMMUAygybTgT0ldSA6Kur+s5VFknOCge8xgLYGuvVPWgobB5eiVV2vrROrH7cJEUIgcBzhBB9URaZBdhvYfvYEsBQbfYVjGQwzVECb6lenB9v3I+9K4WfTrqRBTiJQT3irF3fqkKpRUsTnVdI6c32r+8S/NMBYYQBbYfpy8vubvEIqC8rDFPYqBmQi1mBjlk9U7ok3zqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MENtNE5VYlhIZ2xORG9UYm9ML3V2Q0UxQVBEeS9SWHppRFRDSVlWMTVtNWhU?=
 =?utf-8?B?VE9XMjdFZUNsT0cza2hKUFVjcnFubmxaSVNaeVo1RllZSk9pa3JUeTVldVFB?=
 =?utf-8?B?QkdrWnZ2Z2JKUGdHQ0c5cDFZcVp1T1V1ZE5XZWQvY0VRWXpxYk00QVlPS3lY?=
 =?utf-8?B?dUZLZWFVcm0zOFFzUnZoTDM0NDJ4YnY2QU50YW9teFdFV09waDZ6b3pOOVB2?=
 =?utf-8?B?RXhORWFPWXlmbHY5V1NiUkZnRnJjcW5iMjNrbWhtVDIzbjduK1FYZWxsejRn?=
 =?utf-8?B?Qkt2NGRyWGNvbFJkS1FFdXBqYWduWjgxQkNzNUV6dVdoSjZQTmY1SUNZZ1JL?=
 =?utf-8?B?RlMxOTlHaVc4TmdITGM5ODFiS1U0TTJ4ejhjdVpSR2l2OWRUZjhpT1Azdkxu?=
 =?utf-8?B?S0tCYnVxcWVudDR5OFgwMXA1MitaS2VBcnZzVkRMaDdzSWlJQWhPSHpEZyt1?=
 =?utf-8?B?bUo0VVVnMHRTNjdEK0I2aXUwbFh6Nmc1c3ZOcDZ2czdGVzlFWEdqVmZiSnR3?=
 =?utf-8?B?ZUhGK29PaktyQnhwWDZGZTVkd3l4SmZWcC9ya1FlbFJSelFiVEFrU2FiK1Bo?=
 =?utf-8?B?RnlCcWRlMzZZVklKT0JuTXQ4UkgxcytFb3U2SWdqUWhYN3RZdjF5c09RTkR3?=
 =?utf-8?B?cnVaNWNrN1hGRTlFWUhmSGxrNmxRRWhWMU9DY21ZakpVNEdWdXUrbUtDcDFQ?=
 =?utf-8?B?UjgvS3FsRFZXRXdoS1BLSVdzMWUrYzRiNjNxdmRWUU5qMk9aVDhnZ2REZFRy?=
 =?utf-8?B?dys1NzluYy93Nk1Nbjh2aDMxVWtKaHFpS1E1U01qSGhTbDk5MjFWblJDWW1D?=
 =?utf-8?B?VTNrazVTUzVoMi8vRnNicEprd2hzaVdmRERWMXZUOFJIeVh3cXNNQ3FmTXRR?=
 =?utf-8?B?U1NuSEFBVVRHaVdBRkxFS2hXOHhMUW9vZjU0bXVCdXNKdGdLOGFQeGI4TGVG?=
 =?utf-8?B?WUVPRzlEZ0Z0ZXBVaTNkN3NtYVFLTmFQYnBGc2l2Z3g0M2hDdWtQNVZqWllJ?=
 =?utf-8?B?YUQ1WnpsbXMyaVNiRFd6d3lqNkNPcnZZMTJPanQvbG9UYk12ZEhMV1Q3aFk4?=
 =?utf-8?B?dlZpb0p3NGo1MFRpTkpEYmJWMkFWSURrRnIrcnpFa045eFZuWUJpaDFOb2xR?=
 =?utf-8?B?dkRCZTdLOTA0MkdzQVFKcVRGVEdUU2tqR3o5UmFpZ3B3Wnd4SGMrbiswbzI1?=
 =?utf-8?B?dXBvcWcwU0tGeE10Zm8rTjZWZERHTG45NVVReFF4MWNnbWdFcGZHNzRybFQ3?=
 =?utf-8?B?eXNRSDhVb005cVVscVI4cnlpRnA4c1MvSDEyZkZQNWRNSDh6TlQzU0U3V1Rl?=
 =?utf-8?B?NFVjbm9QYWV1VGVBVFlYYWtUZnBmemRGRWhEZjEvRHpYYUdzVVNHQmpwUEdz?=
 =?utf-8?B?cTRmZW5UYkI0ejQrcW84d0NFVlkwSnhhaUVqS3FaR0VqK3hUU1ZaQVFvMkVK?=
 =?utf-8?B?TXNsdXUyNmJhSnpraGNvdlU5SlZSTGtWMEJlMnNubUN4VUljbWx2N2Z0ckVk?=
 =?utf-8?B?UktNTmhPeFBpaTBGQi9PNi9yS3FaV0VVVU9pNzIwN2FGejQ3dHl3T3l1VHZO?=
 =?utf-8?B?UWR6RStLdTJLUEJ6S2VucWpyNzBzZ0IyKzQzUk8xNzRWWVh5ZHZHOXNTS0I2?=
 =?utf-8?B?Ty9peUptTnJoUkJFS3ZHNHRyVGEybFBxUHNGa3VxWjNXbmJWRDBuVGQzOXFk?=
 =?utf-8?B?Sm9MajVKRlNKcWhoN2NTUVR5NDhGMGxkbUI2QmlMV2NuTGpxY0RYWDZLUnFY?=
 =?utf-8?Q?FcG8/d8wDavL2tibsU/sfPax9acUKdC9HJVtvF3?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b7b09d-97ae-433e-7f2c-08d97690dde7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:22.1219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WKptL5anlJ3eMM7a3xM8cFWjpYaGDbpnIaH3OXa9MoeZU4+qSUa/lGWhFKWIFeyevMcoRBOqJb2BEE6zXjQzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IFdGMjAwIGlzIGFibGUgdG8gZmlsdGVyIGJlYWNvbnMuIEhvd2V2ZXIsIGl0IHVzZXMgYSBwb3Np
dGl2ZSBmaWx0ZXI6CmFueSBjaGFuZ2UgdG8gYW4gSUUgbm90IGxpc3RlZCB3b24ndCBiZSByZXBv
cnRlZC4KCkluIGN1cnJlbnQgY29kZSwgdGhlIGNoYW5nZXMgaW4gQ2hhbm5lbCBTd2l0Y2ggQW5u
b3VuY2VtZW50IChDU0EpIGFyZQpub3QgcmVwb3J0ZWQgdG8gdGhlIGhvc3QuIFRodXMsIGl0IGZp
eGVzIHRoZSBzdXBwb3J0IGZvciBDU0EgaW4gc3RhdGlvbgptb2RlLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgfCA3ICsrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhZmYwNTU5NjUzYmYuLjVm
MmY4OTAwY2U5OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC04MCwxMyArODAsMTggQEAgc3RhdGljIHZvaWQg
d2Z4X2ZpbHRlcl9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZmlsdGVyX2JlYWNv
bikKIAkJCS5oYXNfY2hhbmdlZCAgPSAxLAogCQkJLm5vX2xvbmdlciAgICA9IDEsCiAJCQkuaGFz
X2FwcGVhcmVkID0gMSwKKwkJfSwgeworCQkJLmllX2lkICAgICAgICA9IFdMQU5fRUlEX0NIQU5O
RUxfU1dJVENILAorCQkJLmhhc19jaGFuZ2VkICA9IDEsCisJCQkubm9fbG9uZ2VyICAgID0gMSwK
KwkJCS5oYXNfYXBwZWFyZWQgPSAxLAogCQl9CiAJfTsKIAogCWlmICghZmlsdGVyX2JlYWNvbikg
ewogCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIDAsIDEpOwogCX0gZWxzZSB7Ci0J
CWhpZl9zZXRfYmVhY29uX2ZpbHRlcl90YWJsZSh3dmlmLCAzLCBmaWx0ZXJfaWVzKTsKKwkJaGlm
X3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2aWYsIEFSUkFZX1NJWkUoZmlsdGVyX2llcyksIGZp
bHRlcl9pZXMpOwogCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIEhJRl9CRUFDT05f
RklMVEVSX0VOQUJMRSwgMCk7CiAJfQogfQotLSAKMi4zMy4wCgo=
