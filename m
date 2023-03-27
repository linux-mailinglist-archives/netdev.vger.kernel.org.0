Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838B66CA600
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 15:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbjC0NdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 09:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjC0NdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 09:33:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7506E1BC6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679923944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=45ANxRXv+CmKBORJQeZkZo556TyX4xY4z1xyvoQpf7s=;
        b=MpQpTJ1qAQo4LxA57GJho5oFguBFS3kjSjZcojx6p5kjexzU9Bv2DnFGjnTRSBGMvCnnZq
        gq/ONRoLhUntJDEchLiclOiQEscCU+MUd64ZAHbuQp1eQOsOiOFSeSof10sSXuSZsPPhWb
        LVt4aGvu4NQSitgy68vkM48LshNKg/Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-T-SKuSfoNmyVlsaYHNWJLQ-1; Mon, 27 Mar 2023 09:32:21 -0400
X-MC-Unique: T-SKuSfoNmyVlsaYHNWJLQ-1
Received: by mail-wm1-f71.google.com with SMTP id bg13-20020a05600c3c8d00b003ed40f09355so4719483wmb.5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45ANxRXv+CmKBORJQeZkZo556TyX4xY4z1xyvoQpf7s=;
        b=CaET05Z955OIB9MSfwfw6si2iOqsF0R9z3m4avhsEi6Kjc4/LvneNgZqqCVXg19Q0L
         7t+p0lHY14zI19h0x8x1g7p5uvLQYAd8BsU3HuDI3bDkR+EtFVU3D0OWtU1ey9qHYH6c
         4gpo2iCqru5/NP/K23R8xUVBpXBQnjCrn4UZGReLCNBwPRhr/zmaQheP/wqzXqXmxU87
         JfXYTw4q4bS9+wf7YEmGO1hBONyfaTIcacg0NX590g5dtEwMxwMWTtki4xLtilJopqu9
         F04OjvTgxvBhzz8wXwqGLhxWdqzOGUMXdxdv+ZziEFgeQVR8v1C7xzFhMEgruv1CdqNt
         TuXQ==
X-Gm-Message-State: AO0yUKV2LFxLZXzXRSXIBvZkLTamVIzTHvUKdUdlZq/bahh63MGEmqxC
        sEFIlKroyLyvjVabVNjjyfyq6rwN2QOHHS7ECjZ9tm27wwP3wgC+3yDHYEpV0pAT6tK4n5hMXec
        KrRf+tFigD1M8//nE
X-Received: by 2002:a7b:c7d6:0:b0:3e1:f8af:8772 with SMTP id z22-20020a7bc7d6000000b003e1f8af8772mr9393539wmk.9.1679923940256;
        Mon, 27 Mar 2023 06:32:20 -0700 (PDT)
X-Google-Smtp-Source: AK7set8gdRVPXdFw2VEM14Dq51u4OtBaddjJUio2jBLT7UtvdL6xG4rHCigflYhYz9nOXRbjvmAY9g==
X-Received: by 2002:a7b:c7d6:0:b0:3e1:f8af:8772 with SMTP id z22-20020a7bc7d6000000b003e1f8af8772mr9393524wmk.9.1679923940000;
        Mon, 27 Mar 2023 06:32:20 -0700 (PDT)
Received: from redhat.com ([2.52.153.142])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c354600b003ede6540190sm9086871wmq.0.2023.03.27.06.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:32:19 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:32:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com
Subject: Re: [GIT PULL] vdpa: bugfix
Message-ID: <20230327093125-mutt-send-email-mst@kernel.org>
References: <20230327091947-mutt-send-email-mst@kernel.org>
 <20230327092909-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327092909-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And the issue was that the author self-nacked the single fix here.
So we'll merge another fix, later.

On Mon, Mar 27, 2023 at 09:30:13AM -0400, Michael S. Tsirkin wrote:
> Looks like a sent a bad pull request. Sorry!
> Please disregard.
> 
> On Mon, Mar 27, 2023 at 09:19:50AM -0400, Michael S. Tsirkin wrote:
> > The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:
> > 
> >   Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to 8fc9ce051f22581f60325fd87a0fd0f37a7b70c3:
> > 
> >   vdpa/mlx5: Remove debugfs file after device unregister (2023-03-21 16:39:02 -0400)
> > 
> > ----------------------------------------------------------------
> > vdpa: bugfix
> > 
> > An error handling fix in mlx5.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> 
> 
> 
> > ----------------------------------------------------------------
> > Eli Cohen (1):
> >       vdpa/mlx5: Remove debugfs file after device unregister
> > 
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)

