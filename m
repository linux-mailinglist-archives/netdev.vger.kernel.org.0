Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6D86CC792
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjC1QK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjC1QKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:10:23 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A27DBA;
        Tue, 28 Mar 2023 09:10:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z18so7502058pgj.13;
        Tue, 28 Mar 2023 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680019807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wJiKI9TnWzLmHi6C68IeZ+7MBHHTSu9CAEUNVVcXEnM=;
        b=EBBgDVp5A/GqLJnvspK0XT7CNEATCRF2/0a1orkWSA1avZBU+sI2HGou2ex7aSGaov
         cCOE9kHWEDYhyngnfLiraSjkg+wnbwoHXtf2VTKhHHHKrsPrFyvZUENcQ4wXL3kH0aGN
         aL8QMmeKLageaUZhllDGpC5T6pRVNcXPvlveXK/zFR27SvLJJAobGwre0HwTsh5tJ7Ew
         iY26ZBVBsLL1NxR/+8KCHcrnKKlVJDPKcCUevSAtcCEFThODlEDTbP2C4UgVh9Npi5M8
         IZrMFAlh758uhQESLRkBikQA23Zrr1CJvwIBcB3c4gegNTnXCdlk3rmUjkCjyUbCICvR
         rpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680019807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJiKI9TnWzLmHi6C68IeZ+7MBHHTSu9CAEUNVVcXEnM=;
        b=UiTIRfVrnrh4y5eSPBs49uiacNlRSip7Ky9Q5gt5SULTjubhUvXsS+ZzcqUqdZ5+AQ
         ACF9QUIjx8lsY1y5vjbTbG6VjJAAxHdUyW0itJYI/0wNI7gr+212td9+Zx6HtYrWXSWv
         1IhXmCZ5OaFbgsPY3PMFOksYrF0/rphog+nrxjPS3wOAu3lHHb4glRz8aL45vfL/EP39
         5JAJGpA8QCLsM27qrhMcCVhSRuRIaSYIWgD0Y1sCLUFI2WbD+oHAP2RiGfOxpY9ieaLG
         Eowo1lvsHELFWQy+4TdsjEOiKNPLxaOydeV5LmfAIzOIFFntDG8ISDY09bBqnmadahyx
         mujQ==
X-Gm-Message-State: AAQBX9cwBL34be5awiB5aAxnXLd7DbcgJI7PU1UGv8OM3jQjUwYLTDhB
        Pe+qPYimWNj8YQ/9fdPRiN0=
X-Google-Smtp-Source: AKy350ZZkx2gxZ83pBMCw3pl3b7TNfCvbj4qE/D6y+DPEJppd29r6iK+7Iuar6PfmANY6VmdGpDeZQ==
X-Received: by 2002:a62:18d5:0:b0:625:ff85:21ec with SMTP id 204-20020a6218d5000000b00625ff8521ecmr15186860pfy.26.1680019806894;
        Tue, 28 Mar 2023 09:10:06 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78dd8000000b0062d7d3d7346sm4703336pfr.20.2023.03.28.09.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 09:10:06 -0700 (PDT)
Date:   Sat, 18 Mar 2023 11:38:38 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net] virtio/vsock: fix leak due to missing skb owner
Message-ID: <ZBWivg3d7G/ETqqo@bullseye>
References: <20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com>
 <jinx5oduhddyyaxnreey2riem3s7ju5zuszddmoiie6dcnyiiy@fr4cg33vi7aq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jinx5oduhddyyaxnreey2riem3s7ju5zuszddmoiie6dcnyiiy@fr4cg33vi7aq>
X-Spam-Status: No, score=1.9 required=5.0 tests=DATE_IN_PAST_96_XX,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 09:58:00AM +0200, Stefano Garzarella wrote:
> On Mon, Mar 27, 2023 at 10:01:05PM +0000, Bobby Eshleman wrote:
> > This patch sets the owner for the skb when being sent from a socket and
> > so solves the leak caused when virtio_transport_purge_skbs() finds
> > skb->sk is always NULL and therefore never matches it with the current
> > socket. Setting the owner upon allocation fixes this.
> > 
> > Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
> > ---
> > net/vmw_vsock/virtio_transport_common.c | 3 +++
> > 1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 957cdc01c8e8..2a2f0c1a9fbd 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -94,6 +94,9 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> > 					 info->op,
> > 					 info->flags);
> > 
> > +	if (info->vsk)
> > +		skb_set_owner_w(skb, sk_vsock(info->vsk));
> > +
> 
> Should we do the same also in virtio_transport_recv_pkt()?
> 
> The skb in that cases is allocated in drivers/vhost/vsock.c and
> net/vmw_vsock/virtio_transport.c using directly
> virtio_vsock_alloc_skb(), because we don't know in advance which socket
> it belongs to.
> 
> Then in virtio_transport_recv_pkt() we look for the socket and queue it
> up. This should also solve the problem in vsock_loopback.c where we move
> skb from one socket to another.
> 

That's a great point, skb_set_owner_r() in recv_pkt() will do all of the
right accounting when called by vsock_loopback_work.

I'll add that in a v2.

Thanks,
Bobby
