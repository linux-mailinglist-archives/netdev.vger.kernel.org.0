Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1965F84C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjAFAsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbjAFAsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:48:06 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEF33E0DB;
        Thu,  5 Jan 2023 16:48:04 -0800 (PST)
Message-ID: <bd002756-3295-b708-e304-976d42dbf121@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672966082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QjEddYanE4lYdQQeWVmj0T7Odd9F7GFdvNLOeMV7jMU=;
        b=G19xsRr9ifxxM2AFtDQBlrZ5K+tLRE7D4L7w5jWYahRByZXRX5khc+Mh6tbLCPDW93E1+j
        ju43zZWh/O72JxuD/AclsDcALd/F9KgDfzLxit1ZGUSeQ7lhyLONuLXVwTS1NIstFbYALd
        VIEE+H8uV+220xoc+soPuIEdvfrZNaw=
Date:   Thu, 5 Jan 2023 16:47:55 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v6 07/17] bpf: XDP metadata RX kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20230104215949.529093-1-sdf@google.com>
 <20230104215949.529093-8-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230104215949.529093-8-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/23 1:59 PM, Stanislav Fomichev wrote:
> +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> +{
> +	const struct xdp_metadata_ops *ops;
> +	void *p = NULL;
> +
> +	/* We don't hold bpf_devs_lock while resolving several
> +	 * kfuncs and can race with the unregister_netdevice().
> +	 * We rely on bpf_dev_bound_match() check at attach
> +	 * to render this program unusable.
> +	 */
> +	down_read(&bpf_devs_lock);
> +	if (!prog->aux->offload || !prog->aux->offload->netdev)

nit. !prog->aux->offload->netdev check is not needed. Testing 
!prog->aux->offload should be as good.

