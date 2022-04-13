Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EC44FF05A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiDMHIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiDMHIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:08:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2103.outbound.protection.outlook.com [40.107.93.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A61C901
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 00:05:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dldegvgYsMnjxDPeqEZMIE3YFRSpYEhdOSrdJ3MiDN+zOdhYtMSZO8xXAobYyPmfyuhd+NesxvLtOqD9MJyxkisTqs/OF4RAAFetcD8w4twUPLOGOMtPF8k8FojmAYL0Qo3J8jMhakt190C7Fi+4MCPhWWaHgfWNhK/H+coIdgV04kEkGmu068aScNTQgiUVscTY84+RP1tbstJbAkumI+n306N3ACE4DsCvEdDcuJS+CZdbBo4BfdMq23PS8rqaKNaOLJHAhgh5wQlSooowIOv+/hvdYBGAZ4m/M7J8OspGMrMTcLnZoohVcnzG5Li5VER/L7PcmTvCaXuE95qDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmjCtYzGAvck4LZUIb0wVeq3TmQ0optjn3yWOyRMs60=;
 b=DF2zNTCZNY3QR0uA8W0FQfJOBiZj41+nCB8TlYaV58S2CRDrn2zRMId4RUM0ZGmuohRR7qQe5oqVKxyI5OBFH0xKOaeIqi/SJn6+qRGYrGKFxxM0o/UNkHxfH4VH2zGfJ+89loLJIRCx3JvBXWHVvu7J8Ih3rjpk4lbelF7XNEcG7PpIOvKwhYRvsEBNV/VqQtuRLXoqeXba/8D8qMsktiBk1Vm2BOAwS/SriO2iAxUUM13mgB2W3wq1ACF/LdLip8gRcwPzRU18geNosogFjMmuZvIljrEA9D07pGzDmS1o6OJIwHmRRG+bWJgQsbs/QSv9V3LPF0WTlzvzlOPeKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmjCtYzGAvck4LZUIb0wVeq3TmQ0optjn3yWOyRMs60=;
 b=nkeO/k7XdKVVBE9XJZhuxdyQDpO6go1koMor/cDhnE0Rq4t+zkK6yCiuPF8aKW2BwqIB5RDqvuXAWqmcG5l2qTN30nWx3/EfjJzGC998fuUej/PqPSpq+FNjwvaVg2D86CxMBiAt2tFdnnRsTGbEPY/Htv053yMVllnb5RZbQXQ=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by PH0PR13MB4922.namprd13.prod.outlook.com (2603:10b6:510:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 07:05:39 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::988a:9999:e3a2:9015]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::988a:9999:e3a2:9015%4]) with mapi id 15.20.5164.018; Wed, 13 Apr 2022
 07:05:39 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <eli@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: RE: [RFC net-next] net: tc: flow indirect framework issue
Thread-Topic: [RFC net-next] net: tc: flow indirect framework issue
Thread-Index: AQHYTvq/PA56BYb1CU+UwTrIpnt6TKztZrlg
Date:   Wed, 13 Apr 2022 07:05:39 +0000
Message-ID: <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
In-Reply-To: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4508557-47b9-47ac-b91c-08da1d1c0431
x-ms-traffictypediagnostic: PH0PR13MB4922:EE_
x-microsoft-antispam-prvs: <PH0PR13MB49224A840B2690A283518E10E7EC9@PH0PR13MB4922.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vtmYZkqz8VHcUh6v4oT9gJjU8TfpcSw8ZwK4o5PVMAHYgKWbX75miuIHKuugCYF5T/oby/HL7mIxNbM0sk64zJ8vcUCkOUpoS7r2NvXSogqUECmhGWSwEHxO1l474MjF8pJx6CLZiJQlYA8lFUHRfq8xKG8jj0phj38yJKT8f9lJj59uD+5B56fv3kyMp7EGnz0rJBL3NbUooPEnKnScoA3k1JkAiVwedXPvgjv2Wa/2zoKsoGKACdxgmklwtcqqhUlMO+MpKLl/bc10QtcBr84jpqDskhok8FbLdJFEsy9rOxQArYXY7fuhxxq7ClAnn/dEOzhmKHKnHfXJNfLgFhlJwk7f2BrUTL7xPQRuzBvzyreUD1ud2SXkcF7+dD6bEBg+WgCLdwwKhS4nfG70LvMEwFjVsekUYZeC/En7DYrSGwb4JQaZxYM/8AMtwLJyYWtWi+tHJJm08PzI/yd5Pt4LHC2XKftUIYFqz/1qesMiFbLABxz9q1Fh5B5UtzwblcTqzEGi9v6RCcQNT73CmkHgEhN0/UjOZk++ShLeEG9PSwjarBeS/3OLsITMBDMreJ1HI2uORRYO9lZSCCrTlDSSwnkDQQ3MQwk+DIy4mPsXmoa3gi6w2xQxQHKgOVFtPJoVvCnBh6j1CAX0wVAg3YkrQdXJD5zz8funKXsAjM5YdBEqVuNIpIxDNvlOp7RjM40cwfDOKBjMAj058VrnG2qdk7Buhg+JK4LCAJZJDoGu8+ffmBSgaxgas6wQk5fwWQkhUFcliFIzYlJSi0qN9M1NNvFWIDTrlECXm9QDDDl1EaRzErVgG5vrofomuTTorfHu/WhdrQfMq/AlTLUNvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(39830400003)(396003)(136003)(376002)(83380400001)(44832011)(26005)(110136005)(2906002)(54906003)(8936002)(64756008)(66556008)(66476007)(33656002)(66946007)(76116006)(66446008)(316002)(8676002)(4326008)(52536014)(55016003)(186003)(5660300002)(6506007)(38070700005)(71200400001)(122000001)(38100700002)(9686003)(86362001)(7696005)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2NNdDc0dTZrOEZYOWVMU3B6QjdqNFZDcmV6dW51OTM3cjBoZlJoVXliOTh0?=
 =?utf-8?B?RjFyaTAwd3QwVkNTTCs2RVpMWFBsQmJoUUFXb0hGMitHQ1ZqeFczK1UyeFBN?=
 =?utf-8?B?WmsxWktXR0E0NTlOc3hUdSt4MmhqS3ltQlAyeFdsdk9tOFNWQy9kQUZvUlFB?=
 =?utf-8?B?QlhmTHF5THh0R09TU2JhTGtSdjQ0OHg4T3lBTmV2ckpna3ExYmVPVkNnalFl?=
 =?utf-8?B?Nzk3aDhmMmV6eTRBVVIzVEg2RXBGeEJTSHcwSTVIdSt3aVhuYklBcjJEWkdv?=
 =?utf-8?B?RDVXSmdDYkFJaUhzQ2l6ZFN4YTRObzFWeHVjWjZCS2FYQmw2M1ppRDR5d0Jv?=
 =?utf-8?B?Y2FPdnlSMTFHVHpZTmJxTzdSdmVqYnBKWWwvOE5pbjVwdkxETXpHUUpnRVRq?=
 =?utf-8?B?MWlITk5TOTU5cDBFWVFoa2w5QWNmYUdGenZVcEV3L0ovYk9UQlpCdGo4OGor?=
 =?utf-8?B?cXN6SW5VTWJlMWFJRXNjVHgvbEl5N2h0SlN1ZjJ6UDFROFovbmZrM1JKbC9G?=
 =?utf-8?B?QXc1cTlxL05TVUFIbCttUldsWlhySDhUL0tIVFFnbG4wZERxdjNueUxLRmFi?=
 =?utf-8?B?Z0x1WkFUYURQMmVBZGltVHg2cU1JanpjQjJDZXcyOElObFVVZC9pU0o1cnhx?=
 =?utf-8?B?V014dmVVa1hyWnM3blgzZVRDZWJ1U0RNWUdlQVQ5em1nV29ONHJXVUFiNG03?=
 =?utf-8?B?NTkwbnlEdGU0TFJ6SVl3QWRsbzNWK3VKN2h6TXVKeVZIOHlJUlJzbUZHdHVC?=
 =?utf-8?B?OFRaelNqSGkycEpyMFF3aXB2U0x4QTIvZ0w4VWFUWFVUUFoyVzRQSDBaOXRw?=
 =?utf-8?B?bkcrTXhIQWdUSm9DUnhuSThXc2pFM1FLbHlNSmhzK3F4dkt4Y0o2aDdNUGZp?=
 =?utf-8?B?RnppUXZ1elEwRjdIV0ZMeE9adTZrVGZVaVU1SThncTJsU01WZEY0dm8yTjRF?=
 =?utf-8?B?VnV5MXFXdXBnaWY5UjliYk1NbzNJR04vQVh3ZHVyU2xOMGZ6SDNNbDA0RVdP?=
 =?utf-8?B?SFhVYWROQ3JFL1h5YmtkWWJSQXgraFVXZWlqMVRoMWRJRjJPWFRWYlBiZll5?=
 =?utf-8?B?REVWK1hDcFdNeFE5YmtTZ3Jmdndkbjh6K28yeURPeWVzcWNTV2JYQldSNFR5?=
 =?utf-8?B?Z09WQURuemtSd0RPYklENjNxakJxZjNid2QrWS9NQXpDVlRuMlVLYXlmaUxs?=
 =?utf-8?B?dDd1UER4cVV5N0xLV21TZkxvcitYbkZFMWYvM3hsa00yMjRLZ1I5d1NLMzJG?=
 =?utf-8?B?dTZ4OG5VMkVLOE9yNzV2SWVSY3dZMWVKb1haREpvSlhWN3YyOVM3NTFtODNy?=
 =?utf-8?B?eDc5ZVI0Y3Q2WjNVNW9vMEdNS1I0SjhsVXRrNWpSTWZ3bXNwR2FQUzdiRHps?=
 =?utf-8?B?WlRtL3pxRkE2d3F6UlV6LzEzdURKMWNGSmNWK1ZadUljOWtqWW5Nc1Bja0hv?=
 =?utf-8?B?TmxyUWwrRWw2aFFVK2c5UThGSkdDSnM0WnJVS1c5ZldVblRZNGsvcyszNjdI?=
 =?utf-8?B?UE9kM0pQUU9zTWdoaUJRa3VGMEFZWmZpZFpIMTBmMlZUWHhKdWdKYU5Tc3dD?=
 =?utf-8?B?RjAvZVFpSGNpcnVKc0JVWFJtb0lhbEdWOWlqS2JGeUNTVy9rWXgwdGdVNVlU?=
 =?utf-8?B?MTlKZGlFQVE5ellGM2wvQno0RDQvckltRk54Y2RybW5nNFh3RVBJSlJHTTds?=
 =?utf-8?B?ZVRSeC9RUUNKMHltK3FsSUVYaG43eG9qajJQRFdocHhrNk95bGVmTVVMT1Zi?=
 =?utf-8?B?VDY2bkdtK0pIWEtwYkNKVVZvcE9HS3o5cGZkaFlIVUNQalZaMDhJUUhFN3hx?=
 =?utf-8?B?djNQbnVGVzdGS0F1U1ZDNm1tUmNjcCtwaktTNVFUQVd1QWVzMjJ5dGdnaFc5?=
 =?utf-8?B?ZUljaGo2dWJ5NitENWZucG9RN1l1ekRYSU05WWhlVDRxREVVV09QWkZ0cXBj?=
 =?utf-8?B?TTFqM2o2T0NtRW9LS3JpZzlVY2dFUHg0a2Q3NnlXUTBMWHhmeTYyZXR3bTBp?=
 =?utf-8?B?cE0vdi9wbWNlTnIwYmdvVUZHYUg5RnllZzVxVHFKNjJyRE93Um5mZ3ptYlpu?=
 =?utf-8?B?R3JCRHZsNnovWEpYMnVqc1ZiWFd0OWxST0hYYklGQWVuclpkblh1YTFKTVA0?=
 =?utf-8?B?Y0FrM2FobDdrd0Q1S3U3M2lCMlVSOGVPVUtwWWF0QmVVcEdLSGVGMWNJeG9i?=
 =?utf-8?B?aXFWNU4xaUQrUmQ3YncwUk5ucmQyY2N0Z3lFQWdqdDFabFlCTG1wL3o5T1V0?=
 =?utf-8?B?YWZGSjcxSjJZT0czZEk1djduMTBBVVBBWVp1dysxVDRiWko2SWlpQmViOUV3?=
 =?utf-8?B?Nk9ZTkhYTXJFaUliWG5mdmtWRFVRYWhGc2g0UG1neXFRSDdZZDIyQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4508557-47b9-47ac-b91c-08da1d1c0431
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 07:05:39.1597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkryS3d4mwsrVRzRYZEyPtVhZEOOmvY6E8BBkL4ufJo0/jSUskWzrS1k9xaXQOCzaMzcSJ3PySVaKfeiKtkNuvs/lgNLsWAS5MiFEMhVxQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4922
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gQXByaWwgMTMsIDIwMjIgMTo1MyBQTSwgTWF0dGlhcyB3cm90ZToNCj5IZWxsbyBhbGwsDQo+
DQo+SSdtIGN1cnJlbnRseSB3b3JraW5nIHRvIGdldCBvZmZsb2FkaW5nIG9mIHRjIHJ1bGVzIChj
bHNhY3QvbWF0Y2hhbGwvZHJvcCkgb24gYQ0KPmJyaWRnZSBvZmZsb2FkZWQgdG8gSFcuIFRoZSBw
YXRjaCBzZXJpZXMgaXMgaGVyZToNCj4NCj5odHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYv
MjAyMjA0MTExMzE2MTkuNDNqczZvd3drYWxjZHd3YUBza2J1Zi8NCj5ULyNtMDdiZmY5ZTIwNWU5
YWMwM2QxNWE0ZTc1OGI0MTI5MjM1ZGE4OGFiYQ0KPg0KPkhvd2V2ZXIgSSdtIGhhdmluZyBzb21l
IHRyb3VibGUgd2l0aCBpdC4gTW9yZSBzcGVjaWZpYyBpbiB0aGUgbGltaXRhdGlvbnMNCj5zZWN0
aW9uIGluIHRoZSBsaW5rIGFib3ZlLCBxdW90ZToNCj4NCj5MaW1pdGF0aW9ucw0KPklmIHRoZXJl
IGlzIHRjIHJ1bGVzIG9uIGEgYnJpZGdlIGFuZCBhbGwgdGhlIHBvcnRzIGxlYXZlIHRoZSBicmlk
Z2UgYW5kIHRoZW4gam9pbnMNCj50aGUgYnJpZGdlIGFnYWluLCB0aGUgaW5kaXJlY3QgZnJhbXdv
cmsgZG9lc24ndCBzZWVtIHRvIHJlb2ZmbG9hZCB0aGVtIGF0DQo+am9pbi4gVGhlIHRjIHJ1bGVz
IG5lZWQgdG8gYmUgdG9ybiBkb3duIGFuZCByZS1hZGRlZC4gVGhpcyBzZWVtcyB0byBiZQ0KPmJl
Y2F1c2Ugb2YgbGltaXRhdGlvbnMgaW4gdGhlIHRjIGZyYW1ld29yay4NCj4NCj5UaGUgc2FtZSBp
c3N1ZSBjYW4gYmVlIHNlZW4gaXQgeW91IGhhdmUgYSBicmlkZ2Ugd2l0aCBubyBwb3J0cyBhbmQg
dGhlbiBhZGRzDQo+YSB0YyBydWxlLCBsaWtlIHNvOg0KPg0KPnRjIHFkaXNjIGFkZCBkZXYgYnIw
IGNsc2FjdA0KPnRjIGZpbHRlciBhZGQgZGV2IGJyMCBpbmdyZXNzIHByZWYgMSBwcm90byBhbGwg
bWF0Y2hhbGwgYWN0aW9uIGRyb3ANCj4NCj5BbmQgdGhlbiBhZGRzIGEgcG9ydCB0byB0aGF0IGJy
aWRnZQ0KPmlwIGxpbmsgc2V0IGRldiBzd3AwIG1hc3RlciBicjAgICA8LS0tLSBmbG93X2luZHJf
ZGV2X3JlZ2lzdGVyKCkgYmMgdGhpcw0KSGkgTWF0dGlhcywgaW4gbXkgdW5kZXJzdGFuZCwgeW91
ciBwcm9ibGVtIG1heSBiZWNhdXNlIHlvdSByZWdpc3RlciB5b3VyIGNhbGxiYWNrIGhlcmUuIEkg
YW0gbm90IHN1cmUgd2h5IHlvdSBjaG9vc2UgdG8gcmVnaXN0ZXIgeW91ciBob29rIGhlcmUoYWZ0
ZXIgdGhlIGludGVyZmFjZSBpcyBhZGRlZCB0byB0aGUgYnJpZGdlIHRvIGp1c3QgdHJpZ2dlciB0
aGUgY2FsbGJhY2sgaW4gbmVjZXNzYXJ5IGNhc2UuKQ0KVGhlbiB5b3VyIGZ1bmN0aW9uIGlzIGNh
bGxlZCBhbmQgYWRkIHlvdXIgY2IgdG8gdGhlIHRjZl9ibG9jay4gQnV0IHNpbmNlIHRoZSBtYXRj
aGFsbCBmaWx0ZXIgaGFzIGJlZW4gY3JlYXRlZCBzbyB5b3UgY2FuIG5vdCBnZXQgeW91ciBjYWxs
YmFjayB0cmlnZ2VyZWQuIA0KDQpNYXliZSB5b3UgY2FuIHRyeSB0byByZWdpc3QgeW91ciBjYWxs
YmFjayBpbiB5b3VyIG1vZHVsZSBsb2FkIHN0YWdlIEkgdGhpbmsgeW91ciBjYWxsYmFjayB3aWxs
IGJlIHRyaWdnZXJlZCwgb3IgY2hhbmdlIHRoZSBjb21tYW5kIG9yZGVyIGFzOiANCnRjIHFkaXNj
IGFkZCBkZXYgYnIwIGNsc2FjdA0KaXAgbGluayBzZXQgZGV2IHN3cDAgbWFzdGVyIGJyMA0KdGMg
ZmlsdGVyIGFkZCBkZXYgYnIwIGluZ3Jlc3MgcHJlZiAxIHByb3RvIGFsbCBtYXRjaGFsbCBhY3Rp
b24gZHJvcA0KSSBhbSBub3Qgc3VyZSB3aGV0aGVyIGl0IHdpbGwgdGFrZSBlZmZlY3QuDQo+DQo+
SSdtIHNlZWluZyB0aGUgY2FsbGJhY2soVENfU0VUVVBfQkxPQ0spIGZyb20gZmxvd19pbmRyX2Rl
dl9yZWdpc3RlcigpIGJ1dA0KPkknbSBub3QgZ2V0dGluZyBhbnkgY2FsbGJhY2tzIHRoYXQgSSd2
ZSBhZGRlZCB2aWEgZmxvd19ibG9ja19jYl9hZGQoKQ0KPg0KPkRvIHlvdSBtYXliZSBoYXZlIHNv
bWUgaWRlYSB3aHkgSSdtIHNlZWluZyB0aGlzIGJlaGF2aW9yPw0KPkFtIGkgZG9pbmcgc29tZXRo
aW5nIHdyb25nIG9yIGlzIGl0IGEga25vd24gaXNzdWUgb3Igc29tZXRoaW5nIGVsc2U/DQo+DQo+
QmVzdCByZWdhcmRzLA0KPg0KPk1hdHRpYXMgRm9yc2JsYWQNCj5tYXR0aWFzLmZvcnNibGFkQGdt
YWlsLmNvbQ0K
