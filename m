Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CBB107C67
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 03:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfKWCXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 21:23:13 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35570 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfKWCXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 21:23:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id j6so467367lja.2;
        Fri, 22 Nov 2019 18:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8wfLLi8Yq1inNOq8ExQvkkMGn+5sy1LvT8Zr8TWcwQ=;
        b=pMqNg6x+3ERoZs5Kmi6jKB1J1X5NX+XlNGQ7nB82WjZhnw1vIO38426uQHBIndVLuG
         Pfm1YvfiTu5DVR7r8EC6vrWG9dUVn977KsK2Tolrq2hiIHe1n85zCfu3b5qLrPkKnX18
         7q4q5IFOl03C5GkZJ2Zozxv8MevGoXR8U11mIFjtAXGd++IVZP+X18ZTMwGlWySaC1cx
         bWAyVQGxJtDitL6tB+apwFYnKOon3N3FYIbPLeLgSoal8npEgeE4tiRTUOKML4wUFgrU
         y4j0WhEONt3wCGmpj+CbDBH3zI480X8DoQj+UjpHCAxjSC1erPqkLcQTqilDiHkwgD2v
         gvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8wfLLi8Yq1inNOq8ExQvkkMGn+5sy1LvT8Zr8TWcwQ=;
        b=KOBh/cCiIqRVUDPxDgeJ5KwLc37yELNxqy3mj5oQTdbwq4yvki2u0ohi2Na1lV9ltl
         naZ1J/D5EK7qTccy3I1rPy9smGgb2PTfC297dIpXptv9CMqA1PUQkQdZkFAdBCtrd9Dg
         RCMDU/cOhYJP/ovpLlnDJlbl2EiX00RH5pgG7Pe0xud9K2VjO7at5jTi5TyMHkiHOusI
         VS0v45jEi6Ll8CKk8+MMIkp4niGIK1VMFre2w66VquWPdwK6JofpSaVhuQGlmH66TkzM
         qrpSSZyeZu/IHwFGrEruLAfOSDj5rXHpJ06ndVYi/GNIacC6i6bUxSbAVQfGfEtwgk9L
         npbg==
X-Gm-Message-State: APjAAAXwQDUUnqI9ybRBV8f3hh7tB1aw1G7HoZtS45jeRriZBR7AXT6C
        1KDLJeoZPkoKN1pk0KV2fPJJ46j92XstaKlPcv0=
X-Google-Smtp-Source: APXvYqzJXMRUemp+UZy/oaU7kQ2BG1lfYnCbMvAvpZ1M6YsoV2IBIufCQVsSU41HkOmehfo5zN1c83FhAQqbSYxIXZA=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr14082016lji.136.1574475790279;
 Fri, 22 Nov 2019 18:23:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net>
In-Reply-To: <cover.1574452833.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 22 Nov 2019 18:22:58 -0800
Message-ID: <CAADnVQKpJDD-bG1GnhGwMKfk6rdshGmRY6UrfXtfkqD0V5Sb9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Optimize BPF tail calls for direct jumps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This gets rid of indirect jumps for BPF tail calls whenever possible.
> The series adds emission for *direct* jumps for tail call maps in order
> to avoid the retpoline overhead from a493a87f38cf ("bpf, x64: implement
> retpoline for tail call") for situations that allow for it, meaning,
> for known constant keys at verification time which are used as index
> into the tail call map. See patch 7/8 for more general details.
>
> Thanks!
>
> v1  -> v2:
>   - added more test cases
>   - u8 ip_stable -> bool (Andrii)
>   - removed bpf_map_poke_{un,}lock and simplified the code (Andrii)
>   - added break into prog_array_map_poke_untrack since there's just
>     one prog (Andrii)
>   - fixed typo: for for in commit msg (Andrii)
>   - reworked __bpf_arch_text_poke (Andrii)
>   - added subtests, and comment on tests themselves, NULL-NULL
>     transistion (Andrii)
>   - in constant map key tracking I've moved the map_poke_track callback
>     to once we've finished creating the poke tab as otherwise concurrent
>     access from tail call map would blow up (since we realloc the table)
> rfc -> v1:
>   - Applied Alexei's and Andrii's feeback from
>     https://lore.kernel.org/bpf/cover.1573779287.git.daniel@iogearbox.net/T/#t

Applied. Thanks!
