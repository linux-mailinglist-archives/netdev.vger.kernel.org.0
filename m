Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E20691107
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjBITKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBITKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:10:22 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008BE68ADB;
        Thu,  9 Feb 2023 11:10:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfxzFhCDAJcKGT+e5JzAa3MmnU5IAJyg+tjIfrI/uuPrqNg4UM/qMv2jqmDQ3aE21Wuf+oSTnL8SMDaNVSn9nP7hUyPSyYPIqJNrvuaxOBsVAHTG3tHXb6Gtjy0i2IJiQXNt0wVQbQ9sAwHI/nqwP997dVULPM5Bu5PQ5ErZu/tY8P+52dhghiiueeaHIWx6wahWueWnM6L3dmfRClblP1CNl0e06f2ro30u43bSOThJq5Hgwg7kzNYDPz6xgaJd9BGraFsNG8NnuKLM+sMSFJvKpxzTKsHvr9gsjzOMNpQLi6lT4j4+V/YEnsHpqggF3QK+mjCnIeYSexQBqKnB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sm65pWSGL6ZSKErwIiZTJu27xBU+cJynhHc0arEsnBQ=;
 b=Q91lpIYuCpQiclJ1oXwcHosyxZAj3NGToZNggpJbU315oKyDDN5BUPAV/7eCZyyALgcAsri7DP/iD2qwZZJct1VrrecKCn5SRPCA+ZqXqsQJ38KAkjRcmjV9XIZmewIfx/exn3mvk3I5qoqYzHou+vj1eYsVYKFPegYmeibHN0bou6Z2ptrinWDb5SINcX5Clpqf6FsIxOIaO89czr158lbkhv1eObuwRhFXz0ENSAiSbbaEHbDKT84RiwrdVMbkHj0zr0Km/qtq8Wo0qjoBDaR4ULeK+avmwkVXEmKuqjPsb8lRZVjqXos9KBWfv0IgD6LOwjjhvNeYulNDtf4fUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sm65pWSGL6ZSKErwIiZTJu27xBU+cJynhHc0arEsnBQ=;
 b=T3Yfd2DmWd3BL8jaf1NjasT8H9/4gGvZdcBeKkLgw9kVLgCjXx1g3UeCHaBeXrqQo43p5JJdtyzn0IV8KOjC+NELE++39SfbHAqu0YyPdN2kxmCDJsVEw/WDl8eNEtGkknTA+8dbiMH+YnGL9z09KQlNzU1diANf3ps893bGgHM=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by MN0PR21MB3217.namprd21.prod.outlook.com (2603:10b6:208:37a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.5; Thu, 9 Feb
 2023 19:10:17 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::4d96:93b2:6d5:98cf]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::4d96:93b2:6d5:98cf%9]) with mapi id 15.20.6111.003; Thu, 9 Feb 2023
 19:10:17 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Topic: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Index: AQHZPBgbtvv1UGK0aka4lQW1EWRBLq7GobFQgAA5EACAABxrMA==
Date:   Thu, 9 Feb 2023 19:10:16 +0000
Message-ID: <PH7PR21MB311602D700C0FD965AF792F6CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
 <PH7PR21MB3116666E45172226731263B1CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
 <BYAPR21MB1688422E9CD742B482248E8BD7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1688422E9CD742B482248E8BD7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c8e0a383-fca8-454b-983a-3339aed813d3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-09T13:46:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|MN0PR21MB3217:EE_
x-ms-office365-filtering-correlation-id: 7c3a4a1f-8a75-45b1-7012-08db0ad147aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jOtFGI7nLIZdOWXM9PwI/h7PEvQCVvzeJveF0RHLWAAhkc8igYVIiXWgWsniRQODp4vqg+QseM3RvPoQWCGsYBsGOaSt7smeUDvEF7X/vePUz34XhRitBpDnZMLE1lJagRw9+UjPiq9Zp/o3rCRqDDV7aKwZAJRU9X+/G7FiOPRBITtyiDLCcX34qP0PKLwIk14NNZ62SwqcrjVFT8FxCeswVDL2bSd8IopXRPoGMDVLO5Giq99lH9unuo38YmFYu2mZfAzlmp7NG2CQL/dB0zGEbDOXLSdYz5i2H/qJHyDG0JyDbEzl9SEda5YmwgaERvgcdLB1pQZUlVzUb3WjB+K1lEqUW2T/YAEvdLeVsufqhn9FtJZM4rjxAB6RPHNqjm3X2rm+MPDrnWLgQ667EK9e/VhfnT6R/JrS1zilZ1fGt5NUE5jcWvhdoCH3KI1YqRsjziWF4FcNMf8QkZLrs2Xy0tgNo1UaFRH1FNGusqzJSmOpIFoO8byJdr6rBPW+nbrWsbpStM/7QP5S2L+xzo3i7tTOj/jKIM1qUgz7Txm74iw1mpY9eKG8mg+BKYhJRsYf8H73C5c82MrifXIWN5q7afU+2MXwB/uVR0Lbbo2HiOyTVqgPWgq+nZX4ETGblzJqpu7U3OvwEW8RTYE8enR2Q2aMyT9J+9NP8BIO927jto3NeegOLySy3WMgWm/NgbeTEEzVb+5VMOIIoCw2Bzq584l9SAe2+gQJ8dLwFY03ADvv5/SXI+V5eXVJ6/DyoAxV9oXdbAEI+1ImToT7tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199018)(71200400001)(8990500004)(7696005)(478600001)(55016003)(83380400001)(82960400001)(921005)(38070700005)(86362001)(33656002)(38100700002)(122000001)(82950400001)(53546011)(6506007)(9686003)(5660300002)(41300700001)(110136005)(10290500003)(52536014)(8936002)(316002)(8676002)(64756008)(15650500001)(2906002)(26005)(186003)(76116006)(66476007)(66446008)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wlYCVfjzgh904WLZcMOTMcVxBNYKkBC2UslEvwTixPDbrb6W32dWDO6+1XQY?=
 =?us-ascii?Q?DNm0LyVOxM2gxJ79FOXc+X2oSYJ6RAFlZaRKwmD7QxGuiZNeLrpWTkXIC9hu?=
 =?us-ascii?Q?e1zCf763mqdh2NXhCHliGer9wjm4XqISuCbEY2fGDMhwxn35JWiMOAbulZi4?=
 =?us-ascii?Q?qACB3AnjRcDAXSbXaYCSoRK9KT9QLR2ql3Mpd67UC3vEfhjpGEY3zRYd6NqD?=
 =?us-ascii?Q?87cLK8yRr//QUtKx93+mRkLFcjgC8tNPCGMqEmGayWzhTF6P+TyYpXtom2wm?=
 =?us-ascii?Q?kQ4HD24gMwnAq50y7hiQVWFLy8Gu+KU/r67XEw4T3pMfTR33hZ4+qb2EFTmE?=
 =?us-ascii?Q?QbbH1m0TF8u4yIbpRi+wacb/rcz5/pqWsGtA2tJ0XcropGgHmN4x8PxA+0l+?=
 =?us-ascii?Q?FY1TVsJuv+tkYKoe0T8t8P1XqKCKigpjDoQ17fPjPQzi9wYQeapLF6OmyxFP?=
 =?us-ascii?Q?c0cHCLrD1umevWaItQOjTQJQoSzs1tUxR0qcFfRj/0pySXU0OrhyAui3M7Wb?=
 =?us-ascii?Q?mlcBTr68ISDBI9zQaj9oPn7qTgd+NS05g7lNbZaIdHT3OUVkN+t72RbwkdE7?=
 =?us-ascii?Q?1sPSrD0C6BbpzWg1+4T80q6TqrUMOPJZ3pw8sTWfADPi3m9RYsPlOu4QlqYb?=
 =?us-ascii?Q?SaVejq5pvFDk9BE+Pv4JxFdPu1MD996c7NfBGBB0HS62QDhCeGh6YYlNHHFI?=
 =?us-ascii?Q?tEER8bYgGlMzHW79r+SDC20ATlbE7JlfDGw0CBBuzUtFWwjB4YT8x4MAoXC2?=
 =?us-ascii?Q?HfyPo5L5rvDfp5v0C9IIJIfyEv+WLf9nXsCFom7B3x62DM+gvyfk8QiDDhBB?=
 =?us-ascii?Q?YrOAyLeb3OJP6sB1CbSN0nD+JELzzYfx8hPgZih+mNeLAey6og+zm7dtYDu8?=
 =?us-ascii?Q?YR3Xs470z0RGyfiWOLI2VtDn+7KJ/F6f8HsIfRahsk+ZARCCdwcj7OfEEHIs?=
 =?us-ascii?Q?CN8GrPNHP0RrnnOYyNfleaO42Ua4JppEZ8OZwvfrpIPrbxx/IXrFEV8jPon9?=
 =?us-ascii?Q?OcCNTW8Exe/wpjRFRHKoRAlnFIJiHt6qnZNSTPHRSByAe9yDpreupNi0gYyc?=
 =?us-ascii?Q?mLUEeC7WgYAyzC+dwhqTn2G+MLKee2+N2zPiQLiSMWju75ERohJAnj17aG74?=
 =?us-ascii?Q?sqJ9qSh7efEXiYdwqcseylJl01CjrE7TnfBBPT+qQU/Fc3Llq+/+cwbSdzSh?=
 =?us-ascii?Q?UHfXXA8RGB6NBK34sy9xSLIW7M4VOXSEkD1HdeZ2KaEhyS0eV9MvERc3Xdfj?=
 =?us-ascii?Q?ZMc8VULow5in7L1d7Vk42MSg/NivDcmPECSr14NLn/oNRMbLjlZ22VlIUB8x?=
 =?us-ascii?Q?W1MSwcvlDAsgketbo8TVjGr9kBGAu4ENtMomWeoBwcwwasa2GhoxtBRVTWNb?=
 =?us-ascii?Q?/mJ5uy7fh7wGVaOFYFdTInCMHyL8stp9BqHe3vqxdijPvCE4XYbAUayg7RZk?=
 =?us-ascii?Q?+TCF0BoNFaYVP4eI5rl+krq1jMmygOvDVob4hemWam8lYzORrJg8L8UOJVYG?=
 =?us-ascii?Q?GtrLXZ9vrd7rplo90qK5UzFx2+3mtsVmpOAuzEqKw5riO3R8FH7h6dgyZdhJ?=
 =?us-ascii?Q?W2jfzdZJB+S+xr51wZ0KMMIjV0KkQ3LEgDXiB0wm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3a4a1f-8a75-45b1-7012-08db0ad147aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 19:10:16.9696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyBsA4vQCy0HIT+4SRBr0J5HZuoEMUfFJv7lbNjYMS+4KScHSKGouDJkxLG6oi1v0FGsPTI9fA/HNUlQ9gTHwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3217
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
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Thursday, February 9, 2023 12:11 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH net-next 1/1] hv_netvsc: Check status in
> SEND_RNDIS_PKT completion message
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Thursday, February 9,
> 2023 5:49 AM
> >
> > > -----Original Message-----
> > > From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > > Sent: Wednesday, February 8, 2023 6:50 PM
> > > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > > <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> > > <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> > > kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> > > hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > > Subject: [PATCH net-next 1/1] hv_netvsc: Check status in
> SEND_RNDIS_PKT
> > > completion message
> > >
> > > Completion responses to SEND_RNDIS_PKT messages are currently
> processed
> > > regardless of the status in the response, so that resources associate=
d
> > > with the request are freed.  While this is appropriate, code bugs tha=
t
> > > cause sending a malformed message, or errors on the Hyper-V host, go
> > > undetected. Fix this by checking the status and outputting a message
> > > if there is an error.
> > >
> > > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > > ---
> > >  drivers/net/hyperv/netvsc.c | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > >
> > > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.=
c
> > > index 661bbe6..caf22e9 100644
> > > --- a/drivers/net/hyperv/netvsc.c
> > > +++ b/drivers/net/hyperv/netvsc.c
> > > @@ -813,6 +813,7 @@ static void netvsc_send_completion(struct
> net_device *ndev,
> > >  	u32 msglen =3D hv_pkt_datalen(desc);
> > >  	struct nvsp_message *pkt_rqst;
> > >  	u64 cmd_rqst;
> > > +	u32 status;
> > >
> > >  	/* First check if this is a VMBUS completion without data payload *=
/
> > >  	if (!msglen) {
> > > @@ -884,6 +885,22 @@ static void netvsc_send_completion(struct
> net_device *ndev,
> > >  		break;
> > >
> > >  	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
> > > +		if (msglen < sizeof(struct nvsp_message_header) +
> > > +		    sizeof(struct
> nvsp_1_message_send_rndis_packet_complete)) {
> > > +			netdev_err(ndev, "nvsp_rndis_pkt_complete length
> too small: %u\n",
> > > +				   msglen);
> > > +			return;
> > > +		}
> > > +
> > > +		/* If status indicates an error, output a message so we know
> > > +		 * there's a problem. But process the completion anyway so
> the
> > > +		 * resources are released.
> > > +		 */
> > > +		status =3D nvsp_packet-
> >msg.v1_msg.send_rndis_pkt_complete.status;
> > > +		if (status !=3D NVSP_STAT_SUCCESS)
> > > +			netdev_err(ndev, "nvsp_rndis_pkt_complete error
> status: %x\n",
> > > +				   status);
> > > +
> >
> > Could you add rate limit to this error, so in case it happens frequentl=
y, the
> > errors won't fill up the dmesg.
> >
> > Or even better, add a counter for this.
>=20
> I thought about rate limiting.  But my assumption is that such errors are
> very rare, and that it would be better to see all occurrences instead of
> potentially filtering some out due to rate limiting.  If that assumption
> proves to not be true, then we probably have a bigger problem -- there's
> a bug in the Linux guest causing it to submit bad requests, or there's a
> bug on the Hyper-V side.
>=20
> That said, I don't feel strongly about it either way.
>=20
> Thoughts?

I haven't seen any cases of large amount of TX errors so far (Our=20
existing code doesn't check it).

But I'm just worried about if a VM sending at high speed, and host side is,
for some reason, not able to send them correctly, the log file will become=
=20
really big and difficult to download and read. With rate limit, we still se=
e=20
dozens of messages every 5 seconds or so, and it tells you how many=20
messages are skipped. And, if the rate is lower, it won't skip anything.=20
Isn't this info sufficient to debug?

By the way, guests cannot trust the host -- probably we shouldn't allow the
host to have a way to jam guest's log file?

Thanks,
- Haiyang

