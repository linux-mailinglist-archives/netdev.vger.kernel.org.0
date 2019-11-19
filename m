Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262FB101241
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKSDtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:49:13 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34536 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKSDtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:49:12 -0500
Received: by mail-lf1-f68.google.com with SMTP id l28so6248235lfj.1;
        Mon, 18 Nov 2019 19:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HH5PLvJ20OvC/C8kkLjRvhx1Fuae3xod4pGt4mEoHsI=;
        b=c9nHyk7957V1XyntGICV21JU9/wwZcU3mwdanFsUk/Swjv/gqVPUIznAphXX96Z4FH
         rlT5R5NGrbYaRIy89iMuUo7xARGpCSoernnywn99PZoOAYJwcyBG+9LU1UGUcIZ+vp6p
         goj+yp2XKVIMfUN/ZOahxRVQp+pXN1Hi42PN5+A1OouMErWOG5lrQqHlCR/XNKJnZosT
         YWpc58AF+QJiBY6Y1Ft6s9z3GW3vkNz+cVLTJ22pJH0oCyAXKJP8wCyuDisK6nQRSOs+
         bZtGrD56wMwKhWfItGyzLn/ddPng6B0YhoGkvSe7VjNpLJqiKgNM3t0q5pI3OMGeQNZU
         y7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HH5PLvJ20OvC/C8kkLjRvhx1Fuae3xod4pGt4mEoHsI=;
        b=l+2Rl5mPUbeK9zFYpqYLMHel8bqx4O/Tf/7zPrMO+W75OBL6UnMV9MN0B+rHtLYgJt
         kQwHGx3NWQ/klUzwuq3IzmqjsqjJYZu0HlGxbLD1V/of+MnL+q7oUGS3HpF7u3JhFrzt
         13IjEoz+/QYoyTOmMnNhfAl+7PXpZbGIexHcNAYc26IFiXp6Oj1KUIGcLe2YgHfVQn1f
         UiNx84Ehs0rTf36uAeagXNAeil5VRmy+D4clczfqNTA3xB9CkOsxQ1a4gMBqWx5LdubD
         +i8lXebtM9rGKNZa3JJmgVw8Wknr8TWvV28KW/XxVwQVabp10mnm9rSsNLhUsNEKILYx
         HXJg==
X-Gm-Message-State: APjAAAXWk33EiSoqHCD+uqV2m380YUWTeYjUsCIaj60PSOxRPcGr5H/5
        Pkjyt5/A0XcEnHaOqdZaq3wQhLAe0Kw1TWXrkCA=
X-Google-Smtp-Source: APXvYqzhk9kJlKXPByN23lPwtGWAAWCjVVpsoIoz5EET5xMu7Ch85IPo54pTA7eEfX+pP6MKyzPGNfMA0/3IbOiA4js=
X-Received: by 2002:a05:6512:511:: with SMTP id o17mr1875902lfb.167.1574135350223;
 Mon, 18 Nov 2019 19:49:10 -0800 (PST)
MIME-Version: 1.0
References: <20191118114059.37287-1-colin.king@canonical.com>
In-Reply-To: <20191118114059.37287-1-colin.king@canonical.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Nov 2019 19:48:58 -0800
Message-ID: <CAADnVQLhoHvdnJrcG0Gj128e8w0uLvRqg+p9=GJTr=1R8VLS_A@mail.gmail.com>
Subject: Re: [PATCH][next] bpf: fix memory leak on object 'data'
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 3:41 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The error return path on when bpf_fentry_test* tests fail does not
> kfree 'data'. Fix this by adding the missing kfree.
>
> Addresses-Coverity: ("Resource leak")
> Fixes: faeb2dce084a ("bpf: Add kernel test functions for fentry testing")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied. Thanks
