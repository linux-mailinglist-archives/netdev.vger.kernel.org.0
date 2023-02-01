Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB06870D7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjBAWJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBAWJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:09:58 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2137.outbound.protection.outlook.com [40.107.101.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864DC73755;
        Wed,  1 Feb 2023 14:09:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQ8JNi/usMaBb6u8nedIsk0yyBaKmQqhuBLlOi6xefrr3SvepqQenfnWedyed+D3qc2FCTyl+riEcHvZdR1KJz3imK7+K1sAKrD4scWDHD60CtQWT0Hdbbd4Z83a1BOX3tFuIhLYAFqiNghGPIkIp/qvcK2UfFowC4vE7Dq698do1oXIWVBuNBQX0f3ZbHywHwuv/+4xMNBsS4QlYqN8rEnRB1pyB/+oBJpHY0cON9LI2C9nZKd/aUwm2ZqvdWhaoFbRS/GAZhd8BUPwiMsCXaxNEiYjvYFIJ+EH+o00x8RseNtjT9n31qY65q3rtcECI4/WvbLFO2xk3NIIKLsyWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgnMND922YmuFGXCERhbkHzBv4IyGQw2WB961l6KTJo=;
 b=U61HcchJkKuHrTrvDRZSnYMz5Nzb1gYsY9hWsKq+JbJ77NFSUEM84l74wLN6HXUCIEMaN5rdpLZV/LVU5uRr8uzTRmVQtDCzjtJsEoTssjwWp3J/ckyltgEIdXNf4smUQwZXCuyxV5NYHWj4w0EUVIOn06+MKqSZeAIcvzvGD49coh4cqQFb0hXjB3kchWBjBLliNJ/S4eSle0Z0Z8pThCVmNSjxHZPXKogMC3xDd7xHRMvHDyUQ2oO+YWayQnTHr1VDLYCkJqAzOK8OgaLkovZl0wQtxazYRvfVIpAuo6iAFK557k/6lk4Cva1rNQ5dVcabQv9MsHu9IoL31mUsHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgnMND922YmuFGXCERhbkHzBv4IyGQw2WB961l6KTJo=;
 b=O1ldYQphQL04kNj5QCSSBq/duay2q8b96SHs4tSDPCgS8oAUgcISl68QfXcF/SCO5KjnS5qZzOln0buZ4EbpCTphB2nVvKF4JHgQ7QyuKhYiFOvWFRMPs8Vpi9pgDjvplchSHPAClDfJwtXjLxAJg5y7XF0oD5acMbIf2JwJqgc=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SA3PR21MB3933.namprd21.prod.outlook.com (2603:10b6:806:2f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.4; Wed, 1 Feb
 2023 22:09:55 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%8]) with mapi id 15.20.6086.005; Wed, 1 Feb 2023
 22:09:55 +0000
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
Subject: RE: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Thread-Topic: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Thread-Index: AQHZNobe+eghusa2AEOkAYEeH8Haoq66pqDg
Date:   Wed, 1 Feb 2023 22:09:55 +0000
Message-ID: <BYAPR21MB1688682410E06C122FBA3424D7D19@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=445d93e0-0ef4-4a29-9f85-5c004b847f76;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-01T22:09:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SA3PR21MB3933:EE_
x-ms-office365-filtering-correlation-id: 234acc86-88cd-43ed-32f5-08db04a10ce5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcvD2+NdnqAwXmITNU1ZGHXMgEt+5jelwDzebz+77gLsfz+H7AQkQZ2sbfRDmDkfFJ4jjpAmaXLS9Cw/VEuNIVVT/JGXPYLouVztIGPuzR+QIJ3DSFyvM7zgOavi96TQ04CdFbioL0tLvhXYlNiRQ0BiaYuvkyrOY8kwvf3mE+i/SwUn/c94dQnwx/9IRtuYtqtE3hXQXr3K2MxMsVLL8kpest6MYL2K1dGTBe0zb/lQZq/wnvd2hC2q3CadbS0TTn3FrWwWCH5lQhk4ekmPhaxiEwrje6Wp3PIBoUDEEU+bInSrn0AnbqI0jhZBa01OkHc8jj9jKHk8rKlCvuLvMgTTDjtJiEM6M6ieJoJ8EsfRKM22u6cGGVdMAmAJOLQgUe0G+Ygmm1F8LslFHQxFBug6t1bJQKRe36bpERnSt2CNrh0nLwkit79xJHK38jkMcAyF4lg2Usy3eeBBLfTO0GMJT2uK84bLTekg7JOaKf+eQYZimfyqlBgF137UBub5VfjbBOtgpen9RyfbvfdV61w0D8zKYL8Oql3eKR4/lD3hs7BuUPOdcMF7fhJsuBsCgTjb+OkvEGIMRQGISgBadgJgXRJ8uKOnBwZ0UEtpmZWcC7ODE4n786vwWU6k7YyvTNukUaAQtLP8roYlk+lTL6xoyN6HzVl8OsWIg3amJgDe5PZynx7A5WMbZAo4ppdnJUHHWs1akUbl06jGrWzl8uasCTIi05Zc1Y4ZSlZyYfw9lg5oXRwMn8qDhEjVnGHd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199018)(8936002)(2906002)(38070700005)(83380400001)(8990500004)(5660300002)(10290500003)(76116006)(71200400001)(66446008)(52536014)(6506007)(66476007)(66946007)(66556008)(86362001)(4326008)(8676002)(26005)(478600001)(9686003)(7696005)(64756008)(82960400001)(55016003)(186003)(122000001)(33656002)(54906003)(38100700002)(316002)(41300700001)(110136005)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6sgHjV0BG05ugz2AlgtdWBBaxdLdMULZ4ykdubTV8EL/lcosdfnJeM8rseVQ?=
 =?us-ascii?Q?9YMIQI8+O/Ovr9/cRrd+m8O52SEBfe7nALngb4cCNVE/8w8XYerB6oHzLrUq?=
 =?us-ascii?Q?xhQ+aH/RSEpcA8Og6kZMTWgpcFumTQrSJ/P/+qqEVYTxYp/M8rrG54fAauva?=
 =?us-ascii?Q?JrFcE5xKUcMu9zSRHP6d0dAxxidS3ejHofDybOtvwDGtb/SJv9nD6rkW/GyI?=
 =?us-ascii?Q?Skuyp7feGxMqFbOQ5OD0hfWuMna+bTgLkOKwOECsrwA2mO1Eqh7R2VDmjh9F?=
 =?us-ascii?Q?gEJd82Nswed0yM4aGmsWQKJD/O7svCF81bmuC2bDwzPJPAiTjoFo+Ax4PwUQ?=
 =?us-ascii?Q?j3rD9PxiqDk1lWd4dKQeir0XMMRQEuPY7swBovbmLLk88XFKBw0wNnwNkqHv?=
 =?us-ascii?Q?ERm0hR1jG3sRXd6E89iaHGP7FzHzde/+MNjqPajoy7rytzpgXuvJA8v7hEVt?=
 =?us-ascii?Q?6VrgPPYtjhku2dBEsCB8Wh8L60av+iJS6mLH4cqWKjn9EZ62rp6Yyqs5UdIf?=
 =?us-ascii?Q?olRO1b91PluVhYZPJHJfaL+VngU0HVmJPMWnUfyb/47LZpPIwk4NWHko/tc+?=
 =?us-ascii?Q?qXZOW2jVOKxjFyKefWrwTa64EoDFNdwx6/cHmFTyPe92bwnmqKRB1IrrRPEg?=
 =?us-ascii?Q?+96X5/GLfICnpCgGdSYHmpV0XOwLMmod4Y6Z8yeCEr3EC06kltBh4O37citM?=
 =?us-ascii?Q?hu1mJiAwn9VFI1fTZHPYlo+i9vDHcZN6L6mIVsfA/7Ml4a3HR31yA1hTmOe5?=
 =?us-ascii?Q?+SZ61BFk8hQYTPOvCoDLj0wrsIy1e7lW7noSm5+0m/4aeVWaHGxhv5HFSZHh?=
 =?us-ascii?Q?ix1HVJbHOlANjPKJ4eurYeZSegMqqYVnC06koKIUKTA8/WMX10ijcfQeGZhS?=
 =?us-ascii?Q?10EJ7sikwZWtxwNLt0g90te79ftYzLDITsykrLCILfrpN8WfxUB9qrIG1BnJ?=
 =?us-ascii?Q?8mn9Ar6QnGeZrIveGtTO3j3GfUgw1KL8TZ/v91GhnokFSJMoPTzoC5vAiwNV?=
 =?us-ascii?Q?z3MF5YBZRmEYf3Eqa1WgpUrFVAEs+2xTxq+ShZKFjca7lz9y6W1CeII7H05C?=
 =?us-ascii?Q?hTmi+DQjjRNa8QXmH29CPZf+p032Gk1fcU2Jmg5Kr4zXfrSc7NZHqUqYSoes?=
 =?us-ascii?Q?+Zdk78ENb52CPcrDZQvwe1CS2ODu9zkwoCoySCnuSYzTMrbQxOK82LiZXCA5?=
 =?us-ascii?Q?CGfMqTGXf/xQftma1gX6BAJXhY/R+W8Y1c3Sf7SrYjZ5YM1IrRDgxFwRRR4P?=
 =?us-ascii?Q?ftji02A3qklMixECbiElIhPdvcoqJAl5fmGfXT7W/nPmCJ67buVqR73JR5Ve?=
 =?us-ascii?Q?1mVc/DYwkoyzFAEQHr9rCyQ80BAFSLSG0SnTYrfCrW7sOYd5IVHX2UHikek8?=
 =?us-ascii?Q?yP4ZerJWIAAEQw8UM4s67GILck3ynaUC4uhbE0JQ1bSZ5weWm1kuA+JizonR?=
 =?us-ascii?Q?2a7hvoTxgn+gfOgbuJK6oyoy7nsWkvbHxFaWKIzCAc+sic6fyxAD2jJ9R1xP?=
 =?us-ascii?Q?r23v4tqxVUovDOFdpYxnEBfrGDR+KJWVWT9/0I07Oi1JuRME0y+Rh71k37Ia?=
 =?us-ascii?Q?0Np8MrTB918iRdbQ3vl64t5/jSbrR3FybiNsaiZfp0irKyAXc55vU3wmPA+M?=
 =?us-ascii?Q?eA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234acc86-88cd-43ed-32f5-08db04a10ce5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 22:09:55.4868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1A5H0GoK+IQIu3zT+ce+YQ+pyDOBWGWsiQ/rS+m5IFKaQyF5Z4Qm9er1mB8ZY8ncbQw1l8GnGPOjFvwthuQba1ZE7L4B8u01BJM9fkTCiKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB3933
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang  Sen=
t: Wednesday, February 1, 2023 1:47 PM
>=20
> After calling irq_set_affinity_and_hint(), the cpumask pointer is
> saved in desc->affinity_hint, and will be used later when reading
> /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> persistent. Otherwise, we are accessing freed memory when reading
> the affinity_hint file.
>=20
> Also, need to clear affinity_hint before free_irq(), otherwise there
> is a one-time warning and stack trace during module unloading:
>=20
>  [  243.948687] WARNING: CPU: 10 PID: 1589 at kernel/irq/manage.c:1913
> free_irq+0x318/0x360
>  ...
>  [  243.948753] Call Trace:
>  [  243.948754]  <TASK>
>  [  243.948760]  mana_gd_remove_irqs+0x78/0xc0 [mana]
>  [  243.948767]  mana_gd_remove+0x3e/0x80 [mana]
>  [  243.948773]  pci_device_remove+0x3d/0xb0
>  [  243.948778]  device_remove+0x46/0x70
>  [  243.948782]  device_release_driver_internal+0x1fe/0x280
>  [  243.948785]  driver_detach+0x4e/0xa0
>  [  243.948787]  bus_remove_driver+0x70/0xf0
>  [  243.948789]  driver_unregister+0x35/0x60
>  [  243.948792]  pci_unregister_driver+0x44/0x90
>  [  243.948794]  mana_driver_exit+0x14/0x3fe [mana]
>  [  243.948800]  __do_sys_delete_module.constprop.0+0x185/0x2f0
>=20
> To fix the bug, use the persistent mask, cpumask_of(cpu#), and set
> affinity_hint to NULL before freeing the IRQ, as required by free_irq().
>=20
> Cc: stable@vger.kernel.org
> Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA =
nodes")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 35 ++++++-------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index b144f2237748..a55d42332e20 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1218,8 +1218,6 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	struct gdma_context *gc =3D pci_get_drvdata(pdev);
>  	struct gdma_irq_context *gic;
>  	unsigned int max_irqs;
> -	u16 *cpus;
> -	cpumask_var_t req_mask;
>  	int nvec, irq;
>  	int err, i =3D 0, j;
>=20
> @@ -1240,21 +1238,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev=
)
>  		goto free_irq_vector;
>  	}
>=20
> -	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL)) {
> -		err =3D -ENOMEM;
> -		goto free_irq;
> -	}
> -
> -	cpus =3D kcalloc(nvec, sizeof(*cpus), GFP_KERNEL);
> -	if (!cpus) {
> -		err =3D -ENOMEM;
> -		goto free_mask;
> -	}
> -	for (i =3D 0; i < nvec; i++)
> -		cpus[i] =3D cpumask_local_spread(i, gc->numa_node);
> -
>  	for (i =3D 0; i < nvec; i++) {
> -		cpumask_set_cpu(cpus[i], req_mask);
>  		gic =3D &gc->irq_contexts[i];
>  		gic->handler =3D NULL;
>  		gic->arg =3D NULL;
> @@ -1269,17 +1253,16 @@ static int mana_gd_setup_irqs(struct pci_dev *pde=
v)
>  		irq =3D pci_irq_vector(pdev, i);
>  		if (irq < 0) {
>  			err =3D irq;
> -			goto free_mask;
> +			goto free_irq;
>  		}
>=20
>  		err =3D request_irq(irq, mana_gd_intr, 0, gic->name, gic);
>  		if (err)
> -			goto free_mask;
> -		irq_set_affinity_and_hint(irq, req_mask);
> -		cpumask_clear(req_mask);
> +			goto free_irq;
> +
> +		irq_set_affinity_and_hint(irq, cpumask_of(cpumask_local_spread
> +					  (i, gc->numa_node)));
>  	}
> -	free_cpumask_var(req_mask);
> -	kfree(cpus);
>=20
>  	err =3D mana_gd_alloc_res_map(nvec, &gc->msix_resource);
>  	if (err)
> @@ -1290,13 +1273,12 @@ static int mana_gd_setup_irqs(struct pci_dev *pde=
v)
>=20
>  	return 0;
>=20
> -free_mask:
> -	free_cpumask_var(req_mask);
> -	kfree(cpus);
>  free_irq:
>  	for (j =3D i - 1; j >=3D 0; j--) {
>  		irq =3D pci_irq_vector(pdev, j);
>  		gic =3D &gc->irq_contexts[j];
> +
> +		irq_update_affinity_hint(irq, NULL);
>  		free_irq(irq, gic);
>  	}
>=20
> @@ -1324,6 +1306,9 @@ static void mana_gd_remove_irqs(struct pci_dev *pde=
v)
>  			continue;
>=20
>  		gic =3D &gc->irq_contexts[i];
> +
> +		/* Need to clear the hint before free_irq */
> +		irq_update_affinity_hint(irq, NULL);
>  		free_irq(irq, gic);
>  	}
>=20
> --
> 2.25.1

Reviewed-by: Michael Kelley

