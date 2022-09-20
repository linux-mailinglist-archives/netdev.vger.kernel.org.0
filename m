Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4A45BEFCD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiITWIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiITWIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:08:10 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C0A7823A;
        Tue, 20 Sep 2022 15:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbH9NuZCDZWoTLOV3y/D9ox3pe+qZw/07t3Las7CqRod5fcOlAbHLjcyy6Rtok0AGxaYXoyTiDdbr35JZmkxO2XUysAWkwc1kpB8pGSoL0JqgpecZ+VY1AKZenlK+EmMaXu6sa2GC+A7azF0uk454QGAdz7cyNOl9/GvwgJJvvl3jAAtshCWEFqsH/RkD97qlegFU71yg7amqQ6be55TcRP/0jmvza25tv9qF09fMPlZVDNJw4iOnI4Y/dBMtpDGAOmVwKCzgJhfdj808srnF3njQfMi9svmeY1OlFGzsBW5SloaxVHjalMUz2ABSYGFzCUsqbXwWNDCUhr1BrKhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DE+Y/6/OpnfTK7lqwyYqMLMlvegkccnaNiITnyZ01DM=;
 b=GtwOxznltPedA+nXeKq4Q4Bs2W2gvUAfZFSZ7Bt5vLmWXm0mlUcxcyCn+O09Q7SATlmC4HAtwh4OPoo1PEp8pgV1o6x92WUfQ7I3wtBAhc9kC1RQTlLZPIUgMB70+ZUIthXOUz7yVLA23J6koW7Y9OkTwPWBRW7pR8nfMH757q1DRTnxPN2bbCRJOo79tnqVOP7Sk9ZZERePlYa32x+RdRq2W89q11XppGP2YDpQQXaHrjOB4Im+PIsh4nev9/5D5CDKcY6x1vF5vFj6krWR+xMK1ou1EJ/H7Q7X02Ai4HrvpUn/MwjHyqS2wJewRP6Xyg7loJm9CMkPq5HyLan/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE+Y/6/OpnfTK7lqwyYqMLMlvegkccnaNiITnyZ01DM=;
 b=CXOIYrP9w+ploOdSEvOQXOe/JOF4w52PpajGICkdAAm4P2ZikhZ8A03QKHhC7SKViDOLeFCCkZ6qiv9TzDxABEv9sJBeEWM+/TexwDCOvOwgOY6b80qVW1RtADkj4u1FsJvEPwfas+AQqzucpf7aXLPJaFWdDucPVYWqpohXTEw=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3683.namprd21.prod.outlook.com (2603:10b6:8:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 22:08:08 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:08:08 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 11/12] net: mana: Define data structures for protection
 domain and memory registration
Thread-Topic: [Patch v5 11/12] net: mana: Define data structures for
 protection domain and memory registration
Thread-Index: AQHYvNF726/SfHBSHEu7cEKe2/zwOa3pATpw
Date:   Tue, 20 Sep 2022 22:08:08 +0000
Message-ID: <PH7PR21MB3116926B265C25F981434DE7CA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-12-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-12-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=306ecbf9-a5e5-471c-9945-bce2e496b965;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:07:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3683:EE_
x-ms-office365-filtering-correlation-id: 95ff1871-118b-4962-9387-08da9b549978
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V38Hi++KdNHERR8hL9EcteuH8leVVVYiUhhNGkETn9slBz6y6I/yCOgcVpHTV2W7d97+XQAjWjCXpNe9N0FM/+SNxIkMd4IfWQPdQX2uMwyBmvHf39z60F38EFklnK5IU+NdXa+OEICyzA4SwyuZcu0cC1hnpQBDQxzJm/2lkEWKkgwCgSoEThYrJLZ1bgIUlJlGcGr5KKdJwQw1Gx7k+/k8NNrpWZQWHfhpvZmkfriTrBtX8T0eHxBC8ix+DoQHTLyOt5TWd1avW2BBavvxU3NvVzj1Pwy9lrth5vH7FrpuXNL1GpgOSNC8jfGVCNNGUYPCTDn7B47ynwOsm1yzFXgpEAszPZ0NejoABQuTfWT46f29NM6tuijtH492QrEo5t3u/flAZbtcwJAErjrW/oDtF33YbWvH1ySxQzX19xdGWg2AlrwPVQkq+4Gl+DBbEg8zJFZBt6z+4YZNzVRUYhEsWdq+VdwLGCqAbKBfplJr+zd8MPnBcinhDDJGiwbzb4lmts34IxDdTegpD+zBwWGeJ2y+VI3bX1P3kVBi5zqDMsbsWh3J3lz2wffYJFNC42p1nU4lXSS5NJF7+2Nbvg7fmbhrj/HY6ciXcp4spoDxdYiMjnfEnI7q8HE7MnZ4H73tBIBzyPOfBqXprcOWUrOk4DTQtrLLgn8grrG/JhGtaeUM1tOvyR6QMIg3BYHN1LNriidNv7UcSk1WmtUG4q1fegyO8wAAR/6du2s9t6LLEmvLf+BXP4M61xqmY7VzqTMnMdE4FeDNEAl8jloj1Upzojaj4pw7Rm+aSiWvYDh48snFs/dGaueUTGFb/c9LTJJca3lVLcip3W+GaY753Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(8990500004)(921005)(38070700005)(86362001)(122000001)(186003)(83380400001)(38100700002)(76116006)(82950400001)(82960400001)(6506007)(2906002)(7696005)(53546011)(9686003)(26005)(71200400001)(478600001)(54906003)(10290500003)(66946007)(6636002)(316002)(110136005)(66556008)(41300700001)(4326008)(66476007)(66446008)(64756008)(8676002)(5660300002)(52536014)(7416002)(4744005)(8936002)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H9Q3hxqUmfPfjQ8MKebSjmUKKJ3BLhYjlGTq/xkeAGvvtZN+0/rlm7mvEjOe?=
 =?us-ascii?Q?jAvuEx/7gNndHGlSi3zgtnPt2MiqXHhnRcI+KlnqRNcbtu/79ro+oJFpfGah?=
 =?us-ascii?Q?Jy2dIMfQ4FzfuqQAb2U+xeQBtssQvzP1gpCegBT/AGF/q+Iwdfavk0YuYlqf?=
 =?us-ascii?Q?LcnCgW2ylAD6JoKK5AB8/mokPCUt/Yc6cy3aYteMJIasR4M55w/xFFrylH+m?=
 =?us-ascii?Q?MTSQd37RHR1WMEPIl9UlrYynmc67T6KDGxOgNFc9zk/edtB0qWcKkgB1Q3cH?=
 =?us-ascii?Q?YSYdqRsTSgwpHX6SfdU9KQ0F+jf86Gc2Ei3gl4Hif9S8ZwnQ75q8OiCc++4I?=
 =?us-ascii?Q?BVKBw1WjJUenQhqQCX3pLFr/Hwsvyy3LAY8j0lwE7UbTa3EuFHeb5w5lU0Z5?=
 =?us-ascii?Q?pHwIt9FWgEo14OjNGeTVR3ORW4nzs40YK5jTKFvQAfj9WNcuQFLL+SicwcJv?=
 =?us-ascii?Q?JWeSUzBemmxN4VLYZMr66f6nrTTjC2Dv0te2Xjea370ULvK78/oHBoItkcve?=
 =?us-ascii?Q?1sga5/TGeLx+V7IJmgrIK+5Eg0ZDMlP3nK29Rz0T0qf30yhiB8gwkcw1T8L9?=
 =?us-ascii?Q?2Vx+pXEsGjTCUzaBvjGSgnUnevHEoBvIVFugdRs6RdcfwWyaDpWENXNZVrhu?=
 =?us-ascii?Q?L/gZ2MlZIA+xyN0bi+8P4Ez76sjI16vd7Iw+pbp5DSvxpbGcvcxXP6jIjlpU?=
 =?us-ascii?Q?NtUQWMIkTvq1LLSeHDfzhIsbA0rzI1AOmGdeorgLogP03R8tfsxRpYhnIgTi?=
 =?us-ascii?Q?zrgben6WVez3nH7MUZeQOIp+iREINeZrMNGOqj/EwvRzEG7xEUzNw5qaF4Lh?=
 =?us-ascii?Q?rdfGKvqMBOMVf2Rj+/a1RmhifF6lVENHNNONfoI9CnW+A7MT4ltRSgn1Ccmx?=
 =?us-ascii?Q?nkt28L5rfO/PaFkTQhuuj3uiumEPDk6jftqnT93ihfsGggVPGtNEUWAHQ0Eu?=
 =?us-ascii?Q?Sa2ZuAYQfDnqUZTkc9n9Ew/g62rTpnvHJSgQbohTkPO9NifktpHmBQRJSgNL?=
 =?us-ascii?Q?yhDCvOsBinnUl0nHviqgIrd9sMAQB1lM5NvTQCQmu+8A3+TQwOXm27DYtW2p?=
 =?us-ascii?Q?gpGI7SKx4yzyMOdX8mEmNwvgWLa4mXJn9oGPnWIbRsb0JVSoZcVJIJTv1NZI?=
 =?us-ascii?Q?itn202Z2JoXU3KJDMjlZERTOzKHN/DEN/mvXOafdWhaqTQ3BJzjcIfAJPPzZ?=
 =?us-ascii?Q?jflyYEYPM6eIHgslH0r1xMNWF/2Ylg/RxtExbHyeTHbLjF3EfY0lg/A0mn94?=
 =?us-ascii?Q?up3jrANMtoJ+dmADkuujObeH5Nwgw7jexxZgY82rrCX67oLUwEZQSPGMe8N7?=
 =?us-ascii?Q?LaBavmPS6HiybGbG/Pz85AtXlkcxINuxLDX/TRFcan/t7QkGvtgFhd+SwJYu?=
 =?us-ascii?Q?mwAJdWf+/VbMdnkxf8iCqv/uoDVhrj41kgtdK0hOE2eVoLlh0BCl7tdj1gB5?=
 =?us-ascii?Q?VnIPWlNt8TT54MHZXC2r3w8UZy09To8P+ub7Jqz5aYT+0Y5Dc6sbHfFEyJnQ?=
 =?us-ascii?Q?9v/YRnVd8BwONBe3E07HMjo8Csujku3HqZnED6QxHvf3jeXAJoddxzirFeAZ?=
 =?us-ascii?Q?GSMXivwQp3wODmj1G7Dmdj72wCXGsL9azAtqxrVL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ff1871-118b-4962-9387-08da9b549978
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:08:08.0564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAHQnX4wl67sBorYb239rX6Vbg0FOZJSxKTufkLFyMjdxhB5O0Xp8z3AJiVnqgX1/MpGyrqw7/BjCXsIJBQ0rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:35 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 11/12] net: mana: Define data structures for protectio=
n
> domain and memory registration
>=20
> From: Ajay Sharma <sharmaajay@microsoft.com>
>=20
> The MANA hardware support protection domain and memory registration for
> use
> in RDMA environment. Add those definitions and expose them for use by the
> RDMA driver.
>=20
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
