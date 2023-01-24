Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8F6798FD
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbjAXNRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjAXNRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:17:02 -0500
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91DB2B63E;
        Tue, 24 Jan 2023 05:17:00 -0800 (PST)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4P1SDW6Tncz9sdN;
        Tue, 24 Jan 2023 13:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1674566220; bh=OuhYDR7XimqJnht0OS3tdz0UBOpRvq0aJAdbENHhH5w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YOg67sAsI3PBEgrpqlchkRtNtQPoJMPhyFa181SOtvur0EOggs5BN5yc7zjM0yDMg
         fwqJDSlDUE8CVBV3HmLtxwnEfL0D1m4OrzJcJpr6OavgrogZycmW0m2RTytIT27/tS
         REkThWrMBW+So4ItyISgvdK7Sj18RJi/NJASlmeo=
X-Riseup-User-ID: 449272E7197DFE704BB18DFA491C4986AAA560F241B595A3A2FB4E1C0CD3D9EF
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4P1SDS4sdnz1yBY;
        Tue, 24 Jan 2023 13:16:56 +0000 (UTC)
Message-ID: <f9e39f74-e204-dcba-03ce-dfce7fe37a6d@riseup.net>
Date:   Tue, 24 Jan 2023 14:16:55 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net-next] netfilter: nf_tables: fix wrong pointer passed
 to PTR_ERR()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20230119075125.3598627-1-yangyingliang@huawei.com>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <20230119075125.3598627-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/01/2023 08:51, Yang Yingliang wrote:
> It should be 'chain' passed to PTR_ERR() in the error path
> after calling nft_chain_lookup() in nf_tables_delrule().
> 
> Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   net/netfilter/nf_tables_api.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 974b95dece1d..10264e98978b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3724,7 +3724,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
>   		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
>   					 genmask);
>   		if (IS_ERR(chain)) {
> -			if (PTR_ERR(rule) == -ENOENT &&
> +			if (PTR_ERR(chain) == -ENOENT &&
>   			    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
>   				return 0;
>   

Acked-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
