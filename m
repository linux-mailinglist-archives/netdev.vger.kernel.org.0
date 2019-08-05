Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA17B8284A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 01:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbfHEXy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 19:54:58 -0400
Received: from lekensteyn.nl ([178.21.112.251]:58893 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfHEXy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 19:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=hqh6eFUaA4weWKC8x1OU7+rNmMqJNoDKJJbnv4Jccb8=;
        b=yJDY5Q3g/QOp3rhiz+n9ycEcDvsptOY7VrvarP1BvMPbpS5hUQrEqqt1pHQIiherL0dQvp20Gst5QuiATOiDKXeWDGSQrbzbkYlz4byccepkdSrDqzRRn07Sozw2VRpOJVx+P1oLkmRERD5+OC47h2/+hoHLLHmg2XpUZA1vHKe3S6fcej7Z2+n5IY9RQuZkbKg03PED7ONrwffYwRU2rMFVX6s4nB/zydzc+3UWrDNBwj9o+YZ0XPTsNKdI0Qz6dSq76QsfyQkxj/MHY7YnhhUNbUQpg9Eq6hhQxo+X2SB1QkG/ANEw+EKBQ4X+HRx+1vxafQyOjPTdoPw+FJrJiQ==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1humoW-0007fQ-2t; Tue, 06 Aug 2019 01:54:52 +0200
Date:   Tue, 6 Aug 2019 00:54:49 +0100
From:   Peter Wu <peter@lekensteyn.nl>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190805235449.GA8088@al>
References: <20190805001541.8096-1-peter@lekensteyn.nl>
 <20190805152936.GE4544@mini-arch>
 <20190805120649.421211da@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805120649.421211da@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Thank you for your quick feedback, I will address them in the next
revision.

On Mon, Aug 05, 2019 at 11:41:09AM +0100, Quentin Monnet wrote:

> As far as I understood (from examining Cilium [0]), /proc/config _is_
> used by some distributions, such as CoreOS. This is why we look at that
> location in bpftool.
> 
> [0] https://github.com/cilium/cilium/blob/master/bpf/run_probes.sh#L42

This comment[1] says "CoreOS uses /proc/config", but I think that is a
typo and is supposed to say "/proc/config.gz". The original feature
request[2] uses "/boot/config" as example.

 [1]: https://github.com/cilium/cilium/pull/1065
 [2]: https://github.com/cilium/cilium/issues/891

Given that "/proc/config.gz" is the standard since at least v2.6.12-rc2,
and the official kernel has no mention of "/proc/config", I would like
to skip the latter. If someone has a need for this and it is not covered
by either /boot/config-$(uname -r) or /proc/config.gz, they could submit
a patch for it with links to documentation. How about that?

> > -static char *get_kernel_config_option(FILE *fd, const char *option)
> > +static bool get_kernel_config_option(FILE *fd, char **buf_p, size_t *n_p,
> > +				     char **value)
> 
> Maybe we could rename this function, and have "next" appear in it
> somewhere? After your changes, it does not return the value for a
> specific option anymore.

I have changed it to "read_next_kernel_config_option", let me know if
you prefer an alternative.

> >  {
> > -	size_t line_n = 0, optlen = strlen(option);
> > -	char *res, *strval, *line = NULL;
> > -	ssize_t n;
> > +	char *sep;
> > +	ssize_t linelen;
> 
> Please order the declarations in reverse-Christmas tree style.

Does this refer to the type, name, or full line length? I did not find
this in CodingStyle, the closest I could get is:
https://lore.kernel.org/patchwork/patch/732076/

I will assume the line length for now.

> >  static void probe_kernel_image_config(void)
> > @@ -386,31 +386,34 @@ static void probe_kernel_image_config(void)
> >  		/* test_bpf module for BPF tests */
> >  		"CONFIG_TEST_BPF",
> >  	};
> > +	char *values[ARRAY_SIZE(options)] = { };
> >  	char *value, *buf = NULL;
> >  	struct utsname utsn;
> >  	char path[PATH_MAX];
> >  	size_t i, n;
> >  	ssize_t ret;
> > -	FILE *fd;
> > +	FILE *fd = NULL;
> > +	bool is_pipe = false;
> 
> Reverse-Christmas-tree style please.

Even if that means moving lines? Something like this?

        char path[PATH_MAX];
   +    bool is_pipe = false;
   +    FILE *fd = NULL;
        size_t i, n;
        ssize_t ret;
   -    FILE *fd;

> >  	if (uname(&utsn))
> > -		goto no_config;
> > +		goto end_parse;
> 
> Just thinking, maybe if uname() fails we can skip /boot/config-$(uname
> -r) but still attempt to parse /proc/config{,.gz} instead of printing
> only NULL options?

Good idea, I'll try a bit harder if uname falls for whatever reason.

> Because some distributions do use /proc/config, we should keep this. You
> can probably add /proc/config.gz as another attempt below (or even
> above) the current case?

I doubt it is actually in use, it looks like a typo in the original PR.
This post only lists /proc/config.gz, /boot/config and
/boot/config-$(uname -r): https://superuser.com/questions/287371

> > +	while (get_kernel_config_option(fd, &buf, &n, &value))> +		for (i = 0; i < ARRAY_SIZE(options); i++) {
> > +			if (values[i] || strcmp(buf, options[i]))
> 
> Can we have an option set multiple times in the config file? If so,
> maybe have a p_info() if values are different to warn users that
> conflicting values were found?

scripts/kconfig/merge_config.sh seems to apply a merge strategy,
overwriting earlier values and warning about it. However this should be
rare given that it ended up at /proc/config.gz. For now I will favor
simplicity over complexity and keep the old situation. Let me know if
you prefer otherwise.


On Mon, Aug 05, 2019 at 12:06:49PM -0700, Jakub Kicinski wrote:
> On Mon, 5 Aug 2019 08:29:36 -0700, Stanislav Fomichev wrote:
> > On 08/05, Peter Wu wrote:
> > > /proc/config has never existed as far as I can see, but /proc/config.gz
> > > is present on Arch Linux. Execute an external gunzip program to avoid
> > > linking to zlib and rework the option scanning code since a pipe is not
> > > seekable. This also fixes a file handle leak on some error paths.  
> > Thanks for doing that! One question: why not link against -lz instead?
> > With fork/execing gunzip you're just hiding this dependency.
> > 
> > You can add something like this to the Makefile:
> > ifeq ($(feature-zlib),1)
> > CLFAGS += -DHAVE_ZLIB
> > endif
> > 
> > And then conditionally add support for config.gz. Thoughts?
> 
> +1

Given that the old code did not have this library dependency I did not
add it (the program would otherwise fail to run). Executing an external
process is similar to what tar does. I will look into linking directly
to zlib, thanks!
-- 
Kind regards,
Peter Wu
https://lekensteyn.nl
