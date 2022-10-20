Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67365605ACA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiJTJOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiJTJN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:13:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99421B2BBD;
        Thu, 20 Oct 2022 02:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=LwN0DT2B7IiP57dFXsdsBhXrSEOFYg8TY38x6Of7T3U=; b=V3c6A/Awcjx942D+fi+vu0LwJp
        SlUIg1X1ZC5IxcmJoJr5T+ulqQo4rM5t34mnSe9ujlnQH3gDqJQhNM+SIBA78Py5S1yiEEH2ktB9Q
        U2NxibupuzeYcjZv07Hc12AgLDkPlQZJtwVVn1WpLMFaD86kVU/fJurdk1iUBLhjb+Jw0X4higsBP
        ZH7bICjJibNvCjTH7l1e2zERsafLb9GpL+Uk76Ts7MHmmnAAgqvbsKnq6gn8csXEKfLP/q3FB+nuD
        Y2b5mbiVTnpp6Ez7da53U5Mufr66KAlRTDqWoDCjPeGaMIJ0vx07BLkZlnOgST8EUn2SebOOrSuNl
        K75DOoOaumZVTYku9AtS3rWlkRrpTnPyqfT35zsdu6uXFA393r57rCB2hlYVQK5KWGr04in/wqJIE
        J/Ttbmgv30IpqVMqRgU2U/6n9HmDetJTojHefef48LMDyPP+948lN/or3icANCPoZIDUVUw82aqKI
        EHuxJ6UiL72W8gJpyGpGbcGh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olRce-004zWu-Jw; Thu, 20 Oct 2022 09:13:52 +0000
Message-ID: <f60d98e7-c798-b4a9-f305-4adc16341eca@samba.org>
Date:   Thu, 20 Oct 2022 11:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org
References: <cover.1666229889.git.asml.silence@gmail.com>
 <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
Content-Language: en-US, de-DE
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.1 1/2] io_uring/net: fail zc send for unsupported
 protocols
In-Reply-To: <ee7c163db8cea65b208d327610a6a96f936c1c6f.1666229889.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> If a protocol doesn't support zerocopy it will silently fall back to
> copying. This type of behaviour has always been a source of troubles
> so it's better to fail such requests instead. For now explicitly
> whitelist supported protocols in io_uring, which should be turned later
> into a socket flag.
> 
> Cc: <stable@vger.kernel.org> # 6.0
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/net.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 8c7226b5bf41..28127f1de1f0 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -120,6 +120,13 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
>   	}
>   }
>   
> +static inline bool io_sock_support_zc(struct socket *sock)
> +{
> +	return likely(sock->sk && sk_fullsock(sock->sk) &&
> +		     (sock->sk->sk_protocol == IPPROTO_TCP ||
> +		      sock->sk->sk_protocol == IPPROTO_UDP));
> +}

Can we please make this more generic (at least for 6.1, which is likely be an lts release)

It means my out of tree smbdirect driver would not be able to provide SENDMSG_ZC.

Currently sk_setsockopt has this logic:

         case SO_ZEROCOPY:
                 if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
                         if (!(sk_is_tcp(sk) ||
                               (sk->sk_type == SOCK_DGRAM &&
                                sk->sk_protocol == IPPROTO_UDP)))
                                 ret = -EOPNOTSUPP;
                 } else if (sk->sk_family != PF_RDS) {
                         ret = -EOPNOTSUPP;
                 }
                 if (!ret) {
                         if (val < 0 || val > 1)
                                 ret = -EINVAL;
                         else
                                 sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
                 }
                 break;

Maybe the socket creation code could set
unsigned char skc_so_zerocopy_supported:1;
and/or
unsigned char skc_zerocopy_msg_ubuf_supported:1;

In order to avoid the manual complex tests.

What do you think?

metze

