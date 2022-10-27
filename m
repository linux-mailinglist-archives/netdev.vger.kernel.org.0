Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2113460EDCF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbiJ0CME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiJ0CL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:11:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2107.outbound.protection.outlook.com [40.107.243.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C43E7791
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7JmbbvEA+MvE8aadCI4odopfHQXzHWQ+nbvJpDi8atkF754tXrpy0d+gFYTqUh3jn0XayGqm3RBYDSslt0FV2gJqJaTr5ORYxzNAxsUZX638/1y7YMArfD8CJrOTDG44bTrFarkFlQgRQPf0dQB20dO7C5gy/fbYIjPRk15tIIXHPnf7gF5bjyvWVVPOfyWsCpwuih4HTvvSLFRmo6bCmddyWD6BlasyPxEy67RZfrHPsN4k+IyyuM8MA9Qx9OdnDyoImNBKIW5GOaw39FUWmYavIzfapEYoxH1v3QWrE7UQyrNEJTGnVq9vW2sDMJn3AaZIOPorcK/PT+/UGysjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9xqyUojGkMVutrgXIeG3hGauApkDEerWbzZyGM99ao=;
 b=X1dGpHiQN70liDAEp0Ss9ywjgITV3zkRE+af1NWaMspMFVkAMPPxEa3bUjK7WsA2VkWu+ECgU/aH544LZvQrc0EMf/IkzJt85+ASgRa8WZIn3GCFjO6bZS+ihIDVz1wTDnP5M6jHxDYIYW7wyVbn/hy6TPN0SiOTMN8QMkmyKzKf4EXmXnizTJmYi96TMfHfvqeNLjim6mpAr2uTZP0a0v0U7sBI+7aRH9Cb20Vdn3X606VwE5GOAkLx7k/LHDEBMKkqI+sHMraMJWYk8GBhk/j6p5oqiILvP6i94c7VhICbo/v5ArJ12EUOIHLhD8BP1SaVyWd+Ewvm3ldhc5ojkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9xqyUojGkMVutrgXIeG3hGauApkDEerWbzZyGM99ao=;
 b=h38deRy4sqvE75aH3TYDa172oKHHzWiwSXQZ4/pzEqvnv/OX5paglOcsY2SBfvQZtUQgYY1KVmRWHJX0M8NPd5oujHfnqlfAd/Vh7cVJZ6cco6VyQm4tHDVNXHpkLU1zwnnUwxzauzk52hUZ1aF9q7UTvJ4P/sSFduNsL4mn0b0=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CH2PR13MB3653.namprd13.prod.outlook.com (2603:10b6:610:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 02:11:55 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5769.013; Thu, 27 Oct 2022
 02:11:55 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Nole Zhang <peng.zhang@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Thread-Topic: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Thread-Index: AQHY48SFgqjha7IViEOJ8498J8TVQq4Wd1QAgAAJlQCACETKgIAAHZEwgAAYgwCAAAP1IIABxXOAgAC2Q/A=
Date:   Thu, 27 Oct 2022 02:11:55 +0000
Message-ID: <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
In-Reply-To: <20221026142221.7vp4pkk6qgbwcrjk@sx1>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|CH2PR13MB3653:EE_
x-ms-office365-filtering-correlation-id: 96219e13-257c-452f-5efc-08dab7c09ee5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /sp8N9KnEiRirKXzLiWFXQ/f7C6wKTGYnAMgTdDe4gbE9bnCqmI/w4Y7U4oPl2hYrZA47gfhrrfSwohIU2mqBRb4Rubwgr9aaM+2jxWB9mRoJee2S38xsCUldLfvnPhhVPTf+8eGkYMqRlcPn3Qr97fsprIuJFVT+CakNZaBn+Q50JIltWeZmDdRTeunexdfLMsxKcjAPfimMbzUA5BRgsQnNYwWAJXNb4Hb9zZRXB9sInW4qUCbwc/lpGq+gzK+zXW2DxM/p3gwDNLtH3hmnMCwTuEX0reeE6GMQ9+7uGes2Z8qDgK2sba2kLLNkLVcSXCkEXgFnn6sCm3XxQK7xqHc+3FOj9Vm6ZrFaUXCubYlewIjdXFy4YWxnfV9lztwlNNksAm48MB4/7d5iXpCSmcKSuq2k0hVTP01+i2x0WiACvh3TkyjwIuSkikIl1O+c0aBFPcd2NvaE0WtgBXptEswn7aE1qc3y0qjQ+VH8PTYl0nKhq0Ys5TOyMlqX2uf8DnKx1lBboTKpx8vNzjGvwPi8p8RcgKfyf4G/1MQSFADJHPF97SjOac62szcJH+4OXJKd/zRZC7MOvCdbVCZMkN9GrMkgeOx2RdYCLaN8MzfVgq2WwoKNrCK4TvmveHGPdPAJWES1F+7iJ1u3uo3o4NGQ/DneXAyT5rzpBh+wCLOLssYmS0GFr4MmqR+VBwTsvw1Aga/ux+oEj2sEKKod2CJt1jWED0djajkmkd3yORNon7VxEugcMabeSuoywoDTwYhmJ3mWscptr2ixxA8JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39840400004)(346002)(376002)(136003)(451199015)(9686003)(66899015)(52536014)(76116006)(5660300002)(122000001)(66476007)(7416002)(38070700005)(66946007)(38100700002)(33656002)(66556008)(83380400001)(86362001)(8936002)(66446008)(6916009)(54906003)(71200400001)(26005)(107886003)(186003)(55016003)(316002)(478600001)(64756008)(8676002)(2906002)(4326008)(44832011)(7696005)(41300700001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SYaH0kIILkZveHVku+0tkoe+uap3aDj4nPFL7O7S0xFGwoXFesFF/pVPe6Au?=
 =?us-ascii?Q?t+BwLfIfzfmdq5nyJfL7BxsjWWgszH9AxAGIzeR0WV63m49io9d4L0fEAomv?=
 =?us-ascii?Q?nZZILSFpKh9OIo/u8MnTf7xwNheFMKojOf5Jzs/Tn7iEkOfJqvN2RtCwlqnQ?=
 =?us-ascii?Q?foTjUK9LwdnZbtxRKK1H6umgof7ZuK+78X6g6a0BNUKrpADJPA0hfiQLUp1A?=
 =?us-ascii?Q?LAJfqR4zDiiIuDfSHd0GLSAA3T0GBTR4LWVK/Vejvy3SvDWvccV1UgeBLObf?=
 =?us-ascii?Q?p1cWbAE7cuvT7o5hXLn5j+LcIkPlalGM9K3DRDoexEStqcxzBuvLwl8GXbUi?=
 =?us-ascii?Q?c7jdiX9fu1W/SAhdoZO4jae9oYJpq3SG/E6x9D6QoSm3zF5XaxVmaYFRRZtM?=
 =?us-ascii?Q?LZr9U9LOLEXxj/5jtAFPM/yrCXksSx2RI94f7cyFCjk9Esz/2zelKZIRZQgF?=
 =?us-ascii?Q?fhoaob6SLiuaWVVOfUMsQ263vTgE0a9UauJOhuObwRZoOIBjGfA/l96EqLSt?=
 =?us-ascii?Q?dQrohxch5FzWKYFXOdEQq17Q6oukECF3V8N1QefSyshPoDbo0asvJUJN9xer?=
 =?us-ascii?Q?ilty1HlxiZkrfgXLbZf+YHCFEQjAhC4uhXcg4IZVaBmdEJ3brIQPyC0HfyRC?=
 =?us-ascii?Q?YTM8kf/9SXTJ9U60Brj2XPsNJsTK/wth44enAwMaMo6eBNJBbohmHn/LW/El?=
 =?us-ascii?Q?nBqhC99I0tJ5nlft/9IzjRoEX0wTPcNyRu+1++27w0t5xe9qcvkLt8mnQeWa?=
 =?us-ascii?Q?sSPO9sUTS5skhldAJYe1uhYS6BYd3HAIBDgtSgBmuko4bgnQXByxWHKodYOy?=
 =?us-ascii?Q?xcx39/d1hPTWdWtWqESLnwLa3ssaM39GlrNgqT4UXZMS16sIF5qcoStouvR2?=
 =?us-ascii?Q?j3EGuw+o/Wn7vgfdrJIyC1nzaKk0b9NBSTOEObRYgMPQePT/0A38njHUn3pw?=
 =?us-ascii?Q?YGqpg09cC9imekDoSZM1e4l4ru3xSoCZRuSoh+P4iNk6UlX1q58zZVxqia51?=
 =?us-ascii?Q?7wadkNeQz51NBsLj2NY6W06MrPR69wqdm0IISfDQOVyNDbQ8X12sLhTgRjE6?=
 =?us-ascii?Q?yT+fw0wGUXgCM4aTBDmgCbVJ7uwlM3/aMPycyqgAtkQQttAL+D0m21DpjcUi?=
 =?us-ascii?Q?Kzy1BdRDJ2mC9Zq3IcbXIfJLhudlerxRD2ifR1R7B41RUJY10fuPDcilHVhL?=
 =?us-ascii?Q?ygF93ED9DHGddzaP53GWrPnDGILhwSOOiy1wMcf77hc8tAb3oHJ267+xoFEB?=
 =?us-ascii?Q?Wx+K6Xjy+JYVGm7N6sAyvByr76wuiUwz8JzWqYx6RlN8knqgiltFFja8ste4?=
 =?us-ascii?Q?8AuNQ4mjpIl/qnmuGzwtbczL3uiSDAuWan1brYPYjxUxI5GEG1BMa3z/lyQE?=
 =?us-ascii?Q?8ghA8NGdFJ6Da21pJYAGiKE+ECO4S+fsWoapNMVkCD1GF8H1Vdj0Zl4OdRvv?=
 =?us-ascii?Q?RzmXX6qxS2A8jf3QARAnZ11bpTbZHzcosxSSl26/6cLbYF0aGC9YgYXARhBv?=
 =?us-ascii?Q?GDT9IVZFprhKEmDqYrYaxyvJkfIiEJJgoEG9wgr90Gmc7zz0spWEVOqA0kxs?=
 =?us-ascii?Q?D+TrUYbWCA0DNOKIEUw/csP10H620CDeo6jQLDSb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96219e13-257c-452f-5efc-08dab7c09ee5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 02:11:55.3157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MuUuwBMGnP7QDgXTO7PhnDUjYiRW/z5PNQkpiWUkw99Pfrlhmiw2hwST+QWv+7PbK/P6CwP+8rJ3fwMuMiJ5bviDPAHrh7swWxwA1osxpHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3653
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 15:22:21 +0100, Saeed Mahameed wrote:
> On 25 Oct 11:39, Yinjun Zhang wrote:
> >On Date: Tue, 25 Oct 2022 12:05:14 +0100, Saeed Mahameed wrote:
>=20
> Usually you create the VFs unbound, configure them and then bind them.
> otherwise a query will have to query any possible VF which for some vendo=
rs
> can be thousands ! it's better to work on created but not yet deployed vf=
s

Usually creating and binding are not separated, that's why `sriov_drivers_a=
utoprobe`
is default true, unless some particular configuration requires it, like mln=
x's msix
practice.=20

>=20
> >Two options,
> >one is from VF's perspective, you need configure one by one, very
> straightforward:
> >```
> >pci/xxxx:xx:xx.x:
> >  name max_q size 128 unit entry
> >    resources:
> >      name VF0 size 1 unit entry size_min 1 size_max 128 size_gran 1
> >      name VF1 size 1 unit entry size_min 1 size_max 128 size_gran 1
> >      ...
>=20
> the above semantics are really weird,
> VF0 can't be a sub-resource of max_q !

Sorry, I admit the naming is not appropriate here. It should be "total_q_fo=
r_VF "
for parent resource, and "q_for_VFx" for the sub resources.

>=20
> Note that i called the resource "q_table" and not "max_queues",
> since semantically max_queues is a parameter where q_table can be looked
> at
> as a sub-resource of the VF, the q_table size decides the max_queues a VF
> will accept, so there you go !

Queue itself is a kind of resource, why "q_table"? Just because the unit is=
 entry?
I think we need introduce a new generic unit, so that its usage won't be li=
mited.

> arghh weird.. just make it an attribute for devlink port function and nam=
e it
> max_q as god intended it to be ;). Fix your FW to allow changing VF
> maxqueue for
> unbound VFs if needed.
>=20

It's not the FW constraints, the reason I don't prefer port way is it needs=
:
1. separate VF creating and binding, which needs extra operation
2. register extra ports for VFs
Both can be avoided when using resource way.

>=20
> >```
> >another is from queue's perspective, several class is supported, not ver=
y
> flexible:
> >```
> >pci/xxxx:xx:xx.x:
> >  name max_q_class size 128 unit entry
> >    resources:
> >      # means how many VFs possess max-q-number of 16/8/..1 respectively
> >      name _16 size 0 unit entry size_min 0 size_max 128 size_gran 1
> >      name _8 size 0 unit entry size_min 0 size_max 128 size_gran 1
> >      ...
> >      name _1 size 0 unit entry size_min 0 size_max 128 size_gran 1
> >```
>=20
> weirder.

Yes, kind of obscure. The intention is to avoid configuring one by one, esp=
ecially
when there're thousands of VFs. Any better idea is welcomed.

