Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F3288169
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgJIEnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIEnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:43:47 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021C7C0613D2;
        Thu,  8 Oct 2020 21:43:47 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r10so3166367ilm.11;
        Thu, 08 Oct 2020 21:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=voCiFfDdd2+D4pJRC0Bm4lDshv9ulVu+F7IWds360lc=;
        b=OL3zyK28W68DVIB2CQZ6VHkGxDAAHTTcQCkfUCb0uSTismfrCCwUNXlUSymapxbl+z
         BCVH7wDXFhyE4jFzxjKPybFQlnOBAoreHX8jhyiD+zCEWNlixezb7Y7D96a2ogE29PpE
         F9PpPhdK4QaITTkH0dUeW0MQe2a33K/FsTjdWltKXmqY+PK0R30EIUBlrqnrsDefwBTY
         5i58ryx2CCfkLYrA+3bul8F39JP/s1k4Pvmsfl0pgKOad6TmbTjTTzEe62L41A4Gsx7H
         dAQrkFGQaS1n6FM4S6stZ4uVMTWJjt3x5la3cKN9UNvRSxxP6YFvqHc1EDp23ixcNkWB
         mE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=voCiFfDdd2+D4pJRC0Bm4lDshv9ulVu+F7IWds360lc=;
        b=maQFG+LlKw9RSqK7JiOz6i1Iwje6t2j0udPdTP9KLXohdy0qP3yWKBLqNeQKWdc4na
         Pj57Tp8jw1/66NvmXy4lmcsU8GnbWxZ6Z7YjqAOJ5mlxwSc4LyePTW/cZ48aX2sjKYbU
         ya1CIur4tU3eSt3AYe7Ut4j8YBkR/pO2OSOaWZEsPyM3loNxGrs6IFmdIrFJ3iIqqMlg
         4AZ05RBKDWq3FQEYTuid6a+uLZ8RgwwZc5yZk81c5ofIn9oXOi7pFYcRm5VbmMThcWLn
         +LAYC29OVXs8HOQ4BDzw88YgmUADisRwx8TPSbTGjaNdKNFI12ctQVqux9Qt6gAvEYV2
         jFZw==
X-Gm-Message-State: AOAM5324u0bAvcXM/REdcbYQP/aGqqamE5srM/RlKGuuGyD6Gr6Pckf5
        jeOqwqEvJNNGv4rPBPhidac=
X-Google-Smtp-Source: ABdhPJxeZYjl4p8Lu4Y/goIiUB8AOGanASpF59ctko9u8/kDUelPBHwy5dzSrmXPNGZxeKYCrWdpaw==
X-Received: by 2002:a92:5f15:: with SMTP id t21mr8946880ilb.125.1602218626347;
        Thu, 08 Oct 2020 21:43:46 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y6sm3664264ili.36.2020.10.08.21.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:43:45 -0700 (PDT)
Subject: [bpf-next PATCH 0/6] sockmap/sk_skb program memory acct fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:43:27 -0700
Message-ID: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users of sockmap and skmsg trying to build proxys and other tools
have pointed out to me the error handling can be problematic. If
the proxy is under-provisioned and/or the BPF admin does not have
the ability to update/modify memory provisions on the sockets
its possible data may be dropped. For some things we have retries
so everything works out OK, but for most things this is likely
not great. And things go bad.

The original design dropped memory accounting on the receive
socket as earlyy as possible. We did this early in sk_skb
handling and then charged it to the redirect socket immediately
after running the BPF program.

But, this design caused a fundamental problem. Namely, what should we do
if we redirect to a socket that has already reached its socket memory
limits. For proxy use cases the network admin can tune memory limits.
But, in general we punted on this problem and told folks to simply make
your memory limits high enough to handle your workload. This is not a
really good answer. When deploying into environments where we expect this
to be transparent its no longer the case because we need to tune params.
In fact its really only viable in cases where we have fine grained
control over the application. For example a proxy redirecting from an
ingress socket to an egress socket. The result is I get bug
reports because its surprising for one, but more importantly also breaks
some use cases. So lets fix it.

This series cleans up the different cases so that in many common
modes, such as passing packet up to receive socket, we can simply
use the underlying assumption that the TCP stack already has done
memory accounting.

Next instead of trying to do memory accounting against the socket
we plan to redirect into we keep memory accounting on the receive
socket until the skb can be put on the redirect socket. This means
if we do an egress redirect to a socket and sock_writable() returns
EAGAIN we can requeue the skb on the workqueue and try again. The
same scenario plays out for ingress. If the skb can not be put on
the receive queue of the redirect socket than we simply requeue and
retry. In both cases memory is still accounted for against the
receiving socket.

This also handles head of line blocking. With the above scheme the
skb is on a queue associated with the socket it will be sent/recv'd
on, but the memory accounting is against the received socket. This
means the receive socket can advance to the next skb and avoid head
of line blocking. At least until its receive memory on the socket
runs out. This will put some maximum size on the amount of data any
socket can enqueue giving us bounds on the skb lists so they can't grow
indefinately.

Overall I think this is a win. Tested with test_sockmap and dropped
into a small cluster to see if anything pops out.

These are fixes, but I tagged it for bpf-next considering we are
at -rc8.

---

John Fastabend (6):
      bpf, sockmap: skb verdict SK_PASS to self already checked rmem limits
      bpf, sockmap: On receive programs try to fast track SK_PASS ingress
      bpf, sockmap: remove skb_set_owner_w wmem will be taken later from sendpage
      bpf, sockmap: remove dropped data on errors in redirect case
      bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
      bpf, sockmap: Add memory accounting so skbs on ingress lists are visible


 net/core/skmsg.c |   81 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 36 deletions(-)

--
Signature
