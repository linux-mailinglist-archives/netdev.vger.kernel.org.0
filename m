Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7855E5655
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIUWrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIUWrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:47:36 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2118.outbound.protection.outlook.com [40.107.20.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CB1A3D68
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGioH4pSvLc7UpPJvlFo6vMAoMcwrPXe1D70QnKOycI1hD/1W/z0nC9gZbrwzYSn7edKu+oS03uZ6gYgrCan4TSZ9WgH76m3fRoyZ3ng7EevaDGvTMaPUAnBP5cSpCVai02UutRdFC0+Mhdo4Tq0NzqqxwdhyuIw/H/0a45CfNchT4IHaDm/EfPTANyfN65nFjk/W5guhjdVrSn3PiinbLC2I9yhQGSFXuYME/BwpRZvIqWD/8UWWzHViKXifdrdfuniQjSEbp9isSlorIgakuklncxwqHLq18lt34WzWnyUH+czrbhHCEX63aWS7th8DHOmGdt2+VkFy3uN47lOpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jt93g43JJGwN1lSsonHoAqKiJLqJuJUSDi4RgKvmZLQ=;
 b=RNAwpBGInCn0jXSf+vG22OddPqN0N+jqrYiBe1YMGtztIH82W7zHhk+/FeDxPcNFMwtFsHNWqzKH5RfHf79mSLeUM2LLnl6vdPB6Fd1+NeiPSliaAYODHrRTA6XlsTnmhf5/kSqtGYVKKrwrIA4UMegE0TMzTPOufS2YtyvPmeKZNUo8BYh2B6gqpDXO49QY0f5ue0Uhb0S8I596Iwi2+fp/PGyBHpYijRrxDgKeoChMWJ0INXaHivU4Le+2ahs0ZRIP7Vr8N0nUfYez+XgumAxdmhAbR+/TibmxUqUc6FxKrnLI5bcdmi1hylnNYXeeZt7LN6lrb6SW1LPiPWMOjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt93g43JJGwN1lSsonHoAqKiJLqJuJUSDi4RgKvmZLQ=;
 b=lRRNE0Dpd8j5kMB6xMunh6VpF3Cv5MZYH+Xc+sNLehymKR9ejqvVrZqK7sYyqqi1fB5z6FYnLGq1J22mq11msvXIbrji89CsyUElp7e4vdmdOpohWy0DdBnG9aeeCYPE/vHjR4BTQ7QhLyg0BRjo1B75BnSAXr5T+OwhAefXo8w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by DB8P190MB0665.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:121::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 22:47:27 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5654.017; Wed, 21 Sep 2022
 22:47:27 +0000
Date:   Thu, 22 Sep 2022 01:47:23 +0300
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Liang He <windhl@126.com>, tchornyi@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     taras.chornyi@plvision.eu, oleksandr.mazur@plvision.eu
Subject: Re: [PATCH] net: marvell: Fix refcounting bugs in
 prestera_port_sfp_bind()
Message-ID: <YyuUey3ZsLgJlO0a@yorlov.ow.s>
References: <20220921133245.4111672-1-windhl@126.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921133245.4111672-1-windhl@126.com>
X-ClientProxiedBy: AS8P189CA0043.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:458::24) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|DB8P190MB0665:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d376d24-3f3a-4461-3f79-08da9c234238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gegtzn5dzed9jMhrAxeZJ33w9FXHGevIi4qTFmOX3r8LIyqNsI9tsQvI52iVTiZEQayH2u6ULo7Us04fUrLuiYxUxItlEjv5i6gYMKXnHh9Tnqvo+CFEasr4yPk8V9Sx+9MklLalTjYVgkmTxJP5HSsly6t/4HUpHHx3I2J3i0HDn2h1lGttsXYMfIm9bbNZbEUU7R+ukStpmKpsWmHNPI8mhzdmZYzKoFp6Nh3MPvvUlpnWUDul/pLka8BF7UmVmmjAY4+ubZhIUWq6THlGbdvjoanTcyKXZl0u94fu+2m+JBZ+Y/ulGRnpyC1W/qW5HpndqM0vVhfL71FTd9EsJkbZ+L48/VQHrsC3Bm/spKwuOWU0eRdmbSbpdI4i1KqogV/xkyt86q21m3iCNzsyazaxSf5FR0gLDthrJRwZJtq83P+Z31/C/M4jt4X9QkYaTOyk4mEHPkxGoBX54wfvT9W/STGlqpdYJ61Yb+o6QXTfPRVsdCyo5kSeru+LZr+XPDmA7tRAbotao5dgGMOBIgUsr8PAmKn3WCnLFLscjXYBmK/fphif582x0GfoXlqCU2B5aUJQwWzDVFBfAEWTr4K+5hUaXPu2GYNx5iEH4RSnhM6ZkKTpm2XLJlcdgWgP0InTrP3LR6dmD9zcYUyK6FD2oYB/4DUiZb8cH7MSYiS0Hd22bzZjcMJC72qZ2IphiQqZ2p/yMU1D8+KSofVidlUEmH2PAgkUnoj8ThzL74Nt1RwOjWQ51bQiB7Br3FDwQoZnRNYZD2tcMHrYVWjER/J4JzoUMPAUdYM8rNLLMg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39830400003)(376002)(396003)(346002)(451199015)(186003)(9686003)(44832011)(4744005)(316002)(8936002)(86362001)(66946007)(66476007)(4326008)(5660300002)(66556008)(8676002)(38350700002)(41300700001)(6666004)(107886003)(478600001)(38100700002)(6506007)(6486002)(6512007)(52116002)(26005)(2906002)(525324003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MritZEkj6hrhrrIfln99KX7aJYoQOvnLtzAuwtJLBfwk3KPQCNTq/IbQZ6+8?=
 =?us-ascii?Q?FN9JBUt+c0uCIl4yawguGeAka4u9nHKL6hj/5Wz7jf507km3mDPYQOep0/Rm?=
 =?us-ascii?Q?gLYCBYc6HIOiVSIZnTenYHaUMOGiPL15jK+rjjpW2Do3N3zP//ESiPSSHvEc?=
 =?us-ascii?Q?Kc20Lr5WJRjjCACR6JjLwG18qVDClsenJfBVIhU6/8/BvVB2VjI7p69+g+hf?=
 =?us-ascii?Q?l/jw4LFdoR48KYhV0+S6QSualRBd6O8uVj7bizVleUYicja2/nEu82VEOuHT?=
 =?us-ascii?Q?2y4hYrWm6/ClV25AwGzW8CuCKEIGcYAheD64i3eb2V+eZV2g2Kyy9x3XcJw4?=
 =?us-ascii?Q?zEmHwUr8i1DEwc6vE3PfstkKfBQh6QWo7fF1hMur8HHjDGfm1IDDpBw6XM6O?=
 =?us-ascii?Q?35XsW5+KqXiLufNQMW13RqC1+iSMNeFWt2kbL8db81Hs1tmKLuN82uVXvy/Y?=
 =?us-ascii?Q?GEYZEGYfyzmmf06Y4HYxwFmd9hFFX/2XN/OFr9i55WE3bxr9a/2cOI5GHJjB?=
 =?us-ascii?Q?QNI2AIYHOwT33JvmFOLjL65XWKljSDj87R/s+ToMvm/Q1oMFg/0Nxk0rqE6g?=
 =?us-ascii?Q?+bKEN8namYBFr5OBQIw1g6JCyPHczbuO5XeNi/GmfC35Qro3n8y5pL9pxKEZ?=
 =?us-ascii?Q?bMycVSgZzqMnQDoRKCM7m9KGLtPtRY+HhYyZsfnLROIITPnqezACQ3W8FGdd?=
 =?us-ascii?Q?RSA0BJ0cK6DOnn6H/eQ+sKKf1/MrnT3kEG4291TkMo5c1HKG5WYYtCLecNIk?=
 =?us-ascii?Q?4cds7ArcKICXnUvx4Bz/KgKU1A/7AA2gw3ebHK27Bkre7b3oDdSUHF7gmR+U?=
 =?us-ascii?Q?bXYLMvHU3UJCScG87VI+UktGPnn9hbEYBw1z4QuJV1ZyQtVaRh9Nz8/MVrRt?=
 =?us-ascii?Q?3q4JhNwvMcHDGWEQ3Brf2sk2ZipqZ1c/mm2Ny+gifT3GkO+cEhwtUNMfBkNN?=
 =?us-ascii?Q?7QfID9jbW7CDkgFeP+yth6Tj5b8AXbboY11BpYCoaNIVkvWZauMY/9apZrwY?=
 =?us-ascii?Q?yT3eEjdRH3qmynAbmrYbpBNfm79flhqiTNSrkiE4lMfC1Q9T1/KAvbEIhK0r?=
 =?us-ascii?Q?JKmRliqrV/2a7/8A2Pu17WSFsdm9IhIVxrNXuIxb9g9zlDTKq/QqdE9Pda3b?=
 =?us-ascii?Q?K9WNKAJXd1b5Xg4/+X3S+nIo+HDAu9Tb4w1X7hTBrI52ysnbX8rLT9MDfr0d?=
 =?us-ascii?Q?UHIlXtl+Ma4l3fPKCTEU2S8YqG6YuImJYlku8QbdMkoCc82VNKXyyN/XG+nq?=
 =?us-ascii?Q?LTThdBYSfxoTkA4MbJJNE+WO/2c/Y8pINr7oSlsU5BspoPU3npiM65avnqDv?=
 =?us-ascii?Q?IlZ+uXU8zs5xIiLBGjlDZ2ij7W9rxUcpr2yYokbaTMABg+2qTlsE7M4+oBIz?=
 =?us-ascii?Q?ZdepzafUvkZqgFzzhuXvJ56BXUnYT3fWUdpJiBLRBEtUQGwuS+7+nzL6CdHA?=
 =?us-ascii?Q?PLfQYXZU2jSPgtX8am2bW+O1EYmKYCE2IqwlgcizFe670XCc/DtIXpQdDRXz?=
 =?us-ascii?Q?rbFJUBayRTaCPyMy4o136BOOx8P+GSWaGzwu7S4/GT5IGqJzlwnn/josjQwf?=
 =?us-ascii?Q?47V8UnjEqvf91h/PpbzVhgCXyBajGmXeo7CXRUyYzVkoqhKrG2RltbO62Uoh?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d376d24-3f3a-4461-3f79-08da9c234238
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 22:47:27.6367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQzwNrurYvDbNj1rvT2suyQ9GFibARdhvIdel6NPW25Tlf5c0mqaibliGdliru7B4my/MeLloBy+RokKnvbgOrATA6mFSftxZ96tuQglq7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0665
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 09:32:45PM +0800, Liang He wrote:
> In prestera_port_sfp_bind(), there are two refcounting bugs:
> (1) we should call of_node_get() before of_find_node_by_name() as
> it will automaitcally decrease the refcount of 'from' argument;
> (2) we should call of_node_put() for the break of the iteration
> for_each_child_of_node() as it will automatically increase and
> decrease the 'child'.
> 
> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  it will be safe to call of_node_put() at the end of the function as
> the of_node_put() can handle NULL.
> 
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
