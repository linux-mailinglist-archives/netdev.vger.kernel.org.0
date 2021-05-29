Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF8394E35
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhE2VHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhE2VHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 17:07:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5349C61132;
        Sat, 29 May 2021 21:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622322362;
        bh=YPY63HY1hh7JHdHomJUllgTfk+64TkhnqMFVgjzWOeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o4l3v2WDHQb+d4rK4Do+oiBbAUoJvN/I39S1yhw2hedCmGKQBSsiXgbrdlac8d/6d
         +XYNuhTcNbLBr3peBad3VFF0qqAvYILZsHtWg3NpqOaAmnNZf4QZczn9cQQQewpKkE
         cCk5EfBgw3IcZtW2YjT8bYfyiuTUqQll3+/wuG/hiauhCyp7KEUtRpW8p0VbwSLeZJ
         s0Lx0uYbQ5sut6j1i5Qoh4D1zRoJFlbJ1aQ+c33zp7zsT/zD/fTF5QP/mSIu+pFm4D
         XaAdKHdWen/M/vWsOTE6btoMTXXTcWH4rqfSNl1cyCLfo++oGg6moi4d+sOGYW8iur
         8tFx8HOs9FK6A==
Date:   Sat, 29 May 2021 14:06:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 3/5] ipv6: ioam: IOAM Generic Netlink API
Message-ID: <20210529140601.1ab9d40e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527151652.16074-4-justin.iurman@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-4-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 17:16:50 +0200 Justin Iurman wrote:
> Add Generic Netlink commands to allow userspace to configure IOAM
> namespaces and schemas. The target is iproute2 and the patch is ready.
> It will be posted as soon as this patchset is merged. Here is an overview:
> 
> $ ip ioam
> Usage:	ip ioam { COMMAND | help }
> 	ip ioam namespace show
> 	ip ioam namespace add ID [ DATA ]
> 	ip ioam namespace del ID
> 	ip ioam schema show
> 	ip ioam schema add ID DATA
> 	ip ioam schema del ID
> 	ip ioam namespace set ID schema { ID | none }
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

> +static int ioam6_genl_addns(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ioam6_pernet_data *nsdata;
> +	struct ioam6_namespace *ns;
> +	__be16 ns_id;
> +	int err;
> +
> +	if (!info->attrs[IOAM6_ATTR_NS_ID])
> +		return -EINVAL;
> +
> +	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
> +	nsdata = ioam6_pernet(genl_info_net(info));
> +
> +	mutex_lock(&nsdata->lock);
> +
> +	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
> +	if (ns) {
> +		err = -EEXIST;
> +		goto out_unlock;
> +	}
> +
> +	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
> +	if (!ns) {
> +		err = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	ns->id = ns_id;
> +
> +	if (!info->attrs[IOAM6_ATTR_NS_DATA]) {
> +		ns->data = cpu_to_be64(IOAM6_EMPTY_u64);
> +	} else {
> +		ns->data = cpu_to_be64(
> +				nla_get_u64(info->attrs[IOAM6_ATTR_NS_DATA]));

Store data in a temporary variable to avoid this long line.

> +	}

braces unnecessary

> +	err = rhashtable_lookup_insert_fast(&nsdata->namespaces, &ns->head,
> +					    rht_ns_params);
> +	if (err)
> +		kfree(ns);
> +
> +out_unlock:
> +	mutex_unlock(&nsdata->lock);
> +	return err;
> +}
> +
> +static int ioam6_genl_delns(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ioam6_pernet_data *nsdata;
> +	struct ioam6_namespace *ns;
> +	struct ioam6_schema *sc;
> +	__be16 ns_id;
> +	int err;
> +
> +	if (!info->attrs[IOAM6_ATTR_NS_ID])
> +		return -EINVAL;
> +
> +	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
> +	nsdata = ioam6_pernet(genl_info_net(info));
> +
> +	mutex_lock(&nsdata->lock);
> +
> +	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
> +	if (!ns) {
> +		err = -ENOENT;
> +		goto out_unlock;
> +	}
> +
> +	sc = ns->schema;
> +	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
> +				     rht_ns_params);
> +	if (err)
> +		goto out_unlock;
> +
> +	if (sc)
> +		sc->ns = NULL;

the sc <> ns pointers should be annotated with __rcu, and appropriate
accessors used. At the very least the need READ/WRITE_ONCE().

> +	ioam6_ns_release(ns);
> +
> +out_unlock:
> +	mutex_unlock(&nsdata->lock);
> +	return err;
> +}
> +
> +static int ioam6_genl_addsc(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ioam6_pernet_data *nsdata;
> +	int len, len_aligned, err;
> +	struct ioam6_schema *sc;
> +	u32 sc_id;
> +
> +	if (!info->attrs[IOAM6_ATTR_SC_ID] || !info->attrs[IOAM6_ATTR_SC_DATA])
> +		return -EINVAL;
> +
> +	sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
> +	nsdata = ioam6_pernet(genl_info_net(info));
> +
> +	mutex_lock(&nsdata->lock);
> +
> +	sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id, rht_sc_params);
> +	if (sc) {
> +		err = -EEXIST;
> +		goto out_unlock;
> +	}
> +
> +	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
> +	if (!sc) {
> +		err = -ENOMEM;
> +		goto out_unlock;
> +	}

Why not store the data after the sc structure?

u8 data[] + struct_size()?

> +	len = nla_len(info->attrs[IOAM6_ATTR_SC_DATA]);
> +	len_aligned = ALIGN(len, 4);
> +
> +	sc->data = kzalloc(len_aligned, GFP_KERNEL);
> +	if (!sc->data) {
> +		err = -ENOMEM;
> +		goto free_sc;
> +	}
> +
> +	sc->id = sc_id;
> +	sc->len = len_aligned;
> +	sc->hdr = cpu_to_be32(sc->id | ((u8)(sc->len / 4) << 24));
> +
> +	nla_memcpy(sc->data, info->attrs[IOAM6_ATTR_SC_DATA], len);
> +
> +	err = rhashtable_lookup_insert_fast(&nsdata->schemas, &sc->head,
> +					    rht_sc_params);
> +	if (err)
> +		goto free_data;
> +
> +out_unlock:
> +	mutex_unlock(&nsdata->lock);
> +	return err;
> +free_data:
> +	kfree(sc->data);
> +free_sc:
> +	kfree(sc);
> +	goto out_unlock;
> +}
> +
> +static int ioam6_genl_ns_set_schema(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ioam6_pernet_data *nsdata;
> +	struct ioam6_namespace *ns;
> +	struct ioam6_schema *sc;
> +	__be16 ns_id;
> +	int err = 0;

No need to init.

> +	u32 sc_id;
> +
> +	if (!info->attrs[IOAM6_ATTR_NS_ID] ||
> +	    (!info->attrs[IOAM6_ATTR_SC_ID] &&
> +	     !info->attrs[IOAM6_ATTR_SC_NONE]))
> +		return -EINVAL;
> +
> +	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
> +	nsdata = ioam6_pernet(genl_info_net(info));
> +
> +	mutex_lock(&nsdata->lock);
> +
> +	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
> +	if (!ns) {
> +		err = -ENOENT;
> +		goto out_unlock;
> +	}
> +
> +	if (info->attrs[IOAM6_ATTR_SC_NONE]) {
> +		sc = NULL;
> +	} else {
> +		sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
> +		sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id,
> +					    rht_sc_params);
> +		if (!sc) {
> +			err = -ENOENT;
> +			goto out_unlock;
> +		}
> +	}
> +
> +	if (ns->schema)
> +		ns->schema->ns = NULL;
> +	ns->schema = sc;
> +
> +	if (sc) {
> +		if (sc->ns)
> +			sc->ns->schema = NULL;
> +		sc->ns = ns;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&nsdata->lock);
> +	return err;
> +}
> +
> +static const struct genl_ops ioam6_genl_ops[] = {
> +	{
> +		.cmd	= IOAM6_CMD_ADD_NAMESPACE,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit	= ioam6_genl_addns,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd	= IOAM6_CMD_DEL_NAMESPACE,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit	= ioam6_genl_delns,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd	= IOAM6_CMD_DUMP_NAMESPACES,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.start	= ioam6_genl_dumpns_start,
> +		.dumpit	= ioam6_genl_dumpns,
> +		.done	= ioam6_genl_dumpns_done,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd	= IOAM6_CMD_ADD_SCHEMA,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit	= ioam6_genl_addsc,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd	= IOAM6_CMD_DEL_SCHEMA,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit	= ioam6_genl_delsc,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd	= IOAM6_CMD_DUMP_SCHEMAS,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.start	= ioam6_genl_dumpsc_start,
> +		.dumpit	= ioam6_genl_dumpsc,
> +		.done	= ioam6_genl_dumpsc_done,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd	= IOAM6_CMD_NS_SET_SCHEMA,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit	= ioam6_genl_ns_set_schema,
> +		.flags	= GENL_ADMIN_PERM,
> +	},
> +};

These days I think we should use policy tailored to each op, rather
than a single policy per family. That way we don't ignore any
attributes user may specify but kernel doesn't expect.
