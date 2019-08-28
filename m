Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C22A0A3A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 21:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfH1TPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 15:15:38 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:38515 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfH1TPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 15:15:38 -0400
Received: by mail-qt1-f181.google.com with SMTP id q64so836036qtd.5;
        Wed, 28 Aug 2019 12:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wucswGgAeMprRvHqEbQtJG4/pT+Cqd+9w+NdQqNrAA=;
        b=NnZqPL+8jD0eeAfdtXeLAwJGy78aZke/7tQcutBfMa6BrI6U9S3Lgpkic2ad7K3/F+
         hmmSXWmIdUMSmntqKVlSSHzcwNfZLpzBsK/isi77d9xNKs0tlVWWWmscpbdjTpp2Brz3
         XTNd7VPLYBAca9cdPf07A0SU4Yl0bMdk/ozNQ3y+xdr+WfWNK2jUeKcKFvJ/SCzU+gHa
         dFk344Vihgx1V4T+Lv8FUhFpdOvc3MuUIwG+3L9GRlK8ddYnLBwNi3yC1+8jD7xGoTuw
         lC4NQi89RZeK3GzgPf6XUO0ht8GFzKLTaDnTiR5/qOjMXqI/WhvWKr1sYAKWYYNebK+9
         rShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wucswGgAeMprRvHqEbQtJG4/pT+Cqd+9w+NdQqNrAA=;
        b=iAK01oXT1sv91IdRh89AhgE3gYJkZPo3UmFYo2ICUAyyLYOSBd8J8J64gJZaYKuz/K
         EjscI7b9cQksYF/ZBfWZ8zFpHKwpVb5kiOSi0a9o3ptZaZ93V6JXMs+0WNThIs2GAQQD
         Z380IFTz4TFjQBwfD8oHEQrvDFztzejNUgQe8Qt4h6hoFG9jGJHT+5502I1bys9vGZo8
         UKvl75HMVUeI1WGLaOt72s00ajipl2VGRf4sev18jmsWWTd0Nxb7RkceSgr5kiKJQipA
         71ZyRbbDwIElP9yxPinUNK+6zTRQO7Lb1gs59PBfMJIfocDLFznhe8voOMIny75UYWFe
         1xiQ==
X-Gm-Message-State: APjAAAV6e0dI7f+nLAymcIcAZSqmNpcNTYFWDREf7si4D3AJbx1GkhWi
        NBwIY2r5Tqj1YzWlHpeR+CKFzzE8UaSsUs9wDDU=
X-Google-Smtp-Source: APXvYqyPKf9MY+M0Ey+Z9Z3uHN6ww/XaF44hvYPWY+DuOAKNwhd/1FQJzllTnEP+wZ/r3y06hjnqYX+0VB8FbGVtEXk=
X-Received: by 2002:a0c:f6c6:: with SMTP id d6mr4043204qvo.102.1567019737388;
 Wed, 28 Aug 2019 12:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190827234622.76209-1-ppenkov.kernel@gmail.com>
In-Reply-To: <20190827234622.76209-1-ppenkov.kernel@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 28 Aug 2019 12:15:26 -0700
Message-ID: <CAPhsuW6yGV1MbA9MHdOp_5VyvMA3EX7Eew6rNKbYZKSD42m-uQ@mail.gmail.com>
Subject: Re: [bpf-next] bpf: fix error check in bpf_tcp_gen_syncookie
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 4:46 PM Petar Penkov <ppenkov.kernel@gmail.com> wrote:
>
> From: Petar Penkov <ppenkov@google.com>
>
> If a SYN cookie is not issued by tcp_v#_gen_syncookie, then the return
> value will be exactly 0, rather than <= 0. Let's change the check to
> reflect that, especially since mss is an unsigned value and cannot be
> negative.
>
> Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
> Reported-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Petar Penkov <ppenkov@google.com>

Acked-by: Song Liu <songliubraving@fb.com>
