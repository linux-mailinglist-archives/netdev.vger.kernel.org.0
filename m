Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9C1257129
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 02:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgHaAQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 20:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgHaAQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 20:16:40 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC8CC061573;
        Sun, 30 Aug 2020 17:16:40 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 2so2209231pjx.5;
        Sun, 30 Aug 2020 17:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YswzdnBZWGzwYVGIgsXUFF83/n18VySn9Py56TP2MGk=;
        b=U1KuJ/B0Z8HlRp3eRb0UvumWBL2n76w1Dm4eDrAoV+nGeFWKUE7Bvry91ar4bLjNUn
         45B1Ra8VOsJUbmxEhiI/DHY3kkM6KMqhZCzt6RBtWMEY1AFuy6pGqZIxySN/wAqkn1G+
         Q7O54dB2i3G0WmZkIIutryH76m9MsNVQOkXY1GicOrNLFfME3NoDzag5/aK7ojDP5C/t
         Ys8FTPgQur2DQAF7bQZU2h9skBVVXsk7Uguh3k5iUI+q1s1zpVqUDUz2akKwik/H2b4a
         Z3Op13q9nNkJPXUOlUt+ajSB+BfCU2QmtbcqU+N2dXLYxW85kitJUDIYpvnI1k/5Nrvd
         mv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YswzdnBZWGzwYVGIgsXUFF83/n18VySn9Py56TP2MGk=;
        b=dN3ONBRUqFFrh+CHgY816TB93jdS8acGfTXFhsufgy2HnfPKbfQ1+bcMNegAaPNH57
         ZcBWu6ai0BSlY4guzejKn+KG4+Q5ItsEirgXgUuRpbe71G5yEa9rCq+34ItkwtWMFYk+
         GQhBZs3rVejR3vulhYNtSaTUYdQhsYt28Lw9MfPYs89kYmXVz0In98rO2ZumZkOYRuEX
         I38XpjhZoyS7yfG2BR4AH5m5G4jM7hXoo6PLziqH/QQfWqqPM0kw6PGQo7vg0qNOaDRo
         BmqnwdxnL6fJGHFetyXeJJSpwquOn0q3UK54iBJ576WJIR09eiG1xSJeYvHeu3nZce0a
         xV1A==
X-Gm-Message-State: AOAM5316Scqi8+nLHN3DoByY6xv7BKiPZMqHzpaR6tGgN88Ks1GzLuw8
        G9ZiLUGQTHNbMJqapD++4s0=
X-Google-Smtp-Source: ABdhPJximRMCfe93HkMmDJsVNvXYYIe+mShkJZsKCeC0QVfGH9mQ6syBERF+LAqeumsD3b/FqXwpDQ==
X-Received: by 2002:a17:902:aa41:: with SMTP id c1mr6690600plr.224.1598832998203;
        Sun, 30 Aug 2020 17:16:38 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id b6sm5099381pjz.33.2020.08.30.17.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2020 17:16:37 -0700 (PDT)
Subject: Re: [PATCH] veth: fix memory leak in veth_newlink()
To:     Rustam Kovhaev <rkovhaev@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
References: <20200830131336.275844-1-rkovhaev@gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <32e30526-bcc9-1f2f-1250-f36687561fbb@gmail.com>
Date:   Mon, 31 Aug 2020 09:16:32 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200830131336.275844-1-rkovhaev@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/08/30 22:13, Rustam Kovhaev wrote:
> when register_netdevice(dev) fails we should check whether struct
> veth_rq has been allocated via ndo_init callback and free it, because,
> depending on the code path, register_netdevice() might not call
> priv_destructor() callback

AFAICS, register_netdevice() always goto err_uninit and calls priv_destructor()
on failure after ndo_init() succeeded.
So I could not find such a code path.
Would you elaborate on it?

Thanks,
Toshiaki Makita
