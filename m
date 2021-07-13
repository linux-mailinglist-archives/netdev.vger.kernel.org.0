Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FD93C724F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbhGMOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:37:59 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:19872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236858AbhGMOhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 10:37:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHUwtjW0JnkvZ8TQtE2yJ+uUR11cCBosMUghiyVoYWA8sKo62BCvQrOw0f+PAkQsaoXye5sid2rlLrhg9Y4dbT9+4jz3vsqH0OS6Y0oDg9wmCz0PB8aFhYkGcthYecY9S3G28dzTkkjdGFCOpi6if6Rjg9WHDAW/OqFtZCIIGHiU0xluW79QrGOpw8cwcPnxxHnayVCXUwKyluUdRyVvDO4Zldj/+HGoh5j7DhGtj5yT84x42pQaHus1xg9toKZR1nRbfVRWuf15jLHDJVRf51qs+iDHNDtm/gJFfBADxce/iI3e+AT6DaFnwQV51ByjYg9qOU8OLk9DLVAcdAkPaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tSzvBaiobpvvu6cpCa6DnYvcPXCQY1gXnx5blAL8gc=;
 b=kRtk/GYPfroj3+icF0yiX2/x8ROl6vHNLo0ytz6nD1vLGLrRVHcsSCbtQI6xsE8J2uBZRXAWcKgD+dKwVguvUr4cHpGElgQifrf1b0wzv4Y9URCSVd8k/8AnmQcKq4bM1fSXET2kCyf6luqPS2PgCYr/JA4gWibBXKkEP7TpsaW9wCoOWP5QOctaRvJGZqUBHeQuu73S+dSikVjv6YxKszm1FASr9ukAy/gono2ClFaDsMy8+8m44Mqja+mTRvfmdr0WZO3MNS89C9JX4+v5yCAjCjq2WMAdEtTKhuYc8mKB+OyFyjmH6z8ASKhmEJr/rEfQoeuSxxGkQkipCz17Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tSzvBaiobpvvu6cpCa6DnYvcPXCQY1gXnx5blAL8gc=;
 b=Gslzsz0DnLecYTg9cMN4Q5ROHLxV0cgtZzIfwZPHYwTgJQkO4LIlHRNkGUAznQqC3KuwxgjMmoLeplP/gEEEZu1CRsqAWS9Rqh50yFTwpE/yNdXZZYAxmoJuH9RmO9o/cPFkZdVFj8CfCQNgE5P5c3zdXfb4Lj9oU+PiJrf3UV4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Tue, 13 Jul
 2021 14:35:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 14:35:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Taras Chornyi <tchornyi@marvell.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [EXT] [PATCH net] net: marvell: prestera: if the LAG that we're
 joining is under a bridge, join it
Thread-Topic: [EXT] [PATCH net] net: marvell: prestera: if the LAG that we're
 joining is under a bridge, join it
Thread-Index: AQHXd8lyrzwSSNiRBEG36DOBaEE4L6tA8VmAgAAHmAA=
Date:   Tue, 13 Jul 2021 14:35:01 +0000
Message-ID: <20210713143500.3uzj2ccawppxox5v@skbuf>
References: <20210713092804.938365-1-vladimir.oltean@nxp.com>
 <bace67fc-2904-1903-71bb-684eb73d1f41@marvell.com>
In-Reply-To: <bace67fc-2904-1903-71bb-684eb73d1f41@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78e62538-255b-48cd-96a3-08d9460b657d
x-ms-traffictypediagnostic: VI1PR0402MB3550:
x-microsoft-antispam-prvs: <VI1PR0402MB3550A9A465ADCF0ABEBCDD62E0149@VI1PR0402MB3550.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pCYiik2mC3OjqxOpZ7MywFrD3I+8BxPVgJ9Hmd+AuvOlpACOcOF5MXOznOd8x5IaISVGq16yf+7EGEqOkn7YL3IX7/GhBGD7MYtK7Gti6LFrxvQwSWEY2KHyoSjjR787xl+lMGIEmOA+MI1dgpoVVdjLSzifubEVvHtA2bpcBpwLz3hNR2B87RliPT7HzPGjwPmvucN4mqcRapfl381hYA2x+OqNJnLAkZInJ3fg6TjV/Z7dLAWiW+ENDhX1/m8m8vCbztzW6YHJdmLLioa1o/qB4zTEcf6u+4SkqJgRzdnKIOSlBlDRB4w34bWwjWVP/xJgVjD4k2uK5q6oQ1xqlmf5nfjLILDR48MnWJ7MHWHuEd9ysGuMZwiDPmgDWKBqmKMWL1KVHEFqhf5S2JMXrf6U5/Vjcz61AMqd0qnAlssfhtVb6iFKsq4uHgF7ocx9Ug+5sYaxDf0LRaaRHKjxT7Yve9yQVfIa6wN0qrT3l4N8O8b80or8Pn17SINBznO/RetpLJ3vjdBcg8TWvY7j6FqpL2NhbZu5WyfgQDcGDZ8rbdbaWtqdpeL9QnCpIbrfj5m/KeUtzBcKbC7rQ/kOO1SWtRKhvrhrBbq/3VP77TzpHDGAxcNTkISR3Se4Rr0KTrSL3omOFW0MAhMGUB/qjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(71200400001)(4326008)(2906002)(44832011)(478600001)(6486002)(6916009)(54906003)(8676002)(7416002)(5660300002)(91956017)(64756008)(66476007)(66946007)(26005)(8936002)(66556008)(66446008)(316002)(33716001)(76116006)(83380400001)(1076003)(4744005)(6506007)(122000001)(6512007)(9686003)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jvg6rtat+34O2gCAx4B7T9dvzFASh/t/K183V/5lbJjgpPWHfVAB6V9wWg?=
 =?iso-8859-1?Q?feFEhbhfBAZTblCSbyyKIikC8RmRE0jHq0p4XoqWwD5fMyEFE5FCBlAbKV?=
 =?iso-8859-1?Q?QkPkpqkTygwC/I7T1an4ARUcyztTgR5MMqiqenCn5eoAQctPk2LnJCiSSu?=
 =?iso-8859-1?Q?+XxsPCGLtfYJ3C3X9Vg+6AWWhkKslZlNkFnSmhxQy4zhFOd4UoYA2jwF2c?=
 =?iso-8859-1?Q?upV25w0KrUFPkTDs7yPNUTl2Ldn6mKSuXNRGyFXf6cPEE1MfJ9H2Uw117N?=
 =?iso-8859-1?Q?VGU2BN1NVtJCj+CRz/s7xHzEnTl1GHN1Ul0GYYPrqppUD6BVEwPTOvqA73?=
 =?iso-8859-1?Q?MF4a5Q89XMsq3s++qsmoDzgIOHbfWPAJ8DrfJbDIZp53LQTK45x/HPscF0?=
 =?iso-8859-1?Q?BMCgn9FlbJ98PQwJHpaLA8C8EHZhtmqXGdnZjjbFxAZDh/WIWQNw3Km6qn?=
 =?iso-8859-1?Q?X2pXx2RWGt77hjVCC+o8aRhBhKFXaWYG03kQBuSVtz1CVixrdKMPlMMcYv?=
 =?iso-8859-1?Q?8PPGDFnuDV64O52w5ngPlPOdGcASHrc+23PVJsbMUTAL4Xm7Kwib+ELO2X?=
 =?iso-8859-1?Q?uNDCl7kQq1SVrPfqFd+3h2mJ8vHAV3AajKPS53xCW2FMIJ0fHvBpLCZE3U?=
 =?iso-8859-1?Q?1VBIB6e2nRyFAkKbQVgFCH/FQ+zNupjRLklregk3VdEWkyb/pwGAcRe08u?=
 =?iso-8859-1?Q?ORKrTkszXu+3oSH056aMpSpCek+XHCV3rIIT9ApE39EYx+HELhBgnsosxS?=
 =?iso-8859-1?Q?t913W0vMbTYjZaKoAGuTnGTdLzcnHfS3eMAJ8mFE3g4hG3w4UpYCajBsp8?=
 =?iso-8859-1?Q?WMGf3x3BUC6YtHBXZpz/XWJdJbIsXeBRYKKrWgofsR1S1Jof17dm7Qk6Dj?=
 =?iso-8859-1?Q?r2Tp+9ZCjFOsHEbMXv7z7rr6otBM/qQE/SNsevAnt3kFyQSR4uD9Di6M0Y?=
 =?iso-8859-1?Q?gt8Up+9+dL0C11IiCDydrS2UY0rufUyRO8ROWyLgckYTj4ZlYlWGbJTA6A?=
 =?iso-8859-1?Q?NPmYAVr+2o4Bu0Qv7W3qGnWxsSENRVzYY1bjUF3MukPCr03hI94ClE8uR3?=
 =?iso-8859-1?Q?JEoHgTImRxdMYBP2lfacbxodZ9ABpE+56nBLXxFt/avF1oBaHTHe6Zaw05?=
 =?iso-8859-1?Q?MLIt6ZFJNEgUPG6CPDBOtTPXzB1oeEns9o99DF68hLuSArvnMUZpSkLdx+?=
 =?iso-8859-1?Q?Pr3YZ1H8AwMyFOTAa3q/prYtGbGaJmq+ixtnP+cSqHVtnkaWhA1DZbEDJX?=
 =?iso-8859-1?Q?9YjXoFH7q675bmMYfaDisgWiki6Y2CM3MYkCrE307YkSJesdaU9T8Llwsi?=
 =?iso-8859-1?Q?kSnXmu0IdRVfDeF9sGAtBRFazAuxJvLH343bk+ppY92W5YYern+OWtlcMZ?=
 =?iso-8859-1?Q?Kh35JhkZhH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6621F89D6CF6314EBEF83D1B34C9941B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e62538-255b-48cd-96a3-08d9460b657d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 14:35:01.0450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OYbRCvdiK3kh0qs/60/GdbTZkhLgQWvUyJFxks1d9rFw/w1q348Y8A+9sKkcFCh2rCsgkujpdeLFfqBrgY0bDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taras,

On Tue, Jul 13, 2021 at 05:07:49PM +0300, Taras Chornyi wrote:
> Driver will not allow to enslave port to a bound if bond has any upper
>
> There is a check for this in prestera_netdev_port_event
>
> if (netdev_has_any_upper_dev(upper)) {
> =A0=A0=A0 NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
> =A0=A0=A0 return -EINVAL;
> }
>
> >   	return 0;
> >   }

I didn't notice that, let me drop this patch in that case then.=
