Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC426CF8BB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjC3Bcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC3Bcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:32:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977F62132
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:32:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKH6T2QERX3bUSxhYTEvHx8HV3YrjpkzpnqMlzjHTrN0M7lYdiM4wc+SNMrMQyWsUXjKBMa/qwdS/lDmW9azUyDmJmkx9gZRoIgLdd9bVtxSzbp/6Yplf6OwgqJ+7PGFvkrBgndCZQlVoD7unLghKjWRSisDR7ANDOsVozJCsCtjQbCqLNiZq9yMS0DXwA8r9c/jAqlNqscGX44Lm9cc/KgHedmWsJZeSTIWYK+tHhSJOEuwa0uD1e24DTTtYFeHn3TnwDpmTw4IWSVk9GMLf4ed79t6KRmDEqoLBemR7cJGEJl5U0GNjiHG6GT3mwoMGFtB0Fem2cq/c7+51hOI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PudwNwSRRBQMXgzbksonhsIDqNw11Cn8pK+ufwnw0o=;
 b=hVjBACM2OvcF8S+le62+ud0vQS9ExnP2nbW13kQMR0C9++Rl7wzAfEk1HVRvZxQzSIG2sCtLPDVUCmsrUry2YcJUng6guLUxboMsCtzDaeo81b1GMjldYs7CM/XuQ7SQdcYUknS+JUlq7mXE3GcNv0saxHE9S2Ff/BL+k1D6WFs3J5Kh5Na84+f0mi1fS8oIK27/Nl7ylVl2Qkvv2+6S/Cvz6fQyp8xAGJLfVjE1gzb6E9rs51K34wciu53QAw9BX14E9MFpf81RgV5Utx0f2SPJqlcv2Z05V0YvuOR1fCzXtAc7WzaQ6wjm1Mgd5mRdfYDNPzMBmXVGSQgBG6bylQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PudwNwSRRBQMXgzbksonhsIDqNw11Cn8pK+ufwnw0o=;
 b=WRVLu+Dg5vz6pE1cfVseXIlBUGxTwOAL0TQv623Wfv+hvRchgvi318tSE/zwHXOnZdZwem8cUTH6mnFvCFZYS0wu6KuKCShfDxzbNFVDnaTjgP1f/QrPUWHC/JskAfqbLKrHdYjaeihmJ8nnLa8uA6Im35ZE0LTLwN/FkqhoZtk=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BL0PR13MB4465.namprd13.prod.outlook.com (2603:10b6:208:1ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:32:28 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 01:32:27 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Louis Peens <louis.peens@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Topic: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Index: AQHZYk04vPXGemGWL06stjs7wjJi768SGeuAgABshFA=
Date:   Thu, 30 Mar 2023 01:32:27 +0000
Message-ID: <DM6PR13MB3705F818D9B6B25D73C2DCB2FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
 <20230329144548.66708-2-louis.peens@corigine.com>
 <20230329184959.GC831478@unreal>
In-Reply-To: <20230329184959.GC831478@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|BL0PR13MB4465:EE_
x-ms-office365-filtering-correlation-id: dfac5d17-5dc2-4a78-8e51-08db30be9f32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vmHbxqGPdOiie3va4TqR6ViAzsMvOD91r+THOwE5bKAc7c1rXc/7ToNnSywBhFAZJRRWkNOR0stBWJJiEZD1WzHlGDpop25QgjsnrLL4Bc8ko2LNGJ+KSy6YgBSNChHd7c4LR5xyd+gaDkL22UoF47GH4xI+ER36CS64pJPi+cn9RIoh9A56nsjlCMf0CB9qJxqtV7viItQov2BU+5N0/Uw/BUTNu/20lxgAqS5xW7YdEns9wqy0cFuisS7aMV+Xc90PhyipE1gA5rQ9c+mf2CRNCT0geKWhDik33/6TnfkzT4SF3wWMOhkiQWc8aSVOfPAPp4pAIcGsMd4AWWe0Lkr0k8EFNuCYlxewiRBpX7Gd4VUi4mnE3coGOP7YUMZzi549MHlgTzqlsIBekykajRlB/wJnNydAJF1bNFqY/imFOMOcPGR1J2vN7EuRQewcUKGM6vPr3ZzEVa1QXNBBrIisudfJQdTYo7y/zzUZGPGbxkoSMaFRi1XyBOFGBZskh2OVGGfTzHutsJrUUWZ5/Cw8gR0tmyQlBYRqdYqUoxM8M2vcCwjZfcjUL/5h3gw9Wn/pJSTYd7KJEFF/M5c/nWQ42MyH5BwevCcwg4KKoVGfrh+k90hgrueqn0oES8+J
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(346002)(136003)(376002)(451199021)(122000001)(6506007)(107886003)(26005)(6636002)(52536014)(316002)(110136005)(38070700005)(7696005)(478600001)(66556008)(55016003)(54906003)(8676002)(66946007)(76116006)(66476007)(66446008)(64756008)(41300700001)(71200400001)(86362001)(4326008)(38100700002)(9686003)(44832011)(33656002)(5660300002)(2906002)(8936002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E5PJXTj3fMrZvOjJh0O6qifvhYuLajWkD6Za4oFy7Rl2080RHOr3Cn9szya4?=
 =?us-ascii?Q?6VMy4/ECFq1DfLBXzHDz4ujGvyAX/+G2/mioTXQkrdBCqp2f6BGjv4GL+2Kt?=
 =?us-ascii?Q?UpPE1vj2/kbRwNZ7xBmAq8kSENWUjW6iwviftUBtkTQJYRaj7vl9/aUX+M2D?=
 =?us-ascii?Q?VgchXgT1wAi1R0ScTSM/17Ds/d9t/klaC6ZyvKRCsVT0NvKNtceKKrB3MLBr?=
 =?us-ascii?Q?aSxu+A7IqxKcrIInz6nKGVBsFqKhB0GmGxHt9NJE/VWVsgOlP7vy5LKp96YL?=
 =?us-ascii?Q?r8y40vPddJgzApJDn7QpuAMBvcdPC6yw06Dg8rqJbuAisgwp2ZWbq+2zOPtt?=
 =?us-ascii?Q?48+h8KEnbUgRZzxw7kI9ypfot0xRnpmuEEND2Zl9HWoWjUTTFkdP6aptg9R/?=
 =?us-ascii?Q?G2L3vtunk/xQhtw10BCc91X1AYo/5+ucXVFFwJJhrJQxGEcAPIxcpsWJItlr?=
 =?us-ascii?Q?iLogFAw6X19hmvWD8km1Zq4Lk3XDrA1wunET37rtpgEkxKU0dDTDaBY5KKzJ?=
 =?us-ascii?Q?xIWDDJhywdgHDx6AUYiKt99AHE5RQcni7QUecVwT3eX4xkweoQ9SCF0bcV8Z?=
 =?us-ascii?Q?TpiocWRW9TfPh8w00o/CSVg4YJInLAuZoY5qMOsNuYPmDbnoUSJKQYPlXqCV?=
 =?us-ascii?Q?OXe2BY+yYHwPIpHX2fUcUlR0ZlFqEb+6bC9BOzYtIvPPtx3vpHleloHhiUOY?=
 =?us-ascii?Q?8xKZxOByxEEevtUkBvXDTAjeqr4THSZvzV1Gw1RvX2gC3hlaAZNkFnqmYIjP?=
 =?us-ascii?Q?ToB2SzjeMs0CUlYWVjmBf/hYcBfnvlpIIM5cxU9r48fDsSIontdhSNA6E3x9?=
 =?us-ascii?Q?6VTDrJOoK8+352CL55RNnMgBPu6MU0aVGuJe2PPdHcsLg6WHQq8Im7TP5mqj?=
 =?us-ascii?Q?3EtwQU9f8Ll696jaUjZQ3lj7hp7yVNuL5FGQnHBUtDPMJiyqMkMMeSDt+olU?=
 =?us-ascii?Q?vT+63u21goapkiC6Q9l8LPXefQAGdwzUuoz+JjAifghTNlepEpvPV0Rq+3op?=
 =?us-ascii?Q?gwr2g5N2Sh7CPIS0JR1aS9T1E0g0OSj51PwQQ6tGoY31Hi/+ZSYqYJTu4nBa?=
 =?us-ascii?Q?yL6TzJdK+lppY95OQqOIHSB7JIt8+d4dwFMuKKut5ZZuGmX+S5eTX7vujg9s?=
 =?us-ascii?Q?HXwSiEPZS8Fg+ye+T28Q6AZkJJDxL2OMJrmhAkFJGhiP6UZukF8f1/dtTkeR?=
 =?us-ascii?Q?MvmU78xk9r59Khc2asfTIrM93Y7PoHFe6XGJ/G1XOteD3zo9ZMGFbebXFg/d?=
 =?us-ascii?Q?EXregON9aqL5hXIREzsqRk2HJJ0ezdYLvFxD43VkBFNgNnna4i1tZ8NtGkEz?=
 =?us-ascii?Q?37CbkQXsUbk5XhNHJKVtr/pkKuXkvfyvx+tOM8bejk7btsgfVtnhq4Afh8Bm?=
 =?us-ascii?Q?DhttDJ9DSYEr8bZhceDbKsCL3/Nc6gBCfTzApm1+AtPevDGc68gjbW5Tv+GS?=
 =?us-ascii?Q?nMmQ3fwej249JarVzWORa7o6yG97MpcRA5IyNs5oqjMX07MHAPmBtES5DzAn?=
 =?us-ascii?Q?brVXXjc8g36y8p6nasz7JQrmu4AcNgxGU9Rwa19sKwi+eUqYPgKnAj4ZLa/I?=
 =?us-ascii?Q?u5UgHbfxmzcvnGuHNKYrcCWf/teeQ9cJvffft/le?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfac5d17-5dc2-4a78-8e51-08db30be9f32
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:32:27.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53excbW1hkNxb64yf/7WHGMcOVRvqEQzoyN43d5DiNyGCFiIxqxQA3d//lw+Cd9q/uCkmp0ak8YMBLN+IMj/z9v4vc72vL8kO2gmURp/ZuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4465
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 21:49:59 +0300, Leon Romanovsky wrote:
> On Wed, Mar 29, 2023 at 04:45:47PM +0200, Louis Peens wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> >
> > `dev_port` is used to differentiate devices that share the same
> > function, which is the case in most of NFP NICs.
>=20
> And how did it work without dev_port?

No functionality fault, just cannot rename netdev as expected when the
udev rules use `dev_port` attribute as the example below.

> I have no idea what does it mean "different devices that share the same
> function".

That's how it's commented for the `dev_port` field of struct netdev:
*      @dev_port:              Used to differentiate devices that share
*                              the same function
I think it's used when single pci function instantiates more than one netde=
v.
Ref: 3f85944fe207 ("net: Add sysfs file for port number")

>=20
> Thanks
>=20
> >
> > In some customized scenario, `dev_port` is used to rename netdev
> > instead of `phys_port_name`, which requires to initialize it
> > correctly to get expected netdev name.
> >
> > Example rules using `dev_port`:
> >
> >   SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", KERNELS=3D=3D"0000:e1:00.0",
> ATTR{dev_port}=3D=3D"0", NAME:=3D"ens8np0"
> >   SUBSYSTEM=3D=3D"net", ACTION=3D=3D"add", KERNELS=3D=3D"0000:e1:00.0",
> ATTR{dev_port}=3D=3D"1", NAME:=3D"ens8np1"
> >

