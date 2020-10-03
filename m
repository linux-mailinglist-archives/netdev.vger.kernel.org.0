Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBE7282117
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgJCERt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCERs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:17:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03B4C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 21:17:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gm14so2334354pjb.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 21:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+59yQTBC9bu80apfJ8cflhsz/X+yFuT+sCeqCtr8VLw=;
        b=iM9EKe7PIB+hkv4/Em9vOBCwnIybhHfc14iV8alvXyQZOmzY+vJMq7Kce4YX/gikFF
         9RQd6yFunpnWmhyFWCAFN5SraMtpaI1hJdJDI1oiQmN05BDJmT6qk2DJ306i7w2BAsho
         D0wTbg3ArrG9VRpADAeyPrDeKBqFBaSSytUj13a16KfxXwxn2NyoLuqY7c3hbiuRR57d
         4QSFCUOBRejFDu/08WAVAynu8RsUmJXOte9aXCqEM+9VjKoG8gzDuXwmKJ8K9xT/+uJA
         T+lYQSCbNX7sqYFKQGLKiivFLPEm48Oz6p33Ae7XvI5IEAWVLZ3UUD9dC9eWdlDDo9bY
         jHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+59yQTBC9bu80apfJ8cflhsz/X+yFuT+sCeqCtr8VLw=;
        b=Z0J0vr6gxNV8c3Pu01KPOdZ2uCwZXIYoO3D+Jf4EMIuaXxkqnqTntpD3L3omz7CtEz
         HnaWTVNVx00hBiEYMX5KOVUZh6lIFbQNo6XLnCME9nIthm5icEzULxp8wHfbqQWaPjdW
         9gxjzkwxd4TgfrW5vVwv2NhrO4qUjiR6bLKekSABNGJpK5GiFayUR4nTEx1YFeIH4gcB
         ZfYYELpjO1amcVP/rwJnZBWaGIq8D9IaNOI2CKvsDqlwQQAV9nfpOACBOoM4S3P1Wop1
         GV+Qe0ydIHIECmjA2zT4qTPq9MMMg+/CcETflBzdO+UdlMT1/BR2rQLsJjKnAs8gQGpu
         zxdw==
X-Gm-Message-State: AOAM532kdJHS2d8dNEXP1/10VNaln/fWb9VnSxgnbXMO+wY+/2CfQrhp
        eSy0RDQrloFreTZ4gVPkXSY=
X-Google-Smtp-Source: ABdhPJzit0C1fuAr+8kx1kQr5GlokKJp6j9zRjOtU12gEWCgp68NxIUz/YQRdLVfRIUF5oBjwwxtQw==
X-Received: by 2002:a17:90a:ea96:: with SMTP id h22mr5215103pjz.203.1601698668168;
        Fri, 02 Oct 2020 21:17:48 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:e35d])
        by smtp.gmail.com with ESMTPSA id f4sm3563379pfj.147.2020.10.02.21.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:17:47 -0700 (PDT)
Date:   Fri, 2 Oct 2020 21:17:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>, Wei Wang <weiwan@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
Message-ID: <20201003041744.zyxp5fx6lbyumvfl@ast-mbp>
References: <20200930192140.4192859-1-weiwan@google.com>
 <20201002.160042.621154959486835359.davem@davemloft.net>
 <CAADnVQKdwB9ZnBnyqJG7kysBnwFr+BYBAEF=sqHj-=VRr-j34Q@mail.gmail.com>
 <CANn89iLJSHhb=7mibKTBF2bbceFqSM0kNOANdFZ3rTaM3kwj7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLJSHhb=7mibKTBF2bbceFqSM0kNOANdFZ3rTaM3kwj7w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 05:54:38AM +0200, Eric Dumazet wrote:
> 
> Sure, a WQ is already giving nice results on appliances, because there
> you do not need strong isolation.
> Would a kthread approach also work well on appliances ? Probably...

Right. I think we're on the same page.
The only reason I'm bringing up multiple co-existing approaches now is to make
sure they are designed in from the start instead of as afterthought. Two
implementations already exist, but it doesn't look like that they can co-exist
in the kernel. Like this NAPI_STATE_THREADED bit in this patch set. Should we
burn that bit for kthread approach and another bit for workqueue based? 
I don't know. As the user of the feature I would be happy with any mechanism as
long as I can flip between them in runtime :) Just like RPS and RFS.
