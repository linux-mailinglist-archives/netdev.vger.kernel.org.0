Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8E75E416
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfGCMju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:39:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:56294 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCMju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:39:50 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hieY6-0006bh-7R; Wed, 03 Jul 2019 14:39:46 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hieY5-000LVg-Ve; Wed, 03 Jul 2019 14:39:46 +0200
Subject: Re: [PATCH v5 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        kernel-team@fb.com, yhs@fb.com
References: <20190701235903.660141-1-andriin@fb.com>
 <20190701235903.660141-5-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5e494d84-5db9-3d57-ccb3-c619cbae7833@iogearbox.net>
Date:   Wed, 3 Jul 2019 14:39:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190701235903.660141-5-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 01:58 AM, Andrii Nakryiko wrote:
> Add ability to attach to kernel and user probes and retprobes.
> Implementation depends on perf event support for kprobes/uprobes.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/libbpf.c   | 169 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |   7 ++
>  tools/lib/bpf/libbpf.map |   2 +
>  3 files changed, 178 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index bcaa294f819d..7b6142408b15 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4021,6 +4021,175 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
>  	return (struct bpf_link *)link;
>  }
>  
> +/*
> + * this function is expected to parse integer in the range of [0, 2^31-1] from
> + * given file using scanf format string fmt. If actual parsed value is
> + * negative, the result might be indistinguishable from error
> + */
> +static int parse_uint_from_file(const char *file, const char *fmt)
> +{
> +	char buf[STRERR_BUFSIZE];
> +	int err, ret;
> +	FILE *f;
> +
> +	f = fopen(file, "r");
> +	if (!f) {
> +		err = -errno;
> +		pr_debug("failed to open '%s': %s\n", file,
> +			 libbpf_strerror_r(err, buf, sizeof(buf)));
> +		return err;
> +	}
> +	err = fscanf(f, fmt, &ret);
> +	if (err != 1) {
> +		err = err == EOF ? -EIO : -errno;
> +		pr_debug("failed to parse '%s': %s\n", file,
> +			libbpf_strerror_r(err, buf, sizeof(buf)));
> +		fclose(f);
> +		return err;
> +	}
> +	fclose(f);
> +	return ret;
> +}
> +
> +static int determine_kprobe_perf_type(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/kprobe/type";
> +
> +	return parse_uint_from_file(file, "%d\n");
> +}
> +
> +static int determine_uprobe_perf_type(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/uprobe/type";
> +
> +	return parse_uint_from_file(file, "%d\n");
> +}
> +
> +static int determine_kprobe_retprobe_bit(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> +
> +	return parse_uint_from_file(file, "config:%d\n");
> +}
> +
> +static int determine_uprobe_retprobe_bit(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> +
> +	return parse_uint_from_file(file, "config:%d\n");
> +}
> +
> +static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> +				 uint64_t offset, int pid)
> +{
> +	struct perf_event_attr attr = {};
> +	char errmsg[STRERR_BUFSIZE];
> +	int type, pfd, err;
> +
> +	type = uprobe ? determine_uprobe_perf_type()
> +		      : determine_kprobe_perf_type();
> +	if (type < 0) {
> +		pr_warning("failed to determine %s perf type: %s\n",
> +			   uprobe ? "uprobe" : "kprobe",
> +			   libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> +		return type;
> +	}
> +	if (retprobe) {
> +		int bit = uprobe ? determine_uprobe_retprobe_bit()
> +				 : determine_kprobe_retprobe_bit();
> +
> +		if (bit < 0) {
> +			pr_warning("failed to determine %s retprobe bit: %s\n",
> +				   uprobe ? "uprobe" : "kprobe",
> +				   libbpf_strerror_r(bit, errmsg,
> +						     sizeof(errmsg)));
> +			return bit;
> +		}
> +		attr.config |= 1 << bit;
> +	}
> +	attr.size = sizeof(attr);
> +	attr.type = type;
> +	attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> +	attr.config2 = offset;		       /* kprobe_addr or probe_offset */
> +
> +	/* pid filter is meaningful only for uprobes */
> +	pfd = syscall(__NR_perf_event_open, &attr,
> +		      pid < 0 ? -1 : pid /* pid */,
> +		      pid == -1 ? 0 : -1 /* cpu */,
> +		      -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> +	if (pfd < 0) {
> +		err = -errno;
> +		pr_warning("%s perf_event_open() failed: %s\n",
> +			   uprobe ? "uprobe" : "kprobe",
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	return pfd;
> +}
> +
> +struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> +					    bool retprobe,
> +					    const char *func_name)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	struct bpf_link *link;
> +	int pfd, err;
> +
> +	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> +				    0 /* offset */, -1 /* pid */);
> +	if (pfd < 0) {
> +		pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "kretprobe" : "kprobe", func_name,
> +			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +		return ERR_PTR(pfd);
> +	}
> +	link = bpf_program__attach_perf_event(prog, pfd);
> +	if (IS_ERR(link)) {
> +		close(pfd);
> +		err = PTR_ERR(link);
> +		pr_warning("program '%s': failed to attach to %s '%s': %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "kretprobe" : "kprobe", func_name,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return link;
> +	}
> +	return link;
> +}
> +
> +struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
> +					    bool retprobe, pid_t pid,
> +					    const char *binary_path,
> +					    size_t func_offset)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	struct bpf_link *link;
> +	int pfd, err;
> +
> +	pfd = perf_event_open_probe(true /* uprobe */, retprobe,
> +				    binary_path, func_offset, pid);
> +	if (pfd < 0) {
> +		pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "uretprobe" : "uprobe",
> +			   binary_path, func_offset,
> +			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +		return ERR_PTR(pfd);
> +	}
> +	link = bpf_program__attach_perf_event(prog, pfd);
> +	if (IS_ERR(link)) {
> +		close(pfd);
> +		err = PTR_ERR(link);
> +		pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "uretprobe" : "uprobe",
> +			   binary_path, func_offset,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return link;
> +	}
> +	return link;
> +}

Hm, this only addresses half the feedback I had in prior version [0]. Patch 2/9
with bpf_link with destructor looks good to me, but my feedback from back then was
that all the kprobe/uprobe/tracepoint/raw_tracepoint should be split API-wise, so
you'll end up with something like the below, that is, 1) a set of functions that
only /create/ the bpf_link handle /once/, and 2) a helper that allows /attaching/
progs to one or multiple bpf_links. The set of APIs would look like:

struct bpf_link *bpf_link__create_kprobe(bool retprobe, const char *func_name);
struct bpf_link *bpf_link__create_uprobe(bool retprobe, pid_t pid,
					 const char *binary_path,
					 size_t func_offset);
int bpf_program__attach_to_link(struct bpf_link *link, struct bpf_program *prog);
int bpf_link__destroy(struct bpf_link *link);

This seems much more natural to me. Right now you sort of do both in one single API.
Detangling the bpf_program__attach_{uprobe,kprobe}() would also avoid that you have
to redo all the perf_event_open_probe() work over and over in order to get the pfd
context where you can later attach something to. Given bpf_program__attach_to_link()
API, you also wouldn't need to expose the bpf_program__attach_perf_event() from
patch 3/9. Thoughts?

  [0] https://lore.kernel.org/bpf/a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net/

>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>  			   void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 1bf66c4a9330..bd767cc11967 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -171,6 +171,13 @@ LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
>  
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> +			   const char *func_name);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> +			   pid_t pid, const char *binary_path,
> +			   size_t func_offset);
>  
>  struct bpf_insn;
>  
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 756f5aa802e9..57a40fb60718 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -169,7 +169,9 @@ LIBBPF_0.0.4 {
>  	global:
>  		bpf_link__destroy;
>  		bpf_object__load_xattr;
> +		bpf_program__attach_kprobe;
>  		bpf_program__attach_perf_event;
> +		bpf_program__attach_uprobe;
>  		btf_dump__dump_type;
>  		btf_dump__free;
>  		btf_dump__new;
> 

