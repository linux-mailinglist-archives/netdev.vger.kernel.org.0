Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C4C5062A2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346871AbiDSDeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346806AbiDSDeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:34:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2100.outbound.protection.outlook.com [40.107.244.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13B72B24D;
        Mon, 18 Apr 2022 20:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKk8LhbPzB/zgbozLajSPQCGDXDHY5ccQX2m6fwLtSrh85P+d9rI5291iqUB1uAP9r8fzosf4TvAxc5PpOFy1IHenvf3wsTl7LwqogyO4C2NAd4t/WZ9ue/GM28LR3uhLWU+2wTp+CRMwra3z61bM6tYyf3oPnMwnQnQOU25yckJJWPnFr0+YUQAOiTaqaZUlhy72c1f04QNG1V8AtcxDKNuTJdFYHi8dD2XsVrHHjYywSInARtcwiNoHvlMmAQ2rc0QvPxnhjtp7pDnIaAoSgRdMo56DNNcDqxa6sLnmdzidKt7CZnjYAODvNqhFc1XJAcSC3wEJRGsuy+Ua5dUAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wx3/RzipBSIhO4pXlIYBy5J6P6Xb8bDt9k9grP3Yjy8=;
 b=KiLQirn0XGQu7490HfIfv2rVwodtyKcIvaQkghGsQeUcbLN2qGwPrqi8d/fX5ChCNDq64Js/DXoUp46aSuzxlGvMIJrbDbqOJ9OxmQnFdjcCuMHXZeJ59TiS4ZXpyVYIDAU6uIxkSav4OPlOr5iVWyE3vecH6GpRmY8VzVjP24Qn3T6hNqgZrB5Zrg2glgBROEkFhKvdAEXWFyDuLGQsgtU0d8MZ2H/W+n3Y38WsmJG2yfG8//i2R3GIN3WQDWsaFS1auJeWLw57r4H/r0fa0/GOMzZbOT5CcTb4D7PisEsJ/QZtOgQZFaMyBywGY2E+nXy4+jzpZITAFOAAuNTnyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx3/RzipBSIhO4pXlIYBy5J6P6Xb8bDt9k9grP3Yjy8=;
 b=JyNs9vHn+6cZke7uPkcJgUCw4nzuBlN0Ljdbw0OUr+oEcmSQWfTh3z/Y3hV2ZOfuk+ZuTuhXzASvd91r0Uht5N1q+dGeCq5IgBiuXFa9Vjpfi6hlG3U+VynKxSpfUS2YL+ueo6fJHDYg6ltw+1CvBRUJUxvQZQaDHB4GUkt3SuU=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MW4PR13MB6010.namprd13.prod.outlook.com (2603:10b6:303:132::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Tue, 19 Apr
 2022 03:31:38 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006%7]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 03:31:38 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC:     "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>
Subject: Re: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Topic: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Index: AQHYU0ShVuMmk9QygkCkWs0LWSNy16z2lWmA
Date:   Tue, 19 Apr 2022 03:31:38 +0000
Message-ID: <962bbdf09f6f446f26ea9b418ddfec60a23aed8d.camel@hammerspace.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d118883-510a-4ba7-d51a-08da21b51cfe
x-ms-traffictypediagnostic: MW4PR13MB6010:EE_
x-microsoft-antispam-prvs: <MW4PR13MB60106EB35C946F73B7DCDBC4B8F29@MW4PR13MB6010.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ZT4wwZWjLWYZOu1Cyzf5Ia1YL9EAZbobVAuPIJVUMoDWjBviOIN7pE6GRJGroWf9Xtvy1t8ZqkwHqUjeIApYZOIfbeVey8Dk9gLwAUXDeYI44pq5A3ti+Z1KxH+jgIKpzj3RPNTvICq96eG/wEHeyFiIfPen5r3SGtxOG9s3sONApJz8Sunpq9ohiP0s6R/O+UOh4x1x9J/xmVyATlg6tDuKOkeeVxRNP9GbwPHGLDLssFILgUAob98Y8KV0kas96XHlyz9H5rhPZgHAMNaeum9z8kqcaeVlZj92HahCTe8mhjHZkvLLHHtsZ8M8zvGvTmd1vMvH/R5xRn3mHbi8wSB1bTCdowILL/soX1tI4q2WJIjGO+71g9pzhzy6h+xHcWv+Sc7YSPB2lNk/4EgLAHMji173+sCcpX1CSjxNO4Z1wtfNyNvtrlzuhQsq4AuhAd0ZONgMo1yzZaNcwPbOBnIhOfmLvN3PAZ7SN8RNVko5LB0bhBMj7yUGPFIlpBNzU57n9etnCtXnVbDOEz/2UJekzKHJ31a3cc5TERJOC4GicjpugMwtsuGb5KtOmnrbtSWQTC50YiAUvLZGrEu0XL8ID+epu/CtTVqBnms0qdIqCUlvtvN2kXdGtplngAfkZvga0nNVObJtapmkffnOOdMmp0CPEKvGk0vrzjAVB56Di4n1plwOn5n/W8yzYOBhMOPdWBanXC4+8unF/DQf/ZVorKxe+zg1Ba+FCOuodrgQpp4fDf0y9e2ELBxEyRJmYkUm2jtEMOrsEN+IbGe93ekxZ1gtq4J+kR1HJQx89w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(36756003)(8936002)(6506007)(122000001)(38070700005)(508600001)(6512007)(2906002)(71200400001)(26005)(186003)(6486002)(966005)(110136005)(83380400001)(5660300002)(38100700002)(86362001)(66446008)(4326008)(66556008)(64756008)(66476007)(8676002)(2616005)(76116006)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzFXWk5rb1dUMDVoSXZWV2dHbzJwR3pWZmd6d3Z2d1dQcDRMQ3JibkpJSmRJ?=
 =?utf-8?B?UUhTVUo5WkNaQW5JU3duY0ZFWitLZEFyU3ZlTUM3L0hzTDl0ek0waGg2d0Ns?=
 =?utf-8?B?OE9WdGJ0MTBOQWNlckV4UC8vcnYxc01qKzA1NWFOdzV1RFJnUXRmTlZZeHU3?=
 =?utf-8?B?UXR3Zjdvb0JvMWtsTENCazMyZ00ydGdEckc0OC9XaGZWdHllaTAyaDBzcDEv?=
 =?utf-8?B?cFE3cXArRHVVU0dQYm42WURJMVdRQkhtS1d2R1pUUTh5TXpKYkt6U1RmaGlG?=
 =?utf-8?B?SXV3SWNSdDlDaUUxRjNZa0xGQnM2UGdtWFo3Q1lRcW1sS05Xd2pmaVFuYjM2?=
 =?utf-8?B?K0R1SGZzZFVIOExIN0ZHYmF6M2xHRENCbko5VWVGTHd6UVFySmVoQmVQZmxh?=
 =?utf-8?B?SWZlQUswRzVUUlRKdmNxVXQ4VEdkczNHRnlnWTZZb1hScE9hSFRFU0RIN1Jx?=
 =?utf-8?B?clJ5TStCT0VvUjFwaEdrblpxaVRzN3h0b0YxTHJrSjZpNnI4TXZINVdIQlAr?=
 =?utf-8?B?dUVVNjhFSHpnanhGMTRCRS82MFBxSHFYQXZ1cGZQUWg3Z245UGNUWFhTY0Q4?=
 =?utf-8?B?N3l6UXhYY2IyM0s3MXdPSFd2RERPQ09EREd3bFNCR2RwWDVPSmJuODZ6UERD?=
 =?utf-8?B?aU8xU0kxejlST3hNbzJXYVUwQ0R1YTNRcW9KazZ0eWJBUTN1YlJBVVhwdlRh?=
 =?utf-8?B?cC9nQWFwRzlScFI0dVNNL2NjU2NtcVN0V0hVY1VQUmE3Y3lORXVGWFBKckda?=
 =?utf-8?B?end3UUVXSWtJOUloVmRlTHloLzNIUWJuKzMrS0hBd3J2RzJtUTd2U0NxeExF?=
 =?utf-8?B?UWFTVU5WUVlBN0tOek1YaW1PQ0VjWndFM3YwT0tPeEtwK3Z5TWE2cEpacDRZ?=
 =?utf-8?B?U1BhZVpmL2w4ODZ5akVLMWVQcWdYMGxEVVR0N0cxd0xBWDFZRUsvdFpqcTVs?=
 =?utf-8?B?TUpiNnZHc2daZE1WOXJjbHZSQzBLNzVacFVheGlnclU0MDFZSnBWaDBWRklq?=
 =?utf-8?B?RlJMaDBKYU9PNEhKWnUvMTlIMUovV1BTVW1SbFVFc1g0Z2Y3ZWl5UjA3bS9u?=
 =?utf-8?B?Q05tY3ZaUFpFRkpzQ0ZHZmNYQ211bEQyWDF1OVRWQ3ROcVNiZFpmNWxZc0RO?=
 =?utf-8?B?ZkhnNG5KSzFKM01xbzdjbmI3WEhVa3Y0REZlR0MvVy96ekUwRXZKUTRVaFpN?=
 =?utf-8?B?dDlCMElVallmL0xveG54OEhtMTNNRHZyVTgwdlRKQzY4cDI1TVV1VGFIQUlK?=
 =?utf-8?B?cEhvOFZ0N2VoVTNnWk42eGpUTTVSY1J1UnU0TWJrTWU4c2kvOWRKUTVPQmZT?=
 =?utf-8?B?dHluSm9ibFE1RlR0OFlRbDQydFVYNmtGcmUwcDdTM3VVME9pVW42emxrZ1FV?=
 =?utf-8?B?T1lrTXFQSjY3T1JiWHZ6ZXU3dVJzZ2xENEZvMjFHM0NRN2VISVRydGdjcUhy?=
 =?utf-8?B?ck1LM1JVdDJxRFhNeTVnaUE1MVE4ODJaSG1uTHoyK0o3Rk55eWZMSndRaDBt?=
 =?utf-8?B?d1g3anY3cUdrdFZiVlJvNWJzRWpPNkp4ZmdzMFhBZXBwUkh4NFJ0dVB4b2RU?=
 =?utf-8?B?WXZjbENpQmZmRGduMHpaM3ZQM1ZGWWJtaU1pdWY2T0JkNWY4RTNWTHJTQmhK?=
 =?utf-8?B?aERydlc0TitVRlR3eUxJbkJybUpENERwOWxtM3BIR1BtbWlJOWZjQlNLZkwy?=
 =?utf-8?B?L0JXRUw4QkNnTVIvR1ZuYWhmbHU4ckx3dG12Ylg1U0VlQ0dqWFhRS01hMFNK?=
 =?utf-8?B?TW82eWxKQmJjbzkwS25ZSHBobkpBNmx1VUNSY0Z0eTVwMEVCTnQyaVFwWlhW?=
 =?utf-8?B?VTZWM0VqS3AzcnNPWE9lS1RnQTZPQlZ3SHE2VWNJcmYvZVBnbVZ3b0dvVXUr?=
 =?utf-8?B?QnNoczdHL29nSVVRZmpBendaOHNMTEpjb1FQRW5YYiszTEc1L1A0U1VNK3Uy?=
 =?utf-8?B?Y0tCMk94amNoVHZ2RDZRbGU2bmFWV0I4WXBSR2JZbC9UdG1KZ3VjcjNxREhH?=
 =?utf-8?B?VGhjaWIrS2hQY290dG13K1lHZ0ZPSHZQQ2JORVJmREMyTThsbUMxdjk4R1Bk?=
 =?utf-8?B?S0tockR0b3Y0bVgyd0M1cEtkK0VpbVl4azc1ck90RDllWlNnNVNEbUxrbitB?=
 =?utf-8?B?Z2VkTi9yUnh4cWhiSE1aVnpNcFFmcDdYWW1tOEV5VFBlQmZqbFpFdTd5YWVP?=
 =?utf-8?B?ZzFuWkovc1ZKdVdEN2hWVXU2RER2RnhmTjBFckNnWmpEV2FHWHNBRjFjMFE0?=
 =?utf-8?B?TndMMnBWeldub2wvZ0pnRVpQZGIvWExQTXpoNHkvalFMa0JwRlFHZWpiS0lL?=
 =?utf-8?B?SFVTRGpUUTlKczRZekQrVjI4WTZ2M0VtNUw0M1FleDdOOXVadjFySTZrN1Jl?=
 =?utf-8?Q?OeV6gQBjJw3Ohcz8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <915E1D1B2DA7144382FC84C4DB89D9A5@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d118883-510a-4ba7-d51a-08da21b51cfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 03:31:38.5293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /a6Z7ZLa8Jpvr5Gqcwa+8s0p5xjiCQH5iGDZj6h2PDjftIxI9xbBjX3fPOdk4jIZyjDi2758xUd4ziGFjVQByw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB6010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA0LTE4IGF0IDEyOjUxIC0wNDAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
VGhpcyBzZXJpZXMgaW1wbGVtZW50cyBSUEMtd2l0aC1UTFMgaW4gdGhlIExpbnV4IGtlcm5lbDoN
Cj4gDQo+IGh0dHBzOi8vZGF0YXRyYWNrZXIuaWV0Zi5vcmcvZG9jL2RyYWZ0LWlldGYtbmZzdjQt
cnBjLXRscy8NCj4gDQo+IFRoaXMgcHJvdG90eXBlIGlzIGJhc2VkIG9uIHRoZSBwcmV2aW91c2x5
IHBvc3RlZCBtZWNoYW5pc20gZm9yDQo+IHByb3ZpZGluZyBhIFRMUyBoYW5kc2hha2UgZmFjaWxp
dHkgdG8gaW4ta2VybmVsIFRMUyBjb25zdW1lcnMuDQo+IA0KPiBGb3IgdGhlIHB1cnBvc2Ugb2Yg
ZGVtb25zdHJhdGlvbiwgdGhlIExpbnV4IE5GUyBjbGllbnQgaXMgbW9kaWZpZWQNCj4gdG8gYWRk
IGEgbmV3IG1vdW50IG9wdGlvbjogeHBydHNlYyA9IFsgbm9uZXxhdXRvfHRscyBdIC4gVXBkYXRl
cw0KPiB0byB0aGUgbmZzKDUpIG1hbiBwYWdlIGFyZSBiZWluZyBkZXZlbG9wZWQgc2VwYXJhdGVs
eS4NCj4gDQoNCkknbSBmaW5lIHdpdGggaGF2aW5nIGEgdXNlcnNwYWNlIGxldmVsICdhdXRvJyBv
cHRpb24gaWYgdGhhdCdzIGENCnJlcXVpcmVtZW50IGZvciBzb21lb25lLCBob3dldmVyIEkgc2Vl
IG5vIHJlYXNvbiB3aHkgd2Ugd291bGQgbmVlZCB0bw0KaW1wbGVtZW50IHRoYXQgaW4gdGhlIGtl
cm5lbC4NCg0KTGV0J3MganVzdCBoYXZlIGEgcm9idXN0IG1lY2hhbmlzbSBmb3IgaW1tZWRpYXRl
bHkgcmV0dXJuaW5nIGFuIGVycm9yDQppZiB0aGUgdXNlciBzdXBwbGllcyBhICd0bHMnIG9wdGlv
biBvbiB0aGUgY2xpZW50IHRoYXQgdGhlIHNlcnZlcg0KZG9lc24ndCBzdXBwb3J0LCBhbmQgbGV0
IHRoZSBuZWdvdGlhdGlvbiBwb2xpY3kgYmUgd29ya2VkIG91dCBpbg0KdXNlcnNwYWNlIGJ5IHRo
ZSAnbW91bnQubmZzJyB1dGlsaXR5LiBPdGhlcndpc2Ugd2UnbGwgcmF0aG9sZSBpbnRvDQphbm90
aGVyIHR3aXN0eSBtYXplIG9mIHBvbGljeSBkZWNpc2lvbnMgdGhhdCBnZW5lcmF0ZSBrZXJuZWwg
bGV2ZWwgQ1ZFcw0KaW5zdGVhZCBvZiBhIHNldCBvZiBtb3JlIGdlbnRsZSBmaXhlcy4NCg0KPiBU
aGUgbmV3IG1vdW50IG9wdGlvbiBlbmFibGVzIGNsaWVudCBhZG1pbmlzdHJhdG9ycyB0byByZXF1
aXJlIGluLQ0KPiB0cmFuc2l0IGVuY3J5cHRpb24gZm9yIHRoZWlyIE5GUyB0cmFmZmljLCBwcm90
ZWN0aW5nIHRoZSB3ZWFrDQo+IHNlY3VyaXR5IG9mIEFVVEhfU1lTLiBBbiB4LjUwOSBjZXJ0aWZp
Y2F0ZSBpcyBub3QgcmVxdWlyZWQgb24gdGhlDQo+IGNsaWVudCBmb3IgdGhpcyBwcm90ZWN0aW9u
Lg0KDQpUaGF0IGRvZXNuJ3QgcmVhbGx5IGRvIG11Y2ggdG8gJ3Byb3RlY3QgdGhlIHdlYWsgc2Vj
dXJpdHkgb2YgQVVUSF9TWVMnLg0KSXQganVzdCBtZWFucyB0aGF0IG5vYm9keSBjYW4gdGFtcGVy
IHdpdGggb3VyIEFVVEhfU1lTIGNyZWRlbnRpYWwgd2hpbGUNCmluIGZsaWdodC4gSXQgaXMgc3Rp
bGwgcXVpdGUgcG9zc2libGUgZm9yIHRoZSBjbGllbnQgdG8gc3Bvb2YgYm90aCBpdHMNCklQIGFk
ZHJlc3MgYW5kIHVzZXIvZ3JvdXAgY3JlZGVudGlhbHMuDQoNCkEgYmV0dGVyIHJlY29tbWVuZGF0
aW9uIHdvdWxkIGJlIHRvIGhhdmUgdXNlcnMgc2VsZWN0IHN5cz1rcmI1IHdoZW4NCnRoZXkgaGF2
ZSB0aGUgYWJpbGl0eSB0byBkbyBzby4gRG9pbmcgc28gZW5zdXJlcyB0aGF0IGJvdGggdGhlIGNs
aWVudA0KYW5kIHNlcnZlciBhcmUgYXV0aGVudGljYXRpbmcgdG8gb25lIGFub3RoZXIsIHdoaWxl
IGFsc28gZ3VhcmFudGVlaW5nDQpSUEMgbWVzc2FnZSBpbnRlZ3JpdHkgYW5kIHByaXZhY3kuDQoN
Cj4gVGhpcyBwcm90b3R5cGUgaGFzIGJlZW4gdGVzdGVkIGFnYWluc3QgcHJvdG90eXBlIFRMUy1j
YXBhYmxlIE5GUw0KPiBzZXJ2ZXJzLiBUaGUgTGludXggTkZTIHNlcnZlciBpdHNlbGYgZG9lcyBu
b3QgeWV0IGhhdmUgc3VwcG9ydCBmb3INCj4gUlBDLXdpdGgtVExTLCBidXQgaXQgaXMgcGxhbm5l
ZC4NCj4gDQo+IEF0IGEgbGF0ZXIgdGltZSwgdGhlIExpbnV4IE5GUyBjbGllbnQgd2lsbCBhbHNv
IGdldCBzdXBwb3J0IGZvcg0KPiB4LjUwOSBhdXRoZW50aWNhdGlvbiAoZm9yIHdoaWNoIGEgY2Vy
dGlmaWNhdGUgd2lsbCBiZSByZXF1aXJlZCBvbg0KPiB0aGUgY2xpZW50KSBhbmQgUFNLLiBGb3Ig
dGhpcyBkZW1vbnN0cmF0aW9uLCBvbmx5IGF1dGhlbnRpY2F0aW9uLQ0KPiBsZXNzIFRMUyAoZW5j
cnlwdGlvbi1vbmx5KSBpcyBzdXBwb3J0ZWQuDQo+IA0KPiAtLS0NCj4gDQo+IENodWNrIExldmVy
ICgxNSk6DQo+IMKgwqDCoMKgwqAgU1VOUlBDOiBSZXBsYWNlIGRwcmludGsoKSBjYWxsIHNpdGUg
aW4geHNfZGF0YV9yZWFkeQ0KPiDCoMKgwqDCoMKgIFNVTlJQQzogSWdub3JlIGRhdGFfcmVhZHkg
Y2FsbGJhY2tzIGR1cmluZyBUTFMgaGFuZHNoYWtlcw0KPiDCoMKgwqDCoMKgIFNVTlJQQzogQ2Fw
dHVyZSBjbXNnIG1ldGFkYXRhIG9uIGNsaWVudC1zaWRlIHJlY2VpdmUNCj4gwqDCoMKgwqDCoCBT
VU5SUEM6IEZhaWwgZmFzdGVyIG9uIGJhZCB2ZXJpZmllcg0KPiDCoMKgwqDCoMKgIFNVTlJQQzog
V2lkZW4gcnBjX3Rhc2s6OnRrX2ZsYWdzDQo+IMKgwqDCoMKgwqAgU1VOUlBDOiBBZGQgUlBDIGNs
aWVudCBzdXBwb3J0IGZvciB0aGUgUlBDX0FVVEhfVExTDQo+IGF1dGhlbnRpY2F0aW9uIGZsYXZv
cg0KPiDCoMKgwqDCoMKgIFNVTlJQQzogUmVmYWN0b3IgcnBjX2NhbGxfbnVsbF9oZWxwZXIoKQ0K
PiDCoMKgwqDCoMKgIFNVTlJQQzogQWRkIFJQQ19UQVNLX0NPUksgZmxhZw0KPiDCoMKgwqDCoMKg
IFNVTlJQQzogQWRkIGEgY2xfeHBydHNlY19wb2xpY3kgZmllbGQNCj4gwqDCoMKgwqDCoCBTVU5S
UEM6IEV4cG9zZSBUTFMgcG9saWN5IHZpYSB0aGUgcnBjX2NyZWF0ZSgpIEFQSQ0KPiDCoMKgwqDC
oMKgIFNVTlJQQzogQWRkIGluZnJhc3RydWN0dXJlIGZvciBhc3luYyBSUENfQVVUSF9UTFMgcHJv
YmUNCj4gwqDCoMKgwqDCoCBTVU5SUEM6IEFkZCBGU00gbWFjaGluZXJ5IHRvIGhhbmRsZSBSUENf
QVVUSF9UTFMgb24gcmVjb25uZWN0DQo+IMKgwqDCoMKgwqAgTkZTOiBSZXBsYWNlIGZzX2NvbnRl
eHQtcmVsYXRlZCBkcHJpbnRrKCkgY2FsbCBzaXRlcyB3aXRoDQo+IHRyYWNlcG9pbnRzDQo+IMKg
wqDCoMKgwqAgTkZTOiBIYXZlIHN0cnVjdCBuZnNfY2xpZW50IGNhcnJ5IGEgVExTIHBvbGljeSBm
aWVsZA0KPiDCoMKgwqDCoMKgIE5GUzogQWRkIGFuICJ4cHJ0c2VjPSIgTkZTIG1vdW50IG9wdGlv
bg0KPiANCj4gDQo+IMKgZnMvbmZzL2NsaWVudC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfMKgIDIyICsrKysNCj4gwqBmcy9uZnMvZnNfY29udGV4dC5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHzCoCA3MCArKysrKysrKy0tDQo+IMKgZnMvbmZzL2ludGVybmFsLmjCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDIgKw0KPiDCoGZzL25mcy9uZnMzY2xpZW50LmPC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMSArDQo+IMKgZnMvbmZzL25mczRjbGllbnQu
Y8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMTYgKystDQo+IMKgZnMvbmZzL25mc3RyYWNl
LmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA3NyArKysrKysrKysrKw0KPiDCoGZz
L25mcy9zdXBlci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMTAgKysN
Cj4gwqBpbmNsdWRlL2xpbnV4L25mc19mc19zYi5owqDCoMKgwqDCoMKgIHzCoMKgIDcgKy0NCj4g
wqBpbmNsdWRlL2xpbnV4L3N1bnJwYy9hdXRoLmjCoMKgwqDCoCB8wqDCoCAxICsNCj4gwqBpbmNs
dWRlL2xpbnV4L3N1bnJwYy9jbG50LmjCoMKgwqDCoCB8wqAgMTQgKy0NCj4gwqBpbmNsdWRlL2xp
bnV4L3N1bnJwYy9zY2hlZC5owqDCoMKgIHzCoCAzNiArKystLS0NCj4gwqBpbmNsdWRlL2xpbnV4
L3N1bnJwYy94cHJ0LmjCoMKgwqDCoCB8wqAgMTQgKysNCj4gwqBpbmNsdWRlL2xpbnV4L3N1bnJw
Yy94cHJ0c29jay5oIHzCoMKgIDIgKw0KPiDCoGluY2x1ZGUvbmV0L3Rscy5owqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAyICsNCj4gwqBpbmNsdWRlL3RyYWNlL2V2ZW50cy9zdW5y
cGMuaMKgwqAgfCAxNTcgKysrKysrKysrKysrKysrKysrKystLQ0KPiDCoG5ldC9zdW5ycGMvTWFr
ZWZpbGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMiArLQ0KPiDCoG5ldC9zdW5ycGMv
YXV0aC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAyICsNCj4gwqBuZXQvc3Vu
cnBjL2F1dGhfdGxzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDExNyArKysrKysrKysrKysrKysr
Kw0KPiDCoG5ldC9zdW5ycGMvY2xudC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIy
MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0NCj4gLS0NCj4gwqBuZXQvc3VucnBjL2Rl
YnVnZnMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMiArLQ0KPiDCoG5ldC9zdW5ycGMv
eHBydC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAzICsNCj4gwqBuZXQvc3Vu
cnBjL3hwcnRzb2NrLmPCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIxMSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKy0NCj4gwqAyMiBmaWxlcyBjaGFuZ2VkLCA5MjAgaW5zZXJ0aW9ucygrKSwg
NzAgZGVsZXRpb25zKC0pDQo+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IG5ldC9zdW5ycGMvYXV0aF90
bHMuYw0KPiANCj4gLS0NCj4gQ2h1Y2sgTGV2ZXINCj4gDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0
DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1
c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
