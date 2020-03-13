Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0670E1840EF
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCMGp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:45:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42315 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCMGp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:45:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id h8so4405133pgs.9;
        Thu, 12 Mar 2020 23:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WPL3gUJrRKM2cbWWfIBmuWTyQv5A63MVH3jx8qJd4P8=;
        b=mjEKyd/sdH949lL+MIiRiMVBQxWxwK5iyMcdEk8tyUd40X0Dzh0iKBUB8lxuWsqaTc
         0l0ozuIUIt8XnD6zfnFR2aRiIRV9Ko3/K6pRIrSe+j8omma9FM/xGvhEFMcefI8m854W
         9BkHwHyVVenQwEeYw34EiGyW4DZbk82R1iSmdWmimkqaCoShmredoIVnAqld35dKWmJY
         sDSuGoiK0K+ABHPMn6rmwP/HDLddIm8rR1m3wKtIIjkBwZU0e/1qvlnhs7CpOnEG3foo
         hUExpzHgMTQszVJHHCiz1w0i4BkrdlCvy4TG72uZkBNBJYUnU6PZhfQcTxQ2ur4hN5tR
         Rtcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WPL3gUJrRKM2cbWWfIBmuWTyQv5A63MVH3jx8qJd4P8=;
        b=J1YA1/TUsHrS9UhN3rNDnfXEWS/ds6AENbHpSwhqdLJoCiMVBixTdGIgf1Rk7byNb4
         TBOGVUnmmEEl/7GqmZ3o0DhgjpiGZFDYnIGyMwGQbZXhQaowVwmdCCoEQs6RMdckB6Td
         wQkMUOa9gsDRxyjangVhQjlJ4q/Sh3ovqg7E873Q6h7wHtVjt86W7vlYUK+RPxuh1LQn
         s5nwCoE29kwMQloZFM5+NMsnTD0X7qESbKHBXdu0FrJFXI0ofzj8sDGfQwwwFY4XvfNL
         Be8UXeIJ/O1kCaO3I1/wmRnUaJUH++qfmF1E/OLyJ65xRXwsFljStYkihGn1JPLSJ/UC
         3N/Q==
X-Gm-Message-State: ANhLgQ3G/8MyNmZ7f1z7IvL7339moGhR8gEoiz70YzMSO5+5v541o56Y
        71zvpkTCTgvULF2OEIdyJYc=
X-Google-Smtp-Source: ADFU+vtdwSnIwGDkvJIX39nEet2iV8W2aSU5f/YqKOuadfd8aCC6VJ2S5ob98QKACgVeNVTms1f3MQ==
X-Received: by 2002:aa7:8bd1:: with SMTP id s17mr12079026pfd.225.1584081924569;
        Thu, 12 Mar 2020 23:45:24 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:d19a])
        by smtp.gmail.com with ESMTPSA id o129sm3851681pfb.61.2020.03.12.23.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 23:45:23 -0700 (PDT)
Date:   Thu, 12 Mar 2020 23:45:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: fix usleep() implementation
Message-ID: <20200313064521.se2sqpgkpd5ekmfo@ast-mbp>
References: <20200313061837.3685572-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313061837.3685572-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 11:18:37PM -0700, Andrii Nakryiko wrote:
> nanosleep syscall expects pointer to struct timespec, not nanoseconds
> directly. Current implementation fulfills its purpose of invoking nanosleep
> syscall, but doesn't really provide sleeping capabilities, which can cause
> flakiness for tests relying on usleep() to wait for something.
> 
> Fixes: ec12a57b822c ("selftests/bpf: Guarantee that useep() calls nanosleep() syscall")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index 2b0bc1171c9c..b6201dd82edf 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -35,7 +35,16 @@ struct prog_test_def {
>   */
>  int usleep(useconds_t usec)
>  {
> -	return syscall(__NR_nanosleep, usec * 1000UL);
> +	struct timespec ts;
> +
> +	if (usec > 999999) {
> +		ts.tv_sec = usec / 1000000;
> +		ts.tv_nsec = usec % 1000000;
> +	} else {
> +		ts.tv_sec = 0;
> +		ts.tv_nsec = usec;
> +	}
> +	return nanosleep(&ts, NULL);
>  }

Is this a copy-paste from somewhere?
Above 'if' looks like premature optimization.
I applied it anyway, since it fixes flakiness in test_progs -n 24.
Now pin*tp* tests are stable.

But the other one is still flaky:
server_thread:FAIL:237
Failed to accept client: Resource temporarily unavailable
#64 tcp_rtt:FAIL
Note that if I run the test alone (test_progs -n 64) it is stable.
It fails only when run as part of bigger test_progs.
test_progs -n 30-64 sporadically fails (most of the time)
test_progs -n 40-64 consistently passes
Haven't bisected further.
