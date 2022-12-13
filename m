Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C2664C05B
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 00:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiLMXRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 18:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbiLMXRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 18:17:51 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B74915739;
        Tue, 13 Dec 2022 15:17:46 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id tz12so17901445ejc.9;
        Tue, 13 Dec 2022 15:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faJ0WTl3eQnRUQ7m5HgbJmMQHIzjsBzCYc4YbJMZ6oM=;
        b=S3erkLj39vrQLnjplGoVVFQMpYx05kf2dVu5IlXEde2Jd0Mt/GjNI/hQcIZZjUeitM
         T4ll3TEFD74KakfK+aeV0xAJ6hJvaWfmEEVvW7+onTWX3oLg489ZLv1CnyuwpO1O4PlS
         RC6HNvXc6U2FbctR/gmy92wyhEuFsjqqORKU/VnImWywrymZ+qjeYYlmmP4z0Y0xc7yo
         BGG0S7Vn1g+INZfdcaMDLWUFqTIxEbruZupDJWXdNPd6XvNKwJgFMI1JmoAgw1U/VfSA
         eyWOCTwJMRXJNxUg7FQ/sWFDWD9OHfpfsBuNCoSVSq+OVWlwKq+VpPXAqSEeegD+MtYC
         r7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=faJ0WTl3eQnRUQ7m5HgbJmMQHIzjsBzCYc4YbJMZ6oM=;
        b=nLFrqKKTH8qFaK6hd5uoy5/gKFSroeAlzl3X536Ik7uHE/tCe/6J6D/A2Sr/50MfK5
         TpDzcBjNxj+gUflZRiA1aUEGIQn/sIb8lCuOA29cfvhnjop4Snm5+03faUGmMLF0Xq/u
         SH4aP2PtJAKd/Iws6BDYU+Vph6ElR/coWb1ASzE5iiq79ZfIkkEbwCnJJzVx/3YrGPcO
         sMicP/b0fh9VM9eVdv0ClvM+K6P5KnndEzboIDIbHsQXfK1+jcIMleEcXOm2EBhUzKxC
         l+gRSlnkvuLsoRtJ1TkL7EQZO9rUKYD/6tfx2WG4r2PkfUXFDWaZN5D5jPLeWqgnTg9G
         tUVQ==
X-Gm-Message-State: ANoB5pmys5paLnoNRF0JXU3MnYHl7NIVOScISru/wX9zvUCdeaBc5OCV
        BuK+WCkr886PHG1LPkvcyjkX2lYb3g8W5S9D/3w=
X-Google-Smtp-Source: AA0mqf5TEA31paEQUUo/mVL3cViVZDFuTW1YjRqLLRktLG22zUN+2ayawGBPn4LK9YcpIYBihCVVu29DuUcXah+ir9A=
X-Received: by 2002:a17:906:3e53:b0:7c1:1f2b:945f with SMTP id
 t19-20020a1709063e5300b007c11f2b945fmr5894770eji.302.1670973464778; Tue, 13
 Dec 2022 15:17:44 -0800 (PST)
MIME-Version: 1.0
References: <20221209142622.154126-1-toke@redhat.com> <20221209142622.154126-2-toke@redhat.com>
In-Reply-To: <20221209142622.154126-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Dec 2022 15:17:32 -0800
Message-ID: <CAEf4Bzbub-YHv1c9nHttVwWCW8dbY6BvDsMfqf_rcwKfemUgJg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] selftests/bpf: Add a test for using a cpumap
 from an freplace-to-XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 9, 2022 at 6:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> This adds a simple test for inserting an XDP program into a cpumap that i=
s
> "owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
> does). Prior to the kernel fix this would fail because the map type
> ownership would be set to PROG_TYPE_EXT instead of being resolved to
> PROG_TYPE_XDP.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 53 +++++++++++++++++++
>  .../selftests/bpf/progs/freplace_progmap.c    | 24 +++++++++
>  tools/testing/selftests/bpf/testing_helpers.c | 24 ++++++++-
>  tools/testing/selftests/bpf/testing_helpers.h |  2 +
>  4 files changed, 101 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> index d1e32e792536..dac088217f0f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> @@ -500,6 +500,57 @@ static void test_fentry_to_cgroup_bpf(void)
>         bind4_prog__destroy(skel);
>  }
>
> +static void test_func_replace_progmap(void)
> +{
> +       struct bpf_cpumap_val value =3D { .qsize =3D 1 };
> +       struct bpf_object *obj, *tgt_obj =3D NULL;
> +       struct bpf_program *drop, *redirect;
> +       struct bpf_map *cpumap;
> +       int err, tgt_fd;
> +       __u32 key =3D 0;
> +
> +       err =3D bpf_prog_test_open("freplace_progmap.bpf.o", BPF_PROG_TYP=
E_UNSPEC, &obj);
> +       if (!ASSERT_OK(err, "prog_open"))
> +               return;
> +
> +       err =3D bpf_prog_test_load("xdp_dummy.bpf.o", BPF_PROG_TYPE_UNSPE=
C, &tgt_obj, &tgt_fd);
> +       if (!ASSERT_OK(err, "tgt_prog_load"))
> +               goto out;
> +
> +       drop =3D bpf_object__find_program_by_name(obj, "xdp_drop_prog");
> +       redirect =3D bpf_object__find_program_by_name(obj, "xdp_cpumap_pr=
og");
> +       cpumap =3D bpf_object__find_map_by_name(obj, "cpu_map");
> +
> +       if (!ASSERT_OK_PTR(drop, "drop") || !ASSERT_OK_PTR(redirect, "red=
irect") ||
> +           !ASSERT_OK_PTR(cpumap, "cpumap"))
> +               goto out;
> +
> +       /* Change the 'redirect' program type to be a PROG_TYPE_EXT
> +        * with an XDP target
> +        */
> +       bpf_program__set_type(redirect, BPF_PROG_TYPE_EXT);
> +       bpf_program__set_expected_attach_type(redirect, 0);
> +       err =3D bpf_program__set_attach_target(redirect, tgt_fd, "xdp_dum=
my_prog");
> +       if (!ASSERT_OK(err, "set_attach_target"))
> +               goto out;
> +
> +       err =3D bpf_object__load(obj);
> +       if (!ASSERT_OK(err, "obj_load"))
> +               goto out;
> +
> +       /* This will fail if the map is "owned" by a PROG_TYPE_EXT progra=
m,
> +        * which, prior to fixing the kernel, it will be since the map is=
 used
> +        * from the 'redirect' prog above
> +        */
> +       value.bpf_prog.fd =3D bpf_program__fd(drop);
> +       err =3D bpf_map_update_elem(bpf_map__fd(cpumap), &key, &value, 0)=
;
> +       ASSERT_OK(err, "map_update");
> +
> +out:
> +       bpf_object__close(tgt_obj);
> +       bpf_object__close(obj);
> +}
> +
>  /* NOTE: affect other tests, must run in serial mode */
>  void serial_test_fexit_bpf2bpf(void)
>  {
> @@ -525,4 +576,6 @@ void serial_test_fexit_bpf2bpf(void)
>                 test_func_replace_global_func();
>         if (test__start_subtest("fentry_to_cgroup_bpf"))
>                 test_fentry_to_cgroup_bpf();
> +       if (test__start_subtest("func_replace_progmap"))
> +               test_func_replace_progmap();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/freplace_progmap.c b/tools=
/testing/selftests/bpf/progs/freplace_progmap.c
> new file mode 100644
> index 000000000000..68174c3d7b37
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/freplace_progmap.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_CPUMAP);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(struct bpf_cpumap_val));

so old school... ;) have you tried:

__type(key, __u32);
__type(value, struct bpf_cpumap_val);

?

> +       __uint(max_entries, 1);
> +} cpu_map SEC(".maps");
> +
> +SEC("xdp/cpumap")
> +int xdp_drop_prog(struct xdp_md *ctx)
> +{
> +       return XDP_DROP;
> +}
> +
> +SEC("xdp")
> +int xdp_cpumap_prog(struct xdp_md *ctx)
> +{
> +       return bpf_redirect_map(&cpu_map, 0, XDP_PASS);
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testin=
g/selftests/bpf/testing_helpers.c
> index 9695318e8132..2050244e6f24 100644
> --- a/tools/testing/selftests/bpf/testing_helpers.c
> +++ b/tools/testing/selftests/bpf/testing_helpers.c
> @@ -174,8 +174,8 @@ __u32 link_info_prog_id(const struct bpf_link *link, =
struct bpf_link_info *info)
>
>  int extra_prog_load_log_flags =3D 0;
>
> -int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
> -                      struct bpf_object **pobj, int *prog_fd)
> +int bpf_prog_test_open(const char *file, enum bpf_prog_type type,
> +                      struct bpf_object **pobj)
>  {
>         LIBBPF_OPTS(bpf_object_open_opts, opts,
>                 .kernel_log_level =3D extra_prog_load_log_flags,
> @@ -201,6 +201,26 @@ int bpf_prog_test_load(const char *file, enum bpf_pr=
og_type type,
>         flags =3D bpf_program__flags(prog) | BPF_F_TEST_RND_HI32;
>         bpf_program__set_flags(prog, flags);
>
> +       *pobj =3D obj;
> +       return 0;
> +err_out:
> +       bpf_object__close(obj);
> +       return err;
> +}
> +
> +int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
> +                      struct bpf_object **pobj, int *prog_fd)
> +{
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +       int err;
> +
> +       err =3D bpf_prog_test_open(file, type, &obj);
> +       if (err)
> +               return err;
> +
> +       prog =3D bpf_object__next_program(obj, NULL);
> +

oh, wow, wait, do we really need to add more legacy stuff like this?
Why can't you use BPF skeletons? Avoid all the lookups by name, no
need for helpers like this?


>         err =3D bpf_object__load(obj);
>         if (err)
>                 goto err_out;
> diff --git a/tools/testing/selftests/bpf/testing_helpers.h b/tools/testin=
g/selftests/bpf/testing_helpers.h
> index 6ec00bf79cb5..977eb520d119 100644
> --- a/tools/testing/selftests/bpf/testing_helpers.h
> +++ b/tools/testing/selftests/bpf/testing_helpers.h
> @@ -6,6 +6,8 @@
>
>  int parse_num_list(const char *s, bool **set, int *set_len);
>  __u32 link_info_prog_id(const struct bpf_link *link, struct bpf_link_inf=
o *info);
> +int bpf_prog_test_open(const char *file, enum bpf_prog_type type,
> +                      struct bpf_object **pobj);
>  int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
>                        struct bpf_object **pobj, int *prog_fd);
>  int bpf_test_load_program(enum bpf_prog_type type, const struct bpf_insn=
 *insns,
> --
> 2.38.1
>
