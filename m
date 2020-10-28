Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2074829DFB3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgJ1WKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730389AbgJ1WJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:09:58 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E4C0613D1;
        Wed, 28 Oct 2020 15:09:58 -0700 (PDT)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09SFVhiX001164;
        Wed, 28 Oct 2020 15:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=rVg2yshTozJPoFFO3a7zWiPkU70Ww6t6kt7zeGPsleE=;
 b=ZsjRuSQ5Ybet9guNNVUQkgeFYMeLK6oS7Wl8nOrGfT9deB0WiWsI1Uttcv36p2+ADv66
 szDo9AZoeGtSxhni9dAfJrqzEledfWv6rMfLXKy+Eiaf3f/aogGBD6cZvzIelR6HPSH3
 p0Y6quyj1FbKAJXJSUo3Ltd8UGA1jzHF/vCqv2S2bpu7jZscBOUQo2lfaVZfO6Lxhy19
 nP/5FhjCjPGDu1sWt7wjmMfUMMl8Z9sg4HzOWffhtJEAe7YuQnW0lbyMj8NjakvCch0t
 2ZDTz94gfpgk4UA53h9efeNy0b7igOrqzektNm9HDkb+Kg6tfyaMOTpIJVo8hmxPn+HI hA== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 34ccewxar0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 15:37:42 +0000
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09SFZ9m5007758;
        Wed, 28 Oct 2020 11:37:42 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.116])
        by prod-mail-ppoint8.akamai.com with ESMTP id 34f1pxcj3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 11:37:42 -0400
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com (172.27.165.121) by
 ustx2ex-dag3mb5.msg.corp.akamai.com (172.27.165.129) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 28 Oct 2020 10:37:35 -0500
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com ([172.27.165.121]) by
 ustx2ex-dag1mb3.msg.corp.akamai.com ([172.27.165.121]) with mapi id
 15.00.1497.007; Wed, 28 Oct 2020 10:37:35 -0500
From:   "Pai, Vishwanath" <vpai@akamai.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
CC:     "Hunt, Joshua" <johunt@akamai.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
Thread-Topic: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
Thread-Index: AQHWrTm6PDxhK1NghE+FvFs4+bfvZqmtNtIA
Date:   Wed, 28 Oct 2020 15:37:35 +0000
Message-ID: <AE096F70-4419-4A67-937A-7741FBDA6668@akamai.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <CAP12E-+3DY-dgzVercKc-NYGPExWO1NjTOr1Gf3tPLKvp6O6+g@mail.gmail.com>
In-Reply-To: <CAP12E-+3DY-dgzVercKc-NYGPExWO1NjTOr1Gf3tPLKvp6O6+g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.41.108]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D9209D1D1C4754081C9252657AE9B8B@akamai.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_07:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280104
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_07:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 adultscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280104
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.34)
 smtp.mailfrom=vpai@akamai.com smtp.helo=prod-mail-ppoint8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMjgvMjAsIDEwOjUxIEFNLCAiVmlzaHdhbmF0aCBQYWkiIDxwYWkudmlzaHdhaW4ua2Vy
bmVsQGdtYWlsLmNvbT4gd3JvdGU6DQoNCk9uIFRodSwgU2VwIDE3LCAyMDIwIGF0IDQ6MjYgUE0g
Q29uZyBXYW5nIDx4aXlvdS53YW5nY29uZ0BnbWFpbC5jb20+IHdyb3RlOg0KPg0KPiBPbiBGcmks
IFNlcCAxMSwgMjAyMCBhdCAxOjEzIEFNIFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2Vp
LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiAyMDIwLzkvMTEgNDowNywgQ29uZyBXYW5nIHdyb3Rl
Og0KPiA+ID4gT24gVHVlLCBTZXAgOCwgMjAyMCBhdCA0OjA2IEFNIFl1bnNoZW5nIExpbiA8bGlu
eXVuc2hlbmdAaHVhd2VpLmNvbT4gd3JvdGU6DQo+ID4gPj4NCj4gPiA+PiBDdXJyZW50bHkgdGhl
cmUgaXMgY29uY3VycmVudCByZXNldCBhbmQgZW5xdWV1ZSBvcGVyYXRpb24gZm9yIHRoZQ0KPiA+
ID4+IHNhbWUgbG9ja2xlc3MgcWRpc2Mgd2hlbiB0aGVyZSBpcyBubyBsb2NrIHRvIHN5bmNocm9u
aXplIHRoZQ0KPiA+ID4+IHEtPmVucXVldWUoKSBpbiBfX2Rldl94bWl0X3NrYigpIHdpdGggdGhl
IHFkaXNjIHJlc2V0IG9wZXJhdGlvbiBpbg0KPiA+ID4+IHFkaXNjX2RlYWN0aXZhdGUoKSBjYWxs
ZWQgYnkgZGV2X2RlYWN0aXZhdGVfcXVldWUoKSwgd2hpY2ggbWF5IGNhdXNlDQo+ID4gPj4gb3V0
LW9mLWJvdW5kcyBhY2Nlc3MgZm9yIHByaXYtPnJpbmdbXSBpbiBobnMzIGRyaXZlciBpZiB1c2Vy
IGhhcw0KPiA+ID4+IHJlcXVlc3RlZCBhIHNtYWxsZXIgcXVldWUgbnVtIHdoZW4gX19kZXZfeG1p
dF9za2IoKSBzdGlsbCBlbnF1ZXVlIGENCj4gPiA+PiBza2Igd2l0aCBhIGxhcmdlciBxdWV1ZV9t
YXBwaW5nIGFmdGVyIHRoZSBjb3JyZXNwb25kaW5nIHFkaXNjIGlzDQo+ID4gPj4gcmVzZXQsIGFu
ZCBjYWxsIGhuczNfbmljX25ldF94bWl0KCkgd2l0aCB0aGF0IHNrYiBsYXRlci4NCj4gPiA+Pg0K
PiA+ID4+IFJldXNlZCB0aGUgZXhpc3Rpbmcgc3luY2hyb25pemVfbmV0KCkgaW4gZGV2X2RlYWN0
aXZhdGVfbWFueSgpIHRvDQo+ID4gPj4gbWFrZSBzdXJlIHNrYiB3aXRoIGxhcmdlciBxdWV1ZV9t
YXBwaW5nIGVucXVldWVkIHRvIG9sZCBxZGlzYyh3aGljaA0KPiA+ID4+IGlzIHNhdmVkIGluIGRl
dl9xdWV1ZS0+cWRpc2Nfc2xlZXBpbmcpIHdpbGwgYWx3YXlzIGJlIHJlc2V0IHdoZW4NCj4gPiA+
PiBkZXZfcmVzZXRfcXVldWUoKSBpcyBjYWxsZWQuDQo+ID4gPj4NCj4gPiA+PiBGaXhlczogNmIz
YmE5MTQ2ZmU2ICgibmV0OiBzY2hlZDogYWxsb3cgcWRpc2NzIHRvIGhhbmRsZSBsb2NraW5nIikN
Cj4gPiA+PiBTaWduZWQtb2ZmLWJ5OiBZdW5zaGVuZyBMaW4gPGxpbnl1bnNoZW5nQGh1YXdlaS5j
b20+DQo+ID4gPj4gLS0tDQo+ID4gPj4gQ2hhbmdlTG9nIFYyOg0KPiA+ID4+ICAgICAgICAgUmV1
c2UgZXhpc3Rpbmcgc3luY2hyb25pemVfbmV0KCkuDQo+ID4gPj4gLS0tDQo+ID4gPj4gIG5ldC9z
Y2hlZC9zY2hfZ2VuZXJpYy5jIHwgNDggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tDQo+ID4gPj4gIDEgZmlsZSBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCsp
LCAxNSBkZWxldGlvbnMoLSkNCj4gPiA+Pg0KPiA+ID4+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQv
c2NoX2dlbmVyaWMuYyBiL25ldC9zY2hlZC9zY2hfZ2VuZXJpYy5jDQo+ID4gPj4gaW5kZXggMjY1
YTYxZC4uNTRjNDE3MiAxMDA2NDQNCj4gPiA+PiAtLS0gYS9uZXQvc2NoZWQvc2NoX2dlbmVyaWMu
Yw0KPiA+ID4+ICsrKyBiL25ldC9zY2hlZC9zY2hfZ2VuZXJpYy5jDQo+ID4gPj4gQEAgLTExMzEs
MjQgKzExMzEsMTAgQEAgRVhQT1JUX1NZTUJPTChkZXZfYWN0aXZhdGUpOw0KPiA+ID4+DQo+ID4g
Pj4gIHN0YXRpYyB2b2lkIHFkaXNjX2RlYWN0aXZhdGUoc3RydWN0IFFkaXNjICpxZGlzYykNCj4g
PiA+PiAgew0KPiA+ID4+IC0gICAgICAgYm9vbCBub2xvY2sgPSBxZGlzYy0+ZmxhZ3MgJiBUQ1Ff
Rl9OT0xPQ0s7DQo+ID4gPj4gLQ0KPiA+ID4+ICAgICAgICAgaWYgKHFkaXNjLT5mbGFncyAmIFRD
UV9GX0JVSUxUSU4pDQo+ID4gPj4gICAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiA+PiAtICAg
ICAgIGlmICh0ZXN0X2JpdChfX1FESVNDX1NUQVRFX0RFQUNUSVZBVEVELCAmcWRpc2MtPnN0YXRl
KSkNCj4gPiA+PiAtICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ID4+IC0NCj4gPiA+PiAtICAg
ICAgIGlmIChub2xvY2spDQo+ID4gPj4gLSAgICAgICAgICAgICAgIHNwaW5fbG9ja19iaCgmcWRp
c2MtPnNlcWxvY2spOw0KPiA+ID4+IC0gICAgICAgc3Bpbl9sb2NrX2JoKHFkaXNjX2xvY2socWRp
c2MpKTsNCj4gPiA+Pg0KPiA+ID4+ICAgICAgICAgc2V0X2JpdChfX1FESVNDX1NUQVRFX0RFQUNU
SVZBVEVELCAmcWRpc2MtPnN0YXRlKTsNCj4gPiA+PiAtDQo+ID4gPj4gLSAgICAgICBxZGlzY19y
ZXNldChxZGlzYyk7DQo+ID4gPj4gLQ0KPiA+ID4+IC0gICAgICAgc3Bpbl91bmxvY2tfYmgocWRp
c2NfbG9jayhxZGlzYykpOw0KPiA+ID4+IC0gICAgICAgaWYgKG5vbG9jaykNCj4gPiA+PiAtICAg
ICAgICAgICAgICAgc3Bpbl91bmxvY2tfYmgoJnFkaXNjLT5zZXFsb2NrKTsNCj4gPiA+PiAgfQ0K
PiA+ID4+DQo+ID4gPj4gIHN0YXRpYyB2b2lkIGRldl9kZWFjdGl2YXRlX3F1ZXVlKHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYsDQo+ID4gPj4gQEAgLTExNjUsNiArMTE1MSwzMCBAQCBzdGF0aWMgdm9p
ZCBkZXZfZGVhY3RpdmF0ZV9xdWV1ZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiA+ID4+ICAg
ICAgICAgfQ0KPiA+ID4+ICB9DQo+ID4gPj4NCj4gPiA+PiArc3RhdGljIHZvaWQgZGV2X3Jlc2V0
X3F1ZXVlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+ID4gPj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCBuZXRkZXZfcXVldWUgKmRldl9xdWV1ZSwNCj4gPiA+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdm9pZCAqX3VudXNlZCkNCj4gPiA+PiArew0KPiA+ID4+ICsg
ICAgICAgc3RydWN0IFFkaXNjICpxZGlzYzsNCj4gPiA+PiArICAgICAgIGJvb2wgbm9sb2NrOw0K
PiA+ID4+ICsNCj4gPiA+PiArICAgICAgIHFkaXNjID0gZGV2X3F1ZXVlLT5xZGlzY19zbGVlcGlu
ZzsNCj4gPiA+PiArICAgICAgIGlmICghcWRpc2MpDQo+ID4gPj4gKyAgICAgICAgICAgICAgIHJl
dHVybjsNCj4gPiA+PiArDQo+ID4gPj4gKyAgICAgICBub2xvY2sgPSBxZGlzYy0+ZmxhZ3MgJiBU
Q1FfRl9OT0xPQ0s7DQo+ID4gPj4gKw0KPiA+ID4+ICsgICAgICAgaWYgKG5vbG9jaykNCj4gPiA+
PiArICAgICAgICAgICAgICAgc3Bpbl9sb2NrX2JoKCZxZGlzYy0+c2VxbG9jayk7DQo+ID4gPj4g
KyAgICAgICBzcGluX2xvY2tfYmgocWRpc2NfbG9jayhxZGlzYykpOw0KPiA+ID4NCj4gPiA+DQo+
ID4gPiBJIHRoaW5rIHlvdSBkbyBub3QgbmVlZCB0aGlzIGxvY2sgZm9yIGxvY2tsZXNzIG9uZS4N
Cj4gPg0KPiA+IEl0IHNlZW1zIHNvLg0KPiA+IE1heWJlIGFub3RoZXIgcGF0Y2ggdG8gcmVtb3Zl
IHFkaXNjX2xvY2socWRpc2MpIGZvciBsb2NrbGVzcw0KPiA+IHFkaXNjPw0KPg0KPiBZZWFoLCBi
dXQgbm90IHN1cmUgaWYgd2Ugc3RpbGwgd2FudCB0aGlzIGxvY2tsZXNzIHFkaXNjIGFueSBtb3Jl
LA0KPiBpdCBicmluZ3MgbW9yZSB0cm91YmxlcyB0aGFuIGdhaW5zLg0KPg0KPiA+DQo+ID4NCj4g
PiA+DQo+ID4gPj4gKw0KPiA+ID4+ICsgICAgICAgcWRpc2NfcmVzZXQocWRpc2MpOw0KPiA+ID4+
ICsNCj4gPiA+PiArICAgICAgIHNwaW5fdW5sb2NrX2JoKHFkaXNjX2xvY2socWRpc2MpKTsNCj4g
PiA+PiArICAgICAgIGlmIChub2xvY2spDQo+ID4gPj4gKyAgICAgICAgICAgICAgIHNwaW5fdW5s
b2NrX2JoKCZxZGlzYy0+c2VxbG9jayk7DQo+ID4gPj4gK30NCj4gPiA+PiArDQo+ID4gPj4gIHN0
YXRpYyBib29sIHNvbWVfcWRpc2NfaXNfYnVzeShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiA+
ID4+ICB7DQo+ID4gPj4gICAgICAgICB1bnNpZ25lZCBpbnQgaTsNCj4gPiA+PiBAQCAtMTIxMywx
MiArMTIyMywyMCBAQCB2b2lkIGRldl9kZWFjdGl2YXRlX21hbnkoc3RydWN0IGxpc3RfaGVhZCAq
aGVhZCkNCj4gPiA+PiAgICAgICAgICAgICAgICAgZGV2X3dhdGNoZG9nX2Rvd24oZGV2KTsNCj4g
PiA+PiAgICAgICAgIH0NCj4gPiA+Pg0KPiA+ID4+IC0gICAgICAgLyogV2FpdCBmb3Igb3V0c3Rh
bmRpbmcgcWRpc2MtbGVzcyBkZXZfcXVldWVfeG1pdCBjYWxscy4NCj4gPiA+PiArICAgICAgIC8q
IFdhaXQgZm9yIG91dHN0YW5kaW5nIHFkaXNjLWxlc3MgZGV2X3F1ZXVlX3htaXQgY2FsbHMgb3IN
Cj4gPiA+PiArICAgICAgICAqIG91dHN0YW5kaW5nIHFkaXNjIGVucXVldWluZyBjYWxscy4NCj4g
PiA+PiAgICAgICAgICAqIFRoaXMgaXMgYXZvaWRlZCBpZiBhbGwgZGV2aWNlcyBhcmUgaW4gZGlz
bWFudGxlIHBoYXNlIDoNCj4gPiA+PiAgICAgICAgICAqIENhbGxlciB3aWxsIGNhbGwgc3luY2hy
b25pemVfbmV0KCkgZm9yIHVzDQo+ID4gPj4gICAgICAgICAgKi8NCj4gPiA+PiAgICAgICAgIHN5
bmNocm9uaXplX25ldCgpOw0KPiA+ID4+DQo+ID4gPj4gKyAgICAgICBsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGRldiwgaGVhZCwgY2xvc2VfbGlzdCkgew0KPiA+ID4+ICsgICAgICAgICAgICAgICBuZXRk
ZXZfZm9yX2VhY2hfdHhfcXVldWUoZGV2LCBkZXZfcmVzZXRfcXVldWUsIE5VTEwpOw0KPiA+ID4+
ICsNCj4gPiA+PiArICAgICAgICAgICAgICAgaWYgKGRldl9pbmdyZXNzX3F1ZXVlKGRldikpDQo+
ID4gPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X3Jlc2V0X3F1ZXVlKGRldiwgZGV2X2lu
Z3Jlc3NfcXVldWUoZGV2KSwgTlVMTCk7DQo+ID4gPj4gKyAgICAgICB9DQo+ID4gPj4gKw0KPiA+
ID4+ICAgICAgICAgLyogV2FpdCBmb3Igb3V0c3RhbmRpbmcgcWRpc2NfcnVuIGNhbGxzLiAqLw0K
PiA+ID4+ICAgICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShkZXYsIGhlYWQsIGNsb3NlX2xpc3Qp
IHsNCj4gPiA+PiAgICAgICAgICAgICAgICAgd2hpbGUgKHNvbWVfcWRpc2NfaXNfYnVzeShkZXYp
KSB7DQo+ID4gPg0KPiA+ID4gRG8geW91IHdhbnQgdG8gcmVzZXQgYmVmb3JlIHdhaXRpbmcgZm9y
IFRYIGFjdGlvbj8NCj4gPiA+DQo+ID4gPiBJIHRoaW5rIGl0IGlzIHNhZmVyIHRvIGRvIGl0IGFm
dGVyLCBhdCBsZWFzdCBwcmlvciB0byBjb21taXQgNzU5YWU1N2YxYg0KPiA+ID4gd2UgZGlkIGFm
dGVyLg0KPiA+DQo+ID4gVGhlIHJlZmVyZW5jZSB0byB0aGUgdHhxLT5xZGlzYyBpcyBhbHdheXMg
cHJvdGVjdGVkIGJ5IFJDVSwgc28gdGhlIHN5bmNocm9uaXplX25ldCgpDQo+ID4gc2hvdWxkIGJl
IGVub3VnaHQgdG8gZW5zdXJlIHRoZXJlIGlzIG5vIHNrYiBlbnF1ZXVlZCB0byB0aGUgb2xkIHFk
aXNjIHRoYXQgaXMgc2F2ZWQNCj4gPiBpbiB0aGUgZGV2X3F1ZXVlLT5xZGlzY19zbGVlcGluZywg
YmVjYXVzZSBfX2Rldl9xdWV1ZV94bWl0IGNhbiBvbmx5IHNlZSB0aGUgbmV3IHFkaXNjDQo+ID4g
YWZ0ZXIgc3luY2hyb25pemVfbmV0KCksIHdoaWNoIGlzIG5vb3BfcWRpc2MsIGFuZCBub29wX3Fk
aXNjIHdpbGwgbWFrZSBzdXJlIGFueSBza2INCj4gPiBlbnF1ZXVlZCB0byBpdCB3aWxsIGJlIGRy
b3BwZWQgYW5kIGZyZWVkLCByaWdodD8NCj4NCj4gSG1tPyBJbiBuZXRfdHhfYWN0aW9uKCksIHdl
IGRvIG5vdCBob2xkIFJDVSByZWFkIGxvY2ssIGFuZCB3ZSBkbyBub3QNCj4gcmVmZXJlbmNlIHFk
aXNjIHZpYSB0eHEtPnFkaXNjIGJ1dCB2aWEgc2QtPm91dHB1dF9xdWV1ZS4NCj4NCj4NCj4gPg0K
PiA+IElmIHdlIGRvIGFueSBhZGRpdGlvbmFsIHJlc2V0IHRoYXQgaXMgbm90IHJlbGF0ZWQgdG8g
cWRpc2MgaW4gZGV2X3Jlc2V0X3F1ZXVlKCksIHdlDQo+ID4gY2FuIG1vdmUgaXQgYWZ0ZXIgc29t
ZV9xZGlzY19pc19idXN5KCkgY2hlY2tpbmcuDQo+DQo+IEkgYW0gbm90IHN1Z2dlc3RpbmcgdG8g
ZG8gYW4gYWRkaXRpb25hbCByZXNldCwgSSBhbSBzdWdnZXN0aW5nIHRvIG1vdmUNCj4geW91ciBy
ZXNldCBhZnRlciB0aGUgYnVzeSB3YWl0aW5nLg0KPg0KPiBUaGFua3MuDQoNCkhpLA0KDQpXZSBu
b3RpY2VkIHNvbWUgcHJvYmxlbXMgd2hlbiB0ZXN0aW5nIHRoZSBsYXRlc3QgNS40IExUUyBrZXJu
ZWwgYW5kIHRyYWNlZCBpdA0KYmFjayB0byB0aGlzIGNvbW1pdCB1c2luZyBnaXQgYmlzZWN0LiBX
aGVuIHJ1bm5pbmcgb3VyIHRlc3RzIHRoZSBtYWNoaW5lIHN0b3BzDQpyZXNwb25kaW5nIHRvIGFs
bCB0cmFmZmljIGFuZCB0aGUgb25seSB3YXkgdG8gcmVjb3ZlciBpcyBhIHJlYm9vdC4gSSBkbyBu
b3Qgc2VlDQphIHN0YWNrIHRyYWNlIG9uIHRoZSBjb25zb2xlLg0KDQpUaGlzIGNhbiBiZSByZXBy
b2R1Y2VkIHVzaW5nIHRoZSBwYWNrZXRkcmlsbCB0ZXN0IGJlbG93LCBpdCBzaG91bGQgYmUgcnVu
IGENCmZldyB0aW1lcyBvciBpbiBhIGxvb3AuIFlvdSBzaG91bGQgaGl0IHRoaXMgaXNzdWUgd2l0
aGluIGEgZmV3IHRyaWVzIGJ1dA0Kc29tZXRpbWVzIG1pZ2h0IHRha2UgdXAgdG8gMTUtMjAgdHJp
ZXMuDQoNCioqKiBURVNUIEJFR0lOICoqKg0KDQowIGBlY2hvIDQgPiAvcHJvYy9zeXMvbmV0L2lw
djQvdGNwX21pbl90c29fc2Vnc2ANCg0KMC40MDAgc29ja2V0KC4uLiwgU09DS19TVFJFQU0sIElQ
UFJPVE9fVENQKSA9IDMNCjAuNDAwIHNldHNvY2tvcHQoMywgU09MX1NPQ0tFVCwgU09fUkVVU0VB
RERSLCBbMV0sIDQpID0gMA0KDQovLyBzZXQgbWF4c2VnIHRvIDEwMDAgdG8gd29yayB3aXRoIGJv
dGggaXB2NCBhbmQgaXB2Ng0KMC41MDAgc2V0c29ja29wdCgzLCBTT0xfVENQLCBUQ1BfTUFYU0VH
LCBbMTAwMF0sIDQpID0gMA0KMC41MDAgYmluZCgzLCAuLi4sIC4uLikgPSAwDQowLjUwMCBsaXN0
ZW4oMywgMSkgPSAwDQoNCi8vIEVzdGFibGlzaCBjb25uZWN0aW9uDQowLjYwMCA8IFMgMDowKDAp
IHdpbiAzMjc5MiA8bXNzIDEwMDAsc2Fja09LLG5vcCxub3Asbm9wLHdzY2FsZSA1Pg0KMC42MDAg
PiBTLiAwOjAoMCkgYWNrIDEgPC4uLj4NCg0KMC44MDAgPCAuIDE6MSgwKSBhY2sgMSB3aW4gMzIw
DQowLjgwMCBhY2NlcHQoMywgLi4uLCAuLi4pID0gNA0KDQovLyBTZW5kIDQgZGF0YSBzZWdtZW50
cy4NCiswIHdyaXRlKDQsIC4uLiwgNDAwMCkgPSA0MDAwDQorMCA+IFAuIDE6NDAwMSg0MDAwKSBh
Y2sgMQ0KDQovLyBSZWNlaXZlIGEgU0FDSw0KKy4xIDwgLiAxOjEoMCkgYWNrIDEgd2luIDMyMCA8
c2FjayAxMDAxOjIwMDEsbm9wLG5vcD4NCg0KKy4zICV7IHByaW50ICJUQ1AgQ0Egc3RhdGU6ICIs
dGNwaV9jYV9zdGF0ZSAgfSUNCg0KKioqIFRFU1QgRU5EICoqKg0KDQpJIGNhbiByZXByb2R1Y2Ug
dGhlIGlzc3VlIGVhc2lseSBvbiB2NS40LjY4LCBhbmQgYWZ0ZXIgcmV2ZXJ0aW5nIHRoaXMgY29t
bWl0IGl0DQpkb2VzIG5vdCBoYXBwZW4gYW55bW9yZS4NCg0KVGhhbmtzLA0KVmlzaHdhbmF0aA0K
DQo=
