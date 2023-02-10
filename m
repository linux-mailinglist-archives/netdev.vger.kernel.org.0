Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016F56923D9
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjBJRAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjBJRAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:00:23 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2122.outbound.protection.outlook.com [40.107.243.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0922D6D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:00:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nf4ZMI7NtgbIDCrF8mRs25aF2CqBxolz+xTuaAJz3GpIpKa419MOAoJ8Z6QHmS6VxcZnEKWNZdgdwSSevhXpYEjC7Tf1Psdsi8maVyDxIw0DyAfnSmTM71CXBvkS6obcjKGTKewuzC6EY89hw1tgCF/R6a/CMK93ugLmki8dZXDXPRkmODz8vJkCOusar5PQvZTTorVYavCvyVUXKKm93lkFJn2QUf5ldtgWudf28KSm+7NjKkCII/VOFv0/qsPDYJ6z7g9V9S4zxWL0gCwZZRczEfABe+HFr55WXbSKigMS+Bsonj234w+igooanebfogIZWEYwULnYY08dc8JK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/34opoNk8Ojsrx/71YxwbmKD15HmeAJ5850brcsSvE=;
 b=PtdDWsC5yKzWOgFdvf1YJ3GAebtaBv0qQfztZNLB2iWy7+JRS74s94/8Ei/l16nHwaW1RxLX0j5SmVOmVQ7+umX7ZcWNuTVVslm1U62oYgBBuY5sJuNwtgEAjA8nsKfWAEXuTOJkhX9vYZtON8g4c+7gwmraUlRgAvAHMBfcyiM0/zya4an07fSCF46QSjVTr9NeTYxxAXHEfX3ir3MxUmpNDD4fsAXIBhYxCy4BDioulAlVGIY/fUhGtA9GWUD8cJeU1pFsYZYr0fnFpZQhomz0BrTe8eaS7CI+Or60bGDTPkjBSl534BWKnEwkBGWE76pFYH6etSpZ/EI/G8mQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/34opoNk8Ojsrx/71YxwbmKD15HmeAJ5850brcsSvE=;
 b=A01Xb48aAcm8vDzmEthTDyY9G4p0l2g82WqOCcx5rRUUCHHjvYIdS0v8SvFeoPv0yiw3rX3ydF3ewyP9KfFKZNKSxDTARVRRlgKgrb9f6rNS6JyvLqv4g4iHQMOuTZ1nf1+UISuHUZwyFhCwO38rJhPBb4X9Ckdxvey4S3wQ/+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5321.namprd13.prod.outlook.com (2603:10b6:303:148::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 17:00:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 17:00:14 +0000
Date:   Fri, 10 Feb 2023 18:00:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Harsh Jain <h.jain@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, thomas.lendacky@amd.com, Raju.Rangoju@amd.com,
        Shyam-sundar.S-k@amd.com, harshjain.prof@gmail.com,
        abhijit.gangurde@amd.com, puneet.gupta@amd.com,
        nikhil.agarwal@amd.com, tarak.reddy@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH  1/6] net: ethernet: efct: New X3 net driver
Message-ID: <Y+Z4Fsjw2NTl4fLD@corigine.com>
References: <20230210130321.2898-1-h.jain@amd.com>
 <20230210130321.2898-2-h.jain@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-2-h.jain@amd.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AS4P189CA0021.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5321:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a1ca9b-2b32-42cc-b503-08db0b884714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2kYIczfLYt1wDYy7DiNa27N1yKHffZmQVwYclGykvvtOOcXYl9WKpIVAgeK88Q/oic009ejFBAXclSD5puPCMI8jH8nr78KSiMpiQiKGDlidR0oeoPYM+bhALOFBO3/gkMjq+WzQ4HZas7Oc01zmAo7nju+v0CDzOQrqHT3vzagKQ4obRpI6moeapbkWwtfnsifIS6B9txprX1MponlrTL9tSe5EJSVPS26pBlDIJ6fJV1mh352d8SvJ/rFpN5J6EaS9jR4aSchAQMasgZfBv86Ku2E8W9jG4NXogToEa0thmmi3wTlZbMZou/83u3Ov5l09yA5KTY5o45T7QCEdBQiyjvktJun/I5+r7MWgBEHnB9hHvQvnATvR+d1qR2nTdj7QadDOV9sj2UOk5psKsLtCKoVWUYeLtJG21IphmZEoM51zwJotC1eW4zUUo9sZtUiezowypuEePkvCEa8KyQk+MF2FlFrSl0PSMU29t4eW+0A1qS8whDqmMhoTEb1Aagl3nlnaFSMkh3ZO8d2FrWUqCvcOAfqp51wmBiCGLWzpWDLizsvoxgSqnL9SdSCvvV93ulYFaOTV9zN3CcFbGhrlUVAHl2AIt05bpNwNv3YfjDaJs4PFFHAVeZFoWefm2z6jZZf2CGfHpPLYM/vi84wJlZqbrhEZA/iM8vse5PdOB2h7Wo9OPvIW93U66Y1K9w7npu9tuPQOyqHqdkLwh9t+5phv2ifThxl1CquJ88=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199018)(38100700002)(186003)(6486002)(86362001)(7416002)(41300700001)(5660300002)(8936002)(6916009)(8676002)(30864003)(66476007)(4326008)(66946007)(2616005)(44832011)(66556008)(6506007)(478600001)(2906002)(6512007)(6666004)(316002)(966005)(36756003)(83380400001)(66899018)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5EJ3dUIbHlE+sdBsVtEBKaW+WUWLsswoaLbC8nodRGyEg3bhTvn+hA2w1SR4?=
 =?us-ascii?Q?cZDf6PYdUG6oCvF0ii2WvBo38dyPh9ivF01aMr9Wn7IzROZG8MdC+bSQ/zSe?=
 =?us-ascii?Q?4V5s56Pc6O4gkdgEkqHXSiE/eVpBseeOz5X+TGMrWFgNq3vEwNPeWluzusnU?=
 =?us-ascii?Q?06E6QXjRSMHrs/uxic2knsdFn1i8tfG9mmGAVem+q+8/RDXKQHN3ZHAvsTeG?=
 =?us-ascii?Q?EVpit5oYxAsstT1QLfvcB8O1Yd69cZUSg1kjnkBMNbKbbDY/XVMYtEkx1UoA?=
 =?us-ascii?Q?JJwHIwCLbYQTnw/olvfq3EzYFtE1WB5rBgvmPv5RkvF5II7f3huY1LLOQ9is?=
 =?us-ascii?Q?Rq8WNJQEAMvoHmkvsDl3RiP0onCUarKYI9eHtdmthLxX4n8pCMjKdlRdMaPv?=
 =?us-ascii?Q?qP8pruY1hkYuDm6IWMBgRf7h7ksA66zJ51mCT0vptvyXNVQ2hHmGTiNefd34?=
 =?us-ascii?Q?k+tEUpCEMH7zzNwk9RYFBX6+anNlRmMcqEy3jvwD9aFzrFI+2mkCJNxf9zR4?=
 =?us-ascii?Q?+W3747BU9phxjT8sckp5xG5OqaVgAXmV10Uq0FeOH1sm7VkL+U7KcIbH+z3S?=
 =?us-ascii?Q?75tqAsyMThch1Pk6qN48Ha0Z1olOgNG4F0QsaN1F5KGKwAGCaAJmAMj74chG?=
 =?us-ascii?Q?pzuDV47nX1sKimcijkct6Zu2AuidEJAu0k8QCyPjmitxFZKbznhEz+s24G9B?=
 =?us-ascii?Q?LAIRM915lV6sGAGD8Dh+jO+EWjvLu65KQZcNwf1g5lybt6VUTJl9wFZmOBHH?=
 =?us-ascii?Q?ApYrmpqhrKBgdjm+3wAkWp9nR+6Lpjkn+7J9+jTvbKNc7uMK921zFQBbnJUy?=
 =?us-ascii?Q?OXBw4daAOg1zZuJE/u6DJFF8CzJbx2P9okMQSoq3uoCEzJcKCd0VHMv868s8?=
 =?us-ascii?Q?tJiA1jACtT+pinXoIH0m16eaR2dErmiD8cD75lbE3NafLSTOyX7l6YKUN3pc?=
 =?us-ascii?Q?SbuUd4uIiHsWf16mqN7FdZkd8KhHkfIHapdE8XKyf/WQHEhbObE+3C5YFQ6H?=
 =?us-ascii?Q?KlZDNwZttZk6qN5udczJ6nW536qW9acT67NOL+MYGJ9Fg3/o+8+gBAIhzlpr?=
 =?us-ascii?Q?ntFQRMbfqULfF5nsnHrvAZ9HWuLkfjAg1N/u9HYB0LBgKRtwqrtg/XiJrffF?=
 =?us-ascii?Q?t12ukWTSNXwpi8gISg/BnxUO1HRdJsXiJNJf3BD4kmngqZTBpAZnWIUB0eTQ?=
 =?us-ascii?Q?nuXo8Zfq6hLAuvMhW3r9isMGgEgtz3X2nKUWjqeR/lWYIXHJZaW/94c6rUK2?=
 =?us-ascii?Q?EzsT3UNfC2PI5AJNL3kA1W1oqFBmq3Fliz3wFVzFTH5Ns0Ly/HE8ZdH9sf6h?=
 =?us-ascii?Q?67/vW6AePnYcD6hen8PmqRetNEHj8lUGgGRekaijWboyDe1ZC0vDannGLV89?=
 =?us-ascii?Q?O7jrwLKAUmcngYdIcNUM995hjcZ/Mn80C3lYEO3B+FNdTb43jQ88ZVwODek1?=
 =?us-ascii?Q?PW0pyumy/y34zvmHy0H8hj0QaKhSEQ24rc1cEdjS0h1KtEL6y44nCh/jqlo5?=
 =?us-ascii?Q?j7GGUsipLGisTa11+H7IMOo6jjQuG4rJvAK8PIwKwwwh563QkNwm13E91h2Z?=
 =?us-ascii?Q?WEnFyr7j9jnjh7JMcWROgmDYS0p8f+TFcjHm48mbnIVeJ8zWBZ0ziRsNg5LI?=
 =?us-ascii?Q?LFL1CYR2aloLdvqt92OLiQJ2TX2/BeE+8pGBrWlvmF+SjNJ46T71UyQw/rWh?=
 =?us-ascii?Q?CV7lmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a1ca9b-2b32-42cc-b503-08db0b884714
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 17:00:14.3116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GxFpcYVEMzWVVxOtGzFOoH0C8wWzFTVK7Zz6+Ny72mVhslvCT1q0cfVlDoYQJ0non4zuHFwL/ZojUW6DQ3gqOExP3jl69OVY7yZcmZSw1zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5321
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 06:33:16PM +0530, Harsh Jain wrote:
> This patch series adds new ethernet network driver for Alveo X3522[1].
> is a low-latency NIC with an aim to deliver the lowest possible
> latency. It accelerates a range of diverse trading strategies
> and financial applications.
> 
> Device has 2 PCI functions and each function supports 2 port, currently
> at 10GbE. This patch deals with PCI device probing and netdev creation.
> It also adds support for Firmware communication APIs used in later patches.
> 
> [1] https://www.xilinx.com/x3
> 
> Signed-off-by: Abhijit Gangurde<abhijit.gangurde@amd.com>
> Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
> Signed-off-by: Nikhil Agarwal<nikhil.agarwal@amd.com>
> Signed-off-by: Tarak Reddy<tarak.reddy@amd.com>
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  drivers/net/ethernet/amd/efct/efct_bitfield.h |  483 ++
>  drivers/net/ethernet/amd/efct/efct_common.c   | 1154 ++++
>  drivers/net/ethernet/amd/efct/efct_common.h   |  134 +
>  drivers/net/ethernet/amd/efct/efct_driver.h   |  770 +++
>  drivers/net/ethernet/amd/efct/efct_enum.h     |  130 +
>  drivers/net/ethernet/amd/efct/efct_evq.c      |  185 +
>  drivers/net/ethernet/amd/efct/efct_evq.h      |   21 +
>  drivers/net/ethernet/amd/efct/efct_io.h       |   64 +
>  drivers/net/ethernet/amd/efct/efct_netdev.c   |  459 ++
>  drivers/net/ethernet/amd/efct/efct_netdev.h   |   19 +
>  drivers/net/ethernet/amd/efct/efct_nic.c      | 1300 ++++
>  drivers/net/ethernet/amd/efct/efct_nic.h      |  104 +
>  drivers/net/ethernet/amd/efct/efct_pci.c      | 1077 +++
>  drivers/net/ethernet/amd/efct/efct_reg.h      | 1060 +++
>  drivers/net/ethernet/amd/efct/mcdi.c          | 1817 ++++++
>  drivers/net/ethernet/amd/efct/mcdi.h          |  373 ++
>  .../net/ethernet/amd/efct/mcdi_functions.c    |  642 ++
>  .../net/ethernet/amd/efct/mcdi_functions.h    |   39 +
>  drivers/net/ethernet/amd/efct/mcdi_pcol.h     | 5789 +++++++++++++++++
>  .../net/ethernet/amd/efct/mcdi_port_common.c  |  949 +++
>  .../net/ethernet/amd/efct/mcdi_port_common.h  |   98 +
>  21 files changed, 16667 insertions(+)

This is a very large patch to review.

>  create mode 100644 drivers/net/ethernet/amd/efct/efct_bitfield.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_common.c
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_common.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_driver.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_enum.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_evq.c
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_evq.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_io.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_netdev.c
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_netdev.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_nic.c
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_nic.h
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_pci.c
>  create mode 100644 drivers/net/ethernet/amd/efct/efct_reg.h
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi.c
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi.h
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi_functions.c
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi_functions.h
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi_pcol.h
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi_port_common.c
>  create mode 100644 drivers/net/ethernet/amd/efct/mcdi_port_common.h
> 
> diff --git a/drivers/net/ethernet/amd/efct/efct_bitfield.h b/drivers/net/ethernet/amd/efct/efct_bitfield.h
> new file mode 100644
> index 000000000000..bd67e0fa08f9
> --- /dev/null
> +++ b/drivers/net/ethernet/amd/efct/efct_bitfield.h
> @@ -0,0 +1,483 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + ****************************************************************************
> + * Driver for AMD/Xilinx network controllers and boards
> + * Copyright (C) 2021, Xilinx, Inc.
> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> + */
> +
> +#ifndef EFCT_BITFIELD_H
> +#define EFCT_BITFIELD_H
> +#include <linux/types.h>
> +
> +/* Efct bitfield access
> + * NIC uses bitfield of upto 128 bits wide.  Since there is no
> + * native 128-bit datatype on most systems, and 64-bit datatypes
> + * are inefficient on 32-bit systems and vice versa,
> + * we wrap accesses in a way that uses the most efficient
> + * datatype.
> + *
> + * The NICs are PCI devices and therefore little-endian.  Since most
> + * of the quantities that we deal with are DMAed to/from host memory,
> + * we define our datatypes (union efct_oword, union efct_dword and
> + * union efct_qword) to be little-endian.
> + */
> +
> +/* Lowest bit numbers and widths */
> +#define EFCT_DUMMY_FIELD_LBN 0
> +#define EFCT_DUMMY_FIELD_WIDTH 0
> +#define EFCT_WORD_0_LBN 0
> +#define EFCT_WORD_0_WIDTH 16
> +#define EFCT_WORD_1_LBN 16
> +#define EFCT_WORD_1_WIDTH 16
> +#define EFCT_DWORD_0_LBN 0
> +#define EFCT_DWORD_0_WIDTH 32
> +#define EFCT_DWORD_1_LBN 32
> +#define EFCT_DWORD_1_WIDTH 32
> +#define EFCT_DWORD_2_LBN 64
> +#define EFCT_DWORD_2_WIDTH 32
> +#define EFCT_DWORD_3_LBN 96
> +#define EFCT_DWORD_3_WIDTH 32
> +#define EFCT_QWORD_0_LBN 0
> +#define EFCT_QWORD_0_WIDTH 64

nit: The above would be easier to read if the values were vertically aligned
nit 2: blank line here

> +/* Specified attribute (e.g. LBN) of the specified field */
> +#define EFCT_VAL(field, attribute) field ## _ ## attribute

> +/* Low bit number of the specified field */
> +#define EFCT_LOW_BIT(field) EFCT_VAL(field, LBN)
> +/* Bit width of the specified field */
> +#define EFCT_WIDTH(field) EFCT_VAL(field, WIDTH)
> +/* High bit number of the specified field */
> +#define EFCT_HIGH_BIT(field) (EFCT_LOW_BIT(field) + EFCT_WIDTH(field) - 1)

nit2: and here

> +/* Mask equal in width to the specified field.
> + *
> + * For example, a field with width 5 would have a mask of 0x1f.
> + *
> + * The maximum width mask that can be generated is 64 bits.
> + */
> +#define EFCT_MASK64(width)			\
> +	((width) == 64 ? ~((u64)0) :		\
> +	 (((((u64)1) << (width))) - 1))

Maybe:

#define EFCT_MASK64_B(width) ((width) ? GENMASK_ULL((width) - 1, 0) : 0ULL)

> +
> +/* Mask equal in width to the specified field.
> + *
> + * For example, a field with width 5 would have a mask of 0x1f.
> + *
> + * The maximum width mask that can be generated is 32 bits.  Use
> + * EFCT_MASK64 for higher width fields.
> + */
> +#define EFCT_MASK32(width)			\
> +	((width) == 32 ? ~((u32)0) :		\
>  +	 (((((u32)1) << (width))) - 1))

Maybe:

#define EFCT_MASK32_B(width) ((width) ? GENMASK((width) - 1, 0) : 0UL)

> +
> +/* A doubleword (i.e. 4 byte) datatype - little-endian in HW */
> +union efct_dword {
> +	__le32 word32;
> +};

I see where you are going with consistency for
efct_dword, efct_qword and efct_oword.
But does a union with one element provide value?

> +
> +/* A quadword (i.e. 8 byte) datatype - little-endian in HW */
> +union efct_qword {
> +	__le64 u64[1];
> +	__le32 u32[2];
> +	union efct_dword dword[2];

dword is an alias for .ue2. I'm not sure I see the value in this.

> +};
> +
> +/* An octword (eight-word, i.e. 16 byte) datatype - little-endian in HW */
> +union efct_oword {
> +	__le64 u64[2];
> +	union efct_qword qword[2];
> +	__le32 u32[4];
> +	union efct_dword dword[4];

ditto

> +};
> +
> +/* Format string and value expanders for printk */
> +#define EFCT_DWORD_FMT "%08x"
> +#define EFCT_OWORD_FMT "%08x:%08x:%08x:%08x"
> +#define EFCT_DWORD_VAL(dword)				\
> +	((u32)le32_to_cpu((dword).word32))
> +
> +/* Extract bit field portion [low,high) from the native-endian element
> + * which contains bits [min,max).
> + * For example, suppose "element" represents the high 32 bits of a
> + * 64-bit value, and we wish to extract the bits belonging to the bit
> + * field occupying bits 28-45 of this 64-bit value.
> + * Then EFCT_EXTRACT ( element, 32, 63, 28, 45 ) would give
> + *
> + *   ( element ) << 4
> + * The result will contain the relevant bits filled in the range
> + * [0,high-low), with garbage in bits [high-low+1,...).

In this case [0,min-low) will be zero filled.
But maybe that never happens so it's not important that it is spelt out.

Garbage bits sounds fun.

Did you consider implementing this using GET_FIELD and GENMASK_ULL?

> + */
> +#define EFCT_EXTRACT_NATIVE(native_element, min, max, low, high)		\
> +	((low) > (max) || (high) < (min) ? 0 :				\
> +	 (low) > (min) ?						\
> +	 (native_element) >> ((low) - (min)) :				\
> +	 (native_element) << ((min) - (low)))
> +
> +/* Extract bit field portion [low,high) from the 64-bit little-endian
> + * element which contains bits [min,max)
> + */
> +#define EFCT_EXTRACT64(element, min, max, low, high)			\
> +	EFCT_EXTRACT_NATIVE(le64_to_cpu(element), min, max, low, high)
> +
> +/* Extract bit field portion [low,high) from the 32-bit little-endian
> + * element which contains bits [min,max)
> + */
> +#define EFCT_EXTRACT32(element, min, max, low, high)			\
> +	EFCT_EXTRACT_NATIVE(le32_to_cpu(element), min, max, low, high)
> +
> +#define EFCT_EXTRACT_OWORD64(oword, low, high)				\
> +	((EFCT_EXTRACT64((oword).u64[0], 0, 63, low, high) |		\
> +	  EFCT_EXTRACT64((oword).u64[1], 64, 127, low, high)) &		\
> +	 EFCT_MASK64((high) + 1 - (low)))
> +
> +#define EFCT_EXTRACT_QWORD64(qword, low, high)				\
> +	(EFCT_EXTRACT64((qword).u64[0], 0, 63, low, high) &		\
> +	 EFCT_MASK64((high) + 1 - (low)))
> +
> +#define EFCT_EXTRACT_OWORD32(oword, low, high)				\
> +	((EFCT_EXTRACT32((oword).u32[0], 0, 31, low, high) |		\
> +	  EFCT_EXTRACT32((oword).u32[1], 32, 63, low, high) |		\
> +	  EFCT_EXTRACT32((oword).u32[2], 64, 95, low, high) |		\
> +	  EFCT_EXTRACT32((oword).u32[3], 96, 127, low, high)) &		\
> +	 EFCT_MASK32((high) + 1 - (low)))
> +
> +#define EFCT_EXTRACT_QWORD32(qword, low, high)				\
> +	((EFCT_EXTRACT32((qword).u32[0], 0, 31, low, high) |		\
> +	  EFCT_EXTRACT32((qword).u32[1], 32, 63, low, high)) &		\
> +	 EFCT_MASK32((high) + 1 - (low)))
> +
> +#define EFCT_EXTRACT_DWORD(dword, low, high)			\
> +	(EFCT_EXTRACT32((dword).word32, 0, 31, low, high) &	\
> +	 EFCT_MASK32((high) + 1 - (low)))
> +
> +#define EFCT_OWORD_FIELD64(oword, field)				\
> +	EFCT_EXTRACT_OWORD64(oword, EFCT_LOW_BIT(field),		\
> +			    EFCT_HIGH_BIT(field))
> +
> +#define EFCT_QWORD_FIELD64(qword, field)				\
> +	EFCT_EXTRACT_QWORD64(qword, EFCT_LOW_BIT(field),		\
> +			    EFCT_HIGH_BIT(field))
> +
> +#define EFCT_OWORD_FIELD32(oword, field)				\
> +	EFCT_EXTRACT_OWORD32(oword, EFCT_LOW_BIT(field),		\
> +			    EFCT_HIGH_BIT(field))
> +
> +#define EFCT_QWORD_FIELD32(qword, field)				\
> +	EFCT_EXTRACT_QWORD32(qword, EFCT_LOW_BIT(field),		\
> +			    EFCT_HIGH_BIT(field))
> +
> +#define EFCT_DWORD_FIELD(dword, field)				\
> +	EFCT_EXTRACT_DWORD(dword, EFCT_LOW_BIT(field),		\
> +			  EFCT_HIGH_BIT(field))
> +
> +#define EFCT_OWORD_IS_ZERO64(oword)					\
> +	(((oword).u64[0] | (oword).u64[1]) == (__force __le64)0)
> +
> +#define EFCT_QWORD_IS_ZERO64(qword)					\
> +	(((qword).u64[0]) == (__force __le64)0)
> +
> +#define EFCT_OWORD_IS_ZERO32(oword)					     \
> +	(((oword).u32[0] | (oword).u32[1] | (oword).u32[2] | (oword).u32[3]) \
> +	 == (__force __le32)0)
> +
> +#define EFCT_QWORD_IS_ZERO32(qword)					\
> +	(((qword).u32[0] | (qword).u32[1]) == (__force __le32)0)
> +
> +#define EFCT_DWORD_IS_ZERO(dword)					\
> +	(((dword).u32[0]) == (__force __le32)0)
> +
> +#define EFCT_OWORD_IS_ALL_ONES64(oword)					\
> +	(((oword).u64[0] & (oword).u64[1]) == ~((__force __le64)0))
> +
> +#define EFCT_QWORD_IS_ALL_ONES64(qword)					\
> +	((qword).u64[0] == ~((__force __le64)0))
> +
> +#define EFCT_OWORD_IS_ALL_ONES32(oword)					\
> +	(((oword).u32[0] & (oword).u32[1] & (oword).u32[2] & (oword).u32[3]) \
> +	 == ~((__force __le32)0))
> +
> +#define EFCT_QWORD_IS_ALL_ONES32(qword)					\
> +	(((qword).u32[0] & (qword).u32[1]) == ~((__force __le32)0))
> +
> +#define EFCT_DWORD_IS_ALL_ONES(dword)					\
> +	((dword).u32[0] == ~((__force __le32)0))
> +
> +#if BITS_PER_LONG == 64
> +#define EFCT_OWORD_FIELD		EFCT_OWORD_FIELD64
> +#define EFCT_QWORD_FIELD		EFCT_QWORD_FIELD64
> +#define EFCT_OWORD_IS_ZERO	EFCT_OWORD_IS_ZERO64
> +#define EFCT_QWORD_IS_ZERO	EFCT_QWORD_IS_ZERO64
> +#define EFCT_OWORD_IS_ALL_ONES	EFCT_OWORD_IS_ALL_ONES64
> +#define EFCT_QWORD_IS_ALL_ONES	EFCT_QWORD_IS_ALL_ONES64
> +#else
> +#define EFCT_OWORD_FIELD		EFCT_OWORD_FIELD32
> +#define EFCT_QWORD_FIELD		EFCT_QWORD_FIELD32
> +#define EFCT_OWORD_IS_ZERO	EFCT_OWORD_IS_ZERO32
> +#define EFCT_QWORD_IS_ZERO	EFCT_QWORD_IS_ZERO32
> +#define EFCT_OWORD_IS_ALL_ONES	EFCT_OWORD_IS_ALL_ONES32
> +#define EFCT_QWORD_IS_ALL_ONES	EFCT_QWORD_IS_ALL_ONES32
> +#endif
> +
> +/* Construct bit field portion
> + * Creates the portion of the bit field [low,high) that lies within
> + * the range [min,max).
> + */
> +#define EFCT_INSERT_NATIVE64(min, max, low, high, value)		\
> +	((((low) > (max)) || ((high) < (min))) ? 0 :			\
> +	 (((low) > (min)) ?						\
> +	  (((u64)(value)) << ((low) - (min))) :		\
> +	  (((u64)(value)) >> ((min) - (low)))))
> +
> +#define EFCT_INSERT_NATIVE32(min, max, low, high, value)		\
> +	((((low) > (max)) || ((high) < (min))) ? 0 :			\
> +	 (((low) > (min)) ?						\
> +	  (((u32)(value)) << ((low) - (min))) :		\
> +	  (((u32)(value)) >> ((min) - (low)))))
> +
> +#define EFCT_INSERT_NATIVE(min, max, low, high, value)		\
> +	(((((max) - (min)) >= 32) || (((high) - (low)) >= 32)) ?	\
> +	 EFCT_INSERT_NATIVE64(min, max, low, high, value) :	\
> +	 EFCT_INSERT_NATIVE32(min, max, low, high, value))
> +
> +/* Construct bit field portion
> + * Creates the portion of the named bit field that lies within the
> + * range [min,max).
> + */
> +#define EFCT_INSERT_FIELD_NATIVE(min, max, field, value)		\
> +	EFCT_INSERT_NATIVE(min, max, EFCT_LOW_BIT(field),		\
> +			  EFCT_HIGH_BIT(field), value)
> +
> +/* Construct bit field
> + * Creates the portion of the named bit fields that lie within the
> + * range [min,max).
> + */
> +#define EFCT_INSERT_FIELDS_NATIVE(_min, _max,				\
> +				 field1, value1,			\
> +				 field2, value2,			\
> +				 field3, value3,			\
> +				 field4, value4,			\
> +				 field5, value5,			\
> +				 field6, value6,			\
> +				 field7, value7,			\
> +				 field8, value8,			\
> +				 field9, value9,			\
> +				 field10, value10)			\
> +	({typeof(_min) (min) = (_min);					\
> +	  typeof(_max) (max) = (_max);			\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field1, (value1)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field2, (value2)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field3, (value3)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field4, (value4)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field5, (value5)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field6, (value6)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field7, (value7)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field8, (value8)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field9, (value9)) |	\
> +	 EFCT_INSERT_FIELD_NATIVE((min), (max), field10, (value10)); })
> +
> +#define EFCT_INSERT_FIELDS64(...)				\
> +	cpu_to_le64(EFCT_INSERT_FIELDS_NATIVE(__VA_ARGS__))
> +
> +#define EFCT_INSERT_FIELDS32(...)				\
> +	cpu_to_le32(EFCT_INSERT_FIELDS_NATIVE(__VA_ARGS__))
> +
> +#define EFCT_POPULATE_OWORD64(oword, ...) do {				\
> +	(oword).u64[0] = EFCT_INSERT_FIELDS64(0, 63, __VA_ARGS__);	\
> +	(oword).u64[1] = EFCT_INSERT_FIELDS64(64, 127, __VA_ARGS__);	\
> +	} while (0)
> +
> +#define EFCT_POPULATE_QWORD64(qword, ...) (qword).u64[0] = EFCT_INSERT_FIELDS64(0, 63, __VA_ARGS__)
> +
> +#define EFCT_POPULATE_OWORD32(oword, ...) do {				\
> +	(oword).u32[0] = EFCT_INSERT_FIELDS32(0, 31, __VA_ARGS__);	\
> +	(oword).u32[1] = EFCT_INSERT_FIELDS32(32, 63, __VA_ARGS__);	\
> +	(oword).u32[2] = EFCT_INSERT_FIELDS32(64, 95, __VA_ARGS__);	\
> +	(oword).u32[3] = EFCT_INSERT_FIELDS32(96, 127, __VA_ARGS__);	\
> +	} while (0)
> +
> +#define EFCT_POPULATE_QWORD32(qword, ...) do {				\
> +	(qword).u32[0] = EFCT_INSERT_FIELDS32(0, 31, __VA_ARGS__);	\
> +	(qword).u32[1] = EFCT_INSERT_FIELDS32(32, 63, __VA_ARGS__);	\
> +	} while (0)
> +
> +#define EFCT_POPULATE_DWORD(dword, ...) (dword).word32 = EFCT_INSERT_FIELDS32(0, 31, __VA_ARGS__)
> +
> +#if BITS_PER_LONG == 64
> +#define EFCT_POPULATE_OWORD EFCT_POPULATE_OWORD64
> +#define EFCT_POPULATE_QWORD EFCT_POPULATE_QWORD64
> +#else
> +#define EFCT_POPULATE_OWORD EFCT_POPULATE_OWORD32
> +#define EFCT_POPULATE_QWORD EFCT_POPULATE_QWORD32
> +#endif
> +
> +/* Populate an octword field with various numbers of arguments */
> +#define EFCT_POPULATE_OWORD_10 EFCT_POPULATE_OWORD
> +#define EFCT_POPULATE_OWORD_9(oword, ...) \
> +	EFCT_POPULATE_OWORD_10(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_8(oword, ...) \
> +	EFCT_POPULATE_OWORD_9(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_7(oword, ...) \
> +	EFCT_POPULATE_OWORD_8(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_6(oword, ...) \
> +	EFCT_POPULATE_OWORD_7(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_5(oword, ...) \
> +	EFCT_POPULATE_OWORD_6(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_4(oword, ...) \
> +	EFCT_POPULATE_OWORD_5(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_3(oword, ...) \
> +	EFCT_POPULATE_OWORD_4(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_2(oword, ...) \
> +	EFCT_POPULATE_OWORD_3(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_OWORD_1(oword, ...) \
> +	EFCT_POPULATE_OWORD_2(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_ZERO_OWORD(oword) \
> +	EFCT_POPULATE_OWORD_1(oword, EFCT_DUMMY_FIELD, 0)
> +#define EFCT_SET_OWORD(oword) \
> +	EFCT_POPULATE_OWORD_4(oword, \
> +			     EFCT_DWORD_0, 0xffffffff, \
> +			     EFCT_DWORD_1, 0xffffffff, \
> +			     EFCT_DWORD_2, 0xffffffff, \
> +			     EFCT_DWORD_3, 0xffffffff)
> +
> +/* Populate a quadword field with various numbers of arguments */
> +#define EFCT_POPULATE_QWORD_10 EFCT_POPULATE_QWORD
> +#define EFCT_POPULATE_QWORD_9(qword, ...) \
> +	EFCT_POPULATE_QWORD_10(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_8(qword, ...) \
> +	EFCT_POPULATE_QWORD_9(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_7(qword, ...) \
> +	EFCT_POPULATE_QWORD_8(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_6(qword, ...) \
> +	EFCT_POPULATE_QWORD_7(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_5(qword, ...) \
> +	EFCT_POPULATE_QWORD_6(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_4(qword, ...) \
> +	EFCT_POPULATE_QWORD_5(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_3(qword, ...) \
> +	EFCT_POPULATE_QWORD_4(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_2(qword, ...) \
> +	EFCT_POPULATE_QWORD_3(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_QWORD_1(qword, ...) \
> +	EFCT_POPULATE_QWORD_2(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_ZERO_QWORD(qword) \
> +	EFCT_POPULATE_QWORD_1(qword, EFCT_DUMMY_FIELD, 0)
> +#define EFCT_SET_QWORD(qword) \
> +	EFCT_POPULATE_QWORD_2(qword, \
> +			     EFCT_DWORD_0, 0xffffffff, \
> +			     EFCT_DWORD_1, 0xffffffff)
> +/* Populate a dword field with various numbers of arguments */
> +#define EFCT_POPULATE_DWORD_10 EFCT_POPULATE_DWORD
> +#define EFCT_POPULATE_DWORD_9(dword, ...) \
> +	EFCT_POPULATE_DWORD_10(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_8(dword, ...) \
> +	EFCT_POPULATE_DWORD_9(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_7(dword, ...) \
> +	EFCT_POPULATE_DWORD_8(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_6(dword, ...) \
> +	EFCT_POPULATE_DWORD_7(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_5(dword, ...) \
> +	EFCT_POPULATE_DWORD_6(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_4(dword, ...) \
> +	EFCT_POPULATE_DWORD_5(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_3(dword, ...) \
> +	EFCT_POPULATE_DWORD_4(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_2(dword, ...) \
> +	EFCT_POPULATE_DWORD_3(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_POPULATE_DWORD_1(dword, ...) \
> +	EFCT_POPULATE_DWORD_2(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFCT_ZERO_DWORD(dword) \
> +	EFCT_POPULATE_DWORD_1(dword, EFCT_DUMMY_FIELD, 0)
> +#define EFCT_SET_DWORD(dword) \
> +	EFCT_POPULATE_DWORD_1(dword, EFCT_DWORD_0, 0xffffffff)
> +
> +/* Modify a named field within an already-populated structure.  Used
> + * for read-modify-write operations.
> + */
> +
> +#define EFCT_INSERT64(min, max, low, high, value)			\
> +	cpu_to_le64(EFCT_INSERT_NATIVE(min, max, low, high, value))
> +
> +#define EFCT_INSERT32(min, max, low, high, value)			\
> +	cpu_to_le32(EFCT_INSERT_NATIVE(min, max, low, high, value))
> +
> +#define EFCT_INPLACE_MASK64(min, max, low, high)				\
> +	EFCT_INSERT64(min, max, low, high, EFCT_MASK64((high) + 1 - (low)))
> +
> +#define EFCT_INPLACE_MASK32(min, max, low, high)				\
> +	EFCT_INSERT32(min, max, low, high, EFCT_MASK32((high) + 1 - (low)))
> +
> +#define EFCT_SET_OWORD64(oword, low, high, value) do {			\
> +	(oword).u64[0] = (((oword).u64[0]				\
> +			   & ~EFCT_INPLACE_MASK64(0,  63, low, high))	\
> +			  | EFCT_INSERT64(0,  63, low, high, value));	\
> +	(oword).u64[1] = (((oword).u64[1]				\
> +			   & ~EFCT_INPLACE_MASK64(64, 127, low, high))	\
> +			  | EFCT_INSERT64(64, 127, low, high, value));	\
> +	} while (0)
> +
> +#define EFCT_SET_QWORD64(qword, low, high, value)			\
> +	(qword).u64[0] = (((qword).u64[0]				\
> +			   & ~EFCT_INPLACE_MASK64(0, 63, low, high))	\
> +			  | EFCT_INSERT64(0, 63, low, high, value))	\
> +
> +#define EFCT_SET_OWORD32(oword, low, high, value) do {			\
> +	(oword).u32[0] = (((oword).u32[0]				\
> +			   & ~EFCT_INPLACE_MASK32(0, 31, low, high))	\
> +			  | EFCT_INSERT32(0, 31, low, high, value));	\
> +	(oword).u32[1] = (((oword).u32[1]				\
> +			   & ~EFCT_INPLACE_MASK32(32, 63, low, high))	\
> +			  | EFCT_INSERT32(32, 63, low, high, value));	\
> +	(oword).u32[2] = (((oword).u32[2]				\
> +			   & ~EFCT_INPLACE_MASK32(64, 95, low, high))	\
> +			  | EFCT_INSERT32(64, 95, low, high, value));	\
> +	(oword).u32[3] = (((oword).u32[3]				\
> +			   & ~EFCT_INPLACE_MASK32(96, 127, low, high))	\
> +			  | EFCT_INSERT32(96, 127, low, high, value));	\
> +	} while (0)
> +
> +#define EFCT_SET_QWORD32(qword, low, high, value) do {			\
> +	(qword).u32[0] = (((qword).u32[0]				\
> +			   & ~EFCT_INPLACE_MASK32(0, 31, low, high))	\
> +			  | EFCT_INSERT32(0, 31, low, high, value));	\
> +	(qword).u32[1] = (((qword).u32[1]				\
> +			   & ~EFCT_INPLACE_MASK32(32, 63, low, high))	\
> +			  | EFCT_INSERT32(32, 63, low, high, value));	\
> +	} while (0)
> +
> +#define EFCT_SET_DWORD32(dword, low, high, value)			\
> +	  (dword).word32 = (((dword).word32				\
> +			   & ~EFCT_INPLACE_MASK32(0, 31, low, high))	\
> +			  | EFCT_INSERT32(0, 31, low, high, value))	\
> +
> +#define EFCT_SET_OWORD_FIELD64(oword, field, value)			\
> +	EFCT_SET_OWORD64(oword, EFCT_LOW_BIT(field),			\
> +			 EFCT_HIGH_BIT(field), value)
> +
> +#define EFCT_SET_QWORD_FIELD64(qword, field, value)			\
> +	EFCT_SET_QWORD64(qword, EFCT_LOW_BIT(field),			\
> +			 EFCT_HIGH_BIT(field), value)
> +
> +#define EFCT_SET_OWORD_FIELD32(oword, field, value)			\
> +	EFCT_SET_OWORD32(oword, EFCT_LOW_BIT(field),			\
> +			 EFCT_HIGH_BIT(field), value)
> +
> +#define EFCT_SET_QWORD_FIELD32(qword, field, value)			\
> +	EFCT_SET_QWORD32(qword, EFCT_LOW_BIT(field),			\
> +			 EFCT_HIGH_BIT(field), value)
> +
> +#define EFCT_SET_DWORD_FIELD(dword, field, value)			\
> +	EFCT_SET_DWORD32(dword, EFCT_LOW_BIT(field),			\
> +			 EFCT_HIGH_BIT(field), value)
> +
> +#if BITS_PER_LONG == 64
> +#define EFCT_SET_OWORD_FIELD EFCT_SET_OWORD_FIELD64
> +#define EFCT_SET_QWORD_FIELD EFCT_SET_QWORD_FIELD64
> +#else
> +#define EFCT_SET_OWORD_FIELD EFCT_SET_OWORD_FIELD32
> +#define EFCT_SET_QWORD_FIELD EFCT_SET_QWORD_FIELD32
> +#endif

EFCT_SET_OWORD_FIELD and EFCT_SET_QWORD_FIELD are appear to
be unused in this patchst. I did not look carefully for other
unused defines.

> +
> +/* Static initialiser */
> +#define EFCT_OWORD32(a, b, c, d)				\
> +	{ .u32 = { cpu_to_le32(a), cpu_to_le32(b),	\
> +		   cpu_to_le32(c), cpu_to_le32(d) } }
> +
> +#endif /* EFCT_BITFIELD_H */

I'm stopping my review here (because I've run out of time for now).
