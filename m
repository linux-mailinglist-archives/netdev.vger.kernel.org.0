Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928AC17A54F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCEMcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:32:09 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55647 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCEMcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:32:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id 6so6110537wmi.5
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=XvqoB3YpTGvwS70Yx+o81kC3OP5qwjPAewaCKlcb6hw=;
        b=T3wLGGd4TFmeHvgA1nuM53qFrkJDFyrA1MdY080q3OYGZwSp7Epdjm3D5fCR+9sPzD
         HhKNAmSmWIPWUNohY4rbT/AA4u0fbwHRWxKxdmyiyrqUG5YrupzM39MM6xn/YBtRLH5M
         ZwdLlQoMOkVNKw5IAWUk9hRmklUu9PR2XatJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=XvqoB3YpTGvwS70Yx+o81kC3OP5qwjPAewaCKlcb6hw=;
        b=raD6KX5CtqARa1AvkiswY6LxGgLalMKkPq+cIv1JpjrtS6KLAJpEw1Ksfp7kttnYuu
         EUdmDpEeRuC6MhpF/CV+GuxILfibiXJMZ16XJ25ZOzw8HnlXLAodLY99j8FAlg3ImuPl
         5uLcfaAybS7bEcAqe2fm5sqpWHGfxSzDfQh3CR2dKB/sK7YO0RLLg7t8IdU4c1wK2t6x
         rUxN6tG8dofpm6rC4zS7yBQgJAE1N6K6ZuExwE7F4DJ95JVhEDiCPxq7XqsTk5TRN1t0
         6F4HOkFLMgavxF+nYaDFpfRsSa/Es0IX6U/tyOX0oowJcl84wYgnOGCnYng5uM71p6FP
         NYRg==
X-Gm-Message-State: ANhLgQ13be5nRulI+TJuFXYbcyFnjmwFRq9N5sAKWnw7fiiO/+qIGN48
        ovASr5s2xyZ4hmpLOnTM+KEJoA==
X-Google-Smtp-Source: ADFU+vs0s6JDpJz9Ahed3MeuIOLTRos26RvIX28l24f5TQaaBz1cvByfsJgGNQ/pkbU0F2hDoISdNg==
X-Received: by 2002:a1c:8041:: with SMTP id b62mr9174507wmd.76.1583411525674;
        Thu, 05 Mar 2020 04:32:05 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id b186sm9273626wmb.40.2020.03.05.04.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:32:05 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-6-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 05/12] bpf: sockmap: move generic sockmap hooks from BPF TCP
In-reply-to: <20200304101318.5225-6-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:32:04 +0100
Message-ID: <87blpbyocb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> The init, close and unhash handlers from TCP sockmap are generic,
> and can be reused by UDP sockmap. Move the helpers into the sockmap code
> base and expose them. This requires tcp_bpf_get_proto and tcp_bpf_clone to
> be conditional on BPF_STREAM_PARSER.
>
> The moved functions are unmodified, except that sk_psock_unlink is
> renamed to sock_map_unlink to better match its behaviour.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

To spell out the tcp_bpf_get_proto() and tcp_bpf_clone() dependency on
CONFIG_BPF_STREAM_PARSER - both of these functions access tcp_bpf_prots,
which now hold pointers to sock_map_{unhash,close}. And
sock_map_{unhash,close} get built when CONFIG_BPF_STREAM_PARSER is
enabled.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
