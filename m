Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B344F76B8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiDGHEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiDGHEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:04:10 -0400
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4591EF9DB;
        Thu,  7 Apr 2022 00:02:09 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id c42so5290241edf.3;
        Thu, 07 Apr 2022 00:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=46G4DElr2lTCJKQvU2NBw5+Ku6Z9RIMMPeVF6jkEn4U=;
        b=O8v6DuJ263WlV1eGdk/1DSkiR8EoXqVEWtmXFaX/ODGTAScxC8MPLn6yFO9u2up9JG
         PzozbZSyxn7s5jGRHKIsSko1ySx8uIKmlqwonX37Jjn1zYaBjdJAen6OyS+BwolkUPvL
         kXzz0k6slYzccH59O/iHsGAUH8d8F97fK1EqeZRDO/ZeWJFijv4hGhhFzvf2QIdYa6wC
         Wl1UCOGIIKw3SGlgsy/BK2eScAa6okEZ2BRCfpGFxeaSQsAzhS3fNVFQxPKfJL+LukgS
         s2/ODsQnbPAH7PwErJMwh3KF1T1blebX0IBjlysPo/QCZGkhCfiVOfPKwSK78Fd1023L
         rzfQ==
X-Gm-Message-State: AOAM530SpzQT3aatvWZcWbiBh8KknO2B7rDWElAuuFAxQsA934PzeFtI
        DKZxJKy5LBn8gUmP1eqJD81KTGwrIUt5eg==
X-Google-Smtp-Source: ABdhPJyVCanP2uW7lJxkIPHF3GlJ1OHZfNBFV6sC53moBL0MR5YRphUv/uvWzQu3TDqz1ql0BUTMLw==
X-Received: by 2002:a05:6402:5243:b0:419:52a1:a743 with SMTP id t3-20020a056402524300b0041952a1a743mr12778753edd.269.1649314927858;
        Thu, 07 Apr 2022 00:02:07 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id q3-20020a50da83000000b0041cdd6e92b1sm3870276edj.27.2022.04.07.00.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 00:02:07 -0700 (PDT)
Message-ID: <656ffd1d-e7cf-d2c0-e0e6-c10215ba422b@kernel.org>
Date:   Thu, 7 Apr 2022 09:02:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 01/11] drivers: tty: serial: Fix deadlock in
 sa1100_set_termios()
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     chris@zankel.net, jcmvbkbc@gmail.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        linux-xtensa@linux-xtensa.org, linux-rdma@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-hippi@sunsite.dk, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <e82ff9358d4ef90a7e9f624534d6d54fc193467f.1649310812.git.duoming@zju.edu.cn>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <e82ff9358d4ef90a7e9f624534d6d54fc193467f.1649310812.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07. 04. 22, 8:33, Duoming Zhou wrote:
> There is a deadlock in sa1100_set_termios(), which is shown
> below:
> 
>     (Thread 1)              |      (Thread 2)
>                             | sa1100_enable_ms()
> sa1100_set_termios()       |  mod_timer()
>   spin_lock_irqsave() //(1) |  (wait a time)
>   ...                       | sa1100_timeout()
>   del_timer_sync()          |  spin_lock_irqsave() //(2)
>   (wait timer to stop)      |  ...
> 
> We hold sport->port.lock in position (1) of thread 1 and
> use del_timer_sync() to wait timer to stop, but timer handler
> also need sport->port.lock in position (2) of thread 2. As a result,
> sa1100_set_termios() will block forever.
> 
> This patch extracts del_timer_sync() from the protection of
> spin_lock_irqsave(), which could let timer handler to obtain
> the needed lock.
> 
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>   drivers/tty/serial/sa1100.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
> index 5fe6cccfc1a..3a5f12ced0b 100644
> --- a/drivers/tty/serial/sa1100.c
> +++ b/drivers/tty/serial/sa1100.c
> @@ -476,7 +476,9 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
>   				UTSR1_TO_SM(UTSR1_ROR);
>   	}
>   
> +	spin_unlock_irqrestore(&sport->port.lock, flags);

Unlocking the lock at this point doesn't look safe at all. Maybe moving 
the timer deletion before the lock? There is no current maintainer to 
ask. Most of the driver originates from rmk. Ccing him just in case.

FWIW the lock was moved by this commit around linux 2.5.55 (from 
full-history-linux [1])
commit f38aef3e62c26a33ea360a86fde9b27e183a3748
Author: Russell King <rmk@flint.arm.linux.org.uk>
Date:   Fri Jan 3 15:42:09 2003 +0000

     [SERIAL] Convert change_speed() to settermios()

[1] 
https://archive.org/download/git-history-of-linux/full-history-linux.git.tar

>   	del_timer_sync(&sport->timer);
> +	spin_lock_irqsave(&sport->port.lock, flags);
>   
>   	/*
>   	 * Update the per-port timeout.

thanks,
-- 
js
suse labs
