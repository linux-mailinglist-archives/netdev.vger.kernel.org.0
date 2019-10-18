Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E1ADCF85
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440068AbfJRTo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:44:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:38332 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390538AbfJRTo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 15:44:28 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iLYAj-0000DU-Rv; Fri, 18 Oct 2019 21:44:26 +0200
Date:   Fri, 18 Oct 2019 21:44:25 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     andriin@fb.com, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Message-ID: <20191018194425.GI26267@pc-63.home>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25606/Fri Oct 18 10:58:40 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 07:54:26AM -0700, John Fastabend wrote:
> Following ./Documentation/trace/kprobetrace.rst add support for loading
> kprobes programs on older kernels.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c |   81 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 73 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index fcea6988f962..12b3105d112c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5005,20 +5005,89 @@ static int determine_uprobe_retprobe_bit(void)
>  	return parse_uint_from_file(file, "config:%d\n");
>  }
>  
> +static int use_kprobe_debugfs(const char *name,
> +			      uint64_t offset, int pid, bool retprobe)

offset & pid unused?

> +{
> +	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> +	int fd = open(file, O_WRONLY | O_APPEND, 0);
> +	char buf[PATH_MAX];
> +	int err;
> +
> +	if (fd < 0) {
> +		pr_warning("failed open kprobe_events: %s\n",
> +			   strerror(errno));
> +		return -errno;
> +	}
> +
> +	snprintf(buf, sizeof(buf), "%c:kprobes/%s %s",
> +		 retprobe ? 'r' : 'p', name, name);
> +
> +	err = write(fd, buf, strlen(buf));
> +	close(fd);
> +	if (err < 0)
> +		return -errno;
> +	return 0;
> +}
> +
>  static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
>  				 uint64_t offset, int pid)
>  {
>  	struct perf_event_attr attr = {};
>  	char errmsg[STRERR_BUFSIZE];
> +	uint64_t config1 = 0;
>  	int type, pfd, err;
>  
>  	type = uprobe ? determine_uprobe_perf_type()
>  		      : determine_kprobe_perf_type();
>  	if (type < 0) {
> -		pr_warning("failed to determine %s perf type: %s\n",
> -			   uprobe ? "uprobe" : "kprobe",
> -			   libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> -		return type;
> +		if (uprobe) {
> +			pr_warning("failed to determine uprobe perf type %s: %s\n",
> +				   name,
> +				   libbpf_strerror_r(type,
> +						     errmsg, sizeof(errmsg)));
> +		} else {
> +			/* If we do not have an event_source/../kprobes then we
> +			 * can try to use kprobe-base event tracing, for details
> +			 * see ./Documentation/trace/kprobetrace.rst
> +			 */
> +			const char *file = "/sys/kernel/debug/tracing/events/kprobes/";
> +			char c[PATH_MAX];
> +			int fd, n;
> +
> +			snprintf(c, sizeof(c), "%s/%s/id", file, name);
> +
> +			err = use_kprobe_debugfs(name, offset, pid, retprobe);
> +			if (err)
> +				return err;

Should we throw a pr_warning() here as well when bailing out?

> +			type = PERF_TYPE_TRACEPOINT;
> +			fd = open(c, O_RDONLY, 0);
> +			if (fd < 0) {
> +				pr_warning("failed to open tracepoint %s: %s\n",
> +					   c, strerror(errno));
> +				return -errno;
> +			}
> +			n = read(fd, c, sizeof(c));
> +			close(fd);
> +			if (n < 0) {
> +				pr_warning("failed to read %s: %s\n",
> +					   c, strerror(errno));
> +				return -errno;
> +			}
> +			c[n] = '\0';
> +			config1 = strtol(c, NULL, 0);
> +			attr.size = sizeof(attr);
> +			attr.type = type;
> +			attr.config = config1;
> +			attr.sample_period = 1;
> +			attr.wakeup_events = 1;

Is there a reason you set latter two whereas below they are not set,
does it not default to these?

> +		}
> +	} else {
> +		config1 = ptr_to_u64(name);
> +		attr.size = sizeof(attr);
> +		attr.type = type;
> +		attr.config1 = config1; /* kprobe_func or uprobe_path */
> +		attr.config2 = offset;  /* kprobe_addr or probe_offset */
>  	}
>  	if (retprobe) {
>  		int bit = uprobe ? determine_uprobe_retprobe_bit()
> @@ -5033,10 +5102,6 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
>  		}
>  		attr.config |= 1 << bit;
>  	}

What happens in case of retprobe, don't you (unwantedly) bail out here
again (even through you've set up the retprobe earlier)?

> -	attr.size = sizeof(attr);
> -	attr.type = type;
> -	attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
> -	attr.config2 = offset;		 /* kprobe_addr or probe_offset */
>  
>  	/* pid filter is meaningful only for uprobes */
>  	pfd = syscall(__NR_perf_event_open, &attr,
> 
