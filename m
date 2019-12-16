Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204F1121AF3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLPUdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:33:16 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44190 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfLPUdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:33:16 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so5233491lfa.11;
        Mon, 16 Dec 2019 12:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nbeWbzZltLyT01BiLKGWI8q+vYN8BXtrBDiE9RDrlK4=;
        b=DqO66W5MS3ky29a5lJWviUTVycDFXVZoGD/q0I6EodjMhljtmSmK4udg70irvkQr8W
         xiGgxqngof1fYtuwrTyjPoMW/T9uhj1D6P8t//lEsaBIIi8xiFqcnTKW6f+pd6DWr52z
         ePdDH33vWbTvBzHqxi1lVaEvlxMNJQL0IPS9cz3yqMMGcCFFEaZVn5QGtiGLU1Cjf58n
         2cwGze6R7mvEw+eRCKGTxj72yGiFMxVjji2t9j9OzWRQC9tN9V0oGd2YqaBw9MAPMd3j
         jY/aXs6sE6xh5oNnJjBjqcZLnASc/EvUXjKbhq63V7cVfk2n0PkdiqMAwNR8dC+5s5wL
         sujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nbeWbzZltLyT01BiLKGWI8q+vYN8BXtrBDiE9RDrlK4=;
        b=GYbZ82DdeLVr6IyxJ44MqN8WcZJQk8uC3dSOxiTDh2uXoGTCYEK2Li9vWHxLPF+aTb
         fUiKq+4s1qBs68rkWJrHOscfaxYbYwifwnzvXT4taMwBHnqYBMO771bg5zjy/sySA5/n
         NibvrqPke8dz2Hgi+kZ/ka4U2JQGf7HVFUPs4DwKt0041h1Npk7qqneBXA4hYnKWRT3w
         MQhpGZsn2jeaLiNVCs0CheXMW1F/PX6SHg40hSoqzKlM1MgOiPGdDr+XBnymqnhrgYLC
         RfSgrNWNao/NrNqgGxNpVuDRl/9dD5jM9rBsOdV3lk4lhsxwgHDEproDS3e/atmckysX
         TzTA==
X-Gm-Message-State: APjAAAXUfqh0GYhuK4TNY2g/zlJVpChgfJ2ll5P/gAzlBsCXE0H8qKWk
        KDTH4zB5ZnXL0cx+v3qDYMVmT06Rs4Xbcm5cYS8goQ==
X-Google-Smtp-Source: APXvYqwGWCbuydImBesRxOmA29+XqnohkOoga3xb34URIKYt8gfFKQ0uvGGtCKbb2j1iSQAT9hHi8tadQKinc+d2Y1Q=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr629390lfc.6.1576528394004;
 Mon, 16 Dec 2019 12:33:14 -0800 (PST)
MIME-Version: 1.0
References: <1c2909484ca524ae9f55109b06f22b6213e76376.1576514756.git.daniel@iogearbox.net>
 <31a08a1a-a6cb-d216-c954-e06abd230000@fb.com>
In-Reply-To: <31a08a1a-a6cb-d216-c954-e06abd230000@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 12:33:01 -0800
Message-ID: <CAADnVQK+LmbmZAJarZkKQD+Ny3c_5aQeMPk3Yj0JbACq3K9MYw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix missing prog untrack in release_maps
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 10:52 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/16/19 8:49 AM, Daniel Borkmann wrote:
> > Commit da765a2f5993 ("bpf: Add poke dependency tracking for prog array
> > maps") wrongly assumed that in case of prog load errors, we're cleaning
> > up all program tracking via bpf_free_used_maps().
> >
> > However, it can happen that we're still at the point where we didn't copy
> > map pointers into the prog's aux section such that env->prog->aux->used_maps
> > is still zero, running into a UAF. In such case, the verifier has similar
> > release_maps() helper that drops references to used maps from its env.
> >
> > Consolidate the release code into __bpf_free_used_maps() and call it from
> > all sides to fix it.
> >
> > Fixes: da765a2f5993 ("bpf: Add poke dependency tracking for prog array maps")
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
