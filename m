Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E7C6756BE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjATOQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjATOQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:16:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2698B77C
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:15:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKyj0lgf6PKDmOYW57z+p4edU/ynVeHnrkcBMj4OOCOHxo24/Gw7pBS0zcsRBo1HPk+JAVA0Srn1D3sMAqGjgjbhplEaTxjMj3m4S4g8cSIcm3mL2NGNF0EEiFqXU5tWZB6SqMEdlSILeyWBRMRTjqlRemaY+LqvkwvnIvB2N9Z4CmGirkgt7mRs4AXk8JWgsfs64NSCbX7zAd2u85X2iPclZpU/7hpUU8ovg2vdTv+YyMfM55jtXJkKBcJroSQ1kaN9XB4neXyVYHvWHyUxxPdHl94U0oUD5B7nqHL+4pYKS0V6AV5kMbSex2tMjM2d7snIpxRiv0pEteCaGWKFxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vn3g7fFVtLzqUcF0R77P/qNE0u9Dz+AWF5Kvad9o2Lg=;
 b=ezxUtNMIHXxYgQpXQJHnNFSeozN0TYb1dAwrT+uYBfQJLuqTxcR8D42im9dTJ5jkkIZIpTJf8nNz0FHVU4/f12egDVrmj20xDJb6hk3ELsqgrNJQh351O254vzN0LakhmOHfTGQN50VOgk0IEbjRSWFYZpUEkQfPmX+ELtVUU2b3ZpEr/L+bJdREua2w73PWyhavXHMQwKciM5yaW9ATSyyh44xWFkVaKQeMhy06kUUdNovnMAMDiqL6plpWbFA03x9I93jk6u6E4AZOPFv58Qlz8MbTDKvLI26CmFriuGoGXLoQ53TPGvht8ZMXd5476AO9banyDZyugtspbCV1dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vn3g7fFVtLzqUcF0R77P/qNE0u9Dz+AWF5Kvad9o2Lg=;
 b=gAt3bwLBj7ScKwicBThc04lYxWB2kXrC3phcCCYhbbROOvXDRA71GluRXTCWH2YqygnzEsM19ezBRdTh7Gm/kRUfEVm+duCDDw+tl2ssuDRuUsrltBNX7rT76uyelqBCkcBrbhKup/yRbpUPyvkDV+JuBy8WWEYiGyQQCjetm3A=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DS0PR12MB7900.namprd12.prod.outlook.com (2603:10b6:8:14e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 14:13:53 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6002.026; Fri, 20 Jan 2023
 14:13:53 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 2/7] sfc: enumerate mports in ef100
Thread-Topic: [PATCH net-next 2/7] sfc: enumerate mports in ef100
Thread-Index: AQHZK/m9AFDv8Y870UCltlQ1GqM4AK6maSeAgADxqgA=
Date:   Fri, 20 Jan 2023 14:13:53 +0000
Message-ID: <00dbd8c6-bcc4-87a7-bbfe-82613b4491e5@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-3-alejandro.lucero-palau@amd.com>
 <f6f38dc9-cea4-d328-3657-c48ce7feabb1@intel.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DS0PR12MB7900:EE_
x-ms-office365-filtering-correlation-id: 5886bb20-b1ef-420e-1a5d-08dafaf08f77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iLiFP0Ci4xtx9MwfxfG3Xe0kqjRk6j9hT71IeDiNVdAGquBE3/cwU+oT4DtSKPRIELiiK7IFSIug+4jDLMVUVyjl1G41JZsB71QQhqPAYq0L1DxCXGXhiAg36VKvh3cglUs9AOo324gUQR1nCXsQE869QxGrbwgs3Qz8WOZRxbKzlT3mWqFpsyVAJE2irRQWh498WEDdDUXp/tCq/tUVG1by7KGQT4eLW/rNrFNVxAwvEZsPALb3fuQgoYQmckK4CsWUufZhtuVuJsnK4CVIHbtqNdn0Du441GDLCWoGBV8DCPKG5OOG+DOb9WfjSJJkpG3E9KZNCcdoMXyhn+7dh9PsrYMoDpJatFO64Of2N/DcLr7LDL8Q7dd3AvFw6DLR5OJ9tO7XTkLZ1ViiYBsuGfOP2AnxqWkg2iVmVw09feuLJh6ar31Yz0+DvsLNBNtOzg65VVFiQ9O12ZFVveRk2Suqt0DWE2T4bDSVyZFNXIvbU+VjdUitilkOVc8UXB9d0WsYxd2e0DnZP5SmhEM+gZw2gk+//MTqxBuzoFhWFO4V4Upo1xD2NgEC8zach8SDXVL5piKunRtY2bieYYKoisdVkFN0veGKGW6Z1VTfLNfY7F38Czu0cR0P1B3iudALObuRm8Biz76DtrDA07usYlNJrnqvBe26eor8IxwX/2kHdNOxEul5gQ91evuqU01ABp8Lr9/9RiHn0v1kxZ772+zHcv88Bw3NugnVUoo6Kb0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199015)(4744005)(5660300002)(31686004)(8936002)(4326008)(66476007)(66556008)(66446008)(64756008)(8676002)(66946007)(91956017)(76116006)(71200400001)(38100700002)(31696002)(122000001)(6636002)(110136005)(26005)(186003)(2906002)(6506007)(6512007)(54906003)(6486002)(36756003)(478600001)(316002)(2616005)(53546011)(83380400001)(41300700001)(38070700005)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFkxem1COFlmbzdaSU4xbEJLMW1nOE01dVVWdEk5MFh5bEpyVkhUNjcvb0pF?=
 =?utf-8?B?MHAzMnljbmh3QTdYKzNCUkVONnAxTDV4akdSZkdLZWNZY1RLV0pFNXkvSUJk?=
 =?utf-8?B?Z0pwWTVpNTZFVWR1T3B2bk5QVVRxM0l0K0YrSVdyNWFWemttYXRIWGNhTHRu?=
 =?utf-8?B?aHY5K0hZYm1zb0pRRU1vbnlPL1RPYklwcWtqZWRsMnF4VkcwQ0FucmN3MTRB?=
 =?utf-8?B?OHZlUlBpVyt5ZlZTejQ5RE1IeG92VFQyK2ZHU2UvZEhwZ0t3YThsaVp1czZY?=
 =?utf-8?B?TkJsd3U4L0wrSU42MUd6TXZMd2lNYmpOUUt6YVhDSklNNHpiWDhPZkhEWFYr?=
 =?utf-8?B?SnBST05XZGp4cmxDUDNhSGRveVpWd1BldUdrNi9NUDdKT01ySkRmSHBWSjg2?=
 =?utf-8?B?eUc1ZXp3M0kvUFk3Q0JLNHhaYXRsdFMyQ3h2WGI2WG93RWVWMWMyL1FJMko3?=
 =?utf-8?B?VXhZQ2o2VURxVkNEaUpJZU80Z3M2TFNSODE4emRGcExiSDZ1M2IyWnJWaUY0?=
 =?utf-8?B?aGp1cWFLMk9sbGwrdGFpZnN3Q1F4am5tSnZWdWYxMXI4cjlxbTlScTAzdXgw?=
 =?utf-8?B?ZU9zT3h2cGFrSW8yb0RqYzBIOGRTa3lsajVKS0hVaFZWVDBaeTJpbHhueitz?=
 =?utf-8?B?U2R0REwzTTRjN29id0ZLa05xeFNTL3hDaHlPY2ZYTkp4TmxJMXdQaGJPUzlo?=
 =?utf-8?B?bVJYcDBjWGZ4SHFvVzk5TXlIemZXWXZxV1hmSzJJVlcvZys4NXpJWmFHVTZw?=
 =?utf-8?B?YUFtd0dLenlLai80QXR2b1lLY3NCK3ZseXYvekJuSzNELzI2RWRwZXVXei9H?=
 =?utf-8?B?YWVvdEl2Nk92TnBrQnRTOWhPUGF2SVlUeVVmMnF1bjUzUTY5MkdxNVMvUDNi?=
 =?utf-8?B?eCtrSEdyTGhuZTdNcHRPMmJ2clR1VU5Qd01leWVuSG83bDN4VjBDOVk5K1Zz?=
 =?utf-8?B?YzhvdGYxa3dXdFI0T1RRTkVtNi9aQ1E5S2ZHdnkzdlViYWkzMmE0eFRZU3lS?=
 =?utf-8?B?UUUrb3Bxc2FLMkdWQVFHTXdvdVhqMm1PU25QUUNNeUpvNEJUTlhYSzJkNzUv?=
 =?utf-8?B?ZEU5S25CMGMrK0VvaTRVckNDL0o2dGNtWmNKU291b0FEckpOZlZzZHNWYUtO?=
 =?utf-8?B?NjB0aTBPb2xCVzlJSFBLOFh1Nk5lOERPTEYrVE5sZkJLVjBYUGRJdFVNcnlY?=
 =?utf-8?B?dE1pZy8xdER1WmUwc1JaQ0cyN01ZUzBxdkFOMUtoT0JtbXdjSWtqYUtjU2xn?=
 =?utf-8?B?dmZ4VmdrYjE0dFYrazBJWkx6cStna2JRbWRTdHZVWm9YV1RqcG4yMkxXQ2ZI?=
 =?utf-8?B?RVdRUEw3VDFYSHZMbjZMQzhNZHUxb0JXdFJERXRoSTk3SGRtK2tQMVFWSXVv?=
 =?utf-8?B?UGIzMzRDZUpYN3dSdjE0eERiVUpSZDVjY1drcjBDcG9taFNlTW9OZ2tFWDVE?=
 =?utf-8?B?ZnRnT1Y4V01EcG9yL0o4UE9VdENVYW0rRTJMb3VTOTlDYzBCRlVuZ1V1VDZB?=
 =?utf-8?B?MktRcEZGQksvVnloZWhsUi9vaWpMeDh1M0JmbzdPbGlHTytYcU5MUzRIdldl?=
 =?utf-8?B?ZVdRQ0QxTVZCQzNmdTlnZTJtN1VTbkRZRU5yNGF2QlgreC9qUEU5VkUzTHA0?=
 =?utf-8?B?RjgzUkszSnNDb2diOVBiRWtxUlRuTStzNGxhUVYyQmU4TUsxZ1JiL0Y5RGs3?=
 =?utf-8?B?QkR4VWZvN0dHZTRYM0NoWWhOUzZzd0hYd1FZeWFGMXMwY3BHbDBMamlvQVMr?=
 =?utf-8?B?ZjUzbVhrSThjLzFsY1RyRm1IZnNZdlF1OE1tckNhSDVuQjVuMTJab0dHU2th?=
 =?utf-8?B?emIzUCtjRkEyTmFwMFpKWk9wOW0vVlg0NUcwNHhPNFM0a1FrZHc1aGJLTkRQ?=
 =?utf-8?B?MmVzME5VeUQ5bmZsQTdrMytkR01QUVk2QU53cytXdTgxWUgwVDBNcE9JMEdG?=
 =?utf-8?B?bTFiZ21rVERFTU1SbEQ3Q1JzZllyYy9hOEtyb0RZd3E2MlVIeTNEdzliamEv?=
 =?utf-8?B?SHl5VFlwUkI5Qy9FVE0yalIrcVl4RWsvQnE5UmZTMHVhRGw2M1NXN2lQZ1R4?=
 =?utf-8?B?SE5OSlgvWllwY0lFTDJCNjdhZWRsTC9CUkcxbEJzVHliRzlOWlFxTC9hNXRu?=
 =?utf-8?Q?4dVtbFkYFvVQruT9VBrulv71p?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4D91092FFC4354AB2E49FDA6E5668B0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5886bb20-b1ef-420e-1a5d-08dafaf08f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 14:13:53.1920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kdzlsan27eSMOuXp6kTCVomAofc76TwwERR/mMkxYs0k4fWWenTix+qojT2XoRC3gC5tW7c4TVdtGlZhqGEBVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE5LzIzIDIzOjQ4LCBKYWNvYiBLZWxsZXIgd3JvdGU6DQo+DQo+IE9uIDEvMTkvMjAy
MyAzOjMxIEFNLCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6DQo+PiArDQo+
PiAraW50IGVmeF9tYWVfZW51bWVyYXRlX21wb3J0cyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KPj4g
K3sNCj4+ICsjZGVmaW5lIE1DRElfTVBPUlRfSk9VUk5BTF9MRU4gXA0KPj4gKwlzaXplb2YoZWZ4
X2R3b3JkX3RbRElWX1JPVU5EX1VQKE1DX0NNRF9NQUVfTVBPUlRfUkVBRF9KT1VSTkFMX09VVF9M
RU5NQVhfTUNESTIsIDQpXSkNCj4gUGxlYXNlIGtlZXAgI2RlZmluZSBsaWtlIHRoaXMgb3V0c2lk
ZSB0aGUgZnVuY3Rpb24gYmxvY2suIFRoaXMgaXMgcmVhbGx5DQo+IGhhcmQgdG8gcmVhZC4gSXQn
cyBhbHNvIG5vdCBjbGVhciB0byBtZSB3aGF0IGV4YWN0bHkgdGhpcyBkZWZpbmUgaXMNCj4gZG9p
bmcuLiB5b3UncmUgYWNjZXNzaW5nIGFuIGFycmF5IGFuZCB1c2luZyBhIERJVl9ST1VORF9VUC4u
Lg0KDQoNClRoYW5rIHlvdSBmb3IgcG9pbnRpbmcgdGhpcyBvdXQuIEl0IGRvZXMgbm90IG1ha2Ug
c2Vuc2UgYXQgYWxsLg0KDQpJJ2xsIGZpeCB0aGlzIGluIHRoZSBuZXh0IHZlcnNpb24uDQoNCg0K
Pj4gKwllZnhfZHdvcmRfdCAqb3V0YnVmID0ga3phbGxvYyhNQ0RJX01QT1JUX0pPVVJOQUxfTEVO
LCBHRlBfS0VSTkVMKTsNCj4+ICsJTUNESV9ERUNMQVJFX0JVRihpbmJ1ZiwgTUNfQ01EX01BRV9N
UE9SVF9SRUFEX0pPVVJOQUxfSU5fTEVOKTsNCj4+ICsJTUNESV9ERUNMQVJFX1NUUlVDVF9QVFIo
ZGVzYyk7DQo+PiArCXNpemVfdCBvdXRsZW4sIHN0cmlkZSwgY291bnQ7DQo+PiArCWludCByYyA9
IDAsIGk7DQoNCg==
