Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284AF5F508
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfGDI5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:57:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33614 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbfGDI5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 04:57:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so4778770wme.0
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 01:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=CXvffIVdWmwHi7GwvOSyiELztQ6G1pbeqsS6+aL8ITA=;
        b=1hokgboycaUOFsIKgaZekkY9+bu2yWIoPRKzxhmBo8xj9BwtHqbpWjZT28+jBQULg6
         gjANbGPF4cy6qJVeD1qPNXtKiHjfLwT00pY3EwxwFVn9jZ+FTCholl4uG4n0nDMrerj2
         kzSPQgHdResRaPAV1Jl2hCNESQ4fNbRrHKfJySPD58ketc4MAgTtCwJKGwh2d5dKCi2e
         ZshCNSLZp9M69jW6ROeswbX9CQjkhO+639wEXgfWjGz8Du6Dh/atgUiK1CZZvTQWunDT
         +c7mKMeHEkXHcMYe6/tEmMP5Ns4AUr3pdVOLkg8pjl8uzgPnT1EsyqVIGDZRn2GAbR/l
         fC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CXvffIVdWmwHi7GwvOSyiELztQ6G1pbeqsS6+aL8ITA=;
        b=gyWSAKVchaUH/Ufmj9D5Jnnq1ARXkwpvWKSWxh4pOPMIlw0KEY9ZCOPhn5jRGkmpw+
         YQY5w6MyCKln2H9BdI2aC8Jut4sabJ2Vbszq5Mim3b2INBm+Mt43l75AaixoMhC1PgmM
         61U3f6czG668PjQo3Y1RE2yf/+je6nEH/HmQZ2Tspw1NGxCNt43DkcPtIGqPyHnqJU4Z
         PwWXtZ1LW8FS4nCOnwCqGBlnxc12y9MtXupSf1vuR1OgT+OvgQGXiUv1rAiihryvOM/s
         JfSoUr34hrvyGmozwlKWVP6csv0d/bW+XtLA4wMXf4TvuyKjhCj4Xw8lB/ZqIGKAgDDt
         OwtQ==
X-Gm-Message-State: APjAAAWKN8lOFXnY1IO2CEexfN5D1W39kNH6OtDWeeooqCy8AyH2wpa/
        q+Qygirrka3SYFoanNc6O4IyIg==
X-Google-Smtp-Source: APXvYqyZmfKM0/K3TWeD1IIz6Tv1PVEVAE4CQLdJtpljMA6+FvGprVXkfFp/LvQYhiQxrDn5zyNk7A==
X-Received: by 2002:a1c:b707:: with SMTP id h7mr11412712wmf.45.1562230617779;
        Thu, 04 Jul 2019 01:56:57 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id q7sm4127602wrx.6.2019.07.04.01.56.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 01:56:57 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next] tools: bpftool: add "prog run" subcommand to test-run programs
Date:   Thu,  4 Jul 2019 09:56:46 +0100
Message-Id: <20190704085646.12406-1-quentin.monnet@netronome.com>
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
index 9b0db5d14e31..8dcbaa0a8ab1 100644
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
 
+static int check_single_stdin(char *file_in, char *other_file_in)
+{
+	if (file_in && other_file_in &&
+	    !strcmp(file_in, "-") && !strcmp(other_file_in, "-")) {
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
+			if (check_single_stdin(ctx_fname_in, data_fname_in))
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

