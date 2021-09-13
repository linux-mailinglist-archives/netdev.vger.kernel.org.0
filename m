Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F713408703
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhIMIgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:36:07 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:55755
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238190AbhIMIeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+tdtzAd2mFuhcwcpBUl+Yx3eLay8nHeERMrUB+V2YjPt2tcrRmjis8J9+bVr0t6TUeKWVQcZsenDmfmYNlct0FH9Ak4f8pt2YJhocT+FQ4f4R2U7CIztSkBDRrSRP7CJS3FcbBVj32TogzmKPKby0d8+bgr10WeJCq6GudshQNvZqVqdKMKGg9EPVodADwXsQeJkeHbMztThY9hsBxpAjPA9h4AeBHDnO5QEn7HaVE5vD3oj3UEihZ/97YCuZajYj6FeIOg21TK83eXwKvIzYnYyi+ewTFxLOu83GHF+LGVejxRtu9+/NRZA9ML42wW6lgYS+yPA3OXk2mTgFtTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=62Px7Pc9Wfa37Yp8kwwCsox0dv9QXvJNMbI8fHPQiLQ=;
 b=HjWid1f5pHPJRuDZHHNqEX0vZ/8YJlqrzuVlEZDhYt7v/pqJ3MxenQ2BTsoKeoy4Anf78Twh9AH5GOhmxT4WpeeERVwZxXY2xd2bH5u85UG3+6k2rPs39NDS7KLM2pp58976y5dXmWQy/Td36PtEKwpdo/7GLzJe/mN/mrXGauUKIoVhy8RyoXyGUTFK78D5rvnqjySuMiqBbek+zo4EmnFpU6OCHmqNogVVsHZVjuTuPvwysJw+ZIA7tMztx1cAMwiMjt/PrvS/aIPN9bGzg/rWua2WmOSFZ8JJiygeFxSqADCCxjX6MmpuWWd8Gwh0/U35+y2TPNIpOkr1uB5pGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62Px7Pc9Wfa37Yp8kwwCsox0dv9QXvJNMbI8fHPQiLQ=;
 b=ZyVyReZ1chk2SieeemPJQ31/JruwM5HRLOBoHypo2Idy0Xez83G6BDzvIlQdmEgzC16YEyfGJ37m4udpxIHG+2FVnfkmXM+7ptdG7se54eOX7Cye8vkjQ12gcWUNCjaFm3sU0O47fb47qIDZZ9A13za0MlESbQz0Xs/FjfbHFmk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:55 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:55 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 17/33] staging: wfx: simplify hif_join()
Date:   Mon, 13 Sep 2021 10:30:29 +0200
Message-Id: <20210913083045.1881321-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17359336-8c5b-454e-8355-08d97690e548
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263210471623E7543354DE493D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FhBSh4WxkL2hUFKHUjAN/mNQyi6JnqQufVfgar5zrsjz5E9y1lLyBGBHyntoDce1m404nXlZ9S/zCNgwnnpVBQ08vu/BBMZK4bwq6rN530qXHAs8TcVSP9gDfAmMwxFvHD6j/cpHcx7+8Ecwcc1q88Sn2XkJDSQIlLHxQIl5po56jxtlCSItb70SD9l5R1m3BSRXCGDRg7ACS21Yga3vv9X5JgW8XKPjfobs940TN/NZwS3eTNPfRQO0fRFl6pix9j5Pby8Z0ViAuLXzYwdvYHiW2XpA8TcqnfL0kFJD9TkjJcYyQcs13whPpYe1JdH7XqgEt27iTTAGSyiFKJ3IZhxKgEDYtBIQWKGI/gkcHN04CjXN1Z0xY8/tcesYlVTztaruplDAL9NUoQBjHPbJDCJJWef7P4zP93Ti9+wUL9/c8is+R8HGvk/ACsIp2ZTdZGoiWZeaw/A8abb7wEYLEDIrPxFSCwzeZoR5XnDpXw/OA25w3QoDUhY+t/cxraj95PqnIkwBf/t8Pxv/yQ+cIKPW7VfF7kuOyFZ810VsowYgh4yMmOs0vExIxFTn8bSm37w3/N2ZfCEyceqMiG21E6wkjWPECRBrZ3ycwk8wH5wN/s9l/FlfE6xSX6vO/8ac/rrHEtPf5Qevpj9q46vC0TlAQH0ORugFjoMyEM8j3fmlKq5IEMRDoL1YNAHz9NPvardIVBir6XFFqj0l3FXxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(4744005)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzVucHFUYUtzZUJ3ZGFZajNMOFd3ZktKajN4SWo0VWN1NTJONklxTWZYcU45?=
 =?utf-8?B?K0EzYW1scG1GbG85VmVBR2hhaEtFckFiWkF4dGd6RDlLVkdzK0VTb053M2Zm?=
 =?utf-8?B?SCtWV2dJSHl0NTFUKzBsZGVFSXFxZGRmelFPUTlVVXgwY25SNmljZHlRQ3VL?=
 =?utf-8?B?WHdZbEE3TEh3VXlla04vZkhvL1hiWjlpTVpiempHcVlLRFJMbG9HMVc2eXRy?=
 =?utf-8?B?OE5JVVlRSWNMNDdOaUt3d0ZuNk9yNDU0aElqODNhelVBcHYwdDlRRzZrUlI2?=
 =?utf-8?B?NFRJTVdnSDNzWHVEUmtvblJPcXhnd01ab29takZCa29Rd0t4Z3VyYzNzWHgv?=
 =?utf-8?B?cXhNQnA1NGdsRGFKUjU1OGlXeTVjMFk0TUwwNHFMLy9ETDlzd1JJY2hZVVp5?=
 =?utf-8?B?dE1CdWlIZWdNUHU5d1NCRWdjMXZpSVNsS1JWMEtEMGwwK05ycWlUUkRYVU1z?=
 =?utf-8?B?WFp4NFcvNDc4QWNQWXZBSENpUkwvMG5xSzl2QjBTNFN6SGlGNmpvMEFrMkFq?=
 =?utf-8?B?ME5sV1BmN1ltdzJQNUlEdFVmVE9RbVpIbHpMVmVkdGFwTW00K2RrMkdBZzN6?=
 =?utf-8?B?LzIxUm1abE9Cb0grdE1ZdVIwUkxWbkh3M3FQT1FKMG5makV0allheityeCth?=
 =?utf-8?B?dyttZk9QOXg0ZElHb1NPZWUreWFvdnVuY3d3d1JHUE1uTGNla2dTY1grODdn?=
 =?utf-8?B?TTJIcUJLTi9Ka2tMTVVxUkJWZHJ0ZmI5bGFDczZFL1VOMlZNMytNU3BGOVY2?=
 =?utf-8?B?NzR6UVpRbkJoQ3FDczBBWUZrVXdLOGR5WXRyR1U0MGUwbXNnek5NeVk5UHp0?=
 =?utf-8?B?eGhRNUxITDlDUldlTld3RDNBbE5kM1cxRHl4YVpMQU1GMXJWUCtudFZmR1Y0?=
 =?utf-8?B?R3RKUzFscGZCVEpHNTNjc25pOUJYc2l6My8vRzBRckRWQ3pyL245VHVUK2Fz?=
 =?utf-8?B?SnV3MzJ1OUdsblViM1ZRc2dCUlo1T0Zzanh2WGNlSlZSQ3R4M3VoQkZWNzdW?=
 =?utf-8?B?RnU3blRQUnBYd3pPWFhGR3BSZXRYUHBELzdVQ2FONXZCMklORCtHOEI4ck1V?=
 =?utf-8?B?OEYyd0FCRjdleU9mYWwvTG1rK2FKZEJXNm0wMVFyTng2YkVWNHovNlRTS3pQ?=
 =?utf-8?B?ZzlROXZLV1JEUFI1dkJ5OWJwaElFVW5QN3crcU4xUDhnNjh5TW1YQ3ZPakwr?=
 =?utf-8?B?bDF3SUhCK1kyR2dYc3A3T3FYdWRQZGtFbjRhRXFrMGtqc1VwMFZ5RGIyVGVl?=
 =?utf-8?B?cWs0ODRvTDJDQ3hadXU2emZ2dzQrcTNYcDF5WEJwcWpMYnVQcVhHTW9mWmt6?=
 =?utf-8?B?cGl3TjRCbktNQXpQaGxZQ3VBSmNIUzh1L1VtaVFlcE9OWkVDRk5rbzBHeUlB?=
 =?utf-8?B?cTA1eGZrWlNYdXdFWm1xbDB5SDdqOHhpMnR1RVllbGgrNnM0Z01jUlBvOHlP?=
 =?utf-8?B?K2x1Tno3WmhrZFZnNEN0THBUV2xNcjJKY3JHeHdjSFZNdXZwd1NGbDhiU2s4?=
 =?utf-8?B?WDYwTTJuTDBWb21jek85NktodzMvT09VUHY5aXhvbERLUEVuRGZVQVFmYXdU?=
 =?utf-8?B?VEcxSUUwaXRBVGs3ek9wazVlc2d0MXdlN3Y4LzBOVzhWd1YvcVZHQ0tTNXNQ?=
 =?utf-8?B?Wlg5WkEyUEJKR2dveU5YeFpNMG5pMExoSVVHR3N5bzNXVTVMQ2hBSm8raGh0?=
 =?utf-8?B?TTZFTFpCcC9VYUhVUEVNQ2R5WFBtR2pONzVCeTdFb1Fsc1c1bFVyaGxqcFhr?=
 =?utf-8?Q?2fRRkUicHVFrKyb1cMeMtKNkrQIX2sNW8sLFmqM?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17359336-8c5b-454e-8355-08d97690e548
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:34.6367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +y7i/nbSx6JKFVod8ZMoKoKM9qUJ2ubUotPsu/77bOeuD8P0kNzFJkSDZmb0GB/MZYzwPZZn+oKJE9VLP0aOKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG5ldyBjb2RlIGlzIHNtYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguYyB8IDUgKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCA2ZmZiYWUzMjAyOGIuLmFlYTBlZDU1ZWRjNiAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC0zMDYsMTAgKzMwNiw3IEBAIGludCBoaWZfam9pbihzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiwK
IAkJcmV0dXJuIC1FTk9NRU07CiAJYm9keS0+aW5mcmFzdHJ1Y3R1cmVfYnNzX21vZGUgPSAhY29u
Zi0+aWJzc19qb2luZWQ7CiAJYm9keS0+c2hvcnRfcHJlYW1ibGUgPSBjb25mLT51c2Vfc2hvcnRf
cHJlYW1ibGU7Ci0JaWYgKGNoYW5uZWwtPmZsYWdzICYgSUVFRTgwMjExX0NIQU5fTk9fSVIpCi0J
CWJvZHktPnByb2JlX2Zvcl9qb2luID0gMDsKLQllbHNlCi0JCWJvZHktPnByb2JlX2Zvcl9qb2lu
ID0gMTsKKwlib2R5LT5wcm9iZV9mb3Jfam9pbiA9ICEoY2hhbm5lbC0+ZmxhZ3MgJiBJRUVFODAy
MTFfQ0hBTl9OT19JUik7CiAJYm9keS0+Y2hhbm5lbF9udW1iZXIgPSBjaGFubmVsLT5od192YWx1
ZTsKIAlib2R5LT5iZWFjb25faW50ZXJ2YWwgPSBjcHVfdG9fbGUzMihjb25mLT5iZWFjb25faW50
KTsKIAlib2R5LT5iYXNpY19yYXRlX3NldCA9Ci0tIAoyLjMzLjAKCg==
