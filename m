Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E366198D7
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiKDOIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiKDOI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:08:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DCB24F3A;
        Fri,  4 Nov 2022 07:08:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvtclDpTEQU2khiOZN6sFVlh6J7vBhV45r/5jV4ubydyWY5SHvYSIxOjNpKJ56qeOpSObsBYnELsADxYOOnjRJMI3AWpXG4leaTz2GkjKp4vyDprDOOKvt19j64XxH9zUnvjfy+7uzSLQTcrjjChacgLfNylnd2/esnY4g2dNVFeK/tDOygajeY2+CZXprywf9CBb8hK3ML0D62K9tam/R6smHQ0XcvgD66eyWyu/QU/d44FzsXViArZjtnDSL6uEDvHozKEtVF9xf014N5oQarg/AvDBFBxwLUJ04hI3H2UmFRLQloLAMQodmvl8e3imfXg9Yd+iDJOlO2tZ/J2ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lxK89IEYYEObmimZ8sqVKTZJQ9XkwK2MWybmQUmgJI=;
 b=NS26WCI3at2TJrLC+Ux3oPBiEv4UmRnSy2QAxULQkwozIdCAbae0u1Y0YTD8K4PisDMA3sztZTE8KIEAUWxTYPVNGC1h1YhoWPp0JfWrYT970H22e8FO8OcPcUeqpU7zWXZHRvPs2Bf5UzP+OzKj0dImpfIZvfXtdnwmHwfb0nii1KeZR37qFMu8cwpwvxp0cpJoEld7qy1FjQ5K+RWfSLzWpXVyGu/UfoTMqpKjmPRaAVwAAM5fLTjuqz7G2rTeHsJKNr6EsYHkWwkdHogQvvb6SpHeFuno0cN0/POKXAtEm3xxVGJj6BjTHvjSAiqZHhTpQ0fOthFQsxOnwfgD5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lxK89IEYYEObmimZ8sqVKTZJQ9XkwK2MWybmQUmgJI=;
 b=juyFZzy/JtisnFO8CjkGyZF1HpRsTwx7dEt8vusrTW5IHtw+/EEUMq/nAptKNeDo2L23qrV4acCgRM59S9AoZBAukEYjMySetWSUMDbkC+8wxrYHnZ3bPbWRyoK8WLm8EQL48vss3EdYzhVtNZ2zi8C9h5L70NGWlnTaUDJzOm4=
Received: from BN8PR12MB2852.namprd12.prod.outlook.com (2603:10b6:408:9a::14)
 by MN2PR12MB4359.namprd12.prod.outlook.com (2603:10b6:208:265::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.23; Fri, 4 Nov
 2022 14:08:25 +0000
Received: from BN8PR12MB2852.namprd12.prod.outlook.com
 ([fe80::1305:bd31:c5b:4217]) by BN8PR12MB2852.namprd12.prod.outlook.com
 ([fe80::1305:bd31:c5b:4217%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 14:08:25 +0000
From:   "Somisetty, Pranavi" <pranavi.somisetty@amd.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC PATCH net-next 0/2] Add support for Frame preemption (IEEE
Thread-Topic: [RFC PATCH net-next 0/2] Add support for Frame preemption (IEEE
Thread-Index: AQHY73g85M6SkyRXJU+IsKC0ZZFrfa4tzqgAgAD+HVA=
Date:   Fri, 4 Nov 2022 14:08:25 +0000
Message-ID: <BN8PR12MB28528DB6C999C7608958B284F73B9@BN8PR12MB2852.namprd12.prod.outlook.com>
References: <20221103113348.17378-1-pranavi.somisetty@amd.com>
 <20221103225124.h6nrj2qnypltgqbr@skbuf>
In-Reply-To: <20221103225124.h6nrj2qnypltgqbr@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8PR12MB2852:EE_|MN2PR12MB4359:EE_
x-ms-office365-filtering-correlation-id: 8ca8260a-a71e-4b0a-133b-08dabe6e0a84
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MyeScw2cgUYH68kTJqV7qNrGtb3Zoy4F1UCLWiAa4HAgEik4m1I66i2J0pznxmIsoIk1G3cTN9ga6SviDxb2x5Igi1sFbu94rgXGARHT8w/cR2KRnKxwCLLpeZjglICYTQhwkcwMsR/Hd+hJHHy3GHozJxyTLlomttGwTVXAalzkcwDB0JYI5m1vn1UhWmQ7a4cJgJ/SQ7xm66/H6ba0IBqjuiuWZON7peM65TQdlryny317vSOunkxyp51cOcmesgIbu96MCxTTHSqO43NF758eGw4WySp9/49ubt1SJtWhxjNwZu30/wzyhW7XNKBqbz8roB5/boklMFoLRVHxQ+MSeb2v2ecZisHUnu4MU8L+K+U7cGQMi9sA6atHkcmYe2AwdA0TJf+ePlxpDW+Ur8iDlT/Eu3vaKuOKSC0hvH1ytsYrHIJ68lztA9Lgvuq2iJQETiZW6SGZCvx82f7hB1a4lszMp7F9FJSQTR1Ps9ut9eqRAdTKzHicBqXdOD86OvbNtLBI3oDy2xUgfLYPtkQlVzuB5KyZtSIxpGu834MvCjxfT4PpvVfQmCpwFK4Fjre52s95QK6NW792iGU0Wp/k6CXvYTwgy2TPRVbO2NCHGRTzSAeRi14/EoI41r1vnS5nUjDnWGAP0IKyuQd2b+FRklzqJy3H346r7YU4AGFXq6rhRTfFyWCER74+9tiXkxX+987b25nXuc2JPLFNlJpzFIIDu3zZtPIsasW95YpH7CYtZ/2Bc4azVZCEc0vvYqYdtBlSNri3TnrbyekeZ9T8Qjd64BFAVPhCS6HzvDQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2852.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199015)(122000001)(316002)(86362001)(8936002)(33656002)(83380400001)(52536014)(186003)(2906002)(5660300002)(66946007)(66556008)(66476007)(53546011)(64756008)(76116006)(66446008)(7696005)(6506007)(41300700001)(9686003)(8676002)(55016003)(4326008)(38070700005)(71200400001)(478600001)(966005)(38100700002)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uWlgpWbiI3gpDjnjuHWh64UYRnz83KLWWwRiq/S1d7l0pjIWwhxI2FtLg0EP?=
 =?us-ascii?Q?EQNqvhvIGi9QbkV/agt5jERo55UdifkioTIUsezl8jEhrVTauVOkxhb5yhcV?=
 =?us-ascii?Q?xSWoW7VTKTNW6NDKCFpqysC0sChvtDVEaf1TIlq7yGR/h0QWmQdAb+WmnS9k?=
 =?us-ascii?Q?xjKak18rbd5vvfuQdNN6F2h5/x7ChWLrh5LsCNxAaFNuyWB/CTwwbqCxALz/?=
 =?us-ascii?Q?sqbMNrklPV6qxo3u6mmG7Od7/GDL51mGRznApBJkc+3Vn1LnoLsNUXUG3NuA?=
 =?us-ascii?Q?rbA6NOL/yP/ShAEmbaQEDFLrS1jFZS4qFtk9b37LzVM77MQzIf8/uWMXqpNA?=
 =?us-ascii?Q?VdOnfBgW/kGBhoRejMc92SKvceWEilFaRJa2RbI1qa8DI+tyKGbBDsKWyOWQ?=
 =?us-ascii?Q?rVjW1bqWLa5cwphPW0R8UiQue88M706SCVFOFiw/ULUr2BeBKdoV402S8d/c?=
 =?us-ascii?Q?WyuzQ7ZrrAJM6NBbm7vxFe9uPPHaDwc92MaTzm+LiMuNnHYnXcKEeVOEQ0Gc?=
 =?us-ascii?Q?nIZ/wvaXVmeLVySQvCKNbd4YKgalJeFSf+43XkSb5g83dfpW8yKtF8FzsuO8?=
 =?us-ascii?Q?Yyz2GuBoGeIj8ki+a5kSjvdKjdS/ZqeiEtHr2GhpVmFcPkZsyCftVvdrQzbG?=
 =?us-ascii?Q?MiOhFz/G1JGSNBrBCdY77aV2fheSKRrSXmP3DJSNXGkmDcB8Ne+bVFG4iS7O?=
 =?us-ascii?Q?4OJj6KsXyys8fgydermlMXantWSbdLoV9jPAiMGiSjwMbBWFdsPWHK3BqLGb?=
 =?us-ascii?Q?WIxJ55xbDJ0iWW7g9n1UaTTmcx8YKylV25NRgrmi8B0ZZltzVaQt8PrXDWV9?=
 =?us-ascii?Q?WJCfkWuV/qISOej2jCZEjkM7hNlNbGhIUUbGA0K2Kh0KycIIY6QIwtPbP8bv?=
 =?us-ascii?Q?xJWtoWy6piiJbtO2ZSVZiEdRxQQ5ef+dhs7wZSuVK8r20MGNahEdS3k88sd+?=
 =?us-ascii?Q?GBWrIH1KfcjFAHXIUDmu2xLik2gzJNNeaxsNtWrtJhZXXzuSpgo7p2RTK2C9?=
 =?us-ascii?Q?NrREvyHYQ+l9JIM8ExvG7ip4SLVUOhYy9sFX5e2bUMeK2NojH1VBftKFpobL?=
 =?us-ascii?Q?sCiwm1VFHagEeRaYTtxTTNOKUiSja3II70FZIDeXq1zZDDLL8s2B4sI7UCLH?=
 =?us-ascii?Q?uILp7q0OJbzSqreMSfFvObHQ+Yck7pl9rsVscY2LYV6JxgkX5oAtfIzaqkrb?=
 =?us-ascii?Q?7Y7M8nejyXO4/TGZXKXuATuRs1rtf6H4A/9sJ/7muFbgHu6bqk4zGEvP5mVG?=
 =?us-ascii?Q?XAAAPX3XOkr8tW5PSVszJtUBJGjzPuGqlB0xr2costpCSlUoMjvJtdk+NJBL?=
 =?us-ascii?Q?bUJ79H+nZoybTS/mPwcejnAIBOrqBXM5SqVuREJtSK2jj0UY5qaVrdvbLOPw?=
 =?us-ascii?Q?Dtq+LbcJYwg6woadlmWggHedTBXmaY30xkZDaGnFTZxyDDqOWIBCPCxWlz3L?=
 =?us-ascii?Q?fmohCRZJw+DmYqyOnv0wkS0/5/4zNlvRtQ4C7WZC2LFU2gJp6e2vE2sI7l56?=
 =?us-ascii?Q?3Izw7c1aUInQQFhNL+Qre9DVVuc4NHB3M31+YueU+8L+p1hZSYd9z0o1HCEj?=
 =?us-ascii?Q?ivJNBXIZ+uE/jVnt4HJJiICMgY1LMV+O5WFDAa6TzWQ+oM4qP6GBZNqVsCEd?=
 =?us-ascii?Q?xSYWk9En7xAGTsMIBBCGuUs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2852.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca8260a-a71e-4b0a-133b-08dabe6e0a84
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 14:08:25.7985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m5b+6wyF50r5N+Oe5rqELEzE3JOvFHiDbE1lfgIPgnGLMr5GGgsnTxlqhm779JVzXoWqT2f0px/ZzTTTQX1aTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4359
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Friday, November 4, 2022 4:21 AM
> To: Somisetty, Pranavi <pranavi.somisetty@amd.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; git (AMD-Xilinx) <git@amd.com>; Katakam, Harini
> <harini.katakam@amd.com>; Pandey, Radhey Shyam
> <radhey.shyam.pandey@amd.com>; Simek, Michal
> <michal.simek@amd.com>; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [RFC PATCH net-next 0/2] Add support for Frame preemption
> (IEEE
>=20
> Hi Pranavi,
>=20
> On Thu, Nov 03, 2022 at 05:33:46AM -0600, Pranavi Somisetty wrote:
> > Frame Preemption is one of the core standards of TSN. It enables low
> > latency trasmission of time-critical frames by allowing them to
> > interrupt the transmission of other non time-critical traffic. Frame
> > preemption is only active when the link partner is also capable of it.
> > This negotiation is done using LLDP as specified by the standard. Open
> > source lldp utilities and other applications, can make use of the
> > ioctls and the header being here, to query preemption capabilities and
> > configure various parameters.
> >
> > Pranavi Somisetty (2):
> >   include: uapi: Add new ioctl definitions to support Frame Preemption
> >   include: uapi: Add Frame preemption parameters
> >
> >  include/uapi/linux/preemption_8023br.h | 30
> ++++++++++++++++++++++++++
> >  include/uapi/linux/sockios.h           |  6 ++++++
> >  net/core/dev_ioctl.c                   |  6 +++++-
> >  3 files changed, 41 insertions(+), 1 deletion(-)  create mode 100644
> > include/uapi/linux/preemption_8023br.h
> >
> > --
> > 2.36.1
> >
>=20
> Have you seen:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.195
> 2936-1-vladimir.oltean@nxp.com/

Thanks Vladimir, I hadn't, we will try to use your RFC.

Regards
Pranavi
