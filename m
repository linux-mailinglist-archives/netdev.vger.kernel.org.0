Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102B72C580A
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391318AbgKZPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389756AbgKZPXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:23:11 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D85C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 07:23:11 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id y4so2671618edy.5
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 07:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HPMdUQs0Nq36rRw+fqVZ+RZDMl8mtPAFez5LD7lxuf4=;
        b=HIG/O79+p4LYMhFFjqBix4fe1DS8G17BbYzlfJPoaVebDKbDmo9Sdb0F1Kg0DqvH2M
         bO4dyIe62ki3xiOwpSV1gkUDT3jFAIdGElMinATGFIyrpM0XAEzrs3HBNApoXeXl2xi6
         nr7WZrhNarbKj3YxzRMeKEMMIiE4HpfR7UgI6Ey0jvnALBqiBqCggddPrdMrTwJEfuIx
         /6SRBV7UXCM8Q3/XcXKV55f2abQrWBDAW7LSYFYgu4jQzIWHPF5MKbGoOpB4sUcOQl79
         jPLlszW81PJkDbW1my46CJ4Qfmpw/BaG38Pbx0kHubPGPgWURZXdghqSabJ/Zf1gtWYd
         aFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HPMdUQs0Nq36rRw+fqVZ+RZDMl8mtPAFez5LD7lxuf4=;
        b=dinPnMd9M0JYlQgcrL78bfSbqB1+cQ6PRHV1pnbURax+bqoNiYwvTvgRDV0rI4dFNg
         x1dm67hwOWdykQtYC6j7w9A7OdLuJpsX/RsttF+Tj2lbshb5ZJ6LfMZGhYe2z3do0Va4
         Xj+DHschy3qEUlgnwkyc770BC7JcI3me+rtrzZO/BJmoSCfJqCTdBlq79vAuv1nL5fvy
         11KcuVWJ1Ie7WjwScoJf61+q8H8PHx5kogoGgdyySIkIrwjTYVD5GkM1c1w2V01iRT6I
         5nuGq8/U2KWKwV+Hg3eAXjqq836tPLaXKIZx+VvyKGuQXd28rNmpTX9wr1ZsN18Ztqd/
         dwGQ==
X-Gm-Message-State: AOAM5330N8MhvDVjr7g11j3hwK2/MUqaaOhFZYWurtHVhqk5b8dW/SVF
        o6vfVTVR71P+wiABEyUHbApZ6Q==
X-Google-Smtp-Source: ABdhPJy88Jyklg5zAVI1zteGxad1PToX2xfUJdcJFkalvM0JID9qrCNrML8XEzRgmNm/i7jGXvYWew==
X-Received: by 2002:a50:f98b:: with SMTP id q11mr3053140edn.345.1606404189744;
        Thu, 26 Nov 2020 07:23:09 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:9caf:688a:742d:c63f])
        by smtp.gmail.com with ESMTPSA id r1sm3281024eje.51.2020.11.26.07.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 07:23:09 -0800 (PST)
Subject: Re: [PATCH net] mptcp: fix NULL ptr dereference on bad MPJ
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <03b2cfa3ac80d8fc18272edc6442a9ddf0b1e34e.1606400227.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <2c3eecf9-c3b9-861a-cb8c-2f103496abfc@tessares.net>
Date:   Thu, 26 Nov 2020 16:23:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <03b2cfa3ac80d8fc18272edc6442a9ddf0b1e34e.1606400227.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 26/11/2020 15:17, Paolo Abeni wrote:
> If an msk listener receives an MPJ carrying an invalid token, it
> will zero the request socket msk entry. That should later
> cause fallback and subflow reset - as per RFC - at
> subflow_syn_recv_sock() time due to failing hmac validation.
> 
> Since commit 4cf8b7e48a09 ("subflow: introduce and use
> mptcp_can_accept_new_subflow()"), we unconditionally dereference
> - in mptcp_can_accept_new_subflow - the subflow request msk
> before performing hmac validation. In the above scenario we
> hit a NULL ptr dereference.
> 
> Address the issue doing the hmac validation earlier.
> 
> Fixes: 4cf8b7e48a09 ("subflow: introduce and use mptcp_can_accept_new_subflow()")
> Tested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Good catch! Thank you for the patch!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
