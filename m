Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95C563BAC3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiK2HcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK2HcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:32:15 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2119.outbound.protection.outlook.com [40.107.102.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04F645EFC
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:32:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HB3enxXCg5Mdh4DpfhXHxZVjiIjjNuhegQYV73a6YJ241afb9kp2XvIlaxMxyVfDP2Xt0WTdRf/2oUHjF4pRCvINHwxq1lHBQ9bbEGTCqcI+sEcpEQVYgM5E2ujUKVFww4aDBQ0wCTPboZ4fXordw/b7enyh/LfK0DTbrwb9Dck2QeOP+9TM8LWZq2QzrZ/HNVQ684bpTnyIye31XeFnliwwlKoPN3HR4sWBmynqtEJiIY3qfnbg5+fNwxW99MFGbY7PCQA+/VKJYsD/dTWv6wTm0EYNa8jA+ABPZXhASIG0ZNoYGM3O/+xZII++vMqoJekB8AqQxMLypLW7r9fmSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iw3AgQgDKvCyti8oJvxNn5/Adx5AO+0kqhj1G0obj8=;
 b=DTrgjZUHYMgCYODTD360/JNxZkP/9tRAgwwJTJidxrlOUURyJ44VgZCEoXoXhRlBHR7gfogJz4gU9O9BjO1Ztn9SGROBXPqRyTORlAYBi935PRA59eforbl8NWKT/cOIp0PqQpT9NxLAZdsSSXeTl6oCHFfmYYmHifrpPNyOnPDKW2nZPKl4SR+FWo55cA8ClPLduiSe+fd+L12GgWk8TME8wi7nb3Mks2XQv0qRrvFC69i0fMLhwBJUhqRphW569C8nRGAlIgYwNBBfRCUHGmFkIITrf2g/bsC66OrXFH2FPiuOczbmeO7+W0/6yTojdATo/KR667WWau8XUqzTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iw3AgQgDKvCyti8oJvxNn5/Adx5AO+0kqhj1G0obj8=;
 b=eqxjzh8H7TX+cKHUT8ohTbszKZuGV3YkUObeQ+g+RzscbFJ2LyoMIbnQeY7a9QtU/1NTP9nLu0k5preJzf6L+Lka9NqHc6MAAR/YJlXBqivICkkKnObMnTDOokaWMBSyjR6nwo1CXy/gHxBOqURgKWIa/k4o/ON/LytkelbxFxA=
Received: from PH0PR13MB4793.namprd13.prod.outlook.com (2603:10b6:510:7a::12)
 by SJ0PR13MB5622.namprd13.prod.outlook.com (2603:10b6:a03:425::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 07:32:11 +0000
Received: from PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489]) by PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 07:32:10 +0000
From:   Tianyu Yuan <tianyu.yuan@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Marcelo Leitner <mleitner@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: RE: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Topic: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Index: AQHY/mSdmThOr7A34UyDPeUsz+fSLa5OwOIAgAAoYjCAAPcXAIAEK8gggAAyI4CAAUYrkA==
Date:   Tue, 29 Nov 2022 07:32:10 +0000
Message-ID: <PH0PR13MB4793C795A4446BA2E4DE000E94129@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CAM0EoMnw57gVb+niRzZ-QYefey4TuhFZwnVs3P53_jo60d8Efg@mail.gmail.com>
 <PH0PR13MB47931C1CBABDD4113275A2A994139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CAM0EoMmPjXvfeGo47KN_rAg-HsFMqK2yku4_BHu0M6G1VH48Pw@mail.gmail.com>
In-Reply-To: <CAM0EoMmPjXvfeGo47KN_rAg-HsFMqK2yku4_BHu0M6G1VH48Pw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB4793:EE_|SJ0PR13MB5622:EE_
x-ms-office365-filtering-correlation-id: ba6c702a-e60e-4d33-cc28-08dad1dbd3de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P3eSwzBGBd7VfWW7dGSnUVH7rMlRKgu8m5OwULZVTiqUhPXt2RqBaBP4Jfz4r+SRBkpU5SPnoX+Z7zWa3RilyoydSVSr6JpOUYbKwsnUVOzvfiITIpJVvQPbxCewW3sG4AWOnPP9IvC0qGuMvkyhYi6bQGPDSFtEmuyHFtT3kv3/LUvDqs5JVEZul97O+otFgj3S5pmb6EOguUHngAesGr6ON8FHBzOI3cmvga6HX8smuCvv4fCJr5xo+9YLE41/Uss81a6WnBrEjVi0qMqfOoKAqjoX5wnygCnbILnXSrbHN/D4mq8sP7QBBIiTVP7Y0aEvQ0Ss4jR8GwOETiORutDcuUSBGcGKyY9V3RLE1MFCSqDvijuMqveDA5N4MGiZ11T26eXW1AkWYWQRPiwnuyAAQlmOSNuXa+22PUel+CwHzKEAmOMW7LeBTQSJZPnrC53W6i7JCR69HxCM/Drzl1kgdIHML2JMijvBD9VWNw/1JgRKM5nbVXv50dmRNoeGQH+Hzzco5qZ2zUc0Es8BDiqXB2bYm7GWsQ47DdGtHqBszMBcAAk8VF8kQGWYGCEkx6lmfvNULn3JvlvTmeLbmQxczPIvMojlbzCG6QlLbzY0VIaoMtmNB/e+E3dAvmMViyd1ZtWd9QhIreR2pPvHOO+dbFe0A1NxYExuxA9a5HA6mZbzYHjBWzrt61lE81lIobSlYQJAJwzfXan6ADN0YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4793.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(451199015)(122000001)(38100700002)(8936002)(52536014)(44832011)(83380400001)(5660300002)(41300700001)(7416002)(76116006)(4326008)(64756008)(66946007)(66446008)(66476007)(66556008)(71200400001)(186003)(38070700005)(8676002)(2906002)(478600001)(55016003)(33656002)(316002)(86362001)(54906003)(6916009)(9686003)(26005)(53546011)(6506007)(7696005)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVFGUUo3Y1J4bVZ2b3Q4QXBQY1ppeEZETXhDVkdYL3kzdEVXNEV0SUVEUmZ5?=
 =?utf-8?B?bTJPUmU2SnpHN2FxUkJLb0h0OHRWQktXSzZFNkdsUCs0b1hnYUdxZ1RiZjRO?=
 =?utf-8?B?NEp6Ym5SMm5sQVAvNG53YzNZSzZlNmpxMWs0M2dWcVRjL1AzT0R0bHJyZm5K?=
 =?utf-8?B?a2RZT1ExS0FsUWtQNDdpSDREbFdVVmRFOEx2ZUQwbnVJWmlVMVgzSmFVTFRQ?=
 =?utf-8?B?SG15NVQ0NzRFV3BLQlptdGo1RnEySXQvbEFyNHpxZWNQYlljcmJCYXNmaWJl?=
 =?utf-8?B?eUZRZVh0RytyT2MwY1NidFRhdVFLbnFFanRuQy9YNDNIcU5PYzRuZjd2VDBo?=
 =?utf-8?B?REZNd1JsTWZwWFhPS010TFpyZHI1T2xqQys4M2FQaVpRQ0tQRGtwdUZoOHJL?=
 =?utf-8?B?Q1BXZWV6YlkzYlJqMUUrMmRYZ0c2dTBOVWN0bUQxbUV6MmpzUlZzSTZOamRG?=
 =?utf-8?B?SFFYU01oWlJHUTdXMVhJd1dzUm5na283S285UXl0Q1I0NWx1aU5OdFFMb2E3?=
 =?utf-8?B?QmpGeXpXbUFUbWdwMnZ0OXBkNEpaUTArcEpVU29ZekcwRCs0VktpYVVLZFhz?=
 =?utf-8?B?cENadlVaVXNlZm5mSTRpcUJURUFUd2RZWGdBTzlyZ21qZzViYU0rd01idkdD?=
 =?utf-8?B?aytHVXU3VXFQN3d2OERpbWhmMGVyLzBSbVViSDh3aUFDb1UyWlErdzQzdFZJ?=
 =?utf-8?B?QzRqdmN0Q2UyNUJQQ1B5RUFKVzEyZFJ0dHR2TjYxeUVOWkpqSGdjbUI0SG5S?=
 =?utf-8?B?elFkaXNwR08rZzRralR0eGgraFprY1hvbWFYVTJPUVoreTNwWHdPNkh4bnd4?=
 =?utf-8?B?M2xZK1A2eG4yekNhU0lSOW9USG1VajdjejY0eEpGTU5FSm9aY2FXNWo1ak5X?=
 =?utf-8?B?b2lvT0dkQUZ2M2paNzIzUmx4VmtHVkpKbS91NXFtNm5QRTFTT0xtUDBXSEVB?=
 =?utf-8?B?SWpuT2h2alVVeFg0bTBGM1J0WmVuSWRIUXZaWGtMeVlyd1h5Z2VTNnExMi8x?=
 =?utf-8?B?UFFMWmlrWksvQ2pYSWoySEpyWVA5REtIZVFldmtickFMcEV1MFl6ZkJwU0Ro?=
 =?utf-8?B?SFE1V1dLLzZRMHlOMXdFTUtHVTVYQ2dvb09VdWhNWmh4SHJLUkZMNUwrdURy?=
 =?utf-8?B?Z0x6eVdDeU1pUktyNjhSbjJIamJSc1AwOW8xeXJpbTFVejU0d2I0RjRuTlY0?=
 =?utf-8?B?U3o1Rno2bHluNE5wMithTnVBT3dodGFDS3J0dExkN3dYK1M5SDlOMW83aHIy?=
 =?utf-8?B?NUhjb0hncWRSYTBCRTg5cWkrYlE0djNjM21PakI1UExTeEMrVWg0eStGUktv?=
 =?utf-8?B?bnlXR3ZXRzlIV3R3UXZYNHFXc1ZNYmptQ05yT2ErUHFIVVZ4RkdXcUYzVk0w?=
 =?utf-8?B?NVdaR2d4eDU3MjBXcEJtYW5IcEdyNUEvVDcxbHBWcE54bGJld2czZm93anlu?=
 =?utf-8?B?NjhYV0RGQ0NvZUlPSE5uU2xMcSs0NzZDejVLVXVzMDE1UEJJcVNnTmphTm9W?=
 =?utf-8?B?V2k2ZFkrWW1lZk5ZS1BNZzVZdkJ3WVBjMXZDdDBTb0Q4L29MM1huckpoTjFn?=
 =?utf-8?B?S0lDSzVWTFFCOWpYU3dmK2JFTHpzZmJNRWFqekRxaERZUFNYalpVMUxiU2lP?=
 =?utf-8?B?TVlHNmNDY21HQ2dJME9VQUxWQkN0T2hHZVhUWW1ZNzRxdEtBN1JGeUxGTGds?=
 =?utf-8?B?bU9tdlNmTHBLZkw5TXZQQ2RFRXNjY2ZWODBMQU4vOVc5UnI2SWxUdVVkVStW?=
 =?utf-8?B?R1IyRks0TnY2Uk8rZGJBdUdsYVAvWmc1NmU0ZEJBUnB1UXlZLys3Sk5CVTZ3?=
 =?utf-8?B?MUdkNTVoanNrTnVKbDV6RzhRWHU3MkEzNDVSb0pHcVB6L3hNdkpQSExIODQy?=
 =?utf-8?B?R2YxendaT241ckxYNXN2WkRsNHVkaWVrU3lyamx0MzF6c1ZkT1djb2tWN1BE?=
 =?utf-8?B?ckQ1NGVNL2V3cWdtOUFkTmNHbDRZb3IxdDdWV3N2Q0JOTDNYMHpwYXJIOStI?=
 =?utf-8?B?eDBCeEZBc2grR29iY2xtRjJnZyt5YWcrbW1zUGZHbGVtU2V6UnI4QTRKK0l5?=
 =?utf-8?B?TWFlYTZBa2hkOExpZDdDNHNpcnBTbXZadnYzdy9ndStSVW55cW5wODBUaEU3?=
 =?utf-8?Q?5O1SWD904qM7xqrV/G0KJOnUL?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4793.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6c702a-e60e-4d33-cc28-08dad1dbd3de
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 07:32:10.8826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GWfQ4rKdEZ+X1TJnkyvC7XP7icf9/CMsAa8HGAGRTARix87fptdne2PTliJfD/2XjEHIkcvmi+RZJXQYxvU879BGu5vWQY4HBSIUxiumT+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5622
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCA3OjM2IFBNIEphbWFsIEhhZGkgU2FsaW0gPGpoc0Bt
b2phdGF0dS5jb20+IHdyb3RlOg0KPiBPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCAzOjU2IEFNIFRp
YW55dSBZdWFuIDx0aWFueXUueXVhbkBjb3JpZ2luZS5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4g
SGkgSmFtYWwsDQo+ID4NCj4gPg0KPiA+IFdoZW4gbm8gYWN0aW9uIGlzIHNwZWNpZmllZCwgdGhl
cmUgc2hvdWxkIG5vdCBiZSBnYWN0IHdpdGggUElQRSwgcmF0aGVyIHRoYW4NCj4gYSBnYWN0IHdp
dGggZHJvcCwgbGlrZToNCj4gPg0KDQpUaGFua3MgZm9yIHJlbWluZGluZywgSSdsbCBhZGQgdGhh
dCA6KQ0KPiANCj4gVGhhbmtzIGZvciB0aGUgZXhhbXBsZSBkdW1wcy4gSSB0aGluayB5b3Ugc2hv
dWxkIHB1dCB0aGVtIGluIHlvdXIgY29tbWl0DQo+IGxvZ3MuDQo+IA0KPiBbLi5dDQo+IA0KPiA+
DQo+ID4gQWJvdXQgdGhlIHNlY29uZCBzY2VuYXJpbyBvZiBQSVBFIGFsb25lLCBJIGRvbuKAmXQg
dGhpbmsgaXQgc2hvdWxkIGV4aXN0Lg0KPiA+IEJlc2lkZXMgdGhpcyBhZGRpbmcgYSBQSVBFIGF0
IHRoZSBmaXJzdCBwbGFjZSBvZiBhIHRjIGZpbHRlciB0byB1cGRhdGUNCj4gPiB0aGUgZmxvdyBz
dGF0cywgYW5vdGhlciBhdHRlbXB0IHRoYXQgZGlyZWN0bHkgc3RvcmUgdGhlIGZsb3dlciBzdGF0
cywNCj4gPiB3aGljaCBpcyBnb3QgZnJvbSBkcml2ZXIsIGluIHNvY2tldCB0cmFuc2FjdGVkIHdp
dGggdXNlcnNwYWNlIChlLmcuDQo+ID4gT1ZTKS4gSW4gdGhpcyBhcHByb2FjaCwgd2UgZG9u4oCZ
dCBoYXZlIHRvIG1ha2UgY2hhbmdlcyBpbiBkcml2ZXIuIFdoaWNoDQo+ID4gY291bGQgYmUgYSBi
ZXR0ZXIgc29sdXRpb24geW91IHRoaW5rIGZvciB0aGlzIHByb3Bvc2UNCj4gDQo+IEkgd2FzIHRo
aW5raW5nIGFib3V0IGEgY2FzZSBvZiBhIGZpbHRlciB3aXRoIG5vIGFjdGlvbnMgYnV0IHdpdGgg
aW50ZXJlc3QgaW4gYQ0KPiBjb3VudGVyIGZvciB0aGF0IG1hdGNoLg0KPiANCj4gaS5lIHBzZXVk
by10Yy1kc2wgYXM6DQo+IHRjIGZpbHRlciBhZGQgLi4uIGZsb3dlciBibGFoIGFjdGlvbiBjb3Vu
dA0KPiANCj4gd2hpY2ggdHJhbnNsYXRlZCBpczoNCj4gdGMgZmlsdGVyIGFkZCAuLi4gZmxvd2Vy
IGJsYWggYWN0aW9uIHBpcGUNCj4gDQo+IGNoZWVycywNCj4gamFtYWwNCg0KSSB0ZXN0IHRoZSBj
YXNlIHRoYXQgb25seSBhZGQgYSBnYWN0IHBpcGUgaW4gYSBmaWx0ZXIgYXMgYSBjb3VudGVyLCB0
aGUgcmVzdWx0IGlzIHNob3duIGJlbG93Og0KDQojIHRjIGZpbHRlciBhZGQgZGV2IGV0aDUgcGFy
ZW50IGZmZmY6IHByZWYgNCBmbG93ZXIgYWN0aW9uIGdhY3QgcGlwZQ0KIyB0YyAtcyAtZCBmaWx0
ZXIgc2hvdyBkZXYgZXRoNSBpbmdyZXNzDQpmaWx0ZXIgcGFyZW50IGZmZmY6IHByb3RvY29sIGlw
IHByZWYgNCBmbG93ZXIgY2hhaW4gMA0KZmlsdGVyIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcCBw
cmVmIDQgZmxvd2VyIGNoYWluIDAgaGFuZGxlIDB4MQ0KICBldGhfdHlwZSBpcHY0DQogIGluX2h3
IGluX2h3X2NvdW50IDENCiAgICAgICAgYWN0aW9uIG9yZGVyIDE6IGdhY3QgYWN0aW9uIHBpcGUN
CiAgICAgICAgIHJhbmRvbSB0eXBlIG5vbmUgcGFzcyB2YWwgMA0KICAgICAgICAgaW5kZXggMiBy
ZWYgMSBiaW5kIDEgaW5zdGFsbGVkIDMxNCBzZWMgdXNlZCAwIHNlYw0KICAgICAgICBBY3Rpb24g
c3RhdGlzdGljczoNCiAgICAgICAgU2VudCA4NDQ5MDU2IGJ5dGVzIDU1ODggcGt0IChkcm9wcGVk
IDAsIG92ZXJsaW1pdHMgMCByZXF1ZXVlcyAwKQ0KICAgICAgICBTZW50IHNvZnR3YXJlIDAgYnl0
ZXMgMCBwa3QNCiAgICAgICAgU2VudCBoYXJkd2FyZSA4NDQ5MDU2IGJ5dGVzIDU1ODggcGt0DQog
ICAgICAgIGJhY2tsb2cgMGIgMHAgcmVxdWV1ZXMgMA0KICAgICAgICB1c2VkX2h3X3N0YXRzIGRl
bGF5ZWQNCg0KaW4gd2hpY2ggZXRoNSBpcyBhIHZmIHJlcHJlc2VudG9yIGFuZCBwYWNrZXRzIGFy
ZSBjb21pbmcgZnJvbSBjb3JyZXNwb25kaW5nIHZmLiBQYWNrZXRzIGFyZQ0KZ2VuZXJhdGVkIGJ5
IGlwZXJmIHVkcC4NClRoaXMgcGlwZShjb3VudGVyKSBzdGlsbCBzaG93cyBpbl9odyBmbGFnLCBh
bHRob3VnaCB0aGUgb25seSBvbmUgYWN0aW9uIGlzIGlnbm9yZWQgYnkgZHJpdmVyLg0KDQpCZXN0
IHJlZ2FyZHMsDQpUaWFueXUNCg==
