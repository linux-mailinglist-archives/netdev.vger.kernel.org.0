Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7E713D028
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgAOWfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:35:33 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:32170
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728899AbgAOWfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 17:35:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evoWuQ8B6D59Pl+cKOjNcKFpwEedJlqCxxzd7pJ1SOtgylb/awdue0Ac6c1w2BodUKEKVRWeTmCbgTJylAWH8iVY+8GNLRqZ2Us9wjp4ZvaQ97J+aVcK7mYm49+2nFseqbQpc/Uh2vuMGCN4PFDzF/i8ozDVor5WLygQK/niK1EkSa/vyQnlr5tYdMTV8bC3+5QyGfdHanxT62OJH9YvUKg+/ZoA19nEV1kLYMmPVUe8xOEiv5w+mTu0wefS7miRBC54en8LLFRwXPvopVXVvJU7L82zWIAJjN8E7te0pEZgRQc+c+XUDEecy9+kTUW8FZsJik7iBqEefl3Is0EHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61c/yYAwVhV2a2rzH4wErQi3CLWtQa4rkIBrr4w+W4Q=;
 b=bIQ9hKJxUHFVkRXJ4LXn15CFYIYa1bhr8FSKFk5qKm5YyseVf7z0xF/u2/FqZ1CnPbDHDuzUJF4zQtu55mrOuU8V5J2aZIn4nRPbDuGaVITLaVWhTOIX83cSslfuBWh5ow+AnbPS1g8ydIJvYtc4tUJwgzWmPN1sussJe9QR5diZCarKvpGImrOVIeYEOPyVUwijIIC4YPtXcFXnfRkjjA0Nawsw+CSl2MFU5Gfb0wLOqDXmvbTRP2PSb61PY6LaxLgGD3bhoPNuufvUej3Z0qZikjeEC5wIqN1RbJQ5Pm5zLwHL4EVpjsdaMCqIXtOl4pLqqF58jJoRt4lvM1S67A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61c/yYAwVhV2a2rzH4wErQi3CLWtQa4rkIBrr4w+W4Q=;
 b=daLBW4ofg92zVGYNQTHUE6cgarP5WqtnFJ/G/ZtH2A6vsf8b7yDzY4nSl+Cok1BhG5czXsTcWfcGrF/9RgyZJ04OT6OIdQvgeRE05v9wxbEQ7buUBPXjuKRiKDrhJNYfumAoMvmbJ84RvG0ulE8qTnv9/mgt22OzjJCaD8DPRpA=
Received: from BYAPR05MB5430.namprd05.prod.outlook.com (20.177.185.207) by
 BYAPR05MB4664.namprd05.prod.outlook.com (52.135.233.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.6; Wed, 15 Jan 2020 22:35:30 +0000
Received: from BYAPR05MB5430.namprd05.prod.outlook.com
 ([fe80::2c22:ed2c:1e8f:4270]) by BYAPR05MB5430.namprd05.prod.outlook.com
 ([fe80::2c22:ed2c:1e8f:4270%5]) with mapi id 15.20.2644.015; Wed, 15 Jan 2020
 22:35:30 +0000
From:   Hanlin Shi <hanlins@vmware.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cheng-Chun William Tu <tuc@vmware.com>
Subject: Veth pair swallow packets for XDP_TX operation
Thread-Topic: Veth pair swallow packets for XDP_TX operation
Thread-Index: AQHVy/QXF9NXQcDwM0KlYF7OoDTm2g==
Date:   Wed, 15 Jan 2020 22:35:29 +0000
Message-ID: <1D6D69BF-5643-45C2-A0F5-2D30C9C608E5@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hanlins@vmware.com; 
x-originating-ip: [50.204.244.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30346e66-5011-4f51-5fee-08d79a0b39fd
x-ms-traffictypediagnostic: BYAPR05MB4664:|BYAPR05MB4664:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB466429F0D05EEF89BF81E06CD0370@BYAPR05MB4664.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(199004)(189003)(478600001)(6916009)(2616005)(86362001)(8676002)(966005)(4326008)(316002)(81156014)(36756003)(8936002)(66946007)(81166006)(6512007)(186003)(66446008)(26005)(66556008)(6506007)(64756008)(66476007)(76116006)(2906002)(6486002)(71200400001)(5660300002)(107886003)(33656002)(150783002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4664;H:BYAPR05MB5430.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2cNv28DGfUyeDMSiK6p1a8kzyvVzYNUGZUAQEkupvfir7fxORVgJ91m3eSuOjupfA8bXoCIyMfV7ah/W84terQks85ypVE5yAtQ0cxi7QuqGFXFxBcrRd7cZYQxpVQ95KFZCWNDjgQD8gpOO8R7aAPXOJRboNpOyrzujQRForIYWa/K2NDhe/Bx4tb/vAjdTl06fR7TmhS2Hel+PXEDNX415Hufvnou4j+A9kvsrdRBhkOtaBuKflPTNs6ujKW6dRI3u2rzAVrNVn0jREP6PcnjTw1FS6pw5uNnu4tc5KbcqzYcPylyO6OrBPQ/wMR16C+17GJEbvg/phAOHYXZ8RE8KaLD/KvpYKFVqo89l0uNHHYoEhWIT+j0S7nPdWhgjLKqONkljDJbw22jl9IBAbTmtc3uNJcyT0+1NKqyHzdmKGAaiaxYWhlbaT4oCDBdl5+eAMaVF5+d4aYAxv9wt6lMWg9sWcjy3MzoJq/5f8fau4HYeKEz9Sa5mYZA4H1g7UjdJ4crUrB7y7aE8xRai0Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A9EEA6271AC6448B54E45102CE02B85@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30346e66-5011-4f51-5fee-08d79a0b39fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 22:35:29.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pGFYi5XX4rNj79bY1ZKpjRogvD2lnns0QTqlBN8t1fr5S/d5YI0+ogMxubtLO1UbSCU+tLTp7iEBrEyRyoTArg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4664
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgY29tbXVuaXR5LA0KDQpJ4oCZbSBwcm90b3R5cGluZyBhbiBYRFAgcHJvZ3JhbSwgYW5kIHRo
ZSBoaXQgaXNzdWVzIHdpdGggWERQX1RYIG9wZXJhdGlvbiBvbiB2ZXRoIGRldmljZS4gVGhlIGZv
bGxvd2luZyBjb2RlIHNuaXBwZXQgaXMgd29ya2luZyBhcyBleHBlY3RlZCBvbiA0LjE1LjAtNTQt
Z2VuZXJpYywgYnV0IGlzIE5PVCB3b3JraW5nIG9uIDQuMjAuMTctMDQyMDE3LWxvd2xhdGVuY3kg
KEkgZ290IHRoZSBrZXJuZWwgaGVyZTogaHR0cHM6Ly9rZXJuZWwudWJ1bnR1LmNvbS9+a2VybmVs
LXBwYS9tYWlubGluZS92NC4yMC4xNy8pLg0KDQpIZXJl4oCZcyBteSBzZXR1cDogSSBjcmVhdGVk
IGEgdmV0aCBwYWlyIChuYW1lbHkgdmV0aDEgYW5kIHZldGgyKSwgYW5kIHB1dCB0aGVtIGluIHR3
byBuYW1lc3BhY2VzIChuYW1lbHkgbnMxIGFuZCBuczIpLiBJIGFzc2lnbmVkIGFkZHJlc3MgNjAu
MC4wLjEgb24gdmV0aDEgYW5kIDYwLjAuMC4yIG9uIHZldGgyLCBzZXQgdGhlIGRldmljZSBhcyB0
aGUgZGVmYXVsdCBpbnRlcmZhY2UgaW4gaXRzIG5hbWVzcGFjZSByZXNwZWN0aXZlbHkgKGUuZy4g
aW4gbnMxLCBkbyDigJxpcCByIHNldCBkZWZhdWx0IGRldiB2ZXRoMeKAnSkuIFRoZW4gaW4gbnMx
LCBJIHBpbmcgNjAuMC4wLjIsIGFuZCB0Y3BkdW1wIG9uIHZldGgx4oCZcyBSWCBmb3IgSUNNUC4N
Cg0KQmVmb3JlIGxvYWRpbmcgYW55IFhEUCBwcm9ncmFtIG9uIHZldGgyLCBJIGNhbiBzZWUgSUNN
UCByZXBsaWVzIG9uIHZldGgxIGludGVyZmFjZS4gSSBsb2FkIGEgcHJvZ3JhbSB3aGljaCBkbyDi
gJxYRFBfVFjigJ0gZm9yIGFsbCBwYWNrZXRzIG9uIHZldGgyLiBJIGV4cGVjdCB0byBzZWUgdGhl
IHNhbWUgSUNNUCBwYWNrZXQgYmVpbmcgcmV0dXJuZWQsIGJ1dCBJIHNhdyBub3RoaW5nLg0KDQpJ
IGFkZGVkIHNvbWUgZGVidWdnaW5nIG1lc3NhZ2UgaW4gdGhlIFhEUCBwcm9ncmFtIHNvIEnigJlt
IHN1cmUgdGhhdCB0aGUgcGFja2V0IGlzIHByb2Nlc3NlZCBvbiB2ZXRoMiwgYnV0IG9uIHZldGgx
LCBldmVuIHdpdGggcHJvbWlzYyBtb2RlIG9uLCBJIGNhbm5vdCBzZWUgYW55IElDTVAgcGFja2V0
cyBvciBldmVuIEFSUCBwYWNrZXRzLiBJbiBteSB1bmRlcnN0YW5kaW5nLCA0LjE1IGlzIHVzaW5n
IGdlbmVyaWMgWERQIG1vZGUgd2hlcmUgNC4yMCBpcyB1c2luZyBuYXRpdmUgWERQIG1vZGUgZm9y
IHZldGgsIHNvIEkgZ3Vlc3MgdGhlcmXigJlzIHNvbWV0aGluZyB3cm9uZyB3aXRoIHZldGggbmF0
aXZlIFhEUCBhbmQgbmVlZCBzb21lIGhlbHBzIG9uIGZpeGluZyB0aGUgaXNzdWUuDQoNClBsZWFz
ZSBsZXQgbWUga25vdyBpZiB5b3UgbmVlZCBoZWxwIG9uIHJlcHJvZHVjaW5nIHRoZSBpc3N1ZS4N
Cg0KVGhhbmtzLA0KSGFubGluDQoNClBTOiBoZXJl4oCZcyB0aGUgc3JjIGNvZGUgZm9yIHRoZSBY
RFAgcHJvZ3JhbToNCiNpbmNsdWRlIDxzdGRkZWYuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNp
bmNsdWRlIDxsaW51eC9pZl92bGFuLmg+DQojaW5jbHVkZSA8c3RkYm9vbC5oPg0KI2luY2x1ZGUg
PGJwZi9icGZfZW5kaWFuLmg+DQojaW5jbHVkZSA8bGludXgvaWZfZXRoZXIuaD4NCiNpbmNsdWRl
IDxsaW51eC9pcC5oPg0KI2luY2x1ZGUgPGxpbnV4L3RjcC5oPg0KI2luY2x1ZGUgPGxpbnV4L3Vk
cC5oPg0KI2luY2x1ZGUgPGxpbnV4L2luLmg+I2RlZmluZSBERUJVRw0KI2luY2x1ZGUgImJwZl9o
ZWxwZXJzLmgiDQoNClNFQygieGRwIikNCmludCBsb2FkYmFsKHN0cnVjdCB4ZHBfbWQgKmN0eCkg
ew0KICBicGZfcHJpbnRrKCJnb3QgcGFja2V0LCBkaXJlY3QgcmV0dXJuXG4iKTsNCiAgcmV0dXJu
IFhEUF9UWDsNCn1jaGFyIF9saWNlbnNlW10gU0VDKCJsaWNlbnNlIikgPSAiR1BMIjsNCg0KImJw
Zl9oZWxwZXJzLmgiIGNhbiBiZSBmb3VuZCBoZXJlOiBodHRwczovL2dpdGh1Yi5jb20vZHJvcGJv
eC9nb2VicGYvcmF3L21hc3Rlci9icGZfaGVscGVycy5oDQoNCg==
