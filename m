Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B10553AD8
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354120AbiFUTze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354125AbiFUTza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:55:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ABC28E1E;
        Tue, 21 Jun 2022 12:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPtWoHlvHsyuv/8gSNT6zDO7m2Z6449yVcMKdzTZlJg27+JvpL5ZgcCDga6cFkm+dK0FGKwQLgzo1nSMRFNrGVwFeQmfMkkWcsDUpXkjpNaGODK04tvcDbunHNGxr6DLUj+SWQ0VFyH7vCDZEnVJ24zRZDt7mAFlJmtzkej4KYFlZC6UaAyaURkP8mWGBkWRIcgwM3Y4deBi3d+wpVsv6h5cV0aJ0GGZsTEm8HtoHVJn78bkDbcpTA/Jfrc/rZ7DAWFgqfheVB8thZUyitIJJ/Op20owo5ArNgdCjYtFtV20g6+tozSCYGUyMTgzYEZj0csm8mf0wiJvNJJ4pQEeQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/x+rKek6FcZeba7pGVuy11GaXOCdxLYLFhEmpWjF8M=;
 b=C9dp2pBPkXidIXTUFmRWnOqJ5w2rAU3c5VwPPb6jKlS2UiQBYfEM0GW6YrG7gjyCY6vk24EJUrlXi/Q6KzRO+mPqP4jKaK68exu7Msg4xN9v/L12gI4HZVp5jNNARpSfffjE4RhnJAur1FiNZjs4uBlVfmv5XR79xneTPTmJdVIbgDqHbyxhKW/t938f0G9J8SyxHtr+muPEnmtREHV3VEuxlxBwcI9Rqj432KoU377oFMitUlS1ugDYrtDMG/FGntiWaHIlvjD+nJbKNft4r+GQmlFc5HjjVnjlw7eoU3a28IIMPXrXrwxBTVf0xS9CTv0M6xb99PeEgwxQ1gpajg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/x+rKek6FcZeba7pGVuy11GaXOCdxLYLFhEmpWjF8M=;
 b=KEh+8Gbc8shWyFNLW3kTXPXWHKkhY+JaG4gW7D3j3L4LCwrTuf0LtiNBLTUfYhpqOJkZU3DjiIT/ypWNhkG5D8uMT/35UDJwPFs3ks9ye7tIroUXdOwTvnk58jM5Qd9MvFCh/ZrezoZ1h1tiAtjRvvXauClgSY7x1QcyAf4zMVE=
Received: from DM5PR21MB1749.namprd21.prod.outlook.com (2603:10b6:4:9f::21) by
 CH2PR21MB1528.namprd21.prod.outlook.com (2603:10b6:610:80::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.3; Tue, 21 Jun 2022 19:55:27 +0000
Received: from DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4e3:b5d6:2808:f49c]) by DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4e3:b5d6:2808:f49c%9]) with mapi id 15.20.5395.003; Tue, 21 Jun 2022
 19:55:26 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Thread-Topic: [PATCH net-next, 1/2] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Index: AQHYGhkbwj/2soN83kmQnCFUF3LCRqyFiqLggALM3QCA0sG4YA==
Importance: high
X-Priority: 1
Date:   Tue, 21 Jun 2022 19:55:26 +0000
Message-ID: <DM5PR21MB17494B8D4472F74198C88FE7CAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
        <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
        <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
 <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: gregkh@linuxfoundation.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7e560606-000c-4c57-9e64-b79c51153f2c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-21T19:40:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 377a95fe-458a-4b38-a606-08da53bffc9d
x-ms-traffictypediagnostic: CH2PR21MB1528:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CH2PR21MB15281439B934810E3A2693B8CAB39@CH2PR21MB1528.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVuqZnpXbJnby8J9ovJvhNs1UmGqjBRBhHpLuKfyAp0uVWf+MWFYFxYLVV/Xguc1TAKkjMfi+kbJfGbZlabhfrd7K/T7ip0hGfswcvmkNZJEc26I920VGSqLBNZ5jye05UQRxWZ9r401YyXCAsHcV2HDoUe+JoP9TBOkAzzNm7os5heVyUnr/4AjSUEOeXlT/sC2oD2sx4keaeBZYt2xGdT/bkVGCY6FvM8y6mCNB5ZwCQFu050UxiqIcAyI8O3fGanXny8/cu+6QkBI95huReOdEQoBFIGGL1S/VoKdXEv1D5pOTUXt+2Ftljh2QWFtSEkrbJaWOlFIfEi2GEtbZTtn3T90VQr9/iFu9PA3f4SMYDubaCLpQfHeEBrS756nM6JN3Nln9ttOLxBh3N13RgsT1GUaGd1CprucPq+3Ohtt3VOf2BeO+A8V08UgNQd1Mn9Q5jZ/8fBQ/KM5i5vF5jP0HHnBsqKyOv9ALa52aLWGKFy8lFjQr+YSzKmIrXvDVP6ZejPXdirSJvM5OfmrZvtvuzbX5nIsD9M89M1lJOnFEo3/XBG7ypA/J7eGx++MY+GEiO+2aDLs239dAHZBIvvCrQluw6mAZAOyrrG+J6KbBUImC1u//br/4qF7cSSxUEzrVxTFUKcfoY9UxnyIR+lX+hVmdd7QubzFVZ07ZmEopw3kbAFefipifdPycV1YEZQ4ZCk4KK15uyZ2Ujxi5O3LtpYqTndZ/hCnRJWoYzTwicExfXjC77lNysszSwqk3SISzx9WmDzyCIjr/Gbjp2paSLIxaxLDUhFMaTUiyDItPjEW3u/mrBNks3G315z6Z5qy54nYZWNRGF8Q7BZlrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR21MB1749.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199009)(26005)(478600001)(33656002)(83380400001)(8990500004)(966005)(38070700005)(5660300002)(122000001)(186003)(2906002)(82950400001)(55016003)(8676002)(10290500003)(52536014)(4326008)(41300700001)(316002)(86362001)(64756008)(54906003)(66946007)(110136005)(9686003)(53546011)(66476007)(7696005)(6506007)(71200400001)(82960400001)(38100700002)(66556008)(8936002)(66446008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?15ePAJdmH0H33PRf3qVx2rOUgBfFeEq0hIA80P34GUqm96U12zYMjkt8OAVS?=
 =?us-ascii?Q?uzWVUiQTqYh9Q6WonnpxMEnCWKFcOACHXenzuYe9rxiLxuG/LanABtqhquDF?=
 =?us-ascii?Q?Kcg2IFg6mP5w5NEUwo5+MCqsFWMjQhUsm2MwkBndWImqUPmI8UQsB0/3/vFA?=
 =?us-ascii?Q?1MQ7TM8SBh0Dnklkh2cE8aAncfuP28GmiPeGAceqbb5XtbIq/04Hw3C/fmjV?=
 =?us-ascii?Q?hCOOuzV4hXrdtegMiAhBsaqpS34UKT8GUCE3T0ZdKLcQKJYASwrUxaWuEUz8?=
 =?us-ascii?Q?DeMKKJ/p4mY5aQJ7tuqGslS3te5Lkfzq0+WJm6fxaJVeNKgYy9peeFTXzocd?=
 =?us-ascii?Q?8MfjbiGI1OdCOH+NiH21RZxvK5pTYxvv1Z3nQzYzjl+tXinNay296wBreahf?=
 =?us-ascii?Q?Tk1P+lJTxgh1lCa6eySBk1QzPWWLLI1wA8ciSyf5G8i2SJAdM7gsEdKo54bM?=
 =?us-ascii?Q?klvshy23dc/QIyCi7SzcDt8MGJnll+D/3m0tdeNiq2RkjjTVALcRqwQ6Uvr7?=
 =?us-ascii?Q?Zubey1Qd2JXPjqMvyRMHu7NGk95Ty+sxcpPnseou22f64EnKZv1M+tPCFQ3k?=
 =?us-ascii?Q?FEZcDB7ZJBiBmOMn6LcGQ8t7OSpZboAkf7A1rsLhsUWZUsyxBT0QHCLciaK8?=
 =?us-ascii?Q?9mql9IKCiE0fw8Oz6KKSnDfebscqdHgUkeq27DM0J8NfiOs8XJpqWwBQfDRE?=
 =?us-ascii?Q?b9Fgi32LhYTtufR6op6SvIZ12JSY+0Y9oIh6fbmRWDvD9qKWwe77WrEr4ND2?=
 =?us-ascii?Q?3IhUPxCP8Mw18Zi2iFbLPPx8ilS3jHO/ig7j34eVgXT23f/3T+HJv7jYUa6J?=
 =?us-ascii?Q?dUGc44OTUAkoZYi3EDVs7KWgwOEZINTqgwUiLcZqioNY5IHkL4wfVP69Qn+S?=
 =?us-ascii?Q?wje3NTDCxoeyqVzzzJxNIJRSDoE+exM6qDErKwIrWfIdZpEmju+8J3QpsMWJ?=
 =?us-ascii?Q?+VxDHN10WCvxFd3HE9iQ4Zn8s9Rn5ZJX89+4LzL9VydvUMpE9QBsjzGpXYH7?=
 =?us-ascii?Q?FFXQ+rA2YOl/V+Sg/2v/xxtjEj1AopmhSeMWSDKuW1ETsoW9tp/vCfjz6gqG?=
 =?us-ascii?Q?NqT9NDqnTvK/BxQxnv+B9692lY1EXogitu28/yQSGk8TZd5UKzbbuTvPIJIa?=
 =?us-ascii?Q?8JLprOB7izTgswixqkKCsf8S05qmjxPxnpKFe/gjZb3GMDo65VKdFHHSvDvS?=
 =?us-ascii?Q?BLmH/be9hn1tsnOTzZG/C1xDG3NrGwe5opT3HMOWc/VwDEbBMy9M2wo0xNdl?=
 =?us-ascii?Q?a8jKTdBsJkiIaRzni+Aelh+piWH93189ga0s7JVu52pKiegS9ZJDqrRZtHvk?=
 =?us-ascii?Q?O3hwy9++eCo9s6TyX2OZgnKzLE7bL8gdXkK//vY345177f9+SrbkCNJLa3sj?=
 =?us-ascii?Q?mOlExA2O4xX3j/tHU3pjvbYGJLtTuhovaefxpH8p2V4z/rdHxgQbequYtUJY?=
 =?us-ascii?Q?8BV7W0sAIGnsTNmwfCCwJcKShTC3T3m8tdwAtkQuaKXuHrBIv31Cmv/vrnz5?=
 =?us-ascii?Q?r+pqVHB4Bt6sh9kFPWP3qWB3FXGzOr+ROd498KYC/ZMsNsen1aP179VpG5NG?=
 =?us-ascii?Q?wZJbmbpWbjp6eu257CLGHgSKBOzRLDIMCnLQcCcO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR21MB1749.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 377a95fe-458a-4b38-a606-08da53bffc9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 19:55:26.7770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 54dP5GgNEzKcsngWHiPiZgAGZ1RfCbOHYcJMkrT5IqbkNVo2RI54Ezvc+W809LpbKGlKOAqg11UYlzhb32I5Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1528
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, February 7, 2022 12:12 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; Shachar Raindel <shacharr@microsoft.com>;
> olaf@aepfle.de; vkuznets <vkuznets@redhat.com>; davem@davemloft.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 1/2] net: mana: Add handling of
> CQE_RX_TRUNCATED
>=20
> On Sat, 5 Feb 2022 22:32:41 +0000 Haiyang Zhang wrote:
> > Since the proper handling of CQE_RX_TRUNCATED type is important, could
> any
> > of you backport this patch to the stable branches: 5.16 & 5.15?
>=20
> Only patches which are in Linus's tree can be backported to stable.
> You sent this change for -next so no, it can't be backported now.
> You need to wait until 5.17 final is released and then ask Greg KH
> to backport it.

@Greg KH <gregkh@linuxfoundation.org>

Hi Greg,

This patch is on 5.18 now:
	net: mana: Add handling of CQE_RX_TRUNCATED
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dv5.18.5&id=3De4b7621982d29f26ff4d39af389e5e675a4ffed4

Could you backport it to 5.15?

Thanks,
- Haiyang

