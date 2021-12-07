Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A3446BA9F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhLGMHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:07:08 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33599 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbhLGMHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:07:07 -0500
Received: by mail-wr1-f52.google.com with SMTP id d24so29148554wra.0;
        Tue, 07 Dec 2021 04:03:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WOUkRvk8md0qXXeJWUBaI3pWBezAEcrjYlSaZ1Cva6A=;
        b=IJ9JvEIdZjVPaXmiQuBDDuypRCU4M2pzREewawCznlMR3VhnKVBatXB+JIpXdWhLut
         bb/HyAWzYmyqMu2f2KHjcQ6XjsUJS2i8nHQtj6ANFnM9n4Y3WREEUPAyUbxkIW6mVxbc
         c/gceWEczq2UAWCVKnLuUT5cC12BZ6Qfk7AobzIFfWQ4FRJvZrb5eADBskSsMnj6Qkbc
         PkEDgiLYEHG1atWkVjU21I8mQ3D7sUgzKpyAxfQ7CpEoU+04rDgRCzXn0QhR4A4u7bnd
         o39UjtaQ9yNbX9w0RfRUGmIl094cdnMpRf+TJMUXPPoDBVEtMOjk+1pmmhPRbRNKcBsn
         OruA==
X-Gm-Message-State: AOAM532BY5WO1fwZxye7Ju0Dn8FYaqz4GwgCQHmC71IZVDiCzeAPCp4O
        Xj+DVfjYVxeWGxwLTMYzhts=
X-Google-Smtp-Source: ABdhPJzMzHrPwjx1q6wcjSgllaGFav30b9QtgoVVc3D8PMFLIs2P8l6Us9wMV4IxRbCko1NRKBiujw==
X-Received: by 2002:adf:f947:: with SMTP id q7mr50874696wrr.260.1638878616067;
        Tue, 07 Dec 2021 04:03:36 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g18sm3074323wmq.4.2021.12.07.04.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 04:03:34 -0800 (PST)
Date:   Tue, 7 Dec 2021 12:03:33 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] hv_sock: Extract hvs_send_data() helper that takes only
 header
Message-ID: <20211207120333.rmq3mmla5js7kpuj@liuwe-devbox-debian-v2>
References: <20211207063217.2591451-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207063217.2591451-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:32:17PM -0800, Kees Cook wrote:
> When building under -Warray-bounds, the compiler is especially
> conservative when faced with casts from a smaller object to a larger
> object. While this has found many real bugs, there are some cases that
> are currently false positives (like here). With this as one of the last
> few instances of the warning in the kernel before -Warray-bounds can be
> enabled globally, rearrange the functions so that there is a header-only
> version of hvs_send_data(). Silences this warning:
> 
> net/vmw_vsock/hyperv_transport.c: In function 'hvs_shutdown_lock_held.constprop':
> net/vmw_vsock/hyperv_transport.c:231:32: warning: array subscript 'struct hvs_send_buf[0]' is partly outside array bounds of 'struct vmpipe_proto_header[1]' [-Warray-bounds]
>   231 |         send_buf->hdr.pkt_type = 1;
>       |         ~~~~~~~~~~~~~~~~~~~~~~~^~~
> net/vmw_vsock/hyperv_transport.c:465:36: note: while referencing 'hdr'
>   465 |         struct vmpipe_proto_header hdr;
>       |                                    ^~~
> 
> This change results in no executable instruction differences.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Wei Liu <wei.liu@kernel.org>
