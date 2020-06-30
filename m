Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B0220F727
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbgF3O1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:27:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20114 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388137AbgF3O1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593527259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ihj6s0F2yxdlgw9MZKVngGqJTvCmj3O9Rv3Xianp2ow=;
        b=J3qZY2nPvQzEuGbCo3fs4J4XOZGnXeYhkcLSDRg58l3OGz3L2LvjVcLNwDYGQnV+MbF8ne
        rUEGdpvE4y8725JfaS4pM980PTEghzTJYAJ9duKEzWe8HtDE8nsnmVxzfgj1VWLcs5mpUv
        4XEYISr6XuSU/t82DXPH7n5qvM/rijA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-OBFlmFvSNOW1uAT-_njIGQ-1; Tue, 30 Jun 2020 10:27:34 -0400
X-MC-Unique: OBFlmFvSNOW1uAT-_njIGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 751A91005513;
        Tue, 30 Jun 2020 14:27:32 +0000 (UTC)
Received: from krava (unknown [10.40.192.137])
        by smtp.corp.redhat.com (Postfix) with SMTP id 852DA10013C0;
        Tue, 30 Jun 2020 14:27:28 +0000 (UTC)
Date:   Tue, 30 Jun 2020 16:27:27 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 14/14] selftests/bpf: Add test for
 resolve_btfids
Message-ID: <20200630142727.GC3071036@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-15-jolsa@kernel.org>
 <CAEf4BzZXE7-SmSbG6=T=oLObBTBUhx9yC9SJbSj3tDJLpy93AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZXE7-SmSbG6=T=oLObBTBUhx9yC9SJbSj3tDJLpy93AQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 06:43:51PM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 25, 2020 at 4:48 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding test to resolve_btfids tool, that:
> >   - creates binary with BTF IDs list and set
> >   - process the binary with resolve_btfids tool
> >   - verifies that correct BTF ID values are in place
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |  20 +-
> >  .../selftests/bpf/test_resolve_btfids.c       | 201 ++++++++++++++++++
> >  2 files changed, 220 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/test_resolve_btfids.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 22aaec74ea0a..547322a5feff 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -37,7 +37,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >         test_cgroup_storage \
> >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> >         test_progs-no_alu32 \
> > -       test_current_pid_tgid_new_ns
> > +       test_current_pid_tgid_new_ns \
> > +       test_resolve_btfids
> >
> >  # Also test bpf-gcc, if present
> >  ifneq ($(BPF_GCC),)
> > @@ -427,6 +428,23 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
> >         $(call msg,BINARY,,$@)
> >         $(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
> >
> > +# test_resolve_btfids
> > +#
> 
> useless comment, please drop

ok

> 
> > +$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ) FORCE
> > +       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids \
> > +                   OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
> 
> Why do you need FORCE here? To force building this tool every single
> time, even if nothing changed? See what we did for bpftool rebuilds.

no, the build framework will recognize if the rebuild is needed,
and trigger it..  but it needs to be invoked, hence the FORCE

> It's not perfect, but works fine in practice.

we don't need to put the sources as dependency in here,
as you do for bpftool, the build system will take care
of that

> 
> > +
> > +$(OUTPUT)/test_resolve_btfids.o: test_resolve_btfids.c
> > +       $(call msg,CC,,$@)
> > +       $(CC) $(CFLAGS) -I$(TOOLSINCDIR) -D"BUILD_STR(s)=#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))" -c -o $@ $<
> > +
> > +.PHONY: FORCE
> > +
> > +$(OUTPUT)/test_resolve_btfids: $(OUTPUT)/test_resolve_btfids.o $(SCRATCH_DIR)/resolve_btfids
> > +       $(call msg,BINARY,,$@)
> > +       $(CC) -o $@ $< $(BPFOBJ) -lelf -lz && \
> > +       $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) $@
> > +
> 
> Wouldn't it be better to make this just one of the tests of test_progs
> and let resolve_btfids process test_progs completely? That should
> still work, plus statically resolved BTF IDs against kernel would be
> available for other tests immediately. And you will have all the
> infrastructure of test_progs available. And this will be tested very
> regularly. Win-win-win-win?

ok, sounds good ;-)

> 
> >  EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)                     \
> >         prog_tests/tests.h map_tests/tests.h verifier/tests.h           \
> >         feature                                                         \
> > diff --git a/tools/testing/selftests/bpf/test_resolve_btfids.c b/tools/testing/selftests/bpf/test_resolve_btfids.c
> > new file mode 100644
> > index 000000000000..48aeda2ed881
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_resolve_btfids.c
> > @@ -0,0 +1,201 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <string.h>
> > +#include <stdio.h>
> > +#include <sys/stat.h>
> > +#include <stdio.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <linux/err.h>
> > +#include <stdlib.h>
> > +#include <bpf/btf.h>
> > +#include <bpf/libbpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/kernel.h>
> > +#include <linux/btf_ids.h>
> > +
> > +#define __CHECK(condition, format...) ({                               \
> > +       int __ret = !!(condition);                                      \
> > +       if (__ret) {                                                    \
> > +               fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);     \
> > +               fprintf(stderr, format);                                \
> > +       }                                                               \
> > +       __ret;                                                          \
> > +})
> > +
> > +#define CHECK(condition, format...)                                    \
> > +       do {                                                            \
> > +               if (__CHECK(condition, format))                         \
> > +                       return -1;                                      \
> > +       } while (0)
> 
> it's better to make CHECK return value, makes its use more flexible
> 
> > +
> > +static struct btf *btf__parse_raw(const char *file)
> 
> How about adding this as a libbpf API? It's not the first time I see
> this being re-implemented. While simple, libbpf already implements
> this internally, so there should be no need to require users do this
> all the time. Follow up patch is ok, no need to block on this.

yea, I copied that code around few times already,
I'll add it to libbpf

> 
> > +{
> > +       struct btf *btf;
> > +       struct stat st;
> > +       __u8 *buf;
> > +       FILE *f;
> > +
> > +       if (stat(file, &st))
> > +               return NULL;
> > +
> > +       f = fopen(file, "rb");
> > +       if (!f)
> > +               return NULL;
> > +
> > +       buf = malloc(st.st_size);
> > +       if (!buf) {
> > +               btf = ERR_PTR(-ENOMEM);
> > +               goto exit_close;
> > +       }
> > +
> > +       if ((size_t) st.st_size != fread(buf, 1, st.st_size, f)) {
> > +               btf = ERR_PTR(-EINVAL);
> > +               goto exit_free;
> > +       }
> > +
> > +       btf = btf__new(buf, st.st_size);
> > +
> > +exit_free:
> > +       free(buf);
> > +exit_close:
> > +       fclose(f);
> > +       return btf;
> > +}
> > +
> 
> [...]
> 
> > +
> > +static int
> > +__resolve_symbol(struct btf *btf, int type_id)
> > +{
> > +       const struct btf_type *type;
> > +       const char *str;
> > +       unsigned int i;
> > +
> > +       type = btf__type_by_id(btf, type_id);
> > +       CHECK(!type, "Failed to get type for ID %d\n", type_id);
> 
> return otherwise you'll get crash on few lines below; it's unpleasant
> to debug crashes in VM in Travis CI

the CHECK macro does 'return' on error

> 
> > +
> > +       for (i = 0; i < ARRAY_SIZE(test_symbols); i++) {
> > +               if (test_symbols[i].id != -1)
> > +                       continue;
> > +
> > +               if (BTF_INFO_KIND(type->info) != test_symbols[i].type)
> > +                       continue;
> > +
> > +               str = btf__name_by_offset(btf, type->name_off);
> > +               if (!str) {
> 
> CHECK?

ok

> 
> > +                       fprintf(stderr, "failed to get name for BTF ID %d\n",
> > +                               type_id);
> > +                       continue;
> > +               }
> > +
> > +               if (!strcmp(str, test_symbols[i].name))
> > +                       test_symbols[i].id = type_id;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int resolve_symbols(void)
> > +{
> > +       const char *path = VMLINUX_BTF;
> > +       struct btf *btf;
> > +       int type_id;
> > +       __u32 nr;
> > +       int err;
> > +
> > +       btf = btf_open(path);
> > +       CHECK(libbpf_get_error(btf), "Failed to load BTF from %s\n", path);
> > +
> 
> exit, crash othewise

the CHECK macro does 'return' on error

> 
> > +       nr = btf__get_nr_types(btf);
> > +
> > +       for (type_id = 0; type_id < nr; type_id++) {
> 
> type_id = 1; type_id <= nr

damn.. not again ;-) sry

thanks,
jirka

