Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF7F543FC2
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiFHXIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 19:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiFHXI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 19:08:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3761828729;
        Wed,  8 Jun 2022 16:08:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRllETfM4Eo3YxWofpzJocbJzdPqWyWJzQ5W01gS9zISkFwK5h0JjY7Abg+IexnNlyq/ieFpNQb7a3r4X/yEI3TTQ2eat5/iiDtaUaWBzR8XXTwY9Pt3U6KshrL+nAHUJ2kGO2pfOlqWtJ4tHwlfP3wU6/vZEP6drgS5IfpIOSnz5TOG/dOGsb7aAxG4yy4ovZKblksIjXdFTYn6pyFcCCcgaQfS2cas7Gj9sMsKbJ1rhcTjGOBAmAnlgQH9O0gYzXA2Nxh+YQ7Hzy/j5tdx4iaKV65JGqN8TzD9QnRl/oCvtZhAA9ojfk+e4M+fP2IPbqF18/XjE2AT2q+I6G3HBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MhtxLr35vBmznhX+Z04U48TCfza6NCdp7HzIom4eOw=;
 b=oL1IZzxLuTyDUR6a4cFt1WC+9RJcbX4XsBl1z4Ulm95H6te2w8+IdQXjK6/wuBy39AISLgYWhh3+E4BdYWQPzTy7MhqEDlypiirSII3jQ+8qyKwLy78Bc2ovv3exQZXYf69t3nP+y5fKPH3LUDK7+GbJT3E0+RYazmJu18JmMSrE2PjAcdFKKEsv9TcppiHwaWRw65H8hAh90aQf2Mk8wL2Mq9pDV5cOq1fYZRFSV32nCjdvLzqF7N7tWaA5B5octaiJpnb0cUBKvv5byanH0E7eRdcKIdys8AlfHNKFI1AOpnprrrEkh40Ks7CLk6nenhdnLejIL50g6U5iVEWtYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MhtxLr35vBmznhX+Z04U48TCfza6NCdp7HzIom4eOw=;
 b=xpHfJcVA7r/j1uCGnjKABkTXVlqC9zCzfeTpqn+Cba75+GihezKUzVhn/Bd3Koh4jZYnUi5Xsctk+eboGk9zvX9lIUc6r8xETwveigotJj9dloWviXYVB5tVyv2EHZqv3lqZ6Pds2mUuhvgRm/ZvmDfCA43n/fmFld4ccYotpnU=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by MN2PR05MB6126.namprd05.prod.outlook.com (2603:10b6:208:d2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.10; Wed, 8 Jun
 2022 23:08:22 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::98d8:6172:e1e8:dc86]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::98d8:6172:e1e8:dc86%5]) with mapi id 15.20.5332.013; Wed, 8 Jun 2022
 23:08:22 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 5/8] vmxnet3: add command to set ring buffer
 sizes
Thread-Topic: [PATCH v2 net-next 5/8] vmxnet3: add command to set ring buffer
 sizes
Thread-Index: AQHYekr8+R7wHXJybEKxBTk0fLgxmq1EqK8AgAEGrYA=
Date:   Wed, 8 Jun 2022 23:08:22 +0000
Message-ID: <A1A204A7-87BD-40F5-A2F9-447224285AB9@vmware.com>
References: <20220607084518.30316-1-doshir@vmware.com>
 <20220607084518.30316-6-doshir@vmware.com>
 <20220607172812.489814b9@kernel.org>
In-Reply-To: <20220607172812.489814b9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.59.22031300
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e9852d9-790d-40f2-3eba-08da49a3c906
x-ms-traffictypediagnostic: MN2PR05MB6126:EE_
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <MN2PR05MB61261E142444D82EA129A2E1A4A49@MN2PR05MB6126.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bg3aw7vCCf8oDzSFOvOcDd3q3PEk+f9sevId+Y1gbCnE0wb7bpAgNuZ+IQGEiJrZ+JxCTXOKu5tMXYLPDmEL4iDGoyR7GvBxHqlmmc/rwRzuM0sXyexV9o+EI1d5QDixk4kgWLM7yGluMZLR2u3oP1KxUgIQq+uulhuRxswWOgDmlH9rBDxu5eAhj5DztU7pBXq+uBCm86U+iT8nv8cPn6G0xMwm8e64tr1km+jkaBxAqYZrWJct5aNvRdUfd7/CVHcoCZezaQxpGMiAX6bd/g5ngBVbl/7Zlzf8q0sRvfwtL0G/+8cybtpZkHr7I6zcyxNTd0cwCAkDR2tI6+/mK/RFSx0RxHawPofzftoqvFsM4iaD2WRStr2e4TDCS7i6cp5YAzqjurFqnMEiDQoA0r0U0JiSlWxBOJW64F+3a42fYPlzWo8ZHnN52dKtJ/ZZn+V/fdXgd9DrNcsgOoWZi0Tja18e9lwBSJbfrLfczkG5nXX96UTXCAikNv2jyNOIgNF5ipDurU4Kvpmo31hmFidJutXUxhKDcYTnF0n7RwrJBkP2PZoOJXbsyP6Pqz8BeJo+K5mKZ7/66D5hzHCDPdGTmKZHFEGDnmhmzkmcnJoqnuCb6MuTaJS5rFjIH1m+87opHZGeAeLme/gam6g6wpWrPYxLRsJl4Q0kOlQliFFn0njlzMMW4Kdy0fZLMNHUiqOECMvs1qQpeea+MgXq1uIQwfbwwiyNbfoiEP8awH3Lv7kbmsDfJ4y/3GHQb0zF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(86362001)(186003)(122000001)(66476007)(4326008)(66556008)(64756008)(8676002)(76116006)(6512007)(71200400001)(66946007)(54906003)(66446008)(36756003)(6916009)(316002)(5660300002)(8936002)(4744005)(38070700005)(6506007)(2616005)(6486002)(33656002)(508600001)(2906002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEdIRUcxSllDWGNiNWVCQVo3MnJSay9RNXFRck5LOEhaM3BKRk9RQVRtK3Jq?=
 =?utf-8?B?RExUV0tTTTdFMEwwOW5VRWNabGgvaHhBU3drbUI3UVNobnZnSXdjN25VTFpq?=
 =?utf-8?B?a0FDN1RRVmNXOXdXNHk2WWgxeVdEd0F2dHlzZU04bllXYzhmckczdnpOaE5w?=
 =?utf-8?B?T2lXeGpmMWtKc1hZNU9YZTlPTGtkQ0JjamVVcjlOUWVKZHY0Q2hoODJTRzli?=
 =?utf-8?B?S0NCTy90WitZWGR2amhkWEQ1UzhZQUVVMVRXS1lWWUJkZ29Vc1dhblppbGZ0?=
 =?utf-8?B?UWExU3B3anV2b1plVGR5cVZUdjhmUHROckpzV08rRHR5WkhKaDJJQ3BLWnZq?=
 =?utf-8?B?dUJGRHh5OU84OC82dDhhaVZQOVhPSk1yY0MyTEJER0tUaFJNQzNTdi9LQW5W?=
 =?utf-8?B?cVpRTGFRaCtDb2lhQlFsREJDQXBkcWdKbWlCSE83N1RsYlJXOWQwRWxKOUU4?=
 =?utf-8?B?RnNJSFA0T1RBdGtHRlJxbU9qM0RrUUtkR1ljYXpLR1U2Nm5SejMxY1IxZmdi?=
 =?utf-8?B?c3J5MWJ1bkpPTkNFYXg0QVFqbGpCb3pXT3RHQWNWRXhXclpNSmo2WEM3emVN?=
 =?utf-8?B?ZTVtSzR3bU42UXFhTGErNUVSTEZmTi9zVUtrcmlHZzFpQm5xVGY2M0k0V3pF?=
 =?utf-8?B?RWloSjRoQi9XRmRzVkhkZHNhZVdpRVlVL0cxbUwxNm8vSEwwbGs2Q1Rld0dK?=
 =?utf-8?B?VmMvL2JrYWNvTzhCYzZYd29nNG5ielFSRTZuTjN6aHM5QkpXTWg2b0NzcHha?=
 =?utf-8?B?NkltYWJLZnp3d2pnOEdFLzU5TjQvMmhtd3lKbDFVRUd3a2NzRU5NMFBhVWlh?=
 =?utf-8?B?YjJSZUJKRnFFOE1YMUZaalNPK1dNRnZZRVluYmU2WWFINkFvSlcvZjZFaUYy?=
 =?utf-8?B?UVgySnhGU1AyMmIrUExzVytkVHZ2QUFkaFQ2Y0Zsa1hRTVYvSE1tTThYMEIv?=
 =?utf-8?B?ZTJ2T3hBT092TUsxUkl6NWo5QzRGcjJjdUVsc1dHQmFlUHdFVDFLeEVTcWJv?=
 =?utf-8?B?R0Y2K3c2RzhyOU1mSHFpL09WeXNUZTMzVlRxa0hrcTV6QlhJRk1jY01VTDI5?=
 =?utf-8?B?aXZWVHFhdVYzTldrWjhVNU55Rkk4UHVhU2VHSlVEb2tKd3FpQW4rckR0cFlO?=
 =?utf-8?B?TUxHTE5GVHlqd2RkZXBic2toM3hhbGFtUFMxM3JhRWxwUjJVSWwzMmlkTHdW?=
 =?utf-8?B?Y1dMR1FJMGVLRFNtY3FxQ2dFaGh3RmtNaE0zRFI0cXBka2x3c0hLM3lQQlBI?=
 =?utf-8?B?T0hIOE5Hd2FyRkg5UmtZbFFrYXlFVzBNZGwwTkdKMGVRNUJTZkFVUjFZZU5I?=
 =?utf-8?B?VFJOMnBDaU02VDNOTDYzSE1CVlVmNGFuNjI0c0x3QVR4TDIrSTRJVEpFYzJ2?=
 =?utf-8?B?OHY0OWY3UmtSWlFrOGIzK1JrZi9kS3FnQ21aS2ZnZmFhRUNtNnB0VmxXWUZC?=
 =?utf-8?B?UDdkSzhpZmNTZ09iS2pQNnlSSkRpVUJudmJBdnhEVWl1SDZtczBkNVhHMU5v?=
 =?utf-8?B?UnhkeFJRQ3JZVVkyaUk3ZnJCMlNUMXFsUXlDa1dWRm5vRVdZRTN5NVk1Mzdq?=
 =?utf-8?B?aEprVDFUYXpqVkJUcUxuZmhyV0wwZ25RRkprWGdUN2JxZWVhRndKTXpVT2Q5?=
 =?utf-8?B?WFFnRnRRNjY1cnBOdXNXRk9uZGVBY0V3YTVZVVhpUU9YbEFrZnRsdWp3Qjk3?=
 =?utf-8?B?RXc1aVlIT1ZETWtpQTg0cXRnK0ZjRkdJOFBJS1RMclVLNGJqNU92bGxJWjRQ?=
 =?utf-8?B?bVRaTUlzbkdweWJXdG13bHBqODlPb3ZpdmtZVjdSUFR3M04xeDN4Mzc2Nm9y?=
 =?utf-8?B?L1ZOYkxKVy9JK2dIM1RzSEhRbkdidUZaRWViSFhNLzkzYmZmSmpVRlpxcGYr?=
 =?utf-8?B?QWRHRWp2cXhSakVOaWFLYWdmajlrTytnMGlCTnoyRVFndldLWVY0MGxCVS9a?=
 =?utf-8?B?UGx1SUtIbjZRUWhXTkxDeWgyWnRudkVydldTZlVzN2VCYjBkdklvd0tFQzEv?=
 =?utf-8?B?YkhkMVFxRlZlUkMycU1kb3plamhuaVRBOFFCOGJUR2daeStCWDkrOGFGRktK?=
 =?utf-8?B?T2hIK1pwTmdReTVGTU9pVkE4N1dQQnJWUTFoYXR3ZjY2cDZvMnphRTBnRTFK?=
 =?utf-8?B?UHF1QzlabjlOUE9kNkRrVzUxbmVMOG5NNGFGbGdzMldoZlhuTXpEay9aMFE2?=
 =?utf-8?B?cDNqNUhrVWNjTnMwVWVEUkNWbys3S2p6dHBRc1p1YzJCa2M4a0Irelp5SHJw?=
 =?utf-8?B?ajVsQTgwa2MrUm03SHk5WGlHTlF1SDZuS0k1OGZmMGxobndpaktIZHM2RHlF?=
 =?utf-8?B?d3VVZDkvSExIK1paclBtQkZ3RFV3SWZqQXV6SVZ3U1A0TUgwSzk1c2pGSnJq?=
 =?utf-8?Q?DFCCuNpUqZ8fYqCw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE81DACAAE02214AADD0C042EEEC1075@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9852d9-790d-40f2-3eba-08da49a3c906
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 23:08:22.6848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rmAR4JfF96HqJ7fiT3hFnIsKhDcS3MVNWL5FsQb2j7St36XFO8f/S2LHBuUqYn47aB1BQAmu9BU4HMUdl7uJcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6126
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA2LzcvMjIsIDU6MjggUE0sICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9y
Zz4gd3JvdGU6DQoNCj4gICAgT24gVHVlLCA3IEp1biAyMDIyIDAxOjQ1OjE1IC0wNzAwIFJvbmFr
IERvc2hpIHdyb3RlOg0KPiAgID4gKyAgICAgICAgICAgICBhZGFwdGVyLT5yaW5nQnVmU2l6ZS5y
aW5nMUJ1ZlNpemVUeXBlMCA9IGFkYXB0ZXItPnNrYl9idWZfc2l6ZTsNCj4gICA+ICsgICAgICAg
ICAgICAgYWRhcHRlci0+cmluZ0J1ZlNpemUucmluZzFCdWZTaXplVHlwZTEgPSAwOw0KPiAgID4g
KyAgICAgICAgICAgICBhZGFwdGVyLT5yaW5nQnVmU2l6ZS5yaW5nMkJ1ZlNpemVUeXBlMSA9IFBB
R0VfU0laRTsNCj4NCj4gICAgVGhlc2UgbmVlZCB0byB1c2UgY29ycmVjdCBieXRlIG9yZGVyaW5n
IGhlbHBlcnMsIHNpbmNlIHRoZSBmaWVsZHMgYXJlDQo+ICAgIF9fbGUxNiBwcm9iYWJseSBjcHVf
dG9fbGUxNigpLg0KDQpUaGFua3MsIGZpeGVkIGl0IGFuZCBzZW50IHJldmlzZWQgcGF0Y2hlcy4N
Cg0KVGhhbmtzLA0KUm9uYWsNCg0K
