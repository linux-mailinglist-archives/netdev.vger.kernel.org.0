Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710BA47A718
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhLTJc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:32:27 -0500
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com ([104.47.56.173]:6265
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229513AbhLTJc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 04:32:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3mw5x4UTw6cbyvqDwuc8V01pBCyWip8zZ3Ab426lzPkd6MebIeKn+7bFsCADF4P0EonTrusO2YC3EVpZUPxezLmunMWKN86mm29XRe4Cv2qR0xt3def69AEBHQW1vBuC0FasYUFmx9M4wcN5vIw1uzldNJEBXQ4BKEhECCNjF8vfo9POx6Kw4BuZ30fMje84AVhQe9HiLzouPCyKQP1KMERMMZ0Tx8eOJ3qPM7OUBVeZqqBYInHecRCHS8Y967a1RojOXM4GuHOJIJxwgLKhluN6mD7NsyZVREwBjalhkSgsWNkZIgQSPE99QHQv94mprbNbezYJENe8Zb9tnoKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4G1IKNI8EraUqAANHisBRB0vw3VMDtilF6uMz1yaeD8=;
 b=KaBeNS2NGhv8N3N/RO6U6aRNsTWQ63Kv/SjsR0TG5VWS9iOAdSzlW+hADvVXSUqCGyyLaCaN9O4h62lFyRKq6G+uO6D57+j/lRfKSCmmjMRunAx5wdbYr+jk8emBLGqxuPCjnDvm9OrdepK3n60k/Tpff4W4K0MPfLLY8xmcnXpLYdHpQDuN2c0hs3icRlWzivDO5eT0/Hufk1gYZRfCdg6JrWl0KWwuUsS25vdyvUlwg4MVHNeIU+p+2C+KaMXQ9Q6PEKqRNnS9MOzxjKJVvTw3fekqj0lJInQLOKZjJjwTJKqgP00ESm83Wpg4rXvF0vbw/HUJOuwtBb9APL1+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4G1IKNI8EraUqAANHisBRB0vw3VMDtilF6uMz1yaeD8=;
 b=okPUDCzCARWf9pL7ebhp+v3JfSIgqoioPSR4na6rzl7rcEWlKU2R49hTfVshCwlUsawQuk7oUzrBsdvN7zxc31saQlPzt7pCk7I9FLpl4ViiGqmQDYG9pZvmGTvDydX4a62PjrpnJGXJ4QqM2hPWgs64uoS8LMK8z+DkjY1WvcQ=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by MN2PR13MB4104.namprd13.prod.outlook.com (2603:10b6:208:24e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.7; Mon, 20 Dec
 2021 09:32:23 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4823.014; Mon, 20 Dec 2021
 09:32:23 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Louis Peens <louis.peens@corigine.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v8 net-next 06/13] flow_offload: allow user to offload tc
 action to net device
Thread-Topic: [PATCH v8 net-next 06/13] flow_offload: allow user to offload tc
 action to net device
Thread-Index: AQHX83JfWsf+MSJLiUyMjDH0GmbXNaw7FbmAgAALPLA=
Date:   Mon, 20 Dec 2021 09:32:23 +0000
Message-ID: <DM5PR1301MB21723F73786883C7FEC0D1CFE77B9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
 <20211217181629.28081-7-simon.horman@corigine.com>
 <3d678d71-cc44-1824-7b9b-c12482078be6@gmail.com>
In-Reply-To: <3d678d71-cc44-1824-7b9b-c12482078be6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d1d4826-0bb4-450b-1de8-08d9c39ba0ad
x-ms-traffictypediagnostic: MN2PR13MB4104:EE_
x-microsoft-antispam-prvs: <MN2PR13MB410404873B462CB568CD1E87E77B9@MN2PR13MB4104.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hDFoQTh9BpGyt8xKNkBYNHWp6NqjyXgEWhws7/pawmHGq2kxnU2BieAeC4KkBEfqn8mfSnU8ruW0fiQHaH6kJp0x4OWBrN+uudbYpxvi4hOOoLaCJQ9amnunttFRSekaK59k7r0ZyXCTDN3wtncA7RJ6m2xcBSa21JxaQnxeC+he9vFYcMC5EgIz9zzcrbrJKPcIP/tNqs/+6QQDqPRRBB0ltOiFuAHCirHkNRPqgihbTtDM20/pqoJMJODhv1XdkE0NvNZt1Tv/IbUkE94kuouw1YFkhjkBkkzZLp9MU5PwMxC1u/axU8QMJJ8fX6nMx5KToxUTlTLu/h6wOoS++MXnFaTaDUIuUX9hf5UkDn8gL6odBpPxhYqAo3Vocc62gcyRvxXcBK8FdNbrx5h8h+shcW6iYoMBBqQTqwr125AT4hr6AXDV7bFvw9yJ4SFFNevWIg5J+YhP7cnGUYof+o6qXhyyFv2lwmh2E3RNGQT+oNDuYjAUXQCQITV3C44nfciJxxtyVX59ytZAWvESo0rM+V6ZZ/gedCAOUzsmBwZMm6D+UWkrZnjGs0Ufg7ujv0wRxYt+pZZQ0KsIHURPEDAo+kjJnmJKdClNBUDC3LVrC/qOcNJpS5zzHQjk7Wo99OWpC7/CKPxZqXCbZ6uT5DbMBmuHR+kBrhPPdhq55Xosp/nQdJmOV/80mUNnby17+4U9/1F/Tp0p3We58v6k5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(376002)(346002)(39830400003)(366004)(83380400001)(2906002)(316002)(33656002)(76116006)(110136005)(54906003)(86362001)(66946007)(7416002)(38100700002)(44832011)(5660300002)(122000001)(9686003)(186003)(26005)(508600001)(8936002)(66556008)(66476007)(66446008)(38070700005)(6506007)(64756008)(4326008)(8676002)(107886003)(71200400001)(7696005)(52536014)(55016003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlhSMnF5elg1b1FmS0JQN0JLTEwxMis0RGtQQk5lL2s3cUVvTkR4N2N5UDhM?=
 =?utf-8?B?ZlExNU5rQm1TeEZ5NHpzWWFncGhlazNUdHZxWjh5SVhUUWhzV0xXcWZRdGtB?=
 =?utf-8?B?Smg3Q21rVmlPNytCUk1qZDYxNTNnd0ZzZURqL0gzU3IwQ1VnK1JORHZEKzQy?=
 =?utf-8?B?SnZ2Nm1iTWp5NmNuanpsU0owSEE3bUtzTmNXVk5MbGhSSDlsN3Qydzk4Qm5y?=
 =?utf-8?B?R2cwaEZaVjNWUEZXM24zRzVsMk5hNENEYm5wV25rSmtEQ0RtVHkvSm5ZcTJF?=
 =?utf-8?B?dU9iODE0dGY0SEg0YkJTQjhVNitEdFltUk5HVklTNVhOR3NOUVl2dTJCM3Rq?=
 =?utf-8?B?cVRKR1JiZ2F1bFQrQVEvRVl0RjBsdlVreEdIMzMwdzRZSjZ2R045b0txRW10?=
 =?utf-8?B?K2gvTWNDTTdRcHlLTTFwZUpCd2kwbk5XSkZFeEpRNDVCa3RNSFY5Zmt6SDZZ?=
 =?utf-8?B?anl5T2ZCQzRkZnpPMDFqQ0M5V0tsZ1ZlWVZ5RllDazl1MUpZbkJUQ2h5cERG?=
 =?utf-8?B?TnUxeTBzNTh1S3VnWHliQ2tCaXhJOEMxUmQ0VXAzWmJsRG13LzRZYXZ3NklH?=
 =?utf-8?B?b2tTb2VtZ21WSytxUGlzeExKRzVFbkNXNGNqTWd3cEVsaUQ5VTlvbVR2b2ZL?=
 =?utf-8?B?Y1N3bEdZbHozc0VHazc1czhER2xMVzdPK1p4a1pwTnR6ZGxQMWJWemVGMjEw?=
 =?utf-8?B?T1h2eGFYZmZmOVdEWk5BVlVreGFPRysyQlUwYURHaFEwSldNS1VCT1ZQenR3?=
 =?utf-8?B?eDQ5Z3JGV3QxOE56ZEhrOUZRNUVGVmxGc0VlYnhVY2hTczlIeGYxTzZNOTRZ?=
 =?utf-8?B?ZUxuL28veHFjTDh2OFdQMUYyTDV0ckZSYTZxYXgwdS9GVGdGYlpXNXFaQ0tN?=
 =?utf-8?B?VHhKNVNKMzY1a1U2aVl6Qjd0bkFqVGtkaXcxNHFUUzlhRmpqMHJHOXJzZTBG?=
 =?utf-8?B?ZFo1eEJyMGhyZFZGOU1RY0VGTEI1Wnd5ZmRCa3VXM0NjWTVHVVQ2OHRraGhi?=
 =?utf-8?B?ZmhBaWJSWSsrc2lVYTVFM1EzUmlPVmtqVHJ5bDBMTTBtOE55bjdBT1grR2lx?=
 =?utf-8?B?amZSZzFRc0xHZHpxbldsYXBQM1YwTlcydVg0WjhseGNQcFZsMTRRMktYTU9z?=
 =?utf-8?B?elVtc216ZkVTVW9iUkxTSmllanVXUWFqRGR2aERyeXhWbWpNMFRaQWowSnF1?=
 =?utf-8?B?UVc3VE9xemFZSTJJbStnK2t3NTk3cjVpZ0ZjU0U1czdpaVZtakpzUERoSnR3?=
 =?utf-8?B?TWJjYTRVUVVEVzh3RUpRV2JxQ3gzUWY1M3RraEU0TnZFVnp0alA4S21jTFhZ?=
 =?utf-8?B?eTRuaC9zemZmbWE4ZWhCcUJNMlR3R0xlMVBMcFdqS2E4dFc0ellWZkorTHUw?=
 =?utf-8?B?ME9kdGJ5bVJ5M2drNVhzdUpOODdiOWhIRUkwQUNtd2g1VmY4YUNuQ0VOekhl?=
 =?utf-8?B?QU9xRTUwWDYyNzJyYmpISXlaK2ZhYVNTL0lTSDhoUlVGOGRMbW5JMXA4YVNv?=
 =?utf-8?B?OVdmRzdCUXVHQ054MUJjWmwyZGU0ampoVFllaWs4ZXNYTFlZUEVsZkgra0JS?=
 =?utf-8?B?NytvODZsRGI2aUFwYnlwYUpvSitTeUJCVVB2MHJyQWVFOUorMGsweG54UGc0?=
 =?utf-8?B?NHpkbnVnWVNhZGRXazVvUWpRK0VkQUt5cUlPYmRIcGpxUE5JQjBkVmJHTzJm?=
 =?utf-8?B?ZGgvSTBrZ0NrZ08wNEQ2U3dKdUU3Y3hhc3d2a0JVcVQvVC9wWG5mSy85aTQ0?=
 =?utf-8?B?a2p5MWoyREpnU3FDcDErVEkrdC85bVlqMGYvNVdibEg2bkgvNU9zWGtobkJj?=
 =?utf-8?B?ZEtlUnA5ZnNwL24xUUdRVjRFZ1VHZ2ZVaUp4M2lxRFVJVlFDbzB1R3RQcmZH?=
 =?utf-8?B?Y3hVM2FqYWVhcWhBQW9VRFY5NWZkVGRXeldPb1l3cDJTV2ZtZkw3RmFKRTlD?=
 =?utf-8?B?UWtXZEdncWgxOUdyMzVmeldEZnFpY0VtNGJBdHhkOXpXVEptSVJsWDZiaWtX?=
 =?utf-8?B?dk9GWkRNTm1kRWNkL01IZ0dra0dGbDhLZnh0cVUyYUVTTU9zTzcwSFVKUjlj?=
 =?utf-8?B?Vkg4eHVMSk5OSW91cWFQZjVCaEw4S2tkREtsZGhyM3YzZ0tQTnJJMVJVQU41?=
 =?utf-8?B?YlZONGljMUwrWnhKZUt3ZnkzYUZCYXRKNm01bUdkUDZOaUNGSkYvc1BBSXNQ?=
 =?utf-8?B?STh0QnlUaHJacTNJMXFEa1dJVlRERkZKQnpBWHFXMFE1a2VCQ1ZGK1YzSzZv?=
 =?utf-8?B?WjJPeG9udVBwTWNJMHZkYklraTFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1d4826-0bb4-450b-1de8-08d9c39ba0ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 09:32:23.1153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pjVXj4ZH5fKGzsTDwpPxy91kQitqPKQsbnpdlAvX6xE6PrMU7h04YNFHAj2Xub8Ucp2sicQM1q9p+hICJTV4zA0jqyYy4TpLlEUd8eueSmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRXJpYywgdGhhbmtzIGZvciBicmluZyB0aGlzIHRvIHVzLiBXZSB3aWxsIG1ha2Ugc29tZSB2
ZXJpZmljYXRpb24gYW5kIGZpeCB0aGlzIEFTQVAuDQpDb3VsZCB5b3UgcGxlYXNlIG1ha2Ugc29t
ZSBkZXNjcmlwdGlvbiBvbiBob3cgdG8gdHJpZ2dlciB0aGlzIGlzc3VlPyANCg0KT24gRGVjZW1i
ZXIgMjAsIDIwMjEgNDo0OCBQTSwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPk9uIDEyLzE3LzIxIDEw
OjE2IEFNLCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBGcm9tOiBCYW93ZW4gWmhlbmcgPGJhb3dl
bi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+Pg0KPj4gVXNlIGZsb3dfaW5kcl9kZXZfcmVnaXN0ZXIv
Zmxvd19pbmRyX2Rldl9zZXR1cF9vZmZsb2FkIHRvIG9mZmxvYWQgdGMNCj4+IGFjdGlvbi4NCj4+
DQo+PiBXZSBuZWVkIHRvIGNhbGwgdGNfY2xlYW51cF9mbG93X2FjdGlvbiB0byBjbGVhbiB1cCB0
YyBhY3Rpb24gZW50cnkNCj4+IHNpbmNlIGluIHRjX3NldHVwX2FjdGlvbiwgc29tZSBhY3Rpb25z
IG1heSBob2xkIGRldiByZWZjbnQsIGVzcGVjaWFsbHkNCj4+IHRoZSBtaXJyb3IgYWN0aW9uLg0K
Pj4NCj4+IFNpZ25lZC1vZmYtYnk6IEJhb3dlbiBaaGVuZyA8YmFvd2VuLnpoZW5nQGNvcmlnaW5l
LmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IExvdWlzIFBlZW5zIDxsb3Vpcy5wZWVuc0Bjb3JpZ2lu
ZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTaW1vbiBIb3JtYW4gPHNpbW9uLmhvcm1hbkBjb3Jp
Z2luZS5jb20+DQo+PiAtLS0NCj4NCj4NCj5IaSB0aGVyZS4NCj4NCj4NCj5JIHRoaW5rIHRoaXMg
aXMgY2F1c2luZyB0aGUgZm9sbG93aW5nIHN5emJvdCBzcGxhdCwgcGxlYXNlIHRha2UgYSBsb29r
LCB0aGFua3MgIQ0KPg0KPg0KPldBUk5JTkc6IHN1c3BpY2lvdXMgUkNVIHVzYWdlDQo+NS4xNi4w
LXJjNS1zeXprYWxsZXIgIzAgTm90IHRhaW50ZWQNCj4tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPmluY2x1ZGUvbmV0L3RjX2FjdC90Y190dW5uZWxfa2V5Lmg6MzMgc3VzcGljaW91cw0K
PnJjdV9kZXJlZmVyZW5jZV9wcm90ZWN0ZWQoKSB1c2FnZSENCj4NCj5vdGhlciBpbmZvIHRoYXQg
bWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOg0KPg0KPg0KPnJjdV9zY2hlZHVsZXJfYWN0aXZlID0g
MiwgZGVidWdfbG9ja3MgPSAxDQo+MSBsb2NrIGhlbGQgYnkgc3l6LWV4ZWN1dG9yMzkzLzM2MDI6
DQo+IMKgIzA6IGZmZmZmZmZmOGQzMTM5NjggKHJ0bmxfbXV0ZXgpeysuKy59LXszOjN9LCBhdDog
cnRubF9sb2NrDQo+bmV0L2NvcmUvcnRuZXRsaW5rLmM6NzIgW2lubGluZV0NCj4gwqAjMDogZmZm
ZmZmZmY4ZDMxMzk2OCAocnRubF9tdXRleCl7Ky4rLn0tezM6M30sIGF0OiBydG5sX2xvY2sNCj5u
ZXQvY29yZS9ydG5ldGxpbmsuYzo3MiBbaW5saW5lXSBuZXQvY29yZS9ydG5ldGxpbmsuYzo1NTY3
DQo+IMKgIzA6IGZmZmZmZmZmOGQzMTM5NjggKHJ0bmxfbXV0ZXgpeysuKy59LXszOjN9LCBhdDoN
Cj5ydG5ldGxpbmtfcmN2X21zZysweDNiZS8weGI4MCBuZXQvY29yZS9ydG5ldGxpbmsuYzo1NTY3
DQo+bmV0L2NvcmUvcnRuZXRsaW5rLmM6NTU2Nw0KPg0KPnN0YWNrIGJhY2t0cmFjZToNCj5DUFU6
IDEgUElEOiAzNjAyIENvbW06IHN5ei1leGVjdXRvcjM5MyBOb3QgdGFpbnRlZCA1LjE2LjAtcmM1
LXN5emthbGxlciAjMA0KPkhhcmR3YXJlIG5hbWU6IEdvb2dsZSBHb29nbGUgQ29tcHV0ZSBFbmdp
bmUvR29vZ2xlIENvbXB1dGUgRW5naW5lLA0KPkJJT1MNCj5Hb29nbGUgMDEvMDEvMjAxMQ0KPkNh
bGwgVHJhY2U6DQo+IMKgPFRBU0s+DQo+IMKgX19kdW1wX3N0YWNrIGxpYi9kdW1wX3N0YWNrLmM6
ODggW2lubGluZV0NCj4gwqBfX2R1bXBfc3RhY2sgbGliL2R1bXBfc3RhY2suYzo4OCBbaW5saW5l
XSBsaWIvZHVtcF9zdGFjay5jOjEwNg0KPiDCoGR1bXBfc3RhY2tfbHZsKzB4Y2QvMHgxMzQgbGli
L2R1bXBfc3RhY2suYzoxMDYgbGliL2R1bXBfc3RhY2suYzoxMDYNCj4gwqBpc190Y2ZfdHVubmVs
X3NldCBpbmNsdWRlL25ldC90Y19hY3QvdGNfdHVubmVsX2tleS5oOjMzIFtpbmxpbmVdDQo+IMKg
aXNfdGNmX3R1bm5lbF9zZXQgaW5jbHVkZS9uZXQvdGNfYWN0L3RjX3R1bm5lbF9rZXkuaDozMyBb
aW5saW5lXQ0KPm5ldC9zY2hlZC9hY3RfdHVubmVsX2tleS5jOjgzMg0KPiDCoHRjZl90dW5uZWxf
a2V5X29mZmxvYWRfYWN0X3NldHVwKzB4NGYyLzB4YTIwDQo+bmV0L3NjaGVkL2FjdF90dW5uZWxf
a2V5LmM6ODMyIG5ldC9zY2hlZC9hY3RfdHVubmVsX2tleS5jOjgzMg0KPiDCoG9mZmxvYWRfYWN0
aW9uX2luaXQgbmV0L3NjaGVkL2FjdF9hcGkuYzoxOTQgW2lubGluZV0NCj4gwqBvZmZsb2FkX2Fj
dGlvbl9pbml0IG5ldC9zY2hlZC9hY3RfYXBpLmM6MTk0IFtpbmxpbmVdDQo+bmV0L3NjaGVkL2Fj
dF9hcGkuYzoyNjMNCj4gwqB0Y2ZfYWN0aW9uX29mZmxvYWRfYWRkX2V4KzB4Mjc5LzB4NTUwIG5l
dC9zY2hlZC9hY3RfYXBpLmM6MjYzDQo+bmV0L3NjaGVkL2FjdF9hcGkuYzoyNjMNCj4gwqB0Y2Zf
YWN0aW9uX29mZmxvYWRfYWRkIG5ldC9zY2hlZC9hY3RfYXBpLmM6Mjk0IFtpbmxpbmVdDQo+IMKg
dGNmX2FjdGlvbl9vZmZsb2FkX2FkZCBuZXQvc2NoZWQvYWN0X2FwaS5jOjI5NCBbaW5saW5lXQ0K
Pm5ldC9zY2hlZC9hY3RfYXBpLmM6MTQzOQ0KPiDCoHRjZl9hY3Rpb25faW5pdCsweDYwMS8weDg2
MCBuZXQvc2NoZWQvYWN0X2FwaS5jOjE0MzkNCj5uZXQvc2NoZWQvYWN0X2FwaS5jOjE0MzkNCj4g
wqB0Y2ZfYWN0aW9uX2FkZCsweGY5LzB4NDgwIG5ldC9zY2hlZC9hY3RfYXBpLmM6MTk0MA0KPm5l
dC9zY2hlZC9hY3RfYXBpLmM6MTk0MA0KPiDCoHRjX2N0bF9hY3Rpb24rMHgzNDYvMHg0NzAgbmV0
L3NjaGVkL2FjdF9hcGkuYzoxOTk5DQo+bmV0L3NjaGVkL2FjdF9hcGkuYzoxOTk5DQo+IMKgcnRu
ZXRsaW5rX3Jjdl9tc2crMHg0MTMvMHhiODAgbmV0L2NvcmUvcnRuZXRsaW5rLmM6NTU3MA0KPm5l
dC9jb3JlL3J0bmV0bGluay5jOjU1NzANCj4gwqBuZXRsaW5rX3Jjdl9za2IrMHgxNTMvMHg0MjAg
bmV0L25ldGxpbmsvYWZfbmV0bGluay5jOjI0OTINCj5uZXQvbmV0bGluay9hZl9uZXRsaW5rLmM6
MjQ5Mg0KPiDCoG5ldGxpbmtfdW5pY2FzdF9rZXJuZWwgbmV0L25ldGxpbmsvYWZfbmV0bGluay5j
OjEzMTUgW2lubGluZV0NCj4gwqBuZXRsaW5rX3VuaWNhc3Rfa2VybmVsIG5ldC9uZXRsaW5rL2Fm
X25ldGxpbmsuYzoxMzE1IFtpbmxpbmVdDQo+bmV0L25ldGxpbmsvYWZfbmV0bGluay5jOjEzNDEN
Cj4gwqBuZXRsaW5rX3VuaWNhc3QrMHg1MzMvMHg3ZDAgbmV0L25ldGxpbmsvYWZfbmV0bGluay5j
OjEzNDENCj5uZXQvbmV0bGluay9hZl9uZXRsaW5rLmM6MTM0MQ0KPiDCoG5ldGxpbmtfc2VuZG1z
ZysweDkwNC8weGRmMCBuZXQvbmV0bGluay9hZl9uZXRsaW5rLmM6MTkxNw0KPm5ldC9uZXRsaW5r
L2FmX25ldGxpbmsuYzoxOTE3DQo+IMKgc29ja19zZW5kbXNnX25vc2VjIG5ldC9zb2NrZXQuYzo3
MDQgW2lubGluZV0NCj4gwqBzb2NrX3NlbmRtc2dfbm9zZWMgbmV0L3NvY2tldC5jOjcwNCBbaW5s
aW5lXSBuZXQvc29ja2V0LmM6NzI0DQo+IMKgc29ja19zZW5kbXNnKzB4Y2YvMHgxMjAgbmV0L3Nv
Y2tldC5jOjcyNCBuZXQvc29ja2V0LmM6NzI0DQo+IMKgX19fX3N5c19zZW5kbXNnKzB4NmU4LzB4
ODEwIG5ldC9zb2NrZXQuYzoyNDA5IG5ldC9zb2NrZXQuYzoyNDA5DQo+IMKgX19fc3lzX3NlbmRt
c2crMHhmMy8weDE3MCBuZXQvc29ja2V0LmM6MjQ2MyBuZXQvc29ja2V0LmM6MjQ2Mw0KPiDCoF9f
c3lzX3NlbmRtc2crMHhlNS8weDFiMCBuZXQvc29ja2V0LmM6MjQ5MiBuZXQvc29ja2V0LmM6MjQ5
Mg0KPiDCoGRvX3N5c2NhbGxfeDY0IGFyY2gveDg2L2VudHJ5L2NvbW1vbi5jOjUwIFtpbmxpbmVd
DQo+IMKgZG9fc3lzY2FsbF94NjQgYXJjaC94ODYvZW50cnkvY29tbW9uLmM6NTAgW2lubGluZV0N
Cj5hcmNoL3g4Ni9lbnRyeS9jb21tb24uYzo4MA0KPiDCoGRvX3N5c2NhbGxfNjQrMHgzNS8weGIw
IGFyY2gveDg2L2VudHJ5L2NvbW1vbi5jOjgwDQo+YXJjaC94ODYvZW50cnkvY29tbW9uLmM6ODAN
Cj4gwqBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8weGFlDQo+UklQOiAwMDMz
OjB4N2Y4OTY5MzJiMmE5DQo+Q29kZTogMjggYzMgZTggMmEgMTQgMDAgMDAgNjYgMmUgMGYgMWYg
ODQgMDAgMDAgMDAgMDAgMDAgNDggODkgZjggNDggODkNCj5mNyA0OCA4OSBkNiA0OCA4OSBjYSA0
ZCA4OSBjMiA0ZCA4OSBjOCA0YyA4YiA0YyAyNCAwOCAwZiAwNSA8NDg+IDNkIDAxDQo+ZjAgZmYg
ZmYgNzMgMDEgYzMgNDggYzcgYzEgYzAgZmYgZmYgZmYgZjcgZDggNjQgODkgMDEgNDgNCj5SU1A6
IDAwMmI6MDAwMDdmZmVmZjZjYzRkOCBFRkxBR1M6IDAwMDAwMjQ2IE9SSUdfUkFYOiAwMDAwMDAw
MDAwMDAwMDJlDQo+UkFYOiBmZmZmZmZmZmZmZmZmZmRhIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBS
Q1g6IDAwMDA3Zjg5NjkzMmIyYTkNCj5SRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAw
MDIwMDAwMzAwIFJESTogMDAwMDAwMDAwMDAwMDAwMw0KPg0KPg0KPg0KPj4gICBpbmNsdWRlL2xp
bnV4L25ldGRldmljZS5oICB8ICAxICsNCj4+ICAgaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgg
fCAxNyArKysrKysrDQo+PiAgIGluY2x1ZGUvbmV0L3BrdF9jbHMuaCAgICAgIHwgIDUgKysNCj4+
ICAgbmV0L2NvcmUvZmxvd19vZmZsb2FkLmMgICAgfCA0MiArKysrKysrKysrKysrLS0tLQ0KPj4g
ICBuZXQvc2NoZWQvYWN0X2FwaS5jICAgICAgICB8IDkzDQo+KysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCj4+ICAgbmV0L3NjaGVkL2FjdF9jc3VtLmMgICAgICAgfCAgNCAr
LQ0KPj4gICBuZXQvc2NoZWQvYWN0X2N0LmMgICAgICAgICB8ICA0ICstDQo+PiAgIG5ldC9zY2hl
ZC9hY3RfZ2FjdC5jICAgICAgIHwgMTMgKysrKystDQo+PiAgIG5ldC9zY2hlZC9hY3RfZ2F0ZS5j
ICAgICAgIHwgIDQgKy0NCj4+ICAgbmV0L3NjaGVkL2FjdF9taXJyZWQuYyAgICAgfCAxMyArKysr
Ky0NCj4+ICAgbmV0L3NjaGVkL2FjdF9tcGxzLmMgICAgICAgfCAxNiArKysrKystDQo+PiAgIG5l
dC9zY2hlZC9hY3RfcG9saWNlLmMgICAgIHwgIDQgKy0NCj4+ICAgbmV0L3NjaGVkL2FjdF9zYW1w
bGUuYyAgICAgfCAgNCArLQ0KPj4gICBuZXQvc2NoZWQvYWN0X3NrYmVkaXQuYyAgICB8IDExICsr
KystDQo+PiAgIG5ldC9zY2hlZC9hY3RfdHVubmVsX2tleS5jIHwgIDkgKysrLQ0KPj4gICBuZXQv
c2NoZWQvYWN0X3ZsYW4uYyAgICAgICB8IDE2ICsrKysrKy0NCj4+ICAgbmV0L3NjaGVkL2Nsc19h
cGkuYyAgICAgICAgfCAyMSArKysrKysrLS0NCj4+ICAgMTcgZmlsZXMgY2hhbmdlZCwgMjU0IGlu
c2VydGlvbnMoKyksIDIzIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L25ldGRldmljZS5oIGIvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPj4gaW5kZXgg
YTQxOTcxODYxMmM2Li44YjBiZGViNDczNGUgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4
L25ldGRldmljZS5oDQo+PiArKysgYi9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQo+PiBAQCAt
OTIwLDYgKzkyMCw3IEBAIGVudW0gdGNfc2V0dXBfdHlwZSB7DQo+PiAgIAlUQ19TRVRVUF9RRElT
Q19UQkYsDQo+PiAgIAlUQ19TRVRVUF9RRElTQ19GSUZPLA0KPj4gICAJVENfU0VUVVBfUURJU0Nf
SFRCLA0KPj4gKwlUQ19TRVRVUF9BQ1QsDQo+PiAgIH07DQo+Pg0KPj4gICAvKiBUaGVzZSBzdHJ1
Y3R1cmVzIGhvbGQgdGhlIGF0dHJpYnV0ZXMgb2YgYnBmIHN0YXRlIHRoYXQgYXJlIGJlaW5nIHBh
c3NlZA0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oIGIvaW5jbHVk
ZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4+IGluZGV4IDIyNzFkYTVhYThlZS4uNWI4YzU0ZWI3YTZi
IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4+ICsrKyBiL2lu
Y2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+PiBAQCAtNTUxLDYgKzU1MSwyMyBAQCBzdHJ1Y3Qg
Zmxvd19jbHNfb2ZmbG9hZCB7DQo+PiAgIAl1MzIgY2xhc3NpZDsNCj4+ICAgfTsNCj4+DQo+PiAr
ZW51bSBvZmZsb2FkX2FjdF9jb21tYW5kICB7DQo+PiArCUZMT1dfQUNUX1JFUExBQ0UsDQo+PiAr
CUZMT1dfQUNUX0RFU1RST1ksDQo+PiArCUZMT1dfQUNUX1NUQVRTLA0KPj4gK307DQo+PiArDQo+
PiArc3RydWN0IGZsb3dfb2ZmbG9hZF9hY3Rpb24gew0KPj4gKwlzdHJ1Y3QgbmV0bGlua19leHRf
YWNrICpleHRhY2s7IC8qIE5VTEwgaW4gRkxPV19BQ1RfU1RBVFMNCj5wcm9jZXNzKi8NCj4+ICsJ
ZW51bSBvZmZsb2FkX2FjdF9jb21tYW5kICBjb21tYW5kOw0KPj4gKwllbnVtIGZsb3dfYWN0aW9u
X2lkIGlkOw0KPj4gKwl1MzIgaW5kZXg7DQo+PiArCXN0cnVjdCBmbG93X3N0YXRzIHN0YXRzOw0K
Pj4gKwlzdHJ1Y3QgZmxvd19hY3Rpb24gYWN0aW9uOw0KPj4gK307DQo+PiArDQpbLi5dDQo=
