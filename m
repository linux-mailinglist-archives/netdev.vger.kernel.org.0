Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906881E9636
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgEaIGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:06:49 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:33317
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbgEaIGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 04:06:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6t68XfUP3cZua+RWzFRu+xBFSpw/NworVPRi6QqvCaGa2jJ1x1qBSuxh72EympMBXqeiRxk28QR6zWBkvTarXofRkSCgoQWXp+hC5UxQYnvB4cNHp/Ytsfrp164CLa87Hqk3s/7IkHuXtay/2TBT+Z4hA4dyka0JLq/QWSSSgrDU70BnaRiZp6mifguDu/04gfeJd06KrxGolsi6I9fr6ZpnpcTew/eJdDL/MIhTCYlapwOws0kLUv6Iz2Q0bo/zjT4SNp3xPc1k0cFeUpRCcb8C1fFerGC1aVG8XAFVcXy939C3ijkRvNXSZrgclNtWTrbP10Fk0mR+veiGD0ohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/sMQp8MIHdxnCXPFWdnrx0s+nuag6JualoeiuqP+ys=;
 b=CQNeWdnup6W4sJBUcLVA/2GK/vUgc2iGkWrNXPAsk+N85E5A+3OYNueteI8+jG6muuN26IDLtWhmuZb3MJ3BM/1jvBAftne/Dx1oJ8NRyaT1+oFQtZ5Kuf1hB5801RLhF5YXuhnYl4iCk5f4RoXjPy6fiLSlzItd9/ThA8akGE5KdoT79e7OhTJpW8IZykHzVrBw12OTpGunyApF+7vibNEADKwZ/GfT4FRiSpzFwmgr/S4c3zEXnJ268L9SZSolMn+BZzzKF1c2CPQ82wfwItGtlh+QzwRVqsd5Eg8hE01SC3Jy+EyOZ5qHE245VRlaXooyLPOGmKb/MHBCqN3GVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/sMQp8MIHdxnCXPFWdnrx0s+nuag6JualoeiuqP+ys=;
 b=Fy+1Pwgn2+Z8k/xxNogFUG/KEfXx139pf69Xs/a2/azj7BHibZAv+qMlN9OX5iSs4jPmSdufsrkRVTox/2JM2cy380/1b5xYbVLQ2N5MMru5i/Uv6qMPDja4+LOvLALD+kJ1fwTBNOwgdfUND5EIXXBRfGrKx6h3PYYfmoXYH+8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3924.eurprd05.prod.outlook.com
 (2603:10a6:208:20::30) by AM0PR0502MB4001.eurprd05.prod.outlook.com
 (2603:10a6:208:9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Sun, 31 May
 2020 08:06:44 +0000
Received: from AM0PR0502MB3924.eurprd05.prod.outlook.com
 ([fe80::cd67:f25f:c3aa:f459]) by AM0PR0502MB3924.eurprd05.prod.outlook.com
 ([fe80::cd67:f25f:c3aa:f459%2]) with mapi id 15.20.3045.018; Sun, 31 May 2020
 08:06:44 +0000
Subject: Re: [PATCH net-next v2] net/mlx5e: add conntrack offload rules only
 in ct or ct_nat flow table
To:     wenxu@ucloud.cn, paulb@mellanox.com, saeedm@mellanox.com,
        ecree@solarflare.com
Cc:     netdev@vger.kernel.org
References: <1590820075-4005-1-git-send-email-wenxu@ucloud.cn>
From:   Oz Shlomo <ozsh@mellanox.com>
Message-ID: <fec0fede-b9c0-9f5a-da3e-665e61a7fabd@mellanox.com>
Date:   Sun, 31 May 2020 11:06:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <1590820075-4005-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0056.eurprd03.prod.outlook.com (2603:10a6:208::33)
 To AM0PR0502MB3924.eurprd05.prod.outlook.com (2603:10a6:208:20::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.14.169] (79.180.224.244) by AM0PR03CA0056.eurprd03.prod.outlook.com (2603:10a6:208::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sun, 31 May 2020 08:06:44 +0000
X-Originating-IP: [79.180.224.244]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e977b9be-0e7f-4786-1f3c-08d805398f39
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4001:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40015842084FE2A14964CD2EAB8D0@AM0PR0502MB4001.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 0420213CCD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVCKzgZuZAKIvJnghWH3uwTebVMA6kIb+jvCZDNSMSG+zeto8WPQEJxFEgAG5bOe6ll/hcLYyfdRsSoi0rRzm2flEPDIhr4xYhOXJQ9KXlMHaVOphrEv/g2Njjn39+yK3nzw+sWT6tdQpNyWHJ/+fVuwiUV8nr/nnNEQe0gbm1F4CmVRjzw1tVO26k6LUpZ+k1mEA2BmWZYUwYhtnCLcaqk7nwDSYPT6qxDzw14/jcN7N8whRX1u7LdHVW4/TBF0psU/wz+pEyJO7LfQFttNq+Hu7/fef97pO4qrQfcnpMFMgYoKofCZBjeMfZkHjfZtcp+pc0FbbcJrYv6/W5rJa5HnHti18kJfM5yk9PIAuHqUEfF8FOwNTCmxAyjAq2La
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3924.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(36756003)(26005)(2906002)(6486002)(31686004)(478600001)(86362001)(83380400001)(31696002)(956004)(2616005)(53546011)(8936002)(66946007)(66476007)(66556008)(6666004)(8676002)(16526019)(5660300002)(186003)(4326008)(16576012)(52116002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EFFI4ht1I6Th47ohpZY9pru+AOqA7b5tZkoK1v79hklLZFtXLBY6gwIk2AnruB6J/HJ4qzmqUgUGoAzFIq2z/uMEVVyMdbz4xve9SMYhI8Izn1+1UzYS1WMq0ucv5LhrQg4ISMmjprEY0qxlxin9ML/gEpHpE2/bnRKs742GrIjRC/x2upP8zMf4nvFuXFh7imKwy8HVvY407qirr0viwxdKZBK0bdzSF/bQpMRSvRgrTNlD2iSf7PKcyixGs8aL9Nl12RstivO1R9OvG29byFnGet7um0C7bVW9dO4G1YMAm+VQZM9MqGHilyh6t9acvZxjjMqCXkvFXOT8m6qOX2iA585kbTZrAqZ4xOCiy5phVXOLej5SFN7fhhCJe6JdfZ3JKqsKEaNpF+f4BQASFE0VS/r+XpN9pekwDJNA2Llaa94UBUeifZFtegMrsDvuIPd+I4tGZlTv68SXVq7pto1tKTTo6df0zPHTyLRm+rw/AO/r1p2K9fUQhuXyrFpD
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e977b9be-0e7f-4786-1f3c-08d805398f39
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2020 08:06:44.8004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lk33c+6H2MZMs/v2tiETrB7BrJXkmjJ7C7zHQD2ZvlriZjf+hSV+b+40ZwrPjNTIMreW6kJnmG+FQCCchKdsRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wenxu,

Just saw v2.
Please see my comment in v1.

On 5/30/2020 9:27 AM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the ct offload all the conntrack entry offload rules
> will be add to both ct ft and ct_nat ft twice. It is not
> make sense.
> The driver can distinguish NAT from non-NAT conntrack
> through the FLOW_ACTION_MANGLE action.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 52 ++++++++++++----------
>   1 file changed, 28 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 995b2ef..2281549 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -59,7 +59,6 @@ struct mlx5_ct_zone_rule {
>   	struct mlx5_flow_handle *rule;
>   	struct mlx5_esw_flow_attr attr;
>   	int tupleid;
> -	bool nat;
>   };
>   
>   struct mlx5_tc_ct_pre {
> @@ -88,7 +87,7 @@ struct mlx5_ct_entry {
>   	struct mlx5_fc *counter;
>   	unsigned long cookie;
>   	unsigned long restore_cookie;
> -	struct mlx5_ct_zone_rule zone_rules[2];
> +	struct mlx5_ct_zone_rule zone_rule;
>   };
>   
>   static const struct rhashtable_params cts_ht_params = {
> @@ -238,10 +237,9 @@ struct mlx5_ct_entry {
>   
>   static void
>   mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
> -			  struct mlx5_ct_entry *entry,
> -			  bool nat)
> +			  struct mlx5_ct_entry *entry)
>   {
> -	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
>   	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
>   	struct mlx5_eswitch *esw = ct_priv->esw;
>   
> @@ -256,8 +254,7 @@ struct mlx5_ct_entry {
>   mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
>   			   struct mlx5_ct_entry *entry)
>   {
> -	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
> -	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
> +	mlx5_tc_ct_entry_del_rule(ct_priv, entry);
>   
>   	mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
>   }
> @@ -493,15 +490,13 @@ struct mlx5_ct_entry {
>   			  struct mlx5_ct_entry *entry,
>   			  bool nat)
>   {
> -	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
>   	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
>   	struct mlx5_eswitch *esw = ct_priv->esw;
>   	struct mlx5_flow_spec *spec = NULL;
>   	u32 tupleid;
>   	int err;
>   
> -	zone_rule->nat = nat;
> -
>   	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
>   	if (!spec)
>   		return -ENOMEM;
> @@ -562,7 +557,8 @@ struct mlx5_ct_entry {
>   static int
>   mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
>   			   struct flow_rule *flow_rule,
> -			   struct mlx5_ct_entry *entry)
> +			   struct mlx5_ct_entry *entry,
> +			   bool nat)
>   {
>   	struct mlx5_eswitch *esw = ct_priv->esw;
>   	int err;
> @@ -574,21 +570,26 @@ struct mlx5_ct_entry {
>   		return err;
>   	}
>   
> -	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
> +	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, nat);
>   	if (err)
> -		goto err_orig;
> +		mlx5_fc_destroy(esw->dev, entry->counter);
>   
> -	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
> -	if (err)
> -		goto err_nat;
> +	return err;
> +}
>   
> -	return 0;
> +static bool
> +mlx5_tc_ct_has_mangle_action(struct flow_rule *flow_rule)
> +{
> +	struct flow_action *flow_action = &flow_rule->action;
> +	struct flow_action_entry *act;
> +	int i;
>   
> -err_nat:
> -	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
> -err_orig:
> -	mlx5_fc_destroy(esw->dev, entry->counter);
> -	return err;
> +	flow_action_for_each(i, act, flow_action) {
> +		if (act->id == FLOW_ACTION_MANGLE)
> +			return true;
> +	}
> +
> +	return false;
>   }
>   
>   static int
> @@ -600,6 +601,7 @@ struct mlx5_ct_entry {
>   	struct flow_action_entry *meta_action;
>   	unsigned long cookie = flow->cookie;
>   	struct mlx5_ct_entry *entry;
> +	bool nat;
>   	int err;
>   
>   	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
> @@ -619,7 +621,9 @@ struct mlx5_ct_entry {
>   	entry->cookie = flow->cookie;
>   	entry->restore_cookie = meta_action->ct_metadata.cookie;
>   
> -	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
> +	nat = mlx5_tc_ct_has_mangle_action(flow_rule);
> +
> +	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry, nat);
>   	if (err)
>   		goto err_rules;
>   
> @@ -1620,7 +1624,7 @@ struct mlx5_flow_handle *
>   		return false;
>   
>   	entry = container_of(zone_rule, struct mlx5_ct_entry,
> -			     zone_rules[zone_rule->nat]);
> +			     zone_rule);
>   	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
>   
>   	return true;
> 
