Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8037687A57
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjBBKez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjBBKen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4C66A326
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 02:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675334042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SpknTtimSl+guOKxaF16NMhAWaSqtArEG/8BewjAniM=;
        b=FtcbzLjxVvJOkGDqDyXOXzv8zcTFFurVB54v0WqaIDm3C1007IHZ86i739AjhFrDZd6v8s
        VfAjh73UBibhMHiki4Gq2A1U9K6c30jIQFJLkZ9dgi1z0iJA+59E6t9/rffU2netortYOM
        uhz4K8wootE7tgp1m5NN/ETfG6zuXRY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-ZezsL4NgOG-E7yK2WWOadw-1; Thu, 02 Feb 2023 05:34:00 -0500
X-MC-Unique: ZezsL4NgOG-E7yK2WWOadw-1
Received: by mail-wr1-f72.google.com with SMTP id r6-20020adff106000000b002bfe5fb9649so156918wro.14
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 02:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpknTtimSl+guOKxaF16NMhAWaSqtArEG/8BewjAniM=;
        b=3LWcmxpaPYNL6o6Nw8AYJqTtJFfaaHsF3WIGX12UTQ5XKauzlECFhdgCBDeRp276eM
         YIv3oXoTVGhHFPH/+Nbp/0Dcsb7RTFl4+U4ujhar9R/0xjeuNVy2M50bZj4mHIpcSd5J
         0U56j+BCAPoTy0ZzASQOwFor6eUbEdZ4y0U0ds9/bILuIT7mjeRi8C7/ng+ugq/yEZNb
         MXk0lUoivH3in8EdiBlj8zC/u8rrjOxVIIQM1AC6PC5apADR99506M6NplJsiamcQZjv
         6VqNDETk3BU6Ckpo2ju0lY7nGTXT/+u72JympAWlU6RVKnydX8+rClD9mte6P31saO3v
         Xfrg==
X-Gm-Message-State: AO0yUKXdBeMjimL9f7pYioabpHHx2IyJjwGGY+RyAf/l1Df3l9jr0IAk
        zqytwZbzyYaEl246ZXOXth4StcXtrew51YUg+PlOrCldGKX8eBinVspCBA0lKQ8ye176w1/DZAn
        UlTqml0j10c3wdMxN
X-Received: by 2002:a1c:f606:0:b0:3db:3695:11b4 with SMTP id w6-20020a1cf606000000b003db369511b4mr5235168wmc.33.1675334039773;
        Thu, 02 Feb 2023 02:33:59 -0800 (PST)
X-Google-Smtp-Source: AK7set/aRh3S+7oJAh3Alg/NT2t1M9KB8chGYSyRGs8MriRivULozR8wG/So+QjE+3JvxeVKT3C53g==
X-Received: by 2002:a1c:f606:0:b0:3db:3695:11b4 with SMTP id w6-20020a1cf606000000b003db369511b4mr5235153wmc.33.1675334039564;
        Thu, 02 Feb 2023 02:33:59 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fc:826d:55d8:70a4:3d30:fc2f])
        by smtp.gmail.com with ESMTPSA id l13-20020adff48d000000b002366e3f1497sm19523049wro.6.2023.02.02.02.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:33:58 -0800 (PST)
Date:   Thu, 2 Feb 2023 05:33:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/7] tools/virtio: enable to build with retpoline
Message-ID: <20230202053341-mutt-send-email-mst@kernel.org>
References: <20230202090934.549556-1-mie@igel.co.jp>
 <20230202090934.549556-3-mie@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202090934.549556-3-mie@igel.co.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:09:29PM +0900, Shunsuke Mie wrote:
> Add build options to bring it close to a linux kernel. It allows for
> testing that is close to reality.
> 
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>

This too, pls submit separately.

> ---
>  tools/virtio/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
> index 1b25cc7c64bb..7b7139d97d74 100644
> --- a/tools/virtio/Makefile
> +++ b/tools/virtio/Makefile
> @@ -4,7 +4,7 @@ test: virtio_test vringh_test
>  virtio_test: virtio_ring.o virtio_test.o
>  vringh_test: vringh_test.o vringh.o virtio_ring.o
>  
> -CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
> +CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h -mfunction-return=thunk -fcf-protection=none -mindirect-branch-register
>  CFLAGS += -pthread
>  LDFLAGS += -pthread
>  vpath %.c ../../drivers/virtio ../../drivers/vhost
> -- 
> 2.25.1

