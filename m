Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C4556BC9
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfFZOZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:25:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:42374 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZOZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:25:11 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8rA-0008W1-MR; Wed, 26 Jun 2019 16:25:04 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8rA-0008kw-FF; Wed, 26 Jun 2019 16:25:04 +0200
Subject: Re: [PATCH v2 bpf-next 3/7] libbpf: add kprobe/uprobe attach API
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        ast@fb.com, sdf@fomichev.me, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
References: <20190621045555.4152743-1-andriin@fb.com>
 <20190621045555.4152743-4-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:25:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190621045555.4152743-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/21/2019 06:55 AM, Andrii Nakryiko wrote:
> Add ability to attach to kernel and user probes and retprobes.
> Implementation depends on perf event support for kprobes/uprobes.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 207 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |   8 ++
>  tools/lib/bpf/libbpf.map |   2 +
>  3 files changed, 217 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2bb1fa008be3..d506772df350 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3969,6 +3969,213 @@ int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
>  	return 0;
>  }
>  
> +static int parse_uint(const char *buf)
> +{
> +	int ret;
> +
> +	errno = 0;
> +	ret = (int)strtol(buf, NULL, 10);
> +	if (errno) {
> +		ret = -errno;
> +		pr_debug("failed to parse '%s' as unsigned int\n", buf);
> +		return ret;
> +	}
> +	if (ret < 0) {
> +		pr_debug("failed to parse '%s' as unsigned int\n", buf);
> +		return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static int parse_uint_from_file(const char* file)
> +{
> +	char buf[STRERR_BUFSIZE];
> +	int fd, ret;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		ret = -errno;
> +		pr_debug("failed to open '%s': %s\n", file,
> +			 libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	ret = read(fd, buf, sizeof(buf));
> +	ret = ret < 0 ? -errno : ret;
> +	close(fd);
> +	if (ret < 0) {
> +		pr_debug("failed to read '%s': %s\n", file,
> +			libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	if (ret == 0 || ret >= sizeof(buf)) {
> +		buf[sizeof(buf) - 1] = 0;
> +		pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> +		return -EINVAL;
> +	}
> +	return parse_uint(buf);
> +}
> +
> +static int determine_kprobe_perf_type(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/kprobe/type";
> +	return parse_uint_from_file(file);
> +}
> +
> +static int determine_uprobe_perf_type(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/uprobe/type";
> +	return parse_uint_from_file(file);
> +}
> +
> +static int parse_config_from_file(const char *file)
> +{
> +	char buf[STRERR_BUFSIZE];
> +	int fd, ret;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		ret = -errno;
> +		pr_debug("failed to open '%s': %s\n", file,
> +			 libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	ret = read(fd, buf, sizeof(buf));
> +	ret = ret < 0 ? -errno : ret;
> +	close(fd);
> +	if (ret < 0) {
> +		pr_debug("failed to read '%s': %s\n", file,
> +			libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	if (ret == 0 || ret >= sizeof(buf)) {
> +		buf[sizeof(buf) - 1] = 0;
> +		pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> +		return -EINVAL;
> +	}
> +	if (strncmp(buf, "config:", 7)) {
> +		pr_debug("expected 'config:' prefix, found '%s'\n", buf);
> +		return -EINVAL;
> +	}
> +	return parse_uint(buf + 7);
> +}
> +
> +static int determine_kprobe_retprobe_bit(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> +	return parse_config_from_file(file);
> +}
> +
> +static int determine_uprobe_retprobe_bit(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> +	return parse_config_from_file(file);
> +}
> +
> +static int perf_event_open_probe(bool uprobe, bool retprobe, const char* name,
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
> +int bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> +			       const char *func_name)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	int pfd, err;
> +
> +	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> +				    0 /* offset */, -1 /* pid */);
> +	if (pfd < 0) {
> +		pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "kretprobe" : "kprobe", func_name,
> +			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +		return pfd;
> +	}
> +	err = bpf_program__attach_perf_event(prog, pfd);
> +	if (err) {
> +		libbpf_perf_event_disable_and_close(pfd);
> +		pr_warning("program '%s': failed to attach to %s '%s': %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "kretprobe" : "kprobe", func_name,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	return pfd;
> +}

I do like that we facilitate usage by adding these APIs to libbpf, but my $0.02
would be that they should be designed slightly different. See it as a nit, but
given it's exposed in libbpf.map and therefore immutable in future it's worth
considering; right now with this set here you have:

int bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
			       const char *func_name)
int bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
			       pid_t pid, const char *binary_path,
			       size_t func_offset)
int bpf_program__attach_tracepoint(struct bpf_program *prog,
				   const char *tp_category,
				   const char *tp_name)
int bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
				       const char *tp_name)
int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
int libbpf_perf_event_disable_and_close(int pfd)

So the idea is that all the bpf_program__attach_*() APIs return an fd that you
can later on pass into libbpf_perf_event_disable_and_close(). I think there is
a bit of a disconnect in that the bpf_program__attach_*() APIs try to do too
many things at once. For example, the bpf_program__attach_raw_tracepoint() fd
has nothing to do with perf, so passing to libbpf_perf_event_disable_and_close()
kind of works, but is hacky since there's no PERF_EVENT_IOC_DISABLE for it so this
would always error if a user cares to check the return code. In the kernel, we
use anon inode for this kind of object. Also, if a user tries to add more than
one program to the same event, we need to recreate a new event fd every time.

What this boils down to is that this should get a proper abstraction, e.g. as
in struct libbpf_event which holds the event object. There should be helper
functions like libbpf_event_create_{kprobe,uprobe,tracepoint,raw_tracepoint} returning
such an struct libbpf_event object on success, and a single libbpf_event_destroy()
that does the event specific teardown. bpf_program__attach_event() can then take
care of only attaching the program to it. Having an object for this is also more
extensible than just a fd number. Nice thing is that this can also be completely
internal to libbpf.c as with struct bpf_program and other abstractions where we
don't expose the internals in the public header.

Thanks,
Daniel
