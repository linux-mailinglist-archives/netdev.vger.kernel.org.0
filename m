Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58E310EA4E
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 14:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfLBNCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 08:02:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29071 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727399AbfLBNCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 08:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575291752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnZYQHNyF93TOuzpHzsjI/rl9jczeNd2hf1BHCa51L8=;
        b=CV9Zyb/+lUY4BPuTX3H0HR0A0EQT8TmAjDfPKFHn07LOxCSvKFcTgQClUrGGRKF8WV1CSI
        +hNVgdanGcAzAX4QPsTm3o0Ag33NP5Ru06rqJQpaBEaOCL8v5idG/3MJcx+hiraGDTLKfH
        WbuzY+PpFgLf8m0NiCQOyeyCHoMuxLs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-_kSq0rQJOfmGTY6mChqquw-1; Mon, 02 Dec 2019 08:02:31 -0500
Received: by mail-lf1-f69.google.com with SMTP id y4so5921992lfg.1
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 05:02:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wnZYQHNyF93TOuzpHzsjI/rl9jczeNd2hf1BHCa51L8=;
        b=ZeLVgHoD2+EOGx5zUd9MdwfExeD67sglY39APeltcWoWSfj1Npa8jQtopRCNmWD9NX
         g8nSit54/3wcjTkEo2C1ohKUQcfEKVrrHjhIgq6MSEjRKSfr5GSP97S7m2+laQRuLhLt
         UO53XXv88zA0RrMbo71k/G1yKpqjLiMZVCDHFNWr/ct6RL3n5AWcGxAJXaTH+07sg+U3
         5O1puOu0Bsp86KQ9I3Fg7B/dq0xP2+hv6ZW6Ph1CoIaVcCRIJPrGRAjJpqrdYxmWCvQE
         Wz04i+4wC8XyoZqwll3NZpXXyeJjQ53o5SKE/yeUCgT7q8tRlTLViIMA+iTT7yaOSKXY
         IveQ==
X-Gm-Message-State: APjAAAVgdzv/xewJ0PQnD8OPer8Gjq5KsMVD9L7lUoLmQrr8C/VvzNs0
        B99NhkQ3QlRiKzq69GGiS7QqpjwUE5yI+YSev3zJ7c9bXOvVeKdqmcO4mzeFZf+MD49dvM3AMU/
        v4Vlj7dLCKgq/SGa5
X-Received: by 2002:a05:651c:1066:: with SMTP id y6mr47130199ljm.96.1575291749398;
        Mon, 02 Dec 2019 05:02:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqz9rDXleedQx7EL3lXGtVOObHOfwWLrWorFA2PCi83Q4ChTqbLiZbDzrUkNFFwJzJoFQlZsvA==
X-Received: by 2002:a05:651c:1066:: with SMTP id y6mr47130185ljm.96.1575291749249;
        Mon, 02 Dec 2019 05:02:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u3sm9692949lfm.37.2019.12.02.05.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 05:02:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E1875181942; Mon,  2 Dec 2019 14:02:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        danieltimlee@gmail.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [bpf PATCH] samples/bpf: fix broken xdp_rxq_info due to map order assumptions
In-Reply-To: <157529025128.29832.5953245340679936909.stgit@firesoul>
References: <157529025128.29832.5953245340679936909.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Dec 2019 14:02:27 +0100
Message-ID: <87k17ericc.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: _kSq0rQJOfmGTY6mChqquw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

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
> Fixes: be5bca44aa6b ("samples: bpf: convert some XDP samples from bpf_loa=
d to libbpf")
> Fixes: 451d1dc886b5 ("samples: bpf: update map definition to new syntax B=
TF-defined map")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

