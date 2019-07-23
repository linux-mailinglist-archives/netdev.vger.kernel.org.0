Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F547160B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388773AbfGWK2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:28:04 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:33697 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388667AbfGWK2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:28:04 -0400
Received: by mail-ot1-f53.google.com with SMTP id q20so43448716otl.0
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 03:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DzjZ9xrgJ3e/N9oCtEjwrojn4zWHBMXyeNDwUYtXGpA=;
        b=IMAR6fvAspFpE2VY2zN47kWU83tie4A+Smh5I1eVnhIRNNrh9o5KpPCjY2/S4IT1xX
         MwoSHeg6j1eHNGeezJD7/3o8HH8XQa0EgZ6QAVMVdkrrGfyOpI8mKdF6jQsXtwje9h5d
         eZwYSm3O7jWCVbxabKaIZYM58itmDAl3XtWrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DzjZ9xrgJ3e/N9oCtEjwrojn4zWHBMXyeNDwUYtXGpA=;
        b=THC8niKQxCeYQRuYnz/q3HWTFw2JYqm0o8i1S0t/lLSFTrE64HhP6Bpfh8YY3NHgSs
         dbEWK8tMBifmoPfV/Wr9ouO2Mmq0CQzjROQIhgSC8ccoTuljPpnDDQJVlgpoxLpxnuB5
         ANeQN2m1rDHokL38F06MQZ7kWgY3uce1MmYn9GXZ4+ntSaYn6UCad2PsdR2ME205pP6x
         PVS5vdLib1wZ9oWZi/eRboK0iumXiBQ8N0S3XnxpCIMYxOK1tntsn6XuLq6zjONtM+xf
         vbKSI1eEF9BoUjz8QzOTQS05JOKIGFikW0xzAmSXN2liJQGuDZ/v0ZOvFpq58n9gNXTZ
         niCg==
X-Gm-Message-State: APjAAAXf5/Pay3NfgWg0ilXBzRuR33Bq8Tk6TIW3Vq3A7ictgw70sz4v
        VAEiTXDDi+nDd8enosz6bKkyMnWOxloMeB3mQQKzcA==
X-Google-Smtp-Source: APXvYqzEpVRw6OPxSjOoqAs6BN44GaYDcArZCOF2x1AMWSijh7TcvOBEmzzr2EMth26lY0YWk4E1HNUjbRO2AGoyfPQ=
X-Received: by 2002:a9d:28:: with SMTP id 37mr53996317ota.289.1563877683237;
 Tue, 23 Jul 2019 03:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 23 Jul 2019 11:27:51 +0100
Message-ID: <CACAyw9_6jp6PauEcCSVvc+JJA1VvZgNsYZtuvu5=vf4b0rxkvw@mail.gmail.com>
Subject: Re: [bpf-next 0/6] Introduce a BPF helper to generate SYN cookies
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 at 01:20, Petar Penkov <ppenkov.kernel@gmail.com> wrote:
>
> From: Petar Penkov <ppenkov@google.com>
>
> This patch series introduces a BPF helper function that allows generating SYN
> cookies from BPF. Currently, this helper is enabled at both the TC hook and the
> XDP hook.
>
> The first two patches in the series add/modify several TCP helper functions to
> allow for SKB-less operation, as is the case at the XDP hook.
>
> The third patch introduces the bpf_tcp_gen_syncookie helper function which
> generates a SYN cookie for either XDP or TC programs. The return value of
> this function contains both the MSS value, encoded in the cookie, and the
> cookie itself.
>
> The last three patches sync tools/ and add a test.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
