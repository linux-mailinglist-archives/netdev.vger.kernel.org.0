Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12AE67DE34
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjA0HF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjA0HF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:05:27 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D738610DA
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:05:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hw0Sc1wLuYsjXx6mKjtdY6Etwd2tErbp/Wr/ka/hGMvbGWGyD282W5uBjhfJTx7wb/WKsy+X73BGW0ZYZInNyPD7QzYV08U9PbkkrOPI4WLPdDJIybzedau9qHJ0ccYaZY5Ea0J6oxo2ik1FyT+UQuPCaiGdSog6OaF/jd0uQCxq7PdE4JyakXLBswBgZRwbZLr/EkyHxJlQzXdW2SimzXkKrmI+xtAIRqB94HXyt/BB4lk39xn1DB1L6mqNDclKIopGrLX5U/fdoZH0b87d+qDHacHG0Qv/5y9QOBDpFvygD1nKkI+5Lz2AeD8LDapCSho/jU5qVZ/Fuvalbl0gYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NeaU9thWA22SHszI/tKMp0UoBRMlZxZUa7opvU34qcg=;
 b=NGpBf/srnW3gw6SmKjGgrAqWDS51f4wwBen5qkDCoJnhSXX03U+keBR3S7xmEzizJZlYH5BYam9uGW2L83H2E5sRepg3tSkjkCkBlYw1iqeQ8DdLh75EP6JSQbRe9v6w8qeaT9+RKEeQb5O6RG89+3oe5bntW1RR59n4JR37etV81a4FPQpFsgVdoVV4xvYORn/szd5wBhIsURKR7DzTzR4iogEqX1WhAL5c5EQdooxKKTFO/1m8uw4UBppw8+Cx/ws56tBynigBdodHqqRdch3cPYAQ6Noy7htVp24ljSDfKflCTKTa3o/hLt9GTxa3ncCvufd2dYkmYQnNLWp2Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeaU9thWA22SHszI/tKMp0UoBRMlZxZUa7opvU34qcg=;
 b=S3vQ+T13lOL5rMHrlGNoODjOCTqTomIxd+3nuS9TYgEAq6XreB15BO0m7y3e+CQUGbJNRnaZtwO2i8AQ7OGJJ7w5FmXTS5O1mvJ+q37O5uJJnyRJ3p9TR7mFaFC5XzA93+dQFb3GI+sgOItayr19jA5/XpWo2dBDemHcAHMMaw8=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by SJ0PR12MB8116.namprd12.prod.outlook.com (2603:10b6:a03:4ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 07:05:23 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 07:05:23 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZMEOP60oqKn0V2kaxC8rrlWCMhK6wxVUAgAAnRYCAAO5RgA==
Date:   Fri, 27 Jan 2023 07:05:23 +0000
Message-ID: <3D2AA975-AB07-46F8-A0C7-A1849E2E8664@amd.com>
References: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
 <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
 <2d7dfc88-df55-8aec-5d23-5e8bae05fa77@amd.com>
 <20230126085225.56589846@kernel.org>
In-Reply-To: <20230126085225.56589846@kernel.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|SJ0PR12MB8116:EE_
x-ms-office365-filtering-correlation-id: 58a905f7-91f5-4ad6-ca2f-08db0034dc3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5uO0Z4nSgD4t33CiGOlaS2SPwnOGc+PsWBchRVeD0ZJtincLsDxEr5sjDt0zXyu91OI8ICuvJRD6H6N3LbyLuh0QhlzDKgrCW3bpolC4LfNHA6fhxxgv1OHAjRjhrZSNe44s2liUKhcn4Y9qv5ist0A+riOqyTtk2ojB1XPVgaLroq7bI6uSP27SBSbD6Ku9KEtX799PHc2K+Zj9xevxFm3b7oebyKlnVeg5w+dujSRTEpWR0AfBg/2y6wpOTRVA8lxog76CcZnnm8HKEeVWECQVBoHHyIQ/PGUoMHxYsjBqdrczHz6JVgXa5/hUA1HaXyLCuA+LRS7cnGwCseNY//FVlW1t84tSB+7y6BtejGOOUygbgFMFKxQ7mB1sLnd8y4k5LPSVObQvpZEuv25XgM4xF2W4GQYSXj4TJFNTgI54UN6GknG/IwUCF/npjO34hHUmQyXVlafdvO2Zb/65FgtNVk2fTZMzl/028JbX60pPDBI4RDsWcXIEEaq0ZbRhF11tZmdZ2wAsY7wywenaePE9BdB73ce15rZoEJ+jAKIe7m/HEYeUqB3lU3AD7uFBh3mYEQtpl6A9x9tYdcUXxaXkZ3ZsDprCw4Jd9clOMo9CNgyV3ljnUxiTQs2rimgygyvOpWA9TzYF29yx3kIonF9RJhm5mzh/P0N92cB7GYzfpZnTS/YFyvRqkDw24Ovml11gTdS6mzZ3KczuD+rqnzB0vFZh8yxjVode1GHsa6g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199018)(2906002)(2616005)(38100700002)(33656002)(41300700001)(71200400001)(122000001)(186003)(36756003)(5660300002)(6512007)(6506007)(26005)(316002)(8676002)(86362001)(66476007)(54906003)(8936002)(6486002)(478600001)(66556008)(4744005)(66446008)(66946007)(91956017)(38070700005)(64756008)(76116006)(6916009)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTJRWTh4SnduTEJaclFIS2t1bTBHSEhrSnF1U0xhY21ZSVBkOFB6T2VKQ2Yr?=
 =?utf-8?B?WWNMM2R2dndoOUlNdXJ3TjIzRlV1SnhYL2thVVV0Tkg5djM2MXprTisyU21G?=
 =?utf-8?B?VVBCQk1OQlkvK1lMT0VrenNsR0YxTEFpOTNqSFhrb3NvbTB0d3pMT0tXRnVq?=
 =?utf-8?B?dUdwYlFzWW1YdHlpeS9QYmdhUkJFcWFDNXZaelNFWkZZL2NhT3ZnRE9oR2hN?=
 =?utf-8?B?RENXWUpZeXZDditBalpMUWdiRlVTeVYvWU5jL1JJOTRkQmp3YjJTKzZ4dkxy?=
 =?utf-8?B?aWhtMTVsV093ZXZucTVkQkxkREJIQzBYRjlOQkpqdENMOERiZTQ1Qno0VUZT?=
 =?utf-8?B?MjZwTS9xVlZVcUlQbFBPaDBONTdLQ2ZjQXYzU0t3ckY1TVRscVBMNE96MzZP?=
 =?utf-8?B?TVZtRUhzcExtVWM0QktiMVdFMFc1ckpXLytzNHZJR2lTZnRTNUpFdmowSDJk?=
 =?utf-8?B?UzBTYXBQMVMzT0g3eEY1NTBDZ0s0dUpGQmZhR0JtNEVScGMxcFhCQ2tsZWNW?=
 =?utf-8?B?UFFxcURiRkNCZ3Z4bzRRYno4cG5qdHdnOW9tdFBsNFFabEhYbDNzZ2NzQjhE?=
 =?utf-8?B?MlAxa2Rvc1NQNWpGMzlsam5sTW80RWhQVXJRcjFpR2VOeUg4NllmU3hmaWRU?=
 =?utf-8?B?MEFEVDZUYWlIa1IvUmVBSDJwTTdSYjdVUEdJRVY3Um00ZE5VMlBKcWgvSHBD?=
 =?utf-8?B?NmphYzNFQWpZMmJteWliYm5oZVJhODB1cStVSzB3RDB6b21LMjJEanN1ZUZK?=
 =?utf-8?B?YmloK1VLZjJWVVpkQ2VOV2p3aG9QQTRLemtKcUdKb2dteFowbUx6ZngwSm4x?=
 =?utf-8?B?WjgrTmpxbzRiUlREUFFDYnNWMTU4TWtjNUQ5VDBIZU04VTY0dVpoU1lHMWdR?=
 =?utf-8?B?SE1scEtuS0lPZS9nTHdmeWY5a3M1aFZFcVNuZUY1Sy9LZWNPT09EVytiUkYy?=
 =?utf-8?B?RHhoMEJpREdxc01GQmRFS2x5KzlnWmRqaXRsdW00M3pWUzhvb1ZnNWYxRm1w?=
 =?utf-8?B?NHFwUWhTKzFLRGt2YzYwRy9WaWV1c3JBM1c3c0VwZngrT2xoZ0NSZ2p5QVRH?=
 =?utf-8?B?RnFYalNDTG5ZMzlrTGt4WnhxRDQ0M0toeElZTk1Vc2hTc29qVHF4NStIZjVO?=
 =?utf-8?B?UnIxVHJ4S2YwTmVLeGNoeWJaQlNzZEpSYTJNWXg1WXRWYzNsWm9ZdFk5Z0J0?=
 =?utf-8?B?Q3F6bzBuUUNCNFN3OTdEclRjOU9YNENsSHhKQytEVlZiaE1NQXhKVjQrN1h6?=
 =?utf-8?B?Z2J4TVNBUXZHWGxBeWYyMUZsbUd5NkRldkZiYjN4bGNnVGNsU3hWYW04R2J6?=
 =?utf-8?B?ZHpsZnNBaTJNTEU3YUplN1JFM1FSZ1dQcm9MNzRoMlptQTZ3L1ZpZkcwd3hj?=
 =?utf-8?B?K2pnUHcrOURmYU1uYUIzcGhmTXNocGJmSzhUYndOWXNZWFZWcHVJU2xUd3hC?=
 =?utf-8?B?UE5KaEVzZUdBNkd0WnBmQk0ydFpZbkkxQVRteWlYeVJ6aU9CWDlYNi9VSk5k?=
 =?utf-8?B?cG0zVTJ6bGFDRDFhanZJaW9pbnBZRURYRURNRGVFMkJ4emJ4a2tpL3JBeGJZ?=
 =?utf-8?B?eVRXTDM3WlRBdUdmbkowRFZoalRWTVlUWHBHTmlCdkNmUlZzTmdkeHRUTHpG?=
 =?utf-8?B?Wk1oZnR1d1VIL2dhZ1Y1UzNGTHZCNHRHaE1DOXlhcmh0TW5iVEdwT2lsQ0ls?=
 =?utf-8?B?Zjd0RXBONXNTU2cyRWM2cnlrZnJwbXJQQm04Tmh3WjBPcjJQYk1zbS9PMjFW?=
 =?utf-8?B?ak1JRlBHb1Jra1lyQWhmNkZZSk95WjJjekZXbG04UnRRWW1RWGROWXdmTHJz?=
 =?utf-8?B?dnhqN3pQeWk2b25MRXRWcGo0OFkxTXB5cU9IaTZmRnVkMFU5ZUpVMlFtRjlw?=
 =?utf-8?B?TW80ZFpaOXMzeXFDRHFSRmR6T3F0bE03ejIxbk8vejVCTENXN1FpMlVXNnRJ?=
 =?utf-8?B?R1dkRFBjYWpweW5yT2VCdkVGczFXMmlCUlpMVW5Dd3ZaekJiL3BybDRlTWNW?=
 =?utf-8?B?VWtabTBRcDhvRWxhUExnTVJ5d3c4THl4RGYzbHJJU0VvU214T1FGRWUrbXo0?=
 =?utf-8?B?TnRqM3Fnb0NuOUNNWi84c0g3TkpKWFJ2djR3cWtQYWx5M3duci9acnZ0cVRi?=
 =?utf-8?Q?cFs5mdKgx1eiy81S1MVCtanfh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76659575764FB2458BECE70D4A611034@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a905f7-91f5-4ad6-ca2f-08db0034dc3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2023 07:05:23.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKxfs7FmpYFP2VYd/nZyjMR+uOnPWZIdjmNEIQhj9BBXis6M9aNyidM+1XioZNblF+KasDKk76v4thyWF3iSPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8116
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSdsbCBkbyB0aGF0IHRoZW4uDQoNClRoYW5rcw0KDQrvu79PbiAyNi8wMS8yMDIzLCAxNzo1Miwg
Ikpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwub3JnPiB3cm90ZToNCg0KICAgIE9uIFRodSwg
MjYgSmFuIDIwMjMgMTQ6MzI6MTUgKzAwMDAgTHVjZXJvIFBhbGF1LCBBbGVqYW5kcm8gd3JvdGU6
DQogICAgPiBBZnRlciBzcGxpdHRpbmcgdXAgdGhpcyBmdW5jdGlvbiBvZmZzZXQgdmFyaWFibGUg
aXMgbm90IG5lZWRlZC91c2VkIHNvIA0KICAgID4gcGF0Y2h3b3JrIHJlcG9ydHMgdGhpcyBhcyBl
cnJvci4NCiAgICA+IA0KICAgID4gU2hvdWxkIEkgc2VuZCBhIHYzIHdpdGggdGhpcyBmaXggb3Ig
YmV0dGVyIHRvIHdhaWwgdW50aWwgc29tZSByZXZpZXcgaXMgDQogICAgPiBkb25lPw0KDQogICAg
SSdkIHBvc3QgdGhlIHYzIC0gaXQncyBiZWVuIG92ZXIgYSBkYXkgYW5kIHBlb3BsZSBkZS1wcmlv
cml0aXplIGFueXRoaW5nDQogICAgdGhhdCBnb3QgYSBidWlsZCBib3QgcmVzcG9uc2UuDQoNCg==
