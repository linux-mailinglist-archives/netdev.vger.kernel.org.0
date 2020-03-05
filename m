Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501EA17A4D8
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCEMD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:03:58 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35705 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbgCEMD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:03:58 -0500
Received: by mail-wr1-f67.google.com with SMTP id r7so6712062wro.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=hT7S6vvpnxA0ApcPEejqGxLVzm717a4KSHt7eOw1Bck=;
        b=GIH9MsCPmG16v2K7zrrevmV3g6eLk1wIcKUD9XnRWZuoOJXK1GkdfQGkFYZ928xMmM
         Y3PnJAK/ssHCHqBUqfr96FgMu1N8MTdKO8DxCL5bgs/ODGHWiEnA4ZrWrxCmnB0Qk4kj
         5csGyslb48TLPEaGgGdrIKegAW9qV+4WV2Iu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=hT7S6vvpnxA0ApcPEejqGxLVzm717a4KSHt7eOw1Bck=;
        b=oKtZzxfalgeIQvPXPPuLVhShHKFSYXDgNRIMrjGrzM5IbMMw167THiuZ4ZGfQz3uHd
         PI+gOGM4h9MOW2giLx+DybGA2ofiL+Q5we9i0osMXlaIdjLubb0p9H7KlNqcKpDF5Pqa
         +Df95kTYaaLPlbOV/us+C2PiOdPqgeB0oTfZpVtwrfAOFKeDA7Xt6TTNICUbfBgxqBAx
         V/xgG2P/+Ip8r007Zcfvmp6FaNUn7SY5O7vbsM2gYAnVA+DvsUVEpMauTswAdYB3QnHP
         im6hzlLztjRA1XlzOFrdOo8hdeBkoLjzPWzu7MF4jswFwPvAgV0FWmsQgZfhp70+K3Sv
         WpAg==
X-Gm-Message-State: ANhLgQ36sgXjxQQM9QaWhPvDI7I05oFOZ3upZcV7WBzm7wdCJqzn1zSB
        7Fj8bc9JjDa/wPbK1EL6zS/MRg==
X-Google-Smtp-Source: ADFU+vucLtTgYNewten9hKmRyZyvNiBAi0eWwE91eSAbKxv50uEY0RkR+AYp55iwZRNYjSqE2Bq4mg==
X-Received: by 2002:a5d:5706:: with SMTP id a6mr9660460wrv.318.1583409836025;
        Thu, 05 Mar 2020 04:03:56 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id b186sm9170588wmb.40.2020.03.05.04.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:03:54 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-3-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 02/12] skmsg: update saved hooks only once
In-reply-to: <20200304101318.5225-3-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:03:53 +0100
Message-ID: <87ftenypna.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> Only update psock->saved_* if psock->sk_proto has not been initialized
> yet. This allows us to get rid of tcp_bpf_reinit_sk_prot.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
