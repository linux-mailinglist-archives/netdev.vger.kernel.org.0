Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E66E393E
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 16:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDPOaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 10:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjDPOaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 10:30:23 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2098.outbound.protection.outlook.com [40.107.22.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43302D79
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 07:30:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qtj6351V907DVQ6jWBbuioaRKww+h9BUKpA6XZA1f+msElDQVN5nhTQViHoRaWE9idb3pjxjRGKosPoRQwAGU1RiImPoskVG9iJvYVQNKPYAZkRpJiAC31dWvLpsDzoEAWM2PH9WCRbByyMPxR8tTZNqFwbrEkRmSXMZXQ9xOOQp5He9rGeNsawh+d32gZ30WAwYyk4cnYuT+lCd1HXebTkgtejhvUP5sZkpJEcnTN7raWvkNsBD3hf4XGP38XOsG3WR8ZCBMmrnrZdm0weec5+VY0KUIbG4a8k2Wdh5tZp6kJBiMRsBPOjrR9ArNT7e/hAynXQaZi96U6DODxUYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIe0qF29hTsR1JBTS9YzUsaIOCg8ebphM902GZAaQzU=;
 b=A2Ic9IrLdWWH0yDjtevCBD55wPBiXY6FqVGfBU8ZfI2Mtp2FPfL47e1tOHk9UigkhrlyRlL4hY6IM+tT9R+fMa2J8fZzjHXOYddNe/P53rT/GXXThU1Lp8nODuUAmgJXbKprUm01AfcsuHiKc9YLy+t0rA5QU6OfRK6eOmuA61tVKx3hejCuzbAe/TQeUzRNWLf7w10+vwip0ooVdDxP2Fh28sHrYat00TkI2wFSxIa1QcbHGZ6NhUdfWsKgDr+u0dbwVKZKUXyesr7DrVrv1X7i4/UtWhPzUa1ndxI1eFkNlOwnBxJJK4+r5QIWla3G5Klmcp3JZX2p+CtB6ZiczQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIe0qF29hTsR1JBTS9YzUsaIOCg8ebphM902GZAaQzU=;
 b=j+8s0FMPwxIQUDL3ZjE2nOeH38eF/rY9o1kyywE6o3d6lqzXRm8rZeNlTe28WLRZ1HJNmO4Ti076s/hIT+T/uda/CJqO9VcrgyAedMlNT2mH3tBL+5Roz4wGbxaqEN3x+Fw4rKXSXE7DCT+QBnZwCVciq+NOmo4YzB8a93oMmSw=
Received: from VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:5::17) by PR3PR01MB7115.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:78::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sun, 16 Apr
 2023 14:30:18 +0000
Received: from VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 ([fe80::a0b2:d7a9:4f7:4a70]) by
 VI1PR0102MB3117.eurprd01.prod.exchangelabs.com ([fe80::a0b2:d7a9:4f7:4a70%5])
 with mapi id 15.20.6298.030; Sun, 16 Apr 2023 14:30:18 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Thread-Topic: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Thread-Index: AQHZcG/3jS6cFCsc+UuSyaDRz1oYQg==
Date:   Sun, 16 Apr 2023 14:30:18 +0000
Message-ID: <6806f01c8a6281a15495f5ead08c8b4403b1a581.camel@siklu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR0102MB3117:EE_|PR3PR01MB7115:EE_
x-ms-office365-filtering-correlation-id: 0edbb6f7-74a8-4ecf-3391-08db3e871a04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BPOuyXCsFKGNA3D1H9dyn/870BsFqhIP53zpBMjjVZydvpKaCzKI9jh6/KQVcQ/fkNLrRgZSyQcKQBVgtQsZC21fdIJQbuulyyr9f/zS5vK9iUQmHQ4zb8gjoNj8lQCMY/+VEtgIzyZS+fvWhK7IS5MG+n1jTGdr8DJTDhDNCICt5w9BCJdUYeYR9R1+gkPFoKscYdW4JLJHgO+CywamOkGtPUh/HdAJG0d1eajZG8o1lG+xeepdvHdWPUZqkAx7lDDmtsIPPmox3+TT7cSUbIK6C/YnRAsU/F4BWRBCkJnih/3ilJSJtQq7Fm1MmYzK9D/SsMhB/p/xCsJ4+O2myDDUMJ9+hSsaaOuGZJRqtNanjbNoyDhniBL1fybGRv+ZkQDAzGLAAiGUPuQJzfNuZK6n4sqp1fydAH8PJRq6BFxrCjjq1mkhxiuE1wgSe5YRlUTHXGGZZCo3Yx0Tgp6TNGc161X6bucZX4rbbbIXoTmM4+G3HvLmPE3NpK5fsHyevL8CyZs2eD5lDRRgnPBgwpCk53Kw7F2+y5til81E7yYsl1OvsjuMc733Dc1v6gX58qQIJhYm612T0o5nuZK1q6japO7vPmVvnM+KrxLi957v6lOI8WuYh3HrTd2Mu+3j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3117.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39840400004)(396003)(366004)(136003)(451199021)(41300700001)(76116006)(64756008)(66946007)(66446008)(66556008)(66476007)(54906003)(478600001)(6486002)(316002)(4326008)(2906002)(6916009)(71200400001)(38070700005)(83380400001)(36756003)(8936002)(5660300002)(2616005)(86362001)(8676002)(26005)(186003)(6506007)(6512007)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEk4SHhOM2ZlTnovRHc0ZlJNcklMbnVRVUwySGNmdy9CWDB1OHJUVHErU09E?=
 =?utf-8?B?bWRQWjdNU1g5U1V1SnZaUmhmT0o1SGxDb0l6dWNXVGMvV3Z6eEZBWnhxRk5T?=
 =?utf-8?B?dnd1SXgyK3hiUEtHRGhXSU1ucUNlOXdpQnJGRnJ0MGwydjJ5L0FKcEx1V2c1?=
 =?utf-8?B?QjVRU2UzcmNDSXBlY3RSMXpaSkJJblFzTHQ0bU1BMFBSeHpWS2U5V1FJbVh2?=
 =?utf-8?B?UW5CTnlKYnVPZTlVSllkYWovcWZOeThNMWhzSWo0WS83QTlVUVJocmwwSHFl?=
 =?utf-8?B?VDkwNDhhdlBRM1JZdWZvMGdPTEhaWHFNV2VJRllLdThyb3h3RlQwa3lYVFVl?=
 =?utf-8?B?RmJlZUNmd1UyN0twMFptNS9OaWN3bDErUm1WYUc5aXJEU3U3U29rZVl6dHJp?=
 =?utf-8?B?SUg3TGRjU25VZXhJSzg4QUJPUmlyaTk5blh3aUxqemhYbkU2K0o1Rkc5MGph?=
 =?utf-8?B?OStaditMdkpxSXZxUFAycWZDNlhuUnBEZWFrQTBCR2FJd1RTbktya1NLYWdS?=
 =?utf-8?B?Q28xbjQvclFRNkRvT0hpSXUrUUFuYXViOGJOWlNCanZmWGU5bWh2anoveXBr?=
 =?utf-8?B?Sm9IdEpkaGFLMTN2a2VwbFpBNTBDRXZ3Nkd3QjVMc1FVVWVDVDU5MmxRK05X?=
 =?utf-8?B?cm1FVisvSGwwUDJDYjhQYVduRzFqMVpnQzB3Ym45U04rQWtFK0duV0F2aEtz?=
 =?utf-8?B?YVdVaTNRNVhWMm5JVEluWTd5Um4rZ0gvVmt6NnAvZkx0U3pSLzlFaTgzYWpu?=
 =?utf-8?B?RHJncTQ1RlluWW9ob3dCM1ExYTJleHJLZVA1WmYxbXQ4WDA0bGUzYlZtWUsx?=
 =?utf-8?B?eEM0M2FiZUJxYjd4NmRuRDMydVlrM2QvUXNCakRxKy9rQm1DVm5ITWpmWU51?=
 =?utf-8?B?NUUyNmdzYXp2VXQ3czl0MlcxWEw4aCtOTXBwYmtKQ1VWWWg2NnRCM3Zzam11?=
 =?utf-8?B?bjFHTXRabXgxRWJWTElOUzA5bzBrRCtEcS9XbCtueCs2OWs0dXdWdnBzVlVI?=
 =?utf-8?B?aGdDODRRRTl1Vi95NTZCTGR2QnJhMGhHOWNPRG05UmFzbXJMSm5qWkNnbUhy?=
 =?utf-8?B?eTIrVFZwYjhFbC9VRjFDTWFsTk9UNE43TUtSVDBNRG5GVGhGSS85TTNlSnlk?=
 =?utf-8?B?TnpGbmFJb3F6THVLdkd0VktrR2Ztb0Y3elMyWDlGSnl6WkZpaUlQZGp4TjJS?=
 =?utf-8?B?ZVJCdU9keGQ3R3Z6YW13VTJwb2VmT2ZmRktQSTJZSWVOL2REWWc4RVpKMm04?=
 =?utf-8?B?SWJtaEhwZkRjQlAyNG4wYVRQLzVvaTY4TzB4QUdJRWl5MmdZZWZJaGd4Qmho?=
 =?utf-8?B?c3hiQTR1T2tVVUIzOW91eDBxVVZmV3V0ZERoaXFLU0pQcmh4cXI3ZmhkVVZ3?=
 =?utf-8?B?SldTeXhXbWpnajNiSEp2eHNEUXVnVEdWRXBqejBXL1ROczFXTFZmWDN4YkFl?=
 =?utf-8?B?dTQ0YmhOREtJZ3U1QVZyeC82NkhWR3UzMUZwTkk0Z1FPZno3dVBKdEFSVEVU?=
 =?utf-8?B?bTBHYytiZmwva3ZhTFExUHZWS25TU2JzeXZ3NUs5d1ZGczdpUUQ1R0xFTzRI?=
 =?utf-8?B?WHNJNlhTMkZkbm1nSHJocW9Ua2pmSjlPKzlpM200Sk1aS2FiMFR5bFFOd0JW?=
 =?utf-8?B?QThtT21oR2gwMDF5SGVUVkRWckNOZjZ4OEwwRkYxUHNEaFFXU1kvMVFpT1R0?=
 =?utf-8?B?ZXhKSmM4VTFnQmczaUVqKytBR1E5WXF3WG1sWmhXdTFaZ2tPcm50WWkvNjZZ?=
 =?utf-8?B?SGkzM3EwdnRvS0ppSENURGFQM2JGWDE5akYvV3k3SlZFdHpVSFNGdEszVnJN?=
 =?utf-8?B?NDZWd1RtYW9vVHRFNHY5R1BXRUxFdjFMVnh2aU1xRTJJYVRUMVB2VW1tVnRn?=
 =?utf-8?B?RDBYN2tlVThuVHJIWGQ0RXlzNVBHaDFYTkx2MDUyemV5bXlJK0Vrb05Ldlds?=
 =?utf-8?B?VlFBVDl5NjdHa1ZmSXR0aWlZY1pNNTI4SVR0cFdnVVhGZWlMUndtS00renV2?=
 =?utf-8?B?aWhNRVhIbGx2WTlGcHJQNFU3ZjMvQ3NjWFN2R2YyeXZhYTgxYTFrZjEzTTli?=
 =?utf-8?B?SXhjMUlHK041RU5lRkdFYm1QM1g5SEt3TDRKakw0c0Z4dG9od0hmTk1Na1Vi?=
 =?utf-8?Q?F+aHQV/onABd0emPXXQjEr+d5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C5931BE9785A940A4FB093E74507EB6@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0edbb6f7-74a8-4ecf-3391-08db3e871a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2023 14:30:18.1032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k26CG1WKj2Cpvu7ITqkdPuoW1qRbeC2IAR6F5M0363W4AHSoIn7zfB2M2MTv33DE9XkxGzuhShe99iekHW2WNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR01MB7115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSBiZDdmYjI5MjIxOWU2YjY0YTY1MGE2Yzc5ZDA5ODIyZGJlZjY2MmQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KDQpJbiBzb21lIGNvbmZpZ3VyYXRpb25zLCBhIHNpbmdsZSBUQUkgY2Fu
IGJlDQpyZXNwb25zaWJsZSBmb3IgbXVsdGlwbGUgbXZwcDIgaW50ZXJmYWNlcy4NCkhvd2V2ZXIs
IHRoZSBtdnBwMiBkcml2ZXIgd2lsbCBjYWxsIG12cHAyMl90YWlfc3RvcA0KYW5kIG12cHAyMl90
YWlfc3RhcnQgcGVyIGludGVyZmFjZSBSWCB0aW1lc3RhbXANCmRpc2FibGUvZW5hYmxlLg0KDQpB
cyBhIHJlc3VsdCwgZGlzYWJsaW5nIHRpbWVzdGFtcGluZyBmb3Igb25lDQppbnRlcmZhY2Ugd291
bGQgc3RvcCB0aGUgd29ya2VyIGFuZCBjb3JydXB0DQp0aGUgb3RoZXIgaW50ZXJmYWNlJ3MgUlgg
dGltZXN0YW1wcy4NCg0KVGhpcyBjb21taXQgc29sdmVzIHRoZSBpc3N1ZSBieSBpbnRyb2R1Y2lu
ZyBhDQpzaW1wbGVyIHJlZiBjb3VudCBmb3IgZWFjaCBUQUkgaW5zdGFuY2UuDQoNCkZpeGVzOiBj
ZTM0OTdlMjA3MmUgKCJuZXQ6IG12cHAyOiBwdHA6IGFkZCBzdXBwb3J0IGZvciByZWNlaXZlDQp0
aW1lc3RhbXBpbmciKQ0KU2lnbmVkLW9mZi1ieTogU2htdWVsIEhhemFuIDxzaG11ZWwuaEBzaWts
dS5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212cHAyL212cHAyX3Rh
aS5jIHwgOCArKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZwcDJfdGFpLmMN
CmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl90YWkuYw0KaW5kZXgg
OTU4NjJhZmY0OWYxLi4xYjU3NTczZGQ4NjYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tYXJ2ZWxsL212cHAyL212cHAyX3RhaS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tYXJ2ZWxsL212cHAyL212cHAyX3RhaS5jDQpAQCAtNjEsNiArNjEsNyBAQCBzdHJ1Y3QgbXZw
cDJfdGFpIHsNCiAJdTY0IHBlcmlvZDsJCS8vIG5hbm9zZWNvbmQgcGVyaW9kIGluIDMyLjMyIGZp
eGVkDQpwb2ludA0KIAkvKiBUaGlzIHRpbWVzdGFtcCBpcyB1cGRhdGVkIGV2ZXJ5IHR3byBzZWNv
bmRzICovDQogCXN0cnVjdCB0aW1lc3BlYzY0IHN0YW1wOw0KKwl1MTYgcG9sbF93b3JrZXJfcmVm
Y291bnQ7DQogfTsNCiANCiBzdGF0aWMgdm9pZCBtdnBwMl90YWlfbW9kaWZ5KHZvaWQgX19pb21l
bSAqcmVnLCB1MzIgbWFzaywgdTMyIHNldCkNCkBAIC0zNzIsNiArMzczLDEwIEBAIHZvaWQgbXZw
cDIyX3RhaV9zdGFydChzdHJ1Y3QgbXZwcDJfdGFpICp0YWkpDQogew0KIAlsb25nIGRlbGF5Ow0K
IA0KKwl0YWktPnBvbGxfd29ya2VyX3JlZmNvdW50Kys7DQorCWlmICh0YWktPnBvbGxfd29ya2Vy
X3JlZmNvdW50ID4gMSkNCisJCXJldHVybjsNCisNCiAJZGVsYXkgPSBtdnBwMjJfdGFpX2F1eF93
b3JrKCZ0YWktPmNhcHMpOw0KIA0KIAlwdHBfc2NoZWR1bGVfd29ya2VyKHRhaS0+cHRwX2Nsb2Nr
LCBkZWxheSk7DQpAQCAtMzc5LDYgKzM4NCw5IEBAIHZvaWQgbXZwcDIyX3RhaV9zdGFydChzdHJ1
Y3QgbXZwcDJfdGFpICp0YWkpDQogDQogdm9pZCBtdnBwMjJfdGFpX3N0b3Aoc3RydWN0IG12cHAy
X3RhaSAqdGFpKQ0KIHsNCisJdGFpLT5wb2xsX3dvcmtlcl9yZWZjb3VudC0tOw0KKwlpZiAodGFp
LT5wb2xsX3dvcmtlcl9yZWZjb3VudCkNCisJCXJldHVybjsNCiAJcHRwX2NhbmNlbF93b3JrZXJf
c3luYyh0YWktPnB0cF9jbG9jayk7DQogfQ0KIA0KLS0gDQoyLjQwLjANCg0KDQo=
