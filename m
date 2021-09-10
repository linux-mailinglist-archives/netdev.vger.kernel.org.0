Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AEF406EEF
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhIJQJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:21 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:58752
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229682AbhIJQIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlAiNE2CCPS6dduMVvtj0Hg4brQKpkak5uhOs3FFJkJSe1ok7gvc2sG1hIlrsbrzGJlsGvZ/vitkL3PTTLMhWeveO0TspbNjrx/EoeY5yu8/bkiI04cPv2zlbDf3yBdvs33E5HnZgcm5tEdBwSKmGIBw8CsknahZhEAdvcUaJ5odlBSAIa56vfhGGsLCH7JhqkMw9i6HAmHkguhHD3nfgS9yTHpvkQIuQFYJ/Z9n+mwhv6K7tCLXRwWEorGwmoelfhSBzpJR2+/FxrgMvpn6GWy4CAWSBGb4qotv8XKlqmt1f9p5W9SBcwC36vvaxHuZxLKxZzH0ITF9/Ur+5ZnvIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=A18LMnOuxb9qak/i7j4FnpOPO3I3PNxrXWqfHesfWhU=;
 b=ke8laFruT92bwK7FCA7/yQjjkzMz3X+0h/QJYy1dgUInLrBEs4IjoJ0TLYNOY/zw2ci6ZWJVDYmcThdYx2u5qd3Ml8BgLgz62NfnV4HJtpmQqXEjdpFgiWXJ/FWsXjpoCIjnYsNP1YinVFS3WcHCJbZrY+4B5WTIDrueDahtvMdBrTkNH/dQ5umdXp772uEHHbBN7z53xxUY9O45SBhnNmusYamw1f3BVW7eqJMxmKWYEuigSGA7PbFplnwRoN2FD9/u3iy+anDcVSOXiAA/Yi/0XpQsslwvLBXLRlJSaovxZVGbFoFRoKYgWnaWiTUlIuiOtShu7mOHViXkyG6ZvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A18LMnOuxb9qak/i7j4FnpOPO3I3PNxrXWqfHesfWhU=;
 b=Iwy81M+5hC5ktpoqwunxLG/WtnFDpz+UYbwS9Mp51d6IMN5gDgLogKZT4LwkIWDDGZEXUB2eEoIdeZYijfllHtnYjRPHgggmh7k+hRIXLkoVL8/qu7XOO4Wlj3ApJt+TBoVxYcXYx+W19YNaP4TVf27Ios7npTWZqYXHMIdLfMw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:52 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:52 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/31] staging: wfx: fix support for CSA
Date:   Fri, 10 Sep 2021 18:04:43 +0200
Message-Id: <20210910160504.1794332-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 439380e2-1337-47ad-63bb-08d97474dcbc
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB31183D6A4BEB406F6209F08993D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LvJAr5BK2gItl7nu+rM3OgRyWPs2aJo8opXbKQMdSC4LbTcm0PNyUpQ76zBj6Fuuy+jhZAxO4Qt5tvhoWg/qNozu09TWsTU0Sqh+cDOz43jnXkvWUffZxXVc4PzqBgTSpPXMipp4o8zL+hAz4QuatQayOEII/kPw5Kja+IxHEs6awLOMe8eN1XCFX8xJslyeUUBASskRrL9VncR5D2HMk8NzrtHcN2qqe13hWCL92hewlg6xq0Psc4pSJg7e0SM6izzO13cF4D7UsgmUR1YvUNMFFrmiCM11oFQ3XWsIWdIAl+XWVhtrGiwLBACRsJG5cF4ETA5FrPOoS2dOxKetr/Y0vtNfTxWpyMznK+qogdkCCDb6bB5SVEBHi1533o8QrUhMsH+1ThBrhRwW6xAjk1cddRHmXehLMURNHg51HgNEBM3K5LtusDZirtqqInzH7rAk4WEgWXcLY6bHZybLzAjWbUl9XzCBpmNrB/Du9l2i5g+BflQHVXqP1e3YaKTuMM2z5iA1Qp0JXXw//ZHDasXydjgrmpsdBBd2U8X3xtpXywkqXprrhaEwnyAbo+Vs1ydr2NzWbrQjM+qTjuTmbAYLtsHcdJ9Y+eU8dIqlo/Y93jAbLeCKClI9BrxkP68a2oqKa0lzg5mD6sakRfEalg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em0rRkdsQmlPSGRDZlRIUENKdHk3OTdhY2ZEV3NjaXNzVURWVWhaMG1KdDRD?=
 =?utf-8?B?cmNhTU54bVpvQnNTL3Z0Rk5FVThVOTBSQ3I4UnFHNFFMaTJzNnZhUzhwdXQw?=
 =?utf-8?B?S25BQ29aTHl5djhpN2FSb1BpMWZ4V3YxTTVDUUNDaU4rZDRqZ0lIQS9GSVNa?=
 =?utf-8?B?ZGgzdEhXMHk1S3N3UEYvdUs3WCt0N2YveXI3bTFVS2NOQnlCZlVDVWVsUXRO?=
 =?utf-8?B?ODFRTDRpcEk2RUhjRFNuU3FkUzMzSXZvVFN1SVhybGZpREd2NlFiUEd1L09F?=
 =?utf-8?B?QnVpSVF2anF4M1ZjbWN1bXJ2Y0g2blJpRzIzQklkaUh1TEp2MXRwR2FYMnVP?=
 =?utf-8?B?bHVWUlVkbEp0SU93VlgxalhjS05UUE9rNWt1SXNKUHhDQjRIMTgxbUp2N3M2?=
 =?utf-8?B?ay9XVkV4U0tYRWh3azNBZ1dxVTNJNC9vWnRZZlBwMzNSQjVwY0ZjdXJRZ0Rq?=
 =?utf-8?B?MjhaNko1UlJPZHEyeDkvUDJwZnFYZGhMUmRSVlZXaWxaMWJPY2daZ0tNWXZU?=
 =?utf-8?B?TkZFc2JXWVliVWUvYUs2WnFvM2V6YjIrbk9MMjRYSWVBSE9YZUxnbmQxOXo4?=
 =?utf-8?B?Y1ora0RiYzVxSXVublBEMUQ0L3hsM2UrMTA1QkFwcE1wUGNGVFlVSldyVXZi?=
 =?utf-8?B?cVMxUDJiWmx2T3d4T25xS2pPY2thS2x1UG43YjdiYkl0VzExWWhMTVlCaWF5?=
 =?utf-8?B?UDBvZktBYmt0dmFObFRLWDdkYUxMYzBNd20vZlM2Z1lrYXRnSU13aCtWS3FZ?=
 =?utf-8?B?dXFtYVQxTVZFWm15eitpSVJFcnNNS3hBQWF1TDVDYndaOHlxekRteU1SVmgz?=
 =?utf-8?B?Ym4vb05HQmxtN0ExTHBkZGZqdVhsVjZlTmZLM2lPYXZJWkxYU2NmdFpQbWNv?=
 =?utf-8?B?SE5aQTlSWnJ4OVZ6cXp6M3RTWTRxY1BFdjhlMnRwT0lDM3RkUVVodTUrd0JY?=
 =?utf-8?B?a3duMmVLeFRBR3MwZjUxeVNvc3FLaHVlTW45OEJlaC9PdTdSc0VTSW40Tldm?=
 =?utf-8?B?bVdLL2dBOE1Wdks4Zld5anhZV0JGdUoweEZleGhuMkJKUmthNmxSUTdnaExo?=
 =?utf-8?B?ZWZ0b2xNTjdkYm9lZFluN3JLUkxiQ0ltblJ2b3JCa2ZpT3JOeGxCM2gwZ29L?=
 =?utf-8?B?MG5PT1NLOFprcU9Zc1BNWXZHTFQ1cWRZOW11VGR3Q0pRVkt2Q0NqcVN5UWlz?=
 =?utf-8?B?YS9Wc3A2MW9Wb1JTMVphcG03UVpidmtRbWdZUkVTd2xwVk5RWjNFSlZzQ1RX?=
 =?utf-8?B?ZEN1R0lZQWtqWGV6U1R2MnV4OWxiVG5obksycGR2QUo5MXNPeGRyZFFsUGN1?=
 =?utf-8?B?dWk1YWI5UXAwdnJ3dU9SZVhrUDVlcU4rM2JHN3FPL1FjOXFpMlFCMnNDMVhu?=
 =?utf-8?B?NlF0a3NJcDFobzBsQWV3cGI4L0FmRzlpdU1EUXFDamR5bkFiS0dYMFozQVJP?=
 =?utf-8?B?M2lxV3NtWDNZZlk0N1NMT2FpdEs5VGJVN0RWWHJXVzBUTlpIMEo0RDBNUGUx?=
 =?utf-8?B?eFV6QnJNTmU0VDZFc053Qks3ZXVGa3Rldkk0SEI4TlRqQmNvSlpBbHAycnZw?=
 =?utf-8?B?azZHd2NOeG5LS1h3NXZsSFVwcVF3UnMzRkFmRldqT0k3bFFqNldURnphcnpS?=
 =?utf-8?B?d2Jic0R3ZnpIS0pDdmUxOWFpQ2lobGxwV0JmM0VJUy9GTlVwQzI0YzlGa2l2?=
 =?utf-8?B?TWZoQWZBNUZlY0drNGNyUk54ZGt6R2pFODF3M3QxWnRQejlzVDNialQ4bi8r?=
 =?utf-8?B?Q3M0RERqbTVaVnVOOU5kRlNTTFA1QnA4R0tQSjF4c0ZiM1RLNDRueXd2U09w?=
 =?utf-8?B?dDI3NGpwWVYzYkJtRVREUzdSalg2MmpncmduTlBTL1JrcC9yZTdINE5odGdU?=
 =?utf-8?Q?AkEOJm4WghPQo?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439380e2-1337-47ad-63bb-08d97474dcbc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:52.0336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PrEpHI64pzkXRRkGRSF2gvT4tQ1+DQPFT0ttDrBt06ofXRMd1t30CWkO+2o7xs5mzY5Evb/m4/Kmb3qIK+n1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
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
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA1ODQ0NmY3OGQ2NDguLjQ2
NGE2N2E5YjQxYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9k
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
