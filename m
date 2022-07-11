Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260E156D2AF
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiGKBmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGKBmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:42:46 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D06466;
        Sun, 10 Jul 2022 18:42:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yinkq5QJENrk6IF2NfeI7qmsymP5CrC7mbN9StuIVXwvNSDJzat9NojkKuNt8F7y46Z/4Ur9vsCGvzDjAtCODgqdkUiz/rpLv2Ls552YL5UnNraK6231j8IhUu0oBtEBS5BVy/4ogxfiLDPRIVFPA/s0oaKHkk8K5JoFrDksc1aj0tdVg/eDFT3dZQ6h4lOdLHSObRtXd7Xt62zAeV1fPQvRdxw4eh/u2phLWBPQVriLZnN3mFcHhT1aFWbGWIP8d7Skyvce0E3dElp/ItHIi3BtLwT/WDU8fHjZifytnOlUnxQJn6weKWw8vR+LgVnNTnDPg+iQKge7J9jdW1IBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuavuEEUzH0EQcjWRItAzQRFWkpwcfCTsHUDDwy0+A4=;
 b=iCYkxHyuKAAa5Vf2EIhLAslsLdL3Xc1X6h+BnczPnL6hjKFdNq6Wnwkv0B9PTc3YWQj3R3ezoG+UwUpIPMudNbDJIVZ1vJ3R7tcOU1b2zMAW/QZxJLX5lSNAtMdvE7oq2WQjrX6xIdJgcYLeNYexT/U0mltqcqwzbx+j8l2sgTIOnlWhrWH+x9z0CcR7c2Sxb6AIkUs4jTyr0Guq8RTvaIDu8JmJyMxI+qju6USyuXCjAPyfL/mgh7RNAPoXpwFq7125MmZt/Z9iA7a94K5nA8xeDGv1pZqR2Qdb1r0ObsUSbGFqiTzCcFUdC4XFEdtpC8loy6uR6BO0138AYbto+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuavuEEUzH0EQcjWRItAzQRFWkpwcfCTsHUDDwy0+A4=;
 b=gUxgsDu+4lz6dha7cQce2XCIj6zMfqj2BIkRfegrGP4SoZssL02KCXDiNp28bLbBDPupfI2Zl5uWWOkrpPgNjNNiC/ZRBRhDFYGSSCmLCA9YUH2QSIPwgGkKYP18XooqIrJS4wO81kYtbsJHLAQ9bCrPlsBAb1MuXk0mjJn8+J4=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SA1PR21MB2068.namprd21.prod.outlook.com
 (2603:10b6:806:1c3::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Mon, 11 Jul
 2022 01:42:42 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:42:41 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
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
Subject: RE: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYgSXbp+YB12TPHUGa3Bv46Ly1sK14ihhQ
Date:   Mon, 11 Jul 2022 01:42:41 +0000
Message-ID: <SN6PR2101MB1327827B0EA68876717F0699BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=37fbf502-6d30-442e-a817-37730b6e8ac6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-11T01:33:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02ed54b3-bf95-4abd-1837-08da62dea521
x-ms-traffictypediagnostic: SA1PR21MB2068:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KK3C3IgHRVPm0OakBco7XaL2URxsaFUw+Outelp8xLs3/BtFCz5gCc7aT29kmylMc5ADyiZcznJ40BsFjkmsPRsS/TloeEreLikuRANqzaRDT+FkrAfmK6praRlJPh2hqTDUZyNAmDf+40H9x+ylH4Un4FLNHbLrqkON7CugzkzOQTVcPdWoyCqoPBetHjhw9r3VJo64FfTa7zLyrAnDLFFQFEMjAaNr4e6YNIsUSQ6JvrgmXpmLje/isGPv7ICU8WzrLU2EtI5Zg5Zh9FgtvyCLCgLnRtey++ms+IeD6tqeteMB3z9NV43ZI3032h/UoI9j6JjhiqPVXU2FAfOtiT9N+krtCNXhoDNOUbFgBF8RvQMbnl22ox4PTSccO2AW0K8ElPBPSZZAqH3q13b0rIKuxmkeShXTNrXnsk9V0sztkpTluhJEWur8XP4SXUub4MAACqvRsVu+z3nlRGJsMp3nwM+xL8x+EsiMoYfjaM2tQTkSmM8aN40UQqZ4yWyeFk0pVpf7Ag9qFqyd3mEYUk39x3KBRFV1GRPvi17E97Nk07SFOV7i3hB6b52qvJMygDcM2CHWxiX6LFxvoqk8uzox/OQtxj24CZmRd8d4VnjnI9kJWOpkRY5fZ3RWW/9PdWZ0f47ZOtq3EPk5jAoAGeF8DOLXbJ1BNMFPprcIXY9ucEg+neLAObBtAlZisnPHK8BrEVoIgNjn4CpWcLA88OFsp4WjL6o6a1vfCBHtU/442jumoFgUEjLJMMq+vZqphTFbK+jqORArA4u4RIYySuEZIJwVEBMjcDCH6kp6Rg7Un2fgndfYleq2lQm6JLBnOWD96ztVgYbZAabG9nHUUDHg7afr1i4UJBgjHhfXac9T4kwc9aaptPV2ANoNlEca
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(47530400004)(451199009)(82950400001)(64756008)(66446008)(4326008)(82960400001)(8676002)(921005)(86362001)(66476007)(66556008)(66946007)(76116006)(7696005)(6506007)(9686003)(41300700001)(71200400001)(10290500003)(26005)(478600001)(38070700005)(186003)(6636002)(54906003)(110136005)(316002)(8990500004)(38100700002)(122000001)(7416002)(33656002)(8936002)(5660300002)(55016003)(2906002)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/ysjvLh3gktA+jxdRFMqulaQ7Tv13J6LreyZO4X1AOGyDCRDMLxfl6bb6Hsb?=
 =?us-ascii?Q?kqV/RywiMqAjimr87eX3GOgXp/O52IAe5lgvY8+l6fDhGIkdit/dsa7x6vJp?=
 =?us-ascii?Q?Tn/BhH9Sq/x1NXnkaI66f5IyhGgdtPiM50fPsOXMZxzZNRw0BEFam7RLNhMV?=
 =?us-ascii?Q?EblPLe9oBzpgf56FMfj1J60QlSj7a3WyK1hAX1tP+jBdZSH3lZReYRsCC+8p?=
 =?us-ascii?Q?v+FgMFvuk0FNrYzDx0P07umk0YptZg9F/A2Vso60w6AYGgXVxE12KRAvXNpI?=
 =?us-ascii?Q?L6d/Brxxrib+mMYVzb9v/HNkpio+M93a0L3Bx18b7lS1//C/FMbYVePe2Iub?=
 =?us-ascii?Q?U97BMRp45K4yDoanolVeAqHH8Rhv2a2MjiV7/hGqWlStLLMeIn7vN10xSQah?=
 =?us-ascii?Q?35nSLODtV09c5N5VDZpuw65nEygkDEKt0dmLevWwpnXE17vclrdCeAfnk8l1?=
 =?us-ascii?Q?GDTrlNgzaV6eRA6RZv+1DofImPeHJ4PjrkaD3zxs/FTTvQIIl1qYmlVEHRMg?=
 =?us-ascii?Q?oiiXdDdh2eC2U7lBSDE0A4ACflA2AhxHAeBkbD2gezCD/3AxXR51Y7lAJjH7?=
 =?us-ascii?Q?MPoYK23ZNxEjxnBhD8/loYwf3hhroxDzHaLtQsjoXOo6juXiWkpm2ejg8Sp9?=
 =?us-ascii?Q?lbg2GmrNtn2ZKkg/m/ioC0xnKvv/wPzRlVS10eTBcvfg6kHbVZOD4IwymxDz?=
 =?us-ascii?Q?ERJ8nrnA7i/1J8DsFtDZqxyGWiZtQExfGirgGU+1tv3OD1mpUgT95ZoTSxYt?=
 =?us-ascii?Q?p+6g6AToKXOg9xKFBuTqLFHb/lC/Ek3e69H6SgIU5LFjGnjQgcgBG8XhKV2s?=
 =?us-ascii?Q?5vzcWcGB3fGx18xjO5+HjO0YpcVOp149jyUGcMD3BuTJrO09Udjb5890qNVz?=
 =?us-ascii?Q?HKzjNhKTjNFgzoRFgeyTyqbqvA/WZR0spESmSs0F9SkO4S/1jWUdwS2+nKVm?=
 =?us-ascii?Q?XaKRn2YoOBj1PWnev3mRrFvv2TwQ1DdqsX7VLGSgXnuC1gbNlQA2tRi5UM5h?=
 =?us-ascii?Q?4oAtE2My2gAW6pZvi6FdqkARLHR1W4VuZhKhcS3SlwrTs5jQiAsR56fQ9cEp?=
 =?us-ascii?Q?uPWV/UqM98ZHW5d7YfGo2P5MWNUQfKaKqYLSLiv1uALhUHseK+DqichtSvbI?=
 =?us-ascii?Q?yEB4UPdC+WFfCpz+ttHnMkOobcn7skzmXcTePXwiztCxlDYjXEOGPVEV38X8?=
 =?us-ascii?Q?BACUYRSTLNaB7Q7fZ3MlbADJKlOBJG1QEuK6m/t4Ug/Uc1e+zyYAnVeW9xVh?=
 =?us-ascii?Q?4/wyzj+J5k34LVFQkw/9IgwRzfDbDqO4/mUsM3r3jEIZFmUn9fsvZ1VGECEG?=
 =?us-ascii?Q?hNKktClGrHvlrz5b+2jAexno93fJvh/o11x/TiW3xdL8wJdD0A7T5Qh1yS93?=
 =?us-ascii?Q?K9rSk3p+MEYcJqML40P2tZaEqB3rRY5yaGnxpUkQywxdUUH5FGt9uNa98nbC?=
 =?us-ascii?Q?Ufcvk9M4rFtLKfQ4H4XmFccuSKeSgsvTPpSiqd3RDc4WOV0e7ZOw4EAzOM55?=
 =?us-ascii?Q?S+d3/Isu4pgZqswE/XylI7a5Isoi1oPjn26qEpqONXO8Rx0/D0sREsBoRIYc?=
 =?us-ascii?Q?bNCXK9JZ0X/wFn1xjnrWOpopoef77XnzqjTQtUy0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ed54b3-bf95-4abd-1837-08da62dea521
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:42:41.8549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PAUygYVIraezT1l56+CpUqySSggDxJJ6XDESMl+pMFjmMybd7TslW9F4f6nGM/GfnJqQm09yYmN3ed47mI7jzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB2068
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> ...
> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> ib_umem *umem,
> +				 mana_handle_t *gdma_region, u64 page_sz)
> +{
> + ...
> +	err =3D mana_gd_send_request(gc, create_req_msg_size, create_req,
> +				   sizeof(create_resp), &create_resp);
> +	kfree(create_req);
> +
> +	if (err || create_resp.hdr.status) {
> +		ibdev_err(&dev->ib_dev,
> +			  "Failed to create DMA region: %d, 0x%x\n", err,
> +			  create_resp.hdr.status);

    if (!err)
        err =3D -EPROTO;

> +		goto error;
> +	}
> + ...
> +			err =3D mana_gd_send_request(gc, add_req_msg_size,
> +						   add_req, sizeof(add_resp),
> +						   &add_resp);
> +			if (!err || add_resp.hdr.status !=3D expected_status) {
> +				ibdev_err(&dev->ib_dev,
> +					  "Failed put DMA pages %u: %d,0x%x\n",
> +					  i, err, add_resp.hdr.status);
> +				err =3D -EPROTO;

Should we try to undo what has been done by calling GDMA_DESTROY_DMA_REGION=
?

> +				goto free_req;
> +			}
> +
> +			num_pages_cur +=3D num_pages_to_handle;
> +			num_pages_to_handle =3D
> +				min_t(size_t, num_pages_total - num_pages_cur,
> +				      max_pgs_add_cmd);
> +			add_req_msg_size =3D sizeof(*add_req) +
> +					   num_pages_to_handle * sizeof(u64);
> +		}
> +free_req:
> +		kfree(add_req);
> +	}
> +
> +error:
> +	return err;
> +}
> + ...
> +int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr
> *mr,
> +			 struct gdma_create_mr_params *mr_params)
> +{
> +	struct gdma_create_mr_response resp =3D {};
> +	struct gdma_create_mr_request req =3D {};
> +	struct gdma_dev *mdev =3D dev->gdma_dev;
> +	struct gdma_context *gc;
> +	int err;
> +
> +	gc =3D mdev->gdma_context;
> +
> +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_MR, sizeof(req),
> +			     sizeof(resp));
> +	req.pd_handle =3D mr_params->pd_handle;
> +
> +	switch (mr_params->mr_type) {
> +	case GDMA_MR_TYPE_GVA:
> +		req.mr_type =3D GDMA_MR_TYPE_GVA;
> +		req.gva.dma_region_handle =3D mr_params->gva.dma_region_handle;
> +		req.gva.virtual_address =3D mr_params->gva.virtual_address;
> +		req.gva.access_flags =3D mr_params->gva.access_flags;
> +		break;
> +
> +	case GDMA_MR_TYPE_GPA:
> +		req.mr_type =3D GDMA_MR_TYPE_GPA;
> +		req.gpa.access_flags =3D mr_params->gpa.access_flags;
> +		break;
> +
> +	case GDMA_MR_TYPE_FMR:
> +		req.mr_type =3D GDMA_MR_TYPE_FMR;
> +		req.fmr.page_size =3D mr_params->fmr.page_size;
> +		req.fmr.reserved_pte_count =3D mr_params->fmr.reserved_pte_count;
> +		break;
> +
> +	default:
> +		ibdev_dbg(&dev->ib_dev,
> +			  "invalid param (GDMA_MR_TYPE) passed, type %d\n",
> +			  req.mr_type);

Here req.mr_type is always 0.
We should remove the 3 above lines of "req.mr_type =3D ...", and=20
add a line "req.mr_type =3D mr_params->mr_type;" before the "switch" line..

> +		err =3D -EINVAL;
> +		goto error;
> +	}
> +
> +	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp=
);
> +
> +	if (err || resp.hdr.status) {
> +		ibdev_err(&dev->ib_dev, "Failed to create mr %d, %u", err,
> +			  resp.hdr.status);

    if (!err)
        err =3D -EPROTO;

> +		goto error;
> +	}
> +
> +	mr->ibmr.lkey =3D resp.lkey;
> +	mr->ibmr.rkey =3D resp.rkey;
> +	mr->mr_handle =3D resp.mr_handle;
> +
> +	return 0;
> +error:
> +	return err;
> +}
> + ...
> +static int mana_ib_probe(struct auxiliary_device *adev,
> +			 const struct auxiliary_device_id *id)
> +{
> +	struct mana_adev *madev =3D container_of(adev, struct mana_adev, adev);
> +	struct gdma_dev *mdev =3D madev->mdev;
> +	struct mana_context *mc;
> +	struct mana_ib_dev *dev;
> +	int ret =3D 0;
No need to initialize 'ret' to 0.

> +int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
> +{
> +	struct mana_ib_mr *mr =3D container_of(ibmr, struct mana_ib_mr, ibmr);
> +	struct ib_device *ibdev =3D ibmr->device;
> +	struct mana_ib_dev *dev;
> +	int err;
> +
> +	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> +
> +	err =3D mana_ib_gd_destroy_mr(dev, mr->mr_handle);
> +	if (err)

Should we return here without calling ib_umem_release() and kfree(mr)?
> +		return err;

> +
> +	if (mr->umem)
> +		ib_umem_release(mr->umem);
> +
> +	kfree(mr);
> +
> +	return 0;
> +}
