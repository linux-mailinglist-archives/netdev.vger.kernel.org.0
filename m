Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7754F10
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbfFYMka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:40:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:33672 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFYMka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:40:30 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfkkF-0006gG-F0; Tue, 25 Jun 2019 14:40:19 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfkkF-000KK9-8D; Tue, 25 Jun 2019 14:40:19 +0200
Subject: Re: [PATCH v3 2/2] bpf: Add selftests for bpf_perf_event_output
To:     allanzhang <allanzhang@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190624235720.167067-1-allanzhang@google.com>
 <20190624235720.167067-3-allanzhang@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <260b127d-ee1b-3f62-5bc6-f9e7b339705f@iogearbox.net>
Date:   Tue, 25 Jun 2019 14:40:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190624235720.167067-3-allanzhang@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25491/Tue Jun 25 10:02:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25/2019 01:57 AM, allanzhang wrote:
> Software event output is only enabled by a few prog types.
> This test is to ensure that all supported types are enbled for

Nit, typo: enbled

> bpf_perf_event_output sucessfully.

Nit, typo: sucessfully

> Signed-off-by: allanzhang <allanzhang@google.com>

For SOB, could you add proper formatted name before the email?

> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
>  .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
>  2 files changed, 126 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
> 
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index c5514daf8865..901a188e1eea 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -50,7 +50,7 @@
>  #define MAX_INSNS	BPF_MAXINSNS
>  #define MAX_TEST_INSNS	1000000
>  #define MAX_FIXUPS	8
> -#define MAX_NR_MAPS	18
> +#define MAX_NR_MAPS	19
>  #define MAX_TEST_RUNS	8
>  #define POINTER_VALUE	0xcafe4all
>  #define TEST_DATA_LEN	64
> @@ -84,6 +84,7 @@ struct bpf_test {
>  	int fixup_map_array_wo[MAX_FIXUPS];
>  	int fixup_map_array_small[MAX_FIXUPS];
>  	int fixup_sk_storage_map[MAX_FIXUPS];
> +	int fixup_map_event_output[MAX_FIXUPS];
>  	const char *errstr;
>  	const char *errstr_unpriv;
>  	uint32_t retval, retval_unpriv, insn_processed;
> @@ -604,6 +605,28 @@ static int create_sk_storage_map(void)
>  	return fd;
>  }
>  
> +static int create_event_output_map(void)
> +{
> +	struct bpf_create_map_attr attr = {
> +		.name = "test_map",
> +		.map_type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +		.key_size = 4,
> +		.value_size = 4,
> +		.max_entries = 1,
> +	};
> +	int fd, btf_fd;
> +
> +	btf_fd = load_btf();
> +	if (btf_fd < 0)
> +		return -1;
> +	attr.btf_fd = btf_fd;
> +	fd = bpf_create_map_xattr(&attr);

This does not look correct, BTF for spinlock does not belong to perf event array.

> +	close(attr.btf_fd);
> +	if (fd < 0)
> +		printf("Failed to create event_output\n");
> +	return fd;
> +}
> +
>  static char bpf_vlog[UINT_MAX >> 8];
>  
>  static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
> @@ -627,6 +650,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>  	int *fixup_map_array_wo = test->fixup_map_array_wo;
>  	int *fixup_map_array_small = test->fixup_map_array_small;
>  	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
> +	int *fixup_map_event_output = test->fixup_map_event_output;
>  
>  	if (test->fill_helper) {
>  		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
> @@ -788,6 +812,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>  			fixup_sk_storage_map++;
>  		} while (*fixup_sk_storage_map);
>  	}
> +	if (*fixup_map_event_output) {
> +		map_fds[18] = create_event_output_map();
> +		do {
> +			prog[*fixup_map_event_output].imm = map_fds[18];
> +			fixup_map_event_output++;
> +		} while (*fixup_map_event_output);
> +	}
>  }
>  
>  static int set_admin(bool admin)
> diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
> new file mode 100644
> index 000000000000..b25eabcfaa56
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/event_output.c
> @@ -0,0 +1,94 @@
> +/* instructions used to output a skb based software event, produced
> + * from code snippet:
> +struct TMP {
> +  uint64_t tmp;
> +} tt;
> +tt.tmp = 5;
> +bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
> +		      &tt, sizeof(tt));
> +return 1;
[...]
