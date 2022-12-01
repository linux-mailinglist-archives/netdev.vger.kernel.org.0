Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5F063F9F8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiLAVoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAVoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:44:05 -0500
Received: from BL0PR02CU005-vft-obe.outbound.protection.outlook.com (mail-eastusazon11022016.outbound.protection.outlook.com [52.101.53.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7DDBE6BB;
        Thu,  1 Dec 2022 13:44:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwSTi3qiXFy1ltuWa8XHc8KLeMlo7GPEISLD7w7G84HHXQcCq9r4nbZyU3AFBgeRsMHpMaMPhtNPVP9rLKtAsrO1Q8DmwDkhXmXBZkH5wOukcbNlW6qvIm3PmIF0zzOhhuzG9H6BnsxygKqnbTYtJ66HUhOj25IMUy8gSU2SGAgtF9wyCH89Z4G08rTlIMJ8PDll8FjhPj//YGuLg4ahuBXotPgqhF11ExwDuq2fVkHFd8IDnwlSea87NLPOi+cZPueJrzuagPKm8by95WQTLh58bQEnHJMu+XQTWpNPjNaWP3wTytSuVVLly0XMFWRMqEVEYwoz7l4pqnuEk26EUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4SKVVQ93LeXNKlWK/Q5HaYok4t/YuonHyL5wKuhKzs=;
 b=JrSyj7O1W7i9UabeFXLCdmNAOeSXesUscKosLfBKqm07j4x53OYhRvrfyKjfdcQcHf1ud/51hRZ1i4T4277sQutPD4PtDhTWwJzLfL+EgIk88CMTGZY5jq0mQrJE4LwfPcUhjFISmIn7eOYTL9+FHoO2vhsnl+88I7KcD3IZgoqgQs45TFyciGhecWQweMsGX2HTDRTk2c59iLVEnbYOhHGpLW4jSkAAQ0MzIOznxYxN8/nIq9QKjxUzBOWX8UfkDt8Gz3mcGisF/bNLDEOO5L685UDLgkRniQ4qgGBXVK05V44JMUtHafDd8KHNClMCy9Y3xoSIfLVCoz/humOfhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4SKVVQ93LeXNKlWK/Q5HaYok4t/YuonHyL5wKuhKzs=;
 b=ieRiGjwbqNbYuPsy6F9UzAon3YIabw4zX8JxKTT0OT0lDcVrNwQWStOAWvgeWw7B7IjVuY20JhU8dsj1Pp7v2qkcCcfs00lrIu0j5tM9YROjKkVFJXU1m1j/TieU9tPI22dFRTt0jrjCzm7C7RNg2RSdS2BJ0652DJnYmEhCuIc=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH7PR21MB3359.namprd21.prod.outlook.com (2603:10b6:510:1df::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Thu, 1 Dec
 2022 21:43:59 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::ac9b:6fe1:dca5:b817]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::ac9b:6fe1:dca5:b817%5]) with mapi id 15.20.5901.004; Thu, 1 Dec 2022
 21:43:58 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: RE: [RFC PATCH v2 2/6] hv_sock: always return ENOMEM in case of error
Thread-Topic: [RFC PATCH v2 2/6] hv_sock: always return ENOMEM in case of
 error
Thread-Index: AQHZBWavJMTJ/bMLSkGZvDPWgfYY6K5ZkJOg
Date:   Thu, 1 Dec 2022 21:43:58 +0000
Message-ID: <SA1PR21MB13352787BFC7A9C40E59FB51BF149@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <a10ffbed-848d-df8c-ec4e-ba25c4c8e3e8@sberdevices.ru>
 <20221201092330.ia5addl4sgw7fhk2@sgarzare-redhat>
In-Reply-To: <20221201092330.ia5addl4sgw7fhk2@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4ba7bd93-3130-42be-a135-39ab103114a0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-12-01T21:41:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH7PR21MB3359:EE_
x-ms-office365-filtering-correlation-id: 25d9b1bd-ed71-4612-b075-08dad3e52757
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dh3wjRydhsXjJZKjqnts84SFds78uCkz9U4SfGy4ncESRNq6gw1i+HW0i8HM/nHjd8heJiGrOpqrSF13XrDlW87WMyxvhex6TkvEi5dCdVdbHtVmfnmCfRswuZEAMRfWoaRe6nsVLP3tb9vn8780g8AlOqrS5t1ahOFSLS8GVyqu2O/yrr2juVxUgCxfABEW3EZspf5S5MdqjS8R2zAgF4XrMloQStZFjiszt9jlT+FvUkOAXruIxhGELoOrrCKhkhOR+bd9RnIQ38UoavHkXvOXyIoQwLBEX7g49C3hRXJhO89Dz1GnLSE+4Gsuzau8PqQXjPCX2wFbjyy6+DmLqkvIMyLkNZV7ORa0JGvf5Y4LopCMruoOmvpuf2fNnSZFwBaS2IkPdhuDNqP/KPM6fT9M1egNuGdOyOjygN/KUrBzDEX2HD8Mf0Bdb3xrm/Dfr3HfyJBuFqPoANbHIpBoKM/MO9GkqPugCbnTIeTpiGiPscpCZrsP0owQM5KlcuslqwoMj6eg0Vt8HuV/vi06+wRmwrl+tJwHhh2x9WSgM0rN1r/sWveDJQhh6QdVltIlNiTWCnFP8KcNkTQKqnc5JfFOjWBoh/w4H+bqnQ1hzRZc+q05r87y4fuNP6C32Hu6CSOZsF+tAn0nSmq7UBjta5D5iTLxH61s/Q2BrnZiQqQfYFkiskWIC8Lu5kSH6K82YxVavC7r57UyfBjplSKnrBrUUUkFWPqGdrA+mMjKKm6OYxp0YZgnZsWJVRpnYgmd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(66946007)(316002)(66446008)(66476007)(66556008)(86362001)(8990500004)(82960400001)(38070700005)(2906002)(4744005)(38100700002)(7416002)(41300700001)(64756008)(55016003)(52536014)(5660300002)(8936002)(4326008)(478600001)(6506007)(26005)(76116006)(7696005)(186003)(9686003)(10290500003)(54906003)(82950400001)(110136005)(71200400001)(8676002)(122000001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XNdSEJs/F6vsSHtb4EFM3T+bfd8nskYVW+ZXfUCgYY5cPAFbSSCvsLSx3bwc?=
 =?us-ascii?Q?YnqvhA55KHyhkiNGfSBX9Uf3qxpb7ugkWOp1pEr2wrs0hgJxuDNXGtXPHrIP?=
 =?us-ascii?Q?cUhnSnaIsGQCJ2Pv3CynZ+dUOojgPI9lYS1H11HtX61qFPxgiFxKJuSukbKC?=
 =?us-ascii?Q?osa3xWLuuQNOhl7Cj2OtkW/tFZwI50DdctdqcFCH5/0R93jcefiiZ0kvDEeM?=
 =?us-ascii?Q?jSMr30iJ8DcnBwE28epOxGdZGSce3F74VpYuMqenzXHte0hN7v193jYnGb8R?=
 =?us-ascii?Q?NE7qGeuGZ/K6I7khnbVq1mzhJh2rZvwepxkrWRZ3StHe4VgjE1l12SrtdzvR?=
 =?us-ascii?Q?oi7UrAMxgKwCU6rae8XRHpMNNdtYD5+bVy2mQAaU2qWqBSgxQwOjowEF7SQE?=
 =?us-ascii?Q?lC71e0b+xsZSgGfpzOlbgkQTxlNciFfF3UnB3Ao72afSR0SCsbTHdL88GgfS?=
 =?us-ascii?Q?jF2LiQ4Ky6KOZr0qKcLjEW53miBW9bY7ilJgoJ5R5qnwG0EQHbVYdxk1oCIS?=
 =?us-ascii?Q?7MZc9aRi3Ff7ayS2cx+NBgz/y8KxLa5SvT9vOpUgNuZnJCsdjiZVjvOx5HKK?=
 =?us-ascii?Q?o8ecOQZOoP7+zLg16ETiO1L2fEDutszIEennDX7l26BddT+V7Z6ho+mF4cje?=
 =?us-ascii?Q?85E6G7iAcmhS9NlVHsMPbkv9LAsrk263wlfZYDxnQyQI/31oSIODaQ7JniYN?=
 =?us-ascii?Q?MdacGa5FrEnT7/EU8AKZukvpdPXriZOftoXcmhpI2Xk9yEeiNGpQ/n3Gr4l1?=
 =?us-ascii?Q?g++rxFHnhoQXqKgQeNUDlx92jjIyHjMwuVFV0kkQFQc41HgxtfbSIRWDfCw1?=
 =?us-ascii?Q?NiSHcC3sHFcPicXXKW1EwadTXRernrZo9wQFYmYmSeJfDIQcjiNuoWEYDxS6?=
 =?us-ascii?Q?CUv2OF2MZ8d4aX0fISI9PLunc2l4FyO5dBwKJtlkAbLBaam0LPimsRf4XZmw?=
 =?us-ascii?Q?6oUuyTGrFek7PesYLCOuMZA5NfzFkbPIAOIhmePkh6l+Sr529G2LI21s08XJ?=
 =?us-ascii?Q?xxffRn2RwiDVwNleca/AfpHcPpIwLX+gaOw5PI5nSnDaxbZscM/gfLUVsiJm?=
 =?us-ascii?Q?TH6ZIolPj8t6GDQuibxbKctuZi8VBNXwEPydvXqcTCq9qyeFYcodTC2qlNQo?=
 =?us-ascii?Q?RNpgEGy9PJwe3JSMaHCaDBVPf1c8xRn6IpT2H27TehUFuHayMhD59so61q4G?=
 =?us-ascii?Q?28D0L2AL/n0tBC7spT8XLVFCo6U22zivDiYBziG5of1RSzgP8eQ4Ux9jNUAd?=
 =?us-ascii?Q?B3aVRr9uSfvllFmYfiloPEnmFNbs4LcU8S9Ly5yvqfhxuLbWjNPr7cRKiGpR?=
 =?us-ascii?Q?OjNw6g6kYt9lIGQ8vZqL/UjGjMl0BbXMoUOcULkkdGCVaCX8qy35QRhoboQ3?=
 =?us-ascii?Q?YGiH7w6FirewFLXg07lbGJnmW2umHUp+jfmlQy65z56fuUW0svTNS0Qd/I0O?=
 =?us-ascii?Q?zjhAmNVd9i87es/7p4yU4lkQmizppfNIjHdIPJXF6ht1x6nCWRLcap1wAkQ+?=
 =?us-ascii?Q?bEoFlQJsL8MGr8rs7sUQOnM1xFSwn0GKCNfLbzo/7vqdyeIragk3jjtixFky?=
 =?us-ascii?Q?h6fNU58+yZIrEe/NWm/Yf1WWWUhtVFRl0vJPZ/lR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d9b1bd-ed71-4612-b075-08dad3e52757
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 21:43:58.7063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8SdAX8JsTCSdCapPTIEuttcw765WpGIld1dDMf4DEPaVEaWXclvwOSJvVhIw6qpEaDa9QYrf1m6OgqR4QBt7eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3359
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Thursday, December 1, 2022 1:24 AM
> > [...]
> >--- a/net/vmw_vsock/hyperv_transport.c
> >+++ b/net/vmw_vsock/hyperv_transport.c
> >@@ -687,7 +687,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock
> *vsk, struct msghdr *msg,
> > 	if (bytes_written)
> > 		ret =3D bytes_written;
> > 	kfree(send_buf);
> >-	return ret;
> >+	return ret < 0 ? -ENOMEM : ret;
>=20
> I'm not sure for hyperv we want to preserve -ENOMEM. This transport was
> added after virtio-vsock, so I think we can return the error directly.
>=20
> @Dexuan what do you think?
>=20
> Thanks,
> Stefano

I also think we can return the error directly.
BTW, I doubt any user really depends on the value of a non-zero error code.
