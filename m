Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A614AA402
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377929AbiBDXIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377926AbiBDXIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:08:18 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC27DF9A164;
        Fri,  4 Feb 2022 15:08:17 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id h7so9271787iof.3;
        Fri, 04 Feb 2022 15:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BcAFzp8uW4Ct5nA1XS0G6R2LgeeteE+TABbCFq9f3lk=;
        b=GFSUnihzbKGcF2/Mtqd7owDSS80OWqNZU3HKREWP6Wf9pzXw650LM5a3+TP6Vjj8gT
         j+1dQUbKwMvXXFI5rOvgWhjObInwlKxct9JOROuDfEzBMzfJCaadrZs2MNnpxlCsgYsI
         9YsHZqq2DGRLnZiVGkPZF/IeZNKx5B7rkez3Mlzh1CeHEZ/1GoZLG6qJ8/TJZcm5ef2+
         2wIMD5N/c7s/FnKdyJ1sFfcJ1NHJCyZQtREzoIWecrKzHy/y2SLjCwQQyBSXXgQQsnbQ
         I6uGOwae0+0UmDwkD32TX3v26aIw/rVobYSSkG12cmIkG/AX+5GBfoCGdViPZoOW87EF
         EQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BcAFzp8uW4Ct5nA1XS0G6R2LgeeteE+TABbCFq9f3lk=;
        b=hte2dHffdt29Bu/GyoskXwV4EpuU+Dwj1Ra4PrKibcSTlKcaKfvxZMf6AJV7gV1CKY
         A3t6iH06BJmU+Eu1/s1lk8mX5P/xOHbtBafdunc68Ir/o8IxKK2S6EYS0YkxFafpM05Y
         BUeQL2Dep0/qEll+ss87AZGpj+0pWMLQ5LGSuOBVPmf/nJh/ZgVAezydS/0CdHgrgql0
         LnwU1PoFHJED9Bw53YK2mKv9+PWigsSCqNDEjNSrpkZ7UXoTi07nVztPsBtTPQEDC43i
         L98JyAvFvm3+vzjxQeuZhmnXb7Xw4dTSZ9OaI3u80AsIBINI/eTM7mYnDhoGmK9/ZdKP
         unzg==
X-Gm-Message-State: AOAM530sP6J7BTH7+ERuo8xU8Db9IGcVsJdwAeA+gTAjYLW4ekmf31sg
        1w82GV5c1ggr9dIjp5ljZuYJbpK9DfmFmMpmPsE=
X-Google-Smtp-Source: ABdhPJxTYPr33dMK2tbS3UNPgHCQftAV6Z3V4Y2DqUJbnakKzInf4KDga4u6xLiCAD6gc6AosO9JqDFaifiU7zmn+wk=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr664917jak.103.1644016097092;
 Fri, 04 Feb 2022 15:08:17 -0800 (PST)
MIME-Version: 1.0
References: <20220204225823.339548-1-jolsa@kernel.org> <20220204225823.339548-3-jolsa@kernel.org>
In-Reply-To: <20220204225823.339548-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 15:08:06 -0800
Message-ID: <CAEf4BzbrHKQE-mixiuoqYKeH+iyeTVysNg1RxRmov_uLXyiaQg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpftool: Fix pretty print dump for maps
 without BTF loaded
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 2:58 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check
> error") forced map dump with pretty print enabled to has BTF loaded,
> which is not necessarily needed.
>
> Keeping the libbpf_get_error call, but setting errno to 0 because
> get_map_kv_btf does nothing for this case.
>
> This fixes test_offload.py for me, which failed because of the
> pretty print fails with:
>
>    Test map dump...
>    Traceback (most recent call last):
>      File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 1251, in <module>
>        _, entries = bpftool("map dump id %d" % (m["id"]))
>      File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 169, in bpftool
>        return tool("bpftool", args, {"json":"-p"}, JSON=JSON, ns=ns,
>      File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 155, in tool
>        ret, stdout = cmd(ns + name + " " + params + args,
>      File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 109, in cmd
>        return cmd_result(proc, include_stderr=include_stderr, fail=fail)
>      File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 131, in cmd_result
>        raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
>    Exception: Command failed: bpftool -p map dump id 4325
>
> Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/bpftool/map.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index c66a3c979b7a..2ccf85042e75 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -862,6 +862,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
>         prev_key = NULL;
>
>         if (wtr) {
> +               errno = 0;

I don't think that's right. errno can be modified by something inside
get_map_kv_btf() so this is unreliable approach. It's better to change
get_map_kv_btf() to return an error explicitly and a btf pointer
separate from error. Because btf == NULL isn't necessarily due to an
error anymore.

>                 btf = get_map_kv_btf(info);
>                 err = libbpf_get_error(btf);
>                 if (err) {
> --
> 2.34.1
>
