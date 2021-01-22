Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608D7300078
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbhAVKgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:36:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728042AbhAVKe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611311565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IShh/PB74Qh7ZVtwc2vsohdpK5rU9/+uE6woLaCXjt4=;
        b=QRs3j9dPPiZ24xXHLJCTWSOt1GsqYmMp6wRPdDus3jlxAvMMvgkh43K+FDmZozt3oytvCh
        FoWxyx6hw84gQjoayAQtq7w/fWPDWdhUgieFYaMzWihkrLAc8MEdr5Bkmfb/lgbtA9xSqj
        e00uORx4YPm2fiC+NJryp73FZ+Zc1i0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-Jb8oDqr2MC-jVWyfrSMdHw-1; Fri, 22 Jan 2021 05:32:43 -0500
X-MC-Unique: Jb8oDqr2MC-jVWyfrSMdHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A1EB1005504;
        Fri, 22 Jan 2021 10:32:41 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D8E671D55;
        Fri, 22 Jan 2021 10:32:33 +0000 (UTC)
Date:   Fri, 22 Jan 2021 11:32:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv10 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20210122113232.70040869@carbon>
In-Reply-To: <20210122025007.2968381-1-liuhangbin@gmail.com>
References: <20210121130642.2943811-1-liuhangbin@gmail.com>
        <20210122025007.2968381-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 10:50:07 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> This patch add a xdp program on egress to show that we can modify
> the packet on egress. In this sample we will set the pkt's src
> mac to egress's mac address. The xdp_prog will be attached when
> -X option supplied.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

I think we have nitpicked this enough ;-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> v10:
> make xdp_redirect_map() always inline.
> 
> v9:
> roll back to just set src mac to egress interface mac on 2nd xdp prog,
> this could avoid packet reorder introduce in patch v6.
> 
> v8: Fix some checkpatch issues.
> 
> v7:
> a) use bpf_object__find_program_by_name() instad of
>    bpf_object__find_program_by_title()
> b) set default devmap fd to 0
> 
> v6: no code update, only rebase the code on latest bpf-next
> 
> v5:
> a) close fd when err out in get_mac_addr()
> b) exit program when both -S and -X supplied.
> 
> v4:
> a) Update get_mac_addr socket create
> b) Load dummy prog regardless of 2nd xdp prog on egress
> 
> v3:
> a) modify the src mac address based on egress mac
> 
> v2:
> a) use pkt counter instead of IP ttl modification on egress program
> b) make the egress program selectable by option -X
> ---
>  samples/bpf/xdp_redirect_map_kern.c |  60 +++++++++++++--
>  samples/bpf/xdp_redirect_map_user.c | 112 +++++++++++++++++++++++-----
>  2 files changed, 147 insertions(+), 25 deletions(-)
 
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

