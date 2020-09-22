Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05378273E6F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIVJVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgIVJVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:21:53 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC30C0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:21:53 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id o8so14981689otl.4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OU+qS9YAG/VZrpnjQl2h8/gd+ft5/Qg3gm3naYNnkPg=;
        b=KxEZ38Fbm/om8lQTQQ9ZaiIIDdfs9Zw3UMM/XZh57RmMiSXa3JK/LNC9Mk3uo9VzlH
         qquO0CwQ0bGoTYwNqVcIHDuzXGZsRX9YX9HXD/w0zxBnh/pqwVoTIYsjJm6vi/DqzR2R
         txNBMT+AL+Oxnp+Rfeyhh5V8WI5ZY9fmC2ls0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OU+qS9YAG/VZrpnjQl2h8/gd+ft5/Qg3gm3naYNnkPg=;
        b=tSDKOI1oSh72U14bc22Tcy9M/0NMq9hmQxSCKfCZ/CIlHWALhOczuLO1cBhsILUtuE
         mD4Srzd697qiEal9c8LRRayVhEqDBHnlelE1A4dQKtOXhYkBnzN5Z9DYg+7QczYPZ2mK
         LNv4UG7+pSU2Z0kjibB7o22Q/3gRGJGyz0WNIicfFpvw8vr5Xtcdchkww/h0W+0Ck5DG
         yryLz8qyHUac85OElQXbtM24XM0K3R06sCzyIKo/DbHDnPJXFnEfj0Df5QzN6JVxz2y2
         Ee95pQ0trwJkV1MDcGJvu8WizAgI1dktANZXGT0elkGNs2+OER+KjstZtnyouvx7t6iK
         0fuw==
X-Gm-Message-State: AOAM530263JrIBZPKsI/gcrClOR0iMWH0SaI3EwiT25WQ3nTcGJxxWXg
        FHxEzsBdjd+o5vKNHQwqL7HoHaeHTAmJIz9CPiUDig==
X-Google-Smtp-Source: ABdhPJxWGwB4Hz1/af2msHi62jplb55obrvDl06OYMifrHK4ZzzcELLeqBmhmUTLJYELJ7w1pi3I4EgaTVHI2hE9kps=
X-Received: by 2002:a9d:6e90:: with SMTP id a16mr2113160otr.132.1600766512830;
 Tue, 22 Sep 2020 02:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070447.1920932-1-kafai@fb.com>
In-Reply-To: <20200922070447.1920932-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 22 Sep 2020 10:21:41 +0100
Message-ID: <CACAyw9_XEKZ+Z2w6GLERBS4cK4aygrCJYhT50hk=vVd_XQK5hQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch changes the bpf_sk_assign() to take
> ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will work with the pointer
> returned by the bpf_skc_to_*() helpers also.
>
> The bpf_sk_lookup_assign() is taking ARG_PTR_TO_SOCKET_"OR_NULL".  Meaning
> it specifically takes a scalar NULL.  ARG_PTR_TO_BTF_ID_SOCK_COMMON
> does not allow a scalar NULL, so another ARG type is required
> for this purpose and another folllow-up patch can be used if
> there is such need.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
