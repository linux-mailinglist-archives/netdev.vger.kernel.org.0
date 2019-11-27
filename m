Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A23C10B6C9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfK0TaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:30:24 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44840 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbfK0TaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:30:23 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so17049822lfa.11;
        Wed, 27 Nov 2019 11:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jKEk9MaR5LWSyKK9ek2s+4axInXSAcfLVt7L03UVkM=;
        b=sOqHNvow2Wbqj1ZZFgMQMK0M9BRhiMOk7gQHIQJnyTDooA3qbL05Evp35am94MhbJ/
         X7O6gtC9mOLXfxWrRz/6cLR09fpckbFRSugKlW/ELiTRD2anxBwj1bc4ajtC87Oo3i8w
         fc4CoOkPHD0E4d90A5BtSvpYLoWi80AZVaLCMCwcq0JWxt2d1+PD2wq1HaGRPrEnu628
         UxRAakx+RM6erc9/7yzokp1UvbSfhWo70IEuKrpQbrnMpWoAO4FOGJIWwXaVJmDNywTu
         Gg9qzkzmrt4K+Nbd3xrg33vWi/HlvfMgD/IILL4cx9z45L3B2GLT8daPy7mAOiDhvaho
         NS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jKEk9MaR5LWSyKK9ek2s+4axInXSAcfLVt7L03UVkM=;
        b=jnUXImG71Mg+T4A9dka6BJJfUYYZHSWvsQsXRuRtF0o4oDvFPgxhjUgM/2sVNFLC3V
         ZkucfWleqdlbt1Yu428/ng7n+w5CyQPP7sDFQujL4CZf5U5fWcfyKkbKye6DqZ7bzVlY
         ZXKuCCDEi+ICr0lFKtfP/OBV73NL8fgt5V28IJUMETLrhFJFtUrKq1bWF8+L042G8BcD
         5APBfVhMe2SmfAValpatpVTJXxbJn8WR7y3SfWsmn/S4B2UjorzTAmDlsbTIP3jdyf8O
         TbPII6aoXwVeNIRPdy7znwbLpWv4m3e7SBfMuemKvV7YrrHxpElAx4tfm5yiZtCnzvYQ
         Cz7g==
X-Gm-Message-State: APjAAAUtku7oxh6UGF48UHs4vvkb7zvAHHU+bocKtB91hyHKzJWNCOd9
        PoxsN63E8t8QrA41dOI0M/OBzBU/7/XFk3vr/A0=
X-Google-Smtp-Source: APXvYqyT3bUX2usMnMrAvL6WfAyRFGYg0ISbbXXbc6M8vLi0OQ+Y9E0UViPHLPguHBrNSE44hgOiXjjn0fTBmMdzimE=
X-Received: by 2002:ac2:5462:: with SMTP id e2mr20307174lfn.181.1574883019416;
 Wed, 27 Nov 2019 11:30:19 -0800 (PST)
MIME-Version: 1.0
References: <20191127161410.57327-1-sdf@google.com>
In-Reply-To: <20191127161410.57327-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 11:30:08 -0800
Message-ID: <CAADnVQ+4kwSWzJYTOe2WFB=2G2sCoK1Yc8seJeLBseX5fS_X8A@mail.gmail.com>
Subject: Re: [PATCH bpf v3] bpf: support pre-2.25-binutils objcopy for vmlinux BTF
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 8:14 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> .BTF section of vmlinux is empty and kernel will prohibit
> BPF loading and return "in-kernel BTF is malformed".
>
> --dump-section argument to binutils' objcopy was added in version 2.25.
> When using pre-2.25 binutils, BTF generation silently fails. Convert
> to --only-section which is present on pre-2.25 binutils.
>
> Documentation/process/changes.rst states that binutils 2.21+
> is supported, not sure those standards apply to BPF subsystem.
>
> v2:
> * exit and print an error if gen_btf fails (John Fastabend)
>
> v3:
> * resend with Andrii's Acked-by/Tested-by tags
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Tested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
