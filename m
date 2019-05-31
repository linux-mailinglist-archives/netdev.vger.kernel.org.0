Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1402A310C6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfEaPAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:00:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35573 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfEaPAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:00:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so4124978plo.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 08:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KrRf2BpQZ1ZUjaBjFFvg8Oelgac1774utIrp+24/JiQ=;
        b=IL550bpxJch31aQmnUuJ/0/VZaBAilFgl6i0v1Z/eBOBGSCdkz3YSpzaTjuci403Dk
         H/0OpyDlHX56zPAtqu2iOGSMQqxFDuNL7lWDUF7memKa8yYc31Wri/cYhcPpVBOT5SIg
         pE3AuIqNV8vjUUP9cvTuBVuvX5dydyqNmFpSFJRb7di7rO7TK2qi4mXFa8f02GXckPEJ
         roHr9mX3NPJPUjPpkVEZCWqesOAXjZJ0TM+wl3g9Y+6Zbf6hWx9fegk4LP5LYErhJCVT
         5UDwV7zjSK7sGG27PIrSsT94hU1KdcgY3mc2TSNqO9P6RqCMA18ceue14QRU0xOzR72l
         mLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KrRf2BpQZ1ZUjaBjFFvg8Oelgac1774utIrp+24/JiQ=;
        b=pZX9QEK3w4UARv8BDQOrvgh5/BQSdAnlvARgtoDhFwBDd8nAhx4k+QPmYhSf9Xf0C/
         3e9rAi266KPqQ/s2eFPg+qVzmXmYChtZFFFmF8u9XVIeTJH+WgMjp0BN/QUITseHOSUS
         Sd5WsaWcYDG7S9RGV8ey92cMIPBehDlmd/v0y5mwIuwXTRXHdLCJkyCIEEg7ihXcatqy
         Bv80lVfilbQ23lzGpDJUPARMSm3+fp57n0JqHNTOh55ZZPHfymOm8VUSlLpEivoZsdH4
         1bexUTKsOvzL4bt8kYgSHrdFeq8XDczMJFydgTuZvJdkAMTTFEwQ1Mp3GS7ARv0C512O
         0CIA==
X-Gm-Message-State: APjAAAU8Is8mgWXA+qRSF2rQ2/fPgS+HicnmUOk4qF8E1vn+F93H3zhC
        2rR074h0fvRiR1C2Q0iwfJY0aR/J
X-Google-Smtp-Source: APXvYqwq4YNubc7j/YJR1C5vC9VlOnL7esQrJhopwkzaV+8U0shiCc5nPVNiCHp3zjR1Qc2+sby/qQ==
X-Received: by 2002:a17:902:7003:: with SMTP id y3mr10191337plk.70.1559314833168;
        Fri, 31 May 2019 08:00:33 -0700 (PDT)
Received: from [192.168.84.42] ([107.241.92.149])
        by smtp.gmail.com with ESMTPSA id a30sm16257388pje.4.2019.05.31.08.00.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 08:00:31 -0700 (PDT)
Subject: Re: [PATCH] net/vxlan: fix potential null pointer deference
To:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        petrm@mellanox.com, roopa@cumulusnetworks.com, idosch@mellanox.com,
        sbrivio@redhat.com, netdev@vger.kernel.org
References: <1559291681-6002-1-git-send-email-92siuyang@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6f1010eb-16df-9cbe-3efe-5da6fa7aab56@gmail.com>
Date:   Fri, 31 May 2019 08:00:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559291681-6002-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/19 1:34 AM, Young Xiao wrote:
> There is a possible null pointer deference bug in vxlan_fdb_info(),
> which is similar to the bug which was fixed in commit 6adc5fd6a142
> ("net/neighbour: fix crash at dumping device-agnostic proxy entries").
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  drivers/net/vxlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 5994d54..1ba5977 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -274,7 +274,7 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
>  	} else
>  		ndm->ndm_family	= AF_BRIDGE;
>  	ndm->ndm_state = fdb->state;
> -	ndm->ndm_ifindex = vxlan->dev->ifindex;
> +	ndm->ndm_ifindex = vxlan->dev ? vxlan->dev->ifindex : 0;
>  	ndm->ndm_flags = fdb->flags;
>  	if (rdst->offloaded)
>  		ndm->ndm_flags |= NTF_OFFLOADED;
> 

Please provide a stack trace, and/or a Fixes: tag, and a detailed
analysis.

