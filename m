Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF954F7BF4
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 11:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbiDGJom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 05:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbiDGJok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 05:44:40 -0400
Received: from mxout04.lancloud.ru (mxout04.lancloud.ru [45.84.86.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F38718D9AD;
        Thu,  7 Apr 2022 02:42:37 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru C1ADB20CD431
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 11/11] arch: xtensa: platforms: Fix deadlock in rs_close()
To:     Duoming Zhou <duoming@zju.edu.cn>, <linux-kernel@vger.kernel.org>
CC:     <chris@zankel.net>, <jcmvbkbc@gmail.com>,
        <mustafa.ismail@intel.com>, <shiraz.saleem@intel.com>,
        <jgg@ziepe.ca>, <wg@grandegger.com>, <mkl@pengutronix.de>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jes@trained-monkey.org>, <gregkh@linuxfoundation.org>,
        <jirislaby@kernel.org>, <alexander.deucher@amd.com>,
        <linux-xtensa@linux-xtensa.org>, <linux-rdma@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-hippi@sunsite.dk>, <linux-staging@lists.linux.dev>,
        <linux-serial@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <1195e776-328d-12fe-d1f8-22085dc77b44@omp.ru>
Date:   Thu, 7 Apr 2022 12:42:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 4/7/22 9:37 AM, Duoming Zhou wrote:

> There is a deadlock in rs_close(), which is shown
> below:
> 
>    (Thread 1)              |      (Thread 2)
>                            | rs_open()
> rs_close()                 |  mod_timer()
>  spin_lock_bh() //(1)      |  (wait a time)
>  ...                       | rs_poll()
>  del_timer_sync()          |  spin_lock() //(2)
>  (wait timer to stop)      |  ...
> 
> We hold timer_lock in position (1) of thread 1 and
> use del_timer_sync() to wait timer to stop, but timer handler
> also need timer_lock in position (2) of thread 2.
> As a result, rs_close() will block forever.
> 
> This patch extracts del_timer_sync() from the protection of
> spin_lock_bh(), which could let timer handler to obtain
> the needed lock.
> 
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  arch/xtensa/platforms/iss/console.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
> index 81d7c7e8f7e..d431b61ae3c 100644
> --- a/arch/xtensa/platforms/iss/console.c
> +++ b/arch/xtensa/platforms/iss/console.c
> @@ -51,8 +51,10 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
>  static void rs_close(struct tty_struct *tty, struct file * filp)
>  {
>  	spin_lock_bh(&timer_lock);
> -	if (tty->count == 1)
> +	if (tty->count == 1) {
> +		spin_unlock_bh(&timer_lock);
>  		del_timer_sync(&serial_timer);
> +	}
>  	spin_unlock_bh(&timer_lock);

   Double unlock iff tty->count == 1?

[...]

MBR, Sergey
