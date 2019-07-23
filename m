Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B93D71555
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfGWJhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:37:41 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:36933 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfGWJhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:37:41 -0400
Received: by mail-ot1-f51.google.com with SMTP id s20so43354840otp.4
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 02:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJLBmp3UcQgXAy8r7SgBn/DZj0JZbFiq1vAkMjnkyCs=;
        b=Xe77j7e62YGCOsI3aqFkbt2zOr7PST27REOv5q1UKex1uOn2VXSq6Opr3895VaUR4Y
         eCGfKY+ZAnSfqK5mo3z4Qhf62O7Q6Wmj1WA4/XXhCOUFpGkuiftEKqN4c+gqiWHGOBAl
         Kr0z1WO5InwvjBRyvV7Zov8BQwBLrJg4zQBbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJLBmp3UcQgXAy8r7SgBn/DZj0JZbFiq1vAkMjnkyCs=;
        b=mNyLPiDV6IzWAePp78g4aDV04Yehp500oDeGD1oOzKwGFDl+AQJzoSdui+VScLWODV
         TvbXaW+OfQcAT1zK2zFuO3pnmE4fRFjiuP1bgKYJcWh9R6DFNeK6HJh/BhudmGURQ+7/
         MVzLbfZqv8hqeFr1ccqGYCqVUvUkIITVt+yTZmkC+rFCAljtyt2p4jsH2XDgk9AE6974
         zkA4uvNBbj6tevd7OfvaUk4CfOfdrlvS0OM4bNBCT1wSrzC98+Dd4aj2mlPxL+3f/a/F
         2n5kcqp1ehxeupeVeDBPhAMUs677keyRYYQKW5oMwegmyOpfvnlhuGKJ0EZp2tLB7ldu
         k7kg==
X-Gm-Message-State: APjAAAX5klGnewf50Dh0royY/uSOb3Dmyv3gwI9fN8olwC3BeaE76RQW
        juH+F/liurAJljkXH7odI01R+MDRV0fiWFMoT20jgw==
X-Google-Smtp-Source: APXvYqw3z7VevpOyQx0l6zRV9kfnSV0zaQGQhjGkFjujGieKL5VAT4XveiRoEQ7amtDtd/auEZfScZRCFCBKIlXbf0Q=
X-Received: by 2002:a9d:1b21:: with SMTP id l30mr25731590otl.5.1563874660212;
 Tue, 23 Jul 2019 02:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com> <20190723002042.105927-7-ppenkov.kernel@gmail.com>
In-Reply-To: <20190723002042.105927-7-ppenkov.kernel@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 23 Jul 2019 10:37:29 +0100
Message-ID: <CACAyw9-qQ8KbQk6Q6dg0+A337ZbSpot-sHpH_tSxFaQmUfhLyQ@mail.gmail.com>
Subject: Re: [bpf-next 6/6] selftests/bpf: add test for bpf_tcp_gen_syncookie
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
> +static __always_inline __s64 gen_syncookie(void *data_end, struct bpf_sock *sk,
> +                                          void *iph, __u32 ip_size,
> +                                          struct tcphdr *tcph)
> +{
> +       __u32 thlen = tcph->doff * 4;
> +
> +       if (tcph->syn && !tcph->ack) {
> +               // packet should only have an MSS option
> +               if (thlen != 24)
> +                       return 0;

Just for my own understanding: without this the verifier complains since
thlen is not a known value, even though it is in bounds due to the check below?

> +
> +               if ((void *)tcph + thlen > data_end)
> +                       return 0;
> +
> +               return bpf_tcp_gen_syncookie(sk, iph, ip_size, tcph, thlen);
> +       }
> +       return 0;
> +}
> +

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
