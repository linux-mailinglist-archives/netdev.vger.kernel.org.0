Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A11860B3A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGERyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:54:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46733 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGERyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:54:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so6090789wru.13
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=VJNPemRpMgmN6XQuqA5SzbmJx/EYwBfZw0qyXvicUnU=;
        b=WL284lmnfLfAJHyOWI3qUWmhcK9Nh7HdaQxVg9X60X2zu/Qk6Hvh/VAfHUP9z+wUHo
         188CswlSvOKfGu1X++H3Sj1Hv9XUnYY0USOXjAwdFhup849S7hKTfHjrwf5PKDLRanrk
         YJnGtVsItZkshXn4MOipJHHOxCrTQpqnc4qeHqvIENv0UYD8aw+yGTPngmSqH+lqo9kP
         0o5iXBU9iclV5pRKQVdXI1fTBesKhgEvk8pYE1QjMTxLVLg99CN6Oyn39i6IYuwWDPyL
         EL0l5gQkt8Friw8TnLbT2noA8Jvmm/5A7HURfMQ7TLT3yNMnGwT07yykSNVrxF+KH45e
         BS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VJNPemRpMgmN6XQuqA5SzbmJx/EYwBfZw0qyXvicUnU=;
        b=ZLUarqER7A5R3rtGzbUVO9CA/EYobNcCA1n5s1N0bl8e/BKCmouOEBSuDPOStaeYys
         QA+Pqx6tT8MdFXj4cd5emDd7JlN22DNRiseDyU51Dyh8RcNe9frNbbgpUpIUiNXs+e2w
         UmoTh0Qadle0e/qbYdyJBPpH/qX+vyXIY4TOlNNKm8xGhJGIRUPe6ZFSlArzVEEG+oRY
         gcQUGZcfDrSxxL5FrOUJAbG7Rmfw2u2zr/FXPLK92Famvuoyf3ATsvgFB2vs0Vu/z/oj
         8a3SvmWwBU8xEfh20sqSAQ1ZAzA4xFwCRsVMlNx0V2xDdnvG+K3Iblrt6sA3N/vdhyJV
         wcHA==
X-Gm-Message-State: APjAAAXNQ9LUu0giKfWskR+SnC2wSXNTtmRpf3J7g46vb1S5PKkgLPVv
        jKfvpT36vRzdJ6C6VcL6yr1ecA==
X-Google-Smtp-Source: APXvYqxdL9LZmTdmPvFhrGy7tJsroRT2l8d/pC55nyL95YSPKlmgXPGN4LW3nU+tRQ3tpcuBnLzWqA==
X-Received: by 2002:a5d:5589:: with SMTP id i9mr4844928wrv.198.1562349279478;
        Fri, 05 Jul 2019 10:54:39 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y24sm9580617wmi.10.2019.07.05.10.54.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:54:38 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <ys114321@gmail.com>
Subject: [PATCH bpf-next v2] tools: bpftool: add "prog run" subcommand to test-run programs
Date:   Fri,  5 Jul 2019 18:54:33 +0100
Message-Id: <20190705175433.22511-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new "bpftool prog run" subcommand to run a loaded program on input
data (and possibly with input context) passed by the user.

Print output data (and output context if relevant) into a file or into
the console. Print return value and duration for the test run into the
console.

A "repeat" argument can be passed to run the program several times in a
row.

The command does not perform any kind of verification based on program
type (Is this program type allowed to use an input context?) or on data
consistency (Can I work with empty input data?), this is left to the
kernel.

Example invocation:

    # perl -e 'print "\x0" x 14' | ./bpftool prog run \
            pinned /sys/fs/bpf/sample_ret0 \
            data_in - data_out - repeat 5
    0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
    Return value: 0, duration (average): 260ns

When one of data_in or ctx_in is "-", bpftool reads from standard input,
in binary format. Other formats (JSON, hexdump) might be supported (via
an optional command line keyword like "data_fmt_in") in the future if
relevant, but this would require doing more parsing in bpftool.

v2:
- Fix argument names for function check_single_stdin(). (Yonghong)

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../bpftool/Documentation/bpftool-prog.rst    |  34 ++
 tools/bpf/bpftool/bash-completion/bpftool     |  28 +-
 tools/bpf/bpftool/main.c                      |  29 ++
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/prog.c                      | 348 +++++++++++++++++-
 tools/include/linux/sizes.h                   |  48 +++
 6 files changed, 485 insertions(+), 3 deletions(-)
 create mode 100644 tools/include/linux/sizes.h

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 1df637f85f94..7a374b3c851d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -29,6 +29,7 @@ PROG COMMANDS
 |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog tracelog**
+|	**bpftool** **prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
 |	**bpftool** **prog help**
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
@@ -146,6 +147,39 @@ DESCRIPTION
 		  streaming data from BPF programs to user space, one can use
 		  perf events (see also **bpftool-map**\ (8)).
 
+	**bpftool prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
+		  Run BPF program *PROG* in the kernel testing infrastructure
+		  for BPF, meaning that the program works on the data and
+		  context provided by the user, and not on actual packets or
+		  monitored functions etc. Return value and duration for the
+		  test run are printed out to the console.
+
+		  Input data is read from the *FILE* passed with **data_in**.
+		  If this *FILE* is "**-**", input data is read from standard
+		  input. Input context, if any, is read from *FILE* passed with
+		  **ctx_in**. Again, "**-**" can be used to read from standard
+		  input, but only if standard input is not already in use for
+		  input data. If a *FILE* is passed with **data_out**, output
+		  data is written to that file. Similarly, output context is
+		  written to the *FILE* passed with **ctx_out**. For both
+		  output flows, "**-**" can be used to print to the standard
+		  output (as plain text, or JSON if relevant option was
+		  passed). If output keywords are omitted, output data and
+		  context are discarded. Keywords **data_size_out** and
+		  **ctx_size_out** are used to pass the size (in bytes) for the
+		  output buffers to the kernel, although the default of 32 kB
+		  should be more than enough for most cases.
+
+		  Keyword **repeat** is used to indicate the number of
+		  consecutive runs to perform. Note that output data and
+		  context printed to files correspond to the last of those
+		  runs. The duration printed out at the end of the runs is an
+		  average over all runs performed by the command.
+
+		  Not all program types support test run. Among those which do,
+		  not all of them can take the **ctx_in**/**ctx_out**
+		  arguments. bpftool does not perform checks on program types.
+
 	**bpftool prog help**
 		  Print short help message.
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index ba37095e1f62..965a8658cca3 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -408,10 +408,34 @@ _bpftool()
                 tracelog)
                     return 0
                     ;;
+                run)
+                    if [[ ${#words[@]} -lt 5 ]]; then
+                        _filedir
+                        return 0
+                    fi
+                    case $prev in
+                        id)
+                            _bpftool_get_prog_ids
+                            return 0
+                            ;;
+                        data_in|data_out|ctx_in|ctx_out)
+                            _filedir
+                            return 0
+                            ;;
+                        repeat|data_size_out|ctx_size_out)
+                            return 0
+                            ;;
+                        *)
+                            _bpftool_once_attr 'data_in data_out data_size_out \
+                                ctx_in ctx_out ctx_size_out repeat'
+                            return 0
+                            ;;
+                    esac
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'dump help pin attach detach load \
-                            show list tracelog' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'dump help pin attach detach \
+                            load show list tracelog run' -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4879f6395c7e..e916ff25697f 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -117,6 +117,35 @@ bool is_prefix(const char *pfx, const char *str)
 	return !memcmp(str, pfx, strlen(pfx));
 }
 
+/* Last argument MUST be NULL pointer */
+int detect_common_prefix(const char *arg, ...)
+{
+	unsigned int count = 0;
+	const char *ref;
+	char msg[256];
+	va_list ap;
+
+	snprintf(msg, sizeof(msg), "ambiguous prefix: '%s' could be '", arg);
+	va_start(ap, arg);
+	while ((ref = va_arg(ap, const char *))) {
+		if (!is_prefix(arg, ref))
+			continue;
+		count++;
+		if (count > 1)
+			strncat(msg, "' or '", sizeof(msg) - strlen(msg) - 1);
+		strncat(msg, ref, sizeof(msg) - strlen(msg) - 1);
+	}
+	va_end(ap);
+	strncat(msg, "'", sizeof(msg) - strlen(msg) - 1);
+
+	if (count >= 2) {
+		p_err(msg);
+		return -1;
+	}
+
+	return 0;
+}
+
 void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep)
 {
 	unsigned char *data = arg;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 9c5d9c80f71e..3ef0d9051e10 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -101,6 +101,7 @@ void p_err(const char *fmt, ...);
 void p_info(const char *fmt, ...);
 
 bool is_prefix(const char *pfx, const char *str);
+int detect_common_prefix(const char *arg, ...);
 void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep);
 void usage(void) __noreturn;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9b0db5d14e31..66f04a4846a5 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -15,6 +15,7 @@
 #include <sys/stat.h>
 
 #include <linux/err.h>
+#include <linux/sizes.h>
 
 #include <bpf.h>
 #include <btf.h>
@@ -748,6 +749,344 @@ static int do_detach(int argc, char **argv)
 	return 0;
 }
 
+static int check_single_stdin(char *file_data_in, char *file_ctx_in)
+{
+	if (file_data_in && file_ctx_in &&
+	    !strcmp(file_data_in, "-") && !strcmp(file_ctx_in, "-")) {
+		p_err("cannot use standard input for both data_in and ctx_in");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int get_run_data(const char *fname, void **data_ptr, unsigned int *size)
+{
+	size_t block_size = 256;
+	size_t buf_size = block_size;
+	size_t nb_read = 0;
+	void *tmp;
+	FILE *f;
+
+	if (!fname) {
+		*data_ptr = NULL;
+		*size = 0;
+		return 0;
+	}
+
+	if (!strcmp(fname, "-"))
+		f = stdin;
+	else
+		f = fopen(fname, "r");
+	if (!f) {
+		p_err("failed to open %s: %s", fname, strerror(errno));
+		return -1;
+	}
+
+	*data_ptr = malloc(block_size);
+	if (!*data_ptr) {
+		p_err("failed to allocate memory for data_in/ctx_in: %s",
+		      strerror(errno));
+		goto err_fclose;
+	}
+
+	while ((nb_read += fread(*data_ptr + nb_read, 1, block_size, f))) {
+		if (feof(f))
+			break;
+		if (ferror(f)) {
+			p_err("failed to read data_in/ctx_in from %s: %s",
+			      fname, strerror(errno));
+			goto err_free;
+		}
+		if (nb_read > buf_size - block_size) {
+			if (buf_size == UINT32_MAX) {
+				p_err("data_in/ctx_in is too long (max: %d)",
+				      UINT32_MAX);
+				goto err_free;
+			}
+			/* No space for fread()-ing next chunk; realloc() */
+			buf_size *= 2;
+			tmp = realloc(*data_ptr, buf_size);
+			if (!tmp) {
+				p_err("failed to reallocate data_in/ctx_in: %s",
+				      strerror(errno));
+				goto err_free;
+			}
+			*data_ptr = tmp;
+		}
+	}
+	if (f != stdin)
+		fclose(f);
+
+	*size = nb_read;
+	return 0;
+
+err_free:
+	free(*data_ptr);
+	*data_ptr = NULL;
+err_fclose:
+	if (f != stdin)
+		fclose(f);
+	return -1;
+}
+
+static void hex_print(void *data, unsigned int size, FILE *f)
+{
+	size_t i, j;
+	char c;
+
+	for (i = 0; i < size; i += 16) {
+		/* Row offset */
+		fprintf(f, "%07zx\t", i);
+
+		/* Hexadecimal values */
+		for (j = i; j < i + 16 && j < size; j++)
+			fprintf(f, "%02x%s", *(uint8_t *)(data + j),
+				j % 2 ? " " : "");
+		for (; j < i + 16; j++)
+			fprintf(f, "  %s", j % 2 ? " " : "");
+
+		/* ASCII values (if relevant), '.' otherwise */
+		fprintf(f, "| ");
+		for (j = i; j < i + 16 && j < size; j++) {
+			c = *(char *)(data + j);
+			if (c < ' ' || c > '~')
+				c = '.';
+			fprintf(f, "%c%s", c, j == i + 7 ? " " : "");
+		}
+
+		fprintf(f, "\n");
+	}
+}
+
+static int
+print_run_output(void *data, unsigned int size, const char *fname,
+		 const char *json_key)
+{
+	size_t nb_written;
+	FILE *f;
+
+	if (!fname)
+		return 0;
+
+	if (!strcmp(fname, "-")) {
+		f = stdout;
+		if (json_output) {
+			jsonw_name(json_wtr, json_key);
+			print_data_json(data, size);
+		} else {
+			hex_print(data, size, f);
+		}
+		return 0;
+	}
+
+	f = fopen(fname, "w");
+	if (!f) {
+		p_err("failed to open %s: %s", fname, strerror(errno));
+		return -1;
+	}
+
+	nb_written = fwrite(data, 1, size, f);
+	fclose(f);
+	if (nb_written != size) {
+		p_err("failed to write output data/ctx: %s", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int alloc_run_data(void **data_ptr, unsigned int size_out)
+{
+	*data_ptr = calloc(size_out, 1);
+	if (!*data_ptr) {
+		p_err("failed to allocate memory for output data/ctx: %s",
+		      strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int do_run(int argc, char **argv)
+{
+	char *data_fname_in = NULL, *data_fname_out = NULL;
+	char *ctx_fname_in = NULL, *ctx_fname_out = NULL;
+	struct bpf_prog_test_run_attr test_attr = {0};
+	const unsigned int default_size = SZ_32K;
+	void *data_in = NULL, *data_out = NULL;
+	void *ctx_in = NULL, *ctx_out = NULL;
+	unsigned int repeat = 1;
+	int fd, err;
+
+	if (!REQ_ARGS(4))
+		return -1;
+
+	fd = prog_parse_fd(&argc, &argv);
+	if (fd < 0)
+		return -1;
+
+	while (argc) {
+		if (detect_common_prefix(*argv, "data_in", "data_out",
+					 "data_size_out", NULL))
+			return -1;
+		if (detect_common_prefix(*argv, "ctx_in", "ctx_out",
+					 "ctx_size_out", NULL))
+			return -1;
+
+		if (is_prefix(*argv, "data_in")) {
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			data_fname_in = GET_ARG();
+			if (check_single_stdin(data_fname_in, ctx_fname_in))
+				return -1;
+		} else if (is_prefix(*argv, "data_out")) {
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			data_fname_out = GET_ARG();
+		} else if (is_prefix(*argv, "data_size_out")) {
+			char *endptr;
+
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			test_attr.data_size_out = strtoul(*argv, &endptr, 0);
+			if (*endptr) {
+				p_err("can't parse %s as output data size",
+				      *argv);
+				return -1;
+			}
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "ctx_in")) {
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			ctx_fname_in = GET_ARG();
+			if (check_single_stdin(data_fname_in, ctx_fname_in))
+				return -1;
+		} else if (is_prefix(*argv, "ctx_out")) {
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			ctx_fname_out = GET_ARG();
+		} else if (is_prefix(*argv, "ctx_size_out")) {
+			char *endptr;
+
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			test_attr.ctx_size_out = strtoul(*argv, &endptr, 0);
+			if (*endptr) {
+				p_err("can't parse %s as output context size",
+				      *argv);
+				return -1;
+			}
+			NEXT_ARG();
+		} else if (is_prefix(*argv, "repeat")) {
+			char *endptr;
+
+			NEXT_ARG();
+			if (!REQ_ARGS(1))
+				return -1;
+
+			repeat = strtoul(*argv, &endptr, 0);
+			if (*endptr) {
+				p_err("can't parse %s as repeat number",
+				      *argv);
+				return -1;
+			}
+			NEXT_ARG();
+		} else {
+			p_err("expected no more arguments, 'data_in', 'data_out', 'data_size_out', 'ctx_in', 'ctx_out', 'ctx_size_out' or 'repeat', got: '%s'?",
+			      *argv);
+			return -1;
+		}
+	}
+
+	err = get_run_data(data_fname_in, &data_in, &test_attr.data_size_in);
+	if (err)
+		return -1;
+
+	if (data_in) {
+		if (!test_attr.data_size_out)
+			test_attr.data_size_out = default_size;
+		err = alloc_run_data(&data_out, test_attr.data_size_out);
+		if (err)
+			goto free_data_in;
+	}
+
+	err = get_run_data(ctx_fname_in, &ctx_in, &test_attr.ctx_size_in);
+	if (err)
+		goto free_data_out;
+
+	if (ctx_in) {
+		if (!test_attr.ctx_size_out)
+			test_attr.ctx_size_out = default_size;
+		err = alloc_run_data(&ctx_out, test_attr.ctx_size_out);
+		if (err)
+			goto free_ctx_in;
+	}
+
+	test_attr.prog_fd	= fd;
+	test_attr.repeat	= repeat;
+	test_attr.data_in	= data_in;
+	test_attr.data_out	= data_out;
+	test_attr.ctx_in	= ctx_in;
+	test_attr.ctx_out	= ctx_out;
+
+	err = bpf_prog_test_run_xattr(&test_attr);
+	if (err) {
+		p_err("failed to run program: %s", strerror(errno));
+		goto free_ctx_out;
+	}
+
+	err = 0;
+
+	if (json_output)
+		jsonw_start_object(json_wtr);	/* root */
+
+	/* Do not exit on errors occurring when printing output data/context,
+	 * we still want to print return value and duration for program run.
+	 */
+	if (test_attr.data_size_out)
+		err += print_run_output(test_attr.data_out,
+					test_attr.data_size_out,
+					data_fname_out, "data_out");
+	if (test_attr.ctx_size_out)
+		err += print_run_output(test_attr.ctx_out,
+					test_attr.ctx_size_out,
+					ctx_fname_out, "ctx_out");
+
+	if (json_output) {
+		jsonw_uint_field(json_wtr, "retval", test_attr.retval);
+		jsonw_uint_field(json_wtr, "duration", test_attr.duration);
+		jsonw_end_object(json_wtr);	/* root */
+	} else {
+		fprintf(stdout, "Return value: %u, duration%s: %uns\n",
+			test_attr.retval,
+			repeat > 1 ? " (average)" : "", test_attr.duration);
+	}
+
+free_ctx_out:
+	free(ctx_out);
+free_ctx_in:
+	free(ctx_in);
+free_data_out:
+	free(data_out);
+free_data_in:
+	free(data_in);
+
+	return err;
+}
+
 static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
 	struct bpf_object_load_attr load_attr = { 0 };
@@ -1058,6 +1397,11 @@ static int do_help(int argc, char **argv)
 		"                         [pinmaps MAP_DIR]\n"
 		"       %s %s attach PROG ATTACH_TYPE [MAP]\n"
 		"       %s %s detach PROG ATTACH_TYPE [MAP]\n"
+		"       %s %s run PROG \\\n"
+		"                         data_in FILE \\\n"
+		"                         [data_out FILE [data_size_out L]] \\\n"
+		"                         [ctx_in FILE [ctx_out FILE [ctx_size_out M]]] \\\n"
+		"                         [repeat N]\n"
 		"       %s %s tracelog\n"
 		"       %s %s help\n"
 		"\n"
@@ -1079,7 +1423,8 @@ static int do_help(int argc, char **argv)
 		"",
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -1095,6 +1440,7 @@ static const struct cmd cmds[] = {
 	{ "attach",	do_attach },
 	{ "detach",	do_detach },
 	{ "tracelog",	do_tracelog },
+	{ "run",	do_run },
 	{ 0 }
 };
 
diff --git a/tools/include/linux/sizes.h b/tools/include/linux/sizes.h
new file mode 100644
index 000000000000..1cbb4c4d016e
--- /dev/null
+++ b/tools/include/linux/sizes.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * include/linux/sizes.h
+ */
+#ifndef __LINUX_SIZES_H__
+#define __LINUX_SIZES_H__
+
+#include <linux/const.h>
+
+#define SZ_1				0x00000001
+#define SZ_2				0x00000002
+#define SZ_4				0x00000004
+#define SZ_8				0x00000008
+#define SZ_16				0x00000010
+#define SZ_32				0x00000020
+#define SZ_64				0x00000040
+#define SZ_128				0x00000080
+#define SZ_256				0x00000100
+#define SZ_512				0x00000200
+
+#define SZ_1K				0x00000400
+#define SZ_2K				0x00000800
+#define SZ_4K				0x00001000
+#define SZ_8K				0x00002000
+#define SZ_16K				0x00004000
+#define SZ_32K				0x00008000
+#define SZ_64K				0x00010000
+#define SZ_128K				0x00020000
+#define SZ_256K				0x00040000
+#define SZ_512K				0x00080000
+
+#define SZ_1M				0x00100000
+#define SZ_2M				0x00200000
+#define SZ_4M				0x00400000
+#define SZ_8M				0x00800000
+#define SZ_16M				0x01000000
+#define SZ_32M				0x02000000
+#define SZ_64M				0x04000000
+#define SZ_128M				0x08000000
+#define SZ_256M				0x10000000
+#define SZ_512M				0x20000000
+
+#define SZ_1G				0x40000000
+#define SZ_2G				0x80000000
+
+#define SZ_4G				_AC(0x100000000, ULL)
+
+#endif /* __LINUX_SIZES_H__ */
-- 
2.17.1

