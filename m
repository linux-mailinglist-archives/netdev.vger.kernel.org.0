Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCFA5FC14A
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJLHfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 03:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJLHfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 03:35:24 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2074.outbound.protection.outlook.com [40.107.117.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45BD57888;
        Wed, 12 Oct 2022 00:35:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jrs4oXnX/PSJxBQaNA1xiDXWiiVsBWpN438dIFuimmW7fHZLsi3owGPctahEE8flv90JokBfnSyvSAUT/Benv6FvdO61rv2jqdzm17Mqwd7OElKlnPATVZQYfPjcEE0+hGZkMWvI78nwziae7SGYudGoLxcWqJRktXKSlTthOh8TFM4Qfgw62iMJSfzRrf2TEkXllGoyYc0PxzhzxEBDObwTH394vhn9POzX3DEo+pPW1XSg+IKGFeUq52LhTacNcO6c8db6+adrhQ0nRYkNf+DnGSDK44rrTfnJEClfLQlJ+8DA7oc2xQMGYsPUYVxHOoV4ZvU9iNCXP/rZKElm3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SnIPgYzpo2fudFqfrMN+lEY6pHxMzb1u1BVAqC+PLQ=;
 b=A17cPcIoKLWEA/wdmRi3aYnXhOcfmp2xmKjF+TRLGLYo70YW/sEDmgR69wkMDV4a5taAc5VNEqeBu7kghMLG1i1W11KJAWjTZAFyXJGuNGyeq95nYOknR6bqUFo9eNtO8RyDQOQ5QLFpaxgBpaX9yHghNJs9lJN91FqjZbUucrvF1hjqwtOz/l4mfcR88tgD+LA0SJi2FgPl7CCA0m+nm/a/fzqJ28iBzh7q2+2aYTOWLCW1vJdnhZYZ2mkwJXYL1ppvLJdjPyfZH9Znm1ToNyEc34gmqvTps3zeFa7nQY3ng1+K98jftypVnRUZCIu08vavQF/Du7AIxGeWL9S0LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SnIPgYzpo2fudFqfrMN+lEY6pHxMzb1u1BVAqC+PLQ=;
 b=JpidCFIXV41sIyCpt7AIfJmYOHGscfYCHD5toERVO7coPMq2ALxYtQQtwMQIGV6bXvm85mcDytqJ9Hxwohneyvye+hy4ttClN611fkS3SqZd2UaSEZT/7BMASyujBwSdgr3KOUKos2JLgEhooA4Hqc8U05ThUXvGGB4Gx/nbfHnZhFuGMaijG8TLvrvz5xbtK47p2ADR688RXe118b8OGgrFQh/OjrlXO5jDgwWyb40YTJbFbtgdjvtrLRpkF603+AcBkv2F29mZxoXEUGGEMNXmXCfR0vdqnYGFeK8nd5t9yvgPXe4ZdoooUzdLZ1FeC017LeSFN/KkD46I311pOQ==
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by PSAPR06MB4198.apcprd06.prod.outlook.com (2603:1096:301:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Wed, 12 Oct
 2022 07:35:18 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::aa83:33dc:435c:cb5d]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::aa83:33dc:435c:cb5d%6]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 07:35:17 +0000
From:   Angus Chen <angus.chen@jaguarmicro.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alvaro.karsz@solid-run.com" <alvaro.karsz@solid-run.com>,
        "gavinl@nvidia.com" <gavinl@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "wangdeming@inspur.com" <wangdeming@inspur.com>,
        "xiujianfeng@huawei.com" <xiujianfeng@huawei.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [GIT PULL] virtio: fixes, features
Thread-Topic: [GIT PULL] virtio: fixes, features
Thread-Index: AQHY3MyiiKqJa7Fnx0Wd1nXI+hxoOK4KTBsAgAAR5+A=
Date:   Wed, 12 Oct 2022 07:35:17 +0000
Message-ID: <TY2PR06MB3424CA67A42A40B16FA7A66285229@TY2PR06MB3424.apcprd06.prod.outlook.com>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
In-Reply-To: <87r0zdmujf.fsf@mpe.ellerman.id.au>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3424:EE_|PSAPR06MB4198:EE_
x-ms-office365-filtering-correlation-id: 76ec6c5a-7f5b-428d-e6b5-08daac244f30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76vC2fg6UFuQsMYeJeU2bAL01tlTqDuTcKqbWvODrmgrnhTNZ1g0OT0Ru4L+9W7xUD1JSCfQ5Ll9eTQlqO7pMF5ZPJBeF8r9LssheSuEmjEvPtZoHTzV2rjrZ+e7LL8/M19BFubFS2zwuxfn7qm66BpgNoXU/uNHJc50VmHdj+ehw3uuaRu82yt0oUov7YON75oHfnTyznDQaJDxqs6A07BvlyQ+0WaU7zu/VI29Xm9CCnW2ZW+Kfem8d9F6o0D3IYaozu4B8/28z70qSgw5AMKMwllLnyN82T+K5nGSel17FOnw1aI7mDGdVqe7hII4he7Do7WHkNviu9TAwmClV8Cd3qCjL6Ulbe517sLQvFrjqTHA99zjqH50ksLRrmLK5R8G+MF4k0icOE35lvzPyNwlPLBQBkqHyeKw3+PgqD2amWDD0jRu2zlEEnviQU7NoUGFwZ/QjO8SZ4AYK5XdViway7h+lWxMi3YLOaADBTPRQNReAKN09qL01wqkzcI7q5WBrJXpclvMfhd4MbtcpQt2M1sQgY9QKXakFCtezcwpQ20ZqlFP6w1tLH4u6F72x/atH0chPDVSHW3tHVptkjQRgsekKugZoSt4J7CbHPfdR44/7WrmMcg16c2hN4LMB4cME8LdBhqWv1OWNh85gLZiBMQ1ieH6EDLGiA/VCjxMX2HF9jnamPyapKjbREXCbHpDK++xir/p+WkVJeXAwRceplzcuCue/sgQhUc4X0++iNiEBMRv5Z1Fa9iGcjMNFnMb9qWhBiGeeWh8RpVWSmOulvUmNNs3RGgdUCuJBmk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(376002)(346002)(136003)(396003)(451199015)(71200400001)(86362001)(316002)(38070700005)(110136005)(54906003)(41300700001)(2906002)(55016003)(5660300002)(33656002)(186003)(8936002)(83380400001)(966005)(66446008)(64756008)(66476007)(66556008)(66946007)(52536014)(44832011)(4326008)(7416002)(76116006)(8676002)(478600001)(9686003)(26005)(6506007)(66899015)(38100700002)(122000001)(7696005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkorekFUKzRBeU14NGRaZTdjRXJIZ28zWjdxWlczZTFBV1dMUllNaDhGUCsw?=
 =?utf-8?B?VFk2NnRVV3owZkFKRnZQL3RiVGpZUFpoRHNRSzZlTXNXLzlweHdqampZdmoy?=
 =?utf-8?B?OWk2NDZFRk5ISzhyU3FSS2tGYTBxaEord000MDlrQ0E2VWdTanUwSVhQV2c3?=
 =?utf-8?B?c2xMNWJpQ0tzd2gzeWhyT1RPamwxK1l6a244UmhsK3lGNWlDQldpU3hUMkpL?=
 =?utf-8?B?YmFqMmY3d2U4ZWh4QmUrTUF5RTVoc3R5VVNrcjVleUVjSnlySEFqdUFuaTRl?=
 =?utf-8?B?TW9QcHFxZFlaazZjbkdxQ3FhMFFFNUNna2VFZ3NiOWc5L29JWDJGV01iaVF6?=
 =?utf-8?B?dGZWQXgrQUVEdWFVSVVLTlFESm5KWDZMYU9JUEhFNWY3LzFpRUo0aTlIUjls?=
 =?utf-8?B?bHFrbzBJc3lJUlpPKzFDTmU1UVJBMXNOSmQ2dHFIK1EyUzBpQ3RERm0weHhP?=
 =?utf-8?B?d2pRQnNQM2xsOVJ1aUNwQ3RySk9QSG1TNXVKQVh1VGVsYTBicmlzMkxKZzA0?=
 =?utf-8?B?b3lXV1UrYXdLYmxhUU0xRkplTmJoYW51RkFMR3lmM044WmU2emZCTUR6TGcv?=
 =?utf-8?B?eFNzNjNiQ2pyeU1YOGgranQ1ekhJdTNIZzNvcjNhNE04a2w1anpvMHhsQW9W?=
 =?utf-8?B?NWJPckZrSXpRWlhVQ0ZSUFJsK1hOc1VvNnZ1UkNHMWJSK2ZGYWI3TzZzQTJl?=
 =?utf-8?B?Z0ZXc004eEY4c3NpT3JsVUExbmVHb1BVRGV2MVpKZExrdzF1Wllrd2FpdVZt?=
 =?utf-8?B?UWZLNHVrNHFyb1VhRFFQaUMvQjBwaS9RU3JMYVhSK2RaNi9PY2RkN1ZYYUVq?=
 =?utf-8?B?YmhMdVp3VFZnVUZERld1ckErTnRQOHRQNHZNMXZ1dTdMWk1weHovdmZ3SGpI?=
 =?utf-8?B?MC9RaWl0aTB0eGg1ck95QlZrVTc1VW9kdXFXRmxRQkJ3dk04U2FENnRZekI2?=
 =?utf-8?B?bVg4Z0JFYmR2ZEhLSU8zcnRMWUZEaDNLZ2k4SWs5N0R3YjJRcXhxQk1UNHhs?=
 =?utf-8?B?eEJyanJtUVVXeDZsanNEbnBKa2NzU0h4S2hOSXp0ZkV0cW0rMlRpaDNhVDRH?=
 =?utf-8?B?ZE9nSnJHSVgxdmxNTlZCUEV1MFJxbm1nS2ZTN3V4MDB4NGVhSjErZEU2VFd6?=
 =?utf-8?B?ckVTV0RRK25zd3dWeGZic3FPaktUblJyOUc2MkNadkFPYTNzVWVvdGVHT0Ur?=
 =?utf-8?B?bmEydlZKNzlzZGhKeXk4QWZSRVdhM1ZZMnduajZvTE1WNnV4VlErYytBNFhv?=
 =?utf-8?B?Z0dtczlBaEV0VC94REFkSWdJakJ0WmQzRGZOZk9odDhuVU9vcERoLzZhT2Z0?=
 =?utf-8?B?L0F0UERuMlZkU1VQMFdncDg2SDFteWxGSlJEbHVQY1B2REtFalc2a2Juc3hW?=
 =?utf-8?B?ellLcEhkNDh2disvbFlUZU5USDRoYWZpSVhiRzNVbzJIbytwaCs5NW1MSzNY?=
 =?utf-8?B?bWZ1eXlyYzJWTW5YRE45MDlZZTV0aWkyOW1EKzhQV091RHB3QmxwcnB5N2hY?=
 =?utf-8?B?TFFpNi9RQ1VTUkUxRVdYamVkTkV3dWhka1ZDVCtKaU5QeGlESTNPY3d4T1hN?=
 =?utf-8?B?aTJmc3RsMStqQmNlY1dUdCtGMmtSdHZ5MjQ1Nlk1V1FuRzQwUnphSThaNzNj?=
 =?utf-8?B?TkJOcEFvT0ZGeTZhWGwvZ3BCQXJybFZITEV0K3BPMWlUZlJPbU1uNGZINnRX?=
 =?utf-8?B?NTE4RTMwMGFUcEZrUnVKbk9FWUVvbi9tL0IrLzd0QjVmSmNabm01aHZOQTg1?=
 =?utf-8?B?aUZ1L2dhS2tFNThXcGwydGUxU2UycW9aVGswWDU5OEIvOU5HeGIzd2RUSkM4?=
 =?utf-8?B?eTR4M2lhV0pkWWdSWk9hUXArUDdsL1dOVmhEcEdIczVrZ0pxbUNtNkVLMy9l?=
 =?utf-8?B?RjkyZUpUK1BJWGRETi9DVlN2RUg4Y1FXK1Zwb3QxaEtyNFMrWTRqeEQySDJD?=
 =?utf-8?B?MjFRNDkyc2JwZkp0MWlObVZqWkk3UzhXbldBYzZxSmZRTHZIcXl6UFlhRkZK?=
 =?utf-8?B?Y21UNi8xTFpUUFRnS2J5NTVUQjZCRjlDdC9FckdPTE5neVB1OXRtSkRFNElC?=
 =?utf-8?B?K0FLWTZzYXFIRms5ekxqT0NURFRGWFNwT0l4L3c2OElUSHpGb3g3SkJ6cUR1?=
 =?utf-8?B?UTNELzE4TXRITS9JT2RDaEk2NlpsTzJYa2luZEliTDRDZUozWTUwMTRRSUxo?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ec6c5a-7f5b-428d-e6b5-08daac244f30
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 07:35:17.3126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PjZ5E4NM6zaKx0IkG9Q7MgeL/4luBJNnW6+9DNpn8p1QYq5I1I++iWi/gDIt//qU34L6WnEaqmWJ78vd+YWIPnwwWRGgdQUQG2O5Ijb/u34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4198
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWljaGFlbCBFbGxlcm1h
biA8bXBlQGVsbGVybWFuLmlkLmF1Pg0KPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMTIsIDIw
MjIgMjoyMSBQTQ0KPiBUbzogTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4NCj4g
Q2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZvdW5k
YXRpb24ub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOw0KPiBhbHZhcm8ua2Fyc3pAc29saWQtcnVuLmNvbTsgQW5ndXMgQ2hlbiA8YW5n
dXMuY2hlbkBqYWd1YXJtaWNyby5jb20+Ow0KPiBnYXZpbmxAbnZpZGlhLmNvbTsgamFzb3dhbmdA
cmVkaGF0LmNvbTsgbGluZ3NoYW4uemh1QGludGVsLmNvbTsNCj4gbXN0QHJlZGhhdC5jb207IHdh
bmdkZW1pbmdAaW5zcHVyLmNvbTsgeGl1amlhbmZlbmdAaHVhd2VpLmNvbTsNCj4gbGludXhwcGMt
ZGV2QGxpc3RzLm96bGFicy5vcmc7IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3Vu
ZGF0aW9uLm9yZz4NCj4gU3ViamVjdDogUmU6IFtHSVQgUFVMTF0gdmlydGlvOiBmaXhlcywgZmVh
dHVyZXMNCj4gDQo+ICJNaWNoYWVsIFMuIFRzaXJraW4iIDxtc3RAcmVkaGF0LmNvbT4gd3JpdGVz
Og0KPiA+IFRoZSBmb2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQNCj4gNGZlODlkMDdkY2My
ODA0YzhiNTYyZjZjNzg5NmE0NTY0M2QzNGIyZjoNCj4gPg0KPiA+ICAgTGludXggNi4wICgyMDIy
LTEwLTAyIDE0OjA5OjA3IC0wNzAwKQ0KPiA+DQo+ID4gYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0
IHJlcG9zaXRvcnkgYXQ6DQo+ID4NCj4gPiAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L21zdC92aG9zdC5naXQNCj4gdGFncy9mb3JfbGludXMNCj4gPg0K
PiA+IGZvciB5b3UgdG8gZmV0Y2ggY2hhbmdlcyB1cCB0bw0KPiA3MTQ5MWM1NGVhZmEzMThmZGQy
NGExZjI2YTFjODJiMjhlMWFjMjFkOg0KPiA+DQo+ID4gICB2aXJ0aW9fcGNpOiBkb24ndCB0cnkg
dG8gdXNlIGludHhpZiBwaW4gaXMgemVybyAoMjAyMi0xMC0wNyAyMDowMDo0NCAtMDQwMCkNCj4g
Pg0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gPiB2aXJ0aW86IGZpeGVzLCBmZWF0dXJlcw0KPiA+DQo+ID4gOWsg
bXR1IHBlcmYgaW1wcm92ZW1lbnRzDQo+ID4gdmRwYSBmZWF0dXJlIHByb3Zpc2lvbmluZw0KPiA+
IHZpcnRpbyBibGsgU0VDVVJFIEVSQVNFIHN1cHBvcnQNCj4gPg0KPiA+IEZpeGVzLCBjbGVhbnVw
cyBhbGwgb3ZlciB0aGUgcGxhY2UuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFMu
IFRzaXJraW4gPG1zdEByZWRoYXQuY29tPg0KPiA+DQo+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IEFsdmFybyBL
YXJzeiAoMSk6DQo+ID4gICAgICAgdmlydGlvX2JsazogYWRkIFNFQ1VSRSBFUkFTRSBjb21tYW5k
IHN1cHBvcnQNCj4gPg0KPiA+IEFuZ3VzIENoZW4gKDEpOg0KPiA+ICAgICAgIHZpcnRpb19wY2k6
IGRvbid0IHRyeSB0byB1c2UgaW50eGlmIHBpbiBpcyB6ZXJvDQo+IA0KPiBUaGlzIGNvbW1pdCBi
cmVha3MgdmlydGlvX3BjaSBmb3IgbWUgb24gcG93ZXJwYywgd2hlbiBydW5uaW5nIGFzIGEgcWVt
dQ0KPiBndWVzdC4NCj4gDQo+IHZwX2ZpbmRfdnFzKCkgYmFpbHMgb3V0IGJlY2F1c2UgcGNpX2Rl
di0+cGluID09IDAuDQo+IA0KPiBCdXQgcGNpX2Rldi0+aXJxIGlzIHBvcHVsYXRlZCBjb3JyZWN0
bHksIHNvIHZwX2ZpbmRfdnFzX2ludHgoKSB3b3VsZA0KPiBzdWNjZWVkIGlmIHdlIGNhbGxlZCBp
dCAtIHdoaWNoIGlzIHdoYXQgdGhlIGNvZGUgdXNlZCB0byBkby4NCj4gDQo+IEkgdGhpbmsgdGhp
cyBoYXBwZW5zIGJlY2F1c2UgcGNpX2Rldi0+cGluIGlzIG5vdCBwb3B1bGF0ZWQgaW4NCj4gcGNp
X2Fzc2lnbl9pcnEoKS4NCj4gDQo+IEkgd291bGQgYWJzb2x1dGVseSBiZWxpZXZlIHRoaXMgaXMg
YnVnIGluIG91ciBQQ0kgY29kZSwgYnV0IEkgdGhpbmsgaXQNCj4gbWF5IGFsc28gYWZmZWN0IG90
aGVyIHBsYXRmb3JtcyB0aGF0IHVzZSBvZl9pcnFfcGFyc2VfYW5kX21hcF9wY2koKS4NCj4gDQo+
IGNoZWVycw0KSEksc29ycnkgZm9yIHJlcGx5IGFnYWluLiBJZiBJIGNoYW5nZSB0aGUgY29kZSBs
aWtlIGJsZXc6DQogcGNpX3JlYWRfY29uZmlnX2J5dGUoZGV2LCBQQ0lfSU5URVJSVVBUX1BJTiwg
JnBpbik7DQogaWYgKCFwaW4pIHsNCiAgICAgICAgd2Fybl9vbigic29tZSB0aGluZyIpOw0KICAg
ICAgICAgcmV0dXJuIDA7DQogICAgICAgIH0NCkl0IHdpbGwgZml4IHRoZSBvcmlnbiBidWcuDQpP
ciB3ZSBzaG91bGQgcG9wdWxhdGVkIHRoZSBwY2lfZGV2LT5waW4gdmFsdWUgY29ycmVjdGx5IGFj
Y29yZGluZyB0byBQQ0kgc3BlYyBhYm91dCAiSW50ZXJydXB0IFBpbiIgUmVnaXN0ZXIuDQoNCkkg
aGF2ZSBubyBpZGVhIGFib3V0IGl0LCBhbnkgc3VnZ2VzdGlvbnMgYXJlIHdlbGNvbWUuDQpUaGFu
ayB5b3UuDQo=
