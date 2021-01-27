Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9995F306073
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhA0QBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:01:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236895AbhA0P74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:59:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611763110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RRdCTN25BNxrn+QlHK+1vo/ZCSmfHH6VXv68N8oXCM0=;
        b=HrszeDxcPrP4VWpSO4o8vKyDzdpwOCddLPEHpYsQ8CCaRYw9UfDwXVKJP8Wz7jumC53o+7
        lXnMlrl+NPaTa/Mbuf/GSiFt311UgCh0AjZi4mdqIC/uvHxknyYh1rExkRP0XcKJT048dR
        Om1VkFpA0EKBLVsMfIZa1vNK1jRMbPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-zMZJwoqOOgO_pm2HvqiO7w-1; Wed, 27 Jan 2021 10:58:26 -0500
X-MC-Unique: zMZJwoqOOgO_pm2HvqiO7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74691107ACE3;
        Wed, 27 Jan 2021 15:58:24 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3290D60864;
        Wed, 27 Jan 2021 15:58:11 +0000 (UTC)
Date:   Wed, 27 Jan 2021 16:58:10 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210127165810.7ab9c8b8@carbon>
In-Reply-To: <20210125124516.3098129-2-liuhangbin@gmail.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
        <20210125124516.3098129-1-liuhangbin@gmail.com>
        <20210125124516.3098129-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 20:45:11 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> By using xdp_redirect_map in sample/bpf and send pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> 
> There are about +/- 0.1M deviation for native testing, the performance
> improved for the base-case, but some drop back with xdp devmap prog attached.
> 
> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M |  8.0M
> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M |  9.7M
> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M |  7.5M
> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M |  9.1M

I want to highlight the improvement 9.1M -> 9.5M.  This is the native
(40e->i40e) case where the isn't any "2nd xdp_prog".

This means that when we introduced the "2nd xdp_prog", we lost a little
performance without noticing (death-by-a-1000-paper-cuts), for the
baseline case where this feature is not used/activated.

This patch regains that performance for our baseline.  That in itself
make this patch worth it.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

