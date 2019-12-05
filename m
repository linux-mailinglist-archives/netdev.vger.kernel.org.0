Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8391511396F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfLEBzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:55:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38451 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLEBzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:55:10 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so1169226lfm.5;
        Wed, 04 Dec 2019 17:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKzXWEwIRz1LZ9hdxnkmpyoCOKiovqujudmWGgHLWno=;
        b=EXOBckuU5kNuTa4VMjXcag2IBkksmjNBS5i/XX1nFeFr0Nu29yu7XXgnNBg2SN2DP2
         3khVQaMQciRJy0g54UrR1MHldc4zUJ9iHttOpP4+ldFO6ywAHt9A+jDqtRJB4K1h9Wbi
         HFSdSCAfX/Qowydudrrd5XP0nAv6fIriO0EP8GylyuLmXNR0bJ39Vj3Lm+JGzX+Sf985
         TsGjFsyxkzQNZcdEwQLsj7+W9Sc7nFiq4ATqxRh0HQfhOSfdPQCSeMw457slFnvs+DgC
         KKogLuVCwZwuSRVq9QuIJiL0gllButxOWuE2+z8ZFwfZ8nKNB6e6t8yTxoyYvvw7d1JF
         B+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKzXWEwIRz1LZ9hdxnkmpyoCOKiovqujudmWGgHLWno=;
        b=ftSVuSemSnTVS9gH3R725Tp27BiM9ZxFI6nNlVcG8JA5JisQtw/ETh8ufnNwDNkife
         uI84W3UAxao4GIKPI5okkywWK4C9OJKSL4Lxu7MQrWOAwm1noMv2BLTslBmy6iFp2/Ra
         1kImqtzPjztBXF0ZrnhjE3aSl9rcJegE3beCUM4FzocUvROfOUyjHZc4xCFw/xuUjxj+
         CwYzh+UsGM4Bz5De9T0ZP7r5CDVbNLmofS5f/CNHAfHLJ1PhFhhTaorEnRJlXBQjIk6a
         25vS8jwCxGJHTHXoBFIUApcIGZUbUzLlbKeSyxgUzyxzsxQDkdEzIHXgI2U04vC2x6wk
         jGNw==
X-Gm-Message-State: APjAAAVXrteKuMmuF2T3MCmogGOUPwdrmq68/WVxJcZH0XpcTO4zn/VW
        9grswNdNEDJ5kzclYOiWoB0rnLgS6l4jNT3CpwM=
X-Google-Smtp-Source: APXvYqxcGnjlYV2RmqsXhOVUSQ/ffzUTUotg/9KcV8TxrwYB/t/52kqshlOu0ITq+2J3OcM3N9sjrW47s64jPK1UKZc=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr3596318lfp.162.1575510907616;
 Wed, 04 Dec 2019 17:55:07 -0800 (PST)
MIME-Version: 1.0
References: <157529025128.29832.5953245340679936909.stgit@firesoul>
In-Reply-To: <157529025128.29832.5953245340679936909.stgit@firesoul>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Dec 2019 17:54:56 -0800
Message-ID: <CAADnVQKBouDBQ-3FHJNcLHGoZL5STETw5caiujWNTrwfogEoAA@mail.gmail.com>
Subject: Re: [bpf PATCH] samples/bpf: fix broken xdp_rxq_info due to map order assumptions
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 4:37 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> In the days of using bpf_load.c the order in which the 'maps' sections
> were defines in BPF side (*_kern.c) file, were used by userspace side
> to identify the map via using the map order as an index. In effect the
> order-index is created based on the order the maps sections are stored
> in the ELF-object file, by the LLVM compiler.
>
> This have also carried over in libbpf via API bpf_map__next(NULL, obj)
> to extract maps in the order libbpf parsed the ELF-object file.
>
> When BTF based maps were introduced a new section type ".maps" were
> created. I found that the LLVM compiler doesn't create the ".maps"
> sections in the order they are defined in the C-file. The order in the
> ELF file is based on the order the map pointer is referenced in the code.
>
> This combination of changes lead to xdp_rxq_info mixing up the map
> file-descriptors in userspace, resulting in very broken behaviour, but
> without warning the user.
>
> This patch fix issue by instead using bpf_object__find_map_by_name()
> to find maps via their names. (Note, this is the ELF name, which can
> be longer than the name the kernel retains).
>
> Fixes: be5bca44aa6b ("samples: bpf: convert some XDP samples from bpf_load to libbpf")
> Fixes: 451d1dc886b5 ("samples: bpf: update map definition to new syntax BTF-defined map")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied. Thanks
