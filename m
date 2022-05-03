Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AB518083
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiECJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 05:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiECJGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 05:06:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8F6A1ADA0
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 02:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651568572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ec3tSd2GCBs2wECoraMYnA9Uhes3Kc3NectIdj42y8I=;
        b=NdHJTwJsXqPOODBcV1+EA6JKq8d2ueMs7pUf/76yavRvJfxgSrrnxQksGiD2sxl+tBldCv
        M9VCcmzdHPXKpUHrUc9j2awzpgjbCD9NkPRymWRxlU9RNIF1ObuWs91jPUBToNYphteqLy
        grbRM3Gd6+NI3UnTSvH3RfTEJuUsX9g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-0UADQJtoOS-OBEkajSQknw-1; Tue, 03 May 2022 05:02:50 -0400
X-MC-Unique: 0UADQJtoOS-OBEkajSQknw-1
Received: by mail-wm1-f71.google.com with SMTP id o24-20020a05600c379800b003943412e81dso508084wmr.6
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 02:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ec3tSd2GCBs2wECoraMYnA9Uhes3Kc3NectIdj42y8I=;
        b=Vt6esM71sJYkjlrWkoDNjwb9ynu/+gjO3zqt7aH4tvcwuK/DAt/5HInS8bSk2bayC3
         VgKcwMzWLOYRek9Epiz1QZZLAq7L8F3mj6pRF8UHndIT1pSlPsaz0+qd1FVYvLFil7j8
         jCOAwWtNIoajLSX6nA7TYCCMokmqVXIdT8Renv5Q6ZOy97sOqnkdyPcM0j4bralK4r8l
         PqXqP8TyrJixRCjKGes0XfzmLjpzbIJ2t+raLiNdcYpHMw4Rp7HnLV3UpN7VAXTFd4mJ
         eReBwQVBqeEQfokNz/SdkZcdWmj7q0N6Xu99XxQ88dETLe3BoJqz5aJ+DxmyPQ5faET7
         AUSA==
X-Gm-Message-State: AOAM531Ez0ypnMlZv81k46jcmmVSfmSGTGa3acvOGkZcMcAI/jzogpkk
        +YVKpeWs3y8AIUOLtsOvf8a37T4FMGSRPM8befppSW2oBtJXTcnuZezivUW2u/PvvvIuIKZpT7R
        FspmjoT0MecCqqeU8
X-Received: by 2002:a5d:6a0f:0:b0:20a:ea3b:8d66 with SMTP id m15-20020a5d6a0f000000b0020aea3b8d66mr11448771wru.596.1651568568705;
        Tue, 03 May 2022 02:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIg7qVvJdEqTakcp9NypOEgZemRgMH98B9Q5cxEYsmpmW0M81b132O3YBSPBXvLAnVR09wBQ==
X-Received: by 2002:a5d:6a0f:0:b0:20a:ea3b:8d66 with SMTP id m15-20020a5d6a0f000000b0020aea3b8d66mr11448754wru.596.1651568568469;
        Tue, 03 May 2022 02:02:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id o14-20020adfca0e000000b0020c5253d912sm8872740wrh.94.2022.05.03.02.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 02:02:48 -0700 (PDT)
Message-ID: <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Dumazet <edumazet@google.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Date:   Tue, 03 May 2022 11:02:47 +0200
In-Reply-To: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
References: <00000000000045dc96059f4d7b02@google.com>
         <000000000000f75af905d3ba0716@google.com>
         <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
         <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
         <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
         <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
         <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
         <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-02 at 10:40 +0900, Tetsuo Handa wrote:
> syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> for TCP socket used by RDS is accessing sock_net() without acquiring a
> refcount on net namespace. Since TCP's retransmission can happen after
> a process which created net namespace terminated, we need to explicitly
> acquire a refcount.
> 
> Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> ---
> Changes in v2:
>   Add Fixes: tag.
>   Move to inside lock_sock() section.
> 
> I chose 26abe14379f8e2fa and 8a68173691f03661 which went to 4.2 for Fixes: tag,
> for refcount was implicitly taken when 70041088e3b97662 ("RDS: Add TCP transport
> to RDS") was added to 2.6.32.
> 
>  net/rds/tcp.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index 5327d130c4b5..2f638f8b7b1e 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -495,6 +495,14 @@ void rds_tcp_tune(struct socket *sock)
>  
>  	tcp_sock_set_nodelay(sock->sk);
>  	lock_sock(sk);
> +	/* TCP timer functions might access net namespace even after
> +	 * a process which created this net namespace terminated.
> +	 */
> +	if (!sk->sk_net_refcnt) {
> +		sk->sk_net_refcnt = 1;
> +		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> +		sock_inuse_add(net, 1);
> +	}
>  	if (rtn->sndbuf_size > 0) {
>  		sk->sk_sndbuf = rtn->sndbuf_size;
>  		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;

This looks equivalent to the fix presented here:

https://lore.kernel.org/all/CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com/

but the latter looks a more generic solution. @Tetsuo could you please
test the above in your setup?

Thanks!

Paolo

