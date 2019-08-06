Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0507F82EC8
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbfHFJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 05:36:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33182 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFJg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 05:36:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so87305444wru.0
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 02:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oG90+FtvsflPwy/gjAGj43bDr/li2FbdF2iUB+HK8So=;
        b=1bDL1ucQBwlP2j04ekjdAjlByl3CZe3MMyMDypTzuKROOwZROA7HubZ77wkoWHXhsq
         qwxmX3p9gSU2+K3uprGLMAOcjX7Bijy3JsjIAXoNccRTLwQodFeLggUgtCxy3I+obZ5a
         nbFr7+uG9u/tO4AcbsBN9hdeljIwZ/uYwkhslRHjejfC4yeEdm6IQi0ZXOqhfNgQkPQn
         wcKz4b1IznRsxwztjEg29qp8pT8aoNS6tVDfUULV6b5ORYmQl7IB13uAR4tzsfBNWFVc
         WgnrRbGQ3tun5t1H1ZYJX0w2yhaeg6/OHfQYbqBycgih+JdxIylsnY4AZ4xY+LBxD2mc
         Kc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oG90+FtvsflPwy/gjAGj43bDr/li2FbdF2iUB+HK8So=;
        b=D3OG8Qaxt/djbPT/pLdmYqFUaJndv7k4L/kCnmc0uhvYtzul0lTP2B+8yYZaOAjJUM
         sz5FEuOjhz478D5IEMeYuLCl5bhrMWofe5b84HETQw0STaBJXILlJSC0U0UNGueUg8cA
         M5jYrTBLN1XymwEavG6OBrhdtFb1UCGDaJUFwuLhzfezg9pr/vIeimOBkAoMBzv53OOd
         rU5iNhggvanLRP/yx1RvPWAJb6rmUv36Lh7087fuhDeydYBx46ch/2i36O7OTJqD9A26
         hZdxlSFXZelZHYxf5sUtkLRht2APPfGO+ftXW6WS3skATe3oelOtI0JAEgx/5i7Gtvjl
         yo2g==
X-Gm-Message-State: APjAAAU+LOuaJJmGJexCqRxXLq2PoE2Tu89TLl53SJ33pUuwf3al07BK
        DRdB4cV2Eu2kqWZcUi1Hy8khPg==
X-Google-Smtp-Source: APXvYqyo748hhR+mViWvqcIcwP0+wiEytz4bAf0pWp43V4p47IWLlVf1cHvqp1fVz42ivQye+HnD7A==
X-Received: by 2002:a5d:5607:: with SMTP id l7mr3807725wrv.228.1565084214577;
        Tue, 06 Aug 2019 02:36:54 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.47])
        by smtp.gmail.com with ESMTPSA id s12sm84093665wmh.34.2019.08.06.02.36.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 02:36:53 -0700 (PDT)
Subject: Re: [PATCH] tools: bpftool: fix reading from /proc/config.gz
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>
References: <20190805001541.8096-1-peter@lekensteyn.nl>
 <20190805152936.GE4544@mini-arch>
 <20190805120649.421211da@cakuba.netronome.com> <20190805235449.GA8088@al>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <f0e5683b-ea6c-4966-6785-f154697f76f1@netronome.com>
Date:   Tue, 6 Aug 2019 10:36:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805235449.GA8088@al>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

2019-08-06 00:54 UTC+0100 ~ Peter Wu <peter@lekensteyn.nl>
> Hi all,
> 
> Thank you for your quick feedback, I will address them in the next
> revision.
> 
> On Mon, Aug 05, 2019 at 11:41:09AM +0100, Quentin Monnet wrote:
> 
>> As far as I understood (from examining Cilium [0]), /proc/config _is_
>> used by some distributions, such as CoreOS. This is why we look at that
>> location in bpftool.
>>
>> [0] https://github.com/cilium/cilium/blob/master/bpf/run_probes.sh#L42
> 
> This comment[1] says "CoreOS uses /proc/config", but I think that is a
> typo and is supposed to say "/proc/config.gz". The original feature
> request[2] uses "/boot/config" as example.
> 
>  [1]: https://github.com/cilium/cilium/pull/1065
>  [2]: https://github.com/cilium/cilium/issues/891
> 
> Given that "/proc/config.gz" is the standard since at least v2.6.12-rc2,
> and the official kernel has no mention of "/proc/config", I would like
> to skip the latter. If someone has a need for this and it is not covered
> by either /boot/config-$(uname -r) or /proc/config.gz, they could submit
> a patch for it with links to documentation. How about that?

Ok, did a bit of research on my side as well, and I couldn't find a
solid reference to /proc/config either, so it seems you are correct.
Let's drop /proc/config for now. Thanks for investigating that!

> 
>>> -static char *get_kernel_config_option(FILE *fd, const char *option)
>>> +static bool get_kernel_config_option(FILE *fd, char **buf_p, size_t *n_p,
>>> +				     char **value)
>>
>> Maybe we could rename this function, and have "next" appear in it
>> somewhere? After your changes, it does not return the value for a
>> specific option anymore.
> 
> I have changed it to "read_next_kernel_config_option", let me know if
> you prefer an alternative.
> 

Sounds good to me.

>>>  {
>>> -	size_t line_n = 0, optlen = strlen(option);
>>> -	char *res, *strval, *line = NULL;
>>> -	ssize_t n;
>>> +	char *sep;
>>> +	ssize_t linelen;
>>
>> Please order the declarations in reverse-Christmas tree style.
> 
> Does this refer to the type, name, or full line length? I did not find
> this in CodingStyle, the closest I could get is:
> https://lore.kernel.org/patchwork/patch/732076/
> 
> I will assume the line length for now.

I am unsure this is in the CodingStyle, but fairly certain that this is
a convention for at least network-related code. And yes, as I understand
it refers to the length of the line.

> 
>>>  static void probe_kernel_image_config(void)
>>> @@ -386,31 +386,34 @@ static void probe_kernel_image_config(void)
>>>  		/* test_bpf module for BPF tests */
>>>  		"CONFIG_TEST_BPF",
>>>  	};
>>> +	char *values[ARRAY_SIZE(options)] = { };
>>>  	char *value, *buf = NULL;
>>>  	struct utsname utsn;
>>>  	char path[PATH_MAX];
>>>  	size_t i, n;
>>>  	ssize_t ret;
>>> -	FILE *fd;
>>> +	FILE *fd = NULL;
>>> +	bool is_pipe = false;
>>
>> Reverse-Christmas-tree style please.
> 
> Even if that means moving lines? Something like this?
> 
>         char path[PATH_MAX];
>    +    bool is_pipe = false;
>    +    FILE *fd = NULL;
>         size_t i, n;
>         ssize_t ret;
>    -    FILE *fd;

Yes, that's the idea (although "is_pipe" should be at the top in that
case, above "path" -- and this applies to your v2 patch, by the way).

> 
>>>  	if (uname(&utsn))
>>> -		goto no_config;
>>> +		goto end_parse;
>>
>> Just thinking, maybe if uname() fails we can skip /boot/config-$(uname
>> -r) but still attempt to parse /proc/config{,.gz} instead of printing
>> only NULL options?
> 
> Good idea, I'll try a bit harder if uname falls for whatever reason.

Thanks!

> 
>> Because some distributions do use /proc/config, we should keep this. You
>> can probably add /proc/config.gz as another attempt below (or even
>> above) the current case?
> 
> I doubt it is actually in use, it looks like a typo in the original PR.
> This post only lists /proc/config.gz, /boot/config and
> /boot/config-$(uname -r): https://superuser.com/questions/287371
> 
>>> +	while (get_kernel_config_option(fd, &buf, &n, &value))
>>> +		for (i = 0; i < ARRAY_SIZE(options); i++) {
>>> +			if (values[i] || strcmp(buf, options[i]))
>>
>> Can we have an option set multiple times in the config file? If so,
>> maybe have a p_info() if values are different to warn users that
>> conflicting values were found?
> 
> scripts/kconfig/merge_config.sh seems to apply a merge strategy,
> overwriting earlier values and warning about it. However this should be
> rare given that it ended up at /proc/config.gz. For now I will favor
> simplicity over complexity and keep the old situation. Let me know if
> you prefer otherwise.

Understood, let's keep it that way for now.

Thanks,
Quentin
