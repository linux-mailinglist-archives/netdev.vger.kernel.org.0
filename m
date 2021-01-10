Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124782F088E
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhAJRNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:13:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23380 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbhAJRNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:13:50 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AH1Bhs026734;
        Sun, 10 Jan 2021 09:10:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=EA09BXZZ2y3FUb0dHwuB50QcFz/2bUp1k5QN6GaDgqo=;
 b=XI+m6WXKqpinBIUron9CK0R6A19uA15JNwj47W7rc8v3wTr4sB2o+OofGIkH2In1UUkU
 2bQQVDfvkre9UtBJTBaXQWs/OyiZRsgBqcQdknVfqVqhMBPE8QrXiyhSyyYUZQiW3JfD
 7WBwFpPXArus3Ahs0jDkLU9ZBSZmjlInlkq1vHd7J2bICjXWR5HqKS5VL7y2mGNl7p8T
 aZy52ju02Rm/cj2oGOhefLyTzyE9qL49zXbd7D5dKRbFlP1GY5lN9G8YOqlG8/HnvUED
 nBoHWrYZspGJDIiGGFTuTr5VAZd/1ulQKjICXoH12RG2ct3A5+1T3DdlrO2igoLvTVSH Cw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsj9c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 09:10:56 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:10:55 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:10:55 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.52) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 09:10:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clyczysSwg/5FxYfWqxDT9dGOmTFN+tZQw2XU3S7hYojqkMVskFHS98LIyIyjuKzlGxYPgyw9u6yrBMBGOBsd4MaNdAsIHCeRWb7N4dTJ/t7VZzC/RxPkEFcPIa3gf9tSqdU8DPoz2bBJzhVjKdBeotuOB8S6JT4enDfcGakzXU0UG/TMA8yk085FIcv0DpOIyaYOJFRry89j1fnr5/YSWULYpN7TongFDDD5OO3IPSWUf0dDH16ivcrbkCfv/r47OjVK/5RKeqMRMYbIdBrTshg8du2vj4lvkbYY5bzDuAlgFIxObB/IIKzjrwsoOYkjpncJm4ZKVahWMRbhrbqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA09BXZZ2y3FUb0dHwuB50QcFz/2bUp1k5QN6GaDgqo=;
 b=h08fFFpmdNrm2fJwO50vVv9t461dJ1xDYL5YHs1qDWuNdF5QKhE4WYada+1zC+kTEh0w9jtlDGpYV3AA71F+WF/qaSZbeiOZG4L4kFn6ektG2L94kDougtKcqO7BQ0Blpd59gDV/kaEXyhevS4zmQ8k4bvYN1VXLc2rWwY/1ni7zyva/mYxc4XBrdMqPzCviiAPqwY/xbKPo7PIA94FONQFOeYUIFfleRD8oxroFcHxcZ53dokD3EYsi0eTGNOvyKqKtj4qK9mf2OGHH0VSf07onCDlXjJpCrHVmZ+dMPfRt77ejGcpGUpU3D2zjL6V0cvzS7NV/OUdZoJ9fbHPFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA09BXZZ2y3FUb0dHwuB50QcFz/2bUp1k5QN6GaDgqo=;
 b=JE4oK4F/ZgBIl2eTpVTjTJfjpndo44tVI3SsgMg0+g2CigwLFzSrdB+xABGMf9sh5CfkOcS7PVS4keLcRmr3rFCdHfuS2po4roaLAuoCG8KTPq00Ec2tNdnlQyV6rA6Tzk1b4qkobFmgnfr1vfBbJa99N/pI8vRGdKGm8L5z0ys=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1263.namprd18.prod.outlook.com (2603:10b6:320:2c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 17:10:53 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 17:10:53 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Topic: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Index: AQHW52WtPfi4P1NcGU6aLxAkyBGTaqohFpOAgAAAhYA=
Date:   Sun, 10 Jan 2021 17:10:53 +0000
Message-ID: <CO6PR18MB387341801046DE9663E2FD85B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <X/szqUG3nr/FrZXS@lunn.ch>
In-Reply-To: <X/szqUG3nr/FrZXS@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b33cadda-e707-4376-99de-08d8b58aaffe
x-ms-traffictypediagnostic: MWHPR18MB1263:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1263A7D69A1FA4E8BA555B9FB0AC9@MWHPR18MB1263.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QR/oKBduAl+Kcg8RgM2MKA2JRe7/QSZARllAjpsbl22qGTcZPU4uUDiaencLkGwcHZ98Kf4o+hcMZsFQ1VBMgInZ6LjZx+Y8CNdKNytVyVv6WQtEPv3tH3uV+P4Oad3QbIbwMetOmvXDdjfGH0iem1kiL6lmvZo7XJ9gCMG5L+ZIXEGVtQYVCOOh04MmNmj/Xx6b0oFB8pLhLd9i3I+73MM6RHx7YAGm0BvuLrttKUFg3w70GazxWf4EurPRaHP968rnsotuCLGy8ODbVxefUR3G4VYqp8LQxfPklC1l0PxO7bhL6lEowiEhiF0lYdjAn7o+ahfPDEf/NLVZ+c1+VHGLn1T+OMDzONR+GE+RXUDdliOxm1zCPVbXTXdbf0WAs2qBkmILg9TVroABWqStfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(7696005)(8676002)(66446008)(66556008)(54906003)(76116006)(53546011)(64756008)(83380400001)(86362001)(66946007)(71200400001)(66476007)(2906002)(6916009)(7416002)(9686003)(6506007)(33656002)(52536014)(186003)(55016002)(316002)(26005)(4326008)(5660300002)(478600001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dIUdT1uB8h10FOwR6XHF56UDUEJPs0TKqMPu050k0ATtE5xs6+YQJRmTzzxb?=
 =?us-ascii?Q?IIa+2OJPcPZ0/Ps1X6+1CWkZ/53qUGP4RxznBNg/uWEizNHlu55SiBHQKF8m?=
 =?us-ascii?Q?gjnZcd24by86n6EtXObJ2L4JWwMZWArFhK2sqvuqViz7j7T1cxpSi3Jo9eeo?=
 =?us-ascii?Q?+a8nmUCw71/zKl3/wvPmBuSVSqy/RsTiWea+ZL6p0dJvmGRsWVlieg8ji1It?=
 =?us-ascii?Q?Sfgr1NroBzP/FVZ+A7Xt68KJYQ8NIHAYBbcfgr9KyhM6ilUfTpM8r0kwjXWv?=
 =?us-ascii?Q?F4nTrk8NvpQmqW7fiJjSQHBG4kJlJrZ0HcmA0eelKbJnrXJ92zX/KMPyoGBm?=
 =?us-ascii?Q?ioLAZHVJockrDFEFQtncXC4qPbpLGBE8kTq1Y9Uf3Y7G3WX/ZlCn3AMPZfc2?=
 =?us-ascii?Q?yCLMDusKTzx4bQV3lFTNskIEFDygM7be3xjC0jPw3FoYEOVmJUd9ms8FmlAT?=
 =?us-ascii?Q?KvFbZeg7fm5UsStfWoiUIfNI6//hoIFRjCQVgETFev8P/jCGDvQ/dSSMPrBB?=
 =?us-ascii?Q?UJ6fJhdFG6Zd20MgLioyD36zeAiVr8zO1FFZyQkzvxA9xLRWMSh7L5fSroyw?=
 =?us-ascii?Q?PgquaMnclYxgm5e3JqBfO7irlnDPIXekPXwPpQVy+UjoiqhcLx1RLU89NgMI?=
 =?us-ascii?Q?BWEtpGUWGYl5HvyEiZQTErcK/ctYQYMwWrHVhSFbJV0vMwcw8a0infcGeZpB?=
 =?us-ascii?Q?UoRLYmWUBmagm7RqHz+KleF+8kDttkfrOxgKzrWnViMgSujzMwAiYAqU1Mh/?=
 =?us-ascii?Q?r39KF8Y5HJSfkqmp0iLpIG0uiUvjokp78K+zFomscPK8Ryk8gWZs74ST/X0E?=
 =?us-ascii?Q?zma0RAhQgppgKCykFSaDT2MeZVGN8UUzgJ3lnkQdBIR6alrHru+G0rvjj/uU?=
 =?us-ascii?Q?tU6jvAkcog2BFpVNtV9MyoCnPsjfIAge/swzCXKYqdBxQLLvPmagINIHRsMc?=
 =?us-ascii?Q?Ipkmb34uNYpr92uPYcBh5yfNJmb2YkZrYhrdPLacMvk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33cadda-e707-4376-99de-08d8b58aaffe
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 17:10:53.4732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wZIyOL27/1sTGZ17Nb6In+k+jeM1CL/aySREONOnYGgGdR0c6U5CBbfVowr3QnPRRbNZDGUVjaQKNmEAFo7RLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1263
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, January 10, 2021 7:05 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan Markman
> <ymarkman@marvell.com>; linux-kernel@vger.kernel.org; kuba@kernel.org;
> linux@armlinux.org.uk; mw@semihalf.com; rmk+kernel@armlinux.org.uk;
> atenart@kernel.org
> Subject: [EXT] Re: [PATCH RFC net-next 03/19] net: mvpp2: add CM3 SRAM
> memory map
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> > +static int mvpp2_get_sram(struct platform_device *pdev,
> > +			  struct mvpp2 *priv)
> > +{
> > +	struct device_node *dn =3D pdev->dev.of_node;
> > +	struct resource *res;
> > +
> > +	if (has_acpi_companion(&pdev->dev)) {
> > +		res =3D platform_get_resource(pdev, IORESOURCE_MEM, 2);
> > +		if (!res) {
> > +			dev_warn(&pdev->dev, "ACPI is too old, TX FC
> disabled\n");
> > +			return 0;
> > +		}
> > +		priv->cm3_base =3D devm_ioremap_resource(&pdev->dev,
> res);
> > +		if (IS_ERR(priv->cm3_base))
> > +			return PTR_ERR(priv->cm3_base);
> > +	} else {
> > +		priv->sram_pool =3D of_gen_pool_get(dn, "cm3-mem", 0);
> > +		if (!priv->sram_pool) {
> > +			dev_warn(&pdev->dev, "DT is too old, TX FC
> disabled\n");
> > +			return 0;
> > +		}
> > +		priv->cm3_base =3D (void __iomem *)gen_pool_alloc(priv-
> >sram_pool,
> > +
> 	MSS_SRAM_SIZE);
> > +		if (!priv->cm3_base)
> > +			return -ENOMEM;
>=20
> Should there be -EPROBE_DEFER handling in here somewhere? The SRAM is a
> device, so it might not of been probed yet?

No, firmware probed during bootloader boot and we can use SRAM. SRAM memory=
 can be safely used.=20

Regards.

