Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C47F67B78C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbjAYQ57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbjAYQ55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:57:57 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A4EBB92
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:57:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLR0EqUN1BAp36nRjZlJ4p/jMyO2YV6V4cHFyf+JKgxohqynkQOd7/48silPecUVIYXItZqSN5PdC91BRCnfws4fEYZGAcuNlLy293zXNR58B6NhOHGBY1/znvWqBXGf3H3pKNYt5KhXIQ7KGMl63K4qiOwWo/kdrUtxEjaIuW/wwgKWkkAl7umaLDY6QghzV0ZrruC8U8sG9hVmaM3Bpja5wJ6brHVI+Xyjzq6z69kgpCkGf2i51tcxDB0ylVR6YxshpQbawtjhv+bdQoKwCmoOGloo9sD+MARP9yf8Nnddx4KTPqlW9AW/5dI9g6j701Xrq6pqXjV9fVkTFs0jTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeTPWkTVLwr9iPg3CG5exdyds759z4hZkPzCNSVqtEw=;
 b=llsb8yVDexBl/XhpeHKVv6WaQ5h4dRrHKIV1WAmlNuyt+OjgxxJvjBiSt8QYD6atwP0F3RDYqwubFYw4WAGiN5+gmXcq+wvOe2ehk00OnsAJAW0qlOIrj+YTmKRycyD6Z8vw6z1JZIeVRxGiGox30qechNGWUWfknDHYe+6a9w+Ie3xQ+tvbG0Ote/54Cj35F+wHeAf4zM5FrTbxGvzjgRSSryO00lkgUjzsJd2X0xm2lgRG6ju1qOwB8VxAENTiFBP5qOn7agF2JHp85D8iT0jnuzTUu5HgqrXSdXeUwsodsJXxLaKNRwEiEBIiM1226Z6WSYnmS4lkgfmtz4F/4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeTPWkTVLwr9iPg3CG5exdyds759z4hZkPzCNSVqtEw=;
 b=AVsK3GVPIb99aozbSIVMRsdUBOgC3RozqyiQr8xLzppC3RJ63o4OtR6kiyPdIWY7YrklINir4oRLMZuPQrd9jdUsX4xcNg8yrl4JQsXzx1ryVri+RbXOnx/z5w/jCL+pzds7nFzTiUsGIwwGiqgC2l/p0YDeLcb0FQV3y/PHPUX5TU73Od31GsXdONXTrWZAclgQ7tzRkZJVTE+cYj532cD0ihIcmzR42mJT898M+ANVn5FP2F68FcZvpKfeQjRlNyElHZFwWlW1mUZBGzpUwl7KI/7bp7swcK3k5s/wE59t/W7CMYtMAIuG7KcLbVSpO6Vtyknv7u5JWgwaLidV7g==
Received: from DM6PR03CA0096.namprd03.prod.outlook.com (2603:10b6:5:333::29)
 by BY5PR12MB4274.namprd12.prod.outlook.com (2603:10b6:a03:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 16:57:45 +0000
Received: from DS1PEPF0000E655.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::fd) by DM6PR03CA0096.outlook.office365.com
 (2603:10b6:5:333::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Wed, 25 Jan 2023 16:57:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E655.mail.protection.outlook.com (10.167.18.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.12 via Frontend Transport; Wed, 25 Jan 2023 16:57:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 08:57:44 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 08:57:39 -0800
References: <20230124170510.316970-1-jhs@mojatatu.com>
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
Subject: Re: [PATCH net-next RFC 01/20] net/sched: act_api: change act_base
 into an IDR
Date:   Wed, 25 Jan 2023 18:48:57 +0200
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
Message-ID: <87k01ad01q.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E655:EE_|BY5PR12MB4274:EE_
X-MS-Office365-Filtering-Correlation-Id: 79c3c225-c90c-4951-5878-08dafef547aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H86OTHMCBr+OJPVMf7F+3O0s9x5Lie3fGXz9OivvxojxereGl65yLveZxPHdqJVyIjMWSGxUA8zb9Wco0GOUwQAGMHSnHcmmj8PsLNcFQJn0U5StdvH7lXNFlqP+xE4cpXZHbojSgXIsE5KI6EsnQ22sGqnx3s3SxT2Go4JdtC7wHOV1SnjQSeU6YcsEO8xzo8E8DiW0o+gIwuHXzubLGfa7YVcmB8OkKe92EGNcZpz3h9zj1Shgo+a9+5hCLNFRHxVVQnsuvETNpaOl51hJjFym6IF7OJYCnbqBPuuvdcD8Fj1IXug6JyI42GRRbjttRFbH76l7v56xHvK3iIRsEwmaKY/U/G2mEPwyAY6UOXwatDnnnyOq/IyuWauQJGM424fDLLPJAj3uK6Hs3/1kVwGAVgB6/XlwLleOrmM/MZa9i1Nbr3zyaHM1oP5nj464oQBzs4cfWO476l7hV37TGN12gc9opezKfiaBGVbMtiANrL3k8bwfOR0onhCGRA0GLyXyAre3aRadSE6Zxr9c9ObzsaXOYgcdAZW2ATOlS7R/ymrwVAnZA7i0KIDEfA4QfuKM/iJPrQwFW945kS7hOmAohNUuzi5pDq6+H+dawfuOwTTI91QiCkcsq1mnuqQVZ13hqAx7CT3fPOS9l4+Nb9i5yivTBe2G4Swf4HJohhE=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199018)(46966006)(36840700001)(16526019)(66899018)(47076005)(36756003)(8676002)(40480700001)(54906003)(356005)(36860700001)(7636003)(336012)(2616005)(426003)(83380400001)(86362001)(26005)(82310400005)(186003)(478600001)(7416002)(5660300002)(6666004)(82740400003)(7696005)(316002)(70206006)(6916009)(41300700001)(8936002)(2906002)(70586007)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 16:57:44.7729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79c3c225-c90c-4951-5878-08dafef547aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E655.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Jan 2023 at 12:04, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> Convert act_base from a list to an IDR.
>
> With the introduction of P4TC action templates, we introduce the concept of
> dynamically creating actions on the fly. Dynamic action IDs are not statically
> defined (as was the case previously) and are therefore harder to manage within
> existing linked list approach. We convert to IDR because it has built in ID
> management which we would have to re-invent with linked lists.
>
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/uapi/linux/pkt_cls.h |  1 +
>  net/sched/act_api.c          | 39 +++++++++++++++++++++---------------
>  2 files changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 648a82f32..4d716841c 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -139,6 +139,7 @@ enum tca_id {
>  	TCA_ID_MPLS,
>  	TCA_ID_CT,
>  	TCA_ID_GATE,
> +	TCA_ID_DYN,
>  	/* other actions go here */
>  	__TCA_ID_MAX = 255
>  };
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index cd09ef49d..811dddc3b 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -890,7 +890,7 @@ void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
>  }
>  EXPORT_SYMBOL(tcf_idrinfo_destroy);
>  
> -static LIST_HEAD(act_base);
> +static DEFINE_IDR(act_base);
>  static DEFINE_RWLOCK(act_mod_lock);
>  /* since act ops id is stored in pernet subsystem list,
>   * then there is no way to walk through only all the action
> @@ -949,7 +949,6 @@ static void tcf_pernet_del_id_list(unsigned int id)
>  int tcf_register_action(struct tc_action_ops *act,
>  			struct pernet_operations *ops)
>  {
> -	struct tc_action_ops *a;
>  	int ret;
>  
>  	if (!act->act || !act->dump || !act->init)
> @@ -970,13 +969,24 @@ int tcf_register_action(struct tc_action_ops *act,
>  	}
>  
>  	write_lock(&act_mod_lock);
> -	list_for_each_entry(a, &act_base, head) {
> -		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
> +	if (act->id) {
> +		if (idr_find(&act_base, act->id)) {
>  			ret = -EEXIST;
>  			goto err_out;
>  		}
> +		ret = idr_alloc_u32(&act_base, act, &act->id, act->id,
> +				    GFP_ATOMIC);
> +		if (ret < 0)
> +			goto err_out;
> +	} else {
> +		/* Only dynamic actions will require ID generation */
> +		act->id = TCA_ID_DYN;

Hi Jamal,

Since TCA_ID_DYN is exposed to userspace and this code expects to use
the whole range of [TCA_ID_DYN, TCA_ID_MAX] for dynamic actions any new
action added after that will have two choices:

- Insert future TCA_ID_*NEW_ACTION* before TCA_ID_DYN in the enum tca_id
in order for this code to continue to work (probably breaking userspace
code compiled for previous kernels).

- Modify this code to allocate dynamic action id from empty range
following new action enum value, which is not ideal.

Maybe consider defining TCA_ID_DYN=128 in order to leave some space for
new actions to be added before it without affecting the userspace?

> +
> +		ret = idr_alloc_u32(&act_base, act, &act->id, TCA_ID_MAX,
> +				    GFP_ATOMIC);
> +		if (ret < 0)
> +			goto err_out;
>  	}
> -	list_add_tail(&act->head, &act_base);
>  	write_unlock(&act_mod_lock);
>  
>  	return 0;
> @@ -994,17 +1004,12 @@ EXPORT_SYMBOL(tcf_register_action);
>  int tcf_unregister_action(struct tc_action_ops *act,
>  			  struct pernet_operations *ops)
>  {
> -	struct tc_action_ops *a;
> -	int err = -ENOENT;
> +	int err = 0;
>  
>  	write_lock(&act_mod_lock);
> -	list_for_each_entry(a, &act_base, head) {
> -		if (a == act) {
> -			list_del(&act->head);
> -			err = 0;
> -			break;
> -		}
> -	}
> +	if (!idr_remove(&act_base, act->id))
> +		err = -EINVAL;
> +
>  	write_unlock(&act_mod_lock);
>  	if (!err) {
>  		unregister_pernet_subsys(ops);
> @@ -1019,10 +1024,11 @@ EXPORT_SYMBOL(tcf_unregister_action);
>  static struct tc_action_ops *tc_lookup_action_n(char *kind)
>  {
>  	struct tc_action_ops *a, *res = NULL;
> +	unsigned long tmp, id;
>  
>  	if (kind) {
>  		read_lock(&act_mod_lock);
> -		list_for_each_entry(a, &act_base, head) {
> +		idr_for_each_entry_ul(&act_base, a, tmp, id) {
>  			if (strcmp(kind, a->kind) == 0) {
>  				if (try_module_get(a->owner))
>  					res = a;
> @@ -1038,10 +1044,11 @@ static struct tc_action_ops *tc_lookup_action_n(char *kind)
>  static struct tc_action_ops *tc_lookup_action(struct nlattr *kind)
>  {
>  	struct tc_action_ops *a, *res = NULL;
> +	unsigned long tmp, id;
>  
>  	if (kind) {
>  		read_lock(&act_mod_lock);
> -		list_for_each_entry(a, &act_base, head) {
> +		idr_for_each_entry_ul(&act_base, a, tmp, id) {
>  			if (nla_strcmp(kind, a->kind) == 0) {
>  				if (try_module_get(a->owner))
>  					res = a;

