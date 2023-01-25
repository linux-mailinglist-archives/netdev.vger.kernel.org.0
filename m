Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2723F67BE3A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbjAYVZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbjAYVZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:25:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AEE45BC1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:25:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lnhpo21FpphOzmaDAfl81B8gydO7ylEAjllpSCL9j2NQXypV0ea0P3qxHzjKl3XW1LCZrr6tslBtaj/+BmPTiaUmeO/IVnn6XGE3aDzufX/gvqi2uMuFEC7nebhT7IGtBcr4+rtkC3AX8Go6GP3OXz0SKmFylI+vNFy7d+H2nO57rLglX9iowzFdZyLP/xT9ogqYE+Dk9x0K+4ldXhaYjQZHvkNHTXEaynNXQ1CBuv+ShanT8TdOPd65XPPmzqHw7FtVmqqdLgeEPtaa4l5Z+I5MLIv8drsg6a+dDd2TRlxE89ERy/noVZtFNDoGt5Htz2MC2iza229fqxh+n2KGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1rnGJEQN0B4X9yVcAzGqkO/WD5qlwCKn4qgxdrVEWA=;
 b=HLYg8TR4ygtQxl359sl7o22dgNNq7h/xLl0kLWfMs9JqkydCROcJYDCHtehFT0u8DKJu9WL2z4zsgh7SSUHKZXxnAor2g9R9wX5VRbZYiRgIYNogHwMB5rGh58UAsaqY5jNsvmftxhcQWqomMbwl1DSN1AlZsUoe5bjp0dWRyOYKjPCaqQ+zM3ceemv+GZw8XorOp/5N5APJNZ4fcPX0toYtELWLNsRWrALY+yPZ8ABQMrYJLAswTxbimzvYEi3HebSepfwNUHSYy1K3LRNIqmkSCs20Zrh4/X3FvN6O8GT234xZY3Pz3DHJ/gHKJ1dI9fW1hHO4d8IyWRDGG6pANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1rnGJEQN0B4X9yVcAzGqkO/WD5qlwCKn4qgxdrVEWA=;
 b=K7yE9OZZiSKH/K/P5hGZLVVm/2er4iVNw27SRF8QC1FOlfoKGmKTZo839lG6LOpph6mp+TZFagJXDxyxBQ/yDaodZGO+fxzchBV3IZZXbCfFd9SSj8F5FVT73FRPLZ+Cdg8c86uDoI0zxoEGJkQxzRjwTDp46Vio15bxQLI/brKyk/qVpgwUP3u/U1aOiK2SlE2UcrU9SDQIQXyExZ8qCI+iEK0zmWouzGw0yTOZA7fCBPwcwK8gMIaKPK+lD4ZkGBu8kTN+LxkAuQCkSDaHkEMfBKRt5xfPIgEbJyk8NOa7h2aTxM+WjhEywP1cyEG6lmUCbXqjZy7gPC+gIWP2qA==
Received: from CY5PR19CA0052.namprd19.prod.outlook.com (2603:10b6:930:1a::17)
 by DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 21:25:05 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:1a:cafe::7) by CY5PR19CA0052.outlook.office365.com
 (2603:10b6:930:1a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20 via Frontend
 Transport; Wed, 25 Jan 2023 21:25:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16 via Frontend Transport; Wed, 25 Jan 2023 21:25:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 13:24:56 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 13:24:47 -0800
References: <20230124170510.316970-1-jhs@mojatatu.com>
 <20230124170510.316970-17-jhs@mojatatu.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     <netdev@vger.kernel.org>, <kernel@mojatatu.com>,
        <deb.chatterjee@intel.com>, <anjali.singhai@intel.com>,
        <namrata.limaye@intel.com>, <khalidm@nvidia.com>, <tom@sipanda.io>,
        <pratyush@sipanda.io>, <jiri@resnulli.us>,
        <xiyou.wangcong@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next RFC 17/20] p4tc: add table entry create,
 update, get, delete, flush and dump
Date:   Wed, 25 Jan 2023 23:20:42 +0200
In-Reply-To: <20230124170510.316970-17-jhs@mojatatu.com>
Message-ID: <87bkmmcnoj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|DM6PR12MB4234:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c3a2204-635e-4cd4-6ef3-08daff1a9f71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVYcIQY2pI+ZOurU3E5R5TT6ptQcVWtHslTsAES99RpcGu2o0uxOHvQ1zIvlgGTD8PJAHHc51g3e7nlfJaI5tG4d2uEEGJ/5bzexMMTDpEZNdTVlvdYrS07fMmlr9pGOJAnRxfcLzLlm+FAT2JKlG/0i65mqlX+y0JvSvmX1Uw8Ccs2/rC6+KClwA+VUxJ4q2xhrXybgK8ZKNGycqsgbHrliwEUKF3o2FUwPpVDeDl4j75w1PmUJ4HTlRN2AC86IkklG3jyuY2U5zBAnNIBFBsEue7JA9cwo7+xhNjp9T4etqTbWIj8z65MfRnDIAVoEFux6405EJrkml7GzhLEgqXXkwOOB4YMfDJLqOSWbA0FFC4WRdQsI8VhoGVqPlp9ZQWwy8yf6ppm6Vp1oqObb7u+f3GQNnlFXzNyV1uwhsw6ZLqB/BDSEK/pKExYg6S6OEwQfwDUJF4RoN4aMlIitF5uXdytbDtTlRnUFwfgUXr4gbm3i+MeI8idx8Hfwqj5v5PT325ZuI4IN9CfTk3Vc6sm7l2LgC97t8883a048oVQJwOS20IZ9c0vdUSk8YtICtI7HTHXFI30ruKoTELLxxGaGzBzTcHEne/8/HGTqxBGVYhkEdUjA4BzwwGRMHg71IHyFW4e1w8ErJDozR3e72mHD1d9F5oBhFvGK5om924E76J0T4aCBhy/ijqNzgHxiSq7nemT2MREeTKHK0KT+8HxZZ13VZPjKgJp5f8Oy2k4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(70206006)(70586007)(36860700001)(8676002)(6916009)(316002)(86362001)(36756003)(54906003)(8936002)(5660300002)(336012)(47076005)(82740400003)(82310400005)(426003)(2906002)(40460700003)(4326008)(41300700001)(30864003)(15650500001)(40480700001)(26005)(6666004)(186003)(2616005)(7636003)(478600001)(7416002)(7696005)(356005)(83380400001)(16526019)(32563001)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 21:25:03.4027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3a2204-635e-4cd4-6ef3-08daff1a9f71
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4234
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Jan 2023 at 12:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> Tables are conceptually similar to TCAMs and this implementation could be
> labelled as an "algorithmic" TCAM. Tables have keys of specific size,
> maximum number of entries and masks allowed. The basic P4 key types
> are supported (exact, LPM, ternary, and ranges) although the kernel side is
> oblivious of all that and sees only bit blobs which it masks before a
> lookup is performed.
>
> This commit allows users to create, update, delete, get, flush and dump
> table _entries_ (templates were described in earlier patch).
>
> For example, a user issuing the following command:
>
> tc p4runtime create myprog/table/cb/tname  \
>   dstAddr 10.10.10.0/24 srcAddr 192.168.0.0/16 prio 16 \
>   action myprog/cb/send param port type dev port1
>
> indicates a pipeline named "myprog" with a table "tname" whose entry we are
> updating.
>
> User space tc will create a key which has a value of 0x0a0a0a00c0a00000
> (10.10.10.0 concatenated with 192.168.0.0) and a mask value of
> 0xffffff00ffff0000 (/24 concatenated with /16) that will be sent to the
> kernel. In addition a priority field of 16 is passed to the kernel as
> well as the action definition.
> The priority field is needed to disambiguate in case two entries
> match. In that case, the kernel will choose the one with lowest priority
> number.
>
> Note that table entries can only be created once the pipeline template is
> sealed.
>
> If the user wanted to, for example, add an action to our just created
> entry, they'd issue the following command:
>
> tc p4runtime update myprog/table/cb/tname srcAddr 10.10.10.0/24 \
> dstAddr 192.168.0.0/16 prio 16 action myprog/cb/send param port type dev
> port5
>
> In this case, the user needs to specify the pipeline name, the table name,
> the keys and the priority, so that we can locate the table entry.
>
> If the user wanted to, for example, get the table entry that we just
> updated, they'd issue the following command:
>
> tc p4runtime get myprog/table/cb/tname srcAddr 10.10.10.0/24 \
> dstAddr 192.168.0.0/16 prio 16
>
> Note that, again, we need to specify the pipeline name, the table name,
> the keys and the priority, so that we can locate the table entry.
>
> If the user wanted to delete the table entry we created, they'd issue the
> following command:
>
> tc p4runtime del myprog/table/cb/tname srcAddr 10.10.10.0/24 \
>   dstAddr 192.168.0.0/16 prio 16
>
> Note that, again, we need to specify the pipeline name, the table
> type, the table instance, the keys and the priority, so that we can
> locate the table entry.
>
> We can also flush all the table entries from a specific table instance.
> To flush the table entries of table instance named tinst1, from table
> type tname and pipeline ptables, the user would issue the following
> command:
>
> tc p4runtime del myprog/table/cb/tname
>
> We can also dump all the table entries from a specific table instance.
> To dump the table entries of table instance named tinst1, from table
> type tname and pipeline ptables, the user would issue the following
> command:
>
> tc p4runtime get myprog/table/cb/tname
>
> __Table Entry Permissions__
>
> Table entries can have permissions specified when they are being added.
> caveat: we are doing a lot more than what P4 defines because we feel it is
> necessary.
>
> Table entry permissions build on the table permissions provided when a
> table is created via the template (see earlier patch).
>
> We have two types of permissions: Control path vs datapath.
> The template definition can set either one. For example, one could allow
> for adding table entries by the datapath in case of PNA add-on-miss is
> needed. By default tables entries have control plane RUD, meaning the
> control plane can Read, Update or Delete entries. By default, as well,
> the control plane can create new entries unless specified otherwise by
> the template.
>
> Lets see an example of defining a table "tname" at template time:
>
> $TC p4template create table/ptables/cb/tname tblid 1 keysz 64
> permissions 0x3C9 ...
>
> Above is setting the table tname's permission to be 0x3C9 is equivalent to
> CRUD--R--X meaning:
>
> the control plane can Create, Read, Update, Delete
> The datapath can only Read and Execute table entries.
> If one was to dump this table with:
>
> $TC p4template get table/ptables/cb/tname
>
> The output would be the following:
>
> pipeline name ptables id 22
> table id 1
> table name cb/tname
> key_sz 64
> max entries 256
> masks 8
> default key 1
> table entries 0
> permissions CRUD--R--X
>
> The expressed permissions above are probably the most practical for most
> use cases.
>
> __Constant Tables And P4-programmed Defined Entries__
>
> If one wanted to restrict the table to be an equivalent to a "const" then
> the permissions would be set to be: -R----R--X
>
> In such a case, typically the P4 program will have some entries defined
> (see the famous P4 calc example). The "initial entries" specified in the P4
> program will have to be added by the template (as generated by the
> compiler), as such:
>
> $TC p4template update table/ptables/cb/tname
> entry srcAddr 10.10.10.10/24 dstAddr 1.1.1.0/24 prio 17
>
> This table cannot be updated at runtime. Any attempt to add an entry of a
> table which is read-only at runtime will get a permission denied response
> back from the kernel.
>
> Note: If one was to create an equivalent for PNA add-on-miss feature for
> this table, then the template would issue table permissions as: -R---CR--X
> PNA doesn't specify whether the datapath can also delete or update entries,
> but if it did then more appropriate permissions will be: -R----XCRUDX
>
> __Mix And Match of RW vs Constant Entries__
> Lets look at other scenarios; lets say the table has CRUD--R--X permissions
> as defined by the template...
> At runtime the user could add entries which are "const" - by specifying the
> entry's permission as -R---R--X example:
>
> $TC p4runtime create ptables/table/cb/tname srcAddr 10.10.10.10/24 \
> dstAddr 1.1.1.0/24 prio 17 permissions 0x109 action drop
>
> or not specify permissions at all as such:
>
> $TC p4runtime create ptables/table/cb/tname srcAddr 10.10.10.10/24 \
> dstAddr 1.1.1.0/24 prio 17 \
> action drop
>
> in which case the table's permissions defined at template time( CRUD--R--X)
> are assumed; meaning the table entry can be deleted or updated by the
> control plane.
>
> __Entries permissions Allowed On A Table Entry Creation At Runtime__
>
> When an entry is added with expressed permissions it has at most to have
> what the template table definition expressed but could ask for less
> permission. For example, assuming a table with templated specified
> permissions of CR-D--R--X:
> An entry created at runtime with permission of -R----R--X is allowed but an
> entry with -RUD--R--X will be rejected.
>
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/p4tc.h             |   60 +
>  include/uapi/linux/p4tc.h      |   32 +
>  include/uapi/linux/rtnetlink.h |    7 +
>  net/sched/p4tc/Makefile        |    3 +-
>  net/sched/p4tc/p4tc_pipeline.c |   12 +
>  net/sched/p4tc/p4tc_table.c    |   45 +
>  net/sched/p4tc/p4tc_tbl_api.c  | 1898 ++++++++++++++++++++++++++++++++
>  security/selinux/nlmsgtab.c    |    5 +-
>  8 files changed, 2060 insertions(+), 2 deletions(-)
>  create mode 100644 net/sched/p4tc/p4tc_tbl_api.c
>
> diff --git a/include/net/p4tc.h b/include/net/p4tc.h
> index 58be4f96f..9a7942992 100644
> --- a/include/net/p4tc.h
> +++ b/include/net/p4tc.h
> @@ -123,6 +123,7 @@ struct p4tc_pipeline {
>  	u32                         num_created_acts;
>  	refcount_t                  p_ref;
>  	refcount_t                  p_ctrl_ref;
> +	refcount_t                  p_entry_deferal_ref;
>  	u16                         num_tables;
>  	u16                         curr_tables;
>  	u8                          p_state;
> @@ -234,6 +235,7 @@ struct p4tc_table {
>  	struct rhltable                     tbl_entries;
>  	struct tc_action                    **tbl_preacts;
>  	struct tc_action                    **tbl_postacts;
> +	struct p4tc_table_entry             *tbl_const_entry;
>  	struct p4tc_table_defact __rcu      *tbl_default_hitact;
>  	struct p4tc_table_defact __rcu      *tbl_default_missact;
>  	struct p4tc_table_perm __rcu        *tbl_permissions;
> @@ -321,6 +323,54 @@ extern const struct rhashtable_params p4tc_label_ht_params;
>  extern const struct rhashtable_params acts_params;
>  void p4tc_label_ht_destroy(void *ptr, void *arg);
>  
> +extern const struct rhashtable_params entry_hlt_params;
> +
> +struct p4tc_table_entry;
> +struct p4tc_table_entry_work {
> +	struct work_struct   work;
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_table_entry *entry;
> +	bool defer_deletion;
> +};
> +
> +struct p4tc_table_entry_key {
> +	u8  *value;
> +	u8  *unmasked_key;
> +	u16 keysz;
> +};
> +
> +struct p4tc_table_entry_mask {
> +	struct rcu_head	 rcu;
> +	u32              sz;
> +	u32              mask_id;
> +	refcount_t       mask_ref;
> +	u8               *value;
> +};
> +
> +struct p4tc_table_entry {
> +	struct p4tc_table_entry_key      key;
> +	struct work_struct               work;
> +	struct p4tc_table_entry_tm __rcu *tm;
> +	u32                              prio;
> +	u32                              mask_id;
> +	struct tc_action                 **acts;
> +	struct p4tc_table_entry_work     *entry_work;
> +	int                              num_acts;
> +	struct rhlist_head               ht_node;
> +	struct list_head                 list;
> +	struct rcu_head                  rcu;
> +	refcount_t                       entries_ref;
> +	u16                              who_created;
> +	u16                              who_updated;
> +	u16                              permissions;
> +};
> +
> +extern const struct nla_policy p4tc_root_policy[P4TC_ROOT_MAX + 1];
> +extern const struct nla_policy p4tc_policy[P4TC_MAX + 1];
> +struct p4tc_table_entry *p4tc_table_entry_lookup(struct sk_buff *skb,
> +						 struct p4tc_table *table,
> +						 u32 keysz);
> +
>  struct p4tc_parser {
>  	char parser_name[PARSERNAMSIZ];
>  	struct idr hdr_fields_idr;
> @@ -445,6 +495,16 @@ struct p4tc_table *tcf_table_get(struct p4tc_pipeline *pipeline,
>  				 struct netlink_ext_ack *extack);
>  void tcf_table_put_ref(struct p4tc_table *table);
>  
> +void tcf_table_entry_destroy_hash(void *ptr, void *arg);
> +
> +int tcf_table_const_entry_cu(struct net *net, struct nlattr *arg,
> +			     struct p4tc_table_entry *entry,
> +			     struct p4tc_pipeline *pipeline,
> +			     struct p4tc_table *table,
> +			     struct netlink_ext_ack *extack);
> +int p4tca_table_get_entry_fill(struct sk_buff *skb, struct p4tc_table *table,
> +			       struct p4tc_table_entry *entry, u32 tbl_id);
> +
>  struct p4tc_parser *tcf_parser_create(struct p4tc_pipeline *pipeline,
>  				      const char *parser_name,
>  				      u32 parser_inst_id,
> diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
> index 678ee20cd..727fdcfe5 100644
> --- a/include/uapi/linux/p4tc.h
> +++ b/include/uapi/linux/p4tc.h
> @@ -119,6 +119,7 @@ enum {
>  	P4TC_OBJ_HDR_FIELD,
>  	P4TC_OBJ_ACT,
>  	P4TC_OBJ_TABLE,
> +	P4TC_OBJ_TABLE_ENTRY,
>  	__P4TC_OBJ_MAX,
>  };
>  #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
> @@ -321,6 +322,37 @@ struct tc_act_dyna {
>  	tc_gen;
>  };
>  
> +struct p4tc_table_entry_tm {
> +	__u64 created;
> +	__u64 lastused;
> +	__u64 firstused;
> +};
> +
> +/* Table entry attributes */
> +enum {
> +	P4TC_ENTRY_UNSPEC,
> +	P4TC_ENTRY_TBLNAME, /* string */
> +	P4TC_ENTRY_KEY_BLOB, /* Key blob */
> +	P4TC_ENTRY_MASK_BLOB, /* Mask blob */
> +	P4TC_ENTRY_PRIO, /* u32 */
> +	P4TC_ENTRY_ACT, /* nested actions */
> +	P4TC_ENTRY_TM, /* entry data path timestamps */
> +	P4TC_ENTRY_WHODUNNIT, /* tells who's modifying the entry */
> +	P4TC_ENTRY_CREATE_WHODUNNIT, /* tells who created the entry */
> +	P4TC_ENTRY_UPDATE_WHODUNNIT, /* tells who updated the entry last */
> +	P4TC_ENTRY_PERMISSIONS, /* entry CRUDX permissions */
> +	P4TC_ENTRY_PAD,
> +	__P4TC_ENTRY_MAX
> +};
> +#define P4TC_ENTRY_MAX (__P4TC_ENTRY_MAX - 1)
> +
> +enum {
> +	P4TC_ENTITY_UNSPEC,
> +	P4TC_ENTITY_KERNEL,
> +	P4TC_ENTITY_TC,
> +	P4TC_ENTITY_MAX
> +};
> +
>  #define P4TC_RTA(r) \
>  	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
>  
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 62f0f5c90..dc061ddb8 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -201,6 +201,13 @@ enum {
>  	RTM_GETP4TEMPLATE,
>  #define RTM_GETP4TEMPLATE	RTM_GETP4TEMPLATE
>  
> +	RTM_CREATEP4TBENT = 128,
> +#define RTM_CREATEP4TBENT	RTM_CREATEP4TBENT
> +	RTM_DELP4TBENT,
> +#define RTM_DELP4TBENT		RTM_DELP4TBENT
> +	RTM_GETP4TBENT,
> +#define RTM_GETP4TBENT		RTM_GETP4TBENT
> +
>  	__RTM_MAX,
>  #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
>  };
> diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
> index de3a7b833..0d2c20223 100644
> --- a/net/sched/p4tc/Makefile
> +++ b/net/sched/p4tc/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
> -	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o
> +	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
> +	p4tc_tbl_api.o
> diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
> index 854fc5b57..f8fcde20b 100644
> --- a/net/sched/p4tc/p4tc_pipeline.c
> +++ b/net/sched/p4tc/p4tc_pipeline.c
> @@ -328,7 +328,16 @@ static int tcf_pipeline_put(struct net *net,
>  	struct p4tc_metadata *meta;
>  	struct p4tc_table *table;
>  
> +	if (!refcount_dec_if_one(&pipeline->p_ctrl_ref)) {
> +		if (pipeline_net) {
> +			put_net(pipeline_net);
> +			NL_SET_ERR_MSG(extack, "Can't delete referenced pipeline");
> +			return -EBUSY;
> +		}
> +	}
> +
>  	if (pipeline_net && !refcount_dec_if_one(&pipeline->p_ref)) {
> +		refcount_set(&pipeline->p_ctrl_ref, 1);
>  		NL_SET_ERR_MSG(extack, "Can't delete referenced pipeline");
>  		return -EBUSY;
>          }
> @@ -567,6 +576,9 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
>  	pipeline->net = net;
>  
>  	refcount_set(&pipeline->p_ref, 1);
> +	refcount_set(&pipeline->p_ctrl_ref, 1);
> +	refcount_set(&pipeline->p_hdrs_used, 1);
> +	refcount_set(&pipeline->p_entry_deferal_ref, 1);
>  
>  	pipeline->common.ops = (struct p4tc_template_ops *)&p4tc_pipeline_ops;
>  
> diff --git a/net/sched/p4tc/p4tc_table.c b/net/sched/p4tc/p4tc_table.c
> index f793c70bc..491e44396 100644
> --- a/net/sched/p4tc/p4tc_table.c
> +++ b/net/sched/p4tc/p4tc_table.c
> @@ -234,6 +234,17 @@ static int _tcf_table_fill_nlmsg(struct sk_buff *skb, struct p4tc_table *table)
>  	}
>  	nla_nest_end(skb, nested_tbl_acts);
>  
> +	if (table->tbl_const_entry) {
> +		struct nlattr *const_nest;
> +
> +		const_nest = nla_nest_start(skb, P4TC_TABLE_OPT_ENTRY);
> +		p4tca_table_get_entry_fill(skb, table, table->tbl_const_entry,
> +					   table->tbl_id);
> +		nla_nest_end(skb, const_nest);
> +	}
> +	kfree(table->tbl_const_entry);
> +	table->tbl_const_entry = NULL;
> +
>  	if (nla_put(skb, P4TC_TABLE_INFO, sizeof(parm), &parm))
>  		goto out_nlmsg_trim;
>  	nla_nest_end(skb, nest);
> @@ -381,6 +392,9 @@ static inline int _tcf_table_put(struct net *net, struct nlattr **tb,
>  
>  	tcf_table_acts_list_destroy(&table->tbl_acts_list);
>  
> +	rhltable_free_and_destroy(&table->tbl_entries,
> +				  tcf_table_entry_destroy_hash, table);
> +
>  	idr_destroy(&table->tbl_masks_idr);
>  	idr_destroy(&table->tbl_prio_idr);
>  
> @@ -1075,6 +1089,11 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
>  	spin_lock_init(&table->tbl_masks_idr_lock);
>  	spin_lock_init(&table->tbl_prio_idr_lock);
>  
> +	if (rhltable_init(&table->tbl_entries, &entry_hlt_params) < 0) {
> +		ret = -EINVAL;
> +		goto defaultacts_destroy;
> +	}
> +
>  	table->tbl_key = key;
>  
>  	pipeline->curr_tables += 1;
> @@ -1083,6 +1102,10 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
>  
>  	return table;
>  
> +defaultacts_destroy:
> +	p4tc_table_defact_destroy(table->tbl_default_missact);
> +	p4tc_table_defact_destroy(table->tbl_default_hitact);
> +
>  key_put:
>  	if (key)
>  		tcf_table_key_put(key);
> @@ -1279,6 +1302,25 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
>  		}
>  	}
>  
> +	if (tb[P4TC_TABLE_OPT_ENTRY]) {
> +		struct p4tc_table_entry *entry;
> +
> +		entry = kzalloc(GFP_KERNEL, sizeof(*entry));
> +		if (!entry) {
> +			ret = -ENOMEM;
> +			goto free_perm;
> +		}
> +
> +		/* Workaround to make this work */
> +		ret = tcf_table_const_entry_cu(net, tb[P4TC_TABLE_OPT_ENTRY],
> +					       entry, pipeline, table, extack);
> +		if (ret < 0) {
> +			kfree(entry);
> +			goto free_perm;
> +		}
> +		table->tbl_const_entry = entry;
> +	}
> +
>  	if (preacts) {
>  		p4tc_action_destroy(table->tbl_preacts);
>  		table->tbl_preacts = preacts;
> @@ -1326,6 +1368,9 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
>  
>  	return table;
>  
> +free_perm:
> +	kfree(perm);
> +
>  key_destroy:
>  	if (key)
>  		tcf_table_key_put(key);
> diff --git a/net/sched/p4tc/p4tc_tbl_api.c b/net/sched/p4tc/p4tc_tbl_api.c
> new file mode 100644
> index 000000000..4523ec09b
> --- /dev/null
> +++ b/net/sched/p4tc/p4tc_tbl_api.c
> @@ -0,0 +1,1898 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * net/sched/p4tc_tbl_api.c TC P4 TABLE API
> + *
> + * Copyright (c) 2022, Mojatatu Networks
> + * Copyright (c) 2022, Intel Corporation.
> + * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
> + *              Victor Nogueira <victor@mojatatu.com>
> + *              Pedro Tammela <pctammela@mojatatu.com>
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/skbuff.h>
> +#include <linux/init.h>
> +#include <linux/kmod.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <net/net_namespace.h>
> +#include <net/sock.h>
> +#include <net/sch_generic.h>
> +#include <net/pkt_cls.h>
> +#include <net/p4tc.h>
> +#include <net/netlink.h>
> +#include <net/flow_offload.h>
> +
> +#define KEY_MASK_ID_SZ (sizeof(u32))
> +#define KEY_MASK_ID_SZ_BITS (KEY_MASK_ID_SZ * BITS_PER_BYTE)
> +
> +static u32 p4tc_entry_hash_fn(const void *data, u32 len, u32 seed)
> +{
> +	const struct p4tc_table_entry_key *key = data;
> +
> +	return jhash(key->value, key->keysz >> 3, seed);
> +}
> +
> +static int p4tc_entry_hash_cmp(struct rhashtable_compare_arg *arg,
> +			       const void *ptr)
> +{
> +	const struct p4tc_table_entry_key *key = arg->key;
> +	const struct p4tc_table_entry *entry = ptr;
> +
> +	return memcmp(entry->key.value, key->value, entry->key.keysz >> 3);
> +}
> +
> +static u32 p4tc_entry_obj_hash_fn(const void *data, u32 len, u32 seed)
> +{
> +	const struct p4tc_table_entry *entry = data;
> +
> +	return p4tc_entry_hash_fn(&entry->key, 0, seed);
> +}
> +
> +const struct rhashtable_params entry_hlt_params = {
> +	.obj_cmpfn = p4tc_entry_hash_cmp,
> +	.obj_hashfn = p4tc_entry_obj_hash_fn,
> +	.hashfn = p4tc_entry_hash_fn,
> +	.head_offset = offsetof(struct p4tc_table_entry, ht_node),
> +	.key_offset = offsetof(struct p4tc_table_entry, key),
> +	.automatic_shrinking = true,
> +};
> +
> +static struct p4tc_table_entry *
> +p4tc_entry_lookup(struct p4tc_table *table, struct p4tc_table_entry_key *key,
> +		  u32 prio) __must_hold(RCU)
> +{
> +	struct p4tc_table_entry *entry;
> +	struct rhlist_head *tmp, *bucket_list;
> +
> +	bucket_list =
> +		rhltable_lookup(&table->tbl_entries, key, entry_hlt_params);
> +	if (!bucket_list)
> +		return NULL;
> +
> +	rhl_for_each_entry_rcu(entry, tmp, bucket_list, ht_node)
> +		if (entry->prio == prio)
> +			return entry;
> +
> +	return NULL;
> +}
> +
> +static struct p4tc_table_entry *
> +__p4tc_entry_lookup(struct p4tc_table *table, struct p4tc_table_entry_key *key)
> +	__must_hold(RCU)
> +{
> +	struct p4tc_table_entry *entry = NULL;
> +	u32 smallest_prio = U32_MAX;
> +	struct rhlist_head *tmp, *bucket_list;
> +	struct p4tc_table_entry *entry_curr;
> +
> +	bucket_list =
> +		rhltable_lookup(&table->tbl_entries, key, entry_hlt_params);
> +	if (!bucket_list)
> +		return NULL;
> +
> +	rhl_for_each_entry_rcu(entry_curr, tmp, bucket_list, ht_node) {
> +		if (entry_curr->prio <= smallest_prio) {
> +			smallest_prio = entry_curr->prio;
> +			entry = entry_curr;
> +		}
> +	}
> +
> +	return entry;
> +}
> +
> +static void mask_key(struct p4tc_table_entry_mask *mask, u8 *masked_key,
> +		     u8 *skb_key)
> +{
> +	int i;
> +	__u32 *mask_id;
> +
> +	mask_id = (u32 *)&masked_key[0];
> +	*mask_id = mask->mask_id;
> +
> +	for (i = KEY_MASK_ID_SZ; i < BITS_TO_BYTES(mask->sz); i++)
> +		masked_key[i] = skb_key[i - KEY_MASK_ID_SZ] & mask->value[i];
> +}
> +
> +struct p4tc_table_entry *p4tc_table_entry_lookup(struct sk_buff *skb,
> +						 struct p4tc_table *table,
> +						 u32 keysz)
> +{
> +	struct p4tc_table_entry *entry_curr = NULL;
> +	u8 masked_key[KEY_MASK_ID_SZ + BITS_TO_BYTES(P4TC_MAX_KEYSZ)] = { 0 };
> +	u32 smallest_prio = U32_MAX;
> +	struct p4tc_table_entry_mask *mask;
> +	struct p4tc_table_entry *entry = NULL;
> +	struct p4tc_skb_ext *p4tc_skb_ext;
> +	unsigned long tmp, mask_id;
> +
> +	p4tc_skb_ext = skb_ext_find(skb, P4TC_SKB_EXT);
> +	if (unlikely(!p4tc_skb_ext))
> +		return ERR_PTR(-ENOENT);
> +
> +	idr_for_each_entry_ul(&table->tbl_masks_idr, mask, tmp, mask_id) {
> +		struct p4tc_table_entry_key key = {};
> +
> +		mask_key(mask, masked_key, p4tc_skb_ext->p4tc_ext->key);
> +
> +		key.value = masked_key;
> +		key.keysz = keysz + KEY_MASK_ID_SZ_BITS;
> +
> +		entry_curr = __p4tc_entry_lookup(table, &key);
> +		if (entry_curr) {
> +			if (entry_curr->prio <= smallest_prio) {
> +				smallest_prio = entry_curr->prio;
> +				entry = entry_curr;
> +			}
> +		}
> +	}
> +
> +	return entry;
> +}
> +
> +#define tcf_table_entry_mask_find_byid(table, id) \
> +	(idr_find(&(table)->tbl_masks_idr, id))
> +
> +static int p4tca_table_get_entry_keys(struct sk_buff *skb,
> +				      struct p4tc_table *table,
> +				      struct p4tc_table_entry *entry)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	int ret = -ENOMEM;
> +	struct p4tc_table_entry_mask *mask;
> +	u32 key_sz_bytes;
> +
> +	key_sz_bytes = (entry->key.keysz - KEY_MASK_ID_SZ_BITS) / BITS_PER_BYTE;
> +	if (nla_put(skb, P4TC_ENTRY_KEY_BLOB, key_sz_bytes,
> +		    entry->key.unmasked_key + KEY_MASK_ID_SZ))
> +		goto out_nlmsg_trim;
> +
> +	mask = tcf_table_entry_mask_find_byid(table, entry->mask_id);
> +	if (nla_put(skb, P4TC_ENTRY_MASK_BLOB, key_sz_bytes,
> +		    mask->value + KEY_MASK_ID_SZ))
> +		goto out_nlmsg_trim;
> +
> +	return 0;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return ret;
> +}
> +
> +static void p4tc_table_entry_tm_dump(struct p4tc_table_entry_tm *dtm,
> +				     struct p4tc_table_entry_tm *stm)
> +{
> +	unsigned long now = jiffies;
> +
> +	dtm->created = stm->created ?
> +		jiffies_to_clock_t(now - stm->created) : 0;
> +	dtm->lastused = stm->lastused ?
> +		jiffies_to_clock_t(now - stm->lastused) : 0;
> +	dtm->firstused = stm->firstused ?
> +		jiffies_to_clock_t(now - stm->firstused) : 0;
> +}
> +
> +#define P4TC_ENTRY_MAX_IDS (P4TC_PATH_MAX - 1)
> +
> +int p4tca_table_get_entry_fill(struct sk_buff *skb, struct p4tc_table *table,
> +			       struct p4tc_table_entry *entry, u32 tbl_id)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	int ret = -ENOMEM;
> +	struct nlattr *nest, *nest_acts;
> +	struct p4tc_table_entry_tm dtm, *tm;
> +	u32 ids[P4TC_ENTRY_MAX_IDS];
> +
> +	ids[P4TC_TBLID_IDX - 1] = tbl_id;
> +
> +	if (nla_put(skb, P4TC_PATH, P4TC_ENTRY_MAX_IDS * sizeof(u32), ids))
> +		goto out_nlmsg_trim;
> +
> +	nest = nla_nest_start(skb, P4TC_PARAMS);
> +	if (!nest)
> +		goto out_nlmsg_trim;
> +
> +	if (nla_put_u32(skb, P4TC_ENTRY_PRIO, entry->prio))
> +		goto out_nlmsg_trim;
> +
> +	if (p4tca_table_get_entry_keys(skb, table, entry) < 0)
> +		goto out_nlmsg_trim;
> +
> +	if (entry->acts) {
> +		nest_acts = nla_nest_start(skb, P4TC_ENTRY_ACT);
> +		if (tcf_action_dump(skb, entry->acts, 0, 0, false) < 0)
> +			goto out_nlmsg_trim;
> +		nla_nest_end(skb, nest_acts);
> +	}
> +
> +	if (nla_put_u8(skb, P4TC_ENTRY_CREATE_WHODUNNIT, entry->who_created))
> +		goto out_nlmsg_trim;
> +
> +	if (entry->who_updated) {
> +		if (nla_put_u8(skb, P4TC_ENTRY_UPDATE_WHODUNNIT,
> +			       entry->who_updated))
> +			goto out_nlmsg_trim;
> +	}
> +
> +	if (nla_put_u16(skb, P4TC_ENTRY_PERMISSIONS, entry->permissions))
> +		goto out_nlmsg_trim;
> +
> +	tm = rtnl_dereference(entry->tm);
> +	p4tc_table_entry_tm_dump(&dtm, tm);
> +	if (nla_put_64bit(skb, P4TC_ENTRY_TM, sizeof(dtm), &dtm,
> +			  P4TC_ENTRY_PAD))
> +		goto out_nlmsg_trim;
> +
> +	nla_nest_end(skb, nest);
> +
> +	return skb->len;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return ret;
> +}
> +
> +static const struct nla_policy p4tc_entry_policy[P4TC_ENTRY_MAX + 1] = {
> +	[P4TC_ENTRY_TBLNAME] = { .type = NLA_STRING },
> +	[P4TC_ENTRY_KEY_BLOB] = { .type = NLA_BINARY },
> +	[P4TC_ENTRY_MASK_BLOB] = { .type = NLA_BINARY },
> +	[P4TC_ENTRY_PRIO] = { .type = NLA_U32 },
> +	[P4TC_ENTRY_ACT] = { .type = NLA_NESTED },
> +	[P4TC_ENTRY_TM] = { .type = NLA_BINARY,
> +			    .len = sizeof(struct p4tc_table_entry_tm) },
> +	[P4TC_ENTRY_WHODUNNIT] = { .type = NLA_U8 },
> +	[P4TC_ENTRY_CREATE_WHODUNNIT] = { .type = NLA_U8 },
> +	[P4TC_ENTRY_UPDATE_WHODUNNIT] = { .type = NLA_U8 },
> +	[P4TC_ENTRY_PERMISSIONS] = { .type = NLA_U16 },
> +};
> +
> +static void __tcf_table_entry_mask_destroy(struct p4tc_table_entry_mask *mask)
> +{
> +	kfree(mask->value);
> +	kfree(mask);
> +}
> +
> +static void tcf_table_entry_mask_destroy(struct rcu_head *rcu)
> +{
> +	struct p4tc_table_entry_mask *mask;
> +
> +	mask = container_of(rcu, struct p4tc_table_entry_mask, rcu);
> +
> +	__tcf_table_entry_mask_destroy(mask);
> +}
> +
> +static struct p4tc_table_entry_mask *
> +tcf_table_entry_mask_find_byvalue(struct p4tc_table *table,
> +				  struct p4tc_table_entry_mask *mask)
> +{
> +	struct p4tc_table_entry_mask *mask_cur;
> +	unsigned long mask_id, tmp;
> +
> +	idr_for_each_entry_ul(&table->tbl_masks_idr, mask_cur, tmp, mask_id) {
> +		if (mask_cur->sz == mask->sz) {
> +			u32 mask_sz_bytes = mask->sz / BITS_PER_BYTE - KEY_MASK_ID_SZ;
> +			void *curr_mask_value = mask_cur->value + KEY_MASK_ID_SZ;
> +			void *mask_value = mask->value + KEY_MASK_ID_SZ;
> +
> +			if (memcmp(curr_mask_value, mask_value, mask_sz_bytes) == 0)
> +				return mask_cur;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static void tcf_table_entry_mask_del(struct p4tc_table *table,
> +				     struct p4tc_table_entry *entry)
> +{
> +	const u32 mask_id = entry->mask_id;
> +	struct p4tc_table_entry_mask *mask_found;
> +
> +	/* Will always be found*/
> +	mask_found = tcf_table_entry_mask_find_byid(table, mask_id);
> +
> +	/* Last reference, can delete*/
> +	if (refcount_dec_if_one(&mask_found->mask_ref)) {
> +		spin_lock_bh(&table->tbl_masks_idr_lock);
> +		idr_remove(&table->tbl_masks_idr, mask_found->mask_id);
> +		spin_unlock_bh(&table->tbl_masks_idr_lock);
> +		call_rcu(&mask_found->rcu, tcf_table_entry_mask_destroy);
> +	} else {
> +		if (!refcount_dec_not_one(&mask_found->mask_ref))
> +			pr_warn("Mask was deleted in parallel");
> +	}
> +}
> +
> +/* TODO: Ordering optimisation for LPM */
> +static struct p4tc_table_entry_mask *
> +tcf_table_entry_mask_add(struct p4tc_table *table,
> +			 struct p4tc_table_entry *entry,
> +			 struct p4tc_table_entry_mask *mask)
> +{
> +	struct p4tc_table_entry_mask *mask_found;
> +	int ret;
> +
> +	mask_found = tcf_table_entry_mask_find_byvalue(table, mask);
> +	/* Only add mask if it was not already added */
> +	if (!mask_found) {
> +		struct p4tc_table_entry_mask *mask_allocated;
> +
> +		mask_allocated = kzalloc(sizeof(*mask_allocated), GFP_ATOMIC);
> +		if (!mask_allocated)
> +			return ERR_PTR(-ENOMEM);
> +
> +		mask_allocated->value =
> +			kzalloc(BITS_TO_BYTES(mask->sz), GFP_ATOMIC);
> +		if (!mask_allocated->value) {
> +			kfree(mask_allocated);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		memcpy(mask_allocated->value, mask->value,
> +		       BITS_TO_BYTES(mask->sz));
> +
> +		mask_allocated->mask_id = 1;
> +		refcount_set(&mask_allocated->mask_ref, 1);
> +		mask_allocated->sz = mask->sz;
> +
> +		spin_lock_bh(&table->tbl_masks_idr_lock);
> +		ret = idr_alloc_u32(&table->tbl_masks_idr, mask_allocated,
> +				    &mask_allocated->mask_id, UINT_MAX,
> +				    GFP_ATOMIC);
> +		spin_unlock_bh(&table->tbl_masks_idr_lock);
> +		if (ret < 0) {
> +			kfree(mask_allocated->value);
> +			kfree(mask_allocated);
> +			return ERR_PTR(ret);
> +		}
> +		entry->mask_id = mask_allocated->mask_id;
> +		mask_found = mask_allocated;
> +	} else {
> +		if (!refcount_inc_not_zero(&mask_found->mask_ref))
> +			return ERR_PTR(-EBUSY);
> +		entry->mask_id = mask_found->mask_id;
> +	}
> +
> +	return mask_found;
> +}
> +
> +static void tcf_table_entry_del_act(struct p4tc_table_entry *entry)
> +{
> +	p4tc_action_destroy(entry->acts);
> +	kfree(entry);
> +}
> +
> +static void tcf_table_entry_del_act_work(struct work_struct *work)
> +{
> +	struct p4tc_table_entry_work *entry_work =
> +		container_of(work, typeof(*entry_work), work);
> +	struct p4tc_pipeline *pipeline = entry_work->pipeline;
> +
> +	tcf_table_entry_del_act(entry_work->entry);
> +	put_net(pipeline->net);
> +
> +	refcount_dec(&entry_work->pipeline->p_entry_deferal_ref);
> +
> +	kfree(entry_work);
> +}
> +
> +static void tcf_table_entry_put(struct p4tc_table_entry *entry)
> +{
> +	struct p4tc_table_entry_tm *tm;
> +
> +	tm = rcu_dereference(entry->tm);
> +	kfree(tm);
> +
> +	kfree(entry->key.unmasked_key);
> +	kfree(entry->key.value);
> +
> +	if (entry->acts) {
> +		struct p4tc_table_entry_work *entry_work = entry->entry_work;
> +		struct p4tc_pipeline *pipeline = entry_work->pipeline;
> +		struct net *net;
> +
> +		if (entry_work->defer_deletion) {
> +			net = get_net(pipeline->net);
> +			refcount_inc(&entry_work->pipeline->p_entry_deferal_ref);
> +			schedule_work(&entry_work->work);
> +		} else {
> +			kfree(entry_work);
> +			tcf_table_entry_del_act(entry);
> +		}
> +	} else {
> +		kfree(entry->entry_work);
> +		kfree(entry);
> +	}
> +}
> +
> +static void tcf_table_entry_put_rcu(struct rcu_head *rcu)
> +{
> +	struct p4tc_table_entry *entry;
> +
> +	entry = container_of(rcu, struct p4tc_table_entry, rcu);
> +
> +	tcf_table_entry_put(entry);
> +}
> +
> +static int tcf_table_entry_destroy(struct p4tc_table *table,
> +				   struct p4tc_table_entry *entry,
> +				   bool remove_from_hash)
> +{
> +	/* Entry was deleted in parallel */
> +	if (!refcount_dec_if_one(&entry->entries_ref))
> +		return -EBUSY;
> +
> +	if (remove_from_hash)
> +		rhltable_remove(&table->tbl_entries, &entry->ht_node,
> +				entry_hlt_params);
> +
> +	tcf_table_entry_mask_del(table, entry);
> +	if (entry->entry_work->defer_deletion) {
> +		call_rcu(&entry->rcu, tcf_table_entry_put_rcu);
> +	} else {
> +		synchronize_rcu();
> +		tcf_table_entry_put(entry);
> +	}
> +
> +	return 0;
> +}
> +
> +/* Only deletes entries when called from pipeline delete, which means
> + * pipeline->p_ref will already be 0, so no need to use that refcount.
> + */
> +void tcf_table_entry_destroy_hash(void *ptr, void *arg)
> +{
> +	struct p4tc_table *table = arg;
> +	struct p4tc_table_entry *entry = ptr;
> +
> +	refcount_dec(&table->tbl_entries_ref);
> +
> +	entry->entry_work->defer_deletion = false;
> +	tcf_table_entry_destroy(table, entry, false);
> +}
> +
> +static void tcf_table_entry_put_table(struct p4tc_pipeline *pipeline,
> +				      struct p4tc_table *table)
> +{
> +	/* If we are here, it means that this was just incremented, so it should be > 1 */
> +	WARN_ON(!refcount_dec_not_one(&table->tbl_ctrl_ref));
> +	WARN_ON(!refcount_dec_not_one(&pipeline->p_ctrl_ref));
> +}
> +
> +static int tcf_table_entry_get_table(struct net *net,
> +				     struct p4tc_pipeline **pipeline,
> +				     struct p4tc_table **table,
> +				     struct nlattr **tb, u32 *ids, char *p_name,
> +				     struct netlink_ext_ack *extack)
> +	__must_hold(RCU)
> +{
> +	u32 pipeid, tbl_id;
> +	char *tblname;
> +	int ret;
> +
> +	pipeid = ids[P4TC_PID_IDX];
> +
> +	*pipeline = tcf_pipeline_find_byany(net, p_name, pipeid, extack);
> +	if (IS_ERR(*pipeline)) {
> +		ret = PTR_ERR(*pipeline);
> +		goto out;
> +	}
> +
> +	if (!refcount_inc_not_zero(&((*pipeline)->p_ctrl_ref))) {
> +		NL_SET_ERR_MSG(extack, "Pipeline is stale");
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	tbl_id = ids[P4TC_TBLID_IDX];
> +
> +	tblname = tb[P4TC_ENTRY_TBLNAME] ? nla_data(tb[P4TC_ENTRY_TBLNAME]) : NULL;
> +	*table = tcf_table_find_byany(*pipeline, tblname, tbl_id, extack);
> +	if (IS_ERR(*table)) {
> +		ret = PTR_ERR(*table);
> +		goto dec_pipeline_refcount;
> +	}
> +	if (!refcount_inc_not_zero(&((*table)->tbl_ctrl_ref))) {
> +		NL_SET_ERR_MSG(extack, "Table is marked for deletion");
> +		ret = -EBUSY;
> +		goto dec_pipeline_refcount;
> +	}
> +
> +	return 0;
> +
> +/* If we are here, it means that this was just incremented, so it should be > 1 */
> +dec_pipeline_refcount:
> +	WARN_ON(!refcount_dec_not_one(&((*pipeline)->p_ctrl_ref)));
> +
> +out:
> +	return ret;
> +}
> +
> +static void tcf_table_entry_assign_key(struct p4tc_table_entry_key *key,
> +				       struct p4tc_table_entry_mask *mask,
> +				       u8 *keyblob, u8 *maskblob, u32 keysz)
> +{
> +	/* Don't assign mask_id to key yet, because it has not been allocated */
> +	memcpy(key->unmasked_key + KEY_MASK_ID_SZ, keyblob, keysz);
> +
> +	/* Don't assign mask_id to value yet, because it has not been allocated */
> +	memcpy(mask->value + KEY_MASK_ID_SZ, maskblob, keysz);
> +}
> +
> +static int tcf_table_entry_extract_key(struct nlattr **tb,
> +				       struct p4tc_table_entry_key *key,
> +				       struct p4tc_table_entry_mask *mask,
> +				       struct netlink_ext_ack *extack)
> +{
> +	u32 internal_keysz;
> +	u32 keysz;
> +
> +	if (!tb[P4TC_ENTRY_KEY_BLOB] || !tb[P4TC_ENTRY_MASK_BLOB]) {
> +		NL_SET_ERR_MSG(extack, "Must specify key and mask blobs");
> +		return -EINVAL;
> +	}
> +
> +	keysz = nla_len(tb[P4TC_ENTRY_KEY_BLOB]);
> +	internal_keysz = (keysz + KEY_MASK_ID_SZ) * BITS_PER_BYTE;
> +	if (key->keysz != internal_keysz) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Key blob size and table key size differ");
> +		return -EINVAL;
> +	}
> +
> +	if (keysz != nla_len(tb[P4TC_ENTRY_MASK_BLOB])) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Key and mask blob must have the same length");
> +		return -EINVAL;
> +	}
> +
> +	tcf_table_entry_assign_key(key, mask, nla_data(tb[P4TC_ENTRY_KEY_BLOB]),
> +				   nla_data(tb[P4TC_ENTRY_MASK_BLOB]), keysz);
> +
> +	return 0;
> +}
> +
> +static void tcf_table_entry_build_key(struct p4tc_table_entry_key *key,
> +				      struct p4tc_table_entry_mask *mask)
> +{
> +	u32 *mask_id;
> +	int i;
> +
> +	mask_id = (u32 *)&key->unmasked_key[0];
> +	*mask_id = mask->mask_id;
> +
> +	mask_id = (u32 *)&mask->value[0];
> +	*mask_id = mask->mask_id;
> +
> +	for (i = 0; i < BITS_TO_BYTES(key->keysz); i++)
> +		key->value[i] = key->unmasked_key[i] & mask->value[i];
> +}
> +
> +static int ___tcf_table_entry_del(struct p4tc_pipeline *pipeline,
> +				  struct p4tc_table *table,
> +				  struct p4tc_table_entry *entry,
> +				  bool from_control)
> +	__must_hold(RCU)
> +{
> +	int ret = 0;
> +
> +	if (from_control) {
> +		if (!p4tc_ctrl_delete_ok(entry->permissions))
> +			return -EPERM;
> +	} else {
> +		if (!p4tc_data_delete_ok(entry->permissions))
> +			return -EPERM;
> +	}
> +
> +	if (!refcount_dec_not_one(&table->tbl_entries_ref))
> +		return -EBUSY;
> +
> +	spin_lock_bh(&table->tbl_prio_idr_lock);
> +	idr_remove(&table->tbl_prio_idr, entry->prio);
> +	spin_unlock_bh(&table->tbl_prio_idr_lock);
> +
> +	if (tcf_table_entry_destroy(table, entry, true) < 0) {
> +		ret = -EBUSY;
> +		goto inc_entries_ref;
> +	}
> +
> +	goto out;
> +
> +inc_entries_ref:
> +	WARN_ON(!refcount_dec_not_one(&table->tbl_entries_ref));
> +
> +out:
> +	return ret;
> +}
> +
> +/* Internal function which will be called by the data path */
> +static int __tcf_table_entry_del(struct p4tc_pipeline *pipeline,
> +				 struct p4tc_table *table,
> +				 struct p4tc_table_entry_key *key,
> +				 struct p4tc_table_entry_mask *mask, u32 prio,
> +				 struct netlink_ext_ack *extack)

This seems to be an infrastructure function implemented for future
usage, but since it is static and not called form anywhere it causes
compilation failure on this and following patches.

> +{
> +	struct p4tc_table_entry *entry;
> +	int ret;
> +
> +	tcf_table_entry_build_key(key, mask);
> +
> +	entry = p4tc_entry_lookup(table, key, prio);
> +	if (!entry) {
> +		rcu_read_unlock();

Where is the dual rcu_read_lock() for this?

> +		NL_SET_ERR_MSG(extack, "Unable to find entry");
> +		return -EINVAL;
> +	}
> +
> +	entry->entry_work->defer_deletion = true;
> +	ret = ___tcf_table_entry_del(pipeline, table, entry, false);
> +
> +	return ret;
> +}
> +
> +static int tcf_table_entry_gd(struct net *net, struct sk_buff *skb,
> +			      struct nlmsghdr *n, struct nlattr *arg, u32 *ids,
> +			      struct p4tc_nl_pname *nl_pname,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_ENTRY_MAX + 1] = { NULL };
> +	struct p4tc_table_entry *entry = NULL;
> +	struct p4tc_pipeline *pipeline = NULL;
> +	struct p4tc_table_entry_mask *mask, *new_mask;
> +	struct p4tc_table_entry_key *key;
> +	struct p4tc_table *table;
> +	u32 keysz_bytes;
> +	u32 prio;
> +	int ret;
> +
> +	if (arg) {
> +		ret = nla_parse_nested(tb, P4TC_ENTRY_MAX, arg,
> +				       p4tc_entry_policy, extack);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (!tb[P4TC_ENTRY_PRIO]) {
> +		NL_SET_ERR_MSG(extack, "Must specify table entry priority");
> +		return -EINVAL;
> +	}
> +	prio = *((u32 *)nla_data(tb[P4TC_ENTRY_PRIO]));
> +
> +	rcu_read_lock();
> +	ret = tcf_table_entry_get_table(net, &pipeline, &table, tb, ids,
> +					nl_pname->data, extack);
> +	rcu_read_unlock();
> +	if (ret < 0)
> +		return ret;
> +
> +	if (n->nlmsg_type == RTM_DELP4TBENT && !pipeline_sealed(pipeline)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Unable to delete table entry in unsealed pipeline");
> +		ret = -EINVAL;
> +		goto table_put;
> +	}
> +
> +	key = kzalloc(sizeof(*key), GFP_KERNEL);
> +	if (!key) {
> +		NL_SET_ERR_MSG(extack, "Unable to allocate key");
> +		ret = -ENOMEM;
> +		goto table_put;
> +	}
> +	key->keysz = table->tbl_keysz + KEY_MASK_ID_SZ_BITS;
> +	keysz_bytes = (key->keysz / BITS_PER_BYTE);
> +
> +	mask = kzalloc(sizeof(*mask), GFP_KERNEL);
> +	if (!mask) {
> +		NL_SET_ERR_MSG(extack, "Failed to allocate mask");
> +		ret = -ENOMEM;
> +		goto free_key;
> +	}
> +	mask->value = kzalloc(keysz_bytes, GFP_KERNEL);
> +	if (!mask->value) {
> +		NL_SET_ERR_MSG(extack, "Failed to allocate mask value");
> +		ret = -ENOMEM;
> +		kfree(mask);
> +		goto free_key;
> +	}
> +	mask->sz = key->keysz;
> +
> +	key->value = kzalloc(keysz_bytes, GFP_KERNEL);
> +	if (!key->value) {
> +		ret = -ENOMEM;
> +		kfree(mask->value);
> +		kfree(mask);
> +		goto free_key;
> +	}
> +
> +	key->unmasked_key = kzalloc(keysz_bytes, GFP_KERNEL);
> +	if (!key->unmasked_key) {
> +		ret = -ENOMEM;
> +		kfree(mask->value);
> +		kfree(mask);
> +		goto free_key_value;
> +	}
> +
> +	ret = tcf_table_entry_extract_key(tb, key, mask, extack);
> +	if (ret < 0) {
> +		kfree(mask->value);
> +		kfree(mask);
> +		goto free_key_unmasked;
> +	}
> +
> +	new_mask = tcf_table_entry_mask_find_byvalue(table, mask);
> +	kfree(mask->value);
> +	kfree(mask);
> +	if (!new_mask) {
> +		NL_SET_ERR_MSG(extack, "Unable to find entry");
> +		ret = -ENOENT;
> +		goto free_key_unmasked;
> +	} else {
> +		mask = new_mask;
> +	}
> +
> +	tcf_table_entry_build_key(key, mask);
> +
> +	rcu_read_lock();
> +	entry = p4tc_entry_lookup(table, key, prio);
> +	if (!entry) {
> +		NL_SET_ERR_MSG(extack, "Unable to find entry");
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (n->nlmsg_type == RTM_GETP4TBENT) {
> +		if (!p4tc_ctrl_read_ok(entry->permissions)) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Permission denied: Unable to read table entry");
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +	}
> +
> +	if (p4tca_table_get_entry_fill(skb, table, entry, table->tbl_id) <= 0) {
> +		NL_SET_ERR_MSG(extack, "Unable to fill table entry attributes");
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (n->nlmsg_type == RTM_DELP4TBENT) {
> +		entry->entry_work->defer_deletion = true;
> +		ret = ___tcf_table_entry_del(pipeline, table, entry, true);
> +		if (ret < 0)
> +			goto unlock;
> +	}
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	ret = 0;
> +
> +	goto unlock;
> +
> +unlock:
> +	rcu_read_unlock();
> +
> +free_key_unmasked:
> +	kfree(key->unmasked_key);
> +
> +free_key_value:
> +	kfree(key->value);
> +
> +free_key:
> +	kfree(key);
> +
> +table_put:
> +	tcf_table_entry_put_table(pipeline, table);
> +
> +	return ret;
> +}
> +
> +static int tcf_table_entry_flush(struct net *net, struct sk_buff *skb,
> +				 struct nlmsghdr *n, struct nlattr *arg,
> +				 u32 *ids, struct p4tc_nl_pname *nl_pname,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_ENTRY_MAX + 1] = { NULL };
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	int ret = 0;
> +	int i = 0;
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_table_entry *entry;
> +	struct p4tc_table *table;
> +	u32 arg_ids[P4TC_PATH_MAX - 1];
> +	struct rhashtable_iter iter;
> +
> +	if (arg) {
> +		ret = nla_parse_nested(tb, P4TC_ENTRY_MAX, arg,
> +				       p4tc_entry_policy, extack);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	rcu_read_lock();
> +	ret = tcf_table_entry_get_table(net, &pipeline, &table, tb, ids,
> +					nl_pname->data, extack);
> +	rcu_read_unlock();
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!ids[P4TC_TBLID_IDX])
> +		arg_ids[P4TC_TBLID_IDX - 1] = table->tbl_id;
> +
> +	if (nla_put(skb, P4TC_PATH, sizeof(arg_ids), arg_ids)) {
> +		ret = -ENOMEM;
> +		goto out_nlmsg_trim;
> +	}
> +
> +	rhltable_walk_enter(&table->tbl_entries, &iter);
> +	do {
> +		rhashtable_walk_start(&iter);
> +
> +		while ((entry = rhashtable_walk_next(&iter)) && !IS_ERR(entry)) {
> +			if (!p4tc_ctrl_delete_ok(entry->permissions)) {
> +				ret = -EPERM;
> +				continue;
> +			}
> +
> +			if (!refcount_dec_not_one(&table->tbl_entries_ref)) {
> +				NL_SET_ERR_MSG(extack, "Table entry is stale");
> +				ret = -EBUSY;
> +				rhashtable_walk_stop(&iter);
> +				goto walk_exit;
> +			}
> +
> +			entry->entry_work->defer_deletion = true;
> +			if (tcf_table_entry_destroy(table, entry, true) < 0) {
> +				ret = -EBUSY;
> +				continue;
> +			}
> +			i++;
> +		}
> +
> +		rhashtable_walk_stop(&iter);
> +	} while (entry == ERR_PTR(-EAGAIN));
> +
> +walk_exit:
> +	rhashtable_walk_exit(&iter);
> +
> +	nla_put_u32(skb, P4TC_COUNT, i);
> +
> +	if (ret < 0) {
> +		if (i == 0) {
> +			if (!extack->_msg)
> +				NL_SET_ERR_MSG(extack,
> +					       "Unable to flush any entries");
> +			goto out_nlmsg_trim;
> +		} else {
> +			if (!extack->_msg)
> +				NL_SET_ERR_MSG(extack,
> +					       "Unable to flush all entries");
> +		}
> +	}
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	ret = 0;
> +	goto table_put;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +
> +/* If we are here, it means that this was just incremented, so it should be > 1 */
> +table_put:
> +	tcf_table_entry_put_table(pipeline, table);
> +
> +	return ret;
> +}
> +
> +/* Invoked from both control and data path */
> +static int __tcf_table_entry_create(struct p4tc_pipeline *pipeline,
> +				    struct p4tc_table *table,
> +				    struct p4tc_table_entry *entry,
> +				    struct p4tc_table_entry_mask *mask,
> +				    u16 whodunnit, bool from_control)
> +	__must_hold(RCU)
> +{
> +	struct p4tc_table_perm *tbl_perm;
> +	struct p4tc_table_entry_mask *mask_found;
> +	struct p4tc_table_entry_work *entry_work;
> +	struct p4tc_table_entry_tm *dtm;
> +	u16 permissions;
> +	int ret;
> +
> +	refcount_set(&entry->entries_ref, 1);
> +
> +	tbl_perm = rcu_dereference(table->tbl_permissions);
> +	permissions = tbl_perm->permissions;
> +	if (from_control) {
> +		if (!p4tc_ctrl_create_ok(permissions))
> +			return -EPERM;
> +	} else {
> +		if (!p4tc_data_create_ok(permissions))
> +			return -EPERM;
> +	}
> +
> +	mask_found = tcf_table_entry_mask_add(table, entry, mask);
> +	if (IS_ERR(mask_found)) {
> +		ret = PTR_ERR(mask_found);
> +		goto out;
> +	}
> +
> +	tcf_table_entry_build_key(&entry->key, mask_found);
> +
> +	if (!refcount_inc_not_zero(&table->tbl_entries_ref)) {
> +		ret = -EBUSY;
> +		goto rm_masks_idr;
> +	}
> +
> +	if (p4tc_entry_lookup(table, &entry->key, entry->prio)) {
> +		ret = -EEXIST;
> +		goto dec_entries_ref;
> +	}
> +
> +	dtm = kzalloc(sizeof(*dtm), GFP_ATOMIC);
> +	if (!dtm) {
> +		ret = -ENOMEM;
> +		goto dec_entries_ref;
> +	}
> +
> +	entry->who_created = whodunnit;
> +
> +	dtm->created = jiffies;
> +	dtm->firstused = 0;
> +	dtm->lastused = jiffies;
> +	rcu_assign_pointer(entry->tm, dtm);
> +
> +	entry_work = kzalloc(sizeof(*(entry_work)), GFP_ATOMIC);
> +	if (!entry_work) {
> +		ret = -ENOMEM;
> +		goto free_tm;
> +	}
> +
> +	entry_work->pipeline = pipeline;
> +	entry_work->entry = entry;
> +	entry->entry_work = entry_work;
> +
> +	INIT_WORK(&entry_work->work, tcf_table_entry_del_act_work);
> +
> +	if (rhltable_insert(&table->tbl_entries, &entry->ht_node,
> +			    entry_hlt_params) < 0) {
> +		ret = -EBUSY;
> +		goto free_entry_work;
> +	}
> +
> +	return 0;
> +
> +free_entry_work:
> +	kfree(entry_work);
> +
> +free_tm:
> +	kfree(dtm);
> +/*If we are here, it means that this was just incremented, so it should be > 1 */
> +dec_entries_ref:
> +	WARN_ON(!refcount_dec_not_one(&table->tbl_entries_ref));
> +
> +rm_masks_idr:
> +	tcf_table_entry_mask_del(table, entry);
> +
> +out:
> +	return ret;
> +}
> +
> +/* Invoked from both control and data path  */
> +static int __tcf_table_entry_update(struct p4tc_pipeline *pipeline,
> +				    struct p4tc_table *table,
> +				    struct p4tc_table_entry *entry,
> +				    struct p4tc_table_entry_mask *mask,
> +				    u16 whodunnit, bool from_control)
> +	__must_hold(RCU)
> +{
> +	struct p4tc_table_entry_mask *mask_found;
> +	struct p4tc_table_entry_work *entry_work;
> +	struct p4tc_table_entry *entry_old;
> +	struct p4tc_table_entry_tm *tm_old;
> +	struct p4tc_table_entry_tm *tm;
> +	int ret;
> +
> +	refcount_set(&entry->entries_ref, 1);
> +
> +	mask_found = tcf_table_entry_mask_add(table, entry, mask);
> +	if (IS_ERR(mask_found)) {
> +		ret = PTR_ERR(mask_found);
> +		goto out;
> +	}
> +
> +	tcf_table_entry_build_key(&entry->key, mask_found);
> +
> +	entry_old = p4tc_entry_lookup(table, &entry->key, entry->prio);
> +	if (!entry_old) {
> +		ret = -ENOENT;
> +		goto rm_masks_idr;
> +	}
> +
> +	if (from_control) {
> +		if (!p4tc_ctrl_update_ok(entry_old->permissions)) {
> +			ret = -EPERM;
> +			goto rm_masks_idr;
> +		}
> +	} else {
> +		if (!p4tc_data_update_ok(entry_old->permissions)) {
> +			ret = -EPERM;
> +			goto rm_masks_idr;
> +		}
> +	}
> +
> +	if (refcount_read(&entry_old->entries_ref) > 1) {
> +		ret = -EBUSY;
> +		goto rm_masks_idr;
> +	}
> +
> +	tm = kzalloc(sizeof(*tm), GFP_ATOMIC);
> +	if (!tm) {
> +		ret = -ENOMEM;
> +		goto rm_masks_idr;
> +	}
> +
> +	tm_old = rcu_dereference_protected(entry_old->tm, 1);
> +	tm->created = tm_old->created;
> +	tm->firstused = tm_old->firstused;
> +	tm->lastused = jiffies;
> +
> +	entry->who_updated = whodunnit;
> +
> +	entry->who_created = entry_old->who_created;
> +
> +	if (entry->permissions == P4TC_PERMISSIONS_UNINIT)
> +		entry->permissions = entry_old->permissions;
> +
> +	rcu_assign_pointer(entry->tm, tm);
> +
> +	entry_work = kzalloc(sizeof(*(entry_work)), GFP_ATOMIC);
> +	if (!entry_work) {
> +		ret = -ENOMEM;
> +		goto free_tm;
> +	}
> +
> +	entry_work->pipeline = pipeline;
> +	entry_work->entry = entry;
> +	entry->entry_work = entry_work;
> +
> +	INIT_WORK(&entry_work->work, tcf_table_entry_del_act_work);
> +
> +	if (rhltable_insert(&table->tbl_entries, &entry->ht_node,
> +			    entry_hlt_params) < 0) {
> +		ret = -EEXIST;
> +		goto free_entry_work;
> +	}
> +
> +	entry_old->entry_work->defer_deletion = true;
> +	if (tcf_table_entry_destroy(table, entry_old, true) < 0) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	return 0;
> +
> +free_entry_work:
> +	kfree(entry_work);
> +
> +free_tm:
> +	kfree(tm);
> +
> +rm_masks_idr:
> +	tcf_table_entry_mask_del(table, entry);
> +
> +out:
> +	return ret;
> +}
> +
> +#define P4TC_DEFAULT_TENTRY_PERMISSIONS                           \
> +	(P4TC_CTRL_PERM_R | P4TC_CTRL_PERM_U | P4TC_CTRL_PERM_D | \
> +	 P4TC_DATA_PERM_R | P4TC_DATA_PERM_X)
> +
> +static bool tcf_table_check_entry_acts(struct p4tc_table *table,
> +				       struct tc_action *entry_acts[],
> +				       struct list_head *allowed_acts,
> +				       int num_entry_acts)
> +{
> +	struct p4tc_table_act *table_act;
> +	int i;
> +
> +	for (i = 0; i < num_entry_acts; i++) {
> +		const struct tc_action *entry_act = entry_acts[i];
> +
> +		list_for_each_entry(table_act, allowed_acts, node) {
> +			if (table_act->ops->id == entry_act->ops->id &&
> +			    !(table_act->flags & BIT(P4TC_TABLE_ACTS_DEFAULT_ONLY)))
> +				return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static int __tcf_table_entry_cu(struct net *net, u32 flags, struct nlattr **tb,
> +				struct p4tc_table_entry *entry_cpy,
> +				struct p4tc_pipeline *pipeline,
> +				struct p4tc_table *table,
> +				struct netlink_ext_ack *extack)
> +{
> +	u8 mask_value[KEY_MASK_ID_SZ + BITS_TO_BYTES(P4TC_MAX_KEYSZ)] = { 0 };
> +	struct p4tc_table_entry_mask mask = { 0 };
> +	u8 whodunnit = P4TC_ENTITY_UNSPEC;
> +	int ret = 0;
> +	struct p4tc_table_entry *entry;
> +	u32 keysz_bytes;
> +	u32 prio;
> +
> +	prio = tb[P4TC_ENTRY_PRIO] ? *((u32 *)nla_data(tb[P4TC_ENTRY_PRIO])) : 0;
> +	if (flags & NLM_F_REPLACE) {
> +		if (!prio) {
> +			NL_SET_ERR_MSG(extack, "Must specify entry priority");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (!prio) {
> +			prio = 1;
> +			spin_lock(&table->tbl_prio_idr_lock);
> +			ret = idr_alloc_u32(&table->tbl_prio_idr,
> +					    ERR_PTR(-EBUSY), &prio, UINT_MAX,
> +					    GFP_ATOMIC);
> +			spin_unlock(&table->tbl_prio_idr_lock);
> +			if (ret < 0) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Unable to allocate priority");
> +				return ret;
> +			}
> +		} else {
> +			rcu_read_lock();
> +			if (idr_find(&table->tbl_prio_idr, prio)) {
> +				rcu_read_unlock();
> +				NL_SET_ERR_MSG(extack,
> +					       "Priority already in use");
> +				return -EBUSY;
> +			}
> +			rcu_read_unlock();
> +		}
> +
> +		if (refcount_read(&table->tbl_entries_ref) > table->tbl_max_entries) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Table instance max entries reached");
> +			return -EINVAL;
> +		}
> +	}
> +	if (tb[P4TC_ENTRY_WHODUNNIT]) {
> +		whodunnit = *((u8 *)nla_data(tb[P4TC_ENTRY_WHODUNNIT]));
> +	} else {
> +		NL_SET_ERR_MSG(extack, "Must specify whodunnit attribute");
> +		ret = -EINVAL;
> +		goto idr_rm;
> +	}
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry) {
> +		NL_SET_ERR_MSG(extack, "Unable to allocate table entry");
> +		ret = -ENOMEM;
> +		goto idr_rm;
> +	}
> +	entry->prio = prio;
> +
> +	entry->key.keysz = table->tbl_keysz + KEY_MASK_ID_SZ_BITS;
> +	keysz_bytes = entry->key.keysz / BITS_PER_BYTE;
> +
> +	mask.sz = entry->key.keysz;
> +	mask.value = mask_value;
> +
> +	entry->key.value = kzalloc(keysz_bytes, GFP_KERNEL);
> +	if (!entry->key.value) {
> +		ret = -ENOMEM;
> +		goto free_entry;
> +	}
> +
> +	entry->key.unmasked_key = kzalloc(keysz_bytes, GFP_KERNEL);
> +	if (!entry->key.unmasked_key) {
> +		ret = -ENOMEM;
> +		goto free_key_value;
> +	}
> +
> +	ret = tcf_table_entry_extract_key(tb, &entry->key, &mask, extack);
> +	if (ret < 0)
> +		goto free_key_unmasked;
> +
> +	if (tb[P4TC_ENTRY_PERMISSIONS]) {
> +		const u16 tblperm =
> +			rcu_dereference(table->tbl_permissions)->permissions;
> +		u16 nlperm;
> +
> +		nlperm = *((u16 *)nla_data(tb[P4TC_ENTRY_PERMISSIONS]));
> +		if (nlperm > P4TC_MAX_PERMISSION) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Permission may only have 10 bits turned on");
> +			ret = -EINVAL;
> +			goto free_key_unmasked;
> +		}
> +		if (p4tc_ctrl_create_ok(nlperm) ||
> +		    p4tc_data_create_ok(nlperm)) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Create permission for table entry doesn't make sense");
> +			ret = -EINVAL;
> +			goto free_key_unmasked;
> +		}
> +		if (!p4tc_data_read_ok(nlperm)) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Data path read permission must be set");
> +			ret = -EINVAL;
> +			goto free_key_unmasked;
> +		}
> +		if (!p4tc_data_exec_ok(nlperm)) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Data path execute permissions for entry must be set");
> +			ret = -EINVAL;
> +			goto free_key_unmasked;
> +		}
> +
> +		if (~tblperm & nlperm) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Trying to set permission bits which aren't allowed by table");
> +			ret = -EINVAL;
> +			goto free_key_unmasked;
> +		}
> +		entry->permissions = nlperm;
> +	} else {
> +		if (flags & NLM_F_REPLACE)
> +			entry->permissions = P4TC_PERMISSIONS_UNINIT;
> +		else
> +			entry->permissions = P4TC_DEFAULT_TENTRY_PERMISSIONS;
> +	}
> +
> +	if (tb[P4TC_ENTRY_ACT]) {
> +		entry->acts = kcalloc(TCA_ACT_MAX_PRIO,
> +				      sizeof(struct tc_action *), GFP_KERNEL);
> +		if (!entry->acts) {
> +			ret = -ENOMEM;
> +			goto free_key_unmasked;
> +		}
> +
> +		ret = p4tc_action_init(net, tb[P4TC_ENTRY_ACT], entry->acts,
> +				       table->common.p_id,
> +				       TCA_ACT_FLAGS_NO_RTNL, extack);
> +		if (ret < 0) {
> +			kfree(entry->acts);
> +			entry->acts = NULL;
> +			goto free_key_unmasked;
> +		}
> +		entry->num_acts = ret;
> +
> +		if (!tcf_table_check_entry_acts(table, entry->acts,
> +						&table->tbl_acts_list, ret)) {
> +			ret = -EPERM;
> +			NL_SET_ERR_MSG(extack,
> +				       "Action is not allowed as entry action");
> +			goto free_acts;
> +		}
> +	}
> +
> +	rcu_read_lock();
> +	if (flags & NLM_F_REPLACE)
> +		ret = __tcf_table_entry_update(pipeline, table, entry, &mask,
> +					       whodunnit, true);
> +	else
> +		ret = __tcf_table_entry_create(pipeline, table, entry, &mask,
> +					       whodunnit, true);
> +	if (ret < 0) {
> +		rcu_read_unlock();
> +		goto free_acts;
> +	}
> +
> +	memcpy(entry_cpy, entry, sizeof(*entry));
> +
> +	rcu_read_unlock();
> +
> +	return 0;
> +
> +free_acts:
> +	p4tc_action_destroy(entry->acts);
> +
> +free_key_unmasked:
> +	kfree(entry->key.unmasked_key);
> +
> +free_key_value:
> +	kfree(entry->key.value);
> +
> +free_entry:
> +	kfree(entry);
> +
> +idr_rm:
> +	if (!(flags & NLM_F_REPLACE)) {
> +		spin_lock(&table->tbl_prio_idr_lock);
> +		idr_remove(&table->tbl_prio_idr, prio);
> +		spin_unlock(&table->tbl_prio_idr_lock);
> +	}
> +
> +	return ret;
> +}
> +
> +static int tcf_table_entry_cu(struct sk_buff *skb, struct net *net, u32 flags,
> +			      struct nlattr *arg, u32 *ids,
> +			      struct p4tc_nl_pname *nl_pname,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_ENTRY_MAX + 1] = { NULL };
> +	struct p4tc_table_entry entry = { 0 };
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_table *table;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, P4TC_ENTRY_MAX, arg, p4tc_entry_policy,
> +			       extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	rcu_read_lock();
> +	ret = tcf_table_entry_get_table(net, &pipeline, &table, tb, ids,
> +					nl_pname->data, extack);
> +	rcu_read_unlock();
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!pipeline_sealed(pipeline)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Need to seal pipeline before issuing runtime command");
> +		ret = -EINVAL;
> +		goto table_put;
> +	}
> +
> +	ret = __tcf_table_entry_cu(net, flags, tb, &entry, pipeline, table,
> +				   extack);
> +	if (ret < 0)
> +		goto table_put;
> +
> +	if (p4tca_table_get_entry_fill(skb, table, &entry, table->tbl_id) <= 0)
> +		NL_SET_ERR_MSG(extack, "Unable to fill table entry attributes");
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +table_put:
> +	tcf_table_entry_put_table(pipeline, table);
> +	return ret;
> +}
> +
> +int tcf_table_const_entry_cu(struct net *net, struct nlattr *arg,
> +			     struct p4tc_table_entry *entry,
> +			     struct p4tc_pipeline *pipeline,
> +			     struct p4tc_table *table,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_ENTRY_MAX + 1] = { NULL };
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, P4TC_ENTRY_MAX, arg, p4tc_entry_policy,
> +			       extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	return __tcf_table_entry_cu(net, 0, tb, entry, pipeline, table, extack);
> +}
> +
> +static int tc_ctl_p4_get_1(struct net *net, struct sk_buff *skb,
> +			   struct nlmsghdr *n, u32 *ids, struct nlattr *arg,
> +			   struct p4tc_nl_pname *nl_pname,
> +			   struct netlink_ext_ack *extack)
> +{
> +	int ret = 0;
> +	struct nlattr *tb[P4TC_MAX + 1];
> +	u32 *arg_ids;
> +
> +	ret = nla_parse_nested(tb, P4TC_MAX, arg, NULL, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!tb[P4TC_PATH]) {
> +		NL_SET_ERR_MSG(extack, "Must specify object path");
> +		return -EINVAL;
> +	}
> +
> +	if (nla_len(tb[P4TC_PATH]) > (P4TC_PATH_MAX - 1) * sizeof(u32)) {
> +		NL_SET_ERR_MSG(extack, "Path is too big");
> +		return -E2BIG;
> +	}
> +
> +	arg_ids = nla_data(tb[P4TC_PATH]);
> +	memcpy(&ids[P4TC_TBLID_IDX], arg_ids, nla_len(tb[P4TC_PATH]));
> +
> +	return tcf_table_entry_gd(net, skb, n, tb[P4TC_PARAMS], ids, nl_pname,
> +				  extack);
> +}
> +
> +static int tc_ctl_p4_delete_1(struct net *net, struct sk_buff *skb,
> +			      struct nlmsghdr *n, struct nlattr *arg, u32 *ids,
> +			      struct p4tc_nl_pname *nl_pname,
> +			      struct netlink_ext_ack *extack)
> +{
> +	int ret = 0;
> +	struct nlattr *tb[P4TC_MAX + 1];
> +	u32 *arg_ids;
> +
> +	ret = nla_parse_nested(tb, P4TC_MAX, arg, NULL, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!tb[P4TC_PATH]) {
> +		NL_SET_ERR_MSG(extack, "Must specify object path");
> +		return -EINVAL;
> +	}
> +
> +	if ((nla_len(tb[P4TC_PATH])) > (P4TC_PATH_MAX - 1) * sizeof(u32)) {
> +		NL_SET_ERR_MSG(extack, "Path is too big");
> +		return -E2BIG;
> +	}
> +
> +	arg_ids = nla_data(tb[P4TC_PATH]);
> +	memcpy(&ids[P4TC_TBLID_IDX], arg_ids, nla_len(tb[P4TC_PATH]));
> +	if (n->nlmsg_flags & NLM_F_ROOT)
> +		ret = tcf_table_entry_flush(net, skb, n, tb[P4TC_PARAMS], ids,
> +					    nl_pname, extack);
> +	else
> +		ret = tcf_table_entry_gd(net, skb, n, tb[P4TC_PARAMS], ids,
> +					 nl_pname, extack);
> +
> +	return ret;
> +}
> +
> +static int tc_ctl_p4_cu_1(struct net *net, struct sk_buff *skb,
> +			  struct nlmsghdr *n, u32 *ids, struct nlattr *nla,
> +			  struct p4tc_nl_pname *nl_pname,
> +			  struct netlink_ext_ack *extack)
> +{
> +	int ret = 0;
> +	struct nlattr *p4tca[P4TC_MAX + 1];
> +	u32 *arg_ids;
> +
> +	ret = nla_parse_nested(p4tca, P4TC_MAX, nla, NULL, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!p4tca[P4TC_PATH]) {
> +		NL_SET_ERR_MSG(extack, "Must specify object path");
> +		return -EINVAL;
> +	}
> +
> +	if (nla_len(p4tca[P4TC_PATH]) > (P4TC_PATH_MAX - 1) * sizeof(u32)) {
> +		NL_SET_ERR_MSG(extack, "Path is too big");
> +		return -E2BIG;
> +	}
> +
> +	if (!p4tca[P4TC_PARAMS]) {
> +		NL_SET_ERR_MSG(extack, "Must specify object attributes");
> +		return -EINVAL;
> +	}
> +
> +	arg_ids = nla_data(p4tca[P4TC_PATH]);
> +	memcpy(&ids[P4TC_TBLID_IDX], arg_ids, nla_len(p4tca[P4TC_PATH]));
> +
> +	return tcf_table_entry_cu(skb, net, n->nlmsg_flags, p4tca[P4TC_PARAMS],
> +				  ids, nl_pname, extack);
> +}
> +
> +static int tc_ctl_p4_table_n(struct sk_buff *skb, struct nlmsghdr *n, int cmd,
> +			     char *p_name, struct nlattr *nla,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct p4tcmsg *t = (struct p4tcmsg *)nlmsg_data(n);
> +	struct net *net = sock_net(skb->sk);
> +	u32 portid = NETLINK_CB(skb).portid;
> +	u32 ids[P4TC_PATH_MAX] = { 0 };
> +	int ret = 0, ret_send;
> +	struct nlattr *p4tca[P4TC_MSGBATCH_SIZE + 1];
> +	struct p4tc_nl_pname nl_pname;
> +	struct sk_buff *new_skb;
> +	struct p4tcmsg *t_new;
> +	struct nlmsghdr *nlh;
> +	struct nlattr *pnatt;
> +	struct nlattr *root;
> +	int i;
> +
> +	ret = nla_parse_nested(p4tca, P4TC_MSGBATCH_SIZE, nla, NULL, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!p4tca[1]) {
> +		NL_SET_ERR_MSG(extack, "No elements in root table array");
> +		return -EINVAL;
> +	}
> +
> +	new_skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!new_skb)
> +		return -ENOBUFS;
> +
> +	nlh = nlmsg_put(new_skb, portid, n->nlmsg_seq, cmd, sizeof(*t),
> +			n->nlmsg_flags);
> +	if (!nlh)
> +		goto out;
> +
> +	t_new = nlmsg_data(nlh);
> +	t_new->pipeid = t->pipeid;
> +	t_new->obj = t->obj;
> +	ids[P4TC_PID_IDX] = t_new->pipeid;
> +
> +	pnatt = nla_reserve(new_skb, P4TC_ROOT_PNAME, PIPELINENAMSIZ);
> +	if (!pnatt) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	nl_pname.data = nla_data(pnatt);
> +	if (!p_name) {
> +		/* Filled up by the operation or forced failure */
> +		memset(nl_pname.data, 0, PIPELINENAMSIZ);
> +		nl_pname.passed = false;
> +	} else {
> +		strscpy(nl_pname.data, p_name, PIPELINENAMSIZ);
> +		nl_pname.passed = true;
> +	}
> +
> +	net = maybe_get_net(net);
> +	if (!net) {
> +		NL_SET_ERR_MSG(extack, "Net namespace is going down");
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	root = nla_nest_start(new_skb, P4TC_ROOT);
> +	for (i = 1; i < P4TC_MSGBATCH_SIZE + 1 && p4tca[i]; i++) {
> +		struct nlattr *nest = nla_nest_start(new_skb, i);
> +
> +		if (cmd == RTM_GETP4TBENT)
> +			ret = tc_ctl_p4_get_1(net, new_skb, nlh, ids, p4tca[i],
> +					      &nl_pname, extack);
> +		else if (cmd == RTM_CREATEP4TBENT)
> +			ret = tc_ctl_p4_cu_1(net, new_skb, nlh, ids, p4tca[i],
> +					     &nl_pname, extack);
> +		else if (cmd == RTM_DELP4TBENT)
> +			ret = tc_ctl_p4_delete_1(net, new_skb, nlh, p4tca[i],
> +						 ids, &nl_pname, extack);
> +
> +		if (ret < 0) {
> +			if (i == 1) {
> +				goto put_net;
> +			} else {
> +				nla_nest_cancel(new_skb, nest);
> +				break;
> +			}
> +		}
> +		nla_nest_end(new_skb, nest);
> +	}
> +	nla_nest_end(new_skb, root);
> +
> +	if (!t_new->pipeid)
> +		t_new->pipeid = ids[P4TC_PID_IDX];
> +
> +	nlmsg_end(new_skb, nlh);
> +
> +	if (cmd == RTM_GETP4TBENT)
> +		ret_send = rtnl_unicast(new_skb, net, portid);
> +	else
> +		ret_send = rtnetlink_send(new_skb, net, portid, RTNLGRP_TC,
> +					  n->nlmsg_flags & NLM_F_ECHO);
> +
> +	put_net(net);
> +
> +	return ret_send ? ret_send : ret;
> +
> +put_net:
> +	put_net(net);
> +
> +out:
> +	kfree_skb(new_skb);
> +	return ret;
> +}
> +
> +static int tc_ctl_p4_root(struct sk_buff *skb, struct nlmsghdr *n, int cmd,
> +			  struct netlink_ext_ack *extack)
> +{
> +	char *p_name = NULL;
> +	int ret = 0;
> +	struct nlattr *p4tca[P4TC_ROOT_MAX + 1];
> +
> +	ret = nlmsg_parse(n, sizeof(struct p4tcmsg), p4tca, P4TC_ROOT_MAX,
> +			  p4tc_root_policy, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!p4tca[P4TC_ROOT]) {
> +		NL_SET_ERR_MSG(extack, "Netlink P4TC table attributes missing");
> +		return -EINVAL;
> +	}
> +
> +	if (p4tca[P4TC_ROOT_PNAME])
> +		p_name = nla_data(p4tca[P4TC_ROOT_PNAME]);
> +
> +	return tc_ctl_p4_table_n(skb, n, cmd, p_name, p4tca[P4TC_ROOT], extack);
> +}
> +
> +static int tc_ctl_p4_get(struct sk_buff *skb, struct nlmsghdr *n,
> +			 struct netlink_ext_ack *extack)
> +{
> +	return tc_ctl_p4_root(skb, n, RTM_GETP4TBENT, extack);
> +}
> +
> +static int tc_ctl_p4_delete(struct sk_buff *skb, struct nlmsghdr *n,
> +			    struct netlink_ext_ack *extack)
> +{
> +	if (!netlink_capable(skb, CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	return tc_ctl_p4_root(skb, n, RTM_DELP4TBENT, extack);
> +}
> +
> +static int tc_ctl_p4_cu(struct sk_buff *skb, struct nlmsghdr *n,
> +			struct netlink_ext_ack *extack)
> +{
> +	int ret;
> +
> +	if (!netlink_capable(skb, CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	ret = tc_ctl_p4_root(skb, n, RTM_CREATEP4TBENT, extack);
> +
> +	return ret;
> +}
> +
> +static int tcf_table_entry_dump(struct sk_buff *skb, struct nlattr *arg,
> +				u32 *ids, struct netlink_callback *cb,
> +				char **p_name, struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_ENTRY_MAX + 1] = { NULL };
> +	struct p4tc_dump_ctx *ctx = (void *)cb->ctx;
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_pipeline *pipeline = NULL;
> +	struct p4tc_table_entry *entry = NULL;
> +	struct net *net = sock_net(skb->sk);
> +	int i = 0;
> +	struct p4tc_table *table;
> +	int ret;
> +
> +	net = maybe_get_net(net);
> +	if (!net) {
> +		NL_SET_ERR_MSG(extack, "Net namespace is going down");
> +		return -EBUSY;
> +	}
> +
> +	if (arg) {
> +		ret = nla_parse_nested(tb, P4TC_ENTRY_MAX, arg,
> +				       p4tc_entry_policy, extack);
> +		if (ret < 0) {
> +			kfree(ctx->iter);
> +			goto net_put;
> +		}
> +	}
> +
> +	rcu_read_lock();
> +	ret = tcf_table_entry_get_table(net, &pipeline, &table, tb, ids,
> +					*p_name, extack);
> +	rcu_read_unlock();
> +	if (ret < 0) {
> +		kfree(ctx->iter);
> +		goto net_put;
> +	}
> +
> +	if (!ctx->iter) {
> +		ctx->iter = kzalloc(sizeof(*ctx->iter), GFP_KERNEL);
> +		if (!ctx->iter) {
> +			ret = -ENOMEM;
> +			goto table_put;
> +		}
> +
> +		rhltable_walk_enter(&table->tbl_entries, ctx->iter);
> +	}
> +
> +	ret = -ENOMEM;
> +	rhashtable_walk_start(ctx->iter);
> +	do {
> +		for (i = 0; i < P4TC_MSGBATCH_SIZE &&
> +		     (entry = rhashtable_walk_next(ctx->iter)) &&
> +		     !IS_ERR(entry); i++) {
> +			struct nlattr *count;
> +
> +			if (!p4tc_ctrl_read_ok(entry->permissions)) {
> +				i--;
> +				continue;
> +			}
> +
> +			count = nla_nest_start(skb, i + 1);
> +			if (!count) {
> +				rhashtable_walk_stop(ctx->iter);
> +				goto table_put;
> +			}
> +			ret = p4tca_table_get_entry_fill(skb, table, entry,
> +							 table->tbl_id);
> +			if (ret == 0) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Failed to fill notification attributes for table entry");
> +				goto walk_done;
> +			} else if (ret == -ENOMEM) {
> +				ret = 1;
> +				nla_nest_cancel(skb, count);
> +				rhashtable_walk_stop(ctx->iter);
> +				goto table_put;
> +			}
> +			nla_nest_end(skb, count);
> +		}
> +	} while (entry == ERR_PTR(-EAGAIN));
> +	rhashtable_walk_stop(ctx->iter);
> +
> +	if (!i) {
> +		rhashtable_walk_exit(ctx->iter);
> +
> +		ret = 0;
> +		kfree(ctx->iter);
> +
> +		goto table_put;
> +	}
> +
> +	if (!*p_name)
> +		*p_name = pipeline->common.name;
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	ret = skb->len;
> +
> +	goto table_put;
> +
> +walk_done:
> +	rhashtable_walk_stop(ctx->iter);
> +	rhashtable_walk_exit(ctx->iter);
> +	kfree(ctx->iter);
> +
> +	nlmsg_trim(skb, b);
> +
> +table_put:
> +	tcf_table_entry_put_table(pipeline, table);
> +
> +net_put:
> +	put_net(net);
> +
> +	return ret;
> +}
> +
> +static int tc_ctl_p4_dump_1(struct sk_buff *skb, struct netlink_callback *cb,
> +			    struct nlattr *arg, char *p_name)
> +{
> +	struct netlink_ext_ack *extack = cb->extack;
> +	u32 portid = NETLINK_CB(cb->skb).portid;
> +	const struct nlmsghdr *n = cb->nlh;
> +	u32 ids[P4TC_PATH_MAX] = { 0 };
> +	struct nlattr *tb[P4TC_MAX + 1];
> +	struct p4tcmsg *t_new;
> +	struct nlmsghdr *nlh;
> +	struct nlattr *root;
> +	struct p4tcmsg *t;
> +	u32 *arg_ids;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, P4TC_MAX, arg, p4tc_policy, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, RTM_GETP4TBENT, sizeof(*t),
> +			n->nlmsg_flags);
> +	if (!nlh)
> +		return -ENOSPC;
> +
> +	t = (struct p4tcmsg *)nlmsg_data(n);
> +	t_new = nlmsg_data(nlh);
> +	t_new->pipeid = t->pipeid;
> +	t_new->obj = t->obj;
> +
> +	if (!tb[P4TC_PATH]) {
> +		NL_SET_ERR_MSG(extack, "Must specify object path");
> +		return -EINVAL;
> +	}
> +
> +	if ((nla_len(tb[P4TC_PATH])) > (P4TC_PATH_MAX - 1) * sizeof(u32)) {
> +		NL_SET_ERR_MSG(extack, "Path is too big");
> +		return -E2BIG;
> +	}
> +
> +	ids[P4TC_PID_IDX] = t_new->pipeid;
> +	arg_ids = nla_data(tb[P4TC_PATH]);
> +	memcpy(&ids[P4TC_TBLID_IDX], arg_ids, nla_len(tb[P4TC_PATH]));
> +
> +	root = nla_nest_start(skb, P4TC_ROOT);
> +	ret = tcf_table_entry_dump(skb, tb[P4TC_PARAMS], ids, cb, &p_name,
> +				   extack);
> +	if (ret <= 0)
> +		goto out;
> +	nla_nest_end(skb, root);
> +
> +	if (p_name) {
> +		if (nla_put_string(skb, P4TC_ROOT_PNAME, p_name)) {
> +			ret = -1;
> +			goto out;
> +		}
> +	}
> +
> +	if (!t_new->pipeid)
> +		t_new->pipeid = ids[P4TC_PID_IDX];
> +
> +	nlmsg_end(skb, nlh);
> +
> +	return skb->len;
> +
> +out:
> +	nlmsg_cancel(skb, nlh);
> +	return ret;
> +}
> +
> +static int tc_ctl_p4_dump(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	char *p_name = NULL;
> +	int ret = 0;
> +	struct nlattr *p4tca[P4TC_ROOT_MAX + 1];
> +
> +	ret = nlmsg_parse(cb->nlh, sizeof(struct p4tcmsg), p4tca, P4TC_ROOT_MAX,
> +			  p4tc_root_policy, cb->extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!p4tca[P4TC_ROOT]) {
> +		NL_SET_ERR_MSG(cb->extack,
> +			       "Netlink P4TC table attributes missing");
> +		return -EINVAL;
> +	}
> +
> +	if (p4tca[P4TC_ROOT_PNAME])
> +		p_name = nla_data(p4tca[P4TC_ROOT_PNAME]);
> +
> +	return tc_ctl_p4_dump_1(skb, cb, p4tca[P4TC_ROOT], p_name);
> +}
> +
> +static int __init p4tc_tbl_init(void)
> +{
> +	rtnl_register(PF_UNSPEC, RTM_CREATEP4TBENT, tc_ctl_p4_cu, NULL,
> +		      RTNL_FLAG_DOIT_UNLOCKED);
> +	rtnl_register(PF_UNSPEC, RTM_DELP4TBENT, tc_ctl_p4_delete, NULL,
> +		      RTNL_FLAG_DOIT_UNLOCKED);
> +	rtnl_register(PF_UNSPEC, RTM_GETP4TBENT, tc_ctl_p4_get, tc_ctl_p4_dump,
> +		      RTNL_FLAG_DOIT_UNLOCKED);
> +
> +	return 0;
> +}
> +
> +subsys_initcall(p4tc_tbl_init);
> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> index 0a8daf2f8..3c26d4dc4 100644
> --- a/security/selinux/nlmsgtab.c
> +++ b/security/selinux/nlmsgtab.c
> @@ -97,6 +97,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] = {
>  	{ RTM_CREATEP4TEMPLATE,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>  	{ RTM_DELP4TEMPLATE,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>  	{ RTM_GETP4TEMPLATE,	NETLINK_ROUTE_SOCKET__NLMSG_READ },
> +	{ RTM_CREATEP4TBENT,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> +	{ RTM_DELP4TBENT,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> +	{ RTM_GETP4TBENT,	NETLINK_ROUTE_SOCKET__NLMSG_READ },
>  };
>  
>  static const struct nlmsg_perm nlmsg_tcpdiag_perms[] = {
> @@ -179,7 +182,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
>  		 * structures at the top of this file with the new mappings
>  		 * before updating the BUILD_BUG_ON() macro!
>  		 */
> -		BUILD_BUG_ON(RTM_MAX != (RTM_CREATEP4TEMPLATE + 3));
> +		BUILD_BUG_ON(RTM_MAX != (RTM_CREATEP4TBENT + 3));
>  		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
>  				 sizeof(nlmsg_route_perms));
>  		break;

