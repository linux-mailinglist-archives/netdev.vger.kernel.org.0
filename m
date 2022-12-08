Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8A9646E31
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiLHLOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHLOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:14:50 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71363F05B;
        Thu,  8 Dec 2022 03:14:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STWChbyT3udjy6w/9Of7dI7HLhX5yXghCOab68NjKX40PefejPVhIfdkOev6Iuc/notQVyPwNDTAsJufWaz3eaWnhguV+iv2CFnVEV8wpX0fKi5Vf1JWWLNLYs3VXSgKShsD3fPlsER+eZz+0WZto0TPh0BfP4L/2073/iBboG3v/idloey2xfoCQ0rjF7eZr1qAokr9nXPXTrqb1jUdKF/dlIevWKyRBLr6Op3U45kFZIBsKo1jvYYc8sZHlal/HqeZINxu+SNEN8b2OfTBWl7nBKiVQqU7yfqh8vEfcO/NF9C44+KHLi+iFg/nBVawWdyifoqDdM1ckAvHdLC24A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29F4+XveJU2QEFPvoP23ot5Wk7UVqUXzp5WVPVimeyo=;
 b=hBVIUIdZkBBkUj70FvF4OALAxPt1eKzSDis4z4HXpokkS5onH2LtT3TDDrN8R8zAKdChp3VurtyE2LoSCZyhTrIH8gVkvyMPn7+xIW1tHHc9BDF7ZrqMyQ/p3x2WmkDeapjmpF2YfZKj340nMp4SC8EswNz6vNUf+KRh3Ec5uzylipkaN+ddi1HY7qfXM4DeHVqITbKKDLcoUv+C+plTIPIvFYC2BkdhvpwXGr/FM73kZnk9zxxLbK0u6ZUVonIf0rpv2Udsh2UiIJj5KSMViSuXZgW95xrWsLxhdh/VvOzXHDAot7oN7i7fG0vYpXQcKItsiiq8RI2haqRNOHq28g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29F4+XveJU2QEFPvoP23ot5Wk7UVqUXzp5WVPVimeyo=;
 b=QM6Z4KuOiSHyJLu0bS3SkMpPKngYQKECK52oy06uF3d6anDstMeBhe4CFcSg4PZoURHWMHfMPjq29CunO1jWws8j31JPhz+WmrbfcqqAbpV7g6Dyzvhh0OhcQZJdc8EAgdsicD4OWhh7GfceXXc91j65COHj/OzfH93Oi2wG3K4sIW2Cr6I7x1/Km+ht20zL8/K6aiySuoNEWRBrWkQlPrVddUX6x1dtFcj9O006MNxHPv72+d5ojXsJJ1E9t+5FV+QFVR5zIZbqtgATHNbozUtd1CEMSCVz2/nYF2sEl8MZ1k+4Wtyr3hqrU7igqnPyto7bkflfU0+AzUR86cFYXQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 11:14:46 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 11:14:46 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZCiQusL+UzHu/8U2fyvKlL6owS65ikZoAgAAA31CAAGjLgIAAki4ggABAgYCAAAo3wA==
Date:   Thu, 8 Dec 2022 11:14:46 +0000
Message-ID: <IA1PR12MB63537D0D08860A9BFB223E42AB1D9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221207101017.533-1-ehakim@nvidia.com> <Y5C1Hifsg3/lJJ8N@hog>
 <IA1PR12MB635345D00CDE8F81721EEC89AB1A9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <Y5ENwSv4Q+A4O6lG@hog>
 <IA1PR12MB6353847AB0BC0B15EFD46953AB1D9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <Y5G+feJ65XlY/FdT@hog>
In-Reply-To: <Y5G+feJ65XlY/FdT@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|IA0PR12MB7674:EE_
x-ms-office365-filtering-correlation-id: 6a9da171-2ae4-43e4-dff4-08dad90d6a50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bnhA2EJKKbNt7lwZXfaai421iL1nde7YMpy5ds86h8RfLW1S2atvZV8VmJFiORcIxFOb7v9M8962ycV9Uz52W6VUXNoI8oKuxUxztiPcqyO9hqoPeNss3mJdE+o7fjuKVNR07VhJXld6f1WWJj7PJvFHuaoVGpil9DL7q9+4+0jfn2WZLmTdF1m45NS4XCAuipsjsLH15SfmPx+b4kOn3LbxsBh2/353XIbm9BBsXzixSdOqnWzK5nEYads23uIODBUjvJPWLm+cnM804hg3Q6Vczba4V/KC2C7mfFrYB7LlUtZkOHK1Log0gIrS4SgajTveH/cBloYkfNbg87ax+HCxBaTsUw11SNHkBs4SxU8SSaXGki/GdQ4UyCMTBrp+OhC8yWcBAsyJ1X2axKORo3Wqw125SCKu/md3nrpWX4hr6gWQzoUSo5rJMcbnhzVBjy9Bdm2W2AWHp+p22TMW92WsUTykJ0DBc0YaG9ORe9OT2neyE4n9yw2Ot3PBm3yLpOrt9fa46BAuZha71BHnW+/duAij3/FXo1r2/+Fv6kg4uwyHiGK4gBmxqFzVsjQECNEyCrEOOYhd5y0LvB92apx65HDmyvmdsyFcWfk4PCc34toYjBRNaeJqJpm875atLsez8Xn37HQwFVoVxbJ2LAuJb6pcZn3nv/OtSX3DDKkEE4J0+7wETXO00iPMY+IMz2rTY8zyPrgkdhow0mXcpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199015)(76116006)(478600001)(38070700005)(66946007)(38100700002)(66556008)(122000001)(66446008)(4326008)(8676002)(7696005)(66476007)(64756008)(2906002)(6506007)(33656002)(316002)(54906003)(6916009)(55016003)(71200400001)(86362001)(53546011)(83380400001)(8936002)(5660300002)(9686003)(41300700001)(186003)(26005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekdNZE5LNlVzWDFMTjBXcE9IY1k0T2dFNC9laGltVXB4TDJyTFVFK0ptYlBi?=
 =?utf-8?B?YzZSWlNRVisvZzc1Y1RSejE4TUgvdVN1TStFYXhVckVsVHlQRENwUGtiVEVH?=
 =?utf-8?B?RVlsaDh0ZGdZQ3g3LytWYi8xUndzQjI0QkUyNEVlL0h2WTZMaXZVd3Q1SUJJ?=
 =?utf-8?B?QklkZGo2OSt5WVA5SVRWUEhxZFgvZVhPazYxc004bnFkWWpveXYwQks4eWx1?=
 =?utf-8?B?dWpFRmczQzNQb09qdVM4TURpMEY5MWp2ZUoyTmtZME9KUWZmNjMwd200VVdQ?=
 =?utf-8?B?Qm45YXNtNlhFUi9wOFp6dTZ0TGhZeldvcEpHZDArc0dNWlVhZ09FK0xiUU91?=
 =?utf-8?B?ZGZBSy9vSGIvWjdyNHIyZmZ0Smc2b2pzbm9QajhIQ1VLeFhmOGVjQVcrdFdj?=
 =?utf-8?B?K2ExNnVNdW9GL2lGcHdVbGFKa3AyTlRBUzRScTU2YlJUdEU4TzFwNWNKdFBU?=
 =?utf-8?B?TEtrMnk0S3JDSzkzS2hhekpaUElUZGthbkhnNXlIVDBpRmtTTmV4S3hMMDgr?=
 =?utf-8?B?RDU0aFJLZTZnVGphTDlrTDEvckxPWk95QnZONHoxVXN3RjE3Z05JcmwrM2Zt?=
 =?utf-8?B?S2R2MElDazhHeWdRS3NLYldaOExiRDlrVDZKbHJ1KzNkMC85UlRiOS9WaUVw?=
 =?utf-8?B?RnBaZW9BTnRrL3pRZzByRjk0VVVFMjdQdkxNN2VUc3pJQ2ExU2kwa3RKN2JK?=
 =?utf-8?B?SzlyQUlrTHMxTFA5MU9xMjZhWmg5Z1NrcmI2N2tJcGl6YmF2di9nYXNVRjFK?=
 =?utf-8?B?R2xOTnlITlRPeEI4Z3JUZUJIdnB4U3I4NUtzajlUVkVEWkxTRmZ4TmlSenBJ?=
 =?utf-8?B?WjhGZ0xZdk5CcjNWSldpeHE5bHUyU2Y5R09ETFpJdSt6d0l0VkZRbTJqUjJj?=
 =?utf-8?B?azI1OG5RWUJBZkFoNnRiTDg5M2hKRDZlKzdKTVI3OGQ1QmloUFJjbWVFbmJh?=
 =?utf-8?B?NXlUd01saEVpWUNWVzB5dktsRUFRZWg1emhiTVZWU3dHZDdQbk81bVBCZjNp?=
 =?utf-8?B?QXlTQzcxV1RPbkMxV0liSWc3c0ozc1gzRXNibVFpdWJvTmk2dVR5M2FYTE5O?=
 =?utf-8?B?OU9pOHg5N0hlUGl6SzFWNU5jeHd6U2lPVkVXNzhNaG5haEwxdC9UWXNLVXEx?=
 =?utf-8?B?NlJyL1FNa01WYS94eXBTZ1l5bjV0T05rUDdnd1BrTHFJWVQrZkJtWitBMGw5?=
 =?utf-8?B?RU9IUkFIMlFNSnI1a2pYOGpCK3hTQkdjTVNiZHFXSUJhQ09JVElFbVB0cVd6?=
 =?utf-8?B?elNEcyt0d1AybGJDMUJRekgrSGM2Y1RTVFRHZVp3bWd4Umt4QnYyUkNHRVc0?=
 =?utf-8?B?YlM2b2hRaHpTY1JoR2lKYWZPTE9lclR4N0UyVXF4VUVCSVY2WjRUZjdXL3hq?=
 =?utf-8?B?RnRBZ2dEV2FYUXh3c2ZtaE1ZQk5PRHA3K0NRTXlZcUlPc2VXeEJQWDJ6UDdu?=
 =?utf-8?B?Q3U2Q1ZBcmU4YjVOSWJiUThnbGFwMXlmcndVRUNTSCt2eVRhejl2WnNtb0dm?=
 =?utf-8?B?WTc0em5MMGZ0SzR2ejNzYXhMSmlaQlBSbTRoZUFCMXpxTkV1UVp4SGZIaU1F?=
 =?utf-8?B?aTQ0eGlRdEgzbFdPUFR0REdVaFdlSXZ0TVJIMnZNeVBVbFAxVmdSUHJrYlVS?=
 =?utf-8?B?TG9ub21MRjlQR1BLU2xERUlsQW9PeFk3ZnBpcFlacks0b1VkdWVlTGdoQTRK?=
 =?utf-8?B?YnB1SHZzb1ZRNGd2Y0RRTXVyc1A5NVRra1JFd3VIRWIxNW1xaHRzZjlrcnlr?=
 =?utf-8?B?SGdHOUJaZ2I1SFIrRzNqeDJuQ3pIRFhQL1VCQmR0Z1YvY2RSMm5OMkNSdmZU?=
 =?utf-8?B?R1daVWxzdkZUQnN1bTlrbjlmNVM4QU5JM08vQzBndE9HTC9kVnVocHdWVHpU?=
 =?utf-8?B?M3lTTVZ4aTVrSC85aTBraVlhSGhINGJxMi95Qlk0Tk01UTZMU3N4aHNaUTUz?=
 =?utf-8?B?OCtoYTFrbzdaSEdPMXdWZHR4WHJiWUR5RnJZby9vUU9raVUzQ0c0TzAxdGVK?=
 =?utf-8?B?cVdBN2dkNDl0Wlg3Mk9kREQ1NkNmL1NZelh6VkxPTmJ4K1VIckY0M1IxTWlM?=
 =?utf-8?B?ckIrbUl1UlNNUkJvZjFvS2w0NVg5bU0vMjI4OGhMSjFueGdOdTZkU29Wd0xR?=
 =?utf-8?Q?3qtc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9da171-2ae4-43e4-dff4-08dad90d6a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 11:14:46.7365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PhBYmIsHRDTzMbcRc0W+3zLfoVqNsfXDMAqhYPCzcg5IUkjgDkUJlnGvHqRm8k8LgJiMLBb5H7C4FYxIpO0ISg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFRodXJzZGF5LCA4IERlY2VtYmVyIDIwMjIg
MTI6MzgNCj4gVG86IEVtZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gQ2M6IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFJhZWQgU2FsZW0gPHJhZWRzQG52aWRpYS5jb20+Ow0K
PiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5v
cmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBhdGVuYXJ0
QGtlcm5lbC5vcmc7IGppcmlAcmVzbnVsbGkudXMNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQt
bmV4dCB2MyAxLzJdIG1hY3NlYzogYWRkIHN1cHBvcnQgZm9yDQo+IElGTEFfTUFDU0VDX09GRkxP
QUQgaW4gbWFjc2VjX2NoYW5nZWxpbmsNCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlv
biBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gMjAyMi0xMi0wOCwgMDY6
NTM6MTggKzAwMDAsIEVtZWVsIEhha2ltIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBTYWJyaW5hIER1YnJvY2EgPHNkQHF1ZWFz
eXNuYWlsLm5ldD4NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCA4IERlY2VtYmVyIDIwMjIgMDowNA0K
PiA+ID4gVG86IEVtZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gPiA+IENjOiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtIDxyYWVkc0BudmlkaWEuY29tPjsN
Cj4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2Vy
bmVsLm9yZzsNCj4gPiA+IHBhYmVuaUByZWRoYXQuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBhdGVuYXJ0QGtlcm5lbC5vcmc7DQo+ID4gPiBqaXJpQHJlc251bGxpLnVzDQo+ID4gPiBTdWJq
ZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYzIDEvMl0gbWFjc2VjOiBhZGQgc3VwcG9ydCBmb3IN
Cj4gPiA+IElGTEFfTUFDU0VDX09GRkxPQUQgaW4gbWFjc2VjX2NoYW5nZWxpbmsNCj4gPiA+DQo+
ID4gPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2ht
ZW50cw0KPiA+ID4NCj4gPiA+DQo+ID4gPiAyMDIyLTEyLTA3LCAxNTo1MjoxNSArMDAwMCwgRW1l
ZWwgSGFraW0gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+ID4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gPiBGcm9tOiBTYWJyaW5hIER1YnJvY2EgPHNkQHF1ZWFz
eXNuYWlsLm5ldD4NCj4gPiA+ID4gPiBTZW50OiBXZWRuZXNkYXksIDcgRGVjZW1iZXIgMjAyMiAx
Nzo0Ng0KPiA+ID4gPiA+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+ID4g
PiA+ID4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFJhZWQgU2FsZW0gPHJhZWRz
QG52aWRpYS5jb20+Ow0KPiA+ID4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdv
b2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gPiA+ID4gPiBwYWJlbmlAcmVkaGF0LmNvbTsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYXRlbmFydEBrZXJuZWwub3JnOw0KPiA+ID4gPiA+IGpp
cmlAcmVzbnVsbGkudXMNCj4gPiA+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYz
IDEvMl0gbWFjc2VjOiBhZGQgc3VwcG9ydCBmb3INCj4gPiA+ID4gPiBJRkxBX01BQ1NFQ19PRkZM
T0FEIGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBFeHRlcm5hbCBl
bWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAyMDIyLTEyLTA3LCAxMjoxMDoxNiArMDIwMCwgZWhha2lt
QG52aWRpYS5jb20gd3JvdGU6DQo+ID4gPiA+ID4gWy4uLl0NCj4gPiA+ID4gPiA+ICtzdGF0aWMg
aW50IG1hY3NlY19jaGFuZ2VsaW5rX3VwZF9vZmZsb2FkKHN0cnVjdCBuZXRfZGV2aWNlDQo+ID4g
PiA+ID4gPiArKmRldiwgc3RydWN0IG5sYXR0ciAqZGF0YVtdKSB7DQo+ID4gPiA+ID4gPiArICAg
ICBlbnVtIG1hY3NlY19vZmZsb2FkIG9mZmxvYWQ7DQo+ID4gPiA+ID4gPiArICAgICBzdHJ1Y3Qg
bWFjc2VjX2RldiAqbWFjc2VjOw0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgICAgbWFj
c2VjID0gbWFjc2VjX3ByaXYoZGV2KTsNCj4gPiA+ID4gPiA+ICsgICAgIG9mZmxvYWQgPSBubGFf
Z2V0X3U4KGRhdGFbSUZMQV9NQUNTRUNfT0ZGTE9BRF0pOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4g
QWxsIHRob3NlIGNoZWNrcyBhcmUgYWxzbyBwcmVzZW50IGluIG1hY3NlY191cGRfb2ZmbG9hZCwg
d2h5IG5vdA0KPiA+ID4gPiA+IG1vdmUgdGhlbSBpbnRvIG1hY3NlY191cGRhdGVfb2ZmbG9hZCBh
cyB3ZWxsPyAoYW5kIHRoZW4geW91DQo+ID4gPiA+ID4gZG9uJ3QgcmVhbGx5IG5lZWQgbWFjc2Vj
X2NoYW5nZWxpbmtfdXBkX29mZmxvYWQgYW55bW9yZSkNCj4gPiA+ID4gPg0KPiA+ID4gPg0KPiA+
ID4gPiBSaWdodCwgSSB0aG91Z2h0IGFib3V0IGl0ICwgYnV0IEkgcmVhbGl6ZWQgdGhhdCB0aG9z
ZSBjaGVja3MgYXJlDQo+ID4gPiA+IGRvbmUgYmVmb3JlIGhvbGRpbmcgdGhlIGxvY2sgaW4gbWFj
c2VjX3VwZF9vZmZsb2FkIGFuZCBpZiBJIG1vdmUNCj4gPiA+ID4gdGhlbSB0byBtYWNzZWNfdXBk
YXRlX29mZmxvYWQgSSB3aWxsIGhvbGQgdGhlIGxvY2sgZm9yIGEgbG9uZ2VyDQo+ID4gPiA+IHRp
bWUgLCBJIHdhbnQgdG8gbWluaW1pemUNCj4gPiA+IHRoZSB0aW1lIG9mIGhvbGRpbmcgdGhlIGxv
Y2suDQo+ID4gPg0KPiA+ID4gVGhvc2UgY291cGxlIG9mIHRlc3RzIGFyZSBwcm9iYWJseSBsb3N0
IGluIHRoZSBub2lzZSBjb21wYXJlZCB0bw0KPiA+ID4gd2hhdCBtZG9fYWRkX3NlY3kgZW5kcyB1
cCBkb2luZy4gSXQgYWxzbyBsb29rcyBsaWtlIGEgcmFjZSBjb25kaXRpb24NCj4gPiA+IGJldHdl
ZW4gdGhlICJtYWNzZWMtPm9mZmxvYWQgPT0gb2ZmbG9hZCIgdGVzdCBpbiBtYWNzZWNfdXBkX29m
ZmxvYWQNCj4gPiA+IChvdXRzaWRlIHJ0bmxfbG9jaykgYW5kIHVwZGF0aW5nIG1hY3NlYy0+b2Zm
bG9hZCB2aWENCj4gPiA+IG1hY3NlY19jaGFuZ2VsaW5rIGlzIHBvc3NpYmxlLiAoQ3VycmVudGx5
IHdlIGNhbiBvbmx5IGNoYW5nZSBpdCB3aXRoDQo+ID4gPiBtYWNzZWNfdXBkX29mZmxvYWQgKGNh
bGxlZCB1bmRlciBnZW5sX2xvY2spIHNvIHRoZXJlJ3Mgbm8gaXNzdWUNCj4gPiA+IHVudGlsIHdl
IGFkZCB0aGlzIHBhdGNoKQ0KPiA+DQo+ID4gQWNrLA0KPiA+IHNvIGdldHRpbmcgcmlkIG9mIG1h
Y3NlY19jaGFuZ2VsaW5rX3VwZF9vZmZsb2FkIGFuZCBtb3ZpbmcgdGhlIGxvY2tpbmcNCj4gPiBp
bnNpZGUgbWFjc2VjX3VwZGF0ZV9vZmZsb2FkIHNob3VsZCBoYW5kbGUgdGhpcyBpc3N1ZQ0KPiAN
Cj4gWW91IG1lYW4gbW92aW5nIHJ0bmxfbG9jaygpL3VubG9jayBpbnNpZGUgbWFjc2VjX3VwZGF0
ZV9vZmZsb2FkPw0KPiBjaGFuZ2VsaW5rIGlzIGFscmVhZHkgdW5kZXIgcnRubF9sb2NrLiBKdXN0
IG1vdmUgdGhlIGNoZWNrcyB0aGF0IHlvdSBjdXJyZW50bHkgaGF2ZQ0KPiBpbiBtYWNzZWNfY2hh
bmdlbGlua191cGRfb2ZmbG9hZCBpbnRvIG1hY3NlY191cGRhdGVfb2ZmbG9hZCwgYW5kIHJlbW92
ZSB0aGVtDQo+IGZyb20gbWFjc2VjX3VwZF9vZmZsb2FkLg0KDQpBY2sgd2lsbCBzZW5kIG5ldyB2
ZXJzaW9uDQoNCj4gPiA+DQo+ID4gPiA+ID4gPiArICAgICBpZiAobWFjc2VjLT5vZmZsb2FkID09
IG9mZmxvYWQpDQo+ID4gPiA+ID4gPiArICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ID4gPiA+
ID4gKw0KPiA+ID4gPiA+ID4gKyAgICAgLyogQ2hlY2sgaWYgdGhlIG9mZmxvYWRpbmcgbW9kZSBp
cyBzdXBwb3J0ZWQgYnkgdGhlIHVuZGVybHlpbmcgbGF5ZXJzDQo+ICovDQo+ID4gPiA+ID4gPiAr
ICAgICBpZiAob2ZmbG9hZCAhPSBNQUNTRUNfT0ZGTE9BRF9PRkYgJiYNCj4gPiA+ID4gPiA+ICsg
ICAgICAgICAhbWFjc2VjX2NoZWNrX29mZmxvYWQob2ZmbG9hZCwgbWFjc2VjKSkNCj4gPiA+ID4g
PiA+ICsgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ID4gPiA+ID4gKw0KPiA+
ID4gPiA+ID4gKyAgICAgLyogQ2hlY2sgaWYgdGhlIG5ldCBkZXZpY2UgaXMgYnVzeS4gKi8NCj4g
PiA+ID4gPiA+ICsgICAgIGlmIChuZXRpZl9ydW5uaW5nKGRldikpDQo+ID4gPiA+ID4gPiArICAg
ICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArICAg
ICByZXR1cm4gbWFjc2VjX3VwZGF0ZV9vZmZsb2FkKG1hY3NlYywgb2ZmbG9hZCk7IH0NCj4gPiA+
ID4gPiA+ICsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IC0tDQo+ID4gPiA+ID4gU2FicmluYQ0KPiA+
ID4gPg0KPiA+ID4NCj4gPiA+IC0tDQo+ID4gPiBTYWJyaW5hDQo+ID4NCj4gDQo+IC0tDQo+IFNh
YnJpbmENCg0K
