Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5957E67FF84
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 15:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbjA2O07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 09:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjA2O05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 09:26:57 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016101E2A9;
        Sun, 29 Jan 2023 06:26:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inTsSLZxQzGqHHgUqZzqJ11CElb0iXK4U9iOkXfuoWxmXTXXD8QGNpWGD+tttTrZBrT+2s/HNj15ChVAVtHh3MxsYGcDRL1n1fhIYAZytE9u9huw7KrMklBEKoMoQdT5wfZlAOrsKDWyTq4NuOP1ZpEapF4GuMwauhYDrijsvcc1luTqhtdP5fPaL/tTk/Klfj7+0pcdQ/F1sOcfyPCfp2zAutqZeyIW/bD2R7gydzuNL4SEzi/vH5B3slXbZbNfrhQeb++98m3H5v7IG5GegQBAk6Nr8Cjuc50kl6H91Bv6KLj0ZhQ/hDIvR4TDeoABRNzbh0YwljD/nsN1h5HBjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+uWDLaYdiwRaW8NI0ebj7n9ABST/ufk/riMLgYfW7A=;
 b=FZRqK88kfspFwcvBiXXUWmT8lQ4PAm/+20fk+CRqDtQhF3WHSb0bbV+XEiRj5WlBHmsRMvsTmB7QwtgfO9gHLGGQd7+KJRv/SeNBREmiI6CGMqx0p/5cc2odcfk2B8RFTudEiaML3JAVsMTb9G/5TuEpk5wjsKCkMcmH0iAVo7C4voU3zaPvuA+5t5oqr6Q2hvWNccJzrdzUFqSop+lIe7MdjU8kwaNW4SVwl23bfBuxwDuyxM3sIGBjmBBp1dJ3fMFyrH+p7Poh5BVS8Lt3cy4Fr2XzLGoQuJ7slqbE/onweQLDHyKPep3uGrPXdD9/ovU6RsrmZnAlAnvo9RHuAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+uWDLaYdiwRaW8NI0ebj7n9ABST/ufk/riMLgYfW7A=;
 b=ccZ/VAGzasNPDvfHEqYoSdfZL0O7wWgUxxW5opR+eGEkZeW/+8DJZCgIzNsr5k+8nLfs/rAPOY3b8GejzFi5Z4zHMcd8zwijPzihf6wYdp38Yl2HGLBj61wNw1/ui8nMJMC/N4k9gj9NIh5reMg6QfHWrsGFH9I1XEMCf9rxGhE=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3169.namprd21.prod.outlook.com (2603:10b6:208:379::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7; Sun, 29 Jan
 2023 14:26:43 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%6]) with mapi id 15.20.6064.019; Sun, 29 Jan 2023
 14:26:43 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity_hint
Thread-Topic: [PATCH net, 2/2] net: mana: Fix accessing freed irq
 affinity_hint
Thread-Index: AQHZMcn9FoVtCfDPTUGnJuIl1moS9a61cYLA
Date:   Sun, 29 Jan 2023 14:26:43 +0000
Message-ID: <BYAPR21MB1688D54F89D19932B3654E0ED7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ed50092a-4a52-4891-b37c-98888b68e03a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T14:04:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3169:EE_
x-ms-office365-filtering-correlation-id: 5ed5670f-47c2-4251-d1f9-08db0204d83c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PB4JpWL3nMTV7ZfQC9Ahc95TyFogWOImvAXOUZsX3b8wckDdLdPFrs8mXa0ns1rNwOVD5CzCQWXLNjqCoYn3GJVYgok+T/9KPa9EeeULUuT8d7WtD/BWxx8iws7+c3diFcPtyRitnyACVl/iA+OBev4PIyvaYYz2QgznuQnGB7pqr3FPwjnZXGsnUil5zE50fkCxjgpreVb3onFWkYwSjuxHpS8wL8VjEt+hsEgf+a81r1Nmoc/LvVlP/XLIjJutlZBw+TWfJxiCfb0xFESEhmKo8km+rOdNcDXjcihFxlCv/VPT0ya0EsZujCRNCu8+6PR8yItGbhhOrXsjlk1+U73O4MIgXjiabiAphygE0jv+ghkc9a6zfBEP61V7/53YOdJXS7Qt8ElwiGVK5D3nE/n8WJZcwG4bgWU7X7v1jrox25sCoWUP+s076VJbbBHJmAkJlgqA+t2HJ7WfALBkTNNtFxOk5753HAhrw2Il6UB2MNM1cpwv8haNxwZ6tu/cwOTXs0eFmwwO8XW0zrr6LvNqxmiBk4lrz8Da2g2+h/iGc00UbP+5vI12JJlrRPhUpfhJk7JwyjGYKjFYWFaouqVwKUfSwuZ+yerkVFv5r43tDjZjbPEpNe8KDITBZe89I+kRoKEIl9n7XNgc/TeizEjITYBTbAI+Pu1TSsgEmugd9/R602OSHi6zIVaIFs7v71+LQh7ghB2yS2FDuMVnyaLkPnd7eWZqCXAOxWHdINBcsSfD+8tBHTXp8KEUAzUt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199018)(7696005)(186003)(9686003)(26005)(478600001)(71200400001)(8990500004)(83380400001)(10290500003)(54906003)(41300700001)(8676002)(38100700002)(316002)(64756008)(122000001)(66446008)(6506007)(82960400001)(82950400001)(33656002)(110136005)(8936002)(66556008)(52536014)(38070700005)(86362001)(4326008)(5660300002)(66946007)(66476007)(76116006)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0cFBIOGblNscc3mt0xTP/hG7YgUeTeulEEnj5lUAxIiJSJpVP00OaiVbogce?=
 =?us-ascii?Q?dT3WB6XqH8H/PkySa2a6vz/HSp0bfsLnAwZfQMqNabvV9rkw8zG3Ljlmy/4r?=
 =?us-ascii?Q?n9IXCiteoYXIBJgDrQhRgto1XMfbl1V+JJDo3hooph+rLmiLx2TqOrJeTA01?=
 =?us-ascii?Q?EGr7LQFdJXj9v4sM1jEFcXzdDSaEjrsl4uwl2he3A2rLHMyak2EWeGgWRFp9?=
 =?us-ascii?Q?3kouDHigy8PTY8d30rjYyr8B9IPqlL7qptNoszKs/WoOJkAksIjuGERBLw07?=
 =?us-ascii?Q?6AgmEVjQOh39+73lIRofruk/WWXm8I1DT3FLftXJQqqILoakLCIrwVWSycYR?=
 =?us-ascii?Q?FO3GHrgvMMT5RF2lSejixT6keIki1jZbGwk+eUNhnZdImLsB+gIo91OkK1BL?=
 =?us-ascii?Q?whd6wMT3YFzEFbqFwUa/DPFwF1siXXfq++Frd5lkggJY/W/VTTZp+nwsa/oE?=
 =?us-ascii?Q?4uEmJUW5kbH0n03EBSThjYavwykBGDCY1Egdo5ltCMcEME6PA3YVuH/1mqPr?=
 =?us-ascii?Q?0v7kcIhXf5DyhV/VSkIGDisPHh3aNdPOEdl9Cgw/r+bhswyIrxDlvNQld07Y?=
 =?us-ascii?Q?toJJKGU9gMcTHu0eEIoTw9mU1xtl4Jxztj5QKirQ1f+qDPJlLnBBSwOop/am?=
 =?us-ascii?Q?U2aa0qC5tLVoqXJBG4bpqHNETE6CHixffZNP67/tWTnm8LS+YF5NdNXscQtR?=
 =?us-ascii?Q?3pd+7EIA6Adw5oW51sx+NVUgGAWfOyjyT+9gxDDlYg/xxUXr3XAUo1rsp8is?=
 =?us-ascii?Q?tdXPVcLq7G0InYDx1axAwLfgSUCgYHgowu/kG750qIFleVFEcNB28ubPr1Qj?=
 =?us-ascii?Q?pc/ghdPa2BQ3u1pI6ROF9Kr6/SJ5mS3b1N7OgDHDKiYV4PKq18AhxnUK2MPl?=
 =?us-ascii?Q?shU8fDb+6QJvoUh9IFXmcoUkZ/zdlRXFGOHjExfb9APY+/pMPWrCCNG+MDq8?=
 =?us-ascii?Q?LpAIgfrcqE0eAv19sJh4ITu6mj+isHMhQ2nlx41w402ftelu/V58KLCBK6Uc?=
 =?us-ascii?Q?KFU9Tofn8Oc8NgbidT4YChD5f70AxO8C41LQZvXpalrSOiuYWumjr+agKDHO?=
 =?us-ascii?Q?QmWMXzogIQiaRTfc5Z8KBZ/YINo8tfsYbZOB+p+yf5psTTV116NpXNMuVijH?=
 =?us-ascii?Q?7nYfB3rP2cuEkqdYA+CaI8Fy7/DDfb9egS6Hb4cnPxPItwNSlm5PD6Bzz7L+?=
 =?us-ascii?Q?9VG/Kmf4XoZhjWz7bD+Wt3m8IeU2/deQ/V/aZEs1wbRzSVkqmMFMA/Z+8ohS?=
 =?us-ascii?Q?vHjOTRplNb/hlzl8NGixDu6qmpVIS21XhkOZu1Flsu8GzBR4oeH+5n+uu+f8?=
 =?us-ascii?Q?ZkVHumaSPXex3XZTDnLgZC3Cp8sJrGIMXqZoXlZ4jRPDTOB7ny8GTiNx7gOJ?=
 =?us-ascii?Q?+fqoF1Aob5NNIPiYFQPkFj1PNkkaIlHRd8OAJasTV8qPnL4lU2LFQIyrPrgJ?=
 =?us-ascii?Q?QtJykijXSEH3lyqsnjCdf3eo5cO9pP4iN9qT0BSCG8cA1wtBrenqSdc1Yp/0?=
 =?us-ascii?Q?D6UH3aLTTFMdV4XaEDRMozYobn+daABOYWZ5qgcQBob2PuTrLun7BNivLn5J?=
 =?us-ascii?Q?TcAPUjJqRQdnAiPl2BNeeYMI+naGCGUsusg0x790CzeNfv0fpEKdl1r7Rl6X?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed5670f-47c2-4251-d1f9-08db0204d83c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 14:26:43.3733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFlFtuwKFi67/L0LdyLM4qLrDpQ1umX2Szc8RDp3xypyTqLkLiGuN0v/QdAx4XRChzUD2YE7ldh9eA/9tEQuSEgAr3zCGDgUP3/92IaW9Cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3169
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang Sent=
: Thursday, January 26, 2023 1:05 PM
>=20
> After calling irq_set_affinity_and_hint(), the cpumask pointer is
> saved in desc->affinity_hint, and will be used later when reading
> /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> allocated per irq, and available until freeing the irq. Otherwise,
> we are accessing freed memory when reading the affinity_hint file.
>=20
> To fix the bug, allocate the cpumask per irq, and free it just
> before freeing the irq.

Since the cpumask being passed to irq_set_affinity_and_hint()
always contains exactly one CPU, the code can be considerably
simplified by using the pre-calculated and persistent masks
available as cpumask_of(cpu).  All allocation of cpumasks in this
code goes away, and you can set the affinity_hint to NULL in the
cleanup and remove paths without having to free any masks.

Michael

>=20
> Cc: stable@vger.kernel.org
> Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA =
nodes")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 40 ++++++++++---------
>  include/net/mana/gdma.h                       |  1 +
>  2 files changed, 23 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 3bae9d4c1f08..37473ae3859c 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1219,7 +1219,6 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	struct gdma_irq_context *gic;
>  	unsigned int max_irqs;
>  	u16 *cpus;
> -	cpumask_var_t req_mask;
>  	int nvec, irq;
>  	int err, i =3D 0, j;
>=20
> @@ -1240,25 +1239,26 @@ static int mana_gd_setup_irqs(struct pci_dev *pde=
v)
>  		goto free_irq_vector;
>  	}
>=20
> -	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL)) {
> -		err =3D -ENOMEM;
> -		goto free_irq;
> -	}
> -
>  	cpus =3D kcalloc(nvec, sizeof(*cpus), GFP_KERNEL);
>  	if (!cpus) {
>  		err =3D -ENOMEM;
> -		goto free_mask;
> +		goto free_gic;
>  	}
>  	for (i =3D 0; i < nvec; i++)
>  		cpus[i] =3D cpumask_local_spread(i, gc->numa_node);
>=20
>  	for (i =3D 0; i < nvec; i++) {
> -		cpumask_set_cpu(cpus[i], req_mask);
>  		gic =3D &gc->irq_contexts[i];
>  		gic->handler =3D NULL;
>  		gic->arg =3D NULL;
>=20
> +		if (!zalloc_cpumask_var(&gic->cpu_hint, GFP_KERNEL)) {
> +			err =3D -ENOMEM;
> +			goto free_irq;
> +		}
> +
> +		cpumask_set_cpu(cpus[i], gic->cpu_hint);
> +
>  		if (!i)
>  			snprintf(gic->name, MANA_IRQ_NAME_SZ,
> "mana_hwc@pci:%s",
>  				 pci_name(pdev));
> @@ -1269,17 +1269,18 @@ static int mana_gd_setup_irqs(struct pci_dev *pde=
v)
>  		irq =3D pci_irq_vector(pdev, i);
>  		if (irq < 0) {
>  			err =3D irq;
> -			goto free_mask;
> +			free_cpumask_var(gic->cpu_hint);
> +			goto free_irq;
>  		}
>=20
>  		err =3D request_irq(irq, mana_gd_intr, 0, gic->name, gic);
> -		if (err)
> -			goto free_mask;
> -		irq_set_affinity_and_hint(irq, req_mask);
> -		cpumask_clear(req_mask);
> +		if (err) {
> +			free_cpumask_var(gic->cpu_hint);
> +			goto free_irq;
> +		}
> +
> +		irq_set_affinity_and_hint(irq, gic->cpu_hint);
>  	}
> -	free_cpumask_var(req_mask);
> -	kfree(cpus);
>=20
>  	err =3D mana_gd_alloc_res_map(nvec, &gc->msix_resource);
>  	if (err)
> @@ -1288,20 +1289,22 @@ static int mana_gd_setup_irqs(struct pci_dev *pde=
v)
>  	gc->max_num_msix =3D nvec;
>  	gc->num_msix_usable =3D nvec;
>=20
> +	kfree(cpus);
>  	return 0;
>=20
> -free_mask:
> -	free_cpumask_var(req_mask);
> -	kfree(cpus);
>  free_irq:
>  	for (j =3D i - 1; j >=3D 0; j--) {
>  		irq =3D pci_irq_vector(pdev, j);
>  		gic =3D &gc->irq_contexts[j];
>=20
>  		irq_update_affinity_hint(irq, NULL);
> +		free_cpumask_var(gic->cpu_hint);
>  		free_irq(irq, gic);
>  	}
>=20
> +	kfree(cpus);
> +
> +free_gic:
>  	kfree(gc->irq_contexts);
>  	gc->irq_contexts =3D NULL;
>  free_irq_vector:
> @@ -1329,6 +1332,7 @@ static void mana_gd_remove_irqs(struct pci_dev *pde=
v)
>=20
>  		/* Need to clear the hint before free_irq */
>  		irq_update_affinity_hint(irq, NULL);
> +		free_cpumask_var(gic->cpu_hint);
>  		free_irq(irq, gic);
>  	}
>=20
> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 56189e4252da..4dcafecbd89e 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -342,6 +342,7 @@ struct gdma_irq_context {
>  	void (*handler)(void *arg);
>  	void *arg;
>  	char name[MANA_IRQ_NAME_SZ];
> +	cpumask_var_t cpu_hint;
>  };
>=20
>  struct gdma_context {
> --
> 2.25.1

