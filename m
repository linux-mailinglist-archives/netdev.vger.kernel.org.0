Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0332686FE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgINIPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgINIOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:14:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9A6C06174A;
        Mon, 14 Sep 2020 01:14:43 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k15so11946674pfc.12;
        Mon, 14 Sep 2020 01:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:cc:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=bfli47mnxZDlXaGAUiz/B4BePF6dibgax6S36KEh7f4=;
        b=kdeY9ESVzVF3+Q6NsEEiLky675RJZcJrgdbApwJCmCHBtL7313VB4m9S5+i0VzTw88
         bZ0kMDArw06QERzUQsSi0r1vl1cU+woa+Q9BRtv8/SZx5BEJB8BGWRABc5K1dM30Hs4W
         zC9iiuZAaBQsnSzyl7MfPCZjqo1evsYA3NaDIqgKnVFyN3PzuC3ADX+FlwnJQyYeVCkU
         tTIF+aoR0ZYofD/SybDOFNK8T2C2rjQAJpkTRbni7lHynXleLjYXo5uK7tsvBLE4ZYAK
         7D4735Eu/et6kLghLJLCBKHECP9Y2/jC1CR4XlN8m9oIyS1nLv7cVr1iS5YFaCg+t8Tp
         ZsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bfli47mnxZDlXaGAUiz/B4BePF6dibgax6S36KEh7f4=;
        b=G0JM4D09e2XCvzYo4neFlng0K80aiDTwCVJsc9XmUG/4/r2hW9HBizK3M2fEENbC4V
         WpI5c44l2MPEfi6M4L/fqbK5velotWwuxQdBecuHQrfcHLlR9k29RvHPN78Bz7pKFkqH
         w12kNvghHdoLCPd+GGIRFLYnKyNRXVIDplsj7OJka4FGdGc9V+FbtOscAl5l8E/zfKFI
         37EADICQMzw0dZ1YtS/z5em/Qw714AUsV4vXoU80H4HaxRvIexL7mJc+p3f0rWH8T4SW
         EUkYiIX0AIlyhLj6uwzQm2c89zlfecoBKEhbQj7BW/qc7DIUmogs1EaxEoyqZhi1PG3x
         ySfw==
X-Gm-Message-State: AOAM531vL3AQY9fTKD7X/4uMDdGzkPoTLNYVFOKUFPT4e2ANicGfLdtu
        6ykOzZKiNpJyPsnoLQkncaGH9RT2q4lrrp2Msio=
X-Google-Smtp-Source: ABdhPJzHNbDE2odrsmXsPmIzt3RbJsasIL/ZT1Zm5k9b+IkFKJBzCceoAXBYaAN1lNntaO0Y4OaFcg==
X-Received: by 2002:a17:902:ec03:: with SMTP id l3mr13677394pld.56.1600071282105;
        Mon, 14 Sep 2020 01:14:42 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.209.61])
        by smtp.gmail.com with ESMTPSA id m25sm9286567pfa.32.2020.09.14.01.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 01:14:41 -0700 (PDT)
Subject: Re: [PATCH v2] net: fix uninit value error in __sys_sendmmsg
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200913110313.4239-1-anant.thazhemadam@gmail.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <6adeef07-7dcb-3d05-df26-204a9d43301c@gmail.com>
Date:   Mon, 14 Sep 2020 13:44:37 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200913110313.4239-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/09/20 4:33 pm, Anant Thazhemadam wrote:
> The crash report indicated that there was a local variable;
> ----iovstack.i@__sys_sendmmsg created at:
>  ___sys_sendmsg net/socket.c:2388 [inline]
>  __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
>
>  that was left uninitialized.
>
> Initializing this stack to 0s prevents this bug from happening.
> Since the memory pointed to by *iov is freed at the end of the function
> call, memory leaks are not likely to be an issue.
>
> syzbot seems to have triggered this error by passing an array of 0's as
> a parameter while making the system call.
>
> Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> Tested-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> ---
> Changes from v1:
> 	* Fixed the build warning that v1 had introduced
>  net/socket.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/socket.c b/net/socket.c
> index 0c0144604f81..1e6f9b54982c 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2398,6 +2398,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
>  	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
>  	ssize_t err;
>  
> +	memset(iov, 0, UIO_FASTIOV);
>  	msg_sys->msg_name = &address;
>  
>  	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
It has since been determined that this patch is incorrect, and even if it were correct,
provides a huge performance overhead, that is not welcome. Kindly ignore this patch.
Sorry.

Thanks,
Anant
