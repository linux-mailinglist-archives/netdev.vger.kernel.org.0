Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9DF43BC7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfFMPbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:31:40 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:15939
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728610AbfFMLBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 07:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JINyEK86Hil42VR5rMNs2F4bVrw1vCQUT2OxYFj/FQ4=;
 b=Tg//ifNrJ1q5WihC/ETjG9dCKjVs/Nz12CHb2lqusIlXK26R/LSEgsOBqF541U0ZgD3mliIl6xzhQVufEYXNoQkFZfsFIhMnihh+k9F+sPhJdwpP3RNX7bV2PUA1IcRyiWUaArftwEZqOxf30Uj1Ydjl5P/vsZnZ4d3W4Z7R2yY=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2686.eurprd03.prod.outlook.com (10.171.104.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 11:00:37 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 11:00:37 +0000
From:   Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
To:     Paul Blakey <paulb@mellanox.com>
CC:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIF3qkU1UoG8F9UmD/l8WI3EjR6aWf3mAgALuPoA=
Date:   Thu, 13 Jun 2019 11:00:37 +0000
Message-ID: <6417F7F3-51F5-4384-B01F-00976D135BE2@darbyshire-bryant.me.uk>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <87d0jkgr3r.fsf@toke.dk> <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
In-Reply-To: <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kevin@darbyshire-bryant.me.uk; 
x-originating-ip: [62.214.5.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61478eb7-25af-4a98-425f-08d6efee5dff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB2686;
x-ms-traffictypediagnostic: VI1PR0302MB2686:
x-microsoft-antispam-prvs: <VI1PR0302MB2686D7DE8418257CD9A4DF0FA5EF0@VI1PR0302MB2686.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39830400003)(396003)(366004)(136003)(189003)(199004)(74482002)(486006)(11346002)(86362001)(446003)(2616005)(6512007)(4326008)(476003)(8936002)(53936002)(6116002)(3846002)(25786009)(36756003)(2906002)(508600001)(6246003)(71190400001)(81156014)(81166006)(68736007)(305945005)(71200400001)(8676002)(7736002)(256004)(91956017)(76116006)(6486002)(66946007)(66556008)(64756008)(66446008)(66616009)(6436002)(33656002)(99936001)(5660300002)(6916009)(66066001)(7416002)(26005)(229853002)(53546011)(66476007)(316002)(99286004)(102836004)(73956011)(76176011)(54906003)(14454004)(6506007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2686;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fW5Io2YkwH3HpFMXrqa2Hp9l4xeUq3QZ4Bn7iaSTmLAXCSe8QVBNx/jSuHisT1fKBq/Cm4lwI56EyidhjpVGCIDFo+rswTrFs5M0Pfew+R7s+IFDnfDxCPZjT5dehksT6duuJiRqRGThwyowSRd6smwSqpq7WJXL5tS0OjH9c5e1uHBkkC24VTJzTouOqgEjCW/2TPN0lieQgipJvhZZyawzAmGsPo5lZw6q6lx4sdpnkI4jWYOfJicl/3OmXCMOZU2Qm98MWLZVfAaGPscsB1D86c8BJQNiN8yRGXRClRgyOBsdrAIwysRBmxS3JU+cmTaI5BKmk5+0Q/IWjgmlVrGRyzwQfT7vsdXS9wxHJhbEc5P+/NXjw3DmIidzKHiGbpP7LTYn9hOHIFPLOV2CdMI802LL+HeI8p0B8t3K9gQ=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_C282E2E8-BE77-4254-A11E-2F524A2F96D7";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 61478eb7-25af-4a98-425f-08d6efee5dff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 11:00:37.7007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2686
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_C282E2E8-BE77-4254-A11E-2F524A2F96D7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 11 Jun 2019, at 16:15, Paul Blakey <paulb@mellanox.com> wrote:
>=20
>=20
> On 6/11/2019 4:59 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Paul Blakey <paulb@mellanox.com> writes:
>>=20
>>> Allow sending a packet to conntrack and set conntrack zone, mark,
>>> labels and nat parameters.
>> How is this different from the newly merged ctinfo action?
>>=20
>> -Toke
>=20
> Hi,
>=20
> ctinfo does one of two very specific things,
>=20
> 1) copies DSCP values that have been placed in the firewall conntrack
> mark back into the IPv4/v6 diffserv field
>=20
> 2) copies the firewall conntrack mark to the skb's mark field (like
> act_connmark)

It can do both at the same time if required, taking advantage of the =
single
conntrack entry lookup for both packet/skb mangling operations, but this =
isn=E2=80=99t
relevant to the discussion really.

>=20
> Originally ctinfo action was named conndscp (then conntrack, which is
> what our ct shorthand stands for).
>=20
> We also talked about merging both at some point, but they seem only
> coincidentally related.
>=20
> don't know how it was then be agreed to be named ctinfo suggesting it
> does something else but the above.

I=E2=80=99m a newbie around here so trying to fit in.  conndscp did one =
thing, then it
suggested that as it was doing a similar lookup to act_connmark that the =
connmark
functionality could also be integrated.  There was a brief flirtation =
with a
new =E2=80=98act ct=E2=80=99 it sort of =E2=80=98fell out=E2=80=99 that =
they were only semi-related in function
by name only.

conndscp was clearly the wrong name for what act_ctinfo had become, =
amalgamating
two functions, so I thought it=E2=80=99s a =E2=80=9Cconntrack =
information lookup/user/extractor/mangler=E2=80=99
and thought =E2=80=98ctinfo=E2=80=99 was as good as anything - and =
nobody screamed and AFAIK no
kittens died :-)

But as a newbie around here I=E2=80=99m happy to fit in with whatever =
consensus is reached
as long as it is reached.

>=20
> This action sends packets to conntrack, configures nat, and doesn't =
get
> "info" from conntrack, while the ctinfo already expects packets to be
> passed conntrack
>=20
> by some other kernel mechanism.
>=20

Yeah, one is pulling, the other is pushing :-)

Kevin


--Apple-Mail=_C282E2E8-BE77-4254-A11E-2F524A2F96D7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0CLNMACgkQs6I4m53i
M0rLlQ//TJ4Z0DrA45wcLcbzv3hT8UGYMz6jomxobgn+5qvTFkWzSgC8ZSZ95UEh
o6R/rnd+t0yWCUOE777Vryr32R7CGKUfXrLIXfy81eFIjH1WFB2/LSot/KVh06Xv
Gob5E7egrI7JU/rA4Gu7OwiTyTZbBTGS8ZmWVCNxpX/Z1mLSe92pOQojitDXgfw/
o3BgME/+wLck7xqOM8c7sb+uAjsL5I0HTCYp+CuUAs0121KoscWt3zgHe9/Ncc4V
eQaUh4O3v89k/ff3gL7IqXsewq2zmg3neL+hChuKodnsb3tjhTcmrg3/y6qjEj6g
oxsEqCiR8uf8riV9SvxN04oFcQl0aboIhqKDQGGKbAy2VROvZ76LzIcyCUBHUsRI
2oceUH0onVeS3cyW+dGagqCqVlSfuhH03z4GtIvcqrKtvCO8BqrAJIrBQrKwoKWr
ALFvJbLMqBrc4ugx81kHuQwzQErrWMPxUP8eCytVcAw1wPl3E06YGuHQ7W3fk7SV
pPRzxWI6kl8FibSI3u7RW37U0S8Vc7zID/QN9epIj0l3sZP+kT0uUU8Cjf8J9Nvr
ZYlD8hlCsT8NFYs6NYJlxwXQYjBtL12i6rXuzbVgJhcCd9j9iA9rCehuRUb8MisC
pO5eS70ouZIPyAizEb3NGUymbRBozCCDN+PUeKHgMGqwSzLZtyY=
=p+3N
-----END PGP SIGNATURE-----

--Apple-Mail=_C282E2E8-BE77-4254-A11E-2F524A2F96D7--
