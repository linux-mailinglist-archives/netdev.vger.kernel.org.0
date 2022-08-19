Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C959984A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347926AbiHSI7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347898AbiHSI7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:59:30 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Aug 2022 01:59:29 PDT
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.86.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634B5D9D6D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1660899567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7b+Ugrz/rU0Xa+cd4m4FSbVvRBBiMGGvH4oof3Vaqnw=;
        b=at9Mu6S1DYlGMccEaPqh2nLD3AzMHOHpJCU6hmmuoHmdIPdiyQnD3qofE5i9Ln7REzLinc
        AcFW/Na3EFhy8FKbbLC8CSh4A73UNihwCGlVNXThYxRhpDhMziGdHiB4VQR0IUBKO2Lx1W
        vxxrGa/RVUXmitjr9zvZi6VstMV7KrY=
Received: from GBR01-CWL-obe.outbound.protection.outlook.com
 (mail-cwlgbr01lp2055.outbound.protection.outlook.com [104.47.20.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-315-U-i2biVONAaF60j29slFkg-1; Fri, 19 Aug 2022 09:58:22 +0100
X-MC-Unique: U-i2biVONAaF60j29slFkg-1
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1ba::12)
 by CWXP123MB5451.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:176::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 08:58:20 +0000
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c1af:60b8:39a8:75cd]) by CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c1af:60b8:39a8:75cd%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 08:58:20 +0000
Message-ID: <9c2c52a9de5fdcc1a3a76f564da4c20db098e9a2.camel@camlingroup.com>
Subject: Re: [PATCH ethtool] ethtool: fix EEPROM byte write
From:   Tomasz =?UTF-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Krzysztof =?UTF-8?Q?Drobi=C5=84ski?= 
        <k.drobinski@camlintechnologies.com>
Date:   Fri, 19 Aug 2022 10:58:19 +0200
In-Reply-To: <20220819082717.5w36vkp4jnsbdisg@lion.mk-sys.cz>
References: <20220819062933.1155112-1-tomasz.mon@camlingroup.com>
         <20220819082717.5w36vkp4jnsbdisg@lion.mk-sys.cz>
User-Agent: Evolution 3.36.5-0ubuntu1
X-ClientProxiedBy: LO4P265CA0139.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::14) To CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:1ba::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b11bea40-2ba7-4384-4f2b-08da81c0f71c
X-MS-TrafficTypeDiagnostic: CWXP123MB5451:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: O4Xo4htlVbSg+vcVWIscd3sy3a5DNiKPsSyfTeK3B0z25tHfrIT0RPrui9BRTteQSIS/pCk+RMAOdyvBrr/qi9lFHZF4vp4XBQlSWrdwT/7qjmQ1pV2OwwIKoEpTxLXdlL67OAR4/RtEUB8xcrseFpLD5CSO4wKu178ZJdgJTNKT9Qprk4CGNc2UAdYQPTLowe21sjmuy3nXvvsGaKP3B7gw/7olFY88SDXxdWBi+LMdIkRP/0Zcwxvw4SgOkQcw/lUsIl96eyNGYfUyyvruqQ1wab5TvEDBEIW99i24CSeZorKH9M+PJaMucBAPamXWL8ly+XF7uy7jjRNQAI557jXsXFMCoiuAz9n8t8+4KRErZtkLK8QbTVBP4ik2M0A45xU4k481WrGqedeBHwbayiSrg59e3VmEhab8UZHGNyzJl1ucwnfF8lv5LqumR8IbyKKv0VKc55mU9HsQjXxfgKWcD/1g5AxGisBM1SG48QbOEmPw/LWZ7Y2m1wPLpn0PCjjr3H4mm1W6cdsoIfr9ne5W0qm1WcbX57L8IjRwapQqnbOd1Dx6snElWM9o21RHqhQe5hO19zsJrHyEI/m1RZAyNb55Y0UxnF6LEfT+AdIrzWTGhbBX9Bn1Qj+i0x80DnwJwD7FHZ/C9x1p6joOSCSMi6DvlGKBxwMWF8FtnoR+JGuO/5mAUGFqpHpRHqhLSg1ivneGMG9wF4n5I/9+5wVVFQwfaTlMO0656Wjnh3DAjZH0SjzF7nLsmMsC46XesAqIoAV//HO4pMQuXv93Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(366004)(396003)(136003)(346002)(86362001)(38100700002)(186003)(8936002)(38350700002)(5660300002)(2616005)(36756003)(83380400001)(8676002)(4326008)(66556008)(66476007)(66946007)(2906002)(41300700001)(478600001)(6486002)(6512007)(6916009)(26005)(6506007)(52116002)(107886003)(316002)(54906003);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WjCGaED7EjiSSsPCIn9GyWluoFReqIOK9ggOJf5rdUBxB2pFbyS5Uy1v20QA?=
 =?us-ascii?Q?hY/PS5vKqPkK/TyW0IRLJmqwyKL4DqUbKyXXIxcqlDWmuWw3P6sFPjxHdcLf?=
 =?us-ascii?Q?iIvqXPcRxLGriRRbQZY/JbGhvIWHyRnim9Wy3PxFEJ7R8MOoOaNnqsLjO7go?=
 =?us-ascii?Q?X+bxvk/C6sdwzo/HSp5d+GPpjA7QVsNcvujMAGx+xsO2mEOzmH99dWqhJAaW?=
 =?us-ascii?Q?vMcWJEoS7KU/f7OyEgJ1B7+skaPTEQ+fZTbjq/W3CbqCtDUezvPIi2401dWM?=
 =?us-ascii?Q?nuOp2zjorPLGZH+kjI3SK/DWmynCynVDCngHdiFwhSj0F9bGJMvuOL0Jhg5U?=
 =?us-ascii?Q?whACJrs6+jmiux9s3nBzDhk/WeQwUtHqkXuh16CIgHcEY4LqzFGM1aH8wQnG?=
 =?us-ascii?Q?CetodtJf8XKVujYWkzGYpH5BDvySbkBYioy/QIlXL3wy6ui98yYGHU2kJ7RB?=
 =?us-ascii?Q?C4onOTBXWYYbwtmWzZdb7iLi44QXf67XxYGZ7foMY3ow0/uDoJnQNskVgr5a?=
 =?us-ascii?Q?La+f4dxQ+La0J+CbB0wO3oM4lK388eEhl7lXKPe3VOYfnX9asvoRvd5JE9Cg?=
 =?us-ascii?Q?MrScOzail+u8Z6ufUlNPu69woCIZdgidwDAS+MLUsaALqkOhS7wKr0hJ4HQv?=
 =?us-ascii?Q?A+LGiL/8uO4uc4+baa9zOKL5PTnO/uh1Zntek0khZga663kzD+wrYq0LnWyq?=
 =?us-ascii?Q?/ci11zmtyfS0J9uPpj0g0gpEHgbuwKvn+8R6Q5eu+XSJAXjWUdrYnAvwP2Nw?=
 =?us-ascii?Q?12OG9AzqiSlY4EtOzT2TpL7qA/2Wd44tTZrIK66DiULukpWtQh+pMJG1J+f8?=
 =?us-ascii?Q?hPOLQSTbAV/iQwuVqdHgHJIj0oiZoOk2kK/qZqBx8IN92YZn5dHnYVA6SImH?=
 =?us-ascii?Q?Y8wRAYz69N1jlMxIfOWhTRhJpbVuYCYEltSjl7McBmtroDVqHD4EuREEzSN2?=
 =?us-ascii?Q?dN6k4qJNdKBFnJAcWake4L04m3pG/yyloiQ3jV+shbEgvFCoqY1hw/aBkwlY?=
 =?us-ascii?Q?pBHMssuyXRIlgoKEK14lmusiQc+TzCbJrkNxYOLZ0c58tXEiIml3zU8n76AA?=
 =?us-ascii?Q?ETynjsrpZ1vKEyZHDOQduzo8n/oM0rRyEv1SNc0E8676fIqfW+SDDgE+GLC4?=
 =?us-ascii?Q?KBY/wYyskptq5sMLiASaZigiu/yTQMYcRAfITQykDaAmcd5c0NQejQxGbHva?=
 =?us-ascii?Q?0E5Vg+dKBLsisW8FGSHZJGrtSRKCTzkFHGX/n8JlaScHL2roCKzNt2Q276HL?=
 =?us-ascii?Q?+61X8z3EXAZd+eR4hmVAWwENJXCcJvF6IIBuTmNvQU2yYJ0JbJ3pAoDr1/iN?=
 =?us-ascii?Q?zMSJ+jC4A3/TnV1fKAwpGEj0lfZRVDoX0xYSayQ+NophAjljQKKVu/m1eXIf?=
 =?us-ascii?Q?ED1diFcD0LwC4pnCUj1DAd6u2CLYqZ8s/oZC7Wfqr1D56xUN5qqmycM+PSEB?=
 =?us-ascii?Q?RKGcg7nS97gaVSrSlzvAUk6+QSTa4Jbn4csC6wVir3iNz4zIjRUoZKbZLQjh?=
 =?us-ascii?Q?hv1dtUkeMht1GegKqd7N++1InUo5Tz68pUycbnZfzXdp1dy5hq5SVTiS+4Tg?=
 =?us-ascii?Q?Mq8ecdM9suI49rSWnYvd9sKBABlVWLm13kyD1ZdkqW0kMoiuhSSVpZ5FrHNA?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11bea40-2ba7-4384-4f2b-08da81c0f71c
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 08:58:20.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LfX++JB+/uqvXcSgtoNmN0kp7MX2tnmHSARSufM9ySk0YIVvg+gI2UMvDy3nSNb84skWfO0nkFNWR/C9jlKaG3bFxZliQ2SdNmM+OAq0tQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB5451
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: camlingroup.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-08-19 at 10:27 +0200, Michal Kubecek wrote:
> On Fri, Aug 19, 2022 at 08:29:33AM +0200, Tomasz Mo=C5=84 wrote:
> > @@ -3531,8 +3531,7 @@ static int do_seeprom(struct cmd_context *ctx)
> > =20
> >  =09if (seeprom_value_seen)
> >  =09=09seeprom_length =3D 1;
> > -
> > -=09if (!seeprom_length_seen)
> > +=09else if (!seeprom_length_seen)
> >  =09=09seeprom_length =3D drvinfo.eedump_len;
> > =20
> >  =09if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {
>=20
> I don't like the idea of silently ignoring the length parameter if value
> is used. We should rather issue an error for invalid combination of
> parameters, i.e. value present and length different from 1.

This patch simply restores the way ethtool 2.6.33 - 5.8 worked.

Setting length to 1 matches ethtool man page description:
> If value is specified, changes EEPROM byte for the specified network devi=
ce.
> offset and value specify which byte and it's new value.

What about changing the code to default to length 1 if value is
provided without length (so scripts relying on the way ethtool 1.8 up
to 5.8 works without any change), but report error if user provides
both value and length other than 1?

Best Regards,
Tomasz Mo=C5=84

