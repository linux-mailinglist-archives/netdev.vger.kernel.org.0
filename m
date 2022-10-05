Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEA05F52FE
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJEK54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJEK5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:57:54 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52C97694E;
        Wed,  5 Oct 2022 03:57:51 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a710:a294:cd8d:ff93:7c57] (p200300e9d724a710a294cd8dff937c57.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a710:a294:cd8d:ff93:7c57])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 361E5C034C;
        Wed,  5 Oct 2022 12:57:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1664967469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eseGOXM8tr05KQm4LZ9FALT+pFd06C7SD1X5nx4MrbI=;
        b=us68Y/B/1q10XoYBYd+uNqf+4Uo22ZWTpo6LagK3UjJTUq8FTsulECJFbT7UEHDnt9W0+m
        dHX1szVNlUKz9Aa2gnrci2adkGzDRDiP+6Pr1kG45MkHLDwMHLyIZJ0h2NY1rZPgDf+Jxp
        K9HQVifwk8y4qMTExpRry3euHpp4wer6P99bjLzh6ZyeHcv7c/2Tj0GfVkHkGylIDhycgX
        qSKeJzzj+aEkWNgD7tzIlFe86hb2UeA1u00YM8g7WX3sppBPsDGyCYfeJoKN9AczkRrB/J
        LkuPClNxtLT4SexPw8H/rT5tmlWuV5Ixp/8LMNCJd0EVVmwfOouDWbsPsN68pg==
Message-ID: <71a398bb-7dfc-dd3e-227c-0d465e3cd634@datenfreihafen.org>
Date:   Wed, 5 Oct 2022 12:57:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net 2/2] net/ieee802154: don't warn zero-sized
 raw_sendmsg()
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        penguin-kernel@i-love.sakura.ne.jp
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221005014750.3685555-1-aahringo@redhat.com>
 <20221005014750.3685555-2-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221005014750.3685555-2-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 05.10.22 03:47, Alexander Aring wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> syzbot is hitting skb_assert_len() warning at __dev_queue_xmit() [1],
> for PF_IEEE802154 socket's zero-sized raw_sendmsg() request is hitting
> __dev_queue_xmit() with skb->len == 0.
> 
> Since PF_IEEE802154 socket's zero-sized raw_sendmsg() request was
> able to return 0, don't call __dev_queue_xmit() if packet length is 0.
> 
>    ----------
>    #include <sys/socket.h>
>    #include <netinet/in.h>
> 
>    int main(int argc, char *argv[])
>    {
>      struct sockaddr_in addr = { .sin_family = AF_INET, .sin_addr.s_addr = htonl(INADDR_LOOPBACK) };
>      struct iovec iov = { };
>      struct msghdr hdr = { .msg_name = &addr, .msg_namelen = sizeof(addr), .msg_iov = &iov, .msg_iovlen = 1 };
>      sendmsg(socket(PF_IEEE802154, SOCK_RAW, 0), &hdr, 0);
>      return 0;
>    }
>    ----------
> 
> Note that this might be a sign that commit fd1894224407c484 ("bpf: Don't
> redirect packets with invalid pkt_len") should be reverted, for
> skb->len == 0 was acceptable for at least PF_IEEE802154 socket.
> 
> Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4 [1]
> Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
> Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>   net/ieee802154/socket.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index 7889e1ef7fad..6e55fae4c686 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -272,6 +272,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>   		err = -EMSGSIZE;
>   		goto out_dev;
>   	}
> +	if (!size) {
> +		err = 0;
> +		goto out_dev;
> +	}
>   
>   	hlen = LL_RESERVED_SPACE(dev);
>   	tlen = dev->needed_tailroom;

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
