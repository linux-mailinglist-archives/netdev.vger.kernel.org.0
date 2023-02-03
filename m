Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA13689EEF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjBCQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBCQMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:12:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDD67A91
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675440722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C/lfN7jWXOACRQkrK0PviX4digGUFXHvLqmZuS5Ee2o=;
        b=BHcjmAjhkU3nj+UdFJOAsmKfq/t2CUeZThKnSxALDosxjn53dv9RmGek1VwAR8la9QtdW6
        H4SRowpdIyEYhqYzzyyYvVJnQyeISHLSFZRmq+H2I0uMSZ6IhC8cySvnUN+aq62XpHNVQO
        efTPiqwOUCelhqS/VtnnGLovmAH2toc=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-VOo3rHR-PmCp94b-_8bvmA-1; Fri, 03 Feb 2023 11:12:01 -0500
X-MC-Unique: VOo3rHR-PmCp94b-_8bvmA-1
Received: by mail-vk1-f199.google.com with SMTP id e17-20020a056122041100b003ed8d749c83so1934723vkd.15
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 08:12:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/lfN7jWXOACRQkrK0PviX4digGUFXHvLqmZuS5Ee2o=;
        b=bNdZcJMxCg2BXwIUP3rLPu3Hbuc+PEb4CYnFriETWyv7sFpB4dmTLdDuW9p8DHW56l
         0/JtLkotGdwEEYbaEITsSpqYoH4afsLNYqMzfj5gR0ZBpOCEm8ME1F2SOoeMcDtKCKUe
         H8WO0KmaMWHRPr0/JPb+UOgzZkjTXlq3GAMwZIbL6BNVWvw8Q+wnwijV+McH18U5L5MJ
         ztUuA+gkfbwO6QVMFOvUQK/76Co3xy1Uafk1MQDrwjjWTgnPbgCX81Xnc6S2XreaIsc1
         aeiRRe2vVHGiBV9nngFuotqIPxQNn7VoNM7UPeWLSAJ1XSDghKIPLpqjjO9yz6orMse1
         RFOg==
X-Gm-Message-State: AO0yUKVQqfoSlSe9UiOz2922OEh158hVqannWjNvpALfciH/6mh+hM9G
        chs2kzFUTIXasUSGtu+xYGdw4xlFPS3bT4fm1v2ypr9fB2pY7sAsJIGde8qQ88xNj7q94B2WQdn
        G8KyByPUsmQSbxDplADQI7eVZqotYCr0Q
X-Received: by 2002:a05:6122:216b:b0:3ea:78fc:6dce with SMTP id j11-20020a056122216b00b003ea78fc6dcemr1573692vkr.0.1675440720445;
        Fri, 03 Feb 2023 08:12:00 -0800 (PST)
X-Google-Smtp-Source: AK7set8E2RTKQ8tM/e0FCDDLPSZv8WOCcP/MbFJAGI+0jxgPsMojlXksXeVAHs90BCEUCzPHIjIrTOUxBVD6YBPfWhM=
X-Received: by 2002:a05:6122:216b:b0:3ea:78fc:6dce with SMTP id
 j11-20020a056122216b00b003ea78fc6dcemr1573680vkr.0.1675440720122; Fri, 03 Feb
 2023 08:12:00 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Feb 2023 08:11:59 -0800
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230201161039.20714-1-ozsh@nvidia.com> <20230201161039.20714-8-ozsh@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230201161039.20714-8-ozsh@nvidia.com>
Date:   Fri, 3 Feb 2023 08:11:59 -0800
Message-ID: <CALnP8ZY_QUf2euy5aGGSHZjcZrsWuQ3eTO2kryw80vaAFvaJGQ@mail.gmail.com>
Subject: Re: [PATCH net-next 7/9] net/mlx5e: TC, store tc action cookies per attr
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:10:36PM +0200, Oz Shlomo wrote:
> The tc parse action phase translates the tc actions to mlx5 flow
> attributes data structure that is used during the flow offload phase.
> Currently, the flow offload stage instantiates hw counters while
> associating them to flow cookie. However, flows with branching
> actions are required to associate a hardware counter with its action
> cookies.
>
> Store the parsed tc action cookies on the flow attribute.
> Use the list of cookies in the next patch to associate a tc action cookie
> with its allocated hw counter.
>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 2 ++
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 39f75f7d5c8b..a5118da3ed6c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3797,6 +3797,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
>  	parse_attr->filter_dev = attr->parse_attr->filter_dev;
>  	attr2->action = 0;
>  	attr2->counter = NULL;
> +	attr->tc_act_cookies_count = 0;
>  	attr2->flags = 0;
>  	attr2->parse_attr = parse_attr;
>  	attr2->dest_chain = 0;
> @@ -4160,6 +4161,8 @@ struct mlx5_flow_attr *
>  			goto out_free;
>
>  		parse_state->actions |= attr->action;
> +		if (!tc_act->stats_action)
> +			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
>
>  		/* Split attr for multi table act if not the last act. */
>  		if (jump_state.jump_target ||
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> index ce516dc7f3fd..8aa25d8bac86 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> @@ -70,6 +70,8 @@ struct mlx5_nic_flow_attr {
>  struct mlx5_flow_attr {
>  	u32 action;
>  	struct mlx5_fc *counter;
> +	unsigned long tc_act_cookies[TCA_ACT_MAX_PRIO];
> +	int tc_act_cookies_count;

This one won't count much, as it is limited by TCA_ACT_MAX_PRIO above
andi which is 32.
Maybe this can be an u8 or u16 instead and be added together with 'prio'?
To save 2 bytes, yes, but with a 1M flows, that's 2Mbytes.
Or below 'action' above, to keep it on the same cache line.

>  	struct mlx5_modify_hdr *modify_hdr;
>  	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
>  	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
> --
> 1.8.3.1
>

