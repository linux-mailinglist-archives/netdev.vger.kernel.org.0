Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47CC596DC4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbiHQLlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbiHQLlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:41:07 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20059.outbound.protection.outlook.com [40.107.2.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A32832D4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnufmDMMVVWBXGg8RyehBPWHOrbEz+W1nbD8EgKuayiTEwdMNbPgkWZWf3CgRjFIcBVLOIt1iLMWZhMyUJixan6fDh+Zcr9DFnMHdKGW8geBYw9ZMUPnzplr58AUKo/sy692OAnU5vjhBXIqWjx7T4JABtElhA4wgxf9K5hC+Q6oE0SFv92F9sA/OrQoA+NBuordhEcrpFoPxRUvPbYZxct0tAgfEDpzobxsCUMZsEV0O5UCWTuXwBt5zruMAhCr+HL4YCVFyoyj71W6M6YWlbPy3+JHSxgM7Y9MycyCdI1VeiZ7O9JnlZ+Q75hVcPnjNgg/YbKGe2YsI+2MQCrfUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9nLFvmDy/f73KuXcFvTgs0WGcKi3pVYM9Suo8/58dI=;
 b=KBWyL7EsEW+Fz1KAbUFZwAbDKGTJDtgB8wah5F8Dl/MK38V48FtDKKlzVedGYvSl2LqFMNiDi4XNgZzkws/7uXToW4CEgMVQMqEdqvxvZ9X27SLmWIWGJvFSYdr+l3KqRGGz/VZd0TKYF4vjZRVcmyGLaqbLIJ7Mu6P1YE1mrcWxx8Ss77gKS2+wjwLHdlElPlIRS4AJ8r8Zn1vXGwf7FUyBtLVv/ObIfNgTzbdKuE1lJaOmzSoTfMBnKf9CP8uy9a67KNBEhOYVUwN5fA7+AEsLBJlfxwDDmWX6E/LBXJBT+LhmrX3k4onbKJvYfxmWdjczMiUVmGnA/CPT0a0WfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9nLFvmDy/f73KuXcFvTgs0WGcKi3pVYM9Suo8/58dI=;
 b=erwuv19fy1rAwy4SmLBp1+go8YfsrI3qV4rCv/IXxF0H6pgHr1EUZ8ZjSPegNPJr6FmiZO2IZ8XyziJzkUzOJQqxZ2kU5SF1wUyDUbBO7a0kcACUlMkquI0o7Ib5xzJvnflsbiRajc04dNs1vPh0dqJt7jLvsSHhrpTiq8x+1Ow=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB5772.eurprd04.prod.outlook.com (2603:10a6:10:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 11:41:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 11:41:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
Thread-Topic: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
Thread-Index: AQHYsb+nXYtt3WXwKU2Qzt72A2WzpK2ybZGAgACLYQA=
Date:   Wed, 17 Aug 2022 11:41:01 +0000
Message-ID: <20220817114100.7pu6y4lpnedyc3fg@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com>
 <20220816202209.1d9ae749@kernel.org>
In-Reply-To: <20220816202209.1d9ae749@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e1e6808-6ad7-458c-cfb0-08da80455c00
x-ms-traffictypediagnostic: DB8PR04MB5772:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lUYicD2O53ORxRclpGV2UJoDqWvX0mSAuSxCLqug4d+uhur/rdfrl4A/sMUX4zjaZ4tzuv0bmtF/d2jMU91VdedLo5SrUdXL1wP1A2jnu6YsN0zKb1hCX7P7XlpsUtP5YwXqMvD2YF5jsF7oohxH/gAIqShKluwE2yxAqrgHoALPyMYZebGHfbC7cTjxDj9Yx/n8KPCJp14LbymQGPIYY3+APQ9bcxw2OR8dfcr4I5PslOEx7AAMtaLdNDJx24ljBErA/e8jK2T4X3IX0Q7zxlW77ufNQ3TZpblh8pZVuuMpZbcso+nqt+dbW45Gm+c/hHO55a9e1ZmAofUja2ysVpFnh186vNWsJWBQuUVXPKPdiBhlJZtmRygU+lgiEr32vUK8/VTbrqS11XLxp3+vidIKyL0gJZ9HnGNEj87fKCAjXhkK7EPTS1EE2oaeLiZ9LzbnrYmviNKJ2CsNIny8jfPj+3HEW1HaY+ZcZNRxeOXGE3gGtPH3EMjoQQmlCDURVTo1mZf0ckZsoJOIP+4nsRC2XeJPU0/UVo1gKco9PVJvLoLD4JP3tD58Ket9UlAo4pqchBNIfbKQhTVTunXQkY/x7dGRmZRKGyUCEoN31RQ8Lg/hqmXl9v2WbUHVNxzdTCyGNFuq8QG4u/AaPAUuCHU0SUYuqy9JTTwfhb0Hk4hy4XIpAKY5rOxFcbzEeGrsxQgqjkB8722Q9yNZbYIzCceotqFqV693r01KVUC24+IFP0W5mhwSh9FP0xmKtvJDHYsau4ThLSaGIkGkOdnLN2fmB0tusXtr9Npxgrr5OEB49mrqjDtymW9Ca5useRuT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(39860400002)(396003)(376002)(346002)(9686003)(6512007)(6506007)(26005)(86362001)(38070700005)(1076003)(186003)(38100700002)(33716001)(122000001)(83380400001)(71200400001)(5660300002)(44832011)(478600001)(6486002)(66946007)(8936002)(76116006)(8676002)(4326008)(66446008)(66476007)(64756008)(66556008)(2906002)(41300700001)(54906003)(6916009)(316002)(19627235002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTY5ZDEyWHl2Q09zWnlRcEpyL3pCNXpJQ2ZuRWhaOEc2eUUyQ280Vi9ZS090?=
 =?utf-8?B?OStEUzRZejBLVEl0Y1lGWWhvZWNoUnBVNXZDVXY3STJFT0JrellsSnNEa0JT?=
 =?utf-8?B?QW9Nb0c0UjV4QnVnM2tESnVCN1BxZkY2d085MzRPVVlLeVg3WDVoNkh2QjhL?=
 =?utf-8?B?dEJwTXY1by9wN2czS21VRm9HRys1eHNqT0U0WWxDT3dldFgwSWUzODVZbkkr?=
 =?utf-8?B?RUpQUDdQS2M1RlpxVVhEOWZ4NjI1a2hvRGRVcDNGTzUxTVk5N3FQbjBGSHVG?=
 =?utf-8?B?ZGpuRXhyVWphWS8vd2NvM3NBM1hYOFdYYm9kOXAvZVd2WkVjT2x5LzNXaVFi?=
 =?utf-8?B?ai9tdU5Yd2J6ek44Q2RaWlVrNW9zcW53SXlTd0Q0dzFhRXpqeUdhVW9QMDJw?=
 =?utf-8?B?T2NXYitxN3ZDczUrYisydUtqays5SnRXdS8wMmd0SFVxY04wMlpHWWU5djhP?=
 =?utf-8?B?NDJ3UXJsWHpWWFY0K3U4eXVoaVZ5ZG96Z1FtczA0OHlKeXRGU2d6WVlQdjBX?=
 =?utf-8?B?ekV3YXJSQlBCOEN2MXBxZXNMcDBGNFFmbTVIbG9Hb0Z0ZnB1WVBsQjJZbjZG?=
 =?utf-8?B?K2twTWpKR3pUUmpxV003WDRkN25GVTllU1A1YXBaS0FacnF5WHFMdS9qUThC?=
 =?utf-8?B?Zmk0U09FMDVnMmlqNGNna0I1Nnd1SGVTSmJPcVVWZTV2Tm8vdGtWTHhIUk90?=
 =?utf-8?B?TWRJQk5xM3dpV0xyRDlmcnNKTTd5c0xhMDIwaUkyUjRjZGcrRU9SUlRvSEhL?=
 =?utf-8?B?ZTR2ZXJFeWxqSmZ2YVREYzNwM0FaeWFpcGZvTDZ1WFM2RFdSeU1rZ3NPQ0tu?=
 =?utf-8?B?bFJ3N0gvVytsV0hrL2VhejRHRHlnQlpxVWNtQVVUaVhtdjk4Vzh0TzZXUldK?=
 =?utf-8?B?VXUwS0FkcFVZM2ZtbmxpeFNyT0FpK0huOGxNZnh1cnBmTEEvOGRzMU81aXFw?=
 =?utf-8?B?QXdscG9PZHRwczdWSk9odlFSMGpoZ3pxejhPWEVWV2Z1M01yK1R4R2s3cGV6?=
 =?utf-8?B?RnRzVkFlNU0zbUdXbXpBTXBFd3VQUC9EUUw4Mm0xbk9ONThuYmxXMGptRWd5?=
 =?utf-8?B?RzJlVmpZdmhjcDhUUmtrK2RLVzRnNFdHUlpWSlBtdWxRNURlUUpObUVPMlhP?=
 =?utf-8?B?aHU2bUhuNTc3QXRNTUlOV0Z6cStiTzVob213clJjS1ZhMngvcldySmY1MmhS?=
 =?utf-8?B?WVJxWmdSQmV5OXN5OHA0ZGJ0TkQzanVERysvRGlYQ0RrR3RjaUszdkRwdXMr?=
 =?utf-8?B?THhoQTJoS0VyaWozc0xCWGkzVjlBNU53aVpCNGdiRmxLTGtsUnBCVm1ZRURy?=
 =?utf-8?B?NWw1K2lqL3Y1cFYwMUphV0JLamJYd0wxSGlxQ2hGaU1Ja3VZSGp3c3diUTU3?=
 =?utf-8?B?RnZDZXlTcUVxZkpCWWw3dHBSUFBJRWUxRW5GSEorSkRKYnJqSlVjRFJXcm9s?=
 =?utf-8?B?RzZHR3hlYkdMK1dYQnBCYkttQWJHU1JWUTVaU2FUd2dFaDhRaEtVSHR2cC9S?=
 =?utf-8?B?bG9kY1R3ejJaalQwazhJRThIQjhXQjF6elFqQVZxemJYWnhBZm5BN3JRbTBx?=
 =?utf-8?B?S2hZT0pWcnE2dno4ZnBWM0JrUTBjcVA2TUVMRkZSM2FqcG9wcU8xRmk3WC9V?=
 =?utf-8?B?MElsUnlJdXhRY3RmUyt4THNRSW9USk56WVVSOXowazRWOG5RTXp0RlpnaHFm?=
 =?utf-8?B?elBaMy9MOTlnc0RVWG1NeGxTTGVZWUVmdS9iVzU3OUNUWi8yM1hRb244Tjdx?=
 =?utf-8?B?citCbzA4VWlVK3gvWFRFWENMbHVIdklZenRWUFllVFpaQTh2M0pRdHQzOFRa?=
 =?utf-8?B?OXhkb284NzZhSTlCOHZBYlVzeklzam1INHl0REo0VmpaWkJzbnRURDdPdk05?=
 =?utf-8?B?NTErMHJmRUVKdnFvLzlFMkhaQk12WXoxZENlZ1ZUb2MvL0JnNDl1ZHR5MkdL?=
 =?utf-8?B?ZktsQ25RSTdvRWlkcU5WSjVQQWhlNG13UEJvSFZxaW0yeDNjaE1wQytLTFJy?=
 =?utf-8?B?N1FZSnEzZXRxb3NqREppM0NLalArVy94QjJrbllMMkJsenRMc2ZpRlpVOExY?=
 =?utf-8?B?ZmNGYUx4Z0NHSEs0VFFmMThnWXRWak5kT0FZTUVqVTFxVDBwL0kzd3l6MTd1?=
 =?utf-8?B?bGVUSmdmZVBmVi9vQ2p6V3NGTUg3MjJsRWJOMmhmbXNLOWkvMzErZ2o2WlJV?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A893233996F6F4BA459EB7F57576E86@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1e6808-6ad7-458c-cfb0-08da80455c00
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 11:41:01.0846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yld9+Neh/XbmIZZNaybEt2GZiRRLU30SWxeJHl/iC8g0IgAoxJMQD7UekoNOGeC/pUcpu0ZTYCH3Cp15BB0uZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5772
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBBdWcgMTYsIDIwMjIgYXQgMDg6MjI6MDlQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IE9uIFdlZCwgMTcgQXVnIDIwMjIgMDE6Mjk6MTUgKzAzMDAgVmxhZGltaXIgT2x0
ZWFuIHdyb3RlOg0KPiA+ICsvKioNCj4gPiArICogc3RydWN0IGV0aHRvb2xfbW1fc3RhdGUgLSA4
MDIuMyBNQUMgbWVyZ2UgbGF5ZXIgc3RhdGUNCj4gPiArICovDQo+ID4gK3N0cnVjdCBldGh0b29s
X21tX3N0YXRlIHsNCj4gPiArCXUzMiB2ZXJpZnlfdGltZTsNCj4gPiArCWVudW0gZXRodG9vbF9t
bV92ZXJpZnlfc3RhdHVzIHZlcmlmeV9zdGF0dXM7DQo+ID4gKwlib29sIHN1cHBvcnRlZDsNCj4g
PiArCWJvb2wgZW5hYmxlZDsNCj4gPiArCWJvb2wgYWN0aXZlOw0KPiANCj4gVGhlIGVuYWJsZWQg
dnMgYWN0aXZlIHBpcXVlZCBteSBpbnRlcmVzdC4gSXMgdGhlcmUgc29tZSBoYW5kc2hha2UgLw0K
PiBhbmVnIG9yIHN1Y2g/DQoNClRoaXMgaXMgd2hlcmUgd3JpdGluZyB0aGUga2RvY3MsIGFzIG1l
bnRpb25lZCBpbiB0aGUgY292ZXIgbGV0dGVyLCB3b3VsZA0KaGF2ZSBoZWxwZWQuIFllcywgdGhl
IGhhbmRzaGFrZSBpcyBkZXNjcmliZWQgaW4gODAyLjMgY2xhdXNlICI5OS40LjMNClZlcmlmeWlu
ZyBwcmVlbXB0aW9uIG9wZXJhdGlvbiIuIEl0IHNheXM6DQoNCnwgVmVyaWZpY2F0aW9uIChzZWUg
RmlndXJlIDk54oCTMykgY2hlY2tzIHRoYXQgdGhlIGxpbmsgY2FuIHN1cHBvcnQgdGhlDQp8IHBy
ZWVtcHRpb24gY2FwYWJpbGl0eS4NCnwNCnwgSWYgdmVyaWZpY2F0aW9uIGlzIGVuYWJsZWQsIHRo
ZSBwcmVlbXB0aW9uIGNhcGFiaWxpdHkgc2hhbGwgYmUgYWN0aXZlDQp8IG9ubHkgYWZ0ZXIgdmVy
aWZpY2F0aW9uIGhhcyBjb21wbGV0ZWQNCnwgc3VjY2Vzc2Z1bGx5Lg0KfA0KfCBJZiB0aGUgcHJl
ZW1wdGlvbiBjYXBhYmlsaXR5IGlzIGVuYWJsZWQgYnV0IGhhcyBub3QgYmVlbiB2ZXJpZmllZCB5
ZXQsDQp8IHRoZSBNQUMgTWVyZ2Ugc3VibGF5ZXIgaW5pdGlhdGVzIHZlcmlmaWNhdGlvbi4gVmVy
aWZpY2F0aW9uIHJlbGllcyBvbg0KfCB0aGUgdHJhbnNtaXNzaW9uIG9mIGEgdmVyaWZ5IG1QYWNr
ZXQgYW5kIHJlY2VpcHQgb2YgYSByZXNwb25kIG1QYWNrZXQgdG8NCnwgY29uZmlybSB0aGF0IHRo
ZSByZW1vdGUgc3RhdGlvbiBzdXBwb3J0cyB0aGUgcHJlZW1wdGlvbiBjYXBhYmlsaXR5Lg0KDQpJ
biBmYWN0LCB0aGUgdmVyaWZ5X3RpbWUgYW5kIHZlcmlmeV9zdGF0dXMgZmllbGRzIHJpZ2h0IGFi
b3ZlDQplbmFibGVkL2FjdGl2ZSBhcmUgcmVsYXRlZCBleGFjdGx5IHRvIHRoaXMgaGFuZHNoYWtl
IHByb2Nlc3MuDQoNCj4gPiArCW5lc3RfdGFibGUgPSBubGFfbmVzdF9zdGFydChza2IsIEVUSFRP
T0xfQV9GUF9QQVJBTV9UQUJMRSk7DQo+ID4gKwlpZiAoIW5lc3RfdGFibGUpDQo+ID4gKwkJcmV0
dXJuIC1FTVNHU0laRTsNCj4gDQo+IERvbid0IHdhcnAgdGFibGVzIGluIG5lc3RzLCBsZXQgdGhl
IGVsZW1lbnRzIHJlcGVhdCBpbiB0aGUgcGFyZW50Lg0KDQpPaywgY2FuIGRvLiBJIGRpZCB0aGlz
IGJlY2F1c2UgODAyLjFRIGFjdHVhbGx5IHNwZWNpZmllcyBpbiB0aGUNCklFRUU4MDIxLVByZWVt
cHRpb24tTUlCIHRoYXQgdGhlcmUgaXMgYSBpZWVlODAyMVByZWVtcHRpb25QYXJhbWV0ZXJUYWJs
ZQ0Kc3RydWN0dXJlIGNvbnRhaW5pbmcgcGFpcnMgb2YgaWVlZTgwMjFQcmVlbXB0aW9uUHJpb3Jp
dHkgYW5kDQppZWVlODAyMUZyYW1lUHJlZW1wdGlvbkFkbWluU3RhdHVzLg0KDQpEbyB5b3UgaGF2
ZSBhY3R1YWwgaXNzdWVzIHdpdGggdGhlIHN0cnVjdHVyaW5nIG9mIHRoZSBGUCBwYXJhbWV0ZXJz
DQp0aG91Z2g/IFRoZXkgbG9vayBsaWtlIHRoaXMgY3VycmVudGx5Og0KDQpldGh0b29sIC0tanNv
biAtLXNob3ctZnAgZW5vMA0KWyB7DQogICAgICAgICJpZm5hbWUiOiAiZW5vMCIsDQogICAgICAg
ICJwYXJhbWV0ZXItdGFibGUiOiBbIHsNCiAgICAgICAgICAgICAgICAicHJpbyI6IDAsDQogICAg
ICAgICAgICAgICAgImFkbWluLXN0YXR1cyI6ICJwcmVlbXB0YWJsZSINCiAgICAgICAgICAgIH0s
ew0KICAgICAgICAgICAgICAgICJwcmlvIjogMSwNCiAgICAgICAgICAgICAgICAiYWRtaW4tc3Rh
dHVzIjogInByZWVtcHRhYmxlIg0KICAgICAgICAgICAgfSx7DQogICAgICAgICAgICAgICAgInBy
aW8iOiAyLA0KICAgICAgICAgICAgICAgICJhZG1pbi1zdGF0dXMiOiAicHJlZW1wdGFibGUiDQog
ICAgICAgICAgICB9LHsNCiAgICAgICAgICAgICAgICAicHJpbyI6IDMsDQogICAgICAgICAgICAg
ICAgImFkbWluLXN0YXR1cyI6ICJwcmVlbXB0YWJsZSINCiAgICAgICAgICAgIH0sew0KICAgICAg
ICAgICAgICAgICJwcmlvIjogNCwNCiAgICAgICAgICAgICAgICAiYWRtaW4tc3RhdHVzIjogInBy
ZWVtcHRhYmxlIg0KICAgICAgICAgICAgfSx7DQogICAgICAgICAgICAgICAgInByaW8iOiA1LA0K
ICAgICAgICAgICAgICAgICJhZG1pbi1zdGF0dXMiOiAicHJlZW1wdGFibGUiDQogICAgICAgICAg
ICB9LHsNCiAgICAgICAgICAgICAgICAicHJpbyI6IDYsDQogICAgICAgICAgICAgICAgImFkbWlu
LXN0YXR1cyI6ICJwcmVlbXB0YWJsZSINCiAgICAgICAgICAgIH0sew0KICAgICAgICAgICAgICAg
ICJwcmlvIjogNywNCiAgICAgICAgICAgICAgICAiYWRtaW4tc3RhdHVzIjogInByZWVtcHRhYmxl
Ig0KICAgICAgICAgICAgfSBdLA0KICAgICAgICAiaG9sZC1hZHZhbmNlIjogMCwNCiAgICAgICAg
InJlbGVhc2UtYWR2YW5jZSI6IDANCiAgICB9IF0=
