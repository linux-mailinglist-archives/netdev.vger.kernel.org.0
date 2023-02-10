Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BE691690
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBJCOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBJCOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:14:33 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F086F235
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:14:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itNKdzCvd/Gz9ufyJAhmhw6EqvU1B0nbhDbRkc83orMdnS1wAcpc/7gifS9o3hikf9/v46orZolZt/1a/IFEa3qeGrvQ7SrK/gsVKH4LpgUCjYiY7CVTTs/6zyGWwf2CVMnSc/tivTIQn8Vg103cHMEIt3X6CKqfs2xv7RfY6vYLolt6DUdGgH3vM6fWnzk23JWxN51giD/1is3nU1u7cgbzDvsj3YO/wOuHcRuO7RnyRY2NBk7HIBmv1l4dUf43umfK3UNPwqjp2QIrzBz+lvu0TtKDOz4EclCfFkUV4nYH9V3dji8mQa05qtJKl3yGvZ/JBqtnB/dKNUj9ohMuRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+NJvDb51Pn8dZvDi9FtrkV6Es3pjthnhXm+zny9jwM=;
 b=RDU9Uz5ozltYc3iQ/CU4nuqKeZ9BIVEeL9BjeUQmkJ/IAxEsoo8rd+4YFT+KWoK4gctf2pIzNDkkVGjM0SoQWSWTz8omMtRx4p3yrHnLbACPBWampy8Y4lTu3ixGbrqTZAOkVARy7K4kq2vIywDqA4F8ISJ0QUSOxVPbnd5AjfjJW7yjkOAVL+M1h3LQuCdg70eTYJ+ln70RI+Zlv0zbuPDcM1xT/ifSn2AjNusj2fogdl8MWRBqyGh66YskBWpt8wlK5fZ0Z92NY8jciDE9SYSmTjD4c0BII2OtVOZcY7tDwE3mUEfGzwMiyxHKceQUVIV0iLfc6+GpkyxH6ZWdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+NJvDb51Pn8dZvDi9FtrkV6Es3pjthnhXm+zny9jwM=;
 b=rUJ3xXFlppQC5AhOWke8EcPT9zsu5Zz+9AtitOzURBesgFMfb2GRk0xSObYWdIfFITG/RPmnuhBkQTme/5zcHyzU0PpneGjG7/KsR1kxZhWqXc11h/JHwcUzVDWsGaRf+5T9swbQMdPx++ZSkUyQXeaCV+EJUfluS80bHr+yfBg=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MN2PR13MB4133.namprd13.prod.outlook.com (2603:10b6:208:26b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 02:14:27 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83%5]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 02:14:27 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Thread-Topic: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Thread-Index: AQHZOkDn+f5zju3nNkCFsgzPnuBTBq7Cxx+AgAIjUQCAAARWgIAABLoAgAADIwCAAJ/YAIAAISwAgAAWKwCAAAk10IAA50kAgACxA5A=
Date:   Fri, 10 Feb 2023 02:14:27 +0000
Message-ID: <DM6PR13MB37058D011EC0D1CB7DD72B7BFCDE9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org> <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com> <Y+ONTC6q0pqZl3/I@unreal>
 <Y+OP7rIQ+iB5NgUw@corigine.com> <Y+QWBFoz66KrsU7V@x130>
 <20230208153552.4be414f6@kernel.org> <Y+REcLbT6LYLJS7U@x130>
 <DM6PR13MB37055FC589B66F4F06EF264FFCD99@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y+UOLkAWD0yCJHCb@nanopsycho>
In-Reply-To: <Y+UOLkAWD0yCJHCb@nanopsycho>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|MN2PR13MB4133:EE_
x-ms-office365-filtering-correlation-id: e0fb6048-c2ce-4d21-83fc-08db0b0c894f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T6Fv5d5l8i1BEEdG0Nk20InC3Oh+0rPMeNqAHuogyagStdI1PNB8Mp5E/ca8QEiMjam8JKaKgoej0IcF2u8MN2JAVzlbOnEQ4rGq+K8+TuT1N5Jhp03UuRwQcBvb79N2gbAm42xmmXnYdDOJdl3/uomlmo3YvZ6lkzb8A6zVKbHIAVjVPvodNJSVOruoKyE5YvwuKwjpKMKYcwHlxSU5eQZWwk+8DUyYgj0By9fvB08q4Vz8gpBSbZvkj8eoHtfCWzxlZoaN9IIEYbBeOJyURrMzjWkM39hQZw1+ylJpPGetKX4CsdNaJX1dfq+zAOaL07eX1n7pSMkv3ZSTuyOMK7EoTYc9m1KXZh6oxNE4aZ2TfP3QgN/1/UajOcllhIIiSJne/3Fvbt6tehh6hPJlFunmWpK37fYfCckdV+2nIe7luEVxr35YMwzG3laYscYskEjcU7JZTMPji2GYOZ2OodASUjj0hsXfCm1y7uzO3VJP98Pi5zU/sc7L1pXG843hh/KTzgdBVGh7llwLTF/POYwOJ6eEIa/K9Hb49CYxe5HAMOUb7zkQfpHnmqJbYWtaq4jy+kwqnxRYcRmmH1ZjpP07RFDb7ZEujanvLM2agP+iTB7ZSR4E/64vcc120W0qH6kzxptv2KxVVd6jqi9g8FlmTe2moM2YZF35qaKedT9lufi0FIRpPvZjhGIERq1mwpDI++Cx4AfLuw+KOXSFag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39840400004)(376002)(366004)(451199018)(8936002)(8676002)(41300700001)(186003)(26005)(9686003)(122000001)(83380400001)(38100700002)(2906002)(64756008)(76116006)(66946007)(66556008)(66446008)(6916009)(66476007)(4326008)(54906003)(7416002)(5660300002)(44832011)(52536014)(33656002)(316002)(107886003)(86362001)(478600001)(7696005)(55016003)(6506007)(38070700005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GOxw0PukFXo3rSLU5A4bUunvBxIP6lQtLEJ+ndmA8v5EAZzgsDZ8Ye1F+pBj?=
 =?us-ascii?Q?pcgj3ws5UKK2zhuv61gDIJOmbGQXs8HwysoalVtKyND+NwuJ+UpP2LQUktQg?=
 =?us-ascii?Q?3YmSHWFCMOuEC1F+u+V3wXQPLTpRmr6kDC6JgWOSWc058mBuBji3FDRNvCcU?=
 =?us-ascii?Q?uMGKcOaHwlsOaJkd1ErRAKoEeFgP8EwhulBONYoBvuZl5ZmvHGJAM5i5NiLJ?=
 =?us-ascii?Q?t+FkeuUq/H3cMdW1wM+hzo3GwR5zaF4d+8+xFuGkNSFPmUVa6xtMCNe+hggg?=
 =?us-ascii?Q?mHjyHmJQ1uQHaflPoigEoabxmQLobSi9h974uHwM8NO2tg2pD8Wcs7/aX72V?=
 =?us-ascii?Q?3IVxHnBIg2gkzEZzXlavvRupoJvMdC/3DBJJeQJR+q10byUoFw76mu3RWlzO?=
 =?us-ascii?Q?J4kPQhHXxo2IFdOqnckL2snAAs0T7P2w0r8D12V9YboqmIuwSxoQMfy6P4gf?=
 =?us-ascii?Q?00TLVq/hzJi9733w1MSMRDeY1VT0OXXgbSKVTtTIS8wirvHwI7+rIlZmBGXr?=
 =?us-ascii?Q?+FgCYffDnKoePc/pNv/ItyOvyLMw6xWmL5c96ktIfxfua8Fs7oUkzU2VeH6q?=
 =?us-ascii?Q?f4LgvQS6HT32iqwTfSLh4XT4KoVjmK/Jy5GlVCJsVOT4sTmPjZMmQe2HtRcQ?=
 =?us-ascii?Q?mHxzkNKxl6VSAzROhOAocWyu5Rqu8SY89AefiK2IoNJv137xTSDL/JuIVwrf?=
 =?us-ascii?Q?HgmCRLigVhPQMYK7veBLqM4YierVZic4aNVwBtuUua0NBmbQsx/VA67YhuPw?=
 =?us-ascii?Q?J4owQ/NoHKWHAKofA+kLUe2I4uudMrJYEQbMau01Evkp1LWeigdPpo+5SAuf?=
 =?us-ascii?Q?8cUANyPkAVTHzfOORd8AhwWMd5cPu5bvYmqyrf9oAh2p86nQhVTwAlSclo9R?=
 =?us-ascii?Q?LB4xm+Xr363spjf1496tjwaDJ6Rt0Q9b6dc9/REnt7isO926WiCKQb8MY/8P?=
 =?us-ascii?Q?dUFQ2zk5BpIASWFT7je0hIP0QGlCLwyyYmUl7do3GHjUHf4+RlaqwHLchJA0?=
 =?us-ascii?Q?WjQPxlqhWV+IXGAOj68idM5vEYRcHhq0PqUPBtE4N+d/RolnAHTN5Fu1sNfQ?=
 =?us-ascii?Q?9PnN3VVwz+fu5O3sZPW/10uLdVCJnaLalmfjh4hHWHkKb9XAVvl+u4Jca0EM?=
 =?us-ascii?Q?m1sSpMUz0GO2S9aFp4Y3OZmx+WjZbKY8DyIKhPUKKyR0+o5pW3O16YDxJTsW?=
 =?us-ascii?Q?7dx4HndCJMbhvuW3PhPYJumhfEIiDwChRyMlZn+uJyOHDSt8A51PMXcA+wcI?=
 =?us-ascii?Q?UwUFCWloRL/c2Rm4rGyGibGt7yqJmgpuQzaTudUrCQIuBFVf/6+TqJA9uOFd?=
 =?us-ascii?Q?L+boWrCQe+T4Xb8UutgmDmfmZ9jpmL+FUiaG2ettj6TLY/NGMBC+NO1csQMB?=
 =?us-ascii?Q?RYt7NsPhTfnV5IH5JUrtvIUSLupFPDv2JS+HhmL07NMsi+Xs2Lt490/qzfyw?=
 =?us-ascii?Q?FhYHTroHf65wKdXIXDzWG95sjNHXQo0lulsaliquyiBKOSNo/IdfYacN6qYj?=
 =?us-ascii?Q?BPYDsnp9pAxo9WgyE72ZNYUzGhvLRSow6NoiVioB3MTUzd9i1c0LCcRlSGIB?=
 =?us-ascii?Q?8yuux7cmCQzlwcTkqp+qEsTGbY3RqU/T9XCwtWx3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fb6048-c2ce-4d21-83fc-08db0b0c894f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 02:14:27.3635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zU1rrSUxuvU+nEmjscXVtJCOPb1bsfBt/aA5SlI1SuqzkVNdOc3ClMUzSJzy3otOj+JmeW0Xh7Lg8ftdDdIglBOHvkTyI9eip4XuNpas7WY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4133
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 16:15:58 +0100, Jiri Pirko wrote:
> Thu, Feb 09, 2023 at 03:20:48AM CET, yinjun.zhang@corigine.com wrote:
> >
> >Let me take NFP implementation for example here, all the VFs created fro=
m the single PF
> >use p0 as the uplink port by default. In legacy mode, by no means we can=
 choose other
>=20
> Legacy is legacy. I believe it is like 5 years already no knobs for
> legacy mode are accepted. You should not use it for new features.
> Why this is any different?
>=20
> Implement TC offloading and then you can ballance the hell out of the
> thing :)

I understand in switchdev mode, the fine-grained manipulation by TC can do =
it.
While legacy has fixed forwarding rule, and we hope it can be implemented w=
ithout
too much involved configuration from user if they only want legacy forwardi=
ng.

As multi-port mapping to one PF NIC is scarce, maybe we should implement is=
 as
vendor specific configuration, make sense?

>=20
>=20
> >ports as outlet. So what we're doing here is try to simulate one-port-pe=
r-PF case, to split
> >one switch-set to several switch-sets with every physical port as the up=
link port respectively,
> >by grouping the VFs and assigning them to physical ports.
