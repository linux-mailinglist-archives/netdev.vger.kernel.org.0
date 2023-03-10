Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE2E6B3515
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 05:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCJEAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 23:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJEAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 23:00:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49541102B40;
        Thu,  9 Mar 2023 20:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678420841; x=1709956841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T4Zav4jT3qTqs5z6tuWf1lc6hX/bows+x42u/dS/KS8=;
  b=ADLHgnMa9NdV3x/1j+2vgHyqGKz1OJTfZI8TkDWsgBvcd9lm8MfCfzv3
   NAiLlDF1Lfs0g2dEgHrkq9hL9QFKTZdKdmpKg/rEB6a9xJe6rK5H/6Y1/
   hZJv5cdG90/ysVq/+68kq/DidImnJmO8cJ/6YFzFQw/detnkOeGvUaGY6
   ylgMHTnGIayTY3b21wLPtmxP9U+J8avYU8vZRgcEOIjT/hZixKMj57Eyc
   4ERm65QoY7TJQ+BTxhBYy0FcZp/rH1hE7aq/xib0ylaOef004yJHADkiO
   5i+nUYC9eQlFUVoZPFcY6KA3j+cx6GvaoLEVQwvW24uQIMB7SWxLKTHY8
   w==;
X-IronPort-AV: E=Sophos;i="5.98,248,1673938800"; 
   d="scan'208";a="215652093"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2023 21:00:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Mar 2023 21:00:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Mar 2023 21:00:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3epGFJBomsr7XeTRNQZvs2Y2F45d01AMiNb/oA1xVTHA60QhepmVbjNyq9eJ1g+Fm5m6rTIYtJYlY5/UasG4+rNoxnnlncf10hDd8Iiv+5cz5G+kROHQzaNTAX+ik3PuMzWIVrOBzaerctlVLu2+IkWFztKwv7DtFAY+V/x+f2+w2aerAlrR2yaMlnEn9kNEP2AAs6drLIhUCKVaLzITxZGEPzx/POQpofKnySsqXk9KQR7UcX9eHEHMfyDV9lq17SXznvW+E7hxVz+SGu1CxOhmNPW0pMNRo40Ulw8uSN0wX7CrVHawnq576gFxej2iq3l8FbOl3ShJJR++08c4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4Zav4jT3qTqs5z6tuWf1lc6hX/bows+x42u/dS/KS8=;
 b=Fkl5WmuHH7mRZVZEZZTWQgfm3rscmaM2WYRZt6CprUyB4YJ7LLtpr4vGFsGDpRfclfHNxXacAZHthsuXtgBA2buDWu1lw9pbGpaQBvKngHCWcbhCCHhF+o/Lyg2o4oHhnhWSVmGzIG4z7DlArfpDf4mpih21cb7QCNGajfU3TmGg2NPSAB4Ggqdb3R+EcEVHn+dch+fKGJ7Gcewtj0rwbrb3hkM7jkXq6EWBs84uckA0+8oRmdUehGk5umJ5AHNUeGkoaNaNa6lUdTLfGozGxtCGW88XXPjO1+9ElNVkL+zb+mFosDa1QWMZnWdQQ2iw2Va/ufFtjrMHJ+S55uscNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4Zav4jT3qTqs5z6tuWf1lc6hX/bows+x42u/dS/KS8=;
 b=FG4jcQQGOkV/Wgwg07/A8Ol/XAbaLWt04UeQpbl13pCJMDNmIOQS3y4eXWkYfkxPqF+sh97urMR91kbQM22g9C6lL3ltw3hFkOnmhPnzR7pGYikOkBYMIBugTT9gqMetdr/srsLuLmEOY3NzN9u0knphCxICcPONLGdaVU9nJJY=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM8PR11MB5639.namprd11.prod.outlook.com (2603:10b6:8:24::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Fri, 10 Mar 2023 04:00:36 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 04:00:36 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: add
 ksz_setup_tc_mode() function
Thread-Topic: [PATCH net-next v2 1/2] net: dsa: microchip: add
 ksz_setup_tc_mode() function
Thread-Index: AQHZUZ5Av0nPPShPFEWlvXywg0UHSq7zZoGA
Date:   Fri, 10 Mar 2023 04:00:36 +0000
Message-ID: <6263ddb2ad1fb38dcde524197b5897676c3ddf8c.camel@microchip.com>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
         <20230308091237.3483895-2-o.rempel@pengutronix.de>
In-Reply-To: <20230308091237.3483895-2-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM8PR11MB5639:EE_
x-ms-office365-filtering-correlation-id: 9283e0cb-17dd-4dd5-5ba5-08db211c012f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /4tMNiw1fQRqv1zXIGI4UPehpHVv4Twj/h2C8jPtenMWQefBpNZgnOYBP3xgexvYYYHd3ZxXtkqna+z9LuvwpuDTF/t0GbxxTPsKW8IzEgbNWX/TWx+35FLvc5VamczXwhr6WdNC4xSuN9IkSmQ2kCWFe4o3APFRgHzjE1ySllO5zmilTW+5XfNXzsuPJkD1VPVbljXvRTDLzL8ok20tXzS/IZBTLgQ8jQM5mgOisS/sWlp0d46VajntTe2GXnPBN596GkmJvTRBNdDR1WctYnwjYLHizsu2cjMZuORlG10qRbFZcVhjE0/aquniaEM1PqyPWSgN94rVjcjgSwaLHQW6WQmBt4PuyRsr5TBPt0Kw8bWoi+pIY7R4I2Zi/O/FxAmi1d6mxMs1H+nhGxpdN0ulfoCpKVSrH8ZC5TU8lunkZeuvM6gplTjcl0Sb3WOyAxLS/CPbOFJ4OUS66DM5Ve90DFD6kGqZzlQE9GzD/oxX0js1kEtg4nSkCMBpFJeqeUuyMSi8zLh6vY2PZVzFlDTPIw4Rf1naa7vPV9iGWLeJ2HmEdvU0sRiUVltRz5wtffW87PNUVVxQqWRcWW5Hypzkg0KMqjEPmISznZla+XqDIZTXVKe2EIywatEFfS7iWerYIamkq1CsNvTVoCoVguIvb7ZGnUyaW6aZ/AOF0Wb8LDEvU20S097S6oD5Yfv75n3bc5Kia84P6cTjrZcwrO0x5JFxSgIzjiVU3LFg7iU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199018)(36756003)(38100700002)(54906003)(110136005)(478600001)(6486002)(5660300002)(41300700001)(316002)(7416002)(71200400001)(122000001)(2906002)(64756008)(66556008)(8936002)(66446008)(66476007)(76116006)(91956017)(66946007)(8676002)(4744005)(4326008)(26005)(38070700005)(86362001)(186003)(2616005)(6512007)(6506007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THY1NVU2UnZDR3N3WWFOakN5ZXQydFBPcmQrK3JpbzFhYzdOVDBOUElLWE91?=
 =?utf-8?B?QjFXM3IxUm9nRFpsdE5TUnlab1BnQy82a29uQm8xZXJVOGUyUlhCclBxZUxq?=
 =?utf-8?B?cUpkY2dXeFFhTEVvUEE0QjFrdXFNNG9leUZtbm1vR2xkdHlKbzF2d2lVYnNp?=
 =?utf-8?B?SzZiZFd1b295cFBnZU5GTmhvWTRGMUNTK0JrSmw5Sk4wcWhOdjduVkVjNUIr?=
 =?utf-8?B?YmhQQWlCM21JSXQ4OUgrU0RlNmVmY0pNWXVsOTdDUEQwNVRFRGZwOFphMEtQ?=
 =?utf-8?B?Qmt0NVNFZ2JMYzlCNFhCdEhFUHBWZDdKcWZhVHhMUWdmZVN4MmE0SmlIcENm?=
 =?utf-8?B?aGQrYXB6YjhrNVdNRTQ5bkYxT0hPSTRRRUVZajBmWU5LUjFiOWRmQVFvQ1Q1?=
 =?utf-8?B?V1JTaDF1Q1c1cm5hOHlqUnhFd0h6cmFZdy9yNUhJSloxRHI1QmVVM3JkR0tW?=
 =?utf-8?B?b2s5TkZMSmpTY21zSFZnZEtqMzZpQlRvYm8xWHEweXlJOSs0UGR2WDJia2Rq?=
 =?utf-8?B?ZWNZL1RPbG91TzN5RUVmTitscHZDeXZVRzFQbWZ0Z25LYlcxNzc3eVQ0SCs0?=
 =?utf-8?B?L2dURXdDcWdQZDZWMk1zbklzcnM3SXZ2Rk1WY0JWK1VKNzFmNS83ZVB3dFVN?=
 =?utf-8?B?MXlaekxvY2JVSFlGcndYWFdkU0pUdGdMdWY5eDJpcFcrMVdBa2hNYUE4VVlQ?=
 =?utf-8?B?T2NmZUxLY2t6bExjZ0hzZDRlWDNLZURwdzBDMHBvNUd1SDExcWVTWlFhMWNt?=
 =?utf-8?B?RFpXaXRJR3VrQmJka3ZibmxNczdiYzVoS2hJTXZRcko5Z1JmN1RUbWxPWmtk?=
 =?utf-8?B?ZEs1R0plWll6eFRmSzZsanFVUmZUNnNYTGxwaVEyNDJOUWNjNEM4ZUExSGE3?=
 =?utf-8?B?RjY2WmhXaDloVWFDZHl5YVppZ0NJNHgyOFJMYzZzNkxFVWZPSU82emNFQ1NX?=
 =?utf-8?B?cStJY1dkS0UxSXpVTVphUFhKK2tST29wbUZ6ZG40M01Gb09KSkVaUnlmVG5Q?=
 =?utf-8?B?eW1NTWo3VnFtNmlYd0IrQ0QyZWdES1NFZ3IrYVVwWFpTdU9QMDZWQzlTZkRZ?=
 =?utf-8?B?Y0dyTHQzTGM4ZEtEWWp0bTlMS2hKVTBCZWxRVnBBYThYYUo5L0hZaVp5UUdY?=
 =?utf-8?B?NHlicWpqQy9JVlR3VUF6RTlYVi8wa0E5bmFnYWExc0tROFN0YWxXOGE3eHhl?=
 =?utf-8?B?MUFVT2c2QnpUOG9peDdYU2xZc0pZVDVTUUFRZkhObzR0Nk5lZTlaVWE0eWI5?=
 =?utf-8?B?bVd4ak9CMUNVaTM5eHhFdnl3OWZ6cWNaOUFGREU1ZjZHTzJqcE8wVmM5aGZJ?=
 =?utf-8?B?RzIzUXVoWUdqYWJBR2ZNYS9lZWs3QUJoYnVuOUgzd3dxTjJIODN0ZzJrWGhI?=
 =?utf-8?B?bGx0QjRlamE1akZlRWF2WVkyVG8rT1dhNHorKytrWlcrMHVQdXN4QjFlc2xP?=
 =?utf-8?B?cm1ZRUwvaTBZNnNWNkwybnV0U0xMS0tEOVduZ1VGVS9qUVBTNkUwOVZxSmVk?=
 =?utf-8?B?UW9aRWlSMHltcUpKK3ptOTZvQWtsM0xmT2YxRGs5Zi84eU1qMVlWYkRHanBU?=
 =?utf-8?B?MXd1cG5sMGRQR1o4TVFwT3VZdzRVWWsxUW1WUytuQlJOdXVEWVNoNkhpQVVp?=
 =?utf-8?B?V2J2Ti9iVWVuRkF3QWxDbXNhczh0MTB4TGorakZMclVYNlNHNnFxZjBBbThM?=
 =?utf-8?B?S1lUZGwycjlVcjVsZE9xTmZZYnpVMDZ5eG5yRkxHKzVKSWt6REFVY0Fqc3or?=
 =?utf-8?B?SmZrczg2MjJzTHN1ZUhvdVVpK2lOL1AxUm1OVXFITDlheGQ2QjF6QVhleGQ0?=
 =?utf-8?B?N2U3Ky95STUycldLQWEyU1pFbWRPZlhEa09UVnJLcG03MkY5ODFwWmg0K2Z6?=
 =?utf-8?B?MjR6STFxdDR3MFBvRWRpWEVJbUxhNFNiekZkYWtDSTU0eEhPZThjYnN6YVVh?=
 =?utf-8?B?SkljblluL2huMGRDYnNQdUYwdmNHUVN1MTNSUERMalJnTHdvU1BzUUhuVWor?=
 =?utf-8?B?ZnhubEg4b0RSaVRwMXFKSzdPd3preG9IVUh5amYvSkVXTTI4b1Y3b3ZTSXd1?=
 =?utf-8?B?QnNZRlprTm1JYnRJSXNEYm5KRDFUUDE1a3E0WXpmajFVREM4blBlUGs1WU9T?=
 =?utf-8?B?NXBUMjNiR3dHSEFvb0xRZWhuTUQxdUZzZVZhZzhZRnJ6bjNGUXZ0c0Vub0s1?=
 =?utf-8?Q?vB8wf0VSMdHWreIkAP7KzEs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <200F26D9D94060459493418932DFEB54@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9283e0cb-17dd-4dd5-5ba5-08db211c012f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 04:00:36.5582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4dlpFJXhjUr9ILiXZMPP6/j1mE8vSg2/m0uiI6DjHz6agwADmepBz3c12MD+U9MywekihckufAswq4fOpm+5zbdNCpftUuBO42zvtCIeJSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5639
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTA4IGF0IDEwOjEyICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBBZGQga3N6X3Nl
dHVwX3RjX21vZGUoKSB0byBtYWtlIHF1ZXVlIHNjaGVkdWxpbmcgYW5kIHNoYXBpbmcNCj4gY29u
ZmlndXJhdGlvbiBtb3JlIHZpc2libGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJl
bXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQoNCkFja2VkLWJ5OiBBcnVuIFJhbWFkb3Nz
IDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20NCg0K
