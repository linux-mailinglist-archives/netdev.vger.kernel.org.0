Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC81C51EF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgEEJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 05:30:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED0C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 02:30:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so1828765wrm.13
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 02:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Bya+NTSIs6K7NSmY4ktKq4dWPLC0X3o+d74CxBau3qU=;
        b=thMnOyiVBWdp2xjMXqfsZbnh0jFuAZJinEN4NrNHiYASVJZvvO8k7wz0+vZyOW7fNk
         aOoTIvrUfw3hoaI70+iXYGJ2LzuEWZsgk4fJ94SMuUVy9V1FK513V6KpmSa9bVTtULcy
         PtMQZq9EHz93PuHgnO3TnWhVURj8EoOSQMSiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Bya+NTSIs6K7NSmY4ktKq4dWPLC0X3o+d74CxBau3qU=;
        b=OXX5TSwuLPgKM++vHCuYgcIGFpq+DvNtyD6Dl4V60+dHiRf61D9FFz4Q/bF8mvSiA1
         vGmGDtz0jDOVjtuGYiBevAeYE80RL2lBCFukxXV8K+/bKeZD70/e4W+nWFoPX5J2kNry
         /KogzY70LUI3j5kWmi8afyaix1WKnkUpeg6vp+uPbnCDjxhNAOCsPxNRvtAW7FlKgdMK
         NijmrzxO1hwuF9hkFd117LH+o4IfmYPFwqhFxgclfFAQp5+aXDu9P3nhfzqt1SEMuqVv
         zLK54ngVLgBQKSULgggh8W5HV5zjEgcdJYjChlEGgaxQ27+9tqHWQ/MTTVwtbU4daw1f
         cFlg==
X-Gm-Message-State: AGi0Pub9s/kuibUfhmdiIqfQa/nmmet6+2EPqhhLA/JGKf9U1/X8oLYa
        3ojEprdG3kBfJXF9CzGDrNi6RkzDta8=
X-Google-Smtp-Source: APiQypJHzrGi6UPSlT5gFHZbBbg9tNHDDWBz80cjzTa/xce3Ok+BffT47xJw+8iY2hmwoWcGdvkmEg==
X-Received: by 2002:adf:f684:: with SMTP id v4mr2599388wrp.218.1588671016351;
        Tue, 05 May 2020 02:30:16 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u7sm3090065wmg.41.2020.05.05.02.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 02:30:15 -0700 (PDT)
References: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        ast@kernel.org
Subject: Re: [PATCH 0/2] sockmap, fix for some error paths with helpers
In-reply-to: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
Date:   Tue, 05 May 2020 11:30:14 +0200
Message-ID: <87ftcevie1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 07:21 PM CEST, John Fastabend wrote:
> In these two cases sk_msg layout was getting confused with some helper
> sequences.
>
> I found these while cleaning up test_sockmap to do a better job covering
> the different scenarios. Those patches will go to bpf-next and include
> tests that cover these two cases.
>
> ---
>
> John Fastabend (2):
>       bpf: sockmap, msg_pop_data can incorrecty set an sge length
>       bpf: sockmap, bpf_tcp_ingress needs to subtract bytes from sg.size

Both of these LGTM. Looking forward to revamped test_sockmap.

For the series:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
