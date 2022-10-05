Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423B85F50BA
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJEISv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJEISl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:18:41 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955FD72EE0
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:18:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1AY6BGSf+L79wTGgwhq6sXr4Gp7drcc0DkMQW37SudhFNyo3iB2JH2b5dnFO6DSy0CUTBlpxnSaCiR2vQTNNhi7kfXrO4SpsRGUTV2SFfC+fNyTida8MMUwEewVyTTa9vUizClZ61SITaCvQR37SjUXoH1wYT7IPLe1rzrWDQdLIT3hneFp3A8HFVdqasNSnIkSVM5T2mC8mYPz9NOoTKNFlFOFIurXcacQkihdou48xAqQPf2AejHz2n2u+4Hhe+VD8SHaCqrQgGEO7w0Jq5+nRHzjSXcW3uuAM2JYS4w60XVP6PR6xq8MDlJqn4RGhj3wIYyAqjvov1o7KPEcmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHUvKm9bQOvj4jd1lztIp3/ChEXK+CKy/GPjC4cvClc=;
 b=U0tB0wsPIG9XbKAAly6ziHT0HrOENEsbJFZUh/p5AcYZqAkUh+Ng1/8YDRkons6CneDM2e5FEfppN3qBNMJLSw96YTGTR85rsa1SuCKyTh3FZ5no3RANpfY89bw2zSR+7iEryrIixfkND7FYUhPh4iDCTKjU4lp6oubw5y+CGh9bBER46sWwWdCrlB7n40drxr/vKJQEFzgqg6c/zP3zJ9OIoPtgvyhJgrRmvIoqhk/TwjUs35Osp44cYzgFTXRsaA8cWQhFRX76CULFEamApCFlzMHmHFcRbIJQ0Msp9pLj7S1CloX/UDiZqXQxqkXSVPaas/7rKv9aN5Sqog4l5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHUvKm9bQOvj4jd1lztIp3/ChEXK+CKy/GPjC4cvClc=;
 b=N+0OSTOJ1vy4UICJo6NOnBqQ6GOypoZi/LAssOUWR2vwKvaTvxgFe1OBT8RlynwMGt4ugA1c1mbDWmXWAXUs11Halecg0Zqo4TEpeBKlbw9bMcKsgn9VsQAuANHKd+80PUi6KV43AhT2/6Lbh+HXZD+QKrbtRXaEacL2vXkeJNU=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by BL1PR12MB5945.namprd12.prod.outlook.com (2603:10b6:208:398::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Wed, 5 Oct
 2022 08:18:31 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::b131:1ee7:1726:3ac9]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::b131:1ee7:1726:3ac9%5]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 08:18:29 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "dmichail@fungible.com" <dmichail@fungible.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>
Subject: Re: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Thread-Topic: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Thread-Index: AQHY0aQfklrqw/9EBkuPEu5x26dKnK3+aDuAgAESfACAAAfMAA==
Date:   Wed, 5 Oct 2022 08:18:29 +0000
Message-ID: <c85fb638-77d1-dbbd-51aa-e39b05652e75@amd.com>
References: <20220926110938.2800005-1-jiri@resnulli.us>
 <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com> <Yz03Cm/OBMae5IVT@nanopsycho>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|BL1PR12MB5945:EE_
x-ms-office365-filtering-correlation-id: 910b5386-c8b3-4393-82f2-08daa6aa2f1b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AAv65Tp10RoH6YD4Fbz526VN78l5zh3L+r3G/tVSTWkxuuAU1bHuC1O9zfCQgcTFHvhv6WxlSToM4vrMJ6PZerMoD7mAZjk7d6IDPIjHdignzMa18JvFyILcV1TEHws91Bvvd1B3kRqi744vxDWcXbMKFy/lteHQRzaA1p8gJLoPKzQgRkRQ+oFSt2hgnfcxlAgDcGjHfc7vmRfTI2qQQFxgq+y3TsSwAvhr4reKFimC6CsF/PmJgub+VevpMiAzjG7tHKIE3NUID3iAMB9KfbGabYSuFYiQem72YPGTg9Ug5jK0v/T82TZ2X2hRNUuv8rBKhyZ/6GOPMSGZB2lBT20CWW+2/FO5LaLGYiTQWQWB5XsUnSTsItMAU4pLD7Z/ycx3DlbQ+UMxe9sJrbVLtJY4XsL5xu2L8tHPB3bjBuXODl7Vfv67MdvOaLkSExpHQ/1lrIp/T0S1vnRRRbPRWuY+APtMfJnCwMQKt0okI+4yd+WUSOZfDra1sceyI+hXZWC0MbqzXrx0tzXwaSpV/ZBXqtJ+ZrgdZX3Rc81WVRsX0M3FVEX+bJuSrvIThwi7qax4t3KUko/NaxQ89CTOUw8pCFHJtkC2G1xhpg+Ec6VukXe1OroLJxwLF0OJJGem0YYfi5fYbszKGmpH5nuV2VAm9+m6aRccak/IS3uiI+O61KnWFVPJWdmw4Cnxjum5oTK9jlQquZn/CX+PQOWeGp1V+0we8HY5JjeiW+xEVMGXN1EoarZ6DmKUjClX+Xrmp7LPBsdt0wpSK/tzEs3sOGE+zMfVbs/w2Nf0Q5X63mQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199015)(316002)(26005)(8936002)(36756003)(41300700001)(53546011)(6506007)(91956017)(76116006)(66946007)(66476007)(66446008)(5660300002)(8676002)(4326008)(6512007)(64756008)(7416002)(66556008)(38070700005)(38100700002)(122000001)(2906002)(86362001)(31696002)(2616005)(186003)(83380400001)(478600001)(31686004)(6486002)(110136005)(71200400001)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkhHTWhtYVJLaDNQMmpsWFN3UHFlVVM1M21JYUkyWlpsSjRIbVo3VVpiT3Fr?=
 =?utf-8?B?VGRsMGgrVldMVG02TDhRTnV1aHRHR0V4NzlTeWlQNDBCK25XNTJJRnBlMTU4?=
 =?utf-8?B?ZnZJZzBIMFRmNUlnMEVnVmJiK2V5MHc0SUZ4YXYyMitvTklsLzZkVlJwMlBH?=
 =?utf-8?B?QTBrTEF0RldxWTJLL1NvTkwwVjU1cmd2aUwwclRXaEhSSDhrcUlwai9uaTh2?=
 =?utf-8?B?MXk3b3Y4d3ZOdmF5NVpNRTN0VUNLQnYzVTVhdWxSM2FLSWkxeUJ0RWtGNjJT?=
 =?utf-8?B?dHpHMHZUQW5zckhwL20rWEtXVmJEY1RIRWU4c1JkMWY2MEo5dTBaM0tpN21o?=
 =?utf-8?B?aWoxTGw3SDJEOExKcGt6T01UWWZ3dWl6cDFqVFljTGdVUjJyUHlUMzBrYW9o?=
 =?utf-8?B?WGpWelV2N1lRYnhKRlZXLzh1ZUsyT3B3MkFGV0dFNDFJK2JoMzFGZWhrTGM0?=
 =?utf-8?B?bTZqclNSa01NanFPZUQ2STREY2R6UGRxQWVQcjd0SHQyNWhHZ2VRNXM1K2Uy?=
 =?utf-8?B?QUpnU3J3N2tSakN3b3VUdWJTbEhidUV5TXBBT2dJTWJFYTFiK2h4THFkbjRr?=
 =?utf-8?B?bUczclhUSkpraUE4cldzTlBwUFNWUUwxRWdTajdCUVpvOURsaWtmNVdHUWlx?=
 =?utf-8?B?MHEyNXl6K3p1M1pLWTdZS0NJK3NpdWNaaUpleGN6TkhaN1FvSWZrQlM1bHFo?=
 =?utf-8?B?clhwMUNWMEQ3RUptbXQ0QTd5aGNmR0Jjb2pDUXJwU2JyOW0vTUFManlsYVI2?=
 =?utf-8?B?M3JYWjU1RDRVem5NNUxTQ2tmQktTSVdDdzY0VUU2KzdROTJEUEl2TzFLT2Zo?=
 =?utf-8?B?OW1aSDJoNVMvR3o5RExPdXFQZ2UrQ1RKRnllbGZJVXFQRkZseGRoTDZvZC9z?=
 =?utf-8?B?TnUzV1VtOG51MnJScDNnWWpkRE5paUZhM0s4K1lGeExyeXFXSm45Uk9SNEsv?=
 =?utf-8?B?RUJod3hXdkVyeDB0MkxKcUtEQmZjYjdkcmV3dTV6VG9KMWdjMjljVjZ2dVJF?=
 =?utf-8?B?cGYzYkdtUUVWTWE5OU9iUkFZb2xzckwyakN5VXhuSXdMWExrS2w5bDlTR2No?=
 =?utf-8?B?R0lsdUFsL05mM1c4MW9IUkdqWGFWMjFJSEFRYlhtVTBVUFhQRlNydEJHZzNE?=
 =?utf-8?B?bHltV3dQSzlPdE9taTRvNzFmdjFCOWxOci9YVjgxcUpmV2dPeHErRlNFR2ZX?=
 =?utf-8?B?dFV6RjhVR2ZvUi9KaHdQSS9vaUR0c25kWENzUEI1VjNoU0NPOW9IR1VFNmpo?=
 =?utf-8?B?ZkxZYjFGUkNhTlQ2ZTBUK3lVUzB6UEorWkR5QkYxSjNETWlwQjh2T0NHZzhC?=
 =?utf-8?B?REJmOU50Q0VsMnVnNE5NRWExdzAyWVY3dVhiYks5WVBzRERVRytOWFd3K3ZF?=
 =?utf-8?B?N2ZzWFdMMXRTVFhNWE5DVEMvbnFZaEM3S2hYVmhYeWY5enJGNHlrT1hnSjJt?=
 =?utf-8?B?WlpNTXZ1WVpVMXU1V1BLZVZrbnlDdSsweXlhdEZBSWp5ZkVxQWZGbTlkN2R5?=
 =?utf-8?B?WTZoRnd0dzBNbHBkNXhIRWNwSXl1anlRVTVpRXd5S0x2eVJweUV4U1ZGajVD?=
 =?utf-8?B?RXNiekZNb0xmR1RJVzVwOTI3ZExTd1dGdmk5QnJCSHJBUFFIcVBvVzNwdDBL?=
 =?utf-8?B?VGlSSXJWQlkwSjBtNHFsekFMRkxzamo1K0ZybkJJdkI5S2l0UWpKRDdFbXJo?=
 =?utf-8?B?MWEveHhyYkdlQy9aMzNBdWQ2ZVVYR1M2NXdBZ2J3d3VzVnlNeXkyNEdwaUg2?=
 =?utf-8?B?RUljYk9rSjNoWkt2eGJkaUpoUTczSXVZWUx4cGFvTHcrSzY1Q0IrcUx0R2tp?=
 =?utf-8?B?NVBBVkMxYWNzbW1GTVBWZzI0b3JQU09ZTVJLVEtocGVnL3d4V2wrenNGVWpJ?=
 =?utf-8?B?My9vTEtLNDB5WTE3SGt0Y3pRRFh2bXFFMmJJaFczWWQyZnkrMUJ4TVhvMkhv?=
 =?utf-8?B?blBZUTJvdm5US0ZMUmZFOHhJMzUyL0hpT3pJamtsRWdFNmcvY0UwOWVRZy9U?=
 =?utf-8?B?dDBKZTVzRVlvVkJOVmJUZnhmUjN2VjNQUUxEcG1PdmFDL2EvMEs5TkloVGRT?=
 =?utf-8?B?R2wyZ25sMU8xeWV4Wk81dTdpemN0VGdaYUlwb0xOSDBNOGhLS0NBcFpjQWlW?=
 =?utf-8?Q?715/gksrn49ojdEBEwYvfoe4K?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA82E8C22B24624E9620A5B56D18186B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910b5386-c8b3-4393-82f2-08daa6aa2f1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 08:18:29.0704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pO+TjBZ2340FjtJJJQnWHw2D73uLFe6Qziq4O5YB/GwkC+ExudIzakf+oBZiaME77YvD7QGEDhgoDcrkcTI3nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5945
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMC81LzIyIDA5OjQ5LCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBUdWUsIE9jdCAwNCwgMjAy
MiBhdCAwNTozMToxMFBNIENFU1QsIGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbSB3cm90
ZToNCj4+IEhpIEppcmksDQo+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgeW91IHNlbmQgdGhpcyBh
cyBhIHJlcGx5IHRvIHRoaXMgcGF0Y2hzZXQuIEkNCj4gZG9uJ3Qgc2VlIHRoZSByZWxhdGlvbiB0
byBpdC4NCg0KSSB0aG91Z2h0IHRoZXJlIHdhcyBhIHJlbGF0aW9uc2hpcCB3aXRoIG9yZGVyaW5n
IGJlaW5nIHRoZSBpc3N1ZS4NCg0KQXBvbG9naWVzIGlmIHRoaXMgaXMgbm90IHRoZSByaWdodCB3
YXkgZm9yIHJpc2luZyBteSBjb25jZXJuLg0KDQoNCj4NCj4+IEkgdGhpbmsgd2UgaGF2ZSBhbm90
aGVyIGlzc3VlIHdpdGggZGV2bGlua191bnJlZ2lzdGVyIGFuZCByZWxhdGVkDQo+PiBkZXZsaW5r
X3BvcnRfdW5yZWdpc3Rlci4gSXQgaXMgbGlrZWx5IG5vdCBhbiBpc3N1ZSB3aXRoIGN1cnJlbnQg
ZHJpdmVycw0KPj4gYmVjYXVzZSB0aGUgZGV2bGluayBwb3J0cyBhcmUgbWFuYWdlZCBieSBuZXRk
ZXYgcmVnaXN0ZXIvdW5yZWdpc3Rlcg0KPj4gY29kZSwgYW5kIHdpdGggeW91ciBwYXRjaCB0aGF0
IHdpbGwgYmUgZmluZS4NCj4+DQo+PiBCdXQgYnkgZGVmaW5pdGlvbiwgZGV2bGluayBkb2VzIGV4
aXN0IGZvciB0aG9zZSB0aGluZ3Mgbm90IG1hdGNoaW5nDQo+PiBzbW9vdGhseSB0byBuZXRkZXZz
LCBzbyBpdCBpcyBleHBlY3RlZCBkZXZsaW5rIHBvcnRzIG5vdCByZWxhdGVkIHRvDQo+PiBleGlz
dGluZyBuZXRkZXZzIGF0IGFsbC4gVGhhdCBpcyB0aGUgY2FzZSBpbiBhIHBhdGNoIEknbSB3b3Jr
aW5nIG9uIGZvcg0KPj4gc2ZjIGVmMTAwLCB3aGVyZSBkZXZsaW5rIHBvcnRzIGFyZSBjcmVhdGVk
IGF0IFBGIGluaXRpYWxpemF0aW9uLCBzbw0KPj4gcmVsYXRlZCBuZXRkZXZzIHdpbGwgbm90IGJl
IHRoZXJlIGF0IHRoYXQgcG9pbnQsIGFuZCB0aGV5IGNhbiBub3QgZXhpc3QNCj4+IHdoZW4gdGhl
IGRldmxpbmsgcG9ydHMgYXJlIHJlbW92ZWQgd2hlbiB0aGUgZHJpdmVyIGlzIHJlbW92ZWQuDQo+
Pg0KPj4gU28gdGhlIHF1ZXN0aW9uIGluIHRoaXMgY2FzZSBpcywgc2hvdWxkIHRoZSBkZXZsaW5r
IHBvcnRzIHVucmVnaXN0ZXINCj4+IGJlZm9yZSBvciBhZnRlciB0aGVpciBkZXZsaW5rIHVucmVn
aXN0ZXJzPw0KPiBCZWZvcmUuIElmIGRldmxpbmsgaW5zdGFuY2Ugc2hvdWxkIGJlIHVucmVnaXN0
ZXJlZCBvbmx5IGFmdGVyIGFsbCBvdGhlcg0KPiByZWxhdGVkIGluc3RhbmNlcyBhcmUgZ29uZS4N
Cj4NCj4gQWxzbywgdGhlIGRldmxpbmsgcG9ydHMgY29tZSBhbmQgZ28gZHVyaW5nIHRoZSBkZXZs
aW5rIGxpZmV0aW1lLiBXaGVuDQo+IHlvdSBhZGQgYSBWRiwgc3BsaXQgYSBwb3J0IGZvciBleGFt
cGxlLiBUaGVyZSBhcmUgbWFueSBvdGhlciBjYXNlcy4NCj4NCj4NCj4+IFNpbmNlIHRoZSBwb3J0
cyBhcmUgaW4gYSBsaXN0IG93bmVkIGJ5IHRoZSBkZXZsaW5rIHN0cnVjdCwgSSB0aGluayBpdA0K
Pj4gc2VlbXMgbG9naWNhbCB0byB1bnJlZ2lzdGVyIHRoZSBwb3J0cyBmaXJzdCwgYW5kIHRoYXQg
aXMgd2hhdCBJIGRpZC4gSXQNCj4+IHdvcmtzIGJ1dCB0aGVyZSBleGlzdHMgYSBwb3RlbnRpYWwg
Y29uY3VycmVuY3kgaXNzdWUgd2l0aCBkZXZsaW5rIHVzZXINCj4gV2hhdCBjb25jdXJyZW5jeSBp
c3N1ZSBhcmUgeW91IHRhbGtpbmcgYWJvdXQ/DQo+DQoxKSBkZXZsaW5rIHBvcnQgZnVuY3Rpb24g
c2V0IC4uLg0KDQoyKSBwcmVkb2l0IGluc2lkZSBkZXZsaW5rIG9idGFpbnMgZGV2bGluayB0aGVu
IHRoZSByZWZlcmVuY2UgdG8gZGV2bGluayANCnBvcnQuIENvZGUgZG9lcyBhIHB1dCBvbiBkZXZs
aW5rIGJ1dCBub3Qgb24gdGhlIGRldmxpbmsgcG9ydC4NCg0KMykgZHJpdmVyIGlzIHJlbW92ZWQu
IGRldmxpbmsgcG9ydCBpcyByZW1vdmVkLiBkZXZsaW5rIGlzIG5vdCBiZWNhdXNlIA0KdGhlIHB1
dC4NCg0KNCkgZGV2bGluayBwb3J0IHJlZmVyZW5jZSBpcyB3cm9uZy4NCg0KDQo+PiBzcGFjZSBv
cGVyYXRpb25zLiBUaGUgZGV2bGluayBjb2RlIHRha2VzIGNhcmUgb2YgcmFjZSBjb25kaXRpb25z
IGludm9sdmluZyB0aGUNCj4+IGRldmxpbmsgc3RydWN0IHdpdGggcmN1IHBsdXMgZ2V0L3B1dCBv
cGVyYXRpb25zLCBidXQgdGhhdCBpcyBub3QgdGhlDQo+PiBjYXNlIGZvciBkZXZsaW5rIHBvcnRz
Lg0KPj4NCj4+IEludGVyZXN0aW5nbHksIHVucmVnaXN0ZXJpbmcgdGhlIGRldmxpbmsgZmlyc3Qs
IGFuZCBkb2luZyBzbyB3aXRoIHRoZQ0KPj4gcG9ydHMgd2l0aG91dCB0b3VjaGluZy9yZWxlYXNp
bmcgdGhlIGRldmxpbmsgc3RydWN0IHdvdWxkIHNvbHZlIHRoZQ0KPj4gcHJvYmxlbSwgYnV0IG5v
dCBzdXJlIHRoaXMgaXMgdGhlIHJpZ2h0IGFwcHJvYWNoIGhlcmUuIEl0IGRvZXMgbm90IHNlZW0N
Cj4gSXQgaXMgbm90LiBBcyBJIHdyb3RlIGFib3ZlLCB0aGUgZGV2bGluayBwb3J0cyBjb21lIGFu
ZCBnby4NCj4NCj4NCj4+IGNsZWFuLCBhbmQgaXQgd291bGQgcmVxdWlyZSBkb2N1bWVudGluZyB0
aGUgcmlnaHQgdW53aW5kaW5nIG9yZGVyIGFuZA0KPj4gdG8gYWRkIGEgY2hlY2sgZm9yIERFVkxJ
TktfUkVHSVNURVJFRCBpbiBkZXZsaW5rX3BvcnRfdW5yZWdpc3Rlci4NCj4+DQo+PiBJIHRoaW5r
IHRoZSByaWdodCBzb2x1dGlvbiB3b3VsZCBiZSB0byBhZGQgcHJvdGVjdGlvbiB0byBkZXZsaW5r
IHBvcnRzDQo+PiBhbmQgbGlrZWx5IG90aGVyIGRldmxpbmsgb2JqZWN0cyB3aXRoIHNpbWlsYXIg
Y29uY3VycmVuY3kgaXNzdWVzLg0KPj4NCj4+DQo+PiBMZXQgbWUga25vdyB3aGF0IHlvdSB0aGlu
ayBhYm91dCBpdC4NCj4+DQo+Pg0KPj4NCj4+IE9uIDkvMjYvMjIgMTM6MDksIEppcmkgUGlya28g
d3JvdGU6DQo+Pj4gQ0FVVElPTjogVGhpcyBtZXNzYWdlIGhhcyBvcmlnaW5hdGVkIGZyb20gYW4g
RXh0ZXJuYWwgU291cmNlLiBQbGVhc2UgdXNlIHByb3BlciBqdWRnbWVudCBhbmQgY2F1dGlvbiB3
aGVuIG9wZW5pbmcgYXR0YWNobWVudHMsIGNsaWNraW5nIGxpbmtzLCBvciByZXNwb25kaW5nIHRv
IHRoaXMgZW1haWwuDQo+Pj4NCj4+Pg0KPj4+IEZyb206IEppcmkgUGlya28gPGppcmlAbnZpZGlh
LmNvbT4NCj4+Pg0KPj4+IFNvbWUgb2YgdGhlIGRyaXZlcnMgdXNlIHdyb25nIG9yZGVyIGluIHJl
Z2lzdGVyaW5nIGRldmxpbmsgcG9ydCBhbmQNCj4+PiBuZXRkZXYsIHJlZ2lzdGVyaW5nIG5ldGRl
diBmaXJzdC4gVGhhdCB3YXMgbm90IGludGVuZGVkIGFzIHRoZSBkZXZsaW5rDQo+Pj4gcG9ydCBp
cyBzb21lIHNvcnQgb2YgcGFyZW50IGZvciB0aGUgbmV0ZGV2LiBGaXggdGhlIG9yZGVyaW5nLg0K
Pj4+DQo+Pj4gTm90ZSB0aGF0IHRoZSBmb2xsb3ctdXAgcGF0Y2hzZXQgaXMgZ29pbmcgdG8gbWFr
ZSB0aGlzIG9yZGVyaW5nDQo+Pj4gbWFuZGF0b3J5Lg0KPj4+DQo+Pj4gSmlyaSBQaXJrbyAoMyk6
DQo+Pj4gICAgIGZ1bmV0aDogdW5yZWdpc3RlciBkZXZsaW5rIHBvcnQgYWZ0ZXIgbmV0ZGV2aWNl
IHVucmVnaXN0ZXINCj4+PiAgICAgaWNlOiByZW9yZGVyIFBGL3JlcHJlc2VudG9yIGRldmxpbmsg
cG9ydCByZWdpc3Rlci91bnJlZ2lzdGVyIGZsb3dzDQo+Pj4gICAgIGlvbmljOiBjaGFuZ2Ugb3Jk
ZXIgb2YgZGV2bGluayBwb3J0IHJlZ2lzdGVyIGFuZCBuZXRkZXYgcmVnaXN0ZXINCj4+Pg0KPj4+
ICAgIC4uLi9uZXQvZXRoZXJuZXQvZnVuZ2libGUvZnVuZXRoL2Z1bmV0aF9tYWluLmMgICB8ICAy
ICstDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuYyAgICAg
ICAgIHwgIDYgKysrLS0tDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9tYWluLmMgICAgICAgIHwgMTIgKysrKysrLS0tLS0tDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaWNlL2ljZV9yZXByLmMgICAgICAgIHwgIDIgKy0NCj4+PiAgICAuLi4vbmV0
L2V0aGVybmV0L3BlbnNhbmRvL2lvbmljL2lvbmljX2J1c19wY2kuYyAgfCAxNiArKysrKysrKy0t
LS0tLS0tDQo+Pj4gICAgNSBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxOSBkZWxl
dGlvbnMoLSkNCj4+Pg0KPj4+IC0tDQo+Pj4gMi4zNy4xDQo+Pj4NCg0K
