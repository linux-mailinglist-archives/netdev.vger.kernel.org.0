Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF96C591E74
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 07:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbiHNFZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 01:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHNFZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 01:25:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AFF13E11;
        Sat, 13 Aug 2022 22:25:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTzIebJc7wR27rZhZNxqQXUGEntM7H6pgwQ4wqeKq55S3mCVi1G29ga7ShcQ7DZ8abXomqXocWnviZJaTu24Ve+p13Wuhy6kkYiTndg9NkOCqS0UhlqrURFSBssOQvYQjPE2L7qH6JBRhsueES0HnHy5fRHzptWMJcFNxpyi9DF6REOSA+C31hnFRJJUEYumrpAO3Gpegw8tJgZ6tVX6WI2WCzoZsCngNfUjzC12sMlnOx6sUwPqBISa0YiM0aJ3H7czXOBgnjsRA/5/wxTVes6MyBe4iPbH8fpRQUHZsSuEnCFV5ahFFf9JYVPr+2O6oxPqbIv9na+UfUuFgJrzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPsnByg9GkmeiXdCbLUjXq5RxPhjCaYA61SaoODvzqg=;
 b=jqSeCGlyL6w/kEEktueNI/fuwZ91+/fgVidnZ72YcZ97Rwp7xj5EDvSPLkV1/ahr5+H+EBmvdP4Nl0R9mW0Iq3eY7dm4BwerE2VEkJdnZBgETrEg4IlzWRdLwr4RZvvWLT57m2103oIHk76hEfLtHxvhp0gmsGzJluRa8NyFolbO0GCqYvLCY+PqT0U3p1R6xyorKt3Py9e0dgo9Kw1nc+l5oe5fQ8Jrxs8wOvyLfKJ6X+Wp1VkxFBNx01/QKmQoktGo3k32L3HiP27JkRs27taUwwECYsnyF6pV6NImm+fK/yzYioblAiwUQMSdnHJIv48FihKzpl3avhxqtyqrrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPsnByg9GkmeiXdCbLUjXq5RxPhjCaYA61SaoODvzqg=;
 b=Pq80a7lYO2AKoEkT8vF6OpsyuOwmTuArVdoaMngPuKJXwUPeJT1iDlPtO5FJbvXARElAz8reD+fmZlnlcSgRGD4eHu8W+hgtL3Zo2SwtPeNfLobo6FWydHHHESf1rA9Mbevm4h/fQR/U59WugWV/BNlNhHvcWnpPbc3zwSSFnQXt4rHnp9UOkN4CSpSBE97VKABnj6B6xynrNnOPN01ZUZ/k+oVgdJA5V9n4wBQ0Zorq6ZJlrurxNepEzuMWw90fF5yWwk+KpoC1h6QLT1exzR1yuBpsTKt/7tWdU4HrIzpmqCiB15xCDkDsrng92AXl6yArEcB4R8p+XW/shNACaQ==
Received: from DM5PR12MB4663.namprd12.prod.outlook.com (2603:10b6:4:a9::26) by
 DM4PR12MB5199.namprd12.prod.outlook.com (2603:10b6:5:396::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Sun, 14 Aug 2022 05:25:31 +0000
Received: from DM5PR12MB4663.namprd12.prod.outlook.com
 ([fe80::b4ab:4d63:1cdd:b051]) by DM5PR12MB4663.namprd12.prod.outlook.com
 ([fe80::b4ab:4d63:1cdd:b051%4]) with mapi id 15.20.5504.025; Sun, 14 Aug 2022
 05:25:31 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "ira.weiny@intel.com" <ira.weiny@intel.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
CC:     "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        Thomas Gleixner <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] checkpatch: Add kmap and kmap_atomic to the deprecated
 list
Thread-Topic: [PATCH] checkpatch: Add kmap and kmap_atomic to the deprecated
 list
Thread-Index: AQHYr2AnarTe9oV4GEWjC3HdbpR5Ya2t3ckA
Date:   Sun, 14 Aug 2022 05:25:30 +0000
Message-ID: <91f708ed-f456-dc83-281e-fc18a0b4b981@nvidia.com>
References: <20220813220034.806698-1-ira.weiny@intel.com>
In-Reply-To: <20220813220034.806698-1-ira.weiny@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31ec3568-a4e9-4168-77a9-08da7db567cb
x-ms-traffictypediagnostic: DM4PR12MB5199:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VLE6UsKRBwAODhumIvrq3g/k3pw/3vVudsx7E1SYHm5qNlNlnwoHNGRuBrJQuXwTVVhU/VrAz8wlQXrLxQpPOW3iUHura4jvNR1SaAW/5S6I2Qx6kDAoaJd3avPZjss5UBvvIJ0XTxeHDgZskqRz+Iuwvolz3WQrJZJ7Wu1uU3xEF6au3DuFGl6Med2yyJsJsSGjTXkRj3dq4qOMEf7RN062zm0Q3MylQHxl858NTHI406oDnSxrxFcJLqdMZk1wKAI0QIXLGRs9KFi1XEEq/QcHJDH5AWxH7QSWtuCKWI/LXV6WF7spD0PsHp8NfI6oq/BKnuAAHTCtachXF8YNDALwCj+x1IbZmMvtEZCrnh81tDCGsTHvrSTRTMdvaNIaOE3rpUmBKh4o8a0zZFXbJkjhW4B5mvOtdIodXEajf1D0y2nv3u6XShHIwlVQDdQtu0f9H3V2GEMEv2wYY98m0rxNK80QRyYof11BNGSXMA6YsMA5ib4wDeLSybgNDV5rMxAJ2R8s/0/uY81Bd2ma7Cgsu+dKZFwK2nG/FujAuLxp66HdkHZtEDjrK1uBcTBAjvabxosYanuiMrzK/KmduPw+F8M/vBqqtBRFkoDX5hgcBYD+Dg4QlhCtdZ9t/9S1yQK50V/B5rEPgts1rA6grLB7lTOQfNTJHDVQsAW/pxm3Hys4bqjgOw6xMuU5GvWZWt7K/GnjMxxXuMdDJ3u89cIcErwOX0MxVR3NivkZoqA8+uK03F13AHHxSME3P4gG/hAjnM2bVmq1Taj5+DJtKlNRc15jMly+lv9g7OxKYq2IgXpwuivh6VROmKVUc2lt6y0hmnBcNu8zovkYk7KVhJVd1ZElq8RXIN1mjse85V9z6ROkqRQ0xoRQ9uWbgH2YdM8wUZti0B0W3yYPGekPh+xdOdkVR3rud9Sf1ONTr08EArEgOazyW1wU4zYF0Kw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB4663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(66946007)(66446008)(6506007)(41300700001)(6512007)(53546011)(186003)(83380400001)(91956017)(76116006)(66556008)(4326008)(66476007)(64756008)(8676002)(2616005)(2906002)(8936002)(5660300002)(7406005)(7416002)(86362001)(478600001)(54906003)(966005)(6486002)(110136005)(71200400001)(316002)(38070700005)(31696002)(38100700002)(31686004)(36756003)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1MyRnlCbC8vYlhTbkV3enZJdFhCYXZzOGtIRm52Y3JybUxCZlRBRnVDclN0?=
 =?utf-8?B?ek9xZUhkMm1rNUc2WmgvVXFMSWNYVFZ4dTh0cVY4M0dzRmxxZ1R1R2o0K1la?=
 =?utf-8?B?NVNqd0pEeGNPWm43V0xYRitZWFdqUklvbWsvQ0RmcnFhZkQ4MXRkWko3SDJP?=
 =?utf-8?B?eHJobTFNU1ZUbFk3MytOSUxEeVM1WlFySnc4TGF1MjVWL2tsRENZNW51SnV2?=
 =?utf-8?B?b01wV0RsN0Z2WTA2eEZvMFhQYXBSbk9GWTErbzMrcWJybmd5R0dsMTFCQ1lB?=
 =?utf-8?B?L0k0Um94M0MrNkpRMzFxZVRVZUZGZ3lUUGlXbVBQb1ZYVXZiZCtqMEJsWXpG?=
 =?utf-8?B?QVllM2NCSkR1eE9XRlQrQ0lKeFZ0Y09rWTcrYVV3RVdwTWZGcDcrbDNpWDFH?=
 =?utf-8?B?S3hDODZ3dDBncHdscWFZOWxMWU1SalNhOTlvMDc1cmFaNndHQ2pNSnpCeVF3?=
 =?utf-8?B?L0RIVGN0d1ZqV0VLemg0Unh3VlhpUDdVVnpQbDN0d3NyK0VOWmF5Vkhjanlv?=
 =?utf-8?B?aG1DRDdITjJ5YzFPUHZiYjIvM0Z4ZjVrTnZtdHcrSTVVbmtXcmNXczRRMFJP?=
 =?utf-8?B?YjZNL00zQS8vUm0rMnpDUjV6eGVrS2cxNWNnaWJJaVNZdWhMRW5ZU1dDa0s5?=
 =?utf-8?B?RGExODVYMjBoemc4QnNBaDg0eFNKODJWN29MUHRFUDZWZUlSYUMvWXR3dVhw?=
 =?utf-8?B?UTd4eFVQUGgvazFRaGhOYkNxc2dFelJJUENPdDZJV1o3OEI4dVVwN1h1RG1X?=
 =?utf-8?B?SkZWd09nNWhrSGtnSHFTNXM5VlZnVHYreUpkaVlLOW84UFdlRGlQWWtxdzJh?=
 =?utf-8?B?aSs1VjYrazRuRWloMktyc1JlNzhUcEFmWlFOVS85bFJBeTM5WFpPS2J5bFJh?=
 =?utf-8?B?UElIaTlCUUJ1eDhXcTFpdnlHeHBsdHdMM1oyOXk3aUw1ZlI2c3A3RVo0WnFk?=
 =?utf-8?B?cmhOMHVyNTZTZUhUYkF5dkRkdS9jU1dXMW1nbktKcHd3QTdJZmxxSm5CUkVi?=
 =?utf-8?B?NUsvTVF2THNFMDBFd2JvL0ZzUDdxY0xBUTZhOU5zWHVFVllid2NnTGFicFlu?=
 =?utf-8?B?YkVQQmVwT29vdG51Q2w3eEFGUjNhbUU3OHZOV25jM1VCNlNqSUw5enZFS0h0?=
 =?utf-8?B?eDdUN005QzgvZWtyZVhGclJqdTNVbGtQUm5xVmRQeER0NHVsY3l3OFRLYUlo?=
 =?utf-8?B?aUltOHNRSmowcGhIRjM5ajNjcTNzNEdjVlM3cWdnRnFvaExiRDZhVnNjcjU3?=
 =?utf-8?B?YmRIMU1PenFjM0FLSWtTaGVidHFrSFZDQlp6NDdHTUJnbGZJd203WjNRN2lx?=
 =?utf-8?B?S3ZNK25JVHplalQ3SFhSdGFSeHpPbzMxbTFXQWF4SEtPc25PRG11OUhVQWRC?=
 =?utf-8?B?NFFHYVBzbVlJQkVOZ1Jvd2JPM2QvOUxtUUpSZUIvQUg2MmxEZnlJM3EwTjdX?=
 =?utf-8?B?RVZjM3dwb3JVdDZnMEU1SmtaaXkzZnk0NmxPTnBBcG5INHJSdVAzV2w0RW5J?=
 =?utf-8?B?azJxOUZleldLdW1jTFQ0WmlhM2RlMWpSb0krcGNFZjVIYWNvV1lYbjdSVGlF?=
 =?utf-8?B?a3hNSzhadERYS2VxK20wRHdXSHkvY1F1Mk0xRUhlWUw3bzJXRGgrSHozSVRn?=
 =?utf-8?B?dzBHbk16azVqVWk4WU5iQTdGVENub1Robmk2Y3ZOaUZwdXJ0U0xBb2ZIVHNJ?=
 =?utf-8?B?Qm9EeFBVNmtkSU90ZjM4cDEvdEl3R3dacEM2RFhpN0c1TUdZYVBnemlqYzBV?=
 =?utf-8?B?MUlmSXpaMVpONFhBNHFNY0JPY3FxQWNqckVDd0gvTFRldVJMbGd0SVpBQ2hn?=
 =?utf-8?B?aDRZZkl5MUhjeFlkbDB6eWFrSGpFNHNtbi9JNzhsZzdJQ1N1Z1hKRG9ZcVZR?=
 =?utf-8?B?WGtzbnVGVnN5K2owUy9nS1g2UGpLSEs2KzJibUlRZkZaellFWlRqMTYwSklw?=
 =?utf-8?B?Q2Z2MmlENTlEbXdSWjB5bmwvUFhxWkcreDd2aUMvZWhKS1Iyc1JKMnJtQnpS?=
 =?utf-8?B?TWdtTzUyZmdJMGhaVlpDdStZc3NuR1RZNmgzbEhxejF2cWVFTGlzY1QyM016?=
 =?utf-8?B?WmFDRVY3ZHdPS1oraHNPU3F0S0JHRUVxZFRRWSszLzBqQ1RqaTJYNXY2SEow?=
 =?utf-8?B?SU5IaXpMSWNROTRGYUJsWGVjMXdYQjBuNWg1eUJRcDg4YlR4ZjNMRzFVL1Nx?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5261E63C04B5044FBDC2CBFA7DC85685@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB4663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ec3568-a4e9-4168-77a9-08da7db567cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2022 05:25:31.0130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DTS1C5RKwVtBKScaU/BTbd0QOIaELY0YZxfbtZMm5adcb9U5unTaXCRAksNDGAW1JZlBYO6iAoiBrXG8NSNNaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMy8yMiAxNTowMCwgaXJhLndlaW55QGludGVsLmNvbSB3cm90ZToNCj4gRnJvbTogSXJh
IFdlaW55IDxpcmEud2VpbnlAaW50ZWwuY29tPg0KPiANCj4ga21hcCgpIGFuZCBrbWFwX2F0b21p
YygpIGFyZSBiZWluZyBkZXByZWNhdGVkIGluIGZhdm9yIG9mDQo+IGttYXBfbG9jYWxfcGFnZSgp
Lg0KPiANCj4gVGhlcmUgYXJlIHR3byBtYWluIHByb2JsZW1zIHdpdGgga21hcCgpOiAoMSkgSXQg
Y29tZXMgd2l0aCBhbiBvdmVyaGVhZA0KPiBhcyBtYXBwaW5nIHNwYWNlIGlzIHJlc3RyaWN0ZWQg
YW5kIHByb3RlY3RlZCBieSBhIGdsb2JhbCBsb2NrIGZvcg0KPiBzeW5jaHJvbml6YXRpb24gYW5k
ICgyKSBpdCBhbHNvIHJlcXVpcmVzIGdsb2JhbCBUTEIgaW52YWxpZGF0aW9uIHdoZW4NCj4gdGhl
IGttYXDigJlzIHBvb2wgd3JhcHMgYW5kIGl0IG1pZ2h0IGJsb2NrIHdoZW4gdGhlIG1hcHBpbmcg
c3BhY2UgaXMgZnVsbHkNCj4gdXRpbGl6ZWQgdW50aWwgYSBzbG90IGJlY29tZXMgYXZhaWxhYmxl
Lg0KPiANCj4ga21hcF9sb2NhbF9wYWdlKCkgaXMgc2FmZSBmcm9tIGFueSBjb250ZXh0IGFuZCBp
cyB0aGVyZWZvcmUgcmVkdW5kYW50DQo+IHdpdGgga21hcF9hdG9taWMoKSB3aXRoIHRoZSBleGNl
cHRpb24gb2YgYW55IHBhZ2VmYXVsdCBvciBwcmVlbXB0aW9uDQo+IGRpc2FibGUgcmVxdWlyZW1l
bnRzLiAgSG93ZXZlciwgdXNpbmcga21hcF9hdG9taWMoKSBmb3IgdGhlc2Ugc2lkZQ0KPiBlZmZl
Y3RzIG1ha2VzIHRoZSBjb2RlIGxlc3MgY2xlYXIuICBTbyBhbnkgcmVxdWlyZW1lbnQgZm9yIHBh
Z2VmYXVsdCBvcg0KPiBwcmVlbXB0aW9uIGRpc2FibGUgc2hvdWxkIGJlIG1hZGUgZXhwbGljaXRs
eS4NCj4gDQo+IFdpdGgga21hcF9sb2NhbF9wYWdlKCkgdGhlIG1hcHBpbmdzIGFyZSBwZXIgdGhy
ZWFkLCBDUFUgbG9jYWwsIGNhbiB0YWtlDQo+IHBhZ2UgZmF1bHRzLCBhbmQgY2FuIGJlIGNhbGxl
ZCBmcm9tIGFueSBjb250ZXh0IChpbmNsdWRpbmcgaW50ZXJydXB0cykuDQo+IEl0IGlzIGZhc3Rl
ciB0aGFuIGttYXAoKSBpbiBrZXJuZWxzIHdpdGggSElHSE1FTSBlbmFibGVkLiBGdXJ0aGVybW9y
ZSwNCj4gdGhlIHRhc2tzIGNhbiBiZSBwcmVlbXB0ZWQgYW5kLCB3aGVuIHRoZXkgYXJlIHNjaGVk
dWxlZCB0byBydW4gYWdhaW4sDQo+IHRoZSBrZXJuZWwgdmlydHVhbCBhZGRyZXNzZXMgYXJlIHJl
c3RvcmVkLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRy
b25peC5kZT4NCj4gU3VnZ2VzdGVkLWJ5OiBGYWJpbyBNLiBEZSBGcmFuY2VzY28gPGZtZGVmcmFu
Y2VzY29AZ21haWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBJcmEgV2VpbnkgPGlyYS53ZWlueUBp
bnRlbC5jb20+DQo+IA0KPiAtLS0NCj4gU3VnZ2VzdGVkIGJ5IGNyZWRpdHMuDQo+IAlUaG9tYXM6
IElkZWEgdG8ga2VlcCBmcm9tIGdyb3dpbmcgbW9yZSBrbWFwL2ttYXBfYXRvbWljIGNhbGxzLg0K
PiAJRmFiaW86IFN0b2xlIHNvbWUgb2YgaGlzIGJvaWxlciBwbGF0ZSBjb21taXQgbWVzc2FnZS4N
Cj4gDQo+IE5vdGVzIG9uIHRyZWUtd2lkZSBjb252ZXJzaW9uczoNCj4gDQo+IEkndmUgY2MnZWQg
bWFpbGluZyBsaXN0cyBmb3Igc3Vic3lzdGVtcyB3aGljaCBjdXJyZW50bHkgY29udGFpbnMgZWl0
aGVyIGttYXAoKQ0KPiBvciBrbWFwX2F0b21pYygpIGNhbGxzLiAgQXMgc29tZSBvZiB5b3UgYWxy
ZWFkeSBrbm93IEZhYmlvIGFuZCBJIGhhdmUgYmVlbg0KPiB3b3JraW5nIHRocm91Z2ggY29udmVy
dGluZyBrbWFwKCkgY2FsbHMgdG8ga21hcF9sb2NhbF9wYWdlKCkuICBCdXQgdGhlcmUgaXMgYQ0K
PiBsb3QgbW9yZSB3b3JrIHRvIGJlIGRvbmUuICBIZWxwIGZyb20gdGhlIGNvbW11bml0eSBpcyBh
bHdheXMgd2VsY29tZSwNCj4gZXNwZWNpYWxseSB3aXRoIGttYXBfYXRvbWljKCkgY29udmVyc2lv
bnMuICBUbyBrZWVwIGZyb20gc3RlcHBpbmcgb24gZWFjaA0KPiBvdGhlcnMgdG9lcyBJJ3ZlIGNy
ZWF0ZWQgYSBzcHJlYWRzaGVldCBvZiB0aGUgY3VycmVudCBjYWxsc1sxXS4gIFBsZWFzZSBsZXQg
bWUNCj4gb3IgRmFiaW8ga25vdyBpZiB5b3UgcGxhbiBvbiB0YWNraW5nIG9uZSBvZiB0aGUgY29u
dmVyc2lvbnMgc28gd2UgY2FuIG1hcmsgaXQNCj4gb2ZmIHRoZSBsaXN0Lg0KPiANCj4gWzFdIGh0
dHBzOi8vZG9jcy5nb29nbGUuY29tL3NwcmVhZHNoZWV0cy9kLzFpX2NrWjEwcDkwYkhfQ2t4RDJi
WU5pMDVTMlF6ODRFMk9GUHY4enFfXzB3L2VkaXQjZ2lkPTE2Nzk3MTQzNTcNCj4gDQoNCkxvb2tz
IGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29t
Pg0KDQoNCg==
