Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70384532572
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiEXIie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiEXIi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:38:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F7327E1D6
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653381507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MuszrjlNVINckmioAEd33HWcfPcHl5yzf94fDwEAWrM=;
        b=Z1T5xkEy9Q4qiuIWIW+zRvWXZc0zFv7OlqojDT2ihgFb/+Kr+cbQdUR3m8tBlLqi5iGxm0
        pu+pvCBMCKcJTsHv/wH/Jb0rmctGpWs6Rjqys92qjz8LxHaOILlAOi5H7j3cbWRXXPidY5
        Qhbn5gcEFEZxQwnbqc2Aiec4yahtng4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-vOrlLuRvO8aVTvEMnz4W2A-1; Tue, 24 May 2022 04:38:26 -0400
X-MC-Unique: vOrlLuRvO8aVTvEMnz4W2A-1
Received: by mail-wr1-f71.google.com with SMTP id w20-20020adfd1b4000000b0020cbb4347e6so4577406wrc.17
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MuszrjlNVINckmioAEd33HWcfPcHl5yzf94fDwEAWrM=;
        b=rr9SxDMKcscoGWBYkq5PvE1aBZx5Rx3P52cRHRw0KFvf2dM3562SdVGlVTUmYSaOji
         XlTfcC2mXd+q5+KReWiCX00u1B+xokt3A+wnVCliCA8pAxcb5jSCyA8zaDMIa9vFbwVE
         0vVCREwyo+WmDa0dsP5cyDqLcvDgVKHXU7vcjQoY7Zgpuxshya2oxvKBRWRnLzMuWC9k
         3WPGSifq1zS+Dgpgo3YCbLWrORy08h+nQwxlE7NzyeVFqSl7DpKlz4b4BGETAJlQ8MmE
         i3Fn4sW5HBCx8ofn7rmC+TmPUeiXlM0i9UUqMxRcge76efNfkTe83hnOOOq0WYlq6oQ3
         BU3w==
X-Gm-Message-State: AOAM530a3BlL7ayi3wNRFAGJE3JVgFeDIyRhgpe+76sx3FAjt+wVEDwA
        wyi9sVSW6mrq25zv0PsbSetk+ST/wwvLK93jPbfU8Cm7r5PPbLRAH6ETwnakJNiIVCFx84s8AIX
        wyCJZVNASqLvQ05Ll
X-Received: by 2002:a05:600c:1e1d:b0:397:5496:4435 with SMTP id ay29-20020a05600c1e1d00b0039754964435mr2703388wmb.28.1653381504982;
        Tue, 24 May 2022 01:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyliRj6RYxmlxfWt6ULiYPmj66E3wsK7WjAMeXtmfsfwwq8QpmUwojVYoxWAApaVzDqRtsnlg==
X-Received: by 2002:a05:600c:1e1d:b0:397:5496:4435 with SMTP id ay29-20020a05600c1e1d00b0039754964435mr2703362wmb.28.1653381504689;
        Tue, 24 May 2022 01:38:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id j15-20020adfb30f000000b0020d12936563sm14262360wrd.108.2022.05.24.01.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 01:38:24 -0700 (PDT)
Message-ID: <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time
 for periodic probe
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yuwei Wang <wangyuweihx@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org
Date:   Tue, 24 May 2022 10:38:22 +0200
In-Reply-To: <20220522031739.87399-1-wangyuweihx@gmail.com>
References: <20220522031739.87399-1-wangyuweihx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-05-22 at 03:17 +0000, Yuwei Wang wrote:
> commit 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> neighbor entries which with NTF_EXT_MANAGED flags will periodically call neigh_event_send()
> for performing the resolution. and the interval was set to DELAY_PROBE_TIME
> 
> DELAY_PROBE_TIME was configured as the first probe time delay, and it makes sense to set it to `0`.
> 
> when DELAY_PROBE_TIME is `0`, the queue_delayed_work of neighbor entries with NTF_EXT_MANAGED will
> be called recursively with no interval, and then threads of `system_power_efficient_wq` will consume 100% cpu. 
> 
> as commit messages mentioned in the above commit, we should introduce a new option which means resolution interval.
> 
> Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
> ---
> v2: 
> - move `NDTPA_INTERVAL_PROBE_TIME` to the tail of uAPI enum
> - add `NDTPA_INTERVAL_PROBE_TIME` to `nl_ntbl_parm_policy`
> - add detail explain for the behevior when `DELAY_PROBE_TIME` is `0` in
>   commit messaage
> 
> meanwhile, we should replace `DELAY_PROBE_TIME` with `INTERVAL_PROBE_TIME` 
> in `drivers/net/ethernet/mellanox` after this patch was merged
> 
> and should we remove `include/uapi/linux/sysctl.h` seems it is no
> longer be used.
> 
>  include/net/neighbour.h        |  3 ++-
>  include/net/netevent.h         |  1 +
>  include/uapi/linux/neighbour.h |  1 +
>  include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
>  net/core/neighbour.c           | 15 ++++++++++++--
>  net/decnet/dn_neigh.c          |  1 +
>  net/ipv4/arp.c                 |  1 +
>  net/ipv6/ndisc.c               |  1 +
>  8 files changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 87419f7f5421..75786903f1d4 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -48,6 +48,7 @@ enum {
>  	NEIGH_VAR_RETRANS_TIME,
>  	NEIGH_VAR_BASE_REACHABLE_TIME,
>  	NEIGH_VAR_DELAY_PROBE_TIME,
> +	NEIGH_VAR_INTERVAL_PROBE_TIME,
>  	NEIGH_VAR_GC_STALETIME,
>  	NEIGH_VAR_QUEUE_LEN_BYTES,
>  	NEIGH_VAR_PROXY_QLEN,
> @@ -64,7 +65,7 @@ enum {
>  	NEIGH_VAR_GC_THRESH1,
>  	NEIGH_VAR_GC_THRESH2,
>  	NEIGH_VAR_GC_THRESH3,
> -	NEIGH_VAR_MAX
> +	NEIGH_VAR_MAX,

You should avoid style-only changes in area not touched otherwise by
this 

>  };
>  
>  struct neigh_parms {
> diff --git a/include/net/netevent.h b/include/net/netevent.h
> index 4107016c3bb4..121df77d653e 100644
> --- a/include/net/netevent.h
> +++ b/include/net/netevent.h
> @@ -26,6 +26,7 @@ enum netevent_notif_type {
>  	NETEVENT_NEIGH_UPDATE = 1, /* arg is struct neighbour ptr */
>  	NETEVENT_REDIRECT,	   /* arg is struct netevent_redirect ptr */
>  	NETEVENT_DELAY_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
> +	NETEVENT_INTERVAL_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */

Are you sure we need to notify the drivers about this parameter change?
The host will periodically resolve the neighbours, and that should work
regardless of the NIC offload. I think we don't need additional
notifications.

>  	NETEVENT_IPV4_MPATH_HASH_UPDATE, /* arg is struct net ptr */
>  	NETEVENT_IPV6_MPATH_HASH_UPDATE, /* arg is struct net ptr */
>  	NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE, /* arg is struct net ptr */
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index 39c565e460c7..8713c3ea81b2 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -154,6 +154,7 @@ enum {
>  	NDTPA_QUEUE_LENBYTES,		/* u32 */
>  	NDTPA_MCAST_REPROBES,		/* u32 */
>  	NDTPA_PAD,
> +	NDTPA_INTERVAL_PROBE_TIME,	/* u64, msecs */
>  	__NDTPA_MAX
>  };
>  #define NDTPA_MAX (__NDTPA_MAX - 1)
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 6a3b194c50fe..53f06bfd2a37 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -584,24 +584,25 @@ enum {
>  
>  /* /proc/sys/net/<protocol>/neigh/<dev> */
>  enum {
> -	NET_NEIGH_MCAST_SOLICIT=1,
> -	NET_NEIGH_UCAST_SOLICIT=2,
> -	NET_NEIGH_APP_SOLICIT=3,
> -	NET_NEIGH_RETRANS_TIME=4,
> -	NET_NEIGH_REACHABLE_TIME=5,
> -	NET_NEIGH_DELAY_PROBE_TIME=6,
> -	NET_NEIGH_GC_STALE_TIME=7,
> -	NET_NEIGH_UNRES_QLEN=8,
> -	NET_NEIGH_PROXY_QLEN=9,
> -	NET_NEIGH_ANYCAST_DELAY=10,
> -	NET_NEIGH_PROXY_DELAY=11,
> -	NET_NEIGH_LOCKTIME=12,
> -	NET_NEIGH_GC_INTERVAL=13,
> -	NET_NEIGH_GC_THRESH1=14,
> -	NET_NEIGH_GC_THRESH2=15,
> -	NET_NEIGH_GC_THRESH3=16,
> -	NET_NEIGH_RETRANS_TIME_MS=17,
> -	NET_NEIGH_REACHABLE_TIME_MS=18,
> +	NET_NEIGH_MCAST_SOLICIT = 1,
> +	NET_NEIGH_UCAST_SOLICIT = 2,
> +	NET_NEIGH_APP_SOLICIT = 3,
> +	NET_NEIGH_RETRANS_TIME = 4,
> +	NET_NEIGH_REACHABLE_TIME = 5,
> +	NET_NEIGH_DELAY_PROBE_TIME = 6,
> +	NET_NEIGH_GC_STALE_TIME = 7,
> +	NET_NEIGH_UNRES_QLEN = 8,
> +	NET_NEIGH_PROXY_QLEN = 9,
> +	NET_NEIGH_ANYCAST_DELAY = 10,
> +	NET_NEIGH_PROXY_DELAY = 11,
> +	NET_NEIGH_LOCKTIME = 12,
> +	NET_NEIGH_GC_INTERVAL = 13,
> +	NET_NEIGH_GC_THRESH1 = 14,
> +	NET_NEIGH_GC_THRESH2 = 15,
> +	NET_NEIGH_GC_THRESH3 = 16,
> +	NET_NEIGH_RETRANS_TIME_MS = 17,
> +	NET_NEIGH_REACHABLE_TIME_MS = 18,
> +	NET_NEIGH_INTERVAL_PROBE_TIME = 19,
>  };
>  
>  /* /proc/sys/net/dccp */
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 47b6c1f0fdbb..92447f04cf07 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
>  	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
>  		neigh_event_send_probe(neigh, NULL, false);
>  	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> -			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
> +			   NEIGH_VAR(&tbl->parms, INTERVAL_PROBE_TIME));
>  	write_unlock_bh(&tbl->lock);
>  }
>  
> @@ -2100,7 +2100,9 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
>  	    nla_put_msecs(skb, NDTPA_PROXY_DELAY,
>  			  NEIGH_VAR(parms, PROXY_DELAY), NDTPA_PAD) ||
>  	    nla_put_msecs(skb, NDTPA_LOCKTIME,
> -			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD))
> +			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD) ||
> +	    nla_put_msecs(skb, NDTPA_INTERVAL_PROBE_TIME,
> +			  NEIGH_VAR(parms, INTERVAL_PROBE_TIME), NDTPA_PAD))
>  		goto nla_put_failure;
>  	return nla_nest_end(skb, nest);
>  
> @@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
>  	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
>  	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
>  	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
> +	[NDTPA_INTERVAL_PROBE_TIME]	= { .type = NLA_U64 },

since a 0 value would not make any sense here and will cause problems,
what about adding '.min = 1' ?


Thanks!

Paolo

