Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD40F6D9DF1
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjDFQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbjDFQv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:51:27 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0620.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9182108
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 09:51:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIM2e57fELqStzfk6m7vX/SVf1eoCNmlGz1S4DhfsGqcXu4mmjUVsoUTAuf/+bF5A6RSKaHVSwqivIN8vCKuOSQmQ37aUVTsFG+wBums/OnB8A+eg7HcXGDVO5q2O2Nr51xJOsc7UoqcMUt020pUGqfHR01ntCba03imV5Pw/t+BVbknpRUnwcV0RxgspHF20moia0MmXgvJqvhNo3kft+q6o0i4Bxe94K9VrX1noYkNt3iAawM6ei+AIJ9kNZ7LNr8fu5u3QEiJ5y7I1HvZJszIScj8u82Hs+K6jDCAY8KziZzb3bM177Q1lIW4jbUmp10NYyTlqdv4gM1tzyJ7Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PN09P8RztzPnqb3U3+FV4v3D+86wZUp14oBQiXPZrLo=;
 b=dGd9ApzTNf7yPj/R+saAME0WkJKEUbInXEJtoefXsc1Ifd1Pbm/67kTwYPdJ9hDLKbo+hDQKdAezVE+piTiE6Jc2T1pxkaUuDrw5RdolQVvoTSi6HkcpU9qf1PWo1jQZSH/TjvtYLeK9jJol1s84W9IaY8kxsa8M6MOl0k6clD+E5oEVp5fcBCxMUhY2PE3VivqOD5PovyGM8U8a1ncGzY7HsGmxZhRhSETgLPOAEPaHzm/f336gnYP03ZPh/n4zpxY2/LOGWFB+Kjsf3vdVeIY6A4Crk7zNMVotOoF0jiR2Xsp+64J1N53REABhDDaDapKAn7l4RR7gO05MKMSIJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN09P8RztzPnqb3U3+FV4v3D+86wZUp14oBQiXPZrLo=;
 b=GUpn6pZAygALhVh7FueGfNSDWmstNUfCsKN9kn/qcNtyjyNnUM9JcoOmAJ71XDRDcwgMwrILbdwU8HkWcOmYMIG85EQp0L4u/mUyAKF1xRIVHvg0JskYOwPGrLZln1x0a1WJPClSpLET1yVZaBPPP9DQ6ClRpCrzLCfP7VOa9q0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by PA4PR04MB7647.eurprd04.prod.outlook.com (2603:10a6:102:ef::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 16:51:15 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 16:51:09 +0000
Date:   Thu, 6 Apr 2023 19:50:55 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230406165055.egz32amam6o2bmqu@skbuf>
References: <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf>
 <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf>
 <20230405104253.23a3f5de@kernel.org>
 <20230405180121.cefhbjlejuisywhk@skbuf>
 <20230405170010.1c989a8f@kernel.org>
 <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com>
 <20230406150157.rwpmghgao77lkdny@skbuf>
 <CAP5jrPEmZY4eGVNw+WWcmn0FdN4wXsq0x=h-9aZgX3gJYyi6XQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP5jrPEmZY4eGVNw+WWcmn0FdN4wXsq0x=h-9aZgX3gJYyi6XQ@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::20) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|PA4PR04MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a23388e-aff1-4daf-ed52-08db36bf1ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzuydjkPvctgKafUyZGCItpExdv/XQSRKxQi6ierp/hPW0uR6rGryAJoY4orkta+EKPYWJA/PtdT14Cx9b1uNDwRwz5gos3Jj1d993siq2p7Z+0POCOqN41+I/CuuRBbmM0lDendnBehXxvlS62WvOKjhv947JEP2dzvJJ6t6+8G1Q6dDRt9UraS8cUNrbITir0llMUfIR5xgib8rtfz8DgbT1w4j0Isgs59IHwQYL2hzL0nlABNQxZHPhV5zq6JpCHLbvjMOn/qXEDjgLbKH1brLb0MQ1OQ+XRCSmK7NnwqpvjL6noks8IE6DyZAdWVzypZ1PdykuFurxMP1D/oRg9VIWdcRJUx5YotM1Zo1yr7mgHoDTXmouX+WPDbdY36KrTDt4q+BCn9+Xy9L4HnJTuhz7zONom1y18IEOMSPjiJhf3HYbl/KKc9WU6wBu7znM6MmBvwegKj4etsm5MJT73rZ3xahVDSNspQQ6LfCoGDSSpphqeIlpslEUB/sS6kD6dyqbur7k08/Ne7SqccInjdo8v4y+UtqvDguWtfVw1HAR1MCelcCecFH0qA3Cd6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(6486002)(6666004)(478600001)(83380400001)(38100700002)(86362001)(4326008)(9686003)(44832011)(2906002)(316002)(26005)(6512007)(1076003)(6506007)(5660300002)(186003)(6916009)(8676002)(8936002)(33716001)(66946007)(66556008)(41300700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ThkMiByB/kPrZFF6FzIz7pFpa1IOPq4CYMNsSOaUMOOAn5ZeX4bcWqtYbe6C?=
 =?us-ascii?Q?lPGlsRgmgAHeQwqKJCHkLXMVXAG6Kgi2WwIE7gQyMs/WKq3ZSBLwQYa0VEog?=
 =?us-ascii?Q?Z9bNr+TnUrPZHv+SHnbjjBtjzB8Nowex1et5rl/0p8VcpwdXazRqvr2QHDYv?=
 =?us-ascii?Q?o7D/kkat1DsNxXxr3QLkm/YpkIT8MYurj5Uuajz0X/fYGKUIokWf6VAHHxYZ?=
 =?us-ascii?Q?iX1lmJY/OKjhlDM6E9Ls4ld2egDqNxyLnY2UlCaqeNH5jyaKXrdoNi3LJTNF?=
 =?us-ascii?Q?iuFvbGr2GYYbhLvwW9S9HxI7DE4WQ4JNA2wCd4Sxcevv+2FQxpZKXUd1QnU9?=
 =?us-ascii?Q?pDJcxzgV2N1QEc9HlQVU34LYTcAuZTkFM/79A1CzVkqHqaGsPWkXa/BS5nz+?=
 =?us-ascii?Q?xMpOidVFmbaaxxgblrap8/hoxw/fQtX/ShkBfZ72ePEaPiuBVSKk73D53s14?=
 =?us-ascii?Q?ttqqvzTlI027y+IdhcnAjGdESWaIusR9vXMlueVTktpfw7qRqU/TQlidAQM0?=
 =?us-ascii?Q?pxjehrSC+XRdKbT+U/wtbjZaEs5q8eWLol0H6ylXwIkhFJKhs+DPCuz/iLqS?=
 =?us-ascii?Q?fxJBKj5wvmlrfuD52It88VPZ0+lU43Vr6ySrWWwhSeSJxqKVslP/+OIUWSh9?=
 =?us-ascii?Q?wYO+2kuyCkZ/KxiTATMwmVBwR7STZ5gqP7LxzdB0YzE5DTz3leC0my5/cKz0?=
 =?us-ascii?Q?O5Wzh9V8yoEtlX8+qlpQsRrWNo0LizlF86YA4Z7I4tvFkZcCSo0uELmyvlP4?=
 =?us-ascii?Q?nx9gFXNYN3NbJ3CkMF6/t5nDQqRYUhYtatM9Vi69XSJn8T4luEZstUDQMKqt?=
 =?us-ascii?Q?pcnTOla8L+Xk/gvQbrPCjPdk1vrrNNlPi15JhoWbqdYB2ECpMMKYi6r7RKDM?=
 =?us-ascii?Q?d+UxZ79k9bljCUSLoggaL2YlgyDL8BWLqISpbaR4jKapGluMPs6zGt7KNind?=
 =?us-ascii?Q?HJyAwz304yml3JxtiJ6mZaeqYqZWdeLEibyiL2MtYKBNCif6bRntnjOD9Sp5?=
 =?us-ascii?Q?QVKg8zAKdhTH3JH+s0cSrMF7hJ36yVoNLlyPaF7ba9K71IYbINwsdbIfid/V?=
 =?us-ascii?Q?o5jBPBJ89t79xTcxj3nfpe275A8mUXth7AYbuJ3H0PClXZdgxyvXuQfLU30V?=
 =?us-ascii?Q?Wlvh0Yigo/QT2pYoSoWWXcp60Az5gdrHQR8rv+Ibfx3vorbuU2w56oKmLXf1?=
 =?us-ascii?Q?KKhPtX4XdbNGtyGlQdHPDc5r0Ka4eVf1x3rvtBZMlfq0z8Ja02syPqDZmmFA?=
 =?us-ascii?Q?BE7EzFfXkEpWROq0kRWgqtLDQ3j0koGz/NRAcdS5bvoUCWpQNtmNCR6vpfpr?=
 =?us-ascii?Q?0lwEciKWAOunP48+cvI9Gq5Y8Mq56fTstbdlP9Q6NJf/2p6pBXJdwpV2Kim7?=
 =?us-ascii?Q?IPYhozlZvz9gRsZ5Y5iaUKiQ0p0U4odVOiq7Y+JxBw2o1R8se32Mc+QvOsIy?=
 =?us-ascii?Q?8DR53vT3wE6v/DZ3OZQn9coVpo2Ob1/QJvFa44TtS8/eTEJBDQpw8WPiExG8?=
 =?us-ascii?Q?qDHozHNA14PJK2RXy4ziMwf9BnSbmD64QQggSiXe9Bz0iLc50JusyD3oEVYf?=
 =?us-ascii?Q?+O6+GgAoUR4eAW/2Uqy3xGbXGFyBBe1MrHwCFdvnGyHgzZYyf5PPA8L+WVB8?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a23388e-aff1-4daf-ed52-08db36bf1ee4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 16:51:08.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWgHlczy29YESRYTFrbj5Gz7JHGl1qQrD6M/nWuRiei/NMTjHgCUKd3AwV3m4YKYHVYm+4v3Pqu8bXOkeWV6gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7647
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 10:18:36AM -0600, Max Georgiev wrote:
> If I may, there are other ways to work around this inefficiency.
> Since kernel_hwtstamp_config was meant to be easily extendable,
> we can abuse it and add a flag field there. One of the flag values
> can indicate that the operation result structure was already copied
> to kernel_config->ifr by the function that received this kernel_config
> instance as a parameter, and that the content of the
> hwtstamp_config-related fields in kernel_config structure must
> be ignored when the function returns. It would complicate the
> implementation logic, but we'd avoid some unnecessary copy
> operations while converting *vlan components to the newer interface.
> Would it be a completely unreasonable approach?

No, I think that's fair game and a good idea. It would make the best
case better (SET request on a converted real_dev drops from 3 copies to 2),
while keeping the worst case the same (SET request on an unconverted
real_dev remains at 3 copies).
