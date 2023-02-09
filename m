Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D56690EEB
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBIRLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBIRLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:11:01 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021018.outbound.protection.outlook.com [52.101.57.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5446D658C3;
        Thu,  9 Feb 2023 09:10:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWdtaYx14aG5XUx1Nn1DUFfRgtC7YxckVjZEHXeiw4As8/th/aodYU75SU4pvG7I9oca87iVQMAL+T4LOF6FITh7lCJWsqfhK5Kk+30VAYvBqhO73AGiFsZSRoaBCLgSJOGysNZwjVmf6rG8ps9Bgt5eT1nTHo2+qPhMZfXT1VDpcq0Rnmbws7Pv0uqNnZOQQhD/WdTh0rwm8znj3/QiGwEJXnKIqEARTbv7dg+43t8nWHTJg/KQjI7Xj2PXTYAAzS8idXS4YDcRmYQEQTHEHTgrLO7pIUIL2ClG+52QybOVJG4t1g/CgXu93TlU7BMBlznllpNXX+BWfH6vzkQlvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uyoy8AShoB95aDKJxP4FQjRJZclPv4tg8TzUXD2B4wY=;
 b=MmWw4ZVZTUIZbZ40bOdV1XV98DHC3Af1OaZFi8L4AbPkds8U4m8yYVP7lUFSWpwhE8LHMkhnp93QRuMUhTUkNd7A4lYoRxfMn0n78PxCI8t++3Q04c/babPWFrI0NzddLB62OT0jzN8NhWpKeUEwD+nvet5jZzT1eoNiqFt1bAEb+Wbm2mCPAqBAN2AH2WqY2negLG7y/hbYfhlEP/7S56ZrDdLgK2+qD4JIYzHzZ9cpWAh4hGxe0Nd36tZUB4Tpf3WMeLTWJX0XDzMQzC2Tw0JCAxKOstyECw8hExk0nZQkAjzdy/pbYnUVCpCRzIzPHF7+czQSa/4WiFf2LJURoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uyoy8AShoB95aDKJxP4FQjRJZclPv4tg8TzUXD2B4wY=;
 b=f1mWnFmWU1o+HuntjB64Yd9ivY9Lw0u029gyvdsCWJ6qw4UmLXFfWie38lkV+Hz9g5J3zh2dZKkfsclQvhqrs37fds8FbE+HaHMFb8kq3EePUq7spwvQixOTgPnDmJNuZVK4/J/nhMUL80oZ4U2RTk0qYCagepi0ctgedM8uVzs=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by IA1PR21MB3450.namprd21.prod.outlook.com (2603:10b6:208:3e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.0; Thu, 9 Feb
 2023 17:10:56 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.004; Thu, 9 Feb 2023
 17:10:56 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
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
Thread-Index: AQHZPBgbiUM1q6p2m0iMKUdTxdvJsq7GonSAgAAvmyA=
Date:   Thu, 9 Feb 2023 17:10:56 +0000
Message-ID: <BYAPR21MB1688422E9CD742B482248E8BD7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
 <PH7PR21MB3116666E45172226731263B1CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB3116666E45172226731263B1CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c8e0a383-fca8-454b-983a-3339aed813d3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-09T13:46:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|IA1PR21MB3450:EE_
x-ms-office365-filtering-correlation-id: 497eddf5-1f19-4a9b-9fbd-08db0ac09ba3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2FFqdVgD9YAmqmpDewycDK32CDMRJpTLSHSRShqfFUhk4Q5QpRITbt6SKANyMyqrWZ2bite3zDeq2mPvwc5iisX2rp5LI+P8yPUQswM95c1No+Qzf6QEb/ZjLHyk3eH8tGCrlKY595p/AaC9QMWiuuXFgYX7ZaJ47gWQttXULdo9ZoQkpxdYT9WjiIH2yTq0C2AHdim3LsOGRhPtjh7RrGw2WS1R4/iJXwMZ05Zv+jNWRZXdZTJ0WEc15pfQfG08vTj2WDPtl++Gs4IkeNK1lLD78y4HR0dT3hUU+t/ddjLEO+PkUN6XHeHF21p77S0GNBWywSKFqNY5zeX/IQ1o5kfRNPoQSNn1V+rDyyLsNBvkrq4icbahaEV1ccWOc+so77jiFwi3WUiXVUA5ivRjjYuiidia7x6czFzGwNlx5te5MYkYDJWN3sdXQaFwrt41oVKPGOta5zMtXB00LSnCnCIuveHsfcb/BCDfDeKhg8PRy3buLU4yH3zw7H2Kfo9jeK1ozYa5n9AWAaeVPT0NR6eeZ7WULq6kD9i9hRJiv0cWKAmt+Tx8LcmqSWuZT1Q9YJClfdzI8UCpCVtCrflZq2FeqRdzw1MZNNz/BOVtiH5W6ZSsO6QLz+cxPX3mNoOpL7XIe1xYy2nuVUQHV38IK2fGuo5+r+usfaSYp5XWld1ubJyBIIhR+P0r6qzWKzaAbQnOCOHPBXtIZKXiI1utd/RiF9L6dp3x2dZdKjD86AHOdmHJ3zS9/rCX+5phOllRi1br7wMuYldhaJbUo7admQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(8990500004)(8936002)(9686003)(10290500003)(52536014)(921005)(186003)(26005)(5660300002)(66556008)(8676002)(66946007)(316002)(64756008)(478600001)(33656002)(76116006)(6506007)(55016003)(2906002)(7696005)(41300700001)(110136005)(83380400001)(66476007)(66446008)(86362001)(38070700005)(53546011)(15650500001)(71200400001)(122000001)(38100700002)(82950400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?owbE/p5N2WHQHaESBFl1XogusBXI6GiQOE8u5uejXh8L+4YbssDB/Cv92aRJ?=
 =?us-ascii?Q?Ae37RA0lCeX1Rzz07LtU7zS8+LgCgRoSv3oXfuzPJmRelPx4wAuKMEssmJ8p?=
 =?us-ascii?Q?TRGs1KSzYqw4pP/hLF1+lYHJn0e4VKdAG0cCVJT0xXo5IV4ztCWlKkjciUrJ?=
 =?us-ascii?Q?PY+0qMNBOWZnLfpzJIbp8HiW2+cNgibJRqHVuCSYMxUzWj8rTTq90Gt86PTB?=
 =?us-ascii?Q?Dt99WeJGyDgE2t+w46l5Av+0y0c9369fSmcxvHE5viRsDMkDo5GaK+iuBY3L?=
 =?us-ascii?Q?TxQRbayp+9zDmgseFZjZYJ3187xhNbHWkeRNmpZj0Mt+togZLeZGADbVUh7w?=
 =?us-ascii?Q?e3PJ9Qc5Y37WbSwmfqLVnhOib2Cl28DT1f1ghsnXdyjUjOzsNS7q3NCsbYGx?=
 =?us-ascii?Q?pby3yGpUXbNVgowURXU+e828uJ4aHn/nvAkY+LRDvmIozIk2v6U2jq7lLzr3?=
 =?us-ascii?Q?/QEtVRzNgF/YRhM4wX07VMvRFDLo8Oy8h+Yad6E/qKh1Qwhyvhc5vIMZJGNN?=
 =?us-ascii?Q?LSa5j6WxR4C4sGcX2C/5neu7e0EEUtmq6qwhbxDq/E3IHJEvQTUqLWTh9VK2?=
 =?us-ascii?Q?qVMTZe1eTKy5AwkQpVKmJnkeAopZYldWj2aOD+f3Ce12QDA5GVP+EYfDnIQ3?=
 =?us-ascii?Q?4twtFLhCJsz+IpWlUJUhamVOiKZrsBULh8zBRSyCM1GV9a6K+egj4tlNsB8t?=
 =?us-ascii?Q?+b372uZPQ3YM58b4MsKzBNdjsBhthMzIeQS8D7ESKGPMNoC5iuF7NgYHnYTB?=
 =?us-ascii?Q?hMx5PfN8r3Ci8DVO8hrptWfbhhbbeE9OWA6ElU7uxvN/40Nu/ylCIhsPwYEr?=
 =?us-ascii?Q?sqooJ/v9pg5cT2b2FOW0EcBvW4BujPu9TsIf2gDS1dI3UGfHQzgKx+pdTV07?=
 =?us-ascii?Q?NhNsg18nWGkNAkkZe35pv5j0zzvtYP159ONwvPMxlNLaaZsRklBYcTiBfKcQ?=
 =?us-ascii?Q?uvwTAtkX2QSDLlA70W5LJzgs8QgeeUOCB4KQoAR/JiRVCwd3mWmDjw5XS785?=
 =?us-ascii?Q?XnKvUSPS5psToaXUFHIHjlG60p/ajmezJ6iIS98+yBWSL2tc+c8FBYaLLnbp?=
 =?us-ascii?Q?kr04Vah1XZJASe52iXNfH2PpXBBzWmUbhDI7N/neJySG1E4lRbMWE4icOfER?=
 =?us-ascii?Q?RTswrGjAySQeyQ8A74Rlpx3Yer5UTWrJwRkd0kRkPGU+VWYqYkaU1i5Kp86U?=
 =?us-ascii?Q?A3jcgUG/d/q/PI1DyymRcqYn43GjDjniMs2RzRc45abIdef/tXassNznOhm7?=
 =?us-ascii?Q?PMLPhFKFBGK3wQgPl82zhaYt+bD6Fq/nDJB94pICL5ApyMZsSbKAwHUlpFba?=
 =?us-ascii?Q?rvsL+QIjCF2vtdJ1ezIAobcYI5j24Mof8KiNNAkV9CkqTMCzObUfEXYBNO4X?=
 =?us-ascii?Q?qQQxWo32itqP4JTnZQTduGvTqgXsDCO8ZiPeegkIGyNNDoaKYQzjCnFS61th?=
 =?us-ascii?Q?maoDsdacSKk/a6J5Oh46/c2x/XAoyIt1pOU6FjKknoJFgcRiDTFS7k7WT5o+?=
 =?us-ascii?Q?eonjssXj8W0bK/Smxy432Yb48x5YuZRLbfnBEyTkdhXMTiTN7WwMRNRbVRWi?=
 =?us-ascii?Q?l82jXCE3Fghz2eBgoOSVCrJweo22213cvhVyYXWWkLI9w4HR7vW5hwdqtqTK?=
 =?us-ascii?Q?kQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497eddf5-1f19-4a9b-9fbd-08db0ac09ba3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:10:56.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g3W1WSnTW1Ui40f8dQnKdZIyW1lX5Ao2tu3tUoAgfaRJ+JO0XCHFkMH5xY/PO0ekQNWbx9DxEhLfD0SyTmc7v/OH5pn/ByiVAizjZ9qM2EM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3450
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Thursday, February 9, 20=
23 5:49 AM
>=20
> > -----Original Message-----
> > From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > Sent: Wednesday, February 8, 2023 6:50 PM
> > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> > <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> > hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > Subject: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
> > completion message
> >
> > Completion responses to SEND_RNDIS_PKT messages are currently processed
> > regardless of the status in the response, so that resources associated
> > with the request are freed.  While this is appropriate, code bugs that
> > cause sending a malformed message, or errors on the Hyper-V host, go
> > undetected. Fix this by checking the status and outputting a message
> > if there is an error.
> >
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> > index 661bbe6..caf22e9 100644
> > --- a/drivers/net/hyperv/netvsc.c
> > +++ b/drivers/net/hyperv/netvsc.c
> > @@ -813,6 +813,7 @@ static void netvsc_send_completion(struct net_devic=
e *ndev,
> >  	u32 msglen =3D hv_pkt_datalen(desc);
> >  	struct nvsp_message *pkt_rqst;
> >  	u64 cmd_rqst;
> > +	u32 status;
> >
> >  	/* First check if this is a VMBUS completion without data payload */
> >  	if (!msglen) {
> > @@ -884,6 +885,22 @@ static void netvsc_send_completion(struct net_devi=
ce *ndev,
> >  		break;
> >
> >  	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
> > +		if (msglen < sizeof(struct nvsp_message_header) +
> > +		    sizeof(struct nvsp_1_message_send_rndis_packet_complete)) {
> > +			netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
> > +				   msglen);
> > +			return;
> > +		}
> > +
> > +		/* If status indicates an error, output a message so we know
> > +		 * there's a problem. But process the completion anyway so the
> > +		 * resources are released.
> > +		 */
> > +		status =3D nvsp_packet->msg.v1_msg.send_rndis_pkt_complete.status;
> > +		if (status !=3D NVSP_STAT_SUCCESS)
> > +			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
> > +				   status);
> > +
>=20
> Could you add rate limit to this error, so in case it happens frequently,=
 the
> errors won't fill up the dmesg.
>=20
> Or even better, add a counter for this.

I thought about rate limiting.  But my assumption is that such errors are
very rare, and that it would be better to see all occurrences instead of
potentially filtering some out due to rate limiting.  If that assumption
proves to not be true, then we probably have a bigger problem -- there's
a bug in the Linux guest causing it to submit bad requests, or there's a
bug on the Hyper-V side.

That said, I don't feel strongly about it either way.=20

Thoughts?

Michael


