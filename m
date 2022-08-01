Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5A3586B87
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiHANCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 09:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiHANCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 09:02:37 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E21205D6;
        Mon,  1 Aug 2022 06:02:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJncnmsOTuIlKoIo6khqM+HvQZh5/Kxu6X0RaVNz1jUCK/sKXgfEaZyf9zdBThCkOBQ2qvYkIem2+NM1urwmbrp0DlCZkLmpDXWIWV98ru9VpSsW/C+0aq3/EQl99MU95cyzTBBRCYxtCUif+iDBgBNxhN0dTW+AE0yfjdzqvYSDnL2IIkGfIgqg4y5oVRHy8qLMjR4l2NNEKDWh0myRNc/Gennooe7a9TR6pLDrjjBfIhr+LtWtxgsp0vmz/MBFthI+WZQIAAGOwFyGcyfs1T9iQwhVznqs+ufyJN5jQAMI21tqfatMRMX/XFmAqL0mku8qGuIpTUPQj/rw59jEtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5l/saffsFtHk39a6efbutMsXvbljNfj8duFl7ku4mU=;
 b=AnX+k1eV8xO31cKhflAfc/+9sLa15fuuO30Uqtl8vqIkHu/NuXc4mEUX0+CKG/+ZBe5xBIwl42oSASE1a1C8tkxEKQC7HO6Zz3EXo1CDlV5LiiHLRGIjsZQgec1dJ8JwBxpe5XetR/sJO1g11TWFLWH3mG1BTEYMuZXWenNQSthAO8qXxmCxUDIxdfv8uWP+9DLRhjY0Q7gA1Y+QLbr6oOGB46mEjuDnG61bqx1FhNKDdrlpt9Zh+129NAWhG5qUffgr7T2ibu+TfVoLaCdNmjJepPhd/q4tqPmgEBq1upGfwWF+egEQnM2WZtZbZv6qhpFq5SBJ2zHVmrLJ6C3+Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5l/saffsFtHk39a6efbutMsXvbljNfj8duFl7ku4mU=;
 b=QZuCTxSPeH59WoNMVkbv7wpk6+e+M29uM2GAOlCMwG93uTRA7oO7WlAnZ14fqZjQiHRyLlz3wqK/Xa6nSQBgVQc7myf3K55WCA602iavnmg+g6oq3vGPIxr7yLeShdW3/zUIKWwBxhwt0mN0R2lnDfsFrxr1Rk6lvX9elu5/TCk=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by MW5PR12MB5622.namprd12.prod.outlook.com (2603:10b6:303:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 1 Aug
 2022 13:02:31 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5482.012; Mon, 1 Aug 2022
 13:02:31 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>, "git@xilinx.com" <git@xilinx.com>
Subject: RE: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYo4KewBDB6DbmFk6t7/0QH3lPKq2Z7pgAgAAWHkA=
Date:   Mon, 1 Aug 2022 13:02:31 +0000
Message-ID: <MN0PR12MB59536D8BB90D66FE33BFAE0BB79A9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1659123350-10638-3-git-send-email-radhey.shyam.pandey@amd.com>
 <ca9a0357-676e-3eff-5900-7c5914cd844f@microchip.com>
In-Reply-To: <ca9a0357-676e-3eff-5900-7c5914cd844f@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1312191-e50c-40c0-56f8-08da73be185e
x-ms-traffictypediagnostic: MW5PR12MB5622:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uW9kvJGznMmgedMjZRTGyaix1X+nJYiUO6sWb2IIyws3DQgOOxFMaki9XXTn1+QCzh0I3lMP5ojGHuuWSn4hKfs0bhERk5hO1tRRhyRJdtR3H+uDzWan6ml14kqONjzm0vF9BBfaow55BUpW4xUzddUNtbKuFQJbCUooMc8TYKnZi9hLejExBkHdWQIJTHP9aC8ejDkwdLHp4kQ4ZdxGblwwQY9nFz2PQxCZlBHc2KK0lJRA+XPy3mqR0XM5Vetv5dM61wvMh7R15xmp9rHcq6jIA2VJxBGlM5mtgo2pP5em4wC2C7t5s3W8GyH2o/3HModXy+7khZVEy7uXgWBRrh3Ie8e+eclfLzn9KLak3yVgc87loWV09Xy+vYQb0LpdUDWLS0ac48ZDKg7HjazMPLyGxynC2x0e9C9BBKk6aiCkZA43AQHuNQ8M7HSDovNUUhjYVFO+W81rKE8CRY+KAHjunKuM0a7VlL09UDp30cDAeQ7TeO6LtfHDCvAxBKtiGoRDoq9YXZGfoJmALhN2usiRS0v2SVDj2GremLismU0iIjEDhnUGelmRlrQ0tT5+jSicMl8riZYj2s7t0FNK/83iKBoEJ/JseAKheyEwIsns+x8Yia0fkYS5pWfWiWlHq3SqzAJGyIc6aHggySjyPVaKxtyFp7gSH7bPbk5zsSps2+7UxLqA/ae/e1rlF9WZ9L0hVKS/0rHpEEwpE6+cTRNhtBZ3CUlGYe7IuAiGbCb7dsg8YDPlrnl/2QW0t51NF11Vt7zm2BIfpsAaPJ2K1QKpSTcDaPiUBMdB5Bzhh04=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(38070700005)(52536014)(64756008)(33656002)(186003)(6506007)(8936002)(5660300002)(7696005)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(53546011)(66946007)(110136005)(7416002)(107886003)(9686003)(71200400001)(478600001)(316002)(55016003)(76116006)(4326008)(66446008)(66476007)(66556008)(122000001)(8676002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWVCMFg4UVg1WkFwckxUVGtBL25sWmpGalUwdG05aFlMVDliNHhIZlhTdzVa?=
 =?utf-8?B?NHNyU1dZNmNwSnhCNDE5ZXVGenRPRTdrdmRuTnVQeEREbTdUTjhZWHVwRnNr?=
 =?utf-8?B?V2YyZk4rN3hPNE5VZFRwQldhemRrZlFXSUJEM0VvMjlESFVBYmpZQm9Xc3dq?=
 =?utf-8?B?OXd3UVQva3ZEVUE4aS9EQk1rTEdIR3Q4MVNRUXZBM2dVcytNazk5aFJUbGc0?=
 =?utf-8?B?bTNRcjhGTHRYSEx4THkvNkZKZ1dta0t6MmNrVkdhVFVJYjhJNjdSem9DVnIr?=
 =?utf-8?B?emNITUM1VHpJRVV1WFVDOTBpc3F4Q2F2R0pLTFpSWGlLZzUrY0xrOWF2L0lC?=
 =?utf-8?B?NXVXd3ovTDFqUjNLRjFlemRzZC8vWEN3VVE3VHU5YlV4MFdJZ0hKM2lEbDFR?=
 =?utf-8?B?ZmdhbUh5d3Z3S1NnR29rRnM1L3A0L01hTDE4VzR4OFVMc0prZUpsOFlFalZy?=
 =?utf-8?B?NktRV2NZWnpZcmFOZlV0WVNUUEx6Z3F2N01TVGI0VFFySmMyZnJVKzREdVE5?=
 =?utf-8?B?YStQSUlzdy9YUngrT1F0cFkrcDZMVFZTcnc5RGpQVGhmVjQxTmwxdG53Nkx4?=
 =?utf-8?B?dWlHNHVmSDhyYzUzb0NEditLYjNhZllEVnVLV2U1UFArelpSelhQckZZN0Zi?=
 =?utf-8?B?NUhxUHNwTE5JMnlNb2JoQmFNQ1R1QUFmbEVBVVZwQ21LMHZWY2tGVkdCWVlU?=
 =?utf-8?B?TThQSEZiVTh5WFZvSXJJNnBPWXJpQmN6Y0h6S3pvWkV5YVhsY21TbSttd3BC?=
 =?utf-8?B?WmptcHVpV0MrR3NiVXJYYkFKRlJ3OXZtWllIYTZ4MDFxTXY3cG9tQkQyTFAv?=
 =?utf-8?B?bmMva09OZThhTkltVXlJZEhYbTV0QnN4TlZrNnFFVXYwcXovczBTNjA5aW00?=
 =?utf-8?B?dWtWZ1hDVmg1NnZidnJKWXVVTE16ZDNDaFNvQlMvMmdrcFNyMHBZdmlWWFdq?=
 =?utf-8?B?anhsbmhPa0ZzcllDWWhBNVlXWTFWVVJZSEMyb1RIT0hUUVB2U3Jzb0NQRHV2?=
 =?utf-8?B?MklNOWJEb1VZdU9BM29GV2daMlJyd0FRY3ZzbmtUOUlQZ3VVQk9ha2RaUkVp?=
 =?utf-8?B?Y1FabzY0NCtOTXBxbW9CQXFYblh3WE8wUkh6UDhCbnN6czBTbFlPckd0andJ?=
 =?utf-8?B?N0M1Z3lkbHQ0YlFnYWZPaTBHK25MSlFkMnlMcERlSTRnczFiSlRUbFZoMHFM?=
 =?utf-8?B?MGdyTElOeXp6MCtYOW5wZXF4QjZKRHJoVHpuZnF1dG4rUGpCQ3c5dk13WVBT?=
 =?utf-8?B?bE5BN2s1ZmtqT2NuazJ1czhnZzZSUGtsRnBRZG55OGxBTmNCUXNFV2R0R1oz?=
 =?utf-8?B?bmtqZm52ckpZbW5md3VtQ2RDQ2JRRXEzNm02czFwQllJMk5McnBFTDVjMDR4?=
 =?utf-8?B?b2lRYVpkT0ZxZlBoVzJNZFNNYnptcDNTblcrTThDNU5RTjdnWElpOEIrUE1C?=
 =?utf-8?B?K0F3NlpDRGplN3ZZcytoczhmR3NHYWtCS0JiMy9QV3p2U2pUSUtheUVHMkM0?=
 =?utf-8?B?RTFCN29YRjJwRG5oYUd1SzhCaDVBLythT01kOG1yWnRtSlIyQTdwZ3lXUmpi?=
 =?utf-8?B?L2h0eWxDU2FEemF2YXVtNkdoQ2tvb3hMblUxL2dwb1FaRWFwSkI3aXl0bi9C?=
 =?utf-8?B?K08zdXY1aVZ6ZUtiYlBLazU3UzkwamlHbE1OY2ZBL1lGYlpEaVIrVC9sQXZ5?=
 =?utf-8?B?Rk9WVkwvOWhCS3cxR1U3b3RoUXVoa2NaUEFtOXZqUFc5TG1VMmN5cExmZnhU?=
 =?utf-8?B?YWEzdXpzWDFlT2Y3N3Q2SWZBc0c3TGJFaEhwdHphUURtdlRKd2hrK2RiQW5R?=
 =?utf-8?B?S1crWERXSXN6NmZBdGtUcFNrSFNUMTFBSGRDN3RLYzkvdHlzRTBHejZpTC90?=
 =?utf-8?B?T1I1Nmh6SEdUdFlYR3RPWVBwVlNMUzhJZzdzV1V5bkZNc1Q1RGZuQVNRcFlB?=
 =?utf-8?B?bFZTSlpla21qSG94cy9NaVBiMFkwRzViZ2VyeGh4aVBlL2h6ajM4N1oya2FY?=
 =?utf-8?B?UkV0ZVEwVmZwYndGUnN5WnpIZnVpYUpMVlE0VktYWDF5eGNWa0M0RGxvT2VT?=
 =?utf-8?B?OHBvL01KR3Eyc21kaWpNVmlWSXJuQVhyQlNQM3piWjZFUXlFV3hvaHdCa3pq?=
 =?utf-8?B?R1h1Vk1KZ3M0TjQxckd6TjBIZ2JnK2ozSGRFd1BsVXJaL1o4VGYveFNMdjdZ?=
 =?utf-8?Q?lyB+4f2aO/L4IJuOEr9Jlds=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1312191-e50c-40c0-56f8-08da73be185e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 13:02:31.6006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97icgT/QEYNrzXC+lG2j9H+n75679+y14qV6j8HeN3zzJQPvN4d87jR7z+1AmmgM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5622
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDbGF1ZGl1LkJlem5lYUBtaWNy
b2NoaXAuY29tIDxDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tPg0KPiBTZW50OiBNb25kYXks
IEF1Z3VzdCAxLCAyMDIyIDU6MDYgUE0NCj4gVG86IFBhbmRleSwgUmFkaGV5IFNoeWFtIDxyYWRo
ZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+Ow0KPiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgTmlj
b2xhcy5GZXJyZUBtaWNyb2NoaXAuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpl
dEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyBncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZw0KPiBDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZy
YWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBnaXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNvbT47IGdpdEB4aWxpbnguY29t
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgbmV0LW5leHQgMi8yXSBuZXQ6IG1hY2I6IEFkZCB6
eW5xbXAgU0dNSUkgZHluYW1pYw0KPiBjb25maWd1cmF0aW9uIHN1cHBvcnQNCj4gDQo+IE9uIDI5
LjA3LjIwMjIgMjI6MzUsIFJhZGhleSBTaHlhbSBQYW5kZXkgd3JvdGU6DQo+ID4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdw0KPiA+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gPg0KPiA+IEFkZCBzdXBwb3J0IGZvciB0
aGUgZHluYW1pYyBjb25maWd1cmF0aW9uIHdoaWNoIHRha2VzIGNhcmUgb2YNCj4gPiBjb25maWd1
cmluZyB0aGUgR0VNIHNlY3VyZSBzcGFjZSBjb25maWd1cmF0aW9uIHJlZ2lzdGVycyB1c2luZyBF
RU1JDQo+ID4gQVBJcy4gSGlnaCBsZXZlbCBzZXF1ZW5jZSBpcyB0bzoNCj4gPiAtIENoZWNrIGZv
ciB0aGUgUE0gZHluYW1pYyBjb25maWd1cmF0aW9uIHN1cHBvcnQsIGlmIG5vIGVycm9yIHByb2Nl
ZWQgd2l0aA0KPiA+ICAgR0VNIGR5bmFtaWMgY29uZmlndXJhdGlvbnMobmV4dCBzdGVwcykgb3Ro
ZXJ3aXNlIHNraXAgdGhlIGR5bmFtaWMNCj4gPiAgIGNvbmZpZ3VyYXRpb24uDQo+ID4gLSBDb25m
aWd1cmUgR0VNIEZpeGVkIGNvbmZpZ3VyYXRpb25zLg0KPiA+IC0gQ29uZmlndXJlIEdFTV9DTEtf
Q1RSTCAoZ2VtWF9zZ21paV9tb2RlKS4NCj4gPiAtIFRyaWdnZXIgR0VNIHJlc2V0Lg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRl
eUBhbWQuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
DQo+ID4gVGVzdGVkLWJ5OiBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29t
PiAoZm9yIE1QRlMpDQo+ID4gLS0tDQo+ID4gQ2hhbmdlcyBmb3IgdjI6DQo+ID4gLSBBZGQgcGh5
X2V4aXQoKSBpbiBlcnJvciByZXR1cm4gcGF0aHMuDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAyNQ0KPiA+ICsrKysrKysrKysrKysrKysr
KysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKykNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ID4gaW5kZXgg
NGNkNGY1N2NhMmFhLi41MTdiNDBmZjA5OGIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gPiBAQCAtMzgsNiArMzgsNyBAQA0KPiA+ICAjaW5j
bHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvcHRwX2NsYXNz
aWZ5Lmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9yZXNldC5oPg0KPiA+ICsjaW5jbHVkZSA8bGlu
dXgvZmlybXdhcmUveGxueC16eW5xbXAuaD4NCj4gPiAgI2luY2x1ZGUgIm1hY2IuaCINCj4gPg0K
PiA+ICAvKiBUaGlzIHN0cnVjdHVyZSBpcyBvbmx5IHVzZWQgZm9yIE1BQ0Igb24gU2lGaXZlIEZV
NTQwIGRldmljZXMgKi8gQEANCj4gPiAtNDYyMSw2ICs0NjIyLDMwIEBAIHN0YXRpYyBpbnQgaW5p
dF9yZXNldF9vcHRpb25hbChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+ICpwZGV2KQ0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJmYWlsZWQgdG8gaW5p
dCBTR01JSSBQSFlcbiIpOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gKyAgICAgICByZXQgPSB6
eW5xbXBfcG1faXNfZnVuY3Rpb25fc3VwcG9ydGVkKFBNX0lPQ1RMLA0KPiBJT0NUTF9TRVRfR0VN
X0NPTkZJRyk7DQo+ID4gKyAgICAgICBpZiAoIXJldCkgew0KPiA+ICsgICAgICAgICAgICAgICB1
MzIgcG1faW5mb1syXTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIHJldCA9IG9mX3Byb3Bl
cnR5X3JlYWRfdTMyX2FycmF5KHBkZXYtPmRldi5vZl9ub2RlLCAicG93ZXItDQo+IGRvbWFpbnMi
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBw
bV9pbmZvLCBBUlJBWV9TSVpFKHBtX2luZm8pKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHJl
dCA8IDApIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBwaHlfZXhpdChicC0+c2dtaWlf
cGh5KTsNCj4gDQo+IENvdWxkIHlvdSBtb3ZlIHRoaXMgdG8gYSBzaW5nbGUgZXhpdCBwb2ludCBh
bmQganVtcCBpbiB0aGVyZSB3aXRoIGdvdG8/DQo+IFNhbWUgZm9yIHRoZSByZXN0IG9mIG9jY3Vy
ZW5jaWVzLg0KDQpPaywgd2lsbCBtYWtlIHRvIHVzZSBvZiBjb21tb24gZXhpdCBwYXRoIGFuZCBz
ZW5kIG91dCBhIG5ldyB2ZXJzaW9uLg0KDQo+IA0KPiBBbHNvLCBJIG5vdGljZSBqdXN0IG5vdyB0
aGF0IHBoeV9pbml0KCkgaXMgZG9uZSBvbmx5IGlmIGJwLT5waHlfaW50ZXJmYWNlID09DQo+IFBI
WV9JTlRFUkZBQ0VfTU9ERV9TR01JSSwgcGh5X2V4aXQoKSBzaG91bGQgYmUgaGFuZGxlZCBvbmx5
IGlmIHRoaXMgaXMNCj4gdHJ1ZSwgdG9vLg0KDQpJZiBwaHkgaW50ZXJmYWNlIGlzIG5vdCBTR01J
SSBicC0+c2dtaWlfcGh5IHdvdWxkIGJlIE5VTEwgYW5kIGNhbGxpbmcgDQpwaHlfZXhpdCBzaG91
bGQgc3RpbGwgYmUgZmluZSBhcyB0aGVzZSBwaHkgQVBJcyBoYXMgYWxyZWFkeSBhIE5VTEwgY2hl
Y2suDQoNCj4gDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+ZGV2
LCAiRmFpbGVkIHRvIHJlYWQgcG93ZXIgbWFuYWdlbWVudA0KPiBpbmZvcm1hdGlvblxuIik7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiArICAgICAgICAgICAg
ICAgfQ0KPiA+ICsgICAgICAgICAgICAgICByZXQgPSB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWco
cG1faW5mb1sxXSwNCj4gR0VNX0NPTkZJR19GSVhFRCwgMCk7DQo+ID4gKyAgICAgICAgICAgICAg
IGlmIChyZXQgPCAwKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcGh5X2V4aXQoYnAt
PnNnbWlpX3BoeSk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4g
PiArICAgICAgICAgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgcmV0ID0genlu
cW1wX3BtX3NldF9nZW1fY29uZmlnKHBtX2luZm9bMV0sDQo+IEdFTV9DT05GSUdfU0dNSUlfTU9E
RSwgMSk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChyZXQgPCAwKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcGh5X2V4aXQoYnAtPnNnbWlpX3BoeSk7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAg
ICAgfQ0KPiA+ICsNCj4gPiAgICAgICAgIC8qIEZ1bGx5IHJlc2V0IGNvbnRyb2xsZXIgYXQgaGFy
ZHdhcmUgbGV2ZWwgaWYgbWFwcGVkIGluIGRldmljZSB0cmVlICovDQo+ID4gICAgICAgICByZXQg
PSBkZXZpY2VfcmVzZXRfb3B0aW9uYWwoJnBkZXYtPmRldik7DQo+ID4gICAgICAgICBpZiAocmV0
KSB7DQo+ID4gLS0NCj4gPiAyLjEuMQ0KPiA+DQoNCg==
