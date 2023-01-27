Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4A367E3B1
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbjA0LlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjA0LlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:41:10 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2138.outbound.protection.outlook.com [40.107.220.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5E7F777
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:40:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5co+rRYmLzl26TFQSQsULGSCeNQJdb2VsIMqcN/h4Sa91HZ/JrsxhU4guA5jgA4A6M5palp26nsvCuRfb4StQ83PQt8nIkXJab6ESATFKetpD7vHZ049JNtF6Y8/H1bgUX2yRFz3g1hZRclBL3ujzx/tz6rN4wIz9TFfmi+ayNOn8HnMds5vKkCmkzLzVXVCf/8DALNOLrb/6QRMRapcqCA5EFDd1VjEXPetq/78JzrQjn+tQn5yeyQmyclC7Stbe6s5kby3QdUG2jbV5PzoX+VKGG1Ki1ug10mhRdqiqNv2RnDhKXJVq0iBD/+hjWC+Xkf+TIuwX2kgd9BNM/XUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKidWf1xIC04Q5A5QCCTF60QpSCzXDYkqwy+adF2WSo=;
 b=Y6aizuZrk3+61dWQ6ml22BpwB2yO0sRzFlqs4BW6u4m3u2QZEoMgtmYMK9B0LETPHA78gmqTsNWAEkwlL6NLYfGfJVvIODCt6k4+8qOsFubN17nk/6daowsn6wjsfSMstPJFBZ/SEgTRzoGc7YSyD8zW7ghRhQ9+jG6JtADYqyw7xHAfgPLacHqZwYOeXn//PKG8KFkVcrcDReifNo2bR3DPldnlJb8CzjdWIEYGvmMCvseeNKzf+08V8D/Lbb8yxqdHE0XU5JIoi6p6z5hEH75l5+rJf90hQ9zpqpOxTKhP2F+uDx5tu+rzomAeKo1v7lO95oqwuYxH/75wYH2MIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKidWf1xIC04Q5A5QCCTF60QpSCzXDYkqwy+adF2WSo=;
 b=SqvJ91m4whpgfwkTBLdq5LRCRPioVsoD6f0mC5urw/3x96GQMamkpUYuRvRxZrfvifTPFQjwCg83RKGtoB66VFGe1FL1Gp1EJMjVNknJEgI7fliRk1P7db7c+hnCAJPxXjXmk1ZqTQ1Li936f2cpgf6L9Cg0o7NaEm3xOzV1GDk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5706.namprd13.prod.outlook.com (2603:10b6:a03:406::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:32:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 11:32:21 +0000
Date:   Fri, 27 Jan 2023 12:32:12 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, aelior@marvell.com,
        manishc@marvell.com, jacob.e.keller@intel.com, gal@nvidia.com,
        yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: Re: [patch net-next v2 09/12] devlink: protect devlink param list by
 instance lock
Message-ID: <Y9O2PHu7LDljh7sr@corigine.com>
References: <20230126075838.1643665-1-jiri@resnulli.us>
 <20230126075838.1643665-10-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126075838.1643665-10-jiri@resnulli.us>
X-ClientProxiedBy: AM4PR0101CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5706:EE_
X-MS-Office365-Filtering-Correlation-Id: ad98175c-2959-49bb-bed6-08db005a2719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EZ/QVyqA+HonI8CoH7H9WiQfExjB12xQ+otpyrAT4OWxaURDEx+Nn2zGj4ZXPKPY8GSWUhQVKIEOowLctc0wgzOQnwH7MC6YQcMecYKWEQXa7iVivoB5ETyDshezHmOcUvyHvhsBcX3ikJFUOfXoYG57gDtDutM5lVGkGlYqeCmzbYWMnfOYmu8DB44ovWcI5EYeTBIb6B+dtkm0G9ieboS8JLaBVVbhUWVsJXU3sCUIQPtoSk2SdGRFdilToW/VLj4c3C2mJUa2kg5D8IkiMLHFjsRO2qyR2eJzIlCM85ePW6UhZQX0HTIc1J0JGTLzUXbGRKAfrZnRWE4uYBw8RibHAYU+GPOzSIRCrOc4bRyst537Le6DVj/LYquh1724qoNbBgfBcfi3e4Uhc9sV78MMW1DzOUjCrOgbUIJmAxd45s4TEYP4b8bPAyIJkzfO/DF/+ICjjrxc2hglkg7mxDzElEoL8aVwgV9fLqXnn9enS44RrG4LKlvQpISTHPPmYw7c9gQ6omeZWgGfBbClVDTFr8D+P5GxmivQMLNfOtChp/jWHc3FAuTeQ5Za4OR37rW/DwlCO7SeKRw+b+2s+p23LHV4n8hd9+n0qE9AT4vrsBes7Ux6y643ndhBx2WJM6wBE6sYRESzYzo0vG4QzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(346002)(376002)(39830400003)(451199018)(6486002)(186003)(478600001)(6512007)(2616005)(83380400001)(6666004)(316002)(41300700001)(8676002)(38100700002)(6506007)(7416002)(8936002)(86362001)(44832011)(4326008)(66946007)(5660300002)(66556008)(66476007)(6916009)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6jyHJDbnOY39ssB/icYPhB8E5s57NfGEzojQz/qApfwx3+AgqjVvf96SxcFE?=
 =?us-ascii?Q?tNVnEM1pE4AWKEvwfbztwUywQWV9u+tc5s4eyEmoztOlUSyMykP2k5FAtG2k?=
 =?us-ascii?Q?rS4cfFU+E1ifZdf9CsI3aCS2bOU3RQzBB9GPZtlodiGV7n3slLAC6WPb+36F?=
 =?us-ascii?Q?LevdfUyxmts5fBJv648r07TuzGBSTMktx0ALjyVCU4p9h65y6KGV2ZAQyXBO?=
 =?us-ascii?Q?NjoVtabEZbh9ZfsJlH58A4EKWwYtUkY601kka+mDhAUSbb9Yn521+11o7G5n?=
 =?us-ascii?Q?UqGEFsJJ6jViI4m/A4AJsv0slMV1X6GtRUkmav3pRqldN5KaTdlQgMptaHiP?=
 =?us-ascii?Q?O3kfzu0p7Iaspdqt+lEORa2OiWNTm4PtnEjIUPlXXU/wmzk9feuXnoDmEmPz?=
 =?us-ascii?Q?QQj2N9Y99pMPdpzs2zULDN1bnFoJiTFpjYFeE533/fWEogmgRc61aOUgY4oe?=
 =?us-ascii?Q?aq8zezX/7TmUo2pLaRD+SVoRFYHqymOpjRL/fjT7rYZzKQkvJtD2Bz3VLuXX?=
 =?us-ascii?Q?jmDvYtU/83AYz8m+591dbTqsIAG7zoMNoER920t9QnGgdlik9o0Sh7jUUL87?=
 =?us-ascii?Q?+9DCvvSv8cJVLCu+PyhRDy6+OXZFaiz0sxGb30462lkjf4XDp5Mxn9dUxM0J?=
 =?us-ascii?Q?kym5oG3L40b9uW8k8//KrCgjaLu075EPJqMI7jpSPPxqbBSw6pzl/CYuXe3Y?=
 =?us-ascii?Q?TQr5CI9hgrSSdW0GIKWoQLBnJXiXcnTc1b4eoh17aAMHAA+UGFkr0GcZf3zG?=
 =?us-ascii?Q?RSd7et1+FdNE9Bgk9znwhNytptFqk7N2gDPTiPcqxFkxJDWm4iaz5q/hXvA3?=
 =?us-ascii?Q?7H4CKN+YXgj+s5w1rPHbbR+nbC+tLVCxSSm9VGkINhwMFH2g96pT5+Tg/7QH?=
 =?us-ascii?Q?yJP3EgbjwvP+LI4QZsgWRy8MSSd23senWjTojCkkj50u6C6N6HSDjIg81ToS?=
 =?us-ascii?Q?u6JOL9RYCUVTQwpI2gOlXKqCi/Wa104+PEY8xH7NrBmenGz2UfA+mygoQ1JO?=
 =?us-ascii?Q?jjh1Mw+dZz2FV9yor/qmndqumVoV63meDFP0e6vJJiX9eCEJcLJ6LF7GJOzT?=
 =?us-ascii?Q?uKf2VVAoZp+EfeqcJxDosFTloaTEAS7Rck8y6B1i4uCaN9K9N9HEv5kAaJkN?=
 =?us-ascii?Q?B9OBINYgn74EcW5buMsenh4TWp/wAoUfs1C7dgdx4ddAVqFqroXWuqZ6ke/g?=
 =?us-ascii?Q?0FhA27yKyqG5FXV7I5qunJewWetPwzDGZesR/pDXESRuRcm7ccm9LMop2A0K?=
 =?us-ascii?Q?UJYa0asedBvUlxsZZMxQnFs3iuFr7bLCgSQDiM4Mq4X59f64GhG6eQ4SwKSr?=
 =?us-ascii?Q?SIeM0ytWF0BHSWo3z/VNMFHNDdJQ2hNf2t1jEUwDLxT/6OpnqPE5jXJjXZ+N?=
 =?us-ascii?Q?8ELA10MypyG7h+7hjFdihCiG5BfzKXQtRkmiBcnS815mCevZ6Ze56ndgqMg+?=
 =?us-ascii?Q?NQwp97RpyvqCaY8kRzJDecg1fBmr3YVd94dHkqnspU0oIVzdk3F9PePWjiv7?=
 =?us-ascii?Q?wB+Tr2m0KuLvIzUj/XyT4ZVufUK32q/zUIa4HLTvTKgeS0HaSjBzxz+Ff4X5?=
 =?us-ascii?Q?HfP5hG8JuzXuSvKps0I6Axm5PmG+t0sW4+3ZPkbutQPs0lCDKenk3RZQEQ+N?=
 =?us-ascii?Q?Nb2qh8xBzLcSqjTMOb2BwjpUjJweU1uVId99FvjAzaK5FBImpPInQfsb0VSP?=
 =?us-ascii?Q?SkHuww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad98175c-2959-49bb-bed6-08db005a2719
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:32:20.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XGlLn5kb6fQh3SrsBlWkAF6SgZuLF0AxBbEQR0XG8sop72BsZcq3WMHkmw3/UF3QlTyIFH03XtGZazMa077IfAw/Al299ZZBtdjU7GE8Mds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5706
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 08:58:35AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Commit 1d18bb1a4ddd ("devlink: allow registering parameters after
> the instance") as the subject implies introduced possibility to register
> devlink params even for already registered devlink instance. This is a
> bit problematic, as the consistency or params list was originally
> secured by the fact it is static during devlink lifetime. So in order to
> protect the params list, take devlink instance lock during the params
> operations. Introduce unlocked function variants and use them in drivers
> in locked context. Put lock assertions to appropriate places.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c     | 80 ++++++++--------
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c | 18 ++--
>  .../net/ethernet/mellanox/mlx5/core/devlink.c | 92 +++++++++----------
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 12 +--
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c |  6 +-
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 12 +--
>  drivers/net/ethernet/mellanox/mlxsw/core.c    | 18 ++--
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    | 16 ++--
>  .../ethernet/netronome/nfp/devlink_param.c    |  8 +-
>  .../net/ethernet/netronome/nfp/nfp_net_main.c |  7 +-
>  drivers/net/netdevsim/dev.c                   | 36 ++++----
>  include/net/devlink.h                         | 16 +++-
>  net/devlink/leftover.c                        | 77 +++++++++++-----
>  13 files changed, 218 insertions(+), 180 deletions(-)

For the nfp portion:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I will also see about getting the patchset tested on NFP hardware.
