Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730FF69B44B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBQU7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBQU7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:59:17 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DA63B659;
        Fri, 17 Feb 2023 12:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=6XqZGcFwGDlPUYhyro44Otgaqy95Gc+0z48vc18AVdM=; b=i/+U0PIKK3N7AJzizcArR8yQSk
        d4CVvEW6gHYWOi3cOGZAmdVY8OqRCV1cotZI+tYL61rfOvJhg8pP/xXUHIQe9X1BrjxFkiLfDGV5P
        GNMEluaGGBLnK8ufvKT79jCCVSbjjLnTGJDcLNIMEfT76cV27FcQO3TK/4dFLKZlM7+Io69sX6HXo
        Afqse6blpNkGCPyaZXuLII2/Cky83Y/g1GAASnzH9640nUbXjDkHbjqfceV1dWf+sovznEiAes7LE
        XC1/ReqhidldpY1XtrLBpFL4oHneBne1WfXKOa5f5Cv73UP8unQ2RhzCAlZbgBCHJ1kg6zrpwc3uf
        B6zE5yRQ==;
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT7p0-000FQz-Je; Fri, 17 Feb 2023 21:59:10 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT7p0-000H52-6t; Fri, 17 Feb 2023 21:59:10 +0100
Subject: Re: [PATCH bpf-next V2] igc: enable and fix RX hash usage by netstack
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        martin.lau@kernel.org, ast@kernel.org, alexandr.lobakin@intel.com,
        yoong.siang.song@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        pmenzel@molgen.mpg.de
References: <167656636587.1912541.8039324850101942090.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <571350f8-3302-abc5-505a-8e5b1f77defe@iogearbox.net>
Date:   Fri, 17 Feb 2023 21:59:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <167656636587.1912541.8039324850101942090.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26815/Fri Feb 17 09:41:01 2023)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/23 5:52 PM, Jesper Dangaard Brouer wrote:
> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
> hardware wasn't configured to provide RSS hash, thus it made sense to not
> enable net_device NETIF_F_RXHASH feature bit.
> 
> The NIC hardware was configured to enable RSS hash info in v5.2 via commit
> 2121c2712f82 ("igc: Add multiple receive queues control supporting"), but
> forgot to set the NETIF_F_RXHASH feature bit.
> 
> The original implementation of igc_rx_hash() didn't extract the associated
> pkt_hash_type, but statically set PKT_HASH_TYPE_L3. The largest portions of
> this patch are about extracting the RSS Type from the hardware and mapping
> this to enum pkt_hash_types. This was based on Foxville i225 software user
> manual rev-1.3.1 and tested on Intel Ethernet Controller I225-LM (rev 03).
> 
> For UDP it's worth noting that RSS (type) hashing have been disabled both for
> IPv4 and IPv6 (see IGC_MRQC_RSS_FIELD_IPV4_UDP + IGC_MRQC_RSS_FIELD_IPV6_UDP)
> because hardware RSS doesn't handle fragmented pkts well when enabled (can
> cause out-of-order). This results in PKT_HASH_TYPE_L3 for UDP packets, and
> hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
> the effect that netstack will do a software based hash calc calling into
> flow_dissect, but only when code calls skb_get_hash(), which doesn't
> necessary happen for local delivery.
> 
> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control supporting")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

I presume this should go via net-next, not bpf-next? (Didn't find specific
dependencies, so moved to patchwork netdev bucket..)
