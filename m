Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3451A16B9B9
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgBYG2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:28:35 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40650 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYG2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:28:35 -0500
Received: by mail-yw1-f65.google.com with SMTP id i126so6765036ywe.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 22:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YUEseoc5nFfm01S1YjQu52NcZ+yHtKwJn1jBK5gtp8Y=;
        b=MNU/bMVAHSTBwAF8nuKA4L5SeAUMSLSwFzpJic/bYDxP69XfLgwE6cvaxI4Qghxkhd
         I6XGws0+jRQOe4/6wSfQTNY7NviR8t2AsC3VhqHcX2KlJz+I/EYNoDsdvYnIGdIcP2JK
         WD6YgYY1ZLt2znRUTGPxUCIig0dnsbUuKXAFWQvym3cagfAkUK0HQnIH+ViwSjP3Wubw
         pFeM1HvJv3T4QSIiUFNXFIbkCb9cBICBC6UiEnuVe8N7WiKLSraBq4uDhEIbCcjqdlUX
         EZBY1uYsQZaAok55DeO757aoazXyBJoU7gLhyKhFLJtaSFYfOXsGrRvh8siOB94AZk2V
         nSSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YUEseoc5nFfm01S1YjQu52NcZ+yHtKwJn1jBK5gtp8Y=;
        b=FpLVXvngixMsMX3DjSuiqRREVQvDtgy11SR12rl/+O/YtPZ2AvF7hpc+dN/zzfDJGc
         7ofhg2KrR1GSaRIgzdhPJQ55sql7kj/sKyZ2wmrPhyfPJSaowkzhHjR594PVJ73jclZF
         wxNiL4O9p9Guw8NyLIaCVdLkVswRZhbUShUi5KR92APcikyv4CyCqp+pCnY5k7I2pLje
         ndAKCeStUj4Npvm80tMW4I4XOFpcCooY5uHNZyHSUDoZ0u/Qo9ja+zwww4ojkJd25AcL
         kVX5z6aQt2i5p3U0ARK7fUy9IJJV3Ek3dk72Vzs9NTx+JQiBNCH2psJLZAUfkr3K0HMr
         vwnQ==
X-Gm-Message-State: APjAAAWV7tVA4YtC27qG2GRbO5XVeJpB/A/IVMykRCnxdtoclL1gV34a
        /Rmx+qxXKR4yZwMpI4MdQZnGE1KV/9rviKs3wL8XXcjWwwo=
X-Google-Smtp-Source: APXvYqyGX7bP3yIWa7VV40IwRF3ie6diWmVkz2uCd98r76dUXC4e6VkFBXlc9oIIuj1A0vrOjABcg+C9wFXezYAonwg=
X-Received: by 2002:a25:bd85:: with SMTP id f5mr21130913ybh.274.1582612114053;
 Mon, 24 Feb 2020 22:28:34 -0800 (PST)
MIME-Version: 1.0
References: <20200225060620.76486-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20200225060620.76486-1-arjunroy.kdev@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 24 Feb 2020 22:28:22 -0800
Message-ID: <CANn89iLrOwvNSHOB2i_+gMmN29O6BpJrnd9RfNERDTayNf7qKA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 10:06 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> From: Arjun Roy <arjunroy@google.com>
>
> TCP receive zerocopy currently does not update the returned optlen for
> getsockopt(). Thus, userspace cannot properly determine if all the
> fields are set in the passed-in struct. This patch sets the optlen
> before return, in keeping with the expected operation of getsockopt().
>
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive
> zerocopy")


OK, please note for next time :

Fixes: tag should not wrap : It should be a single line.
Preferably it should be the first tag (before your Sob)

Add v2 as in [PATCH v2 net-next]  :  so that reviewers can easily see
which version is the more recent one.


>
> +               if (!err) {
> +                       if (put_user(len, optlen))
> +                               return -EFAULT;

Sorry for not asking this before during our internal review :

Is the cost of the extra STAC / CLAC (on x86) being high enough that it is worth
trying to call put_user() only if user provided a different length ?
