Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F031290A8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 02:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLWB3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 20:29:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43784 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfLWB3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 20:29:42 -0500
Received: by mail-lf1-f68.google.com with SMTP id 9so11346332lfq.10;
        Sun, 22 Dec 2019 17:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3/T/nKs4wrsuDICyEhvY4U603UgwSn/cAUPgPFMHgvY=;
        b=cyoZ7q1cVANwGHWtxNxWDb81oEK54rgcssJjt0ftSvEUTKJpujX1HsDVIsWz4qM1fN
         4lB4mjBs0YtU/93LAsg1CzPIEeqOrmS8nQ8RIb2Ik4zGUOlr0UXJk8zHJTHEclxI871J
         a97q2+IxpcaU3nHb+eJnb6BHQ10Yea1mdGSN6wAe4m2AGueQHf4a4IJw4w8foo8N+8V4
         ogtgk+w6VJHCvrr5UKpVD93IZNL9/uu2VJQmE4wWYoXFrOqoMJv5SCbbyehnsKshQVC0
         iyb7K+B9SH/WH6rrePNLW9O6ej2ouaVgwiMtjEqLiDcIzB8eMgbxMmQpBsToK94BItjq
         LYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/T/nKs4wrsuDICyEhvY4U603UgwSn/cAUPgPFMHgvY=;
        b=EG1Z7WXHLn70S0J9URJiCcuSFSL6iqNaykg3PFz2MMowBmLLISTF0h4WEJ67CxL86g
         hSJ8rhHDbIuOUB/ZxaIi+LQHP9t01bhwRyO6iZx83V87TCIBwBDyGUmqsQKHOLyYeJMs
         2dz5WpUgoLJH2/RF2LqbxxWCnOmtHFEbCr8THPtod+S/tKzQsvXerzZOfi4L1fFaTsvF
         sPkfaCnca0ae4jcOQAzAhdOg/iqIO6d1njEZBpa4azHogeCHfqULVqeu5rXF6APqriBD
         m/NvhHl5mcDwk+buHiN8IybmFRDnGkB50YxtHN+3mXSCOM8Up7LI6qCkewqEt7sEyuLY
         BW8A==
X-Gm-Message-State: APjAAAUrcrNLdmvWlvLzyWKs6oP1gSrBcjUuycW7j5VaTE3StB01BqB0
        Fu5Bh9FjONE7vS63HgPfJDQmBsX7O9JgXHTsIyU=
X-Google-Smtp-Source: APXvYqxyGkUMXa1mo8W701X4EjQq4peAchitzKXwtzBqJog71t5X3UGvRl+7HQwAkUPx5ZNyBDQcDZJDmBnQHcV3ucc=
X-Received: by 2002:ac2:44d9:: with SMTP id d25mr15887486lfm.15.1577064579951;
 Sun, 22 Dec 2019 17:29:39 -0800 (PST)
MIME-Version: 1.0
References: <20191222223740.25297-1-daniel@iogearbox.net>
In-Reply-To: <20191222223740.25297-1-daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 22 Dec 2019 17:29:28 -0800
Message-ID: <CAADnVQJ5H2c-QCLAXYdb6j2mYpCNDZ0pGa96BMbKRmasqeup3A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix precision tracking for unbounded scalars
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 2:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Anatoly has been fuzzing with kBdysch harness and reported a hang in one
> of the outcomes. Upon closer analysis, it turns out that precise scalar
> value tracking is missing a few precision markings for unknown scalars:
>
> Fixes: 6754172c208d ("bpf: fix precision tracking in presence of bpf2bpf calls")
> Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied. Thanks
