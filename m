Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D856EFAF2
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbjDZTWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbjDZTWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:22:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450E14EF4;
        Wed, 26 Apr 2023 12:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVTkATGybSuPusteqJ2JoR7BdjOfDPr4k5BIC2OPqXGFVVdimcdyJC1kT1bTmnQ63ryxm/0JmwL4EEFZ229IPrti3CX1yK6XMQGm6t0rthZoniRYfUDlJ905p+toARWYMavDrPnfnkqGmBFzuyY9tL+RJLEP5JQNfuR7qsgzPorRpJigICdCwEWguTEFHpdCXstsrAoTcjPH2Snw29DZhW2pcubrOHHCtcN8DdmBg6orRw8h/fIN18JHsvf4BnO48QCjQ+/DlEZ+37g6ltAedjjqPwzadahTpNcPHeoOhgsuOiMZGSHmu5+Je01HhUvfN8hEUHIFnQS1KzvJGwdaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfIiua0Hi/8c5M/Gjt2AuJyKn8dfn4GVEU6CD4F8QLQ=;
 b=g/c6JZA9FCG2Ed+2aj7W7VddvxacYM3gV8QDYgZUUMKeuRw2zVZEzkCCBhi8MzpDiB0kLyBmTyNgVrsoGJCiZe6BOqkpWdQt8b4zI5QqGXOmOSp8wtlspA2ME+rt7yhX+WFRpGF9Jebpi2udAhmIwbjFOmFz+hkwc+I/SBsMopZ05gZfRH0oUfkCaPvX/iKSSDygsG0Ia6w7baimTzHwUZzutdmlla+5EPNLmYu/NIzBPpWKhqhbIxK5nbblPG0ncfzeVpyhK0o/QLZpt3hElzeAGotSQl9QhqCn021wS87NG3qBCXZBvu8pWLrAxuJuJTXpJ5y2VAUQvH2bpj9doQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfIiua0Hi/8c5M/Gjt2AuJyKn8dfn4GVEU6CD4F8QLQ=;
 b=gvgf4msS0u3Yp06BxdElcvkSr3GbgAXazvbAgs59CKUqvEIdflP+4xcf9Trq/zLzN8FJ2QcUvIPkwYn8YN2RYjcMVY0ZBcm9nMZxp1P800M2VLvnVSmz5aMODgF6NiHi8LH5l29a9pdlq0abUMIl/aFfZk7Ooejhrfse4cU+6Gc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4139.namprd13.prod.outlook.com (2603:10b6:303:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 19:21:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 19:21:50 +0000
Date:   Wed, 26 Apr 2023 21:21:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vringh: IOMEM support
Message-ID: <ZEl5yKYzsw/g+tQh@corigine.com>
References: <20230425102250.3847395-1-mie@igel.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425102250.3847395-1-mie@igel.co.jp>
X-ClientProxiedBy: AS4P190CA0064.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: e7b21fd1-cdc5-40af-c6ea-08db468b7c71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8N/zmDwtx7s58ArSHBV+hT926BP0MrlKjgSseAfnH2QelA0gzxD0hzrN+AdtUfCdrekPCeskn0HlJ1AdrpQWQViw6PYLS3SXJwLZuJoif2aNBtbfDfHVzcDeXYBZ6aK5lUdbLoorEOSezMCJ/KjVLZNi1ioUf1b5BJbMkSh3m2N33tsEqZ7hsSoMqh6QdVLNe/HmI7TOQzzejNYw+8LeiyS0Lsnk/Kj0dm2EZyD1yCGH3TaJ03VQeJOIOIaJ6HzoQ37oMf/3JDTp7ZAEXKv4Yjw8PnUcqMM0/OP6We+ZoiJ5zbu7aFXC3zE0ve303P1lglnczKwngQXGn84Kg8vAKBcuFIaLLgQX9QVm+AyFosvOtCB6StO6zetBq0uAsZvSyp8zB5A7ndn0+Bu46GzLddToXuQbkzwugMQJonc9HU5zI/qGzfxphMdY1j0TtjleJK8rNW40LxeokQT4WlYW87BQOGgsFCAphVXgEYTFJrD+bdGIKGA408IZYX0iQGvEk1NJwGUPYKt/hh+VuH5+xCwMi2ePiF97qa+kR732AJ9x2XOPnlPg3X4irB4NsHDjavKZXsZNHtUdSRJNA2jl8wNE7nFZVx0tJP3WQtE3tI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(39840400004)(346002)(136003)(451199021)(83380400001)(2616005)(36756003)(44832011)(86362001)(6512007)(6506007)(6486002)(6666004)(478600001)(54906003)(316002)(66476007)(66946007)(66556008)(4326008)(6916009)(8936002)(8676002)(41300700001)(38100700002)(186003)(2906002)(5660300002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G0pO3Jc9l1SkcyTdb1I/ACsrLx2OeJ+4cG3pGv7R9anGiv4+7nCP/hsy4jmv?=
 =?us-ascii?Q?fRdpkMpp1kzydhrMpCOSyBPU7hNcvy8cHAE61MW635qPD+ROiBJYHUQ1huUO?=
 =?us-ascii?Q?j1zpAZFs7u6RaNhdsiIOGK3vX8+qY5b4XjYmiNh6/PGHJNX3Zb+yXQjFGbvP?=
 =?us-ascii?Q?nPYLjiV5sQB8D/jrHYVAzqFFsmGQ4KsNFoIBY5s5wDM4f/WVSTZr4Je/TDNb?=
 =?us-ascii?Q?2i4xs/5t+Ok0m+siG2jp1/7e80s5s20PAlDoiXq7mF3bx3WVNUPSyRiPMgmV?=
 =?us-ascii?Q?lH+VP+xe4madRD0sxvrNRMJy16220LBDd+tLKTFl+R1fROF1VqI8pCUuvG/c?=
 =?us-ascii?Q?EFARzzr8Y2ikhK3+B3KYO8FXmc+CEMtsvS8XZj/KiY/4aI+sFlyGzv83XEcd?=
 =?us-ascii?Q?IobzNdFwf3e10HwBTcGO0tZAPbLa64wJgKruK1ykBQs0BrmtZAF7WXXST07F?=
 =?us-ascii?Q?bIagW23zUOMOMMp9D669Fd9on8jY4H5uQDO3MI5F/dQviAt4XV12pfchiMXB?=
 =?us-ascii?Q?XFl2dhg38r+Dw7/yb9AKCBNHRKfX0hvcNgdV6zfhWTMIg1jzfWzbzauBx04r?=
 =?us-ascii?Q?R0ubdI2xY+EEXzly8MQC0LrXwKyoCoZZ6hhqiKf0X/fM6sWPfAcmQ7QN3AMQ?=
 =?us-ascii?Q?Mve6iy6pmimIZoDHNbn4Y2SBvPUIcYjTRc+6VemkZWsYjbdpX11bLNLac6jv?=
 =?us-ascii?Q?ILIVg5D6OB9r/jPfl52YtraFt+ziTJrJbJdKTUmcuZHExg9OGVFMZkRL1Vx9?=
 =?us-ascii?Q?vwUDSwQ2z2sRQillPl+OZ6yyGFW/FUve5CgV4VqJoSOPLHLCtHKciSBpDLZQ?=
 =?us-ascii?Q?ggSfGs/UJ7AuE5oFtmLg5qypBZ8L4dU2H8DpuJx80WIUZODyAm/0SLDZfJiV?=
 =?us-ascii?Q?C+vBuOL4X/xFlQfLpjhVX/5TPu6Hyi3etF4EKVIONsg1OYGUSnP3gjxARnwB?=
 =?us-ascii?Q?ZUDBN6tXrJQbGJQ6kW11jvmhsbvk9q5NCrmiialsK44DHNFAG6ddm+YUMY+E?=
 =?us-ascii?Q?MW7WUs8BSZfZlDB2jySAf96uXjQfdn4Aixj2kL8yVDz7Fh0zoNdJDRdZwLbL?=
 =?us-ascii?Q?a3oz8TeaqA+TgpU8s/Lnh27rtl/l5dOcZR37P08vNMD6dJF0muIb/NbnNHe4?=
 =?us-ascii?Q?8asbKp90kDNjg98ldjLw/FcYSLAKEKqmwXHOtg8Oq+du5atMzdRC6AFe+urL?=
 =?us-ascii?Q?DUV6DC70/mdsV8xF96elwhCyHgZ8OuXpx8tCvXJBQPPQmbEXCi68HLfDtNnx?=
 =?us-ascii?Q?N3P+WX6ybx39wO0ZpT20YvsEKHd8tcILW1P5Vtj77QjJheWv0NHFwOuizLUV?=
 =?us-ascii?Q?0ibiFWFFHOtiBrHYAXXgannmx4BHz4gGKXS1Wj0pBXX09lxiJuKp8XJZMMeO?=
 =?us-ascii?Q?cSfM8dZFg15wX40M4vIlxfQJZ8E/cyWEb2RGVs8OsgysuQewZrRyP+VpWfPO?=
 =?us-ascii?Q?2tnxQLTtjzE44KKnOMCYfBihE2ZJI219X9LGhs6N+9x/h0Nng7oiHs2nNkkC?=
 =?us-ascii?Q?sj6Np2wtYo6jx/o+k1hEIoEUMhzZtdRAXIWJhvnV8fivGWTwhFrrkVYt/Pki?=
 =?us-ascii?Q?WWMXdvaVnCwRConjy4cxw4fxz9h/FQik2dibaGi7McgNNyKNi4Y17QYBy4W5?=
 =?us-ascii?Q?c7CQdsYRSaoVqPrk/sZSW/BrpoOEVX6q+aEiG4GbFz56JRDduJQ+wYQH1a6X?=
 =?us-ascii?Q?fAcCxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b21fd1-cdc5-40af-c6ea-08db468b7c71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 19:21:50.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T88RrOuxXBEdjXupAcI6rk6EFVNwfcQJQi+ndZFqAYdhze2URPifxjp5KDnc0ClK358WKI+H+/kQuAE8Jr2XLMpkGioOGAdkGwKkLg3M+aw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4139
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 07:22:50PM +0900, Shunsuke Mie wrote:
> Introduce a new memory accessor for vringh. It is able to use vringh to
> virtio rings located on io-memory region.
> 
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>

...

Hi Mie-san,

thanks for your patch.
One small nit from me below.

> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index c3a8117dabe8..c03d045f7f3f 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -330,4 +330,37 @@ int vringh_need_notify_iotlb(struct vringh *vrh);
>  
>  #endif /* CONFIG_VHOST_IOTLB */
>  
> +#if IS_REACHABLE(CONFIG_VHOST_RING_IOMEM)
> +
> +int vringh_init_iomem(struct vringh *vrh, u64 features,
> +		      unsigned int num, bool weak_barriers,
> +		      struct vring_desc *desc,
> +		      struct vring_avail *avail,
> +		      struct vring_used *used);
> +
> +

nit: one blank line is enough.

> +int vringh_getdesc_iomem(struct vringh *vrh,
> +			 struct vringh_kiov *riov,
> +			 struct vringh_kiov *wiov,
> +			 u16 *head,
> +			 gfp_t gfp);

...
