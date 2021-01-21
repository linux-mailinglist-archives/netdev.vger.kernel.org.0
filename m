Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFA82FE66B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbhAUJdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:33:36 -0500
Received: from mx3.wp.pl ([212.77.101.10]:55865 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbhAUJdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 04:33:06 -0500
Received: (wp-smtpd smtp.wp.pl 6278 invoked from network); 21 Jan 2021 10:25:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1611221111; bh=7R3v0sQPLDsHOXYPZHQTRX7QTzvNopH9J/znAF9MjMo=;
          h=From:To:Cc:Subject;
          b=MdosJgRO81wLb07lh/wqwuHLHTrwPpsxwRRwsAThYsH6pHJluQwu9RVUZODnh++MQ
           Y9c7uRDK1veYi5/bszMpxv+pRiQjY+AFWNqyATasQSM/S9Vp+k+Gxug68UFe2q52ue
           to4c2PWO8hb0Q64ozf3CnP0nMqaJPxMxotO5XuOM=
Received: from ip4-46-39-164-203.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.203])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <mudongliangabcd@gmail.com>; 21 Jan 2021 10:25:11 +0100
Date:   Thu, 21 Jan 2021 10:25:10 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     =?utf-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: "KMSAN: uninit-value in rt2500usb_bbp_read" and "KMSAN:
 uninit-value in rt2500usb_probe_hw" should be duplicate crash reports
Message-ID: <20210121092510.GA648258@wp.pl>
References: <CAD-N9QX=vVdiSf5UkuoYovamfw5a0e5RQJA0dQMOKmCbs-Gyiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-N9QX=vVdiSf5UkuoYovamfw5a0e5RQJA0dQMOKmCbs-Gyiw@mail.gmail.com>
X-WP-MailID: 52baa5e9d7ec4c6f5ab4085cda7857d9
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [MdMR]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 04:47:37PM +0800, 慕冬亮 wrote:
> ## Patch
> 
> I propose to memset reg variable before invoking
> rt2x00usb_vendor_req_buff_lock/rt2x00usb_vendor_request_buff.
> 
> ------------------------------------------------------------------------------------------------------------------------
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> index fce05fc88aaf..f6c93a25b18c 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> @@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev
> *rt2x00dev,
>                                    const unsigned int offset)
>  {
>         __le16 reg;
> +       memset(&reg, 0, sizeof(reg));

Simpler would be just to initialize like this: __le16 reg = 0; 

Stanislaw
