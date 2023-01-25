Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D8767BEE0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbjAYVon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbjAYVob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:44:31 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683051BE5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:44:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZWAIIy7caB5Ee1hEydFOjC7RegoGGcAB6h3TR0AOWO3toL3CJJfh8a1qIwLX2e6q4OSWOcMEKn8FTxacZY8TJgkq9YQ03hibNzvO+2jHcGHSm7XL5P9QlRX/82rlIbeJ/mwyeuIqy46tAsEmIx+WYPL6myNgKsAlxdhrKHC5vjlewnECqk/59AuHXuhQDdQZwjtUmv9yBk0J3tnDc5l/5+umPH9KQNl2unJ20JlMIJZbpVuGfhX3mf6UppD1OF1aE5h0BNjOGb9hVveqaVYSgtX4WQV2uqypOj/K/X+k+WNMLzDX5bvA50Qe+8ghNJHYc5Fp2MgcmjsjGHwKH9lYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMjGiXhEblvPEgJYq6c7eNN5tynnPs2a9O4f3vfD0IE=;
 b=eCFsqYppcngfMCVnVAFzsPusS1fwGlHLU/NEw1Emqb2iQaOamUWIOPHY0TRCRPpDaSlFnJFFtjEnQrspiXDR3lAC1MXkJzdCqTiFX3LNCJRaHtXBFYVOFM5Y6wigsnsEmHEpT3QUsJd2vu0CHLk7hjBK7XTbNWCsliI1gGJpYhpfH3pAwXF4g8DDtUrO1bnTw/8aUcAjSvIUEuLUcShNlL1mMCx8rLtt8lUx7kbq66LjTbTl4XsHiJJKZAaJpoiHzE7yPYC1TgVBKHOjWGvk+PdM+fJmkgbqWQt9bRE1Fuexx17p8fQGlWjTRwL/YiM7CY4zYj5pIWVw2OLqWKTkNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMjGiXhEblvPEgJYq6c7eNN5tynnPs2a9O4f3vfD0IE=;
 b=I0KeAltX1zRJQH4kaYme3J3SLvetywbWz0e3pnRx+YBuCZ1nV6vnfete/UP6XNstLRBXIPSZj/pFXGNE/d8RkIQde96IGbU06kX/ro7bfdMUCiROyAx7NPQ0lmTBx5I67fFYx27Nq4Tj517VjiOKCddR7CUcj5uWIMsWrUOIWUa3R9eSXZ81xlRGQvOKex030DBKWPTtUeLUatrDMnoSjaAbpllQA4QzWy/wci4mKq6Oq5QA3y+EpKEYoeIpJt7rFHANBnckgeeL21X2+MbJ7B4nyfnljW/yRsuqxilOr+/+JiXjmAJ1ThSnUbGAH5je5P/8D8UQc4ClCIk6BB3YsQ==
Received: from DS7PR06CA0043.namprd06.prod.outlook.com (2603:10b6:8:54::25) by
 CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 21:44:26 +0000
Received: from DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::c5) by DS7PR06CA0043.outlook.office365.com
 (2603:10b6:8:54::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Wed, 25 Jan 2023 21:44:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT084.mail.protection.outlook.com (10.13.172.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Wed, 25 Jan 2023 21:44:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 13:44:18 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 13:44:12 -0800
References: <20230124170510.316970-1-jhs@mojatatu.com>
 <20230124170510.316970-14-jhs@mojatatu.com>
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
Subject: Re: [PATCH net-next RFC 14/20] p4tc: add header field create, get,
 delete, flush and dump
Date:   Wed, 25 Jan 2023 23:39:34 +0200
In-Reply-To: <20230124170510.316970-14-jhs@mojatatu.com>
Message-ID: <87357ycms6.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT084:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: aa26e042-680a-4f6d-13b7-08daff1d5423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dapJSIjSpwDrksVzmX+j+UofcP43DFGZlRIZGSzFzVikVydVyhWmQ9AseSwi3ikDFc2/YO5pLu22mX6RbBhKg3+jWgKUP0qyFALj5lYwkh3YRJvi/afIPgGo49QL2G5drYxxSyIMtrGEsd7DDqIWTY7rj04Yg9cAhwwhRPqNMCVxoedasIDER2SN5iDgmIjVfSFY9koPttyKI0griSsohJiZ7cm/BdnfYdsVlWptV1dRXFV2hs6AqqUwh/ztT7QelCDTBJzU/mSXN/qAUvvuQKihbGJeyjFG/ed1PDoCDdaEz00OMNltt28jUUl4iJcg8g/bBwQEWWRHVDjCytU5mhgp7xYtyMJUkqISIdlxuKxyJd8iFGBf7VeU+P4Rw3Uyod2o3HjnuQ4mH8kxb+fMizRh2AkowJjk1pwVSTLlcnZkJKNuakCEr7+hbUd92yzGRUc+g9NGqdFBeXRVu1iVFkui+lEGFFhi80InoBmnNNv6gTeOka+Iixlw+gn2dtQO+qYL1RloX1y8ql0ZfnM8G6eaaKztTbHv93FDWgL5HE2QzAv3oHkXAd3kXbA80SkPnlWxFzuWdDUyARAhSJ1eUXHFzvDgYAtLF6GmkaFNTZe60OuVeefzN3MIydhH5xuD2xAVeeuZi0minL3L6kQ66brLbrmufsC2jE9y9fjjTqeDJ1a+JoJtDEooLUtciUeM6XM6QiVTVRNSAXeeFN6E0/OknPcClkYEaQpjaeu3hTXC7zYTqNZW3kSmgCO1mN0oAsuK1NKhUt9ToN8ME3EeEoB0H33NtfPBKPUpwmR8kiE=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199018)(40470700004)(46966006)(36840700001)(54906003)(356005)(36860700001)(316002)(40480700001)(2616005)(82310400005)(47076005)(70586007)(478600001)(86362001)(336012)(6666004)(6916009)(70206006)(4326008)(8676002)(16526019)(26005)(7696005)(186003)(30864003)(41300700001)(82740400003)(36756003)(83380400001)(2906002)(5660300002)(8936002)(426003)(7636003)(7416002)(40460700003)(21314003)(32563001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 21:44:25.5659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa26e042-680a-4f6d-13b7-08daff1d5423
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
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
> This commit allows control to create, get, delete, flush and dump header
> field objects. The created header fields are retrieved at runtime by
> the parser. From a control plane interaction, a header field can only be
> created once the appropriate parser is instantiated. At runtime, existing
> header fields can be referenced for computation reasons from metact:
> metact will use header fields to either create lookup keys or edit the
> header fields.
>
> Header fields are part of a pipeline and a parser instance and header
> fields can only be created in an unsealed pipeline.
>
> To create a header field, the user must issue the equivalent of the
> following command:
>
> tc p4template create hdrfield/myprog/myparser/ipv4/dstAddr hdrfieldid 4 \
>  type ipv4
>
> where myprog is the name of a pipeline, myparser is a name of a parser
> instance, ipv4/dstAddr is the name of header field which is of type ipv4.
>
> To delete a header field, the user must issue the equivalent of the
> following command:
>
> tc p4template delete hdrfield/myprog/myparser/ipv4/dstAddr
>
> where myprog is the name of pipeline, myparser is a name of a parser
> instance, ipv4/dstAddr is the name of header field to be deleted.
>
> To retrieve meta-information from a header field, such as length,
> position and type, the user must issue the equivalent of the following
> command:
>
> tc p4template get hdrfield/myprog/myparser/ipv4/dstAddr
>
> where myprog is the name of pipeline, myparser is a name of a parser
> instance, ipv4/dstAddr is the name of header field to be deleted.
>
> The user can also dump all the header fields available in a parser
> instance using the equivalent of the following command:
>
> tc p4template get hdrfield/myprog/myparser/
>
> With that, the user will get all the header field names available in a
> specific parser instance.
>
> The user can also flush all the header fields available in a parser
> instance using the equivalent of the following command:
>
> tc p4template del hdrfield/myprog/myparser/
>
> Header fields do not support update operations.
>
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/p4tc.h               |  62 +++
>  include/uapi/linux/p4tc.h        |  19 +
>  net/sched/p4tc/Makefile          |   3 +-
>  net/sched/p4tc/p4tc_hdrfield.c   | 625 +++++++++++++++++++++++++++++++
>  net/sched/p4tc/p4tc_parser_api.c | 229 +++++++++++
>  net/sched/p4tc/p4tc_pipeline.c   |   4 +
>  net/sched/p4tc/p4tc_tmpl_api.c   |   2 +
>  7 files changed, 943 insertions(+), 1 deletion(-)
>  create mode 100644 net/sched/p4tc/p4tc_hdrfield.c
>  create mode 100644 net/sched/p4tc/p4tc_parser_api.c
>
> diff --git a/include/net/p4tc.h b/include/net/p4tc.h
> index 748a70c85..13cf4162e 100644
> --- a/include/net/p4tc.h
> +++ b/include/net/p4tc.h
> @@ -19,6 +19,10 @@
>  
>  #define P4TC_PID_IDX 0
>  #define P4TC_MID_IDX 1
> +#define P4TC_PARSEID_IDX 1
> +#define P4TC_HDRFIELDID_IDX 2
> +
> +#define P4TC_HDRFIELD_IS_VALIDITY_BIT 0x1
>  
>  struct p4tc_dump_ctx {
>  	u32 ids[P4TC_PATH_MAX];
> @@ -83,6 +87,7 @@ struct p4tc_pipeline {
>  	struct idr                  p_meta_idr;
>  	struct rcu_head             rcu;
>  	struct net                  *net;
> +	struct p4tc_parser          *parser;
>  	struct tc_action            **preacts;
>  	int                         num_preacts;
>  	struct tc_action            **postacts;
> @@ -150,6 +155,30 @@ struct p4tc_metadata {
>  
>  extern const struct p4tc_template_ops p4tc_meta_ops;
>  
> +struct p4tc_parser {
> +	char parser_name[PARSERNAMSIZ];
> +	struct idr hdr_fields_idr;
> +#ifdef CONFIG_KPARSER
> +	const struct kparser_parser *kparser;
> +#endif
> +	refcount_t parser_ref;
> +	u32 parser_inst_id;
> +};
> +
> +struct p4tc_hdrfield {
> +	struct p4tc_template_common common;
> +	struct p4tc_parser          *parser;
> +	u32                         parser_inst_id;
> +	u32                         hdrfield_id;
> +	refcount_t                  hdrfield_ref;
> +	u16                         startbit;
> +	u16                         endbit;
> +	u8                          datatype; /* T_XXX */
> +	u8                          flags;  /* P4TC_HDRFIELD_FLAGS_* */
> +};
> +
> +extern const struct p4tc_template_ops p4tc_hdrfield_ops;
> +
>  struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
>  					 u32 m_id);
>  void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline);
> @@ -159,7 +188,40 @@ struct p4tc_metadata *tcf_meta_get(struct p4tc_pipeline *pipeline,
>  				   struct netlink_ext_ack *extack);
>  void tcf_meta_put_ref(struct p4tc_metadata *meta);
>  
> +struct p4tc_parser *tcf_parser_create(struct p4tc_pipeline *pipeline,
> +				      const char *parser_name,
> +				      u32 parser_inst_id,
> +				      struct netlink_ext_ack *extack);
> +
> +struct p4tc_parser *tcf_parser_find_byid(struct p4tc_pipeline *pipeline,
> +					 const u32 parser_inst_id);
> +struct p4tc_parser *tcf_parser_find_byany(struct p4tc_pipeline *pipeline,
> +					  const char *parser_name,
> +					  u32 parser_inst_id,
> +					  struct netlink_ext_ack *extack);
> +int tcf_parser_del(struct net *net, struct p4tc_pipeline *pipeline,
> +		   struct p4tc_parser *parser, struct netlink_ext_ack *extack);
> +bool tcf_parser_is_callable(struct p4tc_parser *parser);
> +int tcf_skb_parse(struct sk_buff *skb, struct p4tc_skb_ext *p4tc_ext,
> +		  struct p4tc_parser *parser);
> +
> +struct p4tc_hdrfield *tcf_hdrfield_find_byid(struct p4tc_parser *parser,
> +					     const u32 hdrfield_id);
> +struct p4tc_hdrfield *tcf_hdrfield_find_byany(struct p4tc_parser *parser,
> +					      const char *hdrfield_name,
> +					      u32 hdrfield_id,
> +					      struct netlink_ext_ack *extack);
> +bool tcf_parser_check_hdrfields(struct p4tc_parser *parser,
> +				struct p4tc_hdrfield *hdrfield);
> +void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield);
> +struct p4tc_hdrfield *tcf_hdrfield_get(struct p4tc_parser *parser,
> +				       const char *hdrfield_name,
> +				       u32 hdrfield_id,
> +				       struct netlink_ext_ack *extack);
> +void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield);
> +
>  #define to_pipeline(t) ((struct p4tc_pipeline *)t)
>  #define to_meta(t) ((struct p4tc_metadata *)t)
> +#define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
>  
>  #endif
> diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
> index 8934c032d..72714df9e 100644
> --- a/include/uapi/linux/p4tc.h
> +++ b/include/uapi/linux/p4tc.h
> @@ -27,6 +27,8 @@ struct p4tcmsg {
>  #define TEMPLATENAMSZ 256
>  #define PIPELINENAMSIZ TEMPLATENAMSZ
>  #define METANAMSIZ TEMPLATENAMSZ
> +#define PARSERNAMSIZ TEMPLATENAMSZ
> +#define HDRFIELDNAMSIZ TEMPLATENAMSZ
>  
>  /* Root attributes */
>  enum {
> @@ -55,6 +57,7 @@ enum {
>  	P4TC_OBJ_UNSPEC,
>  	P4TC_OBJ_PIPELINE,
>  	P4TC_OBJ_META,
> +	P4TC_OBJ_HDR_FIELD,
>  	__P4TC_OBJ_MAX,
>  };
>  #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
> @@ -153,6 +156,22 @@ enum {
>  };
>  #define P4TC_KERNEL_META_MAX (__P4TC_KERNEL_META_MAX - 1)
>  
> +struct p4tc_hdrfield_ty {
> +	__u16 startbit;
> +	__u16 endbit;
> +	__u8  datatype; /* P4T_* */
> +};
> +
> +/* Header field attributes */
> +enum {
> +	P4TC_HDRFIELD_UNSPEC,
> +	P4TC_HDRFIELD_DATA,
> +	P4TC_HDRFIELD_NAME,
> +	P4TC_HDRFIELD_PARSER_NAME,
> +	__P4TC_HDRFIELD_MAX
> +};
> +#define P4TC_HDRFIELD_MAX (__P4TC_HDRFIELD_MAX - 1)
> +
>  #define P4TC_RTA(r) \
>  	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
>  
> diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
> index d523e668c..add22c909 100644
> --- a/net/sched/p4tc/Makefile
> +++ b/net/sched/p4tc/Makefile
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
> -obj-y := p4tc_types.o p4tc_tmpl_api.o p4tc_pipeline.o p4tc_meta.o
> +obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
> +	p4tc_parser_api.o p4tc_hdrfield.o
> diff --git a/net/sched/p4tc/p4tc_hdrfield.c b/net/sched/p4tc/p4tc_hdrfield.c
> new file mode 100644
> index 000000000..2cbb0a624
> --- /dev/null
> +++ b/net/sched/p4tc/p4tc_hdrfield.c
> @@ -0,0 +1,625 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * net/sched/p4tc_hdrfield.c	P4 TC HEADER FIELD
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
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <net/net_namespace.h>
> +#include <net/pkt_cls.h>
> +#include <net/p4tc.h>
> +#include <net/netlink.h>
> +#include <net/p4tc_types.h>
> +#include <net/sock.h>
> +
> +static const struct nla_policy tc_hdrfield_policy[P4TC_HDRFIELD_MAX + 1] = {
> +	[P4TC_HDRFIELD_DATA] = { .type = NLA_BINARY,
> +				 .len = sizeof(struct p4tc_hdrfield_ty) },
> +	[P4TC_HDRFIELD_NAME] = { .type = NLA_STRING, .len = HDRFIELDNAMSIZ },
> +	[P4TC_HDRFIELD_PARSER_NAME] = { .type = NLA_STRING,
> +					.len = PARSERNAMSIZ },
> +};
> +
> +static int _tcf_hdrfield_put(struct p4tc_pipeline *pipeline,
> +			     struct p4tc_parser *parser,
> +			     struct p4tc_hdrfield *hdrfield,
> +			     bool unconditional_purge,
> +			     struct netlink_ext_ack *extack)
> +{
> +	if (!refcount_dec_if_one(&hdrfield->hdrfield_ref) &&
> +	    !unconditional_purge) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Unable to delete referenced header field");
> +		return -EBUSY;
> +	}
> +	idr_remove(&parser->hdr_fields_idr, hdrfield->hdrfield_id);
> +
> +	WARN_ON(!refcount_dec_not_one(&parser->parser_ref));
> +	kfree(hdrfield);
> +
> +	return 0;
> +}
> +
> +static int tcf_hdrfield_put(struct net *net, struct p4tc_template_common *tmpl,
> +			    bool unconditional_purge,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_hdrfield *hdrfield;
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_parser *parser;
> +
> +	pipeline = tcf_pipeline_find_byid(net, tmpl->p_id);
> +
> +	hdrfield = to_hdrfield(tmpl);
> +	parser = pipeline->parser;
> +
> +	return _tcf_hdrfield_put(pipeline, parser, hdrfield,
> +				 unconditional_purge, extack);
> +}
> +
> +static struct p4tc_hdrfield *hdrfield_find_name(struct p4tc_parser *parser,
> +						const char *hdrfield_name)
> +{
> +	struct p4tc_hdrfield *hdrfield;
> +	unsigned long tmp, id;
> +
> +	idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, id)
> +		if (hdrfield->common.name[0] &&
> +		    strncmp(hdrfield->common.name, hdrfield_name,
> +			    HDRFIELDNAMSIZ) == 0)
> +			return hdrfield;
> +
> +	return NULL;
> +}
> +
> +struct p4tc_hdrfield *tcf_hdrfield_find_byid(struct p4tc_parser *parser,
> +					     const u32 hdrfield_id)
> +{
> +	return idr_find(&parser->hdr_fields_idr, hdrfield_id);
> +}
> +
> +struct p4tc_hdrfield *tcf_hdrfield_find_byany(struct p4tc_parser *parser,
> +					      const char *hdrfield_name,
> +					      u32 hdrfield_id,
> +					      struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_hdrfield *hdrfield;
> +	int err;
> +
> +	if (hdrfield_id) {
> +		hdrfield = tcf_hdrfield_find_byid(parser, hdrfield_id);
> +		if (!hdrfield) {
> +			NL_SET_ERR_MSG(extack, "Unable to find hdrfield by id");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	} else {
> +		if (hdrfield_name) {
> +			hdrfield = hdrfield_find_name(parser, hdrfield_name);
> +			if (!hdrfield) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Header field name not found");
> +				err = -EINVAL;
> +				goto out;
> +			}
> +		} else {
> +			NL_SET_ERR_MSG(extack,
> +				       "Must specify hdrfield name or id");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	return hdrfield;
> +
> +out:
> +	return ERR_PTR(err);
> +}
> +
> +struct p4tc_hdrfield *tcf_hdrfield_get(struct p4tc_parser *parser,
> +				       const char *hdrfield_name,
> +				       u32 hdrfield_id,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_hdrfield *hdrfield;
> +
> +	hdrfield = tcf_hdrfield_find_byany(parser, hdrfield_name, hdrfield_id,
> +					   extack);
> +	if (IS_ERR(hdrfield))
> +		return hdrfield;
> +
> +	/* Should never happen */
> +	WARN_ON(!refcount_inc_not_zero(&hdrfield->hdrfield_ref));

I think regular refcount_inc() already generates a warning when
reference value is 0.

> +
> +	return hdrfield;
> +}
> +
> +void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield)
> +{
> +	WARN_ON(!refcount_dec_not_one(&hdrfield->hdrfield_ref));

ditto

> +}
> +
> +static struct p4tc_hdrfield *
> +tcf_hdrfield_find_byanyattr(struct p4tc_parser *parser,
> +			    struct nlattr *name_attr, u32 hdrfield_id,
> +			    struct netlink_ext_ack *extack)
> +{
> +	char *hdrfield_name = NULL;
> +
> +	if (name_attr)
> +		hdrfield_name = nla_data(name_attr);
> +
> +	return tcf_hdrfield_find_byany(parser, hdrfield_name, hdrfield_id,
> +				       extack);
> +}
> +
> +void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield)
> +{
> +	size_t hdr_offset_len = sizeof(u16);
> +	u16 *hdr_offset_bits, hdr_offset;
> +	struct p4tc_skb_ext *p4tc_skb_ext;
> +	u16 hdr_offset_index;
> +
> +	p4tc_skb_ext = skb_ext_find(skb, P4TC_SKB_EXT);
> +	if (!p4tc_skb_ext) {
> +		pr_err("Unable to find P4TC_SKB_EXT\n");
> +		return NULL;
> +	}
> +
> +	hdr_offset_index = (hdrfield->hdrfield_id - 1) * hdr_offset_len;
> +	if (hdrfield->flags & P4TC_HDRFIELD_IS_VALIDITY_BIT)
> +		return &p4tc_skb_ext->p4tc_ext->hdrs[hdr_offset_index];
> +
> +	hdr_offset_bits =
> +		(u16 *)&p4tc_skb_ext->p4tc_ext->hdrs[hdr_offset_index];
> +	hdr_offset = BITS_TO_BYTES(*hdr_offset_bits);
> +
> +	return skb_mac_header(skb) + hdr_offset;
> +}
> +
> +static struct p4tc_hdrfield *tcf_hdrfield_create(struct nlmsghdr *n,
> +						 struct nlattr *nla,
> +						 struct p4tc_pipeline *pipeline,
> +						 u32 *ids,
> +						 struct netlink_ext_ack *extack)
> +{
> +	u32 parser_id = ids[P4TC_PARSEID_IDX];
> +	char *hdrfield_name = NULL;
> +	const char *parser_name = NULL;
> +	u32 hdrfield_id = 0;
> +	struct nlattr *tb[P4TC_HDRFIELD_MAX + 1];
> +	struct p4tc_hdrfield_ty *hdr_arg;
> +	struct p4tc_hdrfield *hdrfield;
> +	struct p4tc_parser *parser;
> +	char *s;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, P4TC_HDRFIELD_MAX, nla, tc_hdrfield_policy,
> +			       extack);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	hdrfield_id = ids[P4TC_HDRFIELDID_IDX];
> +	if (!hdrfield_id) {
> +		NL_SET_ERR_MSG(extack, "Must specify header field id");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (!tb[P4TC_HDRFIELD_DATA]) {
> +		NL_SET_ERR_MSG(extack, "Must supply header field data");
> +		return ERR_PTR(-EINVAL);
> +	}
> +	hdr_arg = nla_data(tb[P4TC_HDRFIELD_DATA]);
> +
> +	if (tb[P4TC_HDRFIELD_PARSER_NAME])
> +		parser_name = nla_data(tb[P4TC_HDRFIELD_PARSER_NAME]);
> +
> +	rcu_read_lock();
> +	parser = tcf_parser_find_byany(pipeline, parser_name, parser_id, NULL);
> +	if (IS_ERR(parser)) {
> +		rcu_read_unlock();
> +		if (!parser_name) {
> +			NL_SET_ERR_MSG(extack, "Must supply parser name");
> +			return ERR_PTR(-EINVAL);
> +		}
> +
> +		/* If the parser instance wasn't created, let's create it here */
> +		parser = tcf_parser_create(pipeline, parser_name, parser_id,
> +					   extack);
> +
> +		if (IS_ERR(parser))
> +			return (void *)parser;
> +		rcu_read_lock();
> +	}
> +
> +	if (!refcount_inc_not_zero(&parser->parser_ref)) {
> +		NL_SET_ERR_MSG(extack, "Parser is stale");
> +		rcu_read_unlock();
> +		return ERR_PTR(-EBUSY);
> +	}
> +	rcu_read_unlock();
> +
> +	if (tb[P4TC_HDRFIELD_NAME])
> +		hdrfield_name = nla_data(tb[P4TC_HDRFIELD_NAME]);
> +
> +	if ((hdrfield_name && hdrfield_find_name(parser, hdrfield_name)) ||
> +	    tcf_hdrfield_find_byid(parser, hdrfield_id)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Header field with same id or name was already inserted");
> +		ret = -EEXIST;
> +		goto refcount_dec_parser;
> +	}
> +
> +	if (hdr_arg->startbit > hdr_arg->endbit) {
> +		NL_SET_ERR_MSG(extack, "Header field startbit > endbit");
> +		ret = -EINVAL;
> +		goto refcount_dec_parser;
> +	}
> +
> +	hdrfield = kzalloc(sizeof(*hdrfield), GFP_KERNEL);
> +	if (!hdrfield) {
> +		NL_SET_ERR_MSG(extack, "Failed to allocate hdrfield");
> +		ret = -ENOMEM;
> +		goto refcount_dec_parser;
> +	}
> +
> +	hdrfield->hdrfield_id = hdrfield_id;
> +
> +	s = strnchr(hdrfield_name, HDRFIELDNAMSIZ, '/');
> +	if (s++ && strncmp(s, "isValid", HDRFIELDNAMSIZ) == 0) {
> +		if (hdr_arg->datatype != P4T_U8 || hdr_arg->startbit != 0 ||
> +		    hdr_arg->endbit != 0) {
> +			NL_SET_ERR_MSG(extack,
> +				       "isValid data type must be bit1");
> +			ret = -EINVAL;
> +			goto free_hdr;
> +		}
> +		hdrfield->datatype = hdr_arg->datatype;
> +		hdrfield->flags = P4TC_HDRFIELD_IS_VALIDITY_BIT;
> +	} else {
> +		if (!p4type_find_byid(hdr_arg->datatype)) {
> +			NL_SET_ERR_MSG(extack, "Invalid hdrfield data type");
> +			ret = -EINVAL;
> +			goto free_hdr;
> +		}
> +		hdrfield->datatype = hdr_arg->datatype;
> +	}
> +
> +	hdrfield->startbit = hdr_arg->startbit;
> +	hdrfield->endbit = hdr_arg->endbit;
> +	hdrfield->parser_inst_id = parser->parser_inst_id;
> +
> +	ret = tcf_parser_check_hdrfields(parser, hdrfield);
> +	if (ret < 0)
> +		goto free_hdr;
> +
> +	ret = idr_alloc_u32(&parser->hdr_fields_idr, hdrfield, &hdrfield_id,
> +			    hdrfield_id, GFP_KERNEL);
> +	if (ret < 0) {
> +		NL_SET_ERR_MSG(extack, "Unable to allocate ID for hdrfield");
> +		goto free_hdr;
> +	}
> +
> +	hdrfield->common.p_id = pipeline->common.p_id;
> +	hdrfield->common.ops = (struct p4tc_template_ops *)&p4tc_hdrfield_ops;
> +	hdrfield->parser = parser;
> +	refcount_set(&hdrfield->hdrfield_ref, 1);
> +
> +	if (hdrfield_name)
> +		strscpy(hdrfield->common.name, hdrfield_name, HDRFIELDNAMSIZ);
> +
> +	return hdrfield;
> +
> +free_hdr:
> +	kfree(hdrfield);
> +
> +refcount_dec_parser:
> +	WARN_ON(!refcount_dec_not_one(&parser->parser_ref));
> +	return ERR_PTR(ret);
> +}
> +
> +static struct p4tc_template_common *
> +tcf_hdrfield_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
> +		struct p4tc_nl_pname *nl_pname, u32 *ids,
> +		struct netlink_ext_ack *extack)
> +{
> +	u32 pipeid = ids[P4TC_PID_IDX];
> +	struct p4tc_hdrfield *hdrfield;
> +	struct p4tc_pipeline *pipeline;
> +
> +	if (n->nlmsg_flags & NLM_F_REPLACE) {
> +		NL_SET_ERR_MSG(extack, "Header field update not supported");
> +		return ERR_PTR(-EOPNOTSUPP);
> +	}
> +
> +	pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data, pipeid,
> +						    extack);
> +	if (IS_ERR(pipeline))
> +		return (void *)pipeline;
> +
> +	hdrfield = tcf_hdrfield_create(n, nla, pipeline, ids, extack);
> +	if (IS_ERR(hdrfield))
> +		goto out;
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +out:
> +	return (struct p4tc_template_common *)hdrfield;
> +}
> +
> +static int _tcf_hdrfield_fill_nlmsg(struct sk_buff *skb,
> +				    struct p4tc_hdrfield *hdrfield)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_hdrfield_ty hdr_arg;
> +	struct nlattr *nest;
> +	/* Parser instance id + header field id */
> +	u32 ids[2];
> +
> +	ids[0] = hdrfield->parser_inst_id;
> +	ids[1] = hdrfield->hdrfield_id;
> +
> +	if (nla_put(skb, P4TC_PATH, sizeof(ids), ids))
> +		goto out_nlmsg_trim;
> +
> +	nest = nla_nest_start(skb, P4TC_PARAMS);
> +	if (!nest)
> +		goto out_nlmsg_trim;
> +
> +	hdr_arg.datatype = hdrfield->datatype;
> +	hdr_arg.startbit = hdrfield->startbit;
> +	hdr_arg.endbit = hdrfield->endbit;
> +
> +	if (hdrfield->common.name[0]) {
> +		if (nla_put_string(skb, P4TC_HDRFIELD_NAME,
> +				   hdrfield->common.name))
> +			goto out_nlmsg_trim;
> +	}
> +
> +	if (nla_put(skb, P4TC_HDRFIELD_DATA, sizeof(hdr_arg), &hdr_arg))
> +		goto out_nlmsg_trim;
> +
> +	nla_nest_end(skb, nest);
> +
> +	return skb->len;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return -1;
> +}
> +
> +static int tcf_hdrfield_fill_nlmsg(struct net *net, struct sk_buff *skb,
> +				   struct p4tc_template_common *template,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_hdrfield *hdrfield = to_hdrfield(template);
> +
> +	if (_tcf_hdrfield_fill_nlmsg(skb, hdrfield) <= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Failed to fill notification attributes for pipeline");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tcf_hdrfield_flush(struct sk_buff *skb,
> +			      struct p4tc_pipeline *pipeline,
> +			      struct p4tc_parser *parser,
> +			      struct netlink_ext_ack *extack)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	int ret = 0;
> +	int i = 0;
> +	struct p4tc_hdrfield *hdrfield;
> +	u32 path[2];
> +	unsigned long tmp, hdrfield_id;
> +
> +	path[0] = parser->parser_inst_id;
> +	path[1] = 0;
> +
> +	if (nla_put(skb, P4TC_PATH, sizeof(path), path))
> +		goto out_nlmsg_trim;
> +
> +	if (idr_is_empty(&parser->hdr_fields_idr)) {
> +		NL_SET_ERR_MSG(extack, "There are no header fields to flush");
> +		goto out_nlmsg_trim;
> +	}
> +
> +	idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, hdrfield_id) {
> +		if (_tcf_hdrfield_put(pipeline, parser, hdrfield, false, extack) < 0) {
> +			ret = -EBUSY;
> +			continue;
> +		}
> +		i++;
> +	}
> +
> +	nla_put_u32(skb, P4TC_COUNT, i);
> +
> +	if (ret < 0) {
> +		if (i == 0) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Unable to flush any table instance");
> +			goto out_nlmsg_trim;
> +		} else {
> +			NL_SET_ERR_MSG(extack,
> +				       "Unable to flush all table instances");
> +		}
> +	}
> +
> +	return i;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return 0;
> +}
> +
> +static int tcf_hdrfield_gd(struct net *net, struct sk_buff *skb,
> +			   struct nlmsghdr *n, struct nlattr *nla,
> +			   struct p4tc_nl_pname *nl_pname, u32 *ids,
> +			   struct netlink_ext_ack *extack)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	u32 pipeid = ids[P4TC_PID_IDX];
> +	u32 parser_inst_id = ids[P4TC_PARSEID_IDX];
> +	u32 hdrfield_id = ids[P4TC_HDRFIELDID_IDX];
> +	struct nlattr *tb[P4TC_HDRFIELD_MAX + 1];
> +	struct p4tc_hdrfield *hdrfield;
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_parser *parser;
> +	char *parser_name;
> +	int ret;
> +
> +	pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid, extack);
> +	if (IS_ERR(pipeline))
> +		return PTR_ERR(pipeline);
> +
> +	ret = nla_parse_nested(tb, P4TC_HDRFIELD_MAX, nla, tc_hdrfield_policy,
> +			       extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	parser_name = tb[P4TC_HDRFIELD_PARSER_NAME] ?
> +		nla_data(tb[P4TC_HDRFIELD_PARSER_NAME]) : NULL;
> +
> +	parser = tcf_parser_find_byany(pipeline, parser_name, parser_inst_id,
> +				       extack);
> +	if (IS_ERR(parser))
> +		return PTR_ERR(parser);
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	if (n->nlmsg_type == RTM_DELP4TEMPLATE && n->nlmsg_flags & NLM_F_ROOT)
> +		return tcf_hdrfield_flush(skb, pipeline, parser, extack);
> +
> +	hdrfield = tcf_hdrfield_find_byanyattr(parser, tb[P4TC_HDRFIELD_NAME],
> +					       hdrfield_id, extack);
> +	if (IS_ERR(hdrfield))
> +		return PTR_ERR(hdrfield);
> +
> +	ret = _tcf_hdrfield_fill_nlmsg(skb, hdrfield);
> +	if (ret < 0)
> +		return -ENOMEM;
> +
> +	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
> +		ret = _tcf_hdrfield_put(pipeline, parser, hdrfield, false,
> +					extack);
> +		if (ret < 0)
> +			goto out_nlmsg_trim;
> +	}
> +
> +	return 0;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return ret;
> +}
> +
> +static int tcf_hdrfield_dump_1(struct sk_buff *skb,
> +			       struct p4tc_template_common *common)
> +{
> +	struct p4tc_hdrfield *hdrfield = to_hdrfield(common);
> +	struct nlattr *param = nla_nest_start(skb, P4TC_PARAMS);
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	u32 path[2];
> +
> +	if (!param)
> +		goto out_nlmsg_trim;
> +
> +	if (hdrfield->common.name[0] &&
> +	    nla_put_string(skb, P4TC_HDRFIELD_NAME, hdrfield->common.name))
> +		goto out_nlmsg_trim;
> +
> +	nla_nest_end(skb, param);
> +
> +	path[0] = hdrfield->parser_inst_id;
> +	path[1] = hdrfield->hdrfield_id;
> +	if (nla_put(skb, P4TC_PATH, sizeof(path), path))
> +		goto out_nlmsg_trim;
> +
> +	return 0;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return -ENOMEM;
> +}
> +
> +static int tcf_hdrfield_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
> +			     struct nlattr *nla, char **p_name, u32 *ids,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_HDRFIELD_MAX + 1] = { NULL };
> +	const u32 pipeid = ids[P4TC_PID_IDX];
> +	struct net *net = sock_net(skb->sk);
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_parser *parser;
> +	int ret;
> +
> +	if (!ctx->ids[P4TC_PID_IDX]) {
> +		pipeline =
> +			tcf_pipeline_find_byany(net, *p_name, pipeid, extack);
> +		if (IS_ERR(pipeline))
> +			return PTR_ERR(pipeline);
> +		ctx->ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +	} else {
> +		pipeline = tcf_pipeline_find_byid(net, ctx->ids[P4TC_PID_IDX]);
> +	}
> +
> +	if (!ctx->ids[P4TC_PARSEID_IDX]) {
> +		if (nla) {
> +			ret = nla_parse_nested(tb, P4TC_HDRFIELD_MAX, nla,
> +					       tc_hdrfield_policy, extack);
> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +		parser = tcf_parser_find_byany(pipeline,
> +					       nla_data(tb[P4TC_HDRFIELD_PARSER_NAME]),
> +					       ids[P4TC_PARSEID_IDX], extack);
> +		if (IS_ERR(parser))
> +			return PTR_ERR(parser);
> +
> +		ctx->ids[P4TC_PARSEID_IDX] = parser->parser_inst_id;
> +	} else {
> +		parser = pipeline->parser;
> +	}
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	if (!(*p_name))
> +		*p_name = pipeline->common.name;
> +
> +	return tcf_p4_tmpl_generic_dump(skb, ctx, &parser->hdr_fields_idr,
> +					P4TC_HDRFIELDID_IDX, extack);
> +}
> +
> +const struct p4tc_template_ops p4tc_hdrfield_ops = {
> +	.init = NULL,
> +	.cu = tcf_hdrfield_cu,
> +	.fill_nlmsg = tcf_hdrfield_fill_nlmsg,
> +	.gd = tcf_hdrfield_gd,
> +	.put = tcf_hdrfield_put,
> +	.dump = tcf_hdrfield_dump,
> +	.dump_1 = tcf_hdrfield_dump_1,
> +};
> diff --git a/net/sched/p4tc/p4tc_parser_api.c b/net/sched/p4tc/p4tc_parser_api.c
> new file mode 100644
> index 000000000..267a58aeb
> --- /dev/null
> +++ b/net/sched/p4tc/p4tc_parser_api.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * net/sched/p4tc_parser_api.c	P4 TC PARSER API
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
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <net/net_namespace.h>
> +#include <net/pkt_cls.h>
> +#include <net/p4tc.h>
> +#include <net/kparser.h>
> +#include <net/netlink.h>
> +
> +static struct p4tc_parser *parser_find_name(struct p4tc_pipeline *pipeline,
> +					    const char *parser_name)
> +{
> +	if (unlikely(!pipeline->parser))
> +		return NULL;
> +
> +	if (!strncmp(pipeline->parser->parser_name, parser_name, PARSERNAMSIZ))
> +		return pipeline->parser;
> +
> +	return NULL;
> +}
> +
> +struct p4tc_parser *tcf_parser_find_byid(struct p4tc_pipeline *pipeline,
> +					 const u32 parser_inst_id)
> +{
> +	if (unlikely(!pipeline->parser))
> +		return NULL;
> +
> +	if (parser_inst_id == pipeline->parser->parser_inst_id)
> +		return pipeline->parser;
> +
> +	return NULL;
> +}
> +
> +static struct p4tc_parser *__parser_find(struct p4tc_pipeline *pipeline,
> +					 const char *parser_name,
> +					 u32 parser_inst_id,
> +					 struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_parser *parser;
> +	int err;
> +
> +	if (parser_inst_id) {
> +		parser = tcf_parser_find_byid(pipeline, parser_inst_id);
> +		if (!parser) {
> +			if (extack)
> +				NL_SET_ERR_MSG(extack,
> +					       "Unable to find parser by id");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	} else {
> +		if (parser_name) {
> +			parser = parser_find_name(pipeline, parser_name);
> +			if (!parser) {
> +				if (extack)
> +					NL_SET_ERR_MSG(extack,
> +						       "Parser name not found");
> +				err = -EINVAL;
> +				goto out;
> +			}
> +		} else {
> +			if (extack)
> +				NL_SET_ERR_MSG(extack,
> +					       "Must specify parser name or id");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	return parser;
> +
> +out:
> +	return ERR_PTR(err);
> +}
> +
> +struct p4tc_parser *tcf_parser_find_byany(struct p4tc_pipeline *pipeline,
> +					  const char *parser_name,
> +					  u32 parser_inst_id,
> +					  struct netlink_ext_ack *extack)
> +{
> +	return __parser_find(pipeline, parser_name, parser_inst_id, extack);
> +}
> +
> +#ifdef CONFIG_KPARSER
> +int tcf_skb_parse(struct sk_buff *skb, struct p4tc_skb_ext *p4tc_skb_ext,
> +		  struct p4tc_parser *parser)
> +{
> +	void *hdr = skb_mac_header(skb);
> +	size_t pktlen = skb_mac_header_len(skb) + skb->len;
> +
> +	return __kparser_parse(parser->kparser, hdr, pktlen,
> +			       p4tc_skb_ext->p4tc_ext->hdrs, HEADER_MAX_LEN);
> +}
> +
> +static int __tcf_parser_fill(struct p4tc_parser *parser,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct kparser_hkey kparser_key = { 0 };
> +
> +	kparser_key.id = parser->parser_inst_id;
> +	strscpy(kparser_key.name, parser->parser_name, KPARSER_MAX_NAME);
> +
> +	parser->kparser = kparser_get_parser(&kparser_key, false);
> +	if (!parser->kparser) {
> +		NL_SET_ERR_MSG(extack, "Unable to get kparser instance");
> +		return -ENOENT;
> +	}
> +
> +	return 0;
> +}
> +
> +void __tcf_parser_put(struct p4tc_parser *parser)
> +{
> +	kparser_put_parser(parser->kparser, false);
> +}
> +
> +bool tcf_parser_is_callable(struct p4tc_parser *parser)
> +{
> +	return parser && parser->kparser;
> +}
> +#else
> +int tcf_skb_parse(struct sk_buff *skb, struct p4tc_skb_ext *p4tc_skb_ext,
> +		  struct p4tc_parser *parser)
> +{
> +	return 0;
> +}
> +
> +static int __tcf_parser_fill(struct p4tc_parser *parser,
> +			     struct netlink_ext_ack *extack)
> +{
> +	return 0;
> +}
> +
> +void __tcf_parser_put(struct p4tc_parser *parser)
> +{
> +}
> +
> +bool tcf_parser_is_callable(struct p4tc_parser *parser)
> +{
> +	return !!parser;
> +}
> +#endif
> +
> +struct p4tc_parser *
> +tcf_parser_create(struct p4tc_pipeline *pipeline, const char *parser_name,
> +		  u32 parser_inst_id, struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_parser *parser;
> +	int ret;
> +
> +	if (pipeline->parser) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Can only have one parser instance per pipeline");
> +		return ERR_PTR(-EEXIST);
> +	}
> +
> +	parser = kzalloc(sizeof(*parser), GFP_KERNEL);
> +	if (!parser)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (parser_inst_id)
> +		parser->parser_inst_id = parser_inst_id;
> +	else
> +		/* Assign to KPARSER_KMOD_ID_MAX + 1 if no ID was supplied */
> +		parser->parser_inst_id = KPARSER_KMOD_ID_MAX + 1;
> +
> +	strscpy(parser->parser_name, parser_name, PARSERNAMSIZ);
> +
> +	ret = __tcf_parser_fill(parser, extack);
> +	if (ret < 0)
> +		goto err;
> +
> +	refcount_set(&parser->parser_ref, 1);
> +
> +	idr_init(&parser->hdr_fields_idr);
> +
> +	pipeline->parser = parser;
> +
> +	return parser;
> +
> +err:
> +	kfree(parser);
> +	return ERR_PTR(ret);
> +}
> +
> +/* Dummy function which just returns true
> + * Once we have the proper parser code, this function will work properly
> + */
> +bool tcf_parser_check_hdrfields(struct p4tc_parser *parser,
> +				struct p4tc_hdrfield *hdrfield)
> +{
> +	return true;
> +}
> +
> +int tcf_parser_del(struct net *net, struct p4tc_pipeline *pipeline,
> +		   struct p4tc_parser *parser, struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_hdrfield *hdrfield;
> +	unsigned long hdr_field_id, tmp;
> +
> +	__tcf_parser_put(parser);
> +
> +	idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, hdr_field_id)
> +		hdrfield->common.ops->put(net, &hdrfield->common, true, extack);
> +
> +	idr_destroy(&parser->hdr_fields_idr);
> +
> +	pipeline->parser = NULL;
> +
> +	kfree(parser);
> +
> +	return 0;
> +}
> diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
> index 49f0062ad..6fc7bd49d 100644
> --- a/net/sched/p4tc/p4tc_pipeline.c
> +++ b/net/sched/p4tc/p4tc_pipeline.c
> @@ -115,6 +115,8 @@ static int tcf_pipeline_put(struct net *net,
>          }
>  
>  	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
> +	if (pipeline->parser)
> +		tcf_parser_del(net, pipeline, pipeline->parser, extack);
>  
>  	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
>  		meta->common.ops->put(net, &meta->common, true, extack);
> @@ -319,6 +321,8 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
>  		pipeline->num_postacts = 0;
>  	}
>  
> +	pipeline->parser = NULL;
> +
>  	idr_init(&pipeline->p_meta_idr);
>  	pipeline->p_meta_offset = 0;
>  
> diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
> index a13d02ce5..325b56d2e 100644
> --- a/net/sched/p4tc/p4tc_tmpl_api.c
> +++ b/net/sched/p4tc/p4tc_tmpl_api.c
> @@ -43,6 +43,7 @@ static bool obj_is_valid(u32 obj)
>  	switch (obj) {
>  	case P4TC_OBJ_PIPELINE:
>  	case P4TC_OBJ_META:
> +	case P4TC_OBJ_HDR_FIELD:
>  		return true;
>  	default:
>  		return false;
> @@ -52,6 +53,7 @@ static bool obj_is_valid(u32 obj)
>  static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
>  	[P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
>  	[P4TC_OBJ_META] = &p4tc_meta_ops,
> +	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
>  };
>  
>  int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,

