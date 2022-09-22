Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA65E5E3B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiIVJQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiIVJQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:16:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D95ACC8F4
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663838172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhZLFn1R5tarTTTxU9XzOLKoFe4nPWuQCWD3fmeWO70=;
        b=R5a4MQCIPjorIOui5cPHj9jBJjqwliSIYFWDW77TJcXy6jP/KTQeT2qxz717bYWltff+xP
        QXykeHyS4PnnCySzRiKm4HwkNZKZdNJEFkT1YWR9pvVYVIxh4/K8d46z66YZh54X63PbYe
        sIXwbqPgcEeH3HZaE0dzvHbPAz9Hlc4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-656-USbrLh6jNRek09tuN5Eupw-1; Thu, 22 Sep 2022 05:16:10 -0400
X-MC-Unique: USbrLh6jNRek09tuN5Eupw-1
Received: by mail-ed1-f69.google.com with SMTP id c6-20020a05640227c600b004521382116dso6335587ede.22
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=PhZLFn1R5tarTTTxU9XzOLKoFe4nPWuQCWD3fmeWO70=;
        b=tF3bfFGZ3M+Tm8m4y30Ydw+/hcb5C3uVb3RunD+C8VSabCZCXxZWz/L/DpY6n4/VAa
         VeI0b9z/7RFXqqLjePqjZc0pLxK3W8tCvnrYfeg5F6R1isZvZuzp3bwYIjsn234hmtCM
         2AKMRt/xe8sc1s5cWA8d4hG+Hf2kOADYfq/zXL2gf867M6ZPocwzZKjmF7s1rAZhW3t0
         NaMjzQ1/wVI5Jkgm35RDp1rPwRbZLVuPW7Hm48WQTUjtlhjvE6q9zQIYvnnys+EApq0a
         wFcqBFQehZVwYIQlS+JILS8WixoSA2hgY8H+5krj3pnzHnOFeFopporQh2xQeDvwyeTx
         roNg==
X-Gm-Message-State: ACrzQf3bexWefJ7WijC7jJRnlavVCxINUdHFD2s4aWcCS3/Q+PUXQlk4
        kASxu+s3D+yryK3Utr2RLVr8RJKDfO2O2OrfqQA7wDNKUcKRsgte8tWBSB+Kk843LQjfhW+RnbD
        IoQYplu7arzYY4J1V
X-Received: by 2002:a05:6402:2547:b0:450:668c:9d93 with SMTP id l7-20020a056402254700b00450668c9d93mr2326110edb.92.1663838169832;
        Thu, 22 Sep 2022 02:16:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5vmhrBTquuS4qjnEl33Y44GZJ0NDrRa7TS8jjlctqoihmeU+ZSkFouVEz2/vb+MFGYkN4DUw==
X-Received: by 2002:a05:6402:2547:b0:450:668c:9d93 with SMTP id l7-20020a056402254700b00450668c9d93mr2326091edb.92.1663838169658;
        Thu, 22 Sep 2022 02:16:09 -0700 (PDT)
Received: from redhat.com ([2.55.16.18])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906300b00b0073d6093ac93sm2417360ejz.16.2022.09.22.02.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:16:09 -0700 (PDT)
Date:   Thu, 22 Sep 2022 05:16:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Junbo <junbo4242@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] Do not name control queue for virtio-net
Message-ID: <20220922051317-mutt-send-email-mst@kernel.org>
References: <20220917092857.3752357-1-junbo4242@gmail.com>
 <20220918025033-mutt-send-email-mst@kernel.org>
 <CACvn-oGUj0mDxBO2yV1mwvz4PzhN3rDnVpUh12NA5jLKTqRT3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACvn-oGUj0mDxBO2yV1mwvz4PzhN3rDnVpUh12NA5jLKTqRT3A@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 05:00:20PM +0800, Junbo wrote:
> hi Michael
> 
> in virtio-net.c
>     /* Parameters for control virtqueue, if any */
>     if (vi->has_cvq) {
>         callbacks[total_vqs - 1] = NULL;
>         names[total_vqs - 1] = "control";
>     }
> 
> I think the Author who write the code maybe want to name the control queue to
> 'virtioX-control',

That would be me I suspect ;)

> but it never worked, we can see the name still be
> 'virtioX-config' in /proc/interrupts,

Nope, what you see in /proc/interrupts are the interrupts, not the queue
name.

> for example 
>  43:          0          0          0          0          0          0        
>  0          0   PCI-MSI-edge      virtio0-config
>  44:         64          0          0          0          0          0      
> 1845          0   PCI-MSI-edge      virtio0-input.0
>  45:          1          0          0          0          0          0        
>  0          0   PCI-MSI-edge      virtio0-output.0
> 
> Because in function vp_request_msix_vectors, it just allocate 'xxxx-config' to
> every virtio devices, even the virtio device do not need it.

Oh yes, we can fix that. The result will be this line disappearing for
devices without a config interrupt. Not for net though, that
generally uses a config interrupt for things like link
state detection.


> in /proc/
> interrupts, we can see that each virtio device's first interrupt always named
> 'virtioX-config'.
> 
> So I think it's better to not explicitly give the "control" here, it's
> useless...  


it's used for debugging.


