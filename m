Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8706A5F6D47
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiJFR4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiJFR4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:56:40 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE38AE840;
        Thu,  6 Oct 2022 10:56:39 -0700 (PDT)
Message-ID: <72deafd9-ebd0-e173-0b41-51820a317292@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665078997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6Oq87YwupaZDOXOv9N6CEe2JLC5UwfpF3YPGpUqBOA=;
        b=teW779MVKvR1GD61lkSQzUDciAccMBFx7PKlfNR4mhumENKFu+dYbFyJWzSjhAn9Hr2AJW
        n/MJsZyffG8h/8YfnudG9nWPz83PEQERaOdW4m2vl7Yol4ulhxTkNu26YVNKvfd0pzLBoX
        DGpmv5iEMSzf/46TD9KIrzrJvkGlFo0=
Date:   Thu, 6 Oct 2022 10:56:32 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 02/10] bpf: Implement BPF link handling for tc
 BPF programs
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        john.fastabend@gmail.com, joannelkoong@gmail.com, memxor@gmail.com,
        toke@redhat.com, joe@cilium.io, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-3-daniel@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221004231143.19190-3-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 4:11 PM, Daniel Borkmann wrote:

> @@ -191,7 +202,8 @@ static void __xtc_prog_detach_all(struct net_device *dev, bool ingress, u32 limi
>   		if (!prog)
>   			break;
>   		dev_xtc_entry_prio_del(entry, item->bpf_priority);
> -		bpf_prog_put(prog);
> +		if (!item->bpf_id)
> +			bpf_prog_put(prog);

Should the link->dev be set to NULL somewhere?

>   		if (ingress)
>   			net_dec_ingress_queue();
>   		else
> @@ -244,6 +256,7 @@ __xtc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
>   		if (!prog)
>   			break;
>   		info.prog_id = prog->aux->id;
> +		info.link_id = item->bpf_id;
>   		info.prio = item->bpf_priority;
>   		if (copy_to_user(uinfo + i, &info, sizeof(info)))
>   			return -EFAULT;
> @@ -272,3 +285,90 @@ int xtc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
>   	rtnl_unlock();
>   	return ret;
>   }
> +

[ ... ]

> +static void xtc_link_release(struct bpf_link *l)
> +{
> +	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
> +
> +	rtnl_lock();
> +	if (link->dev) {
> +		WARN_ON(__xtc_prog_detach(link->dev,
> +					  link->location == BPF_NET_INGRESS,
> +					  XTC_MAX_ENTRIES, l->id, link->priority));
> +		link->dev = NULL;
> +	}
> +	rtnl_unlock();
> +}

