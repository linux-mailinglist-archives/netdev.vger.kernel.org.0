Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D37F679200
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjAXHbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAXHbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:31:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8261E974C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:31:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtbHlbyNR3qckjeG7BDlJyWWesF6uv+hrxgz1UnPXext56IzVSx4MTlG2zUc9q8phscea+lgswO4ePD1kiOd7W1qeYmR9sze1FsNIF1g1MEqbsf7pRPn4e3a0cMBqRgJL37THy2JOns35muiQcYk3foT8iTcGf8/1+ur4nmhvtnTUUcYnVrB5TVw7cRxQQuaNWYk65B21+EPWtQpq4TSvdm/nRGulWo+Bp6lkoj6ZOFfnawxICp46Rw0hDNhiHAN1bOM8FKQWyVQ+X5xJzqe/pD7FauoLvYgol2YvYfYnN2BU48a0lpbW/dlJy95IjUUi1xYDnGL9Pw4usbUZHOBDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nomQbfIkURL9O6D/SLkI1oAr7cSQQT8C38Xgs2OJXH4=;
 b=YVso0SMWuz+MIBel64HHGz5wEz8Yy41m2ejb2CnhbCNZWYz//JCLV0fmSHxdv6pn4DmYB6DF5py7Rx122TvqG44Yp7oCvM45XQtfaEx9q78PvJMGw6HtS5MJb8S78BeRB40dvhU+vd4KpiPVFhUGs5p3C9EgzGFjxNxmp48/hp8O7Q0Vw51EhSCi1albgVeyhyS4Eq0xs7S1oE/hKiPPOB3i64FX59nwA12u+TgS3VNjReXpz0T63/BqBk28+NB2EIUmI6I8oxOCWRCV49g+20lq2Vy2MFc4oswPbaMLPcowl4pr0eInQHmo2tW1+e+kAs6m/56bHmYYYePImrvGdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nomQbfIkURL9O6D/SLkI1oAr7cSQQT8C38Xgs2OJXH4=;
 b=wqEerjg7vUYAQWRebgaaWd0Yjczk/Dg5nZTW6a2+pESkKkwUsAelhqLAkWZYWjmpBjl74cemBsqYHSP80H0053Y3ph4bB/Es7FgNVGKUde5NhC3JcFsQ1WfHyREH6HCXn1c5BfrF73Z8kU6YkIdCVmwsEFoEmczLmXMO/Lfxr7g=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 07:31:16 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 07:31:16 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Thread-Topic: [PATCH net-next 1/7] sfc: add devlink support for ef100
Thread-Index: AQHZK/m3dRrScZP960COfMprLSU9Pa6mZvqAgADzWQCABcOtgIAAFaqA
Date:   Tue, 24 Jan 2023 07:31:16 +0000
Message-ID: <09b1d6e0-3c7f-d9dd-d4fc-a874ffa3458b@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
 <24448301-f6cd-2b8e-f9fa-570bc10953c9@intel.com>
 <a9a56e4c-1a57-a282-1ae5-182656437e01@amd.com>
 <a11cdd6f-fb67-3517-31aa-88e64d607778@gmail.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DM6PR12MB4155:EE_
x-ms-office365-filtering-correlation-id: 5d38340e-a62d-4a07-5a27-08dafddcfa86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SDDNqvGBgsM59ttHDq37C0aG2RHWNisISQTQ56kpDZ0tSDRVPamMpn2CSeyEldQaeIx0U8Kt4l0g6PWd835/SBT0XTu8bJKteOOmvOHZ49amlWoEJpkB6u6/WW6WcpJ/eKcOGFoovDJMMNkK3oBIKj1gxWCConis8hz2sPAnd8x+EW/ifkpD/Kns+mZykFsNWgsyBrlQGUXXCE/XJPg07ZSdZ9Ew9WgBg4zq4w+VoClqydTZ17r1ChNU45PZ7adWgY29R2g9GuWiZft3nHtdhhOHyW+DuBB1BgHxqLzW1GdyedoRRF6AWMAOC04zn17hejihdQAfhacCbsvE2TknOXOCmKU8cG0ojcsp5iW8gcz8dc1kcY/kUUTlbhd4duEo0lyrHJestZBJKZsHxcYxsZhNBfcJaACkdxsHkEsWUKVz1ZB0VxQ6kBpU+7f9zAmDGcqYKJIQK0BJC3Zn7Jmay0T1fy03voCVwl8Ve9tV1Y2BDKPBJGYHj6meME/eDRHbgqyUH62YqvgmswuRx/swBhlqHS0LYuWQMKCtYzHDHRJ6oPf1T1+9Z0oKJSE05La0PrwgcbWQJzwSzBM4doJswqaFv4nbYBQIz2L1PECA/+vjBSEhjSry17TlZDBhhJWQ2wIp/voDHlREuIlfYduC/AV63l6kBiUlXdgCx51QxbjPxow+hHzrwor4h6kempSFWGv2KjL/va7lMQSXTFlFcJZPLaaGoxNUVacBmAK2rtA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(122000001)(38100700002)(83380400001)(38070700005)(41300700001)(86362001)(2906002)(5660300002)(8936002)(4326008)(8676002)(6512007)(26005)(53546011)(6506007)(186003)(316002)(66476007)(66556008)(64756008)(76116006)(66446008)(54906003)(2616005)(6636002)(110136005)(91956017)(478600001)(6486002)(71200400001)(66946007)(31686004)(31696002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3JSYmhEQy9saWJicE5pbVJPaWd0ZnpuUy9Nbk9kbnAvWW9LR1k4SnJWK3dN?=
 =?utf-8?B?OVRaT0pPYmFFVFA4eGRWTndqWWUzOEtoWGpPZHB6amk5QTJmSTROWHB6ZzUv?=
 =?utf-8?B?MG5xbm5NYitZVi9iQmNlYi94ZUlXVkFGWC9GQWNrYzhPQVlFbXhFL2pldVk5?=
 =?utf-8?B?MTRNNmJnOSt4NHRPVkQveXdrbTdqcTdaS0Y3UDVPakxMWUpLVG4rUlhUNzNF?=
 =?utf-8?B?aUhzcUxHQldPTGgxQ0dMVWxZTEQrcWNQQk8rUjJPREpwMlFtd05SY1RwUWk3?=
 =?utf-8?B?WGRVNFdTbnczMkZNRjhTWDFrVkppY0hVbXVrYXV5VnFnTEtiVEg3T1B5dkVz?=
 =?utf-8?B?Sjg3cmhJUFdtS2QyNlJyanVVVkphRFBHbWd6Mi9hbWlvVlFHWTZtcXZwdHNE?=
 =?utf-8?B?R3Jac2JONkV4aHgvZ0FERXQyZzdIUEtKOWhiRUkzWTNmOUFTWk5ZdGh2bzMy?=
 =?utf-8?B?VW94UEVuZEVIWFdJZ0lhNjM4UnpsdVU0c1I5WXF0aGdRcWtsSjYzQXJlWDR3?=
 =?utf-8?B?UzNIeHVlU1lxWUJGTnQ2NDdzbHg3K2k0dlBqME4vd1VYWEdIci9zOHZMeXpi?=
 =?utf-8?B?bnpIMjg0MS9HU09rM09LMTB0NklvdnVMSDJ4cnZtdGtKNWM3WnpOdTMzRFM1?=
 =?utf-8?B?RVVmQ1NXMk9KMzhyUEJSTXB6QlBDNWEyMXBjbHRzWjlGRVc5MFY5V1dYZXZR?=
 =?utf-8?B?cTRXekI5RjFRLzN2WEJiVGtpZWxmUXBNM0hyYkovSWh2aU9UUHhLSlhQbC94?=
 =?utf-8?B?aXpRNm1FRC92Yng0eUJRYTZVTytlT3RXNHIzbEJGMEhJUzRqUEVxVUxIRG1B?=
 =?utf-8?B?dDJMMElpOFlXKzBLbUJpcWQ2L2xyTjBJSVlmcHo5SHJCamJ0S3M1TThLems1?=
 =?utf-8?B?d1djK1AycHNvWkFXMjhzZitLWVVrb1ZuOUZwbXFBRVNNZVplWTFSb1lDemFa?=
 =?utf-8?B?bUVLdW1MdU5USWxWZUJtVTN5SElYNTl3VFdqL0pUREs4MFlhdm9KdUZJRDlC?=
 =?utf-8?B?RUYrcCtMa2dXSzhJM2lUVWpxbmRNd25jK1BKQ3hNejg5R3BCcU1rVE9CWG5v?=
 =?utf-8?B?RkpyTzBPMnFpcTEzMHdpYW5QQm03YmFlajRJT0s3NGhTWVhGaG5lSFlrNUVy?=
 =?utf-8?B?QXhvSE5uc3dzb1I0Q3U3Y1VGMHpoU3ZKdDRMcmNiVGNuSUhaVlJxUE5BWjl4?=
 =?utf-8?B?TGFxWEFiYVlMSFFwcEtEWEpvSk1CRU40WHM3Mzk1OVMrZmU4S2lMNy9BMk9K?=
 =?utf-8?B?VXdYYlhsNXVkZkw4TWUxZU5wNEZpVDNQM0ZmVllNV2NONkc4RFBNcmI3YVJ6?=
 =?utf-8?B?Q0dNS05jejlVSWVaVW56NjlnOU02VUxZa21oMDRzbU5ORlhDRDRvOTFoaEpk?=
 =?utf-8?B?Z3JKUjBtU3Bkb2JvanNSaVN2L3NTN3pTTlJvQ3E1THdXam9TTDhtMDV3TUoy?=
 =?utf-8?B?RFFBVTVkUmh4d01EOFJLeno2eUNOZGlGYmI2ZUJtcnVRYlJvUHZEZURQVCtv?=
 =?utf-8?B?RTVlTVpxbDhqU0xaeW5ESThIY3cxbHFSTjZkMFJaTmZCMFVDNDZkd0hXbVRT?=
 =?utf-8?B?NzlBK0hFdDdMQmpDVndPY1k4MVNPV0FKWHkzT1VHbkUvOHJjTFVYY2hzZEpU?=
 =?utf-8?B?Q05mRHNkY0RrZGJ3d0ZZdkt1Z2ZyOFdHVkdyS3g3THpFaTFmaXViS2U2L25x?=
 =?utf-8?B?UE5nR3dpRVpzMXVhM1JhVm1NS001TTZYc1hORDJiMW5UK090M3VxTVBram1R?=
 =?utf-8?B?T29yRi96ZnlmL2FsUXo1ZFJkcnY0N2d6MjBYemp5RTExWDRDRTY1MlA1K2V0?=
 =?utf-8?B?OTc0a3MrQTU0bmc4NTc4endPeWloMytxdnF0UjNSdDcvZ1NFRjdDa0ExUmhu?=
 =?utf-8?B?b1ZaYVZubFJra2tqUHVEL0Z0NG5WSDV2NlFtM0JWejZwWnJHQnNOZVJtbTdn?=
 =?utf-8?B?dmJ0eUZjeUQrcWE4WCt1QitGRndabFQxT0t3Sjg0V0RrQVI2SEd3VDhpMjJ0?=
 =?utf-8?B?MGhOODlKdExkVnRXUFJQNDFtdEhCNjhQY3kzWUMraWUwMGhUV3FCbGVUT01F?=
 =?utf-8?B?ZHhBWjZsanNnQm1oOGxQSTVSY1l6SW5Daks0aUJ4V3l3RW1WQVhtaUhFSDhU?=
 =?utf-8?Q?lFly/QM1AMcGseQNehLG95Xmm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2730AC2F20F2CA46B93F1FE3E5EE0358@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d38340e-a62d-4a07-5a27-08dafddcfa86
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 07:31:16.3619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngTdiOVD7zMjneswGatjdRqKMPhMU+laRMmOSH7LCpMAUZ0OUKYRBC5KptDFOzrVEpMtEZqy3uopMEQYFBKwRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzI0LzIzIDA2OjEzLCBFZHdhcmQgQ3JlZSB3cm90ZToNCj4gT24gMjAvMDEvMjAyMyAx
NDoxMSwgTHVjZXJvIFBhbGF1LCBBbGVqYW5kcm8gd3JvdGU6DQo+PiBPbiAxLzE5LzIzIDIzOjQw
LCBKYWNvYiBLZWxsZXIgd3JvdGU6DQo+Pj4gT24gMS8xOS8yMDIzIDM6MzEgQU0sIGFsZWphbmRy
by5sdWNlcm8tcGFsYXVAYW1kLmNvbSB3cm90ZToNCj4+Pj4gQEAgLTExMjQsNiArMTEyNSwxMCBA
QCBpbnQgZWYxMDBfcHJvYmVfbmV0ZGV2X3BmKHN0cnVjdCBlZnhfbmljICplZngpDQo+Pj4+ICAg
IAkJbmV0aWZfd2FybihlZngsIHByb2JlLCBuZXRfZGV2LA0KPj4+PiAgICAJCQkgICAiRmFpbGVk
IHRvIHByb2JlIGJhc2UgbXBvcnQgcmMgJWQ7IHJlcHJlc2VudG9ycyB3aWxsIG5vdCBmdW5jdGlv
blxuIiwNCj4+Pj4gICAgCQkJICAgcmMpOw0KPj4+PiArCX0gZWxzZSB7DQo+Pj4+ICsJCWlmIChl
ZnhfcHJvYmVfZGV2bGluayhlZngpKQ0KPj4+PiArCQkJbmV0aWZfd2FybihlZngsIHByb2JlLCBu
ZXRfZGV2LA0KPj4+PiArCQkJCSAgICJGYWlsZWQgdG8gcmVnaXN0ZXIgZGV2bGlua1xuIik7DQo+
Pj4+ICAgIAl9DQo+Pj4+ICAgIA0KPj4+IEEgYml0IG9mIGEgd2VpcmQgY29uc3RydWN0aW9uIGhl
cmUgd2l0aCB0aGUgbmV4dCBzdGVwIGluIGFuIGVsc2UgYmxvY2s/DQo+Pj4gSSBndWVzcyB0aGlz
IGlzIGJlaW5nIHRyZWF0ZWQgYXMgYW4gb3B0aW9uYWwgZmVhdHVyZSwgYW5kIGRlcGVuZHMgb24N
Cj4+PiBlZnhfZWYxMDBfZ2V0X2Jhc2VfbXBvcnQgc3VjY2VlZGluZz8NCj4+IFJpZ2h0LiBUaGUg
bWFlIHBvcnRzIGluaXRpYWxpemF0aW9uIGNhbiBmYWlsIGJ1dCB0aGUgZHJpdmVyIGNhbiBzdGls
bA0KPj4gaW5pdGlhbGl6ZSB0aGUgZGV2aWNlIHdpdGggbGltaXRlZCBmdW5jdGlvbmFsaXR5Lg0K
PiBCdXQgaW4gdGhhdCBjYXNlLCB3ZSBwcm9iYWJseSBzaG91bGQgc3VwcG9ydCBlLmcuIGRldmxp
bmsgaW5mbywgZXZlbg0KPiAgIHRob3VnaCB3aXRob3V0IHRoZSBNQUUgcG9ydHMgd2UgY2FuJ3Qg
c3VwcG9ydCBkZXZsaW5rIHBvcnQuDQoNCg0KR29vZCBwb2ludC4NCg0KSSd2ZSBhbHJlYWR5IG1v
ZGlmaWVkIHRoZSBjb2RlIGZvciBhdm9pZGluZyB0aGUgd2VpcmRuZXNzIGFuZCB0aGlzIA0Kc2hv
dWxkIG5vdCBiZSBoYXJkIHRvIGRvLg0KDQpUaGFua3MNCg0KDQo=
