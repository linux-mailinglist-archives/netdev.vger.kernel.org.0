Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4806E27410
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfEWBhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:37:35 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41225 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:37:35 -0400
Received: by mail-lf1-f67.google.com with SMTP id d8so3117086lfb.8;
        Wed, 22 May 2019 18:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xH7m4r5nXzTcYi5eb1FxiWx4YgQVtNCfhCAfKx++m2g=;
        b=eukNjUvdq2PGQ9Qd5Yd7XxQIfEmpNgWyYeIKol2qAtXrQP7pNnS9K7BVtuURpJXrH3
         id5GiV/n3ffXsfwOiY/xckMaTZt1FjJ/UPNQtTHjLTyK3fHTwczYGhrOmuH5WrqNA0nX
         NWwzGl4Fo/5/SgLWjwBsc2I8xhnxiIj6C7lABWmtZd4zNuNPCIjJLvz9NchJwl7W3Dsf
         CfGKyXOc1YApB6VLf5lZ4/47zpwHArQ9dbCD8iKFbTNgPIhwueWAdS/JiI3fsreUwjsK
         QxX84VlJ2SLIP980UG1C0TdCHYjxyja14ojCVULKFBZEEKUrZRP4jctXl/rMtvHY2dvf
         QcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xH7m4r5nXzTcYi5eb1FxiWx4YgQVtNCfhCAfKx++m2g=;
        b=fGb5V3sw97rms4+UCKALQqgxvliWhgzjfsvW4zYmlsnIv8OGsHzScmyV/sfyZ0esUY
         3RjcomZRsIwhbqwa7IeUANZ1gSzfEl+ozuknA3KpHeS8vtl0QHet7t4QUGTHzyQi0k0S
         OBomLumqUMez2/r15LTN1Np84iwy4GnTEUOXIdlNSuT2Uoagic/mqh4nlcfhJmBoFgVH
         WBukwo0sf56+NXkR0fzjcT83hlDSZiWHjYPaYhFqq4w7hX4lJx8X5ZTfxvJsrYufpzGL
         G6MieSWpF/QnjGtn/2ABZAAIWq+bo9Om/aGQ9LGNI2IYs7PwnbUqne+H0ntMDRMxW0jg
         1hFw==
X-Gm-Message-State: APjAAAVlJMzVIlYzI4HjNVxzz9GR2O2PXcQgU8wd5qWTOxjUqaTvc3Bs
        0tuK41Pti1x1MEaovRCoLPYEBZ99kabGFpHoF5uHAg==
X-Google-Smtp-Source: APXvYqzuhlp2+E+sWkSCOGZbZhm/F+SG7CEtiK45LYtdxaykUesxKbB2KNERm26vCQcGGNr15cAX9+whAwvseykmE9A=
X-Received: by 2002:ac2:494f:: with SMTP id o15mr32206454lfi.22.1558575453295;
 Wed, 22 May 2019 18:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190522175128.3680479-1-andriin@fb.com>
In-Reply-To: <20190522175128.3680479-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 May 2019 18:37:20 -0700
Message-ID: <CAADnVQJcsz3MFvRetB3HVf9KeP9dJ12Zd4xHULTEq9RjryCCow@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: emit diff of mismatched public API,
 if any
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 10:53 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> It's easy to have a mismatch of "intended to be public" vs really
> exposed API functions. While Makefile does check for this mismatch, if
> it actually occurs it's not trivial to determine which functions are
> accidentally exposed. This patch dumps out a diff showing what's not
> supposed to be exposed facilitating easier fixing.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
