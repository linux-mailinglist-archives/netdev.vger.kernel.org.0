Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243716B3145
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCIWuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCIWuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:50:19 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11012000.outbound.protection.outlook.com [52.101.63.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37551E41EE;
        Thu,  9 Mar 2023 14:50:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2eDniy3MbSqnmXcN6RXLOr6aZtdMt7fd8f4cwF4kKwnYIQqNwixG32sWtUPdjmbhKFUgphf/9MtilTHJdJRmwKpVwX6m3noSgZRAErt/+EbawBAFNs2caJOEgGSmpm4BNG9gc6DAolsCGrwsxf5gwFIv/6K116b8F+5oBdKnxyz62IeewmcgBylX+4ZAla5pZnh5qo7Aae4wID16kFL3sIzLZenxGL/vsZ14dKAoC5sj7/m5zNI8vKp7nYXpLNWqBxAUfLvpBTRznX9S0WCyCPBfg772SiAIDTTPzNc890y1Ile6pzRJ7ClboocrbiMtxUE8036a3hylYmrgO8W7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8oHl4jeZl+YaWZAigSaIPeGvFoH+cgpcXzc6ms1FwI=;
 b=Ke0O9PXCTMrX+AfDme4e32bvb2Bx2g2FNM26lvoUfY6VQE+an/5N4UQf7LzYe+LWxncySzzPOz4cJE62goK8tR9qkk/G5PvNyBz8jfybugKAQ5uUuN2QFaZ+YhQqBPRuDN3Tk3tVWDkpgEJzbgCxNONzDrobWbaakigT7Nj0cBSYFgjaYTcyxrivyDidk0wq6mrYHHgD2AXYznzVIQ5o0EQYx7cafV9Ngx7elDnr8axYdwrXekO8cHf3JEZjk7edIIOdDL4+CE5Qy+XHztMsGmt5CldLoVY7v9CXE8P2NoSJOXdYPk2MKNoPdpEu/fKrEYt08jILFGeyRv0Ymdz7HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8oHl4jeZl+YaWZAigSaIPeGvFoH+cgpcXzc6ms1FwI=;
 b=cTWHUA7shnUz+sWeAc7x6mWOdB/IMtKsNlvDnlV7/ZF8qQvmFYDHcSF7xlsYjM+yiH7cPvrmmWA/Q4wSC6C4zUBl2kQ1v1hLDMYwBkcyJtay/YP1mQOwpNEbE3B3Mi3Mpy/g4p8ZJQuGSDtVld6TZiQ2BQNH6tvmjz3vjaelNUk=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by DM6PR05MB5577.namprd05.prod.outlook.com (2603:10b6:5:c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Thu, 9 Mar 2023 22:50:05 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%6]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 22:50:05 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQA=
Date:   Thu, 9 Mar 2023 22:50:04 +0000
Message-ID: <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
In-Reply-To: <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|DM6PR05MB5577:EE_
x-ms-office365-filtering-correlation-id: 0af8c91a-5f5c-4a05-b04b-08db20f09fda
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gNAASmVxjmVSWOGLNw0zTmTYLn1ymM1iatwbKehiYkytmUDF9VCEdAng3zEC39NwcOZYys0MKeeLVnynN/ybtdbT+3SnoeANWeiHU7vcbj6BN12SWNqlGs2J2UY8uAiAeZfo/KuWbVGH1EfWZb8vGeAE50iDPEScsc3NNotzqs9RrqV1l0UAcsnyv34itpXKrEP81xaP7tuTmDiI3ajieDRGE1/1oEIU7p2WBprZUS/GZTuWPPqXgVEgL3S1L78lQQMMT70HWOn+wEc3iwOFH9ieP7oLbVfqik/++3AH57l1PS3A+uBoMarlj4BAzkaDD/WFrGggd9FVEMk4TsS8nFZ7N0PzGjtm22SSJ/nz8PFizd+PtvpcytN0NU74+RQn0BSjD2ZQIjr2R7wwtdToAVjf4bw4uAL1mwjXWr2qIOR7f6QWEGCRB3PGBaLL81u9B3czSHs4F5xJC7R4iouqTt6eMYmZ6t4yBxkD5rIu0yMc4TbHjY3CXWuuAvBn9sXvwOBvX0WyBZMLhqjym3HILJlEhdPT359ZUKlMAuDyVPMlojOdAWpNJCXR/zOBVFfoH/qlN/YPiRbW33SldlzwPE22ITWwpIgNLcM0JxCFUAxUJ7pSmTqpXPCJBk19dx/fedvVtIoBmCQ3b30rAGNwzZX/NwyCzm5xU2UcmHhZnHiNF9FA0HY4zADu9E1shPGwfUrgOUfLBU29ygzgASJbFiorJc/xcbBx+dD6dxblLJQAjBmahFUvvV9Xq0o41yPWbtCPPkYRz4tEhDUPYDtcdSkSk1PWDC11EmucoiCAedA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199018)(110136005)(54906003)(33656002)(36756003)(38100700002)(38070700005)(86362001)(122000001)(26005)(6506007)(6512007)(53546011)(83380400001)(186003)(2616005)(71200400001)(316002)(5660300002)(478600001)(6486002)(4326008)(41300700001)(8936002)(66556008)(2906002)(76116006)(4744005)(66476007)(64756008)(66946007)(8676002)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1g3cUkweWhKUVpldERJM3QvNmxqTjVMNDczUFNFc0lzWVdXZW1EbnpHNFl2?=
 =?utf-8?B?RGpybG5aVk5saW11YkIxbnNKMm0rZDRhMGlLaUg0TkFjWUtLaDBvVWxhcEtX?=
 =?utf-8?B?RGg4UDdUNkVJYzJTWFNYMU9hdFBLRTUvTjdXV3ZaV0xMZ2RlNjF5dmIwdmtP?=
 =?utf-8?B?S0l6K0t4Y3BaeDVLRjRYRUl0STRNYmRWYjVIZ0xrRjlPVzJXQVYzYmdySWZU?=
 =?utf-8?B?SENhcDN2MHE3VkhyNG5IbUdXM2VDYVRqYklwVTQ4VTNteUtlaGkzTHRFYnJF?=
 =?utf-8?B?TVY5bUl4cXdWbndZVWpFaE8vVy92Q2loME5FZXV1M1BVOWh2V2VDVVJ4KzVt?=
 =?utf-8?B?MUxnYmpXeFlTb2VVVytNWVF2Z2pJTUUybktaaDdmL1RRbG1QWmNlbi9NSnZs?=
 =?utf-8?B?MURtR2VXU1kxZVZtbDVKZ2RsRnV3V0lXRkUvZjZxQWdKanZJSWxnODB6S015?=
 =?utf-8?B?T2pZT1Y4U3Yvcm5pQS9UVTFSS3NGS2pIKzQwOEtlaWI1WEZVZ3ZGQXRjTlds?=
 =?utf-8?B?cFZRTHp3Y2lmSHhLVHdrYnZaMXZacUNReEd2a0RqVCt4aDVwVkdaTWN5R1dl?=
 =?utf-8?B?d1QzOXpaRmtWY0RENmZzdjF5a0dNZ0xmREtIazBoL0Z6eHJvRXpOUmtRUXZY?=
 =?utf-8?B?cFFReWlCOXZma0dJdi9yb3J0MlA5RkpHMEZJSEJXK3JnN2NLTjVpZHlscTVv?=
 =?utf-8?B?ZDVVNW52OVZkRzljU0N3L2habjhwWHljdU9yM0xjdkJPSnR3VjBOcEtuY2Iv?=
 =?utf-8?B?U0kvb1dRYTRyRTNxK0xHSEhDWjEwclJ3WEpDSFR6YTk0cW9HdUF1MHBpNGtT?=
 =?utf-8?B?UVo4ajk0L0p4d1ZuZ211dmdjMWVEUjhMWkRqNm9kOVZKYWFCVDFBd1pzU1dX?=
 =?utf-8?B?S3VLUTMxRERLa0M4S1VoQnNqTlVCbFBzN2RMUGdDSkJ3RUFtL0VRVDBJVHB3?=
 =?utf-8?B?UzZoMmxjTVhsQm1adjQ2NXJiM1N1aFg0NDBVbUpVQ2d4TGdmbThCL3c3QVhI?=
 =?utf-8?B?QW5rNGxBL0taQVd0dXJQZzl0YkJ1MUt3TkZVTUFmZ3MrNWV4ZW5FcisyOXNJ?=
 =?utf-8?B?L3Yxa21TQmc4SlNRcm1XUkExOXFWaStMWmV2RnpqTkxNZ2Fac1RKVy9EQmg3?=
 =?utf-8?B?a0JrMTBvYzBtRnRXZVVIRVZIajB2cS82R1hnL1BIRjlFSk5YWnltbU1ZZzh1?=
 =?utf-8?B?TWJuYXhjZW0yaHBHS1ppYndMME5xMUw2dVBYS2ZGcmdldTB3N2NDSm5HRStD?=
 =?utf-8?B?WnFNcUlwWDlHR2x0OXBnS1lHazd1VjliUnBPdmxUdnFBakk1S1p4alJkcE5i?=
 =?utf-8?B?eTNQRHRHZmJKK01SakVja2ZpbVdyakJ6elZZdHF4bExuMmZpaE1JVWpraWN5?=
 =?utf-8?B?U1lyMURWQm8vdmI2bGFLV21GQzQ0Ty9ZQUZvWllCczk3c2xHNDBSUmgzK1Qx?=
 =?utf-8?B?N2c3TTdORDUxa3MyUXhZS0RjUWVLNG1jbVpwbkp2UDZBbGsvaUw4ZWFwR2xC?=
 =?utf-8?B?U0lxNmZySmhXQ2xCSkZPUmpNc2JtUWxQUXc3ZnI4RFRvTllRb3JEV2pJTUxO?=
 =?utf-8?B?MVRuRkdlVjU2azFOTUJGdCthNmk1TUhrMEVKbEQ0NnZvTU5TMi9WYWxmWUlh?=
 =?utf-8?B?Q0JEUWUzT1RydUxBWlA3M3dFWGhnVEF5SHFMM0ZGcDQwUVpLU2FiOWxxUmZB?=
 =?utf-8?B?U2Jnblk5b29qT1NiZWNTdVFGNnpuWWc3bk1US0Q4elNGZlM5MkdkdEhIM0xu?=
 =?utf-8?B?QWpZR3JZOGxBeTUrMmJ4VzFhRWJ0NUJkRDY2MTI0Q0FlaGpoNmpteCtVK3hJ?=
 =?utf-8?B?a0RGaXB1ZHhoTjVUR1JYdHpPZlFCREs4YzhtanBMdHg0cVovK045MVYwWE85?=
 =?utf-8?B?WTlEamlrNDFYSU5QMUFVOU94c3Z4MGZ4Y0ltVW9sTjU5dm5XZXhQVzlpN0NP?=
 =?utf-8?B?V3pZWHFvY0Z1T0c5ZFdFUDZOSkQrTmFKNVRIRWNVSDhOa2dRRDFUVnNmQ2Z5?=
 =?utf-8?B?bnhCT09nMkRCQXM4Skt2aVRLMG53amV5Z1VHME9BMmlETjlXTjgvR3Y2Sk5B?=
 =?utf-8?B?RERqbkdrUnJxUlA4QVVSV3MyU3Z6c2xkR0ZkVGZlMTRCcjNQRkFpa09XS04r?=
 =?utf-8?Q?g6AQE2kJUtBrX+w/ZfAyNOMnt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E397DC141427048A6CF60C0F846D746@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af8c91a-5f5c-4a05-b04b-08db20f09fda
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 22:50:04.9050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zli1Yck03ECsDlGwQzbRVREHFkEda47NN9iblXu4KOTyqDWbkIh7qdsljaC8X3Ki8eZQVPz+W0E/znibjablkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5577
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu78+ID4gT24gMy84LzIzLCA0OjM0IFBNLCAiWXVuc2hlbmcgTGluIiA8bGlueXVuc2hlbmdA
aHVhd2VpLmNvbSA8bWFpbHRvOmxpbnl1bnNoZW5nQGh1YXdlaS5jb20+PiB3cm90ZToNCj4gPg0K
PiA+IC0gaWYgKGFkYXB0ZXItPm5ldGRldi0+ZmVhdHVyZXMgJiBORVRJRl9GX0xSTykNCj4gPiAr
IC8qIFVzZSBHUk8gY2FsbGJhY2sgaWYgVVBUIGlzIGVuYWJsZWQgKi8NCj4gPiArIGlmICgoYWRh
cHRlci0+bmV0ZGV2LT5mZWF0dXJlcyAmIE5FVElGX0ZfTFJPKSAmJiAhcnEtPnNoYXJlZC0+dXBk
YXRlUnhQcm9kKQ0KPiA+DQo+ID4NCj4gSWYgVVBUIGRldmljdmUgZG9lcyBub3Qgc3VwcG9ydCBM
Uk8sIHdoeSBub3QganVzdCBjbGVhciB0aGUgTkVUSUZfRl9MUk8gZnJvbQ0KPiBhZGFwdGVyLT5u
ZXRkZXYtPmZlYXR1cmVzPw0KPg0KPg0KPiBXaXRoIGFib3ZlIGNoYW5nZSwgaXQgc2VlbXMgdGhh
dCBMUk8gaXMgc3VwcG9ydGVkIGZvciB1c2VyJyBQT1YsIGJ1dCB0aGUgR1JPDQo+IGlzIGFjdHVh
bGx5IGJlaW5nIGRvbmUuDQo+DQo+DQo+IEFsc28sIGlmIE5FVElGX0ZfTFJPIGlzIHNldCwgZG8g
d2UgbmVlZCB0byBjbGVhciB0aGUgTkVUSUZfRl9HUk8gYml0LCBzbyB0aGF0DQo+IHRoZXJlIGlz
IG5vIGNvbmZ1c2lvbiBmb3IgdXNlcj8NCg0KV2UgY2Fubm90IGNsZWFyIExSTyBiaXQgYXMgdGhl
IHZpcnR1YWwgbmljIGNhbiBydW4gaW4gZWl0aGVyIGVtdWxhdGlvbiBvciBVUFQgbW9kZS4NCldo
ZW4gdGhlIHZuaWMgc3dpdGNoZXMgdGhlIG1vZGUgYmV0d2VlbiBVUFQgYW5kIGVtdWxhdGlvbiwg
dGhlIGd1ZXN0IHZtIGlzIG5vdA0Kbm90aWZpZWQuIEhlbmNlLCB3ZSB1c2UgdXBkYXRlUnhQcm9k
IHdoaWNoIGlzIHNoYXJlZCBpbiBkYXRhcGF0aCB0byBjaGVjayB3aGF0IG1vZGUNCmlzIGJlaW5n
IHJ1bi4NCg0KQWxzbywgd2UgcGxhbiB0byBhZGQgYW4gZXZlbnQgdG8gbm90aWZ5IHRoZSBndWVz
dCBhYm91dCB0aGlzIGJ1dCB0aGF0IGlzIGZvciBzZXBhcmF0ZSBwYXRjaA0KYW5kIG1heSB0YWtl
IHNvbWUgdGltZS4NCg0KVGhhbmtzLCANClJvbmFrIA0KDQo=
