Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03E06DC6DF
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDJMsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDJMsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:48:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2108.outbound.protection.outlook.com [40.107.223.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6773E6E;
        Mon, 10 Apr 2023 05:48:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMNBi5ZGqqtTjUkR6JYF2gYXE3qtQVNxdnNIMuDBw/xSqtCoqYMIIOTCJsuQ9yfaEKNOceo4acGRExdhuH/dwf/8KdzMx2fzPqFP7beBVCoCoFxXEmBaz+h3V/N3d0W1regYykVR5oOsIhHxFq/EBhHZ68VqzDk9aTraMC4kSZvF9+vl0O8Ipsfe2Td4PQDXeHAFU3WPnLE+VRbmQV44b9vIaTcr9HmPcIB+qlWuH2CdCtC5ceQGLN2hATz9FETqtj5rDA55yJ9NmLj78ahQbOH6dmOAKtv3a8qLCWVlnm/c6MLztm2NlhkS60QszX/lzJf081EfKfmkW+hpudg2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmmdo/2rAJD+gVanExGqGj1+i4CRp9C/cVrH+5tspss=;
 b=AP46C/hXKElMl+PtQmbAe/DGISQxj7wz0tEOb2C9Hlqy2VAVgAfIP/AZRAemnPhv+IrxDfuyKxSyVLrZYKEYzOngoS/PzU/wMohpSVXaFbZ3mV976z+JGvnuUl/QT+X2rnh1aXgOL5GCWP+ALpSPt1/x1T9ME1kX9Wr0ICaF+PwS5hVViYae+zr6ao2HIJF4OV286Mu/QSBWJt14qM8mBxxZTd38MAJMDkuLzZgIIU5WJs+eHvuA0sKa6nWOA456vy86i2EYV1La/ZUi3BRQ1bEjtgKIymCKAptNMIXiFGu/F/ogJumRiWTptWtLMVV3yJkGm/5W0War3B79qliQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmmdo/2rAJD+gVanExGqGj1+i4CRp9C/cVrH+5tspss=;
 b=JY0bcBU2YnGdjr88OCLLnSoCLLnvaKkcXwCtWNOSoE/NL0Z0Q1mU0mte5cR/MyRiC6qafFxTq9+MXYoo1z4K3iXG6dr7pt1/ilK1CCJBP1EU929VYHkSfZh6YhuJ8g7dxcj+2QR/SAGlQFX2Yz9VGVCGgPofbA2S3sAElwwBgBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5314.namprd13.prod.outlook.com (2603:10b6:510:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Mon, 10 Apr
 2023 12:48:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 12:48:48 +0000
Date:   Mon, 10 Apr 2023 14:48:41 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 08/14] sfc: implement vdpa vring config
 operations
Message-ID: <ZDQFqV5xfQBC6hWT@corigine.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230407081021.30952-9-gautam.dawar@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407081021.30952-9-gautam.dawar@amd.com>
X-ClientProxiedBy: AM0PR04CA0127.eurprd04.prod.outlook.com
 (2603:10a6:208:55::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5314:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ed5c29-46a7-4c32-a43e-08db39c1ed7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5UMufbTxD2XlXreKuvJFKP1iSx7TfIjOl83VYOuCuKqFgxddGvCeXHj2VTq8DQLT3zDf0I9KK9nU3e1L2FzF1RZNPE1dQ0GZit8VDPciZCBphJbVS0yU5pslxtucpGWoBRV2fl/ssfVhr27wM33KINb9ZEEji0MdG76XMFauCGgzF3FrUaHDTjHJ3IFkIFMlnLwDl4WJYs8cGleDFC/UX3BcbZm63llQpELCDIFuij5be6bfgWCPvJS6Bw/3NQJnPWoK7qDYoF0GoyDi9Qb4IGI1DuFAwTLBAroauVw1jcUHHXNat6kMW54olI3zPqyA8ZcTzWKbZ77gOb6MFBwJb4o7hXy7OOXNvjHt0mA5HcLR3HrL/Jabn0mw46WVVe+7OdlbEiKIGd3PeOV6j2EO7WIaS6loQENz2za/In1DLnK3sgETKyb4COrQL9mJUtkdy0Wwp4zFGEAOJX5WWXIWNpGcwpGLQ3qt6NYeV0oV8jF00N7/6Vdkx3YFY2SABAUzVZLPUdGo6l7dm60o060Mc3DScaGdrVM16kZZYiOcxQhfrOjEjz33BrOn0wRcIMwE3tbJdWgwoO2MZKCo6LAAtbAUNxcX6uYcVCP29SKiuJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(346002)(136003)(366004)(451199021)(38100700002)(2906002)(6916009)(7416002)(44832011)(5660300002)(4326008)(66946007)(8936002)(41300700001)(86362001)(66476007)(66556008)(8676002)(36756003)(2616005)(6486002)(83380400001)(6512007)(6506007)(186003)(6666004)(54906003)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?knDLcDnvt6ykL6grM+k7CP5h4rieq55xbxBFIoSlBXHXulIdnmEzsn51rAAc?=
 =?us-ascii?Q?ybq4E8qWdVPSzB62yv8Wn4sA3pgeDywIy2uwu57f/590TRIJQNgD1ARRyx2k?=
 =?us-ascii?Q?7ab3rRGdY86XQI4ytrcovdyunfWoOZBIYsDVVsvvUSkvE6lMs9CCzuS3iv2D?=
 =?us-ascii?Q?8hdVHyk+5cubdXc7CBgAQX64TSzm0nRkNmfjFMhoSPxEeXEU157lGjFpy7Ql?=
 =?us-ascii?Q?tVMipuqtvu/SKkm/xug+m9CB1rP3GHxasP2vYtEHGWPGHUXb11devNS/AJwJ?=
 =?us-ascii?Q?8ObqallwZmgpLgJoVpv4dudGa9PtmS2Qp97jLp2aNbqmAxiOO2UsmonQx1gi?=
 =?us-ascii?Q?WIllA4xbCPSDmjQJYdYBvAeHXSTKg2nEbQTb7F1UFtVFVBQ47PnFQKSpDBm2?=
 =?us-ascii?Q?n6xULicoX2PdDoLpLDBGs61ahDI9D/z/wC5PQb7fi0nTI+AUQYAkjCiKfNhV?=
 =?us-ascii?Q?7gLHRLXLECiRCcs3fz4zvzrWCsycZifbq9etqg4/BHLj36LXp/pkwB1SRidM?=
 =?us-ascii?Q?D/TXeRl7BpnyVa1h81oHdhboMFWdf5g/kT7nEfceQ9O2eRy/NicqjWWkf9PK?=
 =?us-ascii?Q?3el3VtE3KQDTeF/3ufqnkfjJUf0dzEohWAmGYkzhnijRIrNZc7H9iMrpt0Em?=
 =?us-ascii?Q?dcHX1X+hwBmjbRbvhpoEX5FkaFdioUp3PvJ2IAvslL8H1W4sqnZAIXiUHRSD?=
 =?us-ascii?Q?MpMTZ91HikChTpyjC7PHU80E9mqcfzHElcxk1G9usZ/pppabuyMW4NvJLq/s?=
 =?us-ascii?Q?Ke7ogf52YvDQl1HwlrcOxepiHEuWCk126iYBuH3Zq14AkcguNmRxwjKAw3TD?=
 =?us-ascii?Q?IBdkaAEqDoU8iT6ISIeWHF3l8mjPEdC34D7kmqfiaD+JvJXCNm1inOBA51Nf?=
 =?us-ascii?Q?O0Cgka8OxkASwd0ajkZ53i3g0MT9zNNNGXESikp9/nrRsxMrtST54BTjGQLG?=
 =?us-ascii?Q?G/1HJsJSx7WfhCIYMuZqxg2bUYYNegGpMVb/o1PcTRDMzlI+tufn7SXDQ4ua?=
 =?us-ascii?Q?bfz6TijkJf4oM4UJTNsGZAzapyxyxVZU2ntjyZVeaHRAU4ovbVpxGfeL2k+0?=
 =?us-ascii?Q?HTnbN11ob/nxa8syYj4be4xZFnpq20RshVN94e5rQdAzxbBy6Eqqvfbctqzd?=
 =?us-ascii?Q?KhOWdHxkeSF6mlvT8OepKDJKmgrX1qzQR+zv1ndGfATro44j+d8Hkkx6A9XN?=
 =?us-ascii?Q?6Jfc0R9puhRjnASVvtGpbIMGOZ7JWWWycZKs/CmepXt646uz4K1fqnXWeMEq?=
 =?us-ascii?Q?N2lRUvv3rDA28R0QA618zpgSYW2aYRDIfbzvo8ZOWDTMro6QIyH6AWHurtqL?=
 =?us-ascii?Q?RO60tz+GflUGjijTRyNJQo4kKTFuUNhlFdGztTFEh3m/wfxR0fm0t+8bNP8J?=
 =?us-ascii?Q?t5WTy8G4i5AhnFFMUVHaVNDk9HyR9BBsklZeIuMfVkFgVLbKPPD4oSXYx6tW?=
 =?us-ascii?Q?7EpBTaS4i3ySPS+SZWSJ2VcUAEKOyu7RUTjkkLW3E9iZMJrtZRHj/mEY7vyc?=
 =?us-ascii?Q?Y98l967Z+rX8tMMhpLZgvvs5HM46nYxe3HapEbyUctDH3OmwllB3z5V05R5L?=
 =?us-ascii?Q?7HCFEnAASq6+IzGM49MHIXsyP2wzzw/k7spIiybqWg19+LVB+SDhlh4Sp1dp?=
 =?us-ascii?Q?b0JWgM06qDvBg5BY8FE3xN3ijQIdnz+IN4GywwvOCg3VnFxTVk5z3+/Wes/t?=
 =?us-ascii?Q?D+uDPQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ed5c29-46a7-4c32-a43e-08db39c1ed7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 12:48:48.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNLnXFZC87sWGOf7dlS5ojScAU6CuEGK5sK1IDnBzeiHK95mf8b+ydVmZQLZwWioGixjX5qP3NIHtbSeR6HI3/5sUsA/OvkFWE94Sj75Wog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5314
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 01:40:09PM +0530, Gautam Dawar wrote:
> This patch implements the vDPA config operations related to
> virtqueues or vrings. These include setting vring address,
> getting vq state, operations to enable/disable a vq etc.
> The resources required for vring operations eg. VI, interrupts etc.
> are also allocated.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>

...

> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c

...

> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
> +				    bool ready)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	if (ready) {
> +		vdpa_nic->vring[idx].vring_state |=
> +					EF100_VRING_READY_CONFIGURED;
> +	} else {
> +		vdpa_nic->vring[idx].vring_state &=
> +					~EF100_VRING_READY_CONFIGURED;
> +	}

nit: the if/else above does not need { }

> +	mutex_unlock(&vdpa_nic->lock);
> +}

...
