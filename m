Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFBDBD23D
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfIXS7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:59:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:51430 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfIXS7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 14:59:14 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iCq1l-0001g7-9Z; Tue, 24 Sep 2019 20:59:09 +0200
Date:   Tue, 24 Sep 2019 20:59:08 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Herbert <tom@herbertland.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kcm: use BPF_PROG_RUN
Message-ID: <20190924185908.GC5889@pc-63.home>
References: <20190905211528.97828-1-samitolvanen@google.com>
 <0f77cc31-4df5-a74f-5b64-a1e3fc439c6d@fb.com>
 <CAADnVQJxrPDZtKAik4VEzvw=TwY6PoWytfp7HcQt5Jsaja7mxw@mail.gmail.com>
 <048e82f4-5b31-f9f4-5bf7-82dfbf7ec8f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <048e82f4-5b31-f9f4-5bf7-82dfbf7ec8f3@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25582/Tue Sep 24 10:20:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 02:31:04PM -0700, Eric Dumazet wrote:
> On 9/6/19 10:06 AM, Alexei Starovoitov wrote:
> > On Fri, Sep 6, 2019 at 3:03 AM Yonghong Song <yhs@fb.com> wrote:
> >> On 9/5/19 2:15 PM, Sami Tolvanen wrote:
> >>> Instead of invoking struct bpf_prog::bpf_func directly, use the
> >>> BPF_PROG_RUN macro.
> >>>
> >>> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> >>
> >> Acked-by: Yonghong Song <yhs@fb.com>
> > 
> > Applied. Thanks
> 
> Then we probably need this as well, what do you think ?

Yep, it's broken. 6cab5e90ab2b ("bpf: run bpf programs with preemption
disabled") probably forgot about it since it wasn't using BPF_PROG_RUN()
in the first place. If you get a chance, please send a proper patch,
thanks!

> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 8f12f5c6ab875ebaa6c59c6268c337919fb43bb9..6508e88efdaf57f206b84307f5ad5915a2ed21f7 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -378,8 +378,13 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
>  {
>         struct kcm_psock *psock = container_of(strp, struct kcm_psock, strp);
>         struct bpf_prog *prog = psock->bpf_prog;
> +       int res;
>  
> -       return BPF_PROG_RUN(prog, skb);
> +       preempt_disable();
> +       res = BPF_PROG_RUN(prog, skb);
> +       preempt_enable();
> +
> +       return res;
>  }
>  
>  static int kcm_read_sock_done(struct strparser *strp, int err)
