Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CBF620BDB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiKHJO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiKHJO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:14:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC586306
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667898808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTNCEXtcsg+P00wIMYCq/ue1rkkRcAz7wFl9PpPqkjE=;
        b=IdPZP2+2i8ZF1+YZxLgYBN8PKSAycI49tiETB/lV16NOr2HC2B6qZBqVrBzifro6yIp7yI
        xWk8vw+hznnnHyr6kwVuljHgchxOOfgeJGcPsy89nN4fHiX3qU6vbqULURVFcXO0de1bEN
        4SPgHW/npgJBCFDDb8v/AgAxOPlXRfY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-538-tNiudIvnOdmtY2g34Tyk7Q-1; Tue, 08 Nov 2022 04:13:26 -0500
X-MC-Unique: tNiudIvnOdmtY2g34Tyk7Q-1
Received: by mail-wr1-f70.google.com with SMTP id r4-20020adfbb04000000b00236639438e9so3813347wrg.11
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 01:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NTNCEXtcsg+P00wIMYCq/ue1rkkRcAz7wFl9PpPqkjE=;
        b=e16aKFriJYkKIRz+Q5XzD9fa+gNjpGs6DRp0w/A/7Dktnpos7vbKlR0nxj2lBBaXZA
         8U6MrUW/MM1FQ20knz7vgFSG/7o2oWlS4HLVJh14oIhQcWEvfM6jsP8ygwoXv0XKEYDr
         ON1nwdoTuscyW+wZevpQEgKNLDLMOu0GPODVylRWciKHJZ9eIqeB0E2/ihgxbyM4e175
         y+iIDqSQ5P4ORGKg6SL6HF1KHUysGB36owZkxkAxM8KfBdan8n5siDSSfkKjLO/MU89y
         Q6WDsTn1DRMixeP07Iw4hVqxz/d/Umb7noMqZ9alZn0Dxb7g/MVX8XwvMV0UT5gOCUEC
         6TGA==
X-Gm-Message-State: ACrzQf1ddkG15kW/POb69rKWd5CsoVUEXPNDQIM0DOME7dHNNJRe4wDM
        anfgjN0n5vW8qXYYaaryjaq/6+cIW6PCfh3nNaJKhayQ86N/vgbJsUBq0I7nkaXdzWIDAoERYx2
        Wp/w2Fm8ORo8kam0i
X-Received: by 2002:a5d:6c6b:0:b0:225:dde:ab40 with SMTP id r11-20020a5d6c6b000000b002250ddeab40mr34957282wrz.690.1667898805836;
        Tue, 08 Nov 2022 01:13:25 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6ry3LNRzYseLvm5Ja9Is/tjNm5mmlFCkAbF3gJy02cL7tR6Ri1idrNRT448SgjUtv+zcpSTQ==
X-Received: by 2002:a5d:6c6b:0:b0:225:dde:ab40 with SMTP id r11-20020a5d6c6b000000b002250ddeab40mr34957263wrz.690.1667898805546;
        Tue, 08 Nov 2022 01:13:25 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-185.dyn.eolo.it. [146.241.112.185])
        by smtp.gmail.com with ESMTPSA id q12-20020a05600c46cc00b003b4ac05a8a4sm17696489wmo.27.2022.11.08.01.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:13:25 -0800 (PST)
Message-ID: <9ffe152671d4620eb1bfd443699c3143db377ca3.camel@redhat.com>
Subject: Re: [Patch net v2] kcm: close race conditions on sk_receive_queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, Cong Wang <cong.wang@bytedance.com>,
        syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com,
        shaozhengchao <shaozhengchao@huawei.com>,
        Tom Herbert <tom@herbertland.com>
Date:   Tue, 08 Nov 2022 10:13:23 +0100
In-Reply-To: <20221103184620.359451-1-xiyou.wangcong@gmail.com>
References: <20221103184620.359451-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
On Thu, 2022-11-03 at 11:46 -0700, Cong Wang wrote:
> @@ -1085,53 +1085,17 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  	return err;
>  }
>  
> -static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
> -				     long timeo, int *err)
> -{
> -	struct sk_buff *skb;
> -
> -	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
> -		if (sk->sk_err) {
> -			*err = sock_error(sk);
> -			return NULL;
> -		}
> -
> -		if (sock_flag(sk, SOCK_DONE))
> -			return NULL;

It looks like skb_recv_datagram() ignores the SOCK_DONE flag, so this
change could potentially miss some wait_data end coditions. On the flip
side I don't see any place where the SOCK_DONE flag is set for the kcm
socket, so this should be safe, but could you please document this in
the commit message?

[...]

> @@ -1187,11 +1147,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
>  
>  	/* Only support splice for SOCKSEQPACKET */
>  
> -	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> -
> -	lock_sock(sk);
> -
> -	skb = kcm_wait_data(sk, flags, timeo, &err);
> +	skb = skb_recv_datagram(sk, flags, &err);
>  	if (!skb)
>  		goto err_out;
>  
> @@ -1219,13 +1175,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
>  	 * finish reading the message.
>  	 */
>  
> -	release_sock(sk);
> -
> +	skb_free_datagram(sk, skb);
>  	return copied;
>  
>  err_out:
> -	release_sock(sk);
> -
> +	skb_free_datagram(sk, skb);

We can reach here with skb == NULL and skb_free_datagram() ->
__kfree_skb() -> skb_release_all() does not deal correctly with NULL
skb, you need to check for skb explicitly here (or rearrange the error
paths in a suitable way).

Thanks!

Paolo

