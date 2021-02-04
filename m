Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FAA30F5CE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhBDPGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbhBDPFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:05:39 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A61C061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 07:04:59 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u14so3916991wri.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 07:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iHo3fk2qm0EEP2///XWtRGeKPst7YAsG4Ss5b7btM7c=;
        b=i/qZJmESoh1cZX6R88Q211oeRkPn5T5brY/TxbLLGfPEf/BdbsGQQBbKQPwdQcCt06
         g00EOpo2GeRKcfqQovmk82B/knAKq2fattKvG+XS4CqwBLVfYYbtAqL7TWc30J65Btut
         hPs1swKah+Dqc3ZKTL5hiviP6ngErpGj2ZxJvpZOIJUAA/RPCeoULk9fOMIPIXbHyrP9
         6M0/6Q4orAX5kQU+9wDWEgY8L1/L/48BYZ9z/LJozYDdBckngyBC2dkTANKflEiYOR/e
         lipLTgY3nm8UTiUMPOBVaNqQXA/7roNOLboaSq2mDOvi6r89qNZLIwEWDAVa7cixV3gt
         nl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iHo3fk2qm0EEP2///XWtRGeKPst7YAsG4Ss5b7btM7c=;
        b=oHrzPmQP3tsnQeGzpCKZ545PeRe2cGmmDANzV2TmXoAxgSKTrTHEN0XPjSaTOFl/9I
         3r6GmiI2x067KDmoa+OfndquQ66GQ7MKxjN9cOWHdg+drkTGBZDvebDcE/DYlomtIzKo
         2V/uXJfhZT+BqjG5id1o1F2g2TkxWctXJ0gj9PMMSN+bFvYNmXUkV6hxNYkIclB9JCl5
         aOz/FKJwugXX518HHvsG1lx+Icwf8HzRvU31qOohZmWZf2oXU+pV1H37CrYgG2fmhYa2
         VcsOhab3sVlqdRW139kapg/YU3/1Xe3EV5rvK5Nk+ohIN8n4ua0K4cpuqvjTg8Q/bTqc
         6/zQ==
X-Gm-Message-State: AOAM531xqtjSIOZkcDkC7NGeZ9fKL4JeipdEjcqoeOSusOqgy8QXZbP7
        9+nCwu3V9D/J9QBgX4LJmkA=
X-Google-Smtp-Source: ABdhPJzxh0UQq36HUVyEBKDfzx0DTM8/o+PLGz1zFBHkRDuWLxh4MkAAJLPombpKw6RZur7vjwQUFA==
X-Received: by 2002:adf:f6c4:: with SMTP id y4mr9697373wrp.127.1612451098114;
        Thu, 04 Feb 2021 07:04:58 -0800 (PST)
Received: from [192.168.1.101] ([37.171.155.194])
        by smtp.gmail.com with ESMTPSA id l10sm8499740wro.4.2021.02.04.07.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 07:04:57 -0800 (PST)
Subject: Re: [PATCH net v2] udp: fix skb_copy_and_csum_datagram with odd
 segment sizes
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, oliver.graute@gmail.com,
        sagi@grimberg.me, viro@zeniv.linux.org.uk, hch@lst.de,
        alexander.duyck@gmail.com, eric.dumazet@gmail.com,
        Willem de Bruijn <willemb@google.com>
References: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <02869fd8-7fbd-25db-c18c-cf9ab6db43f2@gmail.com>
Date:   Thu, 4 Feb 2021 16:04:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/21 8:29 PM, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> When iteratively computing a checksum with csum_block_add, track the
> offset "pos" to correctly rotate in csum_block_add when offset is odd.
> 
> The open coded implementation of skb_copy_and_csum_datagram did this.
> With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
> pos was reinitialized to 0 on each call.
> 
> Bring back the pos by passing it along with the csum to the callback.
> 
> Changes v1->v2
>   - pass csum value, instead of csump pointer (Alexander Duyck)
> 
> Link: https://lore.kernel.org/netdev/20210128152353.GB27281@optiplex/
> Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
> Reported-by: Oliver Graute <oliver.graute@gmail.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

