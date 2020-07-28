Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D281231320
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgG1Tww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbgG1Twv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:52:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690A3C0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:52:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l63so12673578pge.12
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lw5Yo6LYMJj0wtDoaefLNGkgc5QTYl1SaK6AazO3v2w=;
        b=gq6HFa7X7QMj2DalmEMErYJdwibaHGKntgGODdJmOjnvl71XNlf89WdFly/p/8zUsD
         adf6UQmHbEE2XxscjVPyDBuPLHifM78QvAfOfX0iBq+iwH0lfV4yGvEBEVtksCgn6YyM
         K7ENcyD3xpKYwQsxBe6eWsKzfX5e3ZKuSjRas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lw5Yo6LYMJj0wtDoaefLNGkgc5QTYl1SaK6AazO3v2w=;
        b=gdeqOsBoU+cmEWw10hET03QVjQCSyLytYzaMd5BcJvJO2v2R2UiXcIHXNgbvXczJN5
         RBz3JszA2HnnSTbJVy0xeQHKz/EmaZizusaOdZ+l+4bsqhKVf56SP447chgzXgkULfXA
         ZJGx6X6dKqTSEj2fZ4tnW+ODZaMWFQpJa0hQmhI2Bk5HCsMt/hn9unoWFsCRcSzO1XHW
         OiimNJXW55uiKh7myJhuHqEUO5nRuAQwDC6hE33pKS5A4ysganKezrdDHjLyxNQ+GT8w
         f+adSghd/FDfQPDHRSqOdQBpCElm0mVnSpTICKuPCAIKktm7Hs/sHVDapV+GEYRPXnqM
         hTZg==
X-Gm-Message-State: AOAM532tgs1ygbFpyq3S8Si1gPWxg13bHajG9D/PQVAP2ThP9ZTtCRXX
        aoYVcK+EKkLIIaRaHsYWwrJBkK2ErwQ=
X-Google-Smtp-Source: ABdhPJxJqtls1b+2yIeqoQ4yw+g1Ffg2V2qfKF4iRJprNIEuQoawrqtPab00sIL7S6F97Eul4B6+kw==
X-Received: by 2002:aa7:93c3:: with SMTP id y3mr25907842pff.206.1595965970613;
        Tue, 28 Jul 2020 12:52:50 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:8edc:d4ff:fe53:350d])
        by smtp.gmail.com with ESMTPSA id e8sm8677827pfd.34.2020.07.28.12.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 12:52:49 -0700 (PDT)
Date:   Tue, 28 Jul 2020 12:52:46 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
Message-ID: <20200728195246.GA482576@google.com>
References: <20200726110524.151957-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726110524.151957-1-xie.he.0141@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Reviewing as requested; I'm not familiar with this driver either, or
really any WAN driver. It also seems that hard_header_len vs.
needed_headroom aren't very well documented, and even I can't guarantee
I understand them completely. So take my thoughts with a grain of salt.)

Hi,

On Sun, Jul 26, 2020 at 04:05:24AM -0700, Xie He wrote:
> In net/packet/af_packet.c, the function packet_snd first reserves a
> headroom of length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and assumes the user to provide the
> appropriate link layer header.
> 
> So according to the logic of af_packet.c, dev->hard_header_len should
> be the length of the header that would be created by
> dev->header_ops->create.

I believe I'm with you up to here, but:

> However, this driver doesn't provide dev->header_ops, so logically
> dev->hard_header_len should be 0.

I'm not clear on this part.

What's to say you shouldn't be implementing header_ops instead? Note
that with WiFi drivers, they're exposing themselves as ARPHRD_ETHER, and
only the Ethernet headers are part of the upper "protocol" headers. So
my patch deferred to the eth headers.

What is the intention with this X25 protocol? I guess the headers added
in lapbeth_data_transmit() are supposed to be "invisible", as with this
note in af_packet.c?

   - if device has no dev->hard_header routine, it adds and removes ll header
     inside itself. In this case ll header is invisible outside of device,
     but higher levels still should reserve dev->hard_header_len.

If that's the case, then yes, I believe this patch should be correct.

Brian

> So we should use dev->needed_headroom instead of dev->hard_header_len
> to request necessary headroom to be allocated.
> 
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
