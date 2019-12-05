Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FE6113979
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfLECCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:02:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33674 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLECCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 21:02:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id 21so1651022ljr.0;
        Wed, 04 Dec 2019 18:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vy4UrIm2jbRYKhBVybPxalNzM1Qcx1GEJhVkQOqA7Lk=;
        b=YbeIjIJAG4/1dqJq1HBXEgM+DuGuWN84YjlLNDWvHv6RDBe2oEYSNsZGk/FZ+15qEq
         TbkzU9xZcOy9kGJbOpKVzZMCivDH0tC2glfecWpHyuEfRUyQU1HxgltRcITUXwHGKKzP
         cWW8I0JeGm6kkoEaSiHZndMqTwAmjhndPdP26uC5zX7Hlr/tbebkFPx+zkDaVwloCVp4
         glnxFgD7cymIQRmILDMMLIbe/dChXXRviEu66jULnk7M6zvmHP8xYqfuQY8F+1KT1fOb
         ZhalLsmEhQVPOGvE9eT8Dy2eAJweUbYTXshCI7S4NMmO8R9o+3HQEJQWTBtcplOku4qG
         pZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vy4UrIm2jbRYKhBVybPxalNzM1Qcx1GEJhVkQOqA7Lk=;
        b=PbHGId8P4GTY+mjmW0fiZ2H0seXOyTAiIve4iK44zt+9FikWLu5C7oTz9hxXiqJ8ke
         BQ+xcfhu8DV+VvZLblGJM9u21tdlGPwm3XMNl5Sov2j0BNwwT3W9GS9+eYDu3oBt+CMx
         QCTYSdOXuHsk9HeVOVt6nDf7MBpveeVl+nmeMyoeu5pYUhpPadOK1YAQpR7B2Z1vkRPS
         xlx7QOzR7GTfxAZZIB0xNodh/y5Hv/ehkgNwXDE31NXtpY+D4bclX+/iGakrfQLvrGyT
         VIZsVJIKkCZkAh/ee6LGmy1nndaQmeh5zu92RBwakevEpoePwvgVf/CMLwI+h9NKMWRJ
         KH8A==
X-Gm-Message-State: APjAAAXBilUthMsVnz/Js0cMNjZ//MEC8D4S5EHB+RpnlV16Mdy0j6tz
        ecGV/X7cBpjLTzk+0aBvW3r+slbzBgwDPI7p08oBCA==
X-Google-Smtp-Source: APXvYqyggXNzsI94Lxc397HaN2n3ZkgbEF1fEG44wCPqbNffF+4/8JNMj/OoiJNPtWUyX+4u57f9aE/n9vYWu69gHI4=
X-Received: by 2002:a2e:5850:: with SMTP id x16mr3874211ljd.228.1575511324788;
 Wed, 04 Dec 2019 18:02:04 -0800 (PST)
MIME-Version: 1.0
References: <20191204190955.170934-1-sdf@google.com>
In-Reply-To: <20191204190955.170934-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Dec 2019 18:01:53 -0800
Message-ID: <CAADnVQKjVFxWK1VgQTkZp2+Swr=LD1Ar2ABMY3_=78nkjssoJA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: de-flake test_tcpbpf
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 4, 2019 at 11:09 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> It looks like BPF program that handles BPF_SOCK_OPS_STATE_CB state
> can race with the bpf_map_lookup_elem("global_map"); I sometimes
> see the failures in this test and re-running helps.
>
> Since we know that we expect the callback to be called 3 times (one
> time for listener socket, two times for both ends of the connection),
> let's export this number and add simple retry logic around that.
>
> Also, let's make EXPECT_EQ() not return on failure, but continue
> evaluating all conditions; that should make potential debugging
> easier.
>
> With this fix in place I don't observe the flakiness anymore.
>
> Cc: Lawrence Brakmo <brakmo@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
