Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6E964C562
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiLNI6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbiLNI6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:58:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DCD62C1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671008283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=832mpI+gR6rtu0NTrZQMBVgIPwRT7EhuSzoHFhXLS+0=;
        b=hNK84nvEZDkgw6i2HN0RDK6pEC5inFIRRHfCjQFI+ZPKSdqApm7UcUOffhtDT4bfcxM6Z3
        YYwJjj7RBIgXVSkbvMD63y5n/y3JnuYeQUiCcEPtQKhTUgDaIgpH0i1RItOuGIRJ0gSWuJ
        Jk3SPZNDu0I/O60mwVmUrJLukhdUO1M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-WKomTUwyMaKJpkhCVfJPBw-1; Wed, 14 Dec 2022 03:58:01 -0500
X-MC-Unique: WKomTUwyMaKJpkhCVfJPBw-1
Received: by mail-wm1-f70.google.com with SMTP id f20-20020a7bc8d4000000b003d1cda5bd6fso3882637wml.9
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:58:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=832mpI+gR6rtu0NTrZQMBVgIPwRT7EhuSzoHFhXLS+0=;
        b=tcH2Wb7t3J1X+0Yhv7TIAZqpKu3pA2o1mWxLr4qhedPvzQwbNnnPMwFLsWSxKI5Fzb
         /PgZ3yOu2f1faFeCi6OoM9/cZ+xkoRG9P1NiyG7HI71o4YWdEUTPo2OoOPpNUY2EtoeU
         P+7yCHtMCEnBLpFiD2bsSfmij1Hftzw3o4NpSIB9oybwTdOd+ERm0C3b3Yilh8gaPn7+
         7HQkPRaJfucTFVj2zkLhz1l/RlouE48Kufb/cHOErDhWKxbNjRbfRB2QIGYAhsZOs/0V
         fqmv6C4zwzecaAqUHBgWu3l0b5geQ9U/ZRct+F/aPFW+vAOkmqByr3a47qWoVhqehbAK
         LDAQ==
X-Gm-Message-State: ANoB5pn2PA9OXyyucROyx6EN5Ptl7AU/ND4O3wcu51tRz0VGPqDiPdj+
        e2W1IRkKri7z/dcd8vrma76i0HJxpy6hTw5UqY1xXw6JPlW2lrNYnujFIrQu7pKnnTfnLpsrCYF
        J9ddntMliYcqTnR94
X-Received: by 2002:a05:600c:3d92:b0:3c6:e60f:3f4a with SMTP id bi18-20020a05600c3d9200b003c6e60f3f4amr18216229wmb.1.1671008280665;
        Wed, 14 Dec 2022 00:58:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf53p0lWtwtyxZpsSsSCyKb1X/sJvqIEShJdkD4rFJgOxq6InnJoxKzbHWv/g59LP540LxvirA==
X-Received: by 2002:a05:600c:3d92:b0:3c6:e60f:3f4a with SMTP id bi18-20020a05600c3d9200b003c6e60f3f4amr18216216wmb.1.1671008280437;
        Wed, 14 Dec 2022 00:58:00 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id m17-20020a7bce11000000b003d2157627a8sm1685733wmc.47.2022.12.14.00.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 00:57:59 -0800 (PST)
Date:   Wed, 14 Dec 2022 09:57:54 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <20221214085754.6kogsesmqcud5ggn@sgarzare-redhat>
References: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 07:28:42PM +0000, Bobby Eshleman wrote:
>This commit changes virtio/vsock to use sk_buff instead of
>virtio_vsock_pkt. Beyond better conforming to other net code, using
>sk_buff allows vsock to use sk_buff-dependent features in the future
>(such as sockmap) and improves throughput.
>
>This patch introduces the following performance changes:
>
>Tool/Config: uperf w/ 64 threads, SOCK_STREAM
>Test Runs: 5, mean of results
>Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
>
>Test: 64KB, g2h
>Before: 21.63 Gb/s
>After: 25.59 Gb/s (+18%)
>
>Test: 16B, g2h
>Before: 11.86 Mb/s
>After: 17.41 Mb/s (+46%)
>
>Test: 64KB, h2g
>Before: 2.15 Gb/s
>After: 3.6 Gb/s (+67%)
>
>Test: 16B, h2g
>Before: 14.38 Mb/s
>After: 18.43 Mb/s (+28%)
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
>
>Note: v7 only built, not retested since v6.

I re-tested and everything seems okay:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

