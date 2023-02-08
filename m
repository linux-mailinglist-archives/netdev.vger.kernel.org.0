Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D63368FA47
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 23:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjBHWeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 17:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjBHWef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 17:34:35 -0500
Received: from BL0PR02CU005-vft-obe.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F8983E6;
        Wed,  8 Feb 2023 14:34:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBq2qcqYnKZhng8A932coGMrET3CwqzkiTYabPKMWu36KiYFews9IF+4kfgJpnxSQrBOyheL+fnf9IEtRwCFgDID0McakFJ10IXmMoo1eWq6wtVJJ/SxQxkGSMEGkj1Ow2JmmR7FaTJofb3n0R6OwtaT0FzL92ui2HWdAEJNRIPyDWZsJbg5DzHNz97MP0aI8yOumv0ZBZdbdRCVnIBOqMmwR88wUuJzvwmvVXVqmgmBROLwPu1HGf5ZuoeikZjh0DGE2/LtV8ju54k1eLSAEi1Auc4Lh/pNHPAbzQB9FLaS8hwKoCl5WwuUzKXutur0tk4LMqkeG1eEmwYrbENrSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwTJFCVIj5zYeHX1vMPh6da7W0p3lnEEvGV+XY+uIHE=;
 b=bvtU2hggQPS062ArKE8xvsEfXmkyg8MGP2M1PVa8a56VxOCEQo6Wkr34q/UAGU91LyqnW7kAGez/4t1nJy3n+UGR4K4cJvsiqB+HjgL2TDCbnJblFZsWNdzGeBNp+dU/r0hVSIvckyRPDoGx3urpSw0yIGFCINkm7PWR2RPd7o5M+EE9Z+u1VWjCqWRfSWFFkbpfrnA4svGP68HRDDPm4oHKrXnME5GMql7x0nQtBr0tT2hlnNm5zmNYdqUYvh0/bgCAxV60A2B7oe3JXih2DyD/NZzWfegbiIQgxX3hjDGrkfCSKLnoDI8UwJXhAhGakxrOcGpPUhWMt42nNfEKKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwTJFCVIj5zYeHX1vMPh6da7W0p3lnEEvGV+XY+uIHE=;
 b=CZdibko8wZOO1XZBWG2NRI4n1ZMs1KMjWmSEnoWYZQMqmsg7Xx4RP0ECOke3IxQpjF+LRYVEHFoSBR9HwZbZs38rPwtWCJYBuysljBQ3BtfFvtAkIt3+lchYnu4VeHWEU/qQQGs6ekTp9N+a4kuySCD+vrd2ruKjo/3qyeCVNZs=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by SN6PR05MB4190.namprd05.prod.outlook.com (2603:10b6:805:1a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Wed, 8 Feb
 2023 22:34:07 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::47cc:2c8:4b7c:6e2e]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::47cc:2c8:4b7c:6e2e%7]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 22:34:06 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Thread-Topic: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Thread-Index: AQHZOypxXNmqDt6CokOhKzm7AYATM67EkkaAgABNNYCAAI6FgP//sHWA
Date:   Wed, 8 Feb 2023 22:34:06 +0000
Message-ID: <9EC94B1F-88E0-418F-AF3B-E68331855877@vmware.com>
References: <20230207192849.2732-1-doshir@vmware.com>
 <20230207221221.52de5c9a@kernel.org>
 <3051468A-19BA-4CF4-AA4F-61ECA561E5F2@vmware.com>
 <20230208111847.5110b2d4@kernel.org>
In-Reply-To: <20230208111847.5110b2d4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.69.23011802
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|SN6PR05MB4190:EE_
x-ms-office365-filtering-correlation-id: 61ad8a2c-e301-4bb9-d148-08db0a249687
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WGhVFt6G+ts2b+Ad2j5kAMHGPI7Bn8DpARJNx18aaPIYYacmtTDVjOXPDXzAggj1cyyrrIzOSKZcKdjN7M6zRtw2J+ZYgYNXyzomiGDjerhYpSlSgQEHjjtOGmzMIXKkCmc9dH4AesSdYbY0EghFNCO0gj+sktlB6COOawGdk6rotIdyYX84LIFYDyUW20+3S82e+dmEO1F1C/4JpnbNosI1I/1jEwfi9zKQinoGkiPHi4mwoCF1pq1RrQ8RINycLjxzWwCrMvLOSFfRtDDOS8sYP8BX2cOXDW/6TYuDOMvp65wqEctL1YQf5SkI3XeT85ggz3T1/Cxf6CytyZbzlSyy1tb2H+sM41R6vQstloCpxVROeFun9xUSPr6pKuSu8xw+12GWKp5tr0YQYR0ZWN7g8o/2xADhzyM4Gvb+L34NLWZOcCm+mBMUn6ll1OCrlREQI+PeJZP6ehJd8Mtyq11PiZZoF10pSWQKNno+0YRFlA64nW02o2jYqhjFSOsXtJPqSzKCTAyI5U8Pe7mus1J9s+8l2UCSPqMU5mTUrtPPbvYr10ApxVa3sgAxQspbExTqUqp1zN8zfLfryLewe3lrDuTIM1dEuT+VbT479drYXV4uR8AuvIrIfNsa7V0A/t0pOzWOiINnwJTE6R0wSXL9VOJXtUqiz09aBvrU2D28izUlYdLHBWSOioBAKaB9KpLydHQiEPVLa4Y9K5t4vihKAVgJlE+BGGKT5gXbAzw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(6486002)(2906002)(478600001)(71200400001)(6506007)(33656002)(186003)(53546011)(6512007)(83380400001)(2616005)(36756003)(8936002)(316002)(4326008)(66946007)(64756008)(86362001)(6916009)(66476007)(66556008)(66446008)(8676002)(41300700001)(76116006)(38100700002)(122000001)(558084003)(54906003)(38070700005)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1k1V2VlWE1DZUtnUzlDMWNSN01pTUYxYjNlakErdytQT3hpNjhzWWhUK09w?=
 =?utf-8?B?OVh4UGJzeFBoM1YwY09MY3FuWGFIWkxzNFlCRDZicjRrZlpnN0xXRzFYaDNG?=
 =?utf-8?B?RzV5VVFQeFg3SFdkZW50d0E2anV1Zk5HNjZnRCs3QUVKQ3JYU3g3VVpzN2wv?=
 =?utf-8?B?a3RQc3gxaDk5bVNIbzdhVzZXQW1VZ2NsN2RycFZnVXRvNFBKcWM4bCt5NVRj?=
 =?utf-8?B?Y0JiN2J5d1J6TXZsaXllYVBQdC9oQlNnWXEyanF6eW9JaUZaR3lUL3Q2UUxT?=
 =?utf-8?B?L1F1dDdZTnA2c3Axb3MrVDdOVE45UUhvSWhrRUN2TTdNZWpla1M2L3VZbng3?=
 =?utf-8?B?d0RHc2IxUU5SQkYzSFdqL3VKSkVWWWF6aU9uUkRKa21RaGg2bzdySHphN043?=
 =?utf-8?B?MTdDYU9RdXpaTkpycVBkK0xkcDA2YW5ldTBmdmY2ckoraHNxWm91SzlERXEr?=
 =?utf-8?B?RFVvU3V6Z056RWE1QlhYZXdFb3hEZ1BidXRmR2pFQitZTG1jWWVaS1BIN0Uw?=
 =?utf-8?B?TVYyRWpUekk0U2xlK0FkNC9oM00vL1dGWlpsSWlWMWtldCtYTjkwV3RzMkdl?=
 =?utf-8?B?Y0lkUHBycUgrSXp5eXZBdnFRTy9senQyZ1BpZ0MzTmNVREpYdTBxQU5uaHls?=
 =?utf-8?B?MnB6c1VYWFBEcFJyWUVibVhXek1tRnVqR1p5OGlTVk1TOFlPZmRLa21yWHV5?=
 =?utf-8?B?TkgvdGpPRGVmemxLUVRsenhBNGl5bjY4ODJScURyN28wTzJ1TlVsM29vSW1J?=
 =?utf-8?B?U2VhQWdndzR4UG5tSHMxZnoxZG1TdjVVa3MyUFpkUm84RE4rSjdPTE1TdlMz?=
 =?utf-8?B?ZkFFU3piTnRWQjdIbWRnTTd3YUJlRFozYzE5aGtITXZuSEVKczRsSG9yakgy?=
 =?utf-8?B?YzlBY2lkRW52djNFRVVJRjUzUjRjTVFzbDc4b3Z0eU8zcFRYVEduSWFzSDFU?=
 =?utf-8?B?Q0wwczJGTGpNZlVrc0dGWUlDTG1FazZBSjZvZDBnNCtGVFB6ZkVkcDBWZDZL?=
 =?utf-8?B?M3lCSlo3NkE0REZ5WC9aV0lDamJEWVh0YkF0S0xmNWpNcFVaVEU1MEYraE5K?=
 =?utf-8?B?Nkh2RlcvdjN2Wk03dkJKUnNBeE9XVkxuK3lIdlNJZ0Y2MEhyS21sbjlpYmkx?=
 =?utf-8?B?Z2lISWxwQ2JiK3B5WDY5QXhLYUhDV0xQMXFNTlB4ZytZaE9pOUQ3cVg2UEU0?=
 =?utf-8?B?aTM5ZjlqY1JrTk9uZ2J3YkpSdTFON0lGa0pHVmhCVmdISUxSTU9SdURNUHR1?=
 =?utf-8?B?NE9sOVArdFhnRS9FZVhtYXBUYkcyRktIeCtObmVvVmlNSitXTzNTakdMUGNE?=
 =?utf-8?B?WnJxNWQ1OVg5VWdGS3B1OXJSeUszTWRBMGdydUdaMnUzenVXajdRVW1WeHkw?=
 =?utf-8?B?eUFFakhPOTFsSDhSUWtaUXZYd3A0NXliYW1ROEdMNlBIZlhBYjVxSEFqMjNH?=
 =?utf-8?B?REd6WG5Vb0ZKejliUDY0dXpGWkRIc2R4WUVLTER0Smg2VTJsaTJYNlBUQmxY?=
 =?utf-8?B?THVMZExqMTVRbVovaXJaZThKUWMrTmI2MjArTXZxMXc2b0hwdDhBVE1JbUxa?=
 =?utf-8?B?c2tHT0RBVVhwSkJpamtMdjA1d2cyTEw1VXVOdlYralV6bU1pSHRTbmREMUVq?=
 =?utf-8?B?SkVpVTkxYUVFQXk4elVIUlV5a2M1blkybHR0OWg5U3c4N1VoYzBORysxem15?=
 =?utf-8?B?dEE0bUUzMnBPWVphSmRSN2lVM0VLS3cyS0crcEl0UW9Pb1ZnRVNEeEo2clpO?=
 =?utf-8?B?dUxqU0Y3Y09NeWN5eC9EQmRNYlFxKzQ3Tjk1WWtIRStHL2NUaWdyWER1OFhq?=
 =?utf-8?B?aUZ4VlVibGxyUS9qQ2h1S0d2c0lYdWJodW45REVoaTVZVmk5L1JoYlpNOTRq?=
 =?utf-8?B?Rm1zRFI2NkQ5WWFmMXpyZzQ5Tmo5Zis4VGtyQTkrMmVEQVBNZkxJL2lEWncw?=
 =?utf-8?B?K0dkMWhidzJoeU5tQmVEQ2cwZzRzbk5VQXBRLzM1MUIvbklOc1VhWFlkTUVt?=
 =?utf-8?B?alhvcngvUmJrRzQ4RDN4NTBMbDFobG5xNXQyeHc4YVkyc2NYUytjVTc0Nkts?=
 =?utf-8?B?MlhPMVNBTlRMb3JlT2tad2Y3NWIrNmJPYkZ0bDNrTEl3ZnJ3a0pScE52Vnl1?=
 =?utf-8?B?K0wraUdzVTQ0QVJOd2JzeHBtdVNmMjNKRTNuRmhZanhnSXNWeFpNdFB6Tmt6?=
 =?utf-8?Q?qJ2U1uBSGSBdRnUx4wDsualkhG+IOu6rGSOq2IwzOS7A?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3E1B2BF6D98184CADF4FDE927F6B027@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ad8a2c-e301-4bb9-d148-08db0a249687
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 22:34:06.3015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQGRM1KZtUeojHq6Lvp7PPSgIbQFJ6ZDazhEy+IsUi9jbg0r3+b8fDIx7jP2qjl4O8H1fHeTQxPalr8BRFgPCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4190
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAyLzgvMjMsIDExOjE4IEFNLCAiSmFrdWIgS2ljaW5za2kiIDxrdWJhQGtlcm5lbC5vcmcg
PG1haWx0bzprdWJhQGtlcm5lbC5vcmc+PiB3cm90ZToNCj4NCj4gQ291bGQgeW91IGFkZCB0byB0
aGUgY29tbWl0IG1lc3NhZ2Ugd2hlbiB1c2VyIHdpbGwgbW9zdCBsaWtlbHkNCj4gZW5jb3VudGVy
IHRoYXQgc2l0dWF0aW9uPyBXaXRoIGhpZ2ggTVRVcz8gRGVwZW5kaW5nIG9uIHRoZQ0KPiB1bmRl
cmx5aW5nIEhXL05JQz8NCg0KU3VyZSwgbGV0IG1lIGFkZCBpdC4NCg0KVGhhbmtzLCANClJvbmFr
IA0KDQoNCg==
