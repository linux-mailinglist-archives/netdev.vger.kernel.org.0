Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E45052DBE9
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243572AbiESRvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243409AbiESRvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:51:33 -0400
X-Greylist: delayed 166548 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 10:50:11 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A53ED682B;
        Thu, 19 May 2022 10:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLhKTR8UY/Vi4jS/AtGgRfbJaEMpg/bE/p5hdptB9WU2+5lyOfnvWMldjTR21iifEzZU0uXnU/B9PILjukADbX/dj9dwLDUx879A3FsH8l82cxC9eUfvsxKoQneXyDqzn7PZEuCV3RW0EHJ8ENNQRidAOfj/JxTPB6nBZo3wzMt+fOUNTA6cDOGC56GleMhWZno7dHFXi/0qUer1xMtsZsnFc9R46py5FEOF7WF8pxhm87IJZvlyCEtpZuUMCy6bdDvxiTGsrYcs5/4X1aQg7RizCh3bX3xOwMB7NAZGni4hfxXIXQ8sEsby9RDrdQZNoCN8KqTduZiJxdnssokGhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiYNtSv62ZMVlCT+rEup7TeWJ+PSPxRRNIaV8FeSjyU=;
 b=X3UmW9wJyU38n7o/jz0m2eyZgk6e03s27gfeg/NHoKwaQ5aa9ApSRO6FXDNvKWiTpLbyLluHGSSRJz/c3ELOdKJ1EoQxcvDaYVs0i5o3ysnbgRClN9t2MiSNOoC9riPY5fo46cW9Kl/aGmE/wLbDlRlTbRvW8zLE7x7iFXfW5i5xtqZCmktRAuvlsL1Jl4hHIoSmr0YJLVf51NvBBBBxelvh1RGLtnbdb84EBtmLuh+kMb63BAvwra1WE/UlrHE+LHZW1cAq8UDsh+Sj12UZhMKGdY3W8c61OPtmD1eQ73Cy+7dQgsGDPjExwmn9sZiUlaIt43rwbc6QOdK4JlOBcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiYNtSv62ZMVlCT+rEup7TeWJ+PSPxRRNIaV8FeSjyU=;
 b=XdG5DqXBj0j+88yWerYT+IY2h4twMkMOxhdE+qtZzZl4rCw3Pmna3QP0p0LoBK+PWTbeB+fCANsxVXKgjxKxaJfcaYO2uObyIQKbKrxr6s4Wxm5BSeQHMtYNCLzc70oLpyEpGdUUYNz5CfsWnZp/nR7Mn7/8udoTlnc5eXLQmBA=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SJ0PR21MB1901.namprd21.prod.outlook.com (2603:10b6:a03:294::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Thu, 19 May
 2022 17:50:08 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.007; Thu, 19 May 2022
 17:50:07 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYac0wRAeXK+HCykeq53JGGiXdWK0jMLSAgAJ/saCAAHmfAIAAUdjQ
Date:   Thu, 19 May 2022 17:50:07 +0000
Message-ID: <PH7PR21MB3263E61F0A8CA25545B47173CED09@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
 <20220517152409.GJ63055@ziepe.ca>
 <PH7PR21MB326393A3D6BF619C2A7B4A42CED09@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220519124900.GR63055@ziepe.ca>
In-Reply-To: <20220519124900.GR63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5073ea08-8e9b-4bab-9bf9-70b6eeff0487;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-19T17:41:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d9319f8-71e2-4816-9bdb-08da39c0034a
x-ms-traffictypediagnostic: SJ0PR21MB1901:EE_
x-microsoft-antispam-prvs: <SJ0PR21MB1901880D24CC39B700CE8DEFCED09@SJ0PR21MB1901.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WkQEzyJ8XHhDjkG+DruviIarFAKRPC6GIlHEpG/cKV3PPrWnxJp9cDBXwnQkhJkdIAErg/G44KBBIgYFFPyTVkHbpBGkDrdg+umxO8oNPQLtZ5IlQYOi60JMZLa62KfFZgk0lxKG9x15lGzPxdk53F5MCWGGn9lQCP/xEHcfaTpPJLK15lZjYzjDa/L6k/FzRXIwjh5StT6YZu+GJQrSuPnSQbFBVDNLQ0THk+5PP7PJ55y9i9Q80UuVSXVEV5h9/MO7QbNvlLE+50TM3yPYV0EYcmUrqkzkte3WOqPPAO/bkVm0ih9DzCUBkpqK9VBzqvqH24eYvhYhdjWyRoKDw6SdvaX5GlC7okx7zU7ZLfK/iCHQf9y4JiXTrLcVHNZP+S3gA+RjRi0CGfRdumqPhvYW2mC4MRtuWc+jZhvLpbdFiRLIzM2Uh7m8knm1l5SgKg3/S8jGQNYXBHSax3uyP1v/hCLgIYNGBF5QJupJlFJTYGDaLtfngV2oa/fuiky3nNz514kARDxKv2eeXjwq164mpQBQOOdIrvU7AzWLtgtrvQDsYsBiYetPy4g9Ux6SkVeB4eAKIpgC2ytwlpj4Rx3tNp+YvgF4nKWt7yGQ7srvAhD3fZxbl+nT2OHS4xHbOW+GjW0oeIfhWe9vIM7LhCbmkWplyiztxB/MIJHBbjcfy+56Pl2g1iWFWDxKji+wqUEsYV0HlqtQGkJuiXn0B4JtFQz0W/1vOGT+GudkmtFKcMYGEao4MAIncrpjMo8D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(47530400004)(451199009)(186003)(6506007)(7696005)(33656002)(508600001)(26005)(9686003)(71200400001)(10290500003)(6916009)(54906003)(8990500004)(316002)(76116006)(66946007)(86362001)(55016003)(4744005)(2906002)(7416002)(5660300002)(8936002)(52536014)(82950400001)(38100700002)(66446008)(122000001)(38070700005)(64756008)(82960400001)(66556008)(66476007)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OOSUalzX6TUJNthELMdZDvisaBQY/WnchLkM4EmP8AKNTduwU84EDd4bjXiH?=
 =?us-ascii?Q?gLEHPjEJTl76UUvK00uTEfamBRgTPCIg1bxHQSEeeeahycop9TV3Eul+k3OS?=
 =?us-ascii?Q?4VYW0/DmUGEeB4HEgFwGODjyMB0NMMQFXiaWulwYiux5Ux2438xshNv41irV?=
 =?us-ascii?Q?dyinCV7gHRf1Z1cIL1S0JDewqPmsk9aH2FWQg8TzV0L7wKKuGW0Pn2sVtRJd?=
 =?us-ascii?Q?fOAvkVJ0BmuLkk6Ac+xbZZyy4Lofspr1xD2emDXbtkbNaebIPC471GsT7ipw?=
 =?us-ascii?Q?1T5z0gqtt35feCgi2BNu4PtdxoO+cpUZcxkavv6QOL7OagTq5BA8YoOlIs+J?=
 =?us-ascii?Q?6nnElB4MxuEnPpKnb3zdnZ/0deYXrtUdgu/ly7kSUh2aIrGHqim6vUqYEnFQ?=
 =?us-ascii?Q?xliPzfpXSh1zqxTegpvVXujANyGURINfINVNTLRaXPYZBRLCtM7ZikiRvtUq?=
 =?us-ascii?Q?ucuy0miH5V5XBh1G7pxAcMtDWLR+nq1l4aNRu9sjmjKn7AI9+Q1aBghbU1M/?=
 =?us-ascii?Q?l59Oi9TmlBl+/MXDMac61REwJSNSQL5yea4+THv+JbaemA9LOich4P4pXNf0?=
 =?us-ascii?Q?qP2k4G9uNxJDOZJU0Td6Grc8j43YG1gFzJg4raLu4xKBeQSRBlK5tcQpmwrB?=
 =?us-ascii?Q?iLwF3rfAVdo0tyyKFIqizsoOUay/lYCo5zREviVmeCIiR6GcG0yvhB5z0+de?=
 =?us-ascii?Q?9yUiFxiSvn1pXICnRi2BylnXfz96i9NpnOKWRIgKz2OhnzAGjD08TBdw6E8W?=
 =?us-ascii?Q?xppuXH6JoiHAklFLHHXyQMsCv44wRip+2ALabjp25CRwrEnOwc3lrI0aVfva?=
 =?us-ascii?Q?p8sfROboPBRCSLuxlgHRldlWMsURDkThgBOQaTNzBS88ObK2OW0AHH3GMIKK?=
 =?us-ascii?Q?rOOtqFLncSzinSlPsnTnIb2BO9HkFtklyI9WeXXG+H5mApO1WQtFmrczDxxF?=
 =?us-ascii?Q?GuKvHWSZ6JdWc+Sopup3AAKSHLht/RnFS+BS38cV7vpBhII8hkangmqs6nzl?=
 =?us-ascii?Q?hDZreCDeiwDUNa4ulCcqJ+oOW5l75ajt11vrc/jqPSdFyO1voQHSW0PDf0PY?=
 =?us-ascii?Q?BxxICHb9jbE3auGSQ/WIDBs03VIEkYFN1YjCWbGmzacBN0ql8nDPgDmbcez7?=
 =?us-ascii?Q?TwvIC84cydAzihaekr3Ty2JqZcj1SW7dJjT5r3XihrCkyoLa4nGR9oOy0eOV?=
 =?us-ascii?Q?OSWbqhsr39zHgMrXbZH4ybYQvt9nnGT6wFJ/wVL9llXQInhAzEdc7KgBYarW?=
 =?us-ascii?Q?LyE7uXBjiVaNeJ7StCHrBwEuE9c9sLJr/3g7h7r8mweMouzeAMYR/MqyeRIB?=
 =?us-ascii?Q?e9v5gaxBs71Bk4PqpJXtVGzfN2ZtcLQjQJAbNCHswlqqRXhUztgoqBY8wsAj?=
 =?us-ascii?Q?1mYQLN787MIfI2Q/DmSMEDfwQCLqycv1UgdkX9olhUsrI2TuBD1C8GOpgv9Z?=
 =?us-ascii?Q?FZEKfXHyEUtkhYd8MBhnLFLoOgljIkyBtN274Ye4O6omH8+NmxF1lzZ8ic/R?=
 =?us-ascii?Q?MTaVhINOrHp+6AWuQNja6ky6AL+ifyOgPYIHSCZ2s6mFxH+T00x3yDFjDcEs?=
 =?us-ascii?Q?n683GfPK8VHd5EGki2UxzAA32d6M/oJXWcRiIUiN3qnZadJWZdmE4CN4n9BN?=
 =?us-ascii?Q?WeYauNcprj3IXBPJgZaSWWAEYg9S1Kk+IakYDpUQrckz6oqb670ZyyBzPGYz?=
 =?us-ascii?Q?Sn+l+kCXjAkpmRHU71/ye6s5hBu3Y6R+2B2gA9dydpM8y1hewtFyVH32WADw?=
 =?us-ascii?Q?PFkgyK+WdA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9319f8-71e2-4816-9bdb-08da39c0034a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 17:50:07.7621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CmXr7CWydjPWv23eUVp9T8ekjO+108HQmlziicyIGOfFYbkY/QG9p3G+AYsm5lgzb1fRNt4qMqcZcgor7z39ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1901
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
> Network Adapter
>=20
> On Thu, May 19, 2022 at 05:57:01AM +0000, Long Li wrote:
>=20
> > > > +
> > > > +	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd),
> > > > +udata->inlen));
> > >
> > > Skeptical this min is correct, many other drivers get this wrong.
> >
> > I think this is correct. This is to prevent user-mode passing more data=
 that may
> overrun the kernel buffer.
>=20
> And what happens when udata->inlen is, say, 0?

Thanks. I'll add check before calling ib_copy_from_udata().

Long
