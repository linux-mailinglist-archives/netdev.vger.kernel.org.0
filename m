Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5752291856
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgJRQYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:24:06 -0400
Received: from mout01.posteo.de ([185.67.36.65]:42762 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgJRQYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 12:24:05 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 0AF8C160062
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 18:24:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1603038243; bh=ggaLF+6KhMWaExkprMCoLn0nLUb3Tz/6xv0BVvR9diA=;
        h=Subject:From:To:Cc:Date:From;
        b=FD0ZqpywRq1wNsPtV+WANJjs8ZIsVxCYq5T5N6jzmWM0CEa3b2/SO5rU9ij75BMjz
         vv1dRmXYfV6sxiZtXXVYtx9s1XaBmWVEBUb62tjiNlVr8v4elmMk22unftwBQUpTj9
         DFVwv1JV1hfCvfSBDTtxsIRkAmLKNTMhZfZqX+DllTyFSkdbVQSKjtIyrxVmJu+I74
         FDQ/HJxvIu/nxitB2IrwdYzAnJMQUVg87KJlsTq9BgKjz5oxZRW9cI64lxWTYvglKr
         K9zW+/dvOY8xQVZA/0azclk/7R/OoHjp9sp7vfWOYRwNT6WXHx07JT0f1jXq13Ahjx
         DUXIwj6HgKRQQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4CDlZT39Mfz9rxH;
        Sun, 18 Oct 2020 18:24:01 +0200 (CEST)
Message-ID: <f095b9edf561b7f36d45f3bf1ab92f0417b8d8ae.camel@posteo.net>
Subject: Re: [PATCH] Bluetooth: A2MP: Do not set rsp.id to zero
From:   Stefan Gottwald <Gotti79@posteo.net>
To:     marcel@holtmann.org
Cc:     gregkh@linuxfoundation.org, gottwald@igel.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 18 Oct 2020 18:25:47 +0200
In-Reply-To: <1603008332-8402-1-git-send-email-gotti79@posteo.net>
References: <1603008332-8402-1-git-send-email-gotti79@posteo.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Sonntag, den 18.10.2020, 10:05 +0200 schrieb Stefan Gottwald:
> Due to security reasons the rsp struct is not zerod out in one case this will
> also zero out the former set rsp.id which seems to be wrong.
> 
> Signed-off-by: Stefan Gottwald <gotti79@posteo.net>
> ---
>  net/bluetooth/a2mp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
> index da7fd7c..7a1e0b7 100644
> --- a/net/bluetooth/a2mp.c
> +++ b/net/bluetooth/a2mp.c
> @@ -381,10 +381,11 @@ static int a2mp_getampassoc_req(struct amp_mgr *mgr, struct sk_buff *skb,
>  	hdev = hci_dev_get(req->id);
>  	if (!hdev || hdev->amp_type == AMP_TYPE_BREDR || tmp) {
>  		struct a2mp_amp_assoc_rsp rsp;
> -		rsp.id = req->id;
>  
>  		memset(&rsp, 0, sizeof(rsp));
>  
> +		rsp.id = req->id;
> +
>  		if (tmp) {
>  			rsp.status = A2MP_STATUS_COLLISION_OCCURED;
>  			amp_mgr_put(tmp);

As it seems I'm too slow there is already a fix from the author of the initial patch.

https://lore.kernel.org/linux-bluetooth/20201016180956.707681-2-luiz.dentz@gmail.com/

There is a additional patch in this series which might also be a important fix

https://lore.kernel.org/linux-bluetooth/20201016180956.707681-1-luiz.dentz@gmail.com/

Thanks to a LWN member pointing this out to me.

