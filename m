Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3F2473508
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 20:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbhLMTdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 14:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhLMTdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 14:33:12 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1501CC061574;
        Mon, 13 Dec 2021 11:33:12 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id d10so41035189ybn.0;
        Mon, 13 Dec 2021 11:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GyQXe7k/6WqlCtMNdMFwF2JLby24XGQu452pyWy5gvM=;
        b=Lt1CZxNt29K/wifUNSFIZpbS7yWuiMb9eUKT+Bwvf8/vNyS6nTFzgYXT3khMZSJPHA
         wQuPvblhdIarqJ38ESUTyxhaVZuYKeos41luKUhGPQIZxEjv5Oq528leJ3Ytn53jV27M
         tcwd8kSM5doazZ1kziRBIpCtmxryEeAML29MeRW8JCBRJ08XYVYsAzfT6UZoYQQ1fZmr
         RJfPl/ow9qm8tO4I70TQ37+NK6cwGf2WbfEZwZH+ci4wtWMVURFBVTEJEbwbZYbcD93a
         nLMunTPbxk7Ddvs+ldeHwqR8vvNsBV9iHetxgiEu47pqB+R181q/OvmbvwA2vhRtty05
         SsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GyQXe7k/6WqlCtMNdMFwF2JLby24XGQu452pyWy5gvM=;
        b=QY9A60bpDTO3LyOmOzcIU2//Rj1jcW6Xpo4/4oDIAY8aa4VaUGfBpJEchM25ZM0XEN
         PkZ6Vasz02HZ0EN68whBu0KbJoEDJFKIwkNjy5KmSnjdF5ALGT9TvbkpyVn5QTo2uLQ/
         AbUmPMiSbIEf93fyt/CeL4WesWsf9Qwwt8h/xDC4L+Auo5NdP6agq5RGH7gyRZ+Hr+MK
         QLDWGNCoH9kmr7qCMI19ZN3AInFavJNK8kUe4hThO5i3lE9q86Ly4+2JU7EysrHlEri2
         OscU3xC2aFR3XsrXB/01Xzm1pERiHPcBbWn2C34j7pB7fm9eNdjLrK/IuHp3eRvvtuXL
         ZSIg==
X-Gm-Message-State: AOAM531vuYM6icIcDvue/p4SRqO6E/wNZE4juaZaa8s0McoGpf3+yLlx
        T7Rmv8T3uzXJhxsKmJqdBUpfkNblkcCO1SzNWQ8=
X-Google-Smtp-Source: ABdhPJy8gSThjsBrvGkgAy/EBU6r2lKg5zfrb19Fg9URvnfKLqt6JHU22WWTLH7NfDYYCNXCb80WOjpD4UKNjpoJWoI=
X-Received: by 2002:a25:2a89:: with SMTP id q131mr663563ybq.436.1639423991137;
 Mon, 13 Dec 2021 11:33:11 -0800 (PST)
MIME-Version: 1.0
References: <20211212051816.20478-1-linmq006@gmail.com> <CAH-r-ZGri414YWumUs7U_ktvcv+BWOYfPTsB7So6kz5PNcK5tw@mail.gmail.com>
In-Reply-To: <CAH-r-ZGri414YWumUs7U_ktvcv+BWOYfPTsB7So6kz5PNcK5tw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Dec 2021 11:33:00 -0800
Message-ID: <CAEf4BzZG7_ihS7m8e9KNcoO0WhFXqw4iK1=SNPr2u3bPmOmxLQ@mail.gmail.com>
Subject: Re: [PATCH] bpftool: Fix NULL vs IS_ERR() checking for return value
 of hashmap__new
To:     =?UTF-8?B?5p6X5aaZ5YCp?= <linmq006@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 7:07 AM =E6=9E=97=E5=A6=99=E5=80=A9 <linmq006@gmail=
.com> wrote:
>
> Sorry, I forgot to do compile testing. I will test it and let you know.
>
> Miaoqian Lin <linmq006@gmail.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8812=E6=
=97=A5=E5=91=A8=E6=97=A5 13:18=E5=86=99=E9=81=93=EF=BC=9A
>>
>> The hashmap__new() function does not return NULL on errors. It returns
>> ERR_PTR(-ENOMEM). Using IS_ERR() to check the return value to fix this.
>>
>> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
>> ---

Please do test (not just compile test) and re-send all three patches
as one patch set instead of three independent patches. Thanks.


>>  tools/bpf/bpftool/link.c | 2 +-
>>  tools/bpf/bpftool/map.c  | 2 +-
>>  tools/bpf/bpftool/pids.c | 2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
>> index 2c258db0d352..0dc402a89cd8 100644
>> --- a/tools/bpf/bpftool/link.c
>> +++ b/tools/bpf/bpftool/link.c
>> @@ -306,7 +306,7 @@ static int do_show(int argc, char **argv)
>>         if (show_pinned) {
>>                 link_table =3D hashmap__new(hash_fn_for_key_as_id,
>>                                           equal_fn_for_key_as_id, NULL);
>> -               if (!link_table) {
>> +               if (IS_ERR(link_table)) {
>>                         p_err("failed to create hashmap for pinned paths=
");
>>                         return -1;
>>                 }
>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
>> index cae1f1119296..af83ae37d247 100644
>> --- a/tools/bpf/bpftool/map.c
>> +++ b/tools/bpf/bpftool/map.c
>> @@ -698,7 +698,7 @@ static int do_show(int argc, char **argv)
>>         if (show_pinned) {
>>                 map_table =3D hashmap__new(hash_fn_for_key_as_id,
>>                                          equal_fn_for_key_as_id, NULL);
>> -               if (!map_table) {
>> +               if (IS_ERR(map_table)) {
>>                         p_err("failed to create hashmap for pinned paths=
");
>>                         return -1;
>>                 }
>> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
>> index 56b598eee043..6c4767e97061 100644
>> --- a/tools/bpf/bpftool/pids.c
>> +++ b/tools/bpf/bpftool/pids.c
>> @@ -101,7 +101,7 @@ int build_obj_refs_table(struct hashmap **map, enum =
bpf_obj_type type)
>>         libbpf_print_fn_t default_print;
>>
>>         *map =3D hashmap__new(hash_fn_for_key_as_id, equal_fn_for_key_as=
_id, NULL);
>> -       if (!*map) {
>> +       if (IS_ERR(*map)) {
>>                 p_err("failed to create hashmap for PID references");
>>                 return -1;
>>         }
>> --
>> 2.17.1
>>
