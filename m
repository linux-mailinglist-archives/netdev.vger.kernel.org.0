Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8709E1583E6
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJTsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:48:21 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48367 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJTsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 14:48:21 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5c6196ea
        for <netdev@vger.kernel.org>;
        Mon, 10 Feb 2020 19:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=rEX1UFLdEzc3eqWwsM9VDHysHfY=; b=LrHNWh
        PbLbvlJ2vpi8Ee/d/xLcnTRzpl9yUplDF9GrUowjWLLWL02WSnrutk0VnU2FqH2Z
        ReuLVWmqqvUcGfREtIZzErqgvAtwupx6vbPp4MU10ENtgop2wczuUkQVLl9VvW4i
        jHSiwuZz4gSVGjyZYopop/jnIKWYd7OH3d91hagvey9160nrmkKLBVduhfKIKITp
        JxbO3DnB0dDxqUayckdlL8n2E721HWqkAVZ7x73d+HYLT8SQ3TYjvpAom6DGIeWl
        gPOAL1BCIjiMtKtBVeua1UzM2OxMqjwyK2O7cDev6KNMq9qPM9tXNAABwA/HxttI
        /M+xzAf/frIMOKfg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 787def5f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 10 Feb 2020 19:46:43 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id g64so7579979otb.13
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 11:48:20 -0800 (PST)
X-Gm-Message-State: APjAAAVUvSzwrnL0YQbGHmEui8Rvu0m76/1zhoafRyl63lOtqpYK4pkl
        fXKE/alP81kjfeqoHJCJigmWrpLcm5ZBoEp9Prw=
X-Google-Smtp-Source: APXvYqym80cDDc/cj+kD55QJt+jRPYdzuCUHn8HB8s6Hdj7j+Zo2bsF3yzwG0LumxE1Oi40Hyr4/hR5t4RrF5j0jMHc=
X-Received: by 2002:a9d:7a47:: with SMTP id z7mr2372612otm.179.1581364099773;
 Mon, 10 Feb 2020 11:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20200210141423.173790-1-Jason@zx2c4.com> <20200210141423.173790-2-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-2-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 10 Feb 2020 20:48:08 +0100
X-Gmail-Original-Message-ID: <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com>
Message-ID: <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/5] icmp: introduce helper for NAT'd source
 address in network device context
To:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 3:15 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> +               ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> +       }
> +       icmp_send(skb_in, type, code, info);

According to the comments in icmp_send, access to
ip_hdr(skb_in)->saddr requires first checking for `if
(skb_network_header(skb_in) < skb_in->head ||
(skb_network_header(skb_in) + sizeof(struct iphdr)) >
skb_tail_pointer(skb_in))` first to be safe. So, I'll fix this up for
v3, but will wait some time in case there are additional comments.

Jason
