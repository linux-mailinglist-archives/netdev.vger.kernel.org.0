Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3BC140F8A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgAQRAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:00:35 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33452 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgAQRAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:00:33 -0500
Received: by mail-ot1-f68.google.com with SMTP id b18so23146172otp.0;
        Fri, 17 Jan 2020 09:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ch7lyhSCJlF3smYm9T9NtwFuHJijpU4nXKidqi8cP3U=;
        b=o/NkaGYNfPAVO21XcpHsy/HI0JrY1Ic2H5lxO21+x2FjY/IApBemDL/bdcRBfT+C2L
         N932BzyAB3oPPJHmgiMkGRmkTCkxlpxvxHbifWxkhGQqhaEZ0UUwx8/gQ1RxpG3StGrm
         S/yzDISyluGDKvmW+pdGfDLzTvsTSUaxo9ik4YNFwJceNAqF31k8oVYEf2k3kWlc93pX
         5I+O8zncGwstoGGb6awL9nRJJpfFO4zhAkftRJtfwO1KA6SQAFEod694VMISmi/QWGao
         gWei059DkjioB2kqZC2Gx+aNREVcMZ/ES8rUMndkW3d+YYuujYG2l+wgSWTp82ksWsYw
         iILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ch7lyhSCJlF3smYm9T9NtwFuHJijpU4nXKidqi8cP3U=;
        b=hgIiXmp1/ZnX2KuBRCjXvuMS0ne6GWP9OGmZvFd4ItTAprD2qHLuoWTfvt+zu1+ASn
         t52MtsT3mcP4wIw32KE9r1b9vdhm911upvU6vEzOcJH5SCSjqCoa4fLex8DKiF2H12qA
         wLhwSGU5T+Ves39GD8gQuyRaZT60kLjCoFdPhAUzEWAFBvxNnX4lrTgDf/qvf8vxgknB
         xAACKAZxh7D2fcG0PI3B3zCFdMoToRkN+mQW+zwSoQ1tjaBu4IURiL80+G9l7YeohsjB
         2oT4Vzp8b4Rj5aTk3Df3aU98Ic5kcgmQqQxcwEiGNy/ZZqP5AFPibbnKEgzMvAP5Awrt
         3LgQ==
X-Gm-Message-State: APjAAAWyzQ42LIQOHYuXW4u45VKtWNTzuTpmqQyvQAZr54FT6YvtncN4
        JCpVkeBlouBXqweypwLiHOCIfYHPZ0W1K0IOcefBEiJ4
X-Google-Smtp-Source: APXvYqzmrXjjnGqzv8eBpGGfLuzDLqlhnL+dQ1htpgy2jg7VO/yDaN2Vj5BOcqtyRdlgU9ku72cOxXD0BTi3OVFNjU4=
X-Received: by 2002:a9d:7ac9:: with SMTP id m9mr6557409otn.80.1579280432454;
 Fri, 17 Jan 2020 09:00:32 -0800 (PST)
MIME-Version: 1.0
References: <20200117070533.402240-1-komachi.yoshiki@gmail.com> <20200117070533.402240-2-komachi.yoshiki@gmail.com>
In-Reply-To: <20200117070533.402240-2-komachi.yoshiki@gmail.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Fri, 17 Jan 2020 09:00:21 -0800
Message-ID: <CAGdtWsTWdzxnWG8oEryQUVKogBV-8=frC0CtDgGbAC-ZwXU-zA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/2] flow_dissector: Fix to use new variables for
 port ranges in bpf hook
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:09 PM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> This patch applies new flag (FLOW_DISSECTOR_KEY_PORTS_RANGE) and
> field (tp_range) to BPF flow dissector to generate appropriate flow
> keys when classified by specified port ranges.
>
> Fixes: 8ffb055beae5 ("cls_flower: Fix the behavior using port ranges with hw-offload")
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>

Acked-by: Petar Penkov <ppenkov@google.com>
