Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46281B7148
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgDXJ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:56:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44084 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgDXJ4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587722197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B0Qqh9TDBZRHUvv2vtzJJZDrY1m/LNDZHf4jDBqqYrQ=;
        b=MwB/VM/eY8IsHF55FMxiUKK6I8iJGQ/g0UMv9j7FMqWYw1StCj675EZoP6daN+wJKpUsOy
        U5mKMdZ+JlYUfknRQ6LHKIAZVc/0SQcQpr2OXyKq8qNPJViKPYBvdiuSzszD+50OVpe4Nz
        j+5wf1C8rW+JJK86AIP5qBanKTOX7I4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-ZJzFMk2oOYueEVKCJfZsDA-1; Fri, 24 Apr 2020 05:56:34 -0400
X-MC-Unique: ZJzFMk2oOYueEVKCJfZsDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6940872FF7;
        Fri, 24 Apr 2020 09:56:31 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 412B75DA30;
        Fri, 24 Apr 2020 09:56:17 +0000 (UTC)
Date:   Fri, 24 Apr 2020 11:56:16 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 06/17] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200424115616.77a5689c@carbon>
In-Reply-To: <20200424021148.83015-7-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
        <20200424021148.83015-7-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 20:11:37 -0600
David Ahern <dsahern@kernel.org> wrote:

> Running programs in the egress path, on skbs or xdp_frames, does not
> require driver specific resources like Rx path. Accordingly, the
> programs can be run in core code, so add xdp_egress_prog to net_device
> to hold a reference to an attached program.

I disagree.  The TX path does need driver specific resources, most
importantly information about the TX-queue that was used.

That said, I think this patch is the right design, to place this more
centrally in the net-core code, as driver changes are harder to
maintain and generally painful (I speak from experience ;-)).

After this patchset goes in, we need continue this work, and find a
solution for the XDP-redirect overflow problem, and TX-queue selection.
We might still have some driver work ahead, as I think we can change the
ndo_xdp_xmit() API, to give us the information I'm looking for.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

