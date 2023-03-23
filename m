Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323026C65B3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjCWKvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjCWKvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:51:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414AE1715
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679568595; x=1711104595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=El9dPkU7YNQUTpwnJ/4g/cJvkElgzmJV3MuOGLM8hDM=;
  b=FQOtPXGSPli+n7yWg2SJeRss5FSMMvx9qVgCImA+yFqYZGUi2+X9AIua
   3oWbWKo4CXcFDXQ/3AWmwaZTtHr5HbvSwxX943inlpyW8T9ivzFXVvpKL
   RN2qxuzLiOR1CYpdiJl05wbc0WAc6nbZPMfzjqTSA5KvPV5hks/58UpuD
   7hy8RKe6fulstwFVShTN5YXIU5Y0hsD7MZBdU5D5rEJb7pMTsbFAxxgTg
   8BHbudJiGGyeqUu+5EgYiuDP8yXswgAyBOMh2ci+XVyySnmje7B8iEzYj
   ALqUnsmGo9qVTJCw0aSLez875BrtXVzXWflk6T9Din8gsKssfSXqPBCOJ
   g==;
X-IronPort-AV: E=Sophos;i="5.98,283,1673938800"; 
   d="scan'208";a="203049924"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 03:49:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:49:50 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 03:49:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV0RRth/EAD2L5ib9pKHONW34LuOuHeQ7mbRFW6IFSVAeDrenSa+/PwTmQdMecQ8G+fy7vlhWJKFHfTrgCKRAYLplvidk1Io1LkakamnulRUVDdFzcps1I1QCWSfpFm+CIT54ZasD/QLMToJe3fmWNkOEwoHklasJJIx8VUuqxI8PGkH6K9OpaWA5GBT3jCC9FwKtZw7/JC0s1ptggI8y60dwc2FEqu10mbqvJFJEc6fWGwhlsD9gQXlYF0jPkWVY4HFKcL97QMO6e9ua5UetoUzz2L2sZgextcWaKo8iOGvQWrc7X4XitWm+BgzmijKlaYCrqEwPGxOzqKWva48RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=El9dPkU7YNQUTpwnJ/4g/cJvkElgzmJV3MuOGLM8hDM=;
 b=HVkL5mWTk8L63K1K2J3xl8k/1DPlKU/5E6rhMts6i6DInG29CFLOkO+Uo88doncX25ZxiUQ6Wk4bWvj6RCVQntV+5e34ImokumByo9geb7egB+wtrna8Mm74tscLcK/VoRxzEiyRWtOcU8rPUs+NcghQPJRjq5tear9lB5WZyaAGeJb0v5ZZXE8bNwAhWF9qd5Hm9bLgTwM9I7u2CZ0pWt5ZOP9L/38wrl0sAZ3lKhLSanv0MbBST4y+XyFDolA60dbW+1xfFfSKHBLjoqj7F+nWEsllw2fXamK7myeKS/FJUDYezn4D0nFbzrGeydZcoZTspGxXQ1Bln8UgCMNtEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=El9dPkU7YNQUTpwnJ/4g/cJvkElgzmJV3MuOGLM8hDM=;
 b=F8qmOT/BqURy3cXf0soerdW4dnwhc3b1FUkik2pNzHEj45ziiqPVp+xcQUoL+bs0PgYGe2bjF9IMtIE3USVupzuqVwuE+mr1VGSLNjQ9Pw+L0zAA7aBsDqMXOkZkGo9ejU9rFSHhAIfe/CzD2MHgvtLaLQK+y+M48D3QiJOdtb8=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 CY8PR11MB6890.namprd11.prod.outlook.com (2603:10b6:930:5d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.38; Thu, 23 Mar 2023 10:49:48 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9%5]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 10:49:48 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <jiawenwu@trustnetic.com>, <netdev@vger.kernel.org>
CC:     <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net] net: wangxun: Fix vector length of interrupt cause
Thread-Topic: [PATCH net] net: wangxun: Fix vector length of interrupt cause
Thread-Index: AQHZXKhpW2szfE1mBkODVzyUEXXgeK8IMQ2A
Date:   Thu, 23 Mar 2023 10:49:48 +0000
Message-ID: <CRDPDHCPMF0Y.2F1OU3EK4P9NI@den-dk-m31857>
References: <20230322103632.132011-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230322103632.132011-1-jiawenwu@trustnetic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|CY8PR11MB6890:EE_
x-ms-office365-filtering-correlation-id: e3743656-f05e-40a6-bc37-08db2b8c5274
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PU/LTecECWb1NnzXe8t4NKrKcEybO1c0pBGb6sOVgfYa5am7i+l5tIyL+uNFd/jVwKJAA7iw8xFng9z+TpQfR/91RuEw7p93XjHbE290vcDjKxGpAs972nEHHHCVeBux7xl9XbuwgbyNHtOUkfd1ADW5uWU19qKTZlSxu+oZMK49jvSS8AA76ATaI29IoPPdeyI6FwHI6TK/J1gKww06LCfcUp61I7i29SnbgrH5sXRbFFPK7Nm7O7DYDO8N3ZI4WEMuoZXIYksrJKe94/5GQoys0jnhOzb8lRUHZoqEEGET9VnzFKERBhJn4UZVGinIDQ/2wzR6aJpGlJGbPrK1BzmnQuJtAhVXa4pZDRiBwKuYfKbOrb4e7EnUQN4rXJLxLSzBiua2HuQvelCxWeLJroTsQa0UtANZp01wBrAB8SjHoAPL3wUJ+OzyffT9dFDgn7ss0mFnP2LKGj5E8bRiIthnxMH8nV0uZTDJPTD2Qd+pL7lI8YFp2ev89ShuzdX9izBfYgg0EReebrYr/pnxvYoVeu6O6EDH5Fxg357+wfDR5QS39nnsvJ7I6bRjWjNHMsUmB6C8sr+cL2gHSF7kLsz3DQgkYPQp19z3RSWfibu+kfhtG7pTTDKQKMqPu9O0gqY6USsy4HEkPOVyGTzrfiaoJMN2s0RURUqWnJIUal4nVN6BA4YStAiUv1dSpsITMs8wZCe7DDHy55UhMjW/tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(26005)(6512007)(6506007)(38100700002)(33716001)(122000001)(83380400001)(186003)(9686003)(41300700001)(110136005)(478600001)(33656002)(8936002)(5660300002)(66476007)(66446008)(66946007)(66556008)(64756008)(76116006)(4326008)(8676002)(91956017)(316002)(86362001)(6486002)(2906002)(71200400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2tLejcwNlNjdHZiSEU3N3hjWitGZkVOSEY4cFhOd0VNaEhRcmp6V0RBVWR4?=
 =?utf-8?B?THhPVXlUeTdTRUduMjN4UGF4eWEzN3hFK0wySXRuZGRtYVkxT1dRbWlnY2hw?=
 =?utf-8?B?WnB1aVQvSUlvQjFUYk5xSi9BeGJsaDFOb08rb3J3bUdWaVJyalVNYWtTckF4?=
 =?utf-8?B?K3ZRSXlCRTlJUUlsZ3NYckFOdi9iUlZJRlpEUkQvaGtkM0ViR3haU1RxYno5?=
 =?utf-8?B?Z3Nsc0wrTEtZUU5zeWNPMmdkRFVJZXBLVWlGNGR5Y0I4eEtJZDFSN3VzODBl?=
 =?utf-8?B?TkdRVkQ2Vmt3V2Z3Y2FYRlN6dUpndDJhRnljLzZPaUFTVWZjajRWNWJGbElW?=
 =?utf-8?B?VkdIVTMrYnMzVXEvNm5LYUxQcHoxMytZYmZnbWh2WnRmcG5hTGRJZFE3am5V?=
 =?utf-8?B?L3BpTGxYenZET0xqRUFVbzlRM0Y3K2FacHFBWURFRkI4Uk9FclRxejVXNGtJ?=
 =?utf-8?B?am5aMFpnK0xVOWdqbG1vS1g4Nlh6TjZmaFFlMWcvc0ZLR0IybFBKWWFQVmQz?=
 =?utf-8?B?UnBMVWE1bW1rcER4bU9jN2pxeXlWZ09SNXhZU0pjaC9rWHdGVlJnUEw5djMx?=
 =?utf-8?B?S0lTUkNONCtsQWdyL1FaSkVBQngrcCtIUVZhU2RaRzNCY3hwdGdKenRPM1R0?=
 =?utf-8?B?UlJ3WlNXa0g0RlN4UGFhT0phaEcrVTBOT2t5ZkxQSEVPLzZEZ0RMM2c3REtU?=
 =?utf-8?B?NFJjMk1UcjVpSGJsNlNKRC91MjBNUXRsNklXS0hHNytrTmhub05ETXhZYUJj?=
 =?utf-8?B?cFRvcDF1OU44RW4rcWs2d1B0NDhHOGphbFNzR0JsbDU2Q0NGbTN4dWJUOFBx?=
 =?utf-8?B?bUZhdEp5aStSVi9IUWUzS0VRZUZsZ2xINWcyWElaUHdabC9FUUk4ZjNqNmpn?=
 =?utf-8?B?WTdVS2x0aWMzbkozbFRUckxpeitPVEc3MmkvMlNJRVl0MnA5ODFaSVFCU29V?=
 =?utf-8?B?cURGcTkxSStPaHRyN0tEK0xDK1N0Y2tKSFV3K3k4VE1VMXNRdFJxdHRhNVoz?=
 =?utf-8?B?K0o1cTNDUHZMdkt1Tkc3YkJxdG1sTklWV01wVFB0K1l1cXZucnBna01aaG1s?=
 =?utf-8?B?bW9TdmFjTmYxK29NakpZejFKMHNXOE92dFhiTFlNa1lCaWRqMXBZZFp5amhY?=
 =?utf-8?B?aURUZnlrV3p2NlBXR1FGdG95VlBHYUxhSXJyNVMyVEtxVVE3SG4rR0hScVVZ?=
 =?utf-8?B?a1QxdlFCeE1Ha2s1TG5wVlM0eXVwamVYUUt1Z3crazhtK2thL01YL3RNd3NM?=
 =?utf-8?B?VEZMaGRmNDZOUzUwc0dQK3JDOC96d1FLanZRRG01eFBSYjQrSmZRMitvNmFs?=
 =?utf-8?B?WDJ3Z0ZoS1RKOFZxUVVhZVhobmhXZGhXcWN3Tk9BRWVoSWVoVDZuSjlXcC9k?=
 =?utf-8?B?MkNJc3I2d1B1QUUxdmYxRlZkZDZtWkhUalo2SEVVdzRmQjh3VE44YUx2RWZj?=
 =?utf-8?B?Z2o1T3VHOE1TdVZTNlFFRlpDVGc3TjVIVHZGNzdIWUoybHdxT0dxS21RcURl?=
 =?utf-8?B?VklXMkR0M3Y5cFlTK2YveWhXS01VR2VjMGhQNUttNDFwRTRWSU52aGcvcGtE?=
 =?utf-8?B?YTc2SHpneWRobSt3V0xYYjQwbkdJSWNzVEdYRFFYeFRjM2tWWDNJZ2dYY1hV?=
 =?utf-8?B?dHZoZFFZL0grSk1Wam5YbzlVVEpEbzlTNVhtcXUwTzM5alBSdDdKdVFUZDNx?=
 =?utf-8?B?Mm1kNnBDTmZkRFk1MmlyQnBqQ2hPWFNidHdLelBZZ1FGRkFVQjRUa1B3TnZZ?=
 =?utf-8?B?RTl0dkZ0aEdtV0VxQ21CZm5OZTkwYmRmZjJtR3dxZHI0SFNpWFJpT0h0bkF2?=
 =?utf-8?B?WmxqQnoveUtZaUg1dm9wZ1JCa1V0cDIxajlBbitnZXpLZXJJY3hTTW43RlBm?=
 =?utf-8?B?ckpuTUdEQVNBZWhiZGFRZTluc3dxNW1ORTh3bHk1dTJKNWlxcTM3R01SWUtH?=
 =?utf-8?B?TStEMDQzZEdRK2F0YTNxcXc1QmlQQmw5bXdjYTBEVDRjOTI5MEMxcjRkWEhj?=
 =?utf-8?B?VkRkaW84dmVqenc1M3hiRWUvM0ZzeVJWN0hWcmV6SWQ3ZlNkeUR2MFkrdW1Q?=
 =?utf-8?B?U0JwMW5FRDI4T2ZLYWZ2SWxKeXI2OTdIYnhTN1lEckQ4Z2JYbjlKRDBxY0V0?=
 =?utf-8?B?QVppandRbWlHaXJOODBTL1NoWHYySG5uczR6aCswS0ZpQTBRVGxMZU5tenY1?=
 =?utf-8?Q?QgbxrK/GVWjFd/RLzNw4hOk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8FDB0B62D6435499900EC950FCBE452@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3743656-f05e-40a6-bc37-08db2b8c5274
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 10:49:48.1698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LdNPTerHwADuoCnBwNhh20dyFDuP9wV1GY+NdAxR0SG7+mEsumC98DXUqzrd9vopL749SWk3FGFFr51EkaOIwvgVbWVL6MeuES3vPA2TfOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6890
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlhd2VuLA0KDQoNCk9uIFdlZCBNYXIgMjIsIDIwMjMgYXQgMTE6MzYgQU0gQ0VULCBKaWF3
ZW4gV3Ugd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPg0KPiBU
aGVyZSBpcyA2NC1iaXQgaW50ZXJydXB0IGNhdXNlIHJlZ2lzdGVyIGZvciB0eGdiZS4gRml4IHRv
IGNsZWFyIHVwcGVyDQo+IDMyIGJpdHMuDQo+DQo+IEZpeGVzOiAzZjcwMzE4NjExM2YgKCJuZXQ6
IGxpYnd4OiBBZGQgaXJxIGZsb3cgZnVuY3Rpb25zIikNCj4gU2lnbmVkLW9mZi1ieTogSmlhd2Vu
IFd1IDxqaWF3ZW53dUB0cnVzdG5ldGljLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC93YW5neHVuL2xpYnd4L3d4X3R5cGUuaCAgICB8IDIgKy0NCj4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L3dhbmd4dW4vbmdiZS9uZ2JlX21haW4uYyAgIHwgMiArLQ0KPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvd2FuZ3h1bi90eGdiZS90eGdiZV9tYWluLmMgfCAzICsrLQ0KPiAgMyBmaWxlcyBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC93YW5neHVuL2xpYnd4L3d4X3R5cGUuaCBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3dhbmd4dW4vbGlid3gvd3hfdHlwZS5oDQo+IGluZGV4IDc3ZDhkN2YxNzA3
ZS4uOTdlMmMxZTEzYjgwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC93YW5n
eHVuL2xpYnd4L3d4X3R5cGUuaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC93YW5neHVu
L2xpYnd4L3d4X3R5cGUuaA0KPiBAQCAtMjIyLDcgKzIyMiw3IEBADQo+ICAjZGVmaW5lIFdYX1BY
X0lOVEEgICAgICAgICAgICAgICAgICAgMHgxMTANCj4gICNkZWZpbmUgV1hfUFhfR1BJRSAgICAg
ICAgICAgICAgICAgICAweDExOA0KPiAgI2RlZmluZSBXWF9QWF9HUElFX01PREVMICAgICAgICAg
ICAgIEJJVCgwKQ0KPiAtI2RlZmluZSBXWF9QWF9JQyAgICAgICAgICAgICAgICAgICAgIDB4MTIw
DQo+ICsjZGVmaW5lIFdYX1BYX0lDKF9pKSAgICAgICAgICAgICAgICAgKDB4MTIwICsgKF9pKSAq
IDQpDQo+ICAjZGVmaW5lIFdYX1BYX0lNUyhfaSkgICAgICAgICAgICAgICAgKDB4MTQwICsgKF9p
KSAqIDQpDQo+ICAjZGVmaW5lIFdYX1BYX0lNQyhfaSkgICAgICAgICAgICAgICAgKDB4MTUwICsg
KF9pKSAqIDQpDQo+ICAjZGVmaW5lIFdYX1BYX0lTQl9BRERSX0wgICAgICAgICAgICAgMHgxNjAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3dhbmd4dW4vbmdiZS9uZ2JlX21h
aW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3dhbmd4dW4vbmdiZS9uZ2JlX21haW4uYw0KPiBp
bmRleCA1YjU2NGQzNDhjMDkuLjE3NDEyZTUyODJkZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvd2FuZ3h1bi9uZ2JlL25nYmVfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3dhbmd4dW4vbmdiZS9uZ2JlX21haW4uYw0KPiBAQCAtMzUyLDcgKzM1Miw3IEBA
IHN0YXRpYyB2b2lkIG5nYmVfdXAoc3RydWN0IHd4ICp3eCkNCj4gICAgICAgICBuZXRpZl90eF9z
dGFydF9hbGxfcXVldWVzKHd4LT5uZXRkZXYpOw0KPg0KPiAgICAgICAgIC8qIGNsZWFyIGFueSBw
ZW5kaW5nIGludGVycnVwdHMsIG1heSBhdXRvIG1hc2sgKi8NCj4gLSAgICAgICByZDMyKHd4LCBX
WF9QWF9JQyk7DQo+ICsgICAgICAgcmQzMih3eCwgV1hfUFhfSUMoMCkpOw0KDQpIZXJlIHlvdSBv
bmx5IGNsZWFyIGlycSAwIGJ1dCBub3QgMS4uLg0KDQo+ICAgICAgICAgcmQzMih3eCwgV1hfUFhf
TUlTQ19JQyk7DQo+ICAgICAgICAgbmdiZV9pcnFfZW5hYmxlKHd4LCB0cnVlKTsNCj4gICAgICAg
ICBpZiAod3gtPmdwaW9fY3RybCkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3dhbmd4dW4vdHhnYmUvdHhnYmVfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvd2FuZ3h1
bi90eGdiZS90eGdiZV9tYWluLmMNCj4gaW5kZXggNmMwYTk4MjMwNTU3Li5hNThjZTU0NjM2ODYg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3dhbmd4dW4vdHhnYmUvdHhnYmVf
bWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3dhbmd4dW4vdHhnYmUvdHhnYmVf
bWFpbi5jDQo+IEBAIC0yMjksNyArMjI5LDggQEAgc3RhdGljIHZvaWQgdHhnYmVfdXBfY29tcGxl
dGUoc3RydWN0IHd4ICp3eCkNCj4gICAgICAgICB3eF9uYXBpX2VuYWJsZV9hbGwod3gpOw0KPg0K
PiAgICAgICAgIC8qIGNsZWFyIGFueSBwZW5kaW5nIGludGVycnVwdHMsIG1heSBhdXRvIG1hc2sg
Ki8NCj4gLSAgICAgICByZDMyKHd4LCBXWF9QWF9JQyk7DQo+ICsgICAgICAgcmQzMih3eCwgV1hf
UFhfSUMoMCkpOw0KPiArICAgICAgIHJkMzIod3gsIFdYX1BYX0lDKDEpKTsNCg0KSGVyZSB5b3Ug
Y2xlYXIgaXJxIDAgYW5kIDENCg0KPiAgICAgICAgIHJkMzIod3gsIFdYX1BYX01JU0NfSUMpOw0K
PiAgICAgICAgIHR4Z2JlX2lycV9lbmFibGUod3gsIHRydWUpOw0KPg0KPiAtLQ0KPiAyLjI3LjAN
Cg0KV2h5IGlzIHRoZXJlIGEgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSB0d28gc2l0dWF0aW9ucz8N
Cg0KQlINClN0ZWVuDQo=
