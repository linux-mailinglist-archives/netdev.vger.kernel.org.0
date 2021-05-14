Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3AF381365
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhENVum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:50:42 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:18126 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhENVul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 17:50:41 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4Fhhxz6ZsQz4w;
        Fri, 14 May 2021 23:49:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1621028968; bh=YnNDvWNHgZB7OO4mGzFahiZfXN1o66brYRvvwNub8g4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ppClVIpCQMzSv/c2CPp/YX6eXubafqDFI8taNy0w0inG+E3YllIJ0/ZvCsB5vQ37D
         nWxDDe8h5BJk7+LaYJhFCuN3hJffQnPnlgUR6KfVULnF/qbCFI+q6G9QkvtrWESuMl
         1TuoZOo3opLEOcCNEYaxuEqC/x566l5iw+8eVL+vT9pu9L5jXdHa7saBuvnE6T84Sa
         5jKOZSUvEG7hzRmuOhn/avqTHfvmBFEhLz0vpVArpyzLJqCHKuM1UF0ectP7Tqi3Ak
         UAYWxTcOSyrQ9SWunbi+w1IPrdnL/ZvPNG4PiOo8aUjNt5GbHXQgvFOHvRQCtjtO0C
         QYN0ZsBvUT7jQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.2 at mail
Date:   Fri, 14 May 2021 23:49:27 +0200
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [BUG] net: stmmac: Panic observed in stmmac_napi_poll_rx()
Message-ID: <20210514214927.GC1969@qmqm.qmqm.pl>
References: <b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 03:24:58PM +0100, Jon Hunter wrote:
> Hello!
> 
> I have been looking into some random crashes that appear to stem from
> the stmmac_napi_poll_rx() function. There are two different panics I
> have observed which are ...
[...]
> The bug being triggered in skbuff.h is the following ...
> 
>  void *skb_pull(struct sk_buff *skb, unsigned int len);
>  static inline void *__skb_pull(struct sk_buff *skb, unsigned int len)
>  {
>          skb->len -= len;
>          BUG_ON(skb->len < skb->data_len);
>          return skb->data += len;
>  }
> 
> Looking into the above panic triggered in skbuff.h, when this occurs
> I have noticed that the value of skb->data_len is unusually large ...
> 
>  __skb_pull: len 1500 (14), data_len 4294967274
[...]

The big value looks suspiciously similar to (unsigned)-EINVAL.

> I then added some traces to stmmac_napi_poll_rx() and
> stmmac_rx_buf2_len() to trace the values of various various variables
> and when the problem occurs I see ...
> 
>  stmmac_napi_poll_rx: stmmac_rx: count 0, len 1518, buf1 66, buf2 1452
>  stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1518
>  stmmac_napi_poll_rx: stmmac_rx: count 1, len 1518, buf1 66, buf2 1452
>  stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1536
>  stmmac_napi_poll_rx: stmmac_rx: count 2, len 1602, buf1 66, buf2 1536
>  stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 1602, plen 1518
>  stmmac_napi_poll_rx: stmmac_rx: count 2, len 1518, buf1 0, buf2 4294967212
>  stmmac_napi_poll_rx: stmmac_rx: dma_buf_sz 1536, buf1 0, buf2 4294967212

And this one to (unsigned)-EILSEQ.

> Note I added the above BUG_ON to trap unusually large buffers. Let
> me know if you have any thoughts.

Do above ring any bell?

Best Regards
Micha³ Miros³aw
