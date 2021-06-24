Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FA43B3188
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhFXOlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:41:13 -0400
Received: from mail-eopbgr1400135.outbound.protection.outlook.com ([40.107.140.135]:30688
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230008AbhFXOlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 10:41:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxlZP5/qfPN6Ktm6+rBfyL6vhULuS8I0spjgSUwfsvUinRGyPNxESqBiG1jJA+ab1J+SACLPKN65C4kJ/X0jq6btLjL0S5UMP9AGrFRO+oK2QikUXkQ0xSI0OsqRQ62Oyzx8JmZ6WZ7Ku6ZzCQPX+4hYb+0lw9tu4YiON3AUsmMHgRp9+TpL90BthGKwADRolGGodfL6mf0o7KbUVYzJZ5aNfZyBlkKLwkVvraAwHQuG6zLIgou7VkwxKBxiQHMw944Vb71vRWPHr6NMG0/xRAFpu/H/g4AZxU5UwjPLE5z5u3IO6LQw2mJX6nTcM9WHWrJS2WSKLH1k+GiYL8wMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzkds1e0hWi2cnycu5HnZ2TJyaZqX16ajKWp6RVFRDk=;
 b=gNtU2NwFwgXbd17t6E9G1/7+NIzN9nL8EWV9b0496Xzho/S12gbyoJ2TlUeF3xNNeAw4J5r3ZPHLXv2+U/A69VbjRYSmf62WT5rIBE9sCy2zUmBBLGnhC+YQK7bt4rF4x7kgnaVZLqQxse1NbvAnurtyyN1yqEKnlNjqbE4/mlz7jq+Bt99nyE/LMaIdZ4pFQLQYZP6GepWOYlDoGHJfV2YGGs61ttGg/qdOasYkT2UYnc+4+ImATybkL1npxuSvMHK7UW+uRCz9zDx4GZWU5YEC7TCx6C5Bshyg9GzVCXmOF0vqyzK1pWrAkfeZrcQYwYg8aEdhswX1xCvS8bSz/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzkds1e0hWi2cnycu5HnZ2TJyaZqX16ajKWp6RVFRDk=;
 b=oxpTL54qoBYJC8O+thF4bRsNCaUFlM02hAs7HZEo8y1nxRC5PJjH9uP46JA62rEclVyjHjKgf2Mh4dz/IboTHFsvQDvTAgNekH4/nT7b0zzN60ly9makw7BF8A4IVkGrHseYhwtPXEfRk/iYi/DV1dmfZFO0Rm18VM0SHIG4wr8=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSBPR01MB3142.jpnprd01.prod.outlook.com (2603:1096:604:21::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 24 Jun
 2021 14:38:46 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a53c:198f:9145:903b]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a53c:198f:9145:903b%8]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 14:38:46 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Thread-Topic: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Thread-Index: AQHXaD6QH3kS+d8DxUyFpooG2wAFo6sihNkAgAC1sPA=
Date:   Thu, 24 Jun 2021 14:38:46 +0000
Message-ID: <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <20210624034026.GA6853@hoboy.vegasvil.org>
In-Reply-To: <20210624034026.GA6853@hoboy.vegasvil.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e92db02c-57fd-4b85-d672-08d9371dc61d
x-ms-traffictypediagnostic: OSBPR01MB3142:
x-microsoft-antispam-prvs: <OSBPR01MB3142B89FFCEE4EAE6F549A1ABA079@OSBPR01MB3142.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lTu/3UzSFt8ya7kSevOWzpWlYYzVIdDdd0u5RhapYXymjAcMYrSTKtrmooTyoqZOrwZxc+xAu4bUR/Fq7FFfpiMvvlomwJ95o5EMiVmoSSE0hjt7irDUJb1aeu2gncTUXKv4PS3CvZ7meDKsf47kUvv0ndsc+aO0+jjV7+zK2FQoFSC4hbRF+nM3Mu8Ai+yYLBl9oJpbL3hwI1lnQjzabANCJjnSCBcgsduB7JpXtsYDeQawTkrYtC92RyftYXFV1wYQOK3wtasgCz8KMxWjg1yvd/ufXkPg+6gy2b3ijiPxPfrXXk706OLBWzzBJv0pR83mVxIE8SZI6yiHM0gz7HgIUNSoDaQWQehT7fw/ETJKaw3ExR9kqPMBZ5b/VsvUrGLcBs3JTfHLvayaPX4AoEYQAJkMPYJVaTUqSVNmKz2QSQ3e6//y5Li9+wIs5nfnxmkabcNa5Ia9Et7B2/sKLMrQmrCjCIfleuux6Oz8sWo4ejCwodY03RaG4eLs/0XChp/uKWAIQVsAqWZbZ3rXF58FRskmOaks6WTlwJAtCke0EL1/B68n8s9/uSIBNW0iv7YK+zpQ5lXrNrF2tjGd3Vm7OEovbh2nx89ARNa3dk/cXbrBzlgsEqiLyg1t59AtQzX2jqC9wYMcSQLB+WBr6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39850400004)(136003)(376002)(6506007)(53546011)(83380400001)(5660300002)(7696005)(55016002)(26005)(9686003)(316002)(54906003)(8676002)(8936002)(6916009)(186003)(2906002)(66556008)(66946007)(66476007)(52536014)(66446008)(478600001)(86362001)(76116006)(4326008)(64756008)(71200400001)(33656002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tJI9khrz7FtE53poteWUUgfJEIBSsaQn2CrlfoZXJyHDsAvtLnn8UAlBYD1c?=
 =?us-ascii?Q?LidpI9I7d1H/cwFCvxz2Ci3b5glryjGphqiheDFV72CC+a77pRs74OxNIepu?=
 =?us-ascii?Q?svIheM/sm+OW7+ePOqD+cS0O6TrTWDugfpIvp680EUa3JzCBzHoY2SI15cgu?=
 =?us-ascii?Q?LWiNExfp5ml0yDVwcrXwYyV0huDR3qaOMAXBQlfJ5hl3lfOxnjSD/g15vNdR?=
 =?us-ascii?Q?3Ua6ssz+TEegVRnNBHaUdBU8lA15NsrTok7jn5ByJAM6gC2G1/9fuplF0pSA?=
 =?us-ascii?Q?wgb4l8xT4SNhMn+LwRTtC7blp+pJ/5GSbzJXt5g0v3yB4qvRxP2Bpqx7LXkl?=
 =?us-ascii?Q?9Fa2ro2g2jv0qEzVcIuacLJ4iFh5xrLfn14GX+y2bBt0uF/mil+lcnNaALG9?=
 =?us-ascii?Q?7rYoRK0wYrPQ+5DR0Od1eECP50wz4U1RDaBe+JyfLnw0EqtVktEqfPiti4Ka?=
 =?us-ascii?Q?WIg3GoEZUyfimCueXQhg6icb433gnmIMMv5cBBNmPNuAKW97cQCLBaqELBE9?=
 =?us-ascii?Q?d+4nOpMarYnjrkjgptxCEHT5w7a4SSklpYsBNWjLk6iKUjALCOTxoCSuGKdH?=
 =?us-ascii?Q?QaCETd+pzBU+uc2ixuekT6Ahnck3slNhR9kAj9nAVG18O7y2GThwmCVsps0H?=
 =?us-ascii?Q?evxn6Tw+O/Ktkn4jECBTCxluIRZK90ugxmFBoVOAaIibRfI/jwcmK3EOV6u7?=
 =?us-ascii?Q?q2s5MVFa0ZrRVXe9hv7i2/u7/v/vPE4cWhWlR6ScrpPpldS06MIuzk1+mFpM?=
 =?us-ascii?Q?Uz51IFY6I5BR/+4stlfr/iad8tWsBXxgxHECG4yyciI29kHMSBqrG5T//C8b?=
 =?us-ascii?Q?UA6bdszPBOlL388Yu6VtwgMWLUCimFe49/ctLdbOR56phqfGRj3gM2eL0M42?=
 =?us-ascii?Q?GM4gXz/+Qo8HKvmbykZX1KPKK6zR4qF+vjRQi9SDT5edm4qRXlA/MYXGbLxO?=
 =?us-ascii?Q?rynaLDxE5OK2pqprauPcVtdBhGWa6/5GLxGCkRv7DuvIWiwpIA62E72EX3Y4?=
 =?us-ascii?Q?75UA5IKoxMvrY6/4iPeQNhHcag//3ydJJTRylD+ygvwv79xh0pdAAONAyBz8?=
 =?us-ascii?Q?q4ZpZHtxme8pzW7ZqTHuJ7+5BxgWbdAR2R8xMj4KnzX+eI1pdc4OV6pkveuV?=
 =?us-ascii?Q?SXMPmrrQGTb0G+xiW4yaETE2hrKHqfCIL2buqf7yhiOzuH3NHcLbWpXSACjy?=
 =?us-ascii?Q?8uGdvvXPL5WUdPSi7xx1eL5xY8ZT+2ExF1nLQxWGorA8Zg8SeydyFcUmNbCl?=
 =?us-ascii?Q?ywrrUI7/rAEug7bhfN0bmjocSlEv+9dIxiw39Va8gtblkiZTROGjqlAn3IN7?=
 =?us-ascii?Q?fDW2qU9bHhtGjXXPMtSx5cpD?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92db02c-57fd-4b85-d672-08d9371dc61d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 14:38:46.5824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FadfH2YSjM0I/E90Qwul4Dr5Vb51jpQVIzFGG/ZedWyoRMKfi7lSnEDX/M4ML81VRdb8tLeSUHKy80q3RRJJkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: June 23, 2021 11:40 PM
> To: Min Li <min.li.xe@renesas.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
>=20
> On Wed, Jun 23, 2021 at 10:46:24AM -0400, min.li.xe@renesas.com wrote:
> > From: Min Li <min.li.xe@renesas.com>
> >
> > The current adjtime implementation is read-modify-write and
> > immediately triggered, which is not accurate due to slow i2c bus
> > access. Therefore, we will use internally generated 1 PPS pulse as
> > trigger, which will improve adjtime accuracy significantly. On the
> > other hand, the new trigger will not change TOD immediately but delay i=
t
> to the next 1 PPS pulse.
>=20
> Delaying the adjustment by one second (in the worst case) will cause
> problems.  User space expects the adjustment to happen before the call to
> adjtimex() returns.
>=20
> In the case of PTP, if new Sync messages arrive before the delayed
> adjustment completes, there will be a HUGE offset error, and that will hu=
rt
> the PI servo.
>=20
> So it is better to accept a less accurate jump then to delay the adjustme=
nt.
>=20
> Thanks,
> Richard

Hi Richard

Thanks for the review

For linuxptp/ptp4l, we can use step_window to adapt to the slow adjtime.

I have tested this change with ptp4l for by setting step_window to 48 (assu=
ming 16 packets per second)
for both 8265.2/8275.1 and they performed well.

Min
