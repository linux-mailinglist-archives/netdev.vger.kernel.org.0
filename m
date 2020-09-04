Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6225E3DC
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgIDWml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:42:41 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:1977 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgIDWmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 18:42:35 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f52c2c70000>; Sat, 05 Sep 2020 06:42:15 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Fri, 04 Sep 2020 15:42:15 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Fri, 04 Sep 2020 15:42:15 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Sep
 2020 22:42:10 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Sep 2020 22:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUGBtfuj3YZ9DyvpbTSbRgSzywcazdd/jfSEjnzo78hnoR/OVuKUfk6snbrI2R2SDANvHE8oVNWq6P2wJdbE0WPJxs3KZqeeREu42WPuqGxdUvNwqz8lbBeA+UmO2NTgwDRdYCgM/hspI4XXft8YQMqBAkbIoDS/yp0cqk4ABWOTDUqpQz84jEngkRh/4CkXUWjM7Fb59Hm9yhGXNBC/2eIdrqk70/ndZCCB22AROT8Kwpjdm3MkXgd8Bo9L2bpVRLLqwsWizozhGpnlBiopvqGR+05HnFSd5XQyGiJScUqUfnQbZhQUr2I69SWCwTYh9BfhmzZo0ShFQ5JJpq7pJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78YmlDAOAM5hY3E0l2V+NhEdcQKv9sGUiu6TNcL9+zI=;
 b=bed2qLsjDAajN9ERKPmNtIV+VOtLNEyC4cKa3oP41bW7ZnvD+eiDOWHpcLC7H0wfVgWvaKZFyqjcFVjYyj8z4KXWZb9L04JZ1WTB6VHkD+gOwjRA7CMWmihe2q46Nc/F0+ydhdNu5ZLJyW+om+W1FWVGgdqv+ACdH2/6WT5UkBCdWF88NjKEH4kdd1tbozOd7lyLEX8l93MSyoV0/V534siupjNTIb5Bq0TlOFsh1N4j537MeQTrDUQ5G45YG9SDjn6Zyyl6EZVUtlYb6wQR9rRpNkDAaRewD7fyzXxXh+xow30xivozLjBNQ96C7uHwPJseatudvQQjjX28M3HDVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB2856.namprd12.prod.outlook.com (2603:10b6:a03:136::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Fri, 4 Sep
 2020 22:42:07 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::445b:111e:a091:66f9]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::445b:111e:a091:66f9%6]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 22:42:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        <GR-everest-linux-l2@marvell.com>,
        "Jakub Kicinski" <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 16/17] RDMA/qedr: Remove fbo and zbva from the MR
Date:   Fri, 4 Sep 2020 19:41:57 -0300
Message-ID: <16-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
In-Reply-To: <0-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:207:3c::38) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0025.namprd02.prod.outlook.com (2603:10b6:207:3c::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 22:42:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kEKP9-001vCy-Ae; Fri, 04 Sep 2020 19:41:59 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28088da4-d1be-43be-59b6-08d85123bed3
X-MS-TrafficTypeDiagnostic: BYAPR12MB2856:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2856ECD9545C1A611D971F51C22D0@BYAPR12MB2856.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jc06xDVFUww6IhPSEU3nZjsnnQseJqmTHeDl1DaWKLSVGJfsQqmYeQM30BCWVILlaVPukoDbp1r/HvFWnRERacupXnxZ/n1PFoInO9YYOaLqDsqNMjv7XaOOkcWFpgrSlUVwoYHlQVKib6PB4NFBXMSurQTSCPQ6bBdUdS7+vozPDfrNWxnjs2/RrqtncgkGHb1Y0hgH5cA0LT2rjpaVZf+tDfaxxoWEm8plzyyzEj+1GEY3Kk4iS/FN7JQFqnfzIRXRCvbXl/WG0mhG9afTtsiZxn+RwX2m9An7Hm5ip/7lG7rEX4a7Lnkq2UWjZ9WuOGCRq0ywSfggxqBpubKAXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(36756003)(8936002)(8676002)(9746002)(86362001)(9786002)(5660300002)(2906002)(2616005)(66476007)(26005)(186003)(478600001)(83380400001)(426003)(316002)(66556008)(66946007)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lSoc13Kg7cJE9Are48SD8flm2DTPdznSOvG08g8x0wVGGjmhCopj+r1QPXZWDKAex/pA6DNBkCqr+wF0QwCngvgdjorVa4OyPRBIwpZGXMpKU6G50+lkkVtuwh6dbhnrCp5Ru3MdHAlJM4JA1kZpyxjxWB8XIKRMcxhYyC4ZB2ipFhZi70uTN/qdQ8165cjejf9nO6Jlr2hiYoUpChAb7JGJhPMmenHUMfV6BP4KQDyZ2FUhg91DJ8q6wkDQHmxcMLR2g3igz7r4aldI8sF/nLLXWPhwxN3+Kg8K2vMCYbTutd2BXDopplDJTmHiuLpOr33VEmgRP90kwrHHM9Cuqwnx2+9c6b3dYZhy3ZqeSJlCDSsxxRs+N7yuQHF4mEq7oZsRLx3/O00Kd044kmUx5MKzJA3CdVUlEt9o4TyXb8GbGr2jt9Hp48VL+gStfDYUOOz/EPDB4U4DBID3MwOL+uU+LFSetqRUnwN+VGD7niZ12z/2yir591S/HeRIP4m+DqxB6gBeshgFtvvkrl47AhY9n0AELKp3shoCElM5SYRvVqevS9Zw6Bd2n38SRvFDGK/VZWxIQaFBep79WDR1t46RRGxL5b6k7ZL8CirgIGaJI0B9Wjg64wUjAuiyKjaogbeghhy9wNIarnLSOSj90A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 28088da4-d1be-43be-59b6-08d85123bed3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 22:42:04.4400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +G3ua4eC8iYqrTD7siJnDS1QWNdrbF6D8SRM42Oi5zduqJ5A4QV1SYim99CyT2vy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2856
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599259335; bh=UOra5+wekr5q0qfF4XyYZ8V/hit7Txzfrc8C63+hk0g=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:From:To:Subject:
         Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
         Content-Type:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=cD9hcz3TI7B7QmhqnuubxyMpOXJxcvhF3OpknPFnFCi+KArfeul67DrjuEPJQaEl9
         lApckQdQoiGgOqIFelSpbeLL8iBezdMLK/AEabGey0a4GZM5f32fT/nN1048gTAdX4
         I3L07OCDUD7N3DKKIcWafTig4d4w9NRMOQC1QVK/c3vMjSHB2ICMgqwD7PeBUpkuqP
         FlDyiqZj312CRRZ/Imz7AwkYoWvh6opkozS1Wn0S9zn/o9CmRFOW5/qVu24FPwUOyf
         ++1MgXz5SQ3WS5F6YjK0t4/3Is0tTg6aXQZohVMpH7Vyd9Z/PCGLOfHtmOc43lS8u5
         3iH/jX8f7DCmg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zbva is always false, so fbo is never read.

A 'zero-based-virtual-address' is simply IOVA =3D=3D 0, and the driver alre=
ady
supports this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/hw/qedr/verbs.c         |  4 ----
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 12 ++----------
 include/linux/qed/qed_rdma_if.h            |  2 --
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qed=
r/verbs.c
index 278b48443aedba..cca69b4ed354ea 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2878,10 +2878,8 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u=
64 start, u64 len,
 	mr->hw_mr.pbl_two_level =3D mr->info.pbl_info.two_layered;
 	mr->hw_mr.pbl_page_size_log =3D ilog2(mr->info.pbl_info.pbl_size);
 	mr->hw_mr.page_size_log =3D PAGE_SHIFT;
-	mr->hw_mr.fbo =3D ib_umem_offset(mr->umem);
 	mr->hw_mr.length =3D len;
 	mr->hw_mr.vaddr =3D usr_addr;
-	mr->hw_mr.zbva =3D false;
 	mr->hw_mr.phy_mr =3D false;
 	mr->hw_mr.dma_mr =3D false;
=20
@@ -2974,10 +2972,8 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd =
*ibpd,
 	mr->hw_mr.pbl_ptr =3D 0;
 	mr->hw_mr.pbl_two_level =3D mr->info.pbl_info.two_layered;
 	mr->hw_mr.pbl_page_size_log =3D ilog2(mr->info.pbl_info.pbl_size);
-	mr->hw_mr.fbo =3D 0;
 	mr->hw_mr.length =3D 0;
 	mr->hw_mr.vaddr =3D 0;
-	mr->hw_mr.zbva =3D false;
 	mr->hw_mr.phy_mr =3D true;
 	mr->hw_mr.dma_mr =3D false;
=20
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ether=
net/qlogic/qed/qed_rdma.c
index a4bcde522cdf9d..baa4c36608ea91 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1520,7 +1520,7 @@ qed_rdma_register_tid(void *rdma_cxt,
 		  params->pbl_two_level);
=20
 	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_ZERO_BASED,
-		  params->zbva);
+		  false);
=20
 	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_PHY_MR, params->phy_mr);
=20
@@ -1582,15 +1582,7 @@ qed_rdma_register_tid(void *rdma_cxt,
 	p_ramrod->pd =3D cpu_to_le16(params->pd);
 	p_ramrod->length_hi =3D (u8)(params->length >> 32);
 	p_ramrod->length_lo =3D DMA_LO_LE(params->length);
-	if (params->zbva) {
-		/* Lower 32 bits of the registered MR address.
-		 * In case of zero based MR, will hold FBO
-		 */
-		p_ramrod->va.hi =3D 0;
-		p_ramrod->va.lo =3D cpu_to_le32(params->fbo);
-	} else {
-		DMA_REGPAIR_LE(p_ramrod->va, params->vaddr);
-	}
+	DMA_REGPAIR_LE(p_ramrod->va, params->vaddr);
 	DMA_REGPAIR_LE(p_ramrod->pbl_base, params->pbl_ptr);
=20
 	/* DIF */
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_i=
f.h
index f464d85e88a410..aeb242cefebfa8 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -242,10 +242,8 @@ struct qed_rdma_register_tid_in_params {
 	bool pbl_two_level;
 	u8 pbl_page_size_log;
 	u8 page_size_log;
-	u32 fbo;
 	u64 length;
 	u64 vaddr;
-	bool zbva;
 	bool phy_mr;
 	bool dma_mr;
=20
--=20
2.28.0

