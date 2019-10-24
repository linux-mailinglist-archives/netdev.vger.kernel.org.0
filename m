Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E40EE38F2
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409955AbfJXQ4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:56:18 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:44826 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfJXQ4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:56:17 -0400
Received: by mail-io1-f46.google.com with SMTP id w12so30339944iol.11;
        Thu, 24 Oct 2019 09:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wvcNv5xIFN846zQWLu3cY20MZbw7dwnexWPSClFQ4xU=;
        b=bnJWmYtsMkDFfrksxxonX0WtNv9WdkaqUp332rLvu5PuPcgXrurJ+lh81Z3kt//baW
         7uge+ziO9QPECrcQ8hSvralarVirtHvDp3jZUJuE7V8gFD8Kcs+1/NRHCjjN6UkBbEe+
         4IHyUbauPwLc4s1b35XEbgbpgcOrbuGJCi9xmFP27o2+5ma6jljzixNWZaQ4GGyUcXHy
         1leg5rf8ElbYTIgHJ+K1zTkqyoH4KJr0ppCfCAoxr0mu1QwWm8+wKKYWvzjb4byfGtBn
         CXVSjD6wpCp0VCmelLXaDCFIJg1SNGZTw3yZzbTsOvbY6t7RLAJEpBqPxvnGNKCU2d32
         kSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wvcNv5xIFN846zQWLu3cY20MZbw7dwnexWPSClFQ4xU=;
        b=XLA2fqcleZkZCE8zwTrTWX586eHCjOvAAiVsYXzK2ARSqhja81ph5qkZOmAmGsQnfC
         m4Y+UnUFLulS6evCAWlKiR5abc+KdSs1lOfulDCAwiKLIGRyKmtHgxGbX+zwn3MPNhTV
         nRpPo53JCmAMsBi9NQ6KQts4BnqwfNfsSjJYYE603S/nzUYjCfuXQ9jKjknmWjwnAAn+
         kjBXIUsDXG3jUkFYo35Lh3v+v77uxTSuTlKD2pBYiXmikcBYg5eawteHKgzst67iQj+8
         uHYzU/2cCTxSs04BujvsVMFMlVN7dEBZ8QNxJzvQRrheDEWB0jZLBpbFdCfVyg3360nx
         shIA==
X-Gm-Message-State: APjAAAVZKumuibR3wEIEEsgl4iHsayLhjyNcpBwjg+vHJX6dhgK6DJlU
        36QhgJA929rZIayhuigH0GVZ0cAGU+g=
X-Google-Smtp-Source: APXvYqwMMt1NAoU/JFqW8EXxDcrG3v05x+TvywkwWATpKnW98Iv6i5MtG5BrosbPpoHSok1YX56OGA==
X-Received: by 2002:a5e:c642:: with SMTP id s2mr9665676ioo.218.1571936176596;
        Thu, 24 Oct 2019 09:56:16 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z19sm2409237ilj.49.2019.10.24.09.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 09:56:16 -0700 (PDT)
Date:   Thu, 24 Oct 2019 09:56:08 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Message-ID: <5db1d7a810bdb_5c282ada047205c08f@john-XPS-13-9370.notmuch>
In-Reply-To: <20191022113730.29303-1-jakub@cloudflare.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
Subject: RE: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> This patch set is a follow up on a suggestion from LPC '19 discussions to
> make SOCKMAP (or a new map type derived from it) a generic type for storing
> established as well as listening sockets.
> 
> We found ourselves in need of a map type that keeps references to listening
> sockets when working on making the socket lookup programmable, aka BPF
> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found it
> problematic to extend due to being tightly coupled with reuseport
> logic (see slides [2]). So we've turned our attention to SOCKMAP instead.
> 
> As it turns out the changes needed to make SOCKMAP suitable for storing
> listening sockets are self-contained and have use outside of programming
> the socket lookup. Hence this patch set.
> 
> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
> lead to code consolidation between the two map types in the future.
> 
> Having said that, the main intention here is to lay groundwork for using
> SOCKMAP in the next iteration of programmable socket lookup patches.
> 
> I'm looking for feedback if there's anything fundamentally wrong with
> extending SOCKMAP map type like this that I might have missed.

I think this looks good. The main reason I blocked it off before is mostly
because I had no use-case for it and the complication with what to do with
child sockets. Clearing the psock state seems OK to me if user wants to
add it back to a map they can simply grab it again from a sockops event.

By the way I would eventually like to see the lookup hook return the
correct type (PTR_TO_SOCKET_OR_NULL) so that the verifier "knows" the type
and the socket can be used the same as if it was pulled from a sk_lookup
helper.

> 
> Thanks,
> Jakub
> 
> [1] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> [2] https://linuxplumbersconf.org/event/4/contributions/487/attachments/238/417/Programmable_socket_lookup_LPC_19.pdf
> 
