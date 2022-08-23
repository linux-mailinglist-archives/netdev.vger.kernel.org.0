Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB7259CDFC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbiHWBlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiHWBlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484DB5A811
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5953611FE
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863DBC433C1;
        Tue, 23 Aug 2022 01:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218906;
        bh=gN8qXRmVAj4HwGGQVLFpu+VRISCsFddTeleub5pmPDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tG66uSxXFFYRuVj6QWKKaTn0jXCD+k9m6AYAgqmnIowm6KsLndnDsi0by5Svrw8JJ
         aj+nxS0U2HZMc5j3ZD+kqoL2GxCquCr+3aUzL5phKp/1gbwpw5/d7ksLMdY3jo3Iap
         bh4GSuQaOIMOmfKz0nBCLMcvddNvdhrJoVPwyL6RW4H9sCy+OjzpuJaW4G18//m7+u
         OLMHgGXVHEeIpncg4QxaSt+lxYlAFzt+vF3zzuF4aFPbFM+QFNxV26IIsKstshjkJW
         Myz7Is+j1tfWslGJLcFv6NaEcOsrvXjwQHhhN7SWzB07pBkZqpXCA+m3phzbVFWMEt
         5IN80QPlEywmg==
Date:   Mon, 22 Aug 2022 18:41:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org, aconole@redhat.com
Subject: Re: [PATCH net-next v2 3/3] openvswitch: add
 OVS_DP_ATTR_PER_CPU_PIDS to get requests
Message-ID: <20220822184144.595d4801@kernel.org>
In-Reply-To: <20220819153044.423233-4-andrey.zhadchenko@virtuozzo.com>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
        <20220819153044.423233-4-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 18:30:44 +0300 Andrey Zhadchenko wrote:
> -static size_t ovs_dp_cmd_msg_size(void)
> +static size_t ovs_dp_cmd_msg_size(struct datapath *dp)
>  {
>  	size_t msgsize = NLMSG_ALIGN(sizeof(struct ovs_header));
> +	struct dp_nlsk_pids *pids = ovsl_dereference(dp->upcall_portids);
> +
>  

double new line

>  	msgsize += nla_total_size(IFNAMSIZ);
>  	msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_stats));
> @@ -1516,6 +1518,9 @@ static size_t ovs_dp_cmd_msg_size(void)
>  	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_USER_FEATURES */
>  	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_MASKS_CACHE_SIZE */
>  
> +	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && pids)
> +		msgsize += nla_total_size_64bit(sizeof(u32) * pids->n_pids);

Can we make a safe over estimation here, like nr_cpu_ids maybe?
Would that be too large? It's fairly common to overestimate the
netlink message allocation.

Also why 64bit if the value is in u32 units?
