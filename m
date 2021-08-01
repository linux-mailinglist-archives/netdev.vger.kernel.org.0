Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8533DCBAC
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 14:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhHAMgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 08:36:50 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:38836 "EHLO
        zzt.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231802AbhHAMgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 08:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qD0SaqUGLbpCXnxKQhYAIh55AI4eaqb7RBu5u1Fgycg=; b=IRidOk1XEwdiv7peuu2PYqd7f8
        6fNmZ9dbqzc+lyEwenVQya068KgR4Rw9jAjKYr7OjzPJ799gouZIIxkWJ8AVvOC8eQOtoMCrntQ8/
        FGsx/wilz0IbLxvQXmN9C6y15wMAoXHrsmhpF/HdG8lp0Z/qUXLdc4SGBTTKCRGLUaOg=;
Received: from [94.26.108.4] (helo=carbon)
        by zzt.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1mAAhg-0000OU-Df; Sun, 01 Aug 2021 15:36:29 +0300
Date:   Sun, 1 Aug 2021 15:36:27 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: pegasus: fix uninit-value in get_interrupt_interval
Message-ID: <YQaVS5UwG6RFsL4t@carbon>
References: <20210730214411.1973-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730214411.1973-1-paskripkin@gmail.com>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zzt.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-07-31 00:44:11, Pavel Skripkin wrote: > Syzbot reported
    uninit value pegasus_probe(). The problem was in missing > error handling.
    > > get_interrupt_interval() internally calls read_eprom_word() [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-07-31 00:44:11, Pavel Skripkin wrote:
> Syzbot reported uninit value pegasus_probe(). The problem was in missing
> error handling.
> 
> get_interrupt_interval() internally calls read_eprom_word() which can
> fail in some cases. For example: failed to receive usb control message.
> These cases should be handled to prevent uninit value bug, since
> read_eprom_word() will not initialize passed stack variable in case of
> internal failure.

Well, this is most definitelly a bug.

ACK!


		Petko


> Fail log:
> 
> BUG: KMSAN: uninit-value in get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
> BUG: KMSAN: uninit-value in pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
> CPU: 1 PID: 825 Comm: kworker/1:1 Not tainted 5.12.0-rc6-syzkaller #0
> ...
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>  get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
>  pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
> ....
> 
> Local variable ----data.i@pegasus_probe created at:
>  get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
>  pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
>  get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
>  pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
> 
> Reported-and-tested-by: syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/usb/pegasus.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..bc2dbf86496b 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -735,12 +735,16 @@ static inline void disable_net_traffic(pegasus_t *pegasus)
>  	set_registers(pegasus, EthCtrl0, sizeof(tmp), &tmp);
>  }
>  
> -static inline void get_interrupt_interval(pegasus_t *pegasus)
> +static inline int get_interrupt_interval(pegasus_t *pegasus)
>  {
>  	u16 data;
>  	u8 interval;
> +	int ret;
> +
> +	ret = read_eprom_word(pegasus, 4, &data);
> +	if (ret < 0)
> +		return ret;
>  
> -	read_eprom_word(pegasus, 4, &data);
>  	interval = data >> 8;
>  	if (pegasus->usb->speed != USB_SPEED_HIGH) {
>  		if (interval < 0x80) {
> @@ -755,6 +759,8 @@ static inline void get_interrupt_interval(pegasus_t *pegasus)
>  		}
>  	}
>  	pegasus->intr_interval = interval;
> +
> +	return 0;
>  }
>  
>  static void set_carrier(struct net_device *net)
> @@ -1149,7 +1155,9 @@ static int pegasus_probe(struct usb_interface *intf,
>  				| NETIF_MSG_PROBE | NETIF_MSG_LINK);
>  
>  	pegasus->features = usb_dev_id[dev_index].private;
> -	get_interrupt_interval(pegasus);
> +	res = get_interrupt_interval(pegasus);
> +	if (res)
> +		goto out2;
>  	if (reset_mac(pegasus)) {
>  		dev_err(&intf->dev, "can't reset MAC\n");
>  		res = -EIO;
> -- 
> 2.32.0
> 
> 
