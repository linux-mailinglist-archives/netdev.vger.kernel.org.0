Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FC91BE26
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfEMTnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 15:43:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33181 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfEMTnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 15:43:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id h17so7309170pgv.0
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 12:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oQwn/J1Twm6bT/t2K0TcYDv5Z/LC49To9OHP7unRVAg=;
        b=DGSqO0LNcekXyIwJSaRJlpmgHZ9X/gP5TbZv+6kFOeSTo1iS/1EeWCJoeZKkyj1QV3
         L75hMWvu4tbOhH/Xqpn3sQVTARIwrqwYSE0tpqvekCws/peDCEZZ+Ty5Q3Wm2Hx69Awt
         pil5L7c6PrnWbSn0i2w+QjpNhBymWGFQDLzyBwMQQT7SyQq3a/VdkKFR7c+WJlHS/lKO
         xHp30v+sYT7LpBzDW1z2jv7MrVocAPGgNXQGEEiQSb9rkt8tZcHeS97t6zwqmyCo/NiQ
         FI6H39pyCDbZRjYXcDhzKwiu9ssFVKbYbdqL3sktXa1rR/VU5+HIt8pHCVLvKZf6xCY4
         64uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQwn/J1Twm6bT/t2K0TcYDv5Z/LC49To9OHP7unRVAg=;
        b=bw0yiMvRByDxYSALhnLjHnrcPLdcD1D19M1QBK0IwW58ITCPjYTJIodXFXk2sX2TCG
         4QIAt5E47Wk5pWFyG/T7vHkV6ot73zcqsCUFde21E6VXcPCXrmrL/17JyzpukvzQHyKa
         hxseOlZM/enEnRJubvg4DkwE+fZQek6XLvdunQ6y1Tam44FHm5MEc5qHrgushMHVU0vV
         buN4QpGzif1tc9t12XIxEspkZmhEJF9E8/sMkKnrOa/jrX49lb2hVeCXnRE3GazLh24D
         OmZmsjfoma4i/fpqBpsOyeDeSGg14YWVb26oL72i54PuUOnW2RJlmnMZDyJ8zFoAynlS
         xllQ==
X-Gm-Message-State: APjAAAXUQP8RW3h2WkhPSmq69fTe0GfUGCE+/G5XMG9u0mytHrM/yq9y
        75QQZShDtnOx2Hsn2LWUK+wF6Ibf
X-Google-Smtp-Source: APXvYqzGubbIMnqZ52Baug9IRl/pq/HhU4lT2ThvLvU+vAdn9Uw9KS/2U95S7Om7g0rHXl0Kr8sQnw==
X-Received: by 2002:aa7:8493:: with SMTP id u19mr35298009pfn.233.1557776622382;
        Mon, 13 May 2019 12:43:42 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c189sm37433963pfg.46.2019.05.13.12.43.41
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 12:43:41 -0700 (PDT)
Subject: Re: [PATCH v2 net] tcp: fix retrans timestamp on passive Fast Open
To:     Yuchung Cheng <ycheng@google.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ncardwell@google.com
References: <20190513173205.212181-1-ycheng@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2670dea8-e00f-0fc7-14c2-44c8ccf5875e@gmail.com>
Date:   Mon, 13 May 2019 12:43:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513173205.212181-1-ycheng@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/19 10:32 AM, Yuchung Cheng wrote:
> Commit c7d13c8faa74 ("tcp: properly track retry time on
> passive Fast Open") sets the start of SYNACK retransmission
> time on passive Fast Open in "retrans_stamp". However the
> timestamp is not reset upon the handshake has completed. As a
> result, future data packet retransmission may not update it in
> tcp_retransmit_skb(). This may lead to socket aborting earlier
> unexpectedly by retransmits_timed_out() since retrans_stamp remains
> the SYNACK rtx time.
> 
> This bug only manifests on passive TFO sender that a) suffered
> SYNACK timeout and then b) stalls on very first loss recovery. Any
> successful loss recovery would reset the timestamp to avoid this
> issue.
> 
> Fixes: c7d13c8faa74 ("tcp: properly track retry time on passive Fast Open")
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> ---

Signed-off-by: Eric Dumazet <edumazet@google.com>

