Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCB1115724
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLFS10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:27:26 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36789 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFS1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:27:25 -0500
Received: by mail-yw1-f67.google.com with SMTP id u133so3065636ywb.3
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 10:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2cyUhc6aKa9UX20w8SaEoVlza99mkD5oACC/8lQoqY=;
        b=s07zQ3dUXxIf+ohWcGhzui2XcCXnrX9omUpeW6tpUmKCknewNyH67OnlkdPmcq0t09
         LwJUcWBCXmhsbMl4t7Im79WjlopqqBKplKKYolearHstGlVhHd9jEGFeCN0yqMCCu68x
         vSHqkW77nKeDS7jv631y2ucGfECBH0eL+9hCAZbQukvOXiYI1FHctqWdx8kJRVwylq1h
         AQOhlUCGPXGWz6A1OjrcsujIozG3K3IfTA/RTkV9GotFc9qeTXl8/WCb2mGlaZqCCNvh
         LydoxMJBGJuuKoWRbDZGzIdACseSa7cO3vlVmF8l8xVCv8GIyt+WbuhvCfuj41VJvbOI
         11tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2cyUhc6aKa9UX20w8SaEoVlza99mkD5oACC/8lQoqY=;
        b=C5HIf7bfLR9KIygx3fWiRUo0E8IWrjDhcCY2BIPWh7/bUbwQ9LCGPn71EkHWc6iuGC
         YCIQrQhuZ6RrVB4skZ4dpHVF+vMT9zkiySzOhBG8QrnFRDovWJmi/8IbNE7+zfYR0rB+
         IawwRVl0lGOd1Lgs8b3GXZS7pcapf8HX7VjilI+eCEkaEDrPhrGbyVKlY2xwUHxcmgYm
         aiobcy4HvzBhhNbF2fvyRNnylBfCql+klzQjNSiw5VL9bpwNGNVbADjlqoYzlvzSJ96z
         T84aMFJmyjuzn/WJoAff29GZcU+/FDkjZV6zxZkAgPZi+iX0AVRD101Xy72y/ZmZ1H3O
         2oJA==
X-Gm-Message-State: APjAAAVYsrPIf6SOnGLdAEtGf6wsnaf3R2FRhTPSBUgauOxNcArqQ9YK
        zzTMK8AU1uM3iFb+r3eaHDOdNp8DzvuW8JHGZKC7HuGd
X-Google-Smtp-Source: APXvYqw4GazJkbbqCMZw1cBPPg+5E/r5p2PeL4JSy1OzPP+fgV78xZ/Vehvge3twYLIhsJFDEU26dv9yeCUTIZr/+T0=
X-Received: by 2002:a81:a389:: with SMTP id a131mr10975106ywh.52.1575656844273;
 Fri, 06 Dec 2019 10:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20191206173836.34294-1-edumazet@google.com> <28a8318ed78e64213abfe85e105ee6c2a1bdb3aa.camel@redhat.com>
In-Reply-To: <28a8318ed78e64213abfe85e105ee6c2a1bdb3aa.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 Dec 2019 10:27:13 -0800
Message-ID: <CANn89iL8hquiyzVs6RoQ6g-2LAMo0PPNp3+juXRyy0iKL_877g@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid an indirect call in ____sys_recvmsg()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 10:22 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
>
> I'm not sure this is -net material, but the code LGTM.

Well, performance matters (otherwise David Laight would not have
investigated so much),
and patch is kind-of-trivial, I am pretty sure David Miller will not mind.

>
> Acked-by: Paolo Abeni <pabeni@redhat.com>

Thanks.
