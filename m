Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC07C1B72
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfI3G1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:27:50 -0400
Received: from mail-eopbgr760108.outbound.protection.outlook.com ([40.107.76.108]:47190
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729677AbfI3G1u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 02:27:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YE2pbxAM00DSmPLn/6X/oeFL078un6gwnzhoxri78uCkaZHFGLQHZg0u7B7v3g3CqXXEAgc/znOBFynTDEzI7u8az1MolpHnCFh6871rmfiDSXlmdbe0jfLq+h9eCOPDQVOeuR40PPVs1nbK7XYncNABt6xJEjbmiP2D8C6f+ptt0ZgF+OpGxvyji5JH8vC7W7efBhLuLADmx0oHL+79StyNe/QBpHDZUgoVIA2diTSX4+j6C1xzorAdSx/C5qvfnC/2pMjo8VnNPN21ddE77ep7/j4gJIBipeYHE8AjZTobQD8Osmwo6HlRkcCB/QVtv6KEpBm1P79apWpm9Awz0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c89A1CM7fMd6jbRjvEdkvhyzG9AxeLdA89Tw7FX6NDc=;
 b=mARfNC1B1yjZzj7xqTwa176luqB8MBQo/Aj8lQrYnDw0xqklrwJzAwoF+TCJHHsul1nkU/8O6i2bN7uLx7o7kUQi7wbfz2MYlDYkcqZbAnGMOWko+nmjSd621PGXzQu0pzQPCPHi6L2bEspYb4ZTXNgiS10S2vBrysxTv2ccTzGidSrQMkQRWmvVFqYsQFUXr6T/ySl+Z9lR88bTJWdT+ksbtThG17CYQ1wncrKnPdCdM+51apWbqDxBTbYfo/Loz2iYIqcKp5hQvivwwnqn1HJwzx26UpeDdzpY78Ti6PYn9lPf92ud0DTopjcvPDLhMDDtF12Mzw1qolu0p93orw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c89A1CM7fMd6jbRjvEdkvhyzG9AxeLdA89Tw7FX6NDc=;
 b=qPorT8WGVpA5oQSc5pzZ7R0821zPkE6YZr/iHHdq495TDuglIyIVUxFkeW8IkrPFQT22GBdU3Wl4S6PsliMGtYO6DMqGhcWfu76tsas/5E8U9NCgQlApp4V/6lr43ZbJmANllc2C3JXSEDpVMzNF/qtvnbuFN608gwhtswOcnQ4=
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.238.83) by
 BYAPR11MB3510.namprd11.prod.outlook.com (20.177.226.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 06:27:43 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::2831:7738:ebc0:5543]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::2831:7738:ebc0:5543%7]) with mapi id 15.20.2284.023; Mon, 30 Sep 2019
 06:27:43 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Litao jiao <jiaolitao@raisecom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jethro Beekman <jethro@fortanix.com>
Subject: [RFC PATCH] Don't copy mark from encapsulated packet when routing
 VXLAN
Thread-Topic: [RFC PATCH] Don't copy mark from encapsulated packet when
 routing VXLAN
Thread-Index: AQHVd1gqiAyO7yupP0GOyruRZOsWPg==
Date:   Mon, 30 Sep 2019 06:27:43 +0000
Message-ID: <1db9d050-7ccd-0576-7710-156f22517025@fortanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:207:1::11) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fb::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [84.81.201.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e11a86e7-f28d-46c8-8cb5-08d7456f4cc0
x-ms-traffictypediagnostic: BYAPR11MB3510:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB35108FF89DE0597BDCBBDD75AA820@BYAPR11MB3510.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39830400003)(376002)(136003)(189003)(199004)(256004)(7736002)(486006)(476003)(26005)(386003)(6506007)(102836004)(66066001)(86362001)(2201001)(2616005)(31696002)(305945005)(186003)(478600001)(99286004)(52116002)(25786009)(5660300002)(14454004)(31686004)(316002)(4326008)(36756003)(2906002)(8676002)(6436002)(110136005)(3846002)(6116002)(107886003)(71200400001)(71190400001)(66446008)(6486002)(64756008)(99936001)(66556008)(66476007)(66616009)(66946007)(81166006)(6512007)(81156014)(2501003)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3510;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZA1I/b9Iamv7/4I4hY6i2WfvvfBVNqgJPkLTb3ovXrFTIIfODY2ZOTnBg9Aa3lc+MRooq0ozjus3etNgFwsxxOmWCpmSwJCe2ijrMR5/FVhGHKT1aZH5eblR2v4nphED52OGWSqtQOimR+i/CM/kDh0vQkpQVPrOrMmg1I/64yYXxgLoI5gVkSVi910DVwIFS83suKmlV390ngR64bg1g19EdfwOkCI97dRAL2sehV58k8n8NKMV9JnZ3YQTFGqJIVsamIfL9hGR3hLqI1JowrBmGYloW9Vp75+lmIHU1oWR+BeOB1Ry6FIUapuAL0NzmVqZ/enxaNuVmw9qgJKaDHAXuvMUeivU32vbwusH0d9+y9h7RnwO1ADn4PjBNqSAtCCFhQH3vCop10cyaNyKqFrVMZXr2Y7LR1x+45R2FA8=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040402020709080605020103"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11a86e7-f28d-46c8-8cb5-08d7456f4cc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 06:27:43.0796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QrDY59Ie6+qAr2pUOOHxIv9Ezjv5PZMST/g+1k7nYCYbubE1fx3PvGY9/5Vzmo7+emleDsViNhl78hyGafRLYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3510
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------ms040402020709080605020103
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

When using rule-based routing to send traffic via VXLAN, a routing
loop may occur. Say you have the following routing setup:

ip rule add from all fwmark 0x2/0x2 lookup 2
ip route add table 2 default via 10.244.2.0 dev vxlan1 onlink

The intention is to route packets with mark 2 through VXLAN, and
this works fine. However, the current vxlan code copies the mark
to the encapsulated packet. Immediately after egress on the VXLAN
interface, the encapsulated packet is routed, with no opportunity
to mangle the encapsulated packet. The mark is copied from the
inner packet to the outer packet, and the same routing rule and
table shown above will apply, resulting in ELOOP.

This patch simply doesn't copy the mark from the encapsulated packet.
I don't intend this code to land as is, but I want to start a
discussion on how to make separate routing of VXLAN inner and
encapsulated traffic easier.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 drivers/net/vxlan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc9..f9ed1b7 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2236,7 +2236,6 @@ static struct rtable *vxlan_get_route(struct vxlan_=
dev *vxlan, struct net_device
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_oif =3D oif;
 	fl4.flowi4_tos =3D RT_TOS(tos);
-	fl4.flowi4_mark =3D skb->mark;
 	fl4.flowi4_proto =3D IPPROTO_UDP;
 	fl4.daddr =3D daddr;
 	fl4.saddr =3D *saddr;
@@ -2294,7 +2293,6 @@ static struct dst_entry *vxlan6_get_route(struct vx=
lan_dev *vxlan,
 	fl6.daddr =3D *daddr;
 	fl6.saddr =3D *saddr;
 	fl6.flowlabel =3D ip6_make_flowinfo(RT_TOS(tos), label);
-	fl6.flowi6_mark =3D skb->mark;
 	fl6.flowi6_proto =3D IPPROTO_UDP;
 	fl6.fl6_dport =3D dport;
 	fl6.fl6_sport =3D sport;
--=20
2.7.4



--------------ms040402020709080605020103
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xOTA5MzAwNjI3MzVaMC8GCSqGSIb3DQEJBDEiBCCSZtOL9CxE
UNc9ISsG1Z+hllS8qfbIu4tltrttyAyPqzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAEtrNy/7kiEJuW0OnbnK0RjtCtbzlYOZEOoP1Tt8BZRnsQ1Nn3hGcYsBe
3dmkXzsSKSPT1JLicrvOZ5TukHiVv/EFMU/OFMVj0UUkfh6/EBHazfgIXvpnAKy4yVbM2XpZ
F4h0kukby06eL8ULfUSbeEf37Tn7l5nlEkloP4pcCgiY+/tn7sBCusSlB35TQFV6AlFB4Twm
ANlwxS5NqivITlspE44SRU7BRQE+F2yHhjR9xy4znSFyH7pajDR58rWo2nCxF4mSD9akSKgj
GS6TckecWY1U8YZdv3vdmw7FX61jVRLXl1lrhZr1VwJkvwYAO5c8BVYLIJVUz0lFGG8qzAAA
AAAAAA==

--------------ms040402020709080605020103--
