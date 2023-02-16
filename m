Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627F76998AF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBPPUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBPPUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:20:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E6A93FA;
        Thu, 16 Feb 2023 07:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676560836; x=1708096836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RUPiZugdFwiqkpjiDj9/A+mhQPAugQZkVBDjoob52Es=;
  b=I4s4xqE0602PSvLjcVXBXoEnPtuEL/kyA/S6YVxQn5ZTDJ5G71o1PaRq
   CrNNr5O2bNPUuhLVZY5/HCZ+llYmpu36LpbThIGaAGfupFB7XiQ+uywfz
   0GXKrh/BFNkDt1pqKvtZbTW2QzNgQp4vQR/wqO1NRof9c2h15axeAOu31
   ydHoec4XWJ0i8eDpo6fM7VCHwVzPMeq3jjG3XWaXCMiqK5gGHej0ARji+
   jSRrv2RXiaUJuUSY5xLXBZCvq/oezPDxHZcSeX/7T731jgU6IAptMJHJP
   LWJE+Yg9D0ldpVLfAQ2wrs11l8Px3dloAHpXZXZOqbgVLMC6x1MXATUAc
   A==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="201011506"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 08:20:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 08:20:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 16 Feb 2023 08:20:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UffGphM99nodbXz9huLbxkhlKAkF2V/YMg67jeG2dJxmk4e0ijJCW+PjVcV51242+b21BoQb4t3PiXQLH18axt/AcGI0VE7jZQ3HpClbd5cacxey842m28yruPge0sYRitmOxe/QjRMiJ7IVPYVMb7waGwDtQuTTdSrzz9ZJHZ+bkzUuUpKHh1nGToiG1+rmhswCQ7+xzDXFphwZWQJjPoe2PvnRKR3PY9ZNFvsr1iHArDgYP4PyXNeyg9HMt9geL+T2DrBOU0Tu/2ql1Ztpy6+W+ctKc4JGlow5bzmZZCJxiXWUvxiuWlQtCpvjWYoDpZuX+UCKZvWZfWSV6ugiSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXmjpKwKWD0EmfMK4O/wFSUXzIsmc/2RfMRWnHk3V9M=;
 b=WgNH2m6ovJ3zDFv2lEf9w8P+OkMNw4CNmhA1FJxW4my4wt129Zg8dgu5a3g5tcKGyzju3s3XNeXtmbpBbW6djVXP7eZVgdrdbsD1v1JdWOjra0sLOTQ8rYtpOmRhFjiuAorUq34A5kYGu4URJYhJE0IJqdPSjt78hFhmVZH4Sy3j8BbWh3IbmW1Hu9AICQweQJ/qyUCaSNkSh+sPMCaaJGsebWIO4QIVVSiOo+pQVK9AK/mnJd0rVFPVp2jsaQFJqJ+Z6ZbgGr9PhJbGgWKWx6//wMCroS9vUbR+lInvoq9k373dxUj3gmotGAFj2vsA8bQk69wsGyGA5Fuv0RazGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXmjpKwKWD0EmfMK4O/wFSUXzIsmc/2RfMRWnHk3V9M=;
 b=MnwZLjIICpQ4fW8WljPzq/N0YI+a1QojwkE7wL+0MrhdoXaudAHpx9zXo5RG5Fh/XP5sCbfJ25SdwXOxdXbk/ybrqPDo+cR4DP3R4MlGkZRzdZdO8zUTPXqY//snIM8xbzGUxwhiUCjx6hH1x8g/Wi9KIrndJZkjj129u2/IrsU=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by DS0PR11MB8052.namprd11.prod.outlook.com (2603:10b6:8:122::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 15:20:33 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::169e:9ffd:afaa:aa3a]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::169e:9ffd:afaa:aa3a%9]) with mapi id 15.20.6086.019; Thu, 16 Feb 2023
 15:20:33 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>, <edumazet@google.com>,
        <linux-usb@vger.kernel.org>, <kuba@kernel.org>
Subject: RE: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Thread-Topic: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Thread-Index: AQHZQhiv+XmFBaMwYUuMxkOVxIUy9K7Rr0MA
Date:   Thu, 16 Feb 2023 15:20:33 +0000
Message-ID: <CH0PR11MB556166DDD69AD4D5FDCDB2F08EA09@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <cover.1676490952.git.yuiko.oshino@microchip.com>
 <b317787e1e55f9c59c55a3cf5f9f02d477dd5a59.1676490952.git.yuiko.oshino@microchip.com>
 <Y+5G/yc7UB+ahylb@lunn.ch>
In-Reply-To: <Y+5G/yc7UB+ahylb@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5561:EE_|DS0PR11MB8052:EE_
x-ms-office365-filtering-correlation-id: 60c9f66e-400c-4c7a-26c8-08db10315902
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z5s7Xpvs63hBoUXUbqM93thAslWiTuLEFOg31Izz7ZX4kD8Kt84n9XrbFn8JTai7g84KT2dif2lQHmJK7CCGqUTJux81QKIZmGHuBMYh0MKICyF2FklDUEzpbSq/9jzSncbJq55uZ5m0iQrIQUafas7SvNzMOcecuyuvRRtGnIqX166ZfnFNQgi1a5ZiP5j2y5tSXikyuMowAacSnFNaRYB4EYLJDaiPRaJLoyjiBv5CXwBXz7V6qZJ/OCpn2CTeKdWO6tossYUJWzmIquYoLodF2n8RYHBE2qv9erM9oQ+KFVD8eXsaOEcucjMaRDbQ94yvdoaT5DmLL/CPRE7sT8Y68DH9Yh+dc3TCB7wGSfT3SyT6loIN1FlZ53WegaKGtKiYBFd1o34VW7/JCsg0mt4Fdxnc0asZfx0iGXtPFmedJFvEc7I7iFhHcE4srODLFxZZUN8PMDZBXM5QJk06cQz8XBUu0rXUMkT2YhI4BSfxhA10I/xrCVw6b9x0hkiSTrOqAd/LBv4Fdrzg42e/zjYpyUmmtRlBVj7HVANjCvC7fpd9n2PgJcTeyFZ8miJ4CY6OVZkbJWbKOrvnUq/uGfg7tqTrv74+L+taT+GsMZJo28zJ8wLHYnF4K55UTwEyJEfwMHOFqmwq2eXBcrL6vMsJ2wQmdYxyrc1cgxlOgHFO3gjaiOJMf5Pwa6A0e3QR1fUoP1xw3XLPq/7p5QFehQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199018)(66556008)(2906002)(54906003)(7416002)(52536014)(5660300002)(8936002)(33656002)(76116006)(66946007)(316002)(66446008)(71200400001)(66476007)(55016003)(6916009)(64756008)(7696005)(8676002)(41300700001)(4326008)(478600001)(6506007)(86362001)(186003)(9686003)(38070700005)(26005)(38100700002)(122000001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H33OAuZ3/qQtnhFra6j8q7W87PmwFEvBG5AyJ7sfARGZjZ2DM/1LFAXwrxJV?=
 =?us-ascii?Q?9voiFLh3EnWg5DiGYkhpmKQ/ixnyao9U1SuT3C2pCbf1m1WdsDTdBo6m/znd?=
 =?us-ascii?Q?J19a5Am6xFXdqPxPpFeg6WBqUyMqH1tlDWUQtRrH2/XKcKCcYd52ss43QzmB?=
 =?us-ascii?Q?+adRvVhQZH0zvZeIyK21K8/hzaZtE7gC/I0dk2NgjmPNywPGAm/SbNTdJkOe?=
 =?us-ascii?Q?sHWzuqZzys69GumdqFqLjeCAY+kOkj/eKO1FI/8YNVaXmK9pPcAruy7XsoBe?=
 =?us-ascii?Q?x0khEZDVgje+xb9WqkB++t2BFzH//Ag011XK9WVqqZzSGA5l2pAWk7SYhfAe?=
 =?us-ascii?Q?clT6IQ2Tr1acS/Qc5Uv5VyRBRvfBNSPdp5hOEW0NhR47liGaC0b2GOciCKrh?=
 =?us-ascii?Q?AM2v+seH3AhIOO1QHM+ODuaK/j6GNJnwtClSz1KRGDmSlhGgcokXeWj8wOGq?=
 =?us-ascii?Q?SkuOlYWRWBTu0HRL9500xORzzthDmnHyMyGpkZh97y6rjVJY2KoSLaXlfMHE?=
 =?us-ascii?Q?+notN9eoPRWy6+th1SsV9eihYfIhNMrZRo2qhRbymCaZeZNkQXxTYHhQ5Zzb?=
 =?us-ascii?Q?J4M8/KSpr7uQr5vgAgTzHQuBbOlIKBov7AtK34Kc5QGw5htvUmQNRu14rN4g?=
 =?us-ascii?Q?xLubdlW1aLoxKY25NiSgjVYO9Z0s4pAWmchZK7/+M7i59bnC6CEl1hWnTdSv?=
 =?us-ascii?Q?gaZrRl8dGZ5EDV/GANLcPQLZfdeJeg7di8ZrjmzjrGFtDd7B+Vnqz7oU6CSR?=
 =?us-ascii?Q?J2Tnq+0ZrrtybdoXGsLDr25a9Aw7OTk+IAA7Kz1PlnmrW1/VzawWX61Ifjy8?=
 =?us-ascii?Q?5Zb1HvLCFssS4L0UFyLbu0Q5h5zPGl+zLvLd2KSri7jgUpuj9xKEMpb7tgz/?=
 =?us-ascii?Q?JMz+VOhv7+l5T0EyndtbQn7bkOYubNbdjHguLC02mnDKbG6yOaeN9WeAeOra?=
 =?us-ascii?Q?KWYce4x2/WubOE20qYQOyyjfIiYmOi+zrIA2NlAHx54ZoB2OIRxZVm3dIKMQ?=
 =?us-ascii?Q?8cjc8K5Cxc3i0ebD4VCgLEOwjB4wafUbkkKiG7CyPSb8rxSmxoF2AJ5SZ/33?=
 =?us-ascii?Q?oyglukGuzjTb/11Krl/bmysUhBZ2txDepDdOcLIbGsb80o6J0pwGp7nupeJ6?=
 =?us-ascii?Q?XLHhksC+qDn/W27oZlPz6v8duwr7FnRRpFKUPzBA1uT9TnIHEjIz6+ZFCNw5?=
 =?us-ascii?Q?lvM0NEGIfcuN2Pddx+liS7z6Rmln7D/7jysDt6uGUUOM6B4j57C7sXle0q6i?=
 =?us-ascii?Q?b+BHgaRHNn08lLRmE8a8mQcwohQ5pM9IeM8E+KMQYvEB90KYx+atj5grZ7cB?=
 =?us-ascii?Q?HB5nGnpCHVrK5CErW+eLcGaj490gZwBKI/VfcYBGYVcMHV4gGOe4r36wSXOv?=
 =?us-ascii?Q?mSgUa9ckykHDuaOXtcPThPmfZx//wmmHhVIdtaXi1i1p0zZaQ9SvH3nQMe2W?=
 =?us-ascii?Q?NEcWyoer0JNmdBljRSbIjlh6VV5FXLqnHvmu1pDQC79TtxRB13V9PpkmCCOB?=
 =?us-ascii?Q?NzP7MvZR9k7BA6rF9T2KHmsneTK/3mPgJVN/EfYiPzNjG/uuxE51TArgMOYP?=
 =?us-ascii?Q?eqIJtxiWCRhHCqBRLJae90v1QEXZQ7SOLj2R244m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c9f66e-400c-4c7a-26c8-08db10315902
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 15:20:33.5499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55Qh2I7O/pJavtQdqcYsyIwDBFQkNpWrzxOejCqQ44YrOacr9baeM1EQiuK6h0N+uHTmQgd5AQOxgLMe5GQ09K/7qgMhMSjyWtAuhj50/gI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8052
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Thursday, February 16, 2023 10:09 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: enguerrand.de-ribaucourt@savoirfairelinux.com; Woojung Huh - C21699
><Woojung.Huh@microchip.com>; hkallweit1@gmail.com; netdev@vger.kernel.org;
>pabeni@redhat.com; davem@davemloft.net; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>; linux@armlinux.org.uk;
>edumazet@google.com; linux-usb@vger.kernel.org; kuba@kernel.org
>Subject: Re: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
>internal phy specific registers from the MAC driver
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Thu, Feb 16, 2023 at 07:20:53AM -0700, Yuiko Oshino wrote:
>> Move the LAN7800 internal phy (phy ID  0x0007c132) specific register acc=
esses
>to the phy driver (microchip.c).
>>
>> Fixes: 14437e3fa284f465dbbc8611fd4331ca8d60e986 ("lan78xx: workaround
>> of forced 100 Full/Half duplex mode error")
>
>I would not say this is a fix which needs putting into stable. The archite=
cture is
>wrong to do it in the MAC driver, but i don't think it causes real issues?
>
>So please submit this to net-next, not net.
>
>   Andrew

Hi Andrew,

Enguerrand reported the below on 20 Dec 2022, therefore, submitting to net.

" Some operations during the cable switch workaround modify the register
LAN88XX_INT_MASK of the PHY. However, this register is specific to the
LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
that register (0x19), corresponds to the LED and MAC address
configuration, resulting in unapropriate behavior."

Thank you.
Yuiko
