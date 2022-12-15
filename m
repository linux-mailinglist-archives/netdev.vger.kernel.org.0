Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAAB64D94C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 11:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiLOKNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 05:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLOKNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 05:13:12 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F272315B;
        Thu, 15 Dec 2022 02:13:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDYdf6pHBC7XFS4KyMifhSR/E08rEavyomq4r+D/OqfW0l2RFUOozo2NUbffy/GySbD1SNPvLtmrJSpJffP4u/F7Lpy9OE8T7tYZjpIE12ozJ+HRUfv007qhZmqLVOIDXnADBGwgrKFzffsH3GUNe3IutTSVHtEXVfuotc2V/ENnk5GLnoUQ7xC7Z46pYpyo4PiCzMU+PSMuu3eflqTBjbkiSbKK3mA9tB77RHpCEpZsritQHXDbr+NIzAT3uiG9G2tJxicgQbb1YX+VbJMHthQ48tenYS6o7XtzbggLle5DwdHI67HRIYdy70HpQDEfjTp3vFXasslqTZ8YzeEDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WenFXQl/3OnND6LKgFGkCS489sNIo2H0WP3cO5C7hw8=;
 b=RpnAVhWFEvoYwjZLmR+WEL+HYdEsBIvx43YS7f5D3LPOuP0Ws2QInV7S9OzwCkpWk3if+sJaucW5j946xWp+5prHYPYvyIqLrdSh4OZcFyboXG+4PSRt7OyNUh4O8AoK4925FXvjsGvt/XKIoED7cif38C28KgbZnYlrXLCyRx2Uf8GDtfnAovhZOMBoHhFkMUvN5tZgfSt3I/tBvqXsivgJBmmz3/dgE0HThOctSR4gTVWIPoIBDcGIPhcb1xgrQqJM63Jr43zzPZqtkPlT7cVLbc2+jAQsKmWXtSCQRXky+vSP6g7eR8bNxRpcHfhlzub2mclGRCFx4xy94I/c+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WenFXQl/3OnND6LKgFGkCS489sNIo2H0WP3cO5C7hw8=;
 b=j3rCsxQq/ZFKUc5d1/lTBvoE+qZlagu6PyQXcrv/G2aPPwNYJsnGbPKcTyMtf7fTeJ9Y8LvphG0zq8fFOODU2JrZkDpjqFxxOxJ3TI33dcdBYUGau04GyiBV4F6bfE5X4Mi9aEruJsAbUe4VYDwWvip6DqZQ7AAByVg5VpPVyF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB8658.eurprd04.prod.outlook.com (2603:10a6:20b:429::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 10:13:07 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%7]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 10:13:07 +0000
Date:   Thu, 15 Dec 2022 12:13:03 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     iommu@lists.linux.dev, Will Deacon <will@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] iommu/arm-smmu: don't unregister on shutdown
Message-ID: <20221215101303.6rezz5mqjwupdaqe@skbuf>
References: <20221208165350.3895136-1-vladimir.oltean@nxp.com>
 <d3517811-232c-592d-f973-2870bb5ec3ac@arm.com>
 <20221214173418.iwovyxlbogkspjxy@skbuf>
 <a3a034b5-9493-e345-bcb4-8c5eef7f9a65@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3a034b5-9493-e345-bcb4-8c5eef7f9a65@arm.com>
X-ClientProxiedBy: FR2P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::16) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e01acc2-6959-4484-ca06-08dade84f5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afqt31a6HAfgrdmKqooZi00crskk8NDDV6TkcukVu/h876WTFBxatDj9LDxADomlTRwK/q24pi3FdpDfws03wo1OhK5pQS7ppZrdlIBJaWvP2qhWM8Tzno3th164jvTOX7Boca4tVNcpk30dHdH/o5rFqqSXPWAidyYmWj+9eKGo0H9P62D/K5/DAlfQkVMZ3zzev7IyBZggVjESyq9m1n7OS1ZajQsZHL8Lnv4FBW0+gv6eJ4QWpwNnjqncCiUnr/22QAnmQP7sgV0GB+Yriq257XxpxfKiPJnvEvPyRxqNAXqyw1tmf9Mj/+rxvsVrfj7GHaa3xae76kFjzCdX6guGHSUKRLnuxOzUhM7fDyu6lruCn7u/WJQ4vjalIEQZK8Dajuud8ek39qezunKSHMIl/EoFW/9tjs4s9lKBSzPJU+f16KSRdTyZ/qyrZtbxJVv5GGM0uvmkX1hnNUUgtriOzsM8Dokbl/fZoXztnQrMOeQNljIcwQJad2YxpsfqdrmCbd6JeQefD8wuGrxj1R3ztI2TIX4uNS78MBtdxKGvuGV60UrveF3vZ/3O9Sr4Gn/PdCc8Pn9dPOBsCHtToXM4RN2X2l3Lsw+OEn49nzEdeZGt9VpsEM2XAsXmMJdVMzRNjSgxsOLuJcn6+L9SZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199015)(6666004)(6486002)(478600001)(6506007)(2906002)(33716001)(9686003)(6512007)(186003)(26005)(86362001)(6916009)(38100700002)(83380400001)(44832011)(316002)(66476007)(66556008)(1076003)(54906003)(66946007)(8676002)(4326008)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mkblOT7+rzBf5BkuXf1Mr1uvF9rukZu70+4IYNYt3HLWRUszbumu5FoGZ4ww?=
 =?us-ascii?Q?ovhbdr/dCRqeFPRHaNBmkuT7YsVxnWUAJvRS2j1aSqvPWSaKLK7KK4kN8oLq?=
 =?us-ascii?Q?WJXrXrsePQYp6z4qHCTm9KX0Lco+SPoGXzUKl/7V0LPTlHjV92csQZEchzKr?=
 =?us-ascii?Q?1aH9K6gJ62TwNKUXSF2mHnNfEtQSGGdz8gXxHd1HUvgoCpLRP6H6b9jvvcvc?=
 =?us-ascii?Q?rhgsE8t7H74q2PYsNJdW0hhn1ZlB34gDhtTO3PJSOKRlW4atsqzPAKjx8kHd?=
 =?us-ascii?Q?Grs1ZcvIQ4+sRUfEwCKXZeMfmWy9F0r02clSRaguu3ZlO3ao/X9QZ2Ml1zH+?=
 =?us-ascii?Q?+jNQFubkTzemO6/Kmd5CmUJUspSLaP8KnayiHzYbc1Ma/Y53m9othfGNdJ9i?=
 =?us-ascii?Q?7t8qmO6kLISdMG99lT/s6L275FjOqIHV5wJSvCYekqrMyzbyZCzgIlO3d8QE?=
 =?us-ascii?Q?c/TOi83Fml+PMjlCyu5dSnY1uOzgsE+QcfnqZxzTU2ayyTTQiC92XlUvwZXH?=
 =?us-ascii?Q?LP5ILXGQ9p8wt1CXJYGlVMogDYVzK84NXzZWQLMzNpPLUgDlpG6IC/Jm5nja?=
 =?us-ascii?Q?EXNvy9iA9mbASRG9Byn7+COa53xorGVmFWa0nlWsscN0EXS/C0gluKZAeGW1?=
 =?us-ascii?Q?Sb4w8soFI6YY9aJWxEFTaKpaWIYcvQbo73jyvJ/WUy5AMJJlk7Cx9qCsv6RZ?=
 =?us-ascii?Q?Q5cvjF25NZT9xFVL6eXAqLoivBAjFOH1CMPArUmHvnQS35m9lYVrQG4bETNd?=
 =?us-ascii?Q?SiMt2IE36HWISlA+RknzW4kQ7yNRrvzGyOBYl3qzFU6kfY2gzCBha/CkABbv?=
 =?us-ascii?Q?F5cmPvdoCWATQc1F8LOhY+HkJQ/nsA0Dp24tSHQqiR7ihbNIDpj1CDPFBo4b?=
 =?us-ascii?Q?NYgH/KEpfUb8qdobXtPl1S6nbuUnbTjfZNYB+m1FZ/4WcgcYGL1sO1nEPGOZ?=
 =?us-ascii?Q?Bp2SOGZSSBYoUnasbaydPA6TK+fK3LW0/6QvOiioEs9BCgEK9ogqbCqAZn++?=
 =?us-ascii?Q?fnihRKpEnm7uDDRTQv94SKHpJLExsj74eoR2Jk5JfweHbNOAEXskUdmUX6PZ?=
 =?us-ascii?Q?6QKl2JpyobgLqdsgdA8GUOK7NFwmWsTvWtzo2IPkIyCulR0mDjYfqUOfODxv?=
 =?us-ascii?Q?BDtMaty6jQOUWZQZYMLcCFJpuubZ9LUhBp0VpNu/gcm+xPDlw3ERA6rDAubc?=
 =?us-ascii?Q?v9+llMiqsgZ8sYxWzdcpp40ITEz3o4eymFYrRa1YTuIi/zDlb+GwuB8X5hQ+?=
 =?us-ascii?Q?COMR+CZjZTx5jgzPebcq9ZYN7n4wC7segocTUrUZF0Ni13B51BPPoA2Horts?=
 =?us-ascii?Q?Szqont+HgHjBMWYkuWo/BMj/FlXsDMhw6tnCyMcShtDgW1BAjK9J7IN07ROf?=
 =?us-ascii?Q?XNxR8paueUQG/djfRotbYYZvbRes3LBNarsLBjbCM3vcfvpSDJ8TLbUaNik8?=
 =?us-ascii?Q?lUWfjQFWV88tBvQL/Vc1oKGj3PqfEnK5PnUmH67ltjdmNkpNBGHmunja9OLY?=
 =?us-ascii?Q?+lvpBeEXaW0kSthfH/hR7TfhgDnX1bVNsNBTlckvA7kiwBeSbG30vaZmPxc/?=
 =?us-ascii?Q?7G3bGJuOg1bpsJRJFpnMsM0GQnqr6zeInl+SvE3BnLm4Gac3scK1hDFjeUrD?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e01acc2-6959-4484-ca06-08dade84f5d3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 10:13:07.4099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NE2zK3pDiNrXAHpFqzbMfWfvO6ybRkpiEDpXq6x7TEWEn8gjrTtKa+XZ+Sq4HHBDPzlEo4K0TO0XnG49QhfwTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 09:25:45PM +0000, Robin Murphy wrote:
> > > The change itself looks sensible. The point of this shutdown hook is simply
> > > not to leave active translations in place that might confuse future software
> > > after reboot/kexec; any housekeeping in the current kernel state is a waste
> > > of time anyway. Fancy doing the same for SMMUv3 as well?
> > 
> > I can try, but I won't have hardware to test.
> > 
> > Basically the only thing truly relevant for shutdown from arm_smmu_device_remove()
> > is arm_smmu_device_disable(), would you agree to a patch which changes
> > things as below?
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 6d5df91c5c46..d4d8bfee9feb 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3854,7 +3854,9 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
> >   static void arm_smmu_device_shutdown(struct platform_device *pdev)
> >   {
> > -	arm_smmu_device_remove(pdev);
> > +	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
> > +
> > +	arm_smmu_device_disable(smmu);
> >   }
> >   static const struct of_device_id arm_smmu_of_match[] = {
> 
> 
> Looks fine to me! I'll let Will decide if he'd still prefer to do the full
> remove-calls-shutdown reversal here as well for complete consistency, but I
> reckon the minimal diff is no bad thing :)

The reason why I did it this way is that if remove() still called
shutdown(), it would have looked like this here:

static void arm_smmu_device_shutdown(struct platform_device *pdev)
{
	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);

	arm_smmu_device_disable(smmu);
}

static int arm_smmu_device_remove(struct platform_device *pdev)
{
	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);

	iommu_device_unregister(&smmu->iommu);
	iommu_device_sysfs_remove(&smmu->iommu);
	arm_smmu_device_shutdown(pdev);
	iopf_queue_free(smmu->evtq.iopf);

	return 0;
}

Not really that beneficial. I also didn't want to reorder any
operations, they seem to be done in reverse order of what is being done
in arm_smmu_device_probe().
