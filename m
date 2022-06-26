Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23F155AFD3
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 09:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiFZHUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 03:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiFZHUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 03:20:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2119.outbound.protection.outlook.com [40.107.243.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3309713D3D
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 00:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPY2VdG58Nkmiy/btuvMXQBADHAJYsWYBlCkgDQEClOqu2djuS9mNQW6DOyWtfzHJ/p+LGHbLBCoaOv4aXNqCZec3IPQrq0LBbfrIzTwG2reiXLduO1NxXM8MnHxvt7cH7s5dp9Qv9NwXCOcLX1Q2BxSoxFh5IfVQ6pKmi7LIrjPEo0ZMXJBWXHwS61AL/pu5px4FvM2pfOiG8NYSg9KfXft97piTVMDSlWlh5etbUXBCmypjJQnpwMRR6OBhJy7Ph0yUTw36F3IB1VDxb63oe/O/k3sJXSOFg2c07PyuQ1ut3SjICfGt6ultj5kOXZhbTd/AgjLRX3FmZ67lfrmNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjBoKBLVMuXbN1y/JF9qyxu2p35QospYTATvh8Bmlr4=;
 b=AECApyI8j2fCTILkq6E4bQRoALaFEdg8563JHZplA6+6zTve7uxReBOKrYqNkuzYs+pMgnEvtuq8Funjf5BUUGC1T3TBYd0uuVGSiXbDMfoLkWi3ug6z8l7g51ku2r24ImYVZHsT24zPtndW9caiKPqdlhjVC9oqv7XZtqbcfGMSWlQ4YcYXViZGcrvxRChY0Te7fNzuiBk8lP7bb72KjrGAsMYw+FCllSrylZewm2Ni/Udbzu2GzHF5JH+TNk2lBoJC9Mw9jNL0t3qkT8grJlyStpuEwhoIcnomYfj8YQ1z5hZLK5CTkK9m1+8n/BNAcMUefJ34IWUF1hrr3RNa5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjBoKBLVMuXbN1y/JF9qyxu2p35QospYTATvh8Bmlr4=;
 b=vspkxO7cPSc1Iu9udBErBKtSkIA7CKX4Y5AN6hEF+MaVeEeapY6O5dLw6nmOxF5Pe8KH7u1YtDwEx8ku44SPlDuucIiOdN8WsomgxZkz7Zt+mIH39v02f9RRvg3hd8HLdBquzELv5TdjTPqzkhY36SWA2lkR4S5ArMjmoqqAQdI=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by MWHPR13MB1439.namprd13.prod.outlook.com (2603:10b6:300:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.11; Sun, 26 Jun
 2022 07:20:18 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::3046:bcc1:9b9a:84fa]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::3046:bcc1:9b9a:84fa%4]) with mapi id 15.20.5373.017; Sun, 26 Jun 2022
 07:20:18 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "elic@nvidia.com" <elic@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "wojciech.drewek@intel.com" <wojciech.drewek@intel.com>
Subject: RE: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYh9BApOLLLi90qE+POmR0pB03/K1hSShg
Date:   Sun, 26 Jun 2022 07:20:18 +0000
Message-ID: <DM5PR1301MB21725B441E51642967C8BB4FE7B69@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220624134134.13605-1-marcin.szycik@linux.intel.com>
 <20220624134134.13605-2-marcin.szycik@linux.intel.com>
In-Reply-To: <20220624134134.13605-2-marcin.szycik@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88a354f5-a59b-44a7-4896-08da574452a0
x-ms-traffictypediagnostic: MWHPR13MB1439:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 05/EN7PkgAwsZao4ZuVh5q9C5m0LPPrCiH0rnfgNGX4kFZCec642OMZ3fUrnJE6zxCro6fXXp8iJguiXugFbIhDEKGFmMMy7sj9x4ryaPLCZ+sPm054Ra8Y4W6/V0oqiKLYy5fDR6MAco2m/Fnf8mypnUipsekYlzkMk+Q10xssrhTp+lubVbSVLByRDUedxNAZMoyGSTw3ytBVwr+uB6ogGaPro/ssYhVZd7i3iQaaUo5J3sBNXeq6+UAR77g5Ax9gOwBednrZoYf3XRyXFZ89xGmPQ/vbP2cmkhnd6q9lG5e7edwXdLkce7ZnvYw4oZKK2z+GFVmfdQW+kF/RL+AvKKiRc5FyYXKhISH0hb9+tMtZDQZNd0DK3uUdDxWhyP9+/w5NaCQnKXGhK1dyflQVVN8ea4/Ul4lm/vnLzY9wLaRpleGo3+ILz2gPiom3BxNYFnBqzB7emMwPDdf/dAoG8W+IxCiFVgwefHqZff9RHHqjyNK0n09ZDMoWbFJZ2xTIonee0z/Fch7ngql6VOTvXA49QvrekFJMCkviMJbm55Hm7UT0TiSV3yNTnSBWWVd2FTtj3GlXxnKrltBR7kX4DCgJVp0GbBvFh5yLVgdnJOj/5FRxKU9Uumgp2URMLCkRWkcIHhc/E1QQHcJomP4yTJWWOMgv54isrzpR59QsrzIlJJCI16iP1eoyD6Ihqe22C2rNhZqs1E0xgrX2I//7Kp1lUQghGK96Qer9VjGGaHThCp1X2LVOd9LPAZdUE2jzkAcMFwXhukpPQoQ3qXNoC9tiQ7lEypWCsHLej3mI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39830400003)(366004)(396003)(136003)(376002)(55016003)(54906003)(71200400001)(38100700002)(44832011)(316002)(478600001)(186003)(7416002)(122000001)(110136005)(53546011)(33656002)(52536014)(38070700005)(5660300002)(8936002)(9686003)(66446008)(66946007)(8676002)(76116006)(64756008)(66476007)(83380400001)(41300700001)(66556008)(86362001)(2906002)(7696005)(26005)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M09uVjJocGprZElockwvbmFpV0U4TTI2QVQweGJQaFRYNlY4UCtpU3FHdGw3?=
 =?utf-8?B?MGlJMVowanlPdVdkZFdpRDhqVE5ZM0N6dnJqS0EzYTUwWENSc0FwMkQ2dHNI?=
 =?utf-8?B?OTdJQW9mdVp6WGY5OERPOWF5R2xnSDAySC9RZDZFSzRoNjVydUpiRi9Ecm5I?=
 =?utf-8?B?T0lpdm9mMG1mejh6disvcVVCQ2ZnaDJSQ1VBeTRhUXdFQVpTdW9tN0ZoWGZL?=
 =?utf-8?B?Qmw3N2tUVk12T2NqY1lucVJsMm9GalJHd016SmE5U3V6dWNDOHhrVFBoVXRv?=
 =?utf-8?B?MXlyUFpEd3BvblR1dUtNeVdxOXJ4d3RlaFdqanZSdFNJUmVEVkRIbnhEdDJm?=
 =?utf-8?B?YTluenNzejl1bldqa3U2NUkvNktIdm16V2ZQWDdnaXN4RnIrVlVLM2pENkxy?=
 =?utf-8?B?OFZqSlQ3UDB3RGtNbmd6ME9BQXF5VTZKb3BRYUhIdmhQakhyZFRIczhDT3p0?=
 =?utf-8?B?VVZocERHRVpRMGoyTU83NGdpZWdkYlJnSHltWE5XVWFlQkJSUWRzYmFnRXB5?=
 =?utf-8?B?TFEzWHhYWlNTVVdYZzlpK0JqcEIyeGxySFFzR1VLaGx1ZmlaSTJpZGJDWFUw?=
 =?utf-8?B?NlBKSHFkNGlVaEYwRUZKR0JsU1VhQUJkZ3FSSlI1UGFoWXdMN2ppQmJuOG05?=
 =?utf-8?B?ZmI1MHY5a2ZGV2hvaU5WN09lZU5OR0lMQ2tQTStKWFpNWjltZDVQMUQxRllp?=
 =?utf-8?B?ZEI3eG5WY3NrUVlBT3o0RlBaellqQWNDYjFndUl1QktvNUNxWVU0YVFVVmhJ?=
 =?utf-8?B?c3BvTlVyd2pXcHlKR2ExcHFQbkx1UzN5Rzc0KzlXdlQ4NWF1OGpqUGJQUU8w?=
 =?utf-8?B?UStSVHVSU3N0SHZCWVBmVkhnelZlcm9nbk1vQ0RFbUI4NElYTWRHeENWNXpq?=
 =?utf-8?B?ZDVuZjRtNTFKQnduWWsvekkyMjFIZVZBK3JRd2pqYXRhbktqMVBOV0JVS2VL?=
 =?utf-8?B?SmVmTTBxSHFjQW0wRnVzUUhvNVVETGhtbVZKOGIxbTc3di94RmhBanJjYlBl?=
 =?utf-8?B?QzhLdUZpMmpBYldVZ001V3YyangwS1U1OWtDREQ3eDd2bmNmbFoyRm5pQldH?=
 =?utf-8?B?YnJrdURLZUN2cEZjcEtVYlRQWUF4aEl6WmxvTUJ6MFlYRmdET0lVQVl2YlR6?=
 =?utf-8?B?Q2lmMUNYVG5zNXV0V2prZzVpb3VvYmxHb0ExY2FFMklqcTVMa0h6cG1POVRB?=
 =?utf-8?B?OFdoZTNmSTBoMFhEdC82M2U5NlI0NXc3STRWZjZoUE9JbHRxc3hTdjZiTFVu?=
 =?utf-8?B?M0NFcVExajZPZy9xUmRWby9HeTFuazhhTzQrb2N1a1RxVVRBVDFpQTg3a1RL?=
 =?utf-8?B?bTRpUndTVTJLcUNlN0VaeUp3cjlyd21NajFERlU2Sk51N2dQYWY1VFpNWWg5?=
 =?utf-8?B?RFRZL0Zzby9BZmZwWHhkUWI2VnZkOEtBeTN0UTJyNitUd0dYd2d6VStQZ01Y?=
 =?utf-8?B?K21ZREV1akZhaytkTklxVEtnYkh6VEN2NTVabFNTWUlHZFV2ZEJsSnZtRjhU?=
 =?utf-8?B?c3hRUE5UT2U0ZDExb0dlZDV3UFFJQnJ5b2VZNlYxQ2t4L0dTUkJWUTBJdWhE?=
 =?utf-8?B?MkExT2thT0JleVY1YzVKM2IvaFdrNGVYRFdFelhpTmgxa1JaeGhWMjZlamhI?=
 =?utf-8?B?Wk45UDNvWUNnSGsyZEcwQllPc3hVQ0NKWDdLQVhLNzdzU3lNUTdkMnJZcjZk?=
 =?utf-8?B?bktkNFdyUVBDNUlzc0NoUTlXRUlwNDVJN08zYndjaGIrazRJR01zN2l1VkVY?=
 =?utf-8?B?eTlFWFlKR1pYTTRQSFNWM29jYlNXdHpqa1RnQmNicWQvWURzQTVMb2psMUVU?=
 =?utf-8?B?MDZxV3Qzc2hwLzlYbCt2NERrNUZNN1JLKzIzRUxnaVBQWXVzOUFRR1ppSEx4?=
 =?utf-8?B?UERvTjNHV0FidjNMdlZhazJkaHkwR3VlRmk1a1crZ1BhNWkwNVJXckhsZnFL?=
 =?utf-8?B?dlNMRVIxR0N3U2RZRndmSGl4bm51YmNCajYxbTFTNXJ2ZjMrYUNIdlNTdlVT?=
 =?utf-8?B?VWlERkNkZGFiZDJ4ZmNKMHorbWJBOVNMYUhma2ZUcXVJb2J4U2tlR2tKNEVx?=
 =?utf-8?B?VjhsT1FxeUVLQi9oanJOOTZwNWtaMkZjMnpTUTNZdkJENTdEckdFdE9TWGYw?=
 =?utf-8?Q?vaGbKYjtAOQobb439SIk62qvf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a354f5-a59b-44a7-4896-08da574452a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2022 07:20:18.1818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s+V+FDH0VmHN2FSKy0QOAD4Pq3sfrl8Uz1W/rXPsj5EEx8l2Pty30BuTXczgfAy0HWtx6kQyQMQ1pK/7BOX0f0LIObTj9s8EnWlAPslz6ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1439
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBKdW5lIDI0LCAyMDIyIDk6NDIgUE0sIE1hcmNpbiBTenljaWsgd3JvdGU6DQoN
Cj5BbGxvdyB0byBkaXNzZWN0IFBQUG9FIHNwZWNpZmljIGZpZWxkcyB3aGljaCBhcmU6DQo+LSBz
ZXNzaW9uIElEICgxNiBiaXRzKQ0KPi0gcHBwIHByb3RvY29sICgxNiBiaXRzKQ0KPg0KPlRoZSBn
b2FsIGlzIHRvIG1ha2UgdGhlIGZvbGxvd2luZyBUQyBjb21tYW5kIHBvc3NpYmxlOg0KPg0KPiAg
IyB0YyBmaWx0ZXIgYWRkIGRldiBlbnM2ZjAgaW5ncmVzcyBwcmlvIDEgcHJvdG9jb2wgcHBwX3Nl
cyBcDQo+ICAgICAgZmxvd2VyIFwNCj4gICAgICAgIHBwcG9lX3NpZCAxMiBcDQo+ICAgICAgICBw
cHBfcHJvdG8gaXAgXA0KPiAgICAgIGFjdGlvbiBkcm9wDQo+DQo+Tm90ZSB0aGF0IG9ubHkgUFBQ
b0UgU2Vzc2lvbiBpcyBzdXBwb3J0ZWQuDQo+DQo+U2lnbmVkLW9mZi1ieTogV29qY2llY2ggRHJl
d2VrIDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29tPg0KPi0tLQ0KPiBpbmNsdWRlL25ldC9mbG93
X2Rpc3NlY3Rvci5oIHwgMTEgKysrKysrKysNCj4gbmV0L2NvcmUvZmxvd19kaXNzZWN0b3IuYyAg
ICB8IDUxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQ0KPiAyIGZpbGVzIGNo
YW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+DQo+ZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbmV0L2Zsb3dfZGlzc2VjdG9yLmggYi9pbmNsdWRlL25ldC9mbG93X2Rpc3NlY3Rv
ci5oIGluZGV4DQo+YTRjNjA1N2M3MDk3Li44ZmY0MGM3YzNmMWMgMTAwNjQ0DQo+LS0tIGEvaW5j
bHVkZS9uZXQvZmxvd19kaXNzZWN0b3IuaA0KPisrKyBiL2luY2x1ZGUvbmV0L2Zsb3dfZGlzc2Vj
dG9yLmgNCj5AQCAtMjYxLDYgKzI2MSwxNiBAQCBzdHJ1Y3QgZmxvd19kaXNzZWN0b3Jfa2V5X251
bV9vZl92bGFucyB7DQo+IAl1OCBudW1fb2ZfdmxhbnM7DQo+IH07DQo+DQpbLi5dDQo+K3N0YXRp
YyBib29sIGlzX3BwcF9wcm90b19zdXBwb3J0ZWQoX19iZTE2IHByb3RvKSB7DQo+Kwlzd2l0Y2gg
KHByb3RvKSB7DQo+KwljYXNlIGh0b25zKFBQUF9BVCk6DQo+KwljYXNlIGh0b25zKFBQUF9JUFgp
Og0KPisJY2FzZSBodG9ucyhQUFBfVkpDX0NPTVApOg0KPisJY2FzZSBodG9ucyhQUFBfVkpDX1VO
Q09NUCk6DQo+KwljYXNlIGh0b25zKFBQUF9NUCk6DQo+KwljYXNlIGh0b25zKFBQUF9DT01QRlJB
Ryk6DQo+KwljYXNlIGh0b25zKFBQUF9DT01QKToNCj4rCWNhc2UgaHRvbnMoUFBQX01QTFNfVUMp
Og0KPisJY2FzZSBodG9ucyhQUFBfTVBMU19NQyk6DQo+KwljYXNlIGh0b25zKFBQUF9JUENQKToN
Cj4rCWNhc2UgaHRvbnMoUFBQX0FUQ1ApOg0KPisJY2FzZSBodG9ucyhQUFBfSVBYQ1ApOg0KPisJ
Y2FzZSBodG9ucyhQUFBfSVBWNkNQKToNCj4rCWNhc2UgaHRvbnMoUFBQX0NDUEZSQUcpOg0KPisJ
Y2FzZSBodG9ucyhQUFBfTVBMU0NQKToNCj4rCWNhc2UgaHRvbnMoUFBQX0xDUCk6DQo+KwljYXNl
IGh0b25zKFBQUF9QQVApOg0KPisJY2FzZSBodG9ucyhQUFBfTFFSKToNCj4rCWNhc2UgaHRvbnMo
UFBQX0NIQVApOg0KPisJY2FzZSBodG9ucyhQUFBfQ0JDUCk6DQo+KwkJcmV0dXJuIHRydWU7DQo+
KwlkZWZhdWx0Og0KPisJCXJldHVybiBmYWxzZTsNCj4rCX0NCj4rfQ0KPisNCkp1c3QgYSBzdWdn
ZXN0aW9uLCBmb3IgdGhlIGFib3ZlIGNvZGUgc2VnbWVudCwgd2lsbCBpdCBiZSBtb3JlIGNsZWFu
IHRvIGNoYW5nZSBhcyB0aGUgZm9ybWF0Og0KCXN3aXRjaCAobnRvaHMocHJvdG8pKSB7DQoJY2Fz
ZSBQUFBfQVQ6DQoJY2FzZSBQUFBfSVBYOg0KCWNhc2UgUFBQX1ZKQ19DT01QOg0KdGhlbiB5b3Ug
d2lsbCBub3QgbmVlZCB0byBjYWxsIGZ1bmN0aW9uIG9mIGh0b25zIHJlcGVhdGVkbHkuDQo+IC8q
Kg0KPiAgKiBfX3NrYl9mbG93X2Rpc3NlY3QgLSBleHRyYWN0IHRoZSBmbG93X2tleXMgc3RydWN0
IGFuZCByZXR1cm4gaXQNCj4gICogQG5ldDogYXNzb2NpYXRlZCBuZXR3b3JrIG5hbWVzcGFjZSwg
ZGVyaXZlZCBmcm9tIEBza2IgaWYgTlVMTCBAQCAtDQo+MTIyMSwxOSArMTI1MCwyOSBAQCBib29s
IF9fc2tiX2Zsb3dfZGlzc2VjdChjb25zdCBzdHJ1Y3QgbmV0ICpuZXQsDQo+IAkJfQ0KPg0KPiAJ
CW5ob2ZmICs9IFBQUE9FX1NFU19ITEVOOw0KPi0JCXN3aXRjaCAoaGRyLT5wcm90bykgew0KPi0J
CWNhc2UgaHRvbnMoUFBQX0lQKToNCj4rCQlpZiAoaGRyLT5wcm90byA9PSBodG9ucyhQUFBfSVAp
KSB7DQo+IAkJCXByb3RvID0gaHRvbnMoRVRIX1BfSVApOw0KPiAJCQlmZHJldCA9IEZMT1dfRElT
U0VDVF9SRVRfUFJPVE9fQUdBSU47DQo+LQkJCWJyZWFrOw0KPi0JCWNhc2UgaHRvbnMoUFBQX0lQ
VjYpOg0KPisJCX0gZWxzZSBpZiAoaGRyLT5wcm90byA9PSBodG9ucyhQUFBfSVBWNikpIHsNCj4g
CQkJcHJvdG8gPSBodG9ucyhFVEhfUF9JUFY2KTsNCj4gCQkJZmRyZXQgPSBGTE9XX0RJU1NFQ1Rf
UkVUX1BST1RPX0FHQUlOOw0KPi0JCQlicmVhazsNCj4tCQlkZWZhdWx0Og0KPisJCX0gZWxzZSBp
ZiAoaXNfcHBwX3Byb3RvX3N1cHBvcnRlZChoZHItPnByb3RvKSkgew0KPisJCQlmZHJldCA9IEZM
T1dfRElTU0VDVF9SRVRfT1VUX0dPT0Q7DQo+KwkJfSBlbHNlIHsNCj4gCQkJZmRyZXQgPSBGTE9X
X0RJU1NFQ1RfUkVUX09VVF9CQUQ7DQo+IAkJCWJyZWFrOw0KPiAJCX0NCj4rDQo+KwkJaWYgKGRp
c3NlY3Rvcl91c2VzX2tleShmbG93X2Rpc3NlY3RvciwNCj4rCQkJCSAgICAgICBGTE9XX0RJU1NF
Q1RPUl9LRVlfUFBQT0UpKSB7DQo+KwkJCXN0cnVjdCBmbG93X2Rpc3NlY3Rvcl9rZXlfcHBwb2Ug
KmtleV9wcHBvZTsNCj4rDQo+KwkJCWtleV9wcHBvZSA9DQo+c2tiX2Zsb3dfZGlzc2VjdG9yX3Rh
cmdldChmbG93X2Rpc3NlY3RvciwNCj4rDQo+RkxPV19ESVNTRUNUT1JfS0VZX1BQUE9FLA0KPisJ
CQkJCQkJICAgICAgdGFyZ2V0X2NvbnRhaW5lcik7DQo+KwkJCWtleV9wcHBvZS0+c2Vzc2lvbl9p
ZCA9IG50b2hzKGhkci0+aGRyLnNpZCk7DQo+KwkJCWtleV9wcHBvZS0+cHBwX3Byb3RvID0gaGRy
LT5wcm90bzsNCj4rCQl9DQo+IAkJYnJlYWs7DQo+IAl9DQo+IAljYXNlIGh0b25zKEVUSF9QX1RJ
UEMpOiB7DQo+LS0NCj4yLjM1LjENCg0K
