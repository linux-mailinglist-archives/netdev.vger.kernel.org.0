Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA02813D04E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgAOWqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:46:22 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42151 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgAOWqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:46:22 -0500
Received: by mail-qk1-f193.google.com with SMTP id z14so17357041qkg.9;
        Wed, 15 Jan 2020 14:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rhARPzXC772LF2WTgC4sccTie87Nb06JC+Jk3rytFE=;
        b=Y6iO0Md8UXIvNCuMec61bbOzc7xzVJaFebzFWdWOgKy+HXcgPl4YuHSxgkBoECWWG6
         xhVsSGOkelB6ibkhBiODFezOQZ6lQsLDpkH70EOYxm9X8rzx+Jvl6sqgP4C3bJPYRV+f
         zzPkyXMm9Y+xTNldTU+TyeGHD750VEAbzEVA1HJjfL24fBxHuTgKbQqnXCc/1Om6IRLR
         WkcY5ZnRA0tIQtHfug2VhlbT1W8KdRRG+irorGm26LUxopvTyEgvrTevTezr7mAyDiP3
         2MFUShND08VqP+55a7PiUSx8wzCQUifnOfi4wb+ik5inu9Qr5H/OTIQm2KgHfnjhks4x
         GgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rhARPzXC772LF2WTgC4sccTie87Nb06JC+Jk3rytFE=;
        b=WEQQNaMOvd9HdN48LRnpg5IBmz8EjUw35SNa87O78mnCfLWBWLGmrqHa4mIck6c5X3
         YKdOvc6a3MJw270FERHSZQvDOuKaEaFZdfocU/XcxMDpcLbxXySNXGUQq8M4Zt3e/Z7f
         D8IO+hxqWw3NlW6sBXLOtfs70ua6PlBcfb37JEs+Uop6zJOGZJ46yNN1BOprylTmJUyx
         PhP7iaZE68O/KhzJzd5e2RpP7d6pRwlPkofJG7JFrxpxs4HVc41uUIa5FQ806ebsZmEh
         GpgbuzqiMZrzc4uOWzCX3AHNsQb71PVf5FbrgH17fIWfv/ISvrz+8+W4GhT/AZGJzzAP
         7zog==
X-Gm-Message-State: APjAAAUcMXsyh9lZ14rQrbYht07cRtKERzLKTKFi/unrn+Oc9VP/1mQH
        SfEu/OZsZi39cpptVp4OkUOQs8CHOebou472pLQ=
X-Google-Smtp-Source: APXvYqw8oHqjKIuAupvHMuoSejEf3aG9nWPdIjPORFEA9iyzt4n5c+OmRoKuqwtawF+0/x2Q+rQ2ouaFLtok8mIzetY=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr25951693qkq.437.1579128381018;
 Wed, 15 Jan 2020 14:46:21 -0800 (PST)
MIME-Version: 1.0
References: <20200115222241.945672-1-kafai@fb.com> <20200115222312.948025-1-kafai@fb.com>
In-Reply-To: <20200115222312.948025-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 14:46:10 -0800
Message-ID: <CAEf4BzbBTqp7jDsTFdT60DSFSw7hX2wr3PB4a8p2pOaqs18tVA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 2:28 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch makes bpftool support dumping a map's value properly
> when the map's value type is a type of the running kernel's btf.
> (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> map_info.btf_value_type_id).  The first usecase is for the
> BPF_MAP_TYPE_STRUCT_OPS.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/map.c | 62 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 51 insertions(+), 11 deletions(-)
>

[...]
