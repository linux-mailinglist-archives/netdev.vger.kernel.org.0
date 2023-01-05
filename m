Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD94265F06F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbjAEPtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjAEPtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:49:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC6559FA;
        Thu,  5 Jan 2023 07:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672933743; x=1704469743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VDa3p0n2MHNFefMemhVyP5fe2Wr0lbPrdrnaiXREU4E=;
  b=qEdWklRkYo6pSZfX8GBkSyx4Q55rN9GgxQTnf073sZliieZy0vcHOvCy
   jChqFExhtGMVthLxAqdFQfL55Eb8fybkuwMzLw5F2WJW1ttZd5GJH8rj9
   IugaPT+cGBcH9TKaXVFUJHlECx3jeDSmN9dzkqw5XF2DNO3zb/YDCAO2j
   31lTmCqIxceL0cAbPzSnq2L6/Otg1VFLiSE5RaknVHv6kc7csM/3iFJ17
   XsUlJYl07QTQkcNGYHPsBeYxuSF8XpqFXJOyQfyesw46Z+2ecy10OsEnR
   wxpX8YZv1/ZJjmki6cTMe9L9FFyL9+Yh6e13OJW33QH0xEsZx/I6oc957
   A==;
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="194441874"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2023 08:49:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 08:48:59 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 08:48:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwSlibSuX6f3KKRNEPRvYjGS1+dANlXJoIzO8KTiT7n5ekxL2SFGTCDiePy0bKpnKYfjhJIpV9VfKq4EWRp/2yfkIWcUQumEDc7IMUUM7Ri5EU6lMdzsuacLzVlKBIiSInXc6csRQryGLPcmUU03E0ne8jK9Gq3+ulHKEGhuflYTqXFfE9/pX0DFyxTyNk/Iwco/bJ3YyAfBHhB1D0zg9SGidcTR9UAG1EbVQ6ET0AKE4QbcQAlBlg2GREplKyJ4EKOA8WMUsv+bXzMjCNKjqkz1ijOkRJjOLBmWbWUlVLi1cjtroH+IYjJdO6ghmRyKWJpY/aaNt+QfQNSK5D/kRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDa3p0n2MHNFefMemhVyP5fe2Wr0lbPrdrnaiXREU4E=;
 b=T92medlwoLhG0G3bThfvqi2CBTcBbNORNo0bwFhHLT5OjajVksrZUF3FuVP+0H4evM3sHUaaWuCuyMxfOlLuM3FQCHlKQzFkf95Xy+6/YuqqskVXl6F63nnn1ghW1MWhBhvwGIwgT/Ey3JUW41iX3YDlyAPEqfmRTurdxkQwCN7Yk9KYv67fe7rs1Dh6OWIIhKkwmjXwwcXm9t1UfpBeOYZokQ1WC9TTg/6sczdqhUq0pIK/2e0c/wRnm3EodNbKCU5ryOPX1z/XxUOxhRB7aoNUOLKXw5rqmq/VBQvnKTRj4Mdv14TUZhMhpTHHRoRE9keL7nCnRXUv1CC5NKWKQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDa3p0n2MHNFefMemhVyP5fe2Wr0lbPrdrnaiXREU4E=;
 b=U4ps0zDh6BaN0I8EIyeUM9ZftppndqBwC7GUHsrmwt0TIX12GCRgk2J6I+iwf4mY6zezH/45W86oyyhACRN9qi72/4sLop4L+42RmKATznyXxEc4Wxp+s01vq14ZC6/xwtMgySQ2HXI/tgR0ke0TJR3lbcGqKW+ILcVfIT05u64=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA1PR11MB6566.namprd11.prod.outlook.com (2603:10b6:806:251::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Thu, 5 Jan 2023 15:48:56 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 15:48:56 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
CC:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>,
        <richardcochran@gmail.com>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P
 clocks
Thread-Topic: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P
 clocks
Thread-Index: AQHZIBj04D/wYVohdkulxgExYAbHM66Pm06AgAALMoCAAFO7AA==
Date:   Thu, 5 Jan 2023 15:48:55 +0000
Message-ID: <4a168b600a77447915855f3cc10b00dfe7da3835.camel@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
         <20230104084316.4281-7-arun.ramadoss@microchip.com>
         <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
         <bab8cb9e4916ed9f55c720883183812f4e1f717f.camel@redhat.com>
In-Reply-To: <bab8cb9e4916ed9f55c720883183812f4e1f717f.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA1PR11MB6566:EE_
x-ms-office365-filtering-correlation-id: bccfb069-11f2-4746-70d3-08daef345a71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z8LSELTQq7byRlsH1/OlSmRaqqfhzuaPngWTzcZklvAw6LtcWQSit5oH8VrtolmCU74L9YFqZXiWlWxdmjgRTWd3X+uDv36rKZ6nEFPE9+P6YA/umod8FXkf2P0CpNzdZZwzYFvstV7rtk0EKMNjmkcnEb9Jsza5Cs3UtIcM8Nct/plxVUm02o2sUZy51Sl0GQzGJk14/t2qeUTgN0HEzdKPmzJPnk/8hytk6/kdpQGJuFEgQaQeAm3MdU+9dR6yLIqS7JpdCsNoflRXtk1jzi9s6r9Tmql++rnzReLkWSaYUPdgvKH/QusR9+wxAGGYncFN6fFBn3bPoH6YtgnuRKWYpxJujUQTyrZg408VEw4PQqC68WiSSlR0TFfzK8kpHOZn/ytrm/TxdavRx2CWuZgNAFzuK9AlrSQMQ5clxn+g123DvsoHfSNVD9rMC1E75Rg5kyJud0Cuk/U1MpLNqqAvXZ6LywjqNHsRABL/94z21KmSVyg8biDneOEQwXom/VstJs/fz5DlbG/MqEiiXQEfojxn6DMX9x/4QIqZV+g+M4j2oqVhunEDmbebYMVi7c/pk/r5GHPei1vhMihlRtaOaf4hLZq+u6BGbM9I4YFsl24peG2hp+41X0PpNTaRY148XBSDYrCOASg9s1e75Q2jdD5tXXRmZ94Ww9yAMllfLKiLaiwaIqqQXhU41TqB7don+JLDUV/2jfTKD9sxF9X+/BZrPrV9YZSR2w/JIvs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199015)(36756003)(66446008)(91956017)(54906003)(4326008)(66946007)(41300700001)(66556008)(64756008)(66476007)(110136005)(38070700005)(76116006)(8676002)(38100700002)(122000001)(6486002)(186003)(71200400001)(478600001)(6512007)(86362001)(8936002)(2616005)(7416002)(2906002)(6506007)(316002)(5660300002)(83380400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXNoQjdNd0hrS094T2pjcmljcUcyTHZPOVR0c21SY3ZGVjdOUk9YYWJQamdI?=
 =?utf-8?B?NjhPMm1sTUNWSFZZSXlzdXlzKy9WWEtNQlVqbmI3V0hhVGY2Nlg3L1hIcldj?=
 =?utf-8?B?MUlrdWlIYncyK3FzWTlLS0w5bTZkUmhsa3hKTFRkdTZuaEFvTHVhdENHdXFr?=
 =?utf-8?B?TnZvUU1qZVBPZjVPUGRkSEIwcVJIVlNrRDI2c0lLNklMODAxeGwwRUJ5UW9I?=
 =?utf-8?B?SGtsQy9CSGR5NWYwbGh2MGFqWWpFZlR3RlNpOHVqd2pVeFFRS1FuY05TS3N6?=
 =?utf-8?B?U3FSYjZDZnlwMGw3c0RodzZYbkJGbFZJUTY5SjBhVUdxa3AyVzhOM1BlcTI5?=
 =?utf-8?B?RjNGeStvT0VJdkh6N0YyaXVsVVJ6THovUjRnb2RZVlZiTVNLTms5VVJmb2dp?=
 =?utf-8?B?VFVlTHk3OUtZK1hqWTNONXNCZnNNWVZUN1l4YzcvY2N2elJvSkFacUY0M0VE?=
 =?utf-8?B?TEhJdUhPbEZ3ZnVITHZIMFBYVVhlcnpLa2JWT0I4dlNXcDh0L29JbHRXV0ha?=
 =?utf-8?B?OTNEdGNXQm4wd2d4b0RoOG9TT3FMdC9ZUm9NMmtmN1I5dVRZUjJQdWgrOGpw?=
 =?utf-8?B?ODhUandEZ1FrYk5vOGZXRk9xUVhFRXpBY3o1KzNxNjlMYnBzbW9GNll0ZDY0?=
 =?utf-8?B?WUhsVHMwaWJ1eEd4VmV2b1NlM0R1dlpiVFhHVnN2WW5zazlSZXA5VUwwQ0xm?=
 =?utf-8?B?ajdOWFhNbDEzb0F2NFpBNjJ6eVdyaWtFUjJpejRRRStRb0h5dGhKeXNUQytM?=
 =?utf-8?B?TEYzT3VhYm9PVVNiVHZqRDI4UXhVaXNjeVBGZ1kxUGlLbnUvczY0RkJPOVpH?=
 =?utf-8?B?MFRNekt2cXhQcDFGOG5HUlViQ1Z3eW56VDhIT2c5c3BYeTNKa3V6ZFovMWxW?=
 =?utf-8?B?ay9KakpoMlZVcXN3a3dOTWJaMStvRk41aHR1YVlxWFZvZmZEaHJOQXNpOEw4?=
 =?utf-8?B?TGJvQnM3SGJ2VTdFck1qRi9QTExpWTlLcnpKZmJqUnFDOFNLdytodVdMRTJn?=
 =?utf-8?B?eTNLMnIxN0psWC9zZlJNTDZrU0N1VHJxTTVVR0c4ZGxhOGNZdFh3SVZ5WUxG?=
 =?utf-8?B?N25IeExNZ3dha1JWdGw1VUtidkNqL3hBdXM5VkpMQ0FmV0RhQ0l4TThZbmJp?=
 =?utf-8?B?bFdDN04xeUV1aTF0MkdTTWpvdDVqbWViMkdaMWxrdytzb3lCVjdKaWZ5Mm5y?=
 =?utf-8?B?cDA2OElFYVNkQlJ6OUFzVUNDb1Q2NUF2TFZHcVBxRG9GWnBQTk5SUCtBTVY4?=
 =?utf-8?B?d3VvdFM2ejZLZjB3ejl3dUNSTmVlbEpBR3JOUGU1UUI4blp3RFBhYXVtb0FV?=
 =?utf-8?B?cDNxQm5RUzRvclp4bVBjQVhWQU9lcTh6REZOK25aUFczZ3RVeUhkUXlhckk1?=
 =?utf-8?B?SmtjT0NWMFFtck0vQXZBZVFrRkxOODhialRxdVF5K0F6cVNKZ1Q5STNCVnQr?=
 =?utf-8?B?VjJWaGx3OGZ3Um91K2F0Z3FmejRVYTZlM2cxZ05FUFN5L0RtZ1FKMExRWWZs?=
 =?utf-8?B?dFRwaG9yZHdONHY4QzhvVDhBc21RSzFIZ3Q1NTB3VHdFTE8rU056Um5Md2do?=
 =?utf-8?B?L0ErY1NZWEJLTWhjenk5aDBSRTFsUlNEV0JKaVplVlRkYnhZMy9YcHdib2Fl?=
 =?utf-8?B?a3JlSlA5QXZnNmJ2SzhWSzhvc0pub21kYVRZaFRPYTZnUVRqYlV3c0NjK1BB?=
 =?utf-8?B?SnU5eU1SYStVR3JlUFNMeTZNT1RSeS9EdmtaOTZkWW9CQkgrY0I4MzJQd3k0?=
 =?utf-8?B?Ni9TMXIrZTZPUkF0TTlsaGxyU3NNT1lRYWl4V01Nd3dINnI0dEcwOHh3RDQx?=
 =?utf-8?B?aWpYcjJLaEJMOFRYd1JmVkxaeHBBVDVDQTRqR2E5dzZQK1JJLzhQOE03Z09j?=
 =?utf-8?B?MkRLcFo2NWY0WW43eGFoR1hyZjI4b0UrdUw0YXZScW14aGdCUzZtcXFxK3lk?=
 =?utf-8?B?U00xNllvNmI0d0tielNaNHlMUE8yWEJuU2NiNW1iVFRLNUxobmJhTUNIUzVR?=
 =?utf-8?B?QThudUlWMmxuL0ZXZENURHlLTVk1L0xISlJsYjJldkIrSVp6ek96L25pYU9v?=
 =?utf-8?B?dXgva0xHSFRyczlYSFpaMjFXa3JCZjNkbkVOaXZGNmZXQWZmRE9yM1dDdDl2?=
 =?utf-8?B?azJDSmo3ZFk4bVpuTXk2V3g5Z3pLVG1IZmd2YXZXQ2R4Q2VwRyt6dmZhaU9Z?=
 =?utf-8?B?bTF4bGJ6SE5xVHJMNlFGU3NLcVlOUWJuZGo0MnkrT2JzNDFzN05CQjJJUGxQ?=
 =?utf-8?Q?/ZrZ+Uh0rfIIx3BrCDXw59RW/6HTPs72QT1XqTQJ2c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0E9A75B6A57DB4CB073BE045BCC8E5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bccfb069-11f2-4746-70d3-08daef345a71
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 15:48:56.0443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cc0krejzzVvNijq5tu2/fuH2RgkJ2+EpA1ZaghFn8YTFK4NmQW1mSP/Jv+yV4h/xGAVI7izkAvuU3OvD1Cos4S6WyHCFErSo6LZCh3m+7co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6566
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQpUaGFua3MgZm9yIHRoZSByZXZpZXcgY29tbWVudC4NCk9uIFRodSwgMjAyMy0w
MS0wNSBhdCAxMTo0OSArMDEwMCwgUGFvbG8gQWJlbmkgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gDQo+ID4gPiArLyoqDQo+ID4gPiArICogcHRw
X2hlYWRlcl91cGRhdGVfY29ycmVjdGlvbiAtIFVwZGF0ZSBQVFAgaGVhZGVyJ3MgY29ycmVjdGlv
bg0KPiA+ID4gZmllbGQNCj4gPiA+ICsgKiBAc2tiOiBwYWNrZXQgYnVmZmVyDQo+ID4gPiArICog
QHR5cGU6IHR5cGUgb2YgdGhlIHBhY2tldCAoc2VlIHB0cF9jbGFzc2lmeV9yYXcoKSkNCj4gPiA+
ICsgKiBAaGRyOiBwdHAgaGVhZGVyDQo+ID4gPiArICogQGNvcnJlY3Rpb246IG5ldyBjb3JyZWN0
aW9uIHZhbHVlDQo+ID4gPiArICoNCj4gPiA+ICsgKiBUaGlzIHVwZGF0ZXMgdGhlIGNvcnJlY3Rp
b24gZmllbGQgb2YgYSBQVFAgaGVhZGVyIGFuZCB1cGRhdGVzDQo+ID4gPiB0aGUgVURQDQo+ID4g
PiArICogY2hlY2tzdW0gKGlmIFVEUCBpcyB1c2VkIGFzIHRyYW5zcG9ydCkuIEl0IGlzIG5lZWRl
ZCBmb3INCj4gPiA+IGhhcmR3YXJlIGNhcGFibGUgb2YNCj4gPiA+ICsgKiBvbmUtc3RlcCBQMlAg
dGhhdCBkb2VzIG5vdCBhbHJlYWR5IG1vZGlmeSB0aGUgY29ycmVjdGlvbg0KPiA+ID4gZmllbGQg
b2YgUGRlbGF5X1JlcQ0KPiA+ID4gKyAqIGV2ZW50IG1lc3NhZ2VzIG9uIGluZ3Jlc3MuDQo+ID4g
PiArICovDQo+ID4gPiArc3RhdGljIGlubGluZQ0KPiA+ID4gK3ZvaWQgcHRwX2hlYWRlcl91cGRh
dGVfY29ycmVjdGlvbihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1bnNpZ25lZA0KPiA+ID4gaW50IHR5
cGUsDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgcHRwX2hlYWRl
ciAqaGRyLCBzNjQNCj4gPiA+IGNvcnJlY3Rpb24pDQo+ID4gPiArew0KPiA+ID4gKyAgIF9fYmU2
NCBjb3JyZWN0aW9uX29sZDsNCj4gPiA+ICsgICBzdHJ1Y3QgdWRwaGRyICp1aGRyOw0KPiA+ID4g
Kw0KPiA+ID4gKyAgIC8qIHByZXZpb3VzIGNvcnJlY3Rpb24gdmFsdWUgaXMgcmVxdWlyZWQgZm9y
IGNoZWNrc3VtIHVwZGF0ZS4NCj4gPiA+ICovDQo+ID4gPiArICAgbWVtY3B5KCZjb3JyZWN0aW9u
X29sZCwgICZoZHItPmNvcnJlY3Rpb24sDQo+ID4gPiBzaXplb2YoY29ycmVjdGlvbl9vbGQpKTsN
Cj4gPiA+ICsNCj4gPiA+ICsgICAvKiB3cml0ZSBuZXcgY29ycmVjdGlvbiB2YWx1ZSAqLw0KPiA+
ID4gKyAgIHB1dF91bmFsaWduZWRfYmU2NCgodTY0KWNvcnJlY3Rpb24sICZoZHItPmNvcnJlY3Rp
b24pOw0KPiA+ID4gKw0KPiA+ID4gKyAgIHN3aXRjaCAodHlwZSAmIFBUUF9DTEFTU19QTUFTSykg
ew0KPiA+ID4gKyAgIGNhc2UgUFRQX0NMQVNTX0lQVjQ6DQo+ID4gPiArICAgY2FzZSBQVFBfQ0xB
U1NfSVBWNjoNCj4gPiA+ICsgICAgICAgICAgIC8qIGxvY2F0ZSB1ZHAgaGVhZGVyICovDQo+ID4g
PiArICAgICAgICAgICB1aGRyID0gKHN0cnVjdCB1ZHBoZHIgKikoKGNoYXIgKiloZHIgLSBzaXpl
b2Yoc3RydWN0DQo+ID4gPiB1ZHBoZHIpKTsNCj4gPiA+ICsgICAgICAgICAgIGJyZWFrOw0KPiA+
ID4gKyAgIGRlZmF1bHQ6DQo+ID4gPiArICAgICAgICAgICByZXR1cm47DQo+ID4gPiArICAgfQ0K
PiA+ID4gKw0KPiA+ID4gKyAgIC8qIHVwZGF0ZSBjaGVja3N1bSAqLw0KPiA+ID4gKyAgIHVoZHIt
PmNoZWNrID0gY3N1bV9mb2xkKHB0cF9jaGVja19kaWZmOChjb3JyZWN0aW9uX29sZCwNCj4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGRyLT5jb3JyZWN0
aW9uLA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB+
Y3N1bV91bmZvbGQodWhkci0NCj4gPiA+ID5jaGVjaykpKTsNCj4gPiA+ICsgICBpZiAoIXVoZHIt
PmNoZWNrKQ0KPiA+ID4gKyAgICAgICAgICAgdWhkci0+Y2hlY2sgPSBDU1VNX01BTkdMRURfMDsN
Cj4gPiANCj4gPiBBRkFJQ1MgdGhlIGFib3ZlIHdvcmtzIHVuZGVyIHRoZSBhc3N1bXB0aW9uIHRo
YXQgc2tiLT5pcF9zdW1tZWQgIT0NCj4gPiBDSEVDS1NVTV9DT01QTEVURSwgYW5kIHN1Y2ggYXNz
dW1wdGlvbiBpcyB0cnVlIGZvciB0aGUgZXhpc3RpbmcgRFNBDQo+ID4gZGV2aWNlcy4NCj4gPiAN
Cj4gPiBTdGlsbCB0aGUgbmV3IGhlbHBlciBpcyBhIGdlbmVyaWMgb25lLCBzbyBwZXJoYXBzIGl0
IHNob3VsZCB0YWtlDQo+ID4gY2FyZQ0KPiA+IG9mIENIRUNLU1VNX0NPTVBMRVRFLCB0b28/IE9y
IGF0IGxlYXN0IGFkZCBhIGJpZyBmYXQgd2FybmluZyBpbiB0aGUNCj4gPiBoZWxwZXIgZG9jdW1l
bnRhdGlvbiBhbmQvb3IgYSB3YXJuX29uX29uY2UoQ0hFQ0tTVU1fQ09NUExFVEUpLg0KPiANCj4g
SSBzZWUgdGhpcyBoZWxwZXIgaXMgdXNlZCBsYXRlciBldmVuIGluIHRoZSB0eCBwYXRoLCBzbyBl
dmVuIHBhY2tldA0KPiB3aXRoIGlwX3N1bW1lZCA9PSBDSEVDS1NVTV9QQVJUSUFMIGNvdWxkIHJl
YWNoIGhlcmUgYW5kIHNob3VsZCBiZQ0KPiBhY2NvbW9kYXRlZCBhY2NvcmRpbmdseS4NCg0KRG8g
SSBuZWVkIHRvIHVwZGF0ZSB0aGUgY2hlY2tzdW0gb25seSBpZiBpcF9zdW0gaXMgbm90IGVxdWFs
IHRvDQpDSEVDS1NVTV9DT01QTEVURSBvciBDSEVDS1NVTV9QQVJUSUFMLg0KDQppZiAoIHNrYi0+
aXBfc3VtbWVkID09IENIRUNLU1VNX0NPTVBMRVRFIHx8DQogICAgIHNrYi0+aXBfc3VtbWVkID09
IENIRUNLU1VNX1BBUlRJQUwpIHsNCgl3YXJuX29uX29uY2UoMSk7DQoJcmV0dXJuOw0KfQ0KDQpL
aW5kbHkgc3VnZ2VzdC4NCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gUGFvbG8NCj4gDQo+IA0K
