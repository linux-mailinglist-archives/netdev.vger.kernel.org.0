Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485116406DD
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiLBMdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiLBMdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:33:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1B098E96
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:33:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0PwmfM7bg/hZjkyfC5gEnac6yYVPHAQelOaJz/Ho/grh4Xz6U6Ebf1MTpjKyAQ507QiRrNz7qCi9LqK383rFY5x8RXCzJDk/we/wlP91Knlb7Dl5cOOyDVOBEWtMwe5SVVlqBsfACza6pbj6/MJ9/5qdUBzOg62MGJl0fTa+QxwhA6yPD4t5fxy9Dp472QAgUhbjo3PxZQ/XtlOqJ28GXNzXWXRhSgwOb/m3aeoS3vcxSzG9b5zEZQRWqlzZrHrt5q8/XlMjbiCwDnaD/y46wSdQqDqsU2eTpykKGHkOrLxI481DtFNuxTxfi2BojA83jEQNgdk5mFtXH07ZH7IrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daUdNc06nLDa/bNEVegMH2cLRCP+VotVTyFQASbkaIM=;
 b=eK73Uez14+a+IOSdiaMXfi7CIIEgvddKqScvwFFfYVXiyeAIN6ZUkd1OBojxd/vusv6Ct4hP6g6nblLke8XnQzti9x8rl4ByAZPsQplTg+9T/Gtvr3dIUd7cCOhhff8nns3YqCLI2YNtgKusmJPxpt0Q6bwiy3/CLwwKQkDfW1Twf4ZGaVmVLZtVuzJ/Vqs2TTXEXW7xw5mCKqTtRxaMm5LDtElN8KV3c2IKMWvt9xbOh2/3nHNgRV8eXe29iwRonH5OUmh79v/uVVhjieChtRLrWmFOx6j1yS4mLPuN2d2IPhRcz9dtfNXNdEVQVxgyWwWDNPSQrnFWGZ4bksNe3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daUdNc06nLDa/bNEVegMH2cLRCP+VotVTyFQASbkaIM=;
 b=Cj88FCSlB3p03sU67P6/a9z3asOnfAMa1UKCwCOLhNxjNDU1zLILkinjWaajFHMmYAIpORoOQbkHMAyeTcT+DyOpewFqU85TVKQ8NkEfmjTkO460qCpCyJr1dqCcx49hUWWLJq9EoYnnE4alVVriwBHyVRrz1Np1/XTUqxOtjDE=
Received: from PH0PR13MB4793.namprd13.prod.outlook.com (2603:10b6:510:7a::12)
 by CO3PR13MB5670.namprd13.prod.outlook.com (2603:10b6:303:17e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 12:33:10 +0000
Received: from PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489]) by PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 12:33:10 +0000
From:   Tianyu Yuan <tianyu.yuan@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>
CC:     Marcelo Leitner <mleitner@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: RE: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Topic: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Index: AQHY/mSdmThOr7A34UyDPeUsz+fSLa5OwOIAgAAoYjCAAMvsAIAENEkQgABvloCAAAG8AIAABGCAgAGCGgCAAPMOMIADvx+AgAACRRA=
Date:   Fri, 2 Dec 2022 12:33:10 +0000
Message-ID: <PH0PR13MB4793ED98F9384F2CBBA0909094179@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
 <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
 <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
 <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com>
 <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
 <A92B3AD9-296F-4B20-88AC-D9F4124C15A9@redhat.com>
In-Reply-To: <A92B3AD9-296F-4B20-88AC-D9F4124C15A9@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB4793:EE_|CO3PR13MB5670:EE_
x-ms-office365-filtering-correlation-id: 3c1995e8-6b34-4a60-94ec-08dad4615f33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gFQbF8L/hxLXcQjyf8Gtoi5jYPHq9ITV6w2SoAfGNk5O9nxEazRUaDbCBr82HfMFbdc5kLSBhS++O90GHtlaTN+zP20UyLu/6+hFVnGwaQFT2lSyOPQygVrC1oZ2iYR/BMynxmX3/mi72ojI1gZ3QdT8+BvHewOlBgcglRVwSfTr7n/bRhtPNuBRCP9mkGiKErY4A2nr4gzwofxh8jpLU9R6+MFU/OBwQbRTx/5cbjguyXLaMmL4jD+HHMrTFW2eGtnYgyNfcpltV8DN6Bg/XqrLKTqVD8/hF/ZnkoV4I84/qmDoNFczSbHaoNLAFQSFdVvVaRZ+Y++YfXZX9khyhYDVxtJ8nibVZS/sIa9G0+Z1RP5YZpah9V6xcPXytNGho/WxYYJLWiso+MfEj4iKTyPZTlRsu5VwUBlAgvBlE5BY7n8npc6fME+iZFq8/TSwmTgpEHBJJ0Y8HY4N7zvL0R+8jGcWI1jqdOLvPyg4cucWgfgjBeXG+862anImkqL7sn6RVbmeonxiXxBFXtgE2UY9iOeKMyU//nKgow5oE17XlNWDOlAKP/Eo8TIWz5uqN+I40S/14DG7MhVvkn39FiBAgUSnRsnPadF1zDsiDSruapo2m75Sgxii/39HglFekzwKXIwkeuWO5ByF2uoIH+H+bEi4LqNfMP/kb0Y5RKTKxUVgsLqRYtRJ9gaBkioejOT2hkQEjjXDL9Phex2kLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4793.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(39840400004)(396003)(346002)(451199015)(53546011)(83380400001)(6506007)(7696005)(107886003)(71200400001)(478600001)(76116006)(64756008)(8676002)(4326008)(7416002)(41300700001)(52536014)(8936002)(66946007)(66446008)(66476007)(66556008)(2906002)(5660300002)(44832011)(122000001)(33656002)(55016003)(54906003)(38100700002)(316002)(86362001)(26005)(9686003)(6916009)(186003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tjd4b3VWYUlpMk91SmY4MUdLOWROaFZZaGFYVzZ1YmF1MHcySGoxb2dCWUo2?=
 =?utf-8?B?eWtzTm1PM3FONXJzcTA2Ui9ZejNXOXFoZ0h0U0lGL2gxUzJoOVdCQUxlNnN0?=
 =?utf-8?B?cDN3TXRJMmVlUW8yTnZvMTF0MmY2THRnRVQ3MTIxakp6bVZ5TWVBcEJyUTVx?=
 =?utf-8?B?bFd0MEM5MVhPVllOeFo5M1I4OGhIRDI1QWZZeUV2cjlCNHNFWWtYVURLTEZW?=
 =?utf-8?B?MjNBWENKL2hDRW5DemRYbDRBSEI2blphWG9BbnROSnhQVEdxR2sxN0ZSRHZ0?=
 =?utf-8?B?a2NuVmtiTkxjRlpyNXFPbVdwMWxnMzh0Y2dKNUZkeFdMRmZuZ1FuMlFiOUFj?=
 =?utf-8?B?Q0ROU081NzM2N3RQSTNlWkkyMHUvemkycllwZWc2N1lOSGdVZFIzNjg4VVY0?=
 =?utf-8?B?UEhkYVhoWUxjVDg0L2JMUS9zRzBzd2cyaGF2NmIrWUFJWVhTVVBEMVVocHBx?=
 =?utf-8?B?emxBT0JscHRJakpSMVBua2h0YWo5R2U0bVJsSTJLMUVxNGNlb2ZBQVRYZURj?=
 =?utf-8?B?N21NOHZzaE1BdGFwblUvcXBMeFlKYnAxRVVjbUw4cHYrSVpsR3FpdE9RMCti?=
 =?utf-8?B?QXF0S2M0c29ybVo4U0VHUWd5bHI2dDVSem9GVVlDMjgzcko5c1IzdmVDRnVH?=
 =?utf-8?B?cWZjTHJtUUlRaUpTRFVCMlpQVmxOUWhWcXJiVUk5Z0JXMGdZZWZ3d0lZaGxu?=
 =?utf-8?B?RUN6eUVUTVM1Wk9RdHJaNUs2UDlpeXR2ZEMrWnVsUDNoMkdDK3FCOFE1V2ZE?=
 =?utf-8?B?ZVk1NzNlVUZiUDJUNFIrTjJ6eVRNQnBJQTlVRGdJMXdNZmJYYnJRQytGVFdN?=
 =?utf-8?B?Y3d2cFZsY3hHYzFOZzh1TXFVSEFMdlY5TGdiZkdJNGpORHIyaWVpWEdRc2hQ?=
 =?utf-8?B?MWphT0hscGxKdE1qVy9kTDZIV0hMdjNMZEN5eGc0ZTFJc0RwcjVSVGc4dGV5?=
 =?utf-8?B?MEZCWGhMRUplZVBaTjhGREFxcklxN0oyVVlCQXVQOWp6WHVmeEtNUDFBSG5I?=
 =?utf-8?B?ZFdsRU1qVWM1eVJDWndadzVscW8rMDVDQXNzMTRCempwVFVGOEFIOXhkQnZv?=
 =?utf-8?B?R1BXbTRmVURhN3lsdFdJQ2xDL2h1NWhPbFZXNGV1UlA1bGl0SWM0Z0JuL1Ny?=
 =?utf-8?B?eXUxR0tDalVVTnhHdHBVVWp4bTloT3BSbUo0MnAwTjV6eENjUENlQzRSMktp?=
 =?utf-8?B?VTJoOVdnN3BUTXlTL1hreGR2ZHpXZjIrMGFMUEpNYXZnd0QwZzhkVzdjUzU1?=
 =?utf-8?B?M1hKSm1aaDN4cWQ0dEQ5TzNOVzhvbVdzY3JMckJHYzQrSW0rRGZkaVQvYTRR?=
 =?utf-8?B?VUxqc1dkUGhYUnl1NHJRZElMVnBWRWl2S2U5Mm5hZGpXcm5DdE1NSHNDZ01Y?=
 =?utf-8?B?Y3U0OXhsczJmQ1BBcUsxTlBXWHdtdFVBTFBySzR2cUtYWEdIZUhmVUx3S0ZR?=
 =?utf-8?B?ZktLNXZiQmxaSjVnQlNqTFBHbHZNVzN3OVJFamVmMDJHMXdoZEZUdUlSMGg4?=
 =?utf-8?B?L1ZnTGFGVUFxVC85WjNaZkxyM2NJZFlzUUVuVkRoUHBhRFA0NjNFMHJrdXpZ?=
 =?utf-8?B?SjVJZTdkNjRYb1VrNzlteEZiQ3psTHJ5Q3J0OFFQYnRpdXFQcjZTN0RURDVz?=
 =?utf-8?B?UUZJOTNFemxiaE5VMCtaRzVFRDBlbU5mTWEvaTFJYnRrVWV4aHNIbEg2R1hY?=
 =?utf-8?B?eFpDVENWQjRIRGpYYWFMWWV5ODZYTVY0cm9qdW9JV3VZaENkVS9zUnVnaXAv?=
 =?utf-8?B?WUtEK3BDYTVEU1J3YzV1VmhMNU00QmZCa082b3RySjdYeGJGbTg3NXJRSDEy?=
 =?utf-8?B?bzY3bG1YdS9ibWE1VUM5Z2YrQlNhZTVOazFrdjVZbDRZTTI0YkhWemhZck0w?=
 =?utf-8?B?QTE2NGZwM05lQWFwcG9RSDJpamc3M0hTWVoxRWdyU1U5US9hdFBNMWo5ckNl?=
 =?utf-8?B?SlFPMi9GUkppcmJvTzZUUHZoVEtCUnRleFdkbWVtL0VLK0krWURVa0Njdktu?=
 =?utf-8?B?SHE4Z3RGc2kvWkVOVWY0ZzV1Ri95MnBjMVZyWXZ1MjBwNGpBbGpHVHhJcDd1?=
 =?utf-8?B?aE9XTzN3RkUvcXc0bkhEUGlIajUwTkJMdE9nYTYyL2c5bTJYK0I0eVUvZmJl?=
 =?utf-8?Q?397dYEztzjUsgZ3dWtI6vjEPm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4793.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1995e8-6b34-4a60-94ec-08dad4615f33
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 12:33:10.0322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YegbsZC82SsvslsJbROgVF9Gx68X3IHh2zYIEpSFYHW044sVGH/OepI7vfCDKREdDgRgtyIFb2ZHqxpqVEW2jws6d8KN0ZtLY6pYJ73XQu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5670
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBGcmksIERlYyAyLCAyMDIyIGF0IDg6MTggUE0gLCBFZWxjbyBDaGF1ZHJvbiB3cm90ZToN
Cj4gDQo+IE9uIDMwIE5vdiAyMDIyLCBhdCA0OjM2LCBUaWFueXUgWXVhbiB3cm90ZToNCj4gDQo+
ID4gT24gTW9uLCBOb3YgMjksIDIwMjIgYXQgODozNSBQTSAsIEVlbGNvIENoYXVkcm9uIHdyb3Rl
Og0KPiA+Pg0KPiA+PiBPbiAyOCBOb3YgMjAyMiwgYXQgMTQ6MzMsIE1hcmNlbG8gTGVpdG5lciB3
cm90ZToNCj4gPj4NCj4gPj4+IE9uIE1vbiwgTm92IDI4LCAyMDIyIGF0IDAyOjE3OjQwUE0gKzAx
MDAsIEVlbGNvIENoYXVkcm9uIHdyb3RlOg0KPiA+Pj4+DQo+ID4+Pj4NCj4gPj4+PiBPbiAyOCBO
b3YgMjAyMiwgYXQgMTQ6MTEsIE1hcmNlbG8gTGVpdG5lciB3cm90ZToNCj4gPj4+Pg0KPiA+Pj4+
PiBPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCAwNzoxMTowNUFNICswMDAwLCBUaWFueXUgWXVhbiB3
cm90ZToNCj4gPj4+IC4uLg0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IEZ1cnRoZXJtb3JlLCBJIHRoaW5r
IHRoZSBjdXJyZW50IHN0YXRzIGZvciBlYWNoIGFjdGlvbiBtZW50aW9uZWQNCj4gPj4+Pj4+IGlu
DQo+ID4+Pj4+PiAyKSBjYW5ub3QgcmVwcmVzZW50IHRoZSByZWFsIGh3IHN0YXRzIGFuZCB0aGlz
IGlzIHdoeSBbIFJGQw0KPiA+Pj4+Pj4gbmV0LW5leHQgdjIgMC8yXSAobmV0OiBmbG93X29mZmxv
YWQ6IGFkZCBzdXBwb3J0IGZvciBwZXIgYWN0aW9uDQo+ID4+Pj4+PiBodyBzdGF0cykNCj4gPj4g
d2lsbCBjb21lIHVwLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBFeGFjdGx5LiBUaGVuLCB3aGVuIHRoaXMg
cGF0Y2hzZXQgKG9yIHNpbWlsYXIpIGNvbWUgdXAsIGl0IHdvbid0DQo+ID4+Pj4+IHVwZGF0ZSBh
bGwgYWN0aW9ucyB3aXRoIHRoZSBzYW1lIHN0YXRzIGFueW1vcmUuIEl0IHdpbGwgcmVxdWlyZSBh
DQo+ID4+Pj4+IHNldCBvZiBzdGF0cyBmcm9tIGh3IGZvciB0aGUgZ2FjdCB3aXRoIFBJUEUgYWN0
aW9uIGhlcmUuIEJ1dCBpZg0KPiA+Pj4+PiBkcml2ZXJzIGFyZSBpZ25vcmluZyB0aGlzIGFjdGlv
biwgdGhleSBjYW4ndCBoYXZlIHNwZWNpZmljIHN0YXRzDQo+ID4+Pj4+IGZvciBpdC4gT3IgYW0g
SSBtaXNzaW5nIHNvbWV0aGluZz8NCj4gPj4+Pj4NCj4gPj4+Pj4gU28gaXQgaXMgYmV0dGVyIGZv
ciB0aGUgZHJpdmVycyB0byByZWplY3QgdGhlIHdob2xlIGZsb3cgaW5zdGVhZA0KPiA+Pj4+PiBv
ZiBzaW1wbHkgaWdub3JpbmcgaXQsIGFuZCBsZXQgdnN3aXRjaGQgcHJvYmUgaWYgaXQgc2hvdWxk
IG9yDQo+ID4+Pj4+IHNob3VsZCBub3QgdXNlIHRoaXMgYWN0aW9uLg0KPiA+Pj4+DQo+ID4+Pj4g
UGxlYXNlIG5vdGUgdGhhdCBPVlMgZG9lcyBub3QgcHJvYmUgZmVhdHVyZXMgcGVyIGludGVyZmFj
ZSwgYnV0DQo+ID4+Pj4gZG9lcyBpdA0KPiA+PiBwZXIgZGF0YXBhdGguIFNvIGlmIGl04oCZcyBz
dXBwb3J0ZWQgaW4gcGlwZSBpbiB0YyBzb2Z0d2FyZSwgd2Ugd2lsbA0KPiA+PiB1c2UgaXQuIElm
IHRoZSBkcml2ZXIgcmVqZWN0cyBpdCwgd2Ugd2lsbCBwcm9iYWJseSBlbmQgdXAgd2l0aCB0aGUg
dGMgc29mdHdhcmUNCj4gcnVsZSBvbmx5Lg0KPiA+Pj4NCj4gPj4+IEFoIHJpZ2h0LiBJIHJlbWVt
YmVyIGl0IHdpbGwgcGljayAxIGludGVyZmFjZSBmb3IgdGVzdGluZyBhbmQgdXNlDQo+ID4+PiB0
aG9zZSByZXN1bHRzIGV2ZXJ5d2hlcmUsIHdoaWNoIHRoZW4gSSBkb24ndCBrbm93IGlmIGl0IG1h
eSBvciBtYXkNCj4gPj4+IG5vdCBiZSBhIHJlcHJlc2VudG9yIHBvcnQgb3Igbm90LiBBbnlob3cs
IHRoZW4gaXQgc2hvdWxkIHVzZQ0KPiA+Pj4gc2tpcF9zdywgdG8gdHJ5IHRvIHByb2JlIGZvciB0
aGUgb2ZmbG9hZGluZyBwYXJ0LiBPdGhlcndpc2UgSSdtDQo+ID4+PiBhZnJhaWQgdGMgc3cgd2ls
bCBhbHdheXMgYWNjZXB0IHRoaXMgZmxvdyBhbmQgdHJpY2sgdGhlIHByb2JpbmcsIHllcy4NCj4g
Pj4NCj4gPj4gV2VsbCwgaXQgZGVwZW5kcyBvbiBob3cgeW91IGxvb2sgYXQgaXQuIEluIHRoZW9y
eSwgd2Ugc2hvdWxkIGJlDQo+ID4+IGhhcmR3YXJlIGFnbm9zdGljLCBtZWFuaW5nIHdoYXQgaWYg
eW91IGhhdmUgZGlmZmVyZW50IGhhcmR3YXJlIGluDQo+ID4+IHlvdXIgc3lzdGVtPyBPVlMgb25s
eSBzdXBwb3J0cyBnbG9iYWwgb2ZmbG9hZCBlbmFibGVtZW50Lg0KPiA+Pg0KPiA+PiBUaWFueXUg
aG93IGFyZSB5b3UgcGxhbm5pbmcgdG8gc3VwcG9ydCB0aGlzIGZyb20gdGhlIE9WUyBzaWRlPyBI
b3cNCj4gPj4gd291bGQgeW91IHByb2JlIGtlcm5lbCBhbmQvb3IgaGFyZHdhcmUgc3VwcG9ydCBm
b3IgdGhpcyBjaGFuZ2U/DQo+ID4NCj4gPiBDdXJyZW50bHkgaW4gdGhlIHRlc3QgZGVtbywgSSBq
dXN0IGV4dGVuZCBnYWN0IHdpdGggUElQRSAocHJldmlvdXNseQ0KPiA+IG9ubHkgU0hPVCBhcyBk
ZWZhdWx0IGFuZCBHT1RPX0NIQUlOIHdoZW4gY2hhaW4gZXhpc3RzKSwgYW5kIHRoZW4gcHV0DQo+
ID4gc3VjaCBhIGdhY3Qgd2l0aCBQSVBFIGF0IHRoZSBmaXJzdCBwbGFjZSBvZiBlYWNoIGZpbHRl
ciB3aGljaCB3aWxsIGJlIHRyYW5zYWN0ZWQNCj4gd2l0aCBrZXJuZWwgdGMuDQo+ID4NCj4gPiBB
Ym91dCB0aGUgdGMgc3cgZGF0YXBhdGggbWVudGlvbmVkLCB3ZSBkb24ndCBoYXZlIHRvIG1ha2Ug
Y2hhbmdlcw0KPiA+IGJlY2F1c2UgZ2FjdCB3aXRoIFBJUEUgaGFzIGFscmVhZHkgYmVlbiBzdXBw
b3J0ZWQgaW4gY3VycmVudCB0Yw0KPiA+IGltcGxlbWVudGF0aW9uIGFuZCBpdCBjb3VsZCBhY3Qg
bGlrZSBhICdjb3VudGVyJyBBbmQgZm9yIHRoZSBoYXJkd2FyZQ0KPiA+IHdlIGp1c3QgbmVlZCB0
byBpZ25vcmUgdGhpcyBQSVBFIGFuZCB0aGUgc3RhdHMgb2YgdGhpcyBhY3Rpb24gd2lsbCBzdGls
bCBiZQ0KPiB1cGRhdGVkIGluIGtlcm5lbCBzaWRlIGFuZCBzZW50IHRvIHVzZXJzcGFjZS4NCj4g
DQo+IEkga25vdyBpdOKAmXMgc3VwcG9ydGVkIG5vdywgYnV0IGlmIHdlIGltcGxlbWVudCBpdCwg
aXQgbWlnaHQgZmFpbCBpbiBleGlzdGluZw0KPiBlbnZpcm9ubWVudHMuIFNvIGZyb20gYW4gT1ZT
IHVzZXJzcGFjZSBwZXJzcGVjdGl2ZSwgeW91IG5lZWQgdG8NCj4gaW1wbGVtZW50IHNvbWV0aGlu
ZyBsaWtlOg0KDQpJJ3ZlIGdvdCB5b3VyIHBvaW50IG5vdywgc29ycnkgZm9yIG15IG1pc3VuZGVy
c3RhbmRpbmcgcHJldmlvdXNseS4NCj4gDQo+IC0gUHJvYmUgdGhlIGtlcm5lbCB0byBzZWUgaWYg
dGhpcyBwYXRjaCBpcyBhcHBsaWVkLCBpZiBub3QgdXNlIHRoZSBvbGQgbWV0aG9kIHNvDQo+IHdl
IGRvIG5vdCBicmVhayBleGlzdGluZyBkZXBsb3ltZW50cyB3aGVuIHVwZ3JhZGluZyBPVlMgYnV0
IG5vdCB0aGUNCj4ga2VybmVsLg0KPiAtIElmIHdlIGRvIGhhdmUgdGhpcyBuZXdlciBrZXJuZWws
IGRvIHdlIGFzc3VtZSBhbGwgZHJpdmVycyB0aGF0IHdvcmtlZA0KPiBiZWZvcmUsIG5vdyBhbHNv
IHdvcms/DQo+ICAgLSBJZiB0aGlzIGlzIG5vdCB0aGUgY2FzZSwgaG93IHdpbGwgeW91IGRldGVy
bWluZSB3aGF0IGFwcHJvYWNoIHRvIHVzZT8gV2UNCj4gZG8gbm90IGhhdmUgYSBwZXItaW50ZXJm
YWNlIGxheWVyLCBidXQgYSBwZXItZGF0YXBhdGggb25lLCBpLmUuIHRoZSBrZXJuZWwuIFdlDQo+
IGRvIG5vdCBrbm93IGF0IGluaXRpYWxpemF0aW9uIHRpbWUgd2hhdCBOSUNzIHdpbGwgYmUgYWRk
ZWQgbGF0ZXIgYW5kIHdlIGNhbg0KPiBub3QgZGVjaWRlIG9uIHRoZSBzdHJhdGVneSB0byB1c2Uu
DQo+IA0KPiBUaG91Z2h0PyBNYXliZSB0aGlzIHNob3VsZCBiZSBkaXNjdXNzZWQgb3V0c2lkZSBv
ZiB0aGUgbmV0ZGV2IG1haWxpbmcgbGlzdCwNCj4gYnV0IHdoYXQgSSB3YW50IHRvIGhpZ2hsaWdo
dCBpcyB0aGF0IHRoZXJlIHNob3VsZCBiZSBhIHJ1bnRpbWUgd2F5IHRvDQo+IGRldGVybWluZSBp
ZiB0aGlzIHBhdGNoIGlzIGFwcGxpZWQgdG8gdGhlIGtlcm5lbCAod2l0aG91dCB1c2luZyBhbnkg
YWN0dWFsIGh3DQo+IGRyaXZlcikuDQoNCkkgYWdyZWUgdGhhdCB3aGV0aGVyIHRoZSBwYXRjaCBp
cyBhcHBsaWVkIGluIGtlcm5lbCBzaG91bGQgYmUgY2hlY2tlZCBhdCBydW50aW1lIHJhdGhlciB0
aGFuDQpjb21waWxpbmcgKGZvciB0aGUgZGVtbyBJIG1hZGUgdGhpcyBjaGVjayBpbmFjaW5sdWRl
Lm00KS4gSSB0aGluayBJIG5lZWQgc29tZSB0aW1lIHRvIGludmVzdGlnYXRlDQpob3cgdG8gaW1w
bGVtZW50IGl0LiBXZSBtYXkgZGlzY3VzcyBpdCBsYXRlciBpbiBhbiBPVlMgbWFpbGluZyBsaXN0
Lg0KDQpUaGFua3MsDQpUaWFueXUNCj4gDQo+IC8vRWVsY28NCj4gDQo+ID4gSSBhZ3JlZSB3aXRo
IHRoYXQgdGhlIHVuc3VwcG9ydGVkIGFjdGlvbnMgc2hvdWxkIGJlIHJlamVjdGVkIGJ5DQo+ID4g
ZHJpdmVycywgc28gbWF5IGFub3RoZXIgYXBwcm9hY2ggY291bGQgd29yayB3aXRob3V0IGlnbm9y
aW5nIFBJUEUgaW4NCj4gPiBhbGwgdGhlIHJlbGF0ZWQgZHJpdmVycywgdGhhdCB3ZSBkaXJlY3Rs
eSBtYWtlIHB1dCB0aGUgZmxvd2VyIHN0YXRzDQo+ID4gZnJvbSBkcml2ZXIgaW50byB0aGUgc29j
a2V0IHdoaWNoIGlzIHVzZWQgdG8gdHJhbnNhY3Qgd2l0aCB1c2Vyc3BhY2UgYW5kDQo+IHVzZXJz
cGFjZShlLmcuIE9WUykgdXBkYXRlIHRoZSBmbG93IHN0YXRzIHVzaW5nIHRoaXMgc3RhdHMgaW5z
dGVhZCBvZiB0aGUNCj4gcGFyc2luZyB0aGUgYWN0aW9uIHN0YXRzLiBIb3cgZG8geW91IHRoaW5r
IG9mIHRoaXM/DQoNCg==
