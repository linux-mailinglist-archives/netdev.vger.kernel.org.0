Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79306C1341
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCTN1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjCTN1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:27:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43012528C;
        Mon, 20 Mar 2023 06:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rnsq/X63b31pca5NexZcDSVGfBgDg/+b3ZsZKYFW+zeC3IGIjzfiT6RJ/3wO5PSC+j6snUioaftIrCI+Na2pJQHDIJWQrrWvKdqXDw0qgjG7bKkJ/qg1ZiAAU7IswlBMFs6OJjXRs0ca0NedDl8OfQdX+x4FfWfGAytwyJeveN1kEtrjL0QOLhRGGBxvBaQX0JdGJbTDFV/E5xQ/bTVK8CfYCVXnBfKV8ZPsIk363FUusUbq1zddsKtugphYLx/TuPsPuoiTWbe7f0HE3YuseooaI/3UscS6fRDHbZv9ORgDUkqyXtM5rfN/KOYrI91+V535EWN7c2DA1jTBSo6XJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ok1DuOvJ93CbELVy/ByvQlweU5vJbTjXQuLHs068S8=;
 b=hn6LpIxFXX1QjvbT2+b/ypnARfuf1KFFFYAvYuGMshsM6a4b5FKXWt9Z/kjkV3nKy+D0SPmmp0EH8ZEkJ63b8LTKTMsIn7h+RevzeeEjRQdxu97LToVMKDxuJI+1Yfijwq9IGL+OlEwztOyyQ832m52IB+zuykp0KL5DwgDpYhL6UeMRFo3yqNP7M7d2Q3KX7raPTNx5mNmYiUzLVv3uX7g20qSXqab25T9OTX8TC76Zlt0CsTd9692JzSBX7a5vKWf+XGCUhQRLAQgVrHG1UZHp30+z1MORxMIc7DRubQRQM780imTud3PJ9uEuTOI6/FIJuUVIZTT7OQE5cpYVwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ok1DuOvJ93CbELVy/ByvQlweU5vJbTjXQuLHs068S8=;
 b=Yp4s/s+7SFpdar8rr7tdakFvOs7uNJHVnYVPnBgyXG4KjiS2RBZxFTcrisE+MTels6cmdppl6jruDGMLscIbwYNRirO04v2eoJEPM/vZWhVafxSYQORzCt7llSPfZsYsf79t8OW0HBJ+LHWc9Ymm6swsAL2aFTMUXn0newvMuuw=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 13:26:55 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 13:26:55 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
CC:     "Tsao, Anson" <anson.tsao@amd.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: RE: [PATCH] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
Thread-Topic: [PATCH] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
Thread-Index: AQHZU3HKMb/q0Atlp0eQyQVMh+RQAq8DuDNA
Date:   Mon, 20 Mar 2023 13:26:55 +0000
Message-ID: <MN0PR12MB6101B914FFDEA3882E8BB232E2809@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20230310170002.200-1-mario.limonciello@amd.com>
In-Reply-To: <20230310170002.200-1-mario.limonciello@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-03-20T13:26:54Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f095a2a6-ad32-47e5-8ad5-ea60227963c6;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-03-20T13:26:54Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 4155efb8-77ad-44f8-8cc5-9638c62a6d5e
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|PH7PR12MB5620:EE_
x-ms-office365-filtering-correlation-id: 7dd49771-8aad-4dc1-e4f3-08db2946c61f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qFZQ4KD0jPFu43D3XAlYbvhTt5lWL1f/3GtXLsomYGVsQLtSa2V7Agx0GRLlsTyHOIC0rnEaNFnjmblb36CqxM91ECmkOnDxQanlU+jSe/MBTTMiiRx0trE6iVDmIULq1d/RCeG+UpeL8JAPN15s/gCtuFfsWf/Zy9IMUaRej+0WUmlSGEuzT7mk3ZTBjWM+1mYDoBVcJIYPTZCdBTNhPLmsSwsuaaqM/qPhTRBS54ckeSWuXfJpAeR+4jowG/UVm6RdNhybMf7jhjv1tiISgWmIw8IGY3JR8bORDMgTaLl9PabCZ4qlzLAiJ2VkWpUaARExXZM2XydOsBi5InG8uSC8lKuigzwCtGvr4DSmkqyTTJ1r45Uqup1r8nj4gtZoRyGZfhrS/ML+jR81bWa3586dfelTjfiuy+GMuzMXocPkXaO9lYCX6C6IZqJxcDvQIAOPkopeZZIWWUsPK0tL4lUkck5qrroT+LYFMjC6WhhP+WYQTz04i9MUrSPSzPDy0KP4Pb+LizOyNVroxGY1ZZhzrNKxNGv7BMXeoMgkhDjd4e1spjkO24fIMtemub+BdS9h1URHQM5dR3VcGi13lTYnI7GsCFzU+WA1zfqskEQ7iPK58G+bBzAq8TOpRbB8G/fvqiz25LiY9vPBJr8dQPikQajGsYVZeBN7brqpKamVJauIdMuq/Ao07e8T0yd+10HWIn13buCJpZYusR5ykw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199018)(8936002)(6506007)(53546011)(26005)(52536014)(5660300002)(478600001)(41300700001)(33656002)(55016003)(71200400001)(76116006)(66946007)(66556008)(64756008)(66446008)(66476007)(8676002)(38070700005)(4326008)(83380400001)(7696005)(38100700002)(54906003)(122000001)(186003)(9686003)(316002)(2906002)(110136005)(86362001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gWsij5fo/iGLKuewp+C/rNcUbSBu6BD0pFLL0WXHlag0x5JWpMKM4v5w3zHd?=
 =?us-ascii?Q?5f6TH7Qn9/FRMaQFKfHD3Gaswx0CR9sYUBcL9Zww96nkOP0h7TuadkvXO8ss?=
 =?us-ascii?Q?X8886y1nyy2mB8IFwroEr2Am4X+pd/V2vFFHyAC6tjLj/ibRCVg7sGbGzljO?=
 =?us-ascii?Q?LPlv1VpTE6PQuYiHPVY13r7sPRJVvfs1Wf17AYOSk1NePS27N1R5Rl927+6q?=
 =?us-ascii?Q?v9p4C+Jt4qJX8rfRZIvExsuwRkkCyN+F7XTHDk+oGgxN3sgaB0fwVBR0c6OP?=
 =?us-ascii?Q?+WuqyDU7o3hskR3Fkas/eiIjmcO049ks4SlsiHM4f507JtFUj+ht6/eCFdCo?=
 =?us-ascii?Q?CHukz+usPxZ38nd0kT51qGLQ11YyqRrq5cQUSzGOqRBSABniJQDIDj3HWuYx?=
 =?us-ascii?Q?O4+4260IHxJOsNPn3+ERZpNEylBKUxB5IXOPdD4B/mg0u0IHwqN6vcKaFyhR?=
 =?us-ascii?Q?gsaYIARbUOZ++aroOb2XsxrxdCVkcIL0M0X67RvCONAONEXbFrmr3qguxf9T?=
 =?us-ascii?Q?n84Al1+lr4GsdJDVuGMiU8SOYbC2OXUwcYc/wXHJXDsQc65xVucjRqxCEOw6?=
 =?us-ascii?Q?x22ok+6ddVeriolhMikynJz7iHNmQ8nFw3D8GKidosnJLiacTlc9S5cp+UPq?=
 =?us-ascii?Q?ouqhpBYlrabsHlZqFwZ3vPDZ3yVi6/JpDhXadUKSB3vmPPChAZF+lWYQjzcw?=
 =?us-ascii?Q?5xro/WP+uIX+b6WNZCImjsdXT+2ARHdRIPTgDdDF7OVuNlesM/4W1KtrpR4+?=
 =?us-ascii?Q?+zIyz1y8Ks9v1NZlIWSLLH3FoVqFEqIrgQMFkAxSLjoadOuu1G5gdFcZDbDk?=
 =?us-ascii?Q?FRdAztWZAMPBquMqFVoMQUwXhEEIBxCy/SG2WhR7s3dEgBKdbbGCEsln49py?=
 =?us-ascii?Q?8YUKoQXrUWBtvt1zz+qObVNJqUKtKb3ybUtefJYnZVEwWQ8pNUFxXxdPvA2w?=
 =?us-ascii?Q?QSPrZh+H8m0ZUtqHgzVh+LMMrPpQ/tSjWT/bu+VzeCVD7cG10eukaWFaC+ZP?=
 =?us-ascii?Q?RI/sg1iFYnku4mJW6fDOYeAFU5JDzU0fz0TAEMg3GSwZ9AKw0MdO4hDZC9BS?=
 =?us-ascii?Q?t7dcFBj1i5Lcf/BxcLcM8Oj+kuTlx4S7jC78w9M+HW+VuP2MGyRgYbz12LFW?=
 =?us-ascii?Q?zDj1Q9nvLceS9xPgapd9kTchpTjGVbFfB7REZ4k+qOzJaEUm6BjKv7pUn6vE?=
 =?us-ascii?Q?BLvXM4lnSOc5CQ8Od7DKO3Lo+lEdm42NfHcxYU7sz6rL3Cm4s/fCgAqVBk/a?=
 =?us-ascii?Q?v9NCG0+g4FKTC/aqWyeswvsC5bdFdB472qBtDYD6qZZXySmwcDcrbi71lba3?=
 =?us-ascii?Q?UcbHwm5vh4rnHxZVB0D0f/Drd8eKOe4ZWG/deqCPnGCFZtVgEUEXG0DQw+bs?=
 =?us-ascii?Q?lSMY3cgFAYV6Eh4qEnumKLVhrOMYiWNpoDCuax3y04fb9cletopdvlrW1t0+?=
 =?us-ascii?Q?Kp8ilHzopeMUDDSCRiyWgNscThaD22SMEhef2zD1I+a0jXdK+aaczGR1YGCG?=
 =?us-ascii?Q?v3ypVIIEf1qoZ66K5Ea3F5pi+fRPU0NopNmcIta1RfnLBH4NPYL3ULEuZ8GF?=
 =?us-ascii?Q?bE8mslmKGNS4UoqHAFc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd49771-8aad-4dc1-e4f3-08db2946c61f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 13:26:55.1329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jwJ+spTLnTEqY7fzUpVF27NP+PZ6LfRlnZBpNPy8pg1Z3CrcO6587DdSv9PsOqe1XspYRx/nlKK1P0HuMSMuwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Public]



> -----Original Message-----
> From: Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Friday, March 10, 2023 11:00
> To: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Tsao, Anson
> <anson.tsao@amd.com>; Felix Fietkau <nbd@nbd.name>; Lorenzo Bianconi
> <lorenzo@kernel.org>; Ryder Lee <ryder.lee@mediatek.com>; Shayne Chen
> <shayne.chen@mediatek.com>; Sean Wang <sean.wang@mediatek.com>;
> Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>; Eri=
c
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> mediatek@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] wifi: mt76: mt7921e: Set memory space enable in
> PCI_COMMAND if unset
>=20
> When the BIOS has been configured for Fast Boot, systems with mt7921e
> have non-functional wifi.  Turning on Fast boot caused both bus master
> enable and memory space enable bits in PCI_COMMAND not to get
> configured.
>=20
> The mt7921 driver already sets bus master enable, but explicitly check
> and set memory access enable as well to fix this problem.
>=20
> Tested-by: Anson Tsao <anson.tsao@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Hi Felix, Lorenzo, Ryder,

Any comments please?

Thanks,

>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> index 8a53d8f286db..24a2aafa6e2a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> @@ -256,6 +256,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>  	struct mt7921_dev *dev;
>  	struct mt76_dev *mdev;
>  	int ret;
> +	u16 cmd;
>=20
>  	ret =3D pcim_enable_device(pdev);
>  	if (ret)
> @@ -265,6 +266,11 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>  	if (ret)
>  		return ret;
>=20
> +	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> +	if (!(cmd & PCI_COMMAND_MEMORY)) {
> +		cmd |=3D PCI_COMMAND_MEMORY;
> +		pci_write_config_word(pdev, PCI_COMMAND, cmd);
> +	}
>  	pci_set_master(pdev);
>=20
>  	ret =3D pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
> --
> 2.34.1
