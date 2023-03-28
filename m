Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF6D6CBF9C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjC1Mrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjC1Mrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:47:46 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2130.outbound.protection.outlook.com [40.107.215.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C695AAD30;
        Tue, 28 Mar 2023 05:47:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkci1T1FNw/lxH+0JGEPOB49IZOTGal/hK95DN9zte5VRQaTziXNZscUtOSDtHfgCKQa8y+1r7GsLb5fU6h2SZyMNwFvlH3HHMGOCPffxw6+pDau2MlC761U6Cg5+wEhtvHiS/I/KdF1JTyvwRWHC5ujFYBFrSN1RL6i5SWytAyCkHsnLzhl45BuloZbKM3f1F/PUWFwNz4yvvlc3oOPR94QrGO6jRw72ZW6nR9bUDLFOePAOvOZkW1XIckbVwfPpeptzc45QdEurfdMc7KDoct7mIwA9JLUuFR5VI2BfiKmpPnCsSsPUg2XnO3q4WDED9TV1BCTKLJx2oVvDDWbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2///radriASgoMMVoBruNQdwW0R9yiuSvMrK8QDhYdY=;
 b=QAhR4izeyPR/I+ocv5kgjH3gpfjqlTaWNHPaf5/qdLncs8yuQPK8T6tNjjIEcFNMWRlxKWdXasrrJR1/0Pv6E8g94wHU/ed4kzsrG0yUwSTm6by/EwA+GvbnGDgE28ITfSgH9L9rfsZFRNvRpjJC5oJfSjSvRXZfp3iGqJGIUsYIt0iT0/OtdcKuNSFCDjei8vXahDoraetQQBCZUfdSMUG4f9h+dsSRCWEM8yMWXHsS98RGLezo6MtWcuPRDZYcwrtDh7jnQzdQtp3J+Yz5Rqe0qaJafFcL8Mi4yO3Ze6KYlK7zLQBX9EbaeU4XtOlKxAbzuWO8RHxt/BknvtYTfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2///radriASgoMMVoBruNQdwW0R9yiuSvMrK8QDhYdY=;
 b=TCZ/K8Z8lrAwRvXN5ZdfacGR30LwUGvPgbA+qR5k852HvFkCYnlZ2H8NLB0PMzWnV/lNnRdoaZKJ+posKa4EpEyzDOIaM0x9Sh/dPjrvSKkzmEbGYN4O2b1nFFsGlZZcmIBMAaWbBElCCaQxY8w3Re6PkWlF280bRXmmwQWBZWw=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 SEZP153MB0693.APCP153.PROD.OUTLOOK.COM (2603:1096:101:90::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.7; Tue, 28 Mar 2023 12:46:51 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::9544:9f03:90e7:b2cb]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::9544:9f03:90e7:b2cb%5]) with mapi id 15.20.6277.006; Tue, 28 Mar 2023
 12:46:50 +0000
From:   Wei Hu <weh@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Topic: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Index: AQHZYTE02QJw3cJyrE2OQ7EX2SDB268Pu6LwgABofbA=
Date:   Tue, 28 Mar 2023 12:46:49 +0000
Message-ID: <SI2P153MB0441C7535564992D4972F786BB889@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-5-decui@microsoft.com>
 <SA1PR21MB13356A77700580DF0C742856BF889@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To: <SA1PR21MB13356A77700580DF0C742856BF889@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f6d75c5-e156-425e-9f36-09272bf9a5a0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-28T06:32:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|SEZP153MB0693:EE_
x-ms-office365-filtering-correlation-id: 64424f59-6b04-4aa8-68fc-08db2f8a7fd4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZe1jlk1EGg6wCMPv88HonYCT2NQkJvVpBkPEUO4QuezRNfag7PryMpV/0xE2/Lpn4B5KfRjf4A2m1CgLTZ3jjRS1ZaErEqebCW2bfKYPVZJPPa9ngEr46Ia31kJt7RHcvr62MEywQwvlG61P1l7AmboS0JCjPbuQbjNHyY907WlO+HiMAhHc5fKViuPfQ1Kg4hG7b9n2OGBS3jH2406W4CoUqwzGb/hDW9x5/jw5G3Jtdfd1kVLV46stROjhbuR+DKudHb1XorUKJMEbR/NQIQ/cSEZCxIp+3tlGrhjK4knJYJWbnVX08j9J4+EUB7unIO07cZj5d8YB+te/T0PO+MdlZfl42OpCjAxHdxC1Fj7P88/u3MZ+Ob/xe7L0aopm8KQ+tu59t81f9TVowFETNooXivkXQo4O/5QzC0CNpjxCrvwhE7mONmpN3H1Er/GEBFl/Zu2TGgafoZRC43bQFd7KYNfO4S60Ewxg5gGZfKllt64HbrPRVVccZLOTQL5EL4Vf3b30rGWyCjCnQfu5wdiUWhEp7ik5M4sAEL+8EQX4Hw31RmNejb5Nq7L96zuZFHtxyFIUCefTqQPDCUXzLfM2z5vxWTgSIVt08fRAqpxKKJR2ct2MI16f0ajn8e77nJGxh534OYQaH9NrC1QJynClgAQ9arwMfATI669V4+xAwf4RmCpfI8L6zZ8UMOv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199021)(41300700001)(76116006)(64756008)(66446008)(66476007)(8676002)(66556008)(66946007)(4326008)(186003)(2906002)(8990500004)(7416002)(5660300002)(83380400001)(38100700002)(38070700005)(86362001)(82950400001)(82960400001)(921005)(122000001)(33656002)(55016003)(52536014)(8936002)(10290500003)(478600001)(54906003)(7696005)(71200400001)(53546011)(9686003)(6506007)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UbGhhXW0xbmjKXDWPbZ7c7/IN4iUkBXKamgpfTxmgHOwTiLqmRdHqJitxBRj?=
 =?us-ascii?Q?HXgcF7BdYbBLONw05dHDdkVy12tyHBIHN6Oczt7bqYDWx4QAsKqzIx6c6ncJ?=
 =?us-ascii?Q?+wfmXI+8P2LS6QfpxJtT3vey7m9COByqEL/tg/u/ztNFkweC5ZyRmcczjk8p?=
 =?us-ascii?Q?HU+S9SoD4NKCamW/RepVR3e1H8ZSpuDa4IIRZmMqtfgvWpI5Rx0wB1BY386v?=
 =?us-ascii?Q?v9AIoGEM+NuUJ5WZnIatHr4CZwq+30W1Zu3NqHvPrh7rViiGYPAq9EuzRbdB?=
 =?us-ascii?Q?WKenQwXbnmGPDCxvfUZn6Fh7KG/DrWX9mf2KPjQgGiyHE/eWJON91yKacSjZ?=
 =?us-ascii?Q?L/LcBxcX/NiAQxp7YHOq0522GTUpVhuyxdwEe59CrEKNbdAiSfmf4ZLw1c9U?=
 =?us-ascii?Q?XU0QAcLIToM5ls90aM2MdZaw8DcGOAuwbLHs6JIGJuPGSVDOQcDIa2Vau2Qt?=
 =?us-ascii?Q?RqK5EIZfL6Vi7kdJBsfN4QSssZvc/Ll2gK4Xt2aUZGTVJC/xwOqiS2BudDpg?=
 =?us-ascii?Q?5APpah5STN3U+A7+4k5xgKaTH+zGfyvVRgocAMaWfeMBVDNdEGp9B3boVNPH?=
 =?us-ascii?Q?zqBXFp2qpIpUiScJfEbUm6v3DIOybcyCbzmzdEvqkq4EHigijmL2x6nkMlne?=
 =?us-ascii?Q?wuUBGRlx18f3KMAEhpik/rwS9EZsbLQ8B5htEX+HBGVR5wNGtAnvb//9lnww?=
 =?us-ascii?Q?uQJFhK0NI2PWLt/JE+TjTKuz6+DzamBdQCMnw6WY6aUpmMm2afo0BtQoDrPM?=
 =?us-ascii?Q?Ih02hP3pKzNczECvkcfzt/13fdmj0K9Zwd4/1Cbk6fxtwJjpQexPNhfs2zjW?=
 =?us-ascii?Q?rTYbTvic3lAIGG48Yqv//QS9Dks1F5Hmq/hG3qIXLX01r75/2ve23IdMCclY?=
 =?us-ascii?Q?eQpum3TxAEJhIaKs3BeNLQt0A3A8z6MiWV0642zb11PLgCUhaR+Fcb5366kX?=
 =?us-ascii?Q?8NHj0hD2aNoM+5S4Q/KpJ2GkKgMFC5vpA945NWYUyxzQdkiyk4sfUB3MKFvk?=
 =?us-ascii?Q?dnUoLBvfZssjVpYHYg8Ig2YaY821M9RM+Icbzdeaus1HmfGeghgU/OKpT1vK?=
 =?us-ascii?Q?5wXLA2mHKQTLn0C4ZiuyAya191gtpoCPelpsFiUMe1g5FV44IBARVC2CE86+?=
 =?us-ascii?Q?VVlrhtVKdD16jLprqcEpFzMgsOouZbNeWWz1UvX04j4BWsk9gZoQh/lmkHpM?=
 =?us-ascii?Q?w7B+10b1mt3TOenjPIFvGmQG5ZkvYDG2I0vSPIk/cElUSg27KLN0RMsuzwqq?=
 =?us-ascii?Q?IGfIP4X2ZOBGJUnqRgzpCrwt4FuHCKOMPxERRAz3oSuagtfH1g27Y801/sk1?=
 =?us-ascii?Q?MYavE9Wv1IpdoBgLmmt4CvdB7vpKzRyKXKRm1ezz72nyU96eU0Ed4RvmyHZ5?=
 =?us-ascii?Q?2p8lNeq/LlWC+Zf8o/jxl+l00FrYDFK8ShwsKncM4BRkuReJXZVCABD2h6AR?=
 =?us-ascii?Q?g18T5LJhrVb8I/IFwwSSdqXKbQBWLvClNRMdU14TghDtIABHPr1GaLEEo4aT?=
 =?us-ascii?Q?HY8RNBSyBOON2maVXFvLL+6afFEIZxzN+9qfXKVofOBQfKvlK4iHzLvrxT4o?=
 =?us-ascii?Q?7jH0zZOOQyYkya7LD4DI68RSdZF89qDi8FdTn3/OGT6DhzjrR4UJNaHXZDLQ?=
 =?us-ascii?Q?Xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 64424f59-6b04-4aa8-68fc-08db2f8a7fd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 12:46:49.9080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aF4IIZTqsSDal1mP/OAB7XR4GpYAS2X+ZBx4JiaG6o6Hs62EuGW1sZA5J2XfY9MSqEoOYGN6U/QiW2VZy3aHFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZP153MB0693
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Tuesday, March 28, 2023 2:33 PM
> To: bhelgaas@google.com; davem@davemloft.net; edumazet@google.com;
> Haiyang Zhang <haiyangz@microsoft.com>; Jake Oshins
> <jakeo@microsoft.com>; kuba@kernel.org; kw@linux.com; KY Srinivasan
> <kys@microsoft.com>; leon@kernel.org; linux-pci@vger.kernel.org;
> lpieralisi@kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>;
> pabeni@redhat.com; robh@kernel.org; saeedm@nvidia.com;
> wei.liu@kernel.org; Long Li <longli@microsoft.com>; boqun.feng@gmail.com;
> Wei Hu <weh@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; netdev@vger.kernel.org
> Subject: RE: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
> kdump to fail occasionally"
>=20
> > From: Dexuan Cui <decui@microsoft.com>
> > Sent: Monday, March 27, 2023 9:51 PM
> > To: bhelgaas@google.com; davem@davemloft.net; Dexuan Cui
> > <decui@microsoft.com>; edumazet@google.com; Haiyang Zhang
> > <haiyangz@microsoft.com>; Jake Oshins <jakeo@microsoft.com>;
> > kuba@kernel.org; kw@linux.com; KY Srinivasan <kys@microsoft.com>;
> > leon@kernel.org; linux-pci@vger.kernel.org; lpieralisi@kernel.org;
> > Michael Kelley (LINUX) <mikelley@microsoft.com>; pabeni@redhat.com;
> > robh@kernel.org; saeedm@nvidia.com; wei.liu@kernel.org; Long Li
> > <longli@microsoft.com>; boqun.feng@gmail.com
> > Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-rdma@vger.kernel.org; netdev@vger.kernel.org
> > Subject: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes
> > kdump to fail occasionally"
> >
> > This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.
> >
> > The statement "the hv_pci_bus_exit() call releases structures of all
> > its child devices" in commit d6af2ed29c7c is not true: in the path
> > hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true):
> > the parameter "keep_devs" is true, so hv_pci_bus_exit() does *not*
> > release the child "struct hv_pci_dev *hpdev" that is created earlier
> > in
> > pci_devices_present_work() -> new_pcichild_device().
> >
> > The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
> > where the old version of hv_pci_bus_exit() was used; when the commit
> > was rebased and merged into the upstream, people didn't notice that
> > it's not really necessary. The commit itself doesn't cause any issue,
> > but it makes hv_pci_probe() more complicated. Revert it to facilitate
> > some upcoming changes to hv_pci_probe().
> >
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > ---
> >  drivers/pci/controller/pci-hyperv.c | 71
> > ++++++++++++++---------------
> >  1 file changed, 34 insertions(+), 37 deletions(-)
> >
> > diff --git a/drivers/pci/controller/pci-hyperv.c
> > b/drivers/pci/controller/pci-hyperv.c
> > index 46df6d093d68..48feab095a14 100644
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -3225,8 +3225,10 @@ static int hv_pci_enter_d0(struct hv_device
> *hdev)
> >  	struct pci_bus_d0_entry *d0_entry;
> >  	struct hv_pci_compl comp_pkt;
> >  	struct pci_packet *pkt;
> > +	bool retry =3D true;
> >  	int ret;
> >
> > +enter_d0_retry:
> >  	/*
> >  	 * Tell the host that the bus is ready to use, and moved into the
> >  	 * powered-on state.  This includes telling the host which region @@
> > -3253,6 +3255,38 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
> >  	if (ret)
> >  		goto exit;
> >
> > +	/*
> > +	 * In certain case (Kdump) the pci device of interest was
> > +	 * not cleanly shut down and resource is still held on host
> > +	 * side, the host could return invalid device status.
> > +	 * We need to explicitly request host to release the resource
> > +	 * and try to enter D0 again.
> > +	 */
> > +	if (comp_pkt.completion_status < 0 && retry) {
> > +		retry =3D false;
> > +
> > +		dev_err(&hdev->device, "Retrying D0 Entry\n");
> > +
> > +		/*
> > +		 * Hv_pci_bus_exit() calls hv_send_resource_released()
> > +		 * to free up resources of its child devices.
> > +		 * In the kdump kernel we need to set the
> > +		 * wslot_res_allocated to 255 so it scans all child
> > +		 * devices to release resources allocated in the
> > +		 * normal kernel before panic happened.
> > +		 */
> > +		hbus->wslot_res_allocated =3D 255;
> > +
> > +		ret =3D hv_pci_bus_exit(hdev, true);
> > +
> > +		if (ret =3D=3D 0) {
> > +			kfree(pkt);
> > +			goto enter_d0_retry;
> > +		}
> > +		dev_err(&hdev->device,
> > +			"Retrying D0 failed with ret %d\n", ret);
> > +	}
> > +
> >  	if (comp_pkt.completion_status < 0) {
> >  		dev_err(&hdev->device,
> >  			"PCI Pass-through VSP failed D0 Entry with
> status %x\n", @@
> > -3493,7 +3527,6 @@ static int hv_pci_probe(struct hv_device *hdev,
> >  	struct hv_pcibus_device *hbus;
> >  	u16 dom_req, dom;
> >  	char *name;
> > -	bool enter_d0_retry =3D true;
> >  	int ret;
> >
> >  	/*
> > @@ -3633,47 +3666,11 @@ static int hv_pci_probe(struct hv_device *hdev,
> >  	if (ret)
> >  		goto free_fwnode;
> >
> > -retry:
> >  	ret =3D hv_pci_query_relations(hdev);
> >  	if (ret)
> >  		goto free_irq_domain;
> >
> >  	ret =3D hv_pci_enter_d0(hdev);
> > -	/*
> > -	 * In certain case (Kdump) the pci device of interest was
> > -	 * not cleanly shut down and resource is still held on host
> > -	 * side, the host could return invalid device status.
> > -	 * We need to explicitly request host to release the resource
> > -	 * and try to enter D0 again.
> > -	 * Since the hv_pci_bus_exit() call releases structures
> > -	 * of all its child devices, we need to start the retry from
> > -	 * hv_pci_query_relations() call, requesting host to send
> > -	 * the synchronous child device relations message before this
> > -	 * information is needed in hv_send_resources_allocated()
> > -	 * call later.
> > -	 */
> > -	if (ret =3D=3D -EPROTO && enter_d0_retry) {
> > -		enter_d0_retry =3D false;
> > -
> > -		dev_err(&hdev->device, "Retrying D0 Entry\n");
> > -
> > -		/*
> > -		 * Hv_pci_bus_exit() calls hv_send_resources_released()
> > -		 * to free up resources of its child devices.
> > -		 * In the kdump kernel we need to set the
> > -		 * wslot_res_allocated to 255 so it scans all child
> > -		 * devices to release resources allocated in the
> > -		 * normal kernel before panic happened.
> > -		 */
> > -		hbus->wslot_res_allocated =3D 255;
> > -		ret =3D hv_pci_bus_exit(hdev, true);
> > -
> > -		if (ret =3D=3D 0)
> > -			goto retry;
> > -
> > -		dev_err(&hdev->device,
> > -			"Retrying D0 failed with ret %d\n", ret);
> > -	}
> >  	if (ret)
> >  		goto free_irq_domain;
> >
> > --
> > 2.25.1

Looks good to me. Thanks for fixing this.

Wei
