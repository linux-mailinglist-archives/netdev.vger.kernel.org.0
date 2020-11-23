Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCDE2C189A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732653AbgKWWkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:40:20 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731237AbgKWWkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:40:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANMYnP6005992;
        Mon, 23 Nov 2020 14:39:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=NmQzgIFM6fIYsv9TeSQ44qekyWzUxpDnFaDUdqjW0V0=;
 b=N+yE+fJbJBYYzvasUXgIxyHxTo3llPnRNa1XACJ7tsI6Zj4xP7ppBYWl0NgEQB5PqEdf
 uSNc+/pzi3EiejmCYxofZbmGpBe/xPa2D6mSU5qRLzJjNIIqZuMMMo4uCxAzrz8iuCaX
 +hKcSHA2Du4CDqBuRWd81dy2Pv23piIE33YVqBDbnWW3iezIJhdqUUspPp7HnRJdzW1O
 KXbHb7sLfOFq8q07zwx9ry4/N8idsmfdBBptEC/D8oaaRNMPcvyW/o+zWtH4RMMBPuVY
 tRiYpZNUZQkdfHTZsp8gOHl0rhX0hXeSnABBIjsDAEJmU45TbQVTZx3vGYCWHQLZaFue iA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r7e7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:39:40 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 14:39:38 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 14:39:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 14:39:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9VmPA9XcwCfy/mcgC4OmLL2g/zaoYRsb3VtEDk7J78kXQqGVPdTzXOfTfQRkpH8cziYQVYQm6jHeypOTSo885hFadE8xe2twO7O3VXH/yW451vXmVyvdY4vrbw5q/K2ACptt/lwHBnTup9VHRwRmh3Evs7khCZi4w4Mban7yJ/3Dl6gc2V6Y1E8FoP0r+Poqg8Vkcf1M4xI7tGnaA587HRX1pPKnkbRTAv8PT2y5yOjBLNXEcSudBSCHuv/kmG7PcZLnhIvWL98PhKaew18ClTQrafxCN6zkXZPGRHuUSzg6e1ESK1LfmeQeIHP+arCpm6t3xuT07rWNAU/nXjJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmQzgIFM6fIYsv9TeSQ44qekyWzUxpDnFaDUdqjW0V0=;
 b=lf6plm+y0VwRUV833Hef9+IjeT6Fgu5Kvs2kmCVxHwkvRp32fXZpp5TGv85lXRUeaQIDlX+ZyJTpGfBiR2RaEwCM67qnLTrBhMAMqyih2eiCl1hZAfKbBbV9EARK+rwAv+ZRlrJQOhYpANngqr3TfSiXKpiCrvi9gBCGO0fPsiEtVrDKqgmi5njU5YjzRFYnYqduq9L+GcY2YVW70A//HKCfpKY24p2n2l9UJJXMVR9/ooumOAC/EgpgKiSHRSwqM8P9370O4GJBsU0EpbkKsiNpmtPho/OM2GcEiv29+DEicrEJAysq1claalUbply0AuN4u8bl+zWeIDVDFjUgtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmQzgIFM6fIYsv9TeSQ44qekyWzUxpDnFaDUdqjW0V0=;
 b=ldRFXYWVJ+E3jhx8gh0ZC5wzyuRfBLss0+AR6NrN7Lf5HyhCkxbqO2AW/tBirVlq2rSgNTiS0mCUPgGcGyZmQiI3F7R2h0VP4hqCc3W5k4u+HpUNIy/yTa227X9Ou55n5ysF5zPSXgcEOqLNYOVbver/lLc4z0Vs+YutK6S7nLQ=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1967.namprd18.prod.outlook.com (2603:10b6:301:63::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 23 Nov
 2020 22:39:35 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 22:39:35 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync:
 don't kick isolated cpus
Thread-Topic: [EXT] Re: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync:
 don't kick isolated cpus
Thread-Index: AQHWwcJHihlNClCxdEOODDjRi5wCaKnWTJeAgAAC64A=
Date:   Mon, 23 Nov 2020 22:39:34 +0000
Message-ID: <c65ac23c1c408614110635c33eaf4ace98da4343.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <3236b13f42679031960c5605be20664e90e75223.camel@marvell.com>
         <20201123222907.GC1751@lothringen>
In-Reply-To: <20201123222907.GC1751@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e70b603-e4ee-469c-a3a8-08d89000a712
x-ms-traffictypediagnostic: MWHPR1801MB1967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB1967CDFC780D3B88043B9CC9BCFC0@MWHPR1801MB1967.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4pr0OAiaQpRrGDZgoFVyIU9QOVYeaSkmgwXf5aA3t6KkKKCggEMF0tsZuyypEqjHRXaDyknKS2b2CsjCdH5Oj5YefHu8SN7EQ2QVl8xlt8vRYp7vH8gTJhbdDSVk5kBzCJfpFM1hcC9PoslrRdnUy4fLt+SGR26HfaiXBiqB3WByq1brPd0GvTJ+6NE6Y3RxCj1HFW01jcWjQWc5H+G4vWtu8/ff1E0Ry4FyUQEsjA8ywENWj1i+GooGRmKksnM9KEkaFZrcxgB0OcU0uSmuG6UenS1ELfeJG6zdWBkVG1Mg2W6ouJE1w0YiOAya9YbKtmS4C4f9uDlCot6cKQ6FZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(36756003)(2906002)(316002)(4326008)(83380400001)(4001150100001)(6916009)(71200400001)(26005)(66476007)(186003)(478600001)(54906003)(6512007)(6506007)(64756008)(66556008)(66446008)(91956017)(8676002)(66946007)(7416002)(76116006)(6486002)(8936002)(2616005)(5660300002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ORbzOWd2PITMSqK4y4egvLrA5UN7S7JLLGXKrl7AW8vdFfnYN2A2vzRnQwqejWNjOmGuLXkB5hfl2LNhA+L12iJoXDDYS7iNsI6mJue9hFyLSLpMeW31NJKNSRWRHMUxHLyYh+TuDgnwgSUCZL4ScNxKAQAQKzHmbIFvby2w32RukFymcaiDbfEoMQGDSvCvKMd+5UVknRXtb2knONVEuAgXVOrPH8jpcvgIsNEB2I5W9r6toQf1PZPDOycziCA42uAzFbMNbeov2WeSP1wH/mnQC07Nr4CRFsiuGMvNzJW2RsAT3aNK91M7aCJey0qdbFaUbjnK6n4mTh6X+2Xo9LFqtD6F7kd37fuZ0Ac3qTICq1tCJaCmVjf4HDgFubYWPq76dC8qKlEZvxvIs7ufkFNb6siV4G8jcMadeJKdBb/VP4FU4OG1bNIl8P6pSapEpcZ549ANw1L2D3AX3jyH1Y3AQ12UONfmM2IgDpni1lmbl9/ts5+XtUY5m3ROvTIjHu0pZ3/88FJ2uqORQka2JPMpQjjAL+Lad/8k4jC8e8WwaVIXtN0Dc1sgY7iEGIM2pytf3RAP7njP0GAw9j1FaiodVqKKm3z0dAvqDBmnq9NReo5/ieT84mNSezcRj0kHjnVh0tx85Q+JKfu2axKA9r/a0HKA2tpGE5J4DqN7fPdZjgV/cM+LHuNmSMdS952BxnirjNIO/SnsUvpMJvPL6YFz8TNIqOV7CkmMQa1FckOdD3sCvKs6SSV+AZdTS2jwSMUdKKzgJMD4D1hc3/Gfi+mMLbnA60FTAPFfEAifsJvFGhxbS6+A40NfuU45Con6tKPSb4oDctUWSIznN/qaNCeSqVQ7ktodt/qu5JqBC8fXPEt8KvVkIkFoGT0bKXLaKuJfxuy0JucQZQb6m75FXQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B109772BAEE07246AAF6BEC2A782EA5B@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e70b603-e4ee-469c-a3a8-08d89000a712
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 22:39:34.9192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ce9Q3XyYdjSFavyZnZrR/A4I5e0ABRxzogLm+TN1xE6bQ+D4wlBDtKK8/nUYOWR+QpU43W6Kr5yBCAosWKW6cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1967
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBNb24sIDIwMjAtMTEtMjMgYXQgMjM6MjkgKzAxMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLQ0KPiBPbiBN
b24sIE5vdiAyMywgMjAyMCBhdCAwNTo1ODo0MlBNICswMDAwLCBBbGV4IEJlbGl0cyB3cm90ZToN
Cj4gPiBGcm9tOiBZdXJpIE5vcm92IDx5bm9yb3ZAbWFydmVsbC5jb20+DQo+ID4gDQo+ID4gTWFr
ZSBzdXJlIHRoYXQga2lja19hbGxfY3B1c19zeW5jKCkgZG9lcyBub3QgY2FsbCBDUFVzIHRoYXQg
YXJlDQo+ID4gcnVubmluZw0KPiA+IGlzb2xhdGVkIHRhc2tzLg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFl1cmkgTm9yb3YgPHlub3JvdkBtYXJ2ZWxsLmNvbT4NCj4gPiBbYWJlbGl0c0BtYXJ2
ZWxsLmNvbTogdXNlIHNhZmUgdGFza19pc29sYXRpb25fY3B1bWFzaygpDQo+ID4gaW1wbGVtZW50
YXRpb25dDQo+ID4gU2lnbmVkLW9mZi1ieTogQWxleCBCZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5j
b20+DQo+ID4gLS0tDQo+ID4gIGtlcm5lbC9zbXAuYyB8IDE0ICsrKysrKysrKysrKystDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC9zbXAuYyBiL2tlcm5lbC9zbXAuYw0KPiA+IGluZGV4IDRk
MTc1MDE0MzNiZS4uYjJmYWVjZjU4ZWQwIDEwMDY0NA0KPiA+IC0tLSBhL2tlcm5lbC9zbXAuYw0K
PiA+ICsrKyBiL2tlcm5lbC9zbXAuYw0KPiA+IEBAIC05MzIsOSArOTMyLDIxIEBAIHN0YXRpYyB2
b2lkIGRvX25vdGhpbmcodm9pZCAqdW51c2VkKQ0KPiA+ICAgKi8NCj4gPiAgdm9pZCBraWNrX2Fs
bF9jcHVzX3N5bmModm9pZCkNCj4gPiAgew0KPiA+ICsJc3RydWN0IGNwdW1hc2sgbWFzazsNCj4g
PiArDQo+ID4gIAkvKiBNYWtlIHN1cmUgdGhlIGNoYW5nZSBpcyB2aXNpYmxlIGJlZm9yZSB3ZSBr
aWNrIHRoZSBjcHVzICovDQo+ID4gIAlzbXBfbWIoKTsNCj4gPiAtCXNtcF9jYWxsX2Z1bmN0aW9u
KGRvX25vdGhpbmcsIE5VTEwsIDEpOw0KPiA+ICsNCj4gPiArCXByZWVtcHRfZGlzYWJsZSgpOw0K
PiA+ICsjaWZkZWYgQ09ORklHX1RBU0tfSVNPTEFUSU9ODQo+ID4gKwljcHVtYXNrX2NsZWFyKCZt
YXNrKTsNCj4gPiArCXRhc2tfaXNvbGF0aW9uX2NwdW1hc2soJm1hc2spOw0KPiA+ICsJY3B1bWFz
a19jb21wbGVtZW50KCZtYXNrLCAmbWFzayk7DQo+ID4gKyNlbHNlDQo+ID4gKwljcHVtYXNrX3Nl
dGFsbCgmbWFzayk7DQo+ID4gKyNlbmRpZg0KPiA+ICsJc21wX2NhbGxfZnVuY3Rpb25fbWFueSgm
bWFzaywgZG9fbm90aGluZywgTlVMTCwgMSk7DQo+ID4gKwlwcmVlbXB0X2VuYWJsZSgpOw0KPiAN
Cj4gU2FtZSBjb21tZW50IGFib3V0IElQSXMgaGVyZS4NCg0KVGhpcyBpcyBkaWZmZXJlbnQgZnJv
bSB0aW1lcnMuIFRoZSBvcmlnaW5hbCBkZXNpZ24gd2FzIGJhc2VkIG9uIHRoZQ0KaWRlYSB0aGF0
IGV2ZXJ5IENQVSBzaG91bGQgYmUgYWJsZSB0byBlbnRlciBrZXJuZWwgYXQgYW55IHRpbWUgYW5k
IHJ1bg0Ka2VybmVsIGNvZGUgd2l0aCBubyBhZGRpdGlvbmFsIHByZXBhcmF0aW9uLiBUaGVuIHRo
ZSBvbmx5IHNvbHV0aW9uIGlzDQp0byBhbHdheXMgZG8gZnVsbCBicm9hZGNhc3QgYW5kIHJlcXVp
cmUgYWxsIENQVXMgdG8gcHJvY2VzcyBpdC4NCg0KV2hhdCBJIGFtIHRyeWluZyB0byBpbnRyb2R1
Y2UgaXMgdGhlIGlkZWEgb2YgQ1BVIHRoYXQgaXMgbm90IGxpa2VseSB0bw0KcnVuIGtlcm5lbCBj
b2RlIGFueSBzb29uLCBhbmQgY2FuIGFmZm9yZCB0byBnbyB0aHJvdWdoIGFuIGFkZGl0aW9uYWwN
CnN5bmNocm9uaXphdGlvbiBwcm9jZWR1cmUgb24gdGhlIG5leHQgZW50cnkgaW50byBrZXJuZWwu
IFRoZQ0Kc3luY2hyb25pemF0aW9uIGlzIG5vdCBza2lwcGVkLCBpdCBzaW1wbHkgaGFwcGVucyBs
YXRlciwgZWFybHkgaW4NCmtlcm5lbCBlbnRyeSBjb2RlLg0KDQotLSANCkFsZXgNCg==
