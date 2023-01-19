Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5527267328F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjASHfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 02:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjASHer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 02:34:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614A863E24;
        Wed, 18 Jan 2023 23:34:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk9lt0fwZW1arj9X20aavrYcd9ERWa1m81Qg6nX1qKNp1XvPjToSEohnxehNslDwOunxjNzBbxthtyQCePEChblRS6zoM7aoWVDqljfm2sKXlYpK1hTO4W/ehliSOpsH8T/LWKxyahcUgFkLo4Fm4kXp1CTPS9Lqr+KDhrwJk4yqe4kmXIntkGJXhxKDe15wNtfv0lZBG0XSjqBFpdtwpOU9eNV0VWt/bg21bvRf7E9fb/K/lrwzWNsJTWp+RDp/g5FwGZEbvfQ3ogF1u5wrLirR6KncrsvZbEECvuKD3mzsMYdMjnDGAeL8yEQoA/Z6HTJJGZRbBugWbwJ7JIvVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNR4lyNsNHC1jtWrmpPKZRp8BwTA/en7TBzuEJIRyHQ=;
 b=CQcgmQia5sQuFmH0pnL+BoXdTPCmirrPAJvFaDOFPg0kcbOISen5WXt8McAUkCSY8a1ntnTARaNaKozVrko01qz/mUj5ApOXe5KWFIRSd9PwIfxBaUBz4rSpBdlF/2zmREVrHCKnW3a269tuQoTgh6yW/WC+5ODRKioD+qE+GeNiHA62k6DtP6ONwXHaEfn73XdlYfMkt+OqvBgrJKfrsWDgPsJN1DmM4+Ws8k0kKikTwPTYJV0pC38oHLsrXmj95yeqChyVrzRgnGEaIZQDvz/9gIyLU8O8hzIPxneJe45xTDSiMr0usSDcrfAhY6JQehChbeR/jkoBo6NY43A7sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNR4lyNsNHC1jtWrmpPKZRp8BwTA/en7TBzuEJIRyHQ=;
 b=MoIoOLWHBgZR9sNAAS3JGw5PInBMkqUGakTXvYNw2jd9wGg7EAYHzreEYiaEcBH16fZEl7acVCFV+HQzNLOUOfysYyD84XOaxEaEjEOQKLdjooFkH3aI7v4K+unqMixZmXMrgxAlq8MGfXB0+hwWRoKC/LFHijnFG9sun+LGSMhUTOrq4kjPrJfrDwvMHlrA26u0yJCqlZNA8p7RfwuHSu7Dy31jY/OGKAte2O1DOuvHuELd/li/em/c/Y6RiYFGTdXg35ONzo2fqYpaALbpDG9cSevn3+VnbSux6VnNZLKpD3qev2O/KrIYPpK2Mv+wldji3afgXdQ1Dfp7HVJ25w==
Received: from DS7P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::32) by
 MN0PR12MB6002.namprd12.prod.outlook.com (2603:10b6:208:37e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 07:34:41 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::da) by DS7P222CA0026.outlook.office365.com
 (2603:10b6:8:2e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 07:34:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 07:34:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 23:34:34 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 23:34:31 -0800
References: <20230118123208.17167-1-fw@strlen.de>
 <20230118123208.17167-10-fw@strlen.de>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Florian Westphal <fw@strlen.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [PATCH net-next 9/9] netfilter: nf_tables: add support to
 destroy operation
Date:   Thu, 19 Jan 2023 09:29:50 +0200
In-Reply-To: <20230118123208.17167-10-fw@strlen.de>
Message-ID: <87o7qvasfv.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT093:EE_|MN0PR12MB6002:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c2137f-608e-4ffd-0a09-08daf9efa05e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYwz6Bk7RX+oi8qLRwt728hrRbll0NNIaqxeGxKOkBEWlRT5PRnQVL1wutCHjIpHhYnaOmgH0wwBtum59L/JDMxo6GnQCsZdYgVz/sW6Nqrxzinmh2zYtDz9vdLCfXBstcnn1NzFGxx3Mo63UIbALIsQjXOtspTD0a9PavbkSKgvQcwILx0zenXxsNtRtWYlLvIuSNCrgfmPBo8BTFfMIvqf064FN/Pt6OvpI/VJCJki545mmHQ3CrFjdLUqivxxflTXoL6gHnyhJNeKAi23dCwPdUM/xxpa3GWgNBODOEzLt1LtXblKM6aMasG1zNy+3yE9PwcdSh1HeoM6VWGt1RIkzfL9yjK4GOJAMn4wrBrwuvjzJR98kY2eCMZGPoxeSDQxmC7Yw9UUGNxJG1G3s0WcBO0qZCDb+h56meYZrAQbfwtsxQhzqg2z1OQwMp0d4ybYbJQxZc8I62QzzTZY4HUgif5+7W4mIg+LZsmZiciuwQ52/lZcHY83JzXXzFA8Q1Is8zoAfv44zX9OWc9nGXKqSkx3TzFgL9ZiZtNZhesmM7ysgCP9jCNEg4sV6P+fjd0IvwOJS3alThfBBMINBwqflpkH9o5wrOBpfsoIBlZwSKXn6qCPMoSin1cuBTf4+2pRDllp8Qy/nQ0jXJsJMFXFiAA18oHdD6ZZxo1hdoLVx6XxXBJfKVW9f5jDm0psm+UnGD5CicC4gPl7JPyY7g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(8936002)(8676002)(36756003)(16526019)(82310400005)(186003)(426003)(4326008)(70586007)(47076005)(41300700001)(70206006)(26005)(2616005)(86362001)(5660300002)(36860700001)(7696005)(336012)(478600001)(40480700001)(54906003)(82740400003)(107886003)(7636003)(316002)(83380400001)(356005)(110136005)(6666004)(40460700003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 07:34:40.7801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c2137f-608e-4ffd-0a09-08daf9efa05e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6002
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 18 Jan 2023 at 13:32, Florian Westphal <fw@strlen.de> wrote:
> From: Fernando Fernandez Mancera <ffmancera@riseup.net>
>
> Introduce NFT_MSG_DESTROY* message type. The destroy operation performs a
> delete operation but ignoring the ENOENT errors.
>
> This is useful for the transaction semantics, where failing to delete an
> object which does not exist results in aborting the transaction.
>
> This new command allows the transaction to proceed in case the object
> does not exist.
>
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  14 +++
>  net/netfilter/nf_tables_api.c            | 111 +++++++++++++++++++++--
>  2 files changed, 117 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index cfa844da1ce6..ff677f3a6cad 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -98,6 +98,13 @@ enum nft_verdicts {
>   * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
>   * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
>   * @NFT_MSG_GETRULE_RESET: get rules and reset stateful expressions (enum nft_obj_attributes)
> + * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
> + * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
> + * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
> + * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
> + * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
> + * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
> + * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
>   */
>  enum nf_tables_msg_types {
>  	NFT_MSG_NEWTABLE,
> @@ -126,6 +133,13 @@ enum nf_tables_msg_types {
>  	NFT_MSG_GETFLOWTABLE,
>  	NFT_MSG_DELFLOWTABLE,
>  	NFT_MSG_GETRULE_RESET,
> +	NFT_MSG_DESTROYTABLE,
> +	NFT_MSG_DESTROYCHAIN,
> +	NFT_MSG_DESTROYRULE,
> +	NFT_MSG_DESTROYSET,
> +	NFT_MSG_DESTROYSETELEM,
> +	NFT_MSG_DESTROYOBJ,
> +	NFT_MSG_DESTROYFLOWTABLE,
>  	NFT_MSG_MAX,
>  };
>  
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8c09e4d12ac1..974b95dece1d 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1401,6 +1401,10 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
>  	}
>  
>  	if (IS_ERR(table)) {
> +		if (PTR_ERR(table) == -ENOENT &&
> +		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYTABLE)
> +			return 0;
> +
>  		NL_SET_BAD_ATTR(extack, attr);
>  		return PTR_ERR(table);
>  	}
> @@ -2639,6 +2643,10 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
>  		chain = nft_chain_lookup(net, table, attr, genmask);
>  	}
>  	if (IS_ERR(chain)) {
> +		if (PTR_ERR(chain) == -ENOENT &&
> +		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN)
> +			return 0;
> +
>  		NL_SET_BAD_ATTR(extack, attr);
>  		return PTR_ERR(chain);
>  	}
> @@ -3716,6 +3724,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
>  		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
>  					 genmask);
>  		if (IS_ERR(chain)) {
> +			if (PTR_ERR(rule) == -ENOENT &&

Coverity complains that at this point rule is not initialized yet, which
looks like to be the case to me.

[...]

