Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC556F0BB8
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 20:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244496AbjD0SDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 14:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbjD0SDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 14:03:43 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCAA421E
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:03:42 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64115e69e1eso5304226b3a.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682618622; x=1685210622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fh+piB/LEKCTLTDSFOcrpICMj5GtBDUbjH//IFYqtZc=;
        b=cbI3HrZ2S3Ue1P/yd267JGutYEFecBnHhGg5i+33d83UHEJlA8CCQPmWfb2C0/EoVp
         C2w7VZxiJGmtsZA0UpzavcDzybKtoSJnZo1Kzc1dnySm1o5oILW75z0fxqjUtdstrwde
         fjf8IO549GRnmnfuav7TUxJ0Dlmojy8OxDaP9e/AhfT5lcy2kHveC2HddiAGFMEIpaOC
         DcSq68UW5vaj9ixkmoCcmWCGyn5MaWhokB67KqjpUMI906P/d+x3roSv0u7dg+V7/BuV
         E8rcUo9gPGwlJYXlNjurjQ0pfSewt7Yhb8x5VsP1rVefebJijdIZTiXAT5bF1D22tYb4
         aMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682618622; x=1685210622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fh+piB/LEKCTLTDSFOcrpICMj5GtBDUbjH//IFYqtZc=;
        b=d2kwkeGRkS86Bd857XgJrz4FMjNOsWCR0lLgkcyMRw5TMRZQrLyqnJSoVXjbI8vqRg
         XZ/pwpg3acnR8Ma3lrdRXpcKMQE2EqhAgxZV2i7EGCq2Fp1Xm9ZQejnBNwzYD8Ln9qLb
         ftasJiPUHuIFlUnkSXbj+B0PJoBE+ojsmMFMDKn/BLaX8Y1yDkERWAoL6Z0/yu2BtrFz
         CxPh6YFzWToj4GprxXE+4EtjGOd+jkyTm0MSr+WcH9IyDdlEnhEH1Gvbuz+1NVsJFpQ8
         hJmn5N8ptigX4MZZDPC3yrkI5MBx9vyp/TyMYCLbb3vBdjJ64loYlD60+wO2GbHJNyQ7
         bkYw==
X-Gm-Message-State: AC+VfDxLSiT2MqpHPKItKBiq8lJIQqoYxPPUS2nv/20IiQmxE4gsHTm1
        BOieEu3ENT69DuueWGSxun7Dnqc=
X-Google-Smtp-Source: ACHHUZ4m5XBsE7zGA4Mdisw1N212Syt2mumgBcZVYtNSGwwcpqJvfmHMA1PTfBUBSVvnVbXfqQwl0kw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:2843:0:b0:520:8b35:157d with SMTP id
 bs64-20020a632843000000b005208b35157dmr760782pgb.4.1682618622166; Thu, 27 Apr
 2023 11:03:42 -0700 (PDT)
Date:   Thu, 27 Apr 2023 11:03:40 -0700
In-Reply-To: <20230426085122.376768-3-gilad9366@gmail.com>
Mime-Version: 1.0
References: <20230426085122.376768-1-gilad9366@gmail.com> <20230426085122.376768-3-gilad9366@gmail.com>
Message-ID: <ZEq4/JAgLRCKEeQr@google.com>
Subject: Re: [PATCH bpf,v3 2/4] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup()
 directly via TC hookpoint
From:   Stanislav Fomichev <sdf@google.com>
To:     Gilad Sever <gilad9366@gmail.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/26, Gilad Sever wrote:
> skb->dev always exists in the tc flow. There is no need to use
> bpf_skc_lookup(), bpf_sk_lookup() from this code path.
> 
> This change facilitates fixing the tc flow to be VRF aware.
> 
> Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
> Signed-off-by: Gilad Sever <gilad9366@gmail.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>  net/core/filter.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5910956f4e0d..f43f86fc1235 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6704,8 +6704,12 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
>  BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
>  {
> -	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
> -					     netns_id, flags);
> +	struct net *caller_net = dev_net(skb->dev);
> +	int ifindex = skb->dev->ifindex;
> +
> +	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
> +					       ifindex, IPPROTO_TCP, netns_id,
> +					       flags);
>  }
>  
>  static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
> @@ -6723,8 +6727,12 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
>  BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
>  {
> -	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
> -					    netns_id, flags);
> +	struct net *caller_net = dev_net(skb->dev);
> +	int ifindex = skb->dev->ifindex;
> +
> +	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
> +					      ifindex, IPPROTO_TCP, netns_id,
> +					      flags);
>  }
>  
>  static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
> @@ -6742,8 +6750,12 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
>  BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
>  	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
>  {
> -	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
> -					    netns_id, flags);
> +	struct net *caller_net = dev_net(skb->dev);
> +	int ifindex = skb->dev->ifindex;
> +
> +	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
> +					      ifindex, IPPROTO_UDP, netns_id,
> +					      flags);
>  }
>  
>  static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
> -- 
> 2.34.1
> 
