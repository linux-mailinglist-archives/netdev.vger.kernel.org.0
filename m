Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B456D66FF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbjDDPQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjDDPQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:16:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98F526A4;
        Tue,  4 Apr 2023 08:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680621411; x=1712157411;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kQxMJ+z5tQ2vPtwMXbKVw86WUdgetqNqn5ZS5wP9tlk=;
  b=VfhptEHJGqbOI/TPtl7AeSjf9xa1CQERORlz2o6SGoFn8UnDgr+DG0dD
   EooTzqoMjEzw7vd+0hd+c2p9Ly9/wcf2pmS+JPXy4cBvad7kPjBJT7O/w
   vwA+zCLfjgZmt1YSm60a+DtUZQamLSHyInAOCSp1mYh5I1REdkYOFihf4
   FWfb7Zhz1Tte/fzU5mBuG1XLAh6V7gi2jbTRopSRGLQBAM32QOvc7DPwE
   U/Gsg059agA37hwWpD/xiaotDHHDss/hiLBTWsMjDJyHcaHU2NfvOjifv
   UaaZFjDSdsfPDouy+Bs75Z+VlaE8F7TIthQpGjo9eJE5xxv7xbSWGaF9P
   g==;
X-IronPort-AV: E=Sophos;i="5.98,318,1673938800"; 
   d="scan'208";a="145456532"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 08:15:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 08:15:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 4 Apr 2023 08:15:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0ANawKL5Z2cubDrvuK5WXoyTOv3XgvlAXnBPIZXKhmORDjOQajmhUrF02Vi/abjCCe22WkLhMDF9X1Mi1/U5I9N+gJjoG/Ido7qsCjp1pa+xwUQ6mGolo7o3Ob/oWout+Jiu6bXtl+2iXR3ily5RMMbYz5rr7CNcts5DseVv0xypE3U5PLumIy3aId2NzeHJXgj4IQtkLz0+WEla5uui73FidZf/Dfn6TdBksmb+ILZEkhwHFA2c87eFQ2MZMMGApXBx4+Q4Yv/5ytz388GbuCarM18PG7Rx/2R0w3nFHIQWTy87y1znIl/PpxR2KW2lb/Et46mxlx0tZktex/v6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQxMJ+z5tQ2vPtwMXbKVw86WUdgetqNqn5ZS5wP9tlk=;
 b=Z1seBX9lcc+5reLROw+C8YT5RThYUyfIE7XTNHg9/Snrt5zm9TcrwKxViXFi13OL8LqzmBry2nB77tbcrom+gpOx5xi4saWhKXqE9InZGZPNrWJUy+tcTjWdCuEY2BsvOV6pvg1K1n3j8ka4cOxc7KEeNnqmLHexvQshJhNjX4hAlUUrPcwIYJ7rhuZvBjkXbqV83PW1DVo9xjeZGt64BBwf0gn4whS45t/LpPT5eIC+YgcWCdMQWIP4sOBPFx020SMM1MhuKij8oDgGXPVEcWa2Zw3z90lbxSbFeCixtYYPowPW4PLlIVdaYmJVFncka1iUTOV0RdRZkjsKGe+gOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQxMJ+z5tQ2vPtwMXbKVw86WUdgetqNqn5ZS5wP9tlk=;
 b=BnnpFmZah8HSahzvFLRuDh3B2Ez1LwSKB+WLLzt+4KBjys+87eX1+/WjYuMpd1d+rMisB5aRwE/oaor9uUF6bEQPg/HK2ajWaD1E/dPid7gdBxm70LgWAc2LSB1aapv6M72iOhm1bYlbk6o1Gd9Akd2uts+guakB8Mqh7xRyTJw=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DS0PR11MB7481.namprd11.prod.outlook.com (2603:10b6:8:14b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.33; Tue, 4 Apr 2023 15:15:38 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::5fe7:4572:62d7:a88]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::5fe7:4572:62d7:a88%6]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:15:38 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v1 7/7] net: dsa: microchip: Utilize error values
 in ksz8_w_sta_mac_table()
Thread-Topic: [PATCH net-next v1 7/7] net: dsa: microchip: Utilize error
 values in ksz8_w_sta_mac_table()
Thread-Index: AQHZZt8DUU/mMtwyiESfi9+AIwzqDa8bQt8A
Date:   Tue, 4 Apr 2023 15:15:38 +0000
Message-ID: <273f132d1c07b0f84c05712086e68c9abb889ab5.camel@microchip.com>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
         <20230404101842.1382986-8-o.rempel@pengutronix.de>
In-Reply-To: <20230404101842.1382986-8-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DS0PR11MB7481:EE_
x-ms-office365-filtering-correlation-id: 5b4effcd-4e68-4105-87e8-08db351f7252
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wo5XUW6vzm2xsmsr61k1BVIfDhxkKdu/8XNjFwzhW6MgLTQV8lQuO5Vlm4TwRBg58j7Z/F6f0ki9f45CsGuvBBm1VRnOzDV8S/w4YGFOawALrlLSHAs1/xIY8Id9idxUa88l0PArhaVsQnFZdYosbmRLFZcLe67fo2B0KPG7vBBvJKVGGZZDrLpIsMi3NYKYwc78+7PYA/aaBztBmLhj1km8dmN/nmRoAqKG1oVKBTrvIVlbQbGiNDQycPnEDP4ezRClHQoppzU8tSV2DcIbG9IhTXpTbF8IUKMVCqtXK5lYXujpa58wK15pf6A1SJ3dNgDk/kQSZ05nKvkv4S3gbqO0eq9W1EPcj/vX7X8JUIjlSN4chn52MM6Zvn2K4hXQ6G9XIgwSeAkuDaSNbx2nL05tKiE7r9QpPDEKU4X6JJK7g+V9/F4NzdVNbj8BisZ3m6g5yhuy7VYU1kCmtktPtu14iDOyGF65gBP5YqB462K1SADQ8mkVzY6RouKyPQT/zwRHe0wFGGXLlIFwHVDyvvGhHzWNix0thImhRsR2YtF78XSqGmqeU6hZrMsfPCFg8xm14fhYO6YJNADMqJUwE2+qGG1x+EiT1AO2KFJcfsWDQxRRzCqsMajHgZrCp+hmW09TxEvJpQGDKXi/Txdtzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199021)(2906002)(38070700005)(36756003)(86362001)(6486002)(2616005)(71200400001)(186003)(83380400001)(6512007)(6506007)(66476007)(91956017)(66946007)(76116006)(8676002)(66446008)(64756008)(66556008)(41300700001)(5660300002)(110136005)(122000001)(7416002)(38100700002)(54906003)(478600001)(316002)(8936002)(4326008)(4744005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tlo0TzhMemxsemZ2czZDMy9ob1RzU08wcWo5dm5yQjMxNUN3M2NWM2NlbGFy?=
 =?utf-8?B?enBEb0ZrWmljalFleHFWWisvekhxMENjSGJ0MWY3NGo5a3ZPdE9aWXBoWmtS?=
 =?utf-8?B?elFQVlJKS2VrRnd0cW1NV1pkVFRwTmd1cHg5YWREam0yZittTitxdm5jaXBs?=
 =?utf-8?B?akRXKzBTa3Vjck9WWnA4SzUrSjRvWGlTdTRVWnpmRVpRNDRJL1Q2WWdlTkN2?=
 =?utf-8?B?cERSdGFHQkNSTngzRzlHcTRISzNNNjRiblN0Vlk4dVQxTmhYcG1DZkxYTjZt?=
 =?utf-8?B?RmNHamxpcjlDaTN5RTFmRTQ0azVVeXkxUmhuWjl3ZDVjajQvR3FzZkpaMGVU?=
 =?utf-8?B?MTQzMklZUTRyR3Bsa0NxbHFWR2Q0d1M1VHBBN2NLU0xUamN5OTRHbnBmSXkr?=
 =?utf-8?B?S3owWmkrWnhmdXZ2WUR6WC9kY3J2UUN3Z1N4c01yR1I1eGZmZEFKdTVFbUlq?=
 =?utf-8?B?bFdla2VYQ3cxc09ZdzY5eGxhaTNzZ2tLcHR1RmtSZFNkR2txcFdOb1JiKzFo?=
 =?utf-8?B?aDVDdy8yMkZEVzI5ZFlEUThJWnJCbUYyY1VnSXBuQWsyWFF5NGtaRFd2Uk5R?=
 =?utf-8?B?aTBjQS8wNXkrWVRtLzJYMFpZS05tejg3bjJRcHN2QTJOb211VWpvanh1eGIx?=
 =?utf-8?B?OERTQ29Yd1d6Y0llSThoU3RwZStEZWVDUjlhMlMwYndsRFJaTkI3NENmTWxx?=
 =?utf-8?B?R044WlZJY2xMQWs2UlAyL1NvYjAwcDZVSGZrMTFNY2Q4Z01XcGRuV2xuaGty?=
 =?utf-8?B?S05rWE1lMjZuNDN3bGpzVW8rQ2pHVVNxakhKUkpGTGNrUDdndkZ1U2ZuRU9X?=
 =?utf-8?B?a3pldG9PVlFPTEZQK2FIZnBtcnpLZWgvTVMvWHhnbXBMQW04b2hYenZTU2tx?=
 =?utf-8?B?bk56azhUN3EwYXVJbi9XNkphMmhrbU8rdUU4bGFZVDlpZHBYeGRqNHQ5TEhZ?=
 =?utf-8?B?Mkg0VXRQNEtIWXZyQ2MwdWdzNENCNm9HbElTWlEwMW1yUmQvc2p5SnhKeHU5?=
 =?utf-8?B?VktaWURYYVJ3djBkSHlzdi9IVUtQNmtNRnRwVVBIcmJPMUg2L05icjBiaGFN?=
 =?utf-8?B?REo0cEhSYndYTGVMbmQwTUl2cEVhaTk4MG1WTUtXMXZRbWtlbXBtTVRGcDh0?=
 =?utf-8?B?RGhkemtiM0ZURGdieUxydGxGUldFOGxKaXFhc0tCWVhEV0svUVcvS1VxZ2Vz?=
 =?utf-8?B?S3NmRms5YkJ2am40eG9seWw1aWNaNitJelVvMkhHd21xNWx3TmJ3WFJkSzRL?=
 =?utf-8?B?SmxlSUNVN0hEZGptbGNiRnc3TDU3MXdLR3l6cHRZUjM0UzFWR2JQTitpa2Ny?=
 =?utf-8?B?N3BWd3NOam1FSG1keVhvUnNLTmt1ZEJCakRxcnUxcFljejdaUDBjYStEZERm?=
 =?utf-8?B?dlJ4YzlZQzQyVGl0cmZzcWZpS2p1aVo3cklSYnJRR2VWVHpCOGp6dGdDK1FT?=
 =?utf-8?B?MndJQ1NFUUxTWTJ2QTZURm5JdjlkMkhSWXRYMGFhZnc4VWFnNUU0Y3NNTXo3?=
 =?utf-8?B?aWI2OTRIMTlyUEhSYUlPam5FTU5xSW5BQW03MjRNVldZQkZid3Ivd2J3Ri9z?=
 =?utf-8?B?NngrMWduZjRFR2E2aU41SlVwWndhMTdKZTVpWUVzSHZ3KzVBY3U1UnFsc0Zy?=
 =?utf-8?B?eHBSUjZyYTFmN2FscWN4ZkNnZEp5QXREdTlNWUxYU3pLUUNrN1ZxVEV3bEpV?=
 =?utf-8?B?aWlCaGhRbkRncGFJTDR4QTkzQkUrQnFtTVNnc256UG1FVmdyQWdwL29LZ1l5?=
 =?utf-8?B?RE1FK21LeHgraTZsZjFxbzNIOG5BZFBqRXJmMzBEWVFnd1l4L0xRdkFZVEhS?=
 =?utf-8?B?VXRqM0lUSGZwVVUwSmFVLzB4YW9TSG95YUZxS3hyZ0NCNmY5ZjgyejA3Njdv?=
 =?utf-8?B?azY5MGhIMDFvc2I2YXRaUW5rSEtjZFF2bGdzS0lFVml5QU1XMjgvckM0UDVH?=
 =?utf-8?B?OUlhbmp5cFA5Uk11UUYzOWp3aFpLNzJsTnUzbkM4dTRtVzdYMHIxb2RsUGt2?=
 =?utf-8?B?Y3BhbWlGaGQxQkk3WWZMbEpyM0tuR21ESGd0ZGdmaW9iTkhXRjBsVXI5cTR3?=
 =?utf-8?B?U2FabXpOeUYzTjF3Z09IcmU4WC9FaGF3YnBOWmVzTlpBYmd0WjgxUFN4Y2Zm?=
 =?utf-8?B?TU9URGhDVlYyZDdjcmxYVDZ4dmFpZjA4R1lPOWpEZHBjaHBUMmtNU2JkVjlX?=
 =?utf-8?B?Skl5a1pVd2pXRGpZdXNxMTBOdlhkYmVqcUJ4ZmprK0hEUkdtODJZUUlWV0FK?=
 =?utf-8?B?UFBEUjllUzA3em9jSzBBVkNhQVlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7674366172ECBF4BB794148EBE6F6998@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4effcd-4e68-4105-87e8-08db351f7252
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 15:15:38.1188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 837SLz4Fm7dsO3gNdWO8U5x1BYUM345N6SJY9WjcByr22CPnYBp192p2LlFQFP1/twccbtC8vZr3NWQOlXuUHN9dfEH1gjbAwJbTl1uPUIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7481
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gVHVlLCAyMDIzLTA0LTA0IGF0IDEyOjE4ICswMjAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBUbyBoYW5kbGUgcG90ZW50aWFsIHJlYWQvd3JpdGUgb3BlcmF0aW9uIGZhaWx1cmVzLCB1
cGRhdGUNCj4ga3N6OF93X3N0YV9tYWNfdGFibGUoKSB0byBtYWtlIHVzZSBvZiB0aGUgcmV0dXJu
IHZhbHVlcyBwcm92aWRlZCBieQ0KPiByZWFkL3dyaXRlIGZ1bmN0aW9ucy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCg0KQWNr
ZWQtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCg0K
