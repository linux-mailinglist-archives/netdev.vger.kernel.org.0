Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7770E6A6151
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjB1VhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjB1VhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:37:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D073401A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677620192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fr6G339eh4CzZb9wRNzdMKECxjo2Rk+TLv6cPbI33P8=;
        b=SNIo3FCAGjAJvRoLuaxJ3/RkQJ3sBqXZ3+mUk7R74WAR/wjyWRPDsfCS5UjT/xZoq7OtlM
        h3nE0xTi1hdTzWOnjGPYZuGMNC0vSX6i32oG6x9Jryxjz/CTF4vSYJEDsPxyd5+gKNdyQl
        iJj4e/PHj9gdIa/4fLhrj5o8Y126wh4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-PoS4MlILN9yjEW5wADhHUg-1; Tue, 28 Feb 2023 16:36:30 -0500
X-MC-Unique: PoS4MlILN9yjEW5wADhHUg-1
Received: by mail-wm1-f72.google.com with SMTP id l16-20020a05600c1d1000b003e77552705cso4732719wms.7
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 13:36:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677620189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fr6G339eh4CzZb9wRNzdMKECxjo2Rk+TLv6cPbI33P8=;
        b=bFHPq9wcIVmi+ucmd8c9fHb4n5yuXuaQFdkXPpg86U9fuyi5YgUKyjfUqmdSvnyMdP
         jicvCvzj5wW1MVol739jD93oh2B9KCl8v28FG36JixV92XWs61HpTznaPTFBQ8jadIaX
         zy4wZYYUxZbPo08HECKc/NKsPK54yNRH5u336DGxb/keTZvLS/ZD9DPQYTGBLyEOZu0I
         m0wjmCO9JzBD/Nxnfp7Z5Ec+L57flVe0BsjuGxalVIWGl1Ig9ztH6fWd93DxOpuwPl6V
         3b+mrAUghbjnnzzz6LviOB6uTe8/2VLqZUdHZvYi0IDdM3zbW6VCIW+Y6VGVES6WM+nK
         GuJQ==
X-Gm-Message-State: AO0yUKX2FIQOsw/Vp+OT6Pes4dD3gRzXluo1uWX1h8cHfiB0Yi44OFdn
        /mVCLv6yYwxc8G662TShK5221/pY/80LO+P9M1XvGYciTHdCmfrao+EUiPrPA+9IRPa31ZS3eJx
        HTKVCph9R3GD5dKSz
X-Received: by 2002:a05:600c:310c:b0:3eb:395b:8b62 with SMTP id g12-20020a05600c310c00b003eb395b8b62mr3713250wmo.39.1677620189696;
        Tue, 28 Feb 2023 13:36:29 -0800 (PST)
X-Google-Smtp-Source: AK7set9Z8lGr1yxjI9Ypmg9yFzicADc+OvbqqKFlwiu50yEmyScxxP766NN0zApqhzmUJ0CYnPz/ow==
X-Received: by 2002:a05:600c:310c:b0:3eb:395b:8b62 with SMTP id g12-20020a05600c310c00b003eb395b8b62mr3713241wmo.39.1677620189364;
        Tue, 28 Feb 2023 13:36:29 -0800 (PST)
Received: from redhat.com ([2.52.141.194])
        by smtp.gmail.com with ESMTPSA id m25-20020a7bca59000000b003db0bb81b6asm13684976wml.1.2023.02.28.13.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 13:36:28 -0800 (PST)
Date:   Tue, 28 Feb 2023 16:36:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: support sockmap
Message-ID: <20230228163518-mutt-send-email-mst@kernel.org>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
 <20230227-vsock-sockmap-upstream-v3-1-7e7f4ce623ee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227-vsock-sockmap-upstream-v3-1-7e7f4ce623ee@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 07:04:34PM +0000, Bobby Eshleman wrote:
> @@ -1241,19 +1252,34 @@ static int vsock_dgram_connect(struct socket *sock,
>  
>  	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
>  	sock->state = SS_CONNECTED;
> +	sk->sk_state = TCP_ESTABLISHED;
>  
>  out:
>  	release_sock(sk);
>  	return err;
>  }


How is this related? Maybe add a comment to explain? Does
TCP_ESTABLISHED make sense for all types of sockets?

-- 
MST

