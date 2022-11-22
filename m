Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F19633A29
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiKVKcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiKVKbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:31:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217D814D2F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669112771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oI19SpiWxAmPefCFdwMjosxLKWiNQfEQVKjLpldteMU=;
        b=JntkHi6GiBap4FScDpnwSRC7k82/ki9hqIOQJXvfCE8zs8DOV6auuw514hHByaRWFfMjKk
        fNzkpZ+sQHSqXNW1WDU9ZseqH+5IfyhXqxfQ1lbvnOykyRAxWU+BdV0OD0xOVSGzRFCnvp
        48k/0xVic6KPLL7feQUP7PXTAT6dwK8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-EFbcLnX4OWSrtTD0XdKNXQ-1; Tue, 22 Nov 2022 05:26:10 -0500
X-MC-Unique: EFbcLnX4OWSrtTD0XdKNXQ-1
Received: by mail-qk1-f200.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso18524176qkp.7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:26:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oI19SpiWxAmPefCFdwMjosxLKWiNQfEQVKjLpldteMU=;
        b=cifOPFjcG2Hp6bdQOfxI2+O3DBaFTV/pE3oiabCtAj37ySAqq7ctMPFhI9/WpYM8pk
         rJ1MJ/rLwZNIUgD4DovXB7CfbaRFNNGofyaRT6zl/z+XY9MfmGWFM/Corknrk9Y1FkAz
         sb1IUbxO8Pcc1t5q/F0fh5+b5g0rAgEo53/CIwvvyIeRrZCWuYv6HRcTx8XdXbeGCney
         a0BO4uS10CVMYLYPGkRQIaYpG16UW9NyZ7wSmKvYMD0bHDq3ciZCeRcje9378OZ4KFP3
         Qg0Vz2iGN3EeYMiYeIMCMOtzJkGaEdSCYxREfEbbZga+wmmdsJ+ii1yrYhNo2jK+S7En
         biuQ==
X-Gm-Message-State: ANoB5pkD9Yf0eSRRN1T8GUTcVtnQlaJ6Qx6CMnHldTjynrdlgRJo/jVX
        2QQrKMSR+FYjdOzIAPzSPO2y7wV7+yx7nQIEfc5Uu3ibsiTYB3jqejsH9HAgiVUgl+GrP1LajOh
        ZY4qgQZdSYIG3D95G
X-Received: by 2002:ac8:7285:0:b0:3a5:9dc:d83f with SMTP id v5-20020ac87285000000b003a509dcd83fmr21140085qto.28.1669112769570;
        Tue, 22 Nov 2022 02:26:09 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5uIxz+r6GkVOEyvz5R8F3LnJxWIP+Qp5GaLgABRZf8Xq8IBir/I7M/JSZp2undMMB30HiItw==
X-Received: by 2002:ac8:7285:0:b0:3a5:9dc:d83f with SMTP id v5-20020ac87285000000b003a509dcd83fmr21140074qto.28.1669112769275;
        Tue, 22 Nov 2022 02:26:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id z26-20020ac875da000000b003a622111f2csm7576918qtq.86.2022.11.22.02.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 02:26:08 -0800 (PST)
Message-ID: <83852e9f8ca11e75db07a2f4c3577633c01fc68b.camel@redhat.com>
Subject: Re: [PATCH] [openvswitch v3 1/2] openvswitch: Add support to count
 upcall packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>, echaudro@redhat.com,
        pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
Cc:     wangpeihui@inspur.com, netdev@vger.kernel.org, dev@openvswitch.org
Date:   Tue, 22 Nov 2022 11:26:05 +0100
In-Reply-To: <20221118111932.682738-1-wangchuanlei@inspur.com>
References: <20221118111932.682738-1-wangchuanlei@inspur.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-11-18 at 06:19 -0500, wangchuanlei wrote:
> Add support to count upall packets
> 
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>

The fact that you are posting this series simultaneusly to netdev and
the ovs ML with only patch 1/2 landing here is confusing. On next
iteration please sent this patch to netdev as an individual one.

Additionally, please write a more verbose changelog.

[...]

> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..17146200e7c5 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,28 @@ static struct vport *new_vport(const struct vport_parms *parms)
>  	return vport;
>  }
>  
> +static void ovs_vport_upcalls(struct sk_buff *skb,
> +			      const struct dp_upcall_info *upcall_info,
> +			      bool upcall_success)
> +{
> +	if (upcall_info->cmd == OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd == OVS_PACKET_CMD_ACTION) {
> +		const struct vport *p = OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +		u64 *stats_counter_upcall;
> +
> +		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);
> +		if (upcall_success)
> +			stats_counter_upcall = &vport_stats->n_upcall_success;
> +		else
> +			stats_counter_upcall = &vport_stats->n_upcall_fail;

You can move the 'if' statement inside the stats update block and
simplify the code a bit

> +
> +		u64_stats_update_begin(&vport_stats->syncp);
> +		(*stats_counter_upcall)++;

This should be u64_stats_inc()

> +		u64_stats_update_end(&vport_stats->syncp);
> +	}
> +}
> +

[...]

> @@ -305,8 +330,12 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
>  		err = queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
>  	else
>  		err = queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> -	if (err)
> +	if (err) {
> +		ovs_vport_upcalls(skb, upcall_info, false);
>  		goto err;
> +	} else {
> +		ovs_vport_upcalls(skb, upcall_info, true);

Or simply:

	ovs_vport_upcalls(skb, upcall_info, !ret);

before the 'if'

> +	}
>  
>  	return 0;
>  
> @@ -1825,6 +1854,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>  
> +	vport->vport_upcall_stats_percpu =
> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err = -ENOMEM;
> +		goto err_destroy_portids;

You likelly need to additionally destroy 'vport' on this error path.

> +	}
> +
>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);

[...]

> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..17b8ad1a9a16 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,56 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
>  	stats->tx_packets = dev_stats->tx_packets;
>  }
>  
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats
> + * @ovs_vport_upcall_stats: location to store stats
> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_upcall_stats *stats)
> +{
> +	int i;
> +
> +	stats->upcall_success = 0;
> +	stats->upcall_fail = 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *percpu_upcall_stats;
> +		struct vport_upcall_stats_percpu local_stats;
> +		unsigned int start;
> +
> +		percpu_upcall_stats = per_cpu_ptr(vport->vport_upcall_stats_percpu, i);
> +		do {
> +			start = u64_stats_fetch_begin_irq(&percpu_upcall_stats->syncp);

This is an obsolted API, please use plain u64_stats_fetch_begin()
instead

> +			local_stats = *percpu_upcall_stats;

You need to fetch each stat individually with u64_stats_read()


> +		} while (u64_stats_fetch_retry_irq(&percpu_upcall_stats->syncp, start));
> +
> +		stats->upcall_success += local_stats.n_upcall_success;
> +		stats->upcall_fail += local_stats.n_upcall_fail;
> +	}
> +}
> +

Thanks,

Paolo

