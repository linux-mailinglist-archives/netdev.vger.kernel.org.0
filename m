Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2DC575EB2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiGOJfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiGOJfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:35:45 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70132.outbound.protection.outlook.com [40.107.7.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E986A7E801;
        Fri, 15 Jul 2022 02:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbl9JkNU0wq6NF7BebYjJh9NMxPJf8cz98mQzEJsQB04pezmbgDysuvB2NXPyzbhZ1kA2IjcedvXMyZWUcf1lZ7vmaagS6g4XB0HnkCrOJuQr9e7V8j6RKJtOsERZgU+LxJu5f/jTNxvSc0+XIvvikBkhJP0abTEI2kKF2BLcdELfL6HLk1AraBuBEfcrwdovDxci+CFe55Anv6KHvi8N/GSx4grc99zSGDcCbFrdB+GhD9V0yvU8WpNmAlYgHOz6rZ0PjVmB5S8c+MGU17nD6rM7HiBm2HmmyFe20wW7nGOdZxLEnphTlRJhELOzvYs0chKcToDSh4ZMcx5nzl/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amSAQTmoDLcEVOizOoM3y5oh6wPqF0lAgBPILmRKzL4=;
 b=fK6tzhCEweTrCbghO6QzlDhbaLFWDDINskYSZVbt6RgyPfNWsnxUejpoEIExtNeOMq3TRf3qkQDpZtt4qnAcNmUcOu0czabuVZtM7J0fXAp+uTWhI5LSXwVJEHiawYkJqiiCGyrLaMCtgzvvkBK32kRi7bzNolaJI2OmCrih+BYYSbpAXzwdlUzk35bCSa6A/2VnsHDXPczLRxfr/v+/gEWDXZcom66R9MvclmsdLXvJm2scCt3xhNmW8An5pH0Sg3esrfU9TO8aAX12oXAlV2eQ63tngBdz1QviahGGtT6GS7qhmIqXmIv2YQm57GNKEewOw45P5d5OvYwMwO3bSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amSAQTmoDLcEVOizOoM3y5oh6wPqF0lAgBPILmRKzL4=;
 b=mc0IjuhSWJkyEszBamHbRTskwnq2zhgPxMuR6R6rdcKLOACOIHD2yJPnLZFVKU1MqyhzjFl2deMu/ZC56Ey+e9rP5Rdfa2evYpQlSNSzBd50IqIAy3Q3FxMf00gv9DsRacoxVDDRru92QrpFFzXYUcELjpC7tXjGXgXRBBUCXkg=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by VI1P190MB0624.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:124::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 09:35:40 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9917:4436:3c90:ebaf]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9917:4436:3c90:ebaf%6]) with mapi id 15.20.5438.017; Fri, 15 Jul 2022
 09:35:40 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Thread-Topic: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Thread-Index: AQHYltzgx1x7mtWY70C8ofiTDPrM6618ugmAgAAd/YCAALk4SIAAPmoAgAAH0YCAAVbTGQ==
Date:   Fri, 15 Jul 2022 09:35:40 +0000
Message-ID: <GV1P190MB201956D5D1C194DC1264CCA9E48B9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
 <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk> <Ys8+qT6ED4dty+3i@lunn.ch>
 <GV1P190MB2019C2CFF4AB6934E8752A32E4889@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
 <YtAOZGLR1a74FnoQ@shell.armlinux.org.uk> <YtAU89nwoDDA0+dj@lunn.ch>
In-Reply-To: <YtAU89nwoDDA0+dj@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 1d8d248c-d076-1598-22e5-8e68f7d6b1fe
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1f6160b-0fb5-43c5-b641-08da664561dd
x-ms-traffictypediagnostic: VI1P190MB0624:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ht1kHWKKFUIOYIORKuFC0Aqi/5MB3NzyaCAdu0cQEUTaIXCz1CmDbUBU3irnUsxW2En1DhzWmbBblJ1dRKSfTf8VUQIy6H5sYmnEkslg5J7tz7ZKJKP5rmTygeTPMCv1E6o9Lq5+Tdvhb7ZSD6QZzPf3JMyUL0KFWZOrPChuKjXrmF5J4xcZCEWZQjK0j+bT0QLSnPq+0O60ZJY4bVTSIOGwqJrTHPVDbEESGNmqVnwTiLcWpt3pO+KKmhBLl9k5gV8WSmwSfF7q9BaSw5Cn3RTL0LwKTgNnVzCSj0vox8D6IVxQ3StEytjg4ly5c5ox//MXiWTcKQKrYMtyNZay5nFawQtVkBgvNZOFP9kppxyW9ZQV92lqtVS+wKz9Wx3vVgub3NERyChU7wKXuwW27G/RnVWh3+GflOgPhIfJq+M6ua5My3JQPz0xXm3aNJZghQu0X1B+kO+23ptf9z/BV/nZo4nysQYrB8BTL7+T8e7zHpslw/oribNfVb1tE6zj++G8QRJgsJdRhqgjfPSGVyXZjUdaEAaHpg+mHiPtnC8btCdzwQaplLGn8cLu5mHG3H+Dq9ImH32qrw75iESa1P41OjFXR8rC8ABv5A4STvNGacI6D14tGFMc4kXevdyrNg1OPwXshtBz8WyNwKFAZuh9hZ6IrazNpFm78OSGhpcmik6T1dTXjSZ8bYvo6bHW8ovyhJXTLANQnsXdkxizExVWgRGiKahbl8RMk4W7HdT/4fOi8Q7kGaog6A6Let4CjsbgMKVxFwqhSm1eDE0hB2xzvHknEkIsjr7kIOWFMBGhn6SrxVVUe+m2dc+Spjcs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(396003)(366004)(376002)(346002)(136003)(66556008)(71200400001)(107886003)(66446008)(8676002)(4326008)(66946007)(76116006)(38100700002)(186003)(66476007)(55016003)(9686003)(64756008)(26005)(110136005)(7696005)(6506007)(83380400001)(41300700001)(2906002)(38070700005)(86362001)(33656002)(54906003)(122000001)(4744005)(8936002)(52536014)(44832011)(316002)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FWKoBCjcsAgN5Hp7xAv5cOLQrlNYdhPKq5AX9bWKBY+WC3gF1QI5XekbIl?=
 =?iso-8859-1?Q?KOtsjdt/qqx+MSRzPY74t6xOw2pdeys6YRer02/b5xe2j6XvqMraAxB8R7?=
 =?iso-8859-1?Q?8yl2HLq2A9EH0NoTn3KwdDVAbq89hlt33qKTq0vvRJlmxvCfDtdPdQDVVc?=
 =?iso-8859-1?Q?OrVgeNIu+NQzA3x2ZMbxLiI1GDenCOsbcK9NImdyHG2SkevZGoExaihpva?=
 =?iso-8859-1?Q?W/Ows3nqNRVQYZb0HQq/SnJTNCZFXkr7faT4mns5dn1Eh4A6udYURAITRT?=
 =?iso-8859-1?Q?4sYQ4MqIY//w0euwhQzB4qGJPN6kbYRD5DXUFeSJFaF8TNGyuoBp3BjEEL?=
 =?iso-8859-1?Q?4NSqea83/PxhBfq0fw4WvcBvHmQrcJXo5otknjXGgzW1qOPOE9V0qruR1b?=
 =?iso-8859-1?Q?kCQBdk4z4p4t51OvKr1YhgIiSnaQO1trn3YMzlT4zTkPNz+GdGEoLlcdBY?=
 =?iso-8859-1?Q?nClvZJ3TLBRJZXDsC6G+XwFyfrcmLBF5RYKMVeA0G0yw22p1gXq84ugj+4?=
 =?iso-8859-1?Q?aTOduOI79RpnP8J00sz3x0mL8RSBFLda4bn1wQyzla85Kr/8NdLeuULiqc?=
 =?iso-8859-1?Q?GnmFs9ntRAT+GUAnjmwdHCbYOaSMZwhFouSzJprWxGQJhGbbzD6ciThg7e?=
 =?iso-8859-1?Q?DrokyoPAT9t1sKUIdhGMjYm8aexVzT9p+jM0DewpMZ5N8umq0wuhLyt0Ay?=
 =?iso-8859-1?Q?oSc5RKAgc+CI3ITsVD1KMaU8lcXKxARf+7pbfrTiyI0ViY7ZG178i7hX7d?=
 =?iso-8859-1?Q?dc8WzMavvhZpjN7ryQ8Me4JOY3aL+HzewOHAUxVnrKuVkpTM6YBlCIz1wg?=
 =?iso-8859-1?Q?v2aCqB5sNrqJ2r39chcHftTJ0Lxrw8Lf8alcOgz5tibNT67Gqvvjm85h8H?=
 =?iso-8859-1?Q?oP67YFpRk6Io2uYzULA21thuPh4N6Z/aOalO9fxAsrmkuGQwsLGyvNGtXT?=
 =?iso-8859-1?Q?lbSGPEHv/Ql4qlGRQo7W1+hNrWl7RZuyGETf7bbQTc5xc1VHLHcxtmNkG9?=
 =?iso-8859-1?Q?C0pw8QjlDHmWQc8Svaqo2YyitWh7mkBCXA6fqhmHgJSiXhuY2e3NEeBpH1?=
 =?iso-8859-1?Q?EtDJRVl/JhbwyncXsfL3tVoHO8ivvde4DJTzyi6PeMk1OEAZIQyDqdy+lL?=
 =?iso-8859-1?Q?x8xEAZK/oTbO6enXh2Evi++OWnjK+d/f0VVATdlaYKOkZL3kt63wn1W3xj?=
 =?iso-8859-1?Q?UyowdwKo2JLjG2iEfl4EsKZ4m8ekH7cW7+hnhXxlP5wEZdipz7LK6+gK5w?=
 =?iso-8859-1?Q?ytNDPH1Tk2noMUDQxb2aVhFLh4OsmopAtRyRjzRp0R28CL5qUhCISNEKmm?=
 =?iso-8859-1?Q?eMdRyA9ZfTM1TIrtOPYieLw+Nw3Dq+PmUVymWrCRjsfXbDcEIYww/XKCA6?=
 =?iso-8859-1?Q?SKkjHuuiXd95bqfGWuTaVn4LhSd2UUYrRX5Raj4ZM3UtpnWB267eGJTj1b?=
 =?iso-8859-1?Q?Wz/bhOnvNXBowCES6CgLmwGwAFigcqvnkW1nit0FazFVaCVPqAKfCCghQy?=
 =?iso-8859-1?Q?azrjC+rb8oUCzySeynBdXOmDW9Je5wHbzY68dxtLhG3TWRdXvAkGicMZAP?=
 =?iso-8859-1?Q?A6+qPuuXrFBT73Y499EwxG6d+j5i9nq8fxEfCGVgGCI+SEUMZVtpnoPfkC?=
 =?iso-8859-1?Q?YqNKi76kffMa+sXGdBh5oEl6M4BZthWIzHicvJTRCnNUT28Q8IWmImmw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f6160b-0fb5-43c5-b641-08da664561dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 09:35:40.6574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cU3c6Vcu/ntkCCpoqn2JZtDv9/v8TxD/U7jTowMzLKQxW4OVcx37ze5ZoB/ns1jYAtax8sn6rFcNVQ/oRkoldUFpzJgl9NWMwffr5kySaiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0624
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,=0A=
=0A=
>And also think about forward/backward compatibility. At some point=0A=
>your FW will support it. Do you need to do anything now in order to=0A=
>smoothly add support for it in the future?=0A=
=0A=
thanks for the comment, that's a good point;=0A=
We currently have AN restart HW API call, you are right, however whenever w=
e add AN restart support for 1000basex,=0A=
we won't change the ABI nature of HW API calls between FW and Driver.=0A=
So yes, the transition for adding 1000basex AN restart functionality would =
be indeed smooth without ABI changes.=0A=
