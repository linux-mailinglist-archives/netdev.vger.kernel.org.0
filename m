Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C25795A9
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiGSI4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbiGSI4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:56:08 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60110.outbound.protection.outlook.com [40.107.6.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B9C13F77;
        Tue, 19 Jul 2022 01:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTJdbqJPzPbDQ2ag2SjY+6VAVko+BVRnylg3/e+lIn1XOitTLCRW5ylgbfogq3HnESaznpLzwUjNTgXuXG+Ymp5L4kH1R6gG5l3ccxV5C0S8dTO0UgvbPm1rBcn0WtstMa/9VDU2Nx+VpKDW0cWn4tjtaOp0tZimYvjsSorrxwH2moqNVdOmvE9RGqzo/7qNRjTTxpVMC6lvEwYv+1ell5QZPWA9haKD6FH9Lu3IY+q3giHsJRofg1l6aCTa3EyVgXX2kNQf9eIjDWFzvcodJmDxgtoC+20GMhMW/JO78EPrK6HMA88cO8QyGBqPLgm0620g9K2V5g9yA8WIejbhQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aomm00VJRl/iu86mBcZ+dPDYGWdDF9yz7NVUfvYur+k=;
 b=Pe1GAXpt98b+rCQXAsuzY4nrBrBHCEo6lqEB3Uljnk6qwLVgHUw5X9vcA/60TiWi7w4mrIt40RQv0m/sArfZak+/0r+iu35DjrNIyj6erm8Evz/kLcCF07fMV5yBjjfh7KgupVlC3oL8QFXCX5NZlbK2FR3XxiK1TEVzoGjt0nru+k/3qkGIrUUKNax7QRZSmJFJ9m8vAxb4yaEh48s6Jkci1ycPogFI/3+FOlro0gdVfIuOroHnSKlt/PvURchAC1B4PgZnwoyYd8aDxIP5zb/McqezJMIbDcQsC0DbzNlQi0rf8BHqNrssso7l4ukPVSNl+smGr4ccKqZI+4jExA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aomm00VJRl/iu86mBcZ+dPDYGWdDF9yz7NVUfvYur+k=;
 b=cvymMs6KhfNK8OQb/qV38kTKWGeIvwozzDdAg7nqYiZ41l7RQZdzWdlzahxK+EtbZvjtjyAbIKQkNxLGsuk0F4iSArSwT35Kz2lMYnkpUdR97v/6K8uH9rG188in1LguQnpyZA5f7wsGX7OpTy5bDIt6DY7u5nMhO7MjXRzYpsk=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by HE1P190MB0441.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Tue, 19 Jul 2022 08:56:03 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9c9d:92b7:367d:e36e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9c9d:92b7:367d:e36e%9]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 08:56:03 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH V4 net-next] net: marvell: prestera: add phylink support
Thread-Topic: [PATCH V4 net-next] net: marvell: prestera: add phylink support
Thread-Index: AQHYmIH7Ix+aAGHCfUeuqdnaoV6+9a2FaOeAgAAAVyQ=
Date:   Tue, 19 Jul 2022 08:56:02 +0000
Message-ID: <GV1P190MB2019F8813E2E3A169076EE9AE48F9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220715193454.7627-1-oleksandr.mazur@plvision.eu>
 <660684000d6820524c61d733fb076225202dad8e.camel@redhat.com>
In-Reply-To: <660684000d6820524c61d733fb076225202dad8e.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 6d7d1be3-d3df-7eaf-e8e8-4f3e71ff70cd
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 994629f2-3da6-48b5-76c2-08da69648254
x-ms-traffictypediagnostic: HE1P190MB0441:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AiviyWebVO9f9FKKwr64fs5bfZzannsJCOFAPesREMbicORQLO8u76QmvO5XwpQ+sX+zX1R/dGlQHHryPw7w6czZeQjfXHt0Lh8hJlBYwzfb4CJSppUTuqbVih7u0GVKVnsbB3XKwofd1AumBTdJXU6kbNcRMAMYNmZ8EdtzMGb63V4at9oPuErLXwJjND0D9VS92kC/5vXeqKzPyk/bm3sudMPdI9fVOFooWM4PKJBzO6Mrf+/YvnLqW3Mr0eemtg2i/i7i8ljPf71a7h9JS5S3FAvdG5nukjnA6TfgSL57DHAQ6XgXnfWLwBczQwsHS6FIw0Z7k82Q9tqyisONl4bW5ab/bbMfaNUPklfKZJ5+utaKokDNkbSzv+UKOSkrNpL5rzJWLpsAYL51Xxg3cr8WoDe27Vfsnshtbvd9lq3JeowRCsZmSJpw4A5+Ey8YtHzEuBaGje8wO7fVwhgntf0gV1fZqyIfnWmcLWKuA61wR2yexyEB54dRaGwaDPV6NgEcWrghnYMrdJXq9tZUiImuETt6YU6YKCRjI89db7XDE3CLeJxWQGBk/nSwb4oi3tjLgTZoyor9A9WkpqpnslTmLP37wfGnAlfe0qdS5cAtCB1XcPhu4/mSIAK6vHvrBnGCmXJQaBXtJMiA24+1Cfzk9Yq96T6rpxTKrt1EYu/ZMP5fdJ/qf0Rr2hqN3+b0kmW/RyntLTRbiLITGow0nCzfAe1tAGv6xFziDk3UohoTf1+0LSAzUlxGiPk8+h7bOesOzVD56H//YrFPU4dds+CTO0gPdHOiSlHJxf2nqr4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(136003)(376002)(39830400003)(9686003)(86362001)(5660300002)(38070700005)(6506007)(8936002)(41300700001)(7696005)(2906002)(122000001)(26005)(33656002)(4326008)(478600001)(52536014)(44832011)(55016003)(186003)(316002)(66446008)(4744005)(54906003)(76116006)(110136005)(38100700002)(8676002)(66476007)(66946007)(64756008)(66556008)(71200400001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ey4i/y9qOZ8iI1AdpIDzcqUBiu1wbZq21P5sTDGr69BXE4EqOVv8UJr9YG?=
 =?iso-8859-1?Q?lss2+AHDzMyhWmSL+R4unvmu4YWbD5Zbuy5hh8uH5N7uQlYdZKiEFJeBXI?=
 =?iso-8859-1?Q?oVr1JH/9q9WQ1AbJmMv/Bs5t/+Vk38RncC4jbnj2RCnPNkkRFwqR3ncocR?=
 =?iso-8859-1?Q?eQn2uPhhVF0hRcQEIvBdDLCtuV0m/cnvBm+0K39WNNeGVCNZnQM0IF3F3/?=
 =?iso-8859-1?Q?RU32yRXM1YWaRnWL7djzitp86gdkgVGfTWjp85PbI+51foHdV/4T4UhbqY?=
 =?iso-8859-1?Q?BEd9sfrx9c2V4lP5airlftlatvGfDiM0AC2uR3mac+JCYbb4hG5q0p1xH/?=
 =?iso-8859-1?Q?6jwZ1J2dDrIP9MCK6Av7QXWrMhoehTLy5EoeuJDthXkf3Rq8qPiJXGHo0M?=
 =?iso-8859-1?Q?qDt0MT20Zvz0OW8kdPIf0y+dL5QFOMP1dgg2wilzGZHHsdq/CKWDuLhGLj?=
 =?iso-8859-1?Q?V07uwhtU7kTxl+85gHN7c344UHXCg63LjKk2R2lhHR6iXBcRTIeIO2P7tt?=
 =?iso-8859-1?Q?2PUs673T+NFd8NargAogtaOqCxFbW9UwCGgF9z2ks9KJifQdM0t+Q2f9+B?=
 =?iso-8859-1?Q?FWr63Po8XnRV6kYA/qNpxluz1sEK7VIZvBNcfCdCO8CfpqI8jZjWfuxyto?=
 =?iso-8859-1?Q?2p1ulHgUwRBYFcIazC4S4QMyBEozgpV00Dl1weLO09ALvIlAAE3srh8TqJ?=
 =?iso-8859-1?Q?gb9wPF1rXgnbC/CEH2q9FQpY65RD/bWnDozsLIVJFgY7DRNbeQVfffnJpW?=
 =?iso-8859-1?Q?mV2XLb2MO1DaCGJdmzKKqkPjP30Bvux4YY+TpvrBPCerkTnt+Ac/ucccWs?=
 =?iso-8859-1?Q?0R+CvOtfMxtmnm6CRmM56k68RBzSkf5HN9Q+56yeNEd+zVhlPmeYwGLFVt?=
 =?iso-8859-1?Q?jfwXAUpmjXTAORx6OFqGaOZaygFnzfQ+yrQX8BJ/ubsthB6K0bIOg0cVP0?=
 =?iso-8859-1?Q?WifnW0LIKcEMHvN3gYWh1Kr2rwEjgBf+mIIky1mDWBsKW5w87M8SBsIYlV?=
 =?iso-8859-1?Q?1IxpE+ODz6t3aIG9cXgYo1148Y2A6hdAe0R/C9GO0KK5TQT/S7WqMyRJzA?=
 =?iso-8859-1?Q?CbjLiIpZZazfWxZaP8Lb2eQR/l5PYuLK3gfrR8JjrmDlAVOf4OyWVneCLm?=
 =?iso-8859-1?Q?6xxA8RLBqFmZEEIgWQGW1Fv0WyWr10fSyEToDYCNoAZU7GuFwLGf5x3Z77?=
 =?iso-8859-1?Q?WjdzG5i0C+aNs6a5VX7shKBY4kDq9u4BD0ZW7zaHkZFxNs2A2hq0+GhMcK?=
 =?iso-8859-1?Q?u8S/nAOsUTGUGPdHGLH116/LeWb4wMU7/o1mhRzle3tk+VNreW6rlkawaU?=
 =?iso-8859-1?Q?CN4TZjNENXj7uYhUmkFX2ISrdsDljvi00KJwdl1GemHmpT5kQuu6K14op3?=
 =?iso-8859-1?Q?5C0HgKwEh74US9lP5oFcKgWYAh/1Zr87EXE+3QIT1xeh06ZO+ZXiE+M+QA?=
 =?iso-8859-1?Q?H6aRIgNxsGBtvO9F+x1lDe/lAtijrdI7DS1AquQjZ0LgcgzPyk4XrM7qjC?=
 =?iso-8859-1?Q?dwK7nVtZqSruK54yCX6FfFcbUIayF0ITsAhPv4AoCb68vttjb0rU8XwcgR?=
 =?iso-8859-1?Q?0aDpHSR9GepBWmlLRgtFFf1e20KU4zaz1BVCaOvt661kv4T5R64euQB/8z?=
 =?iso-8859-1?Q?0Cbm4gOx+Sc8T7D+chxwFbVPIf9cIh+b1z?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 994629f2-3da6-48b5-76c2-08da69648254
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 08:56:03.0097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Liy/H6Evrw3a4cH6ChAYJv4zc6qFt/MLRb8dcF/XLe1PB+e4szNkhk33ERsSHw+bO2W/hhyqCV8ISPFHcPOv18kZ3sTN8mm2Ak/mluleUVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0441
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
>> +=0A=
>> +static void prestera_pcs_an_restart(struct phylink_pcs *pcs)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * TODO: add 100basex AN restart support=0A=
=0A=
>Possibly typo above ? s/100basex/1000basex/=0A=
=0A=
Hello Paolo, yes, you're right.=0A=
So, should i wait some time before resubmitting patch again with changes - =
V5 - or it's okay to resubmit new version now?=
