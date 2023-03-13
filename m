Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC476B6F9B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjCMGsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCMGsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:48:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ECF498B9;
        Sun, 12 Mar 2023 23:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678690130; x=1710226130;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xvFmI27vXDCwH3w1fI2ZI0ZO+tNTuIiSdJooB6swXfM=;
  b=MTVMNCQIjelqNgRgHH2LpNc83dFcf3NAQm1ScI61gf+akAqaFjyVdaNI
   10IUz+m5ltcEn37zqTRhOITO13oy7exx0JvWkRemeSQ+3HNRhUlTActxk
   PrmNiIlRGD4SKv5X5MfQi5KC6Vo/u6hgMahZ4wkW+7oWNijx2HsI3UV+t
   HQJxO8C5eXf0drWJbtVxraGtAKFb6R9U5p1pikU4OToiaVHxHMmypL163
   yX1ULdcCcRr71onlLLAtu6rjIa0OI0ill9oLGbR31XWEuhYpD7DHXHQur
   CZdPdDdbMX+W5ajtxWuJFIifusWMjhEyHk3dD7swETPWp/Kn48jxjcbtu
   A==;
X-IronPort-AV: E=Sophos;i="5.98,256,1673938800"; 
   d="scan'208";a="141680559"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2023 23:48:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 23:48:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 23:48:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dw5W7R299toddyjDghfUamfo4ds0+7fYLxmyZTTTFwDlFLQKAeskC/KVXMJ1+b+F1VKha9fqGE4mO0/FN1XhsZ0uZIrYLNMDWkwFhpHfjKBP2jvSEhENyDUkgGi95ymIQ+J12Or5M47MTAOrZOJZgIB60V8GZlczFEkFbPXTmyCzRNJBqiXfUpD9iRmAJKQk1WBTBOPHsteKN5Tim9/iKng1IKsbhXgLZQghKkZTvNboTTi6JkrHnf4nQwfF8jAM/CmupNdO8eKJwNHm/125YfqQkp/xjXINcxv6v1ii7u5o/Fud09sU/8cws4q97n2pIPZj7vdTVqpmjDb8ldlufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvFmI27vXDCwH3w1fI2ZI0ZO+tNTuIiSdJooB6swXfM=;
 b=aLOzGeTOzC6ekohTudy96TcVrb4ydgqPRiM4g3fC9ZWpEqync+9glP6fve9WbET9Iy22QM2fQEF4HOQyF6rjRLiLCIdub+cA2MCIytLI0/75pZFWXz+fGo7PwRz4RHs+pcus3w84EWcK4ZAuObHsQjLaJrRAE7m3vyQSGu7fEwTRtYUHTyRAvQW9OZE4N3Nfq3nVyxqOFwQNbOmfHUy+F2MxgN1/LD9wSjH6OCTwKX6h1xzzhn3pdSIRvLPlOYHR8rmMaYOf0dNf5JHBZm9Dm6OcDRhLVpzwiRwFfNHYFlc4ApW9Qt6uvuFccVEn3sHS6lakRclpOEmuyCPOTzdIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvFmI27vXDCwH3w1fI2ZI0ZO+tNTuIiSdJooB6swXfM=;
 b=b+WjtyHfWmnvlLLF2IkYB+WEVeBLVZrGU/7mLZ38l6LjmOBGE6E0OgOsZ1cUMhoIoho/fHJx8lZWJG3o53MWXd8/WwKaKI26f+KCe8ug6S3rgu6KcCZXCngatmb/7usn7//pLk1bltOPX2+0Fu/qUoAUSRiqLvmUYTHcMaupbz8=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB6382.namprd11.prod.outlook.com (2603:10b6:8:be::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 06:48:47 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.025; Mon, 13 Mar 2023
 06:48:47 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 0/2] net: dsa: microchip: tc-ets support
Thread-Topic: [PATCH net-next v2 0/2] net: dsa: microchip: tc-ets support
Thread-Index: AQHZUy/9vNSsSyjqBkq0aCWMN2BQdK74SVuA
Date:   Mon, 13 Mar 2023 06:48:47 +0000
Message-ID: <4c6b2f429d4e0a22d22146ec635574b110e0e5c7.camel@microchip.com>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
In-Reply-To: <20230310090809.220764-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB6382:EE_
x-ms-office365-filtering-correlation-id: dd6c96f5-f7bf-4a77-ec62-08db238efef4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NtZOzNSxo9d8UdRWL06oOutEgH/XeqO/emyoDe+Swmd6BSeO8K18iiDKBJgaA49LLUhRA54dhMn8/1I+VYhWlTv2yE+ixY6T/sokVLDWi2ZbcLSSDHqs1I5AgoEf25kItI4Bkuqv36qXVRtjT84wsWtTkCXv4hErUBZUKEzYvR48ORFd0Jzi5FO759wgjUk8Rg8ksQnpTKPbbpVQa8snIFNW3GgKkzcAZCg6FN4jUhuSkopJi4LfBoADOvO9OQW2Lhpvg61yrTnI7W1ucz9hypZvZLza4J3LkcKTG6lNEeUfQJITN32V88CSfIV6b6TIp7bxqpufUMGFTbmzGy0u7UgWE5lZ52cyz7Qf4EvPCOKJhboeruCjHFPgInqZ4DTSw9ZUHdVkN+S2m06mJ4/9/3RVWIf2UvHFtzgPM5fu3b361Vqs4YrABYROLh6Pc2CvCszzDsQpB9Lcm+hKlNBILV0Uv/F265u1RAaeRMpunudlUIhD8KszPGjHQX4s/1RZRlcgekdDUryncQC+uRYANj5m6JIpWlAGzbSTFTdr7iqdBjTjrxI9IIWsd+Xl0xWJQK+ED1l7Xwp0zmAlHqAQfN7HpEBKKkcXaI9zS8C4h54rLXvEv48eT8b9aZimEhKDxEDYskVG3jJZG6CxqUina9D2e1vlMCNO0q2USlysyyUDMUa6QxVGEyaA316QQjc1PN9F2WXFRynY5ifDnriVHO0e/o/9lxVjpFGbGowtA7Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199018)(8936002)(54906003)(91956017)(110136005)(41300700001)(478600001)(66446008)(4326008)(64756008)(8676002)(66946007)(66556008)(66476007)(76116006)(36756003)(38070700005)(86362001)(122000001)(38100700002)(6512007)(26005)(6486002)(71200400001)(186003)(7416002)(5660300002)(4744005)(2906002)(316002)(6506007)(83380400001)(2616005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVRyK0VFWDZBZ2dpN1dBQ01qMTlacFZwZ29XQUN1Q3lZNjVLaFFNc1hUSktD?=
 =?utf-8?B?Q3ljOUpkcU95ZFBKcVU5NDhpYTdzNUpXWmRDcHJqclBCYWtud2M0Ylk2LzBW?=
 =?utf-8?B?YUpqVm5JeTlVcHlFMU9sdzVDWFBuazFlNmJJcGRYOW1wZzZNZEFTKytOdHd3?=
 =?utf-8?B?RDFNamNsc0RRbnJ3TWYrUW9KcjdFM0U4SkZiblE3TUdtV3pEczZCUXV6Q2R6?=
 =?utf-8?B?b0pJZm9LcTZGbTZrVUtlRjBoVzVCWTZwOWUyRURBelhvNDA1YUw3UUg1dlN5?=
 =?utf-8?B?S1cwWVlQV1hRbTN2emd5ZFBsczRzNjJZc2ZjNTFua21kOU8yWlMxTFVnYTV4?=
 =?utf-8?B?eko4NkVTRFd4UzZxL1R0NXNkR3QxL2J3Mnl3SXdKcjloVG9UL2dXc2J1QU1X?=
 =?utf-8?B?WjY4S2ZrVzY0RVRVRkF3YmJ1Z1RNREI1NFpTeTNtdTBnVUJoRysxKzNpbldR?=
 =?utf-8?B?L1dkbTlYTDFPcGxBb0srWlJMcGU3UWcyZnorbDZKY1dCbXlEUTVUaUdJNVZY?=
 =?utf-8?B?TnBSQ0VDSWpyeWswTE1BM0pTVHZKUnpTRnJLTXhicFBRbUZZQWljcXFtVHJH?=
 =?utf-8?B?bDNlTXdFaVpROUwrTkVYKzZ4TVlZNktIZXd6VUZybWpmeXRQcldyd3o1SnJC?=
 =?utf-8?B?Q25KaTBlOXcrZmpkWFlsSHJrajJaZTRCd3Y5VlB0RUZ2SmdKVmx4QUVuTFFW?=
 =?utf-8?B?WncrUTVqblBSVFBIMkVXdUhIeFM4OVNsNzNZZXN3WWRYWUNpSTJ6VEtST0Rs?=
 =?utf-8?B?TjNpVmNBRC8zazJVN2FhZStWQVFzRVZtVklyVUFhcFlpSHhmU0ZHaEhUVkxG?=
 =?utf-8?B?cWxMNjlBamtMejhUOUpETGFhMitST0ZkVDZCREZVcE41bWVmemFLNDI2dXA0?=
 =?utf-8?B?MlVORm90NURneXNjOWU1eFl6UFgxdms2dkU4T3gxaURMMVdRK0xON0swMXdM?=
 =?utf-8?B?TnpTamMzZnA3SGR4K0xhOEVDSW44M2NJRFhTMjRCdWFzR003WnZ1SGZiYW1z?=
 =?utf-8?B?YmxqeGpWQWtNUnV3K21Xc2JueDlYRFR5NzFQQjZLbXdRSW5RMnJEN0RiUXR6?=
 =?utf-8?B?bVR4QXlOVnZaaDljY2JlSVZncVpGaW8xNHgxT1djWk0zSHhNclFScDJYZ1g2?=
 =?utf-8?B?TG8xTkduS0pBNDFCdUwzUWVybnB5OFVNd0hqY3ZiUk5JT2xheUh3Z3pyUTVU?=
 =?utf-8?B?NlNHQ3ZPeEI5OC9jSE55TFZVR2FkUUhHcmEzY3RDNFpUNWg1Z0N5WEU1Z1lJ?=
 =?utf-8?B?U2FScHRRejRnVXN5V1MxK2lkRDFHdEhGWHQvTGpSdTRLSWNwVERST3F2dk1H?=
 =?utf-8?B?WU80N1YwaTljaUF3QlZqY2RXeWhuVWlQcXVJYTFiZ3hUMEd1Nm5NanR5elhU?=
 =?utf-8?B?YUZscFZEdWtwVDNDY1lNdVFJOEdHUTVvYllNOHhtaytQdmZKNm93NmRySy92?=
 =?utf-8?B?Ymw0ZS9YcWZGLzU5UThyT2hzVnNTK1BlalNZOFZEMTlSdHlZWHlKMWxWUnU1?=
 =?utf-8?B?U1lxbGJRMUtwVDJjVmRWMEhWNEQ4QWFpK1puUVRTeTZaT0hIN1g4UmtCVkZL?=
 =?utf-8?B?eHQydVhFdm8zK2xPSWlkSC9Mb1gyaVVtTnJsVUZqWnkxUndJMkh3cHhPaFJz?=
 =?utf-8?B?dlBCTmtBdXZrcllNT2FQT1h2M09qMkY2UnB6TC9NVzNZdDg5OHBGT1NiTkIr?=
 =?utf-8?B?S0hhYWV2N3V1ODRpL2tHNXBSSGdWRG45WVQrRVVTaUxWWHlYYUdaU3ZOZ0tX?=
 =?utf-8?B?RzNBUjZTM282R25vSDBDSUZTMEs5eW1zZkpxSHZWTDI3elpQTEt0eGhTeGVU?=
 =?utf-8?B?YjBIdGtvRlg0bVRKT2haeGIyNzVNcmkwdldaVm9zanVpVzVybWk0dFZRbUtN?=
 =?utf-8?B?R3FzekxiK1FaY0hLc2xFVFloY0FaTzA5UkRUQ2VHT2RnTWxUQUpMaEd6cUV3?=
 =?utf-8?B?bGZwWFVuVWlkb3BxWEtIRU9Gd2svYTc1TGxhbzZ2T0Zxc1JlQW95Uk0yNXc3?=
 =?utf-8?B?eTBVWGdtQklIbWFHaWs0bWw5MUxpNGhaeDJ5WEFnK1dNTm9VN0lWZXQrTkFi?=
 =?utf-8?B?ZE1DUldOeXR6L2VxSlZXZjZBbk00Ujd1YjZRN213c2RHdUNIeWp6WExUNXRU?=
 =?utf-8?B?TTlVdXV1NWhyK3VmT1hGYys1SzZ3MUNTdHNLcElKbWZCekJVdVR6U0ZDRGxu?=
 =?utf-8?Q?obR5DUamYo6TylXQ40oVNzk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CF2F9DBB69BAF4BAF61FD0021CA3280@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6c96f5-f7bf-4a77-ec62-08db238efef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 06:48:47.2224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEL/R1isuViVWvM/NVhEMbIBW2UEbOIPT+NBGgFRVWD/2ks0lo1J102vFWfvZUgOzn1eqPL09rLuuUoYUudFZa1ltTsHZqZoEjrEfPuud3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6382
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCk9uIEZyaSwgMjAyMy0wMy0xMCBhdCAxMDowOCArMDEwMCwgT2xla3NpaiBS
ZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KDQpD
b3ZlciBsZXR0ZXIgcGF0Y2ggdmVyc2lvbiBpcyBzdGlsbCB2Mi4NCltQQVRDSCBuZXQtbmV4dCB2
Ml0NCg0KPiANCj4gY2hhbmdlcyB2MzoNCj4gLSBhZGQgdGNfZXRzX3N1cHBvcnRlZCB0byBtYXRj
aCBzdXBwb3J0ZWQgZGV2aWNlcw0KPiAtIGR5bmFtaWNhbGx5IHJlZ2VuZXJhdGVkIGRlZmF1bHQg
VEMgdG8gcXVldWUgbWFwLg0KPiAtIGFkZCBBY2tlZC1ieSB0byB0aGUgZmlyc3QgcGF0Y2gNCj4g
DQo+IGNoYW5nZXMgdjI6DQo+IC0gcnVuIGVncmVzcyBsaW1pdCBjb25maWd1cmF0aW9uIG9uIGFs
bCBxdWV1ZSBzZXBhcmF0ZWx5LiBPdGhlcndpc2UNCj4gICBjb25maWd1cmF0aW9uIG1heSBub3Qg
YXBwbHkgY29ycmVjdGx5Lg0KPiANCj4gT2xla3NpaiBSZW1wZWwgKDIpOg0KPiAgIG5ldDogZHNh
OiBtaWNyb2NoaXA6IGFkZCBrc3pfc2V0dXBfdGNfbW9kZSgpIGZ1bmN0aW9uDQo+ICAgbmV0OiBk
c2E6IG1pY3JvY2hpcDogYWRkIEVUUyBRZGlzYyBzdXBwb3J0IGZvciBLU1o5NDc3IHNlcmllcw0K
PiANCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIHwgMjM4DQo+ICsr
KysrKysrKysrKysrKysrKysrKysrKy0NCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6
X2NvbW1vbi5oIHwgIDE4ICstDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDI0NCBpbnNlcnRpb25zKCsp
LCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+IDIuMzAuMg0KPiANCg==
