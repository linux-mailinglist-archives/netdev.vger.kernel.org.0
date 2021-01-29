Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B2830870A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 09:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhA2H7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 02:59:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232408AbhA2H6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 02:58:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611907099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=frWt5ROwdAqhxGSC35VniZUKfzS+yNeowZUQl2ctpUE=;
        b=LL7WcpH76i95Qk5WgrSqK26ZKCCr8GK662prap6yLUmjcAaktBYKjeamoF7kfpy8wYcVsF
        fL+82TYy7oImiHL0u4CWOcPqxJOLPpVwhPL3DF0nAQ5aDqIqRwLrABSZjhJ3csm5YFaqie
        Gq0xWXydmN1CQCWU3jCWj47NAENggQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-ja8k-lrlNzSRSo1R1QwNOQ-1; Fri, 29 Jan 2021 02:58:16 -0500
X-MC-Unique: ja8k-lrlNzSRSo1R1QwNOQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D13DB180A0A9;
        Fri, 29 Jan 2021 07:58:14 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C5C85D9EF;
        Fri, 29 Jan 2021 07:58:09 +0000 (UTC)
Date:   Fri, 29 Jan 2021 08:58:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
Message-ID: <20210129085808.4e023d3f@carbon>
In-Reply-To: <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
        <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 20:51:23 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 1/26/21 10:39 AM, Jesper Dangaard Brouer wrote:
> > The current layout of net_device is not optimal for cacheline usage.
> > 
> > The member adj_list.lower linked list is split between cacheline 2 and 3.
> > The ifindex is placed together with stats (struct net_device_stats),
> > although most modern drivers don't update this stats member.
> > 
> > The members netdev_ops, mtu and hard_header_len are placed on three
> > different cachelines. These members are accessed for XDP redirect into
> > devmap, which were noticeably with perf tool. When not using the map
> > redirect variant (like TC-BPF does), then ifindex is also used, which is
> > placed on a separate fourth cacheline. These members are also accessed
> > during forwarding with regular network stack. The members priv_flags and
> > flags are on fast-path for network stack transmit path in __dev_queue_xmit
> > (currently located together with mtu cacheline).
> > 
> > This patch creates a read mostly cacheline, with the purpose of keeping the
> > above mentioned members on the same cacheline.
> > 
> > Some netdev_features_t members also becomes part of this cacheline, which is
> > on purpose, as function netif_skb_features() is on fast-path via
> > validate_xmit_skb().  
> 
> A long over due look at the organization of this struct. Do you have
> performance numbers for the XDP case?

Yes, my measurements are documented here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_redir01_net_device.org

Calc improvements of xdp_redirect_map on driver i40e:
 * (1/12115061-1/12906785)*10^9 = 5.06 ns
 * ((12906785/12115061)-1)*100  = 6.54%

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

