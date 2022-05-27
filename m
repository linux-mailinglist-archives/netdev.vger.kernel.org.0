Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94C95363D7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 16:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353018AbiE0ONT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 10:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351317AbiE0ONR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 10:13:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30944C42D;
        Fri, 27 May 2022 07:13:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3rGrbsJ5Ij2N0VsuxqpmhAJKisUGrmiLkz/RFqjAYRW+Wl1jGOJQgRycr2kFSKOTq2YeQVtmEReAr4+6574/bW1A4eJAVz9qf1oUC6DfolJjkbpRyjXw5E/AehGNwjlpwfchHSSPIOtmYowoJx0pnUGCtwUH2yCs/m4Osi+Lr0cpkZI/ki515n6fCq42z/JI+ZIus0Sxekx5+Hyv9A0RDxqC5ds96fSZtWRj/VpyRhZ9wo6b8uOZMP8w3Q65tEoQJl0hxXi6QwOtGlY8erfZcbiDcK2ODKVQe4BX9eFByJ63xM0cBi/YY5FLv1TcPQ4QEb05EDcvgoOc0hRzoz95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIi3PxOd/Gcef0HhcRw+dQZakln9y9hTgAOVq+0w/OI=;
 b=aKf1yxMD1a7FqiKBWSg+kZ21mcvBR6Bho49BBCePd2UfZi0wSO0dcrh92dLF5LWbcE2EOSMBxJEuLZaMD0pDmzL7tl+nr/8qy+FY5iWZhVdhW9wD+TmYN4oKdztvdD0ienCLpoGhE/SA35/2Xw6abGZNdA9bU7ESU+mar1vbOqEVtMn9WWN+RapeyoMSAt2tvEWUqDz9HoQCDx72JlbfcVIePl4tOTrV8KAoRcy0MNhkqOQ5eKpvWrouN6rHqkiy6NQVqautM5VGZJCaMF3RrJtjs1UqVUU3D15AyMFmqbni4uxZmc9dgm4q2HKl9m0XovWw1uBnyIkHCKXhs+785w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIi3PxOd/Gcef0HhcRw+dQZakln9y9hTgAOVq+0w/OI=;
 b=v5ljcLreKw4QeN5rmcYt4t6oBhTgE8k+KGJdIZaZUM5hH9ZFLRrBFx6ZsPJmN9FjGrXcfKt7dgnbXKgT8KXR/LwB/9oSJLF/L9RVazzzHQ7KlptHfI803t2f+BMrHYny7jpotR/OJ5ze4LFrKMopmg+A45LzE6eyaJ86UBqShT4=
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by MW2PR12MB2361.namprd12.prod.outlook.com (2603:10b6:907:7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Fri, 27 May
 2022 14:13:09 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6d64:a594:532e:8b84]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6d64:a594:532e:8b84%5]) with mapi id 15.20.5293.013; Fri, 27 May 2022
 14:13:09 +0000
From:   "Dawar, Gautam" <gautam.dawar@amd.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
CC:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Subject: RE: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Thread-Topic: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Thread-Index: AQHYcCaejZ+EcmRq3k6Nyj6LKxIuA60vcvXAgAFp4ICAAALPAIAAPJwAgAAKOgCAAD1RAIAAI1EAgADEoQCAAA0JgIAAbbUA
Date:   Fri, 27 May 2022 14:13:09 +0000
Message-ID: <BL1PR12MB582533E5A1A8D2E9E2C1691499D89@BL1PR12MB5825.namprd12.prod.outlook.com>
References: <20220525105922.2413991-1-eperezma@redhat.com>
 <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
 <20220526090706.maf645wayelb7mcp@sgarzare-redhat>
 <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
 <20220526132038.GF2168@kadam>
 <CAJaqyWe4311B6SK997eijEJyhwnAxkBUGJ_0iuDNd=wZSt0DmQ@mail.gmail.com>
 <20220526190630.GJ2168@kadam>
 <CAJaqyWdfWgC-uthR0aCjitCrBf=ca=Ee1oAB=JumffK=eSLgng@mail.gmail.com>
 <20220527073654.GM2168@kadam>
In-Reply-To: <20220527073654.GM2168@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=f931c7b5-3e6f-4cc7-a891-0000aa9fa24d;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-27T14:09:35Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5b666e3-630e-4b6a-f95c-08da3feb06f1
x-ms-traffictypediagnostic: MW2PR12MB2361:EE_
x-microsoft-antispam-prvs: <MW2PR12MB23611ADBFB734A3D2B905B7999D89@MW2PR12MB2361.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n4jyciAl4fvM84rX98omdUAH1MuJek1r/69QdsuQx+ygqB8jaiUOlBrtx9dXKRBIYnEbPu8ZSiloE1zyrUHtV5zmZO6Pyx9h+lkNduW7TwcqLOmRohMB4WqOSOZEnCiDhAAKHtbEZPjnyowaaaYA6LGkhQSgz1PXbTrlqoPW8G83ZeYzMFYpoMy82UqeQ+0aJuuzwe+b5CeDF3Q4zkWdmvCLY77PcfQTK+Co0qEoNCJmOaa8qrWEdiB3ra0Y6oDUziYQZyOuWJXpx9zGoDYFJ22QuLC4U0gQc8lqYPSEiyFr3YEFcDyyb34Py/bFTwSV2hA8zJk4H98UEtAoM0DoSTX4qPl3Qbwbnm2wwZMIn17f2KapHgGmc0E7TEuL3PVAaQQGT2QDlWBEwWlsVKbZp8Mfg5v1pPdJ3nTrkhO+LKsP4DNoq6hhlYoGkN8UeYEDej8hhBxeHO4vHG6oKrPfNB5uO+++itU3ZcPnadh8g19Xg5MJaj9xQ5ZZb6Hg5zf3NbJnn+DYAko3pkq+FRu+z1PkKcw+Sv92E5PqszaEGrq6KB2nuKvIa/cObRC/A32h/RMbnzMGbN2HbkdmUZ2CbwnO/oPfdlYCKIZbB8orMw8kXJgs9ddzW13LJ17z4Y8LIbtT0gpKsMouSgcEmg7GDlTINKtkZNVnntn7USnLob/kXb1yjBQ788eOSS9YBsZDn0L7Rurc7Yl8+wmvaACWdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(8676002)(4326008)(2906002)(122000001)(55016003)(107886003)(5660300002)(52536014)(38070700005)(186003)(8936002)(66946007)(64756008)(66446008)(66476007)(66556008)(7416002)(33656002)(83380400001)(38100700002)(6506007)(9686003)(71200400001)(53546011)(110136005)(54906003)(508600001)(7696005)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mibQSxSpAVd0AYFZ5Dzva2jOcDee5QZC0hxHYwouaNguv/0xg8wm+mBipoSw?=
 =?us-ascii?Q?dtQuHwnBJ4uTkh+EPbttorcBU9FgqPDVLlkelDRDhZ/T195gFqQljSIUyg+G?=
 =?us-ascii?Q?SY4Zg5mKZf/Kq7aH9w0o7GXT+RltUyNf1fxg7XWxdXT6x1ZxXtkRpyy4wpeC?=
 =?us-ascii?Q?S3bO62Fy9lffcspjCbmzg8AL0Fbo/k6xUESSJFYEoaOZahwcnWiHvZDyYfzg?=
 =?us-ascii?Q?/Vd+W7gPLugeg3nr1Ly+uqcsgdU3vQdCGv1Khv7yWba8/iG+BQBi1rvGKGcB?=
 =?us-ascii?Q?w61p9hjSCi80PWKitk9bQUZ+lAj0DJMSbGt/pmwQLljGwa40P9RsIN2KMc9Y?=
 =?us-ascii?Q?Q5Y/rQG055tia3mbz8Qdj8fkeRBJzjIpI7ocfvjZ4/MVk2Gg/SnuJbTmhydv?=
 =?us-ascii?Q?Dq84b6QboXtaetW6xWBBGA8Ez2BvgBlELbu1Yiek+H8p8JBVp2GlcAF8AVug?=
 =?us-ascii?Q?6HWFH8+/yXaxYB0g0jFmemto7T0mJLV/tymVP3Vycay3YziBcJfo4tpgt77b?=
 =?us-ascii?Q?MpffKbKl4reozl/CY3gInpLrvZXTLZ+baXJh72WM5VBCAt2wK6/Ol/nyonoM?=
 =?us-ascii?Q?wVOFi9x6RXjcYe0n7jsnQRUFuWln8zHPH5VawrmaSEHwAdTt5W4esoz8vRM0?=
 =?us-ascii?Q?m/u3o38m/C8AnLCIDyng6ZFZF4LL2iAObAW3JBjWAbngMn3Tr4JqV+MTppN6?=
 =?us-ascii?Q?5WbJBTFNiXQGGIuEfx7qcmnQ+oE3Wso3/9TAS+QzVmb9tem7gkLaM/oduiF3?=
 =?us-ascii?Q?2MMPqGttXXCBGPJ5Rh/MU9e5BORFL1ycOOI5RuzYtewkDyyTQy2vmDBJQVIc?=
 =?us-ascii?Q?mpA9c6W7am8hijLXypYn/TCs4ANzhr6upPbrq7kAXWpPaO0RO0JwsCGlvg+2?=
 =?us-ascii?Q?v0lhh00lBGo7XojfUkqO51XTaAw3Hs5c+30sbLRXSborfBu1tqPBMVPeb9y5?=
 =?us-ascii?Q?sY5wO7pHiQ2dCz8i+FuKb5h4lz2KJmDKjii9lMBj858VtYu6vgebmhiFVL+Q?=
 =?us-ascii?Q?WhuJJGqGbVlCQaOEI7O89HJWvLsx4c/t41/XNKH3po1gOnAWovjqJFKeuMbI?=
 =?us-ascii?Q?8hu/t0nAp1csabJiy7wY5FIkIHrdh0Vfu1J/3jdtKLpIVFj6NgNRrXk4QW0V?=
 =?us-ascii?Q?ooqSOKN7Slt71fK9WfYOhGbCLEdixkRd0BYduPbv/g++t+z9UDqlW9ElllJ+?=
 =?us-ascii?Q?UMGYnfIJ9MYwgLYfLmvBcSj+Goyh+45/+FKnryI7DAc+4JUAmLOrFZliTiYM?=
 =?us-ascii?Q?xgvYt+IEs+cQ3BzkXSjXGEZdCOR/YwAVRKEci4L+B7QdGQGDvvNAqKDGmUaU?=
 =?us-ascii?Q?A10lg4mxdeHkLNbeSQViw/MyvGThOnzqrhj1FpVGwAQ0M25r7zfBZT4CwdOB?=
 =?us-ascii?Q?bZTfpkcHNfB6HmGCAuDSC6B/7jx5r4LW44uSKgDFYWMfk8SrIqNoNIN38L1w?=
 =?us-ascii?Q?wiEEBhmPkhIfkzMvCtrxEyC0/U6Pw4Zf4rATAS+aFW9TXOiTc+LOGJBwvXpg?=
 =?us-ascii?Q?G/oXAEfRo41EXOKw3cuQ2AfVhMGT8wp72kK8t1DGCj9W7rW/mFcmM14BzRVd?=
 =?us-ascii?Q?o11EoY/h2H81XngbRHh8bYbmGz0oolcqdLRon0hXYvkxkSPnZ3pLLbwQZAQE?=
 =?us-ascii?Q?ghIQ+hjc9THxSpJfpMTEPpTKVR2BYCAqJPTBe/cCCXdaguPXd5Z9zkxpPHrQ?=
 =?us-ascii?Q?pxzbtgcOS+loTjd55J/Y9+TvThNFvLQDL56MLdXnCFFki6vb3R3gRdY9CId8?=
 =?us-ascii?Q?JK1sZUi/ClMk6LXyKcalIBsoX6XnSgJbiFLsxY3SwVOLFO5kYnU7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b666e3-630e-4b6a-f95c-08da3feb06f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2022 14:13:09.2576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zmsxG3uOfXMiy4rDCU5Rns6X+OCdR+nrWULeF8S1fvS6SO41x/1rEgnmlUX3pQLF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2361
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[AMD Official Use Only - General]

IMHO replacing "return ops->stop;" with "return ops->stop?true:false;" shou=
ld be good enough.

On Fri, May 27, 2022 at 08:50:16AM +0200, Eugenio Perez Martin wrote:
> On Thu, May 26, 2022 at 9:07 PM Dan Carpenter <dan.carpenter@oracle.com> =
wrote:
> >
> > On Thu, May 26, 2022 at 07:00:06PM +0200, Eugenio Perez Martin wrote:
> > > > It feels like returning any literal that isn't 1 or 0 should
> > > > trigger a warning...  I've written that and will check it out tonig=
ht.
> > > >
> > >
> > > I'm not sure this should be so strict, or "literal" does not include =
pointers?
> > >
> >
> > What I mean in exact terms, is that if you're returning a known
> > value and the function returns bool then the known value should be 0 or=
 1.
> > Don't "return 3;".  This new warning will complain if you return a
> > known pointer as in "return &a;".  It won't complain if you return
> > an unknown pointer "return p;".
> >
>
> Ok, thanks for the clarification.
>
> > > As an experiment, can Smatch be used to count how many times a
> > > returned pointer is converted to int / bool before returning vs
> > > not converted?
> >
> > I'm not super excited to write that code...  :/
> >
>
> Sure, I understand. I meant if it was possible or if that is too far
> beyond its scope.

To be honest, I misread what you were asking.  GCC won't let you return a p=
ointer with an implied cast to int.  It has to be explicit.  So there are z=
ero of those.  It's not hard to look for pointers with an implied cast to b=
ool.

static void match_pointer(struct expression *ret_value) {
        struct symbol *type;
        char *name;

        type =3D cur_func_return_type();
        if (!type || sval_type_max(type).value !=3D 1)
                return;

        if (!is_pointer(ret_value))
                return;

        name =3D expr_to_str(ret_value);
        sm_msg("'%s' return pointer cast to bool", name);
        free_string(name);
}

regards,
dan carpenter

