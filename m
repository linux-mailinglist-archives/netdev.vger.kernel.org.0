Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A5333743D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 14:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhCKNnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 08:43:14 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:19072 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbhCKNmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 08:42:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615470176; x=1647006176;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=0Dm43OTjlPuwXIrW3yljmNFuhk3JiZgiZDXuXeFWhIc=;
  b=esUjMXVLCWRrHFH6bpW9PFKxX+sKBuG5pInCUZp4C0t07F27MeHmJSgG
   9CalYBh6/Trg5ahIRs0sHWjqcPrj+b+EFXLjvPOJUGVnTlzXlsupAweAr
   /Q4Glop3Ay5kLD3fuGLWacKE2p2iDpSAKt27XBBhCTLsqMbAFjZhxmZbS
   s=;
IronPort-HdrOrdr: A9a23:Z100d6nm6E6fuJXaQBq4+PjsH0fpDfNyimdD5ilNYBxZY6Wkvu
 qpm+kW0gKxtSYJVBgb6Km9EYSjYVeZz5565oENIayvNTONhEKEJJxvhLGSpgHINDb58odmpM
 VdWoh4TOb9FF1ryfv9iTPIcOoI5Pmi3OSWifzFz3FrJDsKV4hF4x1iAgiWVm1aLTM2YaYRL5
 aX6spZqzfIQx1+BfiTPXULU/POoNfGjvvdASIuPQIt6wWFkFqTmdnHOiWfty1uNQ9n8PMN9S
 zgnxbi7quu98unwgLRvlW+071m3PXmzNVHCIigqOgwbg/thAGheZh7V9S50QwdkaWA7lAlld
 WJmRM8JoBI7W/LdG3dm3TQ8jil6zol53/8xVLwuxXenfA=
X-IronPort-AV: E=Sophos;i="5.81,240,1610409600"; 
   d="scan'208";a="96445353"
Subject: RE: [RFC PATCH 05/10] ena: Update driver to use ethtool_gsprintf
Thread-Topic: [RFC PATCH 05/10] ena: Update driver to use ethtool_gsprintf
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 11 Mar 2021 13:42:46 +0000
Received: from EX13D06EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id D9355A1D77;
        Thu, 11 Mar 2021 13:42:43 +0000 (UTC)
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D06EUA002.ant.amazon.com (10.43.165.241) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 11 Mar 2021 13:42:41 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.012;
 Thu, 11 Mar 2021 13:42:41 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "skalluru@marvell.com" <skalluru@marvell.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>
Thread-Index: AQHXFhboRwyXcTUcVkS467rmptG2KKp+yylA
Date:   Thu, 11 Mar 2021 13:42:21 +0000
Deferred-Delivery: Thu, 11 Mar 2021 13:41:28 +0000
Message-ID: <a8d66ff7d2034b75ada799de8b9de448@EX13D22EUA004.ant.amazon.com>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
 <161542654541.13546.817443057977441498.stgit@localhost.localdomain>
In-Reply-To: <161542654541.13546.817443057977441498.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.52]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAxMSwgMjAy
MSAzOjM2IEFNDQo+IFRvOiBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IG9zcy1kcml2ZXJzQG5ldHJvbm9tZS5jb207DQo+IHNpbW9uLmhvcm1hbkBuZXRyb25v
bWUuY29tOyB5aXNlbi56aHVhbmdAaHVhd2VpLmNvbTsNCj4gc2FsaWwubWVodGFAaHVhd2VpLmNv
bTsgaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7DQo+IGplc3NlLmJyYW5kZWJ1cmdA
aW50ZWwuY29tOyBhbnRob255Lmwubmd1eWVuQGludGVsLmNvbTsNCj4gZHJpdmVyc0BwZW5zYW5k
by5pbzsgc25lbHNvbkBwZW5zYW5kby5pbzsgQmVsZ2F6YWwsIE5ldGFuZWwNCj4gPG5ldGFuZWxA
YW1hem9uLmNvbT47IEtpeWFub3Zza2ksIEFydGh1ciA8YWtpeWFub0BhbWF6b24uY29tPjsNCj4g
VHphbGlrLCBHdXkgPGd0emFsaWtAYW1hem9uLmNvbT47IEJzaGFyYSwgU2FlZWQgPHNhZWVkYkBh
bWF6b24uY29tPjsNCj4gR1ItTGludXgtTklDLURldkBtYXJ2ZWxsLmNvbTsgc2thbGx1cnVAbWFy
dmVsbC5jb207DQo+IHJtb2R5QG1hcnZlbGwuY29tOyBreXNAbWljcm9zb2Z0LmNvbTsgaGFpeWFu
Z3pAbWljcm9zb2Z0LmNvbTsNCj4gc3RoZW1taW5AbWljcm9zb2Z0LmNvbTsgd2VpLmxpdUBrZXJu
ZWwub3JnOyBtc3RAcmVkaGF0LmNvbTsNCj4gamFzb3dhbmdAcmVkaGF0LmNvbTsgcHYtZHJpdmVy
c0B2bXdhcmUuY29tOyBkb3NoaXJAdm13YXJlLmNvbTsNCj4gYWxleGFuZGVyZHV5Y2tAZmIuY29t
DQo+IFN1YmplY3Q6IFtFWFRFUk5BTF0gW1JGQyBQQVRDSCAwNS8xMF0gZW5hOiBVcGRhdGUgZHJp
dmVyIHRvIHVzZQ0KPiBldGh0b29sX2dzcHJpbnRmDQo+IA0KPiBDQVVUSU9OOiBUaGlzIGVtYWls
IG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGlj
aw0KPiBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhl
IHNlbmRlciBhbmQga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IA0KPiBG
cm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFsZXhhbmRlcmR1eWNrQGZiLmNvbT4NCj4gDQo+IFJlcGxh
Y2UgaW5zdGFuY2VzIG9mIHNucHJpbnRmIG9yIG1lbWNweSB3aXRoIGEgcG9pbnRlciB1cGRhdGUg
d2l0aA0KPiBldGh0b29sX2dzcHJpbnRmLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVy
IER1eWNrIDxhbGV4YW5kZXJkdXlja0BmYi5jb20+DQoNCkFja2VkLWJ5OiBBcnRodXIgS2l5YW5v
dnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0K
