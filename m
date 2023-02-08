Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F86968F1ED
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjBHPYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 10:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjBHPYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 10:24:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB00943910;
        Wed,  8 Feb 2023 07:24:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/hrs9fxhKbBh1Tc9GPZEjTud3BuVCI4UconWSVrWMr5Kq66IxuoZrTRpDrG8EMd6vuJH+QB+b1uQnjVvsyS9XUg1RCzbsZfIAiB5VCp+xoLoh9LPmT664hQlHX4VOe6EX4M8+AwiG4sEWKgRX7GYdxtI8WRb0ZXR22g+TZKOvzNwUyQr3IZACV9/18Ap5suE6JESXDBZ7pjjkXS6oPz3GHEccDmJDkTGJRZS3Q1YMah1UuvGhQOUJHc4wdhWVGYkeIe5XE4SYcJ0/lxqt4vBEdkI3VMs5IEk9w1Lcp6pHBpkPtEo41vrPbU71mJRuOuugF8VNj0qT4Q+s7VChZYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fke028GyB2xHQKk+aRVashlH1ySX0/ug7tVEM6Wf3yU=;
 b=g2mK9m4uXW8LRcNct+zbNvRh+OQoYCK3rG0H9YZT3QoJHfDridV1XwVe4TE+OG+i8W9+GZxlWEGBVlzhO2Ym5D5Vzj7Q+jT34pcMyVOpnTSIFzkikPkgI9flgcfXWIBRSZpqJba+pik3vmla4IJ1jtDhHd/HbWUHZz5osviTszcOXTD6qLEs9wsrQZlUUKnj54TrLYdPAgz8ND5NVo2fXmx9ro9W853UiBqUQOJ6J1eJsW0sDWGdSlLx+lM1rmVfa+z2oggQSJpHtqfU312HF1yg5Oz0dMTOqo110O8OxZ9VyMHhf+TnqwBzuvtXLM9sbVtlBsO9/VeKsOidpFdhkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fke028GyB2xHQKk+aRVashlH1ySX0/ug7tVEM6Wf3yU=;
 b=WrV1TZZqql1ncPfgFWhkcmD0tJQVBxbgfZJwcZQkej0B3jw8R9+hOAUNo88dC5VzdSmcLLeNhgWuOfjS52lS7GWmCQjAO244yXZLa+0TX2bnERgqPTpym8tsd85XiS+UklpAeYQfMI5Spg+/IFFhKlo1WpXJhw7/CEpW88ZLppM=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by BY5PR12MB4918.namprd12.prod.outlook.com (2603:10b6:a03:1df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 15:24:39 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 15:24:39 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v6 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v6 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZO8k2arH7LrGh5UafCo1ruvtaz67FHpaAgAAMqIA=
Date:   Wed, 8 Feb 2023 15:24:39 +0000
Message-ID: <DM6PR12MB4202FE90A833282B28053DF7C1D89@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-3-alejandro.lucero-palau@amd.com>
 <Y+O0A5Bk/zWur76J@nanopsycho>
In-Reply-To: <Y+O0A5Bk/zWur76J@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4909.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|BY5PR12MB4918:EE_
x-ms-office365-filtering-correlation-id: 4b232e64-04ee-4d2b-4974-08db09e89823
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oye6sAdistDCkJsGOgE4xOzdMiauxWMZUesKOWF8+ikgVEPJktlAEEKcUgGCtaRR3eN2UoVvq5b9eieNM+e7BX4QFQI4Tsz2LFQmCj8jB/YBlbi0pp/xbUroW43gdu2ejRMbq33w2P+7k28LJyLkpdBwdN8ccNw8X+llOF808bYcgRvY6Q7P6lct32422lufRDsGZWU3ODiKf47klfb4pksJwu4WiMAlxtkzuhQwU7wxBJv2H59D6Z9ZiKKW6qbGUx1gObZkUAhR1givWORf5WRFxWwRaaW2n9AzZYefEZP1jfnWHNRyHbZcLrSB9Ca02qFa0bQdPxzKCVmZEeyOWhmJJEi9mmqhRkhy9qPN7E4uvQkHAlk+T6+O7AJOTWkrVVLB6vzekkl1AZFrsiIj2jZQZyq9K5+Yb3twVIi5iYVKpEaADF11erBqv0zH6B9CZgGc6PuF94OXaT/AodzUt+22uGFYWIesdF6REdy+QjS4RXDnWQF6qmnMgRNb+UlWs1M0GrKCooJ5li+R8NhIiAbpqyhlVHTQv5Yw4/YGwohu0HqwTAV6e80EMUVvn2ytsFmAqhduQAHMRd/E/Pnls96Iv2/Vocaa6VR16lT1V7NKprI0LP4+OAqBu0Zb5GUTFkoq6zVetlmnaHOuGTD+nyfv42LQFacpNdGE7MpLJ27VqHncEqouQ4zqVaumyJmPi+tEtgtoKGmpYJMolKwnkzXptXh+0fnz0l94i8fEBibD7alPs9B9X/rxhC9M+i9z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199018)(5660300002)(7416002)(2906002)(83380400001)(55016003)(38100700002)(76116006)(38070700005)(8676002)(122000001)(4326008)(66946007)(54906003)(6636002)(110136005)(66476007)(52536014)(8936002)(33656002)(64756008)(66446008)(66556008)(41300700001)(186003)(53546011)(6506007)(71200400001)(9686003)(26005)(316002)(7696005)(478600001)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmRLSXNGbXhrcTQrdVByNS8vMDdNc3RkdzdUSDRYSGpWUSt0Y0RWdHpGOUdR?=
 =?utf-8?B?cmpuZVVNY2d6cncxMnNWazdRdjY5TVpsKzBRb0xhZk5DcmpZYzd5RG5BUVB6?=
 =?utf-8?B?Rmp3Uzkwa1dLdmdjallFbjhYcDc1ZmZhV2JveXFNU0dNTWdBYk1MVzZyZ05V?=
 =?utf-8?B?WnVWcytMMURCelp3b0Z2bmJTVUg2MGtIUVJySTQ5dDRhMjZ3NERHazN4NUc1?=
 =?utf-8?B?eXM3Y0s3L283MWNYZFN2ZVVxRFVUZ1R6YStCRHA4OXlhV2JpUHpVa0NKdXZC?=
 =?utf-8?B?QWhZYWNOOENpdXFDOVcwZDFCNVNsNllTZzNnRnQ5N1h0ayt0N0tlVmpKNk1F?=
 =?utf-8?B?eG5tTllleGVQcEpOYVZ6bExoajMvTHI2eGJBeFN5cFROcGI0QkFOU1AvNEhq?=
 =?utf-8?B?WVB2VnlWdTdHSEpvcXR1YmhPU2QxTzNyQUpjWUZEWmU5WC9pOGhVY3hYZGFy?=
 =?utf-8?B?NlZBWGRKT3JVUENXN2N2RFAvY3NNWVNycTltSlRZNW5rbUZKa0dwckhJWG9w?=
 =?utf-8?B?SjJ3Y2czUkkwYk5VcDU0dXF5Q1ZDdWJrZ3VZTjFkNS9EVktINDNVRE8xUzNC?=
 =?utf-8?B?T1NCZjlOcXNaUUFBaTMxcmFxWVZIYUxPR2hZUFZ5YURVUXRaLzBBLzA2cFlQ?=
 =?utf-8?B?ZGluM3Y0ZDVsZkhQUGp6Sm5STHBjOUI0RVdwRGFUUnlqMHV5dTJrVjQ3TTBB?=
 =?utf-8?B?VzVUaEczSE1MVHR0SUJCNTNEcDB3cHFhUnAyT0NqQ2Q3QnRyNDBxbE9pTFJ3?=
 =?utf-8?B?NnI5ZGRtRjFyS2N5NStVVG5YdDhNR3h4dkRJMEJ1SURtNFpKUmU2d3ZxNDkv?=
 =?utf-8?B?cEVaWXE2WnJxQlQyWmNiclUyNUREeEk1eTc4YmhFcVd5Ky9RRUVYdFdlZDNz?=
 =?utf-8?B?dTltOFEycG1KdFJyWVR6bVZ4VUx2KzRLa1JnNGhhMHprd2tZNC9MYVZxbVAw?=
 =?utf-8?B?TU5wNDFTWExkdURYY3dEZzdyWlJ1cVNjVVNjK1ZyTEJJSGkyT2xORk5CY1Fr?=
 =?utf-8?B?K002dmtSK1U3dzJ1Q1FWNU8ydzlNdlF4alFWeG5UaWIrSkgvTm12b0lXc1NR?=
 =?utf-8?B?TUNpVmxWeVBycCtxRDRSNjBLQldMWkQzVFp0VDc4SktSQnU0MEVtcG5GME5q?=
 =?utf-8?B?STlSQ1BRTlJPYjkxYnlVUTgvMklsQ1ZTRDJoQitsNVBvQkNESFdEd3lGWTZr?=
 =?utf-8?B?Vzd0ZXV0NUxwZW5LNGd2Tkc1MDBJSFVJT3l0YXcxMTAxeFRBUGJkL3lreVBE?=
 =?utf-8?B?ZE9CQXZkT1JrRHd3NGZuaTFvS1NFSXJqTkhSMVZwOStTaWRaUVVYZDBUYVlZ?=
 =?utf-8?B?ZjhlVml3ajFHbUhqU2VsNWpMWDFSeW16UnlNb2U4Mkk1ZDI1M0MwcHd1NEox?=
 =?utf-8?B?a1pFUVkyeG4rQm5jVVJJa1g3ai85Qy9xM3NrSnVnZW5sWU5RWms4cUxiYWJm?=
 =?utf-8?B?R2tZRktlTDdTaEd0Wi8xVDNmWUpVTWFLYU4remhCdURKdFd4b1lwaHJjMktR?=
 =?utf-8?B?ZzQ1Ylg1bDd0NUIwVW5Vc3ZyYTQwZFBXZS9qa2JWUEpJNTBVRXVqZ3hTdjRE?=
 =?utf-8?B?K3hkOXU1eGZnTlNRYUdrVGRRalNZb3lYUjBwZWNqU1RtTHVmWDR6dVVBRFdh?=
 =?utf-8?B?L3M3ZmFkOVRnR2M1NzJheHN2Vm9zK2hGZDlvZkV1bUk2WlJWMjJERmNCSGVY?=
 =?utf-8?B?MHdZSUprVzMwUXFKWkNWbThOcjJjUmhaQ1dYeis5djFaclliSkNkakp4aThv?=
 =?utf-8?B?UllZRmEzVS9JRU40QjVrL1RTSXQ0cWtud0h0ckcxWWRUcVlMQkVGUHRMZHZr?=
 =?utf-8?B?cmFpbVJ2MzhaQTg3NzhhbFdzMDgyTm5OZFd3Y0d4QW1YZkZ3c3dJNEdTMXBI?=
 =?utf-8?B?YU5Ia2dDOHlwcnBoTTUrRk9Qc3VScUlqNGJuRFRTSEpSM1lYaUFyMThWTEF4?=
 =?utf-8?B?bllTUXdsTVVtcEtpN3JnQVRmRVp5MUk2SDR0YkxKOHVOMllCTlhsd1A2U2FN?=
 =?utf-8?B?YnZSYTRVa1pDZkxGcldSRVJQUmh2d2NvM2ZXR3ErdDJMSytMcUlKMFhFZk5K?=
 =?utf-8?B?ZTltYWx0ZnNVbFZDUnRPQXF5SFhDT3VhL2p6Z1FRdVpBU1N3Z3hRT0tSc0RU?=
 =?utf-8?Q?vWTI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6FE2B14791D1D448420738E642B384E@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b232e64-04ee-4d2b-4974-08db09e89823
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 15:24:39.2100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IffcuoVaao8R/XcpbF6pGVYbg2OT8vvXTcYA4ufClJ2ba1X7yt/d8btU+sVZmISrpX6Gon/xfpCkglhp8DX4BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4918
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzgvMjMgMTQ6MzgsIEppcmkgUGlya28gd3JvdGU6DQo+IFdlZCwgRmViIDA4LCAyMDIz
IGF0IDAzOjI1OjEzUE0gQ0VULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6
DQo+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5j
b20+DQo+IFsuLl0NCj4NCj4NCj4+ICtzdGF0aWMgaW50IGVmeF9kZXZsaW5rX2luZm9fZ2V0KHN0
cnVjdCBkZXZsaW5rICpkZXZsaW5rLA0KPj4gKwkJCQlzdHJ1Y3QgZGV2bGlua19pbmZvX3JlcSAq
cmVxLA0KPj4gKwkJCQlzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+PiArew0KPj4g
KwlzdHJ1Y3QgZWZ4X2RldmxpbmsgKmRldmxpbmtfcHJpdmF0ZSA9IGRldmxpbmtfcHJpdihkZXZs
aW5rKTsNCj4+ICsJc3RydWN0IGVmeF9uaWMgKmVmeCA9IGRldmxpbmtfcHJpdmF0ZS0+ZWZ4Ow0K
Pj4gKwlpbnQgcmM7DQo+PiArDQo+PiArCS8qIFNldmVyYWwgZGlmZmVyZW50IE1DREkgY29tbWFu
ZHMgYXJlIHVzZWQuIFdlIHJlcG9ydCBmaXJzdCBlcnJvcg0KPj4gKwkgKiB0aHJvdWdoIGV4dGFj
ayBhbG9uZyB3aXRoIHRvdGFsIG51bWJlciBvZiBlcnJvcnMuIFNwZWNpZmljIGVycm9yDQo+PiAr
CSAqIGluZm9ybWF0aW9uIHZpYSBzeXN0ZW0gbWVzc2FnZXMuDQo+IEkgdGhpbmsgeW91IGZvcmdv
dCB0byByZW1vdmUgdGhpcyBjb21tZW50Lg0KPg0KPiBXaXRoIHRoaXMgbml0IGZpeGVkLCBmcmVl
IGZyZWUgdG8gYWRkOg0KPiBSZXZpZXdlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBudmlkaWEuY29t
Pg0KPg0KDQpJJ2xsIGRvLg0KDQpUaGFua3MNCg0KPg0KPj4gKwkgKi8NCj4+ICsJcmMgPSBlZnhf
ZGV2bGlua19pbmZvX2JvYXJkX2NmZyhlZngsIHJlcSk7DQo+PiArCWlmIChyYykgew0KPj4gKwkJ
TkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywgIkdldHRpbmcgYm9hcmQgaW5mbyBmYWlsZWQiKTsN
Cj4+ICsJCXJldHVybiByYzsNCj4+ICsJfQ0KPj4gKwlyYyA9IGVmeF9kZXZsaW5rX2luZm9fc3Rv
cmVkX3ZlcnNpb25zKGVmeCwgcmVxKTsNCj4+ICsJaWYgKHJjKSB7DQo+PiArCQlOTF9TRVRfRVJS
X01TR19NT0QoZXh0YWNrLCAiR2V0dGluZyBzdG9yZWQgdmVyc2lvbnMgZmFpbGVkIik7DQo+PiAr
CQlyZXR1cm4gcmM7DQo+PiArCX0NCj4+ICsJcmMgPSBlZnhfZGV2bGlua19pbmZvX3J1bm5pbmdf
dmVyc2lvbnMoZWZ4LCByZXEpOw0KPj4gKwlpZiAocmMpIHsNCj4+ICsJCU5MX1NFVF9FUlJfTVNH
X01PRChleHRhY2ssICJHZXR0aW5nIHJ1bm5pbmcgdmVyc2lvbnMgZmFpbGVkIik7DQo+PiArCQly
ZXR1cm4gcmM7DQo+PiArCX0NCj4+ICsNCj4+ICsJcmV0dXJuIDA7DQo+PiArfQ0KPj4gKyNlbmRp
Zg0KPiBbLi5dDQo+DQo=
