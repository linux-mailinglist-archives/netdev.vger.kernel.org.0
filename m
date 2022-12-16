Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3339B64F31F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 22:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiLPVZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 16:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPVZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 16:25:07 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2139.outbound.protection.outlook.com [40.107.243.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD63461D50;
        Fri, 16 Dec 2022 13:25:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVre1eyI3WvFWDdMruha+U3zatrU9RI0H1sPIw5kU+d3X1RhxYO5WA0bP4Fi5VI7bGNyMfZdT+/SNPVbsmbGZ0FTVJ/zSqHozrj/ERJ8Ar6snibc6X1peycqKKqRWzA0cNHPmIf/n5v+kt1UAPwsSAy2vR8sx+OFIf2lmFqNVMZraHQibGuWcHo3cqPDiBXSCWX/trJxdSBZbPSnuNFqnbn/7vCG1l0DaxC6quICIVEWhdpLCxjbtARPS2WhegV9wU4Sk+E/oMoTj3KYOtFw7OAb53yNA73hktW4QH7q8GQqcq+e7msb9F0pydsMVn17iPlnmP29bxxgd4Pny5unBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvDjeFVMcyANskvqdWrlx1F5z6isiy9IcjYoaho/T5E=;
 b=di0sjIixY4PFPd7HOv8B5EydnRDi5NfKl3Xamer3Tsj+J4LOW6b9qVaiO3/C/joBVYKfCeGA7k+eN1Czp4drPPLi7RA+miMvCHVr9UKB2tXd1uC1GPHYM1PIfjjndk8jx+m6bzwuC6KVCHHBNKWQvmH51U8Zcy3tR7TfQLLsm3/MnI0w7MFRxa+/85z/12k8zDY0owzHfNwNzaxALMhKf5SC6PHkeYKO/UKp+ZW1IvsnFOTipCVhbRHcNwNxJiESy0IqC9lG6BnAioZdQQC4zQ1C4va1qWLqRSb3vG7f3FCJie8PgyPiR/kTvQ6/0qw76ezIxHZxzdjLlm/2ZTwVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvDjeFVMcyANskvqdWrlx1F5z6isiy9IcjYoaho/T5E=;
 b=cyR5wNbm8fs7r48/B7wG/rj1Al9RJjCr7VMG/p7Izx31MX1MgvmsFIj0AB2s1WkAS50qCrUNJpKXB9WY1aVA71atv/2i2OVYZ+Nm7mslBjasKDlmaBCzX99iUPHJ0CvLUBvOLTIIZ/f5PddCkJBjZ0FD4ZKTDjag5EZc5NHA62E=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BN0PR13MB5183.namprd13.prod.outlook.com (2603:10b6:408:156::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 16 Dec
 2022 21:24:59 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::34dd:cd15:8325:3af0]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::34dd:cd15:8325:3af0%9]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 21:24:59 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     Michael Trimarchi <michael@amarulasolutions.com>
CC:     Neil Brown <neilb@suse.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "slade@sladewatkins.com" <slade@sladewatkins.com>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
Thread-Topic: [PATCH 4.19 000/338] 4.19.238-rc1 review
Thread-Index: AQHYVREdUAEMj/tTgUukhJfEz7jj6q0BgOWAgXDOVoCAADBJAA==
Date:   Fri, 16 Dec 2022 21:24:59 +0000
Message-ID: <332A0C50-D53E-4C86-9795-6238C961C869@hammerspace.com>
References: <20220414110838.883074566@linuxfoundation.org>
 <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>
 <CA+G9fYscMP+DTzaQGw1p-KxyhPi0JB64ABDu_aNSU0r+_VgBHg@mail.gmail.com>
 <165094019509.1648.12340115187043043420@noble.neil.brown.name>
 <Y5y5n8JoGZNt1otY@panicking>
In-Reply-To: <Y5y5n8JoGZNt1otY@panicking>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|BN0PR13MB5183:EE_
x-ms-office365-filtering-correlation-id: c1ced52c-c02d-4f55-73c2-08dadfabfc80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ngMVKOdkzGwq6888C7yVDjKRyqhsZivjnn45vY8F2XaviwYIkVYVj/98Kbb6h5Ixr5q6wshOFre9SaZO5Q1X/ul+9BgGP2Od3dfieoElviD8zabp/9gU6INYciSk06VZ8Tyx6VL1rgWHhbOsLhjeu1hSn/AHP4P6oo6N1fWVBNceRcZF7mrxgZ6axUTvLM7OpDcMXMQJrTkkAdrClcM3z18QFTNvA0pNdn8kKlkr+QE37NhxBzsSKkOnMe20XaBE+O9ln+prci2Gb1Zz+mDsOIgmcf1FFICaxfPO6VB6NM6W+FZYqKVDzb4v8CO9fVrXSWmXBJoGqrOGj5zI03ENbAcZw2/V770QrDOKxJjbshXbKofZGDGuwUKe8oDMfpIt7V4hsetF8eezWzEXZU9h23VOhzOWWvN8/DBq+gjxSaZYbM7SnKfuM+FEwXmPVLnFdFuiFC3cbeMCSWxbf9GSotmzt8+3WLYohy3zj4z1VpDslvasS5TniMpQF8Mnf73DJESkwk6NKO/stS51VjRzq+tM+jvvK5P+XTz7cYOBCRQ8YdCim5MdHXnEd064hOwwsCwmLdr6TPJ0+bBhWbQHnpVB3LyJ74Le9OAv0hDE4z0c1jyvqQapdYSxVfuciA4JBeD52TTiI6l66aSs9rA7TJh7NwQoKRohTUdF7USGalkpc0Hpl5EBogZRofFAEdDFHOs/xD6sWmNo2C7JToQeBgxO5NMCS8iOSg6ERp3YE6pusNIiQnPo/ddaz9t2hIwKrKhG4nX9b6rtEMX2UXRCLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(39840400004)(346002)(451199015)(2616005)(33656002)(316002)(6916009)(478600001)(54906003)(38070700005)(36756003)(86362001)(38100700002)(186003)(53546011)(6512007)(6506007)(83380400001)(122000001)(7416002)(5660300002)(966005)(71200400001)(6486002)(41300700001)(8936002)(2906002)(64756008)(4326008)(66476007)(66446008)(8676002)(66946007)(76116006)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0s0eGQvNi9MaHR1MmlJb21qdVBGeXpXQzhBa2NKdytVVkpHTlk3RWdGSDYz?=
 =?utf-8?B?bWZwdVA4UWNTa01QNFp6SnlSSnZsRXBQSkh1WGdMQzF0RFlYTFNKYmorRmdY?=
 =?utf-8?B?NlJmYVJYamh3b3FKT2ExbURwQ25YVExoME5SR3d0NHFSS0dQeG0yQWwyZytj?=
 =?utf-8?B?RGdmbHVnQ0ptQUFkaEsxMThiQ25ZM2swUGwwUnU0YVdNcmQ2Sm5NTmFWRGUz?=
 =?utf-8?B?QWpMSHpJLzluU1dvY3BFanlJZU1tcmEySHh1SEVOay9zejk4V2NOdkxpQVBY?=
 =?utf-8?B?bVJCeWpqT2RIODRtNWQycEFGREdmaTR6VWtLZEhCLy9mUVVzaXl4SVoweHVH?=
 =?utf-8?B?VElkakJYRVlaZ1NDeStrTG5lQWZJdklTS2dBYXcvampBcm5RM2JtOWk5NHBS?=
 =?utf-8?B?ZmE3eXFMUGV3QUpqeXo2Y2JkVjhmQzFZOXlPWVdLaDhKSE8rVktPcGRTUnln?=
 =?utf-8?B?d3hjNE1JdGRIT3Zvb3ZPeTNtb2hOT0t2M0hra2UvckJVYjY5UmIvTVdhdENK?=
 =?utf-8?B?VjlHQ2w0YzVDaXJnM1IwdkR2NVpnOXVnVlFrWW9KTjZ4dEVDdy9rSWtDTTJR?=
 =?utf-8?B?RXB2OXllZ3RwWEVRMWl6NUZtNzdHQVZDMzlXU0RZSGhHdjZpU0V3eTk3ZytG?=
 =?utf-8?B?WFNmSzg4VDU4ZllPeGdWS2ZhME1CY2tTallGR2IzRFBJUmlwVUVYTXpsZXIz?=
 =?utf-8?B?OWVuQXREWFFuM0RBOWU2UzFQdnlaVVQ5Vmt2dExJcTQyWXRpRlNBVmM5VGxy?=
 =?utf-8?B?SXVnMVFmRzVRUnUrWnNnNTNSTUM2QVR6YzhVdkVwYnNKOTRkOW5PZmFjZUc4?=
 =?utf-8?B?Y2pDcjZ4dzR0ZmJEWlR0eUExeFBPeEZPVkt1eXl2MTh1ck1aVzZwQWcrdjNO?=
 =?utf-8?B?REc1a09uTTNnelIyQjB3OGZoc3RVR1lpWHQ2Znp2ODVGRGpDWGtaT1BxY2Z3?=
 =?utf-8?B?TUJvM25zVW93MHNXWjJMNG4yQWdlUWlKZDJLQThwREExOG9vWmwvQXlrVG9h?=
 =?utf-8?B?VTVIakNoandNcE1rVWhjOXVEY05BWkJoNmpGV1hXbjllSDRYaVBnUEszWVJ5?=
 =?utf-8?B?Wm5TRVNHaVFrdy9qamZ4QmcxcWF4SWVOektENWhKZWwwbXU3aUM4Uk1XbC9L?=
 =?utf-8?B?MFNXV3BDLzhLYVVKZ3k3YXRLTHdKQ1JPU0N6cTl6WTVkMFZQWUdUczR0QW9v?=
 =?utf-8?B?SEl0RlhxZmxqcXUxLzk0VXVMbzZCeXN5MDB2aEVTQUNRbEQ2MFZqQm91RkhP?=
 =?utf-8?B?NDdxSU1zK3BUSERsM21SMjBPMTJOU0w4Ny94RG4vOTBxdTFyS053My82M2Y5?=
 =?utf-8?B?V3pwK1RCUzYwL0FleHBWTzFFNzNpcUovd0FQZnBvNHp0NjFTNXI4QzZJZkp3?=
 =?utf-8?B?NXF3ank3MHdyRVhwTFFTaUQxOFpNNmZZU05kSktnRkp6dzhjV0hyVHl1dFk0?=
 =?utf-8?B?ZDkzOFNkWXhDU2JFc3NVZDRXZVRXRXRXNGo5TnVXVTdhazNOaCtueUo3am9D?=
 =?utf-8?B?bG5ZRHpNNitIaVVUTGtRdGJjV1o3czNXbXRUcmw5YVQvUlN1TnVyMDZqQVBa?=
 =?utf-8?B?UWY5UHBMZ29oeUZPbTRQaFo1OVhLZE9DSzJPQ1E2VUNuc3gwa05JUnhVamMx?=
 =?utf-8?B?VjVHdUtXV0NwNy9nS1REMkhQVVdmNFNSc0xWSWZGeEJxTS94amUwZFVmZEVS?=
 =?utf-8?B?RjNJZjhkSmU2MDAzcFNLbllWaVp1Rkppb251R0FFUWdQZ2c3R0FvRmNSN0k2?=
 =?utf-8?B?WW1qU20rbWdkS1B3a0hxTk1JTm82WEZmQis2T29aNHVTUEdwRGl0S1NiVzh1?=
 =?utf-8?B?V3UwdlJaSXk2S05HbVc1MTcyVThzQzhEN3p2aFgvTUtlSVZ3WnJFeFMyRXNo?=
 =?utf-8?B?NnhQMkp1aDlIYVlaVG1kbi9Fd0VhSXRxcWV2K0VKYittQnZ6SE1uS25GNWNy?=
 =?utf-8?B?UG5DUUxqUzdPZ255SXNHWStHTnJFRzk0ekh5QldiSDIwbEg4eEl2d1d0ZkNm?=
 =?utf-8?B?V2UrWXViczBMRVd3dFlsdGNhbUJob1FoeWlYc0hHU0plRmx1d29mNjRJaEZa?=
 =?utf-8?B?YldsMXJRN1dDNk8zWVJyaXNPb1pOS0hINUZ3Yis2WStyMWhaWWxLWjZnaVky?=
 =?utf-8?B?b3pQVFpycTFYOGp3L1dudWFUQ09oUWthaFRKR0p0azZOY1hkRXhVSlpiSzV1?=
 =?utf-8?B?bmxqYzNvNXNhOEVvS0lmbzg1R0orNWJQaFFsVVRqZ3Z3SEVEaWMveTVYQUY5?=
 =?utf-8?B?S3B0bW1RczNKVTJuQmYydWpNR2dRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B035DB362E5C8F4B8842E315DD2374E0@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ced52c-c02d-4f55-73c2-08dadfabfc80
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2022 21:24:59.4712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0e5iRb71QlAO91MmoCrRiaROduv8/yZf2aKKiGKvzTVkAAsU/X5VUCjZqf9ishkDQC2onmsFSolQQ7heK0yGBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5183
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gRGVjIDE2LCAyMDIyLCBhdCAxMzozMSwgTWljaGFlbCBUcmltYXJjaGkgPG1pY2hh
ZWxAYW1hcnVsYXNvbHV0aW9ucy5jb20+IHdyb3RlOg0KPiANCj4gW1lvdSBkb24ndCBvZnRlbiBn
ZXQgZW1haWwgZnJvbSBtaWNoYWVsQGFtYXJ1bGFzb2x1dGlvbnMuY29tLiBMZWFybiB3aHkgdGhp
cyBpcyBpbXBvcnRhbnQgYXQgaHR0cHM6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZp
Y2F0aW9uIF0NCj4gDQo+IEhpIE5laWwNCj4gDQo+IE9uIFR1ZSwgQXByIDI2LCAyMDIyIGF0IDEy
OjI5OjU1UE0gKzEwMDAsIE5laWxCcm93biB3cm90ZToNCj4+IE9uIFRodSwgMjEgQXByIDIwMjIs
IE5hcmVzaCBLYW1ib2p1IHdyb3RlOg0KPj4+IE9uIE1vbiwgMTggQXByIDIwMjIgYXQgMTQ6MDks
IE5hcmVzaCBLYW1ib2p1IDxuYXJlc2gua2FtYm9qdUBsaW5hcm8ub3JnPiB3cm90ZToNCj4+Pj4g
DQo+Pj4+IE9uIFRodSwgMTQgQXByIDIwMjIgYXQgMTg6NDUsIEdyZWcgS3JvYWgtSGFydG1hbg0K
Pj4+PiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPj4+Pj4gDQo+Pj4+PiBU
aGlzIGlzIHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDQuMTku
MjM4IHJlbGVhc2UuDQo+Pj4+PiBUaGVyZSBhcmUgMzM4IHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMs
IGFsbCB3aWxsIGJlIHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+Pj4+PiB0byB0aGlzIG9uZS4gIElm
IGFueW9uZSBoYXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0K
Pj4+Pj4gbGV0IG1lIGtub3cuDQo+Pj4+PiANCj4+Pj4+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFk
ZSBieSBTYXQsIDE2IEFwciAyMDIyIDExOjA3OjU0ICswMDAwLg0KPj4+Pj4gQW55dGhpbmcgcmVj
ZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPj4+Pj4gDQo+Pj4+PiBU
aGUgd2hvbGUgcGF0Y2ggc2VyaWVzIGNhbiBiZSBmb3VuZCBpbiBvbmUgcGF0Y2ggYXQ6DQo+Pj4+
PiAgICAgICAgaHR0cHM6Ly93d3cua2VybmVsLm9yZy9wdWIvbGludXgva2VybmVsL3Y0Lngvc3Rh
YmxlLXJldmlldy9wYXRjaC00LjE5LjIzOC1yYzEuZ3oNCj4+Pj4+IG9yIGluIHRoZSBnaXQgdHJl
ZSBhbmQgYnJhbmNoIGF0Og0KPj4+Pj4gICAgICAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXgtc3RhYmxlLXJjLmdpdCBsaW51eC00LjE5
LnkNCj4+Pj4+IGFuZCB0aGUgZGlmZnN0YXQgY2FuIGJlIGZvdW5kIGJlbG93Lg0KPj4+Pj4gDQo+
Pj4+PiB0aGFua3MsDQo+Pj4+PiANCj4+Pj4+IGdyZWcgay1oDQo+Pj4+IA0KPj4+PiANCj4+Pj4g
Rm9sbG93aW5nIGtlcm5lbCB3YXJuaW5nIG5vdGljZWQgb24gYXJtNjQgSnVuby1yMiB3aGlsZSBi
b290aW5nDQo+Pj4+IHN0YWJsZS1yYyA0LjE5LjIzOC4gSGVyZSBpcyB0aGUgZnVsbCB0ZXN0IGxv
ZyBsaW5rIFsxXS4NCj4+Pj4gDQo+Pj4+IFsgICAgMC4wMDAwMDBdIEJvb3RpbmcgTGludXggb24g
cGh5c2ljYWwgQ1BVIDB4MDAwMDAwMDEwMCBbMHg0MTBmZDAzM10NCj4+Pj4gWyAgICAwLjAwMDAw
MF0gTGludXggdmVyc2lvbiA0LjE5LjIzOCAodHV4bWFrZUB0dXhtYWtlKSAoZ2NjIHZlcnNpb24N
Cj4+Pj4gMTEuMi4wIChEZWJpYW4gMTEuMi4wLTE4KSkgIzEgU01QIFBSRUVNUFQgQDE2NTAyMDYx
NTYNCj4+Pj4gWyAgICAwLjAwMDAwMF0gTWFjaGluZSBtb2RlbDogQVJNIEp1bm8gZGV2ZWxvcG1l
bnQgYm9hcmQgKHIyKQ0KPj4+PiA8dHJpbT4NCj4+Pj4gWyAgIDE4LjQ5OTg5NV0gPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0NCj4+Pj4gWyAgIDE4LjUwNDE3Ml0gV0FSTklORzogaW5j
b25zaXN0ZW50IGxvY2sgc3RhdGUNCj4+Pj4gWyAgIDE4LjUwODQ1MV0gNC4xOS4yMzggIzEgTm90
IHRhaW50ZWQNCj4+Pj4gWyAgIDE4LjUxMTk0NF0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4+Pj4gWyAgIDE4LjUxNjIyMl0gaW5jb25zaXN0ZW50IHtJTi1TT0ZUSVJRLVd9IC0+
IHtTT0ZUSVJRLU9OLVd9IHVzYWdlLg0KPj4+PiBbICAgMTguNTIyMjQyXSBrd29ya2VyL3UxMjoz
LzYwIFtIQzBbMF06U0MwWzBdOkhFMTpTRTFdIHRha2VzOg0KPj4+PiBbICAgMTguNTI3ODI2XSAo
X19fX3B0cnZhbF9fX18pDQo+Pj4+ICgmKCZ4cHJ0LT50cmFuc3BvcnRfbG9jayktPnJsb2NrKXsr
Lj8ufSwgYXQ6IHhwcnRfZGVzdHJveSsweDcwLzB4ZTANCj4+Pj4gWyAgIDE4LjUzNjY0OF0ge0lO
LVNPRlRJUlEtV30gc3RhdGUgd2FzIHJlZ2lzdGVyZWQgYXQ6DQo+Pj4+IFsgICAxOC41NDE1NDNd
ICAgbG9ja19hY3F1aXJlKzB4YzgvMHgyM2MNCj4+IA0KPj4gUHJpb3IgdG8gTGludXggNS4zLCAt
PnRyYW5zcG9ydF9sb2NrIG5lZWRzIHNwaW5fbG9ja19iaCgpIGFuZA0KPj4gc3Bpbl91bmxvY2tf
YmgoKS4NCj4+IA0KPiANCj4gV2UgZ2V0IHRoZSBzYW1lIGRlYWRsb2NrIG9yIHNpbWlsYXIgb25l
IGFuZCB3ZSB0aGluayB0aGF0DQo+IGNhbiBiZSBjb25uZWN0ZWQgdG8gdGhpcyB0aHJlYWQgb24g
NC4xOS4yNDMuIEZvciB1cyBpcyBhIGJpdA0KPiBkaWZmaWN1bHQgdG8gaGl0IGJ1dCB3ZSBhcmUg
Z29pbmcgdG8gYXBwbHkgdGhpcyBjaGFuZ2UNCj4gDQo+IG5ldDogc3VucnBjOiBGaXggZGVhZGxv
Y2sgaW4geHBydF9kZXN0cm95DQo+IA0KPiBQcmlvciB0byBMaW51eCA1LjMsIC0+dHJhbnNwb3J0
X2xvY2sgbmVlZHMgc3Bpbl9sb2NrX2JoKCkgYW5kDQo+IHNwaW5fdW5sb2NrX2JoKCkuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFRyaW1hcmNoaSA8bWljaGFlbEBhbWFydWxhc29sdXRp
b25zLmNvbT4NCj4gLS0tDQo+IG5ldC9zdW5ycGMveHBydC5jIHwgNCArKy0tDQo+IDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvbmV0L3N1bnJwYy94cHJ0LmMgYi9uZXQvc3VucnBjL3hwcnQuYw0KPiBpbmRleCBkMDVmYTdj
MzZkMDAuLmIxYWJmNDg0OGJiYyAxMDA2NDQNCj4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0LmMNCj4g
KysrIGIvbmV0L3N1bnJwYy94cHJ0LmMNCj4gQEAgLTE1NTAsOSArMTU1MCw5IEBAIHN0YXRpYyB2
b2lkIHhwcnRfZGVzdHJveShzdHJ1Y3QgcnBjX3hwcnQgKnhwcnQpDQo+ICAgICAgICAgKiBpcyBj
bGVhcmVkLiAgV2UgdXNlIC0+dHJhbnNwb3J0X2xvY2sgdG8gZW5zdXJlIHRoZSBtb2RfdGltZXIo
KQ0KPiAgICAgICAgICogY2FuIG9ubHkgcnVuICpiZWZvcmUqIGRlbF90aW1lX3N5bmMoKSwgbmV2
ZXIgYWZ0ZXIuDQo+ICAgICAgICAgKi8NCj4gLSAgICAgICBzcGluX2xvY2soJnhwcnQtPnRyYW5z
cG9ydF9sb2NrKTsNCj4gKyAgICAgICBzcGluX2xvY2tfYmgoJnhwcnQtPnRyYW5zcG9ydF9sb2Nr
KTsNCj4gICAgICAgIGRlbF90aW1lcl9zeW5jKCZ4cHJ0LT50aW1lcik7DQo+IC0gICAgICAgc3Bp
bl91bmxvY2soJnhwcnQtPnRyYW5zcG9ydF9sb2NrKTsNCj4gKyAgICAgICBzcGluX3VubG9ja19i
aCgmeHBydC0+dHJhbnNwb3J0X2xvY2spOw0KPiANCj4gICAgICAgIC8qDQo+ICAgICAgICAgKiBE
ZXN0cm95IHNvY2tldHMgZXRjIGZyb20gdGhlIHN5c3RlbSB3b3JrcXVldWUgc28gdGhleSBjYW4N
Cj4g4oCUDQoNCkFncmVlZC4gV2hlbiBiYWNrcG9ydGluZyB0byBrZXJuZWxzIHRoYXQgYXJlIG9s
ZGVyIHRoYW4gNS4zLngsIHRoZSB0cmFuc3BvcnQgbG9jayBuZWVkcyB0byBiZSB0YWtlbiB1c2lu
ZyB0aGUgYmgtc2FmZSBzcGluIGxvY2sgdmFyaWFudHMuDQoNClJldmlld2VkLWJ5OiBUcm9uZCBN
eWtsZWJ1c3QgPHRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20gPG1haWx0bzp0cm9uZC5t
eWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tPj4NCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFt
bWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0K
