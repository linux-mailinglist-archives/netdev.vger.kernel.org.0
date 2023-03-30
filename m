Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193546CF95B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjC3C5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjC3C5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:57:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2105.outbound.protection.outlook.com [40.107.220.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE89F1FCC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gk8Hv35cTgNe+j1V0FFn5IvZK+qk5wiMGja/ViwUdDs3RTeYA62Zlk4/5bPSrW5BkL0v4AD4oqsW+zPCi+MOYZdojjwg5EcFqGC2stPBw8YoUsstBy42zNr7GwtdunGohDtLvJsvlPsvM90MQXhzagu6gXrF0LLebG7MM4xk6gHO9J4ETPpiY6DtSPKZJnd3vDwpWe8h8qdtQem9y03mukqJIP4N768EvP2xD0I/qrYvbEaji9odCtKlRoMMcO53/NNHkNQHtHYrAf8hsvjYd7i8AKz4PEDqfxFM2kdWqlxGFtIc3ZyFtZRvnEAnzEDt5zg/BkII6xEzUy2uocjHmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9D8wQJEKYg7nxGkB31Y5RNB2/Ut7FQHDz1KhIOax+Q=;
 b=mT5dSdA4R86HIiC4VlDtDlgE5qTUluq5e65xlh3CWVm3ptcqXuEFwkWY+tE8K/rJsfhKA6P5YtBN7LfjKoJIADtMPVEzTaHcbAw54GDs8y/bbKlB93Ptp8BZOXE7gDvLTo0d8ZuTocl+HkjMVT9Nu57Cf8mPPAQrLLLDROA75AF1bINqEL46tR6igMPMF5CZJi3aHuz3BgXgzqDD0ChlbxMfs1ylCNT65uuIFmo8aXDFXrHtBBjCmNm+pcuk1ipBOtTU7K9LxFxW1VACX8x1emUCI/EMv3yW22uOgKD3CmjHUG+ChTgKjFVZmfzlibe0hwWyi7GFNbT2B6w8pxtNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9D8wQJEKYg7nxGkB31Y5RNB2/Ut7FQHDz1KhIOax+Q=;
 b=RO/PpUt5RL70pelsCGfG1r9gwfM2Jk5MQkRSgBlI0FEt4FtreKb++Ao9vtPVSt8QHlddJROyX3VanXr/ZMXLq0ZesaGMIgV8uNw7VhPYdsP7Mk6wEv40/jCFbyWAmiNNV05Qz/fhT0Y0+y2ABhxgLWR/5E0S1cO7Tp4q4nTUMzE=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DM6PR13MB3660.namprd13.prod.outlook.com (2603:10b6:5:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 02:57:34 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 02:57:34 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Topic: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Index: AQHZYk07XTN/U7MQDkW8TxKgBUt5LK8SI4YAgABrcdCAAA6tAIAAA8MQ
Date:   Thu, 30 Mar 2023 02:57:34 +0000
Message-ID: <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20230329194126.268ffd61@kernel.org>
In-Reply-To: <20230329194126.268ffd61@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|DM6PR13MB3660:EE_
x-ms-office365-filtering-correlation-id: b46c3b00-7018-4640-3006-08db30ca8356
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L74z/S14si2ORQsZ6g7eMJodcNl3hyCPQTXeEYiMK3isOQFrAY8hVfPxVxNdrT++M+dis07VX5y4FM8VtPGNicvehw0rwxSfO+PcKDwhzkE2B02TUW6W1kpYmVYokTtMdU/g/SSTK6R4M4k6remLhbx3HjPvEt+HvvHHAhGSS30oxKwfR5+vDCZo0Mi/nxSXjhorl7V10OFnk9+8IjNAV0zGn6X+f4rAYE14uzJNIfsWLCEoGBGUGlAI+2yn3cuf019xRJO8aGRhKEjOUnDkz5UzPIq83qC+MJQOjaVvi0La+lA7y63kTSzw80RJTfFNQkg/ox/p71ekW1Jh+T5e5Ip0j11rlII33HyJJt8m1CFxrsFM+AtvBo4a4937LsR+6lOmIOwk68CgEWLYconxhDQ3R52zQj5th/C1K6W6mP6fB/trlOkidI8WKzPRQG7JHUs73nO8z/pgL/pY8dhBI9VJd5epZtWSt7u8V8LPpZFHtKL8y7ZtvgA3esD9+J0JBkIWUz3PvO6yjt+HqHBX4uoDIcpjHPCr0S3p/WaYY8PhNSk9bP6QambWZ6yJL3bmQkbci6m77j75T1RI7hIVkNR5OpYVgyApPTRmPyh68Az4Plwv+ao6pVEgAi2fZcgKtrFadTEEisx11nTbY3LQ88OKmf76DJevXW7+Cl+bVxwn1T/GP02e4MHuQFQd7S/S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199021)(478600001)(54906003)(7696005)(71200400001)(316002)(38100700002)(33656002)(122000001)(55016003)(38070700005)(9686003)(107886003)(26005)(186003)(6506007)(83380400001)(52536014)(8936002)(44832011)(5660300002)(8676002)(66946007)(6916009)(64756008)(4326008)(66446008)(66556008)(66476007)(76116006)(2906002)(41300700001)(86362001)(20673002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nmezjPaNWa8FGlYMDitKuhmC5tLcIDHvxtD+SQmO+cpAZjPrdrVxIVYpZsdm?=
 =?us-ascii?Q?yIlC08Oc3vYdSjHQJZEPIfPKAcv6g2ddOeFFRH1j7FieHJneSsYPZAytNHpY?=
 =?us-ascii?Q?YskLJzrO+fU80PWRlA2TXEWlqFSIV1t2jbDcBWwhAVI2gSHHD4ZHTNhYkt+m?=
 =?us-ascii?Q?3f4DwqwCBeSicV9Mdwjctgo3G0RQmv+ZATSZSlPozxj/EQ/BHnuhBGqL46+4?=
 =?us-ascii?Q?IVYiC1yTZx+Or91dOtN9jqT5H56PsaAGvlE4R4BdrPb0oGj5QbihSdPGDLmW?=
 =?us-ascii?Q?qV0ytldai5fGMGCnuVbxczU0CytNt5vP4rqje0hY6WAEzet3T56CEuLh7PFZ?=
 =?us-ascii?Q?z2k7RENpyY56bKcHnDaC2RrVxmnNVSb/z9s+zq088lli68qL/cApTTBBue4k?=
 =?us-ascii?Q?3ILycHpibCuBYHMtqtTr6rhGXbDWHz+Oi/MfGu81I9sqENiZVbW4QP3jWmSy?=
 =?us-ascii?Q?+RSq1byhAaj/S+BCzt/SGnwuywwqleZ4sZqyvgnrmGGItGULAWt1ApkP5voK?=
 =?us-ascii?Q?T6CyoiWcj1r903AqtY4tfg/lxDNy6QTSYQZe3AbLaE+QSeq01LNzTMU4FHIv?=
 =?us-ascii?Q?NTfCXxrw0OGznQwqCTGVNTJwGKp6WX6sT0y/LnNVejqgVCfOGQk67NCRo9AW?=
 =?us-ascii?Q?fNpVB6Tla+6aumCi2y9eomFB8crC51ReAaSqFeO0qNdOTJLxYb2e8/KRImfu?=
 =?us-ascii?Q?eV5hk3rZDfY9KMePJ/RczHmAqW4BQxYhxDr1u9JBzHFpGZeH5OTq/k8pkVT/?=
 =?us-ascii?Q?jahNNJ+cohd941gxSTjlZwAgbAB6nmU7oU3uSVdnDCcHms1IcS9px3b1SiVZ?=
 =?us-ascii?Q?vTE7e6551bULfmgLz/3M/t7+Ex5L6VyaSs43RxCESrp7pIGcq+uffPNYYTqh?=
 =?us-ascii?Q?P9HpKs2PWWVzEeIODXcfTyBJS1zZAsuGpgyxXhTxTcgJqr5EpY693oYyr6LX?=
 =?us-ascii?Q?Azyctt1ixumtOeTszVtiZ82ZKakcBdbMYkSSXYPhQ7sgcD1qRew3AWi9gLzk?=
 =?us-ascii?Q?ijMYXbBhsO4jd4PbdtR3Lleyeer1MY8lIMxp8Ye+8jm6o+JFveZoY5iJ5aLB?=
 =?us-ascii?Q?mJ1nYUt+DQjMT1VJFog12Uv1ECYrlL7m1iQhPlGY9a/4lFEdZ8+lTV6w2Jg/?=
 =?us-ascii?Q?ZiqrW+OpJn2cZlUeOVDDe5eEOq8x7sTMOsMMqTBxa8k18JfDpi54xE6ByINw?=
 =?us-ascii?Q?3WF3j1zvpl62/KyqC5BLPCDm8ajPbufVUCEDROrWdaCiGM1Z+tI0TG8KidW/?=
 =?us-ascii?Q?uMW0OzS0ION3lIPzBeonOBBJU02toylE+fts3+MMsAj0WcY6e+vULArDWXHc?=
 =?us-ascii?Q?Wk6HRhXMcyy22uBhQXksgkFn7/JnNwwNhJOkGaAiusERSYghAiGtK3ZUiqWl?=
 =?us-ascii?Q?E6unQyn6IlVHnxtIoByGi9LIWSQfGnV2JIaRnZyYDltbrBUe2+T0GVOXd9QU?=
 =?us-ascii?Q?rwPgCtYo/wAQs/hcJ7YNBO43NPC8JlDXYvOPa7K1Xgy5RRlAAr6bnB7cMjOr?=
 =?us-ascii?Q?+Y65DCNBGSbMUb8wVqb75nut5JLuS+Ey97iWXdqgZ0re8Xk2Ly5wmcknfN3t?=
 =?us-ascii?Q?uMxkawFa5EtBmpUFUsmPaY+vv49Es/7AE+WjSuNW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46c3b00-7018-4640-3006-08db30ca8356
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 02:57:34.7824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SYcge5pfpp0Z6Ly8OHgqxWxP+34LWHAx13wuhs5FFWRIsTsost0taqyywlRcSk0JsPYBQ8m2dxDg8ugxfjjMfAeBTTixf3QsThWGedo5/1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3660
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 19:41:26 -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 01:56:13 +0000 Yinjun Zhang wrote:
> > On Wed, 29 Mar 2023 12:24:22 -0700, Jakub Kicinski wrote:
> > > On Wed, 29 Mar 2023 16:45:48 +0200 Louis Peens wrote:
> > > > For nic application firmware, enable the ports' phy state at the
> > > > beginning. And by default its state doesn't change in pace with
> > > > the upper state, unless the ethtool private flag "link_state_detach=
"
> > > > is turned off by:
> > > >
> > > >  ethtool --set-private-flags <netdev> link_state_detach off
> > > >
> > > > With this separation, we're able to keep the VF state up while
> > > > bringing down the PF.
> > >
> > > This commit message is very confusing. Please rewrite it.
> >
> > How about
> > "
> > With this separation, the lower phy state of uplink port can be kept
> > link-on no matter what the upper admin state is.
>=20
> What is "upper", in this context? grep the networking code for upper,
> is that what you mean?

Sorry, it's not that meaning. I'll remove this "upper", use netdev state
instead.

>=20
> > Thus the corresponding
> > VFs can also link up and communicate with exterior through the uplink
> > port.
> > "

